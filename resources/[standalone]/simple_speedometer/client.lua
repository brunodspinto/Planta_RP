local QBCore = exports['qb-core']:GetCoreObject()

-- CONFIGURAÇÃO VISUAL
local posX = 0.88  -- Canto Inferior Direito (Eixo X)
local posY = 0.88  -- Canto Inferior Direito (Eixo Y)

-- Variável de Estado do Cinto
local seatbeltOn = false

-- Evento para detetar quando metes/tiras o cinto (Padrão QBCore)
RegisterNetEvent('seatbelt:client:ToggleSeatbelt', function()
    seatbeltOn = not seatbeltOn
end)

-- Função para desenhar texto
local function DrawHudText(text, x, y, scale, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Thread Principal
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            -- Mostrar apenas para o condutor
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                sleep = 0
                
                -- === CÁLCULOS === --
                local speed = GetEntitySpeed(vehicle) * 3.6 
                local rpm = GetVehicleCurrentRpm(vehicle)
                local gear = GetVehicleCurrentGear(vehicle)
                local fuel = GetVehicleFuelLevel(vehicle)

                -- Lógica da Mudança
                if speed > 0 and GetEntitySpeedVector(vehicle, true).y < 0 then 
                    gear = "R"
                elseif speed < 1 and gear == 0 then
                    gear = "N"
                end

                -- Cores do RPM
                local r, g, b = 255, 255, 255
                if rpm > 0.9 then r, g, b = 255, 50, 50 elseif rpm > 0.75 then r, g, b = 255, 180, 50 end

                -- Cores do Cinto (Verde = Seguro / Vermelho = Perigo)
                local beltColorR, beltColorG, beltColorB = 255, 50, 50 -- Vermelho por defeito
                local beltText = "CINTO OFF"
                if seatbeltOn then 
                    beltColorR, beltColorG, beltColorB = 50, 255, 50 -- Verde
                    beltText = "CINTO ON"
                end

                -- === DESENHO NO ECRÃ === --
                
                -- 1. Velocidade
                DrawHudText(math.floor(speed), posX, posY, 0.8, 255, 255, 255, 255)
                DrawHudText("KM/H", posX + 0.035, posY + 0.015, 0.35, 200, 200, 200, 255)

                -- 2. Informações (Mudança | Gasolina | Cinto)
                DrawHudText("⚙️ " .. gear, posX + 0.005, posY + 0.05, 0.4, r, g, b, 255)
                
                local fuelR, fuelG = 255, 255
                if fuel < 20 then fuelR, fuelG = 255, 50 end
                DrawHudText("⛽ " .. math.floor(fuel) .. "%", posX + 0.035, posY + 0.05, 0.4, fuelR, fuelG, 255, 200)

                -- 3. Cinto de Segurança (Novo)
                DrawHudText(beltText, posX + 0.075, posY + 0.05, 0.4, beltColorR, beltColorG, beltColorB, 255)
            end
        else
            -- Se sair do carro, reseta o estado visual do cinto (opcional)
            seatbeltOn = false 
        end
        
        Wait(sleep)
    end
end)