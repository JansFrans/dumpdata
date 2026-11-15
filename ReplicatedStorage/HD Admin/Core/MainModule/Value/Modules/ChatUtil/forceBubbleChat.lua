-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local v1 = game:GetService("RunService"):IsServer()
local v2
local Remote = require(Modules.Objects.Remote)
local TextChatService = game:GetService("TextChatService")

return function(p1, p2, p3) -- line: 9
    -- upvalues: v1 (copy), v2 (ref), Remote (copy), TextChatService (copy)
    if v1 then
        if typeof(p1) ~= "Instance" or not p1:IsA("Player") then
            error("First argument must be Player on Server")
        elseif typeof(p2) ~= "Instance" or not p2:IsA("Model") then
            error("Second argument must be Character on Server")
        elseif typeof(p3) ~= "string" then
            error("Third argument must be String on Server")
        end

        v2 = v2 or Remote.new("ForceBubbleChat", "Event")
        v2:fireClient(p1, p2, p3)
    else
        if p1 ~= nil and (typeof(p1) ~= "Instance" or not p1:IsA("Model")) then
            error("First argument must be Character on Client")
        elseif typeof(p2) == "string" then
            if p3 ~= nil then
                error("Third argument must be Nil on Client")
            end
        else
            error("Second argument must be String on Client")
        end

        if p1 and p1:FindFirstAncestorWhichIsA("Workspace") then
            TextChatService:DisplayBubble(p1, p2)
        end
    end
end
