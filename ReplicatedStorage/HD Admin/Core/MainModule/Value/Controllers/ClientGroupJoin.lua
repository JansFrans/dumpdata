-- https://lua.expert

local Players = game:GetService("Players")
local GroupService = game:GetService("GroupService")

game:GetService("RunService")

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Remote = require(Modules.Objects.Remote)
local GroupJoinSignal = Remote.get("GroupJoinSignal")
local t1 = {}

function t1.promptAndVerifyAsync(p1) -- line: 25
    -- upvalues: Players (copy), GroupService (copy), GroupJoinSignal (copy)
    if typeof(p1) ~= "number" then
        return
    end

    local LocalPlayer = Players.LocalPlayer
    local IsInGroup = LocalPlayer.IsInGroup
    local ok, result = pcall(IsInGroup, LocalPlayer, p1)
    local v1 = ok and result == true

    local function v2() -- line: 30
        -- upvalues: p1 (copy), GroupService (copy)
        return GroupService:PromptJoinAsync(p1)
    end

    if pcall(v2) and not v1 then
        local IsInGroup = LocalPlayer.IsInGroup
        local ok, result = pcall(IsInGroup, LocalPlayer, p1)

        if ok and result == true then
            GroupJoinSignal:fireServer(p1)
        end
    end
end

function t1.promptAndVerify(p2) -- line: 40
    -- upvalues: t1 (copy)
    task.spawn(t1.promptAndVerifyAsync, p2)
end

Remote.get("PromptJoinGroup"):onClientEvent(function(p3) -- line: 46
    -- upvalues: t1 (copy)
    if typeof(p3) == "number" then
        t1.promptAndVerify(p3)
    end
end)

return t1
