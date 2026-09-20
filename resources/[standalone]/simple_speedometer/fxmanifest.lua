fx_version 'cerulean'
game 'gta5'

author 'PlantaRP'
description 'Velocímetro Simples em KM/H'
version '1.0.0'


-- Sem dependências: este recurso não usa nada do qb-core. Apenas escuta o
-- evento 'seatbelt:client:ToggleSeatbelt', que qualquer recurso pode disparar.

client_scripts {
    'client.lua'
}

lua54 'yes'