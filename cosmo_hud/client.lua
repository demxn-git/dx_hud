local isDriving = false;
local isUnderwater = false;
local speedoEnabled = true;

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

loadedconfig = false
Citizen.CreateThread(function()
    while loadedconfig == false do
        if Config.UnitOfSpeed == "kmh" then
            SpeedMultiplier = 3.6
        elseif Config.UnitOfSpeed == "mph" then
            SpeedMultiplier = 2.236936
        end
        if Config.ShowGear == true then
            SendNUIMessage({showGear = true})
        elseif Config.ShowGear == false then
            SendNUIMessage({showGear = false})
        end
        if Config.ShowSpeedo == true then
            speedoEnabled = true
        elseif Config.ShowSpeedo == false then
            speedoEnabled = false
        end
        loadedconfig = true
        Wait(100)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(50)
        if isDriving and IsPedInAnyVehicle(PlayerPedId(), true) then
            local veh = GetVehiclePedIsUsing(PlayerPedId(), false)
            local speed = math.floor(GetEntitySpeed(veh) * SpeedMultiplier)
            local gear = GetVehicleCurrentGear(veh)
            SendNUIMessage({speed = speed, gear = gear})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(250)
        if speedoEnabled == true then
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
        Wait(250)
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
        SendNUIMessage({
            hp = GetEntityHealth(PlayerPedId()) - 100,
            armor = GetPedArmour(PlayerPedId()),
            hunger = hunger,
            thirst = thirst,
            oxygen = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10
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

    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        Wait(1000)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        BeginScaleformMovieMethod(minimap, 'HIDE_SATNAV')
        EndScaleformMovieMethod()
    end
end)

local waitTimer = 2000
CreateThread(function()
    while true do
        Wait(waitTimer)
        if IsPedInAnyVehicle(PlayerPedId(-1), false) then
            DisplayRadar(true)
            SetRadarZoom(1200)
        else
            DisplayRadar(false)
        end
    end
end)
