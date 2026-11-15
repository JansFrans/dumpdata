-- https://lua.expert

require(script.Parent.Parent.Types)

local function has(p1, p2) -- line: 21
    return p1[p2] ~= nil
end

return has
