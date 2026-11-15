-- https://lua.expert

local function applyTransparency(p1, p2, p3) -- line: 10
    local v1 = 1 - p3
    local v2 = p2.R * v1 + p1.R * p3
    local v3 = p2.G * v1 + p1.G * p3
    local v4 = p2.B * v1 + p1.B * p3

    return Color3.new(v2, v3, v4)
end

return applyTransparency
