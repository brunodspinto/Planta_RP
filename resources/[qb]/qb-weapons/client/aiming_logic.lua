local AimingLogic = {}

function AimingLogic.evaluate(snapshot)
    local nextAimState = false
    local shouldTriggerEvent = false
    local eventValue = nil
    local sleep = 250

    if snapshot.isLoggedIn and not snapshot.isPauseMenuActive then
        if snapshot.hasWeapon then
            nextAimState = snapshot.isControlPressed
            sleep = nextAimState and 0 or 50
        end

        if nextAimState ~= snapshot.lastAimState then
            shouldTriggerEvent = true
            eventValue = nextAimState
        end
    elseif snapshot.lastAimState then
        shouldTriggerEvent = true
        eventValue = false
    end

    return {
        nextAimState = nextAimState,
        shouldTriggerEvent = shouldTriggerEvent,
        eventValue = eventValue,
        sleep = sleep,
    }
end

QbWeaponsAimingLogic = AimingLogic

return AimingLogic
