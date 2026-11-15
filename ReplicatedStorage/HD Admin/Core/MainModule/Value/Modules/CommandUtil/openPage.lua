-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local openPageRemote = require(Modules.References.openPageRemote)

return function(p1, p2, p3, p4) -- line: 7
    -- upvalues: openPageRemote (copy)
    if p1 then
        openPageRemote:fireClient(p1, p2, p3, p4 == true)
    end
end
