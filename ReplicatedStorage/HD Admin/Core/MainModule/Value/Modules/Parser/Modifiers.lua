-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Services = Modules.Parent.Services
local t1 = {}
local Players = game:GetService("Players")
local Task = require(Modules.Objects.Task)

require(Modules.Parser.ParserTypes)

local v1 = true
local t2 = {}
local t3 = {}

local function register(p1) -- line: 27
    return p1
end

local function actOnTasksToUndo(p2, p3) -- line: 31
    -- upvalues: Modules (copy), Services (copy), Task (copy)
    local Commands = require(Services.Commands)
    local Args = require(script.Parent.Args)
    local commandKey = p2.commandKey
    local v2 = Commands.getCommand(commandKey)

    if not v2 then
        return
    end

    local v3 = v2.args[1]
    local v4 = Args.get(v3)

    local function actOn(p4) -- line: 41
        -- upvalues: p3 (copy)
        local extra = p4.extra

        if typeof(extra) == "table" and (extra.entryUID or extra.parentEntryUID) then
            return
        end

        p3(p4)
    end

    local function processTasks(p5) -- line: 49
        -- upvalues: p3 (copy), commandKey (copy), Task (copy)
        for _, v5 in (Task.getTasks(commandKey, p5)) do
            local extra = v5.extra

            if typeof(extra) ~= "table" or not extra.entryUID and not extra.parentEntryUID then
                p3(v5)
            end
        end
    end

    if v4 and v4.playerArg and v4.runForEachPlayer then
        local Player = Args.get("Player")
        local isPromptCommand = require(Modules.CommandUtil.isPromptCommand)

        for _, v6 in Player and Player:parse(p2.qualifiers, p2.callerUserId, {
                silent = true,
                prompt = isPromptCommand(commandKey),
                commandKey = commandKey
            }) or {} do
            local UserId = v6.UserId

            for _, v7 in (Task.getTasks(commandKey, UserId)) do
                local extra = v7.extra

                if typeof(extra) ~= "table" or not extra.entryUID and not extra.parentEntryUID then
                    p3(v7)
                end
            end
        end

        for _, v8 in Task.getTasks(commandKey) do
            if not v8.targetUserId then
                local extra = v8.extra

                if typeof(extra) ~= "table" or not extra.entryUID and not extra.parentEntryUID then
                    p3(v8)
                end
            end
        end
    else
        for _, v9 in (Task.getTasks(commandKey, nil)) do
            local extra = v9.extra

            if typeof(extra) ~= "table" or not extra.entryUID and not extra.parentEntryUID then
                p3(v9)
            end
        end
    end
end

function t1.update() -- line: 76
    -- upvalues: t1 (copy), v1 (ref), t2 (ref), t3 (ref)
    if not v1 then
        return false
    end

    v1 = false

    local v10 = t1.getAll()

    t2 = {}
    t3 = {}

    for v11, v12 in v10 do
        local v13 = tostring(v11):lower()

        t3[v13] = v12

        local t5 = t2

        table.insert(t5, (tostring(v11)))
    end

    table.sort(t2, function(p6, p7) -- line: 89
        return #p6 > #p7
    end)

    return true
end

function t1.getSortedNameAndAliasLengthArray() -- line: 95
    -- upvalues: t1 (copy), t2 (ref)
    t1.update()

    return t2
end

function t1.getLowercaseDictionary() -- line: 100
    -- upvalues: t1 (copy), t3 (ref)
    t1.update()

    return t3
end

