-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local openEmotesRemote = require(Modules.References.openEmotesRemote)

return function(p1) -- line: 7
    -- upvalues: openEmotesRemote (copy)
    if p1 then
        openEmotesRemote:fireClient(p1)
    end
end
