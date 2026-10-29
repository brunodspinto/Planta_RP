local Translations = {
    success = {
        withdraw = 'Levantamento efetuado',
        deposit = 'Depósito efetuado',
        transfer = 'Transferência efetuada',
        account = 'Conta criada',
        rename = 'Conta renomeada',
        delete = 'Conta eliminada',
        userAdd = 'Utilizador adicionado',
        userRemove = 'Utilizador removido',
        card = 'Cartão criado',
        give = 'Deste $%s em dinheiro',
        receive = 'Recebeste $%s em dinheiro',
    },
    error = {
        error = 'Ocorreu um erro',
        access = 'Sem autorização',
        account = 'Conta não encontrada',
        accounts = 'Atingiste o número máximo de contas',
        user = 'O utilizador já foi adicionado',
        noUser = 'Utilizador não encontrado',
        money = 'Dinheiro insuficiente',
        pin = 'PIN inválido',
        card = 'Não tens nenhum cartão bancário',
        amount = 'Quantia inválida',
        toofar = 'Estás demasiado longe',
    },
    progress = {
        atm = 'A aceder ao multibanco',
    },
    target = {
        bank = 'Abrir banco',
        atm = 'Abrir multibanco',
    },
    reason = {
        external_deposit = 'Depósito externo',
        external_withdrawal = 'Levantamento externo',
        initial_deposit = 'Depósito inicial',
        initial_deposit_for = 'Depósito inicial para %{account}',
    },
    commands = {
        givecash = 'Dar dinheiro',
        player_id = 'ID do jogador',
        amount = 'Quantia',
    }
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
