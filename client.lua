local playerId = PlayerId()

local curPaused
local curPed

Citizen.CreateThread(function ()
  while true do
    if nuiIsReady and ESX.PlayerLoaded then
      local ped = PlayerPedId()

      local paused = IsPauseMenuActive()
      if paused ~= curPaused then
        SendMessage('toggleHud', not paused)
        curPaused = paused
      end

      if not cfg.persistentRadar then
        local inVehicle = IsPedInAnyVehicle(ped, true)
        local isRadarHidden = IsRadarHidden()
        if inVehicle == isRadarHidden then
          DisplayRadar(inVehicle)
          SetRadarZoom(1150)
        end
      end

      if ped ~= curPed then
        if IsPedSwimming(ped) then
          local timer = 5000
          while not maxUnderwaterTime do
            Citizen.Wait(1000)
            timer -= 1000
            if not IsPedSwimmingUnderWater(ped) then
              if timer == 0 then maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(playerId) end
            else timer = 5000 end
          end
        else maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(playerId) end
        curPed = ped
      end
    end
    Citizen.Wait(cfg.refreshRates.checks)
  end
end)

local lastHealth
local lastArmour
local lastStamina
local onSurface
local offVehicle
local voiceDisc
local isSilent

CreateThread(function()
  while true do
    if nuiIsReady and ESX.PlayerLoaded then
      local ped = PlayerPedId()

      local curHealth = GetEntityHealth(ped)
      if curHealth ~= lastHealth then
        SendMessage('setHealth', { current = curHealth, max = GetEntityMaxHealth(ped) })
        lastHealth = curHealth
      end

      local curArmour = GetPedArmour(ped)
      if curArmour ~= lastArmour then
        SendMessage('setArmour', curArmour)
        lastArmour = curArmour
      end

      if cfg.stamina and offVehicle then  
        local curStamina = GetPlayerSprintStaminaRemaining(playerId)
        if curStamina ~= lastStamina then
          SendMessage('setStamina', curStamina)
          lastStamina = curStamina
        end
      end

      while not maxUnderwaterTime and IsPedSwimmingUnderWater(ped) do
        ESX.ShowHelpNotification('Initializating HUD... please stay on surface at least 5 seconds!', true)
        Citizen.Wait(0)
      end

      if maxUnderwaterTime then
        local underWater = GetPlayerUnderwaterTimeRemaining(playerId) < maxUnderwaterTime
        if underWater then
          SendMessage('setOxygen', {
            current = GetPlayerUnderwaterTimeRemaining(playerId),
            max = maxUnderwaterTime
          })
          onSurface = false
        elseif not onSurface then
          SendMessage('setOxygen', false)
          onSurface = true
        end
      end

      local inVehicle = IsPedInAnyVehicle(ped, true)
      if inVehicle then
        local curVehicle = GetVehiclePedIsUsing(ped, false)
        SendMessage('setVehicle', {
          speed = {
            current = GetEntitySpeed(curVehicle),
            max = GetVehicleModelMaxSpeed(GetEntityModel(curVehicle))
          },
          unitsMultiplier = cfg.metricSystem and 3.6 or 2.236936,
          fuel = cfg.fuel and GetVehicleFuelLevel(curVehicle),
        })
        offVehicle = false
      elseif not offVehicle then
        SendMessage('setVehicle', false)
        offVehicle = true
      end

      if cfg.voice then
        local voiceCon = MumbleIsConnected()
        local isTalking = NetworkIsPlayerTalking(playerId)
        if voiceCon then
          if isTalking then
            SendMessage('setVoice', isTalking)
            isSilent = false
          elseif not isSilent then
            SendMessage('setVoice', isTalking)
            isSilent = true
          end
          voiceDisc = false
        elseif not voiceDisc then
          SendMessage('setVoice', 'disconnected')
          voiceDisc = true
          isSilent = false
        end
      end
    end
    Citizen.Wait(cfg.refreshRates.base)
  end
end)

local hunger
local thirst
local stress

CreateThread(function()
  while true do
    if nuiIsReady and ESX.PlayerLoaded then
      repeat
        TriggerEvent('esx_status:getStatus', 'hunger', function(status)
          if status then hunger = status.val / 10000 end
        end)
        TriggerEvent('esx_status:getStatus', 'thirst', function(status)
          if status then thirst = status.val / 10000 end
        end)
        if cfg.stress then
          TriggerEvent('esx_status:getStatus', 'stress', function(status)
            if status then stress = status.val / 10000 end
          end)
        end
        Citizen.Wait(100)
      until cfg.stress and hunger and thirst and stress or hunger and thirst

      SendMessage('status', {
        hunger = hunger,
        thirst = thirst,
        stress = cfg.stress and stress,
      })
    end
    Wait(cfg.refreshRates.status)
  end
end)

AddEventHandler('pma-voice:setTalkingMode', function(mode)
  SendMessage('setVoiceRange', mode)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
 	ESX.PlayerLoaded = true
  SendMessage('setPlayerId', GetPlayerServerId(playerId))
  SendMessage('toggleHud', true)
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
  SendMessage('toggleHud', false)
end)