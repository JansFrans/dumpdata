-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local isNaN = require(script.Parent.Parent.Util.isNaN)
local Constants = require(script.Parent.Constants)

local function XYZ_RGB(p1) -- line: 6
    return (if p1 <= 0.00304 then p1 * 12.92 else p1 ^ 0.4166666666666667 * 1.055 - 0.055) * 255
end

local function LAB_XYZ(p2) -- line: 10
    -- upvalues: Constants (copy)
    if Constants.t1 < p2 then
        return p2 ^ 3
    end

    return Constants.t2 * (p2 - Constants.t0)
end

local function FromLAB(p3) -- line: 21
    -- upvalues: Assert (copy), isNaN (copy), Constants (copy)
    Assert.typeOf("FromLAB", "lab", "table", p3)
    Assert.typeOf("FromLAB", "lab.L", "number", p3.L)
    Assert.typeOf("FromLAB", "lab.A", "number", p3.A)
    Assert.typeOf("FromLAB", "lab.B", "number", p3.B)

    local v1 = (p3.L + 16) / 116
    local v2 = if isNaN(p3.A) then v1 else v1 + p3.A / 500
    local v3 = if isNaN(p3.B) then v1 else v1 - p3.B / 200
    local v4 = Constants.Yn * (if Constants.t1 < v1 then v1 ^ 3 else Constants.t2 * (v1 - Constants.t0))
    local v5 = Constants.Xn * (if Constants.t1 < v2 then v2 ^ 3 else Constants.t2 * (v2 - Constants.t0))
    local v6 = Constants.Zn * (if Constants.t1 < v3 then v3 ^ 3 else Constants.t2 * (v3 - Constants.t0))
    local v7 = 3.2404542 * v5 - 1.5371385 * v4 - 0.4985314 * v6
    local v8 = (if v7 <= 0.00304 then v7 * 12.92 else v7 ^ 0.4166666666666667 * 1.055 - 0.055) * 255
    local v9 = -0.969266 * v5 + 1.8760108 * v4 + 0.041556 * v6
    local v10 = (if v9 <= 0.00304 then v9 * 12.92 else v9 ^ 0.4166666666666667 * 1.055 - 0.055) * 255
    local v11 = 0.0556434 * v5 - 0.2040259 * v4 + 1.0572252 * v6
    local v12 = (if v11 <= 0.00304 then v11 * 12.92 else v11 ^ 0.4166666666666667 * 1.055 - 0.055) * 255

    return Color3.fromRGB(v8, v10, v12)
end

return FromLAB
