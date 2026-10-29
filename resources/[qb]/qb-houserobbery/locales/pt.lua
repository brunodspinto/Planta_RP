local Translations = {
    error = {
        not_allowed_time = 'Não podes fazer isso a esta hora do dia.',
        ['missing_something'] = 'Parece que te está a faltar algo...',
        ['not_enough_police'] = 'Policia Insuficiente...',
        ['door_open'] = 'Esta porta já está aberta...',
        ['process_cancelled'] = 'Processo Cancelado...',
        ['didnt_work'] = 'Não funcionou...',
        ['emty_box'] = 'A caixa está vazia...',
    },
    success = {
        ['worked'] = 'Funcionou!',
    },
    info = {
        ['palert'] = 'Tentativa de Roubo a Residência',
        ['henter'] = '~g~E~w~ - Para entrar',
        ['hleave'] = '~g~E~w~ - Para sair',
        ['aint'] = '~g~E~w~ - ',
        ['hsearch'] = 'Procurando..',
        ['hsempty'] = 'Vazio..',
    },
    searching = {
        ['search_bcabinet'] = 'Revistar mesa de cabeceira',
        ['search_closet'] = 'Revistar roupeiro',
        ['search_chest'] = 'Revistar baú',
        ['search_drawer'] = 'Revistar gavetas',
        ['search_cabinet'] = 'Revistar mesinha de cabeceira',
        ['search_kcabinet'] = 'Revistar os armários da cozinha',
        ['search_shelves'] = 'Revistar as prateleiras',
    }
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
