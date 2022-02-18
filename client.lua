local playerId = PlayerId()

CreateThread(function()
    while true do
        if ESX.PlayerLoaded then
            local ped = PlayerPedId()

            local underwaterTime = GetPlayerUnderwaterTimeRemaining(playerId) * 10

            local isDriving = IsPedInAnyVehicle(ped, true)
            local veh = isDriving and GetVehiclePedIsUsing(ped, false)
            local speedMultiplier = isDriving and dx.metricSystem and 3.6 or 2.236936

            SendNUIMessage({ 
                action = "general",
                -- ped
                hp = GetEntityHealth(ped) - 100, -- refer to README.md for a better health management
                armour = GetPedArmour(ped),
                oxygen = IsPedSwimmingUnderWater(ped) and underwaterTime or 100,
                -- vehicles
                speedometer = isDriving and
                {
                    speed = math.floor(GetEntitySpeed(veh) * speedMultiplier),
                    maxspeed = GetVehicleModelMaxSpeed(GetEntityModel(veh)) * speedMultiplier
                },
                fuel = dx.showFuel and isDriving and GetVehicleFuelLevel(veh),
                -- voice
                showVoice = dx.showVoice,
                voiceConnected = dx.showVoice and MumbleIsConnected(),
                voiceTalking = dx.showVoice and NetworkIsPlayerTalking(playerId),
            })

            DisplayRadar(dx.persistentRadar or isDriving)
            SetRadarZoom(1150)
            SendNUIMessage({showUi = not IsPauseMenuActive()})
        else
            SendNUIMessage({showUi = false})
        end

        Wait(dx.generalRefreshRate)
    end
end)

CreateThread(function()
    while true do
        if ESX.PlayerLoaded then
            local hunger, thirst, stress = false, false, false
            local statusReady = false

            TriggerEvent('esx_status:getStatus', 'hunger', function(status) hunger = status.val / 10000 end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(status) thirst = status.val / 10000 end)
            if dx.showStress then
            TriggerEvent('esx_status:getStatus', 'stress', function(status) stress = status.val / 10000 end)
            end

            repeat
                statusReady = dx.showStress and hunger and thirst and stress or hunger and thirst
                Wait(100)
            until statusReady

            SendNUIMessage({
                action = "status",
                -- status
                hunger = hunger,
                thirst = thirst,
                stress = dx.showStress and stress,
            })
        end

        Wait(dx.statusRefreshRate)
    end
end)

if dx.circleMap then
    CreateThread(function()
        RequestStreamedTextureDict("circlemap", false)
        repeat Wait(100) until HasStreamedTextureDictLoaded("circlemap")

        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

        SetMinimapClipType(1)
        SetMinimapComponentPosition('minimap', 'L', 'B', -0.017, 0.021, 0.207, 0.32)
        SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.06, 0.05, 0.132, 0.260)
        SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.005, -0.01, 0.166, 0.257)

        Wait(1000)
        SetRadarBigmapEnabled(true, false)
        Wait(1000)
        SetRadarBigmapEnabled(false, false)

        local minimap = RequestScaleformMovie("minimap")
        repeat Wait(100) until HasScaleformMovieLoaded(minimap)

        while true do
            Wait(0)
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
        end
    end)
end

AddEventHandler('pma-voice:setTalkingMode', function(mode)
    SendNUIMessage({action = "voice_range", voiceRange = mode})
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
 	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)
