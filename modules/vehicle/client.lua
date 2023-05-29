if not lib then return end

local electricVehicles = data('electricvehicles')

CreateThread(function()	
	while true do
		if HUD then
			if cache.vehicle then
				local model = GetEntityModel(cache.vehicle)

				SendNUIMessage({
					action = 'setVehicle',
					data = {
						speed = {
							current = GetEntitySpeed(cache.vehicle),
							max = GetVehicleModelMaxSpeed(model)
						},
						unitsMultiplier = client.unitsystem == 'metric' and 3.6 or 2.236936,
						fuel = client.fuel and not IsThisModelABicycle(model) and GetVehicleFuelLevel(cache.vehicle),
						electric = electricVehicles[model]
					}
				})

				offVehicle = false
			elseif not offVehicle then
				SendNUIMessage({
					action = 'setVehicle',
					data = false
				})

				offVehicle = true
			end
		end
		Wait(200)
	end
end)
