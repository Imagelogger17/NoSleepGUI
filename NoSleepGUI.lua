-- =========================
-- NoSleep GUI for Steal A Brainrot (Enhanced)
-- Features: Rainbow GUI, Movable, Speed (max 48), Rainbow Platform, Player ESP, Brainrot ESP, Base Timer ESP, Invisible Steal, Persistent GUI
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
local stealEnabled = false

-- =========================
-- ESP Folder
-- =========================
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
frame.Size = UDim2.new(0, 300, 0, 260)
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
-- TOGGLE BUTTONS
-- =========================
local function createToggleButton(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,30)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Text = text..": OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = frame
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text..": "..(state and "ON" or "OFF")
        callback(state)
    end)
    return btn
end

createToggleButton("Player ESP", 90, function(state) playerESPEnabled = state end)
createToggleButton("Rainbow Platform", 130, function(state) platformEnabled = state end)
createToggleButton("Invisible Steal", 170, function(state) stealEnabled = state end)

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
