local QBCore = exports['qb-core']:GetCoreObject()
local Bail = {}

-- Turnos de entregas por citizenid, abertos ao pagar a caução da carrinha:
-- { done = n, lastShop = nome, lastCoords = vector3, lastAt = os.time() }
local Deliveries = {}
local MaxSpeed = 45.0 -- m/s; entre duas lojas o tempo mínimo é distância / MaxSpeed

-- Functions

local function checkTable(inputValue, requiredValue)
    if type(inputValue) == 'table' and type(requiredValue) == 'table' then
        for _, v in ipairs(requiredValue) do
            if inputValue[v] then return true end
        end
    elseif type(requiredValue) == 'table' then
        for _, v in ipairs(requiredValue) do
            if v == inputValue then return true end
        end
    elseif type(inputValue) == 'string' and type(requiredValue) == 'string' then
        return inputValue == requiredValue
    elseif type(inputValue) == 'table' and type(requiredValue) == 'string' then
        return inputValue[requiredValue] == true
    elseif type(inputValue) == 'string' and type(requiredValue) == 'table' then
        for _, v in ipairs(requiredValue) do
            if v == inputValue then return true end
        end
    end

    return false
end

local function saveShopInv(shop, products)
    local shopinv = {}
    shopinv[shop] = {}
    shopinv[shop].products = products
    SaveResourceFile(GetCurrentResourceName(), Config.ShopsInvJsonFile, json.encode(shopinv), -1)
end

local function deliveryPay(source, shop)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    local session = Deliveries[Player.PlayerData.citizenid]
    if not session or session.done >= Config.MaxDeliveries or session.lastShop == shop then return false end
    local deliverCoords = Config.Locations[shop].delivery
    if not deliverCoords then return false end
    deliverCoords = vector3(deliverCoords.x, deliverCoords.y, deliverCoords.z)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - deliverCoords)
    if distance > 10 then return false end
    local now = os.time()
    if now - session.lastAt < #(deliverCoords - session.lastCoords) / MaxSpeed then return false end
    session.done = session.done + 1
    session.lastShop = shop
    session.lastCoords = deliverCoords
    session.lastAt = now
    Player.Functions.AddMoney('bank', Config.DeliveryPrice, 'qb-shops:deliveryPay')
    if math.random(100) <= 10 then exports['qb-inventory']:AddItem(source, Config.RewardItem, 1, false, false, 'qb-shops:deliveryPay') end
    return true
end

-- Events

-- Deliveries

RegisterNetEvent('qb-shops:server:RestockShopItems', function(shop)
    local src = source
    if not shop then return end
    if not Config.Locations[shop] then return end
    -- Só repõe stock uma entrega que foi validada e paga
    if not deliveryPay(src, shop) then return end
    if not Config.Locations[shop].useStock then return end
    local randAmount = math.random(10, 50)
    for k in pairs(Config.Locations[shop].products) do Config.Locations[shop].products[k].amount += randAmount end
    saveShopInv(shop, Config.Locations[shop].products)
    TriggerClientEvent('qb-shops:client:SetShopItems', -1, shop, Config.Locations[shop].products)
end)

-- Só o qb-inventory (servidor) o dispara, com TriggerEvent. Como RegisterNetEvent,
-- qualquer cliente mexia no stock (amount negativo = stock infinito).
AddEventHandler('qb-shops:server:UpdateShopItems', function(shop, itemData, amount) -- called from inventory
    if not shop or not itemData or not amount then return end
    if not Config.Locations[shop] then return end
    if not Config.Locations[shop].useStock then return end
    Config.Locations[shop].products[itemData.slot].amount -= amount
    if Config.Locations[shop].products[itemData.slot].amount < 0 then
        Config.Locations[shop].products[itemData.slot].amount = 0
    end
    saveShopInv(shop, Config.Locations[shop].products)
    TriggerClientEvent('qb-shops:client:SetShopItems', -1, shop, Config.Locations[shop].products)
end)

local function startDeliveries(citizenid)
    if Deliveries[citizenid] then return end
    local depot = Config.DeliveryLocations['main'].coords
    Deliveries[citizenid] = { done = 0, lastCoords = vector3(depot.x, depot.y, depot.z), lastAt = os.time() }
end

RegisterNetEvent('qb-shops:server:DoBail', function(bool)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if bool then
        if Player.Functions.RemoveMoney('cash', Config.TruckDeposit, 'tow-received-bail') then
            Bail[Player.PlayerData.citizenid] = Config.TruckDeposit
            startDeliveries(Player.PlayerData.citizenid)
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.paid_with_cash', { value = Config.TruckDeposit }), 'success')
            TriggerClientEvent('qb-shops:client:SpawnVehicle', src)
        elseif Player.Functions.RemoveMoney('bank', Config.TruckDeposit, 'tow-received-bail') then
            Bail[Player.PlayerData.citizenid] = Config.TruckDeposit
            startDeliveries(Player.PlayerData.citizenid)
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.paid_with_bank', { value = Config.TruckDeposit }), 'success')
            TriggerClientEvent('qb-shops:client:SpawnVehicle', src)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_deposit', { value = Config.TruckDeposit }), 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] then
            local deposit = Bail[Player.PlayerData.citizenid]
            Bail[Player.PlayerData.citizenid] = nil
            Deliveries[Player.PlayerData.citizenid] = nil
            Player.Functions.AddMoney('cash', deposit, 'trucker-bail-paid')
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.refund_to_cash', { value = Config.TruckDeposit }), 'success')
        end
    end
end)

-- O antigo qb-shops:server:PaySlip(drops) foi removido: nenhum cliente o chamava
-- e pagava DeliveryPrice x drops sem validar nada. O pagamento é feito por entrega
-- em deliveryPay.

-- Opening shops

RegisterNetEvent('qb-shops:server:openShop', function(data)
    local src = source
    local shopName = data.shop
    local shopData = Config.Locations[shopName]
    if not shopData then return end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local playerData = Player.PlayerData
    local products = shopData.products
    local items = {}

    if shopData.useStock then
        local shopInvJson = json.decode(LoadResourceFile(GetCurrentResourceName(), Config.ShopsInvJsonFile))
        if shopInvJson[shopName] then
            for k, v in pairs(shopInvJson[shopName].products) do
                if products[k] then
                    products[k].amount = v.amount
                end
            end
        end
    end

    for i = 1, #products do
        local curProduct = products[i]
        local addProduct = true

        if curProduct.requiredGrade and playerData.job.grade.level < curProduct.requiredGrade then
            addProduct = false
        end

        if addProduct and curProduct.requiredJob and not checkTable(playerData.job.name, curProduct.requiredJob) then
            addProduct = false
        end

        if addProduct and curProduct.requiredGang and not checkTable(playerData.gang.name, curProduct.requiredGang) then
            addProduct = false
        end

        if addProduct and curProduct.requiredLicense and not checkTable(playerData.metadata['licences'], curProduct.requiredLicense) then
            addProduct = false
        end

        if addProduct then
            curProduct.slot = #items + 1
            items[#items + 1] = curProduct
        end
    end

    exports['qb-inventory']:CreateShop({
        name = shopName,
        label = shopData.label,
        slots = shopData.slots,
        coords = shopData.coords,
        items = items,
    })
    exports['qb-inventory']:OpenShop(src, shopName)
end)
