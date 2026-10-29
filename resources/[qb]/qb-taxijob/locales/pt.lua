local Translations = {
    error = {
        times = 'vezes',
        time = 'vez',
        ride_canceled = 'Bateste demasiadas vezes, a viagem foi cancelada!',
        crash_warning = 'Se bateres mais %d %s, o cliente acaba a viagem e não recebes nada!',
        broken_taxi = 'O teu táxi tem de ser reparado antes de voltares ao trabalho!',
        ['already_mission'] = 'Já te encontrar a efectuar uma missão NPC',
        ['not_in_taxi'] = 'Não estás num Taxi',
        ['missing_meter'] = 'Este veículo não possui um taxímetro',
        ['no_vehicle'] = 'Não estás num veículo',
        ['not_active_meter'] = 'O taxímetro não se encontra activo',
    },
    info = {
        tip_received = 'Recebeste $%d de gorjeta pela condução segura',
        tip_not_received = 'Tenta não bater com o táxi se quiseres receber gorjetas no futuro',
        taxi_returned = 'Táxi estacionado',
        no_spawn_point = 'Não foi possível encontrar um local para trazer o táxi',
        ['person_was_dropped_off'] = 'O passageiro foi entregue!',
        ['npc_on_gps'] = 'O NPC encontra-se indicado no teu GPS',
        ['go_to_location'] = 'Transporta o NPC para a localização assinalada',
        ['vehicle_parking'] = '[E] Estacionamento de Veículo',
        ['job_vehicles'] = '[E] Veículos de Trabalho',
        ['drop_off_npc'] = '[E] Entregar NPC',
        ['call_npc'] = '[E] Chamar NPC',
        ['blip_name'] = 'Taxis da Baixa',
        ['taxi_label_1'] = 'Taxi',
        ['on_duty'] = '[E] - Entrar em serviço',
        ['off_duty'] = '[E] - Sair de serviço'
    },
    menu = {
        boss_menu = 'Menu do patrão',
        ['taxi_menu_header'] = 'Veículos de Taxi',
        ['close_menu'] = '⬅ Fechar Menu'
    },
    success = {
        mission_cancelled = 'Missão cancelada com sucesso',
    },
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
