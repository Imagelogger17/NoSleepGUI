-- NoSleep GUI for Delta Executor (Free High-Speed Linear Movement)
local a=48; local b=game.Players.LocalPlayer
local c=game:GetService("RunService")
local d=game:GetService("UserInputService")
local e=game:GetService("Workspace")

local f=16; local g=true; local h=true; local i=false
local MAX_SPEED = 1000
local ACCELERATION = 5

-- GUI Setup
local j=Instance.new("Folder"); j.Name="NoSleepESP"; j.Parent=b:WaitForChild("PlayerGui")
local k=b:WaitForChild("PlayerGui"):FindFirstChild("NoSleepGUI") or Instance.new("ScreenGui"); k.Name="NoSleepGUI"; k.ResetOnSpawn=false; k.Parent=b:WaitForChild("PlayerGui")
local l=Instance.new("Frame"); l.Size=UDim2.new(0,300,0,220); l.Position=UDim2.new(0,20,0,20); l.Active=true; l.Draggable=true; l.BackgroundColor3=Color3.fromRGB(30,30,30); l.Parent=k
spawn(function() local m=0; while true do l.BackgroundColor3=Color3.fromHSV(m,1,1); m=m+0.005; if m>1 then m=0 end; wait(0.03) end end)
local n=Instance.new("TextLabel"); n.Size=UDim2.new(1,0,0,30); n.Position=UDim2.new(0,0,0,0); n.Text="No Sleep GUI"; n.TextColor3=Color3.fromRGB(255,255,255); n.BackgroundTransparency=1; n.Font=Enum.Font.SourceSansBold; n.TextSize=18; n.Parent=l
local o=Instance.new("Frame"); o.Size=UDim2.new(1,-20,0,40); o.Position=UDim2.new(0,10,0,40); o.BackgroundColor3=Color3.fromRGB(50,50,50); o.Parent=l
local p=Instance.new("Frame"); p.Size=UDim2.new(f/a,0,1,0); p.BackgroundColor3=Color3.fromRGB(0,170,255); p.Parent=o
local q=Instance.new("TextLabel"); q.Size=UDim2.new(1,0,0,20); q.Position=UDim2.new(0,0,1,0); q.BackgroundTransparency=1; q.TextColor3=Color3.fromRGB(255,255,255); q.Text="Speed: "..f; q.Parent=l

-- Speed slider
o.InputBegan:Connect(function(r)
    if r.UserInputType==Enum.UserInputType.Touch or r.UserInputType==Enum.UserInputType.MouseButton1 then
        local function s(t)
            local u=math.clamp(t-o.AbsolutePosition.X,0,o.AbsoluteSize.X)
            local v=u/o.AbsoluteSize.X
            f=math.floor(v*a)
            p.Size=UDim2.new(v,0,1,0)
            q.Text="Speed: "..f
        end
        s(r.Position.X)
    end
end)

-- Toggle buttons
local function t(w,x,y)
    local z=Instance.new("TextButton"); z.Size=UDim2.new(1,-20,0,30); z.Position=UDim2.new(0,10,0,x); z.Text=w..": OFF"; z.TextColor3=Color3.fromRGB(255,255,255); z.BackgroundColor3=Color3.fromRGB(70,70,70); z.Font=Enum.Font.SourceSansBold; z.TextSize=16; z.Parent=l
    local A=false
    z.MouseButton1Click:Connect(function()
        A=not A
        z.Text=w..": "..(A and "ON" or "OFF")
        y(A)
    end)
    return z
end
t("Player ESP",90,function(B)h=B end)
t("Rainbow Platform",130,function(B)i=B end)

-- Free high-speed linear movement (no diagonal boost)
spawn(function()
    local velocity = Vector3.new(0,0,0)
    while true do
        local char = b.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    local desiredVelocity = moveDir.Unit * math.min(f, MAX_SPEED)

                    -- Smooth acceleration
                    velocity = velocity:Lerp(desiredVelocity, ACCELERATION * 0.03)
                    hrp.Velocity = Vector3.new(velocity.X, hrp.Velocity.Y, velocity.Z)
                else
                    -- Smooth deceleration
                    velocity = velocity:Lerp(Vector3.new(0,0,0), 0.2)
                    hrp.Velocity = Vector3.new(velocity.X, hrp.Velocity.Y, velocity.Z)
                end
            end
        end
        wait(0.03)
    end
end)

-- ESP & Brainrot display
local function G(H)
    if H==b then return end
    if not H.Character or not H.Character:FindFirstChild("HumanoidRootPart") then return end
    local I=H.Character.HumanoidRootPart
    local J=Instance.new("BillboardGui"); J.Size=UDim2.new(0,150,0,70); J.Adornee=I; J.AlwaysOnTop=true; J.Parent=j
    local K=Instance.new("TextLabel"); K.Size=UDim2.new(1,0,1,0); K.BackgroundTransparency=1; K.TextColor3=Color3.fromRGB(255,0,0); K.TextStrokeTransparency=0; K.TextScaled=true; K.Text=H.Name; K.Parent=J
    c.RenderStepped:Connect(function()
        if H.Character and H.Character:FindFirstChild("HumanoidRootPart") then J.Adornee=H.Character.HumanoidRootPart else J:Destroy() end
    end)
end
for _,L in pairs(game.Players:GetPlayers()) do G(L) end
game.Players.PlayerAdded:Connect(function(L) G(L) end)

local function M()
    local N=0
    local O=nil
    for _,P in pairs({"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}) do
        local Q=e:FindFirstChild(P)
        if Q then
            for _,R in pairs(Q:GetChildren()) do
                local S=R:FindFirstChild("Value") and R.Value or 0
                if S>N then N=S; O=R end
            end
        end
    end
    if O then
        local T=Instance.new("BillboardGui"); T.Size=UDim2.new(0,150,0,50); T.Adornee=O; T.AlwaysOnTop=true; T.Parent=j
        local U=Instance.new("TextLabel"); U.Size=UDim2.new(1,0,1,0); U.BackgroundTransparency=1; U.TextColor3=Color3.fromRGB(0,255,0); U.TextStrokeTransparency=0; U.TextScaled=true; U.Text=O.Name.." $"..N; U.Parent=T
    end
end
M()
