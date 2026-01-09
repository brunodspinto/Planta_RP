-- Zones for Menus
Config = Config or {}

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' -- Use qb-target interactions (don't change this, go to your server.cfg and add `setr UseTarget true` to use this and just that from true to false or the other way around)

Config.BossMenus = {
    police = {
        vector3(447.16, -974.31, 30.47),
    },
    ambulance = {
        vector3(311.21, -599.36, 43.29),
    },
    cardealer = {
        vector3(-32.94, -1114.64, 26.42),
    },
    mechanic = {
        vector3(-347.59, -133.35, 39.01),
    },
}

Config.GangMenus = {
    lostmc = {
        vector3(-19, 6479.59, 31.49),
    },
    ballas = {
        vector3(83.35, -1959.71, 20.75),
    },
    vagos = {
        vector3(432.94, -1885.33, 31.74),
    },
    cartel = {
        vector3(0, 0, 0),
    },
    families = {
        vector3(-151.86, -1637.1, 36.85),
    },
}
