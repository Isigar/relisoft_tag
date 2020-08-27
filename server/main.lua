-- relisoft.cz
-- Some-RP.cz
-- forum.some-rp.cz

ESX = nil
AdminPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addAdminCommand', 'tag', 1, function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    if AdminPlayers[source] == nil then
        if Config.TagByPermission then
            AdminPlayers[source] = {source = source, permission = xPlayer.getPermissions()}
        else
            AdminPlayers[source] = {source = source, group = xPlayer.getGroup()}
        end

        TriggerClientEvent('chat:addMessage',source, { args = { 'Tag', 'Právě jste si zapl tag' }, color = { 255, 50, 50 } })
    else
        AdminPlayers[source] = nil
        TriggerClientEvent('chat:addMessage',source, { args = { 'Tag', 'Právě jste si vypnul tag' }, color = { 255, 50, 50 } })
    end
    TriggerClientEvent('relisoft_tag:set_admins',-1,AdminPlayers)
end, function(source, args, user)
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Nedostatečné oprávnění!' } })
end, {help = '/tag admin command'})

ESX.RegisterServerCallback('relisoft_tag:getAdminsPlayers',function(source,cb)
    cb(AdminPlayers)
end)

AddEventHandler('esx:playerDropped', function(source)
    if AdminPlayers[source] ~= nil then
        AdminPlayers[source] = nil
    end
    TriggerClientEvent('relisoft_tag:set_admins',-1,AdminPlayers)
end)
