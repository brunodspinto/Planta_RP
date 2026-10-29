/**
 * Translations utility for QB-Multicharacter
 * Handles all translation functionality in one place
 */

class TranslationManager {
    constructor() {
        this.translations = {};
        this.fallbacks = {
            // Textos de recurso (pt-PT): só aparecem quando a chave não vem do locale do servidor.
            // As chaves de erro e validação não existem no en.lua, por isso saem sempre daqui.
            deletechar_description: "Tens a certeza de que queres apagar esta personagem?",
            confirm: "Confirmar",
            cancel: "Cancelar",
            chardel_header: "Registo de personagem",
            firstname: "Nome",
            lastname: "Apelido",
            nationality: "Nacionalidade",
            birthdate: "Data de nascimento",
            gender: "Género",
            male: "Homem",
            female: "Mulher",
            create_button: "Criar personagem",
            retrieving_playerdata: "A obter os dados do jogador...",
            validating_playerdata: "A validar os dados do jogador...",
            retrieving_characters: "A obter as personagens...",
            validating_characters: "A validar as personagens...",
            ran_into_issue: "Ocorreu um problema!",
            profanity: "Os dados que escreveste têm palavrões. Tenta outra vez.",
            forgotten_field: "Esqueceste-te de preencher um campo!",
            connection_error: "Erro de ligação. Tenta outra vez.",
            delete_failed: "Não foi possível apagar a personagem. Tenta outra vez.",
            selection_failed: "Não foi possível escolher a personagem. Tenta outra vez.",
            creation_failed: "Não foi possível criar a personagem. Tenta outra vez.",
            setup_failed: "Não foi possível carregar as personagens. Tenta outra vez.",

            // Chaves de validação
            firstname_too_short: "O nome tem de ter pelo menos 2 caracteres.",
            firstname_too_long: "O nome não pode ter mais de 16 caracteres.",
            lastname_too_short: "O apelido tem de ter pelo menos 2 caracteres.",
            lastname_too_long: "O apelido não pode ter mais de 16 caracteres.",
            invalid_date: "Indica uma data de nascimento válida.",
            date: "Data de nascimento",
            field: "Campo",
        };
    }

    /**
     * Set translations from server
     * @param {Object} translations - Translation key-value pairs
     */
    setTranslations(translations) {
        this.translations = translations || {};
    }

    /**
     * Get translation for a key
     * @param {string} key - Translation key
     * @returns {string} Translated text or fallback
     */
    translate(key) {
        // First check in server-provided translations
        if (this.translations[key]) {
            return this.translations[key];
        }

        // Then check in fallbacks
        if (this.fallbacks[key]) {
            return this.fallbacks[key];
        }

        // Return the key itself if no translation found
        return key;
    }

    /**
     * Format a translation with dynamic values
     * @param {string} key - Translation key
     * @param {Object} params - Object containing replacement values
     * @returns {string} Formatted translation
     */
    formatTranslation(key, params) {
        let text = this.translate(key);

        if (params) {
            Object.keys(params).forEach((param) => {
                text = text.replace(`{${param}}`, params[param]);
            });
        }

        return text;
    }
}

// Create a global instance for the application
const translationManager = new TranslationManager();
