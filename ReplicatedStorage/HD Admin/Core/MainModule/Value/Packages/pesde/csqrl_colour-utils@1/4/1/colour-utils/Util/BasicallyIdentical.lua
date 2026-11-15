-- https://lua.expert

local format, abs = string.format, math.abs

local function StringifyColor3(p1) -- line: 4
    return string.format("Color3<%.3g, %.3g, %.3g> \"#%s\"", p1.R * 255, p1.G * 255, p1.B * 255, p1:ToHex())
end

return function(p2, p3, p4) -- line: 8
    -- upvalues: format (copy), abs (copy)
    local v1 = if type(p4) == "number" then p4 else 0.005

    assert(typeof(p2) == "Color3", "\"Base\" is not a Color3")
    assert(typeof(p3) == "Color3", "\"Compare\" is not a Color3")

    local v5 = abs(p2.R - p3.R)
    local v7 = abs(p2.G - p3.G)
    local v9 = abs(p2.B - p3.B)
    local v10 = v5 <= v1 and v7 <= v1 and v9 <= v1

    if not v10 then
        local t1 = {}

        if v1 < v5 then
            table.insert(t1, format("R was out by %.3g", (tostring((abs(v1 - v5))))))
        end

        if v1 < v7 then
            table.insert(t1, format("G was out by %.3g", (tostring((abs(v1 - v7))))))
        end

        if v1 < v9 then
            table.insert(t1, format("B was out by %.3g", (tostring((abs(v1 - v9))))))
        end

        error(format("Expected %s (%s) to be within %s, got %s (%s) instead; %s", string.format("Color3<%.3g, %.3g, %.3g> \"#%s\"", p2.R * 255, p2.G * 255, p2.B * 255, p2:ToHex()), typeof(p2), tostring(v1), string.format("Color3<%.3g, %.3g, %.3g> \"#%s\"", p3.R * 255, p3.G * 255, p3.B * 255, p3:ToHex()), typeof(p3), table.concat(t1, ", ")), 2)
    end

    return v10
end
