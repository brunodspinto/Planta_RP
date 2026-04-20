fx_version 'cerulean'
game 'gta5'

author 'Boss Engineering'
description 'Velocímetro Simples em KM/H'
version '1.0.0'


dependencies {
    'qb-core',
}

shared_scripts { '@qb-core/shared/locale.lua' }

client_scripts {
    'client.lua'
}

lua54 'yes'