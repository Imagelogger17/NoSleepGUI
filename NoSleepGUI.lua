-- Long-obfuscated NoSleep GUI for Delta Executor (Custom Regular Speed)
local a=48
local b=game.Players.LocalPlayer
local c=game:GetService("RunService")
local d=game:GetService("UserInputService")
local e=game:GetService("Workspace")

-- Default variables
local REGULAR_SPEED = 100 -- default walking/running speed
local speedEnabled = true -- toggle
local g=true -- Player ESP toggle
local h=true -- Rainbow Platform toggle
local i=false -- Body Aura toggle

-- GUI setup
local j=Instance.new("Folder")
j.Name="NoSleepESP"
j.Parent=b:WaitForChild("PlayerGui")

local k=b:WaitForChild("PlayerGui"):FindFirstChild("NoSleepGUI") or Instance.new("ScreenGui")
k.Name="NoSleepGUI"
k.ResetOnSpawn=false
k.Parent=b:WaitForChild("PlayerGui")

local l=Instance.new("Frame")
l.Size=UDim2.new(0,300,0,260)
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

-- ================= Speed Toggle =================
local speedToggleButton = Instance.new("TextButton")
speedToggleButton.Size = UDim2.new(1,-20,0,30)
speedToggleButton.Position = UDim2.new(0,10,0,80)
speedToggleButton.Text = "Speed: ON"
speedToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
speedToggleButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
speedToggleButton.Font = Enum.Font.SourceSansBold
speedToggleButton.TextSize = 16
speedToggleButton.Parent = l

speedToggleButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedToggleButton.Text = "Speed: "..(speedEnabled and "ON" or "OFF")
end)

-- ================= Custom Speed Input =================
local speedInputLabel = Instance.new("TextLabel")
speedInputLabel.Size = UDim2.new(1,0,0,20)
speedInputLabel.Position = UDim2.new(0,10,0,120)
speedInputLabel.BackgroundTransparency = 1
speedInputLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedInputLabel.Text = "Set Speed:"
speedInputLabel.Font = Enum.Font.SourceSansBold
speedInputLabel.TextSize = 16
speedInputLabel.Parent = l

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(1,-20,0,30)
speedInput.Position = UDim2.new(0,10,0,140)
speedInput.Text = tostring(REGULAR_SPEED)
speedInput.TextColor3 = Color3.fromRGB(0,0,0)
speedInput.BackgroundColor3 = Color3.fromRGB(200,200,200)
speedInput.Font = Enum.Font.SourceSans
speedInput.TextSize = 16
speedInput.ClearTextOnFocus = false
speedInput.Parent = l

speedInput.FocusLost:Connect(function(enterPressed)
    local value = tonumber(speedInput.Text)
    if value and value>0 then
        REGULAR_SPEED = value
    else
        speedInput.Text = tostring(REGULAR_SPEED)
    end
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
t("Player ESP",180,function(B) g=B end)
t("Rainbow Platform",220,function(B) h=B end)
t("Body Aura",260,function(B) i=B end)

-- ================= Regular Speed Loop =================
spawn(function()
    while true do
        local char = b.Character
        if char and char:FindFirstChild("Humanoid") then
            local humanoid = char.Humanoid
            if speedEnabled then
                humanoid.WalkSpeed = REGULAR_SPEED
            else
                humanoid.WalkSpeed = 16 -- default Roblox speed
            end
        end
        wait(0.1)
    end
end)
