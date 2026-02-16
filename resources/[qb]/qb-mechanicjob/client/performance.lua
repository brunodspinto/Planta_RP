-- TRADUÇÃO E LÓGICA POR: BOSS ENGENHEIRO

-- Funções dos Menus (Traduzidas)

local function GetArmor(vehicle)
    local armorMenu = { { header = 'Blindagem', isMenuHeader = true, icon = 'fas fa-shield-alt' } }
    
    for i = -1, GetNumVehicleMods(vehicle, 16) - 1 do
        local header = 'Blindagem: ' .. (i >= 0 and (i + 1) or 'Original')
        local disabled = GetVehicleMod(vehicle, 16) == i
        
        local armorItem = {
            header = header,
            disabled = disabled,
            params = {
                event = 'qb-mechanicjob:client:install',
                args = {
                    upgradeType = 'armor',
                    modType = 16,
                    upgradeIndex = i,
                    vehicle = vehicle
                }
            }
        }
        armorMenu[#armorMenu + 1] = armorItem
    end
    exports['qb-menu']:openMenu(armorMenu, true)
end

local function GetBrakes(vehicle)
    local brakesMenu = { { header = 'Travões', isMenuHeader = true, icon = 'fas fa-car' } }
    
    for i = -1, GetNumVehicleMods(vehicle, 12) - 1 do
        local header = 'Travões: ' .. (i >= 0 and (i + 1) or 'Original')
        local disabled = GetVehicleMod(vehicle, 12) == i
        
        local brakesItem = {
            header = header,
            disabled = disabled,
            params = {
                event = 'qb-mechanicjob:client:install',
                args = {
                    upgradeType = 'brakes',
                    modType = 12,
                    upgradeIndex = i,
                    vehicle = vehicle
                }
            }
        }
        brakesMenu[#brakesMenu + 1] = brakesItem
    end
    exports['qb-menu']:openMenu(brakesMenu, true)
end

local function GetEngine(vehicle)
    local engineMenu = { { header = 'Motor (Performance)', isMenuHeader = true, icon = 'fas fa-oil-can' } }
    
    for i = -1, GetNumVehicleMods(vehicle, 11) - 1 do
        local header = 'Motor Nível: ' .. (i >= 0 and (i + 1) or 'Original')
        local disabled = GetVehicleMod(vehicle, 11) == i
        
        local engineItem = {
            header = header,
            disabled = disabled,
            params = {
                event = 'qb-mechanicjob:client:install',
                args = {
                    upgradeType = 'engine',
                    modType = 11,
                    upgradeIndex = i,
                    vehicle = vehicle
                }
            }
        }
        engineMenu[#engineMenu + 1] = engineItem
    end
    exports['qb-menu']:openMenu(engineMenu, true)
end

local function GetSuspension(vehicle)
    local suspensionMenu = { { header = 'Suspensão', isMenuHeader = true, icon = 'fas fa-cogs' } }
    
    for i = -1, GetNumVehicleMods(vehicle, 15) - 1 do
        local header = 'Suspensão: ' .. (i >= 0 and (i + 1) or 'Original')
        local disabled = GetVehicleMod(vehicle, 15) == i
        
        local suspensionItem = {
            header = header,
            disabled = disabled,
            params = {
                event = 'qb-mechanicjob:client:install',
                args = {
                    upgradeType = 'suspension',
                    modType = 15,
                    upgradeIndex = i,
                    vehicle = vehicle
                }
            }
        }
        suspensionMenu[#suspensionMenu + 1] = suspensionItem
    end
    exports['qb-menu']:openMenu(suspensionMenu, true)
end

local function GetTransmission(vehicle)
    local transmissionMenu = { { header = 'Transmissão', isMenuHeader = true, icon = 'fas fa-cog' } }
    
    for i = -1, GetNumVehicleMods(vehicle, 13) - 1 do
        local header = 'Transmissão: ' .. (i >= 0 and (i + 1) or 'Original')
        local disabled = GetVehicleMod(vehicle, 13) == i
        
        local transmissionItem = {
            header = header,
            disabled = disabled,
            params = {
                event = 'qb-mechanicjob:client:install',
                args = {
                    upgradeType = 'transmission',
                    modType = 13,
                    upgradeIndex = i,
                    vehicle = vehicle
                }
            }
        }
        transmissionMenu[#transmissionMenu + 1] = transmissionItem
    end
    exports['qb-menu']:openMenu(transmissionMenu, true)
end

local function GetTurbo(vehicle)
    local turboMenu = { { header = 'Turbo Tuning', isMenuHeader = true, icon = 'fas fa-bolt' } }
    
    local txt = 'Instalar Turbo'
    local turbo = IsToggleModOn(vehicle, 18)
    if turbo then txt = 'Remover Turbo' end
    
    local turboItem = {
        header = 'Turbo',
        txt = txt,
        params = {
            event = 'qb-mechanicjob:client:install',
            args = {
                upgradeType = 'turbo',
                turbo = turbo,
                vehicle = vehicle
            }
        }
    }
    turboMenu[#turboMenu + 1] = turboItem
    exports['qb-menu']:openMenu(turboMenu, true)
end

-- Eventos de Instalação

RegisterNetEvent('qb-mechanicjob:client:install', function(data)
    local upgradeIndex = data.upgradeIndex
    local modType = data.modType
    local partName = data.upgradeType
    local animDict = 'mini@repair'
    local anim = 'fixing_a_player'
    local shouldToggleHood = false
    
    -- Definir animações baseadas na peça
    if partName == 'engine' or partName == 'transmission' or partName == 'turbo' then
        shouldToggleHood = true
    elseif partName == 'armor' or partName == 'brakes' or partName == 'suspension' then
        animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@'
        anim = 'machinic_loop_mechandplayer'
    end

    -- Barra de Progresso
    QBCore.Functions.Progressbar('mechanic_install', 'A instalar ' .. partName .. '...', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = animDict,
        anim = anim,
        flags = 1,
    }, {
        model = 'imp_prop_impexp_span_03',
        bone = 28422,
        coords = vec3(0.06, 0.01, -0.02),
        rotation = vec3(0.0, 0.0, 0.0),
    }, {}, function() -- Sucesso
        if partName == 'turbo' then
            ToggleVehicleMod(data.vehicle, 18, not data.turbo)
        else
            SetVehicleMod(data.vehicle, modType, upgradeIndex, false)
        end
        
        if shouldToggleHood then ToggleHood(data.vehicle) end
        
        -- Remove o item do inventário
        TriggerServerEvent('qb-mechanicjob:server:removeItem', 'veh_' .. partName)
        
        QBCore.Functions.Notify(partName .. ' instalado com sucesso!', 'success')
    end, function() -- Cancelado
        if shouldToggleHood then ToggleHood(data.vehicle) end
        QBCore.Functions.Notify('Instalação cancelada.', 'error')
    end)
end)

-- EVENTO PRINCIPAL: Onde filtramos quem pode fazer o quê
RegisterNetEvent('qb-mechanicjob:client:installPart', function(item)
    local vehicle, distance = QBCore.Functions.GetClosestVehicle()
    
    -- Verificações básicas
    if vehicle == 0 or distance > 5.0 then 
        QBCore.Functions.Notify('Nenhum veículo por perto!', 'error')
        return 
    end
    
    -- Verificar Emprego do Jogador
    local PlayerJob = QBCore.Functions.GetPlayerData().job
    local jobName = PlayerJob.name

    -- === LÓGICA DE ENGENHARIA: SEPARAÇÃO DE JOBS === --
    
    -- Se a peça for de PERFORMANCE (Motor, Transmissão, Turbo)
    if item == 'veh_engine' or item == 'veh_transmission' or item == 'veh_turbo' then
        
        -- Se for o Benny's (Legal), BLOQUEIA
        if jobName == "bennys" then
            QBCore.Functions.Notify('A tua licença não permite instalar modificações de performance ilegal!', 'error')
            return
        end
        
        -- Se for Civil ou outro job qualquer, BLOQUEIA (Opcional, mas seguro)
        if jobName ~= "tuners" and jobName ~= "bennys" then
             QBCore.Functions.Notify('Não sabes instalar isto!', 'error')
             return
        end
        
        -- Se for Tuners, PASSA (Código abaixo executa)
    end
    
    -- Configuração do ModKit (Necessário para tuning)
    if GetVehicleModKit(vehicle) ~= 0 then SetVehicleModKit(vehicle, 0) end

    -- Lógica de Instalação (Manutenção e Segurança - Permitido a todos os mecânicos)
    if item == 'veh_armor' or item == 'veh_brakes' or item == 'veh_suspension' then
        if GetClosestWheel(vehicle) == -1 then 
            QBCore.Functions.Notify('Tens de estar perto de uma roda!', 'error')
            return 
        end
        if item == 'veh_armor' then GetArmor(vehicle) end
        if item == 'veh_brakes' then GetBrakes(vehicle) end
        if item == 'veh_suspension' then GetSuspension(vehicle) end
        
    -- Lógica de Performance (Já filtrada acima pelo Job Check)
    elseif item == 'veh_engine' or item == 'veh_transmission' or item == 'veh_turbo' then
        if IsPedInAnyVehicle(PlayerPedId(), false) then return end
        
        if not IsNearBone(vehicle, 'engine') then 
            QBCore.Functions.Notify('Tens de estar perto do motor!', 'error')
            return 
        end
        
        if GetVehicleDoorAngleRatio(vehicle, 4) <= 0.0 then SetVehicleDoorOpen(vehicle, 4, false, false) end
        
        if item == 'veh_engine' then GetEngine(vehicle) end
        if item == 'veh_transmission' then GetTransmission(vehicle) end
        if item == 'veh_turbo' then GetTurbo(vehicle) end
    end
end)