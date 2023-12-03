local electricModels = {
	[`airtug`] = true,
	[`caddy`] = true,
	[`caddy2`] = true,
	[`caddy3`] = true,
	[`cyclone`] = true,
	[`cyclone2`] = true,
	[`dilettante`] = true,
	[`dilettante2`] = true,
	[`imorgon`] = true,
	[`iwagen`] = true,
	[`khamelion`] = true,
	[`neon`] = true,
	[`omnisegt`] = true,
	[`powersurge`] = true,
	[`raiden`] = true,
	[`rcbandito`] = true,
	[`surge`] = true,
	[`tezeract`] = true,
	[`virtue`] = true,
	[`voltic`] = true,
	[`voltic2`] = true,
}

lib.onCache('vehicle', function(value)
	if not HUD then return end
	if value then
		CreateThread(function()
			while value do
				if not HUD then break end
				local vehicle = cache.vehicle
				local model = GetEntityModel(vehicle)
						
				SendMessage('setVehicle', {
					speed = {
						current = GetEntitySpeed(cache.vehicle),
						max = GetVehicleModelMaxSpeed(model)
					},
					unitsMultiplier = GetConvar('hud:unitsystem', 'imperial') == 'metric' and 3.6 or 2.236936,
					fuel = GetConvarInt('hud:fuel', false) == 1 and not IsThisModelABicycle(model) and GetVehicleFuelLevel(cache.vehicle),
					maxFuel = GetConvarInt('hud:fuel', false) == 1 and not IsThisModelABicycle(model) and GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume'),
					electric = electricModels[model]
				})
						
				Wait(1)
			end
		end)
	else
		SendMessage('setVehicle', false)
	end
end)
