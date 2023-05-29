if not lib or not client.voice then return end

local voiceCon, voiceDisc
local isTalking, isSilent

CreateThread(function()
	while true do
		if HUD then
			if client.voiceservice == 'pma-voice' then
				voiceCon = MumbleIsConnected()
				isTalking = NetworkIsPlayerTalking(cache.playerId)
			end

			if client.voiceservice == 'pma-voice' and voiceCon or client.voiceservice == 'saltychat' and voiceCon > 0 then
				voiceDisc = false

				if isTalking then
					SendNUIMessage({
						action = 'setVoice',
						data = isTalking
					})

					isSilent = false
				elseif not isSilent then
					SendNUIMessage({
						action = 'setVoice',
						data = isTalking
					})

					isSilent = true
				end
			elseif not voiceDisc then
				SendNUIMessage({
					action = 'setvoice',
					data = 'disconnected'
				})

				voiceDisc = true
				isSilent = nil
			end
		end
		Wait(200)
	end
end)

if client.voiceservice == 'pma-voice' then
	AddEventHandler('pma-voice:setTalkingMode', function(mode)
		SendNUIMessage({
			action = 'setVoiceRange',
			data = mode
		})
	end)
elseif client.voiceservice == 'saltychat' then
	AddEventHandler('SaltyChat_PluginStateChanged', function(_voiceCon)
		voiceCon = _voiceCon
	end)

	AddEventHandler('SaltyChat_TalkStateChanged', function(_isTalking)
		isTalking = _isTalking
	end)

	AddEventHandler('SaltyChat_VoiceRangeChanged', function(range, index, count)
		SendNUIMessage({
			action = 'setVoiceRange',
			data = index
		})
	end)
end
