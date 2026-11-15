-- https://lua.expert

local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Remote = require(Modules.Objects.Remote)
local Prompt = require(Modules.Prompt)
local JoinHDGroup = Remote.get("JoinHDGroup")

JoinHDGroup:onClientEvent(function(p1, p2) -- line: 12
    -- upvalues: Prompt (copy), JoinHDGroup (copy)
    local GroupService = game:GetService("GroupService")

    Prompt.info(p2)

    local function v1() -- line: 15
        -- upvalues: p1 (copy), GroupService (copy)
        return GroupService:PromptJoinAsync(p1)
    end

    local ok, result = pcall(v1)

    if ok and result ~= Enum.GroupMembershipStatus.None then
        JoinHDGroup:fireServer("Successfully joined!")
        Prompt.success(p2)
    end
end)

return t1
