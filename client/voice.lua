if GetConvar('hud:voice', 'false') == 'true' then
	local service = GetConvar('hud:voiceService', 'pma-voice')

	local voiceCon, voiceDisc
	local isTalking, isSilent

	CreateThread(function()
		while true do
			if HUD then
				if service == 'pma-voice' then
					voiceCon = MumbleIsConnected()
					isTalking = NetworkIsPlayerTalking(cache.playerId)
				end

				if service == 'pma-voice' and voiceCon
					or service == 'saltychat' and voiceCon > 0
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
					isSilent = nil
				end
			end
			Wait(200)
		end
	end)

	if service == 'pma-voice' then
		AddEventHandler('pma-voice:setTalkingMode', function(mode)
			SendMessage('setVoiceRange', mode)
		end)
	elseif service == 'saltychat' then
		AddEventHandler('SaltyChat_PluginStateChanged', function(_voiceCon)
			voiceCon = _voiceCon
		end)

		AddEventHandler('SaltyChat_TalkStateChanged', function(_isTalking)
			isTalking = _isTalking
		end)

		AddEventHandler('SaltyChat_VoiceRangeChanged', function(range, index, count)
			SendMessage('setVoiceRange', index)
		end)
	end
end
