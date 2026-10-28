local F = dofile("tests/lua/helpers/fivem_server.lua")
local case, assertEqual = F.case, F.assertEqual

local RESOURCE = "resources/[qb]/qb-shops"

local shops
local function setup()
    F.loadResource(RESOURCE, "server/main.lua")
    shops = {}
    for name, v in pairs(Config.Locations) do
        if v.delivery then shops[#shops + 1] = name end
    end
    table.sort(shops)
    return F.addPlayer(1, "unemployed", 1000, 0)
end

local function deliverTo(shop, wait)
    F.advance(wait or 600)
    local d = Config.Locations[shop].delivery
    F.coords.ped1 = vector3(d.x, d.y, d.z)
    F.fire("qb-shops:server:RestockShopItems", 1, shop)
end

local function startShift()
    F.fire("qb-shops:server:DoBail", 1, true)
end

return {
    case("shops: the client-driven PaySlip event is gone", function()
        setup()
        assertEqual(F.events["qb-shops:server:PaySlip"], nil, "handler")
    end),
    case("shops: a delivery without a paid deposit pays nothing", function()
        setup()
        deliverTo(shops[1])
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("shops: a valid delivery pays DeliveryPrice", function()
        setup(); startShift()
        deliverTo(shops[1])
        assertEqual(F.earned(1), Config.DeliveryPrice, "earned")
    end),
    case("shops: repeating the same store pays once", function()
        setup(); startShift()
        deliverTo(shops[1]); deliverTo(shops[1]); deliverTo(shops[1])
        assertEqual(F.earned(1), Config.DeliveryPrice, "earned")
    end),
    case("shops: jumping between stores without travel time pays once", function()
        setup(); startShift()
        deliverTo(shops[1])
        for i = 2, #shops do deliverTo(shops[i], 0) end
        assertEqual(F.earned(1), Config.DeliveryPrice, "earned")
    end),
    case("shops: a shift stops paying after MaxDeliveries", function()
        setup(); startShift()
        for i = 1, Config.MaxDeliveries + 5 do deliverTo(shops[(i % #shops) + 1]) end
        assertEqual(F.earned(1), Config.DeliveryPrice * Config.MaxDeliveries, "earned")
    end),
    case("shops: returning the van ends the shift and refunds once", function()
        local P = setup(); startShift()
        F.fire("qb-shops:server:DoBail", 1, false)
        F.fire("qb-shops:server:DoBail", 1, false)
        assertEqual(P.PlayerData.money.cash, 1000, "cash")
        deliverTo(shops[1])
        assertEqual(F.earned(1), Config.TruckDeposit, "earned after the shift")
    end),
    case("shops: an unpaid delivery does not restock", function()
        setup()
        local shop
        for _, s in ipairs(shops) do
            if Config.Locations[s].useStock then shop = s break end
        end
        if not shop then return end
        local before = Config.Locations[shop].products[1].amount
        deliverTo(shop)
        assertEqual(Config.Locations[shop].products[1].amount, before, "stock")
    end),
    case("shops: UpdateShopItems is not reachable from clients", function()
        setup()
        assertEqual(F.netEvents["qb-shops:server:UpdateShopItems"], nil, "net event")
        assertEqual(type(F.events["qb-shops:server:UpdateShopItems"]), "function", "server handler")
    end),
}
