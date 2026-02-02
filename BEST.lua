-- проверяем вайтлист
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local whitelist = {
    "C017884D-908B-4482-ACDB-2E4A3C1476CF",
    "415F92CD-908A-464C-9123-9CFD3ECE330E",
    "ADC447EF-9C8A-4A4E-966C-220FE03C8F4F"
}

local valid = false
for _, allowed_hwid in ipairs(whitelist) do
    if allowed_hwid == hwid then
        valid = true
        break
    end
end

if valid then
    print('You are in whitelist!')
    
    -- [ИСПРАВЛЕНО]: Убрано 'refs/heads/' из всех ссылок
    
    -- Запускаем логгер (с защитой от ошибок pcall)
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/wartycoon/main/logger.lua", true))()
    end)
    
    -- Фоновый цикл (BEST2)
    local function backgroundLoop()
        while true do
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/kick/main/BEST2.lua", true))()
            end)
            task.wait(10)
        end
    end
    spawn(backgroundLoop)
    
    -- Остальные скрипты (ссылки исправлены)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/rpgAircraft/main/easy.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/rpg/main/easy.lua"))()
    
    -- Эти ссылки и так были рабочие
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    
    -- Ссылка исправлена
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/infammo/main/infammo.lua"))()
    
    pcall(function() 
        game:GetService("ReplicatedStorage").ACS_Engine.Events.FDMG:Destroy() 
    end)

else
    game.Players.LocalPlayer:Kick("Not whitelisted")
end
