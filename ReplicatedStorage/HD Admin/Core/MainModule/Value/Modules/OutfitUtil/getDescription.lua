-- https://lua.expert

local Parent = require(script.Parent)
local _, deferringHumanoidsComplete = Parent.deferringHumanoids, Parent.deferringHumanoidsComplete

return function(p1) -- line: 10
    -- upvalues: deferringHumanoidsComplete (copy)
    local v1 = deferringHumanoidsComplete[p1]

    if not v1 then
        return p1:GetAppliedDescription()
    end

    local baseDesc = v1.baseDesc
    local clone = baseDesc and baseDesc:Clone()

    for _, v2 in v1.array do
        for v3, v4 in v2 do
            clone[v3] = v4
        end
    end

    p1.Destroying:Once(function() -- line: 22
        -- upvalues: clone (copy)
        clone:Destroy()
    end)

    return clone
end
