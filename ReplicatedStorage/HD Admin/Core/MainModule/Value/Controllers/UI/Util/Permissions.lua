-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages

require(Packages.Fusion)

local RoleLockRules = require(Modules.Parent.Controllers.UI.Config.RoleLockRules)
local isInternalRole = require(Modules.RoleUtil.isInternalRole)
local t1 = {
    None = 0,
    Commands = 1,
    Menu = 2
}
local t2 = {
    [0] = "None",
    [1] = "Commands",
    [2] = "Menu"
}

local function anyRoleMatches(p1, p2, p3) -- line: 27
    if typeof(p2) ~= "table" or typeof(p1) ~= "table" then
        return false
    end

    local roleKeys = p2.roleKeys

    if typeof(roleKeys) == "table" then
        for _, v1 in roleKeys do
            local v2 = p1[v1]

            if typeof(v2) == "table" and p3(v2) then
                return true
            end
        end
    end

    return false
end

local t3 = {
    youReady = function(p4) -- youReady | line: 50
        local YouMember = p4:Fuse("temp", "YouMember")
        local RoleInfo = p4:Fuse("everyone", "RoleInfo")

        return p4:Computed(function(p5) -- line: 53
            -- upvalues: YouMember (copy), RoleInfo (copy)
            local v3 = p5(YouMember)
            local v4 = p5(RoleInfo)

            if typeof(v3) ~= "table" or typeof(v4) ~= "table" then
                return false
            end

            return typeof(v3.roleKeys) == "table"
        end)
    end
}

function t3.canViewPage(p6, p7) -- line: 62
    -- upvalues: anyRoleMatches (copy)
    local YouMember = p6:Fuse("temp", "YouMember")
    local RoleInfo = p6:Fuse("everyone", "RoleInfo")

    return p6:Computed(function(p8) -- line: 65
        -- upvalues: p7 (copy), YouMember (copy), RoleInfo (copy), anyRoleMatches (copy)
        return (anyRoleMatches(p8(RoleInfo), p8(YouMember), function(p9) -- line: 68
            -- upvalues: p7 (copy)
            if p9.mayViewAll == true then
                return true
            end

            local mayViewPages = p9.mayViewPages

            if typeof(mayViewPages) == "table" then
                for _, v7 in mayViewPages do
                    if v7 == "All" or v7 == p7 then
                        return true
                    end
                end
            end

            return false
        end))
    end)
end

function t3.canViewAnyOf(p10, p11) -- line: 82
    -- upvalues: anyRoleMatches (copy)
    if #p11 == 0 then
        return p10:Computed(function() -- line: 84
            return true
        end)
    end

    local YouMember = p10:Fuse("temp", "YouMember")
    local RoleInfo = p10:Fuse("everyone", "RoleInfo")

    return p10:Computed(function(p12) -- line: 88
        -- upvalues: p11 (copy), YouMember (copy), RoleInfo (copy), anyRoleMatches (copy)
        return (anyRoleMatches(p12(RoleInfo), p12(YouMember), function(p13) -- line: 91
            -- upvalues: p11 (copy)
            if p13.mayViewAll == true then
                return true
            end

            local mayViewPages = p13.mayViewPages

            if typeof(mayViewPages) == "table" then
                for _, v10 in mayViewPages do
                    if v10 == "All" then
                        return true
                    end

                    for _, v11 in p11 do
                        if v10 == v11 then
                            return true
                        end
                    end
                end
            end

            return false
        end))
    end)
end

function t3.iconMode(p14) -- line: 108
    -- upvalues: t1 (copy), t2 (copy)
    local YouMember = p14:Fuse("temp", "YouMember")
    local RoleInfo = p14:Fuse("everyone", "RoleInfo")

    return p14:Computed(function(p15) -- line: 111
        -- upvalues: YouMember (copy), RoleInfo (copy), t1 (copy), t2 (copy)
        local v12 = p15(RoleInfo)
        local v13 = p15(YouMember)

        if typeof(v13) == "table" and typeof(v12) == "table" and typeof(v13.roleKeys) == "table" then
            local n1 = 0

            for _, v14 in v13.roleKeys do
                local v15 = v12[v14]

                if typeof(v15) == "table" then
                    local v16 = if v15.mayViewAll == true then 2 else t1[tostring(v15.mayViewIcon)] or 0

                    if n1 < v16 then
                        n1 = v16
                    end
                end
            end

            return t2[n1]
        end

        return "Menu"
    end)
end

