-- =========================
-- NoSleep GUI for Steal A Brainrot (Enhanced + Invisible Steal)
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

-- =========================
-- PLAYER ESP (persists after death)
-- =========================
local function createESPForPlayer(targetPlayer)
    if targetPlayer == player then return end
    local function addBillboard()
        if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        local hrp = targetPlayer.Character.HumanoidRootPart

        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0,150,0,70)
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
                billboard.Adornee = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            end
        end)
    end
    addBillboard()
    targetPlayer.CharacterAdded:Connect(addBillboard)
end

for _, p in pairs(game.Players:GetPlayers()) do
    createESPForPlayer(p)
end
game.Players.PlayerAdded:Connect(createESPForPlayer)

-- =========================
-- BRAINROT ESP (Highest Value)
-- =========================
local function createBrainrotESP()
    local highestValue = 0
    local highestPart = nil

    for _, folderName in pairs({"IgnoreBrainrots", "Brainrot God", "Brainrots", "BrainrotName"}) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            for _, br in pairs(folder:GetChildren()) do
                local value = br:FindFirstChild("Value") and br.Value or 0
                if value > highestValue then
                    highestValue = value
                    highestPart = br
                end
            end
        end
    end

    if highestPart then
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0,150,0,50)
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
createBrainrotESP()

-- =========================
-- TIMER ESP
-- =========================
local timerFolder = workspace:FindFirstChild("TimerGui")
if timerFolder and timerFolder:FindFirstChild("Timer") then
    local timerObj = timerFolder.Timer
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,150,0,50)
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
end

-- =========================
-- RAINBOW PLATFORM
-- =========================
local platform = nil
local hue = 0
RunService.RenderStepped:Connect(function()
    if platformEnabled then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if not platform then
                platform = Instance.new("Part")
                platform.Size = Vector3.new(6,0.5,6)
                platform.Anchored = true
                platform.CanCollide = true
                platform.Material = Enum.Material.Neon
                platform.Parent = Workspace
            end
            platform.Position = char.HumanoidRootPart.Position - Vector3.new(0,3,0)
            platform.Color = Color3.fromHSV(hue,1,1)
            hue = hue + 0.005
            if hue > 1 then hue = 0 end
        elseif platform then
            platform:Destroy()
            platform = nil
        end
    elseif platform then
        platform:Destroy()
        platform = nil
    end
end)

-- =========================
-- INVISIBLE STEAL
-- =========================
spawn(function()
    while true do
        if stealEnabled then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local carryingItem = nil
                for _, folderName in pairs({"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}) do
                    local folder = workspace:FindFirstChild(folderName)
                    if folder then
                        for _, br in pairs(folder:GetChildren()) do
                            if br:IsA("BasePart") and (char.HumanoidRootPart.Position - br.Position).Magnitude < 5 then
                                carryingItem = br
                                break
                            end
                        end
                    end
                    if carryingItem then break end
                end
                if carryingItem then
                    -- Turn invisible
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("MeshPart") then
                            part.Transparency = 1
                        elseif part:IsA("Decal") then
                            part.Transparency = 1
                        end
                    end

                    -- Wait until returned to base or plot
                    local reachedBase = false
                    while not reachedBase do
                        for _, baseName in pairs({"Base","Plots"}) do
                            local base = workspace:FindFirstChild(baseName)
                            if base and (carryingItem.Position - base.Position).Magnitude < 10 then
                                reachedBase = true
                                break
                            end
                        end
                        wait(0.1)
                    end

                    char.Humanoid.Health = 0 -- kill to reset invisibility
                end
            end
        end
        wait(0.1)
    end
end)
