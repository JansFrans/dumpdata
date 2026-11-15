-- https://lua.expert

local t1 = {
    MinSpeedKph = 20,
    ConfirmSeconds = 1.2,
    ClearSeconds = 0.5,
    MaxTrackDistance = 140,
    DirectionDot = -0.5
}

local function flat(p1) -- line: 2
    return (Vector3.new(p1.X, 0, p1.Z))
end

function t1.New(p2) -- line: 3
    -- upvalues: t1 (copy)
    local t2 = {}
    local v1 = (p2.StudMetres or 0.28) * 3.6

    local function add(p3, p4) -- line: 6
        -- upvalues: t2 (copy)
        for i = 1, #p3 - (if p4 then 0 else 1) do
            local v2 = p3[i]
            local v3 = Vector3.new(v2.X, 0, v2.Z)
            local v4 = p3[i % #p3 + 1]
            local v5 = Vector3.new(v4.X, 0, v4.Z) - v3

            if v5.Magnitude > 0.01 then
                table.insert(t2, {
                    a = v3,
                    d = v5,
                    length2 = v5:Dot(v5),
                    forward = v5.Unit
                })
            end
        end
    end

    add(p2.Points, true)

    for _, v6 in p2.PitLane and p2.PitLane.paths or {} do
        if v6.points then
            add(v6.points, false)
        end
    end

    local t4 = {}

    function t4.DirectionAt(p5) -- line: 15
        -- upvalues: t2 (copy)
        local v7 = Vector3.new(p5.X, 0, p5.Z)
        local n1 = 1e999
        local forward

        for _, v8 in t2 do
            local v10 = math.clamp((v7 - v8.a):Dot(v8.d) / v8.length2, 0, 1)
            local Magnitude = (v7 - v8.a - v8.d * v10).Magnitude

            if Magnitude < n1 then
                n1 = Magnitude
                forward = v8.forward
            end
        end

        return forward, n1
    end

    function t4.Update(p6, p7, p8, p9, p10) -- line: 20
        -- upvalues: v1 (copy), t4 (copy), t1 (copy)
        local v11 = Vector3.new(p8.X, 0, p8.Z)
        local v12, v13 = t4.DirectionAt(p7)

        if p10 then
            if v12 then
                v12 = v13 <= t1.MaxTrackDistance and v11.Magnitude * v1 >= t1.MinSpeedKph and v11.Unit:Dot(v12) < t1.DirectionDot
            end
        else
            v12 = p10
        end

        if v12 then
            p6.wrong = (p6.wrong or 0) + p9
            p6.clear = 0

            if p6.wrong >= t1.ConfirmSeconds then
                p6.visible = true
            end
        else
            p6.wrong = 0
            p6.clear = (p6.clear or 0) + p9

            local v14 = if p10 then p6.clear >= t1.ClearSeconds else nil

            if not p10 or v14 then
                p6.visible = false
            end
        end

        return p6.visible == true
    end

    return t4
end

return t1
