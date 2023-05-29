HUD = false

require 'modules.hud.client'
require 'modules.minimap.client'
require 'modules.seatbelt.client'
require 'modules.vehicle.client'
require 'modules.voice.client'
require 'modules.bridge.client'

CreateThread(function()
	DisplayRadar(false)
	
	if client.circlemap then
		lib.requestStreamedTextureDict('circlemap')
		AddReplaceTexture('platform:/textures/graphics', 'radarmasksm', 'circlemap', 'radarmasksm')

		SetMinimapClipType(1)
		SetMinimapComponentPosition('minimap', 'L', 'B', -0.017, -0.02, 0.207, 0.32)
		SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.06, 0.00, 0.132, 0.260)
		SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.005, -0.05, 0.166, 0.257)
	else
		SetMinimapComponentPosition('minimap', 'L', 'B', 0.0, -0.035, 0.18, 0.21)
		SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0, -0.05, 0.132, 0.19)
		SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.025, -0.015, 0.3, 0.25)
	end

	SetBigmapActive(true, false)
	SetBigmapActive(false, false)
	Wait(500)

	SendNUIMessage({ action = 'setPlayerId', data = cache.serverId })
	if client.serverlogo then SendNUIMessage({ action = 'setLogo' }) end

	SendNUIMessage({ action = 'setVisible', data = true })
end)
