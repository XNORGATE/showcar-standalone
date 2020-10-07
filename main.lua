local spawned = {}

Citizen.CreateThread(function()
	while not ESX do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(500)
	end
    while not ESX.IsPlayerLoaded() do Wait(500) end

    while 1 do
        inVision = false
        local sleep = true
        local pCoords = GetEntityCoords(PlayerPedId())
        for i, c in ipairs(Cars) do
            if #(pCoords - c.pos) < ShowRange then
                SpawnLocalCar(i, c)
                sleep = false
            elseif spawned[i] ~= nil then
                DeleteEntity(spawned[i])
                spawned[i] = nil
            end
        end
        _ = sleep and Wait(500) or Wait(0)
    end
end)

Citizen.CreateThread(function() 
    while 1 do
        for i, c in pairs(spawned) do
            if Cars[i].spin then
                SetEntityHeading(c, GetEntityHeading(c) - 0.3)
            end
        end
        Wait(5)
    end
end)

function SpawnLocalCar(i, c)
    local hash = GetHashKey(c.model)

    RequestModel(hash)
    local attempt = 0
    while not HasModelLoaded(hash) do
        attempt = attempt + 1
        _ = attempt > 2000 and return or Wait(0)
    end

    local veh = CreateVehicle(hash, c.pos, c.heading, false, false)
	SetModelAsNoLongerNeeded(hash)
    SetVehicleEngineOn(veh, true, true, true)
    SetVehicleBrakeLights(veh, true)
    SetVehicleLights(veh, 2)
    SetVehicleLightsMode(veh, 2)
    SetVehicleInteriorlight(veh, true)
    SetVehicleOnGroundProperly(veh)
    Wait(100)
    FreezeEntityPosition(veh, true)

    spawned[i] = veh
end