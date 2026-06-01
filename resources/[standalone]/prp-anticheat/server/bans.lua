-- prp-anticheat: bans persistentes em MySQL.
-- Inclui cache em memória para evitar query a cada conexão.

PRP = PRP or {}
PRP.Bans = {}

local Bans = PRP.Bans

-- Cache: chaveado por todos os identifiers disponíveis para lookup rápido.
-- Estrutura: { ['license:abc'] = banRow, ['steam:123'] = banRow, ... }
local cache = {}

-- Schema lookup expr: SELECT que filtra bans ainda válidos.
-- expires_at IS NULL = permanente, ou expires_at > NOW().
local SELECT_ACTIVE = [[
    SELECT id, license, steam, discord, fivem, ip, reason, banned_at, expires_at, banned_by
    FROM prp_anticheat_bans
    WHERE expires_at IS NULL OR expires_at > NOW()
]]

local function ensureSchema(cb)
    local sql = LoadResourceFile(GetCurrentResourceName(), 'sql/install.sql')
    if not sql or sql == '' then
        print('[prp-anticheat] ERRO: sql/install.sql não encontrado/vazio. Bans desligados.')
        if cb then cb(false) end
        return
    end

    MySQL.query(sql, {}, function(_)
        if cb then cb(true) end
    end)
end

local function cacheBan(row)
    if row.license then cache['license:' .. row.license] = row end
    if row.steam   then cache['steam:'   .. row.steam]   = row end
    if row.discord then cache['discord:' .. row.discord] = row end
    if row.fivem   then cache['fivem:'   .. row.fivem]   = row end
    if row.ip      then cache['ip:'      .. row.ip]      = row end
end

local function evictBan(row)
    if row.license then cache['license:' .. row.license] = nil end
    if row.steam   then cache['steam:'   .. row.steam]   = nil end
    if row.discord then cache['discord:' .. row.discord] = nil end
    if row.fivem   then cache['fivem:'   .. row.fivem]   = nil end
    if row.ip      then cache['ip:'      .. row.ip]      = nil end
end

local function loadActive(cb)
    MySQL.query(SELECT_ACTIVE, {}, function(rows)
        cache = {}
        if not rows then
            if cb then cb(0) end
            return
        end
        for i = 1, #rows do
            cacheBan(rows[i])
        end
        if cb then cb(#rows) end
    end)
end

function Bans.init()
    if not Config.Punishment.BansEnabled then
        print('[prp-anticheat] Bans desligados (Config.Punishment.BansEnabled=false).')
        return
    end

    ensureSchema(function(ok)
        if not ok then return end
        loadActive(function(count)
            print(('[prp-anticheat] Bans carregados: %d activos em memória'):format(count))
        end)
    end)
end

-- Lookup por identifier completo (com prefixo).
-- Ex.: Bans.lookup('license:abc123') → banRow ou nil.
function Bans.lookup(idWithPrefix)
    return cache[idWithPrefix]
end

-- Lookup considerando todos os identifiers de um source.
-- Retorna primeiro ban encontrado ou nil.
function Bans.lookupBySource(source)
    local ids = PRP.Identifiers.fromSource(source)
    for kind, value in pairs(ids) do
        if value and cache[value] then
            return cache[value], kind
        end
    end
    return nil
end

-- Adiciona ban. ids = table com qualquer subset de {license, steam, discord, fivem, ip}.
-- Cada valor pode ter ou não ter prefixo — normalizamos sem prefixo na BD.
-- durationHours: 0 ou nil = permanente.
function Bans.add(ids, reason, durationHours, bannedBy, cb)
    local clean = {}
    for k, v in pairs(ids) do
        clean[k] = PRP.Identifiers.stripPrefix(v)
    end

    if not (clean.license or clean.steam or clean.discord or clean.fivem or clean.ip) then
        if cb then cb(nil, 'Nenhum identifier válido') end
        return
    end

    local expiresAt = nil
    if durationHours and durationHours > 0 then
        expiresAt = os.date('%Y-%m-%d %H:%M:%S', os.time() + durationHours * 3600)
    end

    MySQL.insert(
        [[INSERT INTO prp_anticheat_bans
            (license, steam, discord, fivem, ip, reason, expires_at, banned_by)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)]],
        {
            clean.license, clean.steam, clean.discord, clean.fivem, clean.ip,
            reason or 'unspecified', expiresAt, bannedBy or 'system'
        },
        function(insertId)
            if not insertId or insertId == 0 then
                if cb then cb(nil, 'INSERT falhou') end
                return
            end

            local row = {
                id         = insertId,
                license    = clean.license,
                steam      = clean.steam,
                discord    = clean.discord,
                fivem      = clean.fivem,
                ip         = clean.ip,
                reason     = reason,
                expires_at = expiresAt,
                banned_by  = bannedBy or 'system',
            }
            cacheBan(row)
            PRP.State.countMetric('bansTotal')
            if cb then cb(row) end
        end
    )
end

-- Remove ban por license.
function Bans.removeByLicense(license, cb)
    license = PRP.Identifiers.stripPrefix(license)
    if not license then
        if cb then cb(false, 'license inválida') end
        return
    end

    MySQL.query(
        'SELECT * FROM prp_anticheat_bans WHERE license = ?',
        { license },
        function(rows)
            if not rows or #rows == 0 then
                if cb then cb(false, 'sem ban activo para esta license') end
                return
            end

            MySQL.update(
                'DELETE FROM prp_anticheat_bans WHERE license = ?',
                { license },
                function(affected)
                    for i = 1, #rows do evictBan(rows[i]) end
                    if cb then cb(affected and affected > 0, nil, affected) end
                end
            )
        end
    )
end

-- Lista bans activos. limit defaults para 50.
function Bans.list(limit, cb)
    limit = limit or 50
    MySQL.query(
        SELECT_ACTIVE .. ' ORDER BY banned_at DESC LIMIT ?',
        { limit },
        function(rows)
            if cb then cb(rows or {}) end
        end
    )
end

-- Re-load do cache. Útil após mudanças manuais na BD.
function Bans.reload(cb)
    loadActive(cb)
end

function Bans.formatRow(row)
    local expires = row.expires_at or 'permanente'
    return ('#%s | license=%s steam=%s discord=%s | reason=%s | expires=%s | by=%s'):format(
        row.id or '?',
        row.license or 'n/a',
        row.steam or 'n/a',
        row.discord or 'n/a',
        row.reason or 'n/a',
        expires,
        row.banned_by or 'n/a'
    )
end
