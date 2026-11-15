-- https://lua.expert

local RunService = game:GetService("RunService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local isBlockingCommands = require(Modules.RoleUtil.isBlockingCommands)
local t1 = {}

local function describeCommand(p1, p2) -- line: 11
    -- upvalues: Modules (copy)
    if typeof(p2) ~= "string" then
        return nil
    end

    local v1 = require(Modules.Parent.Services.Commands).getCommand(p2)

    if v1 and typeof(v1.name) == "string" then
        local Config = require(Modules.Parent.Services.Config)
        local prefix = v1.prefix or Config.getSetting("Prefix", p1) or ""

        return (("%*%*"):format(prefix, (v1.name:lower())))
    end

    return nil
end

local function notify(p3, p4, p5, p6) -- line: 25
    -- upvalues: Modules (copy), t1 (copy), describeCommand (copy)
    local Players = game:GetService("Players")
    local userId = p3.userId
    local PlayerByUserId = Players:GetPlayerByUserId(userId)

    if not PlayerByUserId then
        return
    end

    local v2 = ("%* %*"):format(p6 or "", (table.concat(p4, ", ")))
    local v3 = t1[userId]

    if v3 and v3.names == v2 and os.clock() - v3.at < 2 then
        return
    end

    t1[userId] = {
        at = os.clock(),
        names = v2
    }

    local Prompt = require(Modules.Prompt)
    local v4 = if p5 then "Block Prompts" else "Block Commands"
    local v5 = describeCommand(p3, p6)
    local v6 = if v5 then ("<b>%*</b> "):format(v5) else ""

    Prompt.warn(PlayerByUserId, (("Unable to run %*on %* as they have '%*' enabled"):format(v6, table.concat(p4, ", "), v4)))
end

return function(p7, p8, p9, p10, p11) -- line: 46
    -- upvalues: RunService (copy), Modules (copy), isBlockingCommands (copy), notify (copy)
    local t2 = {}
    local v7 = p9 == true

    if not RunService:IsServer() or typeof(p8) ~= "number" or #p7 == 0 then
        return p7, t2
    end

    local User = require(Modules.Objects.User)
    local Roles = require(Modules.Parent.Services.Roles)
    local v8 = User.getUserByUserId(p8)

    if not v8 or v8.isServerUser then
        return p7, t2
    end

    local v9 = Roles.getTopRank(v8)
    local t3 = {}
    local t4 = {}

    for _, v10 in p7 do
        if v10.UserId == p8 then
            table.insert(t3, v10)
        else
            local v11 = User.getUser(v10)

            if v11 and isBlockingCommands(v11, v7) and v9 <= Roles.getTopRank(v11) then
                table.insert(t2, v10)
                table.insert(t4, "@" .. v10.Name)
            else
                table.insert(t3, v10)
            end
        end
    end

    if #t4 > 0 and not p11 then
        notify(v8, t4, v7, p10)
    end

    return t3, t2
end
