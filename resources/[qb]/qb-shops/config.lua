Config = {}
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

-- Entregas
Config.ShopsInvJsonFile = './json/shops-inventory.json'
Config.TruckDeposit = 400
Config.MaxDeliveries = 20
Config.DeliveryPrice = 700
Config.RewardItem = 'cryptostick'
Config.Fuel = 'LegacyFuel'

Config.DeliveryLocations = {
    ['main'] = { label = 'GO Postal (CTT)', coords = vector4(69.0862, 127.6753, 79.2123, 156.7736) },
    ['vehicleWithdraw'] = vector4(71.9318, 120.8389, 79.0823, 160.5110),
    ['vehicleDeposit'] = vector3(62.7282, 124.9846, 79.0926),
    ['stores'] = {} -- gerado automaticamente
}

Config.Vehicles = {
    ['boxville2'] = { ['label'] = 'Carrinha de Entregas', ['cargodoors'] = { [0] = 2, [1] = 3 }, ['trunkpos'] = 1.5 },
}

Config.Products = {
    ['normal'] = { -- Supermercado
        { name = 'tosti',         price = 10,  amount = 50 },
        { name = 'water_bottle',  price = 8,   amount = 50 },
        { name = 'kurkakola',     price = 10,  amount = 50 },
        { name = 'twerks_candy',  price = 9,   amount = 50 },
        { name = 'snikkel_candy', price = 9,   amount = 50 },
        { name = 'sandwich',      price = 14,  amount = 50 },
        { name = 'beer',          price = 22,  amount = 50 },
        { name = 'whiskey',       price = 45,  amount = 50 },
        { name = 'vodka',         price = 52,  amount = 50 },
        { name = 'bandage',       price = 180, amount = 50 },
        { name = 'lighter',       price = 15,  amount = 50 },
        { name = 'rolling_paper', price = 12,  amount = 5000 },
    },
    ['liquor'] = { -- Bebidas
        { name = 'beer',    price = 22, amount = 50 },
        { name = 'whiskey', price = 45, amount = 50 },
        { name = 'vodka',   price = 52, amount = 50 },
    },
    ['hardware'] = { -- Ferramentas
        { name = 'lockpick',          price = 550, amount = 50 },
        { name = 'weapon_wrench',     price = 450, amount = 250 },
        { name = 'weapon_hammer',     price = 380, amount = 250 },
        { name = 'repairkit',         price = 750, amount = 50, requiredJob = { 'mechanic', 'police', 'bennys', 'tuners' } },
        { name = 'screwdriverset',    price = 650, amount = 50 },
        { name = 'phone',             price = 2500, amount = 50 },
        { name = 'radio',             price = 850, amount = 50 },
        { name = 'binoculars',        price = 180, amount = 50 },
        { name = 'firework1',         price = 50,  amount = 50 },
        { name = 'firework2',         price = 50,  amount = 50 },
        { name = 'firework3',         price = 50,  amount = 50 },
        { name = 'firework4',         price = 50,  amount = 50 },
        { name = 'fitbit',            price = 950, amount = 150 },
        { name = 'cleaningkit',       price = 380, amount = 150 },
        { name = 'advancedrepairkit', price = 1400, amount = 50, requiredJob = { 'mechanic', 'bennys', 'tuners' } },
    },
    ['weedshop'] = { -- Dispensário
        { name = 'joint',          price = 45,  amount = 50 },
        { name = 'weapon_poolcue', price = 450, amount = 50 },
        { name = 'weed_nutrition', price = 80,  amount = 50 },
        { name = 'empty_weed_bag', price = 18,  amount = 1000 },
        { name = 'rolling_paper',  price = 12,  amount = 1000 },
    },
    ['gearshop'] = { -- Mergulho
        { name = 'diving_gear', price = 4500, amount = 10 },
        { name = 'jerry_can',   price = 500,  amount = 50 },
    },
    ['leisureshop'] = { -- Lazer
        { name = 'parachute',   price = 5000, amount = 10 },
        { name = 'binoculars',  price = 180,  amount = 50 },
        { name = 'diving_gear', price = 4500, amount = 10 },
        { name = 'diving_fill', price = 1000, amount = 10 },
    },
    ['weapons'] = { -- Armeiro
        { name = 'weapon_knife',         price = 900,  amount = 250 },
        { name = 'weapon_bat',           price = 800,  amount = 250 },
        { name = 'weapon_hatchet',       price = 950,  amount = 250 },
        { name = 'pistol_ammo',          price = 950,  amount = 250, requiredLicense = 'weapon' },
        { name = 'weapon_pistol',        price = 18000, amount = 5,  requiredLicense = 'weapon' },
        { name = 'weapon_snspistol',     price = 14000, amount = 5,  requiredLicense = 'weapon' },
        { name = 'weapon_vintagepistol', price = 24000, amount = 5,  requiredLicense = 'weapon' },
    },
    ['blackmarket'] = { -- Mercado Negro
        { name = 'security_card_01',  price = 18000, amount = 50 },
        { name = 'security_card_02',  price = 23000, amount = 50 },
        { name = 'advancedlockpick', price = 7500,  amount = 50 },
        { name = 'electronickit',     price = 14000, amount = 50 },
        { name = 'gatecrack',         price = 16000, amount = 50 },
        { name = 'thermite',          price = 17500, amount = 50 },
        { name = 'trojan_usb',        price = 22000, amount = 50 },
        { name = 'drill',             price = 12000, amount = 50 },
        { name = 'radioscanner',      price = 8500,  amount = 50 },
        { name = 'cryptostick',       price = 9000,  amount = 50 },
        { name = 'joint',             price = 65,    amount = 50 },
        { name = 'cokebaggy',         price = 550,   amount = 50 },
        { name = 'crack_baggy',       price = 500,   amount = 50 },
        { name = 'xtcbaggy',          price = 450,   amount = 50 },
        { name = 'coke_brick',        price = 16000, amount = 50 },
        { name = 'weed_brick',        price = 7000,  amount = 50 },
        { name = 'coke_small_brick',  price = 9000,  amount = 50 },
        { name = 'oxy',               price = 650,   amount = 50 },
        { name = 'meth',              price = 700,   amount = 50 },
        { name = 'weed_whitewidow',   price = 140,   amount = 50 },
        { name = 'weed_skunk',        price = 150,   amount = 50 },
        { name = 'weed_purplehaze',   price = 170,   amount = 50 },
        { name = 'weed_ogkush',       price = 160,   amount = 50 },
        { name = 'weed_amnesia',      price = 175,   amount = 50 },
        { name = 'weed_ak47',         price = 190,   amount = 50 },
        { name = 'markedbills',       price = 6500,  amount = 50, info = { worth = 5000 } },
    },
    ['prison'] = { -- Prisão
        { name = 'sandwich',     price = 10, amount = 50 },
        { name = 'water_bottle', price = 8,  amount = 50 },
    },
    ['police'] = { -- Polícia
        { name = 'weapon_pistol',       price = 0, amount = 50, info = { attachments = { { component = 'COMPONENT_AT_PI_FLSH', label = 'Lanterna' } } } },
        { name = 'weapon_stungun',      price = 0, amount = 50, info = { attachments = { { component = 'COMPONENT_AT_AR_FLSH', label = 'Lanterna' } } } },
        { name = 'weapon_pumpshotgun',  price = 0, amount = 50, info = { attachments = { { component = 'COMPONENT_AT_AR_FLSH', label = 'Lanterna' } } } },
        { name = 'weapon_smg',          price = 0, amount = 50, info = { attachments = { { component = 'COMPONENT_AT_SCOPE_MACRO_02', label = 'Mira 1x' }, { component = 'COMPONENT_AT_AR_FLSH', label = 'Lanterna' } } } },
        { name = 'weapon_carbinerifle', price = 0, amount = 50, info = { attachments = { { component = 'COMPONENT_AT_AR_FLSH', label = 'Lanterna' }, { component = 'COMPONENT_AT_SCOPE_MEDIUM', label = 'Mira 3x' } } } },
        { name = 'weapon_nightstick',   price = 0, amount = 50 },
        { name = 'weapon_flashlight',   price = 0, amount = 50 },
        { name = 'pistol_ammo',         price = 0, amount = 50 },
        { name = 'smg_ammo',            price = 0, amount = 50 },
        { name = 'shotgun_ammo',        price = 0, amount = 50 },
        { name = 'rifle_ammo',          price = 0, amount = 50 },
        { name = 'handcuffs',           price = 0, amount = 50 },
        { name = 'empty_evidence_bag',  price = 0, amount = 50 },
        { name = 'police_stormram',     price = 0, amount = 50 },
        { name = 'armor',               price = 0, amount = 50 },
        { name = 'radio',               price = 0, amount = 50 },
        { name = 'heavyarmor',          price = 0, amount = 50 },
    },
    ['ambulance'] = { -- INEM
        { name = 'radio',                 price = 0, amount = 50 },
        { name = 'bandage',               price = 0, amount = 50 },
        { name = 'painkillers',           price = 0, amount = 50 },
        { name = 'firstaid',              price = 0, amount = 50 },
        { name = 'weapon_flashlight',     price = 0, amount = 50 },
        { name = 'weapon_fireextinguisher', price = 0, amount = 50 },
    },
    
    -- === CONFIGURAÇÃO DOS MECÂNICOS (SEPARADO) === --
    
    -- Produtos Benny's (LEGAL: Só Estética e Manutenção)
    ['bennys_products'] = {
        { name = 'veh_toolbox',       price = 650,  amount = 50 },
        { name = 'repairkit',         price = 750,  amount = 50 },
        { name = 'advancedrepairkit', price = 1400, amount = 50 },
        { name = 'cleaningkit',       price = 380,  amount = 50 },
        { name = 'tirerepairkit',     price = 550,  amount = 50 },
        { name = 'veh_tint',          price = 1400, amount = 50 },
        { name = 'veh_wheels',        price = 1900, amount = 50 },
        { name = 'veh_plates',        price = 1100, amount = 50 },
        { name = 'veh_neons',         price = 1200, amount = 50 },
        { name = 'veh_xenons',        price = 1400, amount = 50 },
        { name = 'veh_interior',      price = 1700, amount = 50 },
        { name = 'veh_exterior',      price = 1700, amount = 50 },
        -- Itens de Segurança Permitidos
        { name = 'veh_brakes',        price = 2100, amount = 50 },
        { name = 'veh_suspension',    price = 1900, amount = 50 },
        { name = 'veh_armor',         price = 3600, amount = 50 },
    },

    -- Produtos Tuners (ILEGAL: Performance e Modificações)
    ['tuners_products'] = {
        -- O Básico
        { name = 'repairkit',         price = 750,  amount = 50 },
        { name = 'advancedrepairkit', price = 1400, amount = 50 },
        { name = 'cleaningkit',       price = 380,  amount = 50 },
        
        -- A Carne (Performance)
        { name = 'tunerlaptop',       price = 12000, amount = 5 },  -- O Portátil!
        { name = 'nitrous',           price = 5500,  amount = 20 }, -- Nitro
        { name = 'veh_turbo',         price = 8200,  amount = 20 },
        { name = 'veh_engine',        price = 6800,  amount = 20 },
        { name = 'veh_transmission',  price = 5200,  amount = 20 },
        
        -- Luzes (ADICIONADO)
        { name = 'veh_neons',         price = 1200, amount = 50 },
        { name = 'veh_xenons',        price = 1400, amount = 50 },

        -- Extras
        { name = 'veh_wheels',        price = 1900, amount = 50 },
        { name = 'veh_brakes',        price = 2100, amount = 50 },
        { name = 'veh_suspension',    price = 1900, amount = 50 },
        { name = 'veh_armor',         price = 3600, amount = 50 },
    }
}

