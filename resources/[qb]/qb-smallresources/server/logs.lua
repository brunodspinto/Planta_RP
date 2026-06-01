

local Webhooks = {
    ['default'] = '',
    ['testwebhook'] = '',
    ['playermoney'] = '',
    ['playerinventory'] = '',
    ['robbing'] = '',
    ['cuffing'] = '',
    ['drop'] = '',
    ['trunk'] = '',
    ['stash'] = '',
    ['glovebox'] = '',
    ['banking'] = '',
    ['vehicleshop'] = '',
    ['vehicleupgrades'] = '',
    ['shops'] = '',
    ['dealers'] = '',
    ['storerobbery'] = '',
    ['bankrobbery'] = '',
    ['powerplants'] = '',
    ['death'] = '',
    ['joinleave'] = '',
    ['ooc'] = '',
    ['report'] = '',
    ['me'] = '',
    ['pmelding'] = '',
    ['112'] = '',
    ['bans'] = '',
    ['anticheat'] = '',
    ['weather'] = '',
    ['moneysafes'] = '',
    ['bennys'] = '',
    ['bossmenu'] = '',
    ['robbery'] = '',
    ['casino'] = '',
    ['traphouse'] = '',
    ['911'] = '',
    ['palert'] = '',
    ['house'] = '',
    ['qbjobs'] = '',
}

-- Log category routing using server.cfg convars.
-- Priority order:
-- 1) DISCORD_WEBHOOK_LOG_<LOGNAME>
-- 2) DISCORD_WEBHOOK_<CATEGORY>
-- 3) DISCORD_WEBHOOK_DEFAULT
-- 4) Static values from this file (legacy fallback)
local LogCategoryByName = {
    ['anticheat'] = 'SECURITY',
    ['bans'] = 'SECURITY',
    ['death'] = 'SECURITY',
    ['joinleave'] = 'PLAYER_EVENTS',
    ['ooc'] = 'PLAYER_EVENTS',
    ['report'] = 'ADMIN',
    ['playermoney'] = 'ECONOMY',
    ['banking'] = 'ECONOMY',
    ['playerinventory'] = 'ECONOMY',
    ['vehicleshop'] = 'ECONOMY',
    ['bossmenu'] = 'ADMIN',
    ['house'] = 'RP_EVENTS',
    ['storerobbery'] = 'RP_EVENTS',
    ['bankrobbery'] = 'RP_EVENTS',
    ['qbjobs'] = 'RP_EVENTS',
    ['ps-adminmenu'] = 'ADMIN',
}

local function getWebhookConvar(name)
    return GetConvar(name, '')
end

local function buildSpecificLogConvar(logName)
    return 'DISCORD_WEBHOOK_LOG_' .. string.upper((logName or 'default'):gsub('[^%w]', '_'))
end

local function resolveWebhook(logName)
    local specificWebhook = getWebhookConvar(buildSpecificLogConvar(logName))
    if specificWebhook ~= '' then
        return specificWebhook
    end

    local category = LogCategoryByName[logName]
    if category then
        local categoryWebhook = getWebhookConvar('DISCORD_WEBHOOK_' .. category)
        if categoryWebhook ~= '' then
            return categoryWebhook
        end
    end

    local defaultWebhook = getWebhookConvar('DISCORD_WEBHOOK_DEFAULT')
    if defaultWebhook ~= '' then
        return defaultWebhook
    end

    if Webhooks[logName] and Webhooks[logName] ~= '' then
        return Webhooks[logName]
    end

    return Webhooks['default'] or ''
end

local colors = { -- https://www.spycolor.com/
    ['default'] = 14423100,
    ['blue'] = 255,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['white'] = 16777215,
    ['black'] = 0,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['pink'] = 16761035,
    ['lightgreen'] = 65309,
}

local logQueue = {}
local BrandName = GetConvar('DISCORD_LOGS_BRAND_NAME', 'Planta RP Logs')
local BrandIconUrl = GetConvar('DISCORD_LOGS_ICON_URL', '')

local function buildBrandAuthor()
    local author = {
        ['name'] = BrandName,
    }

    if BrandIconUrl ~= '' then
        author['icon_url'] = BrandIconUrl
    end

    return author
end

local function truncateForDiscord(value, maxLength)
    local text = tostring(value or '')
    if #text <= maxLength then
        return text
    end

    return text:sub(1, maxLength - 3) .. '...'
end

