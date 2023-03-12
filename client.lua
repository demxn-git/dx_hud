local curPaused
local curPed
local lastHealth
local lastArmour
local onSurface
local offVehicle
local isResting

CreateThread(function()
	while true do
		if nuiReady and ESX.PlayerLoaded then
			local ped = PlayerPedId()

			local paused = IsPauseMenuActive()
			if paused ~= curPaused then
				SendMessage('toggleHud', not paused)
				curPaused = paused
			end

			if ped ~= curPed then
				if IsPedSwimming(ped) then
					local timer = 5000
					while not maxUnderwaterTime do
						Wait(1000)
						timer -= 1000
						if not IsPedSwimmingUnderWater(ped) then
							if timer == 0 then maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(playerId) end
						else timer = 5000 end
					end
				else maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(playerId) end
				curPed = ped
			end

			local curHealth = GetEntityHealth(ped)
			if curHealth ~= lastHealth then
				SendMessage('setHealth', { current = curHealth, max = GetEntityMaxHealth(ped) })
				lastHealth = curHealth
			end

			local curArmour = GetPedArmour(ped)
			if curArmour ~= lastArmour then
				SendMessage('setArmour', curArmour)
				lastArmour = curArmour
			end

			if GetConvar('hud:stamina', 'false') == 'true' then
				local curStamina = GetPlayerStamina(playerId)
				local maxStamina = GetPlayerMaxStamina(playerId)
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

			while not maxUnderwaterTime and IsPedSwimmingUnderWater(ped) do
				ESX.ShowHelpNotification('Initializating HUD... please stay on surface at least 5 seconds!', true)
				Wait(0)
			end

			if maxUnderwaterTime then
				local curUnderwaterTime = GetPlayerUnderwaterTimeRemaining(playerId)
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

			local inVehicle = IsPedInAnyVehicle(ped, false)
			if inVehicle then
				local curVehicle = GetVehiclePedIsUsing(ped)
				SendMessage('setVehicle', {
					speed = {
						current = GetEntitySpeed(curVehicle),
						max = GetVehicleModelMaxSpeed(GetEntityModel(curVehicle))
					},
					unitsMultiplier = GetConvar('hud:unitsystem', 'imperial') == 'metric' and 3.6 or 2.236936,
					fuel = GetConvar('hud:fuel', 'false') and GetVehicleFuelLevel(curVehicle),
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

local InitializeHUD = function()
	SendMessage('setPlayerId', GetPlayerServerId(playerId))
	if GetConvar('hud:logo', 'false') == 'true' then SendMessage('setLogo') end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	 ESX.PlayerLoaded = true
	SendMessage('toggleHud', true)
	InitializeHUD()
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	SendMessage('toggleHud', false)
end)

AddEventHandler('esx_status:onTick', function(data)
	local hunger, thirst, stress
	for i = 1, #data do
			if data[i].name == 'thirst' then thirst = math.floor(data[i].percent) end
			if data[i].name == 'hunger' then hunger = math.floor(data[i].percent) end
			if data[i].name == 'stress' then stress = math.floor(data[i].percent) end
	end

	SendMessage('status', {
		hunger = hunger,
		thirst = thirst,
		stress = GetConvar('hud:stress', 'false') and stress,
	})
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		repeat Wait(100) until nuiReady
		InitializeHUD()
	end
end)
