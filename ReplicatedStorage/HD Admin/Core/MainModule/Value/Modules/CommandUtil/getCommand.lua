-- https://lua.expert

local Value = script:FindFirstAncestor("MainModule").Value
local Modules = Value.Modules
local v1 = game:GetService("RunService"):IsClient()

return function(p1) -- line: 6
    -- upvalues: Value (copy), Modules (copy), v1 (copy)
    local v2 = string.lower(p1)

    if v1 then
        local v3, v4 = require(Modules.References.clientUser).everyone:fetchAsync("CommandInfo", v2)

        return if v3 and typeof(v4) == "table" then v4 else nil
    end

    local Services = Value.Services

    return (require(Services.Commands).getCommand(v2))
end
