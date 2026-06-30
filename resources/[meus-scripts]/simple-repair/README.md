# simple-repair

Sistema simples de reparação de veículos via item, para QBCore.

## O que faz

O jogador usa o item **`repairkit`** no inventário. O personagem sai do carro (se estiver
dentro), caminha até à frente do motor, faz uma animação de reparação com `lib.progressBar`
(5s, cancelável) e o veículo fica reparado (motor, sujidade, portas). Funciona tanto **dentro**
como **fora** do carro (procura o veículo mais próximo a < 3m).

## Dependências

- `qb-core`
- `ox_lib` (progress bar)

## Configuração

No topo de [`server.lua`](server.lua):

| Opção | Default | Descrição |
|---|---|---|
| `Custo` | `0` | Custo monetário (atualmente não cobrado) |
| `ItemNecessario` | `'repairkit'` | Item que ativa a reparação |
| `ConsumirItem` | `true` | Remove o item após usar |

## Notas

- A validação do item é feita **server-side** antes de remover/reparar (sem dupe).
- Toda a reparação tem timeouts (caminhada máx. 15s, carregamento de animação máx. 10s)
  para nunca deixar o jogador preso.
