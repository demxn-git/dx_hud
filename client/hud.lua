local curPaused
local lastHealth, lastArmour
local onSurface, isResting

CreateThread(function()
	while true do
		if HUD then
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
		end
		Wait(200)
	end
end)
