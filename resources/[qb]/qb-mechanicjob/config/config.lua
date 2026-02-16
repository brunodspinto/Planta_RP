Config = {}
Config.RequireJob = true                       -- Precisas do emprego para usar as peças?
Config.FuelResource = 'LegacyFuel'             -- Nome do script de combustível

Config.PaintTime = 5                           -- Tempo em segundos para pintar o veículo
Config.ColorFavorites = false                  -- Adicionar cores favoritas ao menu

Config.NitrousBoost = 1.8                      -- Força do Nitro (acima de 1.0)
Config.NitrousUsage = 0.1                      -- Gasto de Nitro por frame

Config.UseDistance = true                      -- Salvar quilometragem do veículo
Config.UseDistanceDamage = true                -- Danificar motor com base na quilometragem
Config.UseWearableParts = true                 -- Peças que se desgastam (travões, embraiagem, etc.)
Config.WearablePartsChance = 1                 -- Probabilidade de desgaste ao conduzir
Config.WearablePartsDamage = math.random(1, 2) -- Quantidade de dano ao desgastar
Config.DamageThreshold = 25                    -- Percentagem mínima para começar a sentir efeitos do desgaste
Config.WarningThreshold = 50                   -- Percentagem para mostrar aviso amarelo na caixa de ferramentas

-- Dano baseado na quilometragem (Só funciona se UseDistanceDamage = true)
Config.MinimalMetersForDamage = {
    { min = 5000,  max = 10000, damage = 10 },
    { min = 15000, max = 20000, damage = 20 },
    { min = 25000, max = 30000, damage = 30 },
}

-- Peças de Desgaste (Traduzido)
Config.WearableParts = {
    radiator = { label = 'Radiador', maxValue = 100, repair = { steel = 2 } },
    axle = { label = 'Eixo', maxValue = 100, repair = { aluminum = 2 } },
    brakes = { label = 'Travões', maxValue = 100, repair = { copper = 2 } },
    clutch = { label = 'Embraiagem', maxValue = 100, repair = { copper = 2 } },
    fuel = { label = 'Depósito', maxValue = 100, repair = { plastic = 2 } },
}

-- CONFIGURAÇÃO DAS OFICINAS
Config.Shops = {
    
    -- 1. OFICINA LEGAL (Benny's Original)
    -- Focado em estética e reparações.
    bennys = {
        managed = true,
        shopLabel = 'Benny\'s Original',
        showBlip = true,
        blipSprite = 446,
        blipColor = 3,                 -- Azul (Legal)
        blipCoords = vector3(-211.73, -1325.28, 30.89),
        
        duty = vector3(-202.92, -1313.74, 31.70),
        stash = vector3(-199.58, -1314.65, 31.08),
        paint = vector3(-202.42, -1322.16, 31.29),
        
        vehicles = {
            withdraw = vector3(-203.20, -1300.95, 31.30),
            spawn = vector4(-198.54, -1297.80, 31.30, 268.64),
            list = { 'flatbed', 'towtruck', 'minivan', 'blista' }
        },
    },

    -- 2. OFICINA ILEGAL (Tuners Underground)
    -- Mapa: moreo_illegalmc
    tuners = {
        managed = true,
        shopLabel = 'Tuners Underground',
        showBlip = false,              -- Mudei para false para ser secreto (opcional)
        blipSprite = 446,
        blipColor = 1,                 -- Vermelho (Ilegal)
        
        blipCoords = vector3(-59.97, -1211.09, 30.0), 
        
        -- Zonas de Interação (AJUSTAR NO JOGO COM /coords)
        -- Coloquei tudo perto do centro, tens de separar as pontas
        duty = vector3(-49.72, -1212.91, 28.77),       -- Ponto de entrar de serviço
        stash = vector3(-45.99, -1198.38, 28.34),        -- Baú (estimado)
        paint = vector3(-62.0, -1212.0, 30.0),        -- Pintura (estimado)
        
        -- Garagem da Empresa
        vehicles = {
            withdraw = vector3(-65.0, -1215.0, 30.0), -- Onde escolhem o carro
            spawn = vector4(-70.0, -1215.0, 30.0, 90.0), -- Onde o carro nasce
            list = { 'flatbed', 'towtruck', 'sultan', 'futo', 'elegy' }
        },
    },
}