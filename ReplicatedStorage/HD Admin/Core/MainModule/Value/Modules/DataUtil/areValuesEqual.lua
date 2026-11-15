-- https://lua.expert

local areColorsEqual = require(script.Parent.areColorsEqual)

local function areValuesEqual(p1, p2) -- line: 4
    -- upvalues: areColorsEqual (copy)
    local t1 = {
        CFrame = true,
        Vector3 = true
    }

    if type(p1) == "table" and type(p2) == "table" then
        return doTablesMatch(p1, p2)
    end

    local v1 = typeof(p1)
    local v2 = typeof(p2)

    if v1 == "Color3" and v2 == "Color3" then
        return areColorsEqual(p1, p2)
    end

    local v3, v4

    if t1[v1] and t1[v2] then
        v3 = tostring(p1)
        v4 = tostring(p2)
    else
        v3 = p1
        v4 = p2
    end

    return v3 == v4
end

function doTablesMatch(p3, p4, p5) -- line: 24
    -- upvalues: areValuesEqual (copy)
    if type(p3) ~= "table" or type(p4) ~= "table" then
        return false
    end

    for v5, v6 in p3 do
        if typeof(v6) == "table" then
            if doTablesMatch(p4[v5], v6) == false then
                return false
            end
        elseif not areValuesEqual(v6, p4[v5]) then
            return false
        end
    end

    return not not (p5 or doTablesMatch(p4, p3, true))
end

return areValuesEqual
