currentResourceName = GetCurrentResourceName()
cfg = json.decode(LoadResourceFile(currentResourceName, 'config.json'))

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