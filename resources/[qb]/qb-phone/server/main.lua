local QBCore = exports['qb-core']:GetCoreObject()
local QBPhone = {}
local AppAlerts = {}
local MentionedTweets = {}
local Hashtags = {}
local Calls = {}
local Adverts = {}
local GeneratedPlates = {}
local WebHook = GetConvar('DISCORD_WEBHOOK_PHONE_MEDIA', GetConvar('DISCORD_WEBHOOK_DEFAULT', ''))
local FivemerrApiToken = ''
local TWData = {}

-- Transferências: teto por operação (valores acima são tratados como inválidos).
local MAX_TRANSFER_AMOUNT = 100000000

-- Valor de dinheiro vindo do cliente: número inteiro, finito e > 0. Devolve nil se inválido.
local function ValidateMoneyAmount(value)
    local n = tonumber(value)
    if not n or n ~= n or n <= 0 or n > MAX_TRANSFER_AMOUNT or n % 1 ~= 0 then return nil end
    return n
end

-- Número de conta vindo do cliente: só alfanumérico (formato do qb-core,
-- ex.: US01QBCore1234567812). Devolve nil se inválido.
local function ValidateIban(value)
    if type(value) ~= 'string' then return nil end
    value = value:gsub('^%s+', ''):gsub('%s+$', '')
    if #value < 4 or #value > 34 or not value:match('^%w+$') then return nil end
    return value
end

-- Procura o titular pela conta com correspondência exata (a mesma query do
-- qb-core em CreateAccountNumber). Devolve a linha ou nil.
local function FindPlayerByAccount(iban)
    local result = MySQL.query.await(
        'SELECT citizenid, money FROM players WHERE JSON_UNQUOTE(JSON_EXTRACT(charinfo, "$.account")) = ? LIMIT 1',
        { iban })
    return result and result[1] or nil
end

-- Credita um titular que pode estar online ou offline. Devolve true se creditou.
local function CreditBank(citizenid, moneyJson, amount, reason)
    local receiver = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if receiver then
        return receiver.Functions.AddMoney('bank', amount, reason) ~= false, receiver
    end
    local moneyInfo = json.decode(moneyJson or '{}') or {}
    moneyInfo.bank = QBCore.Shared.Round((tonumber(moneyInfo.bank) or 0) + amount)
    local affected = MySQL.update.await('UPDATE players SET money = ? WHERE citizenid = ?', { json.encode(moneyInfo), citizenid })
    return (tonumber(affected) or 0) > 0
end

CreateThread(function()
    -- Allow gallery to store data URLs when camera fallback is used without webhook uploads.
    local ok, err = pcall(function()
        MySQL.query.await('ALTER TABLE phone_gallery MODIFY COLUMN image LONGTEXT NOT NULL')
    end)

    if not ok then
        print('^1[qb-phone] Failed to migrate phone_gallery.image to LONGTEXT: ' .. tostring(err) .. '^7')
    end
end)

-- Functions

local function GetOnlineStatus(number)
    local Target = QBCore.Functions.GetPlayerByPhone(number)
    local retval = false
    if Target ~= nil then
        retval = true
    end
    return retval
end

local function GenerateMailId()
    return math.random(111111, 999999)
end

-- Pesquisas do MDT (app 'meos'): limites do input. Evitam pesquisas vazias
-- (que devolviam todos os registos) e queries enormes (um LIKE por termo).
local SEARCH_MIN_LEN = 2
local SEARCH_MAX_LEN = 50
local SEARCH_MAX_TERMS = 5

