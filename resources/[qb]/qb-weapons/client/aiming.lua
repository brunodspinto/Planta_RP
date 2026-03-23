-- Aiming Crosshair Handler
local lastAimState = false
local AimingLogic = QbWeaponsAimingLogic

-- Thread para detectar quando está mirrando
CreateThread(function()
    while true do
        local isLoggedIn = LocalPlayer.state.isLoggedIn
        local isPauseMenuActive = IsPauseMenuActive()
        local hasWeapon = false
        local isControlPressed = false

        if isLoggedIn and not isPauseMenuActive then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            hasWeapon = weapon ~= 0 and weapon ~= GetHashKey('WEAPON_UNARMED')

            if hasWeapon then
                isControlPressed = IsControlPressed(0, 25)
            end
        end

        local result = AimingLogic.evaluate({
            isLoggedIn = isLoggedIn,
            isPauseMenuActive = isPauseMenuActive,
            hasWeapon = hasWeapon,
            isControlPressed = isControlPressed,
            lastAimState = lastAimState,
        })

        if result.shouldTriggerEvent then
            lastAimState = result.nextAimState
            TriggerEvent('hud:client:ShowCrosshair', result.eventValue)
        end

        Wait(result.sleep)
    end
end)
