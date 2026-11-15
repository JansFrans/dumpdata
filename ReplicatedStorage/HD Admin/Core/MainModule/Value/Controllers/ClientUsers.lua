-- https://lua.expert

local t1 = {}
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Remote = require(Modules.Objects.Remote)

require(Modules.References.sharedTypes)

local SendMessage = Remote.get("SendMessage")

TextChatService.SendingMessage:Connect(function(p1) -- line: 15
    -- upvalues: LocalPlayer (copy), SendMessage (copy)
    local TextSource, Text = p1.TextSource, p1.Text

    if TextSource and TextSource.UserId == LocalPlayer.UserId then
        SendMessage:invokeServerAsync(Text, "Chat")
    end
end)

return t1
