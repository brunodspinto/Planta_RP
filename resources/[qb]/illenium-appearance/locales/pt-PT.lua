Locales["pt-PT"] = {
    UI = {
        modal = {
            save = {
                title = "Guardar personalização",
                description = "Vais continuar com essa cara?" -- Mantive o humor do original
            },
            exit = {
                title = "Sair da personalização",
                description = "Nenhuma alteração será guardada"
            },
            accept = "Sim",
            decline = "Não"
        },
        ped = {
            title = "Ped",
            model = "Modelo"
        },
        headBlend = {
            title = "Herança",
            shape = {
                title = "Rosto",
                firstOption = "Pai",
                secondOption = "Mãe",
                mix = "Mistura"
            },
            skin = {
                title = "Pele",
                firstOption = "Pai",
                secondOption = "Mãe",
                mix = "Mistura"
            },
            race = {
                title = "Raça",
                shape = "Forma",
                skin = "Pele",
                mix = "Mistura"
            }
        },
        faceFeatures = {
            title = "Traços Faciais",
            nose = {
                title = "Nariz",
                width = "Largura",
                height = "Altura",
                size = "Tamanho",
                boneHeight = "Altura do osso",
                boneTwist = "Torção do osso",
                peakHeight = "Altura da ponta"
            },
            eyebrows = {
                title = "Sobrancelhas",
                height = "Altura",
                depth = "Profundidade"
            },
            cheeks = {
                title = "Bochechas",
                boneHeight = "Altura do osso",
                boneWidth = "Largura do osso",
                width = "Largura"
            },
            eyesAndMouth = {
                title = "Olhos e Boca",
                eyesOpening = "Abertura dos olhos",
                lipsThickness = "Espessura dos lábios"
            },
            jaw = {
                title = "Maxilar",
                width = "Largura",
                size = "Tamanho"
            },
            chin = {
                title = "Queixo",
                lowering = "Baixar",
                length = "Comprimento",
                size = "Tamanho",
                hole = "Tamanho da covinha"
            },
            neck = {
                title = "Pescoço",
                thickness = "Espessura"
            }
        },
        headOverlays = {
            title = "Aparência",
            hair = {
                title = "Cabelo",
                style = "Estilo",
                color = "Cor",
                highlight = "Nuances",
                texture = "Textura",
                fade = "Fade"
            },
            opacity = "Opacidade",
            style = "Estilo",
            color = "Cor",
            secondColor = "Cor Secundária",
            blemishes = "Sinais",
            beard = "Barba",
            eyebrows = "Sobrancelhas",
            ageing = "Envelhecimento",
            makeUp = "Maquilhagem",
            blush = "Blush",
            complexion = "Tez",
            sunDamage = "Danos solares",
            lipstick = "Batom",
            moleAndFreckles = "Sardas e Manchas",
            chestHair = "Pêlos no peito",
            bodyBlemishes = "Manchas no corpo",
            eyeColor = "Cor dos olhos"
        },
        components = {
            title = "Roupa",
            drawable = "Modelo",
            texture = "Textura",
            mask = "Máscara",
            upperBody = "Mãos/Braços",
            lowerBody = "Calças",
            bags = "Mochilas e pára-quedas",
            shoes = "Sapatos",
            scarfAndChains = "Colares e acessórios",
            shirt = "Camisola Interior",
            bodyArmor = "Colete",
            decals = "Autocolantes",
            jackets = "Casacos",
            head = "Cabeça"
        },
        props = {
            title = "Acessórios",
            drawable = "Modelo",
            texture = "Textura",
            hats = "Chapéus e capacetes",
            glasses = "Óculos",
            ear = "Orelhas",
            watches = "Relógios",
            bracelets = "Pulseiras"
        },
        tattoos = {
            title = "Tatuagens",
            items = {
                ZONE_TORSO = "Tronco",
                ZONE_HEAD = "Cabeça",
                ZONE_LEFT_ARM = "Braço Esquerdo",
                ZONE_RIGHT_ARM = "Braço Direito",
                ZONE_LEFT_LEG = "Perna Esquerda",
                ZONE_RIGHT_LEG = "Perna Direita"
            },
            apply = "Aplicar",
            delete = "Remover",
            deleteAll = "Remover todas as Tatuagens",
            opacity = "Opacidade"
        }
    },
    outfitManagement = {
        title = "Gestão de Conjuntos",
        jobText = "Gerir conjuntos de Trabalho",
        gangText = "Gerir conjuntos de Gang"
    },
    cancelled = {
        title = "Personalização Cancelada",
        description = "As alterações não foram guardadas"
    },
    outfits = {
        import = {
            title = "Inserir código do conjunto",
            menuTitle = "Importar Conjunto",
            description = "Importar um conjunto através de um código",
            name = {
                label = "Nomear o Conjunto",
                placeholder = "Um conjunto fixe",
                default = "Conjunto Importado"
            },
            code = {
                label = "Código do Conjunto"
            },
            success = {
                title = "Conjunto Importado",
                description = "Já podes mudar para este conjunto usando o menu de roupa"
            },
            failure = {
                title = "Falha na Importação",
                description = "Código de conjunto inválido"
            }
        },
        generate = {
            title = "Gerar Código de Conjunto",
            description = "Gerar um código para partilhar este conjunto",
            failure = {
                title = "Algo correu mal",
                description = "Falha ao gerar o código para o conjunto"
            },
            success = {
                title = "Código Gerado",
                description = "Aqui está o teu código de conjunto"
            }
        },
        save = {
            menuTitle = "Guardar Conjunto atual",
            menuDescription = "Guardar o conjunto atual como conjunto de %s",
            description = "Guardar o teu conjunto atual",
            title = "Nomeia o teu conjunto",
            managementTitle = "Detalhes de Gestão do Conjunto",
            name = {
                label = "Nome do Conjunto",
                placeholder = "Conjunto muito louco"
            },
            gender = {
                label = "Género",
                male = "Masculino",
                female = "Feminino"
            },
            rank = {
                label = "Cargo Mínimo"
            },
            failure = {
                title = "Falha ao Guardar",
                description = "Já existe um conjunto com este nome"
            },
            success = {
                title = "Sucesso",
                description = "O conjunto %s foi guardado"
            }
        },
        update = {
            title = "Atualizar Conjunto",
            description = "Guardar a roupa atual num conjunto existente",
            failure = {
                title = "Falha na Atualização",
                description = "Esse conjunto não existe"
            },
            success = {
                title = "Sucesso",
                description = "O conjunto %s foi atualizado"
            }
        },
        change = {
            title = "Mudar de Conjunto",
            description = "Escolhe entre os teus conjuntos de %s guardados",
            pDescription = "Escolhe entre os teus conjuntos guardados",
            failure = {
                title = "Algo correu mal",
                description = "O conjunto que estás a tentar usar não tem uma aparência base",
            }
        },
        delete = {
            title = "Eliminar Conjunto",
            description = "Eliminar um conjunto guardado de %s",
            mDescription = "Eliminar qualquer um dos teus conjuntos guardados",
            item = {
                title = 'Eliminar "%s"',
                description = "Modelo: %s%s"
            },
            success = {
                title = "Sucesso",
                description = "Conjunto eliminado"
            }
        },
        manage = {
            title = "👔 | Gerir conjuntos de %s"
        }
    },
    jobOutfits = {
        title = "Roupas de Trabalho",
        description = "Escolhe uma das tuas roupas de trabalho"
    },
    menu = {
        returnTitle = "Voltar",
        title = "Vestiário",
        outfitsTitle = "Conjuntos do Jogador",
        clothingShopTitle = "Loja de Roupa",
        barberShopTitle = "Barbearia",
        tattooShopTitle = "Loja de Tatuagens",
        surgeonShopTitle = "Cirurgião Plástico"
    },
    clothing = {
        title = "Comprar Roupa - %d€",
        titleNoPrice = "Mudar de Roupa",
        options = {
            title = "👔 | Opções da Loja de Roupa",
            description = "Escolhe entre uma grande variedade de peças"
        },
        outfits = {
            title = "👔 | Opções de Conjuntos",
            civilian = {
                title = "Roupa Civil",
                description = "Vestir a tua roupa normal"
            }
        }
    },
    commands = {
        reloadskin = {
            title = "Recarrega a skin da tua personagem",
            failure = {
                title = "Erro",
                description = "Não podes usar o reloadskin agora"
            }
        },
        clearstuckprops = {
            title = "Remove todos os acessórios colados à entidade",
            failure = {
                title = "Erro",
                description = "Não podes usar o clearstuckprops agora"
            }
        },
        pedmenu = {
            title = "Abrir / Dar Menu de Roupa",
            failure = {
                title = "Erro",
                description = "O jogador não está online"
            }
        },
        joboutfits = {
            title = "Abre o menu de roupas de trabalho"
        },
        gangoutfits = {
            title = "Abre o menu de roupa de gang"
        },
        bossmanagedoutfits = {
            title = "Abre o menu de gestão de roupas de chefe"
        }
    },
    textUI = {
        clothing = "Loja de Roupa - Preço: %d€",
        barber = "Barbearia - Preço: %d€",
        tattoo = "Loja de Tatuagens - Preço: %d€",
        surgeon = "Cirurgião Plástico - Preço: %d€",
        clothingRoom = "Vestiário",
        playerOutfitRoom = "Conjuntos"
    },
    migrate = {
        success = {
            title = "Sucesso",
            description = "Migração concluída. %s skins migradas",
            descriptionSingle = "Skin migrada"
        },
        skip = {
            title = "Informação",
            description = "Skin ignorada"
        },
        typeError = {
            title = "Erro",
            description = "Tipo inválido"
        }
    },
    purchase = {
        tattoo = {
            success = {
                title = "Sucesso",
                description = "Tatuagem %s comprada por %s€"
            },
            failure = {
                title = "Falha ao aplicar tatuagem",
                description = "Não tens dinheiro suficiente!"
            }
        },
        store = {
            success = {
                title = "Sucesso",
                description = "Pagaste %s€ a %s!"
            },
            failure = {
                title = "Exploit!",
                description = "Não tinhas dinheiro suficiente! Tentativa de batota detetada!"
            }
        }
    }
}