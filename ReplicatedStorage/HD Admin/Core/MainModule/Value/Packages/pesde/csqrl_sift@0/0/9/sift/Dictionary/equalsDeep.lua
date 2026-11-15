-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)

require(ParentParent.Types)

local function compareDeep(p1, p2) -- line: 7
    -- upvalues: compareDeep (copy)
    if type(p1) ~= "table" or type(p2) ~= "table" then
        return p1 == p2
    end

    for v1, v2 in pairs(p1) do
        if not compareDeep(v2, p2[v1]) then
            return false
        end
    end

    for v3, v4 in pairs(p2) do
        if not compareDeep(v4, p1[v3]) then
            return false
        end
    end

    return true
end

local function equalsDeep(...) -- line: 45
    -- upvalues: Util (copy), compareDeep (copy)
    if Util.equalObjects(...) then
        return true
    end

    local v5 = select("#", ...)
    local v6 = select(1, ...)

    for i = 2, v5 do
        if not compareDeep(v6, (select(i, ...))) then
            return false
        end
    end

    return true
end

return equalsDeep
