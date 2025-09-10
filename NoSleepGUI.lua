-- =========================================================
-- NoSleep GUI for Steal A Brainrot (Enhanced & Improved)
-- =========================================================
-- This script has been refactored for improved stability,
-- performance, and reliability. It addresses common issues
-- like variable scope, incorrect loops, and error handling.
-- =========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Constants
local MAX_SPEED = 48
local UPDATE_INTERVAL = 0.03 -- For non-RunService loops
local RAINBOW_SPEED = 0.005

-- State variables
local desiredSpeed = 16
local playerESPEnabled = false
local platformEnabled = false
local stealEnabled = false
local currentRainbowHue = 0

-- UI Elements and Helpers
local gui = playerGui:FindFirstChild("NoSleepGUI") or Instance.new("ScreenGui")
gui.Name = "NoSleepGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 260)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

-- Rainbow GUI effect
RunService.Heartbeat:Connect(function()
    currentRainbowHue = (currentRainbowHue + RAINBOW_SPEED) % 1
    frame.BackgroundColor3 = Color3.fromHSV(currentRainbowHue, 1, 1)
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "No Sleep GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

---
### Speed Control
---

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, -20, 0, 40)
sliderFrame.Position = UDim2.new(0, 10, 0, 40)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderFrame.Parent = frame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(desiredSpeed / MAX_SPEED, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.Parent = sliderFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Text = "Speed: "..desiredSpeed
speedLabel.Parent = frame

local function updateSpeedFromInput(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local relativeX = math.clamp(input.Position.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
        local ratio = relativeX / sliderFrame.AbsoluteSize.X
        desiredSpeed = math.floor(ratio * MAX_SPEED)
        sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        speedLabel.Text = "Speed: "..desiredSpeed
    end
end

sliderFrame.InputBegan:Connect(updateSpeedFromInput)
sliderFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        updateSpeedFromInput(input)
    end
end)

-- Speed hack loop
RunService.Stepped:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if humanoid and root then
        -- This logic is more reliable than directly setting Velocity,
        -- as it works with the Humanoid's built-in movement system.
        if humanoid.MoveDirection.Magnitude > 0 then
            humanoid.WalkSpeed = desiredSpeed
        else
            -- Resets to default if not moving to prevent weird behavior
            humanoid.WalkSpeed = 16 
        end
    end
end)

---
### Toggle Buttons
---

local function createToggleButton(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.Text = text..": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
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

createToggleButton("Player ESP", 90, function(state)
    playerESPEnabled = state
    -- Additional ESP logic needs to be implemented here
end)
createToggleButton("Rainbow Platform", 130, function(state)
    platformEnabled = state
    -- Additional platform logic needs to be implemented here
end)
createToggleButton("Invisible Steal", 170, function(state)
    stealEnabled = state
    -- Additional steal logic needs to be implemented here
end)

-- Ensure existing ESP folder is removed on re-execution
local espFolder = playerGui:FindFirstChild("NoSleepESP")
if espFolder then espFolder:Destroy() end

espFolder = Instance.new("Folder")
espFolder.Name = "NoSleepESP"
espFolder.Parent = playerGui

-- NOTE: The ESP and other core logic loops were missing from your
-- original script. You will need to implement them here, using
-- `RunService.Heartbeat` for consistent updates.
--
-- Example ESP loop:
-- RunService.Heartbeat:Connect(function()
--     if playerESPEnabled then
--         -- Iterate through all players, create a BoxHandleAdornment for them,
--         -- and parent it to the espFolder.
--     end
-- end)
