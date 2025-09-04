-- =========================
-- No Sleep GUI Obfuscated
-- =========================

local a=48
local b=game.Players.LocalPlayer
local c=game:GetService("RunService")
local d=game:GetService("UserInputService")
local e=game:GetService("PhysicsService")

local f=16
local g=true
local h=true
local i=false

local j=Vector3.new(6,1,6)
local k=6
local l=10
local m=0

local n=Instance.new("Folder")
n.Name="NoSleepESP"
n.Parent=b:WaitForChild("PlayerGui")

local o=b:WaitForChild("PlayerGui"):FindFirstChild("NoSleepGUI") or Instance.new("ScreenGui")
o.Name="NoSleepGUI"
o.ResetOnSpawn=false
o.Parent=b:WaitForChild("PlayerGui")

local p=Instance.new("Frame")
p.Size=UDim2.new(0,300,0,220)
p.Position=UDim2.new(0,20,0,20)
p.Active=true
p.Draggable=true
p.BackgroundColor3=Color3.fromRGB(30,30,30)
p.Parent=o

spawn(function()
 local q=0
 while true do
  p.BackgroundColor3=Color3.fromHSV(q,1,1)
  q=q+0.005
  if q>1 then q=0 end
  wait(0.03)
 end
end)

local r=Instance.new("TextLabel")
r.Size=UDim2.new(1,0,0,30)
r.Position=UDim2.new(0,0,0,0)
r.Text="No Sleep GUI"
r.TextColor3=Color3.fromRGB(255,255,255)
r.BackgroundTransparency=1
r.Font=Enum.Font.SourceSansBold
r.TextSize=18
r.Parent=p

local s=Instance.new("Frame")
s.Size=UDim2.new(1,-20,0,40)
s.Position=UDim2.new(0,10,0,40)
s.BackgroundColor3=Color3.fromRGB(50,50,50)
s.Parent=p

local t=Instance.new("Frame")
t.Size=UDim2.new(f/a,0,1,0)
t.BackgroundColor3=Color3.fromRGB(0,170,255)
t.Parent=s

local u=Instance.new("TextLabel")
u.Size=UDim2.new(1,0,0,20)
u.Position=UDim2.new(0,0,1,0)
u.BackgroundTransparency=1
u.TextColor3=Color3.fromRGB(255,255,255)
u.Text="Speed: "..f
u.Parent=p

-- SPEED CONTROL
spawn(function()
 while true do
  if g then
   local v=b.Character
   if v and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
    local w=v.HumanoidRootPart
    local x=v.Humanoid
    local y=x.MoveDirection
    if y.Magnitude>0 then
     w.Velocity=y*f+Vector3.new(0,w.Velocity.Y,0)
    end
   end
  end
  wait(0.03)
 end
end)

-- MULTI-LEVEL JUMP
local function z(A)
 local B=Instance.new("Part")
 B.Size=j
 B.Position=A
 B.Anchored=true
 B.CanCollide=true
 B.Transparency=0.5
 B.CastShadow=false
 B.Parent=workspace
 pcall(function() e:SetPartCollisionGroup(B,"NoCollision") end)
 game:GetService("Debris"):AddItem(B,l)
end

d.JumpRequest:Connect(function()
 if i then
  local C=b.Character
  if C and C:FindFirstChild("Humanoid") and C.Humanoid.Health>0 then
   local D=C.HumanoidRootPart
   local pos=D.Position+Vector3.new(0,k*m,0)
   z(pos)
   C.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
   m=m+1
  end
 end
end)
