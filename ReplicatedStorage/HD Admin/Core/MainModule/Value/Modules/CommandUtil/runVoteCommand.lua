-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules

require(Modules.Objects.Task)

local Prompt = require(Modules.Prompt)
local Vote = require(Modules.Prompt.Vote)
local Players = game:GetService("Players")
local _task = task

local function buildStatement(p1, p2) -- line: 21
    return {
        isValid = true,
        isConverted = true,
        commands = {
            [p1.commandKey] = p1.args
        },
        modifiers = p2,
        qualifiers = p1.qualifiers or {}
    }
end

return function(p3) -- line: 33
    -- upvalues: Modules (copy), Prompt (copy), Vote (copy), Players (copy), _task (copy), buildStatement (copy)
    local getAllowedTargets = require(Modules.PlayerUtil.getAllowedTargets)
    local v1 = p3:getArg("OptionalPlayers", true) or getAllowedTargets(p3)
    local Text = p3:getArg("Text")
    local Fields = p3:getArg("Fields")
    local caller = p3.caller

    if typeof(Text) == "string" and Text:gsub(" ", "") ~= "" then
        if typeof(Fields) ~= "table" or #Fields < 1 then
            if caller then
                Prompt.error(caller, "Votes need at least 1 answer, like ;vote Best colour? || Red | Blue")
            end
        else
            local v2 = math.floor(tonumber(p3:getArg("OptionalVoteTime")) or 0)

            if v2 < 1 then
                v2 = 120
            end

            local v5 = math.clamp(v2, 1, 604800)
            local v6 = if typeof(p3.modifiers) == "table" then p3.modifiers else {}
            local v7 = p3.commandKey == "globalvote"
            local globalUID2 = if typeof(v6.globalUID) == "string" then v6.globalUID else nil
            local v8
            local globalUID3 = globalUID2

            if not v7 or not globalUID2 then
                if v7 then
                    local Modifiers = require(Modules.Parser.Modifiers)
                    local v9 = buildStatement(p3, {
                        global = {}
                    })
                    local t2 = {}
                    local Text2 = p3:getArgIndex("Text")
                    local Fields2 = p3:getArgIndex("Fields")

                    if Text2 then
                        t2[tostring(Text2)] = Text
                    end

                    if Fields2 then
                        t2[tostring(Fields2)] = Fields
                    end

                    v9.argOverrides = {
                        [p3.commandKey] = t2
                    }
                    Modifiers.broadcastGlobalStatement(p3.callerUserId, v9)
                    globalUID3 = v9.modifiers.globalUID

                    if typeof(globalUID3) ~= "string" then
                        globalUID3 = nil
                    end
                end

                v8 = true
            else
                v8 = v6.globalOrigin == true
            end

            local callerUserId2 = if typeof(p3.callerUserId) == "number" then p3.callerUserId else nil
            local v10 = p3:getArg("OptionalShareResults") == true
            local v11 = globalUID3 or require(Modules.DataUtil.generateUID)(10)
            local v12 = false
            local v13 = false

            if v7 and v8 and globalUID3 then
                p3:onEnded(function() -- line: 86
                    -- upvalues: p3 (copy), v13 (ref), Modules (copy), buildStatement (copy)
                    if not v13 then
                        require(Modules.Parent.Services.Tasks.GlobalStatements).broadcast(p3.callerUserId, (buildStatement(p3, {
                            undo = {}
                        })))
                    end
                end)
            end

            if caller then
                p3:bindPrompt({
                    text = "",
                    deactivate = false,
                    title = ("Poll Details: \"%*\""):format(Text),
                    audience = caller,
                    duration = v5,
                    votePreview = {
                        question = Text,
                        options = Fields,
                        duration = v5,
                        fromUserId = callerUserId2,
                        colorSeed = v11
                    },
                    buttons = {
                        {
                            label = "End",
                            style = "Neutral",
                            confirm = true,
                            onActivate = function() -- onActivate | line: 107
                                -- upvalues: p3 (copy), v12 (ref), _task (copy)
                                v12 = true

                                local n1 = 0

                                while p3.isActive and n1 < 10 do
                                    _task.wait(0.2)
                                    n1 += 0.2
                                end
                            end
                        }
                    }
                })
            end

            local v14 = Vote.open(p3, {
                question = Text,
                options = Fields,
                duration = v5,
                targets = v1,
                fromUserId = callerUserId2,
                colorSeed = v11
            })
            local deadline = v14.deadline

            while p3.isActive and os.clock() < deadline do
                if v12 then
                    break
                end

                p3.wait(0.5)

                if Vote.allResponded(v14) then
                    break
                end
            end

            Vote.finish(v14)

            if p3.isActive then
                v13 = true

                local v15, v16 = Vote.tally(v14)

                if globalUID3 then
                    if v8 then
                        local v17 = deadline + Vote.GLOBAL_GRACE

                        while p3.isActive and os.clock() < v17 do
                            if v12 then
                                break
                            end

                            p3.wait(1)
                        end

                        if not p3.isActive then
                            return
                        end

                        local v18, v19 = Vote.collectTallies(globalUID3, #Fields)

                        for i = 1, #Fields do
                            v18[i] += v15[i] or 0
                        end

                        local v20 = v19 + v16
                        local t5 = {
                            question = Text,
                            results = Vote.buildResults(Fields, v18, v20),
                            fromUserId = callerUserId2,
                            showToEveryone = v10,
                            colorSeed = v11
                        }

                        Vote.publishResults(globalUID3, t5)

                        if caller and caller.Parent then
                            Vote.displayResults(caller, t5)
                        end

                        if v10 then
                            for _, player in Players:GetPlayers() do
                                if player ~= caller then
                                    Vote.displayResults(player, t5)
                                end
                            end
                        end
                    else
                        Vote.publishTally(globalUID3, v15, v16)

                        while p3.isActive and os.clock() < deadline do
                            p3.wait(1)
                        end

                        local v21 = deadline + Vote.GLOBAL_GRACE + Vote.RESULTS_POLL_TIMEOUT
                        local v22

                        while true do
                            if p3.isActive and os.clock() < v21 then
                                p3.wait(Vote.RESULTS_POLL_INTERVAL)
                                v22 = Vote.fetchResults(globalUID3)

                                if v22 == nil then
                                    continue
                                end
                            end

                            break
                        end

                        if not p3.isActive or typeof(v22) ~= "table" or v22.showToEveryone ~= true then
                            return
                        end

                        if not (typeof(v22.results) == "table" and typeof(v22.question) == "string") then
                            return
                        end

                        for _, player in Players:GetPlayers() do
                            Vote.displayResults(player, v22)
                        end
                    end
                else
                    local t6 = {
                        question = Text,
                        results = Vote.buildResults(Fields, v15, v16),
                        fromUserId = callerUserId2,
                        colorSeed = v11
                    }

                    if caller and caller.Parent then
                        Vote.displayResults(caller, t6)
                    end

                    if v10 then
                        for _, v25 in v1 do
                            if v25.Parent and v25 ~= caller then
                                Vote.displayResults(v25, t6)
                            end
                        end
                    end
                end
            end
        end
    elseif caller then
        Prompt.error(caller, "Votes need a question, like ;vote Best colour? || Red | Blue")
    end
end
