ESX = nil

local _nmsl = nil
local _isShowCar = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
    end

    if ESX.IsPlayerLoaded() then
        local carmodel = GetHashKey(Config.car)

		Citizen.CreateThread(function()           
			 -- Car
            RequestModel(carmodel)
            while not HasModelLoaded(carmodel) do
                Citizen.Wait(0)
            end

            local vehicle = CreateVehicle(carmodel, Config.x , Config.y, Config.z, Config.h , false, false)
            
			SetModelAsNoLongerNeeded(carmodel)
            SetVehicleEngineOn(vehicle, true, true, true )
            SetVehicleBrakeLights(vehicle, true )
            SetVehicleLights(vehicle, 2)
            SetVehicleLightsMode(vehicle, 2)
            SetVehicleInteriorlight(vehicle, true )
			
			FreezeEntityPosition(vehicle, true)
			
			if Config.carspin then
              local _curPos = GetEntityCoords(vehicle)
              SetEntityCoords(vehicle, _curPos.x, _curPos.y, _curPos.z + 1, false, false, true, true)
			  _nmsl = vehicle
			end
            
        end)
    end
end)

Citizen.CreateThread(function() 
    while true do
        if _nmsl ~= nil then
            local _heading = GetEntityHeading(_nmsl)
            local _z = _heading - 0.3
            SetEntityHeading(_nmsl, _z)
        end
        Citizen.Wait(5)
    end
end)


