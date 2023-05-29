if not lib then return end

local curPaused
local lastHealth, lastArmour
local onSurface, isResting
local maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(cache.playerId)

function DrawHUD()
	CreateThread(function()
		HUD = true
		SendNUIMessage({ action = 'setVisible', data = true })
		
		while HUD do
				local paused = IsPauseMenuActive()
	
				if paused ~= curPaused then
					SendNUIMessage({
						action = 'setVisible',
						data = not paused
					})
	
					curPaused = paused
				end
	
				local curHealth = GetEntityHealth(cache.ped)
	
				if curHealth ~= lastHealth then
					SendNUIMessage({
						action = 'setHealth',
						data = {
							current = curHealth,
							max = GetEntityMaxHealth(cache.ped)
						}
					})
	
					lastHealth = curHealth
				end
	
				local curArmour = GetPedArmour(cache.ped)
	
				if curArmour ~= lastArmour then
					SendNUIMessage({
						action = 'setArmour',
						data = curArmour
					})
	
					lastArmour = curArmour
				end
	
				if client.stamina then
					local curStamina = GetPlayerStamina(cache.playerId)
					local maxStamina = GetPlayerMaxStamina(cache.playerId)
	
					if curStamina < maxStamina then
						SendNUIMessage({
							action = 'setStamina',
							data = {
								current = curStamina,
								max = maxStamina
							}
						})
	
						isResting = false
					elseif not isResting then
						SendNUIMessage({
							action = 'setStamina',
							data = false
						})
	
						isResting = true
					end
				end
	
				local curUnderwaterTime = GetPlayerUnderwaterTimeRemaining(cache.playerId)
	
				if curUnderwaterTime < maxUnderwaterTime then
					SendNUIMessage({
						action = 'setOxygen',
						data = {
							current = curUnderwaterTime,
							max = maxUnderwaterTime
						}
					})
	
					onSurface = false
				elseif not onSurface then
					SendNUIMessage({
						action = 'setOxygen',
						data = false
					})
	
					onSurface = true
				end
			Wait(200)
		end
	end)
end
