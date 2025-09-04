-- =========================
-- NoSleep GUI for Steal A Brainrot
-- Features: Rainbow GUI, Movable, Speed (max 48), Ceiling-Safe Inf Jump, Player ESP, Brainrot ESP (highest), Base Timer ESP, Rainbow Platform, Go Through Bases
-- =========================

local MAX_SPEED = 48
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local desiredSpeed = 16
local speedEnabled = true
local playerESPEnabled = true
local infJumpEnabled = false
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
frame.Size = UDim2.new(0, 300, 0, 240)
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
-- TOGGLES
-- =========================
local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,30)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Text = name..": OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        local on = btn.Text:find("OFF")
        btn.Text = name..": "..(on and "ON" or "OFF")
        callback(on)
    end)
    return btn
end

local playerESPBtn = createToggle("Player ESP", 90, function(on) playerESPEnabled = on end)
local infJumpBtn = createToggle("Inf Jump", 130, function(on) infJumpEnabled = on end)
local platformBtn = createToggle("Platform", 170, function(on) platformEnabled = on end)
local goThroughBtn = createToggle("Go Through Bases", 210, function(on) goThroughBasesEnabled = on end)

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
-- PLATFORM MOVEMENT
-- =========================
local platformPart
spawn(function()
    while true do
        if platformEnabled then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                if not platformPart then
                    platformPart = Instance.new("Part")
                    platformPart.Size = Vector3.new(6,0.5,6)
                    platformPart.Anchored = true
                    platformPart.CanCollide = true
                    platformPart.Material = Enum.Material.Neon
                    platformPart.Color = Color3.fromHSV(tick()%5/5,1,1)
                    platformPart.Parent = workspace
                end
                platformPart.Position = char.HumanoidRootPart.Position - Vector3.new(0,2,0)
            else
                if platformPart then
                    platformPart:Destroy()
                    platformPart = nil
                end
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
-- GO THROUGH BASES / NO-CLIP
-- =========================
spawn(function()
    while true do
        if goThroughBasesEnabled then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        else
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        wait(0.1)
    end
end)

-- =========================
-- INF JUMP
-- =========================
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- =========================
-- PLAYER ESP
-- =========================
local espFolder = Instance.new("Folder")
espFolder.Name = "NoSleepESP"
espFolder.Parent = player:WaitForChild("PlayerGui")

local function createESPForPlayer(targetPlayer)
    if targetPlayer == player then return end
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = targetPlayer.Character.HumanoidRootPart

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,200,0,50)
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
    label.Font = Enum.Font.SourceSansBold
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
-- BRAINROT ESP (highest value)
-- =========================
local brainrotFolders = {"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}

local function createESPForBrainrot(br)
    if not br:IsA("BasePart") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,200,0,40)
    billboard.Adornee = br
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0,255,0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Text = br.Name.." | "..(br:FindFirstChild("Value") and br.Value.Value or 0)
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
        local highest
        for _, br in pairs(folder:GetChildren()) do
            if br:FindFirstChild("Value") then
                if not highest or br.Value.Value > highest.Value.Value then
                    highest = br
                end
            end
        end
        if highest then
            createESPForBrainrot(highest)
        end
        folder.ChildAdded:Connect(function(child)
            if child:FindFirstChild("Value") then
                createESPForBrainrot(child)
            end
        end)
    end
end

-- =========================
-- BASE TIMER ESP
-- =========================
local timerFolder = workspace:FindFirstChild("TimerGui")
if timerFolder and timerFolder:FindFirstChild("Timer") then
    local timerObj = timerFolder.Timer
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,200,0,40)
    billboard.Adornee = timerObj
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
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
