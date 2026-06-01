Config = {}

Config.Debug = false

-- =============================================================================
-- Logging
-- =============================================================================
Config.Logging = {
    -- IMPORTANTE: este campo é APENAS fallback. O URL real deve vir da convar
    -- DISCORD_WEBHOOK_SECURITY em server.cfg. Nunca coles um URL real aqui:
    -- este ficheiro está versionado.
    Webhook = '',
    ServerName = 'Planta RP',

    -- Janela deslizante para envio. Discord rejeita com 429 acima de ~30/min.
    RateLimitWindowSeconds = 60,
    RateLimitMaxPerWindow  = 25,

    -- Retry para erros 5xx/timeout. Tamanho de RetryBackoffSeconds define o
    -- número máximo de tentativas. 4xx (config errada) NÃO faz retry.
    RetryBackoffSeconds = { 2, 8, 20 },
}

-- =============================================================================
-- ACL
-- =============================================================================
-- ACE que dá acesso aos comandos /ac*. Use uma ACE real (não um principal).
-- 'admin' funciona out-of-the-box com qb-core (este faz `add_ace qbcore.admin
-- admin allow` no arranque). 'group.admin' é um principal e NÃO funciona.
Config.AdminAce = 'admin'

-- ACE de bypass total. Atribuir a devs/testers que precisam de spawnar entidades
-- em massa para testes sem disparar detecções.
--   add_ace identifier.license:XXXXXX prp_anticheat.bypass
-- Bypassed players ficam com hits zerados e nunca são kicked/banned, mas
-- continuam a aparecer no log (com tag [BYPASS]) para auditoria.
Config.BypassAce = 'prp_anticheat.bypass'

-- =============================================================================
-- Punishment
-- =============================================================================
Config.Punishment = {
    -- Master switch. False = modo observação (loga tudo, não kick/ban).
    Enabled = true,

    -- Modo. False = direct-kick por detection (avalia KickOnDetection).
    --       True  = sistema de pontos (KickAtPoints / DecayEveryMinutes).
    UsePoints = false,

    -- Apenas usado se UsePoints = true.
    KickAtPoints       = 12,
    DecayEveryMinutes  = 15,
    DecayAmount        = 2,

    -- Em modo direct-kick: que tipos kick imediatamente?
    KickOnDetection = {
        BlacklistedEvents     = true,
        ExplosionBlacklisted  = false,
        ExplosionSpam         = false,
        EntitySpam            = false,
        MonitoredEventSpam    = false,
        WeaponDamageModifier  = true,
        GodMode               = true,
    },

    -- Bans persistentes via MySQL.
    BansEnabled        = true,
    BanAtPoints        = 30, -- em modo pontos, threshold para promover a ban.
    BanDurationHours   = 0,  -- 0 = permanente. Pode ser overridden por /acban.

    -- Em modo direct-kick: que tipos disparam ban automático (em vez de só kick)?
    -- Aplica-se apenas a detecções de altíssima confiança.
    BanOnDetection = {
        BlacklistedEvents     = false,
        WeaponDamageModifier  = true,
        GodMode               = false,
    },
}

