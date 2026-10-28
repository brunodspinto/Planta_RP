local F = dofile("tests/lua/helpers/fivem_server.lua")
local case, assertEqual = F.case, F.assertEqual

local RESOURCE = "resources/[qb]/qb-hotdogjob"

local function setup(job)
    F.loadResource(RESOURCE, "server/main.lua")
    return F.addPlayer(1, job or "hotdog", 0, 10000)
end

local function startStand()
    return F.call("qb-hotdogjob:server:HasMoney", 1)
end

local function make(quality)
    F.advance(4)
    F.fire("qb-hotdogjob:server:MakeHotdog", 1, quality)
end

local function sell(quality, amount, price)
    F.advance(5)
    F.fire("qb-hotdogjob:server:Sell", 1, quality, amount, price)
end

local function lastStock()
    local pushes = F.clientEvents("qb-hotdogjob:client:UpdateStock")
    return pushes[#pushes].args[1]
end

return {
    case("hotdog: does not pay a client-chosen price", function()
        setup(); startStand(); make("exotic")
        sell("exotic", 1, 999999)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("hotdog: rejects the old (coords, amount, price) payload", function()
        setup(); startStand(); make("exotic")
        F.fire("qb-hotdogjob:server:Sell", 1, vector3(0, 0, 0), 1000, 999999)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("hotdog: does not pay without an active stand", function()
        setup()
        sell("exotic", 1, 20)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("hotdog: does not sell more than the server-side stock", function()
        setup(); startStand(); make("common")
        sell("common", 3, 12)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("hotdog: rejects fractional, NaN and negative amounts", function()
        setup(); startStand(); make("exotic"); make("exotic")
        sell("exotic", 0.5, 20); sell("exotic", 0 / 0, 20); sell("exotic", -1, 20)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("hotdog: pays amount x price and consumes stock", function()
        setup(); startStand(); make("exotic")
        sell("exotic", 1, 20)
        assertEqual(F.earned(1), 20, "first sale")
        sell("exotic", 1, 20)
        assertEqual(F.earned(1), 20, "second sale without stock")
    end),
    case("hotdog: rejects a price above the level maximum", function()
        setup(); startStand(); make("exotic")
        sell("exotic", 1, Config.Stock.exotic.Price[1].max + 1)
        assertEqual(F.earned(1), 0, "earned")
    end),
    case("hotdog: resyncs the client stock after a rejected sale", function()
        setup(); startStand(); make("common")
        sell("common", 3, 12)
        assertEqual(lastStock().common, 1, "common stock")
    end),
    case("hotdog: enforces a cooldown between hotdogs", function()
        local P = setup(); startStand()
        F.advance(4)
        for _ = 1, 10 do F.fire("qb-hotdogjob:server:MakeHotdog", 1, "common") end
        assertEqual(P.PlayerData.metadata.rep.hotdog, 1, "reputation")
    end),
    case("hotdog: reputation stops at MaxReputation", function()
        local P = setup(); startStand()
        P.PlayerData.metadata.rep.hotdog = Config.MaxReputation - 1
        make("exotic")
        assertEqual(P.PlayerData.metadata.rep.hotdog, Config.MaxReputation, "reputation")
    end),
    case("hotdog: stock stops at the level maximum", function()
        setup(); startStand()
        for _ = 1, Config.Stock.common.Max[1] + 10 do make("common") end
        assertEqual(lastStock().common, Config.Stock.common.Max[1], "common stock")
    end),
    case("hotdog: refunds the stand deposit only once", function()
        local P = setup(); startStand()
        F.call("qb-hotdogjob:server:BringBack", 1)
        F.call("qb-hotdogjob:server:BringBack", 1)
        assertEqual(P.PlayerData.money.bank, 10000, "bank")
    end),
    case("hotdog: opening the stand twice charges one deposit", function()
        local P = setup(); startStand(); startStand()
        assertEqual(P.PlayerData.money.bank, 10000 - Config.StandDeposit, "bank")
    end),
    case("hotdog: requires the hotdog job", function()
        local P = setup("police")
        assertEqual(startStand(), false, "stand opened")
        assertEqual(P.PlayerData.money.bank, 10000, "bank")
    end),
    case("hotdog: the old UpdateReputation event is gone", function()
        setup()
        assertEqual(F.events["qb-hotdogjob:server:UpdateReputation"], nil, "handler")
    end),
}
