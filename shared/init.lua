if not IsDuplicityVersion() then
    HUD = false

    local NuiReady = false
    RegisterNUICallback('nuiReady', function(_, cb)
        NuiReady = true
        cb({})
    end)

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
        DisplayRadar(false)

        if GetConvar('hud:circleMap', 'true') == 'true' then
            RequestStreamedTextureDict('circlemap', false)
            repeat Wait(100) until HasStreamedTextureDictLoaded('circlemap')
            AddReplaceTexture('platform:/textures/graphics', 'radarmasksm', 'circlemap', 'radarmasksm')

            SetMinimapClipType(1)
            SetMinimapComponentPosition('minimap', 'L', 'B', -0.017, -0.02, 0.207, 0.32)
            SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.06, 0.00, 0.132, 0.260)
            SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.005, -0.05, 0.166, 0.257)

            repeat Wait(100) until PlayerLoaded

            SetRadarBigmapEnabled(true, false)
            SetRadarBigmapEnabled(false, false)
        end

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

        repeat Wait(100) until NuiReady

        SendMessage('setPlayerId', cache.serverId)

        if GetConvar('hud:logo', 'true') == 'true' then
            SendMessage('setLogo')
        end

        HUD = true
        SendMessage('toggleHud', HUD)
    end

    AddEventHandler('onResourceStart', function(resourceName)
        if cache.resource ~= resourceName then return end
        InitializeHUD()
    end)
else
    if GetConvar('hud:versioncheck', 'true') == 'true' then
        lib.versionCheck('0xDEMXN/dx_hud')
    end
end