-- https://lua.expert

local FastDefer = require(script.FastDefer)
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 15
        return "linkToInstanceIndex"
    end
})
local t3 = {
    ClassName = "Janitor",
    CurrentlyCleaning = true,
    SuppressInstanceReDestroy = false,
    UnsafeThreadCleanup = false
}

t3.__index = t3

local self2 = setmetatable({}, {
    __mode = "ks"
})
local t6 = {
    ["function"] = true,
    thread = true,
    RBXScriptConnection = "Disconnect"
}

function t3.new() -- line: 157
    -- upvalues: t3 (copy)
    return (setmetatable({
        CurrentlyCleaning = false
    }, t3))
end

function t3.Is(p1) -- line: 170
    -- upvalues: t3 (copy)
    if type(p1) == "table" then
        return getmetatable(p1) == t3
    end

    return false
end

t3.instanceof = t3.Is

local Destroy = game.Destroy
local connection = script:GetPropertyChangedSignal("Parent"):Once(function() -- line: 187
end)
local Disconnect = connection.Disconnect

connection:Disconnect()

local function Remove(p2, p3) -- line: 194
    -- upvalues: FastDefer (copy), self2 (copy), Destroy (copy), Disconnect (copy)
    local v3 = self2[p2]

    if v3 then
        local v4 = v3[p3]

        if not v4 then
            return p2
        end

        local v5 = p2[v4]

        if v5 then
            if v5 == true then
                if type(v4) == "function" then
                    v4()
                elseif coroutine.running() == v4 then
                    if p2.UnsafeThreadCleanup then
                        FastDefer(function() -- line: 219
                            -- upvalues: v4 (copy)
                            task.cancel(v4)
                        end)
                    else
                        task.defer(function() -- line: 223
                            -- upvalues: v4 (copy)
                            task.cancel(v4)
                        end)
                    end
                else
                    local function v6() -- line: 211
                        -- upvalues: v4 (copy)
                        task.cancel(v4)
                    end

                    if not pcall(v6) then
                        if p2.UnsafeThreadCleanup then
                            FastDefer(function() -- line: 219
                                -- upvalues: v4 (copy)
                                task.cancel(v4)
                            end)
                        else
                            task.defer(function() -- line: 223
                                -- upvalues: v4 (copy)
                                task.cancel(v4)
                            end)
                        end
                    end
                end
            elseif v5 == "Destroy" then
                if p2.SuppressInstanceReDestroy and typeof(v4) == "Instance" then
                    pcall(Destroy, v4)
                else
                    local Destroy = v4.Destroy

                    if Destroy then
                        Destroy(v4)
                    else
                        Destroy = v4.destroy

                        if Destroy then
                            Destroy(v4)
                        end
                    end
                end
            elseif v5 == "Disconnect" then
                Disconnect(v4)
            else
                local v7 = v4[v5]

                if v7 then
                    v7(v4)
                end
            end

            p2[v4] = nil
        end

        v3[p3] = nil
    end

    return p2
end

t3.remove = t3.Remove

local function add(p4, p5, p6, p7) -- line: 261
    -- upvalues: self2 (copy), t6 (copy), Remove (copy)
    if p7 then
        Remove(p4, p7)

        local v8 = self2[p4]

        if not v8 then
            v8 = {}
            self2[p4] = v8
        end

        v8[p7] = p5
    end

    local v9 = typeof(p5)

    p6 = p6 or t6[v9] or "Destroy"

    if v9 == "function" or v9 == "thread" then
        if p6 ~= true then
            warn(string.format("Object is a %* and as such expected `true?` for the method name and instead got %*. Traceback: %*", v9, tostring(p6), debug.traceback(nil, 2)))
        end
    elseif not p5[p6] and not p5.destroy then
        warn(string.format("Object %* doesn't have method %*, are you sure you want to add it? Traceback: %*", tostring(p5), tostring(p6), debug.traceback(nil, 2)))
    end

    p4[p5] = p6

    return p5
end

t3.add = add

function t3.addObject(p8, p9, p10, p11, ...) -- line: 414
    -- upvalues: add (copy)
    return (add(p8, p9.new(...), p10, p11))
end

local function Get(p12, p13) -- line: 418
    -- upvalues: self2 (copy)
    local v11 = self2[p12]

    return if v11 then v11[p13] else nil
end

t3.get = Get
t3.Get = Get
t3.Remove = Remove

function t3.removeNoClean(p14, p15) -- line: 517
    -- upvalues: self2 (copy)
    local v12 = self2[p14]

    if v12 then
        local v13 = v12[p15]

        if v13 then
            p14[v13] = nil
            v12[p15] = nil
        end
    end

    return p14
end

function t3.removeList(p16, ...) -- line: 572
    -- upvalues: self2 (copy), Remove (copy)
    if not self2[p16] then
        return p16
    end

    local v14 = select("#", ...)

    if v14 == 1 then
        return (Remove(p16, ...))
    end

    if v14 == 2 then
        local v15, v16 = ...

        Remove(p16, v15)
        Remove(p16, v16)

        return p16
    end

    if v14 == 3 then
        local v17, v18, v19 = ...

        Remove(p16, v17)
        Remove(p16, v18)
        Remove(p16, v19)

        return p16
    end

    for i = 1, v14 do
        Remove(p16, (select(i, ...)))
    end

    return p16
end

