-- https://lua.expert

local Parent = require(script.Parent)

return function(p1) -- line: 3
    -- upvalues: Parent (copy)
    p1 = p1 or Parent.localPlayer

    local v2 = p1 and p1.Character
    local HumanoidRootPart = v2 and v2:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end
