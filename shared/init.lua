HUD = false

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
        if IsPedSwimming(cache.ped) then
            lib.notify({
                id = 'dx_hud:swimming',
                title = 'HUD',
                description = 'Looks like you are swimming, please don\'t go underwater while the HUD is loading.',
                type = 'inform',
                duration = 5000
            })
            local timer = 5000
            while not maxUnderwaterTime do
                Wait(1000)
                timer -= 1000
                if not IsPedSwimmingUnderWater(cache.ped) then
                    maxUnderwaterTime = timer == 0 and GetPlayerUnderwaterTimeRemaining(cache.playerId) or nil
                else
                    timer = 5000
                    lib.notify({
                        id = 'dx_hud:initializing',
                        title = 'HUD',
                        description = 'Please stay on the surface for at least 5 seconds!',
                        type = 'inform',
                        duration = 5000
                    })
                end
            end
        else
                maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(cache.playerId)
        end

        SendMessage('setPlayerId', cache.serverId)

        if GetConvar('hud:logo', 'false') == 'true' then
            SendMessage('setLogo')
        end

        HUD = true
        SendMessage('toggleHud', true)
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