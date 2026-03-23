local Translations = {
    error = {
        minimum_store_robbery_police = "Não há agentes suficientes (%{MinimumStoreRobberyPolice} necessários)",
        not_driver = "Não és o condutor",
        demolish_vehicle = "Não tens autorização para destruir veículos agora",
        process_canceled = "Processo cancelado...",
        you_broke_the_lock_pick = "Partiste a gazua",
    },
    text = {
        the_cash_register_is_empty = "A caixa registadora está vazia",
        try_combination = "~g~E~w~ - Tentar combinação",
        safe_opened = "Cofre aberto",
        emptying_the_register= "A esvaziar a caixa...",
        safe_code = "Código do cofre: "
    },
    email = {
        shop_robbery = "10-31 | Roubo de loja",
        someone_is_trying_to_rob_a_store = "Alguém está a tentar roubar uma loja em %{street} (ID CÂMARA: %{cameraId1})",
        storerobbery_progress = "Roubo de loja em andamento"
    },
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end