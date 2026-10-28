local F = dofile("tests/lua/helpers/fivem_server.lua")
local case, assertEqual = F.case, F.assertEqual

local RESOURCE = "resources/[qb]/qb-banking"

local function setup()
    F.loadResource(RESOURCE, "server.lua")
    F.exported.CreateJobAccount("police", 5000)
    F.exported.CreateJobAccount("ambulance", 5000)
    local P1 = F.addPlayer(1, "ambulance", 1000, 1000)
    local P2 = F.addPlayer(2, "unemployed", 1000, 1000)
    return P1, P2
end

local function balance(account)
    return F.exported.GetAccountBalance(account)
end

local function bank(action, src, data)
    data.reason = data.reason or ""
    return F.call("qb-banking:server:" .. action, src, data)
end

return {
    case("banking: a boss of another job cannot withdraw from a society", function()
        local P1 = setup()
        P1.PlayerData.job.isboss = true
        assertEqual(bank("withdraw", 1, { accountName = "police", amount = 1000 }).success, false, "withdraw")
        assertEqual(balance("police"), 5000, "police balance")
        assertEqual(P1.PlayerData.money.cash, 1000, "cash")
    end),
    case("banking: an employee who is not the boss cannot withdraw", function()
        local P1 = setup()
        assertEqual(bank("withdraw", 1, { accountName = "ambulance", amount = 1000 }).success, false, "withdraw")
        assertEqual(balance("ambulance"), 5000, "ambulance balance")
    end),
    case("banking: the boss of that job can withdraw", function()
        local P1 = setup()
        P1.PlayerData.job.isboss = true
        assertEqual(bank("withdraw", 1, { accountName = "ambulance", amount = 1000 }).success, true, "withdraw")
        assertEqual(balance("ambulance"), 4000, "ambulance balance")
        assertEqual(P1.PlayerData.money.cash, 2000, "cash")
    end),
    case("banking: other players cannot drain a shared account", function()
        local P1 = setup()
        F.exported.CreatePlayerAccount(2, "savings", 3000, "[]")
        bank("withdraw", 1, { accountName = "savings", amount = 1000 })
        bank("internalTransfer", 1, { fromAccountName = "savings", toAccountName = "checking", amount = 1000 })
        bank("externalTransfer", 1, { fromAccountName = "savings", toAccountNumber = "CID1", amount = 1000 })
        assertEqual(balance("savings"), 3000, "savings balance")
        assertEqual(P1.PlayerData.money.cash + P1.PlayerData.money.bank, 2000, "player 1 money")
    end),
    case("banking: the owner and listed users use a shared account", function()
        setup()
        F.exported.CreatePlayerAccount(2, "savings", 3000, "[\"CID1\"]")
        json.decode = function() return { "CID1" } end
        assertEqual(bank("withdraw", 2, { accountName = "savings", amount = 1000 }).success, true, "owner")
        assertEqual(bank("withdraw", 1, { accountName = "savings", amount = 1000 }).success, true, "listed user")
        assertEqual(balance("savings"), 1000, "savings balance")
    end),
    case("banking: negative and NaN amounts are refused", function()
        local P1 = setup()
        P1.PlayerData.job = { name = "police", isboss = true }
        F.exported.CreatePlayerAccount(2, "savings", 3000, "[]")
        bank("deposit", 1, { accountName = "police", amount = -1000 })
        bank("withdraw", 1, { accountName = "police", amount = -1000 })
        bank("withdraw", 1, { accountName = "police", amount = 0 / 0 })
        bank("internalTransfer", 1, { fromAccountName = "checking", toAccountName = "savings", amount = -1000 })
        assertEqual(balance("police"), 5000, "police balance")
        assertEqual(balance("savings"), 3000, "savings balance")
        assertEqual(P1.PlayerData.money.cash, 1000, "cash")
        assertEqual(P1.PlayerData.money.bank, 1000, "bank")
    end),
    case("banking: accounts cannot take the name of a job or another account", function()
        setup()
        QBCore.Shared.Jobs.mechanic = { label = "Mechanic" }
        assertEqual(bank("openAccount", 2, { accountName = "mechanic", amount = 0 }).success, false, "job name")
        assertEqual(bank("openAccount", 2, { accountName = "police", amount = 0 }).success, false, "existing account")
        assertEqual(bank("openAccount", 2, { accountName = "savings", amount = 0 }).success, true, "free name")
        assertEqual(bank("renameAccount", 2, { oldName = "savings", newName = "police" }).success, false, "rename onto police")
        assertEqual(F.exported.GetAccount("police").account_type, "job", "police account")
    end),
    case("banking: a transfer to an account that does not exist keeps the money", function()
        local P1 = setup()
        bank("internalTransfer", 1, { fromAccountName = "checking", toAccountName = "nope", amount = 500 })
        assertEqual(P1.PlayerData.money.bank, 1000, "bank")
    end),
}
