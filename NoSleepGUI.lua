--[[ =========================================================
   No Sleep GUI (Step-Platform Jump, Speed, Player/Brainrot/Base ESP)
   Light-Obfuscated: keys centralised in CFG; vars shortened.
   Edit-friendly: tweak CFG values; rest can stay as-is.
   ========================================================= ]]

local CFG = {
    MAX_SPEED = 48,
    STEP_HEIGHT = 7,           -- height difference per platform step
    STEP_SIZE = Vector3.new(6,1,6),
    STEP_Y_OFFSET = 0.5,       -- tiny offset above target level for clean land
    MAX_STEPS = 25,            -- keep at most this many active steps
    PLATFORM_TRANSP = 0.7,
    PLATFORM_COLOR = Color3.fromRGB(200, 255, 200),
    GUI_W = 300, GUI_H = 240,
    ESP_NAME_SCALE = Vector2.new(200, 60),  -- bigger player-name plates
    ESP_BRAIN_SCALE = Vector2.new(180, 40),
    TIMER_SCALE = Vector2.new(180, 40),
    RAINBOW_SPEED = 0.005,
    UPDATE_DT = 0.03,
    BrainFolders = {"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"},
}

-- tiny string table (keeps the rest short but readable enough)
local S = {
    NoSleepGUI="NoSleepGUI", PlayerGui="PlayerGui", NoSleepESP="NoSleepESP",
    Frame="Frame", ScreenGui="ScreenGui", TextLabel="TextLabel", TextButton="TextButton",
    Folder="Folder", BillboardGui="BillboardGui",
    HRP="HumanoidRootPart", Humanoid="Humanoid",
    TimerGui="TimerGui", Timer="Timer",
    ON="ON", OFF="OFF",
}

local plr = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- state
local desired = 16
local speedOn = true
local espPlayersOn = true
local stepModeOn = false

-- platform state
local stepFolder = Instance.new(S.Folder)
stepFolder.Name = "NS_Steps"
stepFolder.Parent = workspace

local stepStack = {}

local function pushStep(p)
    table.insert(stepStack, p)
    if #stepStack > CFG.MAX_STEPS then
        local old = table.remove(stepStack, 1)
        if old and old.Parent then old:Destroy() end
    end
end

local function clearSteps()
    for _,p in ipairs(stepStack) do
        if p and p.Parent then p:Destroy() end
    end
    table.clear(stepStack)
end

-- ESP container
local espFolder = Instance.new(S.Folder)
espFolder.Name = S.NoSleepESP
espFolder.Parent = plr:WaitForChild(S.PlayerGui)

-- GUI
local gui = plr:WaitForChild(S.PlayerGui):FindFirstChild(S.NoSleepGUI) or Instance.new(S.ScreenGui)
gui.Name = S.NoSleepGUI
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild(S.PlayerGui)

local fr = Instance.new(S.Frame)
fr.Size = UDim2.fromOffset(CFG.GUI_W, CFG.GUI_H)
fr.Position = UDim2.new(0,20,0,20)
fr.Active = true
fr.Draggable = true
fr.BackgroundColor3 = Color3.fromRGB(30,30,30)
fr.Parent = gui

-- rainbow bg
task.spawn(function()
    local h=0
    while fr.Parent do
        fr.BackgroundColor3 = Color3.fromHSV(h,1,1)
        h = h + CFG.RAINBOW_SPEED
        if h > 1 then h = 0 end
        task.wait(CFG.UPDATE_DT)
    end
end)

local title = Instance.new(S.TextLabel)
title.Size = UDim2.new(1,0,0,30)
title.Text = "No Sleep GUI"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = fr

-- slider
local slider = Instance.new(S.Frame)
slider.Size = UDim2.new(1,-20,0,40)
slider.Position = UDim2.new(0,10,0,40)
slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
slider.Parent = fr

