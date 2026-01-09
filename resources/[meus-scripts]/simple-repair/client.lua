local QBCore = exports['qb-core']:GetCoreObject()
local VeiculoParaReparar = nil

-- 1. O servidor disse "O jogador usou a ferramenta, vê lá se ele tem um carro perto"
RegisterNetEvent('simple-repair:client:VerificarCarro')
AddEventHandler('simple-repair:client:VerificarCarro', function()
    local ped = PlayerPedId()

    -- Verifica se está num veículo
    if IsPedInAnyVehicle(ped, false) then
        VeiculoParaReparar = GetVehiclePedIsIn(ped, false)
        
        -- Começa a magia (Sair e animar)
        TriggerEvent('simple-repair:client:AnimacaoReparacao')
    else
        -- Lógica Extra (Nível 5): Reparar DE FORA do carro
        -- Se não estivermos dentro, procuramos o carro mais próximo à nossa frente
        local coord = GetEntityCoords(ped)
        local carroPerto, dist = QBCore.Functions.GetClosestVehicle(coord)

        if carroPerto and dist < 3.0 then
            VeiculoParaReparar = carroPerto
            TriggerEvent('simple-repair:client:AnimacaoReparacao')
        else
            QBCore.Functions.Notify("Não há nenhum veículo por perto!", "error")
        end
    end
end)

-- 2. A Lógica da Animação (Separada para ser mais limpa)
RegisterNetEvent('simple-repair:client:AnimacaoReparacao')
AddEventHandler('simple-repair:client:AnimacaoReparacao', function()
    local ped = PlayerPedId()

    -- Se estiver dentro, sai primeiro
    if IsPedInAnyVehicle(ped, false) then
        TaskLeaveVehicle(ped, VeiculoParaReparar, 0)
        while IsPedInAnyVehicle(ped, false) do Wait(100) end
    end

    -- Calcular frente do motor
    local frenteCarro = GetOffsetFromEntityInWorldCoords(VeiculoParaReparar, 0.0, 3.0, 0.0)
    TaskGoStraightToCoord(ped, frenteCarro.x, frenteCarro.y, frenteCarro.z, 1.0, -1, 0.0, 0.0)

    local aCaminhar = true
    while aCaminhar do
        local posPed = GetEntityCoords(ped)
        local dist = #(posPed - vector3(frenteCarro.x, frenteCarro.y, frenteCarro.z))
        if dist < 1.5 then aCaminhar = false; TaskTurnPedToFaceEntity(ped, VeiculoParaReparar, 1000) end
        Wait(100)
    end
    
    Wait(1000)

    if lib.progressBar({
        duration = 5000,
        label = 'A usar Kit...',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
    }) then
        TriggerServerEvent('simple-repair:server:CobrarEFinalizar')
        ClearPedTasks(ped)
    else
        QBCore.Functions.Notify("Reparação cancelada!", "error")
        ClearPedTasks(ped)
        VeiculoParaReparar = nil
    end
end)

-- 3. Aplicar o Fix (Igual ao anterior)
RegisterNetEvent('simple-repair:client:AplicarFix')
AddEventHandler('simple-repair:client:AplicarFix', function()
    if VeiculoParaReparar then
        SetVehicleDoorOpen(VeiculoParaReparar, 4, false, false)
        Wait(1000)
        SetVehicleFixed(VeiculoParaReparar)
        SetVehicleDirtLevel(VeiculoParaReparar, 0.0)
        SetVehicleEngineHealth(VeiculoParaReparar, 1000.0)
        Wait(500)
        SetVehicleDoorShut(VeiculoParaReparar, 4, false)
        QBCore.Functions.Notify("Veículo reparado!", "success")
        VeiculoParaReparar = nil
    end
end)