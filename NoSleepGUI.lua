-- NoSleep GUI: Rayfield if available, fallback internal GUI if not.
-- Paste this whole file into Delta and run.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local task_wait = task.wait or wait

-- Common variables
local MAX_SPEED = 60
local rainbowPlatformEnabled = false
local playerESPEnabled = false
local brainrotESPEnabled = false
local timerESPEnabled = false

-- storage for ESP objects/conns so we can clean them
local playerESP = {}           -- [player] = {gui = BillboardGui, conn = connection}
local brainrotState = {gui = nil, glow = nil, conn = nil}
local timerState = {gui = nil, conn = nil}
local platformPart = nil
local hue = 0
local hueConn = nil
local allRenderConns = {}     -- to disconnect on kill

-- helper: safe destroy
local function safeDestroy(obj)
    if obj and obj.Destroy then
        pcall(function() obj:Destroy() end)
    end
end

-- common rainbow hue increment
local function startHue()
    if hueConn then return end
    hueConn = RunService.RenderStepped:Connect(function(dt)
        hue = hue + 0.005
        if hue > 1 then hue = 0 end
    end)
    table.insert(allRenderConns, hueConn)
end

-- set fixed speed loop
local running = true
spawn(function()
    while running do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            pcall(function() char.Humanoid.WalkSpeed = MAX_SPEED end)
        end
        task_wait(0.1)
    end
end)

-- ==================== ESP folder ====================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "NoSleepESP"
ESPFolder.Parent = Workspace

-- ================ PLAYER ESP functions =================
local function removePlayerESP(plr)
    local data = playerESP[plr]
    if not data then return end
    if data.conn then
        pcall(function() data.conn:Disconnect() end)
    end
    safeDestroy(data.gui)
    playerESP[plr] = nil
end

local function createPlayerESP(plr)
    -- don't create for local player
    if plr == LocalPlayer then return end
    -- clean existing
    removePlayerESP(plr)

    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = plr.Character.HumanoidRootPart

    local bill = Instance.new("BillboardGui")
    bill.Name = "ESP_"..plr.Name
    bill.Size = UDim2.new(0,150,0,50)
    bill.Adornee = hrp
    bill.AlwaysOnTop = true
    bill.Parent = ESPFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = plr.Name
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    label.Parent = bill

    local conn = RunService.RenderStepped:Connect(function()
        if not playerESPEnabled or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            -- remove if turned off or player died
            removePlayerESP(plr)
            return
        end
        -- update adornee (in case they respawn) and color
        bill.Adornee = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") or hrp
        label.TextColor3 = Color3.fromHSV(hue,1,1)
    end)
    table.insert(allRenderConns, conn)
    playerESP[plr] = { gui = bill, conn = conn }
end

local function enableAllPlayerESP(enable)
    if enable then
        -- create for current players
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                createPlayerESP(p)
            end
        end
    else
        -- remove all
        for p,_ in pairs(playerESP) do
            removePlayerESP(p)
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    -- wait for char spawn
    p.CharacterAdded:Connect(function()
        task_wait(0.8)
        if playerESPEnabled then createPlayerESP(p) end
    end)
end)
-- cleanup on PlayerRemoving
Players.PlayerRemoving:Connect(function(p) removePlayerESP(p) end)

-- ================ BEST BRAINROT ESP functions =================
local function clearBestBrainrot()
    if brainrotState.conn then pcall(function() brainrotState.conn:Disconnect() end) end
    brainrotState.conn = nil
    if brainrotState.gui then safeDestroy(brainrotState.gui); brainrotState.gui = nil end
    if brainrotState.glow then safeDestroy(brainrotState.glow); brainrotState.glow = nil end
end

