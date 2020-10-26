spawned = {}

Citizen.CreateThread(function()
	while not ESX do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(500)
	end
    while not ESX.IsPlayerLoaded() do Wait(500) end

    while 1 do
        local pCoords = GetEntityCoords(PlayerPedId())
        for i=1, #Cars do
            if #(pCoords - Cars[i].pos) < ShowRange then
                if Cars[i].spawned == nil then
                    SpawnLocalCar(i)
                end
            elseif Cars[i].spawned ~= nil then
                DeleteEntity(Cars[i].spawned)
                Cars[i].spawned = nil
            end
        end
        Wait(500)
    end
end)

Citizen.CreateThread(function() 
    while 1 do
        for i=1, #Cars do
            if Cars[i].spawned ~= nil and Cars[i].spin then
                SetEntityHeading(Cars[i].spawned, GetEntityHeading(Cars[i].spawned) - 0.3)
            end
        end
        Wait(5)
    end
end)

function SpawnLocalCar(i)
    Citizen.CreateThread(function()
        local hash = GetHashKey(Cars[i].model)

        RequestModel(hash)
        local attempt = 0
        while not HasModelLoaded(hash) do
            attempt = attempt + 1
            if attempt > 2000 then return end
            Wait(0)
        end

        local veh = CreateVehicle(hash, Cars[i].pos.x, Cars[i].pos.y, Cars[i].pos.z-1,Cars[i].heading, false, false)
        SetModelAsNoLongerNeeded(hash)
        SetVehicleEngineOn(veh, true, true, true)
        SetVehicleBrakeLights(veh, true)
        SetVehicleLights(veh, 2)
        SetVehicleLightsMode(veh, 2)
        SetVehicleInteriorlight(veh, true)
        SetVehicleOnGroundProperly(veh)
        FreezeEntityPosition(veh, true)

        Cars[i].spawned = veh
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        for i=1, #Cars do
            if Cars[i].spawned ~= nil then
                DeleteEntity(Cars[i].spawned)
            end
        end
    end
end)
