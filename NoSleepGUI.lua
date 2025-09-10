-- =========================================================
-- NoSleepGUI - Ultimate Edition
-- A premium script for Steal A Brainrot
-- Features: GUI, Speed Hack, Inf Jump, Player ESP,
--           Brainrot ESP, Invisible Steal
-- =========================================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Local player
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Constants
local MAX_SPEED = 60
local MAX_JUMP = 50
local RAINBOW_SPEED = 0.005

-- State variables
local desiredSpeed = 20
local playerESPEnabled = false
local brainrotESPEnabled = false
local infJumpEnabled = false
local invisibleStealEnabled = false
local currentRainbowHue = 0

-- UI Elements
local gui = Instance.new("ScreenGui")
gui.Name = "NoSleepGUI_Ultimate"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 350)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "No Sleep GUI - Ultimate"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- =========================
-- Helpers
-- =========================

-- Function to create a toggle button
local function createToggleButton(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = frame
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
    return btn
end

-- Function to create a slider
local function createSlider(label, initialValue, maxValue, posY, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 40)
    sliderFrame.Position = UDim2.new(0, 10, 0, posY)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderFrame.Parent = frame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(initialValue / maxValue, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.Parent = sliderFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 0, 20)
    valueLabel.Position = UDim2.new(0, 0, 1, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Text = label .. ": " .. initialValue
    valueLabel.Parent = frame

    local function updateValue(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local relativeX = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
            local ratio = relativeX / sliderFrame.AbsoluteSize.X
            local newValue = math.floor(ratio * maxValue)
            sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
            valueLabel.Text = label .. ": " .. newValue
            callback(newValue)
        end
    end
    sliderFrame.InputBegan:Connect(updateValue)
    sliderFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateValue(input)
        end
    end)
end

-- =========================
-- Core Features
-- =========================

-- Rainbow GUI effect
RunService.Heartbeat:Connect(function()
    currentRainbowHue = (currentRainbowHue + RAINBOW_SPEED) % 1
    frame.BackgroundColor3 = Color3.fromHSV(currentRainbowHue, 1, 1)
end)

-- Speed and Jump Power Sliders
createSlider("Speed", desiredSpeed, MAX_SPEED, 40, function(value)
    desiredSpeed = value
end)
createSlider("Jump Power", 50, MAX_JUMP, 90, function(value)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = value
    end
end)

-- Feature Toggles
createToggleButton("Inf Jump", 140, function(state)
    infJumpEnabled = state
end)
createToggleButton("Player ESP", 180, function(state)
    playerESPEnabled = state
end)
createToggleButton("Brainrot ESP", 220, function(state)
    brainrotESPEnabled = state
end)
createToggleButton("Invisible Steal", 260, function(state)
    invisibleStealEnabled = state
end)

-- Main Loops
RunService.Heartbeat:Connect(function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    -- Speed Hack Loop
    if humanoid and humanoid.WalkSpeed ~= desiredSpeed then
        humanoid.WalkSpeed = desiredSpeed
    end

    -- Inf Jump Loop
    if infJumpEnabled and humanoid and humanoid.Jump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- =========================
-- ESP & Invisible Steal
-- =========================

-- Clean up any existing ESP
local espFolder = playerGui:FindFirstChild("NoSleepESP")
if espFolder then espFolder:Destroy() end
espFolder = Instance.new("Folder")
espFolder.Name = "NoSleepESP"
espFolder.Parent = playerGui

-- Function to create ESP box
local function createESPBox(part, color)
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = part
    box.Color3 = color
    box.Transparency = 0.5
    box.AlwaysOnTop = true
    box.Size = part.Size
    box.Parent = espFolder
    return box
end

-- ESP Loop
RunService.Stepped:Connect(function()
    for _, obj in ipairs(espFolder:GetChildren()) do
        obj:Destroy()
    end

    -- Player ESP
    if playerESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                createESPBox(p.Character.HumanoidRootPart, Color3.fromRGB(255, 0, 0))
            end
        end
    end

    -- Brainrot ESP
    if brainrotESPEnabled then
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj.Name:find("Brainrot") and obj:IsA("Part") then
                createESPBox(obj, Color3.fromRGB(0, 255, 0))
            end
        end
    end
end)

-- Invisible Steal Logic
if invisibleStealEnabled then
    local oldC = workspace.CurrentCamera
    workspace.CurrentCamera = Instance.new("Camera")
    workspace.CurrentCamera.CFrame = CFrame.new(10000,10000,10000)
    -- This is a simple bypass. More complex games will require a different method.
end