local fill = Instance.new(S.Frame)
fill.Size = UDim2.new(desired/CFG.MAX_SPEED,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
fill.Parent = slider

local spLbl = Instance.new(S.TextLabel)
spLbl.Size = UDim2.new(1,0,0,20)
spLbl.Position = UDim2.new(0,0,0,80)
spLbl.BackgroundTransparency = 1
spLbl.TextColor3 = Color3.new(1,1,1)
spLbl.Text = ("Speed: %d"):format(desired)
spLbl.Parent = fr

local function setSpeedFromX(x)
    local rx = math.clamp(x - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
    local r = rx/slider.AbsoluteSize.X
    desired = math.clamp(math.floor(r*CFG.MAX_SPEED), 0, CFG.MAX_SPEED)
    fill.Size = UDim2.new(r,0,1,0)
    spLbl.Text = ("Speed: %d"):format(desired)
end

slider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        setSpeedFromX(input.Position.X)
    end
end)
slider.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UIS.TouchEnabled then
            setSpeedFromX(input.Position.X)
        end
    end
end)

-- player ESP toggle
local espBtn = Instance.new(S.TextButton)
espBtn.Size = UDim2.new(1,-20,0,30)
espBtn.Position = UDim2.new(0,10,0,110)
espBtn.Text = "Player ESP: "..S.ON
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 16
espBtn.Parent = fr
espBtn.MouseButton1Click:Connect(function()
    espPlayersOn = not espPlayersOn
    espBtn.Text = "Player ESP: "..(espPlayersOn and S.ON or S.OFF)
    -- hide/show current player ESP billboards
    for _,b in ipairs(espFolder:GetChildren()) do
        if b:IsA("BillboardGui") and b.Name=="P_ESP" then
            b.Enabled = espPlayersOn
        end
    end
end)

-- platform step mode toggle (replaces old inf-jump)
local stepBtn = Instance.new(S.TextButton)
stepBtn.Size = UDim2.new(1,-20,0,30)
stepBtn.Position = UDim2.new(0,10,0,150)
stepBtn.Text = "Platform Steps: "..S.OFF
stepBtn.TextColor3 = Color3.new(1,1,1)
stepBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
stepBtn.Font = Enum.Font.SourceSansBold
stepBtn.TextSize = 16
stepBtn.Parent = fr
stepBtn.MouseButton1Click:Connect(function()
    stepModeOn = not stepModeOn
    stepBtn.Text = "Platform Steps: "..(stepModeOn and S.ON or S.OFF)
    if not stepModeOn then clearSteps() end
end)

-- SPEED control (keeps vertical velocity)
task.spawn(function()
    while true do
        if speedOn then
            local c = plr.Character
            if c and c:FindFirstChild(S.HRP) and c:FindFirstChild(S.Humanoid) then
                local hrp = c[S.HRP]
                local h = c[S.Humanoid]
                local dir = h.MoveDirection
                if dir.Magnitude > 0 then
                    hrp.Velocity = dir * desired + Vector3.new(0, hrp.Velocity.Y, 0)
                end
            end
        end
        task.wait(CFG.UPDATE_DT)
    end
end)

-- ====== STEP-PLATFORM JUMP (ceiling-safe) ======
local function roofDirectlyAbove(root, dist)
    dist = dist or 6
    local ray = Ray.new(root.Position, Vector3.new(0, dist, 0))
    local hit = workspace:FindPartOnRay(ray, plr.Character)
    return hit ~= nil, hit
end

