-- prp-anticheat: notificações para o Discord.
-- Suporta rate-limit (janela deslizante) + retry com backoff exponencial.

PRP = PRP or {}
PRP.Webhook = {}

local Webhook = PRP.Webhook

-- Janela deslizante de envio. Cada slot é um timestamp.
local rate = {
    timestamps   = {},
    droppedCount = 0,
    lastDropLog  = 0,
}

local function now()
    return os.time()
end

-- Devolve true se podemos enviar agora; false se estamos rate-limited.
-- Em caso de rejeição, conta no metric e periodicamente loga sumário.
local function budgetAllows()
    local ts = now()
    local cutoff = ts - Config.Logging.RateLimitWindowSeconds

    -- Pruning in-place do array de timestamps.
    local kept = {}
    for i = 1, #rate.timestamps do
        if rate.timestamps[i] >= cutoff then
            kept[#kept + 1] = rate.timestamps[i]
        end
    end
    rate.timestamps = kept

    if #kept >= Config.Logging.RateLimitMaxPerWindow then
        rate.droppedCount = rate.droppedCount + 1
        PRP.State.countMetric('webhookDropped')

        if (ts - rate.lastDropLog) >= 60 then
            print(('[prp-anticheat] Webhook rate-limit: %s mensagens descartadas no último minuto')
                :format(rate.droppedCount))
            rate.lastDropLog = ts
            rate.droppedCount = 0
        end
        return false
    end

    kept[#kept + 1] = ts
    return true
end

local function resolveUrl()
    return GetConvar('DISCORD_WEBHOOK_SECURITY', Config.Logging.Webhook or '')
end

-- Envia um payload com retry. Para 4xx (configuração errada) não faz retry.
local function postWithRetry(url, payload, attempt)
    attempt = attempt or 1
    local maxAttempts = #Config.Logging.RetryBackoffSeconds + 1

    PerformHttpRequest(url, function(statusCode, _, _)
        -- 2xx: success path.
        if statusCode and statusCode >= 200 and statusCode < 300 then
            return
        end

        -- 4xx (exclui 429): erro de configuração. Não vale a pena retry.
        if statusCode and statusCode >= 400 and statusCode < 500 and statusCode ~= 429 then
            print(('[prp-anticheat] Webhook devolveu %s (config errada?). Sem retry.')
                :format(statusCode))
            return
        end

        -- 5xx ou 429: retry com backoff.
        if attempt >= maxAttempts then
            print(('[prp-anticheat] Webhook falhou após %s tentativas (status=%s)')
                :format(attempt, tostring(statusCode)))
            return
        end

        local delay = Config.Logging.RetryBackoffSeconds[attempt] or 5
        PRP.State.countMetric('webhookRetries')

        SetTimeout(delay * 1000, function()
            postWithRetry(url, payload, attempt + 1)
        end)
    end, 'POST', payload, {
        ['Content-Type'] = 'application/json',
    })
end

-- API pública.
function Webhook.send(title, description, color)
    local url = resolveUrl()
    if url == '' then return end
    if not budgetAllows() then return end

    local payload = json.encode({
        username = 'prp-anticheat',
        embeds = {
            {
                title       = title,
                description = description,
                color       = color or 15158332,
                footer      = {
                    text = (Config.Logging.ServerName or 'prp-anticheat')
                        .. ' | '
                        .. os.date('%d/%m/%Y %H:%M:%S')
                },
            },
        },
    })

    PRP.State.countMetric('webhookSent')
    postWithRetry(url, payload, 1)
end
