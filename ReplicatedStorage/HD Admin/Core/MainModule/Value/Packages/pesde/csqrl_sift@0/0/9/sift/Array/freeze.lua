-- https://lua.expert

local copy = require(script.Parent.copy)

local function freeze(p1) -- line: 22
    -- upvalues: copy (copy)
    local v1 = copy(p1)

    table.freeze(v1)

    return v1
end

return freeze