local function buildPsAdminmenuEmbed(title, message)
    local actionFromTitle = title and title:match('^Action Used:%s*(.+)$')

    local adminName, citizenId, usedAction, args = message:match('^(.-) %((.-)%) %- Used: ([^ ]+)%s+with args:%s*(.+)$')
    if not adminName then
        adminName, citizenId, usedAction = message:match('^(.-) %((.-)%) %- Used: ([^ ]+)$')
    end

    local action = actionFromTitle or usedAction or 'unknown'
    local safeAdminName = truncateForDiscord(adminName or 'unknown', 256)
    local safeCitizenId = truncateForDiscord(citizenId or 'unknown', 256)
    local safeAction = truncateForDiscord(action, 256)
    local safeArgs = args and ('```json\n' .. truncateForDiscord(args, 950) .. '\n```') or 'Sem argumentos'

    return {
        ['title'] = 'Painel Admin | Acao executada',
        ['color'] = colors['orange'],
        ['footer'] = {
            ['text'] = os.date('%d/%m/%Y %H:%M:%S'),
        },
        ['description'] = 'Uma acao foi executada via ps-adminmenu.',
        ['author'] = buildBrandAuthor(),
        ['fields'] = {
            {
                ['name'] = 'Acao',
                ['value'] = safeAction,
                ['inline'] = true,
            },
            {
                ['name'] = 'Admin',
                ['value'] = safeAdminName,
                ['inline'] = true,
            },
            {
                ['name'] = 'CitizenID',
                ['value'] = safeCitizenId,
                ['inline'] = true,
            },
            {
                ['name'] = 'Argumentos',
                ['value'] = safeArgs,
                ['inline'] = false,
            }
        }
    }
end

local function buildEmbed(name, title, color, message, imageUrl)
    if name == 'ps-adminmenu' and title and title:find('Action Used:', 1, true) == 1 then
        return buildPsAdminmenuEmbed(title, message)
    end

    return {
        ['title'] = title,
        ['color'] = colors[color] or colors['default'],
        ['footer'] = {
            ['text'] = os.date('%c'),
        },
        ['description'] = message,
        ['author'] = buildBrandAuthor(),
        ['image'] = imageUrl and imageUrl ~= '' and { ['url'] = imageUrl } or nil,
    }
end

RegisterNetEvent('qb-log:server:CreateLog', function(name, title, color, message, tagEveryone, imageUrl)
    local tag = tagEveryone or false

    if Config.Logging == 'discord' then
        if not Webhooks[name] then
            Webhooks[name] = ''
        end

        local webHook = resolveWebhook(name)
        if webHook == '' then
            print('No Discord webhook configured for log: ' .. tostring(name))
            return
        end

        local embedData = {
            buildEmbed(name, title, color, message, imageUrl)
        }

        if not logQueue[name] then logQueue[name] = {} end
        logQueue[name][#logQueue[name] + 1] = { webhook = webHook, data = embedData }

        if #logQueue[name] >= 10 then
            local postData = { username = BrandName, embeds = {} }
            if BrandIconUrl ~= '' then
                postData.avatar_url = BrandIconUrl
            end

            if tag then
                postData.content = '@everyone'
            end

            for i = 1, #logQueue[name] do postData.embeds[#postData.embeds + 1] = logQueue[name][i].data[1] end
            PerformHttpRequest(logQueue[name][1].webhook, function() end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })
            logQueue[name] = {}
        end
    elseif Config.Logging == 'fivemanage' then
        local FiveManageAPIKey = GetConvar('FIVEMANAGE_LOGS_API_KEY', 'false')
        if FiveManageAPIKey == 'false' then
            print('You need to set the FiveManage API key in your server.cfg')
            return
        end
        local extraData = {
            level = tagEveryone and 'warn' or 'info', -- info, warn, error or debug
            message = title,                          -- any string
            metadata = {                              -- a table or object with any properties you want
                description = message,
                playerId = source,
                playerLicense = GetPlayerIdentifierByType(source, 'license'),
                playerDiscord = GetPlayerIdentifierByType(source, 'discord')
            },
            resource = GetInvokingResource(),
        }
        PerformHttpRequest('https://api.fivemanage.com/api/logs', function(statusCode, response, headers)
            -- Uncomment the following line to enable debugging
            -- print(statusCode, response, json.encode(headers))
        end, 'POST', json.encode(extraData), {
            ['Authorization'] = FiveManageAPIKey,
            ['Content-Type'] = 'application/json',
        })
    end
end)

Citizen.CreateThread(function()
    local timer = 0
    while true do
        Wait(1000)
        timer = timer + 1
        if timer >= 60 then -- If 60 seconds have passed, post the logs
            timer = 0
            for name, queue in pairs(logQueue) do
                if #queue > 0 then
                    local postData = { username = BrandName, embeds = {} }
                    if BrandIconUrl ~= '' then
                        postData.avatar_url = BrandIconUrl
                    end
                    for i = 1, #queue do
                        postData.embeds[#postData.embeds + 1] = queue[i].data[1]
                    end
                    PerformHttpRequest(queue[1].webhook, function() end, 'POST', json.encode(postData), { ['Content-Type'] = 'application/json' })
                    logQueue[name] = {}
                end
            end
        end
    end
end)

QBCore.Commands.Add('testwebhook', 'Test Your Discord Webhook For Logs (God Only)', {}, false, function()
    TriggerEvent('qb-log:server:CreateLog', 'testwebhook', 'Test Webhook', 'default', 'Webhook setup successfully')
end, 'god')
