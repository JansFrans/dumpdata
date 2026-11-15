-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local openProfileRemote = require(Modules.References.openProfileRemote)

return function(p1, p2) -- line: 7
    -- upvalues: openProfileRemote (copy)
    if p1 then
        openProfileRemote:fireClient(p1, p2)
    end
end
