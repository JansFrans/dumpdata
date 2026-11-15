-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local openCommandsRemote = require(Modules.References.openCommandsRemote)
local boosterDisplay = require(Modules.CommandUtil.boosterDisplay)

return function(p1) -- line: 7
    -- upvalues: openCommandsRemote (copy), boosterDisplay (copy)
    if p1 then
        openCommandsRemote:fireClient(p1, boosterDisplay.getAll())
    end
end
