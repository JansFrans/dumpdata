-- https://lua.expert

require(script.Parent.Parent.Types)

local copy = require(script.Parent.copy)

local function freeze(p1) -- line: 23
    -- upvalues: copy (copy)
    local v1 = copy(p1)

    table.freeze(v1)

    return v1
end

return freeze
