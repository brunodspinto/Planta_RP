QBCore = exports['qb-core']:GetCoreObject()
Inventories = {}
Drops = {}
RegisteredShops = {}
-- Inventário que o servidor abriu a cada jogador, além do dele (stash, mala, drop,
-- loja ou otherplayer-N). Mover, comprar e fechar só mexem neste; o nome que o
-- cliente envia deixou de chegar para abrir caminho a inventários de outros.
OpenedInventory = {}

function IsWholeNumber(n)
    return type(n) == 'number' and n == math.floor(n) and n > -math.huge and n < math.huge
end

-- Regista o inventário aberto e destranca o anterior, se o jogador abriu outro sem fechar
function SetOpenedInventory(src, identifier)
    local previous = OpenedInventory[src]
    if previous and previous ~= identifier then
        local inventory = Inventories[previous]
        if inventory and inventory.isOpen == src then
            inventory.isOpen = false
            MySQL.prepare('INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = ?', { previous, json.encode(inventory.items), json.encode(inventory.items) })
        end
        if Drops[previous] and Drops[previous].isOpen == src then Drops[previous].isOpen = false end
    end
    OpenedInventory[src] = identifier
end

function CopyTable(t)
    if type(t) ~= 'table' then return t end
    local copy = {}
    for k, v in pairs(t) do copy[k] = CopyTable(v) end
    return copy
end

CreateThread(function()
    MySQL.query('SELECT * FROM inventories', {}, function(result)
        if result and #result > 0 then
            for i = 1, #result do
                local inventory = result[i]
                local cacheKey = inventory.identifier
                Inventories[cacheKey] = {
                    items = json.decode(inventory.items) or {},
                    isOpen = false
                }
            end
            print(#result .. ' inventories successfully loaded')
        end
    end)
end)

CreateThread(function()
    while true do
        for k, v in pairs(Drops) do
            if v and (v.createdTime + (Config.CleanupDropTime * 60) < os.time()) and not Drops[k].isOpen then
                local entity = NetworkGetEntityFromNetworkId(v.entityId)
                if DoesEntityExist(entity) then DeleteEntity(entity) end
                Drops[k] = nil
            end
        end
        Wait(Config.CleanupDropInterval * 60000)
    end
end)

-- Handlers

AddEventHandler('playerDropped', function()
    local src = source
    OpenedInventory[src] = nil
    for _, inv in pairs(Inventories) do
        if inv.isOpen == src then
            inv.isOpen = false
        end
    end
    for _, drop in pairs(Drops) do
        if drop.isOpen == src then
            drop.isOpen = false
        end
    end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
    for inventory, data in pairs(Inventories) do
        if data.isOpen then
            MySQL.prepare('INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = ?', { inventory, json.encode(data.items), json.encode(data.items) })
        end
    end
end)

RegisterNetEvent('QBCore:Server:UpdateObject', function()
    if source ~= '' then return end
    QBCore = exports['qb-core']:GetCoreObject()
end)

AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'AddItem', function(item, amount, slot, info, reason)
        return AddItem(Player.PlayerData.source, item, amount, slot, info, reason)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'RemoveItem', function(item, amount, slot, reason)
        return RemoveItem(Player.PlayerData.source, item, amount, slot, reason)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'GetItemBySlot', function(slot)
        return GetItemBySlot(Player.PlayerData.source, slot)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'GetItemByName', function(item)
        return GetItemByName(Player.PlayerData.source, item)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'GetItemsByName', function(item)
        return GetItemsByName(Player.PlayerData.source, item)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'ClearInventory', function(filterItems)
        ClearInventory(Player.PlayerData.source, filterItems)
    end)

    QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, 'SetInventory', function(items)
        SetInventory(Player.PlayerData.source, items)
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    local Players = QBCore.Functions.GetQBPlayers()
    for k in pairs(Players) do
        QBCore.Functions.AddPlayerMethod(k, 'AddItem', function(item, amount, slot, info)
            return AddItem(k, item, amount, slot, info)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'RemoveItem', function(item, amount, slot)
            return RemoveItem(k, item, amount, slot)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'GetItemBySlot', function(slot)
            return GetItemBySlot(k, slot)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'GetItemByName', function(item)
            return GetItemByName(k, item)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'GetItemsByName', function(item)
            return GetItemsByName(k, item)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'ClearInventory', function(filterItems)
            ClearInventory(k, filterItems)
        end)

        QBCore.Functions.AddPlayerMethod(k, 'SetInventory', function(items)
            SetInventory(k, items)
        end)

        Player(k).state.inv_busy = false
    end
