-- https://lua.expert

local Value = script:FindFirstAncestor("MainModule").Value
local Modules = Value.Modules
local v1 = game:GetService("RunService"):IsClient()

return function(p1, p2) -- line: 6
    -- upvalues: Value (copy), Modules (copy), v1 (copy)
    if v1 then
        local clientUser = require(Modules.References.clientUser)
        local v2, v3 = clientUser.perm:fetchAsync("YouSettings", p1)

        if v2 and v3 ~= nil then
            return v3
        end

        local v4, v5 = clientUser.everyone:fetchAsync("GameSettings", "PlayerSettings", p1)

        return if v4 and v5 ~= nil then v5 else nil
    end

    local User = require(Modules.Objects.User)
    local v6 = typeof(p2) == "Instance" and User.getUser(p2)
    local Services = Value.Services

    return require(Services.Config).getSetting(p1, v6)
end