function t1.broadcastGlobalStatement(p8, p9) -- line: 108
    -- upvalues: Modules (copy), Services (copy), Players (copy)
    local modifiers = p9.modifiers
    local v15 = modifiers.global or {}

    modifiers.global = nil
    modifiers.wasGlobal = v15
    modifiers.globalUID = require(Modules.DataUtil.generateUID)(10)

    local v16 = require(Modules.TableUtil.deepCopyTable)(p9)

    modifiers.globalOrigin = true
    v16.modifiers.join = nil

    local prefilterTextArgs = require(Modules.CommandUtil.prefilterTextArgs)
    local Commands = require(Services.Commands)
    local argOverrides = p9.argOverrides
    local v17 = if typeof(argOverrides) == "table" then table.clone(argOverrides) else {}
    local name

    for v18 in v16.commands do
        local v19 = Commands.getCommand(v18)

        if v19 and v17[v19.key] == nil then
            local v20, v21 = prefilterTextArgs(v19, v16.commands[v18], p8)

            if v21 then
                v16.commands[v18] = nil
                name = v19.name
            elseif v20 then
                v17[v19.key] = v20
            end
        end
    end

    if name then
        local v22 = if typeof(p8) == "number" then Players:GetPlayerByUserId(p8) else nil

        if v22 then
            require(Modules.Prompt).warn(v22, (("'%*' text was rejected by the filter, so it wasn't broadcast"):format(name)))
        end
    end

    if next(v16.commands) ~= nil then
        if next(v17) then
            v16.argOverrides = v17
        end

        require(Services.Tasks.GlobalStatements).broadcast(p8, v16)
    end
end

function t1.get(p10) -- line: 168
    -- upvalues: t1 (copy)
    local v23 = tostring(p10):lower()
    local v24 = t1.getLowercaseDictionary()[v23]

    if not v24 then
        return nil
    end

    local key = v24.key

    if v24.mustCreateAliasOf then
        local mustCreateAliasOf = v24.mustCreateAliasOf
        local v25 = t1.items[mustCreateAliasOf]

        if not v25 then
            error((("Modifiers: %* can not create alias because %* is not a valid qualifier"):format(key, mustCreateAliasOf)))
        end

        for v26, v27 in v25 do
            if not v24[v26] then
                v24[v26] = v27
            end
        end

        v24.mustCreateAliasOf = nil
        v24.aliasOf = mustCreateAliasOf
    end

    return v24
end

function t1.getAll() -- line: 195
    -- upvalues: t1 (copy)
    local items = t1.items

    for v28, v29 in items do
        if not v29.key then
            v29.key = v28
        end

        t1.get(v28)
    end

    return items
end

function t1.createAliasOf(p11, p12) -- line: 207
    -- upvalues: t1 (copy)
    task.defer(function() -- line: 211
        -- upvalues: p11 (copy), t1 (copy)
        if not t1.items[p11] then
            error((("Modifiers: %* is not a valid qualifier"):format(p11)))
        end
    end)

    local v30 = if typeof(p12) == "table" then p12 else {}

    v30.mustCreateAliasOf = p11

    return v30
end

