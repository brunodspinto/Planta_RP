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
-- expires_in (segundos que faltam, contados pelo relógio da BD) evita misturar o
-- fuso horário do MySQL com o do servidor ao calcular quando o ban acaba.
local SELECT_ACTIVE = [[
    SELECT id, license, steam, discord, fivem, ip, reason, banned_at, expires_at, banned_by,
        TIMESTAMPDIFF(SECOND, NOW(), expires_at) AS expires_in
    FROM prp_anticheat_bans
    WHERE expires_at IS NULL OR expires_at > NOW()
]]

-- Momento (os.time) em que o ban acaba; nil = permanente
local function expiresTs(row)
    if row.expires_ts then return row.expires_ts end
    if row.expires_in then return os.time() + row.expires_in end
end

local function isExpired(row)
    local ts = expiresTs(row)
    return ts ~= nil and ts <= os.time()
end

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

-- O IP só entra no match com Config.Punishment.BanMatchIP (ver config.lua)
local function cacheKeys(row)
    local keys = {}
    if row.license then keys[#keys + 1] = 'license:' .. row.license end
    if row.steam   then keys[#keys + 1] = 'steam:'   .. row.steam end
    if row.discord then keys[#keys + 1] = 'discord:' .. row.discord end
    if row.fivem   then keys[#keys + 1] = 'fivem:'   .. row.fivem end
    if row.ip and Config.Punishment.BanMatchIP then keys[#keys + 1] = 'ip:' .. row.ip end
    return keys
end

local function cacheBan(row)
    row.expires_ts = expiresTs(row)
    for _, key in ipairs(cacheKeys(row)) do cache[key] = row end
end

-- Só limpa as chaves que ainda apontam para este ban, para não levar outro
-- ban que partilhe o mesmo identifier
local function evictBan(row)
    for _, key in ipairs(cacheKeys(row)) do
        local cached = cache[key]
        if cached and (cached == row or (row.id and cached.id == row.id)) then cache[key] = nil end
    end
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
-- A cache só é lida no arranque, por isso um ban temporário que já acabou é
-- retirado aqui; antes ficava a bloquear até ao próximo restart.
function Bans.lookup(idWithPrefix)
    local row = cache[idWithPrefix]
    if row and isExpired(row) then
        evictBan(row)
        return nil
    end
    return row
end

-- Lookup considerando todos os identifiers de um source.
-- Retorna primeiro ban encontrado ou nil.
function Bans.lookupBySource(source)
    local ids = PRP.Identifiers.fromSource(source)
    for kind, value in pairs(ids) do
        local row = value and Bans.lookup(value)
        if row then
            return row, kind
        end
    end
    return nil
end

-- Texto para mensagens: data de fim no fuso do servidor, ou 'permanente'
function Bans.expiryText(row)
    local ts = expiresTs(row)
    return ts and os.date('%d/%m/%Y %H:%M', ts) or 'permanente'
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

    -- O fim é calculado pelo NOW() da BD, o mesmo relógio do WHERE em SELECT_ACTIVE.
    -- Com os.date, um MySQL noutro fuso horário deslocava a hora de fim.
    local seconds = nil
    if durationHours and durationHours > 0 then
        seconds = math.floor(durationHours * 3600)
    end

    local params = { clean.license, clean.steam, clean.discord, clean.fivem, clean.ip, reason or 'unspecified' }
    if seconds then params[#params + 1] = seconds end
    params[#params + 1] = bannedBy or 'system'

    MySQL.insert(
        ([[INSERT INTO prp_anticheat_bans
            (license, steam, discord, fivem, ip, reason, expires_at, banned_by)
          VALUES (?, ?, ?, ?, ?, ?, %s, ?)]]):format(seconds and 'DATE_ADD(NOW(), INTERVAL ? SECOND)' or 'NULL'),
        params,
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
                expires_ts = seconds and os.time() + seconds,
                banned_by  = bannedBy or 'system',
            }
            row.expires_at = seconds and Bans.expiryText(row)
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
    local expires = Bans.expiryText(row)
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
