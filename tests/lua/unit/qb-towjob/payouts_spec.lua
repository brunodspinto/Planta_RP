local F = dofile("tests/lua/helpers/fivem_server.lua")
local case, assertEqual = F.case, F.assertEqual

local RESOURCE = "resources/[qb]/qb-towjob"
local DROP_PRICE = 160
local PAYMENT_TAX = 15

local nextNetId
local function setup(job)
    F.loadResource(RESOURCE, "server/main.lua")
    nextNetId = 100
    -- Fixed DropPrice and no cryptostick unless a test queues a roll
    F.randomOverride = function(a, b)
        if a == 150 and b == 170 then return DROP_PRICE end
        if a == 1 and b == 100 then return 100 end
    end
    F.lastVehicle.ped1 = "flatbed"
    F.entities.flatbed = { model = joaat("flatbed") }
    return F.addPlayer(1, job or "tow", 0, 0)
end

local function spawnAtSpot(i, model)
    nextNetId = nextNetId + 1
    local spot = Config.Locations.towspots[i]
    local entity = "veh" .. nextNetId
    F.entities[entity] = { model = joaat(model or spot.model) }
    F.netEntities[nextNetId] = entity
    F.coords[entity] = spot.coords
    F.coords.flatbed = spot.coords
    return nextNetId
end

local function hook(netId)
    F.fire("qb-tow:server:nano", 1, netId)
end

local function deliver(netId, wait)
    F.advance(wait or 600)
    F.coords.ped1 = Config.Locations.dropoff.coords
    F.fire("qb-tow:server:DeliverVehicle", 1, netId)
end

local function payslip(drops)
    local m = Config.Locations.main.coords
    F.coords.ped1 = vector3(m.x, m.y, m.z)
    F.fire("qb-tow:server:11101110", 1, drops)
end

local function expected(drops)
    local tier = 0
    if drops > 20 then tier = 12 elseif drops > 15 then tier = 10 elseif drops > 10 then tier = 7 elseif drops > 5 then tier = 5 end
    local price = DROP_PRICE * drops + math.ceil((DROP_PRICE / 10) * tier)
    return price - math.ceil((price / 100) * PAYMENT_TAX)
end

return {
    case("tow: ignores a client-sent drop count", function()
        setup()
        payslip(100000)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("tow: a valid tow counts one drop", function()
        setup()
        local net = spawnAtSpot(1)
        hook(net); deliver(net)
        payslip(50)
        assertEqual(F.earned(1), expected(1), "earned")
    end),
    case("tow: a vehicle that is not from a towspot does not count", function()
        setup()
        local net = spawnAtSpot(1, "adder")
        hook(net); deliver(net)
        payslip(1)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("tow: a delivery without travel time does not count", function()
        setup()
        local net = spawnAtSpot(1)
        hook(net); deliver(net, 1)
        payslip(1)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("tow: the same vehicle cannot be delivered twice", function()
        setup()
        local net = spawnAtSpot(1)
        hook(net); deliver(net); hook(net); deliver(net); deliver(net)
        payslip(3)
        assertEqual(F.earned(1), expected(1), "earned")
    end),
    case("tow: the payslip cannot be collected twice", function()
        setup()
        local net = spawnAtSpot(1)
        hook(net); deliver(net)
        payslip(1); payslip(1)
        assertEqual(F.earned(1), expected(1), "earned")
    end),
    case("tow: 21 drops use the highest bonus tier", function()
        setup()
        for i = 1, 21 do
            local net = spawnAtSpot((i % #Config.Locations.towspots) + 1)
            hook(net); deliver(net)
        end
        payslip(21)
        assertEqual(F.earned(1), expected(21), "earned")
    end),
    case("tow: cryptostick only on hooking a new vehicle", function()
        setup()
        local net = spawnAtSpot(1)
        for _ = 1, 3 do
            F.randomQueue = { 1 }
            hook(net)
        end
        assertEqual(#F.items, 1, "cryptosticks")
    end),
}
