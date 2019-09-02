-- relisoft.cz
-- Some-RP.cz
-- forum.some-rp.cz

ESX = nil
AdminPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addAdminCommand', 'tag', 1, function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    if AdminPlayers[xPlayer.identifier] then
        AdminPlayers[xPlayer.identifier] = {source = source, player = xPlayer}
        TriggerClientEvent('relisoft_tag:owned',source, true)
    else
        AdminPlayers[xPlayer.identifier] = nil
        TriggerClientEvent('relisoft_tag:owned',source, false)
    end

    TriggerClientEvent('relisoft_tag:set_admins',source,AdminPlayers)

end, function(source, args, user)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Nedostatečné oprávnění!' } })
end, {help = '/users admin command'})