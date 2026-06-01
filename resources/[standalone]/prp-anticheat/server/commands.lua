-- prp-anticheat: comandos administrativos.

PRP = PRP or {}
PRP.Commands = {}

local function reply(source, msg)
    if source == 0 then
        print(msg)
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 80, 80 },
            args = { 'prp-anticheat', msg },
        })
    end
end

local function requireAdmin(source)
    if source == 0 then return true end
    if Config.AdminAce and IsPlayerAceAllowed(source, Config.AdminAce) then return true end
    return false
end

-- /acstatus <id> | mostra pontos + últimas razões.
RegisterCommand('acstatus', function(source, args)
    if not requireAdmin(source) then return end

    local target = tonumber(args[1]) or source
    if not target or target <= 0 then
        reply(source, 'uso: /acstatus <id>')
        return
    end

    local p = PRP.State.getPlayer(target)
    if not p then
        reply(source, ('player=%s sem registos'):format(target))
        return
    end

    local lines = {
        ('player=%s name=%s'):format(target, GetPlayerName(target) or 'offline'),
        ('points=%s bypassed=%s kicked=%s banned=%s'):format(
            p.points, tostring(p.bypassed), tostring(p.kicked), tostring(p.banned or false)),
    }

    local n = #p.reasons
    if n > 0 then
        local from = math.max(1, n - 4)
        for i = from, n do
            lines[#lines + 1] = ('  - %s | %s'):format(
                os.date('%H:%M:%S', p.reasons[i].at), p.reasons[i].reason)
        end
    else
        lines[#lines + 1] = '  (sem razões registadas)'
    end

    for _, line in ipairs(lines) do reply(source, line) end
end, false)

-- /acreset <id> | zera pontos sessão atual.
RegisterCommand('acreset', function(source, args)
    if not requireAdmin(source) then return end

    local target = tonumber(args[1])
    if not target or target <= 0 then
        reply(source, 'uso: /acreset <id>')
        return
    end

    local p = PRP.State.getPlayer(target)
    if not p then
        reply(source, ('player=%s já estava limpo'):format(target))
        return
    end

    p.points  = 0
    p.reasons = {}
    p.kicked  = false

    reply(source, ('player=%s pontos zerados'):format(target))
    PRP.Webhook.send('Anticheat Reset',
        ('Admin %s zerou pontos do player %s'):format(
            source == 0 and 'CONSOLE' or source, target),
        3066993)
end, false)

-- /acban <id> [hours] [reason...] | hours=0 ou omitido = permanente.
RegisterCommand('acban', function(source, args)
    if not requireAdmin(source) then return end

    local target = tonumber(args[1])
    if not target or target <= 0 then
        reply(source, 'uso: /acban <id> [hours] [reason...]')
        return
    end

    if not GetPlayerName(target) then
        reply(source, ('player=%s não está online'):format(target))
        return
    end

    local hours = tonumber(args[2]) or 0
    local reasonStart = (args[2] and tonumber(args[2])) and 3 or 2
    local reason = 'manual ban'
    if #args >= reasonStart then
        local parts = {}
        for i = reasonStart, #args do parts[#parts + 1] = args[i] end
        if #parts > 0 then reason = table.concat(parts, ' ') end
    end

    local bannedBy = source == 0 and 'CONSOLE' or ('admin:' .. source)
    PRP.Punishment.ban(target, reason, hours, bannedBy)
    reply(source, ('player=%s banido (%sh, motivo=%s)')
        :format(target, hours == 0 and 'permanente' or hours, reason))
end, false)

-- /acunban <license> | aceita com ou sem prefixo "license:".
RegisterCommand('acunban', function(source, args)
    if not requireAdmin(source) then return end

    local license = args[1]
    if not license or license == '' then
        reply(source, 'uso: /acunban <license>')
        return
    end

    PRP.Bans.removeByLicense(license, function(ok, err)
        if ok then
            reply(source, ('license=%s removida'):format(license))
            PRP.Webhook.send('Anticheat Unban',
                ('Admin %s removeu ban da license=%s'):format(
                    source == 0 and 'CONSOLE' or source, license),
                3066993)
        else
            reply(source, ('falhou: %s'):format(err or 'erro'))
        end
    end)
end, false)

-- /aclist [limit] | últimos N bans (default 20).
RegisterCommand('aclist', function(source, args)
    if not requireAdmin(source) then return end

    local limit = tonumber(args[1]) or 20
    if limit < 1 then limit = 20 end
    if limit > 100 then limit = 100 end

    PRP.Bans.list(limit, function(rows)
        if #rows == 0 then
            reply(source, 'nenhum ban activo')
            return
        end
        reply(source, ('=== %s bans activos ==='):format(#rows))
        for i = 1, #rows do
            reply(source, PRP.Bans.formatRow(rows[i]))
        end
    end)
end, false)

-- /acstats | métricas globais.
RegisterCommand('acstats', function(source)
    if not requireAdmin(source) then return end

    local m = PRP.State.snapshotMetrics()
    reply(source, ('=== prp-anticheat | uptime=%ss ==='):format(m.uptimeSeconds))
    reply(source, ('detections=%s kicks=%s bans=%s')
        :format(m.detectionsTotal, m.kicksTotal, m.bansTotal))
    reply(source, ('webhook sent=%s dropped=%s retries=%s')
        :format(m.webhookSent, m.webhookDropped, m.webhookRetries))

    if next(m.detectionsByType) then
        reply(source, 'por tipo:')
        for k, v in pairs(m.detectionsByType) do
            reply(source, ('  %s = %s'):format(k, v))
        end
    end
end, false)

-- /achelp | listar comandos.
RegisterCommand('achelp', function(source)
    if not requireAdmin(source) then return end

    local cmds = {
        '/acstatus <id>           — info do jogador',
        '/acreset <id>            — zera pontos da sessão',
        '/acban <id> [h] [motivo] — ban (h=0 permanente)',
        '/acunban <license>       — remove ban',
        '/aclist [N]              — listar últimos N bans',
        '/acstats                 — métricas globais',
        '/achelp                  — esta lista',
    }
    for _, line in ipairs(cmds) do reply(source, line) end
end, false)
