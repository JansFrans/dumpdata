-- https://lua.expert

local Players = game:GetService("Players")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Log = require(Modules.Log)
local Janitor = require(Modules.Objects.Janitor)
local Args = require(Modules.Parser.Args)
local Signal = require(Modules.Objects.Signal)
local RunService = game:GetService("RunService")
local deepCopyTable = require(Modules.TableUtil.deepCopyTable)
local generateUID = require(Modules.DataUtil.generateUID)
local getHumanoid = require(Modules.PlayerUtil.getHumanoid)

require(Modules.CommandUtil.getTargets)

local getArgIdentity = require(Modules.CommandUtil.getArgIdentity)

require(Modules.AssetUtil.registerSound)

local v1 = RunService:IsServer()
local v2 = not v1
local Remote = require(Modules.Objects.Remote)
local v3 = if v1 then Remote.new("EndClientTask", "Event") else nil
local t1 = {}
local t2 = {}
local t3 = {}
local TaskClient = require(script.TaskClient)
local TaskServer = require(script.TaskServer)
local t4 = {}

t4.__index = t4
t4.updated = Signal.new()

function t4.getTask(p1) -- line: 52
    -- upvalues: t3 (copy)
    return t3[tostring(p1)]
end

function t4.getSelfRunTasks(p2) -- line: 56
    -- upvalues: t3 (copy)
    local t5 = {}
    local v4 = tostring(p2)

    for _, v5 in t3 do
        if v5.isActive then
            local v6 = tostring(v5.callerUserId)
            local v7 = tostring(v5.targetUserId)

            if v6 == v4 and (not v5.targetUserId or v7 == v4) then
                table.insert(t5, v5)
            end
        end
    end

    return t5
end

function t4.getTasksByCallerId(p3) -- line: 78
    -- upvalues: t3 (copy)
    local t6 = {}
    local v8 = tostring(p3)

    for _, v9 in t3 do
        if tostring(v9.callerUserId) == v8 then
            table.insert(t6, v9)
        end
    end

    return t6
end

function t4.getTasks(p4, p5) -- line: 91
    -- upvalues: t3 (copy)
    local t7 = {}
    local v10 = if p4 then p4:lower() else nil
    local v11 = tostring(p5)

    for _, v12 in t3 do
        local commandKey = v12.commandKey
        local v13 = tostring(v12.targetUserId)

        if (not v10 or commandKey == v10) and (not p5 or v13 == v11) then
            table.insert(t7, v12)
        end
    end

    return t7
end

function t4.new(p6) -- line: 108
    -- upvalues: t4 (copy)
    return (t4.construct(p6))
end

