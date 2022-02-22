currentResourceName = GetCurrentResourceName()
cfg = json.decode(LoadResourceFile(currentResourceName, 'config.json'))

nuiIsReady = false
RegisterNUICallback('nuiIsReady', function(_, cb) 
  nuiIsReady = true
  cb({})
end)

function SendMessage(action, message)
  SendNUIMessage({
    action = action,
    message = message
  })
end