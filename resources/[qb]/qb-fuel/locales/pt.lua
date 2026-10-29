local Translations = {
    progress = {
        refueling = 'A abastecer...',
    },
    success = {
        refueled = 'Veículo abastecido',
    },
    error = {
        no_money = 'Não tens dinheiro suficiente',
        no_vehicle = 'Nenhum veículo por perto',
        no_vehicles = 'Não há veículos por perto',
        no_jerrycan = 'Não tens um jerrican',
        vehicle_full = 'O depósito do veículo já está cheio',
        no_fuel_can = 'O jerrican está vazio',
        no_nozzle = 'Não há nenhum veículo por perto com a mangueira ligada',
        too_far = 'Afastaste-te demasiado da bomba, a mangueira foi devolvida',
        wrong_side = 'O depósito do veículo está do outro lado',
    },
    target = {
        put_fuel = 'Abastecer',
        get_nozzle = 'Pegar na mangueira',
        buy_jerrycan = 'Comprar jerrican $%{price}',
        refill_jerrycan = 'Encher jerrican $%{price}',
        refill_fuel = 'Abastecer',
        nozzle_put = 'Ligar a mangueira',
        nozzle_remove = 'Tirar a mangueira',
        return_nozzle = 'Devolver a mangueira',
    }
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
