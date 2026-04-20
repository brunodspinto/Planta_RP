fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Kakarot'
description 'Allows players to craft items and earn experience'
version '1.0.0'


dependencies {
    'qb-core',
    'qb-input',
    'qb-inventory',
    'qb-menu',
    'qb-minigames',
    'qb-target',
}

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'
