-- https://lua.expert

local GetContrastRatio = require(script.Parent.Parent.Util.Assert).prepTypeOf("GetContrastRatio")
local GetLuminance = require(script.Parent.Parent.GetLuminance)
local max, min = math.max, math.min

return function(p1, p2) -- line: 17
    -- upvalues: GetContrastRatio (copy), GetLuminance (copy), max (copy), min (copy)
    GetContrastRatio("foreground", "Color3", p1)
    GetContrastRatio("background", "Color3", p2)

    local v1 = GetLuminance(p1)
    local v2 = GetLuminance(p2)

    return (max(v1, v2) + 0.05) / (min(v1, v2) + 0.05)
end
