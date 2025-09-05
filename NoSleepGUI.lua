-- =========================
-- No Sleep GUI for Steal A Brainrot
-- Features: Rainbow GUI, Movable, Speed (max 48), Platform, Ceiling-Safe Inf Jump, Player ESP, Brainrot ESP (highest value), Base Timer ESP, Persistent GUI
-- =========================

local MAX_SPEED = 48
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local desiredSpeed = 16
local speedEnabled = true
local playerESPEnabled = true
local infJumpEnabled = false
local platformEnabled = false

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
frame.Size = UDim2.new(0, 300, 0, 300)
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
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1,-20,0,30)
toggleBtn.Position = UDim2.new(0,10,0,90)
toggleBtn.Text = "Player ESP: ON"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
toggleBtn.Parent = frame
toggleBtn.MouseButton1Click:Connect(function()
    playerESPEnabled = not playerESPEnabled
    toggleBtn.Text = "Player ESP: "..(playerESPEnabled and "ON" or "OFF")
end)

-- Infinite Jump Toggle
local infJumpBtn = Instance.new("TextButton")
infJumpBtn.Size = UDim2.new(1,-20,0,30)
infJumpBtn.Position = UDim2.new(0,10,0,130)
infJumpBtn.Text = "Infinite Jump: OFF"
infJumpBtn.TextColor3 = Color3.fromRGB(255,255,255)
infJumpBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
infJumpBtn.Font = Enum.Font.SourceSansBold
infJumpBtn.TextSize = 16
infJumpBtn.Parent = frame
infJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    infJumpBtn.Text = "Infinite Jump: "..(infJumpEnabled and "ON" or "OFF")
end)

-- Platform Toggle
local platformBtn = Instance.new("TextButton")
platformBtn.Size = UDim2.new(1,-20,0,30)
platformBtn.Position = UDim2.new(0,10,0,170)
platformBtn.Text = "Platform: OFF"
platformBtn.TextColor3 = Color3.fromRGB(255,255,255)
platformBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
platformBtn.Font = Enum.Font.SourceSansBold
platformBtn.TextSize = 16
platformBtn.Parent = frame
platformBtn.MouseButton1Click:Connect(function()
    platformEnabled = not platformEnabled
    platformBtn.Text = "Platform: "..(platformEnabled and "ON" or "OFF")
end)

-- Slider input
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
-- CEILING-SAFE NATURAL INFINITE JUMP
-- =========================
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local humanoid = char.Humanoid
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                -- Raycast upwards to check for ceiling
                local ray = Ray.new(root.Position, Vector3.new(0,3,0))
                local hitPart, hitPos = workspace:FindPartOnRay(ray, char)
                if hitPart then
                    -- Touch ceiling -> die
                    humanoid.Health = 0
                else
                    -- Safe jump
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
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
                    platformPart.Size = Vector3.new(6,1,6)
                    platformPart.Anchored = true
                    platformPart.CanCollide = true
                    platformPart.Material = Enum.Material.Neon
                    platformPart.Color = Color3.fromHSV(math.random(),1,1)
                    platformPart.Parent = workspace
                end
                local hrp = char.HumanoidRootPart
                platformPart.Position = hrp.Position - Vector3.new(0,3,0)
            elseif platformPart then
                platformPart:Destroy()
                platformPart = nil
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
-- PLAYER ESP
-- =========================
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
-- BRAINROT ESP (HIGHEST VALUE + COST)
-- =========================
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
    label.Text = br.Name.." $"..(br:FindFirstChild("Value") and br.Value.Value or "0")
    label.Parent = billboard

    RunService.RenderStepped:Connect(function()
        if br.Parent then
            billboard.Adornee = br
        else
            billboard:Destroy()
        end
    end)
end

workspace.ChildAdded:Connect(function(child)
    if child.Name == "Brainrots" then
        for _, br in pairs(child:GetChildren()) do
            createESPForBrainrot(br)
        end
        child.ChildAdded:Connect(function(br)
            createESPForBrainrot(br)
        end)
    end
end)

-- =========================
-- BASE TIMER ESP
-- =========================
local function createTimerESP(timerObj)
    if not timerObj:IsA("BasePart") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,120,0,30)
    billboard.Adornee = timerObj
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Text = "Base Timer: "..(timerObj:FindFirstChild("Time") and timerObj.Time.Value or "0")
    label.Parent = billboard

    RunService.RenderStepped:Connect(function()
        if timerObj.Parent then
            label.Text = "Base Timer: "..(timerObj:FindFirstChild("Time") and timerObj.Time.Value or "0")
        else
            billboard:Destroy()
        end
    end)
end

local timerFolder = workspace:FindFirstChild("TimerGui")
if timerFolder then
    for _, t in pairs(timerFolder:GetChildren()) do
        createTimerESP(t)
    end
    timerFolder.ChildAdded:Connect(function(child)
        createTimerESP(child)
    end)
end
