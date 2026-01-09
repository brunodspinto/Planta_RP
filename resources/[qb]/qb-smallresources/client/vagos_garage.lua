local QBCore = exports['qb-core']:GetCoreObject()

-- --- CONFIGURAÇÃO VAGOS ---
-- Coordenada do Marcador (Onde clicas E) - VAI AO JOGO E TIRA O /vector3
local CoordMenuVagos = vector3(454.88, -1882.73, 26.45) 

-- Coordenada do Spawn (Onde o carro nasce) - TIRA O /vector4
local SpawnVeiculoVagos = vector4(459.65, -1890.49, 25.88, 205.22) 

-- --- MENU DOS VAGOS ---
RegisterNetEvent('planta:client:MenuVagos', function()
    local menu = {
        {
            header = "Garagem Vagos",
            isMenuHeader = true,
            icon = "fa-solid fa-band-aid" -- Ícone
        },
        {
            header = "Vagos Lowrider",
            txt = "Buccaneer Custom",
            icon = "fa-solid fa-car",
            params = {
                event = "planta:client:SpawnarCarroVagos",
                args = {
                    model = "buccaneer2" -- Lowrider clássico
                }
            }
        },
        {
            header = "Clássico da Hood",
            txt = "Manana",
            icon = "fa-solid fa-car-side",
            params = {
                event = "planta:client:SpawnarCarroVagos",
                args = {
                    model = "manana"
                }
            }
        },
        {
            header = "Moto Sanchez",
            txt = "Para fugas rápidas",
            icon = "fa-solid fa-motorcycle",
            params = {
                event = "planta:client:SpawnarCarroVagos",
                args = {
                    model = "sanchez"
                }
            }
        },
        {
            header = "Guardar Veículo",
            txt = "Apagar o veículo atual",
            icon = "fa-solid fa-trash",
            params = {
                event = "planta:client:ApagarVeiculoVagos",
            }
        },
    }
    exports['qb-menu']:openMenu(menu)
end)

-- --- SPAWNAR COM COR AMARELA ---
RegisterNetEvent('planta:client:SpawnarCarroVagos', function(data)
    local vehicle = data.model
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "VAGOS"..tostring(math.random(10, 99)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        
        -- PINTURA: Amarelo (Cor 88)
        SetVehicleColours(veh, 88, 88) 
        -- Extra: Meter brilho perolado branco (Cor 111) para ficar chique
        SetVehicleExtraColours(veh, 111, 88)
    end, SpawnVeiculoVagos, true)
end)

-- --- APAGAR VEÍCULO ---
RegisterNetEvent('planta:client:ApagarVeiculoVagos', function()
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
        local dist = #(pos - CoordMenuVagos)
        
        local PlayerData = QBCore.Functions.GetPlayerData()
        
        -- Verifica se é VAGOS
        if dist < 10.0 and PlayerData.gang.name == "vagos" then
            sleep = 0
            -- Marcador Amarelo (R=255, G=255, B=0)
            DrawMarker(2, CoordMenuVagos.x, CoordMenuVagos.y, CoordMenuVagos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 0, 100, false, true, 2, false, false, false, false)

            if dist < 1.5 then
                exports['qb-core']:DrawText('[E] Garagem Vagos', 'left')
                if IsControlJustPressed(0, 38) then
                    exports['qb-core']:HideText()
                    TriggerEvent('planta:client:MenuVagos')
                end
            else
                exports['qb-core']:HideText()
            end
        end
        Wait(sleep)
    end
end)