function t3.canUseModifierNow(p16) -- line: 133
    -- upvalues: Modules (copy), RoleLockRules (copy), anyRoleMatches (copy)
    if typeof(p16) ~= "table" then
        return false
    end

    local v17 = p16.isAbusive == true
    local v18 = p16.isGlobal == true

    if not (v17 or v18) then
        return true
    end

    local clientUser = require(Modules.References.clientUser)
    local YouMember = clientUser.temp:get("YouMember")
    local RoleInfo = clientUser.everyone:get("RoleInfo")

    if v17 and not anyRoleMatches(RoleInfo, YouMember, function(p17) -- line: 143
        -- upvalues: RoleLockRules (copy)
        return RoleLockRules.isEffectivelyEnabledOnRole(p17, "permitModifiersAbusive")
    end) then
        return false
    end

    local v19 = if v18 then anyRoleMatches(RoleInfo, YouMember, function(p18) -- line: 148
        -- upvalues: RoleLockRules (copy)
        return RoleLockRules.isEffectivelyEnabledOnRole(p18, "permitModifiersGlobal")
    end) else nil

    return not not (not v18 or v19)
end

function t3.hasPermission(p19, p20) -- line: 157
    -- upvalues: RoleLockRules (copy), anyRoleMatches (copy)
    local YouMember = p19:Fuse("temp", "YouMember")
    local RoleInfo = p19:Fuse("everyone", "RoleInfo")

    return p19:Computed(function(p21) -- line: 160
        -- upvalues: p20 (copy), YouMember (copy), RoleInfo (copy), RoleLockRules (copy), anyRoleMatches (copy)
        return (anyRoleMatches(p21(RoleInfo), p21(YouMember), function(p22) -- line: 163
            -- upvalues: p20 (copy), RoleLockRules (copy)
            return RoleLockRules.isEffectivelyEnabledOnRole(p22, p20)
        end))
    end)
end

function t3.canEditRoleByKey(p23, p24) -- line: 171
    -- upvalues: RoleLockRules (copy), isInternalRole (copy)
    local YouMember = p23:Fuse("temp", "YouMember")
    local RoleInfo = p23:Fuse("everyone", "RoleInfo")

    return p23:Computed(function(p25) -- line: 174
        -- upvalues: p24 (copy), YouMember (copy), RoleInfo (copy), RoleLockRules (copy), isInternalRole (copy)
        local v22 = p25(RoleInfo)
        local v23 = p25(YouMember)
        local v24 = if typeof(p24) == "string" then p24 else p25(p24)

        if typeof(v22) ~= "table" or typeof(v23) ~= "table" or typeof(v24) ~= "string" or v24 == "" then
            return false
        end

        local v25 = v22[v24]

        if typeof(v25) ~= "table" or isInternalRole(v25) then
            return false
        end

        local v26 = if typeof(v25.rank) == "number" then v25.rank else 0
        local roleKeys = v23.roleKeys

        if typeof(roleKeys) ~= "table" then
            return false
        end

        local n2 = 0
        local v27 = false

        for _, v28 in roleKeys do
            local v29 = v22[v28]

            if typeof(v29) == "table" then
                local v30 = if typeof(v29.rank) == "number" then v29.rank else 0

                if n2 < v30 then
                    n2 = v30
                end

                if RoleLockRules.isEffectivelyEnabledOnRole(v29, "mayEditRoles") then
                    v27 = true
                end
            end
        end

        if not v27 then
            return false
        end

        return v26 < n2
    end)
end

function t3.canEditRoles(p26) -- line: 201
    -- upvalues: t3 (copy)
    local mayEditAll = t3.hasPermission(p26, "mayEditAll")
    local mayEditRoles = t3.hasPermission(p26, "mayEditRoles")

    return p26:Computed(function(p27) -- line: 204
        -- upvalues: mayEditAll (copy), mayEditRoles (copy)
        if p27(mayEditAll) == true then
            return true
        end

        return p27(mayEditRoles) == true
    end)
end

function t3.canUseCommand(p28, p29) -- line: 211
    local YouMember = p28:Fuse("temp", "YouMember")
    local CommandInfo = p28:Fuse("everyone", "CommandInfo")

    return p28:Computed(function(p30) -- line: 214
        -- upvalues: p29 (copy), YouMember (copy), CommandInfo (copy)
        local v31 = p30(YouMember)
        local v32 = p30(CommandInfo)

        if typeof(v31) == "table" and typeof(v32) == "table" then
            local v33 = v32[p29]

            if typeof(v33) == "table" then
                local roles = v33.roles

                if typeof(roles) == "table" then
                    local t4 = {}

                    for _, v34 in roles do
                        t4[v34] = true
                    end

                    local roleKeys = v31.roleKeys

                    if typeof(roleKeys) == "table" then
                        for _, v35 in roleKeys do
                            if t4[v35] then
                                return true
                            end
                        end
                    end
                end
            end
        end

        return false
    end)
end

return t3