end)

-- Functions

function checkWeapon(source, item)
    local currentWeapon = type(item) == 'table' and item.name or item
    local ped = GetPlayerPed(source)
    local weapon = GetSelectedPedWeapon(ped)
    local weaponInfo = QBCore.Shared.Weapons[weapon]
    if weaponInfo and weaponInfo.name == currentWeapon then
        RemoveWeaponFromPed(ped, weapon)
        TriggerClientEvent('qb-weapons:client:UseWeapon', source, { name = currentWeapon }, false)
    end
end

-- Events

RegisterNetEvent('qb-inventory:server:openVending', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    CreateShop({
        name = 'vending',
        label = 'Vending Machine',
        coords = data.coords,
        slots = #Config.VendingItems,
        items = Config.VendingItems
    })
    OpenShop(src, 'vending')
end)

-- Fecha o que o servidor abriu a este jogador. O nome enviado pelo cliente é ignorado:
-- antes servia para destrancar a stash ou o drop que outro jogador tinha aberto.
RegisterNetEvent('qb-inventory:server:closeInventory', function()
    local src = source
    local QBPlayer = QBCore.Functions.GetPlayer(src)
    if not QBPlayer then return end
    Player(src).state.inv_busy = false
    local inventory = OpenedInventory[src]
    OpenedInventory[src] = nil
    if not inventory or inventory:find('shop%-') then return end
    if inventory:find('otherplayer%-') then
        local targetId = tonumber(inventory:match('otherplayer%-(.+)'))
        if targetId and QBCore.Functions.GetPlayer(targetId) then Player(targetId).state.inv_busy = false end
        return
    end
    if Drops[inventory] then
        if Drops[inventory].isOpen ~= src then return end
        Drops[inventory].isOpen = false
        if #Drops[inventory].items == 0 and not Drops[inventory].isOpen then -- if no listeed items in the drop on close
            TriggerClientEvent('qb-inventory:client:removeDropTarget', -1, Drops[inventory].entityId)
            Wait(500)
            local entity = NetworkGetEntityFromNetworkId(Drops[inventory].entityId)
            if DoesEntityExist(entity) then DeleteEntity(entity) end
            Drops[inventory] = nil
        end
        return
    end
    if not Inventories[inventory] or Inventories[inventory].isOpen ~= src then return end
    Inventories[inventory].isOpen = false
    MySQL.prepare('INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = ?', { inventory, json.encode(Inventories[inventory].items), json.encode(Inventories[inventory].items) })
end)

