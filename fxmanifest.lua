fx_version 'cerulean'
game 'gta5'
description 'System for enterprise to own vehicles and stuffs'
author 'Vitolio' 
version '1.0'
lua54 'yes'

shared_script {
	'@qb-core/shared/locale.lua',
	'config.lua',
	'@PolyZone/client.lua',
    '@PolyZone/CircleZone.lua',
    'locales/fr.lua' --change here to put the correct language
}
server_script {
	'server/*.lua',
	'@oxmysql/lib/MySQL.lua',
}
client_script 'client/*.lua'

escrow_ignore {
  'config.lua', 
  'Readme.md',
  'locales/*.lua',
  'client/*.lua',
  'server/*.lua'
}