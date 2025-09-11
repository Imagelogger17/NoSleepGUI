-- 🌈 NoSleep GUI for Delta (Speed + Combined ESP)
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Folder for ESP
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "NoSleepESP"
ESPFolder.Parent = player:WaitForChild("PlayerGui")

-- 🌈 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NoSleepGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

-- 🌈 Rainbow background
task.spawn(function()
    local hue = 0
    while true do
        frame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        hue = (hue + 0.005) % 1
        task.wait(0.03)
    end
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🌈 NoSleep GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Variables
local speed = 16
local minSpeed, maxSpeed = 16, 60
local ESPEnabled = true
local hue = 0

-- 🌈 Speed Slider
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, -20, 0, 40)
sliderFrame.Position = UDim2.new(0, 10, 0, 40)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderFrame.Parent = frame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new((speed-minSpeed)/(maxSpeed-minSpeed), 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.Parent = sliderFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Text = "Speed: " .. speed
speedLabel.Parent = frame

-- Slider input
sliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local moveConn, releaseConn
        local function update(pos)
            local rel = math.clamp(pos.X - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
            local percent = rel / sliderFrame.AbsoluteSize.X
            speed = math.floor(minSpeed + percent * (maxSpeed - minSpeed))
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            speedLabel.Text = "Speed: " .. speed
        end
        update(input.Position)
        moveConn = UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                update(i.Position)
            end
        end)
        releaseConn = UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                moveConn:Disconnect()
                releaseConn:Disconnect()
            end
        end)
    end
end)

-- 🌈 ESP toggle
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(1, -20, 0, 30)
espButton.Position = UDim2.new(0, 10, 0, 100)
espButton.Text = "ESP: ON"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 16
espButton.Parent = frame
espButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    espButton.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    if not ESPEnabled then
        for _, v in pairs(ESPFolder:GetChildren()) do v:Destroy() end
    end
end)

-- 🌈 Speed loop
task.spawn(function()
    while true do
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = speed
        end
        task.wait(0.1)
    end
end)

-- 🌈 Brainrot + Timer ESP combined
task.spawn(function()
    while true do
        if ESPEnabled then
            -- Brainrot ESP
            local bestBrainrot = nil
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj.Name:lower():find("brainrot") then
                    if not bestBrainrot or (obj:FindFirstChild("Value") and obj.Value > (bestBrainrot.Value or 0)) then
                        bestBrainrot = obj
                    end
                end
            end
            local oldBrainrot = ESPFolder:FindFirstChild("BrainrotESP")
            if oldBrainrot then oldBrainrot:Destroy() end
            if bestBrainrot and bestBrainrot:IsA("BasePart") then
                local bb = Instance.new("BillboardGui")
                bb.Adornee = bestBrainrot
                bb.Size = UDim2.new(0, 200, 0, 50)
                bb.AlwaysOnTop = true
                bb.Name = "BrainrotESP"
                bb.Parent = ESPFolder

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Font = Enum.Font.SourceSansBold
                label.Text = "🔥 Best Brainrot"
                label.Parent = bb

                RunService.RenderStepped:Connect(function()
                    if bb and bestBrainrot then
                        label.TextColor3 = Color3.fromHSV(hue, 1, 1)
                    end
                end)
            end

            -- Timer ESP
            local base = Workspace:FindFirstChild("Base")
            local timer = base and base:FindFirstChild("Timer")
            local oldTimer = ESPFolder:FindFirstChild("TimerESP")
            if oldTimer then oldTimer:Destroy() end
            if base and timer then
                local bb = Instance.new("BillboardGui")
                bb.Adornee = base
                bb.Size = UDim2.new(0, 200, 0, 50)
                bb.AlwaysOnTop = true
                bb.Name = "TimerESP"
                bb.Parent = ESPFolder

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Font = Enum.Font.SourceSansBold
                label.Parent = bb

                RunService.RenderStepped:Connect(function()
                    if timer and bb then
                        if timer:IsA("IntValue") or timer:IsA("NumberValue") then
                            label.Text = "⏳ Laser Timer: " .. timer.Value
                        elseif timer:IsA("StringValue") then
                            label.Text = "⏳ Laser Timer: " .. timer.Value
                        else
                            label.Text = "⏳ Laser Timer"
                        end
                        label.TextColor3 = Color3.fromHSV(hue, 1, 1)
                    end
                end)
            end
        else
            -- Destroy ESPs if disabled
            for _, v in pairs(ESPFolder:GetChildren()) do v:Destroy() end
        end
        task.wait(1)
    end
end)
