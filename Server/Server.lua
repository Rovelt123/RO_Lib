ROVELT = {}
ROVELT.ServerCallbacks = {}

RegisterServerEvent('ROVELT:triggerServerCallback')
AddEventHandler('ROVELT:triggerServerCallback', function(name, requestId, ...)
    local _source = source

    ROVELT.TriggerServerCallback(name, requestID, _source, function(...)
        TriggerClientEvent('ROVELT:serverCallback', _source, requestId, ...)
    end, ...)
end)

ROVELT.RegisterServerCallback = function(name, cb)
    ROVELT.ServerCallbacks[name] = cb
end

ROVELT.TriggerServerCallback = function(name, requestId, source, cb, ...)
    if ROVELT.ServerCallbacks[name] ~= nil then
        ROVELT.ServerCallbacks[name](source, cb, ...)
    else
        print('ROVELT.TriggerServerCallback => [' .. name .. '] does not exist')
    end
end


exports('GetData', function()
    return ROVELT
end)

Citizen.CreateThread( function()
    updatePath = "/Rovelt123/updatecheck"
    resourceName = "[^2ROVELT SCRIPTS^7] ("..GetCurrentResourceName()..")"
    PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/lib", checkVersion, "GET")
end)

function checkVersion(err,responseText, headers)
    curVersion = LoadResourceFile(GetCurrentResourceName(), "version")

    if responseText == nil then
            print("^1"..resourceName.." check for updates failed ^7")
            return
    end

    if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
            updateavail = true
            print("\n^1----------------------------------------------------------------------------------^7")
            print(resourceName.." is outdated, latest version is: ^2"..responseText.."^7, installed version: ^1"..curVersion.." | DISCORD --> https://discord.gg/s7aqeXK6E4" )
            print("^1----------------------------------------------------------------------------------^7")
    elseif tonumber(curVersion) > tonumber(responseText) then
            print("\n^3----------------------------------------------------------------------------------^7")
            print(resourceName.." version is: ^2"..responseText.."^7, installed version: ^1"..curVersion.."^7!")
            print("^3----------------------------------------------------------------------------------^7")
    else
            print("\n"..resourceName.." is up to date. (^2"..curVersion.."^7)")
    end
end