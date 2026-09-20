# Proveniência dos assets binários

Os assets binários de jogo (modelos, texturas, colisões, mapas) **não estão
versionados** neste repositório — ver a nota no [README](../../README.md#assets-binários).
Este ficheiro documenta de onde vem cada pack, para que a origem não se perca.

**Inventário de 2026-09-20:** 461 ficheiros, 324 MB. Nenhum tem `.fxap`, ou seja,
nada foi obtido pelo sistema de escrow do FiveM.

Legenda: ✅ confirmado · ⚠️ por confirmar · ❌ sem qualquer documentação

---

## Risco alto

### Veículos — `resources/[cars]/imports`

| Pack | Tamanho | Marca | Origem | Licença |
|---|---:|---|---|---|
| Mercedes G63 (`g63trg`) | 46,5 MB | ❌ **Mercedes-Benz / AMG** | ❌ desconhecida | ❌ nenhuma |
| Honda CB1000 (`25cb1000`) | 35,3 MB | ❌ **Honda** | ❌ desconhecida | ❌ nenhuma |
| Harley-Davidson Fat Boy (`hexer`) | 7,0 MB | ❌ **Harley-Davidson** ("Fat Boy" é marca registada) | ❌ desconhecida | ❌ nenhuma |
| Truck V8 (`v8truck`) | 10,7 MB | ⚠️ nome genérico, base real por identificar | ❌ desconhecida | ❌ nenhuma |
| Ambulância (em `disabled_assets`, não carrega) | 12,4 MB | — substituição do veículo base | ❌ desconhecida | ❌ nenhuma |

A pasta não tem README, LICENSE nem `author` no `fxmanifest.lua`. Os nomes e as
marcas que aparecem aos jogadores estão em `qb-core/shared/vehicles.lua:411,469,470`.

⚠️ **Por resolver:** `data/Harley_davidson/vehicles.meta` é o `vehicles.meta`
completo do jogo base (298 veículos) em vez de só a mota — sinal de repack — e
declara `hexer` **duas vezes**, com definições diferentes (a primeira entrada tem
`LAYOUT_LOW` e `NINEF_COVER_OFFSET_INFO`, restos do 9F).

### Mapas

| Pack | Tamanho | Origem | Licença |
|---|---:|---|---|
| `[maps]/mapa_illegal_mechanic` | 10,4 MB | ⚠️ **MoreoDesign** (`author` no fxmanifest, ficheiros `moreo_*`) — estúdio que vende mapas | ❌ nenhuma. **Confirmar como foi obtido** |

---

## Risco médio — origem desconhecida

| Pack | Tamanho | O que se sabe |
|---|---:|---|
| `[maps]/postal_map` (stream) | 41,2 MB | Tiles de minimapa com códigos postais. ❌ Sem origem. O README do recurso documenta só o script de zoom |
| `[maps]/mapa_lostmc` | 12,4 MB | Ficheiros `cclosp_*`. ❌ Sem autor |
| `[maps]/mapa_vagos` | 10,0 MB | `vagos_shell`, `vagos_swiatla` ("luzes" em polaco). ❌ Sem autor |
| `[maps]/paleto_police` | 7,6 MB | `v_47_*`, `cs1_16_police_building`. ❌ Sem autor |
| `[maps]/mapa_ballas` | 6,8 MB | `ballas1756`, `lestnica`/`graffity` (transliteração russa). ❌ Sem autor |
| `[maps]/mapa-families` | 2,6 MB | `mlo_interior_grove_st`, `puertas_*`. ❌ Sem autor |
| `[standalone]/interact-sound` (87 `.ogg`) | 9,4 MB | ✅ O script é MIT (Scott Plunkett, 2017), mas **a licença não cobre o áudio**. Há `purge.ogg` e `hobbs1-9.ogg`, nomes que sugerem material de filmes ou séries |
| `[qb]/qb-policejob/html/vcr-ocd.ttf` | 0,07 MB | Fonte VCR OSD Mono. ⚠️ Sem ficheiro de licença no repo |

### `[defaultmaps]/hospital_map` — 2,9 MB

✅ Origem e licença documentadas: [forum.cfx.re](https://forum.cfx.re/t/interior-map-pillbox-medical-center-top-floor/949788),
licença em `license.md`.

⚠️ **Atenção:** é a *NoFreeRide License* (Lorenc95, 2025), que **restringe o uso
comercial**. Se o servidor passar a ter donativos, VIP ou qualquer receita, a
cláusula tem de ser lida com atenção.

---

## Risco baixo — origem e licença claras

| Pack | Tamanho | Origem | Licença |
|---|---:|---|---|
| `[qb]/qb-interior` | 54,3 MB | ✅ **K4MB1 Starter Shells Pack** — [k4mb1maps.com](https://www.k4mb1maps.com/), catálogo em `k4mb1shellstarter.pdf`. Distribuído com o qb-interior oficial | ✅ GPL-3 (código do recurso) |
| `[defaultmaps]/[prison_map]` | 17,7 MB | ✅ [gta5-mods](https://www.gta5-mods.com/maps/prison-3-mlo-interiors-bolingbroke-penitentiary-fivem-ragemp), ficheiros `desertos_*` (criador "Desertos"). README credita expressamente | ⚠️ Termos do gta5-mods |
| `[defaultmaps]/dealer_map` | 14,2 MB | ✅ **Patoche** — [listagem original](https://www.gta5-mods.com/maps/car-dealer-fivem-sp-ready). Autorizou expressamente o uso pelo QBCore na receita txAdmin | ✅ Autorização documentada no README |
| `[standalone]/bob74_ipl` | 2,4 MB | ✅ **Bob74**, v2.6.0 | ✅ MIT |
| `qb-radialmenu`, `qb-hud`, `qb-smallresources`, `menuv`, `qb-mechanicjob` | ~3,1 MB | ✅ Upstream QBCore / MenuV | ✅ Do respetivo recurso |
| `ox_lib/web/build/fonts` (32 `.ttf`) | — | ✅ Família **Roboto** | ✅ Apache 2.0 |
| `[cfx-default]` | — | ✅ Vem com o artifact do FXServer | ✅ Cfx.re |

---

## Imagens de marca substituídas

Em 2026-09-20 foram substituídas por alternativas sem marca, desenhadas de raiz:

| Ficheiro | O que era |
|---|---|
| `qb-phone/html/img/apps/whatsapp-chat.png` | Papel de parede oficial do WhatsApp, com o logótipo no padrão |
| `qb-phone/html/img/apps/whatsapp-chatlight.png` | O mesmo, em versão clara (não é referenciado por nenhum CSS) |
| `qb-radio/html/img/radio.png` | Fotografia de um rádio portátil real, com o logótipo Motorola visível e o nome da marca tapado com "qbcore" |
| `qb-radio/html/img/radio_no_logo.png` | A mesma fotografia (diferia em 0,6% dos pixels) |

---

## Notas de arrumação

- `qb-phone/html/img/apps/bank-logo.png` é byte-a-byte igual a
  `backgrounds/planta-bg.png` (md5 `7be05353857540f8c4a8fb5fbf709fbb`): 3,56 MB
  duplicados, e o "logótipo do banco" é na verdade o wallpaper do servidor.
- `menuv/templates/template.psd` são 10,75 MB de ficheiro-fonte do Photoshop.

## Como manter isto

Sempre que entrar um pack novo, acrescenta aqui uma linha com a origem, o link e
a licença **antes** de o pôr no servidor. Se for pago, guarda o comprovativo de
compra junto ao arquivo dos assets.
