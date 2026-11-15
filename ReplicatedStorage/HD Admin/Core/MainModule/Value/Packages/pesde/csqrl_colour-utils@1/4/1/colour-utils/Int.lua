-- https://lua.expert

local Assert = require(script.Parent.Util.Assert)
local ClampColor = require(script.Parent.Util.ClampColor)
local floor, rshift, lshift, band = math.floor, bit32.rshift, bit32.lshift, bit32.band

return {
    fromInt = function(p1) -- FromInt | line: 16
        -- upvalues: Assert (copy), ClampColor (copy), floor (copy), rshift (copy), band (copy)
        Assert.typeOf("FromInt", "int", "number", p1)

        local v1 = floor(p1)
        local v3 = band(rshift(v1, 16), 255)
        local v5 = band(rshift(v1, 8), 255)
        local v6 = band(v1, 255)

        return ClampColor(Color3.fromRGB(v3, v5, v6))
    end,
    toInt = function(p2) -- ToInt | line: 34
        -- upvalues: Assert (copy), floor (copy), lshift (copy)
        Assert.typeOf("ToInt", "color", "Color3", p2)

        return lshift(lshift(floor(p2.R * 255), 8) + floor(p2.G * 255), 8) + floor(p2.B * 255)
    end
}