-- =============================================================================
-- Detections
-- =============================================================================
Config.Detections = {
    BlacklistedEvents = {
        Enabled = true,
        Points  = 6,
        Events = {
            'esx:getSharedObject',
            'esx_society:openBossMenu',
            'esx_ambulancejob:revive',
            'HCheat:TempDisableDetection',
            'UndetectedServerEvent',
            'antilynx8:anticheat',
            'antilynxr4:detect',
            'mellotrainer:adminTempBan',
            'ynx8:anticheat',
            'AdminMenu:giveCash',
            'AdminMenu:spawnItem',
            'Lynx8:DestroyAllVehicles',
            'LynxEvo:ClearArea',
            'redst0nia:checking',
            'js:jailuser',
            'js:removejailtime',
            'laundry:washcash',
            'betrayed:8282',
            'f0ba1292-b68d-4d95-8823-6230cdf282b6',
            'pawnshop:بيع',
            'bank:deposit',
            'bank:withdraw',
        },
    },

    Explosion = {
        Enabled                  = true,
        WindowSeconds            = 10,
        MaxPerWindow             = 20,
        PointsForSpam            = 2,
        BlacklistedTypes = {
            [0]  = true, -- Grenade
            [1]  = true, -- Grenade Launcher
            [2]  = true, -- Stickybomb
            [4]  = true, -- Molotov
            [5]  = true, -- Rocket
            [25] = true, -- Plane rocket
            [32] = true, -- Underwater
        },
        PointsForBlacklistedType = 4,
        CancelBlacklisted        = false,
    },

    EntitySpam = {
        Enabled                = true,
        WindowSeconds          = 10,
        MaxPerWindow           = 180,
        GraceAfterJoinSeconds  = 120,
        PointsForSpam          = 2,
        CancelWhenExceeded     = false,
    },

    -- Monitorização opt-in de eventos legítimos.
    -- Ex.: ['qb-phone:server:sendNewMail'] = { max = 8, window = 10, points = 2 }
    MonitoredEvents = {
    },

    -- Validação de weapon damage. Captura "weapon damage modifier" cheats.
    -- Funciona para PvP. Headshots usam multiplicador (capturado por HeadShotMultiplier).
    WeaponDamage = {
        Enabled            = true,
        Points             = 8,
        HeadShotMultiplier = 3.0, -- tolerância para headshot real
        -- Dano máximo confiável por weapon hash. Calculado em runtime para evitar
        -- carregar `GetHashKey` no parse. Mapeamento string→max.
        MaxDamageByWeapon = {
            ['WEAPON_UNARMED']          = 15,
            ['WEAPON_KNIFE']            = 30,
            ['WEAPON_BAT']              = 30,
            ['WEAPON_HAMMER']           = 30,
            ['WEAPON_CROWBAR']          = 30,
            ['WEAPON_GOLFCLUB']         = 30,
            ['WEAPON_NIGHTSTICK']       = 30,
            ['WEAPON_WRENCH']           = 30,
            ['WEAPON_PISTOL']           = 60,
            ['WEAPON_COMBATPISTOL']     = 60,
            ['WEAPON_APPISTOL']         = 60,
            ['WEAPON_PISTOL50']         = 110,
            ['WEAPON_SNSPISTOL']        = 60,
            ['WEAPON_HEAVYPISTOL']      = 60,
            ['WEAPON_VINTAGEPISTOL']    = 60,
            ['WEAPON_REVOLVER']         = 200,
            ['WEAPON_MICROSMG']         = 50,
            ['WEAPON_SMG']              = 50,
            ['WEAPON_ASSAULTSMG']       = 50,
            ['WEAPON_COMBATPDW']        = 50,
            ['WEAPON_PUMPSHOTGUN']      = 90,
            ['WEAPON_SAWNOFFSHOTGUN']   = 100,
            ['WEAPON_ASSAULTSHOTGUN']   = 90,
            ['WEAPON_ASSAULTRIFLE']     = 60,
            ['WEAPON_CARBINERIFLE']     = 60,
            ['WEAPON_ADVANCEDRIFLE']    = 60,
            ['WEAPON_SPECIALCARBINE']   = 60,
            ['WEAPON_BULLPUPRIFLE']     = 60,
            ['WEAPON_SNIPERRIFLE']      = 220,
            ['WEAPON_HEAVYSNIPER']      = 280,
            ['WEAPON_STUNGUN']          = 1,
        },
        DefaultMaxDamage = 250, -- fallback para weapons não listadas (RPG, etc).
    },

    -- God mode polling.
    -- Requer GetEntityHealth server-side (FXServer >= 6486).
    GodMode = {
        Enabled         = true,
        IntervalSeconds = 8,
        MaxHealth       = 200, -- 100 health + 100 armor no GTA V vanilla
        GraceSeconds    = 30,  -- skip após join (loading)
        Points          = 8,
    },
}