-- O cartão de cidadão e a carta de condução mostram os dados do item que está no
-- inventário (itemData), não os que o cliente envia: antes dava para mostrar um BI forjado.
RegisterNetEvent('qb-inventory:server:useItem', function(item)
    local src = source
    if type(item) ~= 'table' then return end
    local itemData = GetItemBySlot(src, item.slot)
    if not itemData then return end
    item = itemData
    local itemInfo = QBCore.Shared.Items[itemData.name]
    if itemData.type == 'weapon' then
        TriggerClientEvent('qb-weapons:client:UseWeapon', src, itemData, itemData.info.quality and itemData.info.quality > 0)
        TriggerClientEvent('qb-inventory:client:ItemBox', src, itemInfo, 'use')
    elseif itemData.name == 'id_card' then
        UseItem(itemData.name, src, itemData)
        TriggerClientEvent('qb-inventory:client:ItemBox', source, itemInfo, 'use')
        local playerPed = GetPlayerPed(src)
        local playerCoords = GetEntityCoords(playerPed)
        local players = QBCore.Functions.GetPlayers()
        local gender = item.info.gender == 0 and 'Male' or 'Female'
        for _, v in pairs(players) do
            local targetPed = GetPlayerPed(v)
            local dist = #(playerCoords - GetEntityCoords(targetPed))
            if dist < 3.0 then
                TriggerClientEvent('chat:addMessage', v, {
                    template = '<div class="chat-message advert" style="background: linear-gradient(to right, rgba(5, 5, 5, 0.6), #74807c); display: flex;"><div style="margin-right: 10px;"><i class="far fa-id-card" style="height: 100%;"></i><strong> {0}</strong><br> <strong>Civ ID:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last Name:</strong> {3} <br><strong>Birthdate:</strong> {4} <br><strong>Gender:</strong> {5} <br><strong>Nationality:</strong> {6}</div></div>',
                    args = {
                        'ID Card',
                        item.info.citizenid,
                        item.info.firstname,
                        item.info.lastname,
                        item.info.birthdate,
                        gender,
                        item.info.nationality
                    }
                })
            end
        end
    elseif itemData.name == 'driver_license' then
        UseItem(itemData.name, src, itemData)
        TriggerClientEvent('qb-inventory:client:ItemBox', src, itemInfo, 'use')
        local playerPed = GetPlayerPed(src)
        local playerCoords = GetEntityCoords(playerPed)
        local players = QBCore.Functions.GetPlayers()
        for _, v in pairs(players) do
            local targetPed = GetPlayerPed(v)
            local dist = #(playerCoords - GetEntityCoords(targetPed))
            if dist < 3.0 then
                TriggerClientEvent('chat:addMessage', v, {
                    template = '<div class="chat-message advert" style="background: linear-gradient(to right, rgba(5, 5, 5, 0.6), #657175); display: flex;"><div style="margin-right: 10px;"><i class="far fa-id-card" style="height: 100%;"></i><strong> {0}</strong><br> <strong>First Name:</strong> {1} <br><strong>Last Name:</strong> {2} <br><strong>Birth Date:</strong> {3} <br><strong>Licenses:</strong> {4}</div></div>',
                    args = {
                        'Drivers License',
                        item.info.firstname,
                        item.info.lastname,
                        item.info.birthdate,
                        item.info.type
                    }
                }
                )
            end
        end
    else
        UseItem(itemData.name, src, itemData)
        TriggerClientEvent('qb-inventory:client:ItemBox', src, itemInfo, 'use')
    end
end)

