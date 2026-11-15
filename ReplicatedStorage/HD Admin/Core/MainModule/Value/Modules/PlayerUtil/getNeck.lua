-- https://lua.expert

local getHead = require(script.Parent.getHead)

return function(p1) -- line: 4
    -- upvalues: getHead (copy)
    local v1 = getHead(p1)

    if not v1 then
        return nil
    end

    local Parent = v1.Parent
    local Neck = v1:FindFirstChild("Neck")
    local Torso = Parent:FindFirstChild("Torso")

    if not Neck and Torso then
        Neck = Torso:FindFirstChild("Neck")
    end

    return Neck
end
