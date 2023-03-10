if not IsDuplicityVersion() then

    ---Easier NUI Messages
    ---@param action string
    ---@param message any
    function SendMessage(action, message)
        SendNUIMessage({
            action = action,
            message = message
        })
    end

    nuiReady = false
    RegisterNUICallback('nuiReady', function(_, cb)
        nuiReady = true
        cb({})
    end)

    playerId = PlayerId()
else
    if GetConvar('hud:seatbelt', 'false') == 'true' then
        SetConvarReplicated('game_enableFlyThroughWindscreen', 'true')
    end
end