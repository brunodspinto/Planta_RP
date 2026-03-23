Config = Config or {}
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'
-- Config --

Config.StandDeposit = 600

Config.MyLevel = 1
Config.MaxReputation = 200

Config.Locations = {
    ["take"] = {
        coords = vector4(39.31, -1005.54, 29.48, 240.57),
    },
    ["spawn"] = {
        coords = vector4(38.15, -1001.65, 29.44, 342.5),
    },
}

Config.Stock = {
    ["exotic"] = {
        Current = 0,
        Max = {
            [1] = 15,
            [2] = 30,
            [3] = 45,
            [4] = 60,
        },
        Label = Lang:t("info.label_a"),
        Price = {
            [1] = {
                min = 16,
                max = 24,
            },
            [2] = {
                min = 18,
                max = 26,
            },
            [3] = {
                min = 20,
                max = 28,
            },
            [4] = {
                min = 22,
                max = 30,
            },
        }
    },
    ["rare"] = {
        Current = 0,
        Max = {
            [1] = 15,
            [2] = 30,
            [3] = 45,
            [4] = 60,
        },
        Label = Lang:t("info.label_b"),
        Price = {
            [1] = {
                min = 14,
                max = 20,
            },
            [2] = {
                min = 16,
                max = 22,
            },
            [3] = {
                min = 18,
                max = 24,
            },
            [4] = {
                min = 20,
                max = 26,
            },
        }
    },
    ["common"] = {
        Current = 0,
        Max = {
            [1] = 15,
            [2] = 30,
            [3] = 45,
            [4] = 60,
        },
        Label = Lang:t('info.label_c'),
        Price = {
            [1] = {
                min = 10,
                max = 16,
            },
            [2] = {
                min = 12,
                max = 18,
            },
            [3] = {
                min = 14,
                max = 20,
            },
            [4] = {
                min = 16,
                max = 22,
            },
        }
    },
}
