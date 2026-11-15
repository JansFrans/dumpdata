-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local evaluate = require(ParentParent.Graph.evaluate)
local nameOf = require(ParentParent.Utility.nameOf)

local function depend(p1, p2) -- line: 16
    -- upvalues: External (copy), evaluate (copy), nameOf (copy)
    evaluate(p2, false)

    if table.isfrozen(p1.dependencySet) or table.isfrozen(p2.dependentSet) then
        External.logError("cannotDepend", nil, nameOf(p1, "Dependent"), nameOf(p2, "dependency"))
    end

    p2.dependentSet[p1] = true
    p1.dependencySet[p2] = true
end

return depend
