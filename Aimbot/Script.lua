-- Aimbot

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Settings = {
    AimbotEnabled = false,
    WallCheck = true,
    TargetPart = "Whole Body",
    Smoothness = 0.1,
    FovRadius = 150,
    FovVisible = false,
    
    EspEnabled = false,
    EspNames = false,
    EspDistance = false
}

local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "Persistent_FOV_System"
FOVGui.ResetOnSpawn = false

pcall(function()
    FOVGui.Parent = game:GetService("CoreGui")
end)
if not FOVGui.Parent then
    FOVGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local FOVFrame = Instance.new("Frame")
FOVFrame.BackgroundTransparency = 1
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Size = UDim2.fromOffset(Settings.FovRadius * 2, Settings.FovRadius * 2)
FOVFrame.Parent = FOVGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = FOVFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = FOVFrame

local Window = WindUI:CreateWindow({
    Title = "Universal Target & Visuals",
    Author = "By Gemini",
    Folder = "UniversalCheatSettings",
    Icon = "crosshair",
    IconSize = 24,
    Size = UDim2.fromOffset(500, 420),
    Transparent = false,
    Theme = "Dark",
    HideSearchBar = true,
    OpenButton = {
        Title = "Open Menu",
        Enabled = true,
        Draggable = true
    }
})

local AimTab = Window:Tab({ Title = "Aimbot", Icon = "target" })
local EspTab = Window:Tab({ Title = "ESP Visuals", Icon = "eye" })
local OtherTab = Window:Tab({
	Title = "Other Scripts",
	icon = "door open"

AimTab:Toggle({
    Title = "Enable Aimbot",
    Desc = "Locks camera onto targets inside FOV",
    Value = Settings.AimbotEnabled,
    Callback = function(state)
        Settings.AimbotEnabled = state
    end
})

AimTab:Toggle({
    Title = "Wall Check",
    Desc = "Ignore players behind walls/obstacles",
    Value = Settings.WallCheck,
    Callback = function(state)
        Settings.WallCheck = state
    end
})

AimTab:Toggle({
    Title = "Show FOV Circle",
    Desc = "Display the targeting zone ring",
    Value = Settings.FovVisible,
    Callback = function(state)
        Settings.FovVisible = state
    end
})

AimTab:Slider({
    Title = "FOV Radius",
    IsTooltip = true,
    IsTextbox = true,
    Value = { Min = 10, Max = 800, Default = 150, Step = 5 },
    Callback = function(val)
        Settings.FovRadius = tonumber(val)
    end
})

AimTab:Slider({
    Title = "Camera Smoothness",
    IsTooltip = true,
    IsTextbox = true,
    Value = { Min = 1, Max = 100, Default = 10, Step = 1 },
    Callback = function(val)
        Settings.Smoothness = tonumber(val) / 100
    end
})

AimTab:Dropdown({
    Title = "Target Bone/Part",
    Values = { "Whole Body", "Head", "Right Arm", "Left Arm", "Legs" },
    Value = "Whole Body",
    Callback = function(option)
        Settings.TargetPart = option
    end
})

EspTab:Toggle({
    Title = "Enable ESP",
    Desc = "Highlights enemy players through walls",
    Value = Settings.EspEnabled,
    Callback = function(state)
        Settings.EspEnabled = state
    end
})

EspTab:Toggle({
    Title = "Show Names",
    Desc = "Displays player usernames",
    Value = Settings.EspNames,
    Callback = function(state)
        Settings.EspNames = state
    end
})

EspTab:Toggle({
    Title = "Show Distance",
    Desc = "Displays player distance in studs",
    Value = Settings.EspDistance,
    Callback = function(state)
        Settings.EspDistance = state
    end
})

local function getTargetPart(character, selection)
    if not character then return nil end
    if selection == "Head" then
        return character:FindFirstChild("Head")
    elseif selection == "Right Arm" then
        return character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm")
    elseif selection == "Left Arm" then
        return character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm")
    elseif selection == "Legs" then
        return character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftLowerLeg") or character:FindFirstChild("Right Leg") or character:FindFirstChild("RightLowerLeg")
    else
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    end
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPart = getTargetPart(player.Character, Settings.TargetPart)
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if targetPart and humanoid and humanoid.Health > 0 then
                local passesWallCheck = true
                if Settings.WallCheck then
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                    
                    local origin = Camera.CFrame.Position
                    local direction = targetPart.Position - origin
                    local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
                    
                    if raycastResult then
                        passesWallCheck = false
                    end
                end
                
                if passesWallCheck then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                        local distanceToCenter = (screenPos2D - screenCenter).Magnitude
                        
                        if distanceToCenter <= Settings.FovRadius then
                            if distanceToCenter < shortestDistance then
                                shortestDistance = distanceToCenter
                                closestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

local espObjects = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    local function setupCharacter(character)
        if espObjects[player] then
            pcall(function() espObjects[player].Highlight:Destroy() end)
            pcall(function() espObjects[player].Billboard:Destroy() end)
        end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Enabled = Settings.EspEnabled
        highlight.Parent = character
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Billboard"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Enabled = Settings.EspEnabled
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeTransparency = 0
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextSize = 14
        textLabel.Text = ""
        textLabel.Parent = billboard
        
        local head = character:WaitForChild("Head", 5)
        if head then
            billboard.Adornee = head
            billboard.Parent = head
        end
        
        espObjects[player] = {
            Highlight = highlight,
            Billboard = billboard,
            Label = textLabel,
            Character = character
        }
    end
    
    if player.Character then setupCharacter(player.Character) end
    player.CharacterAdded:Connect(setupCharacter)
end

local function removeESP(player)
    if espObjects[player] then
        pcall(function() espObjects[player].Highlight:Destroy() end)
        pcall(function() espObjects[player].Billboard:Destroy() end)
        espObjects[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    FOVFrame.Visible = Settings.FovVisible and Settings.AimbotEnabled
    FOVFrame.Size = UDim2.fromOffset(Settings.FovRadius * 2, Settings.FovRadius * 2)
    
    if Settings.AimbotEnabled then
        local targetPlayer = getClosestPlayer()
        if targetPlayer and targetPlayer.Character then
            local targetPart = getTargetPart(targetPlayer.Character, Settings.TargetPart)
            if targetPart then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.Smoothness)
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    for player, esp in pairs(espObjects) do
        if esp.Character and esp.Character.Parent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = esp.Character:FindFirstChild("HumanoidRootPart")
            if rootPart and esp.Highlight and esp.Billboard and esp.Label then
                esp.Highlight.Enabled = Settings.EspEnabled
                esp.Billboard.Enabled = Settings.EspEnabled
                
                if Settings.EspEnabled then
                    local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
                    local textStr = ""
                    
                    if Settings.EspNames then
                        textStr = textStr .. player.Name
                    end
                    if Settings.EspDistance then
                        if textStr ~= "" then
                            textStr = textStr .. " [" .. distance .. "s]"
                        else
                            textStr = "[" .. distance .. "s]"
                        end
                    end
                    esp.Label.Text = textStr
                end
            end
        else
            removeESP(player)
        end
    end
end)

local GearTowerScButton = OtherTab:Button({
	title = "Gear Tower Script!",
	Desc = "Get All Items You Wants, Coins and admin!!",
	locked = false,
	Callback = function()
		loadstring(game:HttpGet("https://github.com/abd75x6v777/X-View-HUB/raw/refs/heads/main/Gear%20Tower%20,/Script.lua"))()
	end
})
