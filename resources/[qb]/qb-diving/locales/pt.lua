local Translations = {
    error = {
        ["canceled"] = "Cancelado",
        ["911_chatmessage"] = "911 MENSAGEM",
        ["take_off"] = "/divingsuit para tirar o fato de mergulho",
        ["not_wearing"] = "Não estás a usar equipamento de mergulho..",
        ["no_coral"] = "Não tens coral para vender..",
        ["not_standing_up"] = "Precisas de estar de pé para vestir o equipamento de mergulho",
        ["need_otube"] = "precisas de um tubo de oxigénio",
        ["oxygenlevel"] = 'o nível do equipamento é %{oxygenlevel}, deve estar a 0%'
    },
    success = {
        ["took_out"] = "Retiraste o teu fato de mergulho",
        ["tube_filled"] = "O tubo foi enchido com sucesso"
    },
    info = {
        ["collecting_coral"] = "A recolher coral",
        ["diving_area"] = "Área de mergulho",
        ["collect_coral"] = "Recolher coral",
        ["collect_coral_dt"] = "[E] - Recolher coral",
        ["checking_pockets"] = "A verificar os bolsos para vender coral",
        ["sell_coral"] = "Vender Coral",
        ["sell_coral_dt"] = "[E] - Vender Coral",
        ["blip_text"] = "911 - Local de Mergulho",
        ["put_suit"] = "Vestir fato de mergulho",
        ["pullout_suit"] = "Retirar fato de mergulho ..",
        ["cop_msg"] = "Este coral pode ser furtado",
        ["cop_title"] = "Mergulho ilegal",
        ["command_diving"] = "Retira o teu fato de mergulho",
    },
    warning = {
        ["oxygen_one_minute"] = "Tens menos de 1 minuto de ar restante",
        ["oxygen_running_out"] = "O teu equipamento de mergulho está a ficar sem ar",
    },
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
