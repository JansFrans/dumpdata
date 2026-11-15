-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local GetLuminance = require(script.Parent.Parent.GetLuminance)
local Schema = require(script.Parent.Parent.Util.Schema)

require(script.Parent.Parent.Util.Types)

local Vibrant = Assert.prepArrayOf("Vibrant")
local abs, sqrt, toHSV = math.abs, math.sqrt, Color3.toHSV
local t1 = {
    TargetLuminance = 0.49,
    TargetSaturation = 1,
    TargetValue = 0.8
}

return function(p1, p2) -- line: 51
    -- upvalues: GetLuminance (copy), Schema (copy), Vibrant (copy), abs (copy), sqrt (copy), toHSV (copy), t1 (copy)
    Vibrant("swatches", "Color3", p1)

    local v1 = Schema.Loose(t1, p2)
    local n1 = 1e999
    local v2

    for _, v3 in ipairs(p1) do
        local _, v4, v5 = toHSV(v3)
        local v6 = GetLuminance(v3)
        local v8 = abs(v4 - v1.TargetSaturation)
        local v10 = abs(v5 - v1.TargetValue)
        local v12 = abs(v6 - v1.TargetLuminance)
        local v14 = sqrt(v8 ^ 2 + v10 ^ 2 + v12 ^ 2)

        if v14 < n1 then
            n1 = v14
            v2 = v3
        end
    end

    return v2
end
