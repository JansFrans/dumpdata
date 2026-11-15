-- https://lua.expert

local Parent = require(script.Parent)

return function(p1) -- line: 3
    -- upvalues: Parent (copy)
    p1 = p1 or Parent.localPlayer

    if p1 and p1:IsA("Player") then
        local Character = p1.Character
        local v2, v3

        if Character then
            v2 = Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("Torso")
            v3 = false
        else
            v3 = true
        end

        return not v3 and v2 or nil
    end

    return nil
end
