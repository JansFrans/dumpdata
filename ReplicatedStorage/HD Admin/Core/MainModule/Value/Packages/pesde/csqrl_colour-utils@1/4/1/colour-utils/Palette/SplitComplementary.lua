-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local Rotate = require(script.Parent.Parent.Rotate)

require(script.Parent.Parent.Util.Types)

local SplitComplementary = Assert.prepTypeOf("SplitComplementary")

return function(p1) -- line: 16
    -- upvalues: Rotate (copy), SplitComplementary (copy)
    SplitComplementary("base", "Color3", p1)

    return {
        Rotate(p1, 150),
        Rotate(p1, 210)
    }
end
