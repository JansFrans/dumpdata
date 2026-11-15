-- https://lua.expert

local getHumanoid = require(script.Parent.getHumanoid)

return function(p1) -- line: 3
    -- upvalues: getHumanoid (copy)
    local v1 = getHumanoid(p1)

    return if v1 then v1:FindFirstChildOfClass("Animator") else nil
end
