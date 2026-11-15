-- https://lua.expert

require(script.Parent.Parent.Types)

local toSet = require(script.Parent.toSet)
local toArray = require(script.Parent.Parent.Set.toArray)
local difference = require(script.Parent.Parent.Set.difference)

local function difference2(p1, ...) -- line: 25
    -- upvalues: toSet (copy), toArray (copy), difference (copy)
    local v1 = toSet(p1)
    local t1 = {}

    for _, v2 in { ... } do
        if typeof(v2) == "table" then
            table.insert(t1, toSet(v2))
        end
    end

    return toArray((difference(v1, unpack(t1))))
end

return difference2
