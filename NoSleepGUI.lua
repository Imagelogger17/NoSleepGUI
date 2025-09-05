-- =========================
-- NoSleepGUI + Platform + ESP Fix
-- Features: Rainbow GUI, Movable, Speed (max 48), Platform, Inf Jump, Player ESP, Brainrot ESP (Highest Value), Timer ESP
-- =========================

local MAX_SPEED = 48
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local desiredSpeed = 16
local speedEnabled = true
local playerESPEnabled = true
local brainrotESPEnabled = true
local timerESPEnabled = true
local platformEnabled = false
local infJumpEnabled = false

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
-- BUTTONS
-- =========================
local function createButton(y, text, toggleVar)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,30)
    btn.Position = UDim2.new(0,10,0,y)
    btn.Text = text..": OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        toggleVar.Value = not toggleVar.Value
        btn.Text = text..": "..(toggleVar.Value and "ON" or "OFF")
    end)
    return btn
end

local espToggle = {Value = playerESPEnabled}
local brainrotToggle = {Value = brainrotESPEnabled}
local timerToggle = {Value = timerESPEnabled}
local infJumpToggle = {Value = infJumpEnabled}
local platformToggle = {Value = platformEnabled}

createButton(90,"Player ESP",espToggle)
createButton(130,"Brainrot ESP",brainrotToggle)
createButton(170,"Timer ESP",timerToggle)
createButton(210,"Infinite Jump",infJumpToggle)
createButton(250,"Platform",platformToggle)

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
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    root.Velocity = moveDir*desiredSpeed + Vector3.new(0,root.Velocity.Y,0)
                end
            end
        end
        wait(0.03)
    end
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
-- PLATFORM SYSTEM
-- =========================
spawn(function()
    local currentHeight = 5
    while true do
        if platformToggle.Value then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position.X,currentHeight,char.HumanoidRootPart.Position.Z)
                currentHeight = currentHeight + 5
                wait(0.3)
            end
        else
            currentHeight = 5
        end
        wait(0.03)
    end
end)

-- =========================
-- INFINITE JUMP
-- =========================
UserInputService.JumpRequest:Connect(function()
    if infJumpToggle.Value then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- =========================
-- ESP FOLDERS
-- =========================
local espFolder = Instance.new("Folder")
espFolder.Name = "NoSleepESP"
espFolder.Parent = player:WaitForChild("PlayerGui")

-- =========================
-- PLAYER ESP
-- =========================
local function updatePlayerESP()
    while true do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and espToggle.Value and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local billboard = espFolder:FindFirstChild(p.Name) or Instance.new("BillboardGui")
                billboard.Name = p.Name
                billboard.Size = UDim2.new(0,150,0,60)
                billboard.Adornee = hrp
                billboard.AlwaysOnTop = true
                billboard.Parent = espFolder
                local label = billboard:FindFirstChild("Label") or Instance.new("TextLabel")
                label.Name = "Label"
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255,0,0)
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Text = p.Name
                label.Parent = billboard
            end
        end
        wait(0.1)
    end
end
spawn(updatePlayerESP)

-- =========================
-- BRAINROT ESP (Highest Value)
-- =========================
local brainrotFolders = {"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}
local function updateBrainrotESP()
    while true do
        if brainrotToggle.Value then
            local highestValue = nil
            local highestPart = nil
            for _, folderName in pairs(brainrotFolders) do
                local folder = workspace:FindFirstChild(folderName)
                if folder then
                    for _, br in pairs(folder:GetChildren()) do
                        local val = br:FindFirstChild("Value")
                        if val and (not highestValue or val.Value > highestValue) then
                            highestValue = val.Value
                            highestPart = br
                        end
                    end
                end
            end
            -- Update ESP
            for _, obj in pairs(espFolder:GetChildren()) do
                if obj:IsA("BillboardGui") and obj.Name:match("Brainrot") then obj:Destroy() end
            end
            if highestPart then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "BrainrotESP"
                billboard.Size = UDim2.new(0,120,0,40)
                billboard.Adornee = highestPart
                billboard.AlwaysOnTop = true
                billboard.Parent = espFolder
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(0,255,0)
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Text = highestPart.Name.." $"..highestValue
                label.Parent = billboard
            end
        end
        wait(0.3)
    end
end
spawn(updateBrainrotESP)

-- =========================
-- TIMER ESP
-- =========================
local function updateTimerESP()
    while true do
        if timerToggle.Value then
            local timerFolder = workspace:FindFirstChild("TimerGui")
            local timerObj = timerFolder and timerFolder:FindFirstChild("Timer")
            if timerObj then
                local billboard = espFolder:FindFirstChild("TimerESP") or Instance.new("BillboardGui")
                billboard.Name = "TimerESP"
                billboard.Size = UDim2.new(0,120,0,40)
                billboard.Adornee = timerObj
                billboard.AlwaysOnTop = true
                billboard.Parent = espFolder
                local label = billboard:FindFirstChild("Label") or Instance.new("TextLabel")
                label.Name = "Label"
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255,255,0)
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Text = "Base Timer: "..tostring(timerObj.Value or 0)
                label.Parent = billboard
            end
        end
        wait(0.3)
    end
end
spawn(updateTimerESP)
