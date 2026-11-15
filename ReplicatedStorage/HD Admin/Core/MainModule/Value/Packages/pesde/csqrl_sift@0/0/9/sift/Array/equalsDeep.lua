-- https://lua.expert

local Util = require(script.Parent.Parent.Util)

local function compareDeep(p1, p2) -- line: 6
    -- upvalues: compareDeep (copy)
    if type(p1) ~= "table" or type(p2) ~= "table" then
        return p1 == p2
    end

    local v1 = #p1

    if #p2 ~= v1 then
        return false
    end

    for i = 1, v1 do
        if not compareDeep(p1[i], p2[i]) then
            return false
        end
    end

    return true
end

local function equalsDeep(...) -- line: 44
    -- upvalues: Util (copy), compareDeep (copy)
    if Util.equalObjects(...) then
        return true
    end

    local v2 = select("#", ...)
    local v3 = select(1, ...)

    for i = 2, v2 do
        if not compareDeep(v3, (select(i, ...))) then
            return false
        end
    end

    return true
end

return equalsDeep
