-- prp-anticheat: orquestração de pontos, kick e ban.

PRP = PRP or {}
PRP.Punishment = {}

local Punishment = PRP.Punishment

-- Mensagem de kick standardizada.
local KICK_MESSAGE = '[prp-anticheat] Comportamento suspeito detectado. Reconnect e abre ticket no Discord se for erro.'
local BAN_MESSAGE  = '[prp-anticheat] Foste banido. Vê o motivo no Discord ou abre ticket para apelar.'

-- Verifica se source tem ACE de bypass. Resultado é cacheado no playerState.
local function isBypassed(source)
    local p = PRP.State.getPlayer(source)
    if not p then return false end
    if p.bypassed then return true end

    if Config.BypassAce and Config.BypassAce ~= '' and IsPlayerAceAllowed(source, Config.BypassAce) then
        p.bypassed = true
        return true
    end
    return false
end

PRP.Punishment.isBypassed = isBypassed

-- Kick (apenas sessão). Idempotente.
local function kick(source, reason)
    local p = PRP.State.ensurePlayer(source)
    if p.kicked then return end
    p.kicked = true

    local name = GetPlayerName(source) or ('ID ' .. tostring(source))
    local ids  = PRP.Identifiers.fromSource(source)
    PRP.State.countMetric('kicksTotal')

    PRP.Webhook.send('Player Kicked (Anticheat)', ([[
**Player:** %s
**Source:** %s
**License:** %s
**Steam:** %s
**Discord:** %s
**Reason:** %s
**Points:** %s
]]):format(
        name, source,
        ids.license or 'n/a',
        ids.steam or 'n/a',
        ids.discord or 'n/a',
        reason,
        p.points
    ), 13632027)

    DropPlayer(source, KICK_MESSAGE)
end
Punishment.kick = kick

-- Ban (persistente + drop). Idempotente.
local function ban(source, reason, durationHours, bannedBy)
    local p = PRP.State.ensurePlayer(source)
    if p.banned then return end
    p.banned = true
    p.kicked = true

    local name = GetPlayerName(source) or ('ID ' .. tostring(source))
    local ids  = PRP.Identifiers.fromSource(source)

    PRP.Bans.add(ids, reason, durationHours, bannedBy or 'anticheat', function(row, err)
        if not row then
            print(('[prp-anticheat] FALHA ao banir source=%s: %s'):format(source, err or '?'))
            DropPlayer(source, KICK_MESSAGE)
            return
        end

        PRP.Webhook.send('Player BANNED (Anticheat)', ([[
**Player:** %s
**Source:** %s
**License:** %s
**Steam:** %s
**Discord:** %s
**IP:** %s
**Reason:** %s
**Duration:** %s
**By:** %s
]]):format(
            name, source,
            row.license or 'n/a',
            row.steam or 'n/a',
            row.discord or 'n/a',
            row.ip or 'n/a',
            reason,
            row.expires_at or 'permanente',
            row.banned_by or 'system'
        ), 9109504)

        DropPlayer(source, BAN_MESSAGE)
    end)
end
Punishment.ban = ban

-- Verifica se o jogador acumulou pontos suficientes para escalar punição.
-- Promove a ban antes de kick se BansEnabled e atingiu BanAtPoints.
local function escalateIfNeeded(source, reason)
    if not Config.Punishment.Enabled then return end
    local p = PRP.State.ensurePlayer(source)

    if Config.Punishment.BansEnabled and p.points >= Config.Punishment.BanAtPoints then
        ban(source, ('Pontos acumulados (%s ≥ %s) | último: %s')
            :format(p.points, Config.Punishment.BanAtPoints, reason),
            Config.Punishment.BanDurationHours, 'anticheat-auto')
        return
    end

    if p.points >= Config.Punishment.KickAtPoints then
        kick(source, reason)
    end
end

-- Adiciona pontos ao player. Webhook por cada chamada.
local function addPoints(source, reason, amount, detectionKey)
    local src = tonumber(source)
    if not src or src <= 0 then return end

    if isBypassed(src) then
        print(('[prp-anticheat] [BYPASS] %s (%s) | %s')
            :format(GetPlayerName(src) or '?', src, reason))
        return
    end

    local p = PRP.State.ensurePlayer(src)
    p.points     = p.points + (amount or 1)
    p.lastUpdate = PRP.Now()
    PRP.State.registerReason(p, reason)

    local playerName = GetPlayerName(src) or ('ID ' .. tostring(src))
    local text = ('[prp-anticheat] %s (%s) | +%s pts | total=%s | %s')
        :format(playerName, src, amount or 1, p.points, reason)
    print(text)
    PRP.Webhook.send('Suspicious Activity', text, 16753920)

    escalateIfNeeded(src, reason)
end

-- Ponto de entrada principal das detecções.
-- detectionKey é a string que aparece em KickOnDetection / BanOnDetection.
function Punishment.flag(source, detectionKey, reason, amount)
    local src = tonumber(source)
    if not src or src <= 0 then return end

    PRP.State.countDetection(detectionKey)

    if isBypassed(src) then
        print(('[prp-anticheat] [BYPASS] %s (%s) | %s | %s')
            :format(GetPlayerName(src) or '?', src, detectionKey, reason))
        return
    end

    -- Modo pontos.
    if Config.Punishment.Enabled and Config.Punishment.UsePoints == true then
        addPoints(src, reason, amount or 1, detectionKey)
        return
    end

    -- Modo direct-kick: log + webhook sempre (observabilidade independente
    -- de Punishment.Enabled).
    local playerName = GetPlayerName(src) or ('ID ' .. tostring(src))
    local text = ('[prp-anticheat] %s (%s) | %s'):format(playerName, src, reason)
    print(text)
    PRP.Webhook.send('Suspicious Activity', text, 16753920)

    if not Config.Punishment.Enabled then return end

    -- Ban tem precedência sobre kick para deteções high-confidence.
    if Config.Punishment.BansEnabled and Config.Punishment.BanOnDetection[detectionKey] then
        ban(src, ('Direct-ban: %s'):format(reason), Config.Punishment.BanDurationHours, 'anticheat-auto')
        return
    end

    if Config.Punishment.KickOnDetection[detectionKey] then
        kick(src, reason)
    end
end

-- Decay loop para o modo pontos.
function Punishment.startDecayLoop()
    if Config.Punishment.UsePoints ~= true then return end

    CreateThread(function()
        while true do
            Wait(Config.Punishment.DecayEveryMinutes * 60 * 1000)

            for src, p in pairs(PRP.State.players) do
                if GetPlayerName(src) then
                    p.points = math.max(0, p.points - Config.Punishment.DecayAmount)
                end
            end
        end
    end)
end
