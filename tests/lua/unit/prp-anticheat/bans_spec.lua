local F = dofile("tests/lua/helpers/fivem_server.lua")
local case, assertEqual = F.case, F.assertEqual

local RESOURCE = "resources/[standalone]/prp-anticheat"

local identifiers, dbBans

-- rows: what SELECT_ACTIVE returns from MySQL (expires_in = seconds left, nil = permanent)
local function setup(rows, configure)
    identifiers, dbBans = {}, rows or {}
    GetNumPlayerIdentifiers = function(src) return #(identifiers[src] or {}) end
    GetPlayerIdentifier = function(src, i) return identifiers[src][i + 1] end
    LoadResourceFile = function() return "CREATE TABLE IF NOT EXISTS prp_anticheat_bans (id INT)" end
    MySQL.query = function(sql, params, cb)
        if sql:find("WHERE license = ?", 1, true) then
            local rows = {}
            for _, row in ipairs(dbBans) do
                if row.license == params[1] then rows[#rows + 1] = row end
            end
            return cb(rows)
        end
        if sql:find("SELECT", 1, true) then return cb(dbBans) end
        cb({})
    end
    MySQL.insert = function(_, _, cb) cb(#dbBans + 100) end
    MySQL.update = function(_, _, cb) cb(1) end
    Config = nil
    F.load(RESOURCE .. "/config.lua")
    if configure then configure(Config) end
    for _, file in ipairs({ "server/state.lua", "server/identifiers.lua", "server/bans.lua", "server/main.lua" }) do
        F.load(RESOURCE .. "/" .. file)
    end
    -- init prints how many bans it loaded; keep the test output clean
    local realPrint = print
    print = function() end
    local ok, err = pcall(PRP.Bans.init)
    print = realPrint
    if not ok then error(err, 0) end
end

local function player(src, ...)
    identifiers[src] = { ... }
end

-- Returns the rejection message, or nil when the connection is accepted
local function connect(src)
    local rejected, done = nil, false
    local deferrals = {
        defer = function() end,
        update = function() end,
        done = function(message)
            done = true
            rejected = message
        end,
    }
    F.fire("playerConnecting", src, "tester", nil, deferrals)
    assertEqual(done, true, "deferrals.done called")
    return rejected
end

local function readFile(path)
    local file = assert(io.open(path, "r"))
    local text = file:read("a")
    file:close()
    return text
end

return {
    case("anticheat: a temporary ban stops blocking once it expires", function()
        setup({ { id = 1, license = "abc", reason = "test", expires_in = 3600 } })
        player(5, "license:abc")
        assertEqual(connect(5) ~= nil, true, "blocked while active")
        F.advance(3601)
        assertEqual(connect(5), nil, "accepted after it ends")
    end),
    case("anticheat: a ban made in game ends after its duration", function()
        setup()
        player(5, "license:abc", "discord:123")
        PRP.Bans.add(PRP.Identifiers.fromSource(5), "test", 2, "admin")
        assertEqual(PRP.Bans.lookupBySource(5) ~= nil, true, "banned")
        F.advance(2 * 3600 + 1)
        assertEqual(PRP.Bans.lookupBySource(5), nil, "after two hours")
    end),
    case("anticheat: a permanent ban never ends", function()
        setup({ { id = 1, license = "abc", reason = "test" } })
        player(5, "license:abc")
        F.advance(10 * 365 * 24 * 3600)
        assertEqual(connect(5) ~= nil, true, "still blocked")
    end),
    case("anticheat: another player on the banned IP can connect", function()
        setup({ { id = 1, license = "abc", ip = "1.2.3.4", reason = "test" } })
        player(5, "license:abc", "ip:1.2.3.4")
        player(6, "license:other", "ip:1.2.3.4")
        assertEqual(connect(5) ~= nil, true, "banned player")
        assertEqual(connect(6), nil, "same IP, other licence")
    end),
    case("anticheat: the IP blocks when BanMatchIP is on", function()
        setup({ { id = 1, license = "abc", ip = "1.2.3.4", reason = "test" } }, function(cfg)
            cfg.Punishment.BanMatchIP = true
        end)
        player(6, "license:other", "ip:1.2.3.4")
        assertEqual(connect(6) ~= nil, true, "same IP")
    end),
    case("anticheat: unbanning one licence keeps another ban on a shared identifier", function()
        setup({
            { id = 1, license = "abc", discord = "123", reason = "first" },
            { id = 2, license = "def", discord = "123", reason = "second" },
        })
        player(7, "discord:123")
        PRP.Bans.removeByLicense("abc")
        assertEqual(PRP.Bans.lookupBySource(7) ~= nil, true, "discord still banned")
    end),
    case("anticheat: config.lua is not sent to clients", function()
        local manifest = readFile(RESOURCE .. "/fxmanifest.lua"):gsub("%-%-[^\n]*", "")
        assertEqual(manifest:find("shared_script", 1, true), nil, "shared_script")
        assertEqual(manifest:find("client_script", 1, true), nil, "client_script")
        assertEqual(manifest:find("'config.lua'", 1, true) ~= nil, true, "config.lua listed")
    end),
}
