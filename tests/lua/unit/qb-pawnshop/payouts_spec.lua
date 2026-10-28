local F = dofile("tests/lua/helpers/fivem_server.lua")
local case, assertEqual = F.case, F.assertEqual

local RESOURCE = "resources/[qb]/qb-pawnshop"

local function setup()
    F.loadResource(RESOURCE, "server/main.lua")
    local P = F.addPlayer(1, "unemployed", 0, 0)
    F.coords.ped1 = Config.PawnLocation[1].coords
    P.PlayerData.items = { goldchain = 10, diamond_ring = 10, rolex = 10 }
    return P
end

local function serverPrice(item)
    for _, v in pairs(Config.PawnItems) do
        if v.item == item then return v.price end
    end
end

local function goldbarsPerChain()
    for _, v in pairs(Config.MeltingItems) do
        if v.item == "goldchain" then return v.rewards[1].amount end
    end
end

return {
    case("pawnshop: pays the server price, not the client one", function()
        setup()
        F.fire("qb-pawnshop:server:sellPawnItems", 1, "goldchain", 2, 999999)
        assertEqual(F.earned(1), 2 * serverPrice("goldchain"), "earned")
    end),
    case("pawnshop: does not buy items outside the pawn list", function()
        local P = setup()
        P.PlayerData.items.weapon_pistol = 1
        F.fire("qb-pawnshop:server:sellPawnItems", 1, "weapon_pistol", 1, 50)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("pawnshop: rejects fractional amounts", function()
        setup()
        F.fire("qb-pawnshop:server:sellPawnItems", 1, "goldchain", 0.5, 50)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("pawnshop: bans a sale far from the shop", function()
        setup()
        F.coords.ped1 = vector3(0, 0, 0)
        F.fire("qb-pawnshop:server:sellPawnItems", 1, "goldchain", 1, 50)
        assertEqual(#F.dropped, 1, "dropped")
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("pawnshop: pickupMelted ignores client-sent rewards", function()
        setup()
        F.fire("qb-pawnshop:server:pickupMelted", 1, { items = { { amount = 1000, item = { reward = { { item = "weapon_rpg", amount = 1 } } } } } })
        assertEqual(#F.items, 0, "items given")
    end),
    case("pawnshop: melted items use the server recipe and wait for the timer", function()
        setup()
        F.fire("qb-pawnshop:server:meltItemRemove", 1, "goldchain", 2, { time = 0, reward = { { item = "weapon_rpg", amount = 50 } } })
        F.fire("qb-pawnshop:server:pickupMelted", 1)
        assertEqual(F.received("goldbar"), 0, "picked up before the timer")
        F.advance(600)
        F.fire("qb-pawnshop:server:pickupMelted", 1)
        assertEqual(F.received("goldbar"), 2 * goldbarsPerChain(), "goldbar")
        assertEqual(F.received("weapon_rpg"), 0, "weapon_rpg")
    end),
    case("pawnshop: a melt batch can only be picked up once", function()
        setup()
        F.fire("qb-pawnshop:server:meltItemRemove", 1, "goldchain", 1)
        F.advance(600)
        F.fire("qb-pawnshop:server:pickupMelted", 1)
        F.fire("qb-pawnshop:server:pickupMelted", 1)
        assertEqual(F.received("goldbar"), goldbarsPerChain(), "goldbar")
    end),
    case("pawnshop: a full inventory keeps the reward for later", function()
        setup()
        F.fire("qb-pawnshop:server:meltItemRemove", 1, "goldchain", 1)
        F.advance(600)
        F.inventoryFull = true
        F.fire("qb-pawnshop:server:pickupMelted", 1)
        F.inventoryFull = false
        F.fire("qb-pawnshop:server:pickupMelted", 1)
        assertEqual(F.received("goldbar"), goldbarsPerChain(), "goldbar")
    end),
    case("pawnshop: melting without the items creates no batch", function()
        local P = setup()
        P.PlayerData.items.goldchain = 0
        F.fire("qb-pawnshop:server:meltItemRemove", 1, "goldchain", 5)
        F.advance(600)
        F.fire("qb-pawnshop:server:pickupMelted", 1)
        assertEqual(F.received("goldbar"), 0, "goldbar")
    end),
    case("pawnshop: getInv returns the server prices", function()
        setup()
        local _, prices = F.call("qb-pawnshop:server:getInv", 1)
        assertEqual(type(prices), "table", "prices")
        assertEqual(prices.goldchain, serverPrice("goldchain"), "goldchain price")
    end),
}
