local Translations = {
    info = {
        open_shop = '[E] Loja',
        deliver_e = '~g~E~w~ - Entregar Produtos',
        deliver = 'Entregar Produtos',
    },
    error = {
        missing_license = 'Licença %s ausente para certos produtos',
        no_deposit = '$%{value} Depósito necessário',
        cancelled = 'Cancelado',
        vehicle_not_correct = 'Este não é um veículo comercial!',
        no_driver = 'Tens de ser o condutor para fazer isso...',
        no_work_done = 'Ainda não fizeste nada...',
        backdoors_not_open = 'As portas traseiras do veículo não estão abertas',
        get_out_vehicle = 'Tens de sair do veículo para executar esta ação',
        too_far_from_trunk = 'Tens de pegar nas caixas da bagageira do teu veículo',
        too_far_from_delivery = 'Tens de estar mais perto do ponto de entrega'
    },
    success = {
        dealer_verify = 'O concessionário verifica a tua licença',
        paid_with_cash = '$%{value} Depósito pago em numerário',
        paid_with_bank = '$%{value} Depósito pago via banco',
        refund_to_cash = '$%{value} Depósito devolvido em numerário',
        you_earned = 'Ganhaste $%{value}',
        payslip_time = 'Visitaste todas as lojas... Está na hora do teu recibo de vencimento!',
    },
    mission = {
        store_reached = 'Loja alcançada, pega numa caixa com [E] e entrega no marcador',
        take_box = 'Pega numa caixa de produtos',
        deliver_box = 'Entrega uma caixa de produtos',
        another_box = 'Pega noutra caixa de produtos',
        goto_next_point = 'Entregaste todos os produtos, vai para o próximo ponto',
        return_to_station = 'Entregaste todos os produtos, regressa à estação',
        job_completed = 'Concluíste a tua rota'
    },
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
