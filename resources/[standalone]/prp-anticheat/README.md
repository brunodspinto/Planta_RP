# prp-anticheat

Anticheat gratuito e leve para FiveM/QBCore com foco em validacao no servidor.

## O que ele faz

- Detecta gatilho de eventos conhecidos de cheat/mod menu.
- Detecta spam de explosoes por jogador.
- Detecta spam de criacao de entidades por jogador.
- Permite monitorar spam de eventos legitimos (configuravel).
- Aplica pontuacao por suspeita e kick progressivo quando atingir o limite.
- Envia logs para Discord webhook (opcional).

## Instalacao

1. O recurso esta em `resources/[standalone]/prp-anticheat`.
2. Como o seu `server.cfg` ja usa `ensure [standalone]`, ele inicia automaticamente.
3. Reinicie o servidor ou rode `refresh` e `ensure prp-anticheat` no console.

## Configuracao

Arquivo: `resources/[standalone]/prp-anticheat/config.lua`

- `Config.Logging.Webhook`: URL do webhook do Discord para alertas.
- `Config.Punishment.KickAtPoints`: pontos para kick automatico.
- `Config.Detections.MonitoredEvents`: eventos do teu servidor para limitar spam.

Exemplo de monitoramento de evento legitimo:

```lua
MonitoredEvents = {
    ['qb-phone:server:sendNewMail'] = { max = 8, window = 10, points = 2 },
    ['qb-banking:server:depositMoney'] = { max = 10, window = 10, points = 2 }
}
```

## Comando admin

- `acstatus [id]`: mostra pontuacao atual do jogador (console ou admin in-game).

## Recomendacoes importantes

- Comeca com limites altos e reduz aos poucos.
- Sempre valida dinheiro, inventario e rewards no server dos scripts de gameplay.
- Anticheat bom e processo continuo: logs + ajustes + revisao semanal.
