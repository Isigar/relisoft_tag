-- rcore.cz
-- Some-RP.cz
-- forum.some-rp.cz

ESX = nil
AdminPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('tag', function(source,args)
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
end)

ESX.RegisterServerCallback('relisoft_tag:getAdminsPlayers',function(source,cb)
    cb(AdminPlayers)
end)

AddEventHandler('esx:playerDropped', function(source)
    if AdminPlayers[source] ~= nil then
        AdminPlayers[source] = nil
    end
    TriggerClientEvent('relisoft_tag:set_admins',-1,AdminPlayers)
end)
