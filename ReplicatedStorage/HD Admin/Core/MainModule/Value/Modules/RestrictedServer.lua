-- https://lua.expert

local t1 = {}
local v1 = false
local v2 = "This is restricted in this game"
local t2 = {}
local t3 = {}
local v3 = {}
local v4 = {}
local t4 = {}
local n1 = -1
local Parent = script.Parent
local t5 = {
    perm = true,
    permloop = true,
    permdelay = true,
    permjoin = true,
    permspawn = true,
    permschedule = true,
    unperm = true,
    global = true,
    join = true
}

local function matchRoleKeys(p1, p2) -- line: 50
    local t6 = {}
    local n2 = 0

    for _, v5 in p1 do
        local v6 = v5:lower()
        local v7 = false

        for _, v8 in p2 do
            local v9 = if typeof(v8.key) == "string" then v8.key:lower() else nil
            local v10 = if typeof(v8.name) == "string" then v8.name:lower() else nil

            if v9 == v6 or v10 == v6 then
                v7 = true
                t6[v8.key] = true
            end
        end

        if v7 then
            n2 += 1
        end
    end

    return t6, n2
end

local function resolveRoleKeys() -- line: 73
    -- upvalues: t2 (ref), t3 (ref), v3 (ref), v4 (ref), n1 (ref), Parent (copy), matchRoleKeys (copy)
    if #t2 == 0 and #t3 == 0 then
        return
    end

    local v11 = require(Parent.Parent.Services.Roles).getRoles()
    local v12, v13 = matchRoleKeys(t2, v11)
    local v14, v15 = matchRoleKeys(t3, v11)
    local v16 = v13 + v15

    if v16 == n1 then
        return
    end

    n1 = v16
    v3 = v12
    v4 = v14
end

local function toUser(p3) -- line: 89
    -- upvalues: Parent (copy)
    if typeof(p3) == "table" then
        return p3
    end

    local User = require(Parent.Objects.User)

    if typeof(p3) == "number" then
        return User.getUserByUserId(p3)
    end

    if typeof(p3) == "Instance" then
        return User.getUser(p3)
    end

    return nil
end

function t1.isRestricted() -- line: 105
    -- upvalues: v1 (ref)
    return v1
end

function t1.isBypassed(p4) -- line: 109
    -- upvalues: v1 (ref), t3 (ref), v4 (ref), Parent (copy), resolveRoleKeys (copy), toUser (copy)
    if not v1 or #t3 == 0 then
        return false
    end

    local v17 = toUser(p4)

    if v17 then
        resolveRoleKeys()

        for _, v18 in require(Parent.Parent.Services.Roles).getRealRolesForUser(v17) do
            local v19 = typeof(v18.key) == "string"

            v19 = v19 and v4[v18.key]

            if v19 then
                return true
            end
        end
    end

    return false
end

function t1.isRestrictedFor(p5) -- line: 128
    -- upvalues: t1 (copy), v1 (ref)
    return v1 and not t1.isBypassed(p5)
end

function t1.getWarning() -- line: 132
    -- upvalues: v2 (ref)
    return v2
end

function t1.isCommandRestricted(p6) -- line: 136
    -- upvalues: v1 (ref), t2 (ref), v3 (ref), t4 (ref), resolveRoleKeys (copy)
    if not v1 or typeof(p6) ~= "table" then
        return false
    end

    local v21 = if typeof(p6.key) == "string" then p6.key:lower() else nil
    local v22 = if typeof(p6.name) == "string" then p6.name:lower() else nil

    if v21 and t4[v21] or v22 and t4[v22] then
        return true
    end

    if #t2 == 0 then
        return false
    end

    resolveRoleKeys()

    local primaryRole = p6.primaryRole

    if typeof(primaryRole) == "string" then
        return v3[primaryRole] == true
    end

    return false
end

function t1.isModifierRestricted(p7) -- line: 153
    -- upvalues: v1 (ref), t5 (copy)
    return v1 and t5[p7:lower()] == true
end

function t1.restrict(p8) -- line: 157
    -- upvalues: v1 (ref), v2 (ref), t2 (ref), t3 (ref), t4 (ref), n1 (ref)
    p8 = p8 or {}
    v1 = true

    if typeof(p8.warning) == "string" and p8.warning ~= "" then
        v2 = p8.warning
    end

    for _, v24 in p8.commandsInRoles or {} do
        if typeof(v24) == "string" then
            table.insert(t2, v24)
        end
    end

    for _, v25 in p8.bypassRoles or {} do
        if typeof(v25) == "string" then
            table.insert(t3, v25)
        end
    end

    for _, v26 in p8.commands or {} do
        if typeof(v26) == "string" then
            t4[v26:lower()] = true
        end
    end

    n1 = -1
end

function t1._resetForTesting() -- line: 181
    -- upvalues: v1 (ref), t2 (ref), t3 (ref), v3 (ref), v4 (ref), t4 (ref), n1 (ref)
    v1 = false
    t2 = {}
    t3 = {}
    v3 = {}
    v4 = {}
    t4 = {}
    n1 = -1
end

return t1
