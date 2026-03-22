local Translations = {
    notify = {
        ["hud_settings_loaded"] = "Definições do HUD carregadas!",
        ["hud_restart"] = "O HUD está a reiniciar!",
        ["hud_start"] = "O HUD foi iniciado!",
        ["hud_command_info"] = "Este comando redefine as definições do HUD!",
        ["load_square_map"] = "A carregar mapa quadrado...",
        ["loaded_square_map"] = "Mapa quadrado carregado!",
        ["load_circle_map"] = "A carregar mapa redondo...",
        ["loaded_circle_map"] = "Mapa redondo carregado!",
        ["cinematic_on"] = "Modo cinemático ativado!",
        ["cinematic_off"] = "Modo cinemático desativado!",
        ["engine_on"] = "Motor ligado!",
        ["engine_off"] = "Motor desligado!",
        ["low_fuel"] = "Nível de combustível baixo!",
        ["access_denied"] = "Não estás autorizado!",
        ["stress_gain"] = "Estou a sentir-me mais stressado(a)!",
        ["stress_removed"] = "Estou a sentir-me mais calmo(a)!"
    }
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
