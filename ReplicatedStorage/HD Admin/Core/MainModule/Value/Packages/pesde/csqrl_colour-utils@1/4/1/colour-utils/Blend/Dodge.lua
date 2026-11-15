-- https://lua.expert

local _Filter = require(script.Parent._Filter)
local lshift, clamp, min = bit32.lshift, math.clamp, math.min

return _Filter("Dodge", function(p1, p2) -- line: 15
    -- upvalues: lshift (copy), clamp (copy), min (copy)
    local v2 = clamp(p1 * 255, 0, 255)
    local v3 = p2 * 255

    if v2 ~= 255 or not v2 then
        v2 = min(255, lshift(v3, 8) / (255 - v2))
    end

    return v2
end)
