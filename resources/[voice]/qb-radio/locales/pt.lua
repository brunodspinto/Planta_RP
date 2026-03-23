local Translations = {
    ["not_on_radio"] = "Não estás ligado a nenhuma frequência",
    ["joined_to_radio"] = "Ligaste-te à frequência: %{channel}",
    ["restricted_channel_error"] = "Não te podes ligar a esta frequência!",
    ["invalid_radio"] = "Esta frequência não está disponível.",
    ["you_on_radio"] = "Já estás ligado a este canal",
    ["you_leave"] = "Saíste do canal.",
    ['volume_radio'] = 'Novo volume: %{value}',
    ['decrease_radio_volume'] = 'O rádio já está no volume mínimo',
    ['increase_radio_volume'] = 'O rádio já está no volume máximo',
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
