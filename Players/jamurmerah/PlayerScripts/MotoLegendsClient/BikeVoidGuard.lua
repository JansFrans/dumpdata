-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local v1 = RaycastParams.new()

v1.FilterType = Enum.RaycastFilterType.Include

local n1 = 0

local function refresh() -- line: 24
    -- upvalues: v1 (copy)
    local t1 = {
        workspace.Terrain
    }
    local v2 = workspace:FindFirstChild("RaceCollision", true)

    if v2 then
        table.insert(t1, v2)
    end

    v1.FilterDescendantsInstances = t1
end

local t2 = {
    workspace.Terrain
}
local v3 = workspace:FindFirstChild("RaceCollision", true)

if v3 then
    table.insert(t2, v3)
end

v1.FilterDescendantsInstances = t2

local function isFloor(p1) -- line: 30
    if not p1 then
        return p1
    end

    if p1.Normal.Y > 0.5 then
        return p1.Instance:GetAttribute("Surface") ~= "Barrier"
    end

    return false
end

local function myBike() -- line: 32
    -- upvalues: LocalPlayer (copy)
    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if RaceBikes then
        for _, child in RaceBikes:GetChildren() do
            if child:IsA("Model") and child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                return child
            end
        end
    end

    return nil
end

local t3 = {
    bike = nil,
    last = nil,
    sampleAt = 0,
    liftAt = 0,
    above = 1.4,
    safe = {}
}

local function reset(p2) -- line: 39
    -- upvalues: t3 (copy)
    t3.bike = p2
    t3.last = nil
    table.clear(t3.safe)
    t3.sampleAt = 0
    t3.groundY = nil
end

local function stop(p3) -- line: 40
    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("BasePart") and not descendant.Anchored then
            descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            descendant.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end
end

local n2 = 0

RunService.PostSimulation:Connect(function() -- line: 47
    -- upvalues: v1 (copy), n1 (ref), myBike (copy), t3 (copy), stop (copy), n2 (ref)
    local elapsed = os.clock()

    if n1 < elapsed then
        n1 = elapsed + 5

        local t4 = {
            workspace.Terrain
        }
        local v4 = workspace:FindFirstChild("RaceCollision", true)

        if v4 then
            table.insert(t4, v4)
        end

        v1.FilterDescendantsInstances = t4
    end

    local bike = t3.bike
    local v5 = bike
    local v6

    if not (bike and bike.Parent) then
        if elapsed < n2 then
            return
        end

        n2 = elapsed + 0.5
        v6 = myBike()
        v5 = v6

        if v6 ~= t3.bike then
            t3.bike = v6
            t3.last = nil
            table.clear(t3.safe)
            t3.sampleAt = 0
            t3.groundY = nil
        end

        if not v6 then
            return
        end
    else
        v6 = bike
    end

    local PrimaryPart = v6.PrimaryPart
    local Position, Y

    if not PrimaryPart or PrimaryPart.Anchored then
        t3.last = nil

        return
    else
        Position = PrimaryPart.Position

        local last = t3.last

        if last and (Position - last).Magnitude > 0.05 and (Position - last).Magnitude < 80 then
            local v8 = workspace:Raycast(last, Position - last, v1)

            if v8 and v8.Normal.Y > 0.5 and v8.Instance:GetAttribute("Surface") ~= "Barrier" and v8.Position.Y - Position.Y > 0.9 then
                Y = v8.Position.Y
            end
        end
    end

    local Y2 = Y

    if not Y then
        local v9 = workspace:Raycast(Position + Vector3.new(0, 3, 0), Vector3.new(-0, -3, -0, -0), v1)

        if v9 and v9.Normal.Y > 0.5 and v9.Instance:GetAttribute("Surface") ~= "Barrier" and v9.Position.Y - Position.Y > 0.9 then
            Y2 = v9.Position.Y
        end
    end

    if not (Y2 and elapsed - t3.liftAt >= 0.2) then
        if t3.sampleAt <= elapsed then
            t3.sampleAt = elapsed + 0.25

            local v10 = workspace:Raycast(Position + Vector3.new(0, 2, 0), Vector3.new(-0, -8, -0, -0), v1)

            if v10 and v10.Normal.Y > 0.5 and v10.Instance:GetAttribute("Surface") ~= "Barrier" and Position.Y - v10.Position.Y < 4 then
                t3.groundY = v10.Position.Y
                t3.above = math.clamp(Position.Y - v10.Position.Y, 0.8, 2.5)

                local LookVector = PrimaryPart.CFrame.LookVector
                local v12 = Vector3.new(LookVector.X, 0, LookVector.Z)
                local v13 = v12.Magnitude > 0.1 and CFrame.lookAt(Position, Position + v12.Unit) or CFrame.new(Position)

                table.insert(t3.safe, {
                    cf = v13,
                    at = elapsed,
                    y = v10.Position.Y
                })

                if #t3.safe > 24 then
                    table.remove(t3.safe, 1)
                end
            end
        end

        if t3.groundY and Position.Y < t3.groundY - 25 and PrimaryPart.AssemblyLinearVelocity.Y <= 0 then
            local v14 = #t3.safe
            local v15

            for i = v14, 1, -1 do
                if elapsed - t3.safe[i].at >= 0.75 then
                    v15 = t3.safe[i]
                    break
                end
            end

            local v16 = v15 or t3.safe[1]

            if v16 then
                local v17 = CFrame.new(v16.cf.Position.X, v16.y + t3.above + 0.3, v16.cf.Position.Z) * v16.cf.Rotation

                local function v18() -- line: 101
                    -- upvalues: v5 (ref), PrimaryPart (copy), v17 (copy)
                    v5:PivotTo(v17 * PrimaryPart.CFrame:Inverse() * v5:GetPivot())
                end

                pcall(v18)
                stop(v5)
                t3.last = nil

                return
            end
        end

        t3.last = Position
    else
        t3.liftAt = elapsed

        local v20 = Y2 + t3.above - Position.Y

        local function v21() -- line: 74
            -- upvalues: v5 (ref), v20 (copy)
            v5:PivotTo(v5:GetPivot() + Vector3.new(0, 1, 0) * v20)
        end

        pcall(v21)

        for _, descendant in v5:GetDescendants() do
            if descendant:IsA("BasePart") and not descendant.Anchored then
                local AssemblyLinearVelocity = descendant.AssemblyLinearVelocity

                if AssemblyLinearVelocity.Y < 0 then
                    descendant.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
                end
            end
        end

        t3.last = PrimaryPart.Position
    end
end)