RegisterNetEvent('qb-inventory:server:openDrop', function(dropId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    local drop = Drops[dropId]
    if not drop then return end
    if drop.isOpen then return end
    local distance = #(playerCoords - drop.coords)
    if distance > 2.5 then return end
    SetOpenedInventory(src, dropId)
    local formattedInventory = {
        name = dropId,
        label = dropId,
        maxweight = drop.maxweight,
        slots = drop.slots,
        inventory = drop.items
    }
    drop.isOpen = src
    TriggerClientEvent('qb-inventory:client:openInventory', source, Player.PlayerData.items, formattedInventory)
end)

-- Quem larga um saco que trazia na mão atualiza a posição dele. Antes qualquer
-- cliente punha as coords de qualquer drop ao seu lado e abria-o do outro lado do mapa.
RegisterNetEvent('qb-inventory:server:updateDrop', function(dropId)
    local src = source
    local drop = type(dropId) == 'string' and Drops[dropId]
    if not drop then return end
    local bag = NetworkGetEntityFromNetworkId(drop.entityId)
    if not DoesEntityExist(bag) then return end
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    if #(playerCoords - GetEntityCoords(bag)) > 5.0 then return end
    drop.coords = playerCoords
end)

-- Só o 'remove' é usado (qb-weapons, ao atirar uma bola de neve). O 'add' dava bolas
-- de neve de graça a qualquer cliente e foi retirado.
RegisterNetEvent('qb-inventory:server:snowball', function(action)
    if action == 'remove' then
        RemoveItem(source, 'weapon_snowball', 1, false, 'qb-inventory:server:snowball')
    end
end)

-- Callbacks

QBCore.Functions.CreateCallback('qb-inventory:server:GetCurrentDrops', function(_, cb)
    cb(Drops)
end)

QBCore.Functions.CreateCallback('qb-inventory:server:createDrop', function(source, cb, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        cb(false)
        return
    end
    -- O saco leva uma cópia do item que estava no slot, não o que o cliente envia:
    -- antes dava para largar quantidades negativas (o RemoveItem somava) e info forjada
    local fromSlot = type(item) == 'table' and tonumber(item.fromSlot)
    local amount = type(item) == 'table' and tonumber(item.amount)
    local slotItem = fromSlot and GetItemBySlot(src, fromSlot)
    if not slotItem or not IsWholeNumber(amount) or amount < 1 or amount > slotItem.amount then
        cb(false)
        return
    end
    item = CopyTable(slotItem)
    item.amount = amount
    item.slot = 1
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    if RemoveItem(src, item.name, amount, fromSlot, 'dropped item') then
        if item.type == 'weapon' then checkWeapon(src, item) end
        TaskPlayAnim(playerPed, 'pickup_object', 'pickup_low', 8.0, -8.0, 2000, 0, 0, false, false, false)
        local bag = CreateObjectNoOffset(Config.ItemDropObject, playerCoords.x + 0.5, playerCoords.y + 0.5, playerCoords.z, true, true, false)
        local dropId = NetworkGetNetworkIdFromEntity(bag)
        local newDropId = 'drop-' .. dropId
        local itemsTable = setmetatable({ item }, {
            __len = function(t)
                local length = 0
                for _ in pairs(t) do length += 1 end
                return length
            end
        })
        if not Drops[newDropId] then
            Drops[newDropId] = {
                name = newDropId,
                label = 'Drop',
                items = itemsTable,
                entityId = dropId,
                createdTime = os.time(),
                coords = playerCoords,
                maxweight = Config.DropSize.maxweight,
                slots = Config.DropSize.slots,
                isOpen = src
            }
            TriggerClientEvent('qb-inventory:client:setupDropTarget', -1, dropId)
        else
            table.insert(Drops[newDropId].items, item)
        end
        SetOpenedInventory(src, newDropId)
        cb(dropId)
    else
        cb(false)
    end
end)

-- Quantidade inteira (0.01 de uma arma custava 1% do preço e dava a arma inteira),
-- só na loja que o servidor abriu a este jogador e com o item e a info da loja.
QBCore.Functions.CreateCallback('qb-inventory:server:attemptPurchase', function(source, cb, data)
    if type(data) ~= 'table' or type(data.item) ~= 'table' or type(data.shop) ~= 'string' then
        cb(false)
        return
    end
    local amount = tonumber(data.amount)
    local shop = string.gsub(data.shop, 'shop%-', '')
    local Player = QBCore.Functions.GetPlayer(source)

    if not IsWholeNumber(amount) or amount < 1 then cb(false) return end

    if not Player then
        cb(false)
        return
    end

    local shopInfo = RegisteredShops[shop]
    if not shopInfo or OpenedInventory[source] ~= 'shop-' .. shop then
        cb(false)
        return
    end

    local shopItem = shopInfo.items[tonumber(data.item.slot)]
    if not shopItem then
        cb(false)
        return
    end
    local itemInfo = { name = data.item.name, slot = shopItem.slot }

    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    if shopInfo.coords then
        local shopCoords = vector3(shopInfo.coords.x, shopInfo.coords.y, shopInfo.coords.z)
        if #(playerCoords - shopCoords) > 10 then
            cb(false)
            return
        end
    end

    if shopInfo.items[itemInfo.slot].name ~= itemInfo.name then -- Check if item name passed is the same as the item in that slot
        cb(false)
        return
    end

    if amount > shopInfo.items[itemInfo.slot].amount or shopInfo.items[itemInfo.slot].amount <= 0 then
        TriggerClientEvent('QBCore:Notify', source, 'Cannot purchase larger quantity than currently in stock', 'error')
        cb(false)
        return
    end

    if not CanAddItem(source, itemInfo.name, amount) then
        TriggerClientEvent('QBCore:Notify', source, 'Cannot hold item', 'error')
        cb(false)
        return
    end

    local price = shopInfo.items[itemInfo.slot].price * amount
    if Player.PlayerData.money.cash >= price then
        Player.Functions.RemoveMoney('cash', price, 'shop-purchase')
        AddItem(source, shopItem.name, amount, nil, CopyTable(shopItem.info), 'shop-purchase')
        shopItem.amount -= amount
        TriggerEvent('qb-shops:server:UpdateShopItems', shop, itemInfo, amount)
        cb(true)
    else
        TriggerClientEvent('QBCore:Notify', source, 'You do not have enough money', 'error')
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('qb-inventory:server:giveItem', function(source, cb, target, item, amount, slot, info)
    local player = QBCore.Functions.GetPlayer(source)
    if not player or player.PlayerData.metadata['isdead'] or player.PlayerData.metadata['inlaststand'] or player.PlayerData.metadata['ishandcuffed'] then
        cb(false)
        return
    end
    local playerPed = GetPlayerPed(source)

    local Target = QBCore.Functions.GetPlayer(target)
    if not Target or Target.PlayerData.metadata['isdead'] or Target.PlayerData.metadata['inlaststand'] or Target.PlayerData.metadata['ishandcuffed'] then
        cb(false)
        return
    end
    local targetPed = GetPlayerPed(target)

    local pCoords = GetEntityCoords(playerPed)
    local tCoords = GetEntityCoords(targetPed)
    if #(pCoords - tCoords) > 5 then
        cb(false)
        return
    end

    local itemInfo = type(item) == 'string' and QBCore.Shared.Items[item:lower()]
    if not itemInfo then
        cb(false)
        return
    end

    -- Quantidade inteira e positiva (com -N o RemoveItem somava itens ao jogador) e a
    -- info do item que está no slot, não a que o cliente envia (forjar armas/documentos)
    local slotItem = slot and GetItemBySlot(source, slot) or GetItemByName(source, item)
    if not slotItem or slotItem.name:lower() ~= item:lower() then
        cb(false)
        return
    end

    local giveAmount = tonumber(amount)
    if not IsWholeNumber(giveAmount) or giveAmount < 1 or giveAmount > slotItem.amount then
        cb(false)
        return
    end

    if not CanAddItem(target, slotItem.name, giveAmount) then
        cb(false)
        return
    end

    info = CopyTable(slotItem.info)
    local fromSlot = slotItem.slot
    local removeItem = RemoveItem(source, slotItem.name, giveAmount, fromSlot, 'Item given to ID #' .. target)
    if not removeItem then
        cb(false)
        return
    end

    local giveItem = AddItem(target, slotItem.name, giveAmount, false, info, 'Item given from ID #' .. source)
    if not giveItem then
        AddItem(source, slotItem.name, giveAmount, fromSlot, info, 'give failed, item returned')
        cb(false)
        return
    end

    if itemInfo.type == 'weapon' then checkWeapon(source, item) end
    TriggerClientEvent('qb-inventory:client:giveAnim', source)
    TriggerClientEvent('qb-inventory:client:ItemBox', source, itemInfo, 'remove', giveAmount)
    TriggerClientEvent('qb-inventory:client:giveAnim', target)
    TriggerClientEvent('qb-inventory:client:ItemBox', target, itemInfo, 'add', giveAmount)
    if Player(target).state.inv_busy then TriggerClientEvent('qb-inventory:client:updateInventory', target) end
    cb(true)
end)

-- Item move logic

local function getItem(inventoryId, src, slot)
    local items = {}
    if inventoryId == 'player' then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player and Player.PlayerData.items then
            items = Player.PlayerData.items
        end
    elseif inventoryId:find('otherplayer-') then
        local targetId = tonumber(inventoryId:match('otherplayer%-(.+)'))
        local targetPlayer = QBCore.Functions.GetPlayer(targetId)
        if targetPlayer and targetPlayer.PlayerData.items then
            items = targetPlayer.PlayerData.items
        end
    elseif inventoryId:find('drop-') == 1 then
        if Drops[inventoryId] and Drops[inventoryId]['items'] then
            items = Drops[inventoryId]['items']
        end
    else
        if Inventories[inventoryId] and Inventories[inventoryId]['items'] then
            items = Inventories[inventoryId]['items']
        end
    end

    for _, item in pairs(items) do
        if item.slot == slot then
            return item
        end
    end
    return nil
end

local function getIdentifier(inventoryId, src)
    if inventoryId == 'player' then
        return src
    elseif inventoryId:find('otherplayer-') then
        return tonumber(inventoryId:match('otherplayer%-(.+)'))
    else
        return inventoryId
    end
end

-- O jogador só mexe no próprio inventário e no que o servidor lhe abriu. Antes o
-- cliente escolhia os nomes e tirava itens de qualquer stash, mala, drop ou jogador.
local function canAccess(src, inventoryId)
    if inventoryId == 'player' then return true end
    if OpenedInventory[src] ~= inventoryId then return false end
    if inventoryId:find('otherplayer%-') then
        local targetId = tonumber(inventoryId:match('otherplayer%-(.+)'))
        if not targetId or not QBCore.Functions.GetPlayer(targetId) then return false end
        return #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(targetId))) <= 10.0
    end
    return true
end

local function getMaxSlots(inventoryId)
    if inventoryId == 'player' or inventoryId:find('otherplayer%-') then return Config.MaxSlots end
    local inventory = Drops[inventoryId] or Inventories[inventoryId]
    return inventory and inventory.slots or 0
end

-- Se o destino recusar (peso, por exemplo), o item volta para onde estava em vez de desaparecer
local function moveItem(fromId, toId, name, amount, fromSlot, toSlot, info, reason)
    if not RemoveItem(fromId, name, amount, fromSlot, reason) then return end
    if AddItem(toId, name, amount, toSlot, info, reason) then return end
    AddItem(fromId, name, amount, fromSlot, info, reason .. ' (reverted)')
end

local function swapItems(fromId, toId, fromItem, toItem, fromSlot, toSlot)
    local fromName, fromAmount, fromInfo = fromItem.name, fromItem.amount, fromItem.info
    local toName, toAmount, toInfo = toItem.name, toItem.amount, toItem.info
    if not RemoveItem(fromId, fromName, fromAmount, fromSlot, 'swapped item') then return end
    if not RemoveItem(toId, toName, toAmount, toSlot, 'swapped item') then
        AddItem(fromId, fromName, fromAmount, fromSlot, fromInfo, 'swap reverted')
        return
    end
    local addedTo = AddItem(toId, fromName, fromAmount, toSlot, fromInfo, 'swapped item')
    local addedFrom = AddItem(fromId, toName, toAmount, fromSlot, toInfo, 'swapped item')
    if addedTo and addedFrom then return end
    if addedTo then RemoveItem(toId, fromName, fromAmount, toSlot, 'swap reverted') end
    if addedFrom then RemoveItem(fromId, toName, toAmount, fromSlot, 'swap reverted') end
    AddItem(fromId, fromName, fromAmount, fromSlot, fromInfo, 'swap reverted')
    AddItem(toId, toName, toAmount, toSlot, toInfo, 'swap reverted')
end

RegisterNetEvent('qb-inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromAmount, toAmount)
    local src = source
    if type(fromInventory) ~= 'string' or type(toInventory) ~= 'string' then return end
    if fromInventory:find('shop%-') or toInventory:find('shop%-') then return end
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not canAccess(src, fromInventory) or not canAccess(src, toInventory) then return end

    fromSlot, toSlot, fromAmount, toAmount = tonumber(fromSlot), tonumber(toSlot), tonumber(fromAmount), tonumber(toAmount)
    if not IsWholeNumber(toAmount) or toAmount < 1 or not fromAmount or fromAmount < 0 then return end
    if not IsWholeNumber(toSlot) or toSlot < 1 or toSlot > getMaxSlots(toInventory) then return end

    local fromItem = getItem(fromInventory, src, fromSlot)
    local toItem = getItem(toInventory, src, toSlot)

    if fromItem then
        if not toItem and toAmount > fromItem.amount then return end
        if fromInventory == 'player' and toInventory ~= 'player' then checkWeapon(src, fromItem) end

        local fromId = getIdentifier(fromInventory, src)
        local toId = getIdentifier(toInventory, src)

        if toItem and fromItem.name == toItem.name and not toItem.unique then
            moveItem(fromId, toId, fromItem.name, toAmount, fromSlot, toSlot, toItem.info, 'stacked item')
        elseif not toItem and toAmount < fromAmount then
            moveItem(fromId, toId, fromItem.name, toAmount, fromSlot, toSlot, CopyTable(fromItem.info), 'split item')
        elseif toItem then
            swapItems(fromId, toId, fromItem, toItem, fromSlot, toSlot)
        else
            moveItem(fromId, toId, fromItem.name, toAmount, fromSlot, toSlot, fromItem.info, 'moved item')
        end
    end
end)