function t4.construct(p7) -- line: 112
    -- upvalues: Players (copy), Modules (copy), Janitor (copy), generateUID (copy), v1 (copy), t3 (copy), TaskClient (copy), TaskServer (copy), t4 (copy)
    local v14 = Janitor.new()
    local v15 = Janitor.new()
    local commandKey, callerUserId, targetUserId = p7.commandKey, p7.callerUserId, p7.targetUserId
    local v16 = p7.UID or generateUID(10)
    local Services = Modules.Parent.Services
    local t8 = {}
    local t9 = {}
    local t10 = {}
    local v17
    local v18 = t9
    local v19 = t10

    if v1 then
        local v20 = require(Services.Commands).getCommand(commandKey)
        local v21 = v20 and v20.groups

        if typeof(v21) == "table" then
            for _, v22 in v21 do
                t8[tostring(v22):lower()] = true
            end
        end

        v17 = v20 and v20.cooldown

        if not v17 or typeof(v17) ~= "number" or not (v17 > 0) then
            v17 = 0
        end

        v18 = t9
        v19 = t10

        if v20 then
            if typeof(v20.config) == "table" then
                v18 = v20.config
            end

            if typeof(v20.args) == "table" then
                v19 = v20.args
            end
        end
    else
        v17 = 0
    end

    local t11 = {
        janitor = v14,
        lifecycleJanitor = v15,
        UID = v16,
        isActive = true
    }
    local v23

    if not v1 or typeof(callerUserId) ~= "number" then
        v23 = false
    else
        local v24 = require(Modules.Objects.User).getUserByUserId(callerUserId)

        v23 = if v24 then require(Modules.Parent.Services.Roles).hasPermission(v24, "permitBypassLimits") else false
    end

    t11.bypassLimits = v23
    t11.caller = if typeof(callerUserId) == "number" then Players:GetPlayerByUserId(callerUserId) else nil
    t11.callerUserId = callerUserId
    t11.target = if targetUserId then Players:GetPlayerByUserId(targetUserId) else nil
    t11.client = TaskClient.new(v16)
    t11.server = TaskServer.new(v16)
    t11.extra = {}
    t11.config = v18
    t11.commandKey = commandKey:lower()
    t11.startedAt = os.time()
    t11.isReplay = false
    t11.isPaused = false
    t11.pauseTime = 0
    t11.holdsToResume = {}
    t11.targetUserId = targetUserId
    t11.args = p7.args
    t11.modifiers = p7.modifiers
    t11.qualifiers = p7.qualifiers or {}
    t11.isRestricted = p7.isRestricted
    t11.isRunning = false
    t11.originalArgReturnValues = {}
    t11.defaultedArgIndexes = {}
    t11.commandArgNames = v19
    t11.activeHolds = 0
    t11.forceKeepHolds = 0
    t11.keptPersistences = {}
    t11.deactivated = false
    t11.actionPromptId = nil
    t11.rerunCommand = nil
    t11.resumed = nil
    t11.clientArgs = p7.clientArgs
    t11.activeClientTasks = {}
    t11.cooldownEndTime = nil
    t11.hasCompletedCooldown = false
    t11.cooldown = v17
    t11.dictOfGroupsLower = t8
    t11.activeTweens = {}
    t11.willBeUndone = false
    t11.hasStartedInitialRun = false
    t11.isSubjob = p7.isSubjob == true
    setmetatable(t11, t4)
    t3[v16] = t11

    if v1 then
        t4.updated:Fire("added", t11)
    end

    local function forEachModifier(p8) -- line: 213
        -- upvalues: p7 (copy), Modules (copy)
        local Modifiers = require(Modules.Parser.Modifiers)

        for v27, v28 in p7.modifiers or {} do
            local v29 = Modifiers.get(v27)

            if v29 then
                p8(v29, v28)
            end
        end
    end

    local n1 = 0
    local v30 = false

    forEachModifier(function(p9, p10) -- line: 225
        -- upvalues: t11 (copy), n1 (ref), v30 (ref)
        local preAction = p9.preAction

        if preAction then
            preAction(t11, p10)
        end

        n1 += 1

        if p9.keepInitialRun then
            v30 = true
        end
    end)
    task.defer(function() -- line: 235
        -- upvalues: t11 (copy), forEachModifier (copy), n1 (ref), v30 (ref)
        t11.hasStartedInitialRun = true
        forEachModifier(function(p11, p12) -- line: 240
            -- upvalues: t11 (copy)
            local action = p11.action

            if action then
                action(t11, p12)
            end
        end)

        if n1 == 0 or v30 then
            t11:run()
        end

        t11:checkToDestroy()
    end)

    function t11.spawn(p13) -- line: 253
        -- upvalues: t11 (copy)
        t11:registerHold()
        task.spawn(function() -- line: 255
            -- upvalues: p13 (copy), t11 (copy)
            t11:unregisterHold(p13)
        end)
    end

    function t11.defer(p14) -- line: 260
        -- upvalues: t11 (copy)
        t11:registerHold()
        task.defer(function() -- line: 262
            -- upvalues: p14 (copy), t11 (copy)
            t11:unregisterHold(p14)
        end)
    end

    function t11.delay(p15, p16) -- line: 267
        -- upvalues: t11 (copy)
        local v31 = p16

        t11:registerHold()

        if p16 == nil then
            v31 = function() -- line: 270
            end
        end

        task.delay(p15, function() -- line: 272
            -- upvalues: v31 (ref), t11 (copy)
            t11:unregisterHold(v31)
        end)
    end

    function t11.wait(p17) -- line: 277
        -- upvalues: t11 (copy)
        t11:registerHold()
        task.wait(p17)
        t11:unregisterHold()
    end

    function t11.iterate(p18, p19) -- line: 283
        -- upvalues: t11 (copy)
        for i = 1, p18 do
            if not t11.isActive then
                return
            end

            t11:registerHold()
            t11:unregisterHold(p19, nil, i)
        end
    end

    function t11.loop(p20) -- line: 293
        -- upvalues: t11 (copy)
        local v33 = true

        local function stop() -- line: 296
            -- upvalues: v33 (ref)
            v33 = false
        end

        local n2 = 0

        while t11.isActive and v33 do
            n2 += 1
            t11:registerHold()
            t11:unregisterHold(p20, nil, stop, n2)
        end
    end

    return t11
