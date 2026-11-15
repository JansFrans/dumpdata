-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local getHumanoid = require(Modules.PlayerUtil.getHumanoid)
local getDescription = require(Modules.OutfitUtil.getDescription)
local applyDescription = require(Modules.OutfitUtil.applyDescription)

return function(p1, p2) -- line: 6
    -- upvalues: getHumanoid (copy), getDescription (copy), applyDescription (copy)
    return function(p3, p4) -- line: 7
        -- upvalues: p1 (copy), p2 (copy), getHumanoid (copy), getDescription (copy), applyDescription (copy)
        local v1 = getHumanoid(p1)

        if not v1 then
            return
        end

        local _ = p1.Character
        local v2 = p4 or getDescription(v1)

        if p3 then
            applyDescription(v1, v2)
        else
            applyDescription(v1, p4, p2)
        end

        return v2
    end
end
