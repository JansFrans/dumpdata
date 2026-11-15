-- https://lua.expert

local Lighten = require(script.Parent.Util.Assert).prepTypeOf("Lighten")
local ClampColor = require(script.Parent.Util.ClampColor)

return function(p1, p2) -- line: 14
    -- upvalues: Lighten (copy), ClampColor (copy)
    Lighten("color", "Color3", p1)
    Lighten("coefficient", "number", p2)

    return ClampColor(p1:Lerp(Color3.new(1, 1, 1), p2))
end
