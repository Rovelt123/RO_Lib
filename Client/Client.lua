ROVELT = {}
ROVELT.CurrentRequestId = 0
ROVELT.ServerCallbacks = {}
ROVELT.Functions = {}
local DynamicMenuItems = {}

ROVELT.TriggerServerCallback = function(name, cb, ...)
    ROVELT.ServerCallbacks[ROVELT.CurrentRequestId] = cb

    TriggerServerEvent('ROVELT:triggerServerCallback', name, ROVELT.CurrentRequestId, ...)

    if ROVELT.CurrentRequestId < 65535 then
        ROVELT.CurrentRequestId = ROVELT.CurrentRequestId + 1
    else
        ROVELT.CurrentRequestId = 0
    end
end

RegisterNetEvent('ROVELT:serverCallback')
AddEventHandler('ROVELT:serverCallback', function(requestId, ...)
    ROVELT.ServerCallbacks[requestId](...)
    ROVELT.ServerCallbacks[requestId] = nil
end)

function GetCore(Framework)
    if Framework == "QB" then
        data = exports["qb-core"]:GetCoreObject()
    elseif Framework == "ESX" then
        data = exports["es_extended"]:getSharedObject()
    else
        data = nil
    end
    return data
end

function ROVELT.Functions.notify(text, variable, time, Framework)
    local CORE = GetCore(Framework)
    if Framework == "OX" then
        lib.notify({
            title = text,
            type = variable
        })
    elseif Framework == "ESX" then
        CORE.ShowNotification(text, variable)
    elseif Framework == "QB" then
        CORE.Functions.Notify(text, variable, time)
    elseif Framework == "RO_Notify" then
        exports['RO_Notify']:Notify(variable, text, "fa fa-car", time, nil, false)
    elseif Framework == "NONE" then
        print(text)
    end
end

function ROVELT.Functions.GetID(Framework)
    local CORE = GetCore(Framework)
    if Config.Framework == "QB" then
        id = CORE.Functions.GetPlayerData().citizenid
    elseif Config.Framework == "ESX" then
        id = CORE.GetPlayerData().identifier
    end
    return id
end

function ROVELT.Functions.progressbar(text, time, Framework) 
    local CORE = GetCore(Framework)
    local proge = nil
    local sendt = false
    if Framework == "NONE" then
        Wait(time)
        return true
    elseif Framework == "ESX" then
        CORE.Progressbar(text, time, {FreezePlayer = true, animation = nil, onFinish = function()
            proge = true
        end, onCancel = function()
            CORE.ShowNotification(Lang['Cancelled'], "error")
            proge = false
        end})
        return(proge)
    elseif Framework == "QB" then
        CORE.Functions.Progressbar('ROVELT_LIB', text, time, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            proge = true
        end, function ()
            proge = false
        end)
        while sendt == false do
            Wait(100)
            if proge == true or proge == false then
                sendt = true
                return (proge)
            end
        end
    elseif Framework == "OX" then
        if lib.progressBar({
            duration = time,
            label = text,
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true,
                mouse = false
            },
        }) then  
            
            return true
        else
            
            return false
        end
    end
end

function ROVELT.Functions.OpenMenu(ID, Data, CitizenID, TheMenu, SelectedMenu)
    print(ID, Data, CitizenID, TheMenu, SelectedMenu)
    if SelectedMenu == "OX" then 
        lib.registerContext(TheMenu)
        Wait(100)
        lib.showContext(TheMenu.id)
    elseif SelectedMenu == "QB" then
        exports['qb-menu']:openMenu(TheMenu)
    end
end

exports('GetData', function()
    return ROVELT
end)