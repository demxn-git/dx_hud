local playerId = PlayerId()
local maxUnderwaterTime = 10.0

local GeneralLoop = function()
  CreateThread(function()
    while ESX.PlayerLoaded do
      SendNUIMessage({
        action = 'general',
        visible = not IsPauseMenuActive()
      })

      local health = (GetEntityHealth(ESX.PlayerData.ped) - 100) / (GetEntityMaxHealth(ESX.PlayerData.ped) - 100)
      local underwaterTime = GetPlayerUnderwaterTimeRemaining(playerId) / maxUnderwaterTime
      local isDriving = IsPedInAnyVehicle(ESX.PlayerData.ped, true)
      local veh = isDriving and GetVehiclePedIsUsing(ESX.PlayerData.ped, false)
      local speedMultiplier = isDriving and dx.metricSystem and 3.6 or 2.236936
      local maxSpeed = isDriving and GetVehicleModelMaxSpeed(GetEntityModel(veh)) * speedMultiplier

      SetRadarZoom(1150)
      DisplayRadar(dx.persistentRadar or isDriving)

      SendNUIMessage({
        action = 'base',
        hp = health > 0 and health or 0,
        armour = GetPedArmour(ESX.PlayerData.ped) / 100,
        oxygen = underwaterTime,
        vehicle = isDriving and {
          speed = GetEntitySpeed(veh) * speedMultiplier,
          limit = GetEntitySpeed(veh) * speedMultiplier / maxSpeed / 1.3,
        },
        fuel = dx.fuel and isDriving and GetVehicleFuelLevel(veh) / 100,
        voice = {
          toggled = dx.voice,
          connected = dx.voice and MumbleIsConnected(),
          talking = dx.voice and NetworkIsPlayerTalking(playerId),
        }
      })

      Wait(dx.generalRefreshRate)
    end
    SendNUIMessage({
      action = 'general',
      visible = false
    })
  end)
end

local StatusLoop = function()
  CreateThread(function()
    local hunger, thirst, stress

    while ESX.PlayerLoaded do

      TriggerEvent('esx_status:getStatus', 'hunger', function(status) hunger = status.val / 10000 end)
      TriggerEvent('esx_status:getStatus', 'thirst', function(status) thirst = status.val / 10000 end)
      if dx.stress then TriggerEvent('esx_status:getStatus', 'stress', function(status) stress = status.val / 10000 end) end

      SendNUIMessage({
        action = 'status',
        hunger = hunger,
        thirst = thirst,
        stress = dx.stress and stress,
      })

      Wait(dx.statusRefreshRate)
    end
  end)
end

local InitHUD = function ()
  GeneralLoop()
  StatusLoop()
  SendNUIMessage({
    action = 'general',
    visible = true,
    playerId = GetPlayerServerId(playerId)
  })
  repeat Citizen.Wait(100) until not IsPedSwimmingUnderWater(ESX.PlayerData.ped)
  Citizen.Wait(2000)
  maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(playerId)
end

if dx.circleMap then
  CreateThread(function()
    RequestStreamedTextureDict('circlemap', false)
    repeat Citizen.Wait(100) until HasStreamedTextureDictLoaded('circlemap')

    AddReplaceTexture('platform:/textures/graphics', 'radarmasksm', 'circlemap', 'radarmasksm')

    SetMinimapClipType(1)
    SetMinimapComponentPosition('minimap', 'L', 'B', -0.017, 0.021, 0.207, 0.32)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.06, 0.05, 0.132, 0.260)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.005, -0.01, 0.166, 0.257)

    Citizen.Wait(500)
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(500)
    SetRadarBigmapEnabled(false, false)

    local minimap = RequestScaleformMovie('minimap')
    repeat Citizen.Wait(100) until HasScaleformMovieLoaded(minimap)

    while true do
      Citizen.Wait(0)
      BeginScaleformMovieMethod(minimap, 'SETUP_HEALTH_ARMOUR')
      ScaleformMovieMethodAddParamInt(3)
      EndScaleformMovieMethod()
    end
  end)
end

AddEventHandler('pma-voice:setTalkingMode', function(mode)
  SendNUIMessage({action = 'voice', voiceRange = mode})
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
 	ESX.PlayerLoaded = true
  InitHUD()
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
end)

AddEventHandler('onResourceStart', function(resourceName)
  if (resourceName == GetCurrentResourceName()) then
    if ESX.PlayerLoaded then
      Citizen.Wait(500)
      InitHUD()
    end
  end
end)