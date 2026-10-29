local QBCore = exports['qb-core']:GetCoreObject()
local availableJobs = Config.AvailableJobs

-- Exports

local function AddCityJob(jobName, toCH)
    if availableJobs[jobName] then return false, 'already added' end
    availableJobs[jobName] = {
        ['label'] = toCH.label,
        ['isManaged'] = toCH.isManaged
    }
    return true, 'success'
end

exports('AddCityJob', AddCityJob)

-- Functions

local function giveStarterItems()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    for _, v in pairs(QBCore.Shared.StarterItems) do
        local info = {}
        if v.item == 'id_card' then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == 'driver_license' then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = 'Carta de condução de categoria B'
        end
        exports['qb-inventory']:AddItem(source, v.item, 1, false, info, 'qb-cityhall:giveStarterItems')
    end
end

-- Callbacks

QBCore.Functions.CreateCallback('qb-cityhall:server:receiveJobs', function(_, cb)
    cb(availableJobs)
end)

QBCore.Functions.CreateCallback('qb-cityhall:server:getIdentityData', function(source, cb, hallId)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb({}) end

    local licensesMeta = Player.PlayerData.metadata['licences']
    local availableLicenses = {}

    for license, data in pairs(Config.Cityhalls[hallId].licenses) do
        if not data.metadata or licensesMeta[data.metadata] then
            availableLicenses[license] = data
        end
    end

    cb(availableLicenses)
end)

-- Events

RegisterNetEvent('qb-cityhall:server:requestId', function(item, hall)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local itemInfo = Config.Cityhalls[hall].licenses[item]
    if not Player.Functions.RemoveMoney('cash', itemInfo.cost, 'cityhall id') then return TriggerClientEvent('QBCore:Notify', src, ('Não tens dinheiro suficiente contigo, precisas de $%s em dinheiro'):format(itemInfo.cost), 'error') end
    local info = {}
    if item == 'id_card' then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif item == 'driver_license' then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = 'Carta de condução de categoria B'
    elseif item == 'weaponlicense' then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
    else
        return false
    end
    if not exports['qb-inventory']:AddItem(source, item, 1, false, info, 'qb-cityhall:server:requestId') then return end
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
end)

RegisterNetEvent('qb-cityhall:server:sendDriverTest', function(instructors)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    for i = 1, #instructors do
        local citizenid = instructors[i]
        local SchoolPlayer = QBCore.Functions.GetPlayerByCitizenId(citizenid)
        if SchoolPlayer then
            TriggerClientEvent('qb-cityhall:client:sendDriverEmail', SchoolPlayer.PlayerData.source, Player.PlayerData.charinfo)
        else
            local mailData = {
                sender = 'Câmara Municipal',
                subject = 'Pedido de aulas de condução',
                message = 'Olá,<br><br>Recebemos uma mensagem de alguém que quer ter aulas de condução.<br>Se estiveres disponível para ensinar, contacta esta pessoa:<br>Nome: <strong>' .. Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname .. '<br />Telemóvel: <strong>' .. Player.PlayerData.charinfo.phone .. '</strong><br><br>Com os melhores cumprimentos,<br>Câmara Municipal de Los Santos',
                button = {}
            }
            exports['qb-phone']:sendNewMailToOffline(citizenid, mailData)
        end
    end
    TriggerClientEvent('QBCore:Notify', src, 'Foi enviado um email às escolas de condução, vais ser contactado automaticamente', 'success', 5000)
end)

RegisterNetEvent('qb-cityhall:server:ApplyJob', function(job, cityhallCoords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)

    local data = {
        ['src'] = src,
        ['job'] = job
    }
    if #(pedCoords - cityhallCoords) >= 20.0 or not availableJobs[job] then
        return false
    end
    local JobInfo = QBCore.Shared.Jobs[job]
    Player.Functions.SetJob(data.job)
    TriggerClientEvent('QBCore:Notify', data.src, Lang:t('info.new_job', { job = JobInfo.label }))
end)

RegisterNetEvent('qb-cityhall:server:getIDs', giveStarterItems)

RegisterNetEvent('QBCore:Client:UpdateObject', function()
    QBCore = exports['qb-core']:GetCoreObject()
end)

-- Commands

QBCore.Commands.Add('drivinglicense', 'Dar uma carta de condução a alguém', { { 'id', 'ID da pessoa' } }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local SearchedPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if SearchedPlayer then
        if not SearchedPlayer.PlayerData.metadata['licences']['driver'] then
            for i = 1, #Config.DrivingSchools do
                for id = 1, #Config.DrivingSchools[i].instructors do
                    if Config.DrivingSchools[i].instructors[id] == Player.PlayerData.citizenid then
                        SearchedPlayer.PlayerData.metadata['licences']['driver'] = true
                        SearchedPlayer.Functions.SetMetaData('licences', SearchedPlayer.PlayerData.metadata['licences'])
                        TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, 'Passaste! Levanta a tua carta de condução na câmara municipal', 'success', 5000)
                        TriggerClientEvent('QBCore:Notify', source, ('O jogador com o ID %s pode agora tirar a carta de condução'):format(SearchedPlayer.PlayerData.source), 'success', 5000)
                        break
                    end
                end
            end
        else
            TriggerClientEvent('QBCore:Notify', source, 'Não é possível dar autorização para a carta de condução, esta pessoa já a tem', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'O jogador não está online', 'error')
    end
end)
