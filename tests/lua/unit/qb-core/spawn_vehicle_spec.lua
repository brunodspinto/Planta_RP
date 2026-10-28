local F = dofile("tests/lua/helpers/fivem_server.lua")
local case, assertEqual = F.case, F.assertEqual

local function setup()
    F.load("resources/[qb]/qb-core/server/events.lua")
    F.coords.ped1 = vector3(100, 100, 30)
    return F.addPlayer(1, "police", 0, 0)
end

-- Refusals are logged with print; keep the test output clean
local function quietly(fn)
    local realPrint = print
    print = function() end
    local ok, err = pcall(fn)
    print = realPrint
    if not ok then error(err, 0) end
end

local function spawn(callback, x, y)
    F.advance(3)
    return F.call("QBCore:Server:" .. callback, 1, "adder", vector3(x, y, 30), false)
end

return {
    case("qb-core: spawns a vehicle next to the player", function()
        setup()
        assertEqual(spawn("SpawnVehicle", 110, 110) ~= nil, true, "callback answered")
        assertEqual(#F.spawned, 1, "spawned")
    end),
    case("qb-core: refuses a vehicle far from the player", function()
        setup()
        quietly(function()
            assertEqual(spawn("SpawnVehicle", 3000, 3000), nil, "callback answered")
        end)
        assertEqual(#F.spawned, 0, "spawned")
    end),
    case("qb-core: refuses spawns in quick succession", function()
        setup()
        quietly(function()
            F.advance(3)
            for _ = 1, 5 do F.call("QBCore:Server:SpawnVehicle", 1, "adder", vector3(110, 110, 30), false) end
        end)
        assertEqual(#F.spawned, 1, "spawned")
        spawn("SpawnVehicle", 110, 110)
        assertEqual(#F.spawned, 2, "spawned after the cooldown")
    end),
    case("qb-core: refuses coords that are not a vector", function()
        setup()
        quietly(function()
            F.call("QBCore:Server:SpawnVehicle", 1, "adder", "here", false)
            F.call("QBCore:Server:SpawnVehicle", 1, "adder", { x = "a", y = 0, z = 0 }, false)
        end)
        assertEqual(#F.spawned, 0, "spawned")
    end),
    case("qb-core: spawning without coords uses the player position", function()
        setup()
        F.call("QBCore:Server:SpawnVehicle", 1, "adder", nil, true)
        assertEqual(#F.spawned, 1, "spawned")
    end),
    case("qb-core: CreateVehicle has the same limits", function()
        setup()
        quietly(function() spawn("CreateVehicle", 3000, 3000) end)
        assertEqual(#F.spawned, 0, "far away")
        spawn("CreateVehicle", 110, 110)
        assertEqual(#F.spawned, 1, "next to the player")
    end),
    case("qb-core: admins have no distance or cooldown limits", function()
        setup()
        F.aces[1] = "admin"
        for _ = 1, 3 do F.call("QBCore:Server:SpawnVehicle", 1, "adder", vector3(3000, 3000, 30), false) end
        assertEqual(#F.spawned, 3, "spawned")
    end),
}
