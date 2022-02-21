fx_version 'cerulean'
game 'gta5'
author '0xDEMXN'
version '1.1.1'

lua54 'yes'
use_fxv2_oal 'yes'

shared_scripts {
    '@es_extended/imports.lua'
}

client_scripts {
    'config.lua',
    'init.lua',
    'events.lua',
    'modules/*',
}

files {
    'html/index.html',
    'html/**/*',
}

ui_page 'html/index.html'

dependencies {
    'es_extended',
    'esx_status',
    'esx_basicneeds'
}