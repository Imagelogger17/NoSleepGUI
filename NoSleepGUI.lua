-- =========================
-- No Sleep GUI for Steal A Brainrot
-- Features: Rainbow GUI, Movable, Speed (max 48), Platform, Go Through Bases, Player ESP, Brainrot ESP, Base Timer ESP, Persistent GUI
-- =========================

local MAX_SPEED = 48
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local desiredSpeed = 16
local speedEnabled = true
local playerESPEnabled = true
local platformEnabled = false
local goBasesEnabled = false

-- ESP Folder
local espFolder = Instance.new("Folder")
espFolder.Name = "NoSleepESP"
espFolder.Parent = player:WaitForChild("PlayerGui")

-- =========================
-- GUI CREATION
-- =========================
local gui = player:WaitForChild("PlayerGui"):FindFirstChild("NoSleepGUI") or Instance.new("ScreenGui")
gui.Name = "NoSleepGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 280)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui

-- Rainbow GUI effect
spawn(function()
    local hue = 0
    while true do
        frame.BackgroundColor3 = Color3.fromHSV(hue,1,1)
        hue = hue + 0.005
        if hue > 1 then hue = 0 end
        wait(0.03)
    end
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.Text = "No Sleep GUI"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- =========================
-- SPEED SLIDER
-- =========================
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1,-20,0,40)
sliderFrame.Position = UDim2.new(0,10,0,40)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
sliderFrame.Parent = frame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(desiredSpeed/MAX_SPEED,0,1,0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
sliderFill.Parent = sliderFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1,0,0,20)
speedLabel.Position = UDim2.new(0,0,1,0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.Text = "Speed: "..desiredSpeed
speedLabel.Parent = frame

-- Player ESP Toggle
local togglePlayerESP = Instance.new("TextButton")
togglePlayerESP.Size = UDim2.new(1,-20,0,30)
togglePlayerESP.Position = UDim2.new(0,10,0,90)
togglePlayerESP.Text = "Player ESP: ON"
togglePlayerESP.TextColor3 = Color3.fromRGB(255,255,255)
togglePlayerESP.BackgroundColor3 = Color3.fromRGB(70,70,70)
togglePlayerESP.Font = Enum.Font.SourceSansBold
togglePlayerESP.TextSize = 16
togglePlayerESP.Parent = frame
togglePlayerESP.MouseButton1Click:Connect(function()
    playerESPEnabled = not playerESPEnabled
    togglePlayerESP.Text = "Player ESP: "..(playerESPEnabled and "ON" or "OFF")
end)

-- Platform Toggle
local togglePlatform = Instance.new("TextButton")
togglePlatform.Size = UDim2.new(1,-20,0,30)
togglePlatform.Position = UDim2.new(0,10,0,130)
togglePlatform.Text = "Platform: OFF"
togglePlatform.TextColor3 = Color3.fromRGB(255,255,255)
togglePlatform.BackgroundColor3 = Color3.fromRGB(70,70,70)
togglePlatform.Font = Enum.Font.SourceSansBold
togglePlatform.TextSize = 16
togglePlatform.Parent = frame
togglePlatform.MouseButton1Click:Connect(function()
    platformEnabled = not platformEnabled
    togglePlatform.Text = "Platform: "..(platformEnabled and "ON" or "OFF")
end)

-- Go Through Bases Toggle
local toggleBases = Instance.new("TextButton")
toggleBases.Size = UDim2.new(1,-20,0,30)
toggleBases.Position = UDim2.new(0,10,0,170)
toggleBases.Text = "Go Through Bases: OFF"
toggleBases.TextColor3 = Color3.fromRGB(255,255,255)
toggleBases.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggleBases.Font = Enum.Font.SourceSansBold
toggleBases.TextSize = 16
toggleBases.Parent = frame
toggleBases.MouseButton1Click:Connect(function()
    goBasesEnabled = not goBasesEnabled
    toggleBases.Text = "Go Through Bases: "..(goBasesEnabled and "ON" or "OFF")
end)

-- =========================
-- SLIDER INPUT
-- =========================
sliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local function updateSpeed(posX)
            local relativeX = math.clamp(posX - sliderFrame.AbsolutePosition.X,0,sliderFrame.AbsoluteSize.X)
            local ratio = relativeX / sliderFrame.AbsoluteSize.X
            desiredSpeed = math.floor(ratio*MAX_SPEED)
            sliderFill.Size = UDim2.new(ratio,0,1,0)
            speedLabel.Text = "Speed: "..desiredSpeed
        end
        updateSpeed(input.Position.X)
    end
end)

