-- prp-anticheat: API pública para outros recursos.
--
-- Uso típico de outro script de gameplay:
--   exports['prp-anticheat']:Flag(src, 'qb-banking:custom-check', 'tentativa inválida', 4)
--   if exports['prp-anticheat']:IsBanned(license) then ... end

PRP = PRP or {}

-- Devolve pontos atuais do jogador (0 se sem registo).
exports('GetPlayerScore', function(source)
    local p = PRP.State.getPlayer(tonumber(source) or -1)
    return p and p.points or 0
end)

-- Permite outros scripts sinalizarem suspeitas.
-- detectionKey deve ser único por recurso para aparecer correctamente em
-- /acstats e em Config.Punishment.KickOnDetection.
exports('Flag', function(source, detectionKey, reason, amount)
    PRP.Punishment.flag(source, detectionKey or 'External', reason or 'no reason', amount or 1)
end)

-- Verifica se um license já está banido.
-- Aceita 'license:abc' ou 'abc'. Lookup é em cache (O(1)).
exports('IsBanned', function(license)
    if not license then return false end
    if not license:find('license:', 1, true) then
        license = 'license:' .. license
    end
    return PRP.Bans.lookup(license) ~= nil
end)

-- Verifica se um source online tem ban activo (qualquer identifier).
exports('IsSourceBanned', function(source)
    local ban = PRP.Bans.lookupBySource(tonumber(source) or -1)
    return ban ~= nil
end)

-- Snapshot das métricas globais (cópia segura).
exports('GetMetrics', function()
    return PRP.State.snapshotMetrics()
end)

-- Bypass check para outros scripts respeitarem.
exports('IsBypassed', function(source)
    return PRP.Punishment.isBypassed(tonumber(source) or -1)
end)