end

function t4.run(p21) -- line: 311
    -- upvalues: Players (copy), Modules (copy), Log (copy), Args (copy), deepCopyTable (copy), getArgIdentity (copy), v1 (copy), v2 (copy), t4 (copy)
    local run, v34
    local commandKey, args = p21.commandKey, p21.args
    local v35, run2

    if v1 then
        local Services = Modules.Parent.Services

        v35 = require(Services.Commands).getCommand(commandKey)
        v34 = v35

        if v35 then
            run2 = v35.run
            run = run2
        end

        if v35 and #p21.commandArgNames == 0 and typeof(v35.args) == "table" then
            p21.commandArgNames = v35.args
        end
    elseif v2 then
        local Controllers = Modules.Parent.Controllers

        v35 = require(Controllers.ClientCommands).getCommand(commandKey)
        v34 = v35

        if v35 then
            run2 = v35.run
            run = run2
        end
    end

    if not run2 then
        return false
    end

    local t12, qualifiers, callerUserId, targetUserId, args2, v36, v37

    if p21.isRunning then
        v37 = true
    elseif p21.isActive then
        p21.isRunning = true
        t12 = {}
        t12[1] = nil
        qualifiers = p21.qualifiers
        callerUserId = p21.callerUserId
        targetUserId = p21.targetUserId

        if args then
            if v35 then
                args2 = v35.args
            else
                args2 = {}
            end

            t12[1] = args2

            local v38 = args2[1]

            v36 = Args.get(v38)
        end

        v37 = false
    else
        v37 = true
    end

    if v37 then
        return false
    end

    if v36 and v36.playerArg == true and v36.hidden == true and args and args2 and #args >= #args2 then
        table.remove(args, 1)
    end

    local function runningDone() -- line: 360
        -- upvalues: p21 (copy)
        p21.isRunning = false
        p21:checkToDestroy()
    end

    local function registerOriginalArg(p22, p23) -- line: 366
        -- upvalues: p21 (copy)
        p21.originalArgReturnValues[p22] = p23
    end

    local runCommand = (function(p24)
        local function runCommand(p25, ...) -- line: 370
            -- upvalues: p24 (copy), p21 (copy), run (ref), v34 (ref), commandKey (copy), args (copy), callerUserId (ref), targetUserId (ref), Players (copy), Modules (copy), Log (copy), Args (copy), deepCopyTable (copy), getArgIdentity (copy), v1 (copy)
            local t13 = { ... }

            if v1 and p25 and args and p24[1] then
                local v39 = t13[1]

                if type(v39) ~= "table" then
                    v39 = nil
                end

                if not v39 then
                    v39 = {}
                    t13[1] = v39
                end

                local v40 = v39[1]
                local v41 = #v39 + 1
                local v42 = p24[1]

                for _, _ in v42 do
                    local v43 = p24[1][v41]
                    local v44 = Args.get(v43)
                    local v45 = v41 + 1

                    if not v44 then
                        break
                    end

                    local v47 = args[v40 and v41 - 1 or v41] or ""

                    if v44.playerArg then
                        v47 = {
                            [v47] = {}
                        }
                    end

                    local argOverrides = p21.extra.argOverrides
                    local v48

                    if typeof(argOverrides) == "table" then
                        v48 = argOverrides[tostring(v41)]

                        if v48 == nil then
                            local key = v44.key

                            key = key and tostring(v44.key):lower()
                            v48 = if key then argOverrides[key] else nil
                        end

                        local argOverrideKeys = p21.extra.argOverrideKeys

                        if v48 ~= nil and typeof(argOverrideKeys) == "table" then
                            local v49 = argOverrideKeys[tostring(v41)]

                            if v49 ~= nil and v49 ~= getArgIdentity(v43) then
                                v48 = nil
                            end
                        end
                    end

                    if v48 == nil then
                        v48 = v44:parse(v47, callerUserId, targetUserId)

                        if v44.runForEachPlayer and typeof(v48) == "table" then
                            v48 = v48[1]
                        end
                    end

                    if v48 == nil then
                        v48 = v44.default

                        if typeof(v48) == "table" then
                            v48 = deepCopyTable(v44.default)
                        end

                        p21.defaultedArgIndexes[v41] = true
                    end

                    if p21.defaultedArgIndexes[v41] ~= true then
                        local ArgProducts = require(Modules.CommandUtil.ArgProducts)
                        local v50 = ArgProducts.getProducts(v44)

                        if v50 and not ArgProducts.matchesDefault(v44, v48) then
                            local v51 = if callerUserId then Players:GetPlayerByUserId(callerUserId) else nil

                            if v51 and not ArgProducts.ownsAnyAsync(v51, v50) then
                                ArgProducts.sendUnlockNoticeAsync(v51, v50, v44, if v34 then v34.name else commandKey)
                                v48 = v44.default

                                if typeof(v48) == "table" then
                                    v48 = deepCopyTable(v48)
                                end

                                p21.defaultedArgIndexes[v41] = true
                            end
                        end
                    end

                    p21.originalArgReturnValues[v41] = v48
                    v39[v41] = v48
                    v41 = v45
                end
            end

            local function invokeRun() -- line: 467
                -- upvalues: p25 (copy), t13 (copy), p21 (copy), run (ref), Log (copy)
                local function onError(p26) -- line: 468
                    -- upvalues: p21 (copy), Log (copy)
                    Log.warn((("Command '%*' errored: %*"):format(p21.commandKey, p26)))
                    Log.debug(debug.traceback("", 2))
                end

                if p25 then
                    local run2 = run

                    xpcall(run2, onError, p21)
                else
                    local run2 = run
                    local _unpack = unpack

                    xpcall(run2, onError, p21, _unpack(t13))
                end
            end

            p21.rerunCommand = invokeRun
            invokeRun()
            p21.isRunning = false
            p21:checkToDestroy()

            return true
        end

        return runCommand
    end)(t12)

    if v2 then
        return runCommand(false, unpack(p21.clientArgs))
    end

    local target = p21.target

    if target then
        if v36 and v36.playerArg and not v36.runForEachPlayer then
            local t14 = {
                target
            }

            p21.originalArgReturnValues[1] = t14

            return runCommand(true, { t14 })
        end

        if v36 then
            p21.originalArgReturnValues[1] = target
        end

        return runCommand(true, { target })
    end

    if v36 and not v36.playerArg then
        return runCommand(true, {})
    end

    local v52

    if v36 then
        local v53 = v36:parse(qualifiers, callerUserId, {
            prompt = require(Modules.CommandUtil.isPromptCommand)(commandKey),
            commandKey = commandKey
        })
        local _ = v36.key

        if not v53 then
            v53 = v36.default
            p21.defaultedArgIndexes[1] = true
        end

        v52 = v53
        p21.originalArgReturnValues[1] = v53
    end

    if not (v36 and v36.runForEachPlayer) then
        return runCommand(true, { v52 })
    end

    local extra = p21.extra

    for _, v54 in v52 do
        local t15 = {
            isSubjob = true,
            targetUserId = v54.UserId,
            callerUserId = p21.callerUserId,
            commandKey = p21.commandKey,
            args = p21.args,
            modifiers = {},
            qualifiers = p21.qualifiers,
            isRestricted = p21.isRestricted
        }
        local v55 = t4.new(t15)

        if v55 and v1 then
            v55.isReplay = p21.isReplay
            v55.extra.suppressAutoPrompt = extra.suppressAutoPrompt
            v55.extra.argOverrides = extra.argOverrides
            v55.extra.parentEntryUID = extra.entryUID

            if extra.entryUID then
                require(Modules.Parent.Services.Tasks.PermTasks).trackTask(extra.entryUID, v55)
            end
        end
    end

    p21.isRunning = false
    p21:checkToDestroy()

    return true
