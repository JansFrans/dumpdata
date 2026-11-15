-- https://lua.expert

local Assert = require(script.Parent.Util.Assert)
local ClampColor = require(script.Parent.Util.ClampColor)
local Invert = Assert.prepTypeOf("Invert")

return function(p1) -- line: 12
    -- upvalues: ClampColor (copy), Invert (copy)
    Invert("color", "Color3", p1)

    return ClampColor((Color3.new(1 - p1.R, 1 - p1.G, 1 - p1.B)))
end
