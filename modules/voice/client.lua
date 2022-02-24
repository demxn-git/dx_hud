if cfg.voice.enabled then
  local service = cfg.voice.service

  local voiceCon
  local isTalking
  local voiceDisc
  local isSilent
  
  CreateThread(function()
    while true do
      if nuiReady then
        if service == 'pma-voice' then
          voiceCon = MumbleIsConnected()
          isTalking = NetworkIsPlayerTalking(playerId)
        end

        if service == 'pma-voice' and voiceCon 
        or service == 'saltychat' and voiceCon and voiceCon > 0 
        then
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
      Citizen.Wait(cfg.refreshRates.base)
    end
  end)
  
  if service == 'pma-voice' then
    AddEventHandler('pma-voice:setTalkingMode', function(mode)
      SendMessage('setVoiceRange', mode)
    end)
  elseif service == 'saltychat' then
    AddEventHandler('SaltyChat_PluginStateChanged', function(_voicecon)
      voiceCon = _voicecon
    end)

    AddEventHandler('SaltyChat_TalkStateChanged', function(_isTalking)
      isTalking = _isTalking
    end)

    AddEventHandler('SaltyChat_VoiceRangeChanged', function(range, index, count)
      SendMessage('setVoiceRange', index)
    end)
  end
end