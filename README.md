# Planta RP

**Servidor FiveM de roleplay avançado, construído com QBCore.**

Um projeto completo de roleplay em GTA V (FiveM) que integra economia dinâmica, sistema de empregos, gangues, habitação, voz 3D e ferramentas de administração.

## Visão Geral

O servidor está organizado para funcionar com **txAdmin + FiveM Artifact**, com pilha técnica principal em **Lua** e base de dados **MySQL**.

Principais componentes:

- Núcleo QBCore e recursos do ecossistema oficial
- Sistema de voz 3D (pma-voice)
- Interface e UI responsiva
- Mapas personalizados (bairros, lojas, locais de trabalho)
- Scripts próprios em `[meus-scripts]`
- Suite de testes em Lua para validação

## Pilha Técnica

| Componente | Tecnologia |
|-----------|-----------|
| Plataforma | FiveM (FXServer) |
| Framework | QBCore |
| Linguagem | Lua 5.4+ |
| Base de Dados | MySQL/MariaDB (oxmysql) |
| Voz | pma-voice |
| Biblioteca Utilitária | ox_lib |
| Testes | Lua Unit Test Framework |
| Sistema Operativo | Windows + PowerShell 5.1+ |

## Requisitos

- **Windows** com PowerShell 5.1+
- **FiveM Artifact** atualizado (versão recomendada: atual)
- **txAdmin** instalado e configurado
- **MySQL/MariaDB** acessível em rede local
- **Lua 5.4+** no PATH (opcional, apenas para testes)
- Chaves FiveM válidas e Steam Web API Key

## Como Começar

### 1. Clonar o repositório
```powershell
git clone https://github.com/paocomplanta1/Planta_RP.git
cd PlantaRP
```

### 2. Configurar o servidor

Copia o ficheiro de exemplo para criar a configuração real:
```powershell
Copy-Item server.cfg.example server.cfg
```

Agora edita `server.cfg` com os teus valores reais:

| Variável | O que fazer |
|----------|-----------|
| `endpoint_add_tcp` / `endpoint_add_udp` | Define o IP e porta do servidor |
| `sv_maxclients` | Número máximo de jogadores (padrão: 48) |
| `sv_licenseKey` | Obtém em https://keymaster.fivem.net |
| `steam_webApiKey` | Obtém em https://steamcommunity.com/dev/apikey |

### 3. Estrutura de pastas e ordem de início

O servidor garante que os recursos iniciam nesta ordem:

**Dependências (sempre primeiro):**
```
ensure ox_lib
ensure qb-core
ensure bob74_ipl
```

**Grupos de recursos:**
```
ensure [qb]          # Recursos QBCore modificados
ensure [standalone]  # Scripts independentes
ensure [voice]       # Sistema de voz
ensure [defaultmaps] # Mapas e interiores padrão
ensure [cars]        # Conteúdo de veículos
ensure [maps]        # Mapas personalizados
ensure [meus-scripts] # Scripts próprios
```

## Executar o Servidor

### Com txAdmin (Recomendado)

1. Abre txAdmin
2. Cria um novo "Server Profile" e aponta para a pasta raiz do projeto (onde está `server.cfg`)
3. Inicia o servidor através da interface
4. Verifica os registos para confirmar que `qb-core` e outros recursos iniciaram sem erros

### Via Linha de Comando

```powershell
# Navega até à pasta do servidor
cd C:\FiveM\txData\PlantaRP

# Executa o artefacto (exemplo, ajusta ao teu caminho)
& "C:\FiveM\fx-server-data\run.cmd"
```

**Nota:** Mantém cópias de segurança do `server.cfg` antes de editar configurações críticas.

## Estrutura do Projeto

```
PlantaRP/
├── resources/
│   ├── [qb]/              # Recursos do ecossistema QBCore
│   ├── [standalone]/      # Recursos independentes
│   ├── [voice]/           # Sistema de voz (pma-voice)
│   ├── [defaultmaps]/     # Mapas padrão (hospital, prisão, etc.)
│   ├── [cars]/            # Veículos personalizados
│   ├── [maps]/            # Mapas e locais de RP
│   └── [meus-scripts]/    # Scripts desenvolvidos
├── tests/
│   ├── run-lua-tests.ps1  # Script para executar testes
│   └── lua/
│       ├── test_runner.lua
│       ├── unit/          # Suites de testes
│       └── reports/       # Resultados dos testes
├── server.cfg.example     # Exemplo de configuração
├── README.md              # Este ficheiro
└── .gitignore            # Ficheiros ignorados pelo Git
```

## Testes em Lua

O projeto inclui uma suite de testes para validar sintaxe e lógica dos scripts.

### Como executar

```powershell
powershell -ExecutionPolicy Bypass -File tests/run-lua-tests.ps1
```

### O que faz

- ✓ Detecta interpretador Lua no PATH
- ✓ Varre todos os ficheiros `.lua` em `resources/`
- ✓ Executa suites de teste em `tests/lua/unit/`
- ✓ Gera relatórios em `tests/lua/reports/`

Útil para validar mudanças antes de enviar ao servidor em produção.

## Segurança e Boas Práticas

**NÃO commites as seguintes informações:**
- Chaves de licença FiveM
- Credenciais de BD ou webhooks Discord
- Steam Web API Keys
- Identificadores de licença pessoais
- Qualquer outro token ou palavra-passe

**O que fazer:**
1. Utiliza `server.cfg.example` como modelo
2. Cria o teu `server.cfg` local (ignorado pelo Git)
3. Utiliza variáveis de ambiente ou sistemas de segredos para produção
4. Revê ficheiros antes de fazer commit (`git diff`)
5. Mantém cópias de segurança regulares da BD

## Recursos Úteis

- [Documentação FiveM](https://aka.cfx.re/)
- [Wiki QBCore](https://docs.qbcore.org)
- [Guia txAdmin](https://docs.txadmin.com)
- [Manual de Referência Lua](https://www.lua.org/manual/5.4/)

## Créditos e Agradecimentos

- **FiveM** / **Cfx.re** - Plataforma base
- **Comunidade QBCore** - Framework e recursos
- Documentação da comunidade

---

**Nota:** Este repositório contém o código-fonte e configuração de exemplo. A instalação de um servidor funcional requer chaves FiveM válidas, base de dados MySQL e configuração local apropriada.
