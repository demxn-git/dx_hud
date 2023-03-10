currentResourceName = GetCurrentResourceName()
config = json.decode(LoadResourceFile(currentResourceName, 'config.json'))

if not IsDuplicityVersion() then
    function SendMessage(action, message)
        SendNUIMessage({
            action = action,
            message = message
        })
    end

    nuiReady = false
    RegisterNUICallback('nuiReady', function(_, cb)
        nuiReady = true
        cb({})
    end)

    playerId = PlayerId()
else
    if config.seatbelt.enabled then SetConvarReplicated('game_enableFlyThroughWindscreen', 'true') end
end