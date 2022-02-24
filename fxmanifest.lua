fx_version 'cerulean'
game 'gta5'
author '0xDEMXN'
version '1.2.7'

lua54 'yes'
use_fxv2_oal 'yes'

shared_scripts {
  '@es_extended/imports.lua',
  'modules/init.lua',
}

client_scripts {
  'modules/**/client.lua',
  'client.lua'
}

server_scripts {
  'modules/**/server.lua'
}

files {
  'nui/index.html',
  'nui/**/*',
  'config.json'
}

ui_page 'nui/index.html'

dependencies {
  'es_extended',
  'esx_status',
  'esx_basicneeds'
}