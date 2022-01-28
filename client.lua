CreateThread(function()
    while true do
        if ESX.PlayerLoaded then
            local ped = PlayerPedId()
            local playerId = PlayerId()
            local plyState = LocalPlayer.state

            local hunger, thirst, stress

            local underwaterTime = GetPlayerUnderwaterTimeRemaining(playerId) * 10
            local isConnected = MumbleIsConnected()
            local isTalking = NetworkIsPlayerTalking(playerId)

            TriggerEvent('esx_status:getStatus', 'hunger', function(status) hunger = status.val / 10000 end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(status) thirst = status.val / 10000 end)
            if dx.showStress then
            TriggerEvent('esx_status:getStatus', 'stress', function(status) stress = status.val / 10000 end)
            end

            SendNUIMessage({showUi = not IsPauseMenuActive()})
            SetRadarZoom(1150)
            print(GetEntityHealth(ped)) -- debug
            SendNUIMessage({
                action = "update_hud",
                hp = GetEntityHealth(ped) - 100,
                armour = GetPedArmour(ped),
                hunger = hunger,
                thirst = thirst,
                showStress = dx.showStress,
                stress = dx.showStress and stress or dx.showStress,
                oxygen = IsPedSwimmingUnderWater(ped) and underwaterTime >= 0 and underwaterTime or 0,
                radio = plyState.radioChannel ~= 0 and 1 or 0,
                connection = isConnected,
                talking = isTalking,
            })
        else
            SendNUIMessage({showUi = false})
        end

        Wait(dx.refreshRate)
    end
end)

CreateThread(function()
    while true do
        if ESX.PlayerLoaded then
            local ped = PlayerPedId()

            local isDriving = IsPedInAnyVehicle(ped, true)
            local speedMultiplier = dx.metricSystem and 3.6 or 2.236936
            local veh, fuelLevel

            DisplayRadar(dx.persistentRadar or isDriving)
            
            if isDriving then
                local veh = GetVehiclePedIsUsing(ped, false)
                fuelLevel = GetVehicleFuelLevel(veh)

                SendNUIMessage({ 
                    action = "update_carhud",
                    showFuel = dx.showFuel and isDriving,
                    fuel = fuelLevel or 0,
                    showSpeedo = isDriving,
                    speed = math.floor(GetEntitySpeed(veh) * speedMultiplier),
                    maxspeed = GetVehicleModelMaxSpeed(GetEntityModel(veh)) * speedMultiplier,
                })
            end
        end

        Wait(dx.carRefreshRate)
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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
 	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)
