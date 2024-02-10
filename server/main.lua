-- store.rcore.cz
SharedObject = nil

if Config.Framework == Framework.ESX then
    SharedObject = GetEsxObject()
end

if Config.Framework == Framework.QBCORE then
    SharedObject = GetQBCoreObject()

    -- older version of qbcore is running with group name "qbcore" and not "group" this will support both.
    for k, v in pairs(SharedObject.Config.Server.Permissions) do
        ExecuteCommand(("add_ace qbcore.%s tag.%s allow"):format(v, v))
        ExecuteCommand(("add_ace group.%s tag.%s allow"):format(v, v))
    end
end

AdminPlayers = {}

RegisterCommand('tag', function(source, args)
    if AdminPlayers[source] == nil then
        if Config.Framework == Framework.ESX then
            local xPlayer = SharedObject.GetPlayerFromId(source)
            if xPlayer.getPermissions then
                AdminPlayers[source] = { source = source, permission = xPlayer.getPermissions() }
            end
            if xPlayer.getGroup then
                AdminPlayers[source] = { source = source, group = xPlayer.getGroup() }
            end
        end

        if Config.Framework == Framework.QBCORE then
            for k, v in pairs(SharedObject.Config.Server.Permissions) do
                if IsPlayerAceAllowed(source, "tag." .. v) then
                    AdminPlayers[source] = { source = source, qbcore = v }
                    break
                end
            end
        end

        TriggerClientEvent('chat:addMessage', source, { args = { 'Tag', _U("tag_on") }, color = { 255, 50, 50 } })
    else
        AdminPlayers[source] = nil
        TriggerClientEvent('chat:addMessage', source, { args = { 'Tag', _U("tag_off") }, color = { 255, 50, 50 } })
    end

    TriggerClientEvent('relisoft_tag:set_admins', -1, AdminPlayers)
end)

registerCallback('getAdminsPlayers', function(source, cb)
    cb(AdminPlayers)
end)

AddEventHandler('esx:playerDropped', function(source)
    if AdminPlayers[source] ~= nil then
        AdminPlayers[source] = nil
    end
    TriggerClientEvent('relisoft_tag:set_admins', -1, AdminPlayers)
end)