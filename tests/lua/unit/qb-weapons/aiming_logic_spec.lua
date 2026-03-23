local AimingLogic = dofile("resources/[qb]/qb-weapons/client/aiming_logic.lua")

local function assertEqual(actual, expected, message)
    if actual ~= expected then
        error((message or "Assertion failed") .. " | expected=" .. tostring(expected) .. ", actual=" .. tostring(actual))
    end
end

return {
    {
        name = "shows crosshair when player starts aiming with weapon",
        test = function()
            local result = AimingLogic.evaluate({
                isLoggedIn = true,
                isPauseMenuActive = false,
                hasWeapon = true,
                isControlPressed = true,
                lastAimState = false,
            })

            assertEqual(result.nextAimState, true, "nextAimState")
            assertEqual(result.shouldTriggerEvent, true, "shouldTriggerEvent")
            assertEqual(result.eventValue, true, "eventValue")
            assertEqual(result.sleep, 0, "sleep")
        end,
    },
    {
        name = "does not trigger event when aim state is unchanged",
        test = function()
            local result = AimingLogic.evaluate({
                isLoggedIn = true,
                isPauseMenuActive = false,
                hasWeapon = true,
                isControlPressed = false,
                lastAimState = false,
            })

            assertEqual(result.nextAimState, false, "nextAimState")
            assertEqual(result.shouldTriggerEvent, false, "shouldTriggerEvent")
            assertEqual(result.eventValue, nil, "eventValue")
            assertEqual(result.sleep, 50, "sleep")
        end,
    },
    {
        name = "forces hide crosshair while paused if it was visible",
        test = function()
            local result = AimingLogic.evaluate({
                isLoggedIn = true,
                isPauseMenuActive = true,
                hasWeapon = true,
                isControlPressed = true,
                lastAimState = true,
            })

            assertEqual(result.nextAimState, false, "nextAimState")
            assertEqual(result.shouldTriggerEvent, true, "shouldTriggerEvent")
            assertEqual(result.eventValue, false, "eventValue")
            assertEqual(result.sleep, 250, "sleep")
        end,
    },
    {
        name = "keeps idle sleep when player has no weapon",
        test = function()
            local result = AimingLogic.evaluate({
                isLoggedIn = true,
                isPauseMenuActive = false,
                hasWeapon = false,
                isControlPressed = true,
                lastAimState = false,
            })

            assertEqual(result.nextAimState, false, "nextAimState")
            assertEqual(result.shouldTriggerEvent, false, "shouldTriggerEvent")
            assertEqual(result.eventValue, nil, "eventValue")
            assertEqual(result.sleep, 250, "sleep")
        end,
    },
}
