-- https://lua.expert

local t1 = {
    Message = "You can only send your next message in %s due to Roblox's age safety policies.",
    SurfaceText = "You can only change this again in %s due to Roblox's age safety policies.",
    ChatText = "You can only change this again in %s due to Roblox's age safety policies.",
    Reason = "You can only add your next reason in %s due to Roblox's age safety policies.",
    RoleName = "You can only rename a role again in %s due to Roblox's age safety policies."
}
local t2 = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local ParserSettings = require(Modules.Parser.ParserSettings)
local v1 = RunService:IsServer()
local v2 = RunService:IsStudio()
local t3 = {}
local t4 = {}
local t5 = {}
local n1 = 0

local function formatSeconds(p1) -- line: 69
    local v4 = math.max(1, (math.ceil(p1)))

    if v4 == 1 then
        return "1 second"
    end

    return (("%* seconds"):format(v4))
end

local function describePlayers(p2) -- line: 76
    -- upvalues: Players (copy)
    local t6 = {}

    for _, v5 in p2 do
        local PlayerByUserId = Players:GetPlayerByUserId(v5)

        table.insert(t6, if PlayerByUserId then "@" .. PlayerByUserId.Name else tostring(v5))
    end

    return table.concat(t6, ", ")
end

local function isBlank(p3) -- line: 85
    -- upvalues: ParserSettings (copy)
    if typeof(p3) == "string" and p3:match("^%s*$") == nil then
        return p3 == ParserSettings.EmptyUnparsedValue
    end

    return true
end

local function issueBatch() -- line: 90
    -- upvalues: Modules (copy), t5 (copy), n1 (ref)
    n1 += 1

    if n1 >= 100 then
        n1 = 0

        local elapsed = os.clock()

        for v7, v8 in t5 do
            if next(v8.paid) == nil and elapsed - v8.issuedAt > 600 then
                t5[v7] = nil
            end
        end
    end

    local v9 = require(Modules.DataUtil.generateUID)(10)

    t5[v9] = {
        issuedAt = os.clock(),
        paid = {}
    }

    return v9
end

local function makesNoTasks(p4, p5, p6) -- line: 108
    -- upvalues: Modules (copy)
    local v10 = require(Modules.Parser.Args).get(p4.args[1])

    if not v10 or v10.playerArg ~= true or v10.runForEachPlayer ~= true then
        return false
    end

    local v11 = require(Modules.CommandUtil.getEffectiveModifiers)(p4, p5.modifiers or {})

    if v11.perm ~= nil or v11.join ~= nil then
        return false
    end

    local isPromptCommand = require(Modules.CommandUtil.isPromptCommand)
    local v12 = v10:parse(p5.qualifiers or {}, p6, {
        silent = true,
        prompt = isPromptCommand(p4),
        commandKey = p4.key
    })

    if typeof(v12) == "table" then
        return next(v12) == nil
    end

    return false
end

local function getTextUsage(p7, p8) -- line: 124
    -- upvalues: Modules (copy), ParserSettings (copy)
    local Args = require(Modules.Parser.Args)
    local v13 = if typeof(p7.args) == "table" then p7.args else {}
    local v14 = Args.get(v13[1])
    local v15 = v14 ~= nil and v14.playerArg == true
    local v16 = require(Modules.CommandUtil.isPromptCommand)(p7)
    local t7

    for v17, v18 in v13 do
        local v19 = Args.get(v18)

        if v19 then
            local inputObject = v19.inputObject

            if typeof(inputObject) == "table" and inputObject.filterText == true then
                local v20 = p8[if v15 then v17 - 1 else v17]

                if typeof(v20) == "string" and v20:match("^%s*$") == nil and v20 ~= ParserSettings.EmptyUnparsedValue or v16 then
                    if not t7 then
                        t7 = {
                            command = p7,
                            args = p8
                        }
                        t7.surfaces = {}
                    end

                    local v22 = v19.textSurface or "Message"

                    if v22 ~= "None" then
                        t7.surfaces[v22] = true
                    end
                end
            end
        end
    end

    return t7
