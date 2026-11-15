-- https://lua.expert

local copy = require(script.Parent.copy)

local function removeKey(p1, p2) -- line: 21
    -- upvalues: copy (copy)
    local v1 = copy(p1)

    v1[p2] = nil

    return v1
end

return removeKey
