-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local CrashTopple = require(game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends"):WaitForChild("CrashTopple"))
local t1 = {
    "LowerTorso",
    "UpperTorso",
    "Torso",
    "Head"
}
local v1 = RaycastParams.new()

v1.FilterType = Enum.RaycastFilterType.Include

local function ground() -- line: 20
    -- upvalues: v1 (copy)
    local t2 = {
        workspace.Terrain
    }
    local v2 = workspace:FindFirstChild("RaceCollision", true)

    if v2 then
        table.insert(t2, v2)
    end

    v1.FilterDescendantsInstances = t2
end

local t3 = {
    workspace.Terrain
}
local v3 = workspace:FindFirstChild("RaceCollision", true)

if v3 then
    table.insert(t3, v3)
end

v1.FilterDescendantsInstances = t3

local function floor(p1) -- line: 26
    if not p1 then
        return p1
    end

    if p1.Normal.Y > 0.5 then
        return p1.Instance:GetAttribute("Surface") ~= "Barrier"
    end

    return false
end

local t4 = {}
local n1 = 0
local n2 = 0

RunService.PostSimulation:Connect(function() -- line: 29
    -- upvalues: LocalPlayer (copy), CrashTopple (copy), t1 (copy), v1 (copy), t4 (copy), n1 (ref), n2 (ref)
    local Character = LocalPlayer.Character

    if not Character or Character:GetAttribute("RaceCrashActive") ~= true or Character:GetAttribute("RaceCrashServerSim") == true then
        if next(t4) then
            table.clear(t4)
        end
    else
        if os.clock() > n1 then
            n1 = os.clock() + 5

            local t5 = {
                workspace.Terrain
            }
            local v4 = workspace:FindFirstChild("RaceCollision", true)

            if v4 then
                table.insert(t5, v4)
            end

            v1.FilterDescendantsInstances = t5
        end

        local n3 = 0
        local n4 = 0

        for _, v5 in t1 do
            local v6 = Character:FindFirstChild(v5)

            if v6 and v6:IsA("BasePart") and not v6.Anchored then
                local Position = v6.Position
                local v7 = t4[v6]

                if v7 and (Position - v7).Magnitude > 0.05 and (Position - v7).Magnitude < 60 then
                    local v8 = workspace:Raycast(v7, Position - v7, v1)

                    if v8 and v8.Normal.Y > 0.5 and v8.Instance:GetAttribute("Surface") ~= "Barrier" and v8.Position.Y - Position.Y > 0.5 then
                        n4 = math.max(n4, v8.Position.Y + 0.45 - Position.Y)
                        n3 = n4
                    end
                end

                local v10 = workspace:Raycast(Position + Vector3.new(0, 3, 0), Vector3.new(-0, -3, -0, -0), v1)

                if v10 and v10.Normal.Y > 0.5 and v10.Instance:GetAttribute("Surface") ~= "Barrier" and v10.Position.Y - Position.Y > 0.5 then
                    n4 = math.max(n4, v10.Position.Y + 0.45 - Position.Y)
                    n3 = n4
                end
            end
        end

        if n4 > 0 and os.clock() - n2 >= 0.2 then
            n2 = os.clock()

            local function v12() -- line: 52
                -- upvalues: Character (copy), n3 (ref)
                Character:PivotTo(Character:GetPivot() + Vector3.new(0, 1, 0) * n3)
            end

            pcall(v12)

            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") and not descendant.Anchored then
                    local AssemblyLinearVelocity = descendant.AssemblyLinearVelocity

                    if AssemblyLinearVelocity.Y < 0 then
                        descendant.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
                    end
                end
            end
        end

        if Character:GetAttribute("RaceCrashKind") == "LOWSIDE" and workspace:GetServerTimeNow() - (Character:GetAttribute("RaceCrashAt") or 0) < CrashTopple.Settings.LowsideSeconds then
            local t6 = {}
            local n5 = 0
            local n6 = 0

            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") and not descendant.Anchored and descendant.AssemblyRootPart == descendant then
                    local AssemblyMass = descendant.AssemblyMass

                    n5 += descendant.AssemblyLinearVelocity.Y * AssemblyMass
                    n6 += AssemblyMass
                    table.insert(t6, descendant)
                end
            end

            local v13 = n6 > 0 and n5 / n6 - CrashTopple.Settings.LowsideMaxUp or 0

            if v13 > 0 then
                for _, v14 in t6 do
                    v14.AssemblyLinearVelocity -= Vector3.new(0, 1, 0) * v13
                end
            end
        end

        for _, v15 in t1 do
            local v16 = Character:FindFirstChild(v15)

            if v16 and v16:IsA("BasePart") then
                t4[v16] = v16.Position
            end
        end
    end
end)