end

function t4.registerHold(p27) -- line: 567
    p27.activeHolds += 1
end

function t4.unregisterHold(p28, p29, p30, p31, p32) -- line: 571
    -- upvalues: Log (copy), Signal (copy)
    local v56 = p30

    if p28.isPaused and p28.isActive then
        v56 = os.clock() - p28.pauseTime

        if p29 then
            table.insert(p28.holdsToResume, {
                p29,
                v56
            })

            return
        end

        if not p28.resumed then
            p28.resumed = p28.janitor:add(Signal.new())
        end

        p28.resumed:Wait()
    end

    if v56 and v56 > 0 and p28.isActive then
        task.delay(v56, function() -- line: 590
            -- upvalues: p28 (copy), p29 (copy)
            p28:unregisterHold(p29)
        end)
    else
        if typeof(p29) == "function" and p28.isActive then
            local function v57(p33) -- line: 596
                -- upvalues: p28 (copy), Log (copy)
                Log.warn((("Command '%*' errored: %*"):format(p28.commandKey, p33)))
                Log.debug(debug.traceback("", 2))
            end

            xpcall(p29, v57, p31, p32)
        end

        p28.activeHolds -= 1

        if p28.activeHolds <= 0 then
            task.defer(function() -- line: 605
                -- upvalues: p28 (copy)
                if p28.activeHolds <= 0 then
                    p28:checkToDestroy()
                end
            end)
        end
    end
