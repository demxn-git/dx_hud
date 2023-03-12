if not IsDuplicityVersion() then
    playerId = PlayerId()

    ---Easier NUI Messages
    ---@param action string
    ---@param message any
    function SendMessage(action, message)
        SendNUIMessage({
            action = action,
            message = message
        })
    end

    ---Initialize HUD
    function InitializeHUD()
        SendMessage('setPlayerId', GetPlayerServerId(playerId))
        if GetConvar('hud:logo', 'false') == 'true' then SendMessage('setLogo') end
    end

    nuiReady = false
    RegisterNUICallback('nuiReady', function(_, cb)
        nuiReady = true
        cb({})
    end)
else
    if GetConvar('hud:seatbelt', 'false') == 'true' then
        SetConvarReplicated('game_enableFlyThroughWindscreen', 'true')
    end
end