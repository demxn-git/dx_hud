BaseLoop = function()
  CreateThread(function()
    while ESX.PlayerLoaded do
      local isDriving = IsPedInAnyVehicle(ESX.PlayerData.ped, true)
      local currentVehicle = isDriving and GetVehiclePedIsUsing(ESX.PlayerData.ped, false)

      SetRadarZoom(1150)
      DisplayRadar(dx.persistentRadar or isDriving)

      SendNUIMessage({
        action = 'base',
        health = {
          current = GetEntityHealth(ESX.PlayerData.ped),
          max = GetEntityMaxHealth(ESX.PlayerData.ped)
        },
        armour = GetPedArmour(ESX.PlayerData.ped),
        oxygen = {
          current = IsPedSwimmingUnderWater(ESX.PlayerData.ped) and GetPlayerUnderwaterTimeRemaining(playerId),
          max = maxUnderwaterTime
        },
        vehicle = isDriving and {
          speed = {
            current = GetEntitySpeed(currentVehicle),
            max = GetVehicleModelMaxSpeed(GetEntityModel(currentVehicle))
          },
          unitsMultiplier = dx.metricSystem and 3.6 or 2.236936,
          fuel = dx.fuel and GetVehicleFuelLevel(currentVehicle),
        },
        voice = {
          toggled = dx.voice,
          connected = dx.voice and MumbleIsConnected(),
          talking = dx.voice and NetworkIsPlayerTalking(playerId),
        }
      })

      Wait(dx.generalRefreshRate)
    end
  end)
end