-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    Margin = 7,
    Spans = { 64, 32, 16, 8, 4, 2, 1 },
    Iterations = 120
}

local function layout() -- line: 15
    -- upvalues: ReplicatedStorage (copy)
    local MotoLegends = ReplicatedStorage:FindFirstChild("MotoLegends")

    if MotoLegends then
        local function v1() -- line: 18
            -- upvalues: MotoLegends (copy)
            local Track = require(MotoLegends:FindFirstChild("Config")).Track

            return require(MotoLegends.Tracks[Track].Layout), Track
        end

        local v2, v3, v4 = pcall(v1)

        if v2 and typeof(v3) == "table" and typeof(v3.Points) == "table" and #v3.Points >= 20 then
            return v3, v4
        end
    end

    return nil
end

t1.Layout = layout

function t1.Rights(p1) -- line: 28
    local v5 = #p1
    local v6 = table.create(v5)

    for i = 1, v5 do
        local v7 = p1[(i - 2) % v5 + 1]
        local v8 = p1[i % v5 + 1]
        local v11 = Vector3.new(v8.X - v7.X, 0, v8.Z - v7.Z)
        local v12 = v11.Magnitude > 1E-04
        local Unit = if v12 then v11.Unit else nil

        v6[i] = (if not v12 or not Unit then Vector3.new(0, 0, -1) else Unit):Cross((Vector3.new(0, 1, 0)))
    end

    return v6
end

function t1.Solve(p2, p3, p4, p5) -- line: 44
    -- upvalues: t1 (copy)
    local v13 = #p2
    local v14 = t1.Rights(p2)
    local v15 = table.create(v13, 0)
    local v16 = table.create(v13, 0)
    local v17 = table.create(v13, 0)

    for i = 1, v13 do
        v16[i] = -math.max(0, p3[i] - t1.Margin)
        v17[i] = math.max(0, p4[i] - t1.Margin)
    end

    local function idx(p6) -- line: 53
        -- upvalues: v13 (copy)
        return (p6 - 1) % v13 + 1
    end

    local function curv(p7, p8, p9) -- line: 54
        -- upvalues: p2 (copy), v14 (copy), v15 (copy)
        local v20 = p2[p7]
        local v21 = v14[p7]
        local v22 = p2[p8]
        local v23 = v14[p8]
        local v24 = p2[p9]
        local v25 = v14[p9]
        local v26 = v20.X + v21.X * v15[p7]
        local v27 = v20.Z + v21.Z * v15[p7]
        local v28 = v22.X + v23.X * v15[p8]
        local v29 = v22.Z + v23.Z * v15[p8]
        local v30 = v24.X + v25.X * v15[p9]
        local v31 = v24.Z + v25.Z * v15[p9]
        local v32 = (v28 - v26) * (v31 - v27) - (v29 - v27) * (v30 - v26)
        local v34 = math.sqrt(((v28 - v26) ^ 2 + (v29 - v27) ^ 2) * ((v30 - v28) ^ 2 + (v31 - v29) ^ 2) * ((v30 - v26) ^ 2 + (v31 - v27) ^ 2))

        return v34 > 1E-09 and 2 * v32 / v34 or 0
    end

    local n1 = 0

    for _, v35 in t1.Spans do
        for _ = 1, t1.Iterations do
            for j = 1, v13 do
                local v36 = (j - v35 - 1) % v13 + 1
                local v37 = (j + v35 - 1) % v13 + 1
                local v38 = 0.5 * (curv((j - 2 * v35 - 1) % v13 + 1, v36, j) + curv(j, v37, (j + 2 * v35 - 1) % v13 + 1))
                local v39 = v15[j]
                local v40 = curv(v36, j, v37)

                v15[j] = v39 + 0.05

                local v41 = (curv(v36, j, v37) - v40) / 0.05
                local v42 = math.abs(v41) > 1E-12
                local v43 = if v42 then (v38 - v40) / v41 else nil

                v15[j] = math.clamp(v39 + math.clamp(if not v42 or not v43 then 0 else v43, -3, 3), v16[j], v17[j])
            end

            n1 += v13

            if p5 and p5 <= n1 then
                n1 = 0
                task.wait()
            end
        end
    end

    for _ = 1, 4 do
        local v48 = table.clone(v15)

        for i = 1, v13 do
            v15[i] = math.clamp((v48[(i - 1 - 1) % v13 + 1] + 2 * v48[i] + v48[(i + 1 - 1) % v13 + 1]) / 4, v16[i], v17[i])
        end
    end

    return v15
end

local t2, v52

function t1.Get() -- line: 95
    -- upvalues: t1 (copy), layout (copy), t2 (ref), v52 (ref)
    if t2 then
        return t2
    end

    while v52 do
        task.wait()
    end

    if not t2 then
        local v53, v54 = layout()

        if not v53 then
            return nil
        end

        v52 = true

        local function v55() -- line: 102
            -- upvalues: v53 (copy), v54 (copy), t1 (copy), t2 (ref)
            local Points = v53.Points
            local v56 = #Points
            local v57 = v54 and script:FindFirstChild(v54)
            local v58, y

            if v57 then
                local _require = require
                local ok, result = pcall(_require, v57)

                if ok and typeof(result) == "table" and typeof(result.e) == "table" and #result.e == v56 then
                    v58 = result.e
                    y = result.y
                end
            end

            if not v58 then
                local v59 = (v53.RoadWidthMetres or 12) / (v53.StudMetres or 0.28) * (v53.WorldScale or 1) / 2
                local v60 = table.create(v56, v59)

                v58 = t1.Solve(Points, v60, v60, 15000)
            end

            local v61 = t1.Rights(Points)
            local v62 = table.create(v56)

            for i = 1, v56 do
                local v63 = Points[i]
                local v64 = v61[i]
                local v65 = v63.X + v64.X * v58[i]
                local v66 = if y then y[i] else nil

                v62[i] = Vector3.new(v65, if not y or not v66 then v63.Y else v66, v63.Z + v64.Z * v58[i])
            end

            local v69 = table.create(v56, 0)

            for i = 2, v56 do
                v69[i] = v69[i - 1] + (v62[i] - v62[i - 1]).Magnitude
            end

            t2 = {
                points = v62,
                s = v69,
                length = v69[v56] + (v62[1] - v62[v56]).Magnitude,
                n = v56,
                offsets = v58
            }
        end

        local ok, result = pcall(v55)

        v52 = false

        if not ok then
            warn("[RacingLine] " .. tostring(result))
        end
    end

    return t2
end

return t1
