-- https://lua.expert

require(script.Parent.Parent.Parent.Fusion)

local t1 = {
    Vector2 = function(p1, p2, p3) -- Vector2 | line: 15
        return p1:Computed(function(p4) -- line: 20
            -- upvalues: p2 (copy), p3 (copy)
            return Vector2.new(p4(p2), p4(p3))
        end)
    end,
    UDim = function(p5, p6, p7) -- UDim | line: 34
        return p5:Computed(function(p8) -- line: 39
            -- upvalues: p6 (copy), p7 (copy)
            return UDim.new(p8(p6), p8(p7))
        end)
    end,
    UDim2 = function(p9, p10, p11, p12, p13) -- UDim2 | line: 55
        return p9:Computed(function(p14) -- line: 62
            -- upvalues: p10 (copy), p11 (copy), p12 (copy), p13 (copy)
            return UDim2.new(p14(p10), p14(p11), p14(p12), p14(p13))
        end)
    end
}

function t1.UDim2Offset(p15, p16, p17) -- line: 76
    -- upvalues: t1 (copy)
    return t1.UDim2(p15, 0, p16, 0, p17)
end

function t1.UDim2Scale(p18, p19, p20) -- line: 93
    -- upvalues: t1 (copy)
    return t1.UDim2(p18, p19, 0, p20, 0)
end

function t1.Font(p21, p22, p23, p24) -- line: 110
    return p21:Computed(function(p25) -- line: 116
        -- upvalues: p22 (copy), p23 (copy), p24 (copy)
        return Font.new(p25(p22), p25(p23), p25(p24) or Enum.FontStyle.Normal)
    end)
end

return t1
