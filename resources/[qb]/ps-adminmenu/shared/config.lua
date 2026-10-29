Config = Config or {}

Config.Fuel = "LegacyFuel"        -- "ps-fuel", "LegacyFuel", "ox_fuel"
Config.ResourcePerms = 'admin' -- permission to control resource(start stop restart)
Config.ShowCommandsPerms = 'admin' -- permission to show all commands
Config.RenewedPhone = false    -- if you use qb-phone from renewed. (multijob)

-- Key Bindings
Config.Keybindings = true
Config.AdminKey = "PageDown"
Config.NoclipKey = "PageUp"

-- Give Car
Config.DefaultGarage = "Alta Garage"

Config.Actions = {
    ["admin_car"] = {
        label = "Carro de admin",
        type = "client",
        event = "ps-adminmenu:client:Admincar",
        perms = "mod",
    },

    ["ban_player"] = {
        label = "Banir jogador",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador", option = "dropdown", data = "players" },
            { id = "Reason", label = "Motivo", option = "text" },
            {
                id = "Duration", label = "Duração",
                option = "dropdown",
                data = {
                    { label = "Permanente",  value = "2147483647" },
                    { label = "10 minutos", value = "600" },
                    { label = "30 minutos", value = "1800" },
                    { label = "1 hora",     value = "3600" },
                    { label = "6 horas",    value = "21600" },
                    { label = "12 horas",   value = "43200" },
                    { label = "1 dia",      value = "86400" },
                    { label = "3 dias",     value = "259200" },
                    { label = "1 semana",     value = "604800" },
                    { label = "3 semanas",     value = "1814400" },
                },
            },
            { label = "Confirmar", option = "button", type = "server", event = "ps-adminmenu:server:BanPlayer" },
        },
    },

    ["bring_player"] = {
        label = "Trazer jogador",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:BringPlayer" },
        },
    },

    ["change_weather"] = {
        label = "Mudar o tempo",
        perms = "mod",
        dropdown = {
            {
                id = "Weather", label = "Tempo",
                option = "dropdown",
                data = {
                    { label = "Muito sol", value = "Extrasunny" },
                    { label = "Limpo",      value = "Clear" },
                    { label = "Neutro",    value = "Neutral" },
                    { label = "Smog",       value = "Smog" },
                    { label = "Nevoeiro",      value = "Foggy" },
                    { label = "Encoberto",   value = "Overcast" },
                    { label = "Nuvens",     value = "Clouds" },
                    { label = "A limpar",   value = "Clearing" },
                    { label = "Chuva",       value = "Rain" },
                    { label = "Trovoada",    value = "Thunder" },
                    { label = "Neve",       value = "Snow" },
                    { label = "Nevão",   value = "Blizzard" },
                    { label = "Neve fraca",  value = "Snowlight" },
                    { label = "Natal",       value = "Xmas" },
                    { label = "Halloween",  value = "Halloween" },
                },
            },
            { label = "Confirmar", option = "button", type = "client", event = "ps-adminmenu:client:ChangeWeather" },
        },
    },

    ["change_time"] = {
        label = "Mudar a hora",
        perms = "mod",
        dropdown = {
            {
                id = "Time Events", label = "Hora do dia",
                option = "dropdown",
                data = {
                    { label = "Nascer do sol", value = "06" },
                    { label = "Manhã", value = "09" },
                    { label = "Meio-dia",    value = "12" },
                    { label = "Pôr do sol",  value = "21" },
                    { label = "Fim de tarde", value = "22" },
                    { label = "Noite",   value = "24" },
                },
            },
            { label = "Confirmar", option = "button", type = "client", event = "ps-adminmenu:client:ChangeTime" },
        },
    },

    ["change_plate"] = {
        label = "Mudar matrícula",
        perms = "mod",
        dropdown = {
            { id = "Plate", label = "Matrícula",   option = "text" },
            { label = "Confirmar", option = "button", type = "client", event = "ps-adminmenu:client:ChangePlate" },
        },
    },

    ["clear_inventory"] = {
        label = "Limpar inventário",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:ClearInventory" },
        },
    },

    ["clear_inventory_offline"] = {
        label = "Limpar inventário (offline)",
        perms = "mod",
        dropdown = {
            { id = "Citizen ID", label = "ID de cidadão", option = "text",   data = "players" },
            { label = "Confirmar",    option = "button", type = "server", event = "ps-adminmenu:server:ClearInventoryOffline" },
        },
    },

    ["clothing_menu"] = {
        label = "Dar menu de roupa",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:ClothingMenu" },
        },
    },

    ["set_ped"] = {
        label = "Definir ped",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",     option = "dropdown", data = "players" },
            { id = "Ped Models", label = "Modelos de ped", option = "dropdown", data = "pedlist" },
            { label = "Confirmar",    option = "button",   type = "server", event = "ps-adminmenu:server:setPed" },
        },
    },

    ["copy_coords"] = {
        label = "Copiar coordenadas",
        perms = "mod",
        dropdown = {
            {
                id = "Copy Coords", label = "Copiar coordenadas",
                option = "dropdown",
                data = {
                    { label = "Copiar vector2", value = "vector2" },
                    { label = "Copiar vector3", value = "vector3" },
                    { label = "Copiar vector4",    value = "vector4" },
                    { label = "Copiar direção",  value = "heading" },
                },
            },
            { label = "Copiar", option = "button", type = "client", event = "ps-adminmenu:client:copyToClipboard"},
        },
    },

    ["delete_vehicle"] = {
        label = "Apagar veículo",
        type = "command",
        event = "dv",
        perms = "mod",
    },

    ["freeze_player"] = {
        label = "Congelar jogador",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:FreezePlayer" },
        },
    },

    ["drunk_player"] = {
        label = "Embebedar jogador",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:DrunkPlayer" },
        },
    },

    ["remove_stress"] = {
        label = "Remover stress",
        perms = "mod",
        dropdown = {
            { id = "Player (Optional)", label = "Jogador (opcional)", option = "dropdown", data = "players" },
            { label = "Confirmar",           option = "button",   type = "server", event = "ps-adminmenu:server:RemoveStress" },
        },
    },

    ["set_ammo"] = {
        label = "Definir munições",
        perms = "admin",
        dropdown = {
            { id = "Ammo Amount", label = "Quantidade de munições", option = "text" },
            { label = "Confirmar",      option = "button", type = "client", event = "ps-adminmenu:client:SetAmmo" },
        },
    },

    -- ["nui_focus"] = {
    --     label = "Dar foco NUI",
    --     perms = "mod",
    --     dropdown = {
    --         { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
    --         { label = "Confirmar", option = "button",   type = "client", event = "" },
    --     },
    -- },

    ["god_mode"] = {
        label = "Modo deus",
        type = "client",
        event = "ps-adminmenu:client:ToggleGodmode",
        perms = "mod",
    },

    ["give_car"] = {
        label = "Dar carro",
        perms = "admin",
        dropdown = {
            { id = "Vehicle", label = "Veículo",           option = "dropdown", data = "vehicles" },
            { id = "Player", label = "Jogador",            option = "dropdown", data = "players" },
            { id = "Plate (Optional)", label = "Matrícula (opcional)",  option = "text" },
            { id = "Garage (Optional)", label = "Garagem (opcional)", option = "text" },
            { label = "Confirmar",           option = "button",   type = "server",  event = "ps-adminmenu:server:givecar" },
        }
    },

    ["invisible"] = {
        label = "Invisível",
        type = "client",
        event = "ps-adminmenu:client:ToggleInvisible",
        perms = "mod",
    },

    ["blackout"] = {
        label = "Ligar/desligar apagão",
        type = "server",
        event = "ps-adminmenu:server:ToggleBlackout",
        perms = "mod",
    },

    ["toggle_duty"] = {
        label = "Entrar/sair de serviço",
        type = "server",
        event = "QBCore:ToggleDuty",
        perms = "mod",
    },

    ["toggle_laser"] = {
        label = "Ligar/desligar laser",
        type = "client",
        event = "ps-adminmenu:client:ToggleLaser",
        perms = "mod",
    },

    ["set_perms"] = {
        label = "Definir permissões",
        perms = "admin",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            {
                id = "Permissions", label = "Permissões",
                option = "dropdown",
                data = {
                    { label = "Mod",   value = "mod" },
                    { label = "Admin", value = "admin" },
                    { label = "God",   value = "god" },
                },
            },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:SetPerms" },
        },
    },

    ["set_bucket"] = {
        label = "Definir dimensão",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { id = "Bucket", label = "Dimensão",  option = "text" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:SetBucket" },
        },
    },

    ["get_bucket"] = {
        label = "Ver dimensão",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:GetBucket" },
        },
    },

    ["mute_player"] = {
        label = "Silenciar jogador",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "client", event = "ps-adminmenu:client:MutePlayer" },
        },
    },

    ["noclip"] = {
        label = "NoClip",
        type = "client",
        event = "ps-adminmenu:client:ToggleNoClip",
        perms = "mod",
    },

    ["open_inventory"] = {
        label = "Abrir inventário",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "client", event = "ps-adminmenu:client:openInventory" },
        },
    },

    ["open_stash"] = {
        label = "Abrir armazém",
        perms = "mod",
        dropdown = {
            { id = "Stash", label = "Armazém",   option = "text" },
            { label = "Confirmar", option = "button", type = "client", event = "ps-adminmenu:client:openStash" },
        },
    },

    ["open_trunk"] = {
        label = "Abrir mala",
        perms = "mod",
        dropdown = {
            { id = "Plate", label = "Matrícula",   option = "text" },
            { label = "Confirmar", option = "button", type = "client", event = "ps-adminmenu:client:openTrunk" },
        },
    },

    ["change_vehicle_state"] = {
        label = "Estado do veículo na garagem",
        perms = "mod",
        dropdown = {
            { id = "Plate", label = "Matrícula",   option = "text" },
            {
                id = "State", label = "Estado",
                option = "dropdown",
                data = {
                    { label = "Na garagem",  value = "1" },
                    { label = "Fora", value = "0" },
                },
            },
            { label = "Confirmar", option = "button", type = "server", event = "ps-adminmenu:server:SetVehicleState" },
        },
    },

    ["revive_all"] = {
        label = "Reanimar todos",
        type = "server",
        event = "ps-adminmenu:server:ReviveAll",
        perms = "mod",
    },

    ["revive_player"] = {
        label = "Reanimar jogador",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:Revive" },
        },
    },

    ["revive_radius"] = {
        label = "Reanimar na área",
        type = "server",
        event = "ps-adminmenu:server:ReviveRadius",
        perms = "mod",
    },

    ["refuel_vehicle"] = {
        label = "Abastecer veículo",
        type = "client",
        event = "ps-adminmenu:client:RefuelVehicle",
        perms = "mod",
    },

    ["set_job"] = {
        label = "Definir emprego",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { id = "Job", label = "Emprego",     option = "dropdown", data = "jobs" },
            { id = "Grade", label = "Cargo",   option = "text",     data = "grades" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:SetJob" },
        },
    },

    ["set_gang"] = {
        label = "Definir gang",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { id = "Gang", label = "Gang",    option = "dropdown", data = "gangs" },
            { id = "Grade", label = "Cargo",   option = "text",     data = "grades" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:SetGang" },
        },
    },

    ["give_money"] = {
        label = "Dar dinheiro",
        perms = "admin",
        dropdown = {
            { id = "Player", label = "Jogador", option = "dropdown", data = "players" },
            { id = "Amount", label = "Quantia", option = "text" },
            {
                id = "Type", label = "Tipo",
                option = "dropdown",
                data = {
                    { label = "Dinheiro",   value = "cash" },
                    { label = "Banco",   value = "bank" },
                    { label = "Cripto", value = "crypto" },
                },
            },
            { label = "Confirmar", option = "button", type = "server", event = "ps-adminmenu:server:GiveMoney" },
        },
    },

    ["give_money_all"] = {
        label = "Dar dinheiro a todos",
        perms = "admin",
        dropdown = {
            { id = "Amount", label = "Quantia",  option = "text" },
            {
                id = "Type", label = "Tipo",
                option = "dropdown",
                data = {
                    { label = "Dinheiro",   value = "cash" },
                    { label = "Banco",   value = "bank" },
                    { label = "Cripto", value = "crypto" },
                },
            },
            { label = "Confirmar", option = "button", type = "server", event = "ps-adminmenu:server:GiveMoneyAll" },
        },
    },

    ["remove_money"] = {
        label = "Retirar dinheiro",
        perms = "admin",
        dropdown = {
            { id = "Player", label = "Jogador", option = "dropdown", data = "players" },
            { id = "Amount", label = "Quantia", option = "text" },
            {
                id = "Type", label = "Tipo",
                option = "dropdown",
                data = {
                    { label = "Dinheiro", value = "cash" },
                    { label = "Banco", value = "bank" },
                },
            },
            { label = "Confirmar", option = "button", type = "server", event = "ps-adminmenu:server:TakeMoney" },
        },
    },

    ["give_item"] = {
        label = "Dar item",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { id = "Item", label = "Item",    option = "dropdown", data = "items" },
            { id = "Amount", label = "Quantia",  option = "text" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:GiveItem" },
        },
    },

    ["give_item_all"] = {
        label = "Dar item a todos",
        perms = "mod",
        dropdown = {
            { id = "Item", label = "Item",    option = "dropdown", data = "items" },
            { id = "Amount", label = "Quantia",  option = "text" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:GiveItemAll" },
        },
    },

    ["spawn_vehicle"] = {
        label = "Criar veículo",
        perms = "mod",
        dropdown = {
            { id = "Vehicle", label = "Veículo", option = "dropdown", data = "vehicles" },
            { label = "Confirmar", option = "button",   type = "client",  event = "ps-adminmenu:client:SpawnVehicle" },
        },
    },

    ["fix_vehicle"] = {
        label = "Reparar veículo",
        type = "command",
        event = "fix",
        perms = "mod",
    },

    ["fix_vehicle_for"] = {
        label = "Reparar veículo de um jogador",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:FixVehFor" },
        },
    },

    ["spectate_player"] = {
        label = "Observar jogador",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:SpectateTarget" },
        },
    },

    ["telport_to_player"] = {
        label = "Teleportar até ao jogador",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:TeleportToPlayer" },
        },
    },

    ["telport_to_coords"] = {
        label = "Teleportar para coordenadas",
        perms = "mod",
        dropdown = {
            { id = "Coords", label = "Coordenadas",  option = "text" },
            { label = "Confirmar", option = "button", type = "client", event = "ps-adminmenu:client:TeleportToCoords" },
        },
    },

    ["teleport_to_location"] = {
        label = "Teleportar para um local",
        perms = "mod",
        dropdown = {
            { id = "Location", label = "Local", option = "dropdown", data = "locations" },
            { label = "Confirmar",  option = "button",   type = "client",   event = "ps-adminmenu:client:TeleportToLocation" },
        },
    },

    ["teleport_to_marker"] = {
        label = "Teleportar para o marcador",
        type = "command",
        event = "tpm",
        perms = "mod",
    },

    ["teleport_back"] = {
        label = "Voltar à posição anterior",
        type = "client",
        event = "ps-adminmenu:client:TeleportBack",
        perms = "mod",
    },

    ["vehicle_dev"] = {
        label = "Menu dev de veículos",
        type = "client",
        event = "ps-adminmenu:client:ToggleVehDevMenu",
        perms = "mod",
    },

    ["toggle_coords"] = {
        label = "Mostrar/esconder coordenadas",
        type = "client",
        event = "ps-adminmenu:client:ToggleCoords",
        perms = "mod",
    },

    ["toggle_blips"] = {
        label = "Mostrar/esconder blips",
        type = "client",
        event = "ps-adminmenu:client:toggleBlips",
        perms = "mod",
    },

    ["toggle_names"] = {
        label = "Mostrar/esconder nomes",
        type = "client",
        event = "ps-adminmenu:client:toggleNames",
        perms = "mod",
    },

    ["toggle_cuffs"] = {
        label = "Algemar/desalgemar",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:CuffPlayer" },
        },
    },

    ["max_mods"] = {
        label = "Tunar veículo ao máximo",
        type = "client",
        event = "ps-adminmenu:client:maxmodVehicle",
        perms = "mod",
    },

    ["warn_player"] = {
        label = "Avisar jogador",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { id = "Reason", label = "Motivo",  option = "text" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:WarnPlayer" },
        },
    },

    ["infinite_ammo"] = {
        label = "Munição infinita",
        type = "client",
        event = "ps-adminmenu:client:setInfiniteAmmo",
        perms = "mod",
    },

    ["kick_player"] = {
        label = "Expulsar jogador",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",  option = "dropdown", data = "players" },
            { id = "Reason", label = "Motivo",  option = "text" },
            { label = "Confirmar", option = "button",   type = "server", event = "ps-adminmenu:server:KickPlayer" },
        },
    },


    ["play_sound"] = {
        label = "Tocar som",
        perms = "mod",
        dropdown = {
            { id = "Player", label = "Jogador",     option = "dropdown", data = "players" },
            {
                id = "Sound", label = "Som",
                option = "dropdown",
                data = {
                    { label = "Alerta",      value = "alert" },
                    { label = "Algemas",       value = "cuff" },
                    { label = "Chave pneumática", value = "airwrench" },
                },
            },
            { label = "Tocar som", option = "button",   type = "client", event = "ps-adminmenu:client:PlaySound" },
        },
    },
}

