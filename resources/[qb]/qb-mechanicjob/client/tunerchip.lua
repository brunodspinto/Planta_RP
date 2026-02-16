local QBCore = exports['qb-core']:GetCoreObject()

-- TRADUÇÃO E ENGENHARIA POR: BOSS (VERSÃO 6.0 - REALISMO PURO)
-- Nota: Luzes removidas. O Portátil agora só mexe na ECU e Suspensão.

-- Funções Auxiliares
local function setVecMulti(vehicle)
    local speed = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce")
    local gears = GetVehicleHandlingFloat(vehicle, "CHandlingData", "nInitialDriveGears")
    local force = speed * gears
    local gravity = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fGravity")
    local weight = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fMass")
    local multi = ((force * gravity) / weight) * 2
    return multi
end

-- Menus Interativos
local function OpenTunerMenu(vehicle)
    local menu = {
        {
            header = "💻 Portátil de Reprogramação",
            isMenuHeader = true,
            icon = "fas fa-laptop-code"
        },
        {
            header = "🔧 Ajustar Performance (Stage 3)",
            txt = "Turbo, Injeção e Mapas de Potência",
            icon = "fas fa-tachometer-alt",
            params = {
                event = "qb-tunerchip:client:TunePerformance",
                args = {
                    vehicle = vehicle
                }
            }
        },
        {
            header = "🚗 Ajustar Suspensão (Stance)",
            txt = "Altura da Suspensão e Camber",
            icon = "fas fa-angle-double-down",
            params = {
                event = "qb-tunerchip:client:TuneStance",
                args = {
                    vehicle = vehicle
                }
            }
        },
        {
            header = "🔄 Resetar Centralina",
            txt = "Restaurar Mapa Original (Fábrica)",
            icon = "fas fa-undo",
            params = {
                isServer = false,
                event = "qb-tunerchip:client:ResetStats",
                args = {
                    vehicle = vehicle
                }
            }
        }
    }
    exports['qb-menu']:openMenu(menu)
end

-- Eventos de Tuning (PERFORMANCE & STANCE APENAS)

RegisterNetEvent('qb-tunerchip:client:TunePerformance', function(data)
    -- LER VALORES ATUAIS
    local currBoost = GetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fDriveInertia")
    local currFuel = GetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fInitialDriveForce")
    local currBrake = GetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fBrakeForce")
    local currDrive = GetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fDriveBiasFront")

    local sBoost = string.format("%.2f", currBoost)
    local sFuel = string.format("%.3f", currFuel)
    local sBrake = string.format("%.2f", currBrake)
    local sDrive = string.format("%.2f", currDrive)

    local dialog = exports['qb-input']:ShowInput({
        header = "Reprogramação Stage 3",
        submitText = "Gravar Mapa",
        inputs = {
            {
                text = "Turbo Boost (0.1 - 3.0) [Atual: " .. sBoost .. "]",
                name = "boost",
                type = "text",
                isRequired = true,
                default = sBoost
            },
            {
                text = "Aceleração (0.1 - 2.0) [Atual: " .. sFuel .. "]",
                name = "fuelmix",
                type = "text",
                isRequired = true,
                default = sFuel
            },
            {
                text = "Travagem (0.1 - 2.0) [Atual: " .. sBrake .. "]",
                name = "brakes",
                type = "text",
                isRequired = true,
                default = sBrake
            },
            {
                text = "Tração (0.0 Trás - 1.0 Frente) [Atual: " .. sDrive .. "]",
                name = "driveforce",
                type = "text",
                isRequired = true,
                default = sDrive
            }
        }
    })

    if dialog then
        local boost = tonumber(dialog.boost)
        local fuel = tonumber(dialog.fuelmix)
        local brakes = tonumber(dialog.brakes)
        local drive = tonumber(dialog.driveforce)

        if not boost or not fuel or not brakes or not drive then
            QBCore.Functions.Notify("Tens de escrever números válidos!", "error")
            return
        end

        -- LIMITES (MANTOVEMOS OS AGRESSIVOS DA VERSÃO ANTERIOR)
        if boost > 3.0 then boost = 3.0 QBCore.Functions.Notify("Boost Máximo: 3.0", "error") end
        if boost < 0.1 then boost = 0.1 end
        
        if fuel > 2.0 then fuel = 2.0 QBCore.Functions.Notify("Aceleração Máxima: 2.0", "error") end
        if fuel < 0.1 then fuel = 0.1 end

        if brakes > 2.0 then brakes = 2.0 end
        if brakes < 0.1 then brakes = 0.1 end
        
        if drive > 1.0 then drive = 1.0 end
        if drive < 0.0 then drive = 0.0 end

        -- Aplicação
        SetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fDriveInertia", boost + 0.0)
        SetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fInitialDriveForce", fuel + 0.0)
        SetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fBrakeForce", brakes + 0.0)
        SetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fDriveBiasFront", drive + 0.0)
        
        SetVehicleModKit(data.vehicle, 0) -- Atualizar física

        QBCore.Functions.Notify("Mapa de Potência Carregado na ECU!", "success")
        TriggerServerEvent('qb-tunerchip:server:TuneStatus', 'performance', true)
    end
end)

RegisterNetEvent('qb-tunerchip:client:TuneStance', function(data)
    local currHeight = GetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fSuspensionLowerLimitOffsets")
    local sHeight = string.format("%.3f", currHeight)

    local dialog = exports['qb-input']:ShowInput({
        header = "Suspensão (Stance)",
        submitText = "Calibrar",
        inputs = {
            {
                text = "Altura (-0.20 a 0.20) [Atual: " .. sHeight .. "]",
                name = "lowering",
                type = "text",
                isRequired = true,
                default = sHeight
            }
        }
    })

    if dialog then
        local height = tonumber(dialog.lowering)
        
        if not height then 
            QBCore.Functions.Notify("Número inválido!", "error") 
            return 
        end
        
        if height < -0.25 then height = -0.25 end 
        if height > 0.25 then height = 0.25 end

        SetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fSuspensionLowerLimitOffsets", height + 0.0)
        
        -- Atualizar visualmente a suspensão
        SetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fSuspensionForce", GetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fSuspensionForce") + 0.01)
        Wait(100)
        SetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fSuspensionForce", GetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fSuspensionForce") - 0.01)

        QBCore.Functions.Notify("Suspensão Calibrada!", "success")
    end
end)

RegisterNetEvent('qb-tunerchip:client:ResetStats', function(data)
    QBCore.Functions.Progressbar("reset_ecu", "A restaurar valores de fábrica...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        flags = 49,
    }, {}, {}, function() -- Done
        -- Reset para valores base
        SetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fDriveInertia", 1.0)
        SetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fInitialDriveForce", 0.32) 
        SetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fBrakeForce", 0.8)
        SetVehicleHandlingFloat(data.vehicle, "CHandlingData", "fSuspensionLowerLimitOffsets", 0.0)
        QBCore.Functions.Notify("ECU Restaurada.", "success")
    end, function() -- Cancel
        QBCore.Functions.Notify("Cancelado.", "error")
    end)
end)

-- Abrir Menu com o Item
RegisterNetEvent('qb-tunerchip:client:openMenu', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then 
        QBCore.Functions.Notify("Tens de estar dentro de um veículo!", "error")
        return 
    end

    if GetPedInVehicleSeat(vehicle, -1) ~= ped then
        QBCore.Functions.Notify("Tens de estar no lugar do condutor!", "error")
        return
    end

    OpenTunerMenu(vehicle)
end)