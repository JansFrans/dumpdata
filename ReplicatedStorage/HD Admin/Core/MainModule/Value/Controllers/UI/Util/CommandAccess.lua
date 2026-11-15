-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local RoleLockRules = require(UI.Config.RoleLockRules)
local pickRoleGiver = require(Modules.CommandUtil.pickRoleGiver)
local promptPurchaseAsync = require(Modules.AssetUtil.promptPurchaseAsync)
local awaitPurchaseFinished = require(Modules.AssetUtil.awaitPurchaseFinished)
local isInternalRole = require(Modules.RoleUtil.isInternalRole)
local ClientGroupJoin = require(Modules.Parent.Controllers.ClientGroupJoin)
local t1 = {}

local function ownedSet(p1) -- line: 39
    local t2 = {}

    if typeof(p1) == "table" and typeof(p1.roleKeys) == "table" then
        for _, v1 in p1.roleKeys do
            t2[v1] = true
        end
    end

    return t2
end

function t1.bestGiverForRole(p2) -- line: 52
    -- upvalues: pickRoleGiver (copy)
    if typeof(p2) == "table" then
        return pickRoleGiver(p2.giveToProducts, p2.giveToGroups)
    end

    return nil
end

function t1.unlockStateForRole(p3, p4, p5) -- line: 60
    -- upvalues: t1 (copy)
    if p5 == "" then
        return nil
    end

    local t3 = {}

    if typeof(p3) == "table" and typeof(p3.roleKeys) == "table" then
        for _, v2 in p3.roleKeys do
            t3[v2] = true
        end
    end

    if t3[p5] then
        return "unlocked"
    end

    return if typeof(p4) == "table" and t1.bestGiverForRole(p4[p5]) then "unlock" else nil
end

function t1.promptUnlockAsync(p6, p7) -- line: 74
    -- upvalues: promptPurchaseAsync (copy), awaitPurchaseFinished (copy), ClientGroupJoin (copy), t1 (copy)
    if typeof(p6) == "table" then
        local v3 = t1.bestGiverForRole(p6[p7])

        if v3 then
            if v3.kind == "Group" then
                ClientGroupJoin.promptAndVerifyAsync(v3.groupId)
            elseif promptPurchaseAsync(v3.id, nil, v3.infoType) then
                awaitPurchaseFinished()
            end
        end
    end
end

function t1.promptUnlock(p8, p9) -- line: 92
    -- upvalues: t1 (copy)
    task.spawn(t1.promptUnlockAsync, p8, p9)
end

function t1.mayViewAll(p10, p11) -- line: 97
    -- upvalues: RoleLockRules (copy)
    if typeof(p11) ~= "table" or typeof(p10) ~= "table" then
        return false
    end

    local roleKeys = p10.roleKeys

    if typeof(roleKeys) == "table" then
        for _, v4 in roleKeys do
            local v5 = p11[v4]

            if typeof(v5) == "table" and RoleLockRules.isEffectivelyEnabledOnRole(v5, "mayViewUnavailableCommands") then
                return true
            end
        end
    end

    return false
end

local function isInternalOnly(p12, p13) -- line: 114
    -- upvalues: isInternalRole (copy)
    local roles = p12.roles

    if typeof(roles) ~= "table" or #roles == 0 then
        return false
    end

    for _, v6 in roles do
        if not isInternalRole(p13[v6]) then
            return false
        end
    end

    return true
end

function t1.buildViewable(p14, p15, p16) -- line: 128
    -- upvalues: isInternalRole (copy), t1 (copy), isInternalOnly (copy)
    if typeof(p14) ~= "table" or typeof(p15) ~= "table" or typeof(p16) ~= "table" then
        return {}
    end

    local t4 = {}

    for _, v7 in p14 do
        if not isInternalOnly(v7, p16) then
            table.insert(t4, v7)
        end
    end

    if t1.mayViewAll(p15, p16) then
        return t4
    end

    local t5 = {}

    if typeof(p15) == "table" and typeof(p15.roleKeys) == "table" then
        for _, v8 in p15.roleKeys do
            t5[v8] = true
        end
    end

    local t6 = {}

    for v9, v10 in p16 do
        if typeof(v9) == "string" and not isInternalRole(v10) and t1.bestGiverForRole(v10) then
            t6[v9] = true
        end
    end

    local t7 = {}

    for _, v11 in t4 do
        local roles = v11.roles

        if typeof(roles) == "table" then
            for _, v12 in roles do
                if t5[v12] or t6[v12] then
                    table.insert(t7, v11)
                    break
                end
            end
        end
    end

    return t7
end

function t1.runState(p17, p18, p19) -- line: 174
    -- upvalues: isInternalRole (copy), t1 (copy)
    local t8 = {
        usable = false,
        unlockState = nil,
        unlockRoleKey = nil
    }

    if typeof(p17) == "table" then
        local roles = p17.roles

        if typeof(roles) == "table" then
            local t9 = {}

            if typeof(p18) == "table" and typeof(p18.roleKeys) == "table" then
                for _, v13 in p18.roleKeys do
                    t9[v13] = true
                end
            end

            for _, v14 in roles do
                if t9[v14] then
                    t8.usable = true

                    return t8
                end
            end

            if typeof(p19) == "table" then
                for _, v15 in roles do
                    local v16 = p19[v15]

                    if not isInternalRole(v16) and t1.bestGiverForRole(v16) then
                        t8.unlockState = "unlock"
                        t8.unlockRoleKey = v15

                        return t8
                    end
                end
            end
        end
    end

    return t8
end

return t1
