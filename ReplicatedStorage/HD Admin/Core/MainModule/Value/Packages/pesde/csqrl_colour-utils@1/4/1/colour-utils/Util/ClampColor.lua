-- https://lua.expert

local clamp = math.clamp

return function(p1) -- line: 3
    -- upvalues: clamp (copy)
    local v1 = clamp(p1.R, 0, 1)
    local v2 = clamp(p1.G, 0, 1)
    local v3 = clamp(p1.B, 0, 1)

    return Color3.new(v1, v2, v3)
end
