-- prp-anticheat: entry point.
-- Os módulos (state, identifiers, webhook, bans, punishment, detections,
-- commands, exports) já estão carregados antes deste ficheiro pelo fxmanifest.

PRP = PRP or {}

-- =============================================================================
-- Conexão: verificar ban antes de aceitar.
-- =============================================================================
AddEventHandler('playerConnecting', function(playerName, _, deferrals)
    local src = source
    deferrals.defer()
    Wait(0)
    deferrals.update('A verificar credenciais...')

    if not Config.Punishment.BansEnabled then
        deferrals.done()
        return
    end

    local ban, matchKind = PRP.Bans.lookupBySource(src)
    if ban then
        local expires = ban.expires_at or 'permanente'
        deferrals.done(
            ('[prp-anticheat] Estás banido.\nMotivo: %s\nExpira: %s\nReferência: ban #%s\nMatch: %s')
                :format(ban.reason or 'n/a', expires, ban.id or '?', matchKind or 'n/a'))
        return
    end

    deferrals.done()
end)

-- =============================================================================
-- Lifecycle: registar joinedAt cedo + cleanup no drop.
-- =============================================================================
AddEventHandler('playerJoining', function()
    local src = source
    if src and src > 0 then
        local p = PRP.State.ensurePlayer(src)
        p.joinedAt    = PRP.Now()
        p.identifiers = PRP.Identifiers.fromSource(src)
        -- Verifica bypass uma vez aqui — IsPlayerAceAllowed pode falhar
        -- antes de o jogador estar totalmente conectado, por isso é só
        -- best-effort. punishment.isBypassed faz lazy-check depois.
        if Config.BypassAce and Config.BypassAce ~= '' then
            local ok, allowed = pcall(IsPlayerAceAllowed, src, Config.BypassAce)
            if ok and allowed then
                p.bypassed = true
                print(('[prp-anticheat] %s (%s) entrou com BYPASS ACE')
                    :format(GetPlayerName(src) or '?', src))
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    if src and src > 0 then
        PRP.State.dropPlayer(src)
    end
end)

-- =============================================================================
-- Boot.
-- =============================================================================
CreateThread(function()
    -- Aguarda 1 tick para garantir que oxmysql está pronto.
    Wait(0)

    PRP.Bans.init()
    PRP.Detections.init()
    PRP.Punishment.startDecayLoop()

    print(('[prp-anticheat] v2.0 carregado | mode=%s | bans=%s | bypass-ace=%s')
        :format(
            Config.Punishment.UsePoints and 'pontos' or 'direct-kick',
            tostring(Config.Punishment.BansEnabled),
            Config.BypassAce or 'n/a'))
end)
