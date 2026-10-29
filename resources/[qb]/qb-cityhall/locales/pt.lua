local Translations = {
    error = {
        not_in_range = 'Encontra-se muito longe da camara municipal'
    },
    success = {
        recived_license = 'Recebeu  %{value} por €50'
    },
    info = {
        new_job_app = 'A tua candidatura foi enviada ao chefe de (%{job})',
        bilp_text = 'Camâra Municipal',
        city_services_menu = 'E - Menu Serviços',
        id_card = 'Cartão do Cidadão',
        driver_license = 'Carta de Condução',
        weaponlicense = 'Licença porte de arma',
        new_job = 'Parabéns! O seu novo trabalho: (%{job})'
    },
    email = {
        jobAppSender = "%{job}",
        jobAppSub = "Obrigado pela tua candidatura a %{job}.",
        jobAppMsg = "Olá %{gender} %{lastname}<br /><br />A %{job} recebeu a tua candidatura.<br /><br />O chefe está a analisar o teu pedido e vai contactar-te para uma entrevista assim que possível.<br /><br />Mais uma vez, obrigado pela tua candidatura.",
        mr = 'Sr',
        mrs = 'Sra',
        sender = 'Serviços Municipais',
        subject = 'Solicitação de aulas de condução',
        message = 'Olá %{gender} %{lastname}<br /><br />Acabamos de receber uma mensagem de que alguém quer fazer aulas de condução<br />Se quiser fazer de instructor por favor contacte-nos:<br />Nome: <strong>%{firstname} %{lastname}</strong><br />Telemóvel: <strong>%{phone}</strong><br/><br/>Melhores Cumprimentos,<br />Serviços Municipais'
    }
}
if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
