-- https://lua.expert

local Darken = require(script.Parent.Util.Assert).prepTypeOf("Darken")
local ClampColor = require(script.Parent.Util.ClampColor)

return function(p1, p2) -- line: 14
    -- upvalues: Darken (copy), ClampColor (copy)
    Darken("color", "Color3", p1)
    Darken("coefficient", "number", p2)

    return ClampColor(p1:Lerp(Color3.new(), p2))
end
