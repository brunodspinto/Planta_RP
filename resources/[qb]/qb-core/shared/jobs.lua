QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = true -- true: Forçar entrada em serviço ao logar | false: manter ultimo estado
QBShared.Jobs = {
    -- CVIS E GENÉRICOS
    unemployed = { label = 'Civil', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Desempregado', payment = 25 } } },
    
    bus = { label = 'Autocarros', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Motorista', payment = 85 } } },
    
    judge = { label = 'Tribunal', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Juiz', payment = 220 } } },
    
    lawyer = { label = 'Advocacia', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Associado', payment = 120 } } },
    
    reporter = { label = 'Notícias', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Jornalista', payment = 80 } } },
    
    trucker = { label = 'Camionagem', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Motorista', payment = 95 } } },
    
    tow = { label = 'Reboques', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Motorista', payment = 90 } } },
    
    garbage = { label = 'Saneamento', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Cantoneiro', payment = 85 } } },
    
    vineyard = { label = 'Vinha', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Vindimador', payment = 80 } } },
    
    hotdog = { label = 'Cachorros Quentes', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Vendedor', payment = 80 } } },

    -- SERVIÇOS DE EMERGÊNCIA
    police = {
        label = 'PSP',
        type = 'leo',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruta', payment = 140 },
            ['1'] = { name = 'Agente', payment = 180 },
            ['2'] = { name = 'Chefe', payment = 220 },
            ['3'] = { name = 'Sub-Comissário', payment = 270 },
            ['4'] = { name = 'Comissário', isboss = true, payment = 320 },
        },
    },
    ambulance = {
        label = 'INEM',
        type = 'ems',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Estagiário', payment = 130 },
            ['1'] = { name = 'Paramédico', payment = 170 },
            ['2'] = { name = 'Médico', payment = 220 },
            ['3'] = { name = 'Cirurgião', payment = 270 },
            ['4'] = { name = 'Diretor', isboss = true, payment = 320 },
        },
    },

    -- COMÉRCIO E SERVIÇOS
    realestate = {
        label = 'Imobiliária',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Estagiário', payment = 90 },
            ['1'] = { name = 'Vendedor de Casas', payment = 125 },
            ['2'] = { name = 'Vendedor Comercial', payment = 165 },
            ['3'] = { name = 'Corretor', payment = 210 },
            ['4'] = { name = 'Gerente', isboss = true, payment = 260 },
        },
    },
    taxi = {
        label = 'Táxis',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruta', payment = 85 },
            ['1'] = { name = 'Taxista', payment = 110 },
            ['2'] = { name = 'Taxista VIP', payment = 145 },
            ['3'] = { name = 'Coordenador', payment = 180 },
            ['4'] = { name = 'Gerente', isboss = true, payment = 220 },
        },
    },
    cardealer = {
        label = 'Stand Automóvel',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruta', payment = 100 },
            ['1'] = { name = 'Vendedor', payment = 130 },
            ['2'] = { name = 'Vendedor Sénior', payment = 170 },
            ['3'] = { name = 'Financeiro', payment = 210 },
            ['4'] = { name = 'Dono', isboss = true, payment = 260 },
        },
    },

    -- MECÂNICO LEGAL (Benny's Original)
    -- Focado em reparações visuais e manutenção básica
    bennys = {
        label = 'Benny\'s Original',
        type = 'mechanic',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruta', payment = 95 },
            ['1'] = { name = 'Aprendiz', payment = 120 },
            ['2'] = { name = 'Mecânico', payment = 160 },
            ['3'] = { name = 'Gerente', payment = 200 },
            ['4'] = { name = 'Patrão', isboss = true, payment = 250 },
        },
    },

    -- MECÂNICO ILEGAL (Tuners Underground)
    -- Focado em performance, turbos e ilegalidades
    tuners = {
        label = 'Tuners Underground',
        type = 'mechanic',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Vigia', payment = 90 },
            ['1'] = { name = 'Ajudante', payment = 120 },
            ['2'] = { name = 'Tuner', payment = 165 },
            ['3'] = { name = 'Especialista', payment = 210 },
            ['4'] = { name = 'Boss', isboss = true, payment = 260 },
        },
    },
}