fx_version 'cerulean'
game 'gta5'
author '0xDEMXN'
version '1.0.1'

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
    'html/loading-bar.js',
}

ui_page 'html/ui.html'

dependencies {
    'es_extended',
    'esx_status',
    'esx_basicneeds'
}