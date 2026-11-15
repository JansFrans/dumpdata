-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local v1 = game:GetService("RunService"):IsServer()
local v2
local Remote = require(Modules.Objects.Remote)
local TextChatService = game:GetService("TextChatService")

return function(p1, p2) -- line: 9
    -- upvalues: v1 (copy), v2 (ref), Remote (copy), TextChatService (copy)
    if v1 then
        if typeof(p1) ~= "Instance" or not p1:IsA("Player") then
            error("First argument must be a Player when called from Server")
        end

        v2 = v2 or Remote.new("SystemMessage", "Event")
        v2:fireClient(p1, p2)
    else
        if typeof(p1) == "Instance" then
            error("First argument must be a string when called from Client")
        end

        local v3 = TextChatService:WaitForChild("TextChannels", 3)
        local RBXGeneral = v3 and v3:FindFirstChild("RBXGeneral")

        if RBXGeneral and RBXGeneral:IsA("TextChannel") then
            RBXGeneral:DisplaySystemMessage(p1)
        end
    end
end
