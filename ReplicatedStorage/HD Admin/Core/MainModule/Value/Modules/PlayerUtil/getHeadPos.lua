-- https://lua.expert

local getHead = require(script.Parent.getHead)

return function(p1) -- line: 3
    -- upvalues: getHead (copy)
    local v1 = getHead(p1)

    return v1 and v1.Position
end
