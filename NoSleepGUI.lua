-- Long-obfuscated NoSleep GUI for Delta Executor (Speed Fixed)
local a=48
local b=game.Players.LocalPlayer
local c=game:GetService("RunService")
local d=game:GetService("UserInputService")
local e=game:GetService("Workspace")

-- Default variables
local f=16 -- current speed value
local MAX_SPEED=100
local SPEED_MULTIPLIER=5 -- makes slider feel faster
local g=true -- Player ESP toggle
local h=true -- Rainbow Platform toggle
local i=false -- Body Aura toggle
local speedEnabled = true -- Speed toggle

-- GUI setup
local j=Instance.new("Folder")
j.Name="NoSleepESP"
j.Parent=b:WaitForChild("PlayerGui")

local k=b:WaitForChild("PlayerGui"):FindFirstChild("NoSleepGUI") or Instance.new("ScreenGui")
k.Name="NoSleepGUI"
k.ResetOnSpawn=false
k.Parent=b:WaitForChild("PlayerGui")

local l=Instance.new("Frame")
l.Size=UDim2.new(0,300,0,220)
l.Position=UDim2.new(0,20,0,20)
l.Active=true
l.Draggable=true
l.BackgroundColor3=Color3.fromRGB(30,30,30)
l.Parent=k

-- Rainbow background animation
spawn(function()
    local m=0
    while true do
        l.BackgroundColor3=Color3.fromHSV(m,1,1)
        m=m+0.005
        if m>1 then m=0 end
        wait(0.03)
    end
end)

-- GUI labels
local n=Instance.new("TextLabel")
n.Size=UDim2.new(1,0,0,30)
n.Position=UDim2.new(0,0,0,0)
n.Text="No Sleep GUI"
n.TextColor3=Color3.fromRGB(255,255,255)
n.BackgroundTransparency=1
n.Font=Enum.Font.SourceSansBold
n.TextSize=18
n.Parent=l

-- ================= Speed Slider =================
local speedSliderFrame=Instance.new("Frame")
speedSliderFrame.Size=UDim2.new(1,-20,0,40)
speedSliderFrame.Position=UDim2.new(0,10,0,80)
speedSliderFrame.BackgroundColor3=Color3.fromRGB(50,50,50)
speedSliderFrame.Parent=l

local speedBar=Instance.new("Frame")
speedBar.Size=UDim2.new(f/a,0,1,0)
speedBar.BackgroundColor3=Color3.fromRGB(0,170,255)
speedBar.Parent=speedSliderFrame

local speedLabel=Instance.new("TextLabel")
speedLabel.Size=UDim2.new(1,0,0,20)
speedLabel.Position=UDim2.new(0,0,1,0)
speedLabel.BackgroundTransparency=1
speedLabel.TextColor3=Color3.fromRGB(255,255,255)
speedLabel.Text="Speed: "..f
speedLabel.Parent=l

-- Function to update slider
local function updateSlider(x)
    local u=math.clamp(x-speedSliderFrame.AbsolutePosition.X,0,speedSliderFrame.AbsoluteSize.X)
    local v=u/speedSliderFrame.AbsoluteSize.X
    f=math.floor(v*MAX_SPEED)
    speedBar.Size=UDim2.new(v,0,1,0)
    speedLabel.Text="Speed: "..f
end

-- Dragging logic
local dragging=false
speedSliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        updateSlider(input.Position.X)
    end
end)
speedSliderFrame.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)
d.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        updateSlider(input.Position.X)
    end
end)

-- Speed ON/OFF button
local speedToggleButton=Instance.new("TextButton")
speedToggleButton.Size=UDim2.new(1,-20,0,30)
speedToggleButton.Position=UDim2.new(0,10,0,130)
speedToggleButton.Text="Speed: ON"
speedToggleButton.TextColor3=Color3.fromRGB(255,255,255)
speedToggleButton.BackgroundColor3=Color3.fromRGB(70,70,70)
speedToggleButton.Font=Enum.Font.SourceSansBold
speedToggleButton.TextSize=16
speedToggleButton.Parent=l
speedToggleButton.MouseButton1Click:Connect(function()
    speedEnabled=not speedEnabled
    speedToggleButton.Text="Speed: "..(speedEnabled and "ON" or "OFF")
end)

-- ================= Other Toggles =================
local function t(w,x,y)
    local z=Instance.new("TextButton")
    z.Size=UDim2.new(1,-20,0,30)
    z.Position=UDim2.new(0,10,0,x)
    z.Text=w..": OFF"
    z.TextColor3=Color3.fromRGB(255,255,255)
    z.BackgroundColor3=Color3.fromRGB(70,70,70)
    z.Font=Enum.Font.SourceSansBold
    z.TextSize=16
    z.Parent=l
    local A=false
    z.MouseButton1Click:Connect(function()
        A=not A
        z.Text=w..": "..(A and "ON" or "OFF")
        y(A)
    end)
    return z
end
t("Player ESP",90,function(B) h=B end)
t("Rainbow Platform",130,function(B) i=B end)

-- ================= Grapple Movement =================
spawn(function()
    while true do
        local char=b.Character
        if char and char:FindFirstChild("HumanoidRootPart") and speedEnabled then
            local hrp=char.HumanoidRootPart
            local grapple=char:FindFirstChild("Grapple") or (b.Backpack and b.Backpack:FindFirstChild("Grapple"))
            if grapple and grapple:FindFirstChild("Handle") then
                if char:FindFirstChildOfClass("Tool")~=grapple then
                    grapple.Parent=char
                end
                if char:FindFirstChildOfClass("Tool")==grapple then
                    local direction=grapple.Handle.Position-hrp.Position
                    local distance=direction.Magnitude
                    if distance>0 then
                        -- Fixed speed: multiply slider by SPEED_MULTIPLIER
                        local velocity=direction.Unit*math.min(distance*2,f*SPEED_MULTIPLIER)
                        hrp.Velocity=Vector3.new(velocity.X,hrp.Velocity.Y,velocity.Z)
                    end
                end
            else
                hrp.Velocity=Vector3.new(0,hrp.Velocity.Y,0)
            end
        end
        wait(0.03)
    end
end)

-- ================= Body Aura =================
local Z=nil; local _=0
c.RenderStepped:Connect(function()
    if i then
        local aa=b.Character
        if aa and aa:FindFirstChild("HumanoidRootPart") then
            if not Z then
                Z=Instance.new("Part")
                Z.Size=Vector3.new(6,0.5,6)
                Z.Anchored=true
                Z.CanCollide=true
                Z.Material=Enum.Material.Neon
                Z.Parent=e
            end
            Z.Position=aa.HumanoidRootPart.Position-Vector3.new(0,3,0)
            Z.Color=Color3.fromHSV(_,1,1)
            _=_+0.005;if _>1 then _=0 end
        elseif Z then Z:Destroy(); Z=nil end
    elseif Z then Z:Destroy(); Z=nil end
end)
