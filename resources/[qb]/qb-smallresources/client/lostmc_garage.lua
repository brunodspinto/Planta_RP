local QBCore = exports['qb-core']:GetCoreObject()

-- --- CONFIGURAÇÃO ---
-- Coordenada onde aparece o marcador no chão (onde clicas E)
-- CONFIRMA SE ESTAS COORDENADAS ESTÃO CERTAS (não podem ser 0,0,0)
local CoordMenu = vector3(-8.17, 6477.55, 30.97) 

-- Coordenada onde a mota nasce
local SpawnVeiculo = vector4(-8.17, 6477.55, 30.97, 144.36) 

-- --- CÓDIGO DO MENU ---

RegisterNetEvent('planta:client:MenuLostMC', function()
    local menu = {
        {
            header = "Garagem Lost MC",
            isMenuHeader = true,
            icon = "fa-solid fa-motorcycle"
        },
        {
            header = "Harley Davidson",
            txt = "Mota Oficial",
            icon = "fa-solid fa-bicycle",
            params = {
                event = "planta:client:SpawnarMota",
                args = {
                    model = "hexer" -- NOME DE SPAWN DA MOTA
                }
            }
        },
        {
            header = "Carrinha Burrito",
            txt = "Transporte",
            icon = "fa-solid fa-van-shuttle",
            params = {
                event = "planta:client:SpawnarMota",
                args = {
                    model = "gburrito"
                }
            }
        },
        {
            header = "Guardar Veículo",
            txt = "Apagar o veículo atual",
            icon = "fa-solid fa-trash",
            params = {
                event = "planta:client:ApagarVeiculo",
            }
        },
    }
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('planta:client:SpawnarMota', function(data)
    local vehicle = data.model
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "LOST"..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, SpawnVeiculo, true)
end)

RegisterNetEvent('planta:client:ApagarVeiculo', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, true)
    if vehicle ~= 0 then
        QBCore.Functions.DeleteVehicle(vehicle)
        QBCore.Functions.Notify("Veículo guardado!", "success")
    else
        QBCore.Functions.Notify("Não há veículo para guardar.", "error")
    end
end)

-- --- A CORREÇÃO ESTÁ AQUI EM BAIXO ---
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = #(pos - CoordMenu)
        
        -- AGORA VERIFICA A GANG E NÃO O JOB
        local PlayerData = QBCore.Functions.GetPlayerData()
        
        if dist < 10.0 and PlayerData.gang.name == "lostmc" then
            sleep = 0
            DrawMarker(2, CoordMenu.x, CoordMenu.y, CoordMenu.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 0, 0, 100, false, true, 2, false, false, false, false)

            if dist < 1.5 then
                exports['qb-core']:DrawText('[E] Garagem Lost MC', 'left')
                if IsControlJustPressed(0, 38) then
                    exports['qb-core']:HideText()
                    TriggerEvent('planta:client:MenuLostMC')
                end
            else
                exports['qb-core']:HideText()
            end
        end
        Wait(sleep)
    end
end)