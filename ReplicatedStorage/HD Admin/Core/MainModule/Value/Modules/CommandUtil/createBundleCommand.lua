-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local runBundleId = require(Modules.OutfitUtil.runBundleId)

require(Modules.Prompt)
require(Modules.Objects.Task)

return function(p1, p2, p3) -- line: 6
    -- upvalues: runBundleId (copy)
    return {
        name = p1,
        aliases = if p3 then p3.Aliases else nil,
        groups = { "Bundle" },
        args = { "Player" },
        run = function(p4) -- run | line: 13
            -- upvalues: p2 (copy), p3 (copy), runBundleId (copy)
            return runBundleId(p4, p2, p3)
        end
    }
end
