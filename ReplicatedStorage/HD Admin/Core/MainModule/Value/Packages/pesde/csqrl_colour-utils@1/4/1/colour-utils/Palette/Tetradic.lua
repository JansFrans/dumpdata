-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local Rotate = require(script.Parent.Parent.Rotate)

require(script.Parent.Parent.Util.Types)

local Tetradic = Assert.prepTypeOf("Tetradic")

return function(p1) -- line: 16
    -- upvalues: Rotate (copy), Tetradic (copy)
    Tetradic("base", "Color3", p1)

    return {
        Rotate(p1, -180),
        Rotate(p1, -120),
        Rotate(p1, -300)
    }
end
