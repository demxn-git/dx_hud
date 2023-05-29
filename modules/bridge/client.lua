if not lib then return end

function HideHUD()
	HUD = false
	SendNUIMessage({ action = 'setVisible', data = false })
end

if GetResourceState('ox_core'):find('start') then
	local file = ('imports/%s.lua'):format(IsDuplicityVersion() and 'server' or 'client')
	local import = LoadResourceFile('ox_core', file)
	local chunk = assert(load(import, ('@@ox_core/%s'):format(file)))
	chunk()

	if player then DrawHUD() end
	RegisterNetEvent('ox:playerLoaded', DrawHUD)
	RegisterNetEvent('ox:playerLogout', HideHUD)

	AddEventHandler('ox:statusTick', function(values)
		SendNUIMessage({
			action = 'status',
			data  = values
		})
	end)
end

if GetResourceState('es_extended'):find('start') then
	local ESX = exports['es_extended']:getSharedObject()
	if ESX.PlayerLoaded then DrawHUD() end

	RegisterNetEvent('esx:playerLoaded', DrawHUD)
	RegisterNetEvent('esx:onPlayerLogout', HideHUD)

	AddEventHandler('esx_status:onTick', function(data)
		local hunger, thirst, stress
		for i = 1, #data do
			if data[i].name == 'thirst' then thirst = math.floor(data[i].percent) end
			if data[i].name == 'hunger' then hunger = math.floor(data[i].percent) end
			if data[i].name == 'stress' then stress = math.floor(data[i].percent) end
		end

		SendNUIMessage({
			action = 'status',
			data = {
				hunger = hunger,
				thirst = thirst,
				stress = client.stress and stress,
			}
		})
	end)
end
