-- https://lua.expert

local at = require(script.Parent.at)

local function first(p1) -- line: 19
    -- upvalues: at (copy)
    return at(p1, 1)
end

return first
