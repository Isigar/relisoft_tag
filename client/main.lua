-- relisoft.cz
-- Some-RP.cz
-- forum.some-rp.cz

ESX = nil
local currentAdminPlayers = {}
local visibleAdmins = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('relisoft_tag:set_admins')
AddEventHandler('relisoft_tag:set_admins', function(admins)
    currentAdminPlayers = admins
    for id, admin in pairs(visibleAdmins) do
        if admins[id] == nil then
            visibleAdmins[id] = nil
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    ESX.TriggerServerCallback('relisoft_tag:getAdminsPlayers', function(admins)
        currentAdminPlayers = admins
    end)
end)

function draw3DText(pos, text, options)
    options = options or {}
    local color = options.color or { r = 255, g = 255, b = 255, a = 255 }
    local scaleOption = options.size or 0.8

    local camCoords = GetGameplayCamCoords()
    local dist = #(vector3(camCoords.x, camCoords.y, camCoords.z) - vector3(pos.x, pos.y, pos.z))
    local scale = (scaleOption / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scaleMultiplier = scale * fov
    SetDrawOrigin(pos.x, pos.y, pos.z, 0);
    SetTextProportional(0)
    SetTextScale(0.0 * scaleMultiplier, 0.55 * scaleMultiplier)
    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.NearCheckWait)
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for k, v in pairs(currentAdminPlayers) do
            local playerServerID = GetPlayerFromServerId(v.source)
            if playerServerID ~= -1 then
                local adminPed = GetPlayerPed(playerServerID)
                local adminCoords = GetEntityCoords(adminPed)

                local distance = #(adminCoords - pedCoords)
                if distance < (Config.SeeDistance) then
                    visibleAdmins[v.source] = v
                else
                    visibleAdmins[v.source] = nil
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k, v in pairs(visibleAdmins) do
            local playerServerID = GetPlayerFromServerId(v.source)
            if playerServerID ~= -1 then
                local adminPed = GetPlayerPed(playerServerID)
                local adminCoords = GetEntityCoords(adminPed)
                local x, y, z = table.unpack(adminCoords)
                z = z + Config.ZOffset

                local label
                if Config.TagByPermission then
                    label = Config.PermissionLabels[v.permission]
                else
                    label = Config.GroupLabels[v.group]
                end

                if label then
                    if v.source == GetPlayerServerId(PlayerId()) then
                        if Config.SeeOwnLabel == true then
                            draw3DText(vector3(x, y, z), label, {
                                size = Config.TextSize
                            })
                        end
                    else
                        draw3DText(vector3(x, y, z), label, {
                            size = Config.TextSize
                        })
                    end
                end
            end
        end
    end
end)
