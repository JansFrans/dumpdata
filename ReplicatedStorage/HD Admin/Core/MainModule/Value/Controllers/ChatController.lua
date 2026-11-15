-- https://lua.expert

local t1 = {}
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Remote = require(Modules.Objects.Remote)
local escapeRichText = require(Modules.DataUtil.escapeRichText)
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local t2 = {}
local SendMessage = Remote.get("SendMessage")

Remote.get("ForceBubbleChat"):onClientEvent(function(p1, p2) -- line: 15
    -- upvalues: Modules (copy)
    require(Modules.ChatUtil.forceBubbleChat)(p1, p2)
end)
Remote.get("SystemMessage"):onClientEvent(function(p3) -- line: 20
    -- upvalues: Modules (copy)
    require(Modules.ChatUtil.systemMessage)(p3)
end)

local function bindToEvent(p4) -- line: 27
    -- upvalues: escapeRichText (copy), TextChatService (copy), Players (copy)
    TextChatService[p4]:Connect(function(p5) -- line: 28
        -- upvalues: escapeRichText (copy), Players (copy)
        local TextSource = p5.TextSource
        local v1 = if TextSource then Players:FindFirstChild(TextSource.Name) else nil

        if not (v1 and v1:IsA("Player")) or not v1:GetAttribute("HDChatConfigEnabled") then
            return nil
        end

        local ChatTag = v1:GetAttribute("ChatTag")
        local ChatTagColor = v1:GetAttribute("ChatTagColor")
        local ChatName = v1:GetAttribute("ChatName")
        local ChatNameColor = v1:GetAttribute("ChatNameColor")

        if p5.TextSource then
            local v2 = ChatTag and ("[%*]"):format((escapeRichText(ChatTag)))

            if v2 and ChatTagColor then
                v2 = ("<font color='#%*'>%*</font>"):format(ChatTagColor:ToHex(), v2)
            end

            local v3 = ("%*:"):format(if ChatName then ("%* (@%*)"):format(escapeRichText(ChatName), v1.Name) else v1.DisplayName)

            if v3 and ChatNameColor then
                v3 = ("<font color='#%*'>%*</font>"):format(ChatNameColor:ToHex(), v3)
            end

            if v2 then
                v3 = v2 .. " " .. v3
            end

            local PrefixText = p5.PrefixText
            local v4 = string.match(PrefixText, "<.*>(.*)<.*>")
            local v5, v6
            local v7 = v3

            if ChatTag then
            elseif v4 and typeof(PrefixText) == "string" then
                local v8, v9 = string.find(string.reverse(PrefixText), string.reverse(v4), 1, true)

                if v8 and v9 then
                    local v10 = string.len(PrefixText) - v9 + 1
                    local v11 = string.len(PrefixText) - v8 + 1

                    if v10 and v11 then
                        v5 = string.sub(PrefixText, 1, v10 - 1)

                        local v13 = string.match(v5, "<.*>(.*)<.*>")

                        v6 = string.sub(PrefixText, v11 + 1)

                        if v13 then
                            v5 ..= " "
                        end

                        v7 = v5 .. v3 .. v6
                    end
                end
            end

            p5.PrefixText = v7
        end

        return p5
    end)
end

local function createChatCommand(p6) -- line: 85
    -- upvalues: Modules (copy), TextChatService (copy), LocalPlayer (copy), t2 (copy), SendMessage (copy)
    if t2[p6] then
        return
    end

    t2[p6] = true

    local TextChatCommand = Instance.new("TextChatCommand")

    TextChatCommand.AutocompleteVisible = true
    TextChatCommand.Enabled = true
    TextChatCommand.PrimaryAlias = p6
    TextChatCommand.Parent = TextChatService
    TextChatCommand.Triggered:Connect(function(p7, p8) -- line: 95
        -- upvalues: Modules (copy), LocalPlayer (copy), SendMessage (copy)
        if p7 and p7.UserId == LocalPlayer.UserId then
            require(Modules.References.sharedTypes)
            SendMessage:invokeServerAsync(p8, "ChatCommand")
        end
    end)
end

function t1.generateChatCommands(p9) -- line: 107
    -- upvalues: createChatCommand (copy)
    for _, v15 in p9 do
        createChatCommand(v15)
    end
end

function t1.decideWelcomePrompt() -- line: 113
    -- upvalues: createChatCommand (copy)
    createChatCommand("/dance")
    createChatCommand("/backflip")
    createChatCommand("/commands")
    createChatCommand("/helicopter")
    createChatCommand("/plane")
    createChatCommand("/reset")
end

