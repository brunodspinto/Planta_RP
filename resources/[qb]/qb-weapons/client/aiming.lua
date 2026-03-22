-- Aiming Crosshair Handler
local lastAimState = false

-- Thread para detectar quando está mirrando
CreateThread(function()
    while true do
        local sleep = 250

        if LocalPlayer.state.isLoggedIn and not IsPauseMenuActive() then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            local hasWeapon = weapon ~= 0 and weapon ~= `WEAPON_UNARMED`
            
            -- Verifica se o player está a pressionar o botão de aiming (Right Click / L1)
            local isAiming = false
            
            if hasWeapon then
                -- Verifica se está a pressionar o botão de aiming (0, 25)
                isAiming = IsControlPressed(0, 25)
                sleep = isAiming and 0 or 50
            end
            
            -- Só envia mensagem se o estado mudou
            if isAiming ~= lastAimState then
                lastAimState = isAiming
                TriggerEvent('hud:client:ShowCrosshair', isAiming)
            end
        elseif lastAimState then
            -- Garante que a mira desaparece ao pausar/deslogar sem depender de outros scripts.
            lastAimState = false
            TriggerEvent('hud:client:ShowCrosshair', false)
        end

        Wait(sleep)
    end
end)
