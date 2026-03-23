QBShared = QBShared or {}
QBShared.Items = {
    -- ARMAS (WEAPONS)
    -- Melee
    weapon_unarmed                   = { name = 'weapon_unarmed', label = 'Punhos', weight = 1000, type = 'weapon', ammotype = nil, image = 'placeholder.png', unique = true, useable = false, description = 'Mãozinhas para a porrada' },
    weapon_dagger                    = { name = 'weapon_dagger', label = 'Adaga', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_dagger.png', unique = true, useable = false, description = 'Uma faca curta e pontiaguda' },
    weapon_bat                       = { name = 'weapon_bat', label = 'Taco de Basebol', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_bat.png', unique = true, useable = false, description = 'Para jogar basebol... ou partir joelhos' },
    weapon_bottle                    = { name = 'weapon_bottle', label = 'Garrafa Partida', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_bottle.png', unique = true, useable = false, description = 'Uma garrafa de vidro partida' },
    weapon_crowbar                   = { name = 'weapon_crowbar', label = 'Pé de Cabra', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_crowbar.png', unique = true, useable = false, description = 'Ferramenta de ferro para alavancar coisas' },
    weapon_flashlight                = { name = 'weapon_flashlight', label = 'Lanterna', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_flashlight.png', unique = true, useable = false, description = 'Para ver no escuro' },
    weapon_golfclub                  = { name = 'weapon_golfclub', label = 'Taco de Golfe', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_golfclub.png', unique = true, useable = false, description = 'Para os buracos do campo de golfe' },
    weapon_hammer                    = { name = 'weapon_hammer', label = 'Martelo', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_hammer.png', unique = true, useable = false, description = 'Para pregar pregos' },
    weapon_hatchet                   = { name = 'weapon_hatchet', label = 'Machadinha', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_hatchet.png', unique = true, useable = false, description = 'Pequeno machado de mão' },
    weapon_knuckle                   = { name = 'weapon_knuckle', label = 'Soco Inglês', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_knuckle.png', unique = true, useable = false, description = 'Para doer mais quando bates' },
    weapon_knife                     = { name = 'weapon_knife', label = 'Faca', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_knife.png', unique = true, useable = false, description = 'Lâmina afiada' },
    weapon_machete                   = { name = 'weapon_machete', label = 'Machete', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_machete.png', unique = true, useable = false, description = 'Para cortar mato grosso' },
    weapon_switchblade               = { name = 'weapon_switchblade', label = 'Canivete', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_switchblade.png', unique = true, useable = false, description = 'Faca de ponta e mola' },
    weapon_nightstick                = { name = 'weapon_nightstick', label = 'Cassetete', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_nightstick.png', unique = true, useable = false, description = 'Ferramenta de trabalho da polícia' },
    weapon_wrench                    = { name = 'weapon_wrench', label = 'Chave Inglesa', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_wrench.png', unique = true, useable = false, description = 'Para apertar porcas e parafusos' },
    weapon_battleaxe                 = { name = 'weapon_battleaxe', label = 'Machado de Batalha', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_battleaxe.png', unique = true, useable = false, description = 'Machado medieval' },
    weapon_poolcue                   = { name = 'weapon_poolcue', label = 'Taco de Bilhar', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_poolcue.png', unique = true, useable = false, description = 'Para jogar bilhar' },
    weapon_briefcase                 = { name = 'weapon_briefcase', label = 'Mala', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_briefcase.png', unique = true, useable = false, description = 'Mala executiva' },
    weapon_briefcase_02              = { name = 'weapon_briefcase_02', label = 'Mala de Viagem', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_briefcase2.png', unique = true, useable = false, description = 'Para umas férias em Liberty City' },
    weapon_garbagebag                = { name = 'weapon_garbagebag', label = 'Saco do Lixo', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_garbagebag.png', unique = true, useable = false, description = 'Um saco do lixo preto' },
    weapon_handcuffs                 = { name = 'weapon_handcuffs', label = 'Algemas', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_handcuffs.png', unique = true, useable = false, description = 'Para prender suspeitos' },
    weapon_bread                     = { name = 'weapon_bread', label = 'Baguete', weight = 1000, type = 'weapon', ammotype = nil, image = 'baquette.png', unique = true, useable = false, description = 'Pão rijo?' },
    weapon_stone_hatchet             = { name = 'weapon_stone_hatchet', label = 'Machado de Pedra', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_stone_hatchet.png', unique = true, useable = true, description = 'Machado primitivo' },

    -- Pistolas
    weapon_pistol                    = { name = 'weapon_pistol', label = 'Pistola', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_pistol.png', unique = true, useable = false, description = 'Walther P99' },
    weapon_pistol_mk2                = { name = 'weapon_pistol_mk2', label = 'Pistola Mk II', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_pistol_mk2.png', unique = true, useable = false, description = 'Versão melhorada da pistola' },
    weapon_combatpistol              = { name = 'weapon_combatpistol', label = 'Pistola de Combate', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_combatpistol.png', unique = true, useable = false, description = 'Pistola de combate' },
    weapon_appistol                  = { name = 'weapon_appistol', label = 'Pistola AP', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_appistol.png', unique = true, useable = false, description = 'Pistola automática' },
    weapon_stungun                   = { name = 'weapon_stungun', label = 'Taser', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_stungun.png', unique = true, useable = false, description = 'Arma de choques elétricos' },
    weapon_pistol50                  = { name = 'weapon_pistol50', label = 'Pistola .50', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_pistol50.png', unique = true, useable = false, description = 'Pistola de calibre elevado' },
    weapon_snspistol                 = { name = 'weapon_snspistol', label = 'Pistola SNS', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_snspistol.png', unique = true, useable = false, description = 'Pistola compacta' },
    weapon_heavypistol               = { name = 'weapon_heavypistol', label = 'Pistola Pesada', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_heavypistol.png', unique = true, useable = false, description = 'Pistola com poder de paragem' },
    weapon_vintagepistol             = { name = 'weapon_vintagepistol', label = 'Pistola Vintage', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_vintagepistol.png', unique = true, useable = false, description = 'Uma pistola clássica' },
    weapon_flaregun                  = { name = 'weapon_flaregun', label = 'Pistola de Sinalização', weight = 1000, type = 'weapon', ammotype = 'AMMO_FLARE', image = 'weapon_flaregun.png', unique = true, useable = false, description = 'Lança very-lights' },
    weapon_revolver                  = { name = 'weapon_revolver', label = 'Revólver', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_revolver.png', unique = true, useable = false, description = 'Revólver clássico' },
    weapon_navyrevolver              = { name = 'weapon_navyrevolver', label = 'Revólver Navy', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_navyrevolver.png', unique = true, useable = true, description = 'Revólver antigo da marinha' },

    -- SMGs
    weapon_microsmg                  = { name = 'weapon_microsmg', label = 'Micro SMG', weight = 1000, type = 'weapon', ammotype = 'AMMO_SMG', image = 'weapon_microsmg.png', unique = true, useable = false, description = 'Submetralhadora compacta' },
    weapon_smg                       = { name = 'weapon_smg', label = 'SMG', weight = 1000, type = 'weapon', ammotype = 'AMMO_SMG', image = 'weapon_smg.png', unique = true, useable = false, description = 'MP5' },
    weapon_assaultsmg                = { name = 'weapon_assaultsmg', label = 'SMG de Assalto', weight = 1000, type = 'weapon', ammotype = 'AMMO_SMG', image = 'weapon_assaultsmg.png', unique = true, useable = false, description = 'P90' },
    weapon_combatpdw                 = { name = 'weapon_combatpdw', label = 'Combat PDW', weight = 1000, type = 'weapon', ammotype = 'AMMO_SMG', image = 'weapon_combatpdw.png', unique = true, useable = false, description = 'PDW Sig Sauer' },
    weapon_machinepistol             = { name = 'weapon_machinepistol', label = 'Tec-9', weight = 1000, type = 'weapon', ammotype = 'AMMO_PISTOL', image = 'weapon_machinepistol.png', unique = true, useable = false, description = 'Tec-9 Automática' },
    weapon_minismg                   = { name = 'weapon_minismg', label = 'Mini SMG', weight = 1000, type = 'weapon', ammotype = 'AMMO_SMG', image = 'weapon_minismg.png', unique = true, useable = false, description = 'Skorpion' },

    -- Shotguns (Caçadeiras)
    weapon_pumpshotgun               = { name = 'weapon_pumpshotgun', label = 'Pump Shotgun', weight = 1000, type = 'weapon', ammotype = 'AMMO_SHOTGUN', image = 'weapon_pumpshotgun.png', unique = true, useable = false, description = 'Caçadeira de bombear' },
    weapon_sawnoffshotgun            = { name = 'weapon_sawnoffshotgun', label = 'Caçadeira de Canos Serrados', weight = 1000, type = 'weapon', ammotype = 'AMMO_SHOTGUN', image = 'weapon_sawnoffshotgun.png', unique = true, useable = false, description = 'Caçadeira curta' },
    weapon_assaultshotgun            = { name = 'weapon_assaultshotgun', label = 'Caçadeira de Assalto', weight = 1000, type = 'weapon', ammotype = 'AMMO_SHOTGUN', image = 'weapon_assaultshotgun.png', unique = true, useable = false, description = 'Caçadeira automática' },
    weapon_bullpupshotgun            = { name = 'weapon_bullpupshotgun', label = 'Bullpup Shotgun', weight = 1000, type = 'weapon', ammotype = 'AMMO_SHOTGUN', image = 'weapon_bullpupshotgun.png', unique = true, useable = false, description = 'Caçadeira compacta' },
    weapon_musket                    = { name = 'weapon_musket', label = 'Mosquete', weight = 1000, type = 'weapon', ammotype = 'AMMO_SHOTGUN', image = 'weapon_musket.png', unique = true, useable = false, description = 'Arma antiga' },
    weapon_dbshotgun                 = { name = 'weapon_dbshotgun', label = 'Caçadeira de Canos Duplos', weight = 1000, type = 'weapon', ammotype = 'AMMO_SHOTGUN', image = 'weapon_dbshotgun.png', unique = true, useable = false, description = 'Dois tiros rápidos' },
    
    -- Assault Rifles (Espingardas)
    weapon_assaultrifle              = { name = 'weapon_assaultrifle', label = 'AK-47', weight = 1000, type = 'weapon', ammotype = 'AMMO_RIFLE', image = 'weapon_assaultrifle.png', unique = true, useable = false, description = 'Espingarda de assalto clássica' },
    weapon_carbinerifle              = { name = 'weapon_carbinerifle', label = 'M4A1', weight = 1000, type = 'weapon', ammotype = 'AMMO_RIFLE', image = 'weapon_carbinerifle.png', unique = true, useable = false, description = 'Carabina automática' },
    weapon_advancedrifle             = { name = 'weapon_advancedrifle', label = 'Espingarda Avançada', weight = 1000, type = 'weapon', ammotype = 'AMMO_RIFLE', image = 'weapon_advancedrifle.png', unique = true, useable = false, description = 'Tavor TAR-21' },
    weapon_specialcarbine            = { name = 'weapon_specialcarbine', label = 'Carabina Especial', weight = 1000, type = 'weapon', ammotype = 'AMMO_RIFLE', image = 'weapon_specialcarbine.png', unique = true, useable = false, description = 'G36C' },
    weapon_bullpuprifle              = { name = 'weapon_bullpuprifle', label = 'Espingarda Bullpup', weight = 1000, type = 'weapon', ammotype = 'AMMO_RIFLE', image = 'weapon_bullpuprifle.png', unique = true, useable = false, description = 'Espingarda compacta' },
    weapon_compactrifle              = { name = 'weapon_compactrifle', label = 'Espingarda Compacta', weight = 1000, type = 'weapon', ammotype = 'AMMO_RIFLE', image = 'weapon_compactrifle.png', unique = true, useable = false, description = 'AK-74u' },

    -- Outras Armas
    weapon_gusenberg                 = { name = 'weapon_gusenberg', label = 'Thompson', weight = 1000, type = 'weapon', ammotype = 'AMMO_MG', image = 'weapon_gusenberg.png', unique = true, useable = false, description = 'Tommy Gun' },
    weapon_sniperrifle               = { name = 'weapon_sniperrifle', label = 'Sniper', weight = 1000, type = 'weapon', ammotype = 'AMMO_SNIPER', image = 'weapon_sniperrifle.png', unique = true, useable = false, description = 'Espingarda de precisão' },
    weapon_molotov                   = { name = 'weapon_molotov', label = 'Cocktail Molotov', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_molotov.png', unique = true, useable = false, description = 'Garrafa inflamável' },
    weapon_stickybomb                = { name = 'weapon_stickybomb', label = 'C4', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_stickybomb.png', unique = true, useable = false, description = 'Explosivo remoto' },
    weapon_petrolcan                 = { name = 'weapon_petrolcan', label = 'Jerrican', weight = 1000, type = 'weapon', ammotype = 'AMMO_PETROLCAN', image = 'weapon_petrolcan.png', unique = true, useable = false, description = 'Jerrican de Gasolina' },
    weapon_fireextinguisher          = { name = 'weapon_fireextinguisher', label = 'Extintor', weight = 1000, type = 'weapon', ammotype = nil, image = 'weapon_fireextinguisher.png', unique = true, useable = false, description = 'Para apagar fogos' },

    -- MUNIÇÕES (AMMO)
    pistol_ammo                      = { name = 'pistol_ammo', label = 'Munição de Pistola', weight = 200, type = 'item', image = 'pistol_ammo.png', unique = false, useable = true, shouldClose = true, description = 'Balas para Pistolas' },
    rifle_ammo                       = { name = 'rifle_ammo', label = 'Munição de Rifle', weight = 1000, type = 'item', image = 'rifle_ammo.png', unique = false, useable = true, shouldClose = true, description = 'Balas para Espingardas' },
    smg_ammo                         = { name = 'smg_ammo', label = 'Munição de SMG', weight = 500, type = 'item', image = 'smg_ammo.png', unique = false, useable = true, shouldClose = true, description = 'Balas para Submetralhadoras' },
    shotgun_ammo                     = { name = 'shotgun_ammo', label = 'Munição de Caçadeira', weight = 500, type = 'item', image = 'shotgun_ammo.png', unique = false, useable = true, shouldClose = true, description = 'Cartuchos para Caçadeiras' },
    mg_ammo                          = { name = 'mg_ammo', label = 'Munição de MG', weight = 1000, type = 'item', image = 'mg_ammo.png', unique = false, useable = true, shouldClose = true, description = 'Munição pesada' },
    snp_ammo                         = { name = 'snp_ammo', label = 'Munição de Sniper', weight = 1000, type = 'item', image = 'rifle_ammo.png', unique = false, useable = true, shouldClose = true, description = 'Balas de alto calibre' },

    -- DOCUMENTOS E CARTÕES
    id_card                          = { name = 'id_card', label = 'Cartão de Cidadão', weight = 0, type = 'item', image = 'id_card.png', unique = true, useable = true, shouldClose = false, description = 'A tua identificação pessoal' },
    driver_license                   = { name = 'driver_license', label = 'Carta de Condução', weight = 0, type = 'item', image = 'driver_license.png', unique = true, useable = true, shouldClose = false, description = 'Prova que sabes conduzir' },
    lawyerpass                       = { name = 'lawyerpass', label = 'Carteira de Advogado', weight = 0, type = 'item', image = 'lawyerpass.png', unique = true, useable = true, shouldClose = false, description = 'Identificação da Ordem dos Advogados' },
    weaponlicense                    = { name = 'weaponlicense', label = 'Porte de Arma', weight = 0, type = 'item', image = 'weapon_license.png', unique = true, useable = true, shouldClose = true, description = 'Licença de porte de arma' },
    bank_card                        = { name = 'bank_card', label = 'Cartão Multibanco', weight = 0, type = 'item', image = 'bank_card.png', unique = true, useable = true, shouldClose = true, description = 'Para levantar dinheiro no ATM' },

    -- COMIDA E BEBIDA
    tosti                            = { name = 'tosti', label = 'Tosta Mista', weight = 200, type = 'item', image = 'tosti.png', unique = false, useable = true, shouldClose = true, description = 'Uma tosta deliciosa' },
    sandwich                         = { name = 'sandwich', label = 'Sandes', weight = 200, type = 'item', image = 'sandwich.png', unique = false, useable = true, shouldClose = true, description = 'Para matar a fome' },
    water_bottle                     = { name = 'water_bottle', label = 'Garrafa de Água', weight = 500, type = 'item', image = 'water_bottle.png', unique = false, useable = true, shouldClose = true, description = 'Hidrata-te!' },
    coffee                           = { name = 'coffee', label = 'Café', weight = 200, type = 'item', image = 'coffee.png', unique = false, useable = true, shouldClose = true, description = 'Cafeína para acordar' },
    kurkakola                        = { name = 'kurkakola', label = 'Cola', weight = 500, type = 'item', image = 'cola.png', unique = false, useable = true, shouldClose = true, description = 'Refrigerante fresco' },
    beer                             = { name = 'beer', label = 'Cerveja', weight = 500, type = 'item', image = 'beer.png', unique = false, useable = true, shouldClose = true, description = 'Uma mini fresquinha' },
    whiskey                          = { name = 'whiskey', label = 'Whiskey', weight = 500, type = 'item', image = 'whiskey.png', unique = false, useable = true, shouldClose = true, description = 'Bebida forte' },
    vodka                            = { name = 'vodka', label = 'Vodka', weight = 500, type = 'item', image = 'vodka.png', unique = false, useable = true, shouldClose = true, description = 'Diretamente da Rússia' },
    wine                             = { name = 'wine', label = 'Vinho', weight = 300, type = 'item', image = 'wine.png', unique = false, useable = true, shouldClose = false, description = 'Um bom vinho tinto' },

    -- DROGAS
    joint                            = { name = 'joint', label = 'Ganza', weight = 0, type = 'item', image = 'joint.png', unique = false, useable = true, shouldClose = true, description = 'Para relaxar' },
    cokebaggy                        = { name = 'cokebaggy', label = 'Saco de Coca', weight = 0, type = 'item', image = 'cocaine_baggy.png', unique = false, useable = true, shouldClose = true, description = 'Pó branco' },
    crack_baggy                      = { name = 'crack_baggy', label = 'Saco de Crack', weight = 0, type = 'item', image = 'crack_baggy.png', unique = false, useable = true, shouldClose = true, description = 'Cristais duvidosos' },
    xtcbaggy                         = { name = 'xtcbaggy', label = 'Saco de XTC', weight = 0, type = 'item', image = 'xtc_baggy.png', unique = false, useable = true, shouldClose = true, description = 'Pastilhas da felicidade' },
    meth                             = { name = 'meth', label = 'Metanfetamina', weight = 100, type = 'item', image = 'meth_baggy.png', unique = false, useable = true, shouldClose = true, description = 'Cristais azuis' },
    rolling_paper                    = { name = 'rolling_paper', label = 'Mortalhas', weight = 0, type = 'item', image = 'rolling_paper.png', unique = false, useable = false, shouldClose = true, description = 'Papel para enrolar' },
    weed_nutrition                   = { name = 'weed_nutrition', label = 'Fertilizante', weight = 2000, type = 'item', image = 'weed_nutrition.png', unique = false, useable = true, shouldClose = true, description = 'Para as plantas crescerem fortes' },

    -- MATERIAIS DE CRAFT
    plastic                          = { name = 'plastic', label = 'Plástico', weight = 100, type = 'item', image = 'plastic.png', unique = false, useable = false, shouldClose = false, description = 'Material reciclável' },
    metalscrap                       = { name = 'metalscrap', label = 'Sucata de Metal', weight = 100, type = 'item', image = 'metalscrap.png', unique = false, useable = false, shouldClose = false, description = 'Pedaços de metal velho' },
    copper                           = { name = 'copper', label = 'Cobre', weight = 100, type = 'item', image = 'copper.png', unique = false, useable = false, shouldClose = false, description = 'Fios de cobre' },
    aluminum                         = { name = 'aluminum', label = 'Alumínio', weight = 100, type = 'item', image = 'aluminum.png', unique = false, useable = false, shouldClose = false, description = 'Metal leve' },
    iron                             = { name = 'iron', label = 'Ferro', weight = 100, type = 'item', image = 'iron.png', unique = false, useable = false, shouldClose = false, description = 'Metal pesado' },
    steel                            = { name = 'steel', label = 'Aço', weight = 100, type = 'item', image = 'steel.png', unique = false, useable = false, shouldClose = false, description = 'Liga metálica forte' },
    glass                            = { name = 'glass', label = 'Vidro', weight = 100, type = 'item', image = 'glass.png', unique = false, useable = false, shouldClose = false, description = 'Cuidado que corta' },
    rubber                           = { name = 'rubber', label = 'Borracha', weight = 100, type = 'item', image = 'rubber.png', unique = false, useable = false, shouldClose = false, description = 'Material elástico' },

    -- FERRAMENTAS GERAIS
    lockpick                         = { name = 'lockpick', label = 'Gazua', weight = 300, type = 'item', image = 'lockpick.png', unique = false, useable = true, shouldClose = true, description = 'Para abrir fechaduras simples' },
    advancedlockpick                 = { name = 'advancedlockpick', label = 'Gazua Avançada', weight = 500, type = 'item', image = 'advancedlockpick.png', unique = false, useable = true, shouldClose = true, description = 'Para fechaduras mais complexas' },
    screwdriverset                   = { name = 'screwdriverset', label = 'Kit de Chaves', weight = 1000, type = 'item', image = 'screwdriverset.png', unique = false, useable = false, shouldClose = false, description = 'Chaves de fendas e estrelas' },
    drill                            = { name = 'drill', label = 'Berbequim', weight = 20000, type = 'item', image = 'drill.png', unique = false, useable = false, shouldClose = false, description = 'Para furar cofres' },
    thermite                         = { name = 'thermite', label = 'Termite', weight = 1000, type = 'item', image = 'thermite.png', unique = false, useable = true, shouldClose = true, description = 'Derrete metal num instante' },
    electronickit                    = { name = 'electronickit', label = 'Kit Eletrónico', weight = 100, type = 'item', image = 'electronickit.png', unique = false, useable = true, shouldClose = true, description = 'Componentes eletrónicos diversos' },

    -- FERRAMENTAS DE MECÂNICO (IMPORTANTE PARA OS JOBS)
    nitrous                          = { name = 'nitrous', label = 'Garrafa de Nitro', weight = 1000, type = 'item', image = 'nitrous.png', unique = false, useable = true, shouldClose = true, description = 'Gás para dar velocidade extra' },
    repairkit                        = { name = 'repairkit', label = 'Caixa de Ferramentas', weight = 2500, type = 'item', image = 'repairkit.png', unique = false, useable = true, shouldClose = true, description = 'Ferramentas básicas para reparações' },
    advancedrepairkit                = { name = 'advancedrepairkit', label = 'Caixa de Ferramentas Pro', weight = 4000, type = 'item', image = 'advancedkit.png', unique = false, useable = true, shouldClose = true, description = 'Ferramentas avançadas para reparações completas' },
    cleaningkit                      = { name = 'cleaningkit', label = 'Kit de Limpeza', weight = 250, type = 'item', image = 'cleaningkit.png', unique = false, useable = true, shouldClose = true, description = 'Pano e cera para limpar o carro' },
    -- ITEM IMPORTANTE PARA O JOB "TUNERS"
    tunerlaptop                      = { name = 'tunerlaptop', label = 'Portátil de Repros', weight = 2000, type = 'item', image = 'tunerchip.png', unique = true, useable = true, shouldClose = true, description = 'Portátil com software para alterar a centralina e performance do carro.' },
    
    harness                          = { name = 'harness', label = 'Cintos de Corrida', weight = 1000, type = 'item', image = 'harness.png', unique = true, useable = true, shouldClose = true, description = 'Arnês de segurança para não voares pelo vidro' },
    jerry_can                        = { name = 'jerry_can', label = 'Jerrican 20L', weight = 20000, type = 'item', image = 'jerry_can.png', unique = false, useable = true, shouldClose = true, description = 'Combustível de reserva' },
    tirerepairkit                    = { name = 'tirerepairkit', label = 'Kit Repara Pneus', weight = 1000, type = 'item', image = 'tirerepairkit.png', unique = false, useable = true, shouldClose = true, description = 'Para remendar furos' },
    
    -- PEÇAS DE VEÍCULO
    veh_toolbox                      = { name = 'veh_toolbox', label = 'Caixa de Diagnóstico', weight = 1000, type = 'item', image = 'veh_toolbox.png', unique = false, useable = true, shouldClose = true, description = 'Para verificar o estado do veículo' },
    veh_armor                        = { name = 'veh_armor', label = 'Blindagem', weight = 1000, type = 'item', image = 'veh_armor.png', unique = false, useable = true, shouldClose = true, description = 'Reforço de chassi' },
    veh_brakes                       = { name = 'veh_brakes', label = 'Travões Desportivos', weight = 1000, type = 'item', image = 'veh_brakes.png', unique = false, useable = true, shouldClose = true, description = 'Melhora a travagem' },
    veh_engine                       = { name = 'veh_engine', label = 'Bloco de Motor', weight = 1000, type = 'item', image = 'veh_engine.png', unique = false, useable = true, shouldClose = true, description = 'Aumenta a potência do motor' },
    veh_suspension                   = { name = 'veh_suspension', label = 'Suspensão', weight = 1000, type = 'item', image = 'veh_suspension.png', unique = false, useable = true, shouldClose = true, description = 'Melhora a estabilidade' },
    veh_transmission                 = { name = 'veh_transmission', label = 'Transmissão', weight = 1000, type = 'item', image = 'veh_transmission.png', unique = false, useable = true, shouldClose = true, description = 'Caixa de velocidades desportiva' },
    veh_turbo                        = { name = 'veh_turbo', label = 'Turbo', weight = 1000, type = 'item', image = 'veh_turbo.png', unique = false, useable = true, shouldClose = true, description = 'Stututu!' },
    veh_wheels                       = { name = 'veh_wheels', label = 'Pneus de Corrida', weight = 1000, type = 'item', image = 'veh_wheels.png', unique = false, useable = true, shouldClose = true, description = 'Melhor aderência' },
    veh_tint                         = { name = 'veh_tint', label = 'Películas', weight = 1000, type = 'item', image = 'veh_tint.png', unique = false, useable = true, shouldClose = true, description = 'Vidros fumados' },
    veh_plates                       = { name = 'veh_plates', label = 'Matrículas', weight = 1000, type = 'item', image = 'veh_plates.png', unique = false, useable = true, shouldClose = true, description = 'Matrículas personalizadas' },
    
    -- NOVOS ITENS DE ESTÉTICA ADICIONADOS
    veh_interior                     = { name = 'veh_interior', label = 'Decoração Interior', weight = 1000, type = 'item', image = 'veh_interior.png', unique = false, useable = true, shouldClose = true, description = 'Peças para modificar o interior' },
    veh_exterior                     = { name = 'veh_exterior', label = 'Kit de Carroçaria', weight = 1000, type = 'item', image = 'veh_exterior.png', unique = false, useable = true, shouldClose = true, description = 'Peças para modificar o exterior' },
    veh_neons                        = { name = 'veh_neons', label = 'Kit de Néons', weight = 1000, type = 'item', image = 'veh_neons.png', unique = false, useable = true, shouldClose = true, description = 'Iluminação néon para o carro' },
    veh_xenons                       = { name = 'veh_xenons', label = 'Luzes Xénon', weight = 1000, type = 'item', image = 'veh_xenons.png', unique = false, useable = true, shouldClose = true, description = 'Faróis de alta intensidade' },

    -- MEDICINA
    firstaid                         = { name = 'firstaid', label = 'Primeiros Socorros', weight = 2500, type = 'item', image = 'firstaid.png', unique = false, useable = true, shouldClose = true, description = 'Para reanimar pessoas' },
    bandage                          = { name = 'bandage', label = 'Ligadura', weight = 0, type = 'item', image = 'bandage.png', unique = false, useable = true, shouldClose = true, description = 'Para estancar sangramentos leves' },
    painkillers                      = { name = 'painkillers', label = 'Analgésicos', weight = 0, type = 'item', image = 'painkillers.png', unique = false, useable = true, shouldClose = true, description = 'Para aliviar a dor' },

    -- COMUNICAÇÃO
    phone                            = { name = 'phone', label = 'Telemóvel', weight = 700, type = 'item', image = 'phone.png', unique = true, useable = false, shouldClose = false, description = 'Smartphone' },
    radio                            = { name = 'radio', label = 'Rádio', weight = 2000, type = 'item', image = 'radio.png', unique = true, useable = true, shouldClose = true, description = 'Para comunicar em frequências' },
    laptop                           = { name = 'laptop', label = 'Portátil', weight = 4000, type = 'item', image = 'laptop.png', unique = false, useable = false, shouldClose = true, description = 'Computador portátil' },
    tablet                           = { name = 'tablet', label = 'Tablet', weight = 2000, type = 'item', image = 'tablet.png', unique = false, useable = false, shouldClose = true, description = 'Tablet' },

    -- ROUPAS E ACESSÓRIOS
    rolex                            = { name = 'rolex', label = 'Relógio de Ouro', weight = 1500, type = 'item', image = 'rolex.png', unique = false, useable = false, shouldClose = true, description = 'Relógio valioso' },
    goldchain                        = { name = 'goldchain', label = 'Fio de Ouro', weight = 1500, type = 'item', image = 'goldchain.png', unique = false, useable = false, shouldClose = true, description = 'Fio valioso' },
    diamond                          = { name = 'diamond', label = 'Diamante', weight = 1000, type = 'item', image = 'diamond.png', unique = false, useable = false, shouldClose = true, description = 'Pedra preciosa' },

    -- POLÍCIA
    armor                            = { name = 'armor', label = 'Colete Kevlar', weight = 5000, type = 'item', image = 'armor.png', unique = false, useable = true, shouldClose = true, description = 'Colete à prova de bala' },
    handcuffs                        = { name = 'handcuffs', label = 'Algemas de Polícia', weight = 100, type = 'item', image = 'handcuffs.png', unique = false, useable = true, shouldClose = true, description = 'Algemas oficiais' },
    police_stormram                  = { name = 'police_stormram', label = 'Aríete', weight = 18000, type = 'item', image = 'police_stormram.png', unique = false, useable = true, shouldClose = true, description = 'Para arrombar portas' },
    filled_evidence_bag              = { name = 'filled_evidence_bag', label = 'Saco de Provas', weight = 200, type = 'item', image = 'evidence.png', unique = true, useable = false, shouldClose = false, description = 'Provas recolhidas' },

    -- OUTROS
    parachute                        = { name = 'parachute', label = 'Paraquedas', weight = 30000, type = 'item', image = 'parachute.png', unique = true, useable = true, shouldClose = true, description = 'Se caíres do céu...' },
    binoculars                       = { name = 'binoculars', label = 'Binóculos', weight = 600, type = 'item', image = 'binoculars.png', unique = false, useable = true, shouldClose = true, description = 'Para ver ao longe' },
    lighter                          = { name = 'lighter', label = 'Isqueiro', weight = 0, type = 'item', image = 'lighter.png', unique = false, useable = false, shouldClose = true, description = 'Para acender cigarros' },
    item_bench                       = { name = "item_bench", label = "Bancada de Trabalho", weight = 15000, type = "item", image = "workbench.png", unique = true, useable = true, shouldClose = false, combinable = nil, description = "Mesa para construir itens."},
    attachment_bench                 = { name = "attachment_bench", label = "Bancada de Armas", weight = 15000, type = "item", image = "attworkbench.png", unique = true, useable = true, shouldClose = false, combinable = nil, description = "Mesa para modificar armas."},

    -- Item para o qb-crypto
    ['cryptostick'] = { 
        name = 'cryptostick', 
        label = 'Crypto Stick', 
        weight = 100, 
        type = 'item', 
        image = 'cryptostick.png', 
        unique = false, 
        useable = true, 
        shouldClose = true, 
        description = 'Uma pen USB para transações de criptomoedas.' 
    },

    -- Item para o qb-prison
    ['gatecrack'] = { 
        name = 'gatecrack', 
        label = 'Gate Crack', 
        weight = 500, 
        type = 'item', 
        image = 'gatecrack.png', 
        unique = true, 
        useable = true, 
        shouldClose = true, 
        description = 'Dispositivo eletrónico para forçar portões.' 
    },

    -- Itens adicionais de gameplay/lojas
    heavyarmor                       = { name = 'heavyarmor', label = 'Colete Pesado', weight = 6000, type = 'item', image = 'heavyarmor.png', unique = false, useable = true, shouldClose = true, description = 'Colete pesado para máxima proteção' },
    oxy                              = { name = 'oxy', label = 'Oxicodona', weight = 100, type = 'item', image = 'oxy.png', unique = false, useable = true, shouldClose = true, description = 'Comprimidos para reduzir dor e stress' },
    diving_gear                      = { name = 'diving_gear', label = 'Equipamento de Mergulho', weight = 30000, type = 'item', image = 'diving_gear.png', unique = true, useable = true, shouldClose = true, description = 'Conjunto de mergulho com tanque de ar' },
    diving_fill                      = { name = 'diving_fill', label = 'Recarga de Oxigénio', weight = 2000, type = 'item', image = 'diving_fill.png', unique = false, useable = true, shouldClose = true, description = 'Recarga para equipamento de mergulho' },
    fitbit                           = { name = 'fitbit', label = 'Pulseira Fitness', weight = 500, type = 'item', image = 'fitbit.png', unique = true, useable = false, shouldClose = false, description = 'Pulseira para monitorizar dados de saúde' },
    radioscanner                     = { name = 'radioscanner', label = 'Scanner de Rádio', weight = 1000, type = 'item', image = 'radioscanner.png', unique = false, useable = false, shouldClose = true, description = 'Dispositivo para captar frequências de rádio' },
    security_card_01                 = { name = 'security_card_01', label = 'Cartão de Segurança A', weight = 100, type = 'item', image = 'security_card_01.png', unique = false, useable = true, shouldClose = true, description = 'Cartão de acesso de baixo nível' },
    security_card_02                 = { name = 'security_card_02', label = 'Cartão de Segurança B', weight = 100, type = 'item', image = 'security_card_02.png', unique = false, useable = true, shouldClose = true, description = 'Cartão de acesso de alto nível' },
    trojan_usb                       = { name = 'trojan_usb', label = 'Pen USB Trojan', weight = 100, type = 'item', image = 'trojan_usb.png', unique = false, useable = false, shouldClose = true, description = 'USB preparado para invasão de sistemas' },
    markedbills                      = { name = 'markedbills', label = 'Notas Marcadas', weight = 1000, type = 'item', image = 'markedbills.png', unique = true, useable = false, shouldClose = true, description = 'Dinheiro sujo que precisa de lavagem' },
    empty_evidence_bag               = { name = 'empty_evidence_bag', label = 'Saco de Provas (Vazio)', weight = 100, type = 'item', image = 'evidence.png', unique = false, useable = false, shouldClose = true, description = 'Saco vazio para recolha de provas' },
    empty_weed_bag                   = { name = 'empty_weed_bag', label = 'Saqueta Vazia', weight = 0, type = 'item', image = 'empty_weed_bag.png', unique = false, useable = false, shouldClose = true, description = 'Saqueta para embalar erva' },
    firework1                        = { name = 'firework1', label = 'Fogo de Artifício Tipo 1', weight = 1000, type = 'item', image = 'firework1.png', unique = false, useable = true, shouldClose = true, description = 'Foguete de celebração' },
    firework2                        = { name = 'firework2', label = 'Fogo de Artifício Tipo 2', weight = 1000, type = 'item', image = 'firework2.png', unique = false, useable = true, shouldClose = true, description = 'Foguete de celebração' },
    firework3                        = { name = 'firework3', label = 'Fogo de Artifício Tipo 3', weight = 1000, type = 'item', image = 'firework3.png', unique = false, useable = true, shouldClose = true, description = 'Foguete de celebração' },
    firework4                        = { name = 'firework4', label = 'Fogo de Artifício Tipo 4', weight = 1000, type = 'item', image = 'firework4.png', unique = false, useable = true, shouldClose = true, description = 'Foguete de celebração' },
    snikkel_candy                    = { name = 'snikkel_candy', label = 'Snikkel Candy', weight = 100, type = 'item', image = 'snikkel_candy.png', unique = false, useable = true, shouldClose = true, description = 'Doce energético' },
    twerks_candy                     = { name = 'twerks_candy', label = 'Twerks Candy', weight = 100, type = 'item', image = 'twerks_candy.png', unique = false, useable = true, shouldClose = true, description = 'Doce energético' },
    weed_brick                       = { name = 'weed_brick', label = 'Tijolo de Erva', weight = 4000, type = 'item', image = 'weed_brick.png', unique = false, useable = false, shouldClose = true, description = 'Grande quantidade de cannabis prensada' },
    weed_whitewidow                  = { name = 'weed_whitewidow', label = 'White Widow', weight = 100, type = 'item', image = 'weed_whitewidow.png', unique = false, useable = false, shouldClose = true, description = 'Variedade de cannabis White Widow' },
    weed_ogkush                      = { name = 'weed_ogkush', label = 'OG Kush', weight = 100, type = 'item', image = 'weed_ogkush.png', unique = false, useable = false, shouldClose = true, description = 'Variedade de cannabis OG Kush' },
    weed_skunk                       = { name = 'weed_skunk', label = 'Skunk', weight = 100, type = 'item', image = 'weed_skunk.png', unique = false, useable = false, shouldClose = true, description = 'Variedade de cannabis Skunk' },
    weed_amnesia                     = { name = 'weed_amnesia', label = 'Amnesia', weight = 100, type = 'item', image = 'weed_amnesia.png', unique = false, useable = false, shouldClose = true, description = 'Variedade de cannabis Amnesia' },
    weed_purplehaze                  = { name = 'weed_purplehaze', label = 'Purple Haze', weight = 100, type = 'item', image = 'weed_purplehaze.png', unique = false, useable = false, shouldClose = true, description = 'Variedade de cannabis Purple Haze' },
    weed_ak47                        = { name = 'weed_ak47', label = 'AK-47 (Erva)', weight = 100, type = 'item', image = 'weed_ak47.png', unique = false, useable = false, shouldClose = true, description = 'Variedade de cannabis AK-47' },
    coke_brick                       = { name = 'coke_brick', label = 'Tijolo de Cocaína', weight = 5000, type = 'item', image = 'coke_brick.png', unique = false, useable = false, shouldClose = true, description = 'Grande quantidade de cocaína prensada' },
    coke_small_brick                 = { name = 'coke_small_brick', label = 'Tijolo Pequeno de Cocaína', weight = 2500, type = 'item', image = 'coke_small_brick.png', unique = false, useable = false, shouldClose = true, description = 'Quantidade média de cocaína prensada' },
}