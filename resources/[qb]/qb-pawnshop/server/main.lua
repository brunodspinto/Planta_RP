local QBCore = exports['qb-core']:GetCoreObject()

-- Os preços em config.lua usam math.random, por isso cada lado sorteia os seus
-- ao carregar. Os que contam são os do servidor; o cliente recebe-os no getInv.
local PawnPrices = {}
for _, v in pairs(Config.PawnItems) do
    PawnPrices[v.item] = v.price
end

local MeltRecipes = {}
for _, v in pairs(Config.MeltingItems) do
    MeltRecipes[v.item] = v
end

-- Fundições por citizenid: { { item, amount, readyAt, rewards = { { item, amount } } } }
local Melts = {}

local function exploitBan(id, reason)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {
            GetPlayerName(id),
            QBCore.Functions.GetIdentifier(id, 'license'),
            QBCore.Functions.GetIdentifier(id, 'discord'),
            QBCore.Functions.GetIdentifier(id, 'ip'),
            reason,
            2147483647,
            'qb-pawnshop'
        })
    TriggerEvent('qb-log:server:CreateLog', 'pawnshop', 'Player Banned', 'red',
        string.format('%s was banned by %s for %s', GetPlayerName(id), 'qb-pawnshop', reason), true)
    DropPlayer(id, 'You were permanently banned by the server for: Exploiting')
end

local function distanceToPawnShop(src)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local nearest = math.huge
    for _, value in pairs(Config.PawnLocation) do
        nearest = math.min(nearest, #(playerCoords - value.coords))
    end
    return nearest
end

local function parseAmount(amount)
    amount = tonumber(amount)
    if not amount or amount ~= math.floor(amount) or amount < 1 then return end
    return amount
end

RegisterNetEvent('qb-pawnshop:server:sellPawnItems', function(itemName, itemAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if distanceToPawnShop(src) > 5 then
        exploitBan(src, 'sellPawnItems Exploiting')
        return
    end
    local price = PawnPrices[itemName]
    local amount = parseAmount(itemAmount)
    if not price or not amount then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_items'), 'error')
        return
    end
    local totalPrice = amount * price
    if exports['qb-inventory']:RemoveItem(src, itemName, amount, false, 'qb-pawnshop:server:sellPawnItems') then
        if Config.BankMoney then
            Player.Functions.AddMoney('bank', totalPrice, 'qb-pawnshop:server:sellPawnItems')
        else
            Player.Functions.AddMoney('cash', totalPrice, 'qb-pawnshop:server:sellPawnItems')
        end
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.sold', { value = amount, value2 = QBCore.Shared.Items[itemName].label, value3 = totalPrice }), 'success')
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_items'), 'error')
    end
    TriggerClientEvent('qb-pawnshop:client:openMenu', src)
end)

RegisterNetEvent('qb-pawnshop:server:meltItemRemove', function(itemName, itemAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if distanceToPawnShop(src) > 5 then return end
    local recipe = MeltRecipes[itemName]
    local amount = parseAmount(itemAmount)
    if not recipe or not amount then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_melt'), 'error')
        return
    end

    -- O cliente só acompanha uma fundição de cada vez
    local citizenid = Player.PlayerData.citizenid
    local now = os.time()
    for _, batch in ipairs(Melts[citizenid] or {}) do
        if batch.readyAt > now then
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.still_melting'), 'error')
            return
        end
    end

    if exports['qb-inventory']:RemoveItem(src, itemName, amount, false, 'qb-pawnshop:server:meltItemRemove') then
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], 'remove')
        local meltTime = amount * recipe.meltTime
        local rewards = {}
        for _, reward in ipairs(recipe.rewards) do
            rewards[#rewards + 1] = { item = reward.item, amount = amount * reward.amount }
        end
        Melts[citizenid] = Melts[citizenid] or {}
        Melts[citizenid][#Melts[citizenid] + 1] = {
            item = itemName,
            amount = amount,
            readyAt = now + math.ceil(meltTime * 60),
            rewards = rewards,
        }
        local item = { name = itemName, reward = recipe.rewards, time = recipe.meltTime }
        TriggerClientEvent('qb-pawnshop:client:startMelting', src, item, amount, (meltTime * 60000 / 1000))
        TriggerClientEvent('QBCore:Notify', src, Lang:t('info.melt_wait', { value = meltTime }), 'primary')
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_items'), 'error')
    end
end)

-- O que se recolhe vem da fila do servidor; os argumentos do cliente são ignorados
RegisterNetEvent('qb-pawnshop:server:pickupMelted', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if distanceToPawnShop(src) > 5 then
        exploitBan(src, 'pickupMelted Exploiting')
        return
    end
    local citizenid = Player.PlayerData.citizenid
    local batches = Melts[citizenid] or {}
    local now = os.time()
    local pending, ready = {}, 0
    for _, batch in ipairs(batches) do
        if batch.readyAt > now then
            pending[#pending + 1] = batch
        else
            ready = ready + 1
            local left = {}
            for _, reward in ipairs(batch.rewards) do
                if exports['qb-inventory']:AddItem(src, reward.item, reward.amount, false, false, 'qb-pawnshop:server:pickupMelted') then
                    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[reward.item], 'add')
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.items_received', { value = reward.amount, value2 = QBCore.Shared.Items[reward.item].label }), 'success')
                else
                    -- Fica guardado para a próxima recolha em vez de se perder
                    left[#left + 1] = reward
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('error.inventory_full', { value = QBCore.Shared.Items[reward.item].label }), 'warning', 7500)
                end
            end
            if #left > 0 then
                batch.rewards = left
                pending[#pending + 1] = batch
            end
        end
    end
    if ready == 0 and #batches > 0 then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.still_melting'), 'error')
    end
    Melts[citizenid] = #pending > 0 and pending or nil

    local stillReady = false
    for _, batch in ipairs(pending) do
        if batch.readyAt <= now then stillReady = true end
    end
    if not stillReady then
        TriggerClientEvent('qb-pawnshop:client:resetPickup', src)
    end
    TriggerClientEvent('qb-pawnshop:client:openMenu', src)
end)

QBCore.Functions.CreateCallback('qb-pawnshop:server:getInv', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local inventory = Player.PlayerData.items
    return cb(inventory, PawnPrices)
end)
