# postal_map

Ajusta os níveis de zoom do minimapa para que os **códigos postais** fiquem legíveis.

## O que faz

Configura os 5 níveis de zoom do mapa (`SetMapZoomDataLevel`) para que os números
postais apareçam ao nível certo no minimapa e no mapa grande (tecla M).

## Dependências

Nenhuma (standalone).

## Notas importantes

- O **zoom do radar** (`SetRadarZoom`) **NÃO** é gerido aqui — é controlado pelo `qb-hud`
  (thread "Minimap update", valor 1100), que é o dono único. Houve aqui um loop de
  `SetRadarZoom` per-frame que competia com o qb-hud e fazia o radar piscar; foi removido
  de propósito. **Não voltar a adicionar** um loop de radar zoom neste recurso.
- Se quiseres mudar o nível de zoom do radar, edita o valor no `qb-hud/client.lua`.