TextChatService.SendingMessage:Connect(function(p10) -- line: 28
    -- upvalues: escapeRichText (copy), Players (copy)
    local TextSource = p10.TextSource
    local v16 = if TextSource then Players:FindFirstChild(TextSource.Name) else nil

    if not (v16 and v16:IsA("Player")) or not v16:GetAttribute("HDChatConfigEnabled") then
        return nil
    end

    local ChatTag = v16:GetAttribute("ChatTag")
    local ChatTagColor = v16:GetAttribute("ChatTagColor")
    local ChatName = v16:GetAttribute("ChatName")
    local ChatNameColor = v16:GetAttribute("ChatNameColor")

    if p10.TextSource then
        local v17 = ChatTag and ("[%*]"):format((escapeRichText(ChatTag)))

        if v17 and ChatTagColor then
            v17 = ("<font color='#%*'>%*</font>"):format(ChatTagColor:ToHex(), v17)
        end

        local v18 = ("%*:"):format(if ChatName then ("%* (@%*)"):format(escapeRichText(ChatName), v16.Name) else v16.DisplayName)

        if v18 and ChatNameColor then
            v18 = ("<font color='#%*'>%*</font>"):format(ChatNameColor:ToHex(), v18)
        end

        if v17 then
            v18 = v17 .. " " .. v18
        end

        local PrefixText = p10.PrefixText
        local v19 = string.match(PrefixText, "<.*>(.*)<.*>")
        local v20, v21
        local v22 = v18

        if ChatTag then
        elseif v19 and typeof(PrefixText) == "string" then
            local v23, v24 = string.find(string.reverse(PrefixText), string.reverse(v19), 1, true)

            if v23 and v24 then
                local v25 = string.len(PrefixText) - v24 + 1
                local v26 = string.len(PrefixText) - v23 + 1

                if v25 and v26 then
                    v20 = string.sub(PrefixText, 1, v25 - 1)

                    local v28 = string.match(v20, "<.*>(.*)<.*>")

                    v21 = string.sub(PrefixText, v26 + 1)

                    if v28 then
                        v20 ..= " "
                    end

                    v22 = v20 .. v18 .. v21
                end
            end
        end

        p10.PrefixText = v22
    end

    return p10
end)
TextChatService.MessageReceived:Connect(function(p11) -- line: 28
    -- upvalues: escapeRichText (copy), Players (copy)
    local TextSource = p11.TextSource
    local v30 = if TextSource then Players:FindFirstChild(TextSource.Name) else nil

    if not (v30 and v30:IsA("Player")) or not v30:GetAttribute("HDChatConfigEnabled") then
        return nil
    end

    local ChatTag = v30:GetAttribute("ChatTag")
    local ChatTagColor = v30:GetAttribute("ChatTagColor")
    local ChatName = v30:GetAttribute("ChatName")
    local ChatNameColor = v30:GetAttribute("ChatNameColor")

    if p11.TextSource then
        local v31 = ChatTag and ("[%*]"):format((escapeRichText(ChatTag)))

        if v31 and ChatTagColor then
            v31 = ("<font color='#%*'>%*</font>"):format(ChatTagColor:ToHex(), v31)
        end

        local v32 = ("%*:"):format(if ChatName then ("%* (@%*)"):format(escapeRichText(ChatName), v30.Name) else v30.DisplayName)

        if v32 and ChatNameColor then
            v32 = ("<font color='#%*'>%*</font>"):format(ChatNameColor:ToHex(), v32)
        end

        if v31 then
            v32 = v31 .. " " .. v32
        end

        local PrefixText = p11.PrefixText
        local v33 = string.match(PrefixText, "<.*>(.*)<.*>")
        local v34, v35
        local v36 = v32

        if ChatTag then
        elseif v33 and typeof(PrefixText) == "string" then
            local v37, v38 = string.find(string.reverse(PrefixText), string.reverse(v33), 1, true)

            if v37 and v38 then
                local v39 = string.len(PrefixText) - v38 + 1
                local v40 = string.len(PrefixText) - v37 + 1

                if v39 and v40 then
                    v34 = string.sub(PrefixText, 1, v39 - 1)

                    local v42 = string.match(v34, "<.*>(.*)<.*>")

                    v35 = string.sub(PrefixText, v40 + 1)

                    if v42 then
                        v34 ..= " "
                    end

                    v36 = v34 .. v32 .. v35
                end
            end
        end

        p11.PrefixText = v36
    end

    return p11
end)
task.defer(t1.decideWelcomePrompt)
task.defer(function() -- line: 131
    -- upvalues: TextChatService (copy), LocalPlayer (copy)
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end

    task.wait(1)

    local TextChatCommand = Instance.new("TextChatCommand")

    TextChatCommand.PrimaryAlias = "/zzz"
    TextChatCommand.Enabled = true
    TextChatCommand.AutocompleteVisible = true
    TextChatCommand.Name = "FixChat"
    TextChatCommand.Parent = TextChatService
    task.delay(0.25, function() -- line: 140
        -- upvalues: TextChatCommand (copy)
        TextChatCommand.Enabled = false
        TextChatCommand.AutocompleteVisible = false
        task.wait(0.25)
        TextChatCommand:Destroy()
    end)
end)

return t1
