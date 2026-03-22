-- Aiming Crosshair Handler
local lastAimState = false

-- Thread para detectar quando está mirrando
CreateThread(function()
    while true do
        Wait(0)
        
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            local hasWeapon = weapon ~= 0 and weapon ~= `WEAPON_UNARMED`
            
            -- Verifica se o player está a pressionar o botão de aiming (Right Click / L1)
            local isAiming = false
            
            if hasWeapon then
                -- Verifica se está a pressionar o botão de aiming (0, 25)
                isAiming = IsControlPressed(0, 25)
            end
            
            -- Só envia mensagem se o estado mudou
            if isAiming ~= lastAimState then
                lastAimState = isAiming
                TriggerEvent('hud:client:ShowCrosshair', isAiming)
            end
        end
    end
end)
