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
- Anticheat próprio server-side (`prp-anticheat`) com persistência de bans
- Scripts próprios: `simple-repair` (reparação por item), `simple_speedometer`
  (HUD de velocidade/cinto), `postal_map` (códigos postais no minimapa)
- Suite de testes em Lua para validação

> Os recursos do ecossistema QBCore são vendored (upstream). O código realmente
> específico deste servidor são os scripts próprios acima, o `prp-anticheat`, e as
> traduções/ajustes pt-PT dentro do `qb-core`.

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
git clone https://github.com/brunodspinto/Planta_RP.git
cd Planta_RP
```

> **Este clone não traz um servidor visualmente completo.** Os assets binários de
> jogo não estão versionados — ver [Assets binários](#assets-binários).

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
| `sv_enforceGameBuild` | Build do GTA V (atual: **3258**, DLC Bottom Dollar Bounties) |
| `DISCORD_WEBHOOK_SECURITY` | Webhook usado pelo `prp-anticheat` para alertas |

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
cd C:\FiveM\txData\Planta_RP

# Executa o artefacto (exemplo, ajusta ao teu caminho)
& "C:\FiveM\fx-server-data\run.cmd"
```

> **Nota sobre o nome da pasta:** o `git clone` cria `Planta_RP`, e é esse o nome
> usado ao longo deste README. Numa instalação com txAdmin a pasta pode chamar-se
> outra coisa — o txAdmin cria os seus próprios *deploys* dentro de `txData/` com
> o nome que lhe deres. Ajusta os caminhos ao teu caso.

**Nota:** Mantém cópias de segurança do `server.cfg` antes de editar configurações críticas.

## Estrutura do Projeto

```
Planta_RP/
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

## Assets binários

Os ficheiros binários de jogo — modelos (`.ydr`, `.ydd`, `.yft`), texturas
(`.ytd`), colisões (`.ybn`) e mapas (`.ymap`, `.ytyp`) — **não estão versionados
neste repositório** e são excluídos pelo `.gitignore`. São 357 ficheiros, cerca
de 308 MB.

**Porquê:** são assets de terceiros, com as suas próprias condições de
distribuição, e cada um tem de ser obtido junto da respetiva fonte. Mantê-los
fora do git evita também arrastar centenas de MB em cada clone e em cada
operação sobre o histórico.

**O que isto significa na prática:**

- Um clone novo **arranca**, mas sem os carros, os MLOs nem o minimapa
  personalizado. Os manifestos (`fxmanifest.lua`, `__resource.lua`), os `.meta`
  e todo o código continuam versionados — só faltam os binários.
- Para pôr um servidor a funcionar a sério, os assets têm de ser colocados no
  disco à parte, por cima da árvore de `resources/`.
- ⚠️ **Nunca corras `git clean -xfd`** numa instalação a sério: o `-x` inclui os
  ficheiros ignorados e apagaria todos os assets, que fora do git não têm
  segunda cópia no repositório.

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

## Licença

**Código próprio:** [GPL-3.0](LICENSE), copyright © 2026 Bruno Pinto, exceto
onde indicado abaixo.

Três recursos são independentes do QBCore e estão sob **MIT**, com o respetivo
`LICENSE` dentro da pasta:

| Recurso | Âmbito |
|---|---|
| [`[standalone]/prp-anticheat`](resources/[standalone]/prp-anticheat/LICENSE) | Todo o recurso |
| [`[standalone]/simple_speedometer`](resources/[standalone]/simple_speedometer/LICENSE) | Todo o recurso |
| [`[maps]/postal_map`](resources/[maps]/postal_map/LICENSE) | **Apenas o código.** Os tiles de minimapa em `stream/` são de terceiros |

**Código de terceiros:** este repositório é uma instalação de servidor e contém
dezenas de recursos de outros autores. **Cada recurso mantém a sua própria
licença, que prevalece sobre esta.** Procura o `LICENSE` dentro da pasta de cada
um antes de reutilizar seja o que for.

A maioria dos recursos do ecossistema QBCore está sob GPL-3.0. As exceções que
importam:

| Recurso | Licença | O que implica |
|---|---|---|
| `[qb]/ps-adminmenu` | CC BY-NC-SA 4.0 | Uso não-comercial; derivados sob a mesma licença |
| `[defaultmaps]/hospital_map` | NoFreeRide (NFRL) | Uso não-comercial |
| `[standalone]/ox_lib`, `oxmysql` | LGPL-3.0 | Podem ser usadas sem impor copyleft a quem as chama |
| `[voice]/pma-voice`, `PolyZone`, `bob74_ipl`, `interact-sound`, `screenshot-basic` | MIT | |

As duas primeiras pedem uso não-comercial, e este servidor não tem qualquer
receita — sem donativos, VIP ou venda de itens —, pelo que a condição está
cumprida. Fica a nota para o caso de isso mudar um dia: aí esses dois recursos
teriam de ser revistos.

**Recursos modificados.** Vários recursos de terceiros foram alterados aqui —
correções de segurança e traduções pt-PT em `qb-core`, `qb-phone`, `qb-houses`,
`qb-policejob`, `qb-vehicleshop`, `ps-adminmenu`, `qb-hud`, `qb-radialmenu` e
`qb-smallresources`. Essas alterações ficam sob a licença do recurso original, e
o histórico do git identifica-as uma a uma.

**Recursos sem licença.** 35 dos 100 recursos chegaram ao projeto sem qualquer
ficheiro de licença — sobretudo mapas. Sem licença expressa, o padrão é *todos os
direitos reservados*: não são redistribuíveis sem autorização do autor.

## Créditos e Agradecimentos

- **FiveM** / **Cfx.re** - Plataforma base
- **Comunidade QBCore** - Framework e recursos
- Documentação da comunidade

---

**Nota:** Este repositório contém o código-fonte e configuração de exemplo. A instalação de um servidor funcional requer chaves FiveM válidas, base de dados MySQL e configuração local apropriada.
