-- https://lua.expert

local Parent = require(script.Parent)

return function(p1) -- line: 3
    -- upvalues: Parent (copy)
    p1 = p1 or Parent.localPlayer

    if typeof(p1) ~= "Instance" or not p1:IsA("Player") then
        return nil, nil
    end

    local v2 = p1 and p1.Character
    local Head = v2 and v2:FindFirstChild("Head")

    if Head and Head:IsA("BasePart") then
        return Head, v2
    end

    return nil, nil
end
