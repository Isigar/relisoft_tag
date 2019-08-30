-- relisoft.cz
-- Some-RP.cz
-- forum.some-rp.cz

ESX = nil
local currentAdminPlayers = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('relisoft_tag:set_admins')
AddEventHandler('relisoft_tag:set_admins',function (admins)
    currentAdminPlayers = admins
end)

Citizens.CreateThread(function ()

    while true do
        Citizens.Wait(300)

        local currentPed = PlayerPedId()
        local currentPos = GetEntityCoords(currentPed)

        for i, v in pairs(currentAdminPlayers) do

            local adminPed = GetPlayerPed(v.source)
            local adminCoords = GetEntityCoords(adminPed)
            local distance = GetDistanceBetweenCoords(currentPos, adminCoords)
            if distance < Config.SeeDistance then
                ESX.Game.Utils.DrawText3D(adminCoords, "ADMIN", 2)
            end
        end
    end

end)