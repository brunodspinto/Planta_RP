-- Commands

QBCore.Commands.Add('giveitem', 'Give An Item (Admin Only)', { { name = 'id', help = 'Player ID' }, { name = 'item', help = 'Name of the item (not a label)' }, { name = 'amount', help = 'Amount of items' } }, false, function(source, args)
    local id = tonumber(args[1])
    local player = QBCore.Functions.GetPlayer(id)
    local amount = tonumber(args[3]) or 1
    local itemData = QBCore.Shared.Items[tostring(args[2]):lower()]
    if player then
        if itemData then
            -- check iteminfo
            local info = {}
            if itemData['name'] == 'id_card' then
                info.citizenid = player.PlayerData.citizenid
                info.firstname = player.PlayerData.charinfo.firstname
                info.lastname = player.PlayerData.charinfo.lastname
                info.birthdate = player.PlayerData.charinfo.birthdate
                info.gender = player.PlayerData.charinfo.gender
                info.nationality = player.PlayerData.charinfo.nationality
            elseif itemData['name'] == 'driver_license' then
                info.firstname = player.PlayerData.charinfo.firstname
                info.lastname = player.PlayerData.charinfo.lastname
                info.birthdate = player.PlayerData.charinfo.birthdate
                info.type = 'Class C Driver License'
            elseif itemData['type'] == 'weapon' then
                amount = 1
                info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
                info.quality = 100
            elseif itemData['name'] == 'harness' then
                info.uses = 20
            elseif itemData['name'] == 'markedbills' then
                info.worth = math.random(5000, 10000)
            elseif itemData['name'] == 'printerdocument' then
                info.url = 'https://cdn.discordapp.com/attachments/870094209783308299/870104331142189126/Logo_-_Display_Picture_-_Stylized_-_Red.png'
            end

            if AddItem(id, itemData['name'], amount, false, info, 'give item command') then
                QBCore.Functions.Notify(source, Lang:t('notify.yhg') .. GetPlayerName(id) .. ' ' .. amount .. ' ' .. itemData['name'] .. '', 'success')
                TriggerClientEvent('qb-inventory:client:ItemBox', id, itemData, 'add', amount)
                if Player(id).state.inv_busy then TriggerClientEvent('qb-inventory:client:updateInventory', id) end
            else
                QBCore.Functions.Notify(source, Lang:t('notify.cgitem'), 'error')
            end
        else
            QBCore.Functions.Notify(source, Lang:t('notify.idne'), 'error')
        end
    else
        QBCore.Functions.Notify(source, Lang:t('notify.pdne'), 'error')
    end
end, 'admin')

