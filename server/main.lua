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

ESX.RegisterServerCallback('relisoft_tag:getAdminsPlayers',function(source,cb)
    cb(AdminPlayers)
end)

ESX.RegisterServerCallback('relisoft_tag:removePlayer',function(source,cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if AdminPlayers[xPlayer.identifier] ~= nil then
        AdminPlayers[xPlayer.identifier] = nil
    end
    cb()
end)

RegisterNetEvent('relisoft_tag:get_admins')
AddEventHandler('relisoft_tag:get_admins',function(source, cb)
    return cb(AdminPlayers);
end)

RegisterNetEvent('es:playerLoaded')
AddEventHandler('es:playerLoaded',function (source,user)
    TriggerClientEvent('relisoft_tag:set_admins',-1,AdminPlayers)
end)

RegisterNetEvent('es:playerDropped')
AddEventHandler('es:playerDropped', function(user)
    local identifier = user.identifier
    if AdminPlayers[identifier] ~= nil then
        AdminPlayers[identifier] = nil
    end
    TriggerClientEvent('relisoft_tag:set_admins',-1,AdminPlayers)
end)

