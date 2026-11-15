-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local Rotate = require(script.Parent.Parent.Rotate)

require(script.Parent.Parent.Util.Types)

local Triadic = Assert.prepTypeOf("Triadic")

return function(p1) -- line: 16
    -- upvalues: Rotate (copy), Triadic (copy)
    Triadic("base", "Color3", p1)

    return {
        Rotate(p1, 120),
        Rotate(p1, 240)
    }
end