end

function t4.pause(p34) -- line: 613
    -- upvalues: v1 (copy), t4 (copy)
    p34.pauseTime = os.clock()
    p34.isPaused = true

    for v58, _ in p34.activeTweens do
        v58:Pause()
    end

    if v1 then
        t4.updated:Fire("changed", p34)
    end
end

function t4.resume(p35) -- line: 624
    -- upvalues: v1 (copy), t4 (copy)
    p35.isPaused = false

    for _, v59 in p35.holdsToResume do
        local v60 = v59[1]
        local v61 = v59[2]

        task.defer(function() -- line: 629
            -- upvalues: p35 (copy), v60 (copy), v61 (copy)
            p35:unregisterHold(v60, v61)
        end)
    end

    for v62, _ in p35.activeTweens do
        v62:Play()
    end

    if p35.resumed then
        p35.resumed:Fire()
    end

    if v1 then
        t4.updated:Fire("changed", p35)
    end
end

function t4.checkToDestroy(p36) -- line: 644
    if not p36.isRunning and not (p36.activeHolds > 0) then
        p36:destroy()
    end
end

function t4.updateBuffs(p37, p38, p39, p40) -- line: 654
    -- upvalues: t1 (copy), t2 (copy)
    if p40 then
        local v63 = ("%*-%*"):format(if typeof(p38) == "Instance" then p38.Name else p38, p39)

        if t2[v63] then
            return
        end

        t2[v63] = true
        task.defer(function() -- line: 662
            -- upvalues: v63 (copy), t2 (copy)
            task.wait()
            t2[v63] = nil
        end)
    end

    local t17 = {}

    for _, v64 in t1 do
        if (p38 == nil or v64.player == p38) and (p39 == nil or v64.group == p39) then
            table.insert(t17, v64)
        end
    end

    table.sort(t17, function(p41, p42) -- line: 677
        local priority = p41.priority
        local priority2 = p42.priority

        if priority == priority2 then
            return p41.timeAdded > p42.timeAdded
        end

        return priority2 < priority
    end)

    local v65 = #t17
    local originalValue

    for i = v65, 1, -1 do
        originalValue = t17[i].originalValue

        if originalValue then
            break
        end

        originalValue = nil
    end

    for i = v65, 1, -1 do
        local v66 = p37:callBuff(t17[i], false, originalValue, i == 1)

        if originalValue == nil and v66 ~= nil then
            originalValue = v66
        end
    end
end

function t4.callBuff(p43, p44, p45, p46, p47) -- line: 709
    -- upvalues: Log (copy)
    if p46 ~= nil then
        p44.originalValue = p46
    end

    local originalValue, callback = p44.originalValue, p44.callback

    local function v67(p48) -- line: 714
        -- upvalues: p43 (copy), Log (copy)
        Log.warn((("Command '%*' errored: %*"):format(p43.commandKey, p48)))
        Log.debug(debug.traceback("", 2))
    end

    local v68, v69 = xpcall(callback, v67, p45, originalValue, p47)

    if v68 and originalValue == nil then
        p44.originalValue = v69
    else
        v69 = originalValue
    end

    return v69
end

