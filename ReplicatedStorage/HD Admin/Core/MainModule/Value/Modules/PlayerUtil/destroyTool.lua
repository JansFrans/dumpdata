-- https://lua.expert

local Players = game:GetService("Players")
local unequipTools = require(script.Parent.unequipTools)

return function(p1) -- line: 4
    -- upvalues: Players (copy), unequipTools (copy)
    local Parent = p1.Parent

    Parent = Parent and Parent:IsA("Model") and Players:GetPlayerFromCharacter(Parent)

    if Parent then
        unequipTools(Parent)
        task.delay(0.01, function() -- line: 12
            -- upvalues: p1 (copy)
            p1:Destroy()
        end)
    else
        p1:Destroy()
    end
end
