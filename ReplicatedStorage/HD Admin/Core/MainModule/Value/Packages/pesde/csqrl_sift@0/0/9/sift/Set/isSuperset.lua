-- https://lua.expert

local isSubset = require(script.Parent.isSubset)

local function isSuperset(p1, p2) -- line: 21
    -- upvalues: isSubset (copy)
    return isSubset(p2, p1)
end

return isSuperset
