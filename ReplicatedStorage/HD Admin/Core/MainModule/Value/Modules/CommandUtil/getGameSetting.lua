-- https://lua.expert

local Value = script:FindFirstAncestor("MainModule").Value
local Modules = Value.Modules
local v1 = game:GetService("RunService"):IsClient()

return function(p1) -- line: 6
    -- upvalues: Value (copy), Modules (copy), v1 (copy)
    if v1 then
        local v2, v3 = require(Modules.References.clientUser).everyone:fetchAsync("GameSettings", p1)

        if not v2 then
            v3 = nil
        end

        return v3
    end

    local Services = Value.Services

    return require(Services.Config).getSetting(p1)
end
