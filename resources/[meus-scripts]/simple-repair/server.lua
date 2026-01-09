local QBCore = exports['qb-core']:GetCoreObject()

local Config = {
    Custo = 0, 
    ItemNecessario = 'repairkit', 
    ConsumirItem = true 
}

-- 1. O GATILHO: Quando o jogador clica "USAR"
QBCore.Functions.CreateUseableItem(Config.ItemNecessario, function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    TriggerClientEvent('simple-repair:client:VerificarCarro', source)
end)

-- 2. FINALIZAR: Remover o item e aplicar reparação
RegisterNetEvent('simple-repair:server:CobrarEFinalizar')
AddEventHandler('simple-repair:server:CobrarEFinalizar', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Remover o item do inventário (Consumo)
    if Config.ConsumirItem then
        -- Verifica se ele ainda tem o item (para evitar batotas de dropar a meio)
        if Player.Functions.GetItemByName(Config.ItemNecessario) then
            Player.Functions.RemoveItem(Config.ItemNecessario, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.ItemNecessario], "remove")
            
            -- Aplicar a reparação
            TriggerClientEvent('simple-repair:client:AplicarFix', src)
        else
            TriggerClientEvent('QBCore:Notify', src, "Não tens o kit de reparação!", "error")
        end
    else
        -- Se o item for infinito (como uma ferramenta fixa)
        TriggerClientEvent('simple-repair:client:AplicarFix', src)
    end
end)