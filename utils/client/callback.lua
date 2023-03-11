---TAKEN FROM rcore framework
---https://githu.com/Isigar/relisoft_core
---https://docs.rcore.cz

local clientCallbacks = {}
local callbackNames = {}
local currentRequest = 0

function callCallback(name, cb, ...)
    clientCallbacks[currentRequest] = cb
    TriggerServerEvent('rcore_tag:callCallback', name, currentRequest, GetPlayerServerId(PlayerId()), ...)

    if currentRequest < 65535 then
        currentRequest = currentRequest + 1
    else
        currentRequest = 0
    end

    callbackNames[currentRequest] = name
end

RegisterNetEvent('rcore_tag:callCallback', function(requestId, ...)
    if clientCallbacks[requestId] == nil then
        return
    end
    clientCallbacks[requestId](...)
end)
