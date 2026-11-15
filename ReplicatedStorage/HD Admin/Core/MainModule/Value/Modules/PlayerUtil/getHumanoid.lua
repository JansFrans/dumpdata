-- https://lua.expert

local Parent = require(script.Parent)

return function(p1) -- line: 3
    -- upvalues: Parent (copy)
    p1 = p1 or Parent.localPlayer

    local v2 = p1 and p1.Character

    return v2 and v2:FindFirstChildOfClass("Humanoid")
end
