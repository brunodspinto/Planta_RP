QBCore = exports['qb-core']:GetCoreObject()
local particleEffects = {}
local isPainting = false

-- TRADUÇÃO E LÓGICA POR: BOSS ENGENHEIRO

-- Funções Auxiliares de Pintura

local function HexToRGB(hex)
    if type(hex) ~= 'string' or not hex:match('^#?[%x]+$') or (#hex ~= 6 and #hex ~= 7) then return end
    hex = hex:gsub('#', '')
    return {
        r = tonumber('0x' .. hex:sub(1, 2)),
        g = tonumber('0x' .. hex:sub(3, 4)),
        b = tonumber('0x' .. hex:sub(5, 6))
    }
end

local function GetHex(category, id)
    local hex
    for i = 1, #Config.Paints[category] do
        if Config.Paints[category][i].id == tonumber(id) then
            hex = Config.Paints[category][i].hex
            break
        end
    end
    return hex
end

local function GetPaints(category)
    local Paints = {}
    Paints[#Paints + 1] = { value = 'none', text = 'Nenhuma' }
    for i = 1, #Config.Paints[category] do
        Paints[#Paints + 1] = {
            value = Config.Paints[category][i].id,
            text = Config.Paints[category][i].label
        }
    end
    return Paints
end

local function PaintList(category)
    local paintOptions = GetPaints(category)
    local dialog = exports['qb-input']:ShowInput({
        header = 'Pintura do Veículo',
        submitText = 'Confirmar',
        inputs = {
            {
                text = 'Primária',
                name = 'primarypaint',
                type = 'select',
                options = paintOptions
            },
            {
                text = 'Secundária',
                name = 'secondarypaint',
                type = 'select',
                options = paintOptions
            },
            {
                text = 'Perolada',
                name = 'pearlescentpaint',
                type = 'select',
                options = paintOptions
            },
            {
                text = 'Rodas',
                name = 'wheelpaint',
                type = 'select',
                options = paintOptions
            }
        }
    })
    if not dialog then return end
    if dialog.primarypaint and dialog.secondarypaint and dialog.pearlescentpaint and dialog.wheelpaint then
        local colors = {
            primary = dialog.primarypaint ~= 'none' and HexToRGB(GetHex(category, dialog.primarypaint)) or nil,
            secondary = dialog.secondarypaint ~= 'none' and HexToRGB(GetHex(category, dialog.secondarypaint)) or nil,
            pearlescent = dialog.pearlescentpaint ~= 'none' and HexToRGB(GetHex(category, dialog.pearlescentpaint)) or nil,
            wheel = dialog.wheelpaint ~= 'none' and HexToRGB(GetHex(category, dialog.wheelpaint)) or nil
        }
        local vehicle, distance = QBCore.Functions.GetClosestVehicle()
        if vehicle == 0 or distance > 5.0 then return end
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        if isPainting then return end
        TriggerServerEvent('qb-mechanicjob:server:sprayVehicle', netId, dialog.primarypaint, dialog.secondarypaint, dialog.pearlescentpaint, dialog.wheelpaint, colors)
    end
end

local function CustomColor()
    local dialog = exports['qb-input']:ShowInput({
        header = 'Cor Personalizada',
        submitText = 'Confirmar',
        inputs = {
            {
                text = 'HEX (Ex: #FF0000)',
                name = 'hex',
                type = 'text',
                isRequired = false
            },
            {
                text = '',
                name = 'colorpicker',
                type = 'color',
                isRequired = false
            },
            {
                text = 'Secção',
                name = 'section',
                type = 'radio',
                options = {
                    { value = 'primary',   text = 'Primária' },
                    { value = 'secondary', text = 'Secundária' }
                }
            },
            {
                text = 'Tipo',
                name = 'paintType',
                type = 'radio',
                options = {
                    { value = 'metallic', text = 'Metálica' },
                    { value = 'matte',    text = 'Matte (Fosco)' },
                    { value = 'chrome',   text = 'Cromado' }
                }
            }
        }
    })
    if not dialog then return end
    if (dialog.hex or dialog.colorpicker) and dialog.section then
        local color = (dialog.hex and dialog.hex ~= '') and dialog.hex or dialog.colorpicker
        local vehicle, distance = QBCore.Functions.GetClosestVehicle()
        if vehicle == 0 or distance > 5.0 then return end
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        if isPainting then return end
        TriggerServerEvent('qb-mechanicjob:server:sprayVehicleCustom', netId, dialog.section, dialog.paintType, HexToRGB(color))
    end
end

function PaintCategories()
    local Paints = { { header = 'Categorias de Pintura', isMenuHeader = true, icon = 'fas fa-fill' } }
    Paints[#Paints + 1] = {
        header = 'Cor Personalizada (HEX/RGB)',
        params = {
            isAction = true,
            event = function()
                CustomColor()
            end,
            args = {}
        }
    }
    for k in pairs(Config.Paints) do
        Paints[#Paints + 1] = {
            header = k, -- Nome da categoria (Metallic, Matte, etc)
            params = {
                isAction = true,
                event = function()
                    PaintList(k)
                end,
                args = {}
            }
        }
    end
    exports['qb-menu']:openMenu(Paints)
end

-- Interior

local function OpenInteriors(vehicle)
    local mods = { { header = 'Interior', isMenuHeader = true, icon = 'fas fa-chair' } }
    for i = 1, #Config.InteriorCategories do
        local modCount = GetNumVehicleMods(vehicle, Config.InteriorCategories[i].id)
        if modCount > 0 then
            mods[#mods + 1] = {
                header = Config.InteriorCategories[i].label,
                params = {
                    isAction = true,
                    event = function()
                        InteriorModList(Config.InteriorCategories[i].id, vehicle, Config.InteriorCategories[i].label)
                    end,
                    args = {}
                }
            }
        end
    end
    exports['qb-menu']:openMenu(mods)
end

function InteriorModList(id, vehicle, label)
    local mods = { { header = label, isMenuHeader = true, icon = 'fas fa-chair' } }
    mods[#mods + 1] = {
        header = 'Voltar',
        icon = 'fas fa-backward',
        params = {
            isAction = true,
            event = function()
                OpenInteriors(vehicle)
            end,
            args = {}
        }
    }
    for i = 0, GetNumVehicleMods(vehicle, id) - 1 do
        local modHeader
        if id == 14 then
            modHeader = Config.HornLabels[i] or 'Desconhecido'
        else
            local modTextLabel = GetModTextLabel(vehicle, id, i)
            modHeader = modTextLabel and GetLabelText(modTextLabel) or 'Mod ' .. i
        end

        mods[#mods + 1] = {
            header = modHeader,
            params = {
                isAction = true,
                event = function(data)
                    SetVehicleModKit(vehicle, 0)
                    SetVehicleMod(vehicle, data.modType, data.modIndex, false)
                    if id == 14 then
                        StartVehicleHorn(vehicle, 10000, 0, false)
                    end
                    InteriorModList(id, vehicle, label)
                end,
                args = {
                    modType = id,
                    modIndex = i
                }
            }
        }
    end
    exports['qb-menu']:openMenu(mods)
end

-- Exterior

local function OpenExteriors(vehicle)
    local mods = { { header = 'Exterior', isMenuHeader = true, icon = 'fas fa-car-side' } }
    for i = 1, #Config.ExteriorCategories do
        local modCount = GetNumVehicleMods(vehicle, Config.ExteriorCategories[i].id)
        if modCount > 0 then
            mods[#mods + 1] = {
                header = Config.ExteriorCategories[i].label,
                params = {
                    isAction = true,
                    event = function()
                        ExteriorModList(Config.ExteriorCategories[i].id, vehicle, Config.ExteriorCategories[i].label)
                    end,
                    args = {}
                }
            }
        end
    end
    exports['qb-menu']:openMenu(mods)
end

function ExteriorModList(id, vehicle, label)
    local mods = { { header = label, isMenuHeader = true, icon = 'fas fa-car-side' } }
    mods[#mods + 1] = {
        header = 'Voltar',
        icon = 'fas fa-backward',
        params = {
            isAction = true,
            event = function()
                OpenExteriors(vehicle)
            end,
            args = {}
        }
    }
    for i = 1, GetNumVehicleMods(vehicle, id) - 1 do
        mods[#mods + 1] = {
            header = GetLabelText(GetModTextLabel(vehicle, id, i)),
            params = {
                isAction = true,
                event = function()
                    SetVehicleModKit(vehicle, 0)
                    SetVehicleMod(vehicle, id, i, false)
                    ExteriorModList(id, vehicle, label)
                end,
                args = {}
            }
        }
    end
    exports['qb-menu']:openMenu(mods)
end

-- Tire Smoke (Fumo dos Pneus)

local function GetSmokeList()
    local smokes = {}
    for i = 1, #Config.TyreSmoke do
        smokes[#smokes + 1] = {
            value = Config.TyreSmoke[i].label,
            text = Config.TyreSmoke[i].label
        }
    end
    return smokes
end

local function GetSmokeColors(color)
    for i = 1, #Config.TyreSmoke do
        if Config.TyreSmoke[i].label == color then
            return Config.TyreSmoke[i].r, Config.TyreSmoke[i].g, Config.TyreSmoke[i].b
        end
    end
end

local function TireSmoke(vehicle)
    local dialog = exports['qb-input']:ShowInput({
        header = 'Fumo dos Pneus',
        submitText = 'Confirmar',
        inputs = {
            {
                text = 'HEX (Ex: #FF0000)',
                name = 'hex',
                type = 'text',
                isRequired = false
            },
            {
                text = '',
                name = 'colorpicker',
                type = 'color',
                isRequired = false
            },
            {
                text = 'Cores Padrão',
                name = 'color',
                type = 'select',
                options = GetSmokeList()
            },
            {
                text = 'Opções',
                name = 'toggle',
                type = 'radio',
                options = {
                    { value = 'togglehex',      text = 'Cor Personalizada' },
                    { value = 'togglestandard', text = 'Cor Padrão' },
                }
            }
        }
    })
    if not dialog then return end

    if dialog.toggle == 'togglehex' and dialog.hex ~= '' then
        local color = HexToRGB(dialog.hex)
        ToggleVehicleMod(vehicle, 20, true)
        SetVehicleTyreSmokeColor(vehicle, color.r, color.g, color.b)
    elseif dialog.toggle == 'togglestandard' and dialog.colorpicker ~= '' then
        local color = HexToRGB(dialog.colorpicker)
        ToggleVehicleMod(vehicle, 20, true)
        SetVehicleTyreSmokeColor(vehicle, color.r, color.g, color.b)
    elseif dialog.toggle == 'togglestandard' and tonumber(dialog.color) then
        ToggleVehicleMod(vehicle, 20, true)
        SetVehicleTyreSmokeColor(vehicle, GetSmokeColors(dialog.color))
    else
        ToggleVehicleMod(vehicle, 20, false)
    end
end

-- Wheels (Rodas)

local function OpenWheels(vehicle)
    local mods = { { header = 'Rodas e Pneus', isMenuHeader = true, icon = 'fas fa-truck-monster' } }
    mods[#mods + 1] = {
        header = 'Fumo dos Pneus',
        icon = 'fas fa-smog',
        params = {
            isAction = true,
            event = function()
                TireSmoke(vehicle)
            end,
            args = {}
        }
    }
    for i = 1, #Config.WheelCategories do
        mods[#mods + 1] = {
            header = Config.WheelCategories[i].label,
            params = {
                isAction = true,
                event = function()
                    OpenWheelList(Config.WheelCategories[i].id, vehicle, Config.WheelCategories[i].label)
                end,
                args = {}
            }
        }
    end
    exports['qb-menu']:openMenu(mods)
end

function OpenWheelList(id, vehicle, label)
    local mods = { { header = label, isMenuHeader = true, icon = 'fas fa-truck-monster' } }
    mods[#mods + 1] = {
        header = 'Voltar',
        icon = 'fas fa-backward',
        params = {
            isAction = true,
            event = function()
                OpenWheels(vehicle)
            end,
            args = {}
        }
    }
    SetVehicleWheelType(vehicle, id)
    for i = 1, GetNumVehicleMods(vehicle, 23) - 1 do
        mods[#mods + 1] = {
            header = GetLabelText(GetModTextLabel(vehicle, 23, i)),
            params = {
                isAction = true,
                event = function()
                    SetVehicleModKit(vehicle, 0)
                    SetVehicleMod(vehicle, 23, i, false)
                    OpenWheelList(id, vehicle, label)
                end,
                args = {}
            }
        }
    end
    exports['qb-menu']:openMenu(mods)
end

-- Neons

local function GetNeonList()
    local neons = {}
    for i = 1, #Config.NeonColors do
        neons[#neons + 1] = {
            value = Config.NeonColors[i].label,
            text = Config.NeonColors[i].label
        }
    end
    return neons
end

local function GetNeonColors(color)
    for i = 1, #Config.NeonColors do
        if Config.NeonColors[i].label == color then
            return Config.NeonColors[i].r, Config.NeonColors[i].g, Config.NeonColors[i].b
        end
    end
end

local function OpenNeon(vehicle)
    local dialog = exports['qb-input']:ShowInput({
        header = 'Configuração de Neons',
        submitText = 'Confirmar',
        inputs = {
            {
                text = 'Cor',
                name = 'color',
                type = 'select',
                options = GetNeonList()
            },
            {
                text = 'Frente',
                name = 'frontenable',
                type = 'radio',
                options = {
                    { value = 'enable',  text = 'Ativado' },
                    { value = 'disable', text = 'Desativado' },
                }
            },
            {
                text = 'Trás',
                name = 'rearenable',
                type = 'radio',
                options = {
                    { value = 'enable',  text = 'Ativado' },
                    { value = 'disable', text = 'Desativado' },
                }
            },
            {
                text = 'Esquerda',
                name = 'leftenable',
                type = 'radio',
                options = {
                    { value = 'enable',  text = 'Ativado' },
                    { value = 'disable', text = 'Desativado' },
                }
            },
            {
                text = 'Direita',
                name = 'rightenable',
                type = 'radio',
                options = {
                    { value = 'enable',  text = 'Ativado' },
                    { value = 'disable', text = 'Desativado' },
                }
            }
        }
    })
    if not dialog then return end

    if dialog.frontenable == 'enable' then
        SetVehicleNeonLightEnabled(vehicle, 2, true)
    else
        SetVehicleNeonLightEnabled(vehicle, 2, false)
    end

    if dialog.rearenable == 'enable' then
        SetVehicleNeonLightEnabled(vehicle, 3, true)
    else
        SetVehicleNeonLightEnabled(vehicle, 3, false)
    end

    if dialog.leftenable == 'enable' then
        SetVehicleNeonLightEnabled(vehicle, 0, true)
    else
        SetVehicleNeonLightEnabled(vehicle, 0, false)
    end

    if dialog.rightenable == 'enable' then
        SetVehicleNeonLightEnabled(vehicle, 1, true)
    else
        SetVehicleNeonLightEnabled(vehicle, 1, false)
    end

    SetVehicleNeonLightsColour(vehicle, GetNeonColors(dialog.color))
end

-- Headlights (Xénon)

local function GetXenonList()
    local xenons = {}
    for i = 1, #Config.Xenon do
        xenons[#xenons + 1] = {
            value = Config.Xenon[i].id,
            text = Config.Xenon[i].label
        }
    end
    return xenons
end

local function OpenXenon(vehicle)
    local dialog = exports['qb-input']:ShowInput({
        header = 'Luzes Xénon',
        submitText = 'Confirmar',
        inputs = {
            {
                text = 'Estado',
                name = 'toggle',
                type = 'radio',
                options = {
                    { value = 'enable',  text = 'Instalar (Branco Padrão)' },
                    { value = 'disable', text = 'Remover' },
                    { value = 'custom',  text = 'Cor Personalizada' }
                }
            },
            {
                text = 'Cor (Se escolheste Personalizada)',
                name = 'color',
                type = 'select',
                options = GetXenonList()
            }
        }
    })
    if not dialog then return end

    -- Remover
    if dialog.toggle == 'disable' then
        ToggleVehicleMod(vehicle, 22, false) -- 22 é o ID do Xénon
        TriggerServerEvent('qb-mechanicjob:server:removeItem', 'veh_xenons')
        return
    end

    -- Instalar Padrão (Mais Seguro)
    if dialog.toggle == 'enable' then
        ToggleVehicleMod(vehicle, 22, true)
        SetVehicleXenonLightsColor(vehicle, -1) -- Cor Padrão
        TriggerServerEvent('qb-mechanicjob:server:removeItem', 'veh_xenons')
        return
    end

    -- Instalar Cor (Com verificação de segurança)
    if dialog.toggle == 'custom' and tonumber(dialog.color) then
        ToggleVehicleMod(vehicle, 22, true)
        Wait(100) -- Pequena pausa para o sistema processar
        SetVehicleXenonLightsColor(vehicle, tonumber(dialog.color))
        TriggerServerEvent('qb-mechanicjob:server:removeItem', 'veh_xenons')
    end
end

-- Window Tint (Películas)

local function WindowTint(vehicle)
    local tints = { { header = 'Películas (Vidros Fumados)', isMenuHeader = true, icon = 'fas fa-window-maximize' } }
    if GetNumVehicleWindowTints() > 0 then
        for i = 1, #Config.WindowTints do
            tints[#tints + 1] = {
                header = Config.WindowTints[i].label,
                params = {
                    isAction = true,
                    event = function()
                        SetVehicleModKit(vehicle, 0)
                        SetVehicleWindowTint(vehicle, Config.WindowTints[i].id)
                        WindowTint(vehicle)
                    end,
                    args = {}
                }
            }
        end
    end
    exports['qb-menu']:openMenu(tints)
end

-- Plates (Matrículas)

local function PlateIndex(vehicle)
    local plates = { { header = 'Estilo de Matrícula', isMenuHeader = true, icon = 'fas fa-id-card' } }
    for i = 1, #Config.PlateIndexes do
        plates[#plates + 1] = {
            header = Config.PlateIndexes[i].label,
            params = {
                isAction = true,
                event = function()
                    SetVehicleNumberPlateTextIndex(vehicle, Config.PlateIndexes[i].id)
                    PlateIndex(vehicle)
                end,
                args = {}
            }
        }
    end
    exports['qb-menu']:openMenu(plates)
end

-- Eventos de Servidor e Efeitos

RegisterNetEvent('qb-mechanicjob:client:vehicleSetColors', function(netId, section, colorIndex)
    if not NetworkDoesEntityExistWithNetworkId(netId) then return end
    local vehicle = NetworkGetEntityFromNetworkId(netId)

    if section == 'primary' then
        local _, colorSecondary = GetVehicleColours(vehicle)
        ClearVehicleCustomPrimaryColour(vehicle)
        SetVehicleColours(vehicle, tonumber(colorIndex), colorSecondary)
    end

    if section == 'secondary' then
        local colorPrimary, _ = GetVehicleColours(vehicle)
        ClearVehicleCustomSecondaryColour(vehicle)
        SetVehicleColours(vehicle, colorPrimary, tonumber(colorIndex))
    end

    if section == 'pearlescent' then
        local _, wheelColor = GetVehicleExtraColours(vehicle)
        SetVehicleExtraColours(vehicle, tonumber(colorIndex), wheelColor)
    end

    if section == 'wheel' then
        local pearlescentColor, _ = GetVehicleExtraColours(vehicle)
        SetVehicleExtraColours(vehicle, pearlescentColor, tonumber(colorIndex))
    end

        
    local props = QBCore.Functions.GetVehicleProperties(vehicle)
    TriggerServerEvent('qb-mechanicjob:server:SaveVehicleProps', props)
end)

RegisterNetEvent('qb-mechanicjob:client:startParticles', function(netId, color)
    isPainting = true
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not color then color = { r = 255, g = 255, b = 255 } end
    UseParticleFxAsset('core')
    local offsetX, offsetY, offsetZ = 0.0, 0.0, 3.0
    local xRot, yRot, zRot = 0.0, 180.0, 0.0
    local scale = 1.5
    local effect = StartNetworkedParticleFxLoopedOnEntity('ent_amb_steam', vehicle, offsetX, offsetY, offsetZ, xRot, yRot, zRot, scale, false, false, false)
    particleEffects[#particleEffects + 1] = effect
    SetParticleFxLoopedAlpha(effect, 100.0)
    SetParticleFxLoopedColour(effect, color.r / 255.0, color.g / 255.0, color.b / 255.0, 0)
end)

RegisterNetEvent('qb-mechanicjob:client:stopParticles', function()
    isPainting = false
    for _, effect in ipairs(particleEffects) do
        StopParticleFxLooped(effect, true)
    end
end)

-- EVENTO PRINCIPAL: Instalação e Permissões

RegisterNetEvent('qb-mechanicjob:client:installCosmetic', function(item)
    local vehicle, distance = QBCore.Functions.GetClosestVehicle()
    if vehicle == 0 or distance > 5.0 then return end
    
    local vehicleClass = GetVehicleClass(vehicle)
    if Config.IgnoreClasses[vehicleClass] then return end

    -- === LÓGICA DE ENGENHARIA === --
    local PlayerJob = QBCore.Functions.GetPlayerData().job
    local jobName = PlayerJob.name
    
    -- Permitir tanto Benny's (Legal) como Tuners (Ilegal) fazerem estética
    -- Porque até os criminosos precisam de mudar a cor do carro para fugir!
    if jobName ~= "bennys" and jobName ~= "tuners" then
        QBCore.Functions.Notify("Apenas mecânicos autorizados podem modificar a estética!", "error")
        return
    end

    if GetVehicleModKit(vehicle) ~= 0 then SetVehicleModKit(vehicle, 0) end
    
    if item == 'veh_interior' then
        OpenInteriors(vehicle)
        TriggerServerEvent('qb-mechanicjob:server:removeItem', item)
    elseif item == 'veh_exterior' then
        OpenExteriors(vehicle)
        TriggerServerEvent('qb-mechanicjob:server:removeItem', item)
    elseif item == 'veh_wheels' then
        OpenWheels(vehicle)
        TriggerServerEvent('qb-mechanicjob:server:removeItem', item)
    elseif item == 'veh_neons' then
        OpenNeon(vehicle)
        TriggerServerEvent('qb-mechanicjob:server:removeItem', item)
    elseif item == 'veh_xenons' then
        OpenXenon(vehicle)
        TriggerServerEvent('qb-mechanicjob:server:removeItem', item)
    elseif item == 'veh_tint' then
        WindowTint(vehicle)
        TriggerServerEvent('qb-mechanicjob:server:removeItem', item)
    elseif item == 'veh_plates' then
        if not IsNearBone(vehicle, 'platelight') then 
            QBCore.Functions.Notify("Chega-te perto da matrícula!", "error")
            return 
        end
        PlateIndex(vehicle)
        TriggerServerEvent('qb-mechanicjob:server:removeItem', item)
    end
end)

-- Threads

CreateThread(function()
    RequestNamedPtfxAsset('core')
    while not HasNamedPtfxAssetLoaded('core') do
        Wait(0)
        RequestNamedPtfxAsset('core')
    end
end)