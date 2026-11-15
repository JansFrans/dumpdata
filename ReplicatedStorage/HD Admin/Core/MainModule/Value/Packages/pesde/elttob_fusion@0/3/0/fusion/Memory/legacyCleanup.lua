-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local doCleanup = require(ParentParent.Memory.doCleanup)

local function legacyCleanup(p1) -- line: 11
    -- upvalues: External (copy), doCleanup (copy)
    External.logWarn("cleanupWasRenamed")

    return doCleanup(p1)
end

return legacyCleanup
