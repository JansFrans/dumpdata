-- https://lua.expert

local GetLuminance = require(script.Parent.Util.Assert).prepTypeOf("GetLuminance")

local function transformValue(p1) -- line: 5
    return p1 <= 0.03928 and p1 / 12.92 or ((p1 + 0.055) / 1.055) ^ 2.4
end

return function(p2) -- line: 16
    -- upvalues: GetLuminance (copy)
    GetLuminance("color", "Color3", p2)

    local R = p2.R
    local v1 = R <= 0.03928 and R / 12.92 or ((R + 0.055) / 1.055) ^ 2.4
    local G = p2.G
    local v2 = G <= 0.03928 and G / 12.92 or ((G + 0.055) / 1.055) ^ 2.4
    local B = p2.B
    local v3 = B <= 0.03928 and B / 12.92 or ((B + 0.055) / 1.055) ^ 2.4

    return v1 * 0.2126 + v2 * 0.7152 + v3 * 0.0722
end