QBCore.Commands.Add('randomitems', 'Receive random items', {}, false, function(source)
    local player = QBCore.Functions.GetPlayer(source)
    local playerInventory = player.PlayerData.items
    local filteredItems = {}
    for k, v in pairs(QBCore.Shared.Items) do
        if QBCore.Shared.Items[k]['type'] ~= 'weapon' then
            filteredItems[#filteredItems + 1] = v
        end
    end
    for _ = 1, 10, 1 do
        local randitem = filteredItems[math.random(1, #filteredItems)]
        local amount = math.random(1, 10)
        if randitem['unique'] then
            amount = 1
        end
        local emptySlot = nil
        for i = 1, Config.MaxSlots do
            if not playerInventory[i] then
                emptySlot = i
                break
            end
        end
        if emptySlot then
            if AddItem(source, randitem.name, amount, emptySlot, false, 'random items command') then
                TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items[randitem.name], 'add')
                player = QBCore.Functions.GetPlayer(source)
                playerInventory = player.PlayerData.items
                if Player(source).state.inv_busy then TriggerClientEvent('qb-inventory:client:updateInventory', source) end
            end
            Wait(1000)
        end
    end
end, 'god')

QBCore.Commands.Add('clearinv', 'Clear Inventory (Admin Only)', { { name = 'id', help = 'Player ID' } }, false, function(source, args)
    local id = tonumber(args[1])
    if not id then
        ClearInventory(source)
        return
    end
    ClearInventory(id)
end, 'admin')

-- Keybindings

RegisterCommand('closeInv', function(source)
    CloseInventory(source)
end, false)

RegisterCommand('hotbar', function(source)
    if Player(source).state.inv_busy then return end
    local QBPlayer = QBCore.Functions.GetPlayer(source)
    if not QBPlayer then return end
    if not QBPlayer or QBPlayer.PlayerData.metadata['isdead'] or QBPlayer.PlayerData.metadata['inlaststand'] or QBPlayer.PlayerData.metadata['ishandcuffed'] then return end
    local hotbarItems = {
        QBPlayer.PlayerData.items[1],
        QBPlayer.PlayerData.items[2],
        QBPlayer.PlayerData.items[3],
        QBPlayer.PlayerData.items[4],
        QBPlayer.PlayerData.items[5],
    }
    TriggerClientEvent('qb-inventory:client:hotbar', source, hotbarItems)
end, false)

local function trimPlate(plate)
    return (tostring(plate or ''):gsub('^%s+', ''):gsub('%s+$', ''))
end

-- O cliente diz que mala ou porta-luvas abrir. Sem confirmar no servidor, bastava
-- enviar a matrícula de qualquer carro do mapa para lhe tirar as coisas.
-- Devolve o veículo dessa mala/porta-luvas, ou nil.
local function findVehicleStorage(source, inventory)
    local kind, plate = inventory:match('^(%a+)%-(.+)$')
    plate = trimPlate(plate)
    if plate == '' then return end
    local ped = GetPlayerPed(source)
    if kind == 'glovebox' then
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 and trimPlate(GetVehicleNumberPlateText(vehicle)) == plate then return vehicle end
    elseif kind == 'trunk' then
        local coords = GetEntityCoords(ped)
        for _, vehicle in ipairs(GetAllVehicles()) do
            if #(GetEntityCoords(vehicle) - coords) < 10.0 and trimPlate(GetVehicleNumberPlateText(vehicle)) == plate then
                return vehicle
            end
        end
    end
end

-- Classe GTA (a de GetVehicleClass) de cada categoria de qb-core/shared/vehicles.lua
local CategoryClass = {
    compacts = 0, sedans = 1, suvs = 2, coupes = 3, muscle = 4, sportsclassics = 5, sports = 6, super = 7,
    motorcycles = 8, offroad = 9, industrial = 10, utility = 11, vans = 12, cycles = 13, boats = 14,
    helicopters = 15, planes = 16, service = 17, emergency = 18, military = 19, commercial = 20, openwheel = 22,
}

-- O tamanho dependia da classe enviada pelo cliente: um compacto passava por barco
-- (120 kg) ou mandava uma classe que não existe e caía no tamanho de stash (2000 kg).
-- Modelos fora de QBCore.Shared.Vehicles (addons, alguns carros de empregos) ficam
-- com a classe do cliente, mas uma classe desconhecida já só dá o tamanho default.
local function vehicleStorage(vehicle, clientClass)
    local hashes = QBCore.Shared.VehicleHashes or {}
    local model = GetEntityModel(vehicle)
    -- joaat e GetEntityModel podem não concordar no sinal do hash de 32 bits
    local shared = hashes[model] or hashes[model & 0xFFFFFFFF] or hashes[model - 0x100000000]
    local class = shared and CategoryClass[shared.category] or tonumber(clientClass)
    return VehicleStorage[class] or VehicleStorage.default
end

RegisterCommand('inventory', function(source)
    if Player(source).state.inv_busy then return end
    local QBPlayer = QBCore.Functions.GetPlayer(source)
    if not QBPlayer then return end
    if not QBPlayer or QBPlayer.PlayerData.metadata['isdead'] or QBPlayer.PlayerData.metadata['inlaststand'] or QBPlayer.PlayerData.metadata['ishandcuffed'] then return end
    QBCore.Functions.TriggerClientCallback('qb-inventory:client:vehicleCheck', source, function(inventory, class)
        local vehicle = type(inventory) == 'string' and findVehicleStorage(source, inventory)
        if not vehicle then return OpenInventory(source) end
        local storage = vehicleStorage(vehicle, class)
        if inventory:find('trunk-') then
            OpenInventory(source, inventory, { slots = storage.trunkSlots, maxweight = storage.trunkWeight })
            return
        elseif inventory:find('glovebox-') then
            OpenInventory(source, inventory, { slots = storage.gloveboxSlots, maxweight = storage.gloveboxWeight })
            return
        end
    end)
end, false)