end

local function getTargetUserIds(p9, p10, p11) -- line: 157
    -- upvalues: Modules (copy)
    local v23 = require(Modules.Parser.Args).get(p9.args[1])

    if not v23 or v23.playerArg ~= true then
        return {}
    end

    local v24 = v23:parse(p10, p11, {
        silent = true,
        prompt = require(Modules.CommandUtil.isPromptCommand)(p9),
        commandKey = p9.key
    })

    if typeof(v24) == "Instance" then
        v24 = { v24 }
    end

    local t8 = {}

    if typeof(v24) == "table" then
        for _, v25 in v24 do
            if typeof(v25) == "Instance" and v25:IsA("Player") then
                table.insert(t8, v25.UserId)
            end
        end
    end

    return t8
end

function t2.cooldownNotice(p12, p13) -- line: 181
    -- upvalues: t1 (copy)
    local format = string.format
    local v26 = t1[p12] or "You can only send your next message in %s due to Roblox's age safety policies."
    local v28 = math.max(1, (math.ceil(p13)))

    return format(v26, if v28 == 1 then "1 second" else ("%* seconds"):format(v28))
end

function t2.secondsLeft(p14, p15, p16) -- line: 185
    -- upvalues: t3 (copy)
    local v29 = t3[p14]
    local v30 = if v29 then v29[p15] else nil

    if v30 then
        local v31 = v30.untilClock - os.clock()

        if not (v31 <= 0) and (p16 == nil or v30.batchId ~= p16) then
            return v31
        end
    end

    return 0
end

function t2.tryConsume(p17, p18, p19) -- line: 203
    -- upvalues: t2 (copy), t3 (copy)
    local v32 = t2.secondsLeft(p17, p18, p19)

    if v32 > 0 then
        return v32
    end

    local v33 = t3[p17]

    if not v33 then
        v33 = {}
        t3[p17] = v33
    end

    local v34 = v33[p18]

    if v34 and v34.batchId ~= nil and v34.batchId == p19 and v34.untilClock > os.clock() then
        return 0
    end

    v33[p18] = {
        untilClock = os.clock() + 60,
        batchId = p19
    }

    return 0
end

function t2.canUserChatAsync(p20) -- line: 222
    -- upvalues: TextChatService (copy), v2 (copy), t4 (copy)
    if v2 then
        return true
    end

    local v35 = t4[p20]

    if v35 and os.clock() - v35.checkedAt < 300 then
        return v35.canChat
    end

    local CanUserChatAsync = TextChatService.CanUserChatAsync
    local ok, result = pcall(CanUserChatAsync, TextChatService, p20)

    if not ok or typeof(result) ~= "boolean" then
        return nil
    end

    t4[p20] = {
        canChat = result,
        checkedAt = os.clock()
    }

    return result
end

function t2.canDirectChatAsync(p21, p22) -- line: 238
    -- upvalues: TextChatService (copy), v2 (copy)
    if p21 == p22 or v2 then
        return true
    end

    local CanUsersDirectChatAsync = TextChatService.CanUsersDirectChatAsync
    local t9 = {
        p22
    }
    local ok, result = pcall(CanUsersDirectChatAsync, TextChatService, p21, t9)

    return if ok and typeof(result) == "table" then table.find(result, p22) ~= nil else nil
end

function t2.getEligibilityRefusal(p23) -- line: 249
    -- upvalues: t2 (copy)
    local v36 = t2.canUserChatAsync(p23)

    if v36 == nil then
        return "HD Admin couldn't check your chat settings with Roblox just now, so nothing was sent. Try again in a moment."
    end

    return if not v36 then "HD Admin can't send text for you because chat is turned off on your Roblox account or you haven't completed an age check. Turn chat on in your Roblox settings, then try again." else nil
end

