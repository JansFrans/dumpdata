-- https://lua.expert

local Layout = require(script.Parent:WaitForChild("Layout"))

return function(p1) -- line: 3
    -- upvalues: Layout (copy)
    local v1 = Layout.WorldScale or 1.2

    p1.GridOffsetStuds = 0
    p1.CircuitLengthMetres = Layout.LapLengthMetres
    p1.TrackCredit = "Pertamina Mandalika International Circuit from OpenStreetMap (© OpenStreetMap contributors, ODbL)"

    local function alongBehind(p2) -- line: 8
        -- upvalues: Layout (copy)
        local v2 = #Layout.Points
        local v3 = p2
        local n1 = 1

        for _ = 1, v2 do
            local v4 = (n1 - 2) % #Layout.Points + 1
            local Magnitude = (Layout.Points[n1] - Layout.Points[v4]).Magnitude

            if v3 <= Magnitude then
                return Layout.Points[n1]:Lerp(Layout.Points[v4], v3 / Magnitude), (Layout.Points[n1] - Layout.Points[v4]).Unit
            end

            n1 = v4
            v3 -= Magnitude
        end
    end

    for i = 0, 13 do
        for j = 0, 2 do
            local v5, v6 = alongBehind(p1.GridOffsetStuds + (i * 12 + 3 + j * 4) * v1 / p1.StudMetres)
            local v7 = CFrame.lookAt(v5 + Vector3.new(0, 1, 0) * p1.RideHeight, v5 + Vector3.new(0, 1, 0) * p1.RideHeight + v6)

            table.insert(p1.Grid, v7 * CFrame.new((1 - j) * 3.7 * v1 / p1.StudMetres, 0, 0))
        end
    end

    p1.KerbEdgeLeanDryPre14 = 55
    p1.KerbEdgeLeanWetPre14 = 50
    p1.Spawn = p1.Grid[1]
    p1.CharacterSpawn = p1.Spawn * CFrame.new(0, 0, 9)

    local function onTarmac(p3) -- line: 37
        local function v9() -- line: 38
            -- upvalues: p3 (copy)
            local Mandalika = workspace:FindFirstChild("Mandalika")

            Mandalika = Mandalika and Mandalika:FindFirstChild("RaceCollision") and Mandalika.RaceCollision:FindFirstChild("Track")

            if not Mandalika then
                return nil
            end

            local v10 = RaycastParams.new()

            v10.FilterType = Enum.RaycastFilterType.Include
            v10.FilterDescendantsInstances = { Mandalika }

            local v12 = workspace:Raycast(Vector3.new(p3.X, p3.Y + 200, p3.Z), Vector3.new(0, -400, 0), v10)

            return v12 and v12.Position.Y
        end

        local ok, result = pcall(v9)
        local v13, v14

        if ok and result then
            local v15 = Vector3.new(p3.X, result, p3.Z)

            if v15 then
                v13 = v15
                v14 = true
            else
                v14 = false
            end
        else
            v14 = false
        end

        if not v14 then
            v13 = p3
        end

        return v13
    end

    local v16, v17 = alongBehind(p1.GridOffsetStuds)
    local Unit = Vector3.new(v17.X, 0, v17.Z).Unit
    local Gates = p1.Gates

    local function v18() -- line: 38
        -- upvalues: v16 (copy)
        local Mandalika = workspace:FindFirstChild("Mandalika")

        Mandalika = Mandalika and Mandalika:FindFirstChild("RaceCollision") and Mandalika.RaceCollision:FindFirstChild("Track")

        if not Mandalika then
            return nil
        end

        local v19 = RaycastParams.new()

        v19.FilterType = Enum.RaycastFilterType.Include
        v19.FilterDescendantsInstances = { Mandalika }

        local v21 = workspace:Raycast(Vector3.new(v16.X, v16.Y + 200, v16.Z), Vector3.new(0, -400, 0), v19)

        return v21 and v21.Position.Y
    end

    local ok, result = pcall(v18)
    local v22, v23

    if ok and result then
        local v24 = Vector3.new(v16.X, result, v16.Z)

        if v24 then
            v22 = v24
            v23 = true
        else
            v23 = false
        end
    else
        v23 = false
    end

    if not v23 then
        v22 = v16
    end

    Gates[1] = {
        v22,
        Unit,
        (Layout.GridWidthMetres + 8) / p1.StudMetres
    }

    for v26, v27 in { 0.25, 0.5, 0.75 } do
        local Sector4Index

        if v26 == 3 then
            Sector4Index = Layout.Sector4Index

            if not Sector4Index then
                Sector4Index = math.floor(#Layout.Points * v27) + 1
            end
        else
            Sector4Index = math.floor(#Layout.Points * v27) + 1
        end

        local v30 = Layout.Points[(Sector4Index - 2) % #Layout.Points + 1]
        local v31 = Layout.Points[Sector4Index % #Layout.Points + 1] - v30
        local Unit = Vector3.new(v31.X, 0, v31.Z).Unit
        local Gates = p1.Gates
        local v32 = Layout.Points[Sector4Index]

        local function v33() -- line: 38
            -- upvalues: v32 (copy)
            local Mandalika = workspace:FindFirstChild("Mandalika")

            Mandalika = Mandalika and Mandalika:FindFirstChild("RaceCollision") and Mandalika.RaceCollision:FindFirstChild("Track")

            if not Mandalika then
                return nil
            end

            local v34 = RaycastParams.new()

            v34.FilterType = Enum.RaycastFilterType.Include
            v34.FilterDescendantsInstances = { Mandalika }

            local v36 = workspace:Raycast(Vector3.new(v32.X, v32.Y + 200, v32.Z), Vector3.new(0, -400, 0), v34)

            return v36 and v36.Position.Y
        end

        local ok, result = pcall(v33)

        table.insert(Gates, {
            ok and result and Vector3.new(v32.X, result, v32.Z) or v32,
            Unit,
            (Layout.GridWidthMetres + 8) / p1.StudMetres
        })
    end
end
