-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local Rotate = require(script.Parent.Parent.Rotate)

require(script.Parent.Parent.Util.Types)

local Complementary = Assert.prepTypeOf("Complementary")

return function(p1) -- line: 16
    -- upvalues: Rotate (copy), Complementary (copy)
    Complementary("base", "Color3", p1)

    return { Rotate(p1, 180) }
end
