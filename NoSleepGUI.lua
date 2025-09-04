-- =========================
-- No Sleep GUI for Steal A Brainrot (Ultimate Version)
-- Features: Rainbow GUI, Resizable, Movable, Speed (max 48), Player ESP, Brainrot ESP, Base Timer ESP, Rainbow Platform, Go Through Bases
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
local goThroughBasesEnabled = false

-- =========================
-- GUI CREATION
-- =========================
local gui = player:WaitForChild("PlayerGui"):FindFirstChild("NoSleepGUI") or Instance.new("ScreenGui")
gui.Name = "NoSleepGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 280)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui

-- =========================
-- Make GUI Resizable
-- =========================
do
    local resizer = Instance.new("Frame")
    resizer.Size = UDim2.new(0, 15, 0, 15)
    resizer.Position = UDim2.new(1, -15, 1, -15)
    resizer.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    resizer.AnchorPoint = Vector2.new(1,1)
    resizer.Parent = frame
    resizer.Cursor = "SizeNWSE"
    
    local dragging = false
    resizer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    resizer.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = player:GetMouse()
            local newWidth = math.clamp(mouse.X - frame.AbsolutePosition.X, 200, 800)
            local newHeight = math.clamp(mouse.Y - frame.AbsolutePosition.Y, 150, 600)
            frame.Size = UDim2.new(0,newWidth,0,newHeight)
        end
    end)
end

-- =========================
-- Rainbow GUI effect
-- =========================
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

-- =========================
-- Buttons
-- =========================
local function createButton(text, positionY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,30)
    btn.Position = UDim2.new(0,10,0,positionY)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = frame
    return btn
end

local togglePlayerESP = createButton("Player ESP: ON", 90)
local togglePlatform = createButton("Rainbow Platform: OFF", 130)
local toggleGoThrough = createButton("Go Through Bases: OFF", 170)

-- =========================
-- Button Callbacks
-- =========================
togglePlayerESP.MouseButton1Click:Connect(function()
    playerESPEnabled = not playerESPEnabled
    togglePlayerESP.Text = "Player ESP: "..(playerESPEnabled and "ON" or "OFF")
end)

togglePlatform.MouseButton1Click:Connect(function()
    platformEnabled = not platformEnabled
    togglePlatform.Text = "Rainbow Platform: "..(platformEnabled and "ON" or "OFF")
end)

toggleGoThrough.MouseButton1Click:Connect(function()
    goThroughBasesEnabled = not goThroughBasesEnabled
    toggleGoThrough.Text = "Go Through Bases: "..(goThroughBasesEnabled and "ON" or "OFF")
end)

-- =========================
-- Slider input
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
-- PLATFORM & GO THROUGH BASES LOGIC
-- =========================
local platformPart = nil
spawn(function()
    local hue = 0
    while true do
        local char = player.Character
        if platformEnabled and char and char:FindFirstChild("HumanoidRootPart") then
            if not platformPart then
                platformPart = Instance.new("Part")
                platformPart.Size = Vector3.new(6,0.5,6)
                platformPart.Anchored = true
                platformPart.CanCollide = true
                platformPart.Material = Enum.Material.Neon
                platformPart.Parent = workspace
            end
            hue = hue + 0.01
            if hue > 1 then hue = 0 end
            platformPart.Color = Color3.fromHSV(hue,1,1)
            platformPart.Position = char.HumanoidRootPart.Position - Vector3.new(0,2,0)
        else
            if platformPart then
                platformPart:Destroy()
                platformPart = nil
            end
        end
        wait(0.03)
    end
end)

spawn(function()
    while true do
        if goThroughBasesEnabled then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name:lower():find("laser") then
                    part.CanCollide = false
                end
            end
        else
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name:lower():find("laser") then
                    part.CanCollide = true
                end
            end
        end
        wait(0.1)
    end
end)

-- =========================
-- ESP FOLDER
-- =========================
local espFolder = Instance.new("Folder")
espFolder.Name = "NoSleepESP"
espFolder.Parent = player:WaitForChild("PlayerGui")

-- =========================
-- PLAYER ESP
-- =========================
local function createESPForPlayer(targetPlayer)
    if targetPlayer == player then return end
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = targetPlayer.Character.HumanoidRootPart

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,150,0,70)
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
game.Players.PlayerAdded:Connect(createESPForPlayer)

-- =========================
-- BRAINROT ESP
-- =========================
local brainrotFolders = {"IgnoreBrainrots", "Brainrot God", "Brainrots", "BrainrotName"}

local function createESPForBrainrot(br)
    if not br:IsA("BasePart") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,150,0,50)
    billboard.Adornee = br
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0,255,0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Text = br.Name.." | Cost: "..(br:FindFirstChild("Value") and br.Value.Value or 0)
    label.Parent = billboard

    RunService.RenderStepped:Connect(function()
        if br.Parent then
            billboard.Adornee = br
        else
            billboard:Destroy()
        end
    end)
end

for _, folderName in pairs(brainrotFolders) do
    local folder = workspace:FindFirstChild(folderName)
    if folder then
        for _, br in pairs(folder:GetChildren()) do
            createESPForBrainrot(br)
        end
        folder.ChildAdded:Connect(createESPForBrainrot)
    end
end

-- =========================
-- BASE TIMER ESP
-- =========================
local timerFolder = workspace:FindFirstChild("TimerGui")
if timerFolder and timerFolder:FindFirstChild("Timer") then
    local timerObj = timerFolder.Timer
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,150,0,50)
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
        else
            billboard:Destroy()
        end
    end)
end
