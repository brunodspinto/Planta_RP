-- Minimal FiveM + QBCore server runtime for testing resource handlers outside the game.
-- Every case runs between install() and uninstall(), so the mocked globals never leak
-- into other specs that share the same Lua state.
local M = {}

local MOCKED_GLOBALS = {
    'vector3', 'vector4', 'joaat', 'GetHashKey', 'GetConvar', 'json', 'GetGameTimer',
    'RegisterNetEvent', 'RegisterServerEvent', 'AddEventHandler', 'TriggerEvent', 'TriggerClientEvent',
    'DropPlayer', 'CreateThread', 'Wait', 'SetTimeout', 'SaveResourceFile', 'LoadResourceFile',
    'GetCurrentResourceName', 'GetPlayerName', 'GetPlayerPed', 'GetEntityCoords', 'GetVehiclePedIsIn',
    'NetworkGetEntityFromNetworkId', 'NetworkGetNetworkIdFromEntity', 'DoesEntityExist', 'GetEntityModel',
    'DeleteEntity', 'IsPlayerAceAllowed', 'MySQL', 'Lang', 'Locale', 'QBCore', 'exports', 'Config', 'source',
}

local vecmt = {}
vecmt.__index = vecmt
vecmt.__sub = function(a, b)
    return setmetatable({ x = a.x - b.x, y = a.y - b.y, z = (a.z or 0) - (b.z or 0) }, vecmt)
end
vecmt.__len = function(a) return math.sqrt(a.x * a.x + a.y * a.y + (a.z or 0) ^ 2) end

local function joaat(s)
    local h = 0
    for i = 1, #s do h = (h * 31 + s:byte(i)) % 4294967296 end
    return h
end

local saved
local realRandom = math.random
local realTime = os.time

