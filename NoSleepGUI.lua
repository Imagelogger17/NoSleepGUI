-- Load Rayfield GUI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Variables
local MAX_SPEED = 60
local rainbowPlatformEnabled = true
local playerESPEnabled = true
local brainrotESPEnabled = true
local timerESPEnabled = true

-- GUI
local Window = Rayfield:CreateWindow({
    Name = "NoSleep GUI",
    LoadingTitle = "Loading NoSleep...",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "NoSleep",
       FileName = "Config"
    }
})

-- ================= TABS =================
local MainTab = Window:CreateTab("Main")
local VisualsTab = Window:CreateTab("Visuals")

-- ================= MAIN TAB =================
MainTab:CreateLabel({
    Name = "Speed: "..MAX_SPEED
})

MainTab:CreateToggle({
    Name = "Rainbow Platform",
    CurrentValue = true,
    Flag = "RainbowPlatform",
    Callback = function(val)
        rainbowPlatformEnabled = val
    end
})

-- ================= VISUALS TAB =================
VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = true,
    Flag = "PlayerESP",
    Callback = function(val)
        playerESPEnabled = val
    end
})

VisualsTab:CreateToggle({
    Name = "Best Brainrot ESP",
    CurrentValue = true,
    Flag = "BrainrotESP",
    Callback = function(val)
        brainrotESPEnabled = val
    end
})

VisualsTab:CreateToggle({
    Name = "Timer ESP",
    CurrentValue = true,
    Flag = "TimerESP",
    Callback = function(val)
        timerESPEnabled = val
    end
})

-- ================= FIXED SPEED =================
spawn(function()
    while true do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = MAX_SPEED
        end
        wait(0.1)
    end
end)

-- ================= ESP FOLDER =================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "NoSleepESP"
ESPFolder.Parent = Workspace

-- Rainbow hue tracker
local hue = 0
RunService.RenderStepped:Connect(function()
    hue = hue + 0.005
    if hue > 1 then hue = 0 end
end)

-- ================= CREATE ESP FUNCTION =================
local function createESP(player, isBrainrot)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character.HumanoidRootPart
    local bill = Instance.new("BillboardGui")
    bill.AlwaysOnTop = true
    bill.Adornee = hrp
    bill.Parent = ESPFolder

    -- Bigger size for brainrot
    if isBrainrot then
        bill.Size = UDim2.new(0,250,0,80)
    else
        bill.Size = UDim2.new(0,150,0,50)
    end
    bill.Name = player.Name

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    label.Text = player.Name
    label.Parent = bill

    if isBrainrot then
        label.Font = Enum.Font.Antique
        label.TextSize = 28
    end

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            bill.Adornee = player.Character.HumanoidRootPart
            if (isBrainrot and brainrotESPEnabled) or (not isBrainrot and playerESPEnabled) then
                label.TextColor3 = Color3.fromHSV(hue,1,1)
            else
                bill:Destroy()
                if conn then conn:Disconnect() end
            end
        else
            bill:Destroy()
            if conn then conn:Disconnect() end
        end
    end)
end

-- Add normal players
for _,p in pairs(Players:GetPlayers()) do
    createESP(p, false)
end
Players.PlayerAdded:Connect(function(p)
    createESP(p, false)
end)

-- ================= BEST BRAINROT ESP WITH NEON =================
local function updateBestBrainrot()
    while true do
        if brainrotESPEnabled then
            local bestValue = 0
            local bestObj = nil
            for _, groupName in pairs({"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}) do
                local group = Workspace:FindFirstChild(groupName)
                if group then
                    for _, obj in pairs(group:GetChildren()) do
                        local val = obj:FindFirstChild("Value") and obj.Value or 0
                        if val > bestValue then
                            bestValue = val
                            bestObj = obj
                        end
                    end
                end
            end

            -- Remove old Brainrot ESP and glow
            local oldESP = ESPFolder:FindFirstChild("BrainrotESP")
            if oldESP then oldESP:Destroy() end
            for _, groupName in pairs({"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}) do
                local group = Workspace:FindFirstChild(groupName)
                if group then
                    for _, obj in pairs(group:GetChildren()) do
                        local glow = obj:FindFirstChild("BrainrotGlow")
                        if glow then glow:Destroy() end
                    end
                end
            end

            -- Create ESP for best Brainrot
            if bestObj then
                local dummyPlayer = {Name = bestObj.Name, Character = {HumanoidRootPart = bestObj}}
                createESP(dummyPlayer, true)
                local bill = ESPFolder:FindFirstChild(bestObj.Name)
                if bill then bill.Name = "BrainrotESP" end

                -- Neon Glow Outline
                local selectionBox = Instance.new("SelectionBox")
                selectionBox.Adornee = bestObj
                selectionBox.Name = "BrainrotGlow"
                selectionBox.LineThickness = 0.05
                selectionBox.Color3 = Color3.fromHSV(hue,1,1)
                selectionBox.SurfaceTransparency = 1
                selectionBox.Parent = bestObj

                -- Update neon color rainbow
                RunService.RenderStepped:Connect(function()
                    if selectionBox and brainrotESPEnabled then
                        selectionBox.Color3 = Color3.fromHSV(hue,1,1)
                    end
                end)
            end
        else
            local oldESP = ESPFolder:FindFirstChild("BrainrotESP")
            if oldESP then oldESP:Destroy() end
        end
        wait(1)
    end
end
spawn(updateBestBrainrot)

-- ================= TIMER ESP =================
spawn(function()
    while true do
        if timerESPEnabled then
            local timerGui = Workspace:FindFirstChild("TimerGui")
            if timerGui and timerGui:FindFirstChild("Timer") then
                local timerPart = timerGui.Timer
                if not ESPFolder:FindFirstChild("TimerESP") then
                    local bb = Instance.new("BillboardGui")
                    bb.Size = UDim2.new(0,150,0,50)
                    bb.Adornee = timerPart
                    bb.AlwaysOnTop = true
                    bb.Name = "TimerESP"
                    bb.Parent = ESPFolder

                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1,0,1,0)
                    label.BackgroundTransparency = 1
                    label.TextScaled = true
                    label.TextStrokeTransparency = 0
                    label.Text = "Base Timer"
                    label.Parent = bb

                    -- Rainbow glow
                    RunService.RenderStepped:Connect(function()
                        if label and timerESPEnabled then
                            label.TextColor3 = Color3.fromHSV(hue,1,1)
                        end
                    end)
                end
            end
        else
            local tESP = ESPFolder:FindFirstChild("TimerESP")
            if tESP then tESP:Destroy() end
        end
        wait(1)
    end
end)
