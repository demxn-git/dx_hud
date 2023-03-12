local curPaused
local curPed
local lastHealth
local lastArmour
local onSurface
local offVehicle
local isResting

CreateThread(function()
	while true do
		if nuiReady and PlayerLoaded then
			local paused = IsPauseMenuActive()
			if paused ~= curPaused then
				SendMessage('toggleHud', not paused)
				curPaused = paused
			end

			if cache.ped ~= curPed then
				if IsPedSwimming(cache.ped) then
					local timer = 5000
					while not maxUnderwaterTime do
						Wait(1000)
						timer -= 1000
						if not IsPedSwimmingUnderWater(cache.ped) then
							if timer == 0 then maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(cache.playerId) end
						else timer = 5000 end
					end
				else maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(cache.playerId) end
				curPed = cache.ped
			end

			local curHealth = GetEntityHealth(cache.ped)
			if curHealth ~= lastHealth then
				SendMessage('setHealth', { current = curHealth, max = GetEntityMaxHealth(cache.ped) })
				lastHealth = curHealth
			end

			local curArmour = GetPedArmour(cache.ped)
			if curArmour ~= lastArmour then
				SendMessage('setArmour', curArmour)
				lastArmour = curArmour
			end

			if GetConvar('hud:stamina', 'false') == 'true' then
				local curStamina = GetPlayerStamina(cache.playerId)
				local maxStamina = GetPlayerMaxStamina(cache.playerId)
				if curStamina < maxStamina then
					SendMessage('setStamina', {
						current = curStamina,
						max = maxStamina
					})
					isResting = false
				elseif not isResting then
					SendMessage('setStamina', false)
					isResting = true
				end
			end

			if not maxUnderwaterTime and IsPedSwimmingUnderWater(cache.ped) then
				lib.notify({
					title = 'Initializating HUD...',
					description = 'Please stay on the surface for at least 5 seconds!',
					type = 'inform'
				})
			end

			if maxUnderwaterTime then
				local curUnderwaterTime = GetPlayerUnderwaterTimeRemaining(cache.playerId)
				if curUnderwaterTime < maxUnderwaterTime then
					SendMessage('setOxygen', {
						current = curUnderwaterTime,
						max = maxUnderwaterTime
					})
					onSurface = false
				elseif not onSurface then
					SendMessage('setOxygen', false)
					onSurface = true
				end
			end

			local inVehicle = IsPedInAnyVehicle(cache.ped, false)
			
			if GetConvar('hud:persistentRadar', 'false') == 'false' then
				local isRadarHidden = IsRadarHidden()
				if inVehicle == isRadarHidden then
					DisplayRadar(inVehicle)
					SetRadarZoom(1150)
				end
			end

			if inVehicle then
				SendMessage('setVehicle', {
					speed = {
						current = GetEntitySpeed(cache.vehicle),
						max = GetVehicleModelMaxSpeed(GetEntityModel(cache.vehicle))
					},
					unitsMultiplier = GetConvar('hud:unitsystem', 'imperial') == 'metric' and 3.6 or 2.236936,
					fuel = GetConvar('hud:fuel', 'false') and GetVehicleFuelLevel(cache.vehicle),
				})
				offVehicle = false
			elseif not offVehicle then
				SendMessage('setVehicle', false)
				offVehicle = true
			end
		end
		Wait(200)
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if cache.resource ~= resourceName then return end
	repeat Wait(100) until nuiReady
	InitializeHUD()
end)
