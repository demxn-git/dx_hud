--[[ FX Information ]]--
fx_version   'cerulean'
use_experimental_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'dx_hud'
version      '1.3'
description  'An HUD for FiveM and ESX Legacy.'
license      'GNU General Public License v3.0'
author       '0xDEMXN'
repository   'https://github.com/0xDEMXN/dx_hud'

--[[ Manifest ]]--
dependencies {
    'es_extended',
    'esx_status',
    'esx_basicneeds'
}

shared_scripts {
    '@es_extended/imports.lua',
    'shared/init.lua',
}

client_scripts {
    'client/hud.lua',
    'client/minimap.lua',
    'client/seatbelt.lua',
    'client/voice.lua'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/**/*'
}