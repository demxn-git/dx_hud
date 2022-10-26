local curPaused
local maxUnderwaterTime

if player then
    PlayerLoaded = true
end

RegisterNetEvent('ox:playerLoaded', function()
	PlayerLoaded = true
    SendMessage('toggleHud', true)
end)

RegisterNetEvent('ox:playerLogout', function()
	PlayerLoaded = false
	SendMessage('toggleHud', false)
end)

CreateThread(function()
	while true do
		if nuiReady and PlayerLoaded then
			local paused = IsPauseMenuActive()
			if paused ~= curPaused then
				SendMessage('toggleHud', not paused)
				curPaused = paused
			end

			if not maxUnderwaterTime then
				if IsPedSwimming(cache.ped) then
					local timer = 5000
					while not maxUnderwaterTime do
						Wait(1000)
						timer -= 1000
						if not IsPedSwimmingUnderWater(cache.ped) then
							if timer == 0 then maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(cache.playerId) end
						else timer = 5000 end
					end
				else
					maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(cache.playerId)
				end
			end
		end
		Wait(cfg.refreshRates.checks)
	end
end)

local lastHealth
local lastArmour
local onSurface
local offVehicle
local isResting

CreateThread(function()
	while true do
		if nuiReady and PlayerLoaded then
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

			if cfg.stamina then
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

			if cache.vehicle and cache.vehicle ~= 0 then
				SendMessage('setVehicle', {
					speed = {
						current = GetEntitySpeed(cache.vehicle),
						max = GetVehicleModelEstimatedMaxSpeed(GetEntityModel(cache.vehicle))
					},
					unitsMultiplier = cfg.metricSystem and 3.6 or 2.236936,
					fuel = cfg.fuel and GetVehicleFuelLevel(cache.vehicle),
				})
				offVehicle = false
			elseif not offVehicle then
				SendMessage('setVehicle', false)
				offVehicle = true
			end
		end
		Wait(cfg.refreshRates.base)
	end
end)

local InitializeHUD = function()
	SendMessage('setPlayerId', cache.serverId)
	if cfg.serverLogo then SendMessage('setLogo') end
end

AddEventHandler('onResourceStart', function(resourceName)
	if cache.resource ~= resourceName then return end
	repeat Wait(100) until nuiReady
	InitializeHUD()
end)
