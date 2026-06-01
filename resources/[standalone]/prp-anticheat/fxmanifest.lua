fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'PlantaRP'
description 'Anticheat server-side com persistência, detecções de gameplay e bans'
version '2.0.0'

shared_script 'config.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/state.lua',
    'server/identifiers.lua',
    'server/webhook.lua',
    'server/bans.lua',
    'server/punishment.lua',
    'server/detections.lua',
    'server/commands.lua',
    'server/exports.lua',
    'server/main.lua',
}

files {
    'sql/install.sql',
}

dependencies {
    'oxmysql',
}
