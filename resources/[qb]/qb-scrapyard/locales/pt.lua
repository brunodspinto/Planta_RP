local Translations = {
    error = {
        smash_own = "Não podes desmantelar um veículo que é teu.",
        cannot_scrap = "Este veículo não pode ser desmontado.",
        not_driver = "Não és o condutor.",
        demolish_vehicle = "Não tens permissão para desmantelar veículos agora.",
        canceled = "Cancelado",
    },
    text = {
        scrapyard = 'Sucata',
        disassemble_vehicle = '[E] - Desmontar Veículo',
        disassemble_vehicle_target = 'Desmontar Veículo',
        email_list = "[E] - Enviar Lista de Veículos por E-mail",
        email_list_target = "Enviar Lista de Veículos por E-mail",
        demolish_vehicle = "Demolir Veículo",
    },
    email = {
        sender = "Sucata Turner",
        subject = "Lista de Veículos",
        message = "Só podes desmantelar um número limitado de veículos.<br />Podes ficar com tudo o que desmantelares, desde que não me chateies.<br /><br /><strong>Lista de Veículos:</strong><br />",
    },
}


if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
