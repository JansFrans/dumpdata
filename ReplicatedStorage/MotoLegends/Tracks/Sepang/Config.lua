-- https://lua.expert

local Layout = require(script.Parent:WaitForChild("Layout"))

return function(p1) -- line: 3
    -- upvalues: Layout (copy)
    local v1 = Layout.WorldScale or 1.2

    p1.GridOffsetStuds = 831
    p1.CircuitLengthMetres = Layout.LapLengthMetres
    p1.TrackCredit = "Petronas Sepang International Circuit from OpenStreetMap (© OpenStreetMap contributors, ODbL)"

    local function alongBehind(p2) -- line: 11
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

    for i = 0, 7 do
        for j = 0, 2 do
            local v5, v6 = alongBehind(p1.GridOffsetStuds + (i * 12 + 3 + j * 4) * v1 / p1.StudMetres)
            local v7 = CFrame.lookAt(v5 + Vector3.new(0, 1, 0) * p1.RideHeight, v5 + Vector3.new(0, 1, 0) * p1.RideHeight + v6)
            local v8 = i * -1.6 / 7 + 2.5

            table.insert(p1.Grid, v7 * CFrame.new((j - 1) * 3.7 * v1 / p1.StudMetres + v8, 0, 0))
        end
    end

    p1.Spawn = p1.Grid[1]
    p1.CharacterSpawn = p1.Spawn * CFrame.new(0, 0, 9)

    local v10, v11 = alongBehind(p1.GridOffsetStuds)
    local Unit = Vector3.new(v11.X, 0, v11.Z).Unit

    p1.Gates[1] = {
        v10,
        Unit,
        (Layout.GridWidthMetres + 8) / p1.StudMetres
    }

    for v12, v13 in { 0.25, 0.5, 0.75 } do
        local Sector4Index

        if v12 == 3 then
            Sector4Index = Layout.Sector4Index

            if not Sector4Index then
                Sector4Index = math.floor(#Layout.Points * v13) + 1
            end
        else
            Sector4Index = math.floor(#Layout.Points * v13) + 1
        end

        local v16 = Layout.Points[(Sector4Index - 2) % #Layout.Points + 1]
        local v17 = Layout.Points[Sector4Index % #Layout.Points + 1]

        table.insert(p1.Gates, {
            Layout.Points[Sector4Index],
            (v17 - v16).Unit,
            (Layout.GridWidthMetres + 8) / p1.StudMetres
        })
    end
end
