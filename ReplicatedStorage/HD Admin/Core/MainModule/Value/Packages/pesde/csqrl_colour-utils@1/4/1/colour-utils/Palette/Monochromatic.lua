-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local Monochromatic = Assert.prepTypeOf("Monochromatic")
local Monochromatic2 = Assert.prepEvalArg("Monochromatic")
local insert, floor, sort = table.insert, math.floor, table.sort

return function(p1, p2) -- line: 18
    -- upvalues: Monochromatic (copy), Monochromatic2 (copy), insert (copy), floor (copy), sort (copy)
    p2 = p2 or 3
    Monochromatic("base", "Color3", p1)
    Monochromatic("swatches", "number", p2)

    local v2 = floor(p2)

    Monochromatic2("swatches", "be greater than 0", v2 > 0, v2)

    local v3, v4, v5 = p1:ToHSV()
    local v6 = 1 / v2
    local t1 = {}

    for _ = 1, v2 do
        insert(t1, Color3.fromHSV(v3, v4, v5))
        v5 = (v5 + v6) % 1
    end

    sort(t1, function(p3, p4) -- line: 37
        return select(3, p3:ToHSV()) < select(3, p4:ToHSV())
    end)

    return t1
end
