-- https://lua.expert

local Assert = require(script.Parent.Util.Assert)
local ClampColor = require(script.Parent.Util.ClampColor)
local Rotate = Assert.prepTypeOf("Rotate")
local clamp = math.clamp

return function(p1, p2) -- line: 15
    -- upvalues: ClampColor (copy), Rotate (copy), clamp (copy)
    Rotate("color", "Color3", p1)
    Rotate("angle", "number", p2)

    local v1, v2, v3 = p1:ToHSV()
    local v5 = clamp((v1 + p2 / 360) % 1, 0, 1)

    return ClampColor((Color3.fromHSV(v5, v2, v3)))
end
