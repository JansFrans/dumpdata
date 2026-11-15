-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(script.Parent:WaitForChild("Config"))
local RacingLine = require(ReplicatedStorage:WaitForChild("MotoLegends"):WaitForChild("RacingLine"))
local StudMetres = Config.StudMetres
local t1 = {
    StartDelay = 2,
    TopKph = 140,
    PitKph = 60,
    LatG = 0.8,
    Accel = 3,
    Brake = 6,
    PitNodes = 40,
    CurveSpan = 4,
    Blend = 15,
    BlendIn = 45
}

local function layout() -- line: 29
    -- upvalues: ReplicatedStorage (copy)
    local MotoLegends = ReplicatedStorage:FindFirstChild("MotoLegends")

    if not MotoLegends then
        return nil
    end

    local function v1() -- line: 32
        -- upvalues: MotoLegends (copy)
        local Track = require(MotoLegends:FindFirstChild("Config")).Track

        return require(MotoLegends.Tracks[Track].Layout)
    end

    local ok, result = pcall(v1)

    return if ok and typeof(result) == "table" and result then result else nil
end

local function flat(p1) -- line: 39
    return (Vector3.new(p1.X, 0, p1.Z))
end

local function radius(p2, p3, p4) -- line: 42
    local Magnitude = (p3 - p2).Magnitude
    local Magnitude2 = (p4 - p3).Magnitude
    local Magnitude3 = (p2 - p4).Magnitude
    local v3 = math.abs((p3.X - p2.X) * (p4.Z - p2.Z) - (p3.Z - p2.Z) * (p4.X - p2.X))

    if v3 < 1E-06 then
        return 1e999
    end

    return Magnitude * Magnitude2 * Magnitude3 / (v3 * 2)
end

