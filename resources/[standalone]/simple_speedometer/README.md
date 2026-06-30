# simple_speedometer

Velocímetro HUD leve para QBCore, no canto inferior direito do ecrã.

## O que faz

Quando o jogador conduz (apenas o **condutor**), desenha no ecrã:

- **Velocidade** em km/h
- **Mudança** (com `R` para marcha-atrás, `N` para ponto-morto) — cor muda com as RPM
- **Gasolina** em % — fica vermelho abaixo de 20%
- **Cinto de segurança** — `CINTO ON` (verde) / `CINTO OFF` (vermelho)

O estado do cinto escuta o evento `seatbelt:client:ToggleSeatbelt` (padrão QBCore).

## Dependências

- `qb-core`

## Configuração

No topo de [`client.lua`](client.lua):

| Opção | Default | Descrição |
|---|---|---|
| `posX` | `0.88` | Posição horizontal no ecrã (0–1) |
| `posY` | `0.88` | Posição vertical no ecrã (0–1) |

## Notas

- A thread usa sleep adaptativo: só corre a cada frame quando o jogador é o condutor;
  caso contrário dorme 1s. Sem custo de performance fora de veículos.
