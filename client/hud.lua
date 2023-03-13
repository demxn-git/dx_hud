local curPaused
local lastHealth, lastArmour
local onSurface, offVehicle, isResting

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

CreateThread(function()
	while true do
		if HUD and PlayerLoaded then
			local paused = IsPauseMenuActive()
			if paused ~= curPaused then
				SendMessage('toggleHud', not paused)
				curPaused = paused
			end

			local curHealth = GetEntityHealth(cache.ped)
			if curHealth ~= lastHealth then
				SendMessage('setHealth', { 
					current = curHealth, 
					max = GetEntityMaxHealth(cache.ped) 
				})
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

			if cache.vehicle then
        local model = GetEntityModel(cache.vehicle)

				SendMessage('setVehicle', {
					speed = {
						current = GetEntitySpeed(cache.vehicle),
						max = GetVehicleModelMaxSpeed(model)
					},
					unitsMultiplier = GetConvar('hud:unitsystem', 'imperial') == 'metric' and 3.6 or 2.236936,
					fuel = GetConvar('hud:fuel', 'false') and not IsThisModelABicycle(model) and GetVehicleFuelLevel(cache.vehicle),
          electric = electricModels[model]
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
