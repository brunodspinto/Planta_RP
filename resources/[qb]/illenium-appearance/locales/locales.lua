Locales = {}

function _L(key)
    local lang = GetConvar("illenium-appearance:locale", "en")
    
    -- Função interna para navegar na tabela sem crashar
    local function getFromTable(t, k)
        for part in k:gmatch("[^.]+") do
            if t and type(t) == "table" then
                t = t[part]
            else
                return nil
            end
        end
        return t
    end

    -- 1. Tenta no idioma selecionado (ex: pt-PT)
    local result = getFromTable(Locales[lang], key)

    -- 2. Se não encontrou, tenta no Inglês (Fallback)
    if not result and lang ~= "en" then
        result = getFromTable(Locales["en"], key)
    end

    -- 3. Se ainda assim não existe, retorna a chave vazia e avisa
    if not result then
        print("^1[illenium-appearance] Tradução em falta: " .. key .. " (Idioma: " .. lang .. ")^7")
        return ""
    end

    return result
end