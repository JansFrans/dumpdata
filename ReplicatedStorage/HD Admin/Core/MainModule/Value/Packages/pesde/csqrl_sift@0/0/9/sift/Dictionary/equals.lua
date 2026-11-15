-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)

require(ParentParent.Types)

local function compare(p1, p2) -- line: 7
    if type(p1) ~= "table" or type(p2) ~= "table" then
        return p1 == p2
    end

    for v1, v2 in pairs(p1) do
        if p2[v1] ~= v2 then
            return false
        end
    end

    for v3, v4 in pairs(p2) do
        if p1[v3] ~= v4 then
            return false
        end
    end

    return true
end

local function equals(...) -- line: 45
    -- upvalues: Util (copy), compare (copy)
    if Util.equalObjects(...) then
        return true
    end

    local v5 = select("#", ...)
    local v6 = select(1, ...)

    for i = 2, v5 do
        if not compare(v6, (select(i, ...))) then
            return false
        end
    end

    return true
end

return equals
