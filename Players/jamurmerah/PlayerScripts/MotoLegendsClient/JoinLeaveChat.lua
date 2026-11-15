-- https://lua.expert

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer

local function general() -- line: 8
    -- upvalues: TextChatService (copy)
    local TextChannels = TextChatService:FindFirstChild("TextChannels")

    return TextChannels and TextChannels:FindFirstChild("RBXGeneral")
end

local function escape(p1) -- line: 12
    return (tostring(p1):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function who(p2) -- line: 15
    if p2.DisplayName == p2.Name then
        return "@" .. tostring(p2.Name):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    end

    return tostring(p2.DisplayName):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. " (@" .. tostring(p2.Name):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. ")"
end

local function announce(p3) -- line: 19
    -- upvalues: TextChatService (copy)
    task.spawn(function() -- line: 20
        -- upvalues: p3 (copy), TextChatService (copy)
        local TextChannels = TextChatService:FindFirstChild("TextChannels")
        local v2 = TextChannels and TextChannels:FindFirstChild("RBXGeneral")

        if not v2 then
            local v3 = TextChatService:WaitForChild("TextChannels", 10)

            v2 = v3 and v3:WaitForChild("RBXGeneral", 10)
        end

        if not v2 then
            return
        end

        local DisplaySystemMessage = v2.DisplaySystemMessage

        pcall(DisplaySystemMessage, v2, p3, "MotoLegendsJoinLeave")
    end)
end

Players.PlayerAdded:Connect(function(p4) -- line: 30
    -- upvalues: TextChatService (copy), LocalPlayer (copy)
    if p4 == LocalPlayer then
        return
    end

    local v6 = "<font color=\"#3CDC78\"><b>" .. (if p4.DisplayName == p4.Name then "@" .. tostring(p4.Name):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") else tostring(p4.DisplayName):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. " (@" .. tostring(p4.Name):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. ")") .. "</b> joined the server</font>"

    task.spawn(function() -- line: 20
        -- upvalues: v6 (copy), TextChatService (copy)
        local TextChannels = TextChatService:FindFirstChild("TextChannels")
        local v7 = TextChannels and TextChannels:FindFirstChild("RBXGeneral")

        if not v7 then
            local v8 = TextChatService:WaitForChild("TextChannels", 10)

            v7 = v8 and v8:WaitForChild("RBXGeneral", 10)
        end

        if not v7 then
            return
        end

        local DisplaySystemMessage = v7.DisplaySystemMessage

        pcall(DisplaySystemMessage, v7, v6, "MotoLegendsJoinLeave")
    end)
end)
Players.PlayerRemoving:Connect(function(p5) -- line: 34
    -- upvalues: TextChatService (copy), LocalPlayer (copy)
    if p5 == LocalPlayer then
        return
    end

    local v11 = "<font color=\"#FF6A5A\"><b>" .. (if p5.DisplayName == p5.Name then "@" .. tostring(p5.Name):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") else tostring(p5.DisplayName):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. " (@" .. tostring(p5.Name):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;") .. ")") .. "</b> left the server</font>"

    task.spawn(function() -- line: 20
        -- upvalues: v11 (copy), TextChatService (copy)
        local TextChannels = TextChatService:FindFirstChild("TextChannels")
        local v12 = TextChannels and TextChannels:FindFirstChild("RBXGeneral")

        if not v12 then
            local v13 = TextChatService:WaitForChild("TextChannels", 10)

            v12 = v13 and v13:WaitForChild("RBXGeneral", 10)
        end

        if not v12 then
            return
        end

        local DisplaySystemMessage = v12.DisplaySystemMessage

        pcall(DisplaySystemMessage, v12, v11, "MotoLegendsJoinLeave")
    end)
end)
