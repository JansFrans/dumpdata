-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local Constants = require(script.Parent.Constants)

local function RGB_XYZ(p1) -- line: 4
    if p1 <= 0.04045 then
        return p1 / 12.92
    end

    return ((p1 + 0.055) / 1.055) ^ 2.4
end

local function XYZ_LAB(p2) -- line: 12
    -- upvalues: Constants (copy)
    if Constants.t3 < p2 then
        return p2 ^ 0.3333333333333333
    end

    return p2 / Constants.t2 + Constants.t0
end

local function ToVector3(p3) -- line: 20
    -- upvalues: Constants (copy)
    local R = p3.R
    local v1 = if R <= 0.04045 then R / 12.92 else ((R + 0.055) / 1.055) ^ 2.4
    local G = p3.G
    local v2 = if G <= 0.04045 then G / 12.92 else ((G + 0.055) / 1.055) ^ 2.4
    local B = p3.B
    local v3 = if B <= 0.04045 then B / 12.92 else ((B + 0.055) / 1.055) ^ 2.4
    local v4 = (v1 * 0.4124564 + v2 * 0.3575761 + v3 * 0.1804375) / Constants.Xn
    local v5 = if Constants.t3 < v4 then v4 ^ 0.3333333333333333 else v4 / Constants.t2 + Constants.t0
    local v6 = (v1 * 0.2126729 + v2 * 0.7151522 + v3 * 0.072175) / Constants.Yn
    local v7 = if Constants.t3 < v6 then v6 ^ 0.3333333333333333 else v6 / Constants.t2 + Constants.t0
    local v8 = (v1 * 0.0193339 + v2 * 0.119192 + v3 * 0.9503041) / Constants.Zn

    return (Vector3.new(v5, v7, if Constants.t3 < v8 then v8 ^ 0.3333333333333333 else v8 / Constants.t2 + Constants.t0))
end

local function ToLAB(p4) -- line: 39
    -- upvalues: Assert (copy), ToVector3 (copy)
    Assert.typeOf("ToLAB", "color", "Color3", p4)

    local v10 = ToVector3(p4)
    local v11 = v10.Y * 116 - 16

    if v11 < 0 then
        v11 = 0
    end

    return {
        L = v11,
        A = (v10.X - v10.Y) * 500,
        B = (v10.Y - v10.Z) * 200
    }
end

return ToLAB
