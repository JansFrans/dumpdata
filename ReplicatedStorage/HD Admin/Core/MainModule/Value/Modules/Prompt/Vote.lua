-- https://lua.expert

local Players = game:GetService("Players")
local MemoryStoreService = game:GetService("MemoryStoreService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Remote = require(Modules.Objects.Remote)
local Prompt = require(Modules.Prompt)
local generateUID = require(Modules.DataUtil.generateUID)
local IsolatedServer = require(Modules.IsolatedServer)
local v1
local t2 = {}
local v2
local t3 = {}
local t1 = {}

t1.GLOBAL_GRACE = 5
t1.RESULTS_POLL_INTERVAL = 2
t1.RESULTS_POLL_TIMEOUT = 20

local function getServerKey() -- line: 80
    -- upvalues: generateUID (copy), v2 (ref)
    if not v2 then
        v2 = "s_" .. (if game.JobId == "" then generateUID(10) else game.JobId)
    end

    return v2
end

local function getIsolatedSortedMap(p1) -- line: 87
    -- upvalues: t3 (copy)
    local v3 = t3[p1]

    if v3 then
        return v3
    end

    local t4 = {}
    local t5 = {
        SetAsync = function(_, p3, p4, _) -- SetAsync | line: 94
            -- upvalues: t4 (copy)
            t4[p3] = p4
        end,
        GetAsync = function(_, p7) -- GetAsync | line: 97
            -- upvalues: t4 (copy)
            return t4[p7]
        end,
        GetRangeAsync = function(_, _, _, _) -- GetRangeAsync | line: 100
            -- upvalues: t4 (copy)
            local t6 = {}

            for v4, v5 in t4 do
                table.insert(t6, {
                    key = v4,
                    value = v5
                })
            end

            table.sort(t6, function(p12, p13) -- line: 105
                return p12.key < p13.key
            end)

            return t6
        end
    }

    t3[p1] = t5
    task.delay(240, function() -- line: 112
        -- upvalues: p1 (copy), t3 (copy)
        t3[p1] = nil
    end)

    return t5
end

local function getSortedMap(p14) -- line: 118
    -- upvalues: MemoryStoreService (copy), IsolatedServer (copy), getIsolatedSortedMap (copy)
    if IsolatedServer.isIsolated() then
        return (getIsolatedSortedMap(p14))
    end

    local function v6() -- line: 122
        -- upvalues: p14 (copy), MemoryStoreService (copy)
        return MemoryStoreService:GetSortedMap("HDAdminVote_" .. p14)
    end

    local ok, result = pcall(v6)

    return if ok then result else nil
end

local function ensureRemote() -- line: 131
    -- upvalues: Remote (copy), v1 (ref), t2 (copy)
    if not v1 then
        v1 = Remote.new("VoteSubmit", "Event", "Low")

        if v1 then
            local v7 = v1

            v7:onServerEvent(function(p15, p16, p17) -- line: 139
                -- upvalues: t2 (copy)
                if typeof(p16) == "string" then
                    local v8 = t2[p16]

                    if v8 and not v8.finished and v8.eligible[p15.UserId] and not (os.clock() > v8.deadline + 1) then
                        if p17 == "dismiss" then
                            v8.dismissed[p15.UserId] = true
                        elseif typeof(p17) == "number" and p17 % 1 == 0 and not (p17 < 1 or #v8.options < p17) then
                            if v8.ballots[p15.UserId] == nil then
                                v8.ballotCount += 1
                            end

                            v8.ballots[p15.UserId] = p17
                        end
                    end
                end
            end)
        end
    end
end

function t1.open(p18, p19) -- line: 176
    -- upvalues: Remote (copy), Prompt (copy), generateUID (copy), v1 (ref), t2 (copy)
    if not v1 then
        v1 = Remote.new("VoteSubmit", "Event", "Low")

        if v1 then
            v1:onServerEvent(function(p20, p21, p22) -- line: 139
                -- upvalues: t2 (copy)
                if typeof(p21) == "string" then
                    local v10 = t2[p21]

                    if v10 and not v10.finished and v10.eligible[p20.UserId] and not (os.clock() > v10.deadline + 1) then
                        if p22 == "dismiss" then
                            v10.dismissed[p20.UserId] = true
                        elseif typeof(p22) == "number" and p22 % 1 == 0 and not (p22 < 1 or #v10.options < p22) then
                            if v10.ballots[p20.UserId] == nil then
                                v10.ballotCount += 1
                            end

                            v10.ballots[p20.UserId] = p22
                        end
                    end
                end
            end)
        end
    end

    local v11 = generateUID(10)
    local t8 = {
        eligibleCount = 0,
        ballotCount = 0,
        finished = false,
        voteId = v11,
        question = p19.question,
        options = p19.options,
        deadline = os.clock() + p19.duration,
        eligible = {},
        ballots = {},
        dismissed = {},
        taskRef = p18,
        promptIndexes = {}
    }

    t2[v11] = t8
    p18.janitor:add(function() -- line: 195
        -- upvalues: v11 (copy), t8 (copy), t2 (copy)
        t8.finished = true
        t2[v11] = nil
    end, true)

    local t9 = {
        voteId = v11,
        fields = p19.options,
        duration = p19.duration,
        colorSeed = p19.colorSeed or v11
    }

    if typeof(p19.fromUserId) == "number" then
        t9.fromUserId = p19.fromUserId
        t9.userText = true
    else
        t9.fromServer = true
    end

    for v12, v13 in p19.targets do
        if typeof(v13) == "Instance" and v13:IsA("Player") and v13.Parent and not t8.eligible[v13.UserId] then
            t8.eligible[v13.UserId] = true
            t8.eligibleCount += 1

            local v14 = ("votePrompt_%*_%*"):format(v11, v12)

            p18.janitor:add(Prompt.vote(v13, p19.question, t9), nil, v14)
            table.insert(t8.promptIndexes, v14)
        end
    end

    return t8
end

function t1.allResponded(p23) -- line: 227
    -- upvalues: Players (copy)
    for v15 in p23.eligible do
        if p23.ballots[v15] == nil and not p23.dismissed[v15] and Players:GetPlayerByUserId(v15) then
            return false
        end
    end

    return true
end

function t1.finish(p24) -- line: 236
    -- upvalues: t2 (copy)
    if p24.finished then
        return
    end

    p24.finished = true
    t2[p24.voteId] = nil

    local v16 = p24.taskRef and p24.taskRef.janitor

    if v16 then
        for _, v17 in p24.promptIndexes do
            v16:removeList(v17)
        end
    end
end

function t1.tally(p25) -- line: 251
    local v18 = table.create(#p25.options, 0)
    local n1 = 0

    for _, v19 in p25.ballots do
        v18[v19] += 1
        n1 += 1
    end

    return v18, (math.max(p25.eligibleCount - n1, 0))
end

function t1.buildResults(p26, p27, p28) -- line: 262
    local v21 = p28

    for _, v22 in p27 do
        if v21 < v22 then
            v21 = v22
        end
    end

    if v21 < 1 then
        v21 = 1
    end

    local t10 = {}

    for v23, v24 in p26 do
        local v25 = p27[v23] or 0

        table.insert(t10, {
            answer = v24,
            votes = v25,
            percentage = v25 / v21
        })
    end

    table.insert(t10, {
        answer = "Did Not Vote",
        votes = p28,
        percentage = p28 / v21
    })

    return t10
end

function t1.publishTally(p29, p30, p31) -- line: 281
    -- upvalues: MemoryStoreService (copy), generateUID (copy), IsolatedServer (copy), v2 (ref), getIsolatedSortedMap (copy)
    local result

    if IsolatedServer.isIsolated() then
        result = getIsolatedSortedMap(p29)
    else
        local function v26() -- line: 122
            -- upvalues: p29 (copy), MemoryStoreService (copy)
            return MemoryStoreService:GetSortedMap("HDAdminVote_" .. p29)
        end

        local ok

        ok, result = pcall(v26)

        if not ok then
            result = nil
        end
    end

    if not result then
        return
    end

    local function v27() -- line: 286
        -- upvalues: p30 (copy), p31 (copy), result (ref), generateUID (copy), v2 (ref)
        if not v2 then
            v2 = "s_" .. (if game.JobId == "" then generateUID(10) else game.JobId)
        end

        result:SetAsync(v2, {
            scores = p30,
            didNotVote = p31
        }, 240)
    end

    pcall(v27)
end

function t1.collectTallies(p32, p33) -- line: 291
    -- upvalues: MemoryStoreService (copy), IsolatedServer (copy), getIsolatedSortedMap (copy)
    local v29 = table.create(p33, 0)
    local result

    if IsolatedServer.isIsolated() then
        result = getIsolatedSortedMap(p32)
    else
        local function v30() -- line: 122
            -- upvalues: p32 (copy), MemoryStoreService (copy)
            return MemoryStoreService:GetSortedMap("HDAdminVote_" .. p32)
        end

        local ok

        ok, result = pcall(v30)

        if not ok then
            result = nil
        end
    end

    if not result then
        return v29, 0
    end

    local t13
    local n2 = 0

    while true do
        local result2 = result

        local function v31() -- line: 300
            -- upvalues: t13 (ref), result2 (copy)
            return result2:GetRangeAsync(Enum.SortDirection.Ascending, 200, t13)
        end

        local ok, result3 = pcall(v31)

        if ok and typeof(result3) == "table" then
            for _, v32 in result3 do
                if typeof(v32.key) == "string" and string.sub(v32.key, 1, 2) == "s_" and typeof(v32.value) == "table" then
                    local scores = v32.value.scores

                    if typeof(scores) == "table" then
                        for i = 1, p33 do
                            local v34 = tonumber(scores[i])

                            if v34 and v34 > 0 then
                                v29[i] += math.floor(v34)
                            end
                        end
                    end

                    local v35 = tonumber(v32.value.didNotVote)

                    if v35 and v35 > 0 then
                        n2 += math.floor(v35)
                    end
                end
            end

            if #result3 < 200 then
                break
            end

            t13 = {
                key = result3[#result3].key
            }
            continue
        end

        break
    end

    return v29, n2
end

function t1.publishResults(p34, p35) -- line: 332
    -- upvalues: MemoryStoreService (copy), IsolatedServer (copy), getIsolatedSortedMap (copy)
    local result

    if IsolatedServer.isIsolated() then
        result = getIsolatedSortedMap(p34)
    else
        local function v36() -- line: 122
            -- upvalues: p34 (copy), MemoryStoreService (copy)
            return MemoryStoreService:GetSortedMap("HDAdminVote_" .. p34)
        end

        local ok

        ok, result = pcall(v36)

        if not ok then
            result = nil
        end
    end

    if not result then
        return
    end

    local function v37() -- line: 337
        -- upvalues: p35 (copy), result (ref)
        result:SetAsync("results", p35, 240)
    end

    pcall(v37)
end

function t1.fetchResults(p36) -- line: 342
    -- upvalues: MemoryStoreService (copy), IsolatedServer (copy), getIsolatedSortedMap (copy)
    local result

    if IsolatedServer.isIsolated() then
        result = getIsolatedSortedMap(p36)
    else
        local function v38() -- line: 122
            -- upvalues: p36 (copy), MemoryStoreService (copy)
            return MemoryStoreService:GetSortedMap("HDAdminVote_" .. p36)
        end

        local ok

        ok, result = pcall(v38)

        if not ok then
            result = nil
        end
    end

    if not result then
        return nil
    end

    local function v39() -- line: 347
        -- upvalues: result (ref)
        return result:GetAsync("results")
    end

    local ok, result2 = pcall(v39)

    return if ok and typeof(result2) == "table" then result2 else nil
end

function t1.displayResults(p37, p38) -- line: 356
    -- upvalues: Prompt (copy)
    local t14 = {
        results = p38.results,
        colorSeed = p38.colorSeed
    }

    if typeof(p38.fromUserId) == "number" then
        t14.fromUserId = p38.fromUserId
        t14.userText = true
    else
        t14.fromServer = true
    end

    Prompt.voteResults(p37, p38.question, t14)
end

return t1
