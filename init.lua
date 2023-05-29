lib.locale()

shared = {
	resource = GetCurrentResourceName(),
	framework = GetConvar('hud:framework', 'esx'),
	seatbelt = GetConvarInt('hud:seatbelt', false) == 0,
}

if not IsDuplicityVersion() then
	client = {
		circlemap = GetConvarInt('hud:circleMap', true) == 1,
		serverlogo = GetConvarInt('hud:logo', true) == 1,
		stress = GetConvarInt('hud:stress', false) == 1,
		stamina = GetConvarInt('hud:stamina', false) == 1,
		persistentradar = GetConvarInt('hud:persistentRadar', false) == 1,
		circlemapkey = GetConvar('hud:cyclemapKey', 'Z'),
		seatbeltkey = GetConvar('hud:seatbeltKey', 'B'),
		unitsystem = GetConvar('hud:unitsystem', 'imperial'),
		fuel = GetConvarInt('hud:fuel', false) == 1,
		voice = GetConvarInt('hud:voice', false) == 1,
		voiceservice = GetConvar('hud:voiceService', 'pma-voice')
	}
end

---@param variable string
---@param expected string
---@param received string
function TypeError(variable, expected, received)
    error(("expected %s to have type '%s' (received %s)"):format(variable, expected, received))
end

---@param name string
---@return table
function data(name)
	if shared.server and shared.ready == nil then return {} end
	local file = ('data/%s.lua'):format(name)
	local datafile = LoadResourceFile(shared.resource, file)
	local path = ('@@%s/%s'):format(shared.resource, file)

	if not datafile then
		warn(('no datafile found at path %s'):format(path:gsub('@@', '')))
		return {}
	end

	local func, err = load(datafile, path)

	if not func or err then
		shared.ready = false
		---@diagnostic disable-next-line: return-type-mismatch
		return error(err)
	end

	return func()
end

if not lib then
	return error('dx_hud requires the ox_lib resource, refer to the README.')
end

success, msg = lib.checkDependency('ox_lib', '3.2.0')

if not success then error(msg) end

if not LoadResourceFile(shared.resource, 'web/build/index.html') then
	return error('UI has not been built, refer to the README or download a release build.\n	^3https://github.com/0xDEMXN/dx_hud/releases^0')
end

if lib.context == 'server' then
	return require 'server'
end

require 'client'
