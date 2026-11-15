-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local Rotate = require(script.Parent.Parent.Rotate)

require(script.Parent.Parent.Util.Types)

local Analogous = Assert.prepTypeOf("Analogous")

return function(p1) -- line: 16
    -- upvalues: Rotate (copy), Analogous (copy)
    Analogous("base", "Color3", p1)

    return {
        Rotate(p1, -30),
        Rotate(p1, 30)
    }
end
