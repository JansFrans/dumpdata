-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local applyInstanceProps = require(ParentParent.Instances.applyInstanceProps)

local function Hydrate(p1, p2) -- line: 16
    -- upvalues: External (copy), applyInstanceProps (copy)
    if p2 == nil then
        External.logError("scopeMissing", nil, "instances using Hydrate", "myScope:Hydrate (instance) { ... }")
    end

    return function(p3) -- line: 23
        -- upvalues: p1 (copy), p2 (copy), applyInstanceProps (copy)
        table.insert(p1, p2)
        applyInstanceProps(p1, p3, p2)

        return p2
    end
end

return Hydrate
