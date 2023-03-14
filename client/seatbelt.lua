if GetConvar('hud:seatbelt', 'false') == 'true' then
	local isBuckled = false
	SetFlyThroughWindscreenParams(15.0, 20.0, 17.0, 2000.0)

	local function Buckled()
		CreateThread(function()
			while isBuckled do
				lib.disableControls()
				Wait(0)
			end
		end)
	end

	local function Seatbelt(status)
		if status then
			SendMessage('playSound', 'buckle')
			SendMessage('setSeatbelt', { toggled = true, buckled = true })
			SetFlyThroughWindscreenParams(1000.0, 1000.0, 0.0, 0.0)
			lib.disableControls:Add(75)
			Buckled()
		else
			SendMessage('playSound', 'unbuckle')
			SendMessage('setSeatbelt', { toggled = true, buckled = false })
			SetFlyThroughWindscreenParams(15.0, 20.0, 17.0, 2000.0)
			lib.disableControls:Remove(75)
		end
		isBuckled = status
	end

	local inVehicle
	CreateThread(function()
		while true do
			if HUD then
				local isPedUsingAnyVehicle = cache.vehicle and true or false
				if isPedUsingAnyVehicle ~= inVehicle then
					SendMessage('setSeatbelt', { toggled = isPedUsingAnyVehicle })
					if not isPedUsingAnyVehicle and isBuckled then isBuckled = false end
					inVehicle = isPedUsingAnyVehicle
				end
			end
			Wait(1000)
		end
	end)

	lib.addKeybind({
		name = 'seatbelt',
		description = 'Toggle Seatbelt',
		defaultKey = GetConvar('hud:seatbeltKey', 'B'),
		onPressed = function()
			if cache.vehicle then
				local curVehicleClass = GetVehicleClass(cache.vehicle)

				if curVehicleClass ~= 8
					and curVehicleClass ~= 13
					and curVehicleClass ~= 14
				then
					Seatbelt(not isBuckled)
				end
			end
		end,
	})
end
