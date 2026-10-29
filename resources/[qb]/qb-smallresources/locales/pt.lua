local Translations = {
    afk = {
        will_kick = "Estás AFK e vais ser kickado em",
        time_seconds = " segundos!",
        time_minutes = " minutos!",
        kick_message = "Foste Kickado Por Estares AFK"
    },
    error = {
        ["car_wash_canceled"] = "Lavagem cancelada...",
        ["car_wash_notdirty"] = "O veículo não está sujo",
        ["cruise_deactivated"] = "Cruise control desativado",
        ["cruise_unavailable"] = "Cruise control indisponível",
        ["not_in_car"] = "Não estás dentro de um carro.",
        ["dont_have_enough_money"] = "Não tens dinheiro suficiente...",
        ["global_canceled"] = "Cancelado..."
    },
    info = {
        ["cruise_activated_mp"] = "Cruise Ativado: %{speed} MP/H",
        ["cruise_activated_km"] = "Cruise Ativado: %{speed} KM/H"
    },
    progress = {
        ["car_wash_progress"] = "O veículo está a ser lavado...",
        ["placing_firework"] = "A preparar fogo de artifício...",
        ["attach_race_harness"] = "A colocar Arnês de Corrida",
        ["remove_race_harness"] = "A remover Arnês de Corrida"
    },
    text = {
        ["car_wash_text"] = "~g~E~w~ - Lavar Veículo (%{price}€)",
        ["car_wash_not_available"] = "A estação de lavagem não está disponível...",
        ["time_until_firework"] = "Fogo de Artifício em ~r~%{time}",
        ["push_vehicle"] = "[~g~SHIFT~w~] + [~g~E~w~] para empurrar veículo"
    },
    cruise = {
        ["not_Enough_Fuel"] = "Combustível insuficiente",
        ["activated"] = "Cruise control ativado",
        ["deactivated"] = "Cruise control desativado",
        ["unavailable"] = "Cruise control indisponível"
    },
    editor = {
        started = 'Gravação iniciada!',
        delete = 'Gravação apagada!',
        ["record"] = "Gravação Iniciada!",
        ["save"] = "Gravação Guardada!",
        ["delete_clip"] = "Gravação Apagada!",
        ["editor"] = "Até logo!"
    },
    firework = {
        place_progress = 'A colocar o fogo de artifício...',
        ["canceled"] = "Cancelado...",
        ["time_left"] = "Fogo de Artifício em ",
        ["place_firework"] = "A colocar fogo de artifício..."
    },
    seatbelt = {
        use_harness_progress = 'A colocar o arnês de corrida',
        remove_harness_progress = 'A tirar o arnês de corrida',
        ["no_car"] = "Não estás dentro de um carro.",
        ["use_harness"] = "A colocar Arnês de Corrida",
        ["remove_harness"] = "A remover Arnês de Corrida"
    },
    teleport = {
        ["teleport_default"] = "Usar Elevador"
    },
    pushcar = {
        ["stop_push"] = "[E] Parar de Empurrar",
        ["notDamaged"] = "O veículo não está danificado o suficiente para empurrar!"
    },
    consumables = {
        use_parachute_progress = 'A colocar o paraquedas...',
        remove_armor_progress = 'A tirar o colete...',
        pack_parachute_progress = 'A dobrar o paraquedas...',
        no_parachute = 'Não tens paraquedas!',
        meth_progress = 'A fumar meta...',
        liqour_progress = 'A beber álcool...',
        joint_progress = 'A acender o charro...',
        heavy_armor_progress = 'A vestir o colete pesado...',
        healing_progress = 'A tratar ferimentos...',
        ecstasy_progress = 'A tomar comprimidos...',
        eat_progress = 'A comer...',
        drink_progress = 'A beber...',
        crack_progress = 'A fumar crack...',
        coke_progress = 'Uma snifadela rápida...',
        canceled = 'Cancelado...',
        armor_progress = 'A vestir o colete...',
        armor_full = 'Já tens colete suficiente!',
        armor_empty = 'Não tens nenhum colete vestido...',
    },
    wash = {
        wash_vehicle_target = 'Lavar veículo',
        wash_vehicle = '[E] Lavar veículo',
        in_progress = 'O veículo está a ser lavado...',
        dirty = 'O veículo não está sujo',
        cancel = 'Lavagem cancelada...',
    },
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end

