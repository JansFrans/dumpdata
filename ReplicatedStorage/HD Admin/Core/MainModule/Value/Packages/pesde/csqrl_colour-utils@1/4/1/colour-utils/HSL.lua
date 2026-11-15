-- https://lua.expert

local Assert = require(script.Parent.Util.Assert)
local round, floor, clamp, min = math.round, math.floor, math.clamp, math.min
local max, abs = math.max, math.abs

local function ToHSL(p1) -- line: 30
    -- upvalues: Assert (copy), round (copy), clamp (copy), min (copy), max (copy), abs (copy)
    Assert.typeOf("ToHSL", "color", "Color3", p1)

    local v1 = min(p1.R, p1.G, p1.B)
    local v2 = max(p1.R, p1.G, p1.B)
    local v3 = v2 - v1
    local v4 = (v2 + v1) / 2
    local v5 = if v3 == 0 then 0 else v3 / (1 - abs(v4 * 2 - 1))
    local v8 = round((if v3 == 0 then 0
        elseif v2 == p1.R then (p1.G - p1.B) / v3 % 6
        elseif v2 == p1.G then (p1.B - p1.R) / v3 + 2
        else (p1.R - p1.G) / v3 + 4) * 60)

    if v8 < 0 then
        v8 += 360
    end

    return {
        H = v8,
        S = clamp(abs((round(v5 * 100))), 0, 100),
        L = clamp(abs((round(v4 * 100))), 0, 100)
    }
end

return {
    fromHSL = function(p2) -- FromHSL | line: 74
        -- upvalues: Assert (copy), floor (copy), min (copy), abs (copy)
        Assert.typeOf("FromHSL", "hsl", "table", p2)
        Assert.typeOf("FromHSL", "hsl.H", "number", p2.H)
        Assert.typeOf("FromHSL", "hsl.S", "number", p2.S)
        Assert.typeOf("FromHSL", "hsl.L", "number", p2.L)

        local v16 = p2.S / 100
        local v17 = p2.L / 100
        local v19 = (1 - abs(v17 * 2 - 1)) * v16
        local v21 = v19 * (1 - abs(p2.H / 60 % 2 - 1))
        local v22 = v17 - v19 / 2
        local v23

        if p2.H >= 0 and p2.H < 60 then
            v21, v23, v19 = v19, v21, 0
        elseif p2.H >= 60 and p2.H < 120 then
            v23 = v19
            v19 = 0
        elseif p2.H >= 120 and p2.H < 180 then
            v21, v23, v19 = 0, v19, v21
        elseif not (p2.H >= 180 and p2.H < 240) then
            if not (p2.H >= 240 and p2.H < 300) then
                if p2.H >= 300 and p2.H < 360 then
                    v21, v19 = v19, v21
                else
                    v21 = 0
                    v19 = 0
                end
            end

            v23 = 0
        else
            v21, v23 = 0, v21
        end

        local v26 = min(floor((v21 + v22) * 255), 255)
        local v29 = min(floor((v23 + v22) * 255), 255)
        local v32 = min(floor((v19 + v22) * 255), 255)

        return Color3.fromRGB(v26, v29, v32)
    end,
    toHSL = ToHSL
}
