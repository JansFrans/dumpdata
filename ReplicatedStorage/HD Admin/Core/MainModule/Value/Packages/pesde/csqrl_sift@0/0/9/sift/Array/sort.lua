-- https://lua.expert

local copy = require(script.Parent.copy)

local function sort(p1, p2) -- line: 22
    -- upvalues: copy (copy)
    local v1 = copy(p1)

    table.sort(v1, p2)

    return v1
end

return sort
