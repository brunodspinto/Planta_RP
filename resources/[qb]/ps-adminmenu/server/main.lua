QBCore = exports['qb-core']:GetCoreObject()

lib.addCommand('admin', {
    help = locale('command_admin_desc'),
    restricted = 'qbcore.mod'
}, function(source)
    if not QBCore.Functions.IsOptin(source) then TriggerClientEvent('QBCore:Notify', source, locale('not_on_duty'), 'error'); return end
    TriggerClientEvent('ps-adminmenu:client:OpenUI', source)
end)
-- Callbacks
