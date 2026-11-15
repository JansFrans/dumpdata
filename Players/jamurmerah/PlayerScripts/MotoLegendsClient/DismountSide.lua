-- https://lua.expert

local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("JerezRaceHUD", 30)

local function spotFor(p1, p2, p3, p4, p5) -- line: 13
    local v2 = RaycastParams.new()

    v2.FilterType = Enum.RaycastFilterType.Exclude
    v2.FilterDescendantsInstances = {
        p2,
        p1.Parent
    }

    local v3 = p1.Position + Vector3.new(0, 2, 0)
    local Position = (p1.CFrame * CFrame.new(p5 * 6, 2, 0)).Position
    local v4 = workspace:Raycast(v3, Position - v3, v2)

    if v4 and v4.Instance.CanCollide then
        return nil
    end

    local v5 = workspace:Raycast(Position + Vector3.new(0, 2, 0), Vector3.new(0, -10, 0), v2)

    return if v5 then Vector3.new(Position.X, v5.Position.Y + p3.HipHeight + p4.Size.Y / 2 + 0.2, Position.Z) else nil
end

local function inBike(p6, p7) -- line: 26
    local v7 = p6.CFrame:PointToObjectSpace(p7.Position)

    if math.abs(v7.X) < 2.6 then
        if not (math.abs(v7.Z) < 4.5) then
            return false
        end

        return math.abs(v7.Y) < 6
    end

    return false
end

local function place(p8, p9, p10) -- line: 31
    -- upvalues: v1 (copy), spotFor (copy)
    local Parent = p8.Parent
    local v8 = Parent and Parent.PrimaryPart
    local HumanoidRootPart = p9:FindFirstChild("HumanoidRootPart")

    if v8 and HumanoidRootPart then
        for _, v9 in { 0, 0.1, 0.25, 0.45 } do
            if v9 > 0 then
                task.wait(v9)
            end

            if not p9.Parent
                or p10.Health <= 0
                or p10.SeatPart
                or not v8.Parent
                or (Parent:GetAttribute("Crash") or "") ~= ""
                or (v8:GetAttribute("LossStage") or "") ~= ""
                or v1 and v1:GetAttribute("Freecam") == true then
                return
            end

            local AssemblyLinearVelocity = v8.AssemblyLinearVelocity

            if Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude > 3 and not v8.Anchored then
                return
            end

            local v10 = v8.CFrame:PointToObjectSpace(HumanoidRootPart.Position)

            if math.abs(v10.X) < 2.6 and math.abs(v10.Z) < 4.5 and math.abs(v10.Y) < 6 then
                local v11 = spotFor(v8, p9, p10, HumanoidRootPart, 1) or spotFor(v8, p9, p10, HumanoidRootPart, -1)

                if v11 then
                    p9:PivotTo(CFrame.lookAt(v11, v11 + Vector3.new(v8.CFrame.LookVector.X, 0, v8.CFrame.LookVector.Z)))
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
end

local function watch(p11) -- line: 52
    -- upvalues: place (copy)
    local v12 = p11:WaitForChild("Humanoid", 10)

    if not v12 then
        return
    end

    local SeatPart = v12.SeatPart

    v12:GetPropertyChangedSignal("SeatPart"):Connect(function() -- line: 55
        -- upvalues: p11 (copy), v12 (copy), SeatPart (ref), place (copy)
        local SeatPart2 = v12.SeatPart

        if SeatPart and not SeatPart2 and SeatPart.Name == "RiderSeat" then
            task.spawn(place, SeatPart, p11, v12)
        end

        SeatPart = SeatPart2
    end)
end

LocalPlayer.CharacterAdded:Connect(watch)

if LocalPlayer.Character then
    task.spawn(watch, LocalPlayer.Character)
end