function t2.gateStatementAsync(p24, p25, p26) -- line: 259
    -- upvalues: t2 (copy), Players (copy), Modules (copy), t5 (copy), describePlayers (copy), issueBatch (copy), makesNoTasks (copy), getTextUsage (copy), getTargetUserIds (copy)
    if p24.isServerUser then
        return nil
    end

    local userId = p24.userId

    if typeof(userId) == "number" then
        local v37 = p25.modifiers or {}

        if v37.undo ~= nil or v37.unperm ~= nil then
            return nil
        end

        local Commands = require(Modules.Parent.Services.Commands)
        local t10 = {}
        local t11 = {}

        for v38, v39 in p25.commands or {} do
            local v40 = Commands.getCommand(v38)

            if v40 and typeof(v40.args) == "table" and typeof(v39) == "table" then
                local v41 = getTextUsage(v40, v39)

                if v41 and not makesNoTasks(v40, p25, userId) then
                    for v42 in v41.surfaces do
                        local v43 = t11[v42]

                        if v43 ~= nil then
                            return (("Send '%*' and '%*' one at a time. Each kind of shown text is limited to once a minute due to Roblox's age safety policies."):format(v43, v40.name))
                        end

                        t11[v42] = v40.name
                    end

                    if v41.surfaces.Message and (v37.loop ~= nil or v37.permloop ~= nil) then
                        return (("'Loop' can't be used with '%*'. Messages are limited to one a minute due to Roblox's age safety policies."):format(v40.name))
                    end

                    table.insert(t10, v41)
                end
            end
        end

        if #t10 ~= 0 then
            local v44 = next(t11) == nil
            local v45 = if not v44 then t2.getEligibilityRefusal(userId) else nil

            if not v44 and v45 then
                return v45
            end

            for v46 in t11 do
                local v47 = t2.secondsLeft(userId, v46)

                if v47 > 0 then
                    return t2.cooldownNotice(v46, v47)
                end
            end

            local t12 = {}
            local t13 = {}

            for _, v48 in t10 do
                if v48.command.requiresDirectChat == true then
                    local v49 = getTargetUserIds(v48.command, p25.qualifiers, userId)

                    if #v49 ~= 0 then
                        local v50 = false

                        for _, v51 in v49 do
                            local v52 = t2.canDirectChatAsync(userId, v51)

                            if v52 then
                                v50 = true
                            elseif v52 ~= nil then
                                table.insert(t12, v51)
                            else
                                table.insert(t13, v51)
                            end
                        end

                        if not v50 then
                            return "Nobody you selected can receive private messages because of their Roblox chat settings."
                        end
                    end
                end
            end

            if not p26 then
                local t14

                if #t12 > 0 or #t13 > 0 then
                    local Prompt = require(Modules.Prompt)
                    local PlayerByUserId = Players:GetPlayerByUserId(userId)

                    t14 = {}

                    if #t12 > 0 then
                        for _, v53 in t12 do
                            t14[v53] = true
                        end

                        if PlayerByUserId then
                            Prompt.warn(PlayerByUserId, (("%* can't receive messages from you because of their Roblox chat settings."):format((describePlayers(t12)))))
                        end
                    end

                    if #t13 > 0 then
                        for _, v54 in t13 do
                            t14[v54] = true
                        end

                        if PlayerByUserId then
                            Prompt.warn(PlayerByUserId, (("HD Admin couldn't check chat settings for %* with Roblox just now, so nothing was sent to them. Try again in a moment."):format((describePlayers(t13)))))
                        end
                    end
                end

                local prefilterTextArgs = require(Modules.CommandUtil.prefilterTextArgs)
                local v55 = if typeof(p25.argOverrides) == "table" then p25.argOverrides else {}

                for _, v56 in t10 do
                    local command = v56.command
                    local v57, v58 = prefilterTextArgs(command, v56.args, userId)

                    if v58 then
                        return (("Roblox's filter blocked the text for '%*', so nothing was sent."):format(command.name))
                    end

                    if v57 then
                        v55[command.key] = v57
                    end
                end

                if next(v55) then
                    p25.argOverrides = v55
                end

                local v59 = issueBatch()

                for v60 in t11 do
                    local v61 = t2.tryConsume(userId, v60, v59)

                    if v61 > 0 then
                        return t2.cooldownNotice(v60, v61)
                    end
                end

                p25.textBatchId = v59

                if t14 then
                    t5[v59].directChatAnnounced = t14
                end
            end
        end
    end

    return nil
