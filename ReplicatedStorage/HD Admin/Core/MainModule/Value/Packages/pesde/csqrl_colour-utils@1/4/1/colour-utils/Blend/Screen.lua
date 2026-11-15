-- https://lua.expert

local _Filter = require(script.Parent._Filter)
local rshift = bit32.rshift

return _Filter("Screen", function(p1, p2) -- line: 12
    -- upvalues: rshift (copy)
    return 255 - rshift((255 - p2 * 255) * (255 - p1 * 255), 8)
end)
