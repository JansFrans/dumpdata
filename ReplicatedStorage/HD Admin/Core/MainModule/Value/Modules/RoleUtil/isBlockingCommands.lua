-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules

return function(p1, p2) -- line: 6
    -- upvalues: Modules (copy)
    if not require(Modules.Parent.Services.Roles).hasPermission(p1, "permitBlockCommands") then
        return false
    end

    local Config = require(Modules.Parent.Services.Config)
    local v1 = if p2 == true then "BlockPrompts" else "BlockCommands"

    return Config.getSetting(v1, p1) == true
end
