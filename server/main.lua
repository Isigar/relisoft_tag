-- relisoft.cz
-- Some-RP.cz
-- forum.some-rp.cz

ESX = nil
AdminPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addAdminCommand', 'tag', 1, function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    local found = false
    for i, v in pairs(AdminPlayers) do
        if v.player == xPlayer then
            found = i
        end
    end
    if found == false then
        table.insert(AdminPlayers,{source = source, player = xPlayer})
    else
        table.remove(AdminPlayers,found)
    end

    TriggerClientEvent('relisoft_tag:set_admins',source,AdminPlayers)
end, function(source, args, user)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Nedostatečné oprávnění!' } })
end, {help = '/users admin command'})