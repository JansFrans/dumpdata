-- https://lua.expert

require(script.Parent.Parent.Types)

local toSet = require(script.Parent.toSet)
local toArray = require(script.Parent.Parent.Set.toArray)
local differenceSymmetric = require(script.Parent.Parent.Set.differenceSymmetric)

local function differenceSymmetric2(p1, ...) -- line: 25
    -- upvalues: toSet (copy), toArray (copy), differenceSymmetric (copy)
    local v1 = toSet(p1)
    local t1 = {}

    for _, v2 in { ... } do
        if typeof(v2) == "table" then
            table.insert(t1, toSet(v2))
        end
    end

    return toArray((differenceSymmetric(v1, unpack(t1))))
end

return differenceSymmetric2
