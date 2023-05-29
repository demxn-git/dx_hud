--[[ FX Information ]]--
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]]--
name 'dx_hud'
version '1.4.0'
description 'A FiveM HUD for ox_core and ESX Legacy.'
license 'GNU General Public License v3.0'
author '0xDEMXN'
repository 'https://github.com/0xDEMXN/dx_hud'

--[[ Manifest ]]--
dependencies {
	'ox_lib'
}

shared_script '@ox_lib/init.lua'
server_script 'init.lua'
client_script 'init.lua'

ui_page 'web/build/index.html'

files {
	'client.lua',
	'server.lua',
	'locales/*.json',
	'web/build/index.html',
	'web/build/assets/*.js',
	'web/build/assets/*.css',
	'web/build/assets/*.ogg',
	'web/build/assets/*.png',
	'modules/**/client.lua',
	'data/*.lua',
}
