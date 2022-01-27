CreateThread(function()
    while true do
        if ESX.PlayerLoaded then
            local ped = PlayerPedId()
            local playerId = PlayerId()
            local plyState = LocalPlayer.state
            local isConnected = MumbleIsConnected()
            local isTalking = NetworkIsPlayerTalking(playerId)
            local underwaterTime = GetPlayerUnderwaterTimeRemaining(playerId) * 10
            local isDriving = IsPedInAnyVehicle(ped, true)
            local speedMultiplier = dx.metricSystem and 3.6 or 2.236936
            local hunger, thirst, stress, veh, fuelLevel

            TriggerEvent('esx_status:getStatus', 'hunger', function(status) hunger = status.val / 10000 end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(status) thirst = status.val / 10000 end)
            TriggerEvent('esx_status:getStatus', 'stress', function(status) stress = status.val / 10000 end)

            SendNUIMessage({showUi = not IsPauseMenuActive()})
            DisplayRadar(dx.persistentRadar or isDriving)
            SetRadarZoom(1150)
            
            if isDriving then
                local veh = GetVehiclePedIsUsing(ped, false)
                fuelLevel = GetVehicleFuelLevel(veh)

                SendNUIMessage({ 
                    speed = math.floor(GetEntitySpeed(veh) * speedMultiplier),
                    maxspeed = GetVehicleModelMaxSpeed(GetEntityModel(veh)) * speedMultiplier,
                })
            end

            SendNUIMessage({
                action = "update_hud",
                hp = GetEntityHealth(ped) - 100,
                armour = GetPedArmour(ped),
                hunger = hunger,
                thirst = thirst,
                stress = stress or 0,
                oxygen = underwaterTime >= 0 and underwaterTime or 0,
                showStress = dx.showStress,
                showSpeed = isDriving,
                showOxygen = IsPedSwimmingUnderWater(ped),
                showFuel = isDriving,
                fuel = fuelLevel or 0,
                radio = plyState.radioChannel ~= 0 and 1 or 0,
                talking = isTalking,
                connection = isConnected,
            })
        end

        Wait(dx.refreshRate)
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
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)

AddEventHandler('pma-voice:setTalkingMode', function(mode)
    SendNUIMessage({action = "voice_level", voicelevel = mode})
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    SendNUIMessage({showUi = false})
end)
