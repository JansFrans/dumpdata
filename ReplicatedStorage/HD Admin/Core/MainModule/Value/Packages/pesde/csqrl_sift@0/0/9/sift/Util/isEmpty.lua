-- https://lua.expert

require(script.Parent.Parent.Types)

local function isEmpty(p1) -- line: 22
    return next(p1) == nil
end

return isEmpty
