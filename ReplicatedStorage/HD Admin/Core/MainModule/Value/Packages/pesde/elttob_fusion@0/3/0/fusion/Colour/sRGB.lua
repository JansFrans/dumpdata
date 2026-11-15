-- https://lua.expert

local t1 = {}

local function transform(p1) -- line: 18
    if p1 >= 0.04045 then
        return ((p1 + 0.055) / 1.055) ^ 2.4
    end

    return p1 / 12.92
end

local function inverse(p2) -- line: 28
    if p2 >= 0.0031308 then
        return p2 ^ 0.4166666666666667 * 1.055 - 0.055
    end

    return p2 * 12.92
end

function t1.fromLinear(p3) -- line: 37
    local new = Color3.new
    local R = p3.R
    local v1 = if R >= 0.04045 then ((R + 0.055) / 1.055) ^ 2.4 else R / 12.92
    local G = p3.G
    local v2 = if G >= 0.04045 then ((G + 0.055) / 1.055) ^ 2.4 else G / 12.92
    local B = p3.B

    return new(v1, v2, if B >= 0.04045 then ((B + 0.055) / 1.055) ^ 2.4 else B / 12.92)
end

function t1.toLinear(p4) -- line: 47
    local new = Color3.new
    local R = p4.R
    local v3 = if R >= 0.0031308 then R ^ 0.4166666666666667 * 1.055 - 0.055 else R * 12.92
    local G = p4.G
    local v4 = if G >= 0.0031308 then G ^ 0.4166666666666667 * 1.055 - 0.055 else G * 12.92
    local B = p4.B

    return new(v3, v4, if B >= 0.0031308 then B ^ 0.4166666666666667 * 1.055 - 0.055 else B * 12.92)
end

return t1
