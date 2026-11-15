-- https://lua.expert

local t1 = {}

return {
    register = function(p1, p2) -- register | line: 5
        -- upvalues: t1 (copy)
        t1[p1] = p2
    end,
    getKey = function(p3) -- getKey | line: 9
        -- upvalues: t1 (copy)
        return t1[p3]
    end,
    resolveLocalKey = function(p4) -- resolveLocalKey | line: 14
        local Modules = script:FindFirstAncestor("MainModule").Value.Modules
        local User = require(Modules.Objects.User)
        local Roles = require(Modules.Parent.Services.Roles)
        local v1 = User.getUserByUserId(p4)
        local v2 = if v1 then Roles.getTopRole(v1) else nil

        return if typeof(v2) == "table" and v2.key then v2.key else nil
    end
}
