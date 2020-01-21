-- relisoft.cz
-- Some-RP.cz
-- forum.some-rp.cz

ESX = nil
local currentAdminPlayers = {}
local owned = false
local ownedGroup

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('relisoft_tag:owned')
AddEventHandler('relisoft_tag:owned',function(own,group)
    owned = own
    if own then
        ownedGroup = group
        TriggerEvent('chat:addMessage', { args = { 'Tag', 'Právě jste si zapl tag' }, color = { 255, 50, 50 } })
    else
        TriggerEvent('chat:addMessage', { args = { 'Tag', 'Váš tag je vypnutý' }, color = { 255, 50, 50 } })
    end
end)

RegisterNetEvent('relisoft_tag:set_admins')
AddEventHandler('relisoft_tag:set_admins',function (admins)
    currentAdminPlayers = admins
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function()
    ESX.TriggerServerCallback('relisoft_tag:getAdminsPlayers',function(admins)
        currentAdminPlayers = admins
    end)
end)

Citizen.CreateThread(function ()

    while true do
        Citizen.Wait(0)

        local currentPed = PlayerPedId()
        local currentPos = GetEntityCoords(currentPed)

        local cx,cy,cz = table.unpack(currentPos)
        cz = cz + 1.2

        if owned then
            ESX.Game.Utils.DrawText3D(vector3(cx,cy,cz), Config.Labels[ownedGroup], 2)
        end

        for k, v in pairs(currentAdminPlayers) do
            local adminPed = GetPlayerPed(GetPlayerFromServerId(v.source))
            local adminCoords = GetEntityCoords(adminPed)
            local x,y,z = table.unpack(adminCoords)
            z = z + 1.2

            local distance = GetDistanceBetweenCoords(vector3(cx,cy,cz), x,y,z, true)
            local label = Config.Labels[v.group]
            if label then
                if distance < Config.SeeDistance then
                    ESX.Game.Utils.DrawText3D(vector3(x,y,z), label, 2)
                end
            end
        end
    end

end)
