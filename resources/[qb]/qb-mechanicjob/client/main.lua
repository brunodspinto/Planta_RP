PlayerData = {}

-- Handlers (Inicialização)

AddEventHandler('OnResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    PlayerData = QBCore.Functions.GetPlayerData()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

-- Global Functions (Funções Auxiliares)

function Trim(plate)
    return (string.gsub(plate, '^%s*(.-)%s*$', '%1'))
end

function ToggleHood(vehicle)
    if GetVehicleDoorAngleRatio(vehicle, 4) > 0.0 then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorOpen(vehicle, 4, false, false)
    end
end

function IsNearBone(vehicle, bone)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local vehicleBoneIndex = GetEntityBoneIndexByName(vehicle, bone)
    if vehicleBoneIndex ~= -1 then
        local bonePos = GetWorldPositionOfEntityBone(vehicle, vehicleBoneIndex)
        if #(playerCoords - bonePos) <= 1.5 then
            return true
        end
    end
    return false
end

function GetClosestWheel(vehicle)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestWheelIndex
    for wheelIndex, wheelBone in pairs(Config.WheelBones) do
        local wheelBoneIndex = GetEntityBoneIndexByName(vehicle, wheelBone)
        if wheelBoneIndex ~= -1 then
            local wheelPos = GetWorldPositionOfEntityBone(vehicle, wheelBoneIndex)
            if #(playerCoords - wheelPos) <= 1.5 then
                closestWheelIndex = wheelIndex
                break
            end
        end
    end
    return closestWheelIndex
end

-- Local Functions (Garagens)

local function SpawnListVehicle(model, spawnPoint)
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        SetVehicleNumberPlateText(veh, 'MEC' .. tostring(math.random(1000, 9999))) -- Mudei para MEC (Mecânico)
        SetEntityHeading(veh, spawnPoint.w)
        exports[Config.FuelResource]:SetFuel(veh, 100.0)
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true, false)
    end, model, spawnPoint, true)
end

local function VehicleList(shop)
    local vehicleMenu = { { header = 'Veículos de Serviço', isMenuHeader = true } }
    local list = Config.Shops[shop].vehicles.list
    for i = 1, #list do
        local v = list[i]
        vehicleMenu[#vehicleMenu + 1] = {
            header = QBCore.Shared.Vehicles[v].name,
            params = {
                event = 'qb-mechanicjob:client:SpawnListVehicle',
                args = {
                    spawnName = v,
                    location = Config.Shops[shop].vehicles.spawn
                }
            }
        }
    end
    vehicleMenu[#vehicleMenu + 1] = {
        header = 'Fechar Menu',
        txt = '',
        params = {
            event = 'qb-menu:client:closeMenu'
        }

    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

-- Events

RegisterNetEvent('qb-mechanicjob:client:SpawnListVehicle', function(data)
    local vehicleSpawnName = data.spawnName
    local spawnPoint = data.location
    SpawnListVehicle(vehicleSpawnName, spawnPoint)
end)

-- Main Thread (Criação das Zonas e Blips)

CreateThread(function()
    -- Loop pelas oficinas (Agora vai ler 'bennys' e 'tuners')
    for k, v in pairs(Config.Shops) do
        
        -- 1. Criação do Blip no Mapa
        if v.showBlip then
            local blip = AddBlipForCoord(v.blipCoords)
            SetBlipSprite(blip, v.blipSprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.6)
            SetBlipColour(blip, v.blipColor)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.shopLabel)
            EndTextCommandSetBlipName(blip)
        end

        -- 2. Zona de Entrar em Serviço (Duty)
        exports['qb-target']:AddCircleZone(k .. '_duty', v.duty, 0.5, {
            name = k .. '_duty',
            debugPoly = false,
            useZ = true
        }, {
            options = { {
                type = 'server',
                event = 'QBCore:ToggleDuty',
                label = 'Entrar/Sair de Serviço',
                icon = 'fas fa-user-clock',
                job = v.managed and k or nil -- Verifica se é bennys ou tuners
            } },
            distance = 2.0
        })

        -- 3. Zona do Baú (Stash)
        exports['qb-target']:AddCircleZone(k .. '_stash', v.stash, 0.5, {
            name = k .. '_stash',
            debugPoly = false,
            useZ = true
        }, {
            options = { {
                label = 'Abrir Baú da Oficina',
                icon = 'fas fa-box-open',
                job = v.managed and k or nil,
                type = 'server',
                event = 'qb-mechanicjob:server:stash',
            } },
            distance = 2.0
        })

        -- 4. Cabine de Pintura (Paintbooth)
        exports['qb-target']:AddCircleZone(k .. '_paintbooth', v.paint, 0.5, {
            name = k .. '_paintbooth',
            debugPoly = false,
            useZ = true
        }, {
            options = { {
                label = 'Cabine de Pintura',
                icon = 'fas fa-fill-drip',
                job = v.managed and k or nil,
                action = function()
                    PaintCategories()
                end
            } },
            distance = 2.0
        })

        -- 5. Garagem (Spawner)
        exports['qb-target']:AddCircleZone(k .. '_spawner', v.vehicles.withdraw, 0.5, {
            name = k .. '_spawner',
            debugPoly = false,
            useZ = true
        }, {
            options = {
                {
                    label = 'Retirar Veículo',
                    icon = 'fas fa-car',
                    job = v.managed and k or nil,
                    canInteract = function()
                        local inVehicle = GetVehiclePedIsUsing(PlayerPedId())
                        if inVehicle ~= 0 then return false end
                        return true
                    end,
                    action = function()
                        VehicleList(k)
                    end
                },
                {
                    label = 'Guardar Veículo',
                    icon = 'fas fa-car',
                    job = k,
                    canInteract = function()
                        local inVehicle = GetVehiclePedIsUsing(PlayerPedId())
                        if inVehicle == 0 then return false end
                        return true
                    end,
                    action = function()
                        SetEntityAsMissionEntity(GetVehiclePedIsUsing(PlayerPedId()), true, true)
                        DeleteVehicle(GetVehiclePedIsUsing(PlayerPedId()))
                    end
                }
            },
            distance = 5.0
        })
    end
end)