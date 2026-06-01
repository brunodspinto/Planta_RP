# prp-anticheat

Anticheat server-side modular para FiveM/QBCore, com persistência de bans, validação de gameplay e API para outros recursos.

## O que faz

### Detecções
- **Eventos blacklisted** — handler para 24 nomes conhecidos de mod menus/cheats (`HCheat:TempDisableDetection`, `mellotrainer:adminTempBan`, etc.); kick imediato.
- **Eventos monitorizados** — opt-in: define limites de rate para qualquer evento legítimo (ex.: `qb-phone:server:sendNewMail` >8/10s = suspeita).
- **Explosões** — janela deslizante por jogador; alerta acima de 20/10s; tipos blacklisted (granadas, RPG, stickybomb...) somam mais pontos.
- **Spawn massivo de entidades** — janela deslizante por owner com grace period após join.
- **Weapon damage modifier** — valida `weaponDamageEvent`; dano acima do máximo realista por arma (com multiplicador para headshot) dispara ban automático.
- **God mode** — polling de `GetEntityHealth` para todos os players online a cada 8s; health > 200 = kick.

### Punição
Dois modos, exclusivos:
- **Direct-kick** (default): cada deteção é avaliada contra `KickOnDetection` / `BanOnDetection`. Algumas categorias (weapon damage modifier) escalam diretamente a ban permanente.
- **Pontos** (`Config.Punishment.UsePoints = true`): cada deteção soma pontos; ao chegar a `KickAtPoints` o jogador é expulso, a `BanAtPoints` é banido. Decay periódico evita acumular falsos positivos.

`Punishment.Enabled = false` **continua a logar** mas não kicka nem bana (modo observação para tuning).

### Bans persistentes
- Tabela MySQL `prp_anticheat_bans` criada automaticamente no arranque.
- Match por `license`, `steam`, `discord`, `fivem`, `ip` (qualquer um chega).
- Cache em memória (lookup O(1)).
- `playerConnecting` rejeita ligações banidas antes de carregar recursos.
- Bans podem ter expiração (`expires_at`) ou ser permanentes.

### Allowlist por ACE
Devs/testers precisam fazer testes que dispararíam alertas (spawn massivo, etc.). Atribui:

```
add_ace identifier.license:XXXXXX prp_anticheat.bypass
```

Players com a ACE `prp_anticheat.bypass` (configurável via `Config.BypassAce`) continuam a aparecer no log com tag `[BYPASS]` para auditoria, mas nunca acumulam pontos nem são kicked.

### Webhook Discord
- URL lido da convar `DISCORD_WEBHOOK_SECURITY` em `server.cfg`.
- **Janela deslizante** real (25 mensagens/60s) para evitar `429` do Discord.
- **Retry com backoff exponencial** (2s, 8s, 20s) em erros 5xx ou 429.
- 4xx (config errada) abortam sem retry.

## Instalação

1. O recurso já está em `resources/[standalone]/prp-anticheat`.
2. Como o `server.cfg` faz `ensure [standalone]`, inicia automaticamente.
3. Confirma que `DISCORD_WEBHOOK_SECURITY` está definido em `server.cfg`.
4. A tabela MySQL é criada automaticamente no primeiro start (verifica `[prp-anticheat] Bans carregados: N activos em memória` nos logs).

## Comandos administrativos

Acesso por ACE `admin` (ajustável em `Config.AdminAce`). Console (`source=0`) tem sempre acesso.

| Comando | Efeito |
|---|---|
| `/acstatus <id>` | Mostra pontos, flags (bypassed/kicked/banned) e as últimas 5 razões registadas. Read-only — não cria estado. |
| `/acreset <id>` | Zera pontos e razões da sessão atual (não remove ban). |
| `/acban <id> [horas] [motivo...]` | Banir jogador online. `horas=0` ou omitido = permanente. Motivo livre. |
| `/acunban <license>` | Remove ban. Aceita com ou sem prefixo `license:`. |
| `/aclist [N]` | Listar os últimos N bans ativos (default 20, máx 100). |
| `/acstats` | Métricas globais: deteções por tipo, kicks, bans, webhooks enviados/descartados/retries, uptime. |
| `/achelp` | Listar todos os comandos. |

## API para outros recursos

```lua
-- Pontos atuais do jogador (modo pontos).
local pts = exports['prp-anticheat']:GetPlayerScore(src)

-- Sinalizar suspeita a partir de outro script de gameplay.
exports['prp-anticheat']:Flag(src, 'qb-banking:withdraw-too-fast',
    'Levantamento acima do limite diário em <1s', 4)

-- Verificar se uma license está banida (cache em memória, O(1)).
if exports['prp-anticheat']:IsBanned(license) then ... end

-- Verificar source online.
if exports['prp-anticheat']:IsSourceBanned(src) then ... end

-- Snapshot das métricas para dashboards.
local m = exports['prp-anticheat']:GetMetrics()
print(m.detectionsTotal, m.kicksTotal, m.bansTotal)

-- Verificar se source tem bypass (para outros scripts respeitarem).
if exports['prp-anticheat']:IsBypassed(src) then return end
```

## Estrutura

```
prp-anticheat/
├── fxmanifest.lua
├── config.lua
├── README.md
├── sql/
│   └── install.sql              -- schema da tabela prp_anticheat_bans
└── server/
    ├── state.lua                -- gestão central de state + sliding windows + métricas
    ├── identifiers.lua          -- helpers de license/steam/etc
    ├── webhook.lua              -- Discord notifier (rate-limit + retry)
    ├── bans.lua                 -- MySQL persistence + cache
    ├── punishment.lua           -- orquestração de kick/ban
    ├── detections.lua           -- 6 detectores
    ├── commands.lua             -- /ac*
    ├── exports.lua              -- API pública
    └── main.lua                 -- entry point (lifecycle + boot)
```

## Boas práticas para o servidor

- O anticheat é **complementar**, não único. Continua a validar dinheiro, inventário, rewards e ações sensíveis no servidor de cada recurso.
- Para deploy: começa com `Config.Punishment.Enabled = false` por algumas horas, monitoriza o webhook, ajusta limites em `Config.Detections.*.MaxPerWindow` conforme tráfego real, depois liga.
- Adiciona ACE `prp_anticheat.bypass` a contas de devs/testers antes de fazerem stress tests.
- Revê `acstats` periodicamente. Se uma deteção tem 1000+/dia, ou estás sob ataque, ou o limite está mal calibrado.
