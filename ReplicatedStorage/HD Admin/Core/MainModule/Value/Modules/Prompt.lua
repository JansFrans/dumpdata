-- https://lua.expert

local t1 = {}
local RunService = game:GetService("RunService")

game:GetService("Players")
game:GetService("UserService")

local HttpService = game:GetService("HttpService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Remote = require(Modules.Objects.Remote)
local v1, v2
local createConnection = require(Modules.AssetUtil.createConnection)
local v3

local function getPopups() -- line: 23
    -- upvalues: v3 (ref)
    if v3 == nil then
        local MainModule = script:FindFirstAncestor("MainModule")

        v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
    end

    return v3
end

local function ensureRemotes() -- line: 31
    -- upvalues: Remote (copy), v1 (ref), v2 (ref)
    v1 = v1 or Remote.new("Prompt", "Event")
    v2 = v2 or Remote.new("PromptDismiss", "Event")
end

local function addInUserInfo(p1) -- line: 40
    -- upvalues: Modules (copy)
    if typeof(p1) ~= "table" then
        return p1
    end

    local fromUserId = p1.fromUserId

    if fromUserId and not p1.fromUserName then
        local v4, v5 = require(Modules.PlayerUtil.getUserInfoAsync)(fromUserId)

        if v4 and typeof(v5) == "table" then
            p1.fromUserName = v5.userName
            p1.fromUserImage = v5.userImage
            p1.fromUserDisplayName = v5.userDisplayName

            local userTopRole = v5.userTopRole

            if typeof(userTopRole) == "table" then
                p1.fromUserTopRole = userTopRole.name
                p1.fromUserTopRoleColor = userTopRole.color
            end

            return p1
        end
    end

    return p1
end

function t1.fireRaw(p2, p3, p4, p5, p6) -- line: 64
    -- upvalues: Remote (copy), v1 (ref), v2 (ref)
    v1 = v1 or Remote.new("Prompt", "Event")
    v2 = v2 or Remote.new("PromptDismiss", "Event")

    if v1 then
        v1:fireClient(p2, p3, p4, p5, p6)
    end
end

function t1.dismissRaw(p7, p8) -- line: 71
    -- upvalues: Remote (copy), v1 (ref), v2 (ref)
    v1 = v1 or Remote.new("Prompt", "Event")
    v2 = v2 or Remote.new("PromptDismiss", "Event")

    if v2 then
        v2:fireClient(p7, p8)
    end
end

function t1.addUserInfoAsync(p9) -- line: 78
    -- upvalues: addInUserInfo (copy)
    return (addInUserInfo(p9))
end

local function handleClient(p10, p11, p12, p13, p14) -- line: 82
    -- upvalues: RunService (copy), HttpService (copy), Remote (copy), v1 (ref), v2 (ref), createConnection (copy), addInUserInfo (copy)
    if RunService:IsClient() then
        if typeof(p12) ~= "string" then
            error("HD Admin: First argument must be a string (on the client)")
        end

        if p13 and typeof(p13) ~= "table" then
            error("HD Admin: Second argument must be a PromptOptions table or empty (on the client)")
        end

        addInUserInfo(p13)

        local v6 = p11(p12, p13)

        return createConnection(function() -- line: 94
            -- upvalues: v6 (copy)
            if v6 then
                v6:Destroy()
            end
        end)
    end

    if p12 == nil then
        return createConnection(function() -- line: 104
        end)
    end

    if typeof(p12) ~= "Instance" or not p12:IsA("Player") then
        error("HD Admin: First argument must be a Player (on the server)")
    end

    if typeof(p13) ~= "string" then
        error("HD Admin: Second argument must be a string (on the server)")
    end

    if p14 and typeof(p14) ~= "table" then
        error("HD Admin: Third argument must be a PromptOptions table or empty (on the server)")
    end

    addInUserInfo(p14)
    v1 = v1 or Remote.new("Prompt", "Event")
    v2 = v2 or Remote.new("PromptDismiss", "Event")

    local v7 = HttpService:GenerateGUID(false)

    if v1 then
        v1:fireClient(p12, p10, p13, p14, v7)
    end

    return createConnection(function() -- line: 124
        -- upvalues: p12 (copy), v7 (copy), v2 (ref)
        if v2 and typeof(p12) == "Instance" and p12.Parent then
            v2:fireClient(p12, v7)
        end
    end)
end

function t1.info(...) -- line: 133
    -- upvalues: v3 (ref), handleClient (copy)
    return handleClient("info", function(p15, p16) -- line: 135
        -- upvalues: v3 (ref)
        if v3 == nil then
            local MainModule = script:FindFirstAncestor("MainModule")

            v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
        end

        return v3.push("sidebar", {
            kind = "info",
            text = p15,
            options = p16
        })
    end, ...)
end

function t1.success(...) -- line: 140
    -- upvalues: v3 (ref), handleClient (copy)
    return handleClient("success", function(p17, p18) -- line: 142
        -- upvalues: v3 (ref)
        if v3 == nil then
            local MainModule = script:FindFirstAncestor("MainModule")

            v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
        end

        return v3.push("sidebar", {
            kind = "success",
            text = p17,
            options = p18
        })
    end, ...)
end

function t1.warn(...) -- line: 147
    -- upvalues: v3 (ref), handleClient (copy)
    return handleClient("warn", function(p19, p20) -- line: 149
        -- upvalues: v3 (ref)
        if v3 == nil then
            local MainModule = script:FindFirstAncestor("MainModule")

            v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
        end

        return v3.push("sidebar", {
            kind = "warn",
            text = p19,
            options = p20
        })
    end, ...)
end

function t1.error(...) -- line: 154
    -- upvalues: v3 (ref), handleClient (copy)
    return handleClient("error", function(p21, p22) -- line: 156
        -- upvalues: v3 (ref)
        if v3 == nil then
            local MainModule = script:FindFirstAncestor("MainModule")

            v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
        end

        return v3.push("sidebar", {
            kind = "error",
            text = p21,
            options = p22
        })
    end, ...)
end

function t1.message(...) -- line: 161
    -- upvalues: v3 (ref), handleClient (copy)
    return handleClient("message", function(p23, p24) -- line: 163
        -- upvalues: v3 (ref)
        if v3 == nil then
            local MainModule = script:FindFirstAncestor("MainModule")

            v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
        end

        return v3.push("centre", {
            kind = "message",
            text = p23,
            options = p24
        })
    end, ...)
end

function t1.hint(...) -- line: 168
    -- upvalues: v3 (ref), handleClient (copy)
    return handleClient("hint", function(p25, p26) -- line: 169
        -- upvalues: v3 (ref)
        if v3 == nil then
            local MainModule = script:FindFirstAncestor("MainModule")

            v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
        end

        return v3.push("top", {
            kind = "hint",
            text = p25,
            options = p26
        })
    end, ...)
end

function t1.privateMessage(...) -- line: 174
    -- upvalues: v3 (ref), handleClient (copy)
    return handleClient("privateMessage", function(p27, p28) -- line: 176
        -- upvalues: v3 (ref)
        if v3 == nil then
            local MainModule = script:FindFirstAncestor("MainModule")

            v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
        end

        local v8 = v3
        local v9 = p28 or {}

        if v9.duration == nil then
            v9.duration = 0
        end

        v9.keepOpenOnActivate = true
        v9.title = "Private Message"

        local v10 = if v9.fromServer then "the server" else v9.fromUserDisplayName or v9.fromUserName or "Someone"

        v9.onActivate = function() -- line: 184
            -- upvalues: p27 (copy), v8 (copy), v9 (copy), v10 (copy)
            v8.push("centre", {
                kind = "message",
                text = p27,
                options = {
                    duration = 0,
                    userOpened = true,
                    title = ("Private Message from %*"):format(v10),
                    userText = v9.userText,
                    fromServer = v9.fromServer,
                    fromUserId = v9.fromUserId,
                    fromUserName = v9.fromUserName,
                    fromUserImage = v9.fromUserImage,
                    fromUserDisplayName = v9.fromUserDisplayName,
                    fromUserTopRole = v9.fromUserTopRole,
                    fromUserTopRoleColor = v9.fromUserTopRoleColor
                }
            })
        end

        return v8.push("sidebar", {
            kind = "privateMessage",
            text = p27,
            options = v9
        })
    end, ...)
end

function t1.alert(...) -- line: 207
    -- upvalues: v3 (ref), handleClient (copy)
    return handleClient("alert", function(p29, p30) -- line: 209
        -- upvalues: v3 (ref)
        if v3 == nil then
            local MainModule = script:FindFirstAncestor("MainModule")

            v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
        end

        local v11 = v3
        local v12 = p30 or {}

        v12.duration = 0
        v12.keepOpenOnActivate = true
        v12.title = "Alert"

        local v13 = v11.value(false)

        v12.muteState = v13

        v12.onMute = function() -- line: 217
            -- upvalues: v11 (copy), v13 (copy)
            v11.toggle(v13)
        end

        v12.onActivate = function() -- line: 218
            -- upvalues: p29 (copy), v11 (copy), v12 (copy), v13 (copy)
            v11.push("centre", {
                kind = "alert",
                text = p29,
                options = {
                    title = "Alert",
                    duration = 0,
                    userOpened = true,
                    fromServer = v12.fromServer,
                    userText = v12.userText,
                    muteState = v13,
                    onMute = function() -- onMute | line: 229
                        -- upvalues: v11 (copy), v13 (copy)
                        v11.toggle(v13)
                    end,
                    fromUserId = v12.fromUserId,
                    fromUserName = v12.fromUserName,
                    fromUserImage = v12.fromUserImage,
                    fromUserDisplayName = v12.fromUserDisplayName,
                    fromUserTopRole = v12.fromUserTopRole,
                    fromUserTopRoleColor = v12.fromUserTopRoleColor
                }
            })
        end

        return v11.push("sidebar", {
            kind = "alert",
            text = p29,
            options = v12
        })
    end, ...)
end

function t1.vote(...) -- line: 243
    -- upvalues: Remote (copy), v3 (ref), handleClient (copy)
    return handleClient("vote", function(p31, p32) -- line: 244
        -- upvalues: Remote (copy), v3 (ref)
        if v3 == nil then
            local MainModule = script:FindFirstAncestor("MainModule")

            v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
        end

        local v14 = v3
        local v15 = p32 or {}
        local voteId = v15.voteId
        local v16 = if typeof(v15.fields) == "table" then v15.fields else {}
        local v17 = if typeof(v15.duration) == "number" then v15.duration else 20
        local v18 = os.clock() + v17
        local v19 = v14.value(nil)
        local v20

        local function submitVote(p33) -- line: 253
            -- upvalues: voteId (copy), v19 (copy), Remote (copy)
            v19:set(p33)

            if typeof(voteId) == "string" then
                task.spawn(function() -- line: 258
                    -- upvalues: p33 (copy), voteId (copy), Remote (copy)
                    local VoteSubmit = Remote.get("VoteSubmit")

                    if VoteSubmit then
                        VoteSubmit:fireServer(voteId, p33)
                    end
                end)
            end
        end

        v15.keepOpenOnActivate = true

        local onClosed = v15.onClosed

        v15.onClosed = function() -- line: 267
            -- upvalues: voteId (copy), v18 (copy), onClosed (copy), Remote (copy)
            if typeof(voteId) == "string" and os.clock() < v18 then
                task.spawn(function() -- line: 269
                    -- upvalues: voteId (copy), Remote (copy)
                    local VoteSubmit = Remote.get("VoteSubmit")

                    if VoteSubmit then
                        VoteSubmit:fireServer(voteId, "dismiss")
                    end
                end)
            end

            if onClosed then
                onClosed()
            end
        end

        v15.onActivate = function() -- line: 280
            -- upvalues: p31 (copy), v14 (copy), v15 (copy), v17 (copy), v18 (copy), v19 (copy), v20 (ref), submitVote (copy), v16 (copy)
            local v21 = v18 - os.clock()

            if not (v21 <= 0.5) then
                v20 = v14.push("centre", {
                    kind = "vote",
                    text = p31,
                    options = {
                        userOpened = true,
                        duration = v21,
                        progressScale = v21 / v17,
                        userText = v15.userText,
                        fromServer = v15.fromServer,
                        fromUserId = v15.fromUserId,
                        fromUserName = v15.fromUserName,
                        fromUserImage = v15.fromUserImage,
                        fromUserDisplayName = v15.fromUserDisplayName,
                        fromUserTopRole = v15.fromUserTopRole,
                        fromUserTopRoleColor = v15.fromUserTopRoleColor,
                        voteConfig = {
                            mode = "voting",
                            options = v16,
                            votedIndex = v19,
                            endTime = v18,
                            onVote = submitVote,
                            colorSeed = v15.colorSeed
                        }
                    }
                })
            end
        end

        local v22 = v14.push("sidebar", {
            kind = "vote",
            text = p31,
            options = v15
        })

        local function destroy() -- line: 312
            -- upvalues: v20 (ref), v22 (copy)
            if v20 then
                v20.Destroy()
            end

            v22.Destroy()
        end

        return {
            Destroy = destroy,
            Disconnect = destroy
        }
    end, ...)
end

function t1.voteResults(...) -- line: 325
    -- upvalues: v3 (ref), handleClient (copy)
    return handleClient("voteResults", function(p34, p35) -- line: 326
        -- upvalues: v3 (ref)
        if v3 == nil then
            local MainModule = script:FindFirstAncestor("MainModule")

            v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
        end

        local v23 = v3
        local v24 = p35 or {}
        local v25 = if typeof(v24.results) == "table" then v24.results else {}

        local function buildCentreOptions() -- line: 330
            -- upvalues: v24 (copy), v25 (copy)
            return {
                duration = 0,
                userOpened = true,
                userText = v24.userText,
                fromServer = v24.fromServer,
                fromUserId = v24.fromUserId,
                fromUserName = v24.fromUserName,
                fromUserImage = v24.fromUserImage,
                fromUserDisplayName = v24.fromUserDisplayName,
                fromUserTopRole = v24.fromUserTopRole,
                fromUserTopRoleColor = v24.fromUserTopRoleColor,
                voteConfig = {
                    mode = "results",
                    results = v25,
                    colorSeed = v24.colorSeed
                }
            }
        end

        local v26

        v24.duration = 0
        v24.keepOpenOnActivate = true

        v24.onActivate = function() -- line: 352
            -- upvalues: p34 (copy), v23 (copy), buildCentreOptions (copy), v26 (ref)
            v26 = v23.push("centre", {
                kind = "voteResults",
                text = p34,
                options = buildCentreOptions()
            })
        end

        local v27 = v23.push("sidebar", {
            kind = "voteResults",
            text = p34,
            options = v24
        })

        local function destroy() -- line: 356
            -- upvalues: v26 (ref), v27 (copy)
            if v26 then
                v26.Destroy()
            end

            v27.Destroy()
        end

        return {
            Destroy = destroy,
            Disconnect = destroy
        }
    end, ...)
end

function t1.action(...) -- line: 369
    -- upvalues: v3 (ref), handleClient (copy)
    return handleClient("action", function(p36, p37) -- line: 370
        -- upvalues: v3 (ref)
        if v3 == nil then
            local MainModule = script:FindFirstAncestor("MainModule")

            v3 = require(MainModule.Value.Controllers.UI.Util.Popups)
        end

        local v28 = v3

        p37 = p37 or {}

        local votePreview2 = if typeof(p37.votePreview) == "table" then p37.votePreview else nil

        if not votePreview2 then
            return v28.push("sidebar", {
                kind = "action",
                text = p36,
                options = p37
            })
        end

        local v30 = if typeof(votePreview2.question) == "string" then votePreview2.question else p36
        local v31 = if typeof(votePreview2.options) == "table" then votePreview2.options else {}
        local v32 = if typeof(votePreview2.duration) == "number" then votePreview2.duration else 20
        local v33 = os.clock() + v32
        local v34

        p37.clientButtons = {
            {
                label = "View",
                onActivate = function() -- openDetails | line: 382
                    -- upvalues: v28 (copy), votePreview2 (copy), v32 (copy), v33 (copy), v34 (ref), v30 (copy), v31 (copy)
                    local v35 = v33 - os.clock()

                    if v35 <= 0.5 then
                        return
                    end

                    v34 = v28.push("centre", {
                        kind = "vote",
                        text = v30,
                        options = {
                            userOpened = true,
                            duration = v35,
                            progressScale = v35 / v32,
                            userText = typeof(votePreview2.fromUserId) == "number",
                            fromUserId = votePreview2.fromUserId,
                            fromUserName = votePreview2.fromUserName,
                            fromUserImage = votePreview2.fromUserImage,
                            fromUserDisplayName = votePreview2.fromUserDisplayName,
                            fromUserTopRole = votePreview2.fromUserTopRole,
                            fromUserTopRoleColor = votePreview2.fromUserTopRoleColor,
                            voteConfig = {
                                mode = "voting",
                                preview = true,
                                options = v31,
                                endTime = v33,
                                colorSeed = votePreview2.colorSeed
                            }
                        }
                    })
                end
            }
        }

        local v36 = v28.push("sidebar", {
            kind = "action",
            text = p36,
            options = p37
        })

        local function destroy() -- line: 415
            -- upvalues: v34 (ref), v36 (copy)
            if v34 then
                v34.Destroy()
            end

            v36.Destroy()
        end

        return {
            Destroy = destroy,
            Disconnect = destroy
        }
    end, ...)
end

return t1
