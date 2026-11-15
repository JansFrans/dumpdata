-- https://lua.expert

local getHumanoid = require(script.Parent.getHumanoid)

return function(p1) -- line: 3
    -- upvalues: getHumanoid (copy)
    local v1 = getHumanoid(p1)

    if not v1 or not p1 then
        return false, "Missing Humanoid or Character or Player"
    end

    if not p1.Character then
        return false, "Missing Character"
    end

    v1:UnequipTools()

    return true, "Success"
end
