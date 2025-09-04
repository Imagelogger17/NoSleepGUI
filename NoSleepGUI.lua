-- =========================
-- No Sleep GUI for Steal A Brainrot
-- Features: Rainbow GUI, Movable, Speed (max 48), Platform Movement, Player ESP, Brainrot ESP, Base Timer ESP
-- =========================

local MAX_SPEED = 48
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local desiredSpeed = 16
local speedEnabled = true
local playerESPEnabled = true
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
frame.Size = UDim2.new(0, 300, 0, 250)
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

-- Platform Toggle
local platformBtn = Instance.new("TextButton")
platformBtn.Size = UDim2.new(1,-20,0,30)
platformBtn.Position = UDim2.new(0,10,0,130)
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
                    platformPart.Color = Color3.fromHSV(math.random(),1,1)
                    platformPart.Parent = workspace
                end
                platformPart.Position = char.HumanoidRootPart.Position - Vector3.new(0,3,0)
                platformPart.Color = Color3.fromHSV(tick()%1,1,1)
            elseif platformPart then
                platformPart:Destroy()
                platformPart = nil
            end
        elseif platformPart then
            platformPart:Destroy()
            platformPart = nil
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
-- TIMER ESP
-- =========================
local timerFolder = workspace:FindFirstChild("TimerGui")
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

-- =========================
-- HIGHEST VALUE BRAINROT ESP
-- =========================
local brainrotFolders = {"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}
local highestBrainrotESP

local function getHighestValueBrainrot()
    local highestValue = -math.huge
    local topBrainrot = nil
    for _, folderName in pairs(brainrotFolders) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            for _, br in pairs(folder:GetChildren()) do
                if br:IsA("BasePart") then
                    local cost = br:FindFirstChild("Price") and br.Price.Value or 0
                    if cost > highestValue then
                        highestValue = cost
                        topBrainrot = br
                    end
                end
            end
        end
    end
    return topBrainrot, highestValue
end

spawn(function()
    while true do
        local br, value = getHighestValueBrainrot()
        if br and br.Parent then
            if not highestBrainrotESP then
                highestBrainrotESP = Instance.new("BillboardGui")
                highestBrainrotESP.Size = UDim2.new(0,250,0,50)
                highestBrainrotESP.AlwaysOnTop = true
                highestBrainrotESP.Parent = espFolder

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(0,255,0)
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Name = "Label"
                label.Parent = highestBrainrotESP
            end
            highestBrainrotESP.Adornee = br
            highestBrainrotESP.Label.Text = br.Name.." | Cost: "..value
        elseif highestBrainrotESP then
            highestBrainrotESP:Destroy()
            highestBrainrotESP = nil
        end
        wait(0.2)
    end
end)
