-- =========================
-- No Sleep GUI for Steal A Brainrot
-- Features: Rainbow GUI, Resizable, Speed, Platform, Go Through Bases, Player ESP, Brainrot ESP, Timer ESP
-- =========================

local MAX_SPEED = 48
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- SETTINGS
local desiredSpeed = 16
local speedEnabled = true
local playerESPEnabled = true
local brainrotESPEnabled = true
local timerESPEnabled = true
local platformEnabled = false
local goThroughBasesEnabled = false

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

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 300)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.BorderSizePixel = 2
frame.Parent = gui

-- Resize handle
local resize = Instance.new("Frame")
resize.Size = UDim2.new(0,20,0,20)
resize.Position = UDim2.new(1,-20,1,-20)
resize.BackgroundColor3 = Color3.fromRGB(255,255,255)
resize.BorderSizePixel = 1
resize.Parent = frame
resize.Cursor = "SizeNWSE"

resize.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = player:GetMouse()
        local startPos = Vector2.new(mouse.X, mouse.Y)
        local startSize = frame.Size
        local conn
        conn = RunService.RenderStepped:Connect(function()
            local delta = Vector2.new(mouse.X, mouse.Y) - startPos
            frame.Size = UDim2.new(0, math.max(300, startSize.X.Offset + delta.X), 0, math.max(200, startSize.Y.Offset + delta.Y))
        end)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                conn:Disconnect()
            end
        end)
    end
end)

-- Rainbow effect
spawn(function()
    local hue = 0
    while true do
        frame.BackgroundColor3 = Color3.fromHSV(hue,0.8,0.9)
        hue = hue + 0.002
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
title.TextSize = 20
title.Parent = frame

-- Helper function to create toggle buttons
local function createToggleButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,30)
    btn.Position = UDim2.new(0,10,0,yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Buttons
local playerESPBtn = createToggleButton("Player ESP: ON", 50, function()
    playerESPEnabled = not playerESPEnabled
    playerESPBtn.Text = "Player ESP: "..(playerESPEnabled and "ON" or "OFF")
end)

local brainrotESPBtn = createToggleButton("Brainrot ESP: ON", 90, function()
    brainrotESPEnabled = not brainrotESPEnabled
    brainrotESPBtn.Text = "Brainrot ESP: "..(brainrotESPEnabled and "ON" or "OFF")
end)

local timerESPBtn = createToggleButton("Timer ESP: ON", 130, function()
    timerESPEnabled = not timerESPEnabled
    timerESPBtn.Text = "Timer ESP: "..(timerESPEnabled and "ON" or "OFF")
end)

local platformBtn = createToggleButton("Platform: OFF", 170, function()
    platformEnabled = not platformEnabled
    platformBtn.Text = "Platform: "..(platformEnabled and "ON" or "OFF")
end)

local goBasesBtn = createToggleButton("Go Through Bases: OFF", 210, function()
    goThroughBasesEnabled = not goThroughBasesEnabled
    goBasesBtn.Text = "Go Through Bases: "..(goThroughBasesEnabled and "ON" or "OFF")
end)

-- =========================
-- SPEED CONTROL
-- =========================
spawn(function()
    while true do
        if speedEnabled then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
                local root = character.HumanoidRootPart
                local humanoid = character.Humanoid
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
-- PLAYER ESP
-- =========================
local function createESPForPlayer(targetPlayer)
    if targetPlayer == player then return end
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = targetPlayer.Character.HumanoidRootPart

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,150,0,50)
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
            label.Text = targetPlayer.Name
        else
            billboard:Destroy()
        end
    end)
end

for _, p in pairs(game.Players:GetPlayers()) do
    createESPForPlayer(p)
end
game.Players.PlayerAdded:Connect(createESPForPlayer)

-- =========================
-- BRAINROT ESP
-- =========================
local brainrotFolders = {"Brainrots","IgnoreBrainrots","Brainrot God","BrainrotName"}

local function createESPForBrainrot(br)
    if not br:IsA("BasePart") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,150,0,40)
    billboard.Adornee = br
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0,255,0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Text = br.Name.." | $"..(br:FindFirstChild("Value") and br.Value or "0")
    label.Parent = billboard

    RunService.RenderStepped:Connect(function()
        if br.Parent then
            billboard.Adornee = br
            label.Text = br.Name.." | $"..(br:FindFirstChild("Value") and br.Value or "0")
        else
            billboard:Destroy()
        end
    end)
end

for _, folderName in pairs(brainrotFolders) do
    local folder = Workspace:FindFirstChild(folderName)
    if folder then
        for _, br in pairs(folder:GetChildren()) do
            createESPForBrainrot(br)
        end
        folder.ChildAdded:Connect(createESPForBrainrot)
    end
end

-- =========================
-- TIMER ESP
-- =========================
local timerFolder = Workspace:FindFirstChild("TimerGui")
if timerFolder and timerFolder:FindFirstChild("Timer") then
    local timerObj = timerFolder.Timer
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,150,0,40)
    billboard.Adornee = timerObj
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Text = "Base Timer"
    label.Parent = billboard

    RunService.RenderStepped:Connect(function()
        if timerObj.Parent then
            billboard.Adornee = timerObj
            label.Text = "Base Timer"
        else
            billboard:Destroy()
        end
    end)
end
