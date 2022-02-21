playerId = PlayerId()

InitHUD = function()
  if IsPedSwimming(ESX.PlayerData.ped) then
    local timer = 5000
    ESX.ShowNotification('Calculating your lung capacity...')
    while not maxUnderwaterTime do
      Citizen.Wait(1000)
      timer -= 1000
      if not IsPedSwimmingUnderWater(ESX.PlayerData.ped) then
        if timer == 0 then maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(playerId) end
      else
        timer = 5000
        ESX.ShowNotification('Don\'t go underwater while your lung capacity is being calculated!')
      end
    end
  else maxUnderwaterTime = GetPlayerUnderwaterTimeRemaining(playerId) end

  BaseLoop()
  StatusLoop()
  SendNUIMessage({ action = 'general', playerId = GetPlayerServerId(playerId) })

  while ESX.PlayerLoaded do
    SendNUIMessage({ action = 'general', visible = not IsPauseMenuActive() })
    Citizen.Wait(1000)
  end
end