end

function t2.wasDirectChatAnnounced(p27, p28) -- line: 399
    -- upvalues: t5 (copy)
    local v62, v63

    if typeof(p27) == "table" then
        if typeof(p27.extra) == "table" then
            local textBatchId = p27.extra.textBatchId

            if typeof(textBatchId) == "string" then
                v62 = t5[textBatchId]
            end

            v63 = false
        else
            v63 = true
        end
    else
        v63 = true
    end

    if v63 then
        return false
    end

    local directChatAnnounced = if v62 then v62.directChatAnnounced else nil

    return directChatAnnounced ~= nil and directChatAnnounced[p28] == true
end

function t2.checkTextLimit(p29, p30) -- line: 409
    -- upvalues: t2 (copy), Players (copy), Modules (copy), v1 (copy), t5 (copy)
    if not v1 or typeof(p29) ~= "table" then
        return true, nil
    end

    local callerUserId = p29.callerUserId

    if typeof(callerUserId) == "number" then
        local extra = p29.extra

        if typeof(extra) == "table" then
            if extra.textCharged == nil then
                extra.textCharged = {}
            end

            if extra.textCharged[p30] or extra.fromOtherServer then
                return true, nil
            end

            local textBatchId = extra.textBatchId
            local v64 = if typeof(textBatchId) == "string" then t5[textBatchId] else nil

            if not (v64 and v64.paid[p30]) then
                local isReplay = if not v64 then p29.isReplay else nil

                if v64 or not isReplay then
                    local PlayerByUserId = Players:GetPlayerByUserId(callerUserId)

                    if PlayerByUserId then
                        local Prompt = require(Modules.Prompt)
                        local v65 = t2.getEligibilityRefusal(callerUserId)

                        if v65 then
                            Prompt.warn(PlayerByUserId, v65)

                            return false, nil
                        end

                        local v66 = t2.tryConsume(callerUserId, p30, textBatchId)

                        if v66 > 0 then
                            Prompt.warn(PlayerByUserId, t2.cooldownNotice(p30, v66))

                            return false, (math.ceil(v66))
                        end

                        if v64 then
                            v64.paid[p30] = true
                        end

                        extra.textCharged[p30] = true
                    end

                    return true, nil
                end
            end

            extra.textCharged[p30] = true
        end
    end

    return true, nil
end

function t2.refundTextLimit(p31, p32) -- line: 458
    -- upvalues: v1 (copy), t3 (copy), t5 (copy)
    if not v1 or typeof(p31) ~= "table" then
        return false
    end

    local callerUserId, extra = p31.callerUserId, p31.extra

    if typeof(callerUserId) ~= "number" or typeof(extra) ~= "table" then
        return false
    end

    local textBatchId = extra.textBatchId

    if typeof(textBatchId) ~= "string" then
        return false
    end

    local v67 = t3[callerUserId]
    local v68 = if v67 then v67[p32] else nil

    if not v68 or v68.batchId ~= textBatchId then
        return false
    end

    v67[p32] = nil

    local v69 = t5[textBatchId]

    if v69 then
        v69.paid[p32] = nil
    end

    if typeof(extra.textCharged) == "table" then
        extra.textCharged[p32] = nil
    end

    return true
end

if v1 then
    Players.PlayerRemoving:Connect(function(p33) -- line: 490
        -- upvalues: Players (copy), t3 (copy), t4 (copy)
        local UserId = p33.UserId

        t4[UserId] = nil
        task.delay(60, function() -- line: 494
            -- upvalues: UserId (copy), Players (copy), t3 (copy)
            if not Players:GetPlayerByUserId(UserId) then
                t3[UserId] = nil
            end
        end)
    end)
end

return t2
