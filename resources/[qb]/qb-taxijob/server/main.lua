local QBCore = exports['qb-core']:GetCoreObject()

-- Viagens NPC em curso, por citizenid: { start = vector3, deliver = índice, startedAt = os.time() }
local Rides = {}
local RouteFactor = 1.75 -- o taxímetro conta a rota do GPS, que é mais longa do que a linha reta
local MaxSpeed = 45.0    -- m/s; abaixo deste tempo a viagem não pode ter sido feita a conduzir

local function IsNear(coords, list, maxDist)
    for _, v in pairs(list) do
        local pos = v.coord or v
        if #(coords - vector3(pos.x, pos.y, pos.z)) < maxDist then
            return true
        end
    end
    return false
end

local function NearDelivery(coords, index)
    local targets = { Config.NPCLocations.DeliverLocations[index] }
    if Config.PZLocations and Config.PZLocations.DropLocations and Config.PZLocations.DropLocations[index] then
        targets[#targets + 1] = Config.PZLocations.DropLocations[index]
    end
    return IsNear(coords, targets, 25.0)
end

RegisterNetEvent('qb-taxi:server:NpcPickup', function(deliverIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.job.name ~= Config.jobRequired then return end
    if type(deliverIndex) ~= 'number' or not Config.NPCLocations.DeliverLocations[deliverIndex] then return end
    local coords = GetEntityCoords(GetPlayerPed(src))
    if not IsNear(coords, Config.NPCLocations.TakeLocations, 30.0) then return end
    Rides[Player.PlayerData.citizenid] = { start = coords, deliver = deliverIndex, startedAt = os.time() }
end)

RegisterNetEvent('qb-taxi:server:NpcPay', function(payment, hasReceivedBonus)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.name ~= Config.jobRequired then
        return DropPlayer(src, 'Tentativa de exploração de falhas')
    end

    -- Só se paga uma viagem que o servidor viu começar, e só uma vez
    local citizenid = Player.PlayerData.citizenid
    local ride = Rides[citizenid]
    Rides[citizenid] = nil
    if not ride then return end

    local coords = GetEntityCoords(GetPlayerPed(src))
    if not NearDelivery(coords, ride.deliver) then
        return DropPlayer(src, 'Tentativa de exploração de falhas')
    end

    local distance = #(coords - ride.start)
    if os.time() - ride.startedAt < distance / MaxSpeed then return end

    -- O valor do taxímetro vem do cliente; aceita-se até ao máximo que esta viagem podia custar
    local maxFare = math.floor((distance * RouteFactor / 1609) * Config.Meter['defaultPrice'] + Config.Meter['startingPrice'])
    payment = tonumber(payment) or 0
    if payment ~= payment or payment < 0 then payment = 0 end
    payment = math.min(math.floor(payment), maxFare)

    local randomAmount = math.random(1, 5)
    local r1, r2 = math.random(1, 5), math.random(1, 5)
    if randomAmount == r1 or randomAmount == r2 then payment = payment + math.random(10, 20) end

    if Config.Advanced.Bonus.Enabled then
        if hasReceivedBonus == true then
            local tipAmount = math.floor(payment * Config.Advanced.Bonus.Percentage / 100)
            payment += tipAmount
            TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t('info.tip_received'), tipAmount), 'primary', 5000)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('info.tip_not_received'), 'primary', 5000)
        end
    end

    if Config.Management then
        exports['qb-banking']:AddMoney('taxi', payment, 'Customer payment')
    else
        Player.Functions.AddMoney('cash', payment, 'Taxi payout')
    end

    local chance = math.random(1, 100)
    if chance < 26 then
        exports['qb-inventory']:AddItem(src, Config.Rewards, 1, false, false, 'qb-taxi:server:NpcPay')
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Rewards], 'add')
    end
end)
