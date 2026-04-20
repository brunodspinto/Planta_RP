fx_version 'cerulean'
game 'gta5'

description 'Sistema de Reparar Carro Pago'
version '1.0.0'


dependencies {
    'qb-core',
}

shared_script '@ox_lib/init.lua'

client_script 'client.lua'
server_script 'server.lua'