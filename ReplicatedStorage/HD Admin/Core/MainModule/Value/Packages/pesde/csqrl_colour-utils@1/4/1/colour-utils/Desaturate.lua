-- https://lua.expert

local Assert = require(script.Parent.Util.Assert)
local Saturate = require(script.Parent.Saturate)
local Saturate2 = Assert.prepTypeOf("Saturate")

return function(p1, p2) -- line: 14
    -- upvalues: Saturate (copy), Saturate2 (copy)
    Saturate2("color", "Color3", p1)
    Saturate2("coefficient", "number", p2)

    return Saturate(p1, -p2)
end
