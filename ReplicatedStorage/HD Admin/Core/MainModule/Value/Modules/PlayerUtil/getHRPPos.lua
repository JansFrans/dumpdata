-- https://lua.expert

local getHRP = require(script.Parent.getHRP)

return function(p1) -- line: 3
    -- upvalues: getHRP (copy)
    local v1 = getHRP(p1)

    return v1 and v1.Position
end
