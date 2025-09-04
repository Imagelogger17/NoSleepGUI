-- =========================
-- No Sleep GUI for Steal A Brainrot
-- Features: Speed slider, Player ESP, Brainrot ESP, Base Timer ESP
-- =========================

local MAX_SPEED = 100
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local desiredSpeed = 16
local speedEnabled = true
local playerESPEnabled = true
local brainrotESPEnabled = true
local baseTimerESPEnabled = true

-- Folder for ESP GUI
local espFolder = Instance.new("Folder")
espFolder.Name = "NoSleepESP"
espFolder.Parent = player:WaitForChild("PlayerGui")

-- =========================
-- GUI CREATION
-- =========================
local function createGUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "NoSleepGUI"
    gui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 220)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Parent = gui

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

    -- Speed Slider
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

    -- Feature Toggles
    local toggleY = 90
    local function createToggle(name, stateRef)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, toggleY)
        toggleY = toggleY + 35
        btn.Text = name.." : "..(stateRef[1] and "ON" or "OFF")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 16
        btn.Parent = frame
        btn.MouseButton1Click:Connect(function()
            stateRef[1] = not stateRef[1]
            btn.Text = name.." : "..(stateRef[1] and "ON" or "OFF")
        end)
    end

    createToggle("Player ESP", {playerESPEnabled})
    createToggle("Brainrot ESP", {brainrotESPEnabled})
    createToggle("Base Timer ESP", {baseTimerESPEnabled})

    -- Slider input
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local function updateSpeed(posX)
                local relativeX = math.clamp(posX - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
                local ratio = relativeX / sliderFrame.AbsoluteSize.X
                desiredSpeed = math.floor(ratio * MAX_SPEED)
                sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
                speedLabel.Text = "Speed: "..desiredSpeed
            end
            updateSpeed(input.Position.X)
        end
    end)
end

-- =========================
-- SPEED CONTROL
-- =========================
local function applySpeed()
    spawn(function()
        while true do
            if speedEnabled then
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
                    local root = character.HumanoidRootPart
                    local humanoid = character.Humanoid
                    local moveDirection = humanoid.MoveDirection
                    if moveDirection.Magnitude > 0 then
                        root.Velocity = moveDirection * desiredSpeed + Vector3.new(0, root.Velocity.Y, 0)
                    end
                end
            end
            wait(0.03)
        end
    end)
end

-- =========================
-- PLAYER ESP
-- =========================
local function createESPForPlayer(targetPlayer)
    if targetPlayer == player then return end
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = targetPlayer.Character.HumanoidRootPart

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
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

-- =========================
-- BRAINROT & BASE ESP
-- =========================
local function highlightObjects()
    for _, obj in pairs(workspace:GetChildren()) do
        -- Brainrot ESP
        if brainrotESPEnabled and obj.Name:lower():find("brainrot") then
            if not obj:FindFirstChild("Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = obj
            end
        end

        -- Base Timer ESP
        if baseTimerESPEnabled and obj:FindFirstChildWhichIsA("NumberValue") then
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("NumberValue") and child.Name:lower():find("timer") then
                    if not child:FindFirstChild("BillboardTimer") then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.Adornee = obj
                        billboard.AlwaysOnTop = true
                        billboard.Name = "BillboardTimer"
                        billboard.Parent = espFolder

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.TextColor3 = Color3.fromRGB(255, 255, 0)
                        label.TextStrokeTransparency = 0
                        label.TextScaled = true
                        label.Text = tostring(child.Value)
                        label.Parent = billboard

                        RunService.RenderStepped:Connect(function()
                            if child.Parent then
                                label.Text = tostring(child.Value)
                            else
                                billboard:Destroy()
                            end
                        end)
                    end
                end
            end
        end
    end
end

-- =========================
-- INITIALIZATION
-- =========================
createGUI()
applySpeed()

-- ESP for existing players
for _, p in pairs(game.Players:GetPlayers()) do
    createESPForPlayer(p)
end

-- ESP for new players
game.Players.PlayerAdded:Connect(function(p)
    createESPForPlayer(p)
end)

-- Highlight brainrots & bases every frame
RunService.RenderStepped:Connect(function()
    highlightObjects()
end)

-- Reapply speed after respawn
player.CharacterAdded:Connect(function()
    wait(1)
    applySpeed()
end)
