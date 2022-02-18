fx_version 'cerulean'
game 'gta5'
author '0xDEMXN'
version '1.0.6'

lua54 'yes'
use_fxv2_oal 'yes'

shared_scripts {
    '@es_extended/imports.lua'
}

client_scripts {
    'config.lua',
    'client.lua',
}

files {
    'html/ui.html',
    'html/script.js',
    'html/style.css',
    'html/logo.png',
}

ui_page 'html/ui.html'

dependencies {
    'es_extended',
    'esx_status',
    'esx_basicneeds'
}