Config.Locations = {
    -- Supermercados 24/7
    ['247supermarket'] = {
        ['label'] = 'Supermercado 24/7',
        ['coords'] = vector4(24.47, -1346.62, 29.5, 271.66),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(26.45, -1315.51, 29.62, 0.07),
        ['useStock'] = true
    },

    ['247supermarket2'] = {
        ['label'] = 'Supermercado 24/7',
        ['coords'] = vector4(-3039.54, 584.38, 7.91, 17.27),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-3047.95, 590.71, 7.62, 19.53)
    },

    ['247supermarket3'] = {
        ['label'] = 'Supermercado 24/7',
        ['coords'] = vector4(-3242.97, 1000.01, 12.83, 357.57),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-3245.76, 1005.25, 12.83, 269.45)
    },

    ['247supermarket4'] = {
        ['label'] = 'Supermercado 24/7',
        ['coords'] = vector4(1728.07, 6415.63, 35.04, 242.95),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1741.76, 6419.61, 35.04, 6.83)
    },

    ['247supermarket5'] = {
        ['label'] = 'Supermercado 24/7',
        ['coords'] = vector4(1959.82, 3740.48, 32.34, 301.57),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1963.81, 3750.09, 32.26, 302.46)
    },

    ['247supermarket6'] = {
        ['label'] = 'Supermercado 24/7',
        ['coords'] = vector4(549.13, 2670.85, 42.16, 99.39),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(541.54, 2663.53, 42.17, 120.51)
    },

    ['247supermarket7'] = {
        ['label'] = 'Supermercado 24/7',
        ['coords'] = vector4(2677.47, 3279.76, 55.24, 335.08),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(2662.19, 3264.95, 55.24, 168.55)
    },

    ['247supermarket8'] = {
        ['label'] = 'Supermercado 24/7',
        ['coords'] = vector4(2556.66, 380.84, 108.62, 356.67),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(2553.24, 399.73, 108.56, 344.86)
    },

    ['247supermarket9'] = {
        ['label'] = 'Supermercado 24/7',
        ['coords'] = vector4(372.66, 326.98, 103.57, 253.73),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(379.97, 357.3, 102.56, 26.42)
    },

    -- Bombas LTD
    ['ltdgasoline'] = {
        ['label'] = 'Bombas LTD',
        ['coords'] = vector4(-47.02, -1758.23, 29.42, 45.05),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-40.51, -1747.45, 29.29, 326.39)
    },

    ['ltdgasoline2'] = {
        ['label'] = 'Bombas LTD',
        ['coords'] = vector4(-706.06, -913.97, 19.22, 88.04),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-702.89, -917.44, 19.21, 181.96)
    },

    ['ltdgasoline3'] = {
        ['label'] = 'Bombas LTD',
        ['coords'] = vector4(-1820.02, 794.03, 138.09, 135.45),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1829.29, 801.49, 138.41, 41.39)
    },

    ['ltdgasoline4'] = {
        ['label'] = 'Bombas LTD',
        ['coords'] = vector4(1164.71, -322.94, 69.21, 101.72),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1160.62, -312.06, 69.28, 3.77)
    },

    ['ltdgasoline5'] = {
        ['label'] = 'Bombas LTD',
        ['coords'] = vector4(1697.87, 4922.96, 42.06, 324.71),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['normal'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1702.68, 4917.28, 42.22, 139.27)
    },

    -- Garrafeiras (Rob's Liquor)
    ['robsliquor'] = {
        ['label'] = 'Garrafeira do Rob',
        ['coords'] = vector4(-1221.58, -908.15, 12.33, 35.49),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['liquor'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1226.92, -901.82, 12.28, 213.26)
    },

    ['robsliquor2'] = {
        ['label'] = 'Garrafeira do Rob',
        ['coords'] = vector4(-1486.59, -377.68, 40.16, 139.51),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['liquor'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1468.29, -387.61, 38.79, 220.13)
    },

    ['robsliquor3'] = {
        ['label'] = 'Garrafeira do Rob',
        ['coords'] = vector4(-2966.39, 391.42, 15.04, 87.48),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['liquor'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-2961.49, 376.25, 15.02, 111.41)
    },

    ['robsliquor4'] = {
        ['label'] = 'Garrafeira do Rob',
        ['coords'] = vector4(1165.17, 2710.88, 38.16, 179.43),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['liquor'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1194.52, 2722.21, 38.62, 9.37)
    },

    ['robsliquor5'] = {
        ['label'] = 'Garrafeira do Rob',
        ['coords'] = vector4(1134.2, -982.91, 46.42, 277.24),
        ['ped'] = 'mp_m_shopkeep_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-shopping-basket',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['liquor'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1129.73, -989.27, 45.97, 280.98)
    },

    -- Lojas de Ferramentas
    ['hardware'] = {
        ['label'] = 'Loja de Ferramentas',
        ['coords'] = vector4(45.68, -1749.04, 29.61, 53.13),
        ['ped'] = 'mp_m_waremech_01',
        ['scenario'] = 'WORLD_HUMAN_CLIPBOARD',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-wrench',
        ['targetLabel'] = 'Abrir Loja de Ferramentas',
        ['products'] = Config.Products['hardware'],
        ['showblip'] = true,
        ['blipsprite'] = 402,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(89.15, -1745.29, 30.09, 315.25)
    },

    ['hardware2'] = {
        ['label'] = 'Loja de Ferramentas',
        ['coords'] = vector4(2747.71, 3472.85, 55.67, 255.08),
        ['ped'] = 'mp_m_waremech_01',
        ['scenario'] = 'WORLD_HUMAN_CLIPBOARD',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-wrench',
        ['targetLabel'] = 'Abrir Loja de Ferramentas',
        ['products'] = Config.Products['hardware'],
        ['showblip'] = true,
        ['blipsprite'] = 402,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(2704.68, 3457.21, 55.54, 176.28)
    },

    ['hardware3'] = {
        ['label'] = 'Loja de Ferramentas',
        ['coords'] = vector4(-421.83, 6136.13, 31.88, 228.2),
        ['ped'] = 'mp_m_waremech_01',
        ['scenario'] = 'WORLD_HUMAN_CLIPBOARD',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-wrench',
        ['targetLabel'] = 'Abrir Loja de Ferramentas',
        ['products'] = Config.Products['hardware'],
        ['showblip'] = true,
        ['blipsprite'] = 402,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-438.25, 6146.9, 31.48, 136.99)
    },

    -- Ammunation (Armeiros)
    ['ammunation'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(-661.96, -933.53, 21.83, 177.05),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['weapons'],
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-660.61, -938.14, 21.83, 167.22)
    },
    ['ammunation2'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(809.68, -2159.13, 29.62, 1.43),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['weapons'],
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(820.97, -2146.7, 28.71, 359.98)
    },
    ['ammunation3'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(1692.67, 3761.38, 34.71, 227.65),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['weapons'],
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1687.17, 3755.47, 34.34, 163.69)
    },
    ['ammunation4'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(-331.23, 6085.37, 31.45, 228.02),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['weapons'],
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-341.72, 6098.49, 31.32, 11.05)
    },
    ['ammunation5'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(253.63, -51.02, 69.94, 72.91),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['weapons'],
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(249.0, -50.64, 69.94, 60.71)
    },
    ['ammunation6'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(23.0, -1105.67, 29.8, 162.91),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['weapons'],
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-5.82, -1107.48, 29.0, 164.32)
    },
    ['ammunation7'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(2567.48, 292.59, 108.73, 349.68),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['weapons'],
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(2578.77, 285.53, 108.61, 277.2)
    },
    ['ammunation8'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(-1118.59, 2700.05, 18.55, 221.89),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['weapons'],
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1127.67, 2708.18, 18.8, 41.76)
    },
    ['ammunation9'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(841.92, -1035.32, 28.19, 1.56),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['weapons'],
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(847.83, -1020.36, 27.88, 88.29)
    },
    ['ammunation10'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(-1304.19, -395.12, 36.7, 75.03),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['weapons'],
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1302.44, -385.23, 36.62, 303.79)
    },
    ['ammunation11'] = {
        ['label'] = 'Ammunation',
        ['type'] = 'weapon',
        ['coords'] = vector4(-3173.31, 1088.85, 20.84, 244.18),
        ['ped'] = 's_m_y_ammucity_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['weapons'],
        ['showblip'] = true,
        ['blipsprite'] = 110,
        ['blipscale'] = 0.6,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-3183.6, 1084.35, 20.84, 68.13)
    },

    -- Weedshop
    ['weedshop'] = {
        ['label'] = 'Smoke On The Water',
        ['coords'] = vector4(-1168.26, -1573.2, 4.66, 105.24),
        ['ped'] = 'a_m_y_hippy_01',
        ['scenario'] = 'WORLD_HUMAN_AA_SMOKE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-cannabis',
        ['targetLabel'] = 'Abrir Dispensário',
        ['products'] = Config.Products['weedshop'],
        ['showblip'] = true,
        ['blipsprite'] = 140,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1162.13, -1568.57, 4.39, 328.52)
    },

    -- Sea Word
    ['seaword'] = {
        ['label'] = 'Sea Word',
        ['coords'] = vector4(-1687.03, -1072.18, 13.15, 52.93),
        ['ped'] = 'a_m_y_beach_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_IMPATIENT',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-fish',
        ['targetLabel'] = 'Loja de Mergulho',
        ['products'] = Config.Products['gearshop'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1674.18, -1073.7, 13.15, 333.56)
    },

    -- Loja de Lazer
    ['leisureshop'] = {
        ['label'] = 'Loja de Lazer',
        ['coords'] = vector4(-1505.91, 1511.95, 115.29, 257.13),
        ['ped'] = 'a_m_y_beach_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE_CLUBHOUSE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-leaf',
        ['targetLabel'] = 'Abrir Loja de Lazer',
        ['products'] = Config.Products['leisureshop'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(-1507.64, 1505.52, 115.29, 262.2)
    },

    -- Polícia
    ['police'] = {
        ['label'] = 'Armeiro da Polícia',
        ['coords'] = vector4(461.8498, -981.0677, 30.6896, 91.5892),
        ['ped'] = 'mp_m_securoguard_01',
        ['scenario'] = 'WORLD_HUMAN_COP_IDLES',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-gun',
        ['targetLabel'] = 'Abrir Armeiro',
        ['products'] = Config.Products['police'],
        ['delivery'] = vector4(459.0441, -1008.0366, 28.2627, 271.4695),
        ['requiredJob'] = 'police',
    },

    -- INEM
    ['ambulance'] = {
        ['label'] = 'Farmácia do INEM',
        ['coords'] = vector4(309.93, -602.94, 43.29, 71.0820),
        ['ped'] = 's_m_m_doctor_01',
        ['scenario'] = 'WORLD_HUMAN_STAND_MOBILE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-hand',
        ['targetLabel'] = 'Abrir Farmácia',
        ['products'] = Config.Products['ambulance'],
        ['delivery'] = vector4(283.5821, -614.8570, 43.3792, 159.2903),
        ['requiredJob'] = 'ambulance'
    },

    -- === LOJAS DE MECÂNICO CONFIGURADAS === --

    -- Loja Benny's (Legal)
    ['bennys_store'] = {
        ['label'] = 'Armazém Benny\'s',
        ['coords'] = vector4(-195.42, -1320.77, 31.09, 75.95),
        ['ped'] = 's_m_m_autoshop_01',
        ['scenario'] = 'WORLD_HUMAN_CLIPBOARD',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-wrench',
        ['targetLabel'] = 'Comprar Peças',
        ['products'] = Config.Products['bennys_products'],
        ['delivery'] = vector4(-232.5028, -1311.7202, 31.2960, 180.3716),
        ['requiredJob'] = 'bennys'
    },

    -- Loja Tuners (Ilegal)
    ['tuners_store'] = {
        ['label'] = 'Fornecedor Underground',
        ['coords'] = vector4(-45.29, -1207.31, 28.77, 30.19),
        ['ped'] = 'g_m_y_salvagoon_01',
        ['scenario'] = 'WORLD_HUMAN_LEANING',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-microchip',
        ['targetLabel'] = 'Mercado Negro',
        ['products'] = Config.Products['tuners_products'],
        ['delivery'] = vector4(-60.0, -1215.0, 30.0, 0.0),
        ['requiredJob'] = 'tuners'
    },

    -- Cantina da Prisão
    ['prison'] = {
        ['label'] = 'Cantina',
        ['coords'] = vector4(1777.59, 2560.52, 44.62, 187.83),
        ['ped'] = false,
        ['products'] = Config.Products['prison'],
        ['showblip'] = true,
        ['blipsprite'] = 52,
        ['blipscale'] = 0.8,
        ['blipcolor'] = 0,
        ['delivery'] = vector4(1845.8175, 2585.9312, 45.6721, 96.7577)
    },

    -- Mercado Negro
    ['blackmarket'] = {
        ['label'] = 'Mercado Negro',
        ['coords'] = vector4(-594.7032, -1616.3647, 33.0105, 170.6846),
        ['ped'] = 'a_m_y_smartcaspat_01',
        ['scenario'] = 'WORLD_HUMAN_AA_SMOKE',
        ['radius'] = 1.5,
        ['targetIcon'] = 'fas fa-clipboard',
        ['targetLabel'] = 'Abrir Loja',
        ['products'] = Config.Products['blackmarket'],
        ['delivery'] = vector4(-428.6385, -1728.1962, 19.7838, 75.6646)
    },
}