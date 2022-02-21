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
  SendNUIMessage({ action = 'general', visible = false })
end)

AddEventHandler('onResourceStart', function(resourceName)
  if (resourceName == GetCurrentResourceName()) then
    if ESX.PlayerLoaded then
      Citizen.Wait(500)
      InitHUD()
    end
  end
end)