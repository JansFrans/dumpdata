-- https://lua.expert

local Assert = require(script.Parent.Util.Assert)
local ClampColor = require(script.Parent.Util.ClampColor)
local Saturate = Assert.prepTypeOf("Saturate")
local clamp = math.clamp

return function(p1, p2) -- line: 16
    -- upvalues: ClampColor (copy), Saturate (copy), clamp (copy)
    Saturate("color", "Color3", p1)
    Saturate("coefficient", "number", p2)

    local v1, v2, v3 = p1:ToHSV()
    local v4 = v2 + v2 * p2

    return ClampColor(Color3.fromHSV(v1, clamp(v4, 0, 1), v3))
end