local function updateBestBrainrotOnce()
    -- find best brainrot object by Value
    local bestValue = -math.huge
    local bestObj = nil
    for _, groupName in ipairs({"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}) do
        local group = Workspace:FindFirstChild(groupName)
        if group then
            for _, obj in ipairs(group:GetChildren()) do
                local v = obj:FindFirstChild("Value") and obj:FindFirstChild("Value").Value or 0
                if v > bestValue then
                    bestValue = v
                    bestObj = obj
                end
            end
        end
    end

    clearBestBrainrot()

    if not bestObj then return end
    -- create billboard GUI attached to the bestObj (assumed to be a BasePart)
    local bb = Instance.new("BillboardGui")
    bb.Name = "BrainrotESP"
    bb.Size = UDim2.new(0,250,0,80)
    bb.Adornee = bestObj
    bb.AlwaysOnTop = true
    bb.Parent = ESPFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.Arcade
    label.Text = tostring(bestObj.Name) .. " $" .. tostring(bestValue)
    label.Parent = bb

    -- selectionbox glow
    local box = Instance.new("SelectionBox")
    box.Name = "BrainrotGlow"
    box.Adornee = bestObj
    box.LineThickness = 0.05
    box.SurfaceTransparency = 1
    box.Parent = bestObj

    -- update color each frame
    local conn = RunService.RenderStepped:Connect(function()
        if not brainrotESPEnabled then
            clearBestBrainrot()
            return
        end
        if label then label.TextColor3 = Color3.fromHSV(hue,1,1) end
        if box then box.Color3 = Color3.fromHSV(hue,1,1) end
    end)
    table.insert(allRenderConns, conn)
    brainrotState.gui = bb
    brainrotState.glow = box
    brainrotState.conn = conn
end

-- spawner that keeps best brainrot updated
spawn(function()
    while true do
        if brainrotESPEnabled then
            pcall(updateBestBrainrotOnce)
        else
            clearBestBrainrot()
        end
        task_wait(1)
    end
end)

-- ================ TIMER ESP functions =================
local function clearTimerESP()
    if timerState.conn then pcall(function() timerState.conn:Disconnect() end) end
    timerState.conn = nil
    if timerState.gui then safeDestroy(timerState.gui); timerState.gui = nil end
end

local function ensureTimerESP()
    if not timerESPEnabled then
        clearTimerESP()
        return
    end
    local timerGui = Workspace:FindFirstChild("TimerGui")
    if not timerGui or not timerGui:FindFirstChild("Timer") then
        clearTimerESP()
        return
    end
    local timerPart = timerGui.Timer
    if not timerPart then clearTimerESP(); return end
    if timerState.gui then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "TimerESP"
    bb.Size = UDim2.new(0,150,0,50)
    bb.Adornee = timerPart
    bb.AlwaysOnTop = true
    bb.Parent = ESPFolder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    label.Text = "Base Timer"
    label.Parent = bb

    local conn = RunService.RenderStepped:Connect(function()
        if not timerESPEnabled then
            clearTimerESP()
            return
        end
        label.TextColor3 = Color3.fromHSV(hue,1,1)
    end)
    timerState.gui = bb
    timerState.conn = conn
    table.insert(allRenderConns, conn)
end

spawn(function()
    while true do
        ensureTimerESP()
        task_wait(1)
    end
end)

-- ================ RAINBOW PLATFORM =================
local platformConn = nil
local function enablePlatform(enable)
    if not enable then
        if platformConn then pcall(function() platformConn:Disconnect() end) end
        platformConn = nil
        safeDestroy(platformPart)
        platformPart = nil
        return
    end
    if platformPart == nil then
        platformPart = Instance.new("Part")
        platformPart.Name = "NoSleep_RainbowPlatform"
        platformPart.Size = Vector3.new(6,0.5,6)
        platformPart.Anchored = true
        platformPart.CanCollide = true
        platformPart.Material = Enum.Material.Neon
        platformPart.Parent = Workspace
    end
    if platformConn then platformConn:Disconnect() end
    platformConn = RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            platformPart.Position = hrp.Position - Vector3.new(0,3,0)
            platformPart.Color = Color3.fromHSV(hue,1,1)
        end
    end)
    table.insert(allRenderConns, platformConn)
end

-- ================ KILL GUI / CLEANUP =================
local createdScreenGui = nil
local function killAll()
    running = false
    -- disconnect render conns
    for _,con in ipairs(allRenderConns) do
        pcall(function() con:Disconnect() end)
    end
    allRenderConns = {}

    -- remove player ESPs
    for p,_ in pairs(playerESP) do removePlayerESP(p) end
    playerESP = {}

    -- brainrot/timer/platform cleanup
    clearBestBrainrot()
    clearTimerESP()
    enablePlatform(false)

    -- destroy ESPFolder
    safeDestroy(ESPFolder)
    ESPFolder = nil

    -- destroy GUI
    if createdScreenGui then safeDestroy(createdScreenGui) end
    createdScreenGui = nil
end

-- ================ TRY LOAD RAYFIELD, ELSE FALLBACK GUI =================
local function buildRayfieldUI(Rayfield)
    -- create window and tabs using Rayfield API (if available)
    local Win = Rayfield:CreateWindow({
        Name = "NoSleep GUI",
        LoadingTitle = "NoSleep GUI",
        LoadingSubtitle = "Delta Executor",
        ConfigurationSaving = { Enabled = false }
    })

    local MainTab = Win:CreateTab("Main")
    local VisualTab = Win:CreateTab("Visuals")

    MainTab:CreateLabel({ Name = "Speed: "..MAX_SPEED })
    MainTab:CreateToggle({
        Name = "Rainbow Platform",
        CurrentValue = rainbowPlatformEnabled,
        Callback = function(v) rainbowPlatformEnabled = v; enablePlatform(v) end
    })
    MainTab:CreateButton({
        Name = "Kill GUI",
        Callback = function() killAll() end
    })

    VisualTab:CreateToggle({
        Name = "Player ESP",
        CurrentValue = playerESPEnabled,
        Callback = function(v) playerESPEnabled = v; enableAllPlayerESP(v) end
    })
    VisualTab:CreateToggle({
        Name = "Best Brainrot ESP",
        CurrentValue = brainrotESPEnabled,
        Callback = function(v) brainrotESPEnabled = v end
    })
    VisualTab:CreateToggle({
        Name = "Timer ESP",
        CurrentValue = timerESPEnabled,
        Callback = function(v) timerESPEnabled = v end
    })
end

local function buildFallbackUI()
    -- Create a ScreenGui and a simple Rayfield-like UI with tabs/buttons
    local SG = Instance.new("ScreenGui")
    SG.Name = "NoSleepGUI_Fallback"
    SG.Parent = LocalPlayer:WaitForChild("PlayerGui")
    createdScreenGui = SG

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0,480,0,320)
    mainFrame.Position = UDim2.new(0,50,0,50)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = SG

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,36)
    title.Position = UDim2.new(0,0,0,0)
    title.BackgroundTransparency = 1
    title.Text = "NoSleep GUI (Fallback)"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = mainFrame

    -- tab buttons
    local tabMainBtn = Instance.new("TextButton")
    tabMainBtn.Size = UDim2.new(0,110,0,30)
    tabMainBtn.Position = UDim2.new(0,10,0,44)
    tabMainBtn.Text = "Main"
    tabMainBtn.Parent = mainFrame

    local tabVisualBtn = Instance.new("TextButton")
    tabVisualBtn.Size = UDim2.new(0,110,0,30)
    tabVisualBtn.Position = UDim2.new(0,130,0,44)
    tabVisualBtn.Text = "Visuals"
    tabVisualBtn.Parent = mainFrame

    -- content frames
    local contentMain = Instance.new("Frame")
    contentMain.Size = UDim2.new(1,-20,1,-100)
    contentMain.Position = UDim2.new(0,10,0,84)
    contentMain.BackgroundTransparency = 1
    contentMain.Parent = mainFrame

    local contentVisual = contentMain:Clone()
    contentVisual.Parent = mainFrame
    contentVisual.Visible = false

    -- MAIN content
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1,0,0,24)
    speedLabel.Position = UDim2.new(0,0,0,0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: "..MAX_SPEED
    speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
    speedLabel.Parent = contentMain

    local setSpeedBtn = Instance.new("TextButton")
    setSpeedBtn.Size = UDim2.new(0,140,0,28)
    setSpeedBtn.Position = UDim2.new(0,0,0,34)
    setSpeedBtn.Text = "Set Speed 60"
    setSpeedBtn.Parent = contentMain
    setSpeedBtn.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            pcall(function() char.Humanoid.WalkSpeed = MAX_SPEED end)
        end
    end)

    local rainbowPlatBtn = Instance.new("TextButton")
    rainbowPlatBtn.Size = UDim2.new(0,140,0,28)
    rainbowPlatBtn.Position = UDim2.new(0,150,0,34)
    rainbowPlatBtn.Text = "Rainbow Platform: OFF"
    rainbowPlatBtn.Parent = contentMain
    rainbowPlatBtn.MouseButton1Click:Connect(function()
        rainbowPlatformEnabled = not rainbowPlatformEnabled
        rainbowPlatBtn.Text = "Rainbow Platform: "..(rainbowPlatformEnabled and "ON" or "OFF")
        enablePlatform(rainbowPlatformEnabled)
    end)

    local killBtn = Instance.new("TextButton")
    killBtn.Size = UDim2.new(0,140,0,28)
    killBtn.Position = UDim2.new(0,300,0,34)
    killBtn.Text = "Kill GUI"
    killBtn.Parent = contentMain
    killBtn.MouseButton1Click:Connect(killAll)

    -- VISUALS content
    local pESPBtn = Instance.new("TextButton")
    pESPBtn.Size = UDim2.new(0,160,0,28)
    pESPBtn.Position = UDim2.new(0,0,0,0)
    pESPBtn.Text = "Player ESP: OFF"
    pESPBtn.Parent = contentVisual
    pESPBtn.MouseButton1Click:Connect(function()
        playerESPEnabled = not playerESPEnabled
        pESPBtn.Text = "Player ESP: "..(playerESPEnabled and "ON" or "OFF")
        enableAllPlayerESP(playerESPEnabled)
    end)

    local bESPBtn = Instance.new("TextButton")
    bESPBtn.Size = UDim2.new(0,160,0,28)
    bESPBtn.Position = UDim2.new(0,170,0,0)
    bESPBtn.Text = "Best Brainrot ESP: OFF"
    bESPBtn.Parent = contentVisual
    bESPBtn.MouseButton1Click:Connect(function()
        brainrotESPEnabled = not brainrotESPEnabled
        bESPBtn.Text = "Best Brainrot ESP: "..(brainrotESPEnabled and "ON" or "OFF")
        -- updateBestBrainrot will run automatically in its loop
    end)

    local tESPBtn = Instance.new("TextButton")
    tESPBtn.Size = UDim2.new(0,160,0,28)
    tESPBtn.Position = UDim2.new(0,340,0,0)
    tESPBtn.Text = "Timer ESP: OFF"
    tESPBtn.Parent = contentVisual
    tESPBtn.MouseButton1Click:Connect(function()
        timerESPEnabled = not timerESPEnabled
        tESPBtn.Text = "Timer ESP: "..(timerESPEnabled and "ON" or "OFF")
    end)

    -- tab switching
    tabMainBtn.MouseButton1Click:Connect(function()
        contentMain.Visible = true
        contentVisual.Visible = false
    end)
    tabVisualBtn.MouseButton1Click:Connect(function()
        contentMain.Visible = false
        contentVisual.Visible = true
    end)
end

-- try to load Rayfield (safe pcall). If it works, use it. If not, build fallback UI.
local ok, RayfieldOrErr = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
end)

if ok and RayfieldOrErr then
    -- Rayfield loaded successfully
    startHue()
    buildRayfieldUI(RayfieldOrErr)
else
    -- fallback UI
    startHue()
    buildFallbackUI()
end

-- make sure we remove/destroy when player leaves or script killed
Players.LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if not parent then killAll() end
end)
