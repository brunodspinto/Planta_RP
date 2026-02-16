QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = true -- true: Forçar entrada em serviço ao logar | false: manter ultimo estado
QBShared.Jobs = {
    -- CVIS E GENÉRICOS
    unemployed = { label = 'Civil', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Desempregado', payment = 10 } } },
    
    bus = { label = 'Autocarros', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Motorista', payment = 50 } } },
    
    judge = { label = 'Tribunal', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Juiz', payment = 100 } } },
    
    lawyer = { label = 'Advocacia', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Associado', payment = 50 } } },
    
    reporter = { label = 'Notícias', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Jornalista', payment = 50 } } },
    
    trucker = { label = 'Camionagem', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Motorista', payment = 50 } } },
    
    tow = { label = 'Reboques', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Motorista', payment = 50 } } },
    
    garbage = { label = 'Saneamento', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Cantoneiro', payment = 50 } } },
    
    vineyard = { label = 'Vinha', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Vindimador', payment = 50 } } },
    
    hotdog = { label = 'Cachorros Quentes', defaultDuty = true, offDutyPay = false, grades = { ['0'] = { name = 'Vendedor', payment = 50 } } },

    -- SERVIÇOS DE EMERGÊNCIA
    police = {
        label = 'PSP',
        type = 'leo',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruta', payment = 50 },
            ['1'] = { name = 'Agente', payment = 75 },
            ['2'] = { name = 'Chefe', payment = 100 },
            ['3'] = { name = 'Sub-Comissário', payment = 125 },
            ['4'] = { name = 'Comissário', isboss = true, payment = 150 },
        },
    },
    ambulance = {
        label = 'INEM',
        type = 'ems',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Estagiário', payment = 50 },
            ['1'] = { name = 'Paramédico', payment = 75 },
            ['2'] = { name = 'Médico', payment = 100 },
            ['3'] = { name = 'Cirurgião', payment = 125 },
            ['4'] = { name = 'Diretor', isboss = true, payment = 150 },
        },
    },

    -- COMÉRCIO E SERVIÇOS
    realestate = {
        label = 'Imobiliária',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Estagiário', payment = 50 },
            ['1'] = { name = 'Vendedor de Casas', payment = 75 },
            ['2'] = { name = 'Vendedor Comercial', payment = 100 },
            ['3'] = { name = 'Corretor', payment = 125 },
            ['4'] = { name = 'Gerente', isboss = true, payment = 150 },
        },
    },
    taxi = {
        label = 'Táxis',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruta', payment = 50 },
            ['1'] = { name = 'Taxista', payment = 75 },
            ['2'] = { name = 'Taxista VIP', payment = 100 },
            ['3'] = { name = 'Coordenador', payment = 125 },
            ['4'] = { name = 'Gerente', isboss = true, payment = 150 },
        },
    },
    cardealer = {
        label = 'Stand Automóvel',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = { name = 'Recruta', payment = 50 },
            ['1'] = { name = 'Vendedor', payment = 75 },
            ['2'] = { name = 'Vendedor Sénior', payment = 100 },
            ['3'] = { name = 'Financeiro', payment = 125 },
            ['4'] = { name = 'Dono', isboss = true, payment = 150 },
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
            ['0'] = { name = 'Recruta', payment = 50 },
            ['1'] = { name = 'Aprendiz', payment = 75 },
            ['2'] = { name = 'Mecânico', payment = 100 },
            ['3'] = { name = 'Gerente', payment = 125 },
            ['4'] = { name = 'Patrão', isboss = true, payment = 150 },
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
            ['0'] = { name = 'Vigia', payment = 50 },
            ['1'] = { name = 'Ajudante', payment = 75 },
            ['2'] = { name = 'Tuner', payment = 150 },
            ['3'] = { name = 'Especialista', payment = 200 },
            ['4'] = { name = 'Boss', isboss = true, payment = 250 },
        },
    },
}