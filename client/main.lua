-- store.rcore.cz

local currentAdminPlayers = {}
local visibleAdmins = {}
local closeAdmins = {}

RegisterNetEvent('relisoft_tag:set_admins')
AddEventHandler('relisoft_tag:set_admins', function(admins)
    currentAdminPlayers = admins
    for id, admin in pairs(visibleAdmins) do
        if admins[id] == nil then
            visibleAdmins[id] = nil
        end
    end
end)

CreateThread(function()
    callCallback('getAdminsPlayers', function(admins)
        currentAdminPlayers = admins
    end)
end)

function draw3DText(pos, text, options)
    options = options or {}
    local color = options.color or { r = 255, g = 255, b = 255, a = 255 }
    local scaleOption = options.size or 0.8

    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - pos)
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
        Wait(Config.NearCheckWait)
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for k, v in pairs(currentAdminPlayers) do
            local playerServerID = GetPlayerFromServerId(v.source)
            if playerServerID ~= -1 then
                local adminPed = GetPlayerPed(playerServerID)
                local adminCoords = GetEntityCoords(adminPed)

                local distance = #(adminCoords - pedCoords)
                if distance < 40 then
                    visibleAdmins[v.source] = v
                else
                    visibleAdmins[v.source] = nil
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(500)
        closeAdmins = {}
        for k, v in pairs(visibleAdmins) do
            local playerServerID = GetPlayerFromServerId(v.source)
            if playerServerID ~= -1 then
                local adminPed = GetPlayerPed(playerServerID)
                local label

                if v.permission then
                    label = Config.GroupLabels.ESX[1][v.permission]
                end

                if v.group then
                    label = Config.GroupLabels.ESX[2][v.group]
                end

                if v.qbcore then
                    label = Config.GroupLabels.QBCore[1][v.qbcore]
                end


                if label then
                    closeAdmins[playerServerID] = {
                        ped = adminPed,
                        label = label,
                        source = v.source,
                        self = v.source == GetPlayerServerId(PlayerId()),
                    }
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if next(closeAdmins) ~= nil then
            for k, v in pairs(closeAdmins) do
                if v.label then
                    if v.self then
                        if Config.SeeOwnLabel == true then
                            draw3DText(GetEntityCoords(v.ped) + Config.Offset, v.label, {
                                size = Config.TextSize
                            })
                        end
                    else
                        draw3DText(GetEntityCoords(v.ped) + Config.Offset, v.label, {
                            size = Config.TextSize
                        })
                    end
                end
            end
        else
            Wait(1000)
        end
    end
end)