function t4.getArgIndex(p49, p50) -- line: 728
    -- upvalues: Args (copy)
    local v70 = tonumber(p50)

    if v70 then
        return if p49.commandArgNames[v70] ~= nil then v70 else nil
    end

    local v71 = typeof(p50) == "table"
    local v72 = if v71 then nil else tostring(p50):lower()

    for v73, v74 in p49.commandArgNames do
        if v71 then
            if v74 == p50 then
                return v73
            end
        else
            local v75 = Args.get(v74)
            local v76 = v75 and v75.key

            if v76 and tostring(v76):lower() == v72 then
                return v73
            end
        end
    end

    return nil
end

function t4.getArgDetail(p51, p52) -- line: 754
    -- upvalues: Args (copy)
    local v77 = p51:getArgIndex(p52)

    if v77 then
        return Args.get(p51.commandArgNames[v77])
    end

    return Args.get(p52)
end

function t4.buff(p53, p54, p55, p56, p57) -- line: 766
    -- upvalues: t1 (copy)
    local v78, v79

    if typeof(p56) == "function" then
        v79 = p56
        v78 = 1
    else
        v79 = p57
        v78 = p56
    end

    local function destroyBuffCallback(p58) -- line: 787
        -- upvalues: p53 (copy), p54 (copy), p55 (copy), t1 (copy)
        if p58.isActive == false then
            return
        end

        for v80, v81 in t1 do
            if v81 == p58 then
                table.remove(t1, v80)
                break
            end
        end

        p58.isActive = false
        p53:callBuff(p58, true, nil, false)
        task.defer(function() -- line: 802
            -- upvalues: p53 (copy), p54 (copy), p55 (copy)
            p53:updateBuffs(p54, p55, true)
        end)
    end

    local t18 = {
        originalValue = nil,
        isActive = true,
        player = p54,
        group = p55,
        priority = v78,
        callback = v79,
        timeAdded = os.clock(),
        taskUID = p53.UID,
        destroy = destroyBuffCallback,
        Destroy = destroyBuffCallback
    }

    if p54 ~= "Server" and (typeof(p54) ~= "Instance" or not p54:IsA("Player")) then
        return t18
    end

    if typeof(p54) == "Instance" and p54:IsA("Player") then
        p53.janitor:add(p54.CharacterAdded:Connect(function(p59) -- line: 833
            -- upvalues: p53 (copy), p54 (copy), p55 (copy)
            local v82 = p59:WaitForChild("Humanoid", 5)
            local v83 = p59:WaitForChild("HumanoidRootPart", 5)

            task.defer(function() -- line: 836
                -- upvalues: v82 (copy), v83 (copy), p53 (copy), p54 (copy), p55 (copy)
                if v83 and v83.Parent and v82 and v82.Parent and p53.isActive then
                    p53:updateBuffs(p54, p55, true)
                end
            end)
        end))
    end

    p53.janitor:add(t18)
    table.insert(t1, t18)
    p53:updateBuffs(p54, p55)

    return t18
end

function t4.redo(p60, p61, p62) -- line: 856
    if typeof(p61) == "Instance" and p61:IsA("Player") then
        p60.janitor:add(p61.CharacterAdded:Connect(function(p63) -- line: 865
            -- upvalues: p60 (copy), p62 (copy)
            p63:WaitForChild("Humanoid", 5)
            p63:WaitForChild("HumanoidRootPart", 5)
            task.wait()
            task.wait()
            task.wait()
            task.wait()
            task.wait()

            local Humanoid = p63:FindFirstChild("Humanoid")
            local HumanoidRootPart = p63:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart and HumanoidRootPart.Parent and Humanoid and Humanoid.Parent and p60.isActive then
                p62()
            end
        end))
    end

    p60.spawn(function() -- line: 887
        -- upvalues: p62 (copy)
        p62()
    end)
end

