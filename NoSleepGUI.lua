-- ================= Rayfield GUI NoSleep =================
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variables
local MAX_SPEED = 60
local rainbowPlatformEnabled = false
local playerESPEnabled = false
local brainrotESPEnabled = false
local timerESPEnabled = false

-- ================= GUI =================
local Window = Rayfield:CreateWindow({
    Name = "NoSleep GUI",
    LoadingTitle = "NoSleep GUI",
    LoadingSubtitle = "Delta Executor",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NoSleep", -- Config folder
        FileName = "Config"
    }
})

-- ================= TABS =================
local MainTab = Window:CreateTab("Main", 4483362458) -- Main features
local VisualsTab = Window:CreateTab("Visuals", 4483362458) -- ESP / Visuals

-- ================= MAIN TAB =================
MainTab:CreateLabel("Player Controls")

MainTab:CreateButton({
    Name = "Set Speed 60",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = MAX_SPEED
        end
    end
})

MainTab:CreateToggle({
    Name = "Rainbow Platform",
    CurrentValue = false,
    Flag = "RainbowPlatform",
    Callback = function(Value)
        rainbowPlatformEnabled = Value
    end
})

-- Keep Speed at 60
spawn(function()
    while true do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = MAX_SPEED
        end
        task.wait(0.2)
    end
end)

-- ================= VISUALS TAB =================
VisualsTab:CreateLabel("ESP & Visuals")

VisualsTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        playerESPEnabled = Value
    end
})

VisualsTab:CreateToggle({
    Name = "Best Brainrot ESP",
    CurrentValue = false,
    Flag = "BrainrotESP",
    Callback = function(Value)
        brainrotESPEnabled = Value
    end
})

VisualsTab:CreateToggle({
    Name = "Timer ESP",
    CurrentValue = false,
    Flag = "TimerESP",
    Callback = function(Value)
        timerESPEnabled = Value
    end
})

-- ================= ESP FOLDER =================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "NoSleepESP"
ESPFolder.Parent = Workspace

-- Rainbow color cycle
local hue = 0
RunService.RenderStepped:Connect(function()
    hue = hue + 0.005
    if hue > 1 then hue = 0 end
end)

-- ================= PLAYER ESP =================
local function createPlayerESP(plr)
    local function makeESP()
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
        local hrp = plr.Character.HumanoidRootPart

        local bill = Instance.new("BillboardGui")
        bill.Adornee = hrp
        bill.Size = UDim2.new(0,150,0,50)
        bill.AlwaysOnTop = true
        bill.Name = "ESP_"..plr.Name
        bill.Parent = ESPFolder

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Text = plr.Name
        label.Parent = bill

        RunService.RenderStepped:Connect(function()
            if playerESPEnabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                label.TextColor3 = Color3.fromHSV(hue,1,1)
            elseif bill then
                bill:Destroy()
            end
        end)
    end

    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if playerESPEnabled then makeESP() end
    end)

    if plr.Character and playerESPEnabled then
        makeESP()
    end
end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        createPlayerESP(plr)
    end
end
Players.PlayerAdded:Connect(createPlayerESP)

-- ================= BEST BRAINROT ESP =================
spawn(function()
    while true do
        if brainrotESPEnabled then
            local bestValue, bestObj = 0, nil
            for _, groupName in ipairs({"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}) do
                local group = Workspace:FindFirstChild(groupName)
                if group then
                    for _, obj in ipairs(group:GetChildren()) do
                        local val = obj:FindFirstChild("Value") and obj.Value or 0
                        if val > bestValue then
                            bestValue = val
                            bestObj = obj
                        end
                    end
                end
            end

            -- Remove old
            local old = ESPFolder:FindFirstChild("BrainrotESP")
            if old then old:Destroy() end

            if bestObj then
                local bill = Instance.new("BillboardGui")
                bill.Adornee = bestObj
                bill.Size = UDim2.new(0,250,0,80)
                bill.AlwaysOnTop = true
                bill.Name = "BrainrotESP"
                bill.Parent = ESPFolder

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Font = Enum.Font.Arcade
                label.Text = bestObj.Name.." $"..bestValue
                label.Parent = bill

                local box = Instance.new("SelectionBox")
                box.Adornee = bestObj
                box.Name = "BrainrotGlow"
                box.LineThickness = 0.05
                box.SurfaceTransparency = 1
                box.Parent = bestObj

                RunService.RenderStepped:Connect(function()
                    if brainrotESPEnabled then
                        label.TextColor3 = Color3.fromHSV(hue,1,1)
                        box.Color3 = Color3.fromHSV(hue,1,1)
                    else
                        bill:Destroy()
                        box:Destroy()
                    end
                end)
            end
        else
            local old = ESPFolder:FindFirstChild("BrainrotESP")
            if old then old:Destroy() end
        end
        task.wait(1)
    end
end)

-- ================= TIMER ESP =================
spawn(function()
    while true do
        if timerESPEnabled then
            local timerGui = Workspace:FindFirstChild("TimerGui")
            if timerGui and timerGui:FindFirstChild("Timer") then
                local part = timerGui.Timer
                if not ESPFolder:FindFirstChild("TimerESP") then
                    local bb = Instance.new("BillboardGui")
                    bb.Size = UDim2.new(0,150,0,50)
                    bb.Adornee = part
                    bb.AlwaysOnTop = true
                    bb.Name = "TimerESP"
                    bb.Parent = ESPFolder

                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1,0,1,0)
                    label.BackgroundTransparency = 1
                    label.TextStrokeTransparency = 0
                    label.TextScaled = true
                    label.Text = "Base Timer"
                    label.Parent = bb

                    RunService.RenderStepped:Connect(function()
                        if timerESPEnabled then
                            label.TextColor3 = Color3.fromHSV(hue,1,1)
                        else
                            bb:Destroy()
                        end
                    end)
                end
            end
        else
            local tESP = ESPFolder:FindFirstChild("TimerESP")
            if tESP then tESP:Destroy() end
        end
        task.wait(1)
    end
end)
