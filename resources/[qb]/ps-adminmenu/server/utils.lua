local function noPerms(source)
    QBCore.Functions.Notify(source, "You are not Admin or God.", 'error')
end

--- @param perms string
function CheckPerms(source, perms)
    local hasPerms = QBCore.Functions.HasPermission(source, perms)
    if not hasPerms then
        return noPerms(source)
    end

    return hasPerms
end

-- Permissão exigida por cada handler, declarada no servidor.
-- Antes, cada handler recebia do CLIENTE a chave da ação e usava a permissão
-- dessa ação (CheckDataFromKey), sem confirmar que a ação correspondia ao
-- handler: um mod podia enviar a chave de uma ação 'mod' e passar num handler
-- de nível 'admin'. Agora cada handler indica o próprio nome de evento e a
-- permissão é a da(s) ação(ões) da config que disparam esse evento.
local PERMS_RANK = { mod = 1, admin = 2, god = 3 }

local function stricterPerms(a, b)
    if not a then return b end
    if not b then return a end
    return (PERMS_RANK[a] or 99) >= (PERMS_RANK[b] or 99) and a or b
end

local function findAction(key)
    return Config.Actions[key] or Config.PlayerActions[key] or Config.OtherActions[key]
end

local EventPerms = {}
for _, section in ipairs({ Config.Actions, Config.PlayerActions, Config.OtherActions }) do
    for _, action in pairs(section) do
        local events = { action.event }
        for _, item in pairs(action.dropdown or {}) do events[#events + 1] = item.event end
        for _, event in pairs(events) do
            if event then EventPerms[event] = stricterPerms(EventPerms[event], action.perms) end
        end
    end
end

-- Handlers disparados pelo cliente A SEGUIR a uma ação do menu (o evento não
-- aparece na config): exigem a permissão da ação de origem.
local LinkedActions = {
    ['ps-adminmenu:server:SaveCar']             = 'admin_car',
    ['ps-adminmenu:server:ChangePlate']         = 'change_plate',
    ['ps-adminmenu:callback:CheckAlreadyPlate'] = 'change_plate',
    ['ps-adminmenu:server:GetVehicleByPlate']   = 'spawnPersonalVehicle',
    ['ps-adminmenu:spectate:teleport']          = 'spectate_player',
    ['ps-adminmenu:server:OpenInv']             = 'open_inventory',
    ['ps-adminmenu:server:OpenStash']           = 'open_stash',
    ['ps-adminmenu:server:OpenTrunk']           = 'open_trunk',
}
for event, key in pairs(LinkedActions) do
    local action = findAction(key)
    if action then EventPerms[event] = stricterPerms(EventPerms[event], action.perms) end
end
EventPerms['ps-adminmenu:callback:GetResources'] = Config.ResourcePerms

--- Verifica se `source` tem a permissão declarada para o handler `eventName`.
--- Falha fechado: um evento sem permissão declarada é sempre recusado.
--- @param eventName string
function CheckEventPerms(source, eventName)
    local perms = EventPerms[eventName]
    if not perms then
        print(('[ps-adminmenu] Sem permissão declarada para %s: pedido recusado'):format(eventName))
        return noPerms(source)
    end
    return CheckPerms(source, perms)
end

--- Permissão declarada para um evento (para testes/diagnóstico).
function GetEventPerms(eventName)
    return EventPerms[eventName]
end

---@param plate string
---@return boolean
function CheckAlreadyPlate(plate)
    local vPlate = QBCore.Shared.Trim(plate)
    local result = MySQL.single.await("SELECT plate FROM player_vehicles WHERE plate = ?", { vPlate })
    if result and result.plate then return true end
    return false
end

lib.callback.register('ps-adminmenu:callback:CheckPerms', function(source, perms)
    return CheckPerms(source, perms)
end)

lib.callback.register('ps-adminmenu:callback:CheckAlreadyPlate', function(source, vPlate)
    if not CheckEventPerms(source, 'ps-adminmenu:callback:CheckAlreadyPlate') then return nil end
    return CheckAlreadyPlate(vPlate)
end)

--- @param source number
--- @param target number
function CheckRoutingbucket(source, target)
    local sourceBucket = GetPlayerRoutingBucket(source)
    local targetBucket = GetPlayerRoutingBucket(target)

    if sourceBucket == targetBucket then return end

    SetPlayerRoutingBucket(source, targetBucket)
    QBCore.Functions.Notify(source, locale("bucket_set", targetBucket), 'error', 7500)
end
