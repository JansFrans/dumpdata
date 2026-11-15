-- https://lua.expert

local _Filter = require(script.Parent._Filter)
local lshift, clamp, max = bit32.lshift, math.clamp, math.max

return _Filter("Burn", function(p1, p2) -- line: 15
    -- upvalues: lshift (copy), clamp (copy), max (copy)
    local v2 = clamp(p1 * 255, 0, 255)
    local v3 = p2 * 255

    if v2 ~= 0 or not v2 then
        v2 = max(0, 255 - lshift(255 - v3, 8) / v2)
    end

    return v2
end)
