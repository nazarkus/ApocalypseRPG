-- проверяем вайтлист
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local whitelist = {
    "C017884D-908B-4482-ACDB-2E4A3C1476CF"
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
    
     --если в вайтлисте - запускаем скрипты
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/wartycoon/refs/heads/main/logger.lua", true))()
    
    local function backgroundLoop()
        while true do
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/kick/refs/heads/main/BEST2.lua", true))()
            task.wait(10)
        end
    end
    spawn(backgroundLoop)
    
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/rpgAircraft/refs/heads/main/easy.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/rpg/refs/heads/main/easy.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/infammo/refs/heads/main/infammo.lua"))()
    pcall(function() 
        game:GetService("ReplicatedStorage").ACS_Engine.Events.FDMG:Destroy() 
    end)

else
    game.Players.LocalPlayer:Kick("Not whitelisted")
end
