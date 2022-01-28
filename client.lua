CreateThread(function()
    while true do
        if ESX.PlayerLoaded then
            local ped = PlayerPedId()
            local playerId = PlayerId()

            local underwaterTime = GetPlayerUnderwaterTimeRemaining(playerId) * 10
            local voiceConnected = MumbleIsConnected()
            local voiceTalking = NetworkIsPlayerTalking(playerId)
            local isDriving = IsPedInAnyVehicle(ped, true)
            local speed, maxspeed, fuel = 0, 0, 0
            
            if isDriving then
                local veh = GetVehiclePedIsUsing(ped, false)
                local speedMultiplier = dx.metricSystem and 3.6 or 2.236936

                speed = math.floor(GetEntitySpeed(veh) * speedMultiplier)
                maxspeed = GetVehicleModelMaxSpeed(GetEntityModel(veh)) * speedMultiplier
                if dx.showFuel then fuel = GetVehicleFuelLevel(veh) end
            end

            SendNUIMessage({ 
                action = "general",
                hp = GetEntityHealth(ped) - 100,
                armour = GetPedArmour(ped),
                oxygen = IsPedSwimmingUnderWater(ped) and underwaterTime >= 0 and underwaterTime or 100,
                showSpeedo = isDriving,
                showFuel = dx.showFuel and isDriving,
                speed = speed,
                maxspeed = maxspeed,
                fuel = fuel,
                voiceConnected = voiceConnected,
                voiceTalking = voiceTalking,
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
            local ped = PlayerPedId()
            local playerId = PlayerId()

            local hunger, thirst, stress
            TriggerEvent('esx_status:getStatus', 'hunger', function(status) hunger = status.val / 10000 end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(status) thirst = status.val / 10000 end)
            if dx.showStress then
            TriggerEvent('esx_status:getStatus', 'stress', function(status) stress = status.val / 10000 end)
            end
            
            Wait(100)
            SendNUIMessage({
                action = "status",
                hunger = hunger,
                thirst = thirst,
                stress = dx.showStress and stress,
            })
        end

        Wait(dx.statusRefreshRate)
    end
end)

CreateThread(function()
	RequestStreamedTextureDict("circlemap", false)
	repeat Wait(100) until HasStreamedTextureDictLoaded("circlemap")

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

	SetMinimapClipType(1)
    SetMinimapComponentPosition('minimap', 'L', 'B', -0.015, 0.02, 0.190, 0.265)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.065, 0.080, 0.120, 0.220)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.010, 0.017, 0.180, 0.255)

    SetRadarBigmapEnabled(true, false)
    Wait(0)
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

AddEventHandler('pma-voice:setTalkingMode', function(mode)
    SendNUIMessage({action = "voice_range", voiceRange = mode})
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
 	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)
