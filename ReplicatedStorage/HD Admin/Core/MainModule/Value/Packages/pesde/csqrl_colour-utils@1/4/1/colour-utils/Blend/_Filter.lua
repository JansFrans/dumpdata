-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local ClampColor = require(script.Parent.Parent.Util.ClampColor)

return function(p1, p2) -- line: 4
    -- upvalues: Assert (copy), ClampColor (copy)
    local v1 = Assert.prepTypeOf(p1)

    return function(p3, p4) -- line: 7
        -- upvalues: p2 (copy), v1 (copy), ClampColor (copy)
        v1("background", "Color3", p3)
        v1("foreground", "Color3", p4)

        return ClampColor((Color3.fromRGB(p2(p3.R, p4.R), p2(p3.G, p4.G), p2(p3.B, p4.B))))
    end
end