local function makePlayer(src, job, cash, bank)
    local P = {
        PlayerData = {
            source = src,
            citizenid = 'CID' .. src,
            job = { name = job, isboss = false, grade = { level = 0 } },
            money = { cash = cash or 0, bank = bank or 0 },
            metadata = { rep = {} },
            items = {},
        },
        Functions = {},
    }
    function P.Functions.AddMoney(kind, amount)
        assert(type(amount) == 'number' and amount >= 0, 'invalid AddMoney amount: ' .. tostring(amount))
        P.PlayerData.money[kind] = P.PlayerData.money[kind] + amount
        M.money[#M.money + 1] = { src = src, kind = kind, amount = amount }
        return true
    end
    function P.Functions.RemoveMoney(kind, amount)
        if P.PlayerData.money[kind] < amount then return false end
        P.PlayerData.money[kind] = P.PlayerData.money[kind] - amount
        return true
    end
    function P.Functions.GetRep(name) return P.PlayerData.metadata.rep[name] or 0 end
    function P.Functions.AddRep(name, n) P.PlayerData.metadata.rep[name] = (P.PlayerData.metadata.rep[name] or 0) + n end
    return P
end

local function resetState()
    M.events, M.netEvents, M.callbacks, M.client, M.dropped = {}, {}, {}, {}, {}
    M.money, M.items, M.spawned = {}, {}, {}
    M.now, M.timer = 1000000, 1000000
    M.coords, M.entities, M.netEntities, M.lastVehicle = {}, {}, {}, {}
    M.players, M.aces = {}, {}
    M.inventoryFull = false
    M.randomQueue = {}
    M.randomOverride = nil
end

local function installGlobals()
    vector3 = function(x, y, z) return setmetatable({ x = x, y = y, z = z }, vecmt) end
    vector4 = function(x, y, z, w) return setmetatable({ x = x, y = y, z = z, w = w }, vecmt) end
    _G.joaat = joaat
    GetHashKey = joaat
    GetConvar = function(_, default) return default end
    json = { encode = function() return '{}' end, decode = function() return {} end }
    GetGameTimer = function() return M.timer end

    RegisterNetEvent = function(name, fn)
        M.netEvents[name] = true
        if fn then M.events[name] = fn end
    end
    RegisterServerEvent = RegisterNetEvent
    AddEventHandler = function(name, fn) M.events[name] = fn end
    TriggerEvent = function() end
    TriggerClientEvent = function(name, src, ...) M.client[#M.client + 1] = { name = name, src = src, args = { ... } } end
    DropPlayer = function(src, reason) M.dropped[#M.dropped + 1] = { src = src, reason = reason } end
    CreateThread = function() end
    Wait = function() end
    SetTimeout = function() end
    SaveResourceFile = function() end
    LoadResourceFile = function() return nil end
    GetCurrentResourceName = function() return 'test' end
    GetPlayerName = function() return 'tester' end
    GetPlayerPed = function(src) return 'ped' .. src end
    GetEntityCoords = function(ent) return M.coords[ent] or vector3(0, 0, 0) end
    GetVehiclePedIsIn = function(ped) return M.lastVehicle[ped] end
    NetworkGetEntityFromNetworkId = function(id) return M.netEntities[id] or 0 end
    NetworkGetNetworkIdFromEntity = function(ent)
        for id, e in pairs(M.netEntities) do if e == ent then return id end end
        return 0
    end
    DoesEntityExist = function(ent) return M.entities[ent] ~= nil end
    GetEntityModel = function(ent) return M.entities[ent] and M.entities[ent].model or 0 end
    DeleteEntity = function(ent)
        M.entities[ent] = nil
        for id, e in pairs(M.netEntities) do if e == ent then M.netEntities[id] = nil end end
    end
    IsPlayerAceAllowed = function(src, ace) return M.aces[src] == ace end
    MySQL = { insert = function() end, query = { await = function() return {} end }, scalar = { await = function() end } }

    Lang = { t = function(_, key) return key end }
    Locale = { new = function() return Lang end }

    QBCore = {
        Functions = {
            GetPlayer = function(src) return M.players[src] end,
            CreateCallback = function(name, fn) M.callbacks[name] = fn end,
            GetIdentifier = function() return 'id' end,
            HasPermission = function(src, perm) return IsPlayerAceAllowed(src, perm) end,
            SpawnVehicle = function(src, model)
                M.spawned[#M.spawned + 1] = { src = src, model = model }
                return 'spawned' .. #M.spawned
            end,
            CreateAutomobile = function(src, model)
                M.spawned[#M.spawned + 1] = { src = src, model = model }
                return 'spawned' .. #M.spawned
            end,
        },
        Commands = { Add = function() end, List = {} },
        Config = { Server = { Closed = false } },
        Players = {},
        Shared = { Items = setmetatable({}, { __index = function(_, k) return { name = k, label = k } end }) },
    }

    local inventory = {
        AddItem = function(_, src, item, amount)
            if M.inventoryFull then return false end
            M.items[#M.items + 1] = { src = src, item = item, amount = amount }
            return true
        end,
        RemoveItem = function(_, src, item, amount)
            local P = M.players[src]
            local have = P.PlayerData.items[item] or 0
            if type(amount) ~= 'number' or amount < 1 or have < amount then return false end
            P.PlayerData.items[item] = have - amount
            return true
        end,
    }
    exports = setmetatable({}, { __index = function(_, res)
        if res == 'qb-core' then
            return { GetCoreObject = function() return QBCore end }
        elseif res == 'qb-inventory' then
            return inventory
        elseif res == 'qb-banking' then
            return { AddMoney = function(_, account, amount) M.money[#M.money + 1] = { src = account, kind = 'society', amount = amount } end }
        end
        return setmetatable({}, { __index = function() return function() end end })
    end })

    os.time = function(t)
        if t then return realTime(t) end
        return M.now
    end
    math.random = function(a, b)
        if #M.randomQueue > 0 then return table.remove(M.randomQueue, 1) end
        if M.randomOverride then
            local value = M.randomOverride(a, b)
            if value ~= nil then return value end
        end
        if a == nil then return realRandom() end
        if b == nil then return realRandom(a) end
        return realRandom(a, b)
    end
end

function M.install()
    saved = { osTime = os.time, random = math.random, globals = {} }
    for _, name in ipairs(MOCKED_GLOBALS) do saved.globals[name] = _G[name] end
    resetState()
    installGlobals()
end

function M.uninstall()
    for _, name in ipairs(MOCKED_GLOBALS) do _G[name] = saved.globals[name] end
    os.time = saved.osTime
    math.random = saved.random
    saved = nil
end

-- Wraps a test so the mocked runtime only exists while it runs.
function M.case(name, fn)
    return {
        name = name,
        test = function()
            M.install()
            local ok, err = pcall(fn)
            M.uninstall()
            if not ok then error(err, 0) end
        end,
    }
end

-- Loads a FiveM Lua file: accepts the CfxLua `+=`/`-=` operators and `backtick` hashes.
function M.load(path)
    local file = assert(io.open(path, 'r'))
    local src = file:read('a')
    file:close()
    src = src:gsub('([%w_%.%[%]\'"]+)%s*%+=%s*', '%1 = %1 + ')
    src = src:gsub('([%w_%.%[%]\'"]+)%s*%-=%s*', '%1 = %1 - ')
    src = src:gsub('`([^`]+)`', function(s) return tostring(joaat(s)) end)
    assert(load(src, '@' .. path))()
end

-- Loads config.lua and then the given server files of a resource.
function M.loadResource(resource, ...)
    Config = nil
    M.load(resource .. '/config.lua')
    for _, file in ipairs({ ... }) do M.load(resource .. '/' .. file) end
end

function M.advance(seconds)
    M.now = M.now + seconds
    M.timer = M.timer + seconds * 1000
end

function M.addPlayer(src, job, cash, bank)
    M.players[src] = makePlayer(src, job, cash, bank)
    return M.players[src]
end

function M.fire(name, src, ...)
    source = src
    return M.events[name](...)
end

function M.call(name, src, ...)
    local result
    M.callbacks[name](src, function(...) result = { ... } end, ...)
    if not result then return end
    return table.unpack(result)
end

function M.earned(src)
    local total = 0
    for _, m in ipairs(M.money) do
        if m.src == src then total = total + m.amount end
    end
    return total
end

function M.received(item)
    local total = 0
    for _, i in ipairs(M.items) do
        if i.item == item then total = total + i.amount end
    end
    return total
end

function M.clientEvents(name)
    local out = {}
    for _, e in ipairs(M.client) do
        if e.name == name then out[#out + 1] = e end
    end
    return out
end

function M.assertEqual(actual, expected, message)
    if actual ~= expected then
        error((message or 'Assertion failed') .. ' | expected=' .. tostring(expected) .. ', actual=' .. tostring(actual), 2)
    end
end

return M
