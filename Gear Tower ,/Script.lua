local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local mapManagerRemote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("mapManagerRemote")

local Window = WindUI:CreateWindow({
    Title = "Gear Tower Hub",
    Icon = "gamepad",
    Author = "Programming Expert",
    Folder = "GearTowerConfig",
    Size = UDim2.fromOffset(550, 420),
    Theme = "Dark",
    Transparent = true
})

local MainTab = Window:Tab({
    Title = "Main Features",
    Icon = "home"
})

local ToolsSection = MainTab:Section({
    Title = "Tools & Weapons"
})

ToolsSection:Button({
    Title = "Get Hyper Laser Gun",
    Desc = "Instantly grants you the Hyper Laser Gun in-game",
    Callback = function()
        local args = {"claimTool", "Hyper Laser Gun"}
        mapManagerRemote:FireServer(unpack(args))
        
        WindUI:Notify({
            Title = "Success",
            Content = "Hyper Laser Gun has been obtained!",
            Duration = 3
        })
    end
})

ToolsSection:Button({
    Title = "Get Rainbow Carpet",
    Desc = "Instantly grants you the Rainbow Carpet in-game",
    Callback = function()
        local args = {"claimTool", "Rainbow Carpet"}
        mapManagerRemote:FireServer(unpack(args))
        
        WindUI:Notify({
            Title = "Success",
            Content = "Hyper Laser Gun has been obtained!",
            Duration = 3
        })
    end
})

ToolsSection:Button({
    Title = "Get Rainbow Slap",
    Desc = "Automatically grants you the Rainbow Slap tool, (TEST)",
    Callback = function()
        local args = {"claimTool", "Rainbow Slap"}
        mapManagerRemote:FireServer(unpack(args))
        
        WindUI:Notify({
            Title = "Success",
            Content = "Whirlpool Slap has been obtained!",
            Duration = 3
        })
    end
})

ToolsSection:Button({
    Title = "Get Whirlpool Slap",
    Desc = "Automatically grants you the Whirlpool Slap tool",
    Callback = function()
        local args = {"claimTool", "Whirlpool Slap"}
        mapManagerRemote:FireServer(unpack(args))
        
        WindUI:Notify({
            Title = "Success",
            Content = "Whirlpool Slap has been obtained!",
            Duration = 3
        })
    end
})

local AdminSection = MainTab:Section({
    Title = "Admin & Coins"
})

AdminSection:Button({
    Title = "Activate Mod Admin",
    Desc = "Activate Mod permissions for free",
    Callback = function()
        local args = {"buyAdmin", "Mod", 0}
        mapManagerRemote:FireServer(unpack(args))
        
        WindUI:Notify({
            Title = "Success",
            Content = "Mod rank activated successfully!",
            Duration = 3
        })
    end
})

AdminSection:Button({
    Title = "Get 8K Free Coins",
    Desc = "Add 8,000 coins to your in-game balance",
    Callback = function()
        local args = {"claimCoins", "8kCoinsGiver"}
        mapManagerRemote:FireServer(unpack(args))
        
        WindUI:Notify({
            Title = "Success",
            Content = "8,000 coins added successfully!",
            Duration = 3
        })
    end
})

local QuickSection = MainTab:Section({
    Title = "Quick Actions"
})

QuickSection:Button({
    Title = "Activate All Features 🚀",
    Desc = "Executes all the above commands sequentially automatically",
    Callback = function()
        mapManagerRemote:FireServer(unpack({"claimTool", "Hyper Laser Gun"}))
        task.wait(0.1)
        mapManagerRemote:FireServer(unpack({"claimTool", "Whirlpool Slap"}))
        task.wait(0.1)
        mapManagerRemote:FireServer(unpack({"buyAdmin", "Mod", 0}))
        task.wait(0.1)
        mapManagerRemote:FireServer(unpack({"claimCoins", "8kCoinsGiver"}))
        
        WindUI:Notify({
            Title = "Global Success",
            Content = "All tools and coins have been successfully activated!",
            Duration = 4
        })
    end
})
