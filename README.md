Planta RP

Servidor de GTA RP

A ideia e deixar o servidor ao mais alto nivel e totalmente funcional

## Testes unitarios (Lua)

Foi adicionada uma base inicial de testes unitarios para scripts Lua.
Agora a suite inclui validacao automatica para todos os scripts Lua em `resources/`.

### Como executar

1. Instale o Lua 5.4+ e garanta que o comando `lua` esteja no PATH.
2. Na raiz do projeto, execute:

```powershell
powershell -ExecutionPolicy Bypass -File tests/run-lua-tests.ps1
```

### Estrutura

- `tests/lua/test_runner.lua`: executa todas as suites registradas.
- `tests/lua/unit/qb-weapons/aiming_logic_spec.lua`: testes da logica de mira (`qb-weapons`).
- `tests/lua/unit/all-resources/lua_syntax_spec.lua`: valida sintaxe de todos os arquivos `.lua` do servidor (com sanitizacao dos hash literals do FiveM).
- `tests/lua/.generated_lua_files.txt`: lista gerada automaticamente com todos os arquivos Lua de `resources/`.
- `tests/lua/.generated_test_suites.txt`: lista gerada automaticamente com todas as suites `*_spec.lua`.
- `tests/lua/reports/cfx-parser-mismatches.txt`: relatorio automatico dos trechos com sintaxe estendida Cfx/FiveM ignorados na validacao com Lua stock.

### Proximo passo sugerido

Extrair mais regras de negocio para modulos puros (sem nativos FiveM) e adicionar novas suites especificas por recurso em `tests/lua/unit/`.