function t3.removeListNoClean(p17, ...) -- line: 643
    -- upvalues: self2 (copy)
    local v21 = self2[p17]

    if v21 then
        local v22 = select("#", ...)

        if v22 == 1 then
            local v23 = ...
            local v24 = v21[v23]

            if v24 then
                p17[v24] = nil
                v21[v23] = nil
            end

            return p17
        end

        if v22 == 2 then
            local v25, v26 = ...
            local v27 = v21[v25]

            if v27 then
                p17[v27] = nil
                v21[v25] = nil
            end

            local v28 = v21[v26]

            if v28 then
                p17[v28] = nil
                v21[v26] = nil
            end

            return p17
        end

        if v22 == 3 then
            local v29, v30, v31 = ...
            local v32 = v21[v29]

            if v32 then
                p17[v32] = nil
                v21[v29] = nil
            end

            local v33 = v21[v30]

            if v33 then
                p17[v33] = nil
                v21[v30] = nil
            end

            local v34 = v21[v31]

            if v34 then
                p17[v34] = nil
                v21[v31] = nil
            end

            return p17
        end

        for i = 1, v22 do
            local v35 = select(i, ...)
            local v36 = v21[v35]

            if v36 then
                p17[v36] = nil
                v21[v35] = nil
            end
        end
    end

    return p17
end

function t3.getAll(p18) -- line: 728
    -- upvalues: self2 (copy)
    local v37 = self2[p18]

    if v37 then
        return (table.freeze(table.clone(v37)))
    end

    return {}
end

local function cleanup(p19) -- line: 756
    -- upvalues: FastDefer (copy), self2 (copy), Destroy (copy), Disconnect (copy)
    if p19.CurrentlyCleaning then
        return
    end

    local SuppressInstanceReDestroy, UnsafeThreadCleanup = p19.SuppressInstanceReDestroy, p19.UnsafeThreadCleanup

    p19.CurrentlyCleaning = nil
    p19.SuppressInstanceReDestroy = nil
    p19.UnsafeThreadCleanup = nil

    local v38, v39 = next(p19)

    while v38 and v39 do
        if v39 == true then
            if type(v38) == "function" then
                v38()
            elseif coroutine.running() == v38 then
                local v41 = v38

                if UnsafeThreadCleanup then
                    FastDefer(function() -- line: 781
                        -- upvalues: v41 (copy)
                        task.cancel(v41)
                    end)
                else
                    task.defer(function() -- line: 785
                        -- upvalues: v41 (copy)
                        task.cancel(v41)
                    end)
                end
            else
                local function v42() -- line: 773
                    -- upvalues: v38 (ref)
                    task.cancel(v38)
                end

                if not pcall(v42) then
                    local v43 = v38

                    if UnsafeThreadCleanup then
                        FastDefer(function() -- line: 781
                            -- upvalues: v43 (copy)
                            task.cancel(v43)
                        end)
                    else
                        task.defer(function() -- line: 785
                            -- upvalues: v43 (copy)
                            task.cancel(v43)
                        end)
                    end
                end
            end
        elseif v39 == "Destroy" then
            if p19.SuppressInstanceReDestroy then
                if typeof(v38) == "Instance" then
                    local v45 = v38

                    pcall(Destroy, v45)
                else
                    local v46 = v38
                    local Destroy = v46.Destroy

                    if Destroy then
                        Destroy(v38)
                    else
                        local v47 = v38

                        Destroy = v47.destroy

                        if Destroy then
                            Destroy(v38)
                        end
                    end
                end
            else
                local v48 = v38
                local Destroy = v48.Destroy

                if Destroy then
                    Destroy(v38)
                else
                    local v49 = v38

                    Destroy = v49.destroy

                    if Destroy then
                        Destroy(v38)
                    end
                end
            end
        elseif v39 == "Disconnect" then
            Disconnect(v38)
        else
            local v50 = v38[v39]

            if v50 then
                v50(v38)
            end
        end

        p19[v38] = nil
        v38, v39 = next(p19, v38)
    end

    local v51 = self2[p19]

    if v51 then
        table.clear(v51)
        self2[p19] = nil
    end

    p19.CurrentlyCleaning = false
    p19.SuppressInstanceReDestroy = SuppressInstanceReDestroy
    p19.UnsafeThreadCleanup = UnsafeThreadCleanup
end

t3.cleanup = cleanup

function t3.Destroy(p20) -- line: 836
    -- upvalues: cleanup (copy)
    cleanup(p20)
    table.clear(p20)
    setmetatable(p20, nil)
end

t3.destroy = t3.Destroy
t3.__call = cleanup

local function linkToInstance(p21, p22, p23) -- line: 845
    -- upvalues: self (copy), add (copy), cleanup (copy)
    local v52 = if p23 then newproxy(false) else self

    return (add(p21, p22.Destroying:Connect(function() -- line: 848
        -- upvalues: p21 (copy), cleanup (copy)
        cleanup(p21)
    end), "Disconnect", v52))
end

t3.linkToInstance = linkToInstance
t3.LegacylinkToInstance = linkToInstance

function t3.linkToInstances(p24, ...) -- line: 911
    -- upvalues: t3 (copy), linkToInstance (copy)
    local v53 = t3.new()

    for i = 1, select("#", ...) do
        local v54 = select(i, ...)

        if typeof(v54) == "Instance" then
            v53:add(linkToInstance(p24, v54, true), "Disconnect")
        end
    end

    return v53
end

function t3.__tostring(_) -- line: 925
    return "Janitor"
end

return t3