Config.PlayerActions = {
    ["teleportToPlayer"] = {
        label = "Teleportar até ao jogador",
        type = "server",
        event = "ps-adminmenu:server:TeleportToPlayer",
        perms = "mod",
    },
    ["bringPlayer"] = {
        label = "Trazer jogador",
        type = "server",
        event = "ps-adminmenu:server:BringPlayer",
        perms = "mod",
    },
    ["revivePlayer"] = {
        label = "Reanimar jogador",
        event = "ps-adminmenu:server:Revive",
        perms = "mod",
        type = "server"
    },
    ["spawnPersonalVehicle"] = {
        label = "Criar veículo pessoal",
        event = "ps-adminmenu:client:SpawnPersonalVehicle",
        perms = "mod",
        type = "client"
    },
    ["banPlayer"] = {
        label = "Banir jogador",
        event = "ps-adminmenu:server:BanPlayer",
        perms = "mod",
        type = "server"
    },
    ["kickPlayer"] = {
        label = "Expulsar jogador",
        event = "ps-adminmenu:server:KickPlayer",
        perms = "mod",
        type = "server"
    }
}

Config.OtherActions = {
    ["toggleDevmode"] = {
        type = "client",
        event = "ps-adminmenu:client:ToggleDev",
        perms = "admin",
        label = "Ligar/desligar modo dev"
    }
}

if GetResourceState('ox_inventory') == 'started' then
    Config.Inventory = 'ox_inventory'
elseif GetResourceState('ps-inventory') == 'started' then
    Config.Inventory = 'ps-inventory'
elseif GetResourceState('lj-inventory') == 'started' then
    Config.Inventory = 'lj-inventory'
elseif GetResourceState('qb-inventory') == 'started' then
    Config.Inventory = 'qb-inventory'
end
