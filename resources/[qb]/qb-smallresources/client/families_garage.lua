local QBCore = exports['qb-core']:GetCoreObject()

-- --- CONFIGURAÇÃO FAMILIES ---
-- Coordenada do Marcador (Onde clicas E)
local CoordMenuFamilies = vector3(-141.36, -1637.95, 32.4)

-- Coordenada do Spawn (Onde o carro nasce)
local SpawnVeiculoFamilies = vector4(-133.92, -1628.68, 31.89, 320.68) 

-- --- MENU DOS FAMILIES ---
RegisterNetEvent('planta:client:MenuFamilies', function()
    local menu = {
        {
            header = "Garagem Families",
            isMenuHeader = true,
            icon = "fa-solid fa-leaf" -- Ícone de folha (Verde)
        },
        {
            header = "Lowrider Faction",
            txt = "Willard Faction",
            icon = "fa-solid fa-car",
            params = {
                event = "planta:client:SpawnarCarroFamilies",
                args = {
                    model = "faction" -- Lowrider clássico
                }
            }
        },
        {
            header = "O Carro do Sweet",
            txt = "Greenwood (Se tiveres mod) ou Virgo",
            icon = "fa-solid fa-car-side",
            params = {
                event = "planta:client:SpawnarCarroFamilies",
                args = {
                    model = "virgo" -- O Virgo é muito parecido com o clássico
                }
            }
        },
        {
            header = "BMX",
            txt = "Bicicleta da Hood",
            icon = "fa-solid fa-bicycle",
            params = {
                event = "planta:client:SpawnarCarroFamilies",
                args = {
                    model = "bmx"
                }
            }
        },
        {
            header = "Guardar Veículo",
            txt = "Apagar o veículo atual",
            icon = "fa-solid fa-trash",
            params = {
                event = "planta:client:ApagarVeiculoFamilies",
            }
        },
    }
    exports['qb-menu']:openMenu(menu)
end)

-- --- SPAWNAR COM COR VERDE ---
RegisterNetEvent('planta:client:SpawnarCarroFamilies', function(data)
    local vehicle = data.model
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "GROVE"..tostring(math.random(10, 99)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        
        -- PINTURA: Verde Clássico (Cor 53)
        SetVehicleColours(veh, 53, 53) 
        -- Extra: Brilho perolado (Cor 112 - Branco Gelo ou Verde mais claro)
        SetVehicleExtraColours(veh, 112, 53)
    end, SpawnVeiculoFamilies, true)
end)

-- --- APAGAR VEÍCULO ---
RegisterNetEvent('planta:client:ApagarVeiculoFamilies', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, true)
    if vehicle ~= 0 then
        QBCore.Functions.DeleteVehicle(vehicle)
        QBCore.Functions.Notify("Veículo guardado!", "success")
    else
        QBCore.Functions.Notify("Não há veículo para guardar.", "error")
    end
end)

-- --- LÓGICA DO MARCADOR ---
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - CoordMenuFamilies)
        
        local PlayerData = QBCore.Functions.GetPlayerData()
        
        -- Verifica se é FAMILIES
        if dist < 10.0 and PlayerData.gang.name == "families" then
            sleep = 0
            -- Marcador Verde (R=0, G=255, B=0)
            DrawMarker(2, CoordMenuFamilies.x, CoordMenuFamilies.y, CoordMenuFamilies.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 0, 255, 0, 100, false, true, 2, false, false, false, false)

            if dist < 1.5 then
                exports['qb-core']:DrawText('[E] Garagem Families', 'left')
                if IsControlJustPressed(0, 38) then
                    exports['qb-core']:HideText()
                    TriggerEvent('planta:client:MenuFamilies')
                end
            else
                exports['qb-core']:HideText()
            end
        end
        Wait(sleep)
    end
end)