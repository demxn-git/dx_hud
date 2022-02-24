currentResourceName = GetCurrentResourceName()
cfg = json.decode(LoadResourceFile(currentResourceName, 'config.json'))

if not IsDuplicityVersion() then
  playerId = PlayerId()
  nuiReady = false
  RegisterNUICallback('nuiReady', function(_, cb) 
    nuiReady = true
    cb({})
  end)

  function SendMessage(action, message)
    SendNUIMessage({
      action = action,
      message = message
    })
  end
else
  if cfg.seatbelt.enabled then SetConvarReplicated('game_enableFlyThroughWindscreen', 'true') end
end