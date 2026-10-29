local Translations = {
    notifications = {
        ["char_deleted"] = "Personagem apagada!",
        ["deleted_other_char"] = "Apagaste com sucesso a personagem com o ID de cidadão %{citizenid}.",
        ["forgot_citizenid"] = "Esqueceste-te de indicar o ID de cidadão!",
        },

    commands = {
        -- /deletechar
        ["deletechar_description"] = "Apaga a personagem de outro jogador",
        ["citizenid"] = "ID de cidadão",
        ["citizenid_help"] = "O ID de cidadão da personagem que queres apagar",

        -- /logout
        ["logout_description"] = "Sair da personagem (só admin)",

        -- /closeNUI
        ["closeNUI_description"] = "Fechar várias NUIs"
    },

    misc = {
        ["droppedplayer"] = "Saiu do servidor"
    },

    ui = {
        -- Main
        characters_header = "As minhas personagens",
        emptyslot = "Espaço vazio",
        play_button = "Jogar",
        create_button = "Criar personagem",
        delete_button = "Apagar personagem",

        -- Character Information
        charinfo_header = "Informação da personagem",
        charinfo_description = "Escolhe uma personagem para veres as informações dela.",
        name = "Nome",
        male = "Homem",
        female = "Mulher",
        firstname = "Nome",
        lastname = "Apelido",
        nationality = "Nacionalidade",
        gender = "Género",
        birthdate = "Data de nascimento",
        job = "Profissão",
        jobgrade = "Cargo",
        cash = "Dinheiro",
        bank = "Banco",
        phonenumber = "Telemóvel",
        accountnumber = "Número de conta",

        chardel_header = "Registo de personagem",

        -- Delete character
        deletechar_header = "Apagar personagem",
        deletechar_description = "Tens a certeza de que queres apagar esta personagem?",

        -- Buttons
        cancel = "Cancelar",
        confirm = "Confirmar",

        -- Loading Text
        retrieving_playerdata = "A obter os dados do jogador",
        validating_playerdata = "A validar os dados do jogador",
        retrieving_characters = "A obter as personagens",
        validating_characters = "A validar as personagens",

        -- Notifications
        ran_into_issue = "Ocorreu um problema",
        profanity = "Parece que estás a tentar usar palavrões no nome ou na nacionalidade!",
        forgotten_field = "Parece que te esqueceste de preencher um ou mais campos!"
        }
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
