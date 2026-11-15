-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules

require(Modules.Objects.State)
require(Modules.Parent.Packages.Fusion)

local clientUser = require(Modules.References.clientUser)

return function(p1, p2, ...) -- line: 27
    -- upvalues: clientUser (copy)
    local v1 = if typeof(p2) == "string" then clientUser[p2] else p2

    if typeof(v1) ~= "table" then
        error("Invalid state provided to fuseState")
    end

    return v1:fuse(p1, ...)
end
