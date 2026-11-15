-- https://lua.expert

local t1 = {
    Accel = 0.7,
    FadeSeconds = 0.35
}

function t1.Travel(p1, p2) -- line: 9
    -- upvalues: t1 (copy)
    if p1 <= 0 or p2 <= 0 then
        return 0
    end

    local Accel = t1.Accel

    if p1 < Accel then
        return p2 * p1 * p1 / (2 * Accel)
    end

    return p2 * (p1 - Accel / 2)
end

function t1.Speed(p3, p4) -- line: 16
    -- upvalues: t1 (copy)
    if p3 <= 0 or p4 <= 0 then
        return 0
    end

    return p4 * math.min(p3 / t1.Accel, 1)
end

function t1.Duration(p5, p6) -- line: 21
    -- upvalues: t1 (copy)
    if p5 <= 0 or p6 <= 0 then
        return 0
    end

    local Accel = t1.Accel
    local v2 = p6 * Accel / 2

    if not (p5 <= v2) then
        return Accel + (p5 - v2) / p6
    end

    return (math.sqrt(2 * p5 * Accel / p6))
end

return t1
