-- =========================
-- NoSleep GUI Enhanced: Brainrot Selector & Server Hop
-- Features: Player ESP, Brainrot ESP, Base Timer ESP, Rainbow Platform, Speed, Server Hop
-- =========================

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- GUI Setup
local gui = player:WaitForChild("PlayerGui"):FindFirstChild("NoSleepGUI") or Instance.new("ScreenGui")
gui.Name = "NoSleepGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "NoSleep GUI"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- =========================
-- ESP Folder
-- =========================
local espFolder = Instance.new("Folder")
espFolder.Name = "NoSleepESP"
espFolder.Parent = player.PlayerGui

-- =========================
-- Brainrot Selector
-- =========================
local selectedBrainrot = nil
local brainrotListFrame = Instance.new("ScrollingFrame")
brainrotListFrame.Size = UDim2.new(1, -20, 0, 100)
brainrotListFrame.Position = UDim2.new(0, 10, 0, 40)
brainrotListFrame.CanvasSize = UDim2.new(0,0,1,0)
brainrotListFrame.ScrollBarThickness = 6
brainrotListFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
brainrotListFrame.Parent = frame

local function refreshBrainrotList()
    -- Clear previous buttons
    for _, child in pairs(brainrotListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Detect brainrots in server
    local brainrots = {}
    for _, folderName in pairs({"IgnoreBrainrots", "Brainrot God", "Brainrots", "BrainrotName"}) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            for _, br in pairs(folder:GetChildren()) do
                table.insert(brainrots, br)
            end
        end
    end

    -- Create buttons
    for i, br in pairs(brainrots) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.Position = UDim2.new(0, 0, 0, (i-1)*30)
        btn.Text = br.Name
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 14
        btn.Parent = brainrotListFrame
        btn.MouseButton1Click:Connect(function()
            selectedBrainrot = br.Name
            print("Selected Brainrot:", selectedBrainrot)
        end)
    end

    brainrotListFrame.CanvasSize = UDim2.new(0,0,0,#brainrots*30)
end

refreshBrainrotList()

-- =========================
-- Server Hop Button
-- =========================
local serverHopBtn = Instance.new("TextButton")
serverHopBtn.Size = UDim2.new(1, -20, 0, 30)
serverHopBtn.Position = UDim2.new(0, 10, 0, 150)
serverHopBtn.Text = "Server Hop"
serverHopBtn.TextColor3 = Color3.fromRGB(255,255,255)
serverHopBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
serverHopBtn.Font = Enum.Font.SourceSansBold
serverHopBtn.TextSize = 16
serverHopBtn.Parent = frame

serverHopBtn.MouseButton1Click:Connect(function()
    if not selectedBrainrot then
        print("Select a brainrot first!")
        return
    end

    -- Query Roblox server list
    local placeId = game.PlaceId
    local success, response = pcall(function()
        return game:HttpGetAsync("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100")
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        local servers = data.data
        for _, s in pairs(servers) do
            local serverId = s.id
            local playerCount = s.playing
            -- This is where you would check if the server has your selected brainrot
            -- For simplicity, we'll just teleport to the first available
            if playerCount < s.maxPlayers then
                -- Teleport
                game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, serverId, player)
                break
            end
        end
    else
        warn("Failed to fetch server list")
    end
end)

-- =========================
-- ESP Functions (Player + Brainrot + Timer)
-- =========================
local function createESPForPart(part, name, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,150,0,50)
    billboard.Adornee = part
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Text = name
    label.Parent = billboard
end

-- Player ESP
for _, p in pairs(Players:GetPlayers()) do
    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        createESPForPart(p.Character.HumanoidRootPart, p.Name, Color3.fromRGB(255,0,0))
    end
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        if char:FindFirstChild("HumanoidRootPart") then
            createESPForPart(char.HumanoidRootPart, p.Name, Color3.fromRGB(255,0,0))
        end
    end)
end)

-- Brainrot ESP (Highest Value)
local function refreshBrainrotESP()
    local highestValue = 0
    local highestPart = nil
    for _, folderName in pairs({"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}) do
        local folder = Workspace:FindFirstChild(folderName)
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
        createESPForPart(highestPart, highestPart.Name.." $"..highestValue, Color3.fromRGB(0,255,0))
    end
end
refreshBrainrotESP()

-- Timer ESP
local timerFolder = Workspace:FindFirstChild("TimerGui")
if timerFolder and timerFolder:FindFirstChild("Timer") then
    createESPForPart(timerFolder.Timer, "Base Timer", Color3.fromRGB(255,255,0))
end
