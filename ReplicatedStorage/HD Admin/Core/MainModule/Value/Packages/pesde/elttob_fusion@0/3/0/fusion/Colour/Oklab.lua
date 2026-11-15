-- https://lua.expert

local sRGB = require(script.Parent.sRGB)
local t1 = {
    fromLinear = function(p1) -- fromLinear | line: 18
        local v1 = p1.R * 0.4122214708 + p1.G * 0.5363325363 + p1.B * 0.0514459929
        local v2 = p1.R * 0.2119034982 + p1.G * 0.6806995451 + p1.B * 0.1073969566
        local v3 = p1.R * 0.0883024619 + p1.G * 0.2817188376 + p1.B * 0.6299787005
        local v4 = v1 ^ 0.3333333333333333
        local v5 = v2 ^ 0.3333333333333333
        local v6 = v3 ^ 0.3333333333333333

        return (Vector3.new(v4 * 0.2104542553 + v5 * 0.793617785 - v6 * 0.0040720468, v4 * 1.9779984951 - v5 * 2.428592205 + v6 * 0.4505937099, v4 * 0.0259040371 + v5 * 0.7827717662 - v6 * 0.808675766))
    end
}

function t1.fromSRGB(p2) -- line: 36
    -- upvalues: sRGB (copy), t1 (copy)
    return t1.fromLinear(sRGB.toLinear(p2))
end

function t1.toLinear(p3, p4) -- line: 42
    local v10 = p3.X + p3.Y * 0.3963377774 + p3.Z * 0.2158037573
    local v11 = p3.X - p3.Y * 0.1055613458 - p3.Z * 0.0638541728
    local v12 = p3.X - p3.Y * 0.0894841775 - p3.Z * 1.291485548
    local v13 = v10 ^ 3
    local v14 = v11 ^ 3
    local v15 = v12 ^ 3
    local v16 = v13 * 4.0767416621 - v14 * 3.3077115913 + v15 * 0.2309699292
    local v17 = v13 * -1.2684380046 + v14 * 2.6097574011 - v15 * 0.3413193965
    local v18 = v13 * -0.0041960863 - v14 * 0.7034186147 + v15 * 1.707614701

    if not p4 then
        v16 = math.clamp(v16, 0, 1)
        v17 = math.clamp(v17, 0, 1)
        v18 = math.clamp(v18, 0, 1)
    end

    return Color3.new(v16, v17, v18)
end

function t1.toSRGB(p5, p6) -- line: 66
    -- upvalues: sRGB (copy), t1 (copy)
    return sRGB.fromLinear(t1.toLinear(p5, p6))
end

return t1
