-- https://lua.expert

local find = require(script.Parent.find)

local function includes(p1, p2, p3) -- line: 28
    -- upvalues: find (copy)
    return find(p1, p2, p3) ~= nil
end

return includes