function t4.keep(p64, p65, p66) -- line: 892
    -- upvalues: Players (copy), Modules (copy), getHumanoid (copy)
    local v84 = if typeof(p65) == "string" then p65 else "Indefinitely"
    local isActive = p64.isActive
    local v85 = if isActive then typeof(p64.lifecycleJanitor.add) == "function" else nil

    if not isActive or not v85 or p64.keptPersistences[v84] then
        return
    end

    p64.keptPersistences[v84] = true

    if p66 then
        p64.forceKeepHolds += 1
    end

    p64:registerHold()

    local t19, Caller, target

    if typeof(p65) == "string" and p65 ~= "Indefinitely" then
        local function endPersistence() -- line: 924
            -- upvalues: p64 (copy), p66 (copy)
            if p66 then
                p64.forceKeepHolds -= 1
            end

            if p64.forceKeepHolds <= 0 then
                p64:destroy()
            end
        end

        t19 = {}
        t19[1] = nil
        Caller = p65:match("Caller")

        if p65:match("Target") then
            target = p64.target
            t19[1] = target
        elseif Caller then
            target = p64.caller
            t19[1] = target
        end

        if target then
            local v86 = p65:match("([A-Z][a-z]+)$")

            if v86 then
                local caller = p64.caller

                if Caller and caller then
                    p64:onEnded(function() -- line: 956
                        -- upvalues: caller (copy)
                        if not caller:GetAttribute("HDCallerHasInformedOthers") then
                            caller:SetAttribute("HDCallerHasInformedOthers", true)
                        end
                    end)
                end

                local v87 = v86 == "Dies"
                local v88 = v86 == "Respawns"
                local v89 = getHumanoid(target)

                if (v87 or v88) and v89 then
                    if v87 and v89.Health <= 0 then
                        if p66 then
                            p64.forceKeepHolds -= 1
                        end

                        if p64.forceKeepHolds <= 0 then
                            p64:destroy()
                        end
                    elseif p64.lifecycleJanitor.add then
                        p64.lifecycleJanitor:add(v89.Died:Connect(function() -- line: 976
                            -- upvalues: p64 (copy), p66 (copy), v88 (copy), Players (copy)
                            if v88 then
                                local v90 = Players.RespawnTime - 0.01

                                task.wait(v90)
                            end

                            if p66 then
                                p64.forceKeepHolds -= 1
                            end

                            if p64.forceKeepHolds <= 0 then
                                p64:destroy()
                            end
                        end))
                    end
                end

                if v88 or v87 then
                    local loadCharacterStarted = require(Modules.PlayerUtil.loadCharacterStarted)

                    p64.lifecycleJanitor:add(loadCharacterStarted:Connect(((function(p67)
                        return function(p68) -- line: 991
                            -- upvalues: p67 (copy), p64 (copy), p66 (copy)
                            if p68 == p67[1] then
                                if p66 then
                                    p64.forceKeepHolds -= 1
                                end

                                if p64.forceKeepHolds <= 0 then
                                    p64:destroy()
                                end
                            end
                        end
                    end)(t19))))
                    p64.lifecycleJanitor:add(t19[1].CharacterAdded:Connect(function(_) -- line: 996
                        -- upvalues: p64 (copy), p66 (copy)
                        if p66 then
                            p64.forceKeepHolds -= 1
                        end

                        if p64.forceKeepHolds <= 0 then
                            p64:destroy()
                        end
                    end))
                end

                if v86 == "Leaves" or v88 or v87 then
                    p64.lifecycleJanitor:add(t19[1]:GetPropertyChangedSignal("Parent"):Connect(((function(p70)
                        return function() -- line: 1002
                            -- upvalues: p70 (copy), p64 (copy), p66 (copy)
                            if not (p70[1] and p70[1].Parent) then
                                if p66 then
                                    p64.forceKeepHolds -= 1
                                end

                                if p64.forceKeepHolds <= 0 then
                                    p64:destroy()
                                end
                            end
                        end
                    end)(t19))))
                end
            end
        end
    end
end

function t4.getArg(p71, p72, p73) -- line: 1015
    local v91 = p71:getArgIndex(p72)

    return if v91 and not (p73 and p71.defaultedArgIndexes[v91]) then p71.originalArgReturnValues[v91] else nil
end

function t4.setArg(p74, p75, p76) -- line: 1028
    -- upvalues: Modules (copy), v1 (copy)
    local v92 = p74:getArgIndex(p75)

    if v92 then
        p74.originalArgReturnValues[v92] = p76
        p74.defaultedArgIndexes[v92] = nil

        local extra = p74.extra

        if v1 and extra.entryUID and not extra.applyingRemoteArg then
            require(Modules.Parent.Services.Tasks.PermTasks).updateEntryArg(extra.entryUID, v92, p76)
        end
    end

    return p76
