-- prp-anticheat: tabela de bans persistente.
-- Aplicado automaticamente no arranque do recurso (server/bans.lua).
CREATE TABLE IF NOT EXISTS `prp_anticheat_bans` (
    `id`         INT AUTO_INCREMENT PRIMARY KEY,
    `license`    VARCHAR(60)  DEFAULT NULL,
    `steam`      VARCHAR(50)  DEFAULT NULL,
    `discord`    VARCHAR(50)  DEFAULT NULL,
    `fivem`      VARCHAR(50)  DEFAULT NULL,
    `ip`         VARCHAR(50)  DEFAULT NULL,
    `reason`     TEXT,
    `banned_at`  DATETIME    DEFAULT CURRENT_TIMESTAMP,
    `expires_at` DATETIME    DEFAULT NULL, -- NULL = permanente
    `banned_by`  VARCHAR(80) DEFAULT 'system',
    INDEX `idx_license` (`license`),
    INDEX `idx_steam`   (`steam`),
    INDEX `idx_discord` (`discord`),
    INDEX `idx_fivem`   (`fivem`),
    INDEX `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
