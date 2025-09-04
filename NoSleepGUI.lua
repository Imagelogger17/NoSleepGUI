-- =========================
-- No Sleep GUI for Steal A Brainrot
-- Features: Rainbow GUI, Movable, Close/Reopen, Speed (max 48), Safe Inf Jump, Player ESP, Persistent GUI
-- =========================

local MAX_SPEED = 48
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local desiredSpeed = 16
local speedEnabled = true
local playerESPEnabled = true
local infJumpEnabled = false

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
frame.Size = UDim2.new(0, 300, 0, 220)
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

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,50,0,30)
closeBtn.Position = UDim2.new(1,-55,0,0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
end)

-- Reopen button
local reopenBtn = Instance.new("TextButton")
reopenBtn.Size = UDim2.new(0,140,0,30)
reopenBtn.Position = UDim2.new(0,20,0,250)
reopenBtn.Text = "Open No Sleep GUI"
reopenBtn.TextColor3 = Color3.fromRGB(255,255,255)
reopenBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
reopenBtn.Font = Enum.Font.SourceSansBold
reopenBtn.TextSize = 16
reopenBtn.Parent = gui
reopenBtn.MouseButton1Click:Connect(function()
    gui.Enabled = true
end)

-- Speed slider
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
-- SAFE INFINITE JUMP
-- =========================
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local humanoid = char.Humanoid
            local workspaceJumpAnim = workspace:FindFirstChild("jumpanim") or workspace:FindFirstChild("jump")
            if workspaceJumpAnim then
                local animTrack = humanoid:LoadAnimation(workspaceJumpAnim)
                animTrack:Play()
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            else
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
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
    billboard.Size = UDim2.new(0,100,0,50)
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

-- ESP for existing players
for _, p in pairs(game.Players:GetPlayers()) do
    createESPForPlayer(p)
end

-- ESP for new players
game.Players.PlayerAdded:Connect(function(p)
    createESPForPlayer(p)
end)
