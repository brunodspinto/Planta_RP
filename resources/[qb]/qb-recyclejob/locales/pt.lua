local Translations = {
    success = {
        you_have_been_clocked_in = "Entraste ao serviço",
        sold = 'Vendeste %{amount} %{item} por $%{price}',
    },
    text = {
        point_enter_warehouse = "[E] Entrar no armazém",
        enter_warehouse = "Entrar no armazém",
        exit_warehouse = "Sair do armazém",
        point_exit_warehouse = "[E] Sair do armazém",
        toggle_duty = "Alternar turno",
        point_toggle_duty = "[E] Alternar turno",
        hand_in_package = "Entregar pacote",
        point_hand_in_package = "[E] Entregar pacote",
        get_package = "Recolher pacote",
        point_get_package = "[E] Recolher pacote",
        picking_up_the_package = "A recolher o pacote",
        unpacking_the_package = "A desembalar o pacote",
        clock_in = "Entraste ao serviço",
        clock_out = "Saíste de serviço",
        sell_materials = "Vender materiais",
        point_sell_materials = "[E] Vender materiais",
        price = "Preço: $%{price}",
        amount = "Quantidade",
        sell = "Vender",
    },
    error = {
        you_have_clocked_out = "Saíste de serviço",
        nothing_to_sell = "Não tens nada para vender",
        out_of_stock = "%{item} está sem stock",
        too_far_to_sell = "Estás demasiado longe para vender",
    },
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end