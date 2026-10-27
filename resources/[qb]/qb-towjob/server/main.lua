local QBCore = exports['qb-core']:GetCoreObject()
local PaymentTax = 15
local Bail = {}

-- O número de entregas é contado aqui e não no cliente.
-- Tows[citizenid] = { netId, hookedAt, hookCoords }: veículo NPC atrelado neste momento
-- Drops[citizenid] = entregas validadas desde o último recibo
local Tows = {}
local Drops = {}
local MaxSpeed = 45.0 -- m/s; abaixo deste tempo o reboque não pode ter sido feito a conduzir

local function GetTowSpot(vehicle, coords)
    local model = GetEntityModel(vehicle)
    for _, spot in pairs(Config.Locations['towspots']) do
        if model == joaat(spot.model) and #(coords - spot.coords) < 75.0 then
            return spot
        end
    end
end

RegisterNetEvent('qb-tow:server:DoBail', function(bool, vehInfo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if bool then
        if Player.PlayerData.money.cash >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('cash', Config.BailPrice, 'tow-paid-bail')
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.paid_with_cash', { value = Config.BailPrice }), 'success')
            TriggerClientEvent('qb-tow:client:SpawnVehicle', src, vehInfo)
        elseif Player.PlayerData.money.bank >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('bank', Config.BailPrice, 'tow-paid-bail')
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.paid_with_bank', { value = Config.BailPrice }), 'success')
            TriggerClientEvent('qb-tow:client:SpawnVehicle', src, vehInfo)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_deposit', { value = Config.BailPrice }), 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] ~= nil then
            Player.Functions.AddMoney('bank', Bail[Player.PlayerData.citizenid], 'tow-bail-paid')
            Bail[Player.PlayerData.citizenid] = nil
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.refund_to_cash', { value = Config.BailPrice }), 'success')
        end
    end
end)

RegisterNetEvent('qb-tow:server:nano', function(vehNetID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local targetVehicle = NetworkGetEntityFromNetworkId(vehNetID)
    if not Player then return end
    local playerPed = GetPlayerPed(src)
    local playerVehicle = GetVehiclePedIsIn(playerPed, true)
    local playerVehicleCoords = GetEntityCoords(playerVehicle)
    local targetVehicleCoords = GetEntityCoords(targetVehicle)
    local dist = #(playerVehicleCoords - targetVehicleCoords)
    if Player.PlayerData.job.name ~= 'tow' or dist > 11.0 then
        return DropPlayer(src, Lang:t('info.skick'))
    end
    -- Só conta um veículo de uma das towspots, atrelado perto de onde nasceu.
    -- Voltar a atrelar o mesmo veículo não dá outra recompensa.
    local citizenid = Player.PlayerData.citizenid
    if not DoesEntityExist(targetVehicle) or not GetTowSpot(targetVehicle, targetVehicleCoords) then return end
    if Tows[citizenid] and Tows[citizenid].netId == vehNetID then return end
    Tows[citizenid] = { netId = vehNetID, hookedAt = os.time(), hookCoords = targetVehicleCoords }
    local chance = math.random(1, 100)
    if chance < 26 then
        exports['qb-inventory']:AddItem(src, 'cryptostick', 1, false, false, 'qb-tow:server:nano')
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items['cryptostick'], 'add')
    end
end)

RegisterNetEvent('qb-tow:server:DeliverVehicle', function(vehNetID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.job.name ~= 'tow' then return end
    local citizenid = Player.PlayerData.citizenid
    local tow = Tows[citizenid]
    if not tow or tow.netId ~= vehNetID then return end
    local dropoff = Config.Locations['dropoff'].coords
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    -- O veículo é largado 15 m atrás do reboque, o reboque pode estar a 25 m do ponto
    -- e o /tow não obriga o jogador a estar junto do reboque: margem larga
    if #(playerCoords - dropoff) > 75.0 then return end
    if os.time() - tow.hookedAt < #(tow.hookCoords - dropoff) / MaxSpeed then return end
    Tows[citizenid] = nil
    Drops[citizenid] = (Drops[citizenid] or 0) + 1
    -- O cliente também o apaga; aqui garante-se que o mesmo veículo não volta a ser entregue
    local vehicle = NetworkGetEntityFromNetworkId(vehNetID)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then DeleteEntity(vehicle) end
end)

RegisterNetEvent('qb-tow:server:11101110', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    if Player.PlayerData.job.name ~= 'tow' or #(playerCoords - vector3(Config.Locations['main'].coords.x, Config.Locations['main'].coords.y, Config.Locations['main'].coords.z)) > 6.0 then
        return DropPlayer(src, Lang:t('info.skick'))
    end
    local citizenid = Player.PlayerData.citizenid
    local drops = Drops[citizenid] or 0
    Drops[citizenid] = nil
    if drops == 0 then
        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_work_done'), 'error')
    end
    local bonus = 0
    local DropPrice = math.random(150, 170)
    if drops > 20 then
        bonus = math.ceil((DropPrice / 10) * 12)
    elseif drops > 15 then
        bonus = math.ceil((DropPrice / 10) * 10)
    elseif drops > 10 then
        bonus = math.ceil((DropPrice / 10) * 7)
    elseif drops > 5 then
        bonus = math.ceil((DropPrice / 10) * 5)
    end
    local price = (DropPrice * drops) + bonus
    local taxAmount = math.ceil((price / 100) * PaymentTax)
    local payment = price - taxAmount
    Player.Functions.AddMoney('bank', payment, 'tow-salary')
    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.you_earned', { value = payment }), 'success')
end)

QBCore.Commands.Add('npc', Lang:t('info.toggle_npc'), {}, false, function(source)
    TriggerClientEvent('jobs:client:ToggleNpc', source)
end)

QBCore.Commands.Add('tow', Lang:t('info.tow'), {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == 'tow' or Player.PlayerData.job.name == 'mechanic' then
        TriggerClientEvent('qb-tow:client:TowVehicle', source)
    end
end)
