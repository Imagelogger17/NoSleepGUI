-- =========================
-- NoSleep GUI for Steal A Brainrot (Persistent ESP)
-- =========================
local b=game.Players.LocalPlayer
local c=game:GetService("RunService")
local d=game:GetService("UserInputService")
local e=game:GetService("Workspace")

local f=48
local g=16
local h=true
local i=true
local j=false

local k=Instance.new("Folder")
k.Name="NoSleepESP"
k.Parent=b:WaitForChild("PlayerGui")

local l=b:WaitForChild("PlayerGui"):FindFirstChild("NoSleepGUI") or Instance.new("ScreenGui")
l.Name="NoSleepGUI"
l.ResetOnSpawn=false
l.Parent=b:WaitForChild("PlayerGui")

local m=Instance.new("Frame")
m.Size=UDim2.new(0,300,0,220)
m.Position=UDim2.new(0,20,0,20)
m.Active=true
m.Draggable=true
m.BackgroundColor3=Color3.fromRGB(30,30,30)
m.Parent=l

spawn(function()
    local n=0
    while true do
        m.BackgroundColor3=Color3.fromHSV(n,1,1)
        n=n+0.005
        if n>1 then n=0 end
        wait(0.03)
    end
end)

local o=Instance.new("TextLabel")
o.Size=UDim2.new(1,0,0,30)
o.Position=UDim2.new(0,0,0,0)
o.Text="No Sleep GUI"
o.TextColor3=Color3.fromRGB(255,255,255)
o.BackgroundTransparency=1
o.Font=Enum.Font.SourceSansBold
o.TextSize=18
o.Parent=m

-- Speed slider
local p=Instance.new("Frame")
p.Size=UDim2.new(1,-20,0,40)
p.Position=UDim2.new(0,10,0,40)
p.BackgroundColor3=Color3.fromRGB(50,50,50)
p.Parent=m

local q=Instance.new("Frame")
q.Size=UDim2.new(g/f,0,1,0)
q.BackgroundColor3=Color3.fromRGB(0,170,255)
q.Parent=p

local r=Instance.new("TextLabel")
r.Size=UDim2.new(1,0,0,20)
r.Position=UDim2.new(0,0,1,0)
r.BackgroundTransparency=1
r.TextColor3=Color3.fromRGB(255,255,255)
r.Text="Speed: "..g
r.Parent=m

p.InputBegan:Connect(function(s)
    if s.UserInputType==Enum.UserInputType.Touch or s.UserInputType==Enum.UserInputType.MouseButton1 then
        local function t(u)
            local v=math.clamp(u-p.AbsolutePosition.X,0,p.AbsoluteSize.X)
            local w=v/p.AbsoluteSize.X
            g=math.floor(w*f)
            q.Size=UDim2.new(w,0,1,0)
            r.Text="Speed: "..g
        end
        t(s.Position.X)
    end
end)

-- Toggle Buttons
local function x(y,z,A)
    local B=Instance.new("TextButton")
    B.Size=UDim2.new(1,-20,0,30)
    B.Position=UDim2.new(0,10,0,z)
    B.Text=y..": OFF"
    B.TextColor3=Color3.fromRGB(255,255,255)
    B.BackgroundColor3=Color3.fromRGB(70,70,70)
    B.Font=Enum.Font.SourceSansBold
    B.TextSize=16
    B.Parent=m
    local C=false
    B.MouseButton1Click:Connect(function()
        C=not C
        B.Text=y..": "..(C and "ON" or "OFF")
        A(C)
    end)
    return B
end

x("Player ESP",90,function(D)i=D end)
x("Rainbow Platform",130,function(D)j=D end)

-- Speed control
spawn(function()
    while true do
        if h then
            local E=b.Character
            if E and E:FindFirstChild("HumanoidRootPart") and E:FindFirstChild("Humanoid") then
                local F=E.HumanoidRootPart
                local G=E.Humanoid
                local H=G.MoveDirection
                if H.Magnitude>0 then
                    F.Velocity=H*g+Vector3.new(0,F.Velocity.Y,0)
                end
            end
        end
        wait(0.03)
    end
end)

-- Player ESP persistent
local function I(J)
    if J==b then return end
    if not J.Character or not J.Character:FindFirstChild("HumanoidRootPart") then return end
    local K=J.Character.HumanoidRootPart
    local L=Instance.new("BillboardGui")
    L.Size=UDim2.new(0,150,0,70)
    L.Adornee=K
    L.AlwaysOnTop=true
    L.Parent=k

    local M=Instance.new("TextLabel")
    M.Size=UDim2.new(1,0,1,0)
    M.BackgroundTransparency=1
    M.TextColor3=Color3.fromRGB(255,0,0)
    M.TextStrokeTransparency=0
    M.TextScaled=true
    M.Text=J.Name
    M.Parent=L

    c.RenderStepped:Connect(function()
        if J.Character and J.Character:FindFirstChild("HumanoidRootPart") then
            L.Adornee=J.Character.HumanoidRootPart
        else
            -- Keep ESP even if dead
            if K then L.Adornee=K end
        end
    end)
end

for _,p in pairs(game.Players:GetPlayers()) do I(p) end
game.Players.PlayerAdded:Connect(function(p) I(p) end)

-- Brainrot ESP (highest)
local function N()
    local O=0
    local P=nil
    for _,Q in pairs({"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}) do
        local R=e:FindFirstChild(Q)
        if R then
            for _,S in pairs(R:GetChildren()) do
                local T=S:FindFirstChild("Value") and S.Value or 0
                if T>O then
                    O=T
                    P=S
                end
            end
        end
    end
    if P then
        local U=Instance.new("BillboardGui")
        U.Size=UDim2.new(0,150,0,50)
        U.Adornee=P
        U.AlwaysOnTop=true
        U.Parent=k

        local V=Instance.new("TextLabel")
        V.Size=UDim2.new(1,0,1,0)
        V.BackgroundTransparency=1
        V.TextColor3=Color3.fromRGB(0,255,0)
        V.TextStrokeTransparency=0
        V.TextScaled=true
        V.Text=P.Name.." $"..O
        V.Parent=U
    end
end
N()

-- Timer ESP
local W=e:FindFirstChild("TimerGui")
if W and W:FindFirstChild("Timer") then
    local X=W.Timer
    local Y=Instance.new("BillboardGui")
    Y.Size=UDim2.new(0,150,0,50)
    Y.Adornee=X
    Y.AlwaysOnTop=true
    Y.Parent=k

    local Z=Instance.new("TextLabel")
    Z.Size=UDim2.new(1,0,1,0)
    Z.BackgroundTransparency=1
    Z.TextColor3=Color3.fromRGB(255,255,0)
    Z.TextStrokeTransparency=0
    Z.TextScaled=true
    Z.Text="Base Timer"
    Z.Parent=Y
end

-- Rainbow Platform
local _=nil
local a=0
c.RenderStepped:Connect(function()
    if j then
        local aa=b.Character
        if aa and aa:FindFirstChild("HumanoidRootPart") then
            if not _ then
                _=Instance.new("Part")
                _.Size=Vector3.new(6,0.5,6)
                _.Anchored=true
                _.CanCollide=true
                _.Material=Enum.Material.Neon
                _.Parent=e
            end
            _.Position=aa.HumanoidRootPart.Position-Vector3.new(0,3,0)
            _.Color=Color3.fromHSV(a,1,1)
            a=a+0.005
            if a>1 then a=0 end
        elseif _ then
            _.Parent=nil
            _=nil
        end
    elseif _ then
        _.Parent=nil
        _=nil
    end
end)
