-- Long-obfuscated NoSleep GUI for Delta Executor
local a=48;local b=game.Players.LocalPlayer;local c=game:GetService("RunService");local d=game:GetService("UserInputService");local e=game:GetService("Workspace")
local f=16;local g=true;local h=true;local i=false
local j=Instance.new("Folder");j.Name="NoSleepESP";j.Parent=b:WaitForChild("PlayerGui")
local k=b:WaitForChild("PlayerGui"):FindFirstChild("NoSleepGUI") or Instance.new("ScreenGui");k.Name="NoSleepGUI";k.ResetOnSpawn=false;k.Parent=b:WaitForChild("PlayerGui")
local l=Instance.new("Frame");l.Size=UDim2.new(0,300,0,220);l.Position=UDim2.new(0,20,0,20);l.Active=true;l.Draggable=true;l.BackgroundColor3=Color3.fromRGB(30,30,30);l.Parent=k
spawn(function()local m=0;while true do l.BackgroundColor3=Color3.fromHSV(m,1,1);m=m+0.005;if m>1 then m=0 end;wait(0.03)end end)
local n=Instance.new("TextLabel");n.Size=UDim2.new(1,0,0,30);n.Position=UDim2.new(0,0,0,0);n.Text="No Sleep GUI";n.TextColor3=Color3.fromRGB(255,255,255);n.BackgroundTransparency=1;n.Font=Enum.Font.SourceSansBold;n.TextSize=18;n.Parent=l
local o=Instance.new("Frame");o.Size=UDim2.new(1,-20,0,40);o.Position=UDim2.new(0,10,0,40);o.BackgroundColor3=Color3.fromRGB(50,50,50);o.Parent=l
local p=Instance.new("Frame");p.Size=UDim2.new(f/a,0,1,0);p.BackgroundColor3=Color3.fromRGB(0,170,255);p.Parent=o
local q=Instance.new("TextLabel");q.Size=UDim2.new(1,0,0,20);q.Position=UDim2.new(0,0,1,0);q.BackgroundTransparency=1;q.TextColor3=Color3.fromRGB(255,255,255);q.Text="Speed: "..f;q.Parent=l
o.InputBegan:Connect(function(r)if r.UserInputType==Enum.UserInputType.Touch or r.UserInputType==Enum.UserInputType.MouseButton1 then local function s(t)local u=math.clamp(t-o.AbsolutePosition.X,0,o.AbsoluteSize.X)local v=u/o.AbsoluteSize.X;f=math.floor(v*a);p.Size=UDim2.new(v,0,1,0);q.Text="Speed: "..f end;s(r.Position.X)end end)
local function t(w,x,y)local z=Instance.new("TextButton");z.Size=UDim2.new(1,-20,0,30);z.Position=UDim2.new(0,10,0,x);z.Text=w..": OFF";z.TextColor3=Color3.fromRGB(255,255,255);z.BackgroundColor3=Color3.fromRGB(70,70,70);z.Font=Enum.Font.SourceSansBold;z.TextSize=16;z.Parent=l;local A=false;z.MouseButton1Click:Connect(function()A=not A;z.Text=w..": "..(A and "ON" or "OFF");y(A)end);return z end
local a=48; local b=game.Players.LocalPlayer; local c=game:GetService("RunService"); local d=game:GetService("UserInputService"); local e=game:GetService("Workspace")
local f=16; local g=true; local h=true; local i=false
local MAX_SPEED = 100 -- Max speed for grapple movement

