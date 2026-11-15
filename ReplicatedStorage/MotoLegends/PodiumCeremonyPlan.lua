-- https://lua.expert

local t1 = {
    Lead = 0.8,
    Scene1 = 5.5,
    WideHold = 1.5,
    Direct = 1.1,
    AfterShake = 0.3,
    WalkIn = 0.3,
    TurnLong = 0.95,
    CutFade = 0.35,
    WalkDelay = 0.45,
    Speed = 3.1,
    Ramp = 0.6,
    Turn = 0.55,
    Beat = {
        LiftEnd = 0.85,
        LowerEnd = 1.75,
        Wear = 1.85,
        ReleaseEnd = 2.45,
        PumpHz = 2.1,
        End = 6.1,
        BowIn = { 0.25, 1.05 },
        BowOut = { 2.1, 2.9 },
        Back = { 2.45, 3.15 },
        ShakeIn = { 3.15, 3.65 },
        Pump = { 3.65, 5.05 },
        ShakeOut = { 5.05, 5.55 },
        TurnIn = { -1.4, -0.3 },
        TurnOut = { 5.25, 6 }
    },
    ReturnDelay = 0.5,
    ReleaseDelay = 0.3,
    TimeScale = 1.1
}
local v1 = 1 / t1.TimeScale

for _, v2 in {
        "Lead",
        "Scene1",
        "WideHold",
        "Direct",
        "AfterShake",
        "WalkIn",
        "TurnLong",
        "CutFade",
        "WalkDelay",
        "Ramp",
        "Turn",
        "ReturnDelay",
        "ReleaseDelay"
    } do
    t1[v2] *= v1
end

t1.Speed *= t1.TimeScale

for v3, v4 in t1.Beat do
    if v3 == "PumpHz" then
        t1.Beat[v3] = v4 * t1.TimeScale
    elseif type(v4) == "number" then
        t1.Beat[v3] = v4 * v1
    elseif type(v4) == "table" then
        for v5, v6 in v4 do
            v4[v5] = v6 * v1
        end
    end
end

function t1.Duration(p1, p2) -- line: 54
    -- upvalues: t1 (copy)
    if p1 <= 0 then
        return 0
    end

    return p1 / p2 + t1.Ramp
end

function t1.Travel(p3, p4, p5) -- line: 55
    -- upvalues: t1 (copy)
    if p3 <= 0 or p4 <= 0 then
        return 0
    end

    local Ramp = t1.Ramp
    local v7 = t1.Duration(p4, p5)

    if v7 <= p3 then
        return p4
    end

    if p3 < Ramp then
        return p5 * p3 * p3 / (2 * Ramp)
    end

    if v7 - Ramp < p3 then
        local v8 = v7 - p3

        return p4 - p5 * v8 * v8 / (2 * Ramp)
    end

    return p5 * Ramp / 2 + p5 * (p3 - Ramp)
end

function t1.Rate(p6, p7, p8) -- line: 63
    -- upvalues: t1 (copy)
    if p6 <= 0 or p7 <= 0 then
        return 0
    end

    local Ramp = t1.Ramp
    local v9 = t1.Duration(p7, p8)

    if v9 <= p6 then
        return 0
    end

    return p8 * math.min(p6 / Ramp, (v9 - p6) / Ramp, 1)
end

function t1.Prepare(p9) -- line: 70
    local t2 = {
        0
    }

    for i = 2, #p9 do
        local v12 = p9[i - 1]
        local v13 = p9[i]

        t2[i] = t2[i - 1] + Vector3.new(v13.X - v12.X, 0, v13.Z - v12.Z).Magnitude
    end

    return t2
end

function t1.Length(p10) -- line: 75
    -- upvalues: t1 (copy)
    local v17 = t1.Prepare(p10)

    return v17[#v17]
end

function t1.At(p11, p12, p13) -- line: 78
    local v18 = #p11

    if p13 <= 0 then
        return p11[1], 1
    end

    if p12[v18] <= p13 then
        return p11[v18], v18 - 1
    end

    local n1 = 2

    while p12[n1] < p13 do
        n1 += 1
    end

    local v19 = p11[n1 - 1]
    local v20 = p11[n1]
    local v21 = p12[n1] - p12[n1 - 1]
    local v22 = v21 > 1E-06 and (p13 - p12[n1 - 1]) / v21 or 1
    local v23 = v22 * v22 * (3 - 2 * v22)

    return Vector3.new(v19.X + (v20.X - v19.X) * v22, v19.Y + (v20.Y - v19.Y) * v23, v19.Z + (v20.Z - v19.Z) * v22), n1 - 1
end

return t1
