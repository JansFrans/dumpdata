-- https://lua.expert

local Fusion = require(script.Parent.Parent.Parent.Fusion)

return function(p1, p2) -- line: 15
    -- upvalues: Fusion (copy)
    if typeof(p2) ~= "table" or p2.kind ~= "Value" then
        return Fusion.Value(p1, Fusion.peek(p2))
    end

    return p2
end
