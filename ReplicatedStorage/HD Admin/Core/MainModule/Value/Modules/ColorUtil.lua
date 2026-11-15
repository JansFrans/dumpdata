-- https://lua.expert

local t1 = {
    getLuminance = function(p1) -- getLuminance | line: 5
        local function transform(p2) -- line: 6
            if p2 <= 0.03928 then
                return p2 / 12.92
            end

            return ((p2 + 0.055) / 1.055) ^ 2.4
        end

        local R = p1.R
        local v1 = (if R <= 0.03928 then R / 12.92 else ((R + 0.055) / 1.055) ^ 2.4) * 0.2126
        local G = p1.G
        local v2 = v1 + (if G <= 0.03928 then G / 12.92 else ((G + 0.055) / 1.055) ^ 2.4) * 0.7152
        local B = p1.B

        return v2 + (if B <= 0.03928 then B / 12.92 else ((B + 0.055) / 1.055) ^ 2.4) * 0.0722
    end,
    getPerceivedBrightness = function(p3) -- getPerceivedBrightness | line: 13
        return (p3.R * 255 * 299 + p3.G * 255 * 587 + p3.B * 255 * 114) / 1000 / 255
    end,
    darken = function(p4, p5) -- darken | line: 18
        return p4:Lerp(Color3.new(), (math.clamp(p5, 0, 1)))
    end,
    lighten = function(p6, p7) -- lighten | line: 23
        return p6:Lerp(Color3.new(1, 1, 1), (math.clamp(p7, 0, 1)))
    end
}

function t1.emphasize(p8, p9, p10) -- line: 30
    -- upvalues: t1 (copy)
    p10 = p10 or 0.5

    local v4 = p9 * (1 + t1.getPerceivedBrightness(p8))

    if p10 < t1.getLuminance(p8) then
        return t1.darken(p8, v4)
    end

    return t1.lighten(p8, v4)
end

return t1
