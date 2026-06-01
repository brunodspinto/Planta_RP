-- prp-anticheat: detecções.

PRP = PRP or {}
PRP.Detections = {}

local Detections = PRP.Detections
local flag = function(...) PRP.Punishment.flag(...) end

-- =============================================================================
-- 1) Eventos blacklisted (mod menus conhecidos)
-- =============================================================================
local function initBlacklistedEvents()
    local cfg = Config.Detections.BlacklistedEvents
    if not cfg.Enabled then return end

    for _, eventName in ipairs(cfg.Events) do
        RegisterNetEvent(eventName, function()
            local src = source
            flag(src, 'BlacklistedEvents',
                'Triggered blacklisted event: ' .. eventName,
                cfg.Points)
            CancelEvent()
        end)
    end
end

-- =============================================================================
-- 2) Eventos legítimos monitorizados (opt-in via config)
-- =============================================================================
local function initMonitoredEvents()
    for eventName, eventCfg in pairs(Config.Detections.MonitoredEvents) do
        RegisterNetEvent(eventName, function()
            local src = source
            if not src or src <= 0 then return end

            local count = PRP.State.bumpWindow('monitored:' .. eventName, tostring(src), eventCfg.window)
            if count > eventCfg.max then
                flag(src, 'MonitoredEventSpam',
                    ('Event spam detected: %s (%s/%ss)'):format(eventName, count, eventCfg.window),
                    eventCfg.points)
            end
        end)
    end
end

-- =============================================================================
-- 3) Explosões — spam + tipos blacklisted
-- =============================================================================
local function initExplosionGuard()
    local cfg = Config.Detections.Explosion
    if not cfg.Enabled then return end

    AddEventHandler('explosionEvent', function(sender, eventData)
        if not sender or tonumber(sender) == nil or tonumber(sender) <= 0 then
            return
        end
        if type(eventData) ~= 'table' then return end

        local explosionType = tonumber(eventData.explosionType or -1)
        local count = PRP.State.bumpWindow('explosion', tostring(sender), cfg.WindowSeconds)

        if cfg.BlacklistedTypes[explosionType] then
            flag(sender, 'ExplosionBlacklisted',
                ('Blacklisted explosion type: %s'):format(explosionType),
                cfg.PointsForBlacklistedType)
            if cfg.CancelBlacklisted then CancelEvent() end
            return
        end

        if count > cfg.MaxPerWindow then
            flag(sender, 'ExplosionSpam',
                ('Explosion spam: %s in %ss'):format(count, cfg.WindowSeconds),
                cfg.PointsForSpam)
        end
    end)
end

-- =============================================================================
-- 4) Spam de criação de entidades
-- =============================================================================
local function initEntitySpamGuard()
    local cfg = Config.Detections.EntitySpam
    if not cfg.Enabled then return end

    AddEventHandler('entityCreating', function(entity)
        local owner = NetworkGetEntityOwner(entity)
        if not owner or owner <= 0 then return end

        -- Garante state para applicar grace coerentemente, mesmo que
        -- entityCreating chegue antes de playerJoining.
        local p = PRP.State.ensurePlayer(owner)
        if cfg.GraceAfterJoinSeconds > 0
            and (PRP.Now() - p.joinedAt) < cfg.GraceAfterJoinSeconds then
            return
        end

        local count = PRP.State.bumpWindow('entity', tostring(owner), cfg.WindowSeconds)
        if count > cfg.MaxPerWindow then
            flag(owner, 'EntitySpam',
                ('Entity spam: %s in %ss'):format(count, cfg.WindowSeconds),
                cfg.PointsForSpam)
            if cfg.CancelWhenExceeded then CancelEvent() end
        end
    end)
end

-- =============================================================================
-- 5) Weapon damage modifier
-- =============================================================================
-- weaponDamageEvent: server-side handler que recebe data sobre damage feito
-- por um jogador. Validamos contra dano máximo confiado por weapon.
local function initWeaponDamageGuard()
    local cfg = Config.Detections.WeaponDamage
    if not cfg.Enabled then return end

    -- Build de tabela hash → max em runtime (GetHashKey existe server-side).
    local maxByHash = {}
    for weaponName, maxDamage in pairs(cfg.MaxDamageByWeapon) do
        maxByHash[GetHashKey(weaponName)] = maxDamage
    end

    AddEventHandler('weaponDamageEvent', function(sender, data)
        if not sender or tonumber(sender) == nil or tonumber(sender) <= 0 then
            return
        end
        if type(data) ~= 'table' then return end

        local damage = tonumber(data.weaponDamage or data.damage)
        local weapon = tonumber(data.weaponType)
        if not damage or not weapon then return end

        local maxAllowed = maxByHash[weapon] or cfg.DefaultMaxDamage
        if data.hitGlobalId and data.hitGlobalId ~= 0 then
            -- Tem alvo; aplicar headshot multiplier.
            -- isHeadShot vem em alguns FXServers; fallback liberal.
            if data.isHeadShot then
                maxAllowed = maxAllowed * (cfg.HeadShotMultiplier or 2.5)
            end
        end

        if damage > maxAllowed then
            flag(sender, 'WeaponDamageModifier',
                ('Weapon=%s damage=%s > max=%s'):format(weapon, damage, math.floor(maxAllowed)),
                cfg.Points)
        end
    end)
end

-- =============================================================================
-- 6) God mode polling
-- =============================================================================
-- Em FXServer recente, GetEntityHealth(GetPlayerPed(src)) funciona server-side.
local function initGodModeLoop()
    local cfg = Config.Detections.GodMode
    if not cfg.Enabled then return end

    CreateThread(function()
        while true do
            Wait(cfg.IntervalSeconds * 1000)

            for src, p in pairs(PRP.State.players) do
                -- Skip durante grace de loading.
                if (PRP.Now() - p.joinedAt) >= cfg.GraceSeconds then
                    local ped = GetPlayerPed(src)
                    if ped and ped ~= 0 then
                        local health = GetEntityHealth(ped)
                        if health and health > cfg.MaxHealth then
                            -- Throttle: 1 deteção por ciclo por jogador.
                            if (PRP.Now() - (p.lastHealthCheck or 0)) >= cfg.IntervalSeconds then
                                p.lastHealthCheck = PRP.Now()
                                flag(src, 'GodMode',
                                    ('Health=%s > max=%s'):format(health, cfg.MaxHealth),
                                    cfg.Points)
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- =============================================================================
-- Init pública
-- =============================================================================
function Detections.init()
    initBlacklistedEvents()
    initMonitoredEvents()
    initExplosionGuard()
    initEntitySpamGuard()
    initWeaponDamageGuard()
    initGodModeLoop()
end
