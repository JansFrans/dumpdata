-- https://lua.expert

local Players = game:GetService("Players")
local UserService = game:GetService("UserService")
local RunService = game:GetService("RunService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local t1 = {}

local function getTopRole(p1) -- line: 31
    -- upvalues: Players (copy), RunService (copy), Modules (copy)
    if not RunService:IsServer() then
        return nil
    end

    local Roles = require(Modules.Parent.Services.Roles)
    local v1

    if Players:GetPlayerByUserId(p1) then
        local v2 = require(Modules.Objects.User).getUserByUserId(p1, true)

        if v2 then
            v1 = Roles.getTopRole(v2)
        end
    else
        local v3 = require(Modules.References.remoteCallerRoles).getKey(p1)

        if v3 then
            v1 = Roles.getRole(v3)
        end
    end

    return if typeof(v1) == "table" then {
        key = v1.key,
        name = v1.name,
        color = v1.color
    } else nil
end

local function getUserInfoAsync(p2) -- line: 52
    -- upvalues: Players (copy), UserService (copy), getTopRole (copy)
    if typeof(p2) ~= "number" then
        return true, {
            userName = "System",
            userImage = "",
            userDisplayName = "System",
            userTopRole = nil,
            userId = p2
        }
    end

    local v4 = ("https://www.roblox.com/headshot-thumbnail/image?userId=%*&width=420&height=420&format=png"):format(p2)
    local PlayerByUserId = Players:GetPlayerByUserId(p2)

    if PlayerByUserId then
        return true, {
            userId = p2,
            userName = PlayerByUserId.Name,
            userImage = v4,
            userDisplayName = PlayerByUserId.DisplayName,
            userTopRole = getTopRole(p2)
        }
    end

    local function v5() -- line: 73
        -- upvalues: p2 (copy), UserService (copy)
        return UserService:GetUserInfosByUserIdsAsync({ p2 })
    end

    local ok, result = pcall(v5)

    if not ok or not result or #result <= 0 then
        return false, (tostring(result))
    end

    local v6 = result[1]

    if typeof(v6) == "table" then
        return true, {
            userTopRole = nil,
            userId = v6.Id,
            userName = v6.Username,
            userImage = v4,
            userDisplayName = v6.DisplayName
        }
    end

    return false, "Failed to find info"
end

return function(p3) -- line: 92
    -- upvalues: t1 (copy), getTopRole (copy), getUserInfoAsync (copy)
    local v7 = t1[p3]

    if v7 then
        if not v7.userTopRole and typeof(p3) == "number" then
            v7.userTopRole = getTopRole(p3)
        end

        return true, v7
    end

    local v8, v9 = getUserInfoAsync(p3)

    if not v8 then
        return false, v9
    end

    t1[p3] = v9
    task.delay(300, function() -- line: 105
        -- upvalues: p3 (copy), t1 (copy)
        t1[p3] = nil
    end)

    return true, v9
end
