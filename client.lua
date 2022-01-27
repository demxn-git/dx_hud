local isDriving = false;
local isUnderwater = false;

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        if Config.UnitOfSpeed == "kmh" then
            SpeedMultiplier = 3.6
        elseif Config.UnitOfSpeed == "mph" then
            SpeedMultiplier = 2.236936
        end
        Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(100)

        if isDriving and IsPedInAnyVehicle(PlayerPedId(), true) then
            local veh = GetVehiclePedIsUsing(PlayerPedId(), false)
            local speed = math.floor(GetEntitySpeed(veh) * SpeedMultiplier)
            local vehhash = GetEntityModel(veh)
            local maxspeed = GetVehicleModelMaxSpeed(vehhash) * 3.6
            SendNUIMessage({speed = speed, maxspeed = maxspeed})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if Config.ShowSpeedo then
            if IsPedInAnyVehicle(PlayerPedId(), false) and
                not IsPedInFlyingVehicle(PlayerPedId()) and
                not IsPedInAnySub(PlayerPedId()) then
                isDriving = true
                SendNUIMessage({showSpeedo = true})
            elseif not IsPedInAnyVehicle(PlayerPedId(), false) then
                isDriving = false
                SendNUIMessage({showSpeedo = false})
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(500)

        local isTalking = NetworkIsPlayerTalking(PlayerId())
        if IsPedSwimmingUnderWater(PlayerPedId()) then
            isUnderwater = true
            SendNUIMessage({showOxygen = true})
        elseif not IsPedSwimmingUnderWater(PlayerPedId()) then
            isUnderwater = false
            SendNUIMessage({showOxygen = false})
        end
        TriggerEvent('esx_status:getStatus', 'hunger',
                     function(status) hunger = status.val / 10000 end)
        TriggerEvent('esx_status:getStatus', 'thirst',
                     function(status) thirst = status.val / 10000 end)
        if Config.ShowStress == true then
            TriggerEvent('esx_status:getStatus', 'stress',
                         function(status) stress = status.val / 10000 end)
        end

        if Config.UseRadio then
            local radioStatus = exports["rp-radio"]:IsRadioOn()
            SendNUIMessage({radio = radioStatus})
        end

        SendNUIMessage({
            action = "update_hud",
            hp = GetEntityHealth(PlayerPedId()) - 100,
            armor = GetPedArmour(PlayerPedId()),
            hunger = hunger,
            thirst = thirst,
            stress = stress,
            oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10,
            talking = isTalking
        })
        if IsPauseMenuActive() then
            SendNUIMessage({showUi = false})
        elseif not IsPauseMenuActive() then
            SendNUIMessage({showUi = true})
        end
    end
end)

-- Map stuff below
local x = -0.025
local y = -0.015
local w = 0.16
local h = 0.25

Citizen.CreateThread(function()

    local minimap = RequestScaleformMovie("minimap")
    RequestStreamedTextureDict("circlemap", false)
    while not HasStreamedTextureDictLoaded("circlemap") do Wait(100) end
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap",
                      "radarmasksm")

    SetMinimapClipType(1)
    SetMinimapComponentPosition('minimap', 'L', 'B', x, y, w, h)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', x + 0.17, y + 0.09,
                                0.072, 0.162)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.035, -0.03, 0.18,
                                0.22)
    Wait(5000)
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        BeginScaleformMovieMethod(minimap, 'HIDE_SATNAV')
        EndScaleformMovieMethod()
    end
end)

CreateThread(function()
    while true do
        Wait(2000)
        SetRadarZoom(1150)
        if Config.AlwaysShowRadar == false then
            if IsPedInAnyVehicle(PlayerPedId(-1), false) then
                DisplayRadar(true)
            else
                DisplayRadar(false)
            end
        elseif Config.AlwaysShowRadar == true then
            DisplayRadar(true)
        end
        if Config.ShowStress == false then
            SendNUIMessage({action = "disable_stress"})
        end

        if Config.ShowVoice == false then
            SendNUIMessage({action = "disable_voice"})
        end

        if Config.ShowFuel == true then
            if isDriving and IsPedInAnyVehicle(PlayerPedId(), true) then
                local veh = GetVehiclePedIsUsing(PlayerPedId(), false)
                local fuellevel = GetVehicleFuelLevel(veh)
                SendNUIMessage({
                    action = "update_fuel",
                    fuel = fuellevel,
                    showFuel = true
                })
            end
        elseif Config.ShowFuel == false then
            SendNUIMessage({showFuel = false})
        end
    end
end)

function Voicelevel(val)
    SendNUIMessage({action = "voice_level", voicelevel = val})
end

exports('Voicelevel', Voicelevel)

RegisterCommand("togglehud",
                function()  SendNUIMessage({action = "toggle_hud"}) end, false)
