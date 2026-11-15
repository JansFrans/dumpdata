-- https://lua.expert

local copy = require(script.Parent.copy)

local function set(p1, p2, p3) -- line: 21
    -- upvalues: copy (copy)
    local v1 = copy(p1)

    v1[p2] = p3

    return v1
end

return set
