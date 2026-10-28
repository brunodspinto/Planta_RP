local F = dofile("tests/lua/helpers/fivem_server.lua")
local case, assertEqual = F.case, F.assertEqual

local RESOURCE = "resources/[qb]/qb-taxijob"
local ROUTE_FACTOR = 1.75

local function setup(job)
    F.loadResource(RESOURCE, "server/main.lua")
    return F.addPlayer(1, job or "taxi", 0, 0)
end

local function take(i)
    local v = Config.NPCLocations.TakeLocations[i]
    return vector3(v.x, v.y, v.z)
end

local function deliver(i)
    local v = Config.NPCLocations.DeliverLocations[i]
    return vector3(v.x, v.y, v.z)
end

-- randomAmount = 1, r1 = 2, r2 = 3 (no random bonus) and chance = 100 (no reward item)
local function noLuck()
    F.randomQueue = { 1, 2, 3, 100 }
end

local function ride(from, to, wait, fare, intact)
    F.coords.ped1 = take(from)
    F.fire("qb-taxi:server:NpcPickup", 1, to)
    F.advance(wait)
    F.coords.ped1 = deliver(to)
    noLuck()
    F.fire("qb-taxi:server:NpcPay", 1, fare, intact)
end

local function maxFare(from, to)
    local miles = #(deliver(to) - take(from)) * ROUTE_FACTOR / 1609
    return math.floor(miles * Config.Meter.defaultPrice + Config.Meter.startingPrice)
end

return {
    case("taxi: does not pay without a registered pickup", function()
        setup()
        F.coords.ped1 = deliver(1)
        noLuck()
        F.fire("qb-taxi:server:NpcPay", 1, 999999, false)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("taxi: caps an inflated meter at the trip maximum", function()
        setup()
        ride(1, 5, 600, 999999, false)
        assertEqual(F.earned(1), maxFare(1, 5), "earned")
    end),
    case("taxi: pays a normal meter value as is", function()
        setup()
        local fare = math.floor(maxFare(1, 5) * 0.7)
        ride(1, 5, 600, fare, false)
        assertEqual(F.earned(1), fare, "earned")
    end),
    case("taxi: tips only when the cab is intact", function()
        setup()
        ride(1, 5, 600, 100, true)
        assertEqual(F.earned(1), 100 + math.floor(100 * Config.Advanced.Bonus.Percentage / 100), "earned")
    end),
    case("taxi: pays each ride only once", function()
        setup()
        ride(1, 5, 600, 100, false)
        noLuck()
        F.fire("qb-taxi:server:NpcPay", 1, 100, false)
        assertEqual(F.earned(1), 100, "earned")
    end),
    case("taxi: does not pay a ride faster than possible", function()
        setup()
        ride(1, 5, 1, 100, false)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("taxi: drops a player paid away from the chosen destination", function()
        setup()
        F.coords.ped1 = take(1)
        F.fire("qb-taxi:server:NpcPickup", 1, 5)
        F.advance(600)
        F.coords.ped1 = deliver(6)
        noLuck()
        F.fire("qb-taxi:server:NpcPay", 1, 100, false)
        assertEqual(F.earned(1), 0, "earned")
        assertEqual(#F.dropped, 1, "dropped")
    end),
    case("taxi: a pickup away from any customer opens no ride", function()
        setup()
        F.coords.ped1 = vector3(5000, 5000, 0)
        F.fire("qb-taxi:server:NpcPickup", 1, 5)
        F.advance(600)
        F.coords.ped1 = deliver(5)
        noLuck()
        F.fire("qb-taxi:server:NpcPay", 1, 100, false)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("taxi: NaN and negative meters pay nothing", function()
        setup()
        ride(1, 5, 600, 0 / 0, false)
        ride(1, 5, 600, -500, false)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("taxi: drops a player without the taxi job", function()
        setup("police")
        ride(1, 5, 600, 100, false)
        assertEqual(F.earned(1), 0, "earned")
        assertEqual(#F.dropped >= 1, true, "dropped")
    end),
}
