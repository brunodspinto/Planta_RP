local QBCore = exports['qb-core']:GetCoreObject()
local Bail = {}

-- Stock de cada banca, por citizenid. É a única fonte de verdade: o cliente
-- só mostra uma cópia, que o servidor atualiza com UpdateStock.
local Stands = {}
local MakeCooldown = 3000 -- ms entre cachorros feitos (o minijogo demora mais do que isto)
local SellCooldown = 4000 -- ms entre vendas (o cliente tem de caminhar até à banca)
local RepGain = { exotic = 3, rare = 2, common = 1 }

local function GetLevel(Player)
    local rep = Player.Functions.GetRep('hotdog')
    if rep >= 200 then
        return 4
    elseif rep >= 100 then
        return 3
    elseif rep >= 50 then
        return 2
    end
    return 1
end

local function IsWholeNumber(n)
    return type(n) == 'number' and n == math.floor(n)
end

local function StockSnapshot(stand)
    local snapshot = {}
    for quality in pairs(Config.Stock) do
        snapshot[quality] = stand.stock[quality] or 0
    end
    return snapshot
end

local function PushStock(src, stand)
    TriggerClientEvent('qb-hotdogjob:client:UpdateStock', src, StockSnapshot(stand))
end

local function GetStand(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.job.name ~= 'hotdog' then return end
    local stand = Stands[Player.PlayerData.citizenid]
    if not stand then return end
    return Player, stand
end

-- Callbacks

QBCore.Functions.CreateCallback('qb-hotdogjob:server:HasMoney', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or Player.PlayerData.job.name ~= 'hotdog' then return cb(false) end
    local citizenid = Player.PlayerData.citizenid

    -- Banca já paga e ainda não devolvida: não cobra outra vez a caução
    if Bail[citizenid] and Stands[citizenid] then
        PushStock(source, Stands[citizenid])
        return cb(true)
    end

    if Player.PlayerData.money.bank >= Config.StandDeposit then
        Player.Functions.RemoveMoney('bank', Config.StandDeposit, 'hot dog deposit')
        Bail[citizenid] = true
        Stands[citizenid] = { stock = {}, lastMake = 0, lastSell = 0 }
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('qb-hotdogjob:server:BringBack', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    local citizenid = Player.PlayerData.citizenid

    if Bail[citizenid] then
        -- Repor antes de pagar: a caução só se devolve uma vez
        Bail[citizenid] = nil
        Stands[citizenid] = nil
        Player.Functions.AddMoney('bank', Config.StandDeposit, 'hot dog deposit')
        cb(true)
    else
        cb(false)
    end
end)

-- Events

RegisterNetEvent('qb-hotdogjob:server:MakeHotdog', function(quality)
    local src = source
    local Player, stand = GetStand(src)
    if not Player then return end
    if type(quality) ~= 'string' or not Config.Stock[quality] then return end

    local now = GetGameTimer()
    if now - stand.lastMake < MakeCooldown then return end
    stand.lastMake = now

    local level = GetLevel(Player)
    local label = Config.Stock[quality].Label
    local current = stand.stock[quality] or 0
    local max = Config.Stock[quality].Max[level]
    if current + 1 > max then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_more', { value = label }), 'error')
        return
    end

    local made = 1
    if level > 1 and math.random(1, 2) == math.random(1, 2) then
        made = math.min(math.random(1, level), max - current)
    end
    stand.stock[quality] = current + made

    if made > 1 then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.made_luck_hotdog', { value = made, value2 = label }), 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.made_hotdog', { value = label }), 'success')
    end

    local rep = Player.Functions.GetRep('hotdog')
    local gain = math.min(RepGain[quality] or 1, Config.MaxReputation - rep)
    if gain > 0 then
        Player.Functions.AddRep('hotdog', gain)
    end

    PushStock(src, stand)
    TriggerClientEvent('qb-hotdogjob:client:UpdateReputation', src, Player.PlayerData.metadata['rep'])
end)

RegisterNetEvent('qb-hotdogjob:server:Sell', function(quality, amount, price)
    local src = source
    local Player, stand = GetStand(src)
    if not Player then return end

    local now = GetGameTimer()
    local valid = type(quality) == 'string' and Config.Stock[quality]
        and IsWholeNumber(amount) and amount >= 1 and amount <= 3
        and amount <= (stand.stock[quality] or 0)
        and now - stand.lastSell >= SellCooldown
    if valid then
        -- O preço é sorteado no cliente para o mostrar ao comprador; aqui só se
        -- aceita até ao máximo do nível que o servidor calcula. O mínimo é o do
        -- nível 1 para não recusar vendas se o nível do cliente estiver atrasado.
        local prices = Config.Stock[quality].Price
        valid = IsWholeNumber(price) and price >= prices[1].min and price <= prices[GetLevel(Player)].max
    end

    if not valid then
        -- O cliente já descontou o stock dele; volta a alinhar com o servidor
        PushStock(src, stand)
        return
    end

    stand.lastSell = now
    stand.stock[quality] = stand.stock[quality] - amount
    Player.Functions.AddMoney('cash', amount * price, 'sold hotdog')
    PushStock(src, stand)
end)

-- Commands

QBCore.Commands.Add('removestand', Lang:t('info.command'), {}, false, function(source, _)
    TriggerClientEvent('qb-hotdogjob:staff:DeletStand', source)
end, 'admin')