function t1.Build(p5) -- line: 50
    -- upvalues: ReplicatedStorage (copy), RacingLine (copy), t1 (copy), StudMetres (copy), radius (copy)
    local MotoLegends = ReplicatedStorage:FindFirstChild("MotoLegends")
    local result

    if MotoLegends then
        local function v4() -- line: 32
            -- upvalues: MotoLegends (copy)
            local Track = require(MotoLegends:FindFirstChild("Config")).Track

            return require(MotoLegends.Tracks[Track].Layout)
        end

        local ok, result2 = pcall(v4)

        if ok and typeof(result2) == "table" and result2 then
            result = result2
        end
    end

    local v5 = result and result.Points
    local v6, v7, v8

    if typeof(v5) ~= "table" or #v5 < 20 then
        return nil
    else
        v6 = #v5

        local Position = p5.Position

        v7 = Vector3.new(Position.X, 0, Position.Z)

        local LookVector = p5.LookVector
        local v10 = Vector3.new(LookVector.X, 0, LookVector.Z)

        v8 = v10.Magnitude > 0.01 and v10.Unit or Vector3.new(0, 0, -1)
    end

    local n1 = 1
    local n2 = 1e999

    for v11, v12 in v5 do
        local Magnitude = (Vector3.new(v12.X, 0, v12.Z) - v7).Magnitude

        if Magnitude < n2 then
            n2 = Magnitude
            n1 = v11
        end
    end

    local v13 = v5[n1]

    if (Vector3.new(v13.X, 0, v13.Z) - v7):Dot(v8) < 1 then
        n1 = n1 % v6 + 1
    end

    local PitLane = result.PitLane and result.PitLane.paths and result.PitLane.paths[1] and result.PitLane.paths[1].points

    if typeof(PitLane) ~= "table" or #PitLane < 3 then
        PitLane = nil
    end

    local v14

    if PitLane then
        local n3 = 1e999
        local v15

        for v16, v17 in v5 do
            local v18 = Vector3.new(v17.X, 0, v17.Z)
            local v19 = PitLane[1]
            local Magnitude = (v18 - Vector3.new(v19.X, 0, v19.Z)).Magnitude

            if Magnitude < n3 then
                v15 = v16
                n3 = Magnitude
            end

            v14 = v15
        end
    end

    local t2 = {}

    repeat
        table.insert(t2, n1)
        n1 = n1 % v6 + 1
    until v6 <= #t2 or v14 ~= nil and n1 == v14 and #t2 > v6 / 2

    local v20 = RacingLine.Get()
    local points, v21

    if v20 and v20.n == v6 then
        local points2 = v20.points

        if points2 then
            points = points2
            v21 = true
        else
            v21 = false
        end
    else
        v21 = false
    end

    if not v21 then
        points = nil
    end

    local t3 = {
        v7
    }

    for v22, v23 in t2 do
        local v24 = v5[v23]
        local v25 = Vector3.new(v24.X, 0, v24.Z)

        if points then
            local v29 = math.clamp(math.min(v22 / t1.BlendIn, (#t2 - v22) / t1.Blend), 0, 1)
            local v30 = points[v23]

            v25 = v25:Lerp(Vector3.new(v30.X, 0, v30.Z), v29 * v29 * (3 - v29 * 2))
        end

        table.insert(t3, v25)
    end

    local v31 = #t3

    if PitLane then
        for i = 1, math.min(t1.PitNodes, #PitLane) do
            local v33 = PitLane[i]

            table.insert(t3, (Vector3.new(v33.X, 0, v33.Z)))
        end
    end

    local v35 = #t3
    local t4 = {
        0
    }

    for i = 2, v35 do
        t4[i] = t4[i - 1] + (t3[i] - t3[i - 1]).Magnitude
    end

    local v36 = t1.TopKph / 3.6 / StudMetres
    local v37 = t1.PitKph / 3.6 / StudMetres
    local v38 = table.create(v35, 0)

    for i = 1, v35 do
        local v40 = t3[math.max(1, i - t1.CurveSpan)]
        local v42 = t3[math.min(v35, i + t1.CurveSpan)]
        local v43 = radius(v40, t3[i], v42) * StudMetres

        v38[i] = math.min(if not (v31 < i) or not v37 then v36 else v37, math.sqrt(t1.LatG * 9.81 * v43) / StudMetres)
    end

    v38[1] = 0

    local v47 = t1.Accel / StudMetres
    local v48 = t1.Brake / StudMetres

    for i = 1, v35 - 1 do
        local v49 = t4[i + 1] - t4[i]
        local v50 = v38[i + 1]
        local v52 = math.sqrt(v38[i] * v38[i] + 2 * v47 * v49)

        v38[i + 1] = math.min(v50, v52)
    end

    for i = v35 - 1, 2, -1 do
        local v53 = t4[i + 1] - t4[i]

        v38[i] = math.min(v38[i], (math.sqrt(v38[i + 1] * v38[i + 1] + 2 * v48 * v53)))
    end

    local t5 = {
        0
    }

    for i = 1, v35 - 1 do
        local v57 = t4[i + 1] - t4[i]
        local v58 = v38[i] + v38[i + 1]
        local v59 = t5[i]
        local v60 = v58 > 0.001
        local v61 = if v60 then 2 * v57 / v58 else nil

        t5[i + 1] = v59 + (if not v60 or not v61 then 0 else v61)
    end

    return {
        k = 1,
        kp = 1,
        nodes = t3,
        s = t4,
        v = v38,
        T = t5,
        total = t5[v35],
        length = t4[v35],
        lapEnd = v31
    }
end

function t1.Sample(p6, p7) -- line: 133
    local T, s, v = p6.T, p6.s, p6.v
    local v62 = #T

    if p7 <= 0 then
        return 0, 0, 0
    end

    if T[v62] <= p7 then
        return s[v62], v[v62], 0
    end

    local v63 = p6.k

    while v63 < v62 - 1 and T[v63 + 1] <= p7 do
        v63 += 1
    end

    while v63 > 1 and p7 < T[v63] do
        v63 -= 1
    end

    p6.k = v63

    local v64 = s[v63 + 1] - s[v63]
    local v65 = v[v63]
    local v66 = v[v63 + 1]
    local v67 = v64 > 0 and (v66 * v66 - v65 * v65) / (2 * v64) or 0
    local v68 = p7 - T[v63]

    return s[v63] + math.min(v65 * v68 + 0.5 * v67 * v68 * v68, v64), v65 + v67 * v68, v67
end

function t1.PointAt(p8, p9) -- line: 150
    local s, nodes = p8.s, p8.nodes
    local v71 = #s

    if p9 <= 0 then
        return nodes[1]
    end

    if s[v71] <= p9 then
        return nodes[v71]
    end

    local n4 = 1

    while v71 - n4 > 1 do
        local v72 = (n4 + v71) // 2

        if s[v72] <= p9 then
            n4 = v72
        else
            v71 = v72
        end
    end

    local v73 = s[v71] - s[n4]

    return nodes[n4]:Lerp(nodes[v71], v73 > 0 and (p9 - s[n4]) / v73 or 0)
end

return t1
