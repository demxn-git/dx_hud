if cfg.voice.enabled then
  voiceCon = false
  isTalking = false
  local service = cfg.voice.service
  if service == 'pma-voice' then
    CreateThread(function()
      while true do
        voiceCon = MumbleIsConnected()
        isTalking = NetworkIsPlayerTalking(playerId)
        Citizen.Wait(cfg.refreshRates.base)
      end
    end)
    AddEventHandler('pma-voice:setTalkingMode', function(mode)
      SendMessage('setVoiceRange', mode)
    end)
  elseif service == 'saltychat' then
    AddEventHandler('SaltyChat_PluginStateChanged', function(pluginState)
      voiceCon = pluginState
    end)

    AddEventHandler('SaltyChat_TalkStateChanged', function(isTalking)
      isTalking = isTalking
    end)

    AddEventHandler('SaltyChat_VoiceRangeChanged', function(range, index, count)
      SendMessage('setVoiceRange', index)
    end)
  end
end