-- GUI setup
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
spawn(function()while true do if g then local C=b.Character;if C and C:FindFirstChild("HumanoidRootPart") and C:FindFirstChild("Humanoid") then local D=C.HumanoidRootPart;local E=C.Humanoid;local F=E.MoveDirection;if F.Magnitude>0 then D.Velocity=F*f+Vector3.new(0,D.Velocity.Y,0)end end end;wait(0.03)end end)
local function G(H)if H==b then return end;if not H.Character or not H.Character:FindFirstChild("HumanoidRootPart") then return end;local I=H.Character.HumanoidRootPart;local J=Instance.new("BillboardGui");J.Size=UDim2.new(0,150,0,70);J.Adornee=I;J.AlwaysOnTop=true;J.Parent=j;local K=Instance.new("TextLabel");K.Size=UDim2.new(1,0,1,0);K.BackgroundTransparency=1;K.TextColor3=Color3.fromRGB(255,0,0);K.TextStrokeTransparency=0;K.TextScaled=true;K.Text=H.Name;K.Parent=J;c.RenderStepped:Connect(function()if H.Character and H.Character:FindFirstChild("HumanoidRootPart") then J.Adornee=H.Character.HumanoidRootPart else J:Destroy()end end)end

-- Grapple-only movement
spawn(function()
    while true do
        local char = b.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local backpack = b:FindFirstChild("Backpack")
            local grapple = char:FindFirstChild("Grapple") or (backpack and backpack:FindFirstChild("Grapple"))

            if grapple then
                -- Force equip grapple if not equipped
                if char:FindFirstChildOfClass("Tool") ~= grapple then
                    grapple.Parent = char
                end

                -- Move only if grapple is equipped and has a Handle
                if char:FindFirstChildOfClass("Tool") == grapple and grapple:FindFirstChild("Handle") then
                    local targetPos = grapple.Handle.Position
                    local direction = (targetPos - hrp.Position)
                    local distance = direction.Magnitude
                    local currentSpeed = math.min(f, MAX_SPEED)
                    local velocity = direction.Unit * math.min(distance * 2, currentSpeed)
                    hrp.Velocity = Vector3.new(velocity.X, hrp.Velocity.Y, velocity.Z)
                else
                    hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
                end
            else
                hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
            end
        end
        wait(0.03)
    end
end)

-- ESP & Brainrot display (unchanged from original)
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
game.Players.PlayerAdded:Connect(function(L)G(L) end)
local function M()local N=0;local O=nil;for _,P in pairs({"IgnoreBrainrots","Brainrot God","Brainrots","BrainrotName"}) do local Q=e:FindFirstChild(P);if Q then for _,R in pairs(Q:GetChildren()) do local S=R:FindFirstChild("Value") and R.Value or 0;if S>N then N=S;O=R end end end end;if O then local T=Instance.new("BillboardGui");T.Size=UDim2.new(0,150,0,50);T.Adornee=O;T.AlwaysOnTop=true;T.Parent=j;local U=Instance.new("TextLabel");U.Size=UDim2.new(1,0,1,0);U.BackgroundTransparency=1;U.TextColor3=Color3.fromRGB(0,255,0);U.TextStrokeTransparency=0;U.TextScaled=true;U.Text=O.Name.." $"..N;U.Parent=T end end
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
local V=e:FindFirstChild("TimerGui");if V and V:FindFirstChild("Timer") then local W=V.Timer;local X=Instance.new("BillboardGui");X.Size=UDim2.new(0,150,0,50);X.Adornee=W;X.AlwaysOnTop=true;X.Parent=j;local Y=Instance.new("TextLabel");Y.Size=UDim2.new(1,0,1,0);Y.BackgroundTransparency=1;Y.TextColor3=Color3.fromRGB(255,255,0);Y.TextStrokeTransparency=0;Y.TextScaled=true;Y.Text="Base Timer";Y.Parent=X end
local Z=nil;local _=0;c.RenderStepped:Connect(function()if i then local aa=b.Character;if aa and aa:FindFirstChild("HumanoidRootPart") then if not Z then Z=Instance.new("Part");Z.Size=Vector3.new(6,0.5,6);Z.Anchored=true;Z.CanCollide=true;Z.Material=Enum.Material.Neon;Z.Parent=e end;Z.Position=aa.HumanoidRootPart.Position-Vector3.new(0,3,0);Z.Color=Color3.fromHSV(_,1,1);_=_+0.005;if _>1 then _=0 end elseif Z then Z:Destroy();Z=nil end elseif Z then Z:Destroy();Z=nil end end)
