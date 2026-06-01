-- prp-anticheat: gestão de estado.
-- Single-source-of-truth para tudo o que precisa de TTL ou cleanup por player.

PRP = PRP or {}
PRP.State = {}

local State = PRP.State

State.players = {}        -- source -> { points, reasons[], lastUpdate, kicked, joinedAt, bypassed, identifiers, lastHealthCheck }
State.windows = {}        -- kind -> key -> sliding window { timestamps[], lastPrune }
State.metrics = {
    detectionsTotal     = 0,
    detectionsByType    = {},
    kicksTotal          = 0,
    bansTotal           = 0,
    webhookSent         = 0,
    webhookDropped      = 0,
    webhookRetries      = 0,
    startedAt           = os.time(),
}

local function now()
    return os.time()
end

PRP.Now = now

function State.ensurePlayer(source)
    local p = State.players[source]
    if not p then
        p = {
            points          = 0,
            reasons         = {},
            lastUpdate      = now(),
            kicked          = false,
            joinedAt        = now(),
            bypassed        = false,
            identifiers     = {},
            lastHealthCheck = 0,
        }
        State.players[source] = p
    end
    return p
end

function State.getPlayer(source)
    return State.players[source]
end

function State.dropPlayer(source)
    State.players[source] = nil

    -- Limpa todas as sliding windows associadas a este source.
    -- O state é nested (kind -> key -> window) por isso a separação é trivial.
    local key = tostring(source)
    for _, byKey in pairs(State.windows) do
        byKey[key] = nil
    end
end

function State.registerReason(playerState, reason)
    local reasons = playerState.reasons
    reasons[#reasons + 1] = { reason = reason, at = now() }
    if #reasons > 15 then
        table.remove(reasons, 1)
    end
end

-- Sliding window counter.
-- kind: string ("explosion", "entity", "monitored:eventName", etc.)
-- key:  string (geralmente o source). Tem que ser único *dentro* do kind.
-- windowSec: segundos para "esquecer" timestamps
-- Retorna: contagem atual dentro da janela.
function State.bumpWindow(kind, key, windowSec)
    local byKey = State.windows[kind]
    if not byKey then
        byKey = {}
        State.windows[kind] = byKey
    end

    local ts = now()
    local w  = byKey[key]
    if not w then
        w = { timestamps = {}, lastPrune = ts }
        byKey[key] = w
    end

    -- Pruning eficiente: como timestamps são monotonamente crescentes,
    -- basta avançar um cursor de início.
    local tsList = w.timestamps
    local cutoff = ts - windowSec
    if (ts - w.lastPrune) >= 1 then
        local i = 1
        while i <= #tsList and tsList[i] < cutoff do
            i = i + 1
        end
        if i > 1 then
            local newList = {}
            for j = i, #tsList do
                newList[#newList + 1] = tsList[j]
            end
            w.timestamps = newList
            tsList = newList
        end
        w.lastPrune = ts
    end

    tsList[#tsList + 1] = ts
    return #tsList
end

function State.countMetric(name, by)
    State.metrics[name] = (State.metrics[name] or 0) + (by or 1)
end

function State.countDetection(detectionKey)
    State.metrics.detectionsTotal = State.metrics.detectionsTotal + 1
    local byType = State.metrics.detectionsByType
    byType[detectionKey] = (byType[detectionKey] or 0) + 1
end

function State.snapshotMetrics()
    -- Cópia rasa para passar ao admin sem expor refs internas.
    local out = {}
    for k, v in pairs(State.metrics) do
        if type(v) == 'table' then
            local copy = {}
            for kk, vv in pairs(v) do copy[kk] = vv end
            out[k] = copy
        else
            out[k] = v
        end
    end
    out.uptimeSeconds = now() - out.startedAt
    return out
end
