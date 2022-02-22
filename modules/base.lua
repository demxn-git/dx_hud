BaseLoop = function()
  CreateThread(function()
    while ESX.PlayerLoaded do
      local currentVehicle = GetVehiclePedIsUsing(ESX.PlayerData.ped, false)

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
        vehicle = IsPedInAnyVehicle(ESX.PlayerData.ped, true) and {
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

      Wait(dx.baseRefreshRate)
    end
  end)
end