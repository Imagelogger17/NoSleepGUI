-- High-speed grapple movement (max 1000) without lag-back
local MAX_SPEED = 1000
local ACCELERATION = 5 -- smooth acceleration factor
local DIAGONAL_BOOST = 1.3 -- diagonal boost
spawn(function()
    local velocity = Vector3.new(0,0,0)
    while true do
        local char = b.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local backpack = b:FindFirstChild("Backpack")
            local grapple = char:FindFirstChild("Grapple") or (backpack and backpack:FindFirstChild("Grapple"))

            if grapple then
                -- Auto-equip
                if char:FindFirstChildOfClass("Tool") ~= grapple then
                    grapple.Parent = char
                end

                -- Only move if grapple has a handle
                if char:FindFirstChildOfClass("Tool") == grapple and grapple:FindFirstChild("Handle") then
                    local direction = (grapple.Handle.Position - hrp.Position)
                    local distance = direction.Magnitude
                    if distance > 1 then
                        direction = direction.Unit
                    else
                        direction = Vector3.new(0,0,0)
                    end

                    local speed = math.min(f, MAX_SPEED)
                    local desiredVelocity = direction * speed

                    -- Diagonal boost
                    local moveDir = Vector3.new(direction.X,0,direction.Z)
                    if math.abs(moveDir.X) > 0 and math.abs(moveDir.Z) > 0 then
                        desiredVelocity = desiredVelocity * DIAGONAL_BOOST
                    end

                    -- Smooth acceleration
                    velocity = velocity:Lerp(desiredVelocity, ACCELERATION * 0.03)
                    hrp.Velocity = Vector3.new(velocity.X, hrp.Velocity.Y, velocity.Z)
                end
            end
        end
        wait(0.03)
    end
end)
