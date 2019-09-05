-- relisoft.cz
-- Some-RP.cz
-- forum.some-rp.cz

ESX = nil
local currentAdminPlayers = {}
local owned = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('relisoft_tag:owned')
AddEventHandler('relisoft_tag:owned',function(owned)
    owned = false
end)

RegisterNetEvent('relisoft_tag:set_admins')
AddEventHandler('relisoft_tag:set_admins',function (admins)
    currentAdminPlayers = admins
end)

Citizens.CreateThread(function ()

    while true do
        Citizens.Wait(0)

        local currentPed = PlayerPedId()
        local currentPos = GetEntityCoords(currentPed)

        for i, v in pairs(currentAdminPlayers) do
            local adminPed = GetPlayerPed(v.source)
            local adminCoords = GetEntityCoords(adminPed)
            local x,y,z = unpack(adminCoords)
            z = z + 1
            local distance = GetDistanceBetweenCoords(currentPos, adminCoords)

            local label = Config.Labels[xPlayer.getGroup()]
            if label then
                if distance < Config.SeeDistance then
                    ESX.Game.Utils.DrawText3D({x,y,z}, label, 2)
                end
                if owned then
                    ESX.Game.Utils.DrawText3D({x,y,z}, label, 2)
                end
            end
        end
    end

end)