-- O job vem do servidor (source do callback), nunca do cliente. A app só
-- aparece à polícia, mas qualquer cliente pode chamar o callback diretamente.
local function IsPolice(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player ~= nil and Player.PlayerData.job.name == 'police'
end

-- Devolve a pesquisa limpa, ou nil se for inválida.
local function SanitizeSearch(search)
    if type(search) ~= 'string' then return nil end
    search = search:gsub('^%s+', ''):gsub('%s+$', '')
    if #search < SEARCH_MIN_LEN or #search > SEARCH_MAX_LEN then return nil end
    return search
end

-- Escapa os wildcards do LIKE (\ % _) para o input ser texto literal.
-- Sem isto, pesquisar '%' devolvia todos os registos.
local function EscapeLike(value)
    return (value:gsub('[\\%%_]', '\\%0'))
end

function QBPhone.AddMentionedTweet(citizenid, TweetData)
    if MentionedTweets[citizenid] == nil then
        MentionedTweets[citizenid] = {}
    end
    MentionedTweets[citizenid][#MentionedTweets[citizenid] + 1] = TweetData
end

function QBPhone.SetPhoneAlerts(citizenid, app, alerts)
    if citizenid ~= nil and app ~= nil then
        if AppAlerts[citizenid] == nil then
            AppAlerts[citizenid] = {}
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = alerts
                end
            end
        else
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = 0
                end
            else
                if alerts == nil then
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 1
                else
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 0
                end
            end
        end
    end
end

local function SplitStringToArray(string)
    local retval = {}
    for i in string.gmatch(string, '%S+') do
        retval[#retval + 1] = i
    end
    return retval
end

local function GenerateOwnerName()
    local names = {
        [1] = { name = 'Bailey Sykes', citizenid = 'DSH091G93' },
        [2] = { name = 'Aroush Goodwin', citizenid = 'AVH09M193' },
        [3] = { name = 'Tom Warren', citizenid = 'DVH091T93' },
        [4] = { name = 'Abdallah Friedman', citizenid = 'GZP091G93' },
        [5] = { name = 'Lavinia Powell', citizenid = 'DRH09Z193' },
        [6] = { name = 'Andrew Delarosa', citizenid = 'KGV091J93' },
        [7] = { name = 'Skye Cardenas', citizenid = 'ODF09S193' },
        [8] = { name = 'Amelia-Mae Walter', citizenid = 'KSD0919H3' },
        [9] = { name = 'Elisha Cote', citizenid = 'NDX091D93' },
        [10] = { name = 'Janice Rhodes', citizenid = 'ZAL0919X3' },
        [11] = { name = 'Justin Harris', citizenid = 'ZAK09D193' },
        [12] = { name = 'Montel Graves', citizenid = 'POL09F193' },
        [13] = { name = 'Benjamin Zavala', citizenid = 'TEW0J9193' },
        [14] = { name = 'Mia Willis', citizenid = 'YOO09H193' },
        [15] = { name = 'Jacques Schmitt', citizenid = 'QBC091H93' },
        [16] = { name = 'Mert Simmonds', citizenid = 'YDN091H93' },
        [17] = { name = 'Rickie Browne', citizenid = 'PJD09D193' },
        [18] = { name = 'Deacon Stanley', citizenid = 'RND091D93' },
        [19] = { name = 'Daisy Fraser', citizenid = 'QWE091A93' },
        [20] = { name = 'Kitty Walters', citizenid = 'KJH0919M3' },
        [21] = { name = 'Jareth Fernandez', citizenid = 'ZXC09D193' },
        [22] = { name = 'Meredith Calhoun', citizenid = 'XYZ0919C3' },
        [23] = { name = 'Teagan Mckay', citizenid = 'ZYX0919F3' },
        [24] = { name = 'Kurt Bain', citizenid = 'IOP091O93' },
        [25] = { name = 'Burt Kain', citizenid = 'PIO091R93' },
        [26] = { name = 'Joanna Huff', citizenid = 'LEK091X93' },
        [27] = { name = 'Carrie-Ann Pineda', citizenid = 'ALG091Y93' },
        [28] = { name = 'Gracie-Mai Mcghee', citizenid = 'YUR09E193' },
        [29] = { name = 'Robyn Boone', citizenid = 'SOM091W93' },
        [30] = { name = 'Aliya William', citizenid = 'KAS009193' },
        [31] = { name = 'Rohit West', citizenid = 'SOK091093' },
        [32] = { name = 'Skylar Archer', citizenid = 'LOK091093' },
        [33] = { name = 'Jake Kumar', citizenid = 'AKA420609' },
    }
    return names[math.random(1, #names)]
end


local function sendNewMailToOffline(citizenid, mailData)
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if Player then
        local src = Player.PlayerData.source
        if mailData.button == nil then
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', { Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0 })
            TriggerClientEvent('qb-phone:client:NewMailNotify', src, mailData)
        else
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', { Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button) })
            TriggerClientEvent('qb-phone:client:NewMailNotify', src, mailData)
        end
        SetTimeout(200, function()
            local mails = MySQL.query.await(
                'SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', { Player.PlayerData.citizenid })
            if mails[1] ~= nil then
                for k, _ in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end

            TriggerClientEvent('qb-phone:client:UpdateMails', src, mails)
        end)
    else
        if mailData.button == nil then
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', { citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0 })
        else
            MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', { citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button) })
        end
    end
end
exports('sendNewMailToOffline', sendNewMailToOffline)

-- Mail de faturação para os funcionários de uma sociedade, enviado PELO
-- SERVIDOR. Antes era o cliente que disparava qb-phone:server:BillingEmail com
-- os dados dele (sociedade, valor e "pago/recusado"), por isso qualquer jogador
-- podia forjar faturas pagas a qualquer profissão. Agora só é chamado aqui,
-- depois de a transação ser confirmada, e com os valores que estão na BD.
local function SendBillingMailToSociety(society, subject, message)
    if type(society) ~= 'string' or society == '' then return end
    for _, playerId in pairs(QBCore.Functions.GetPlayers()) do
        local employee = QBCore.Functions.GetPlayer(playerId)
        if employee and employee.PlayerData.job.name == society then
            sendNewMailToOffline(employee.PlayerData.citizenid, {
                sender = 'Departamento de faturação',
                subject = subject,
                message = message,
            })
        end
    end
end
-- Callbacks

QBCore.Functions.CreateCallback("qb-phone:server:GetInvoices", function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)

    if Player then
        local invoices = MySQL.query.await('SELECT * FROM phone_invoices WHERE citizenid = ?', { Player.PlayerData.citizenid })
        for _, v in pairs(invoices) do
            local Ply = QBCore.Functions.GetPlayerByCitizenId(v.sender)
            if Ply ~= nil then
                v.number = Ply.PlayerData.charinfo.phone
            else
                local res = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', { v.sender })
                if res[1] ~= nil then
                    res[1].charinfo = json.decode(res[1].charinfo)
                    v.number = res[1].charinfo.phone
                else
                    v.number = nil
                end
            end
        end
        cb(invoices)
        return
    end

    cb({})
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetCallState', function(_, cb, ContactData)
    local Target = QBCore.Functions.GetPlayerByPhone(ContactData.number)
    if Target ~= nil then
        if Calls[Target.PlayerData.citizenid] ~= nil then
            if Calls[Target.PlayerData.citizenid].inCall then
                cb(false, true)
            else
                cb(true, true)
            end
        else
            cb(true, true)
        end
    else
        cb(false, false)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetPhoneData', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then
        local PhoneData = {
            Applications = {},
            PlayerContacts = {},
            MentionedTweets = {},
            Chats = {},
            Hashtags = {},
            Garage = {},
            Mails = {},
            Adverts = {},
            CryptoTransactions = {},
            Tweets = {},
            Images = {},
            InstalledApps = Player.PlayerData.metadata['phonedata'].InstalledApps
        }
        PhoneData.Adverts = Adverts

        local result = MySQL.query.await('SELECT * FROM player_contacts WHERE citizenid = ? ORDER BY name ASC', { Player.PlayerData.citizenid })
        if result[1] ~= nil then
            for _, v in pairs(result) do
                v.status = GetOnlineStatus(v.number)
            end

            PhoneData.PlayerContacts = result
        end

        local garageresult = MySQL.query.await('SELECT * FROM player_vehicles WHERE citizenid = ?', { Player.PlayerData.citizenid })
        if garageresult[1] ~= nil then
            PhoneData.Garage = garageresult
        end

        local messages = MySQL.query.await('SELECT * FROM phone_messages WHERE citizenid = ?', { Player.PlayerData.citizenid })
        if messages ~= nil and next(messages) ~= nil then
            PhoneData.Chats = messages
        end

        if AppAlerts[Player.PlayerData.citizenid] ~= nil then
            PhoneData.Applications = AppAlerts[Player.PlayerData.citizenid]
        end

        if MentionedTweets[Player.PlayerData.citizenid] ~= nil then
            PhoneData.MentionedTweets = MentionedTweets[Player.PlayerData.citizenid]
        end

        if Hashtags ~= nil and next(Hashtags) ~= nil then
            PhoneData.Hashtags = Hashtags
        end

        local Tweets = MySQL.query.await('SELECT * FROM phone_tweets WHERE `date` > NOW() - INTERVAL ? hour', { Config.TweetDuration })

        if Tweets ~= nil and next(Tweets) ~= nil then
            PhoneData.Tweets = Tweets
            TWData = Tweets
        end

        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', { Player.PlayerData.citizenid })
        if mails[1] ~= nil then
            for k, _ in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
            PhoneData.Mails = mails
        end

        local transactions = MySQL.query.await('SELECT * FROM crypto_transactions WHERE citizenid = ? ORDER BY `date` ASC', { Player.PlayerData.citizenid })
        if transactions[1] ~= nil then
            for _, v in pairs(transactions) do
                PhoneData.CryptoTransactions[#PhoneData.CryptoTransactions + 1] = {
                    TransactionTitle = v.title,
                    TransactionMessage = v.message
                }
            end
        end
        local images = MySQL.query.await('SELECT * FROM phone_gallery WHERE citizenid = ? ORDER BY `date` DESC', { Player.PlayerData.citizenid })
        if images ~= nil and next(images) ~= nil then
            PhoneData.Images = images
        end
        cb(PhoneData)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:PayInvoice', function(source, cb, _, _, invoiceId, _)
    -- Valor, sociedade e destinatário da comissão vêm SEMPRE da fatura na BD;
    -- os valores equivalentes enviados pelo cliente são ignorados. Qualquer
    -- falha devolve false, tal como "fatura não encontrada".
    local Ply = QBCore.Functions.GetPlayer(source)
    invoiceId = tonumber(invoiceId)
    if not Ply or not invoiceId or invoiceId % 1 ~= 0 or invoiceId <= 0 then return cb(false) end
    local cid = Ply.PlayerData.citizenid

    -- Só faturas do próprio pagador (citizenid vem do source).
    local rows = MySQL.query.await('SELECT amount, society, sendercitizenid FROM phone_invoices WHERE id = ? AND citizenid = ?', { invoiceId, cid })
    local invoice = rows and rows[1]
    if not invoice then return cb(false) end
    local amount = tonumber(invoice.amount)
    if not amount or amount <= 0 then return cb(false) end

    -- 1) Débito primeiro. Se falhar, nada mais acontece (sem comissão) e a fatura fica.
    if Ply.PlayerData.money.bank < amount or not Ply.Functions.RemoveMoney('bank', amount, 'paid-invoice') then
        return cb(false)
    end
    -- 2) Apagar a fatura só se ainda existir: com dois pedidos em simultâneo, só
    --    um a apaga; o outro é reembolsado. Impede pagar/comissionar duas vezes.
    local deleted = MySQL.update.await('DELETE FROM phone_invoices WHERE id = ? AND citizenid = ?', { invoiceId, cid })
    if (tonumber(deleted) or 0) < 1 then
        Ply.Functions.AddMoney('bank', amount, 'paid-invoice-refund')
        return cb(false)
    end

    -- 3) Só agora: comissão, depósito na sociedade e mail.
    local society = invoice.society
    local sendercitizenid = invoice.sendercitizenid
    local rate = society and Config.BillingCommissions[society]
    local invoiceMailData = nil
    if rate then
        local SenderPly = sendercitizenid and QBCore.Functions.GetPlayerByCitizenId(sendercitizenid)
        if SenderPly then
            local commission = QBCore.Shared.Round(amount * rate)
            SenderPly.Functions.AddMoney('bank', commission)
            invoiceMailData = {
                sender = 'Departamento de faturação',
                subject = 'Comissão recebida',
                message = string.format('Recebeste uma comissão de $%s quando %s %s pagou uma fatura de $%s.', commission, Ply.PlayerData.charinfo.firstname, Ply.PlayerData.charinfo.lastname, amount)
            }
        else
            invoiceMailData = {
                sender = 'Departamento de faturação',
                subject = 'Fatura paga',
                message = string.format('%s %s pagou uma fatura de $%s', Ply.PlayerData.charinfo.firstname, Ply.PlayerData.charinfo.lastname, amount)
            }
        end
    end
    if invoiceMailData and sendercitizenid then
        exports['qb-phone']:sendNewMailToOffline(sendercitizenid, invoiceMailData)
    end
    TriggerEvent("qb-phone:server:paidInvoice", source, invoiceId)
    if society then
        exports['qb-banking']:AddMoney(society, amount, 'Fatura por telemóvel')
    end
    SendBillingMailToSociety(society, 'Fatura paga', string.format('A fatura foi paga por %s %s no valor de $%s',
        Ply.PlayerData.charinfo.firstname, Ply.PlayerData.charinfo.lastname, amount))
    cb(true)
end)

QBCore.Functions.CreateCallback('qb-phone:server:DeclineInvoice', function(source, cb, _, _, invoiceId)
    -- Sociedade e valor vêm da fatura na BD; os enviados pelo cliente são
    -- ignorados. Qualquer falha devolve false, tal como "fatura não encontrada".
    local Ply = QBCore.Functions.GetPlayer(source)
    invoiceId = tonumber(invoiceId)
    if not Ply or not invoiceId or invoiceId % 1 ~= 0 or invoiceId <= 0 then return cb(false) end
    local cid = Ply.PlayerData.citizenid

    -- Só faturas do próprio e que possam ser recusadas.
    local rows = MySQL.query.await('SELECT amount, society FROM phone_invoices WHERE id = ? AND citizenid = ? AND candecline = ?', { invoiceId, cid, 1 })
    local invoice = rows and rows[1]
    if not invoice then return cb(false) end

    -- Apagar só se ainda existir: dois pedidos em simultâneo só recusam uma vez.
    local deleted = MySQL.update.await('DELETE FROM phone_invoices WHERE id = ? AND citizenid = ? AND candecline = ?', { invoiceId, cid, 1 })
    if (tonumber(deleted) or 0) < 1 then return cb(false) end

    TriggerEvent("qb-phone:server:declinedInvoice", source, invoiceId)
    SendBillingMailToSociety(invoice.society, 'Fatura recusada', string.format('A fatura foi recusada por %s %s no valor de $%s',
        Ply.PlayerData.charinfo.firstname, Ply.PlayerData.charinfo.lastname, invoice.amount))
    cb(true)
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetContactPictures', function(_, cb, Chats)
    for _, v in pairs(Chats) do
        local query = '%' .. v.number .. '%'
        local result = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ?', { query })
        if result[1] ~= nil then
            local MetaData = json.decode(result[1].metadata)

            if MetaData.phone.profilepicture ~= nil then
                v.picture = MetaData.phone.profilepicture
            else
                v.picture = 'default'
            end
        end
    end
    SetTimeout(100, function()
        cb(Chats)
    end)
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetContactPicture', function(_, cb, Chat)
    local query = '%' .. Chat.number .. '%'
    local result = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ?', { query })
    local MetaData = json.decode(result[1].metadata)
    if MetaData.phone.profilepicture ~= nil then
        Chat.picture = MetaData.phone.profilepicture
    else
        Chat.picture = 'default'
    end
    SetTimeout(100, function()
        cb(Chat)
    end)
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetPicture', function(_, cb, number)
    local query = '%' .. number .. '%'
    local result = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ?', { query })
    if result[1] ~= nil then
        local Picture = 'default'
        local MetaData = json.decode(result[1].metadata)
        if MetaData.phone.profilepicture ~= nil then
            Picture = MetaData.phone.profilepicture
        end
        cb(Picture)
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:FetchResult', function(source, cb, search)
    -- Sem autorização ou com input inválido devolve vazio, tal como "sem
    -- resultados", para não revelar se o registo existe.
    if not IsPolice(source) then return cb(nil) end
    search = SanitizeSearch(search)
    if not search then return cb(nil) end
    -- Split on " " and check each var individual
    local searchParameters = SplitStringToArray(search)
    if #searchParameters > SEARCH_MAX_TERMS then return cb(nil) end

    local searchData = {}
    local ApaData = {}
    -- Queries parameterizadas (?): o input do cliente nunca toca no SQL como texto.
    local query = 'SELECT * FROM `players` WHERE `citizenid` = ?'
    local params = { search }
    -- Construct query dynamicly for individual parm check (cada termo = 1 bind)
    if #searchParameters > 1 then
        query = query .. ' OR `charinfo` LIKE ?'
        params[#params + 1] = '%' .. EscapeLike(searchParameters[1]) .. '%'
        for i = 2, #searchParameters do
            query = query .. ' AND `charinfo` LIKE ?'
            params[#params + 1] = '%' .. EscapeLike(searchParameters[i]) .. '%'
        end
    else
        query = query .. ' OR `charinfo` LIKE ?'
        params[#params + 1] = '%' .. EscapeLike(search) .. '%'
    end
    local ApartmentData = MySQL.query.await('SELECT * FROM apartments', {})
    for k, v in pairs(ApartmentData) do
        ApaData[v.citizenid] = ApartmentData[k]
    end
    local result = MySQL.query.await(query, params)
    if result[1] ~= nil then
        for _, v in pairs(result) do
            local charinfo = json.decode(v.charinfo)
            local metadata = json.decode(v.metadata)
            local appiepappie = {}
            if ApaData[v.citizenid] ~= nil and next(ApaData[v.citizenid]) ~= nil then
                appiepappie = ApaData[v.citizenid]
            end
            searchData[#searchData + 1] = {
                citizenid = v.citizenid,
                firstname = charinfo.firstname,
                lastname = charinfo.lastname,
                birthdate = charinfo.birthdate,
                phone = charinfo.phone,
                nationality = charinfo.nationality,
                gender = charinfo.gender,
                warrant = false,
                driverlicense = metadata['licences']['driver'],
                appartmentdata = appiepappie
            }
        end
        cb(searchData)
    else
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetVehicleSearchResults', function(source, cb, search)
    -- Mesmas regras do FetchResult: só polícia, input validado, vazio caso contrário.
    if not IsPolice(source) then return cb(nil) end
    search = SanitizeSearch(search)
    if not search then return cb(nil) end

    local searchData = {}
    local query = '%' .. EscapeLike(search) .. '%'
    local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate LIKE ? OR citizenid = ?',
        { query, search })
    if result[1] ~= nil then
        for k, _ in pairs(result) do
            local player = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', { result[k].citizenid })
            if player[1] ~= nil then
                local charinfo = json.decode(player[1].charinfo)
                local vehicleInfo = QBCore.Shared.Vehicles[result[k].vehicle]
                if vehicleInfo ~= nil then
                    searchData[#searchData + 1] = {
                        plate = result[k].plate,
                        status = true,
                        owner = charinfo.firstname .. ' ' .. charinfo.lastname,
                        citizenid = result[k].citizenid,
                        label = vehicleInfo['name']
                    }
                else
                    searchData[#searchData + 1] = {
                        plate = result[k].plate,
                        status = true,
                        owner = charinfo.firstname .. ' ' .. charinfo.lastname,
                        citizenid = result[k].citizenid,
                        label = 'Nome não encontrado..'
                    }
                end
            end
        end
    else
        if GeneratedPlates[search] ~= nil then
            searchData[#searchData + 1] = {
                plate = GeneratedPlates[search].plate,
                status = GeneratedPlates[search].status,
                owner = GeneratedPlates[search].owner,
                citizenid = GeneratedPlates[search].citizenid,
                label = 'Marca desconhecida..'
            }
        else
            local ownerInfo = GenerateOwnerName()
            GeneratedPlates[search] = {
                plate = search,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid
            }
            searchData[#searchData + 1] = {
                plate = search,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid,
                label = 'Marca desconhecida..'
            }
        end
    end
    cb(searchData)
end)

QBCore.Functions.CreateCallback('qb-phone:server:ScanPlate', function(source, cb, plate)
    local src = source
    local vehicleData
    if plate ~= nil then
        local result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?', { plate })
        if result[1] ~= nil then
            local player = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', { result[1].citizenid })
            local charinfo = json.decode(player[1].charinfo)
            vehicleData = {
                plate = plate,
                status = true,
                owner = charinfo.firstname .. ' ' .. charinfo.lastname,
                citizenid = result[1].citizenid
            }
        elseif GeneratedPlates ~= nil and GeneratedPlates[plate] ~= nil then
            vehicleData = GeneratedPlates[plate]
        else
            local ownerInfo = GenerateOwnerName()
            GeneratedPlates[plate] = {
                plate = plate,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid
            }
            vehicleData = {
                plate = plate,
                status = true,
                owner = ownerInfo.name,
                citizenid = ownerInfo.citizenid
            }
        end
        cb(vehicleData)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Nenhum veículo por perto', 'error')
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:HasPhone', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local HasPhone = Player.Functions.GetItemByName('phone')
        if HasPhone ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:CanTransferMoney', function(source, cb, amount, iban)
    -- Qualquer falha devolve false, tal como "a conta não existe".
    local Player = QBCore.Functions.GetPlayer(source)
    amount = ValidateMoneyAmount(amount) -- rejeita negativos, zero, NaN e não-inteiros
    iban = ValidateIban(iban)
    if not Player or not amount or not iban then return cb(false) end
    if Player.PlayerData.money.bank < amount then return cb(false) end

    local target = FindPlayerByAccount(iban)
    if not target or target.citizenid == Player.PlayerData.citizenid then return cb(false) end

    -- Débito antes do crédito; se não der para creditar, reembolsa.
    if not Player.Functions.RemoveMoney('bank', amount, 'phone-transfered-to-' .. target.citizenid) then return cb(false) end
    if not CreditBank(target.citizenid, target.money, amount, 'phone-transfered-from-' .. Player.PlayerData.citizenid) then
        Player.Functions.AddMoney('bank', amount, 'phone-transfer-refund')
        return cb(false)
    end
    cb(true)
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetCurrentLawyers', function(_, cb)
    local Lawyers = {}
    for _, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == 'lawyer' or Player.PlayerData.job.name == 'realestate' or
                    Player.PlayerData.job.name == 'mechanic' or Player.PlayerData.job.name == 'taxi' or
                    Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance') and
                Player.PlayerData.job.onduty then
                Lawyers[#Lawyers + 1] = {
                    name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
                    phone = Player.PlayerData.charinfo.phone,
                    typejob = Player.PlayerData.job.name
                }
            end
        end
    end
    cb(Lawyers)
end)

QBCore.Functions.CreateCallback('qb-phone:server:GetWebhook', function(_, cb)
    if WebHook ~= '' then
        cb(WebHook)
    else
        print('Set your webhook to ensure that your camera will work!!!!!! Set this on line 9 of the server sided script!!!!!')
        cb(nil)
    end
end)

QBCore.Functions.CreateCallback('qb-phone:server:UploadToFivemerr', function(source, cb)
    local src = source

    if Config.Fivemerr == true and FivemerrApiToken == '' then
        print("^1--- Fivemerr is enabled but no API token has been specified. ---^7")
        return cb(nil)
    end

    exports['screenshot-basic']:requestClientScreenshot(src, {
        encoding = 'png'
    }, function(err, data)
        if err then return cb(nil) end
        PerformHttpRequest(WebHook, function(status, response)
            if status ~= 200 then
                print("^1--- ERROR UPLOADING IMAGE: " .. status .. " ---^7")
                cb(nil)
            end

            cb(response)
        end, "POST", json.encode({ data = data }), {
            ['Authorization'] = FivemerrApiToken,
            ['Content-Type'] = 'application/json'
        })
    end)
end)

-- Events

RegisterNetEvent('qb-phone:server:AddAdvert', function(msg, url)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    if Adverts[CitizenId] ~= nil then
        Adverts[CitizenId].message = msg
        Adverts[CitizenId].name = '@' .. Player.PlayerData.charinfo.firstname .. '' .. Player.PlayerData.charinfo.lastname
        Adverts[CitizenId].number = Player.PlayerData.charinfo.phone
        Adverts[CitizenId].url = url
    else
        Adverts[CitizenId] = {
            message = msg,
            name = '@' .. Player.PlayerData.charinfo.firstname .. '' .. Player.PlayerData.charinfo.lastname,
            number = Player.PlayerData.charinfo.phone,
            url = url
        }
    end
    TriggerClientEvent('qb-phone:client:UpdateAdverts', -1, Adverts, '@' .. Player.PlayerData.charinfo.firstname .. '' .. Player.PlayerData.charinfo.lastname)
end)

RegisterNetEvent('qb-phone:server:DeleteAdvert', function()
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    Adverts[citizenid] = nil
    TriggerClientEvent('qb-phone:client:UpdateAdvertsDel', -1, Adverts)
end)

RegisterNetEvent('qb-phone:server:SetCallState', function(bool)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    if Calls[Ply.PlayerData.citizenid] ~= nil then
        Calls[Ply.PlayerData.citizenid].inCall = bool
    else
        Calls[Ply.PlayerData.citizenid] = {}
        Calls[Ply.PlayerData.citizenid].inCall = bool
    end
end)

RegisterNetEvent('qb-phone:server:RemoveMail', function(MailId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.query('DELETE FROM player_mails WHERE mailid = ? AND citizenid = ?', { MailId, Player.PlayerData.citizenid })
    SetTimeout(100, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', { Player.PlayerData.citizenid })
        if mails[1] ~= nil then
            for k, _ in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end
        TriggerClientEvent('qb-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterNetEvent('qb-phone:server:sendNewMail', function(mailData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if mailData.button == nil then
        MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', { Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0 })
    else
        MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', { Player.PlayerData.citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button) })
    end
    TriggerClientEvent('qb-phone:client:NewMailNotify', src, mailData)
    SetTimeout(200, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` DESC',
            { Player.PlayerData.citizenid })
        if mails[1] ~= nil then
            for k, _ in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end

        TriggerClientEvent('qb-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterNetEvent('qb-phone:server:sendNewEventMail', function(citizenid, mailData)
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if mailData.button == nil then
        MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES (?, ?, ?, ?, ?, ?)', { citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0 })
    else
        MySQL.insert('INSERT INTO player_mails (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES (?, ?, ?, ?, ?, ?, ?)', { citizenid, mailData.sender, mailData.subject, mailData.message, GenerateMailId(), 0, json.encode(mailData.button) })
    end
    SetTimeout(200, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', { citizenid })
        if mails[1] ~= nil then
            for k, _ in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end
        TriggerClientEvent('qb-phone:client:UpdateMails', Player.PlayerData.source, mails)
    end)
end)

RegisterNetEvent('qb-phone:server:ClearButtonData', function(mailId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.update('UPDATE player_mails SET button = ? WHERE mailid = ? AND citizenid = ?', { '', mailId, Player.PlayerData.citizenid })
    SetTimeout(200, function()
        local mails = MySQL.query.await('SELECT * FROM player_mails WHERE citizenid = ? ORDER BY `date` ASC', { Player.PlayerData.citizenid })
        if mails[1] ~= nil then
            for k, _ in pairs(mails) do
                if mails[k].button ~= nil then
                    mails[k].button = json.decode(mails[k].button)
                end
            end
        end
        TriggerClientEvent('qb-phone:client:UpdateMails', src, mails)
    end)
end)

RegisterNetEvent('qb-phone:server:MentionedPlayer', function(firstName, lastName, TweetMessage)
    for _, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.charinfo.firstname == firstName and Player.PlayerData.charinfo.lastname == lastName) then
                QBPhone.SetPhoneAlerts(Player.PlayerData.citizenid, 'twitter')
                QBPhone.AddMentionedTweet(Player.PlayerData.citizenid, TweetMessage)
                TriggerClientEvent('qb-phone:client:GetMentioned', Player.PlayerData.source, TweetMessage, AppAlerts[Player.PlayerData.citizenid]['twitter'])
            else
                local query1 = '%' .. firstName .. '%'
                local query2 = '%' .. lastName .. '%'
                local result = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ? AND charinfo LIKE ?', { query1, query2 })
                if result[1] ~= nil then
                    local MentionedTarget = result[1].citizenid
                    QBPhone.SetPhoneAlerts(MentionedTarget, 'twitter')
                    QBPhone.AddMentionedTweet(MentionedTarget, TweetMessage)
                end
            end
        end
    end
end)

RegisterNetEvent('qb-phone:server:CallContact', function(TargetData, CallId, AnonymousCall)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayerByPhone(TargetData.number)
    if Target ~= nil then
        TriggerClientEvent('qb-phone:client:GetCalled', Target.PlayerData.source, Ply.PlayerData.charinfo.phone, CallId, AnonymousCall)
    end
end)

-- qb-phone:server:BillingEmail foi removido: o mail de faturação passou a ser
-- enviado pelo servidor em PayInvoice/DeclineInvoice (SendBillingMailToSociety).

RegisterNetEvent('qb-phone:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        Hashtags[Handle].messages[#Hashtags[Handle].messages + 1] = messageData
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        Hashtags[Handle].messages[#Hashtags[Handle].messages + 1] = messageData
    end
    TriggerClientEvent('qb-phone:client:UpdateHashtags', -1, Handle, messageData)
end)

RegisterNetEvent('qb-phone:server:SetPhoneAlerts', function(app, alerts)
    local src = source
    local CitizenId = QBCore.Functions.GetPlayer(src).citizenid
    QBPhone.SetPhoneAlerts(CitizenId, app, alerts)
end)

RegisterNetEvent('qb-phone:server:DeleteTweet', function(tweetId)
    local Player = QBCore.Functions.GetPlayer(source)
    local delete = false
    local TID = tweetId
    local Data = MySQL.scalar.await('SELECT citizenid FROM phone_tweets WHERE tweetId = ?', { TID })
    if Data == Player.PlayerData.citizenid then
        MySQL.query.await('DELETE FROM phone_tweets WHERE tweetId = ?', { TID })
        delete = true
    end

    if delete then
        for k, _ in pairs(TWData) do
            if TWData[k].tweetId == TID then
                TWData = nil
            end
        end
        TriggerClientEvent('qb-phone:client:UpdateTweets', -1, TWData, nil, true)
    end
end)

RegisterNetEvent('qb-phone:server:UpdateTweets', function(NewTweets, TweetData)
    local src = source

    MySQL.insert('INSERT INTO phone_tweets (citizenid, firstName, lastName, message, date, url, picture, tweetid) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        TweetData.citizenid,
        TweetData.firstName,
        TweetData.lastName,
        TweetData.message,
        TweetData.time,
        TweetData.url:gsub('[%<>\"()\' $]', ''),
        TweetData.picture:gsub('[%<>\"()\' $]', ''),
        TweetData.tweetId
    })
    TriggerClientEvent('qb-phone:client:UpdateTweets', -1, src, NewTweets, TweetData, false)
end)

RegisterNetEvent('qb-phone:server:TransferMoney', function(iban, amount)
    -- O emissor é sempre o source (o cliente não indica emissor). Ordem:
    -- validar -> saldo -> destinatário -> DEBITAR -> creditar (com reembolso).
    local src = source
    local sender = QBCore.Functions.GetPlayer(src)
    if not sender then return end

    amount = ValidateMoneyAmount(amount)
    if not amount then
        return TriggerClientEvent('QBCore:Notify', src, 'Valor de transferência inválido.', 'error')
    end
    -- Saldo antes de procurar a conta, para não revelar se a conta existe.
    if sender.PlayerData.money.bank < amount then
        return TriggerClientEvent('QBCore:Notify', src, 'Saldo insuficiente.', 'error')
    end

    iban = ValidateIban(iban)
    local target = iban and FindPlayerByAccount(iban)
    if not target or target.citizenid == sender.PlayerData.citizenid then
        return TriggerClientEvent('QBCore:Notify', src, 'Este número de conta não existe!', 'error')
    end

    if not sender.Functions.RemoveMoney('bank', amount, 'phone-transfered-to-' .. target.citizenid) then
        return TriggerClientEvent('QBCore:Notify', src, 'Saldo insuficiente.', 'error')
    end

    local credited, reciever = CreditBank(target.citizenid, target.money, amount, 'phone-transfered-from-' .. sender.PlayerData.citizenid)
    if not credited then
        -- Não foi possível creditar: devolve ao emissor.
        sender.Functions.AddMoney('bank', amount, 'phone-transfer-refund')
        return TriggerClientEvent('QBCore:Notify', src, 'Transferência falhou. O valor foi devolvido.', 'error')
    end

    if reciever and reciever.Functions.GetItemByName('phone') then
        TriggerClientEvent('qb-phone:client:TransferMoney', reciever.PlayerData.source, amount, reciever.PlayerData.money.bank)
    end
end)

RegisterNetEvent('qb-phone:server:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, _)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.update(
        'UPDATE player_contacts SET name = ?, number = ?, iban = ? WHERE citizenid = ? AND name = ? AND number = ?',
        { newName, newNumber, newIban, Player.PlayerData.citizenid, oldName, oldNumber })
end)

RegisterNetEvent('qb-phone:server:RemoveContact', function(Name, Number)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.query('DELETE FROM player_contacts WHERE name = ? AND number = ? AND citizenid = ?',
        { Name, Number, Player.PlayerData.citizenid })
end)

RegisterNetEvent('qb-phone:server:AddNewContact', function(name, number, iban)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.insert('INSERT INTO player_contacts (citizenid, name, number, iban) VALUES (?, ?, ?, ?)', { Player.PlayerData.citizenid, tostring(name), tostring(number), tostring(iban) })
end)

RegisterNetEvent('qb-phone:server:UpdateMessages', function(ChatMessages, ChatNumber, _)
    local src = source
    local SenderData = QBCore.Functions.GetPlayer(src)
    local query = '%' .. ChatNumber .. '%'
    local Player = MySQL.query.await('SELECT * FROM players WHERE charinfo LIKE ?', { query })
    if Player[1] ~= nil then
        local TargetData = QBCore.Functions.GetPlayerByCitizenId(Player[1].citizenid)
        if TargetData ~= nil then
            local Chat = MySQL.query.await('SELECT * FROM phone_messages WHERE citizenid = ? AND number = ?', { SenderData.PlayerData.citizenid, ChatNumber })
            if Chat[1] ~= nil then
                -- Update for target
                MySQL.update('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', { json.encode(ChatMessages), TargetData.PlayerData.citizenid, SenderData.PlayerData.charinfo.phone })
                -- Update for sender
                MySQL.update('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', { json.encode(ChatMessages), SenderData.PlayerData.citizenid, TargetData.PlayerData.charinfo.phone })
                -- Send notification & Update messages for target
                TriggerClientEvent('qb-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, false)
            else
                -- Insert for target
                MySQL.insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', { TargetData.PlayerData.citizenid, SenderData.PlayerData.charinfo.phone, json.encode(ChatMessages) })
                -- Insert for sender
                MySQL.insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', { SenderData.PlayerData.citizenid, TargetData.PlayerData.charinfo.phone, json.encode(ChatMessages) })
                -- Send notification & Update messages for target
                TriggerClientEvent('qb-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, true)
            end
        else
            local Chat = MySQL.query.await('SELECT * FROM phone_messages WHERE citizenid = ? AND number = ?', { SenderData.PlayerData.citizenid, ChatNumber })
            if Chat[1] ~= nil then
                -- Update for target
                MySQL.update('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', { json.encode(ChatMessages), Player[1].citizenid, SenderData.PlayerData.charinfo.phone })
                -- Update for sender
                Player[1].charinfo = json.decode(Player[1].charinfo)
                MySQL.update('UPDATE phone_messages SET messages = ? WHERE citizenid = ? AND number = ?', { json.encode(ChatMessages), SenderData.PlayerData.citizenid, Player[1].charinfo.phone })
            else
                -- Insert for target
                MySQL.insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', { Player[1].citizenid, SenderData.PlayerData.charinfo.phone, json.encode(ChatMessages) })
                -- Insert for sender
                Player[1].charinfo = json.decode(Player[1].charinfo)
                MySQL.insert('INSERT INTO phone_messages (citizenid, number, messages) VALUES (?, ?, ?)', { SenderData.PlayerData.citizenid, Player[1].charinfo.phone, json.encode(ChatMessages) })
            end
        end
    end
end)

RegisterNetEvent('qb-phone:server:AddRecentCall', function(type, data)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local Hour = os.date('%H')
    local Minute = os.date('%M')
    local label = Hour .. ':' .. Minute
    TriggerClientEvent('qb-phone:client:AddRecentCall', src, data, label, type)
    local Trgt = QBCore.Functions.GetPlayerByPhone(data.number)
    if Trgt ~= nil then
        TriggerClientEvent('qb-phone:client:AddRecentCall', Trgt.PlayerData.source, {
            name = Ply.PlayerData.charinfo.firstname .. ' ' .. Ply.PlayerData.charinfo.lastname,
            number = Ply.PlayerData.charinfo.phone,
            anonymous = data.anonymous
        }, label, 'outgoing')
    end
end)

RegisterNetEvent('qb-phone:server:CancelCall', function(ContactData)
    local Ply = QBCore.Functions.GetPlayerByPhone(ContactData.TargetData.number)
    if Ply ~= nil then
        TriggerClientEvent('qb-phone:client:CancelCall', Ply.PlayerData.source)
    end
end)

RegisterNetEvent('qb-phone:server:AnswerCall', function(CallData)
    local Ply = QBCore.Functions.GetPlayerByPhone(CallData.TargetData.number)
    if Ply ~= nil then
        TriggerClientEvent('qb-phone:client:AnswerCall', Ply.PlayerData.source)
    end
end)

RegisterNetEvent('qb-phone:server:SaveMetaData', function(MData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', { Player.PlayerData.citizenid })
    local MetaData = json.decode(result[1].metadata)
    MetaData.phone = MData
    MySQL.update('UPDATE players SET metadata = ? WHERE citizenid = ?',
        { json.encode(MetaData), Player.PlayerData.citizenid })
    Player.Functions.SetMetaData('phone', MData)
end)

RegisterNetEvent('qb-phone:server:GiveContactDetails', function(PlayerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local SuggestionData = {
        name = {
            [1] = Player.PlayerData.charinfo.firstname,
            [2] = Player.PlayerData.charinfo.lastname
        },
        number = Player.PlayerData.charinfo.phone,
        bank = Player.PlayerData.charinfo.account
    }

    TriggerClientEvent('qb-phone:client:AddNewSuggestion', PlayerId, SuggestionData)
end)

RegisterNetEvent('qb-phone:server:AddTransaction', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.insert('INSERT INTO crypto_transactions (citizenid, title, message) VALUES (?, ?, ?)', {
        Player.PlayerData.citizenid,
        data.TransactionTitle,
        data.TransactionMessage
    })
end)

RegisterNetEvent('qb-phone:server:InstallApplication', function(ApplicationData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.PlayerData.metadata['phonedata'].InstalledApps[ApplicationData.app] = ApplicationData
    Player.Functions.SetMetaData('phonedata', Player.PlayerData.metadata['phonedata'])

    -- TriggerClientEvent('qb-phone:RefreshPhone', src)
end)

RegisterNetEvent('qb-phone:server:RemoveInstallation', function(App)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.PlayerData.metadata['phonedata'].InstalledApps[App] = nil
    Player.Functions.SetMetaData('phonedata', Player.PlayerData.metadata['phonedata'])

    -- TriggerClientEvent('qb-phone:RefreshPhone', src)
end)

RegisterNetEvent('qb-phone:server:addImageToGallery', function(image)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not image or image == '' then return end

    local ok, err = pcall(function()
        MySQL.insert.await('INSERT INTO phone_gallery (`citizenid`, `image`) VALUES (?, ?)', { Player.PlayerData.citizenid, image })
    end)

    if not ok then
        print('^1[qb-phone] Failed to save gallery image for ' .. tostring(Player.PlayerData.citizenid) .. ': ' .. tostring(err) .. '^7')
    end
end)

RegisterNetEvent('qb-phone:server:getImageFromGallery', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local images = MySQL.query.await('SELECT * FROM phone_gallery WHERE citizenid = ? ORDER BY `date` DESC', { Player.PlayerData.citizenid })
    TriggerClientEvent('qb-phone:refreshImages', src, images)
end)

RegisterNetEvent('qb-phone:server:RemoveImageFromGallery', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local image = data.image
    MySQL.query('DELETE FROM phone_gallery WHERE citizenid = ? AND image = ?', { Player.PlayerData.citizenid, image })
end)

RegisterNetEvent('qb-phone:server:sendPing', function(data)
    local src = source
    if src == data then
        TriggerClientEvent('QBCore:Notify', src, 'You cannot ping yourself', 'error')
    end
end)

-- Command

QBCore.Commands.Add('setmetadata', 'Set Player Metadata (God Only)', {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if args[1] then
        if args[1] == 'trucker' then
            if args[2] then
                local newrep = Player.PlayerData.metadata['jobrep']
                newrep.trucker = tonumber(args[2])
                Player.Functions.SetMetaData('jobrep', newrep)
            end
        end
    end
end, 'god')

QBCore.Commands.Add('bill', 'Bill A Player', { { name = 'id', help = 'Player ID' }, { name = 'amount', help = 'Fine Amount' } }, false, function(source, args)
    local biller = QBCore.Functions.GetPlayer(source)
    local billed = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local amount = tonumber(args[2])
    if biller.PlayerData.job.name == 'police' or biller.PlayerData.job.name == 'ambulance' or biller.PlayerData.job.name == 'mechanic' then
        if billed ~= nil then
            if biller.PlayerData.citizenid ~= billed.PlayerData.citizenid then
                if amount and amount > 0 then
                    MySQL.insert(
                        'INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',
                        { billed.PlayerData.citizenid, amount, biller.PlayerData.job.name,
                            biller.PlayerData.charinfo.firstname, biller.PlayerData.citizenid })
                    TriggerClientEvent('qb-phone:RefreshPhone', billed.PlayerData.source)
                    TriggerClientEvent('QBCore:Notify', source, 'Invoice Successfully Sent', 'success')
                    TriggerClientEvent('QBCore:Notify', billed.PlayerData.source, 'New Invoice Received')
                else
                    TriggerClientEvent('QBCore:Notify', source, 'Must Be A Valid Amount Above 0', 'error')
                end
            else
                TriggerClientEvent('QBCore:Notify', source, 'You Cannot Bill Yourself', 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', source, 'Player Not Online', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'No Access', 'error')
    end
end)


