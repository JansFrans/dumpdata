-- https://lua.expert

local toSet = require(script.Parent.Parent.Array.toSet)

local function removeValues(p1, ...) -- line: 23
    -- upvalues: toSet (copy)
    local v1 = toSet({ ... })
    local t1 = {}

    for v2, v3 in pairs(p1) do
        if not v1[v3] then
            t1[v2] = v3
        end
    end

    return t1
end

return removeValues
