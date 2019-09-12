-- relisoft.cz
-- Some-RP.cz
-- forum.some-rp.cz

ESX = nil
AdminPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addAdminCommand', 'tag', 1, function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    if AdminPlayers[xPlayer.identifier] == nil then
        AdminPlayers[xPlayer.identifier] = {source = source, permission = xPlayer.getPermissions(), group = xPlayer.getGroup()}
        TriggerClientEvent('relisoft_tag:owned',source, true,xPlayer.getGroup())
    else
        AdminPlayers[xPlayer.identifier] = nil
        TriggerClientEvent('relisoft_tag:owned',source, false)
    end
    TriggerClientEvent('relisoft_tag:set_admins',-1,AdminPlayers)
end, function(source, args, user)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Nedostatečné oprávnění!' } })
end, {help = '/tag admin command'})