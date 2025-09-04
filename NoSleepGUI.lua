-- Obfuscated No Sleep GUI for Steal A Brainrot
local A,B,C,D,E,F,G,H,I=48,game.Players.LocalPlayer,game:GetService("RunService"),game:GetService("UserInputService"),16,true,true,false
local J,K,L={},workspace:WaitForChild("Platforms"),0
for _,M in pairs(L:GetChildren())do table.insert(J,M)end
table.sort(J,function(a,b)return a.Position.Y<b.Position.Y end)
local N=#J
local O=Instance.new("Folder")O.Name="NoSleepESP" O.Parent=B:WaitForChild("PlayerGui")
local P=B:WaitForChild("PlayerGui"):FindFirstChild("NoSleepGUI")or Instance.new("ScreenGui")P.Name="NoSleepGUI" P.ResetOnSpawn=false P.Parent=B:WaitForChild("PlayerGui")
local Q=Instance.new("Frame")Q.Size=UDim2.new(0,300,0,250) Q.Position=UDim2.new(0,20,0,20) Q.Active=true Q.Draggable=true Q.BackgroundColor3=Color3.fromRGB(30,30,30) Q.Parent=P
spawn(function()local R=0 while true do Q.BackgroundColor3=Color3.fromHSV(R,1,1) R=R+0.005 if R>1 then R=0 end wait(0.03)end end)
local S=Instance.new("TextLabel")S.Size=UDim2.new(1,0,0,30) S.Position=UDim2.new(0,0,0,0) S.Text="No Sleep GUI" S.TextColor3=Color3.fromRGB(255,255,255) S.BackgroundTransparency=1 S.Font=Enum.Font.SourceSansBold S.TextSize=18 S.Parent=Q
local T=Instance.new("Frame")T.Size=UDim2.new(1,-20,0,40) T.Position=UDim2.new(0,10,0,40) T.BackgroundColor3=Color3.fromRGB(50,50,50) T.Parent=Q
local U=Instance.new("Frame")U.Size=UDim2.new(E/A,0,1,0) U.BackgroundColor3=Color3.fromRGB(0,170,255) U.Parent=T
local V=Instance.new("TextLabel")V.Size=UDim2.new(1,0,0,20) V.Position=UDim2.new(0,0,1,0) V.BackgroundTransparency=1 V.TextColor3=Color3.fromRGB(255,255,255) V.Text="Speed: "..E V.Parent=Q
local W=Instance.new("TextButton")W.Size=UDim2.new(1,-20,0,30) W.Position=UDim2.new(0,10,0,90) W.Text="Player ESP: ON" W.TextColor3=Color3.fromRGB(255,255,255) W.BackgroundColor3=Color3.fromRGB(70,70,70) W.Font=Enum.Font.SourceSansBold W.TextSize=16 W.Parent=Q
W.MouseButton1Click:Connect(function() F=not F W.Text="Player ESP: "..(F and "ON" or "OFF") end)
local X=Instance.new("TextButton")X.Size=UDim2.new(1,-20,0,30) X.Position=UDim2.new(0,10,0,130) X.Text="Infinite Jump: OFF" X.TextColor3=Color3.fromRGB(255,255,255) X.BackgroundColor3=Color3.fromRGB(70,70,70) X.Font=Enum.Font.SourceSansBold X.TextSize=16 X.Parent=Q
X.MouseButton1Click:Connect(function() I=not I X.Text="Infinite Jump: "..(I and "ON" or "OFF") end)
local Y=Instance.new("TextButton")Y.Size=UDim2.new(1,-20,0,30) Y.Position=UDim2.new(0,10,0,170) Y.Text="Platform Jump: OFF" Y.TextColor3=Color3.fromRGB(255,255,255) Y.BackgroundColor3=Color3.fromRGB(70,70,70) Y.Font=Enum.Font.SourceSansBold Y.TextSize=16 Y.Parent=Q
Y.MouseButton1Click:Connect(function() H=not H Y.Text="Platform Jump: "..(H and "ON" or "OFF") end)
T.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then local function Z(posX)local aa=math.clamp(posX-T.AbsolutePosition.X,0,T.AbsoluteSize.X)local ab=aa/T.AbsoluteSize.X E=math.floor(ab*A) U.Size=UDim2.new(ab,0,1,0) V.Text="Speed: "..E end Z(input.Position.X) end end)
spawn(function() while true do if B and B.Character and B.Character:FindFirstChild("HumanoidRootPart")and B.Character:FindFirstChild("Humanoid") then local ac=B.Character.HumanoidRootPart local ad=B.Character.Humanoid local ae=ad.MoveDirection if ae.Magnitude>0 then ac.Velocity=ae*E+Vector3.new(0,ac.Velocity.Y,0) end end wait(0.03) end end)
UserInputService.JumpRequest:Connect(function() local af=B.Character if af and af:FindFirstChild("Humanoid")and af.Humanoid.Health>0 then local ag=af.Humanoid local ah=af:FindFirstChild("HumanoidRootPart") if I and ah then local ai=Ray.new(ah.Position,Vector3.new(0,3,0)) local aj,ak=workspace:FindPartOnRay(ai,af) if aj then ag.Health=0 else ag:ChangeState(Enum.HumanoidStateType.Jumping) end end if H and ah then L=math.min(L+1,N) local al=J[L] if al then ah.CFrame=CFrame.new(al.Position+Vector3.new(0,al.Size.Y/2+3,0)) end end end end)
local function am(targetPlayer) if targetPlayer==B then return end if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end local an=targetPlayer.Character.HumanoidRootPart local ao=Instance.new("BillboardGui") ao.Size=UDim2.new(0,200,0,100) ao.Adornee=an ao.AlwaysOnTop=true ao.Parent=O local ap=Instance.new("TextLabel") ap.Size=UDim2.new(1,0,1,0) ap.BackgroundTransparency=1 ap.TextColor3=Color3.fromRGB(255,0,0) ap.TextStrokeTransparency=0 ap.TextScaled=true ap.Text=targetPlayer.Name ap.Parent=ao RunService.RenderStepped:Connect(function() if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then ao.Adornee=targetPlayer.Character.HumanoidRootPart else ao:Destroy() end end) end
for _,p in pairs(game.Players:GetPlayers())do am(p) end
game.Players.PlayerAdded:Connect(function(p) am(p) end)
