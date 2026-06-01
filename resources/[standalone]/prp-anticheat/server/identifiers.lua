-- prp-anticheat: helpers para identifiers de jogador.

PRP = PRP or {}
PRP.Identifiers = {}

local Identifiers = PRP.Identifiers

local PREFIXES = {
    license = 'license:',
    license2 = 'license2:',
    steam   = 'steam:',
    discord = 'discord:',
    fivem   = 'fivem:',
    ip      = 'ip:',
}

-- Lê os identifiers brutos do source.
-- Retorna table { license=..., steam=..., discord=..., fivem=..., ip=... }
-- Cada valor é o ID completo (com prefixo) ou nil se ausente.
function Identifiers.fromSource(source)
    local result = {}
    if not source or source <= 0 then return result end

    local n = GetNumPlayerIdentifiers(source)
    if not n or n == 0 then return result end

    for i = 0, n - 1 do
        local id = GetPlayerIdentifier(source, i)
        if id then
            for kind, prefix in pairs(PREFIXES) do
                if id:sub(1, #prefix) == prefix and not result[kind] then
                    result[kind] = id
                end
            end
        end
    end

    -- license2 conta como license para fins de match em bans.
    if not result.license and result.license2 then
        result.license = result.license2
    end

    return result
end

-- Trim do prefixo. license:abcd1234 → abcd1234.
function Identifiers.stripPrefix(id)
    if not id then return nil end
    local colon = id:find(':', 1, true)
    if not colon then return id end
    return id:sub(colon + 1)
end

-- Constrói uma linha resumo para embeds/logs.
function Identifiers.format(ids)
    local parts = {}
    if ids.license then parts[#parts + 1] = ids.license end
    if ids.steam   then parts[#parts + 1] = ids.steam end
    if ids.discord then parts[#parts + 1] = ids.discord end
    if ids.fivem   then parts[#parts + 1] = ids.fivem end
    if ids.ip      then parts[#parts + 1] = ids.ip end
    return #parts > 0 and table.concat(parts, ' | ') or 'n/a'
end
