-- https://lua.expert

local at = require(script.Parent.at)

local function last(p1) -- line: 19
    -- upvalues: at (copy)
    return at(p1, 0)
end

return last
