-- https://lua.expert

local Array = require(script.Parent.Parent.Util.Array)
local Assert = require(script.Parent.Parent.Util.Assert)

require(script.Parent.Parent.Util.Types)

local HSL = require(script.Parent.Parent.HSL)
local Saturate = require(script.Parent.Parent.Saturate)
local Tailwind = Assert.prepTypeOf("Tailwind")
local find, abs = table.find, math.abs
local t1 = {
    0.32, 0.16, 0.08, 0.04, 0, 0, 0.04, 0.08,
    0.16, 0.32, 0.84
}
local t2 = {
    0.95, 0.85, 0.75, 0.65, 0.55, 0.45, 0.35, 0.25,
    0.15, 0.1, 0.05
}

local function GetBaseColorSaturationIndex(p1) -- line: 33
    -- upvalues: Array (copy), find (copy), abs (copy), t2 (copy)
    local v1 = p1.L / 100

    return find(t2, (Array.reduce(t2, function(p2, p3) -- line: 36
        -- upvalues: v1 (copy), abs (copy)
        if abs(p3 - v1) < abs(p2 - v1) then
            return p3
        end

        return p2
    end)))
end

local function Tailwind2(p4) -- line: 61
    -- upvalues: Array (copy), HSL (copy), Saturate (copy), Tailwind (copy), find (copy), abs (copy), t1 (copy), t2 (copy)
    Tailwind("base", "Color3", p4)

    local v6 = HSL.toHSL(p4)
    local v7 = v6.L / 100
    local v12 = find(t2, (Array.reduce(t2, function(p5, p6) -- line: 36
        -- upvalues: v7 (copy), abs (copy)
        if abs(p6 - v7) < abs(p5 - v7) then
            return p6
        end

        return p5
    end)))
    local v13 = Array.map(Array.map(t2, function(p7) -- line: 68
        -- upvalues: v6 (copy), HSL (copy)
        return HSL.fromHSL({
            H = v6.H,
            S = v6.S,
            L = p7 * 100
        })
    end), function(p8, p9) -- line: 71
        -- upvalues: v12 (copy), Saturate (copy), t1 (copy)
        return Saturate(p8, t1[p9] - t1[v12])
    end)

    return Array.reduce(v13, function(p10, p11, p12) -- line: 77
        -- upvalues: v13 (copy)
        local v15 = if p12 == 1 then 50 else (p12 - 1) * 100

        if p12 == #v13 then
            v15 -= 50
        end

        p10[v15] = p11

        return p10
    end, {})
end

return Tailwind2
