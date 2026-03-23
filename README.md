# Planta RP

Servidor FiveM focado em roleplay com base QBCore, incluindo recursos essenciais de economia, empregos, criminalidade, habitação, voz e administração.

## Visão Geral

O projeto está organizado para rodar com txAdmin + FiveM Artifact, com stack principal em Lua e banco MySQL via oxmysql.

Principais blocos:

- Núcleo QBCore e recursos oficiais
- Recursos de voz e interface
- Mapas personalizados
- Scripts próprios e standalone
- Base de testes em Lua para validação rápida

## Stack Técnica

- Plataforma: FiveM (FXServer)
- Framework: QBCore
- Linguagem principal: Lua
- Banco de dados: MySQL (oxmysql)
- Voz: pma-voice
- Biblioteca utilitária: ox_lib

## Estrutura do Projeto

~~~text
resources/
	[qb]/            # Recursos do ecossistema QBCore
	[standalone]/    # Recursos independentes
	[voice]/         # Recursos de voz
	[maps]/          # Mapas customizados
	[defaultmaps]/   # Mapas base e complementares
	[cars]/          # Conteúdo de veículos
	[meus-scripts]/  # Scripts próprios

tests/
	run-lua-tests.ps1
	lua/
		test_runner.lua
		unit/
		reports/

server.cfg          # Configuração principal do servidor
~~~

## Requisitos

- Windows com PowerShell 5.1+
- FiveM Artifact atualizado
- txAdmin
- MySQL/MariaDB acessível
- Lua 5.4+ no PATH (para rodar testes)

## Configuração Inicial

1. Ajuste as variáveis principais no arquivo `server.cfg`:

- `endpoint_add_tcp` e `endpoint_add_udp`
- `sv_maxclients`
- `sv_hostname`, `sv_projectName`, `sv_projectDesc`
- `set mysql_connection_string`
- `sv_licenseKey`
- `steam_webApiKey`

2. Confirme os recursos que devem iniciar com `ensure`:

- Dependências: `ox_lib`, `qb-core`, `bob74_ipl`
- Grupos: `[qb]`, `[standalone]`, `[voice]`, `[defaultmaps]`, `[cars]`, `[maps]`
- Extras: `ps-adminmenu`, `simple-repair`, `illenium-appearance`

3. Revise permissões e principals:

- ACL para `group.admin`
- Herança de permissões (`qbcore.god`, `qbcore.admin`, `qbcore.mod`)
- Identificadores de donos/admins

## Executar o Servidor

Com txAdmin, use o perfil deste projeto e garanta que o caminho aponta para a raiz onde está o `server.cfg`.

Também é recomendado manter backups de configuração (exemplo: `server.cfg.bkp`) antes de alterações sensíveis.

## Testes Lua

Existe uma base de testes para validar sintaxe e suites unitárias em Lua.

### Como executar

~~~powershell
powershell -ExecutionPolicy Bypass -File tests/run-lua-tests.ps1
~~~

### O que o runner faz

- Verifica se existe interpretador Lua no PATH (ou fallback local)
- Gera lista de arquivos Lua de `resources/`
- Gera lista de suites em `tests/lua/unit`
- Executa o `tests/lua/test_runner.lua`
- Salva relatórios na pasta `tests/lua/reports`

## Convenções Operacionais

- Evite editar recursos diretamente na pasta `cache/files` (conteúdo regenerável)
- Faça alterações em `resources/` e mantenha versionamento limpo
- Sempre validar sintaxe Lua antes de subir para ambiente de produção
- Ao adicionar script novo, garantir ordem correta de `ensure` e dependências

## Segurança e Boas Práticas

- Não partilhar chaves de licença, API keys e connection strings reais
- Use credenciais por ambiente (desenvolvimento, homologação, produção)
- Restrinja permissões administrativas ao mínimo necessário
- Mantenha backups regulares de banco e arquivos críticos

## Créditos

- Cfx.re/FiveM
- Comunidade QBCore