t1.items = {
    Undo = {
        isGlobal = false,
        isAbusive = false,
        description = "Ends all tasks of this command and/or player",
        ignorePreTaskChecks = true,
        displayOrder = 1,
        affectsArgs = "firstPlayerArg",
        preAction = function(p13, _) -- preAction | line: 235
            -- upvalues: actOnTasksToUndo (copy)
            actOnTasksToUndo(p13, function(p15) -- line: 236
                p15.willBeUndone = true
            end)
        end,
        action = function(p16, _) -- action | line: 240
            -- upvalues: actOnTasksToUndo (copy)
            actOnTasksToUndo(p16, function(p18) -- line: 241
                p18:destroy()
            end)
        end
    },
    Un = t1.createAliasOf("Undo"),
    Unperm = {
        isGlobal = true,
        isAbusive = false,
        description = "Ends all permanent tasks of this command and/or player",
        ignorePreTaskChecks = true,
        displayOrder = 15,
        affectsArgs = "firstPlayerArg"
    },
    Loop = {
        isGlobal = false,
        isAbusive = true,
        description = "Repeatedly re-runs",
        isCustomizable = true,
        requiresCapsule = true,
        ignorePreTaskChecks = false,
        displayOrder = 2,
        configurable = "iterations,interval",
        action = function(p19, p20) -- action | line: 270
            local v31, v32 = unpack(p20)
            local v33 = tonumber(v31) or 1E+07
            local v34 = v33

            if v33 > 1E+07 then
                v34 = 1E+07
                v33 = 1E+07
            end

            local v35 = tonumber(v32) or 0.1
            local v36 = v35

            if v35 < 0.1 then
                v36 = 0.1
            end

            if p19.target then
                p19:keep("UntilTargetLeaves", true)
            end

            p19.iterate(v33, function(p21) -- line: 286
                -- upvalues: p19 (copy), v34 (ref), v36 (ref)
                p19:run()

                if p21 ~= v34 then
                    p19.wait(v36)
                end
            end)
        end
    },
    Spawn = {
        isGlobal = false,
        isAbusive = true,
        description = "Runs now and every time the player respawns",
        displayOrder = 3,
        ignorePreTaskChecks = false,
        action = function(p22, _) -- action | line: 302
            local target = p22.target

            if target and target:IsA("Player") and p22.isActive then
                p22:keep("UntilTargetLeaves", true)
                p22:redo(target, function() -- line: 311
                    -- upvalues: p22 (copy)
                    p22:run()
                end)
            end
        end
    },
    Global = {
        isGlobal = true,
        isAbusive = true,
        description = "Runs once on all servers",
        ignorePreTaskChecks = false,
        displayOrder = 8,
        preCreation = function(p24, p25) -- preCreation | line: 323
            -- upvalues: t1 (copy)
            if p25.modifiers.global and not p25.modifiers.preview then
                t1.broadcastGlobalStatement(p24, p25)
            end
        end
    },
    Perm = {
        isGlobal = true,
        isAbusive = true,
        description = "Runs on every server and future servers",
        ignorePreTaskChecks = false,
        displayOrder = 9
    },
    PermLoop = {
        isGlobal = true,
        isAbusive = true,
        description = "Repeatedly reruns on every server and future servers",
        isCustomizable = true,
        requiresCapsule = true,
        ignorePreTaskChecks = false,
        displayOrder = 10,
        configurable = "iterations,interval"
    },
    PermDelay = {
        isGlobal = true,
        isAbusive = true,
        description = "Waits this many seconds on all servers and future servers before running",
        isCustomizable = true,
        requiresCapsule = true,
        ignorePreTaskChecks = false,
        displayOrder = 13,
        configurable = "seconds"
    },
    PermJoin = {
        isGlobal = true,
        isAbusive = true,
        description = "Runs now and whenever a matching player joins any server. It keeps applying in future servers too",
        ignorePreTaskChecks = false,
        displayOrder = 12
    },
    Join = {
        isGlobal = true,
        isAbusive = true,
        description = "Runs on a player when they join this server",
        ignorePreTaskChecks = false,
        displayOrder = 4,
        action = function(p26, _) -- action | line: 385
            -- upvalues: Modules (copy), Services (copy), Task (copy)
            local Players = game:GetService("Players")

            if typeof(p26.modifiers) == "table" and p26.modifiers.undo then
                return
            end

            p26:keep("Indefinitely")
            p26.janitor:add(Players.PlayerAdded:Connect(function(p28) -- line: 397
                -- upvalues: p26 (copy), Modules (copy), Services (copy), Task (copy)
                p26.spawn(function() -- line: 398
                    -- upvalues: p28 (copy), p26 (copy), Modules (copy), Services (copy), Task (copy)
                    local User = require(Modules.Objects.User)

                    while true do
                        if User.getUser(p28) then
                            if p26.isActive and p28.Parent ~= nil and require(Services.Tasks.PermTasks).playerMatchesCommand(p26.commandKey, p26.qualifiers, p26.callerUserId, p28) then
                                local v37 = Task.new({
                                    callerUserId = p26.callerUserId,
                                    targetUserId = p28.UserId,
                                    commandKey = p26.commandKey,
                                    args = p26.args,
                                    modifiers = p26.extra.childModifiers or {},
                                    qualifiers = p26.qualifiers,
                                    isRestricted = p26.isRestricted
                                })

                                if v37 then
                                    v37.extra.suppressAutoPrompt = true
                                    v37.isReplay = true
                                    v37.extra.textBatchId = p26.extra.textBatchId

                                    local childArgOverrides = p26.extra.childArgOverrides

                                    if typeof(childArgOverrides) == "table" then
                                        v37.extra.argOverrides = childArgOverrides
                                    end
                                end
                            end

                            return
                        end

                        if p28.Parent ~= nil and p26.isActive then
                            p26.wait(0.5)
                            continue
                        end

                        break
                    end
                end)
            end))
        end
    },
    Delay = {
        isGlobal = false,
        isAbusive = true,
        description = "Waits this many seconds before running",
        isCustomizable = true,
        requiresCapsule = true,
        displayOrder = 5,
        configurable = "seconds",
        keepInitialRun = true,
        action = function(p29, p30) -- action | line: 448
            local v39 = tonumber(p30[1]) or 0

            p29.wait(v39)
        end
    },
    PermSpawn = {
        isGlobal = true,
        isAbusive = true,
        description = "Runs now and on every respawn, in this and future servers. It follows the players you picked wherever they go",
        ignorePreTaskChecks = false,
        displayOrder = 11
    },
    Schedule = {
        isGlobal = false,
        isAbusive = true,
        description = "Runs at the given epoch time",
        isCustomizable = true,
        requiresCapsule = true,
        displayOrder = 6,
        configurable = "epochTime",
        keepInitialRun = true,
        action = function(p31, p32) -- action | line: 473
            -- upvalues: Services (copy)
            local v41 = tonumber(p32 and p32[1])

            if v41 then
                local v42 = v41 - os.time()

                if v42 > 0 then
                    local entryUID = p31.extra.entryUID

                    if entryUID then
                        p31:onEnded(function() -- line: 486
                            -- upvalues: p31 (copy), entryUID (copy), Services (copy)
                            if p31.extra.scheduleFired then
                                require(Services.Tasks.PermTasks).remove(entryUID, "schedule fired")
                            end
                        end)
                    end

                    p31.wait(v42)
                    p31.extra.scheduleFired = true
                elseif p31.isReplay then
                    local entryUID = p31.extra.entryUID

                    if entryUID then
                        require(Services.Tasks.PermTasks).remove(entryUID, "schedule moment passed")
                    end

                    p31:destroy()
                end
            end
        end
    },
    PermSchedule = {
        isGlobal = true,
        isAbusive = true,
        description = "Waits until the given epoch time on all servers and future servers before running",
        isCustomizable = true,
        requiresCapsule = true,
        displayOrder = 14,
        configurable = "epochTime"
    },
    Expire = {
        isGlobal = false,
        isAbusive = true,
        description = "Ends after this many seconds",
        isCustomizable = true,
        requiresCapsule = true,
        displayOrder = 7,
        configurable = "seconds",
        keepInitialRun = true,
        action = function(p33, p34) -- action | line: 527
            local v44 = tonumber(p34 and p34[1])

            if not v44 or v44 <= 0 then
                return
            end

            p33.delay(v44, function() -- line: 532
                -- upvalues: p33 (copy)
                p33:destroy()
            end)
        end
    },
    Until = t1.createAliasOf("Expire"),
    Preview = {
        isGlobal = false,
        isAbusive = false,
        ignorePreTaskChecks = true,
        description = "Loads up the command run menu of that command instead of running",
        keepInitialRun = false,
        action = function(p35, _) -- action | line: 546
            -- upvalues: Modules (copy)
            local caller = p35.caller

            if typeof(caller) == "Instance" and caller:IsA("Player") then
                local openPreviewRemote = require(Modules.References.openPreviewRemote)

                if openPreviewRemote then
                    local t13 = {}

                    if typeof(p35.modifiers) == "table" then
                        for v45, _ in p35.modifiers do
                            if typeof(v45) == "string" and v45:lower() ~= "preview" then
                                table.insert(t13, v45)
                            end
                        end
                    end

                    openPreviewRemote:fireClient(caller, {
                        commandKey = p35.commandKey,
                        argTokens = p35.args,
                        modifierTokens = t13
                    })
                end
            end
        end
    },
    Random = {
        isGlobal = false,
        isAbusive = false,
        description = "Picks one command at random from the statement",
        preCreation = function(_, p38) -- preCreation | line: 572
            local commands = p38.commands

            if #commands > 1 then
                p38.commands = { commands[math.random(1, #commands)] }
            end
        end
    }
}

return t1
