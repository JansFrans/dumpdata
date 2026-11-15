-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local isNaN = require(script.Parent.Parent.Util.isNaN)
local Constants = require(script.Parent.Constants)
local LAB = require(script.Parent.Parent.LAB)
local sin, cos = math.sin, math.cos

local function LCHtoLAB(p1) -- line: 10
    -- upvalues: isNaN (copy), Constants (copy), sin (copy), cos (copy)
    if isNaN(p1.H) then
        p1.H = 0
    end

    p1.H *= Constants.DEG_RAD

    return {
        L = p1.L,
        A = cos(p1.H) * p1.C,
        B = sin(p1.H) * p1.C
    }
end

local function FromLCH(p2) -- line: 31
    -- upvalues: Assert (copy), LAB (copy), LCHtoLAB (copy)
    Assert.typeOf("FromLCH", "lch", "table", p2)
    Assert.typeOf("FromLCH", "lch.L", "number", p2.L)
    Assert.typeOf("FromLCH", "lch.C", "number", p2.C)
    Assert.typeOf("FromLCH", "lch.H", "number", p2.H)

    local v1 = LCHtoLAB(p2)

    return LAB.fromLAB(v1)
end

return FromLCH
