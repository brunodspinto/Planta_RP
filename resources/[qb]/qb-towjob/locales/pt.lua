local Translations = {
    error = {
        finish_work = "Termine todo o seu trabalho primeiro",
        vehicle_not_correct = "Este não é o veículo correto",
        failed = "Falhaste",
        not_towing_vehicle = "Tens de estar no teu veículo de reboque",
        too_far_away = "Estás demasiado longe",
        no_work_done = "Ainda não fizeste nenhum trabalho",
        no_deposit = "Depósito de $%{value} necessário",
    },
    success = {
        paid_with_cash = "Depósito de $%{value} pago em numerário",
        paid_with_bank = "Depósito de $%{value} pago da conta bancária",
        refund_to_cash = "Depósito de $%{value} devolvido em numerário",
        you_earned = "Ganhaste $%{value}",
    },
    menu = {
        header = "Camiões Disponíveis",
        close_menu = "⬅ Fechar Menu",
    },
    mission = {
        delivered_vehicle = "Entregaste um veículo",
        get_new_vehicle = "Um novo veículo pode ser retirado",
        towing_vehicle = "A içar o veículo...",
        goto_depot = "Leva o veículo para o Depósito Hayes",
        vehicle_towed = "Veículo rebocado",
        untowing_vehicle = "Remover o veículo",
        vehicle_takenoff = "Veículo retirado",
    },
    info = {
        tow = "Coloca um carro na traseira do teu camião de plataforma",
        toggle_npc = "Alternar Trabalho de NPC",
        skick = "Tentativa de abuso de exploração",
    },
    label = {
        payslip = "Recibo de vencimento",
        vehicle = "Veículo",
        npcz = "Zona de NPC",
    }
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
