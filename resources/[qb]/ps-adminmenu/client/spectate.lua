local oldPos = nil
local spectateInfo = {
    toggled = false,
    target = 0,
    targetPed = 0
}

RegisterNetEvent('ps-adminmenu:requestSpectate', function(targetPed, target, name)
    oldPos = GetEntityCoords(cache.ped)
    spectateInfo = {
        toggled = true,
        target = target,
        targetPed = targetPed
    }
end)

RegisterNetEvent('ps-adminmenu:cancelSpectate', function()
    if NetworkIsInSpectatorMode() then
        NetworkSetInSpectatorMode(false, spectateInfo['targetPed'])
    end
    SetEntityVisible(cache.ped, true, 0)
    spectateInfo = { toggled = false, target = 0, targetPed = 0 }
    RequestCollisionAtCoord(oldPos)
    SetEntityCoords(cache.ped, oldPos)
    oldPos = nil;
end)

CreateThread(function()
    while true do
        Wait(100)
        if spectateInfo['toggled'] then
            local targetPed = NetworkGetEntityFromNetworkId(spectateInfo.targetPed)
            if DoesEntityExist(targetPed) then
                SetEntityVisible(cache.ped, false, 0)
                if not NetworkIsInSpectatorMode() then
                    RequestCollisionAtCoord(GetEntityCoords(targetPed))
                    NetworkSetInSpectatorMode(true, targetPed)
                end
            else
                TriggerServerEvent('ps-adminmenu:spectate:teleport', spectateInfo['target'])
                local waitTimeout = 0
                while not DoesEntityExist(NetworkGetEntityFromNetworkId(spectateInfo.targetPed)) and waitTimeout < 50 do
                    Wait(100)
                    waitTimeout = waitTimeout + 1
                end
            end
        else
            Wait(500)
        end
    end
end)
