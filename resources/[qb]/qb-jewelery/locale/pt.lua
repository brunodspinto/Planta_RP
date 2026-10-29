local Translations = {
    error = {
        fingerprints = 'Deixaste uma impressão digital no vidro',
        minimum_police = 'São precisos pelo menos %{value} polícias',
        wrong_weapon = 'A tua arma não é forte o suficiente...',
        to_much = 'Tens demasiadas coisas nos bolsos'
    },
    success = {},
    info = {
        progressbar = 'A partir a vitrine',
    },
    general = {
        target_label = 'Partir a vitrine',
        drawtextui_grab = '[E] Partir a vitrine',
        drawtextui_broken = 'A vitrine está partida'
    }
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
