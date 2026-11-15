-- https://lua.expert

local toSet = require(script.Parent.toSet)

local function removeValues(p1, ...) -- line: 20
    -- upvalues: toSet (copy)
    local v1 = toSet({ ... })
    local t1 = {}

    for _, v2 in ipairs(p1) do
        if not v1[v2] then
            table.insert(t1, v2)
        end
    end

    return t1
end

return removeValues
