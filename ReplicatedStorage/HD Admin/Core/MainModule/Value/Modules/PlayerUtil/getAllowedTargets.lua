-- https://lua.expert

local Players = game:GetService("Players")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules

return function(p1, p2) -- line: 12
    -- upvalues: Players (copy), Modules (copy)
    p2 = p2 or {}

    local v2 = p2.prompt == true
    local v3, commandKey

    if typeof(p1) ~= "table" then
        v3 = p1

        return require(Modules.RoleUtil.filterBlockedTargets)(p2.players or Players:GetPlayers(), v3, v2, commandKey)
    end

    v3 = p1.callerUserId
    commandKey = p1.commandKey
    v2 = require(Modules.CommandUtil.isPromptCommand)(p1.commandKey)

    return require(Modules.RoleUtil.filterBlockedTargets)(p2.players or Players:GetPlayers(), v3, v2, commandKey)
end