end

function t4.bindPrompt(p77, p78) -- line: 1047
    -- upvalues: Modules (copy)
    local Action = require(Modules.Prompt.Action)

    p77.extra.lastPromptConfig = p78

    if not p77.actionPromptId then
        if p77.extra.suppressAutoPrompt then
            return
        end

        local v93 = Action.bind(p77, p78)

        p77.lifecycleJanitor:add(v93)

        return v93
    end

    Action.update(p77, p78)
end

function t4.endClientTasks(p79, p80) -- line: 1072
    -- upvalues: Players (copy), v1 (copy), Remote (copy), v3 (ref)
    if not v1 then
        return
    end

    v3 = v3 or Remote.new("EndClientTask", "Event")

    for v94, _ in p79.activeClientTasks do
        local v95 = Players:FindFirstChild(v94)

        if v95 and v3 and v95:IsA("Player") then
            v3:fireClient(v95, p79.UID, p80 == true)
        end

        p79.activeClientTasks[v94] = nil
    end
end

function t4.deactivate(p81) -- line: 1088
    if p81.deactivated or not p81.isActive then
        return
    end

    p81.deactivated = true
    p81:endClientTasks(true)
    p81.janitor:cleanup()
end

function t4.reactivate(p82) -- line: 1097
    if not (p82.deactivated and p82.isActive) then
        return
    end

    p82.deactivated = false

    if p82.rerunCommand then
        p82.rerunCommand()
    end
end

function t4.createSound(_, p84) -- line: 1107
    -- upvalues: Modules (copy)
    p84 = p84 or "Command"

    local registerSound = require(Modules.AssetUtil.registerSound)
    local Sound = Instance.new("Sound")

    registerSound(Sound, p84)

    return Sound
end

function t4.tween(p85, p86, p87, p88) -- line: 1120
    local v98 = game:GetService("TweenService"):Create(p86, p87, p88)

    if not p85.isActive then
        v98:Destroy()

        return v98
    end

    p85.activeTweens[v98] = true

    if p85.isPaused then
        v98:Pause()
    end

    local v99 = false

    local function cleanup() -- line: 1132
        -- upvalues: p85 (copy), v98 (copy), v99 (ref)
        if v99 then
            return
        end

        v99 = true
        v98:Cancel()
        v98:Destroy()
        p85.activeTweens[v98] = nil
    end

    p85.janitor:add(v98.Completed:Once(cleanup))
    p85.janitor:add(cleanup)
    v98:Play()

    return v98
end

function t4.onEnded(p89, p90) -- line: 1146
    if p89.isActive then
        p89.janitor:add(p90)
    end
end

function t4.onEndedForGood(p91, p92) -- line: 1152
    -- upvalues: t4 (copy)
    local target = p91.target
    local v100 = target and target.UserId
    local commandKey = p91.commandKey

    p91:onEnded(function() -- line: 1161
        -- upvalues: p92 (copy), commandKey (copy), v100 (copy), t4 (copy)
        task.delay(0.1, function() -- line: 1162
            -- upvalues: p92 (copy), commandKey (copy), v100 (copy), t4 (copy)
            if commandKey then
                for _, v101 in t4.getTasks(commandKey, v100) do
                    if v101.isActive then
                        return
                    end
                end
            end

            p92()
        end)
    end)
end

function t4.destroy(p93) -- line: 1177
    -- upvalues: v1 (copy), t3 (copy), t4 (copy)
    if p93.isActive == false then
        return
    end

    if v1 then
        t4.updated:Fire("removed", p93)
        p93:endClientTasks()
    end

    local function unregisterTask() -- line: 1185
        -- upvalues: p93 (copy), t3 (copy)
        t3[p93.UID] = nil
    end

    if not (p93.cooldown > 0) or p93.hasCompletedCooldown then
        t3[p93.UID] = nil
    else
        p93.cooldownEndTime = os.clock() + p93.cooldown
        task.delay(p93.cooldown, function() -- line: 1190
            -- upvalues: p93 (copy), t3 (copy)
            p93.hasCompletedCooldown = true
            t3[p93.UID] = nil
        end)
    end

    p93.holdsToResume = {}
    p93.isActive = false
    p93.janitor:destroy()
    p93.lifecycleJanitor:destroy()
end

return t4
