if GetConvar('hud:seatbelt', 'false') == 'true' then
    local isBuckled = false

    local Buckled = function()
        CreateThread(function()
            while isBuckled do
                DisableControlAction(0, 75, true)
                Wait(0)
            end
        end)
    end

    SetFlyThroughWindscreenParams(15.0, 20.0, 17.0, 2000.0)
    local Seatbelt = function(status)
        if status then
            SendMessage('playSound', 'buckle')
            SendMessage('setSeatbelt', { toggled = true, buckled = true })
            SetFlyThroughWindscreenParams(1000.0, 1000.0, 0.0, 0.0)
            Buckled()
        else
            SendMessage('playSound', 'unbuckle')
            SendMessage('setSeatbelt', { toggled = true, buckled = false })
            SetFlyThroughWindscreenParams(15.0, 20.0, 17.0, 2000.0)
        end
        isBuckled = status
    end

    local curInVehicle

    CreateThread(function()
        while true do
            if nuiReady then
                if cache.vehicle ~= curInVehicle then
                    SendMessage('setSeatbelt', { toggled = cache.vehicle })
                    if not cache.vehicle and isBuckled then isBuckled = false end
                    curInVehicle = cache.vehicle
                end
            end
            Wait(1000)
        end
    end)

    RegisterCommand('seatbelt', function()
        if cache.vehicle then
            local curVehicleClass = GetVehicleClass(cache.vehicle)

            if curVehicleClass ~= 8
            and curVehicleClass ~= 13
            and curVehicleClass ~= 14
            then Seatbelt(not isBuckled) end
        end
    end, false)

    RegisterKeyMapping('seatbelt', 'Toggle Seatbelt', 'keyboard', GetConvar('hud:seatbeltKey', 'B'))
    TriggerEvent('chat:removeSuggestion', '/seatbelt')
end