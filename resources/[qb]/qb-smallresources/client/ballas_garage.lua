local QBCore = exports['qb-core']:GetCoreObject()

-- --- CONFIGURAÇÃO BALLAS ---
-- Coordenada do Marcador (Onde clicas E) - MUDA ISTO COM /vector3
local CoordMenuBallas = vector3(87.51, -1969.1, 20.75) 

-- Coordenada do Spawn (Onde o carro nasce) - MUDA ISTO COM /vector4
local SpawnVeiculoBallas = vector4(93.78, -1961.73, 20.34, 319.11) 

-- --- MENU DOS BALLAS ---
RegisterNetEvent('planta:client:MenuBallas', function()
    local menu = {
        {
            header = "Garagem Ballas",
            isMenuHeader = true,
            icon = "fa-solid fa-skull" -- Ícone diferente
        },
        {
            header = "Ballas SUV", -- Nome
            txt = "Gallivanter Baller",
            icon = "fa-solid fa-car",
            params = {
                event = "planta:client:SpawnarCarroBallas",
                args = {
                    model = "baller" -- Modelo do Jogo
                }
            }
        },
        {
            header = "Lowrider Clássico",
            txt = "Buccaneer Custom",
            icon = "fa-solid fa-car-side",
            params = {
                event = "planta:client:SpawnarCarroBallas",
                args = {
                    model = "buccaneer2"
                }
            }
        },
        {
            header = "BMX",
            txt = "Bicicleta da Hood",
            icon = "fa-solid fa-bicycle",
            params = {
                event = "planta:client:SpawnarCarroBallas",
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
                event = "planta:client:ApagarVeiculoBallas",
            }
        },
    }
    exports['qb-menu']:openMenu(menu)
end)

-- --- SPAWNAR COM COR ROXA ---
RegisterNetEvent('planta:client:SpawnarCarroBallas', function(data)
    local vehicle = data.model
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "BALLAS"..tostring(math.random(10, 99)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        
        -- O SEGREDO: Pintar de Roxo (Cor 145)
        SetVehicleColours(veh, 145, 145) 
    end, SpawnVeiculoBallas, true)
end)

-- --- APAGAR VEÍCULO ---
RegisterNetEvent('planta:client:ApagarVeiculoBallas', function()
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
        local dist = #(pos - CoordMenuBallas)
        
        local PlayerData = QBCore.Functions.GetPlayerData()
        
        -- Verifica se é BALLAS
        if dist < 10.0 and PlayerData.gang.name == "ballas" then
            sleep = 0
            -- Marcador Roxo (R=145, G=0, B=255)
            DrawMarker(2, CoordMenuBallas.x, CoordMenuBallas.y, CoordMenuBallas.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 145, 0, 255, 100, false, true, 2, false, false, false, false)

            if dist < 1.5 then
                exports['qb-core']:DrawText('[E] Garagem Ballas', 'left')
                if IsControlJustPressed(0, 38) then
                    exports['qb-core']:HideText()
                    TriggerEvent('planta:client:MenuBallas')
                end
            else
                exports['qb-core']:HideText()
            end
        end
        Wait(sleep)
    end
end)