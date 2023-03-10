Locales = {}

function IsResourceOnServer(resourceName)
    if GetResourceState(resourceName) == "started" or GetResourceState(resourceName) == "starting" then
        return true
    end
    return false
end

function GetEsxObject()
    local promise_ = promise:new()
    local obj
    xpcall(function()
        if ESX == nil then
            error("ESX variable is nil")
        end
        obj = ESX
        promise_:resolve(obj)
    end, function(error)
        xpcall(function()
            obj = exports["es_extended"]['getSharedObject']()
            promise_:resolve(obj)
        end, function(error)
            TriggerEvent(Config.ESX or "esx:getSharedObject", function(module)
                obj = module
                promise_:resolve(obj)
            end)
        end)
    end)

    Citizen.Await(obj)
    return obj
end

function GetQBCoreObject()
    local promise_ = promise:new()
    local obj
    xpcall(function()
        obj = exports['qb-core']['GetCoreObject']()
        promise_:resolve(obj)
    end, function(error)
        xpcall(function()
            obj = exports['qb-core']['GetSharedObject']()
            promise_:resolve(obj)
        end, function(error)

            local QBCore = nil
            local tries = 10

            LoadQBCore = function()
                if tries == 0 then
                    print("The QBCORE couldnt load any object! You need to correct the event / resource name for export!")
                    return
                end

                tries = tries - 1

                if QBCore == nil then
                    SetTimeout(100, LoadQBCore)
                end

                TriggerEvent(Config.QBCoreObject or "QBCore:GetObject", function(module)
                    QBCore = module

                    obj = QBCore
                    promise_:resolve(QBCore)
                end)
            end

            LoadQBCore()

        end)
    end)

    Citizen.Await(obj)

    return obj
end

function _U(str, ...)
    if type(Locales) ~= "table" then
        return string.format("[%s] the locales is wrong type, it is not a table..", GetCurrentResourceName())
    end
    if not Locales[Config.Locale] then
        return string.format("[%s] The language does not exists: %s", GetCurrentResourceName(), Config.Locale)
    end
    if not Locales[Config.Locale][str] then
        return string.format("[%s] There isnt such [%s] translation", GetCurrentResourceName(), str)
    end
    return string.format(Locales[Config.Locale][str], ...)
end

if IsResourceOnServer("es_extended") then
    Config.Framework = Framework.ESX
end
if IsResourceOnServer("qb-core") then
    Config.Framework = Framework.QBCORE
end
