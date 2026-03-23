Config = {}

Config.Debug = false

Config.Logging = {
    Webhook = '',
    ServerName = 'Planta RP'
}

Config.AdminAce = 'group.admin'

Config.Punishment = {
    Enabled = true,
    KickAtPoints = 12,
    DecayEveryMinutes = 15,
    DecayAmount = 2
}

Config.Detections = {
    BlacklistedEvents = {
        Enabled = true,
        Points = 6,
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
            'bank:withdraw'
        }
    },

    Explosion = {
        Enabled = true,
        WindowSeconds = 10,
        MaxPerWindow = 8,
        PointsForSpam = 2,
        BlacklistedTypes = {
            [0] = true,
            [1] = true,
            [2] = true,
            [4] = true,
            [5] = true,
            [25] = true,
            [32] = true
        },
        PointsForBlacklistedType = 4,
        CancelBlacklisted = true
    },

    EntitySpam = {
        Enabled = true,
        WindowSeconds = 10,
        MaxPerWindow = 35,
        PointsForSpam = 2,
        CancelWhenExceeded = true
    },

    -- Monitora eventos legitimos para detectar spam anormal.
    -- Exemplo:
    -- ['qb-phone:server:sendNewMail'] = { max = 8, window = 10, points = 2 }
    MonitoredEvents = {
    }
}
