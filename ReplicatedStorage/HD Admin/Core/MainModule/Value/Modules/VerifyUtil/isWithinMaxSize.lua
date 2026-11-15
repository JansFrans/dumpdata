-- https://lua.expert

local Parent = require(script.Parent)
local processMaxSize = require(script.Parent.processMaxSize)

return function(p1, p2) -- line: 3
    -- upvalues: Parent (copy), processMaxSize (copy)
    return processMaxSize(p1, p2 or Parent.KEY_MAX_CHARACTERS)
end