-- =========================
-- SPEED CONTROL
-- =========================
spawn(function()
    while true do
        if speedEnabled then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local root = char.HumanoidRootPart
                local humanoid = char.Humanoid
                local moveDirection = humanoid.MoveDirection
                if moveDirection.Magnitude > 0 then
                    root.Velocity = moveDirection*desiredSpeed + Vector3.new(0,root.Velocity.Y,0)
                end
            end
        end
        wait(0.03)
    end
end)

-- =========================
-- PLATFORM & RAINBOW
-- =========================
local platformPart
local hue = 0
spawn(function()
    while true do
        if platformEnabled then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                if not platformPart then
                    platformPart = Instance.new("Part")
                    platformPart.Size = Vector3.new(10,1,10)
                    platformPart.Anchored = true
                    platformPart.CanCollide = true
                    platformPart.Material = Enum.Material.Neon
                    platformPart.Parent = Workspace
                end

                platformPart.Color = Color3.fromHSV(hue,1,1)
                hue = hue + 0.005
                if hue > 1 then hue = 0 end

                platformPart.Position = char.HumanoidRootPart.Position - Vector3.new(0,3,0)
            end
        else
            if platformPart then
                platformPart:Destroy()
                platformPart = nil
            end
        end
        wait(0.03)
    end
end)

-- =========================
-- GO THROUGH BASES
-- =========================
spawn(function()
    while true do
        if goBasesEnabled then
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and string.find(part.Name:lower(),"laser") then
                    part.CanCollide = false
                    part.Transparency = 0.5
                end
            end
        else
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and string.find(part.Name:lower(),"laser") then
                    part.CanCollide = true
                    part.Transparency = 0
                end
            end
        end
        wait(0.1)
    end
end)

-- =========================
-- PLAYER ESP
-- =========================
local function createESPForPlayer(targetPlayer)
    if targetPlayer == player then return end
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = targetPlayer.Character.HumanoidRootPart

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,200,0,50) -- Bigger name
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,0,0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Text = targetPlayer.Name
    label.Parent = billboard

    RunService.RenderStepped:Connect(function()
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            billboard.Adornee = targetPlayer.Character.HumanoidRootPart
        else
            billboard:Destroy()
        end
    end)
end

for _, p in pairs(game.Players:GetPlayers()) do
    createESPForPlayer(p)
end

game.Players.PlayerAdded:Connect(function(p)
    createESPForPlayer(p)
end)

-- =========================
-- BRAINROT ESP (Highest value with cost)
-- =========================
local function createESPForBrainrot(br)
    if not br:IsA("BasePart") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,150,0,30)
    billboard.Adornee = br
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0,255,0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Text = br.Name.." | "..(br:FindFirstChild("Value") and br.Value.Value or 0).."$"
    label.Parent = billboard

    RunService.RenderStepped:Connect(function()
        if br.Parent then
            billboard.Adornee = br
        else
            billboard:Destroy()
        end
    end)
end

local brainrotFolders = {"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}
for _, folderName in pairs(brainrotFolders) do
    local folder = Workspace:FindFirstChild(folderName)
    if folder then
        for _, br in pairs(folder:GetChildren()) do
            createESPForBrainrot(br)
        end
        folder.ChildAdded:Connect(function(child)
            createESPForBrainrot(child)
        end)
    end
end

-- =========================
-- TIMER ESP
-- =========================
local timerFolder = Workspace:FindFirstChild("TimerGui")
if timerFolder and timerFolder:FindFirstChild("Timer") then
    local timerObj = timerFolder.Timer
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,150,0,30)
    billboard.Adornee = timerObj
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Text = "Base Timer: "..(timerObj:FindFirstChild("Time") and timerObj.Time.Value or 0)
    label.Parent = billboard

    RunService.RenderStepped:Connect(function()
        if timerObj.Parent then
            billboard.Adornee = timerObj
        else
            billboard:Destroy()
        end
    end)
end