UIS.JumpRequest:Connect(function()
    if not stepModeOn then return end
    local c = plr.Character
    if not c then return end
    local hum = c:FindFirstChild(S.Humanoid)
    local root = c:FindFirstChild(S.HRP)
    if not hum or hum.Health <= 0 or not root then return end

    -- if there's a solid roof within jump headroom, let Roblox kill you only when you actually hit it
    -- (we don't pre-kill; we just avoid spawning a step that would clip you into the roof)
    local hitRoof = roofDirectlyAbove(root, CFG.STEP_HEIGHT + 3)

    -- spawn the next step at a fixed increment so you land at that level naturally
    if not hitRoof then
        local nextY = root.Position.Y + CFG.STEP_HEIGHT
        local p = Instance.new("Part")
        p.Anchored, p.CanCollide = true, true
        p.Size = CFG.STEP_SIZE
        p.Transparency = CFG.PLATFORM_TRANSP
        p.Color = CFG.PLATFORM_COLOR
        p.Name = "NS_Step"
        p.CFrame = CFrame.new(Vector3.new(root.Position.X, nextY + CFG.STEP_Y_OFFSET, root.Position.Z))
        p.Parent = stepFolder
        pushStep(p)
    end

    -- perform a normal jump (natural physics)
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
end)

-- ====== PLAYER ESP (bigger name plates) ======
local function mkPlayerESP(tgt)
    if tgt == plr then return end
    if not tgt.Character or not tgt.Character:FindFirstChild(S.HRP) then return end
    local hrp = tgt.Character[S.HRP]

    local bb = Instance.new(S.BillboardGui)
    bb.Name = "P_ESP"
    bb.Size = UDim2.fromOffset(CFG.ESP_NAME_SCALE.X, CFG.ESP_NAME_SCALE.Y)
    bb.Adornee = hrp
    bb.AlwaysOnTop = true
    bb.Enabled = espPlayersOn
    bb.Parent = espFolder

    local lb = Instance.new(S.TextLabel)
    lb.Size = UDim2.new(1,0,1,0)
    lb.BackgroundTransparency = 1
    lb.TextColor3 = Color3.fromRGB(255,60,60)
    lb.TextStrokeTransparency = 0
    lb.TextScaled = true
    lb.Font = Enum.Font.GothamBold
    lb.Text = tgt.Name
    lb.Parent = bb

    -- keep it attached; destroy if they leave/die
    local conn; conn = RS.RenderStepped:Connect(function()
        if tgt.Character and tgt.Character:FindFirstChild(S.HRP) then
            bb.Adornee = tgt.Character[S.HRP]
        else
            if bb then bb:Destroy() end
            if conn then conn:Disconnect() end
        end
    end)
end

for _,p in ipairs(game.Players:GetPlayers()) do mkPlayerESP(p) end
game.Players.PlayerAdded:Connect(mkPlayerESP)

-- ====== BRAINROT ESP ======
local function mkBrainESP(part)
    if not part:IsA("BasePart") then return end
    local bb = Instance.new(S.BillboardGui)
    bb.Size = UDim2.fromOffset(CFG.ESP_BRAIN_SCALE.X, CFG.ESP_BRAIN_SCALE.Y)
    bb.Adornee = part
    bb.AlwaysOnTop = true
    bb.Parent = espFolder

    local lb = Instance.new(S.TextLabel)
    lb.Size = UDim2.new(1,0,1,0)
    lb.BackgroundTransparency = 1
    lb.TextColor3 = Color3.fromRGB(0,255,100)
    lb.TextStrokeTransparency = 0
    lb.TextScaled = true
    lb.Font = Enum.Font.GothamBold
    lb.Text = part.Name
    lb.Parent = bb

    local c; c = RS.RenderStepped:Connect(function()
        if part.Parent then
            bb.Adornee = part
        else
            if bb then bb:Destroy() end
            if c then c:Disconnect() end
        end
    end)
end

for _,fname in ipairs(CFG.BrainFolders) do
    local f = workspace:FindFirstChild(fname)
    if f then
        for _,ch in ipairs(f:GetChildren()) do mkBrainESP(ch) end
        f.ChildAdded:Connect(mkBrainESP)
    end
end

-- ====== BASE TIMER ESP ======
do
    local tf = workspace:FindFirstChild(S.TimerGui)
    if tf and tf:FindFirstChild(S.Timer) then
        local t = tf[S.Timer]
        local bb = Instance.new(S.BillboardGui)
        bb.Size = UDim2.fromOffset(CFG.TIMER_SCALE.X, CFG.TIMER_SCALE.Y)
        bb.Adornee = t
        bb.AlwaysOnTop = true
        bb.Parent = espFolder

        local lb = Instance.new(S.TextLabel)
        lb.Size = UDim2.new(1,0,1,0)
        lb.BackgroundTransparency = 1
        lb.TextColor3 = Color3.fromRGB(255,255,0)
        lb.TextStrokeTransparency = 0
        lb.TextScaled = true
        lb.Font = Enum.Font.GothamBold
        lb.Text = "Base Timer"
        lb.Parent = bb

        local c; c = RS.RenderStepped:Connect(function()
            if t.Parent then
                bb.Adornee = t
            else
                if bb then bb:Destroy() end
                if c then c:Disconnect() end
            end
        end)
    end
end

-- tidy up on respawn
plr.CharacterAdded:Connect(function()
    clearSteps()
end)
