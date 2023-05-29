if not lib then return end

if GetConvarInt('hud:versioncheck', true) == 1 then
	lib.versionCheck('0xDEMXN/dx_hud')
end

require 'modules.seatbelt.server'
