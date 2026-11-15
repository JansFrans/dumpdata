-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local getTargets = require(Modules.CommandUtil.getTargets)
local Remote = require(Modules.Objects.Remote)
local RunService = game:GetService("RunService")
local v1 = if RunService:IsServer() then Remote.new("RunClientCommand", "Event") else nil
local v2, v3
local t1 = {}

t1.__index = t1

local function setupReplicateListener() -- line: 17
    -- upvalues: Modules (copy), Remote (copy), v2 (ref), v3 (ref)
    if v2 then
        return
    end

    v2 = Remote.new("RequestReplication", "Function", "Low")

    if v2 then
        local Parent = require(script.Parent)
        local v4 = v2

        v4:onServerInvoke(function(p1, p2, ...) -- line: 28
            -- upvalues: Parent (copy), Modules (copy), Remote (copy), v3 (ref)
            local v5 = Parent.getTask(p2)

            if not v5 then
                return true, "Invalid taskUID"
            end

            local activeClientTasks = v5.activeClientTasks

            if typeof(activeClientTasks[p1.Name]) ~= "table" then
                return false, "Invalid permission to replicate"
            end

            local commandKey = v5.commandKey
            local replicator = v5.client.replicator

            if typeof(replicator) ~= "function" then
                return false, (("Command '%*' has no defined replicator"):format(commandKey))
            end

            local function checkCooldown(p3, p4, p5) -- line: 50
                -- upvalues: activeClientTasks (copy)
                local v7 = activeClientTasks[p3]
                local v8 = activeClientTasks[p3] or 0

                if p4 <= v8 then
                    return false, (("Only send requests every 0.25 seconds (%*)"):format(p3))
                end

                activeClientTasks[p3] = v8 + 1

                if not v7 then
                    task.delay(p5, function() -- line: 59
                        -- upvalues: p3 (copy), activeClientTasks (copy)
                        activeClientTasks[p3] = nil
                    end)
                end

                return true, "Success"
            end

            local Cooldown1 = activeClientTasks.Cooldown1
            local v10 = activeClientTasks.Cooldown1 or 0
            local v11, v12

            if v10 >= 4 then
                v11 = false
                v12 = "Only send requests every 0.25 seconds (Cooldown1)"
            else
                activeClientTasks.Cooldown1 = v10 + 1

                if not Cooldown1 then
                    local delay = task.delay
                    local v13 = "Cooldown1"

                    delay(0.2, function() -- line: 59
                        -- upvalues: activeClientTasks (copy), v13 (copy)
                        activeClientTasks[v13] = nil
                    end)
                end

                v11 = true
                v12 = "Success"
            end

            if not v11 then
                return false, v12
            end

            local Cooldown2 = activeClientTasks.Cooldown2
            local v14 = activeClientTasks.Cooldown2 or 0
            local v15, v16

            if v14 >= 15 then
                v15 = false
                v16 = "Only send requests every 0.25 seconds (Cooldown2)"
            else
                activeClientTasks.Cooldown2 = v14 + 1

                if not Cooldown2 then
                    local delay = task.delay
                    local v17 = "Cooldown2"

                    delay(2, function() -- line: 59
                        -- upvalues: activeClientTasks (copy), v17 (copy)
                        activeClientTasks[v17] = nil
                    end)
                end

                v15 = true
                v16 = "Success"
            end

            if not v15 then
                return false, v16
            end

            if require(Modules.VerifyUtil.getDataSize)({ ... }) > 250 then
                return false, (`Exceeded replicate data limit of {250} bytes`)
            end

            replicator(function(p6, ...) -- replicateTo | line: 78
                -- upvalues: commandKey (copy), Remote (copy), v3 (ref)
                v3 = v3 or Remote.new("ReplicateClientCommand", "Event", "Low")

                if v3 then
                    v3:fireClient(p6, commandKey, ...)
                end
            end, ...)

            return true, "Success"
        end)
    end
end

function t1.new(p7) -- line: 94
    -- upvalues: t1 (copy)
    local t2 = {
        replicator = nil,
        taskUID = p7
    }

    setmetatable(t2, t1)

    return t2
end

function t1.run(p8, p9, ...) -- line: 121
    -- upvalues: Remote (copy), RunService (copy), v1 (ref), setupReplicateListener (copy)
    if RunService:IsClient() then
        error("task.client should only be used on the server!")
    end

    local v19 = require(script.Parent).getTask(p8.taskUID)

    if not (p9 and v19 and v19.isActive) then
        return
    end

    v1 = v1 or Remote.new("RunClientCommand", "Event")

    local t3 = { ... }
    local t4 = {
        callerUserId = v19.callerUserId,
        targetUserId = v19.targetUserId,
        commandKey = v19.commandKey,
        UID = v19.UID,
        clientArgs = t3
    }

    if v1 then
        v19.activeClientTasks[p9.Name] = {}
        v1:fireClient(p9, t4)
    end

    setupReplicateListener()
end

function t1.runAll(p10, ...) -- line: 151
    -- upvalues: getTargets (copy)
    for _, v20 in (getTargets("All")) do
        p10:run(v20, ...)
    end
end

function t1.runOthers(p11, p12, ...) -- line: 158
    -- upvalues: getTargets (copy)
    for _, v21 in (getTargets("Others", p12)) do
        p11:run(v21, ...)
    end
end

function t1.runNearby(p13, p14, p15, ...) -- line: 165
    -- upvalues: getTargets (copy)
    for _, v22 in (getTargets("Nearby", p14, p15)) do
        p13:run(v22, ...)
    end
end

function t1._exposeInstances(_, p17, p18) -- line: 172
    local v23 = if typeof(p17) == "table" then p17 else { p17 }

    for _, v24 in v23 do
        if typeof(v24) == "Instance" then
            local Parent = v24.Parent

            if not p18 then
                return
            end

            v24.Parent = p18
            task.defer(function() -- line: 185
                -- upvalues: p18 (copy), v24 (copy), Parent (copy)
                if v24.Parent == p18 then
                    v24.Parent = Parent
                end
            end)
        end
    end
end

function t1.expose(p19, p20, p21) -- line: 193
    local PlayerGui = p20:FindFirstChildOfClass("PlayerGui")

    if PlayerGui then
        p19:_exposeInstances(p21, PlayerGui)
    end
end

function t1.exposeAll(p22, p23) -- line: 204
    p22:_exposeInstances(p23, (game:GetService("ReplicatedStorage")))
end

return t1
