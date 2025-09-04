-- =========================
-- No Sleep GUI for Steal A Brainrot
-- Features: Rainbow GUI, Movable, Speed (max 48), Platform Jump, Player ESP, Brainrot ESP, Base Timer ESP, Persistent GUI
-- =========================

local MAX_SPEED, UserInputService, RunService = 48, game:GetService("UserInputService"), game:GetService("RunService")
local player = game.Players.LocalPlayer

local desiredSpeed, speedEnabled, playerESPEnabled, jumpEnabled = 16, true, true, false
local currentJumpLevel, jumpHeight = 0, 10

-- ESP Folder
local espFolder = Instance.new("Folder")
espFolder.Name = "NoSleepESP"
espFolder.Parent = player:WaitForChild("PlayerGui")

-- GUI Creation
local gui = player:WaitForChild("PlayerGui"):FindFirstChild("NoSleepGUI") or Instance.new("ScreenGui")
gui.Name = "NoSleepGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size, frame.Position, frame.Active, frame.Draggable = UDim2.new(0,300,0,220), UDim2.new(0,20,0,20), true, true
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui

-- Rainbow GUI
spawn(function()
    local hue = 0
    while true do
        frame.BackgroundColor3 = Color3.fromHSV(hue,1,1)
        hue = (hue + 0.005) % 1
        wait(0.03)
    end
end)

-- Title
local title = Instance.new("TextLabel")
title.Size, title.Position, title.Text, title.TextColor3, title.BackgroundTransparency, title.Font, title.TextSize = UDim2.new(1,0,0,30), UDim2.new(0,0,0,0), "No Sleep GUI", Color3.fromRGB(255,255,255), 1, Enum.Font.SourceSansBold, 18
title.Parent = frame

-- Speed Slider
local sliderFrame = Instance.new("Frame")
sliderFrame.Size, sliderFrame.Position, sliderFrame.BackgroundColor3 = UDim2.new(1,-20,0,40), UDim2.new(0,10,0,40), Color3.fromRGB(50,50,50)
sliderFrame.Parent = frame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(desiredSpeed/MAX_SPEED,0,1,0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
sliderFill.Parent = sliderFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size, speedLabel.Position, speedLabel.BackgroundTransparency, speedLabel.TextColor3, speedLabel.Text = UDim2.new(1,0,0,20), UDim2.new(0,0,1,0), 1, Color3.fromRGB(255,255,255), "Speed: "..desiredSpeed
speedLabel.Parent = frame

-- Player ESP Toggle
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size, toggleBtn.Position, toggleBtn.Text, toggleBtn.TextColor3, toggleBtn.BackgroundColor3, toggleBtn.Font, toggleBtn.TextSize = UDim2.new(1,-20,0,30), UDim2.new(0,10,0,90), "Player ESP: ON", Color3.fromRGB(255,255,255), Color3.fromRGB(70,70,70), Enum.Font.SourceSansBold, 16
toggleBtn.Parent = frame
toggleBtn.MouseButton1Click:Connect(function()
    playerESPEnabled = not playerESPEnabled
    toggleBtn.Text = "Player ESP: "..(playerESPEnabled and "ON" or "OFF")
end)

-- Jump Toggle
local jumpBtn = Instance.new("TextButton")
jumpBtn.Size, jumpBtn.Position, jumpBtn.Text, jumpBtn.TextColor3, jumpBtn.BackgroundColor3, jumpBtn.Font, jumpBtn.TextSize = UDim2.new(1,-20,0,30), UDim2.new(0,10,0,130), "Platform Jump: OFF", Color3.fromRGB(255,255,255), Color3.fromRGB(70,70,70), Enum.Font.SourceSansBold, 16
jumpBtn.Parent = frame
jumpBtn.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    jumpBtn.Text = "Platform Jump: "..(jumpEnabled and "ON" or "OFF")
end)

-- Slider Input
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

-- Speed Control
spawn(function()
    while true do
        if speedEnabled then
            local c = player.Character
            if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Humanoid") then
                local root, humanoid = c.HumanoidRootPart, c.Humanoid
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    root.Velocity = moveDir*desiredSpeed + Vector3.new(0,root.Velocity.Y,0)
                end
            end
        end
        wait(0.03)
    end
end)

-- Platform Jump
UserInputService.JumpRequest:Connect(function()
    if jumpEnabled then
        local c = player.Character
        if c and c:FindFirstChild("Humanoid") and c.Humanoid.Health>0 then
            local root = c:FindFirstChild("HumanoidRootPart")
            if root then
                currentJumpLevel = currentJumpLevel + 1
                root.CFrame = root.CFrame + Vector3.new(0,jumpHeight,0)
            end
        end
    end
end)

-- Player ESP
local function espPlayer(p)
    if p==player or not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return end
    local b = Instance.new("BillboardGui")
    b.Size, b.Adornee, b.AlwaysOnTop, b.Parent = UDim2.new(0,100,0,50), p.Character.HumanoidRootPart, true, espFolder
    local l = Instance.new("TextLabel")
    l.Size, l.BackgroundTransparency, l.TextColor3, l.TextStrokeTransparency, l.TextScaled, l.Text, l.Parent = UDim2.new(1,0,1,0),1,Color3.fromRGB(255,0,0),0,true,p.Name,b
    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then b.Adornee = p.Character.HumanoidRootPart else b:Destroy() end
    end)
end
for _,p in pairs(game.Players:GetPlayers()) do espPlayer(p) end
game.Players.PlayerAdded:Connect(espPlayer)

-- Brainrot ESP
local brFolders={"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}
local function espBrainrot(br)
    if not br:IsA("BasePart") then return end
    local b = Instance.new("BillboardGui")
    b.Size, b.Adornee, b.AlwaysOnTop, b.Parent = UDim2.new(0,100,0,30), br, true, espFolder
    local l = Instance.new("TextLabel")
    l.Size, l.BackgroundTransparency, l.TextColor3, l.TextStrokeTransparency, l.TextScaled, l.Text, l.Parent = UDim2.new(1,0,1,0),1,Color3.fromRGB(0,255,0),0,true,br.Name,b
    RunService.RenderStepped:Connect(function()
        if br.Parent then b.Adornee = br else b:Destroy() end
    end)
end
for _,fName in pairs(brFolders) do
    local f = workspace:FindFirstChild(fName)
    if f then
        for _,br in pairs(f:GetChildren()) do espBrainrot(br) end
        f.ChildAdded:Connect(espBrainrot)
    end
end

-- Base Timer ESP
local timerFolder = workspace:FindFirstChild("TimerGui")
if timerFolder and timerFolder:FindFirstChild("Timer") then
    local timerObj = timerFolder.Timer
    local b = Instance.new("BillboardGui")
    b.Size, b.Adornee, b.AlwaysOnTop, b.Parent = UDim2.new(0,100,0,30), timerObj, true, espFolder
    local l = Instance.new("TextLabel")
    l.Size, l.BackgroundTransparency, l.TextColor3, l.TextStrokeTransparency, l.TextScaled, l.Text, l.Parent = UDim2.new(1,0,1,0),1,Color3.fromRGB(255,255,0),0,true,"Base Timer",b
    RunService.RenderStepped:Connect(function()
        if timerObj.Parent then b.Adornee = timerObj else b:Destroy() end
    end)
end
