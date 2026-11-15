-- https://lua.expert

local Assert = require(script.Parent.Parent.Util.Assert)
local LAB = require(script.Parent.Parent.LAB)
local Constants = require(script.Parent.Constants)
local round, atan2, sqrt = math.round, math.atan2, math.sqrt

local function LABtoLCH(p1) -- line: 10
    -- upvalues: Constants (copy), round (copy), atan2 (copy), sqrt (copy)
    local v2 = sqrt(p1.A ^ 2 + p1.B ^ 2)
    local v3 = (atan2(p1.B, p1.A) * Constants.RAD_DEG + 360) % 360

    if round(v2 * 10000) == 0 then
        v3 = Constants.NaN
    end

    return {
        L = p1.L,
        C = v2,
        H = v3
    }
end

local function ToLCH(p2) -- line: 32
    -- upvalues: Assert (copy), LAB (copy), LABtoLCH (copy)
    Assert.typeOf("ToLCH", "color", "Color3", p2)

    return (LABtoLCH((LAB.toLAB(p2))))
end

return ToLCH
