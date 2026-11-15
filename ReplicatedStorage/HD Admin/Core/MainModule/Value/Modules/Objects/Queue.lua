-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Janitor = require(Modules.Objects.Janitor)
local Signal = require(Modules.Objects.Signal)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 11
    -- upvalues: Janitor (copy), Signal (copy), t1 (copy)
    local v1 = Janitor.new()
    local t2 = {
        sortEveryCall = false,
        sortCooldown = 0.5,
        processing = false,
        isSorting = false,
        isRequestingSort = false,
        hasStarted = false,
        isActive = true,
        sortByFunction = nil,
        janitor = v1,
        callbackGroups = {},
        sorted = v1:add(Signal.new()),
        started = v1:add(Signal.new()),
        ended = v1:add(Signal.new())
    }

    t2.sorted:Fire()
    setmetatable(t2, t1)

    return t2
end

function t1.requestSort(p1) -- line: 44
    local sortByFunction = p1.sortByFunction

    if not sortByFunction then
        return
    end

    local function sort() -- line: 47
        -- upvalues: p1 (copy), sortByFunction (copy), sort (copy)
        if p1.isSorting then
            p1.isRequestingSort = true
        else
            p1.isSorting = true
            table.sort(p1.callbackGroups, sortByFunction)
            p1.sorted:Fire(p1.callbackGroups)
            task.delay(p1.sortCooldown, function() -- line: 54
                -- upvalues: p1 (copy), sort (copy)
                p1.isSorting = false

                if p1.isRequestingSort then
                    p1.isRequestingSort = false
                    sort()
                end
            end)
        end
    end

    sort()
end

function t1._add(p2, _, p4, p5) -- line: 67
    local newCallback

    if p2.sortEveryCall then
        function newCallback() -- line: 70
            -- upvalues: p2 (copy), p4 (copy)
            p2:requestSort()
            p4()
        end
    else
        newCallback = p4
    end

    table.insert(p2.callbackGroups, {
        newCallback,
        p5
    })
    p2:requestSort()
    task.spawn(function() -- line: 78
        -- upvalues: p2 (copy)
        p2:next()
    end)
end

function t1.add(p6, p7, p8) -- line: 83
    p6:_add(nil, p7, p8)
end

function t1.customAdd(p9, p10, p11, p12) -- line: 87
    p9:_add(p10, p11, p12)
end

function t1.sortBy(p13, p14) -- line: 91
    p13.sortByFunction = p14
end

function t1.sortByEveryCall(p15, p16, p17) -- line: 95
    p15.sortEveryCall = true
    p15.sortCooldown = p16 or p15.sortCooldown
    p15:sortBy(p17)
    task.defer(function() -- line: 99
        -- upvalues: p15 (copy)
        p15:requestSort()
    end)
end

function t1.getSize(p18) -- line: 104
    return #p18.callbackGroups
end

function t1.next(p19) -- line: 108
    if p19.processing or p19.isActive == false then
        return
    end

    local v2 = p19.callbackGroups[1]

    if not v2 then
        p19.hasStarted = false
        p19.ended:Fire()

        return
    end

    if not p19.hasStarted then
        local started = p19.started

        p19.hasStarted = true
        started:Fire()
    end

    p19.processing = true

    local v3 = v2[1]

    table.remove(p19.callbackGroups, 1)
    v3()
    p19.processing = false
    p19:next()
end

function t1.completeAsync(p20) -- line: 131
    local callbackGroups = p20.callbackGroups

    p20.callbackGroups = {}

    local n1 = 0

    for _, v4 in callbackGroups do
        local v5 = v4[1]

        n1 += 1
        task.spawn(function() -- line: 138
            -- upvalues: n1 (ref), v5 (copy)
            v5()
            n1 -= 1
        end)
    end

    task.delay(2, function() -- line: 143
        -- upvalues: n1 (ref)
        n1 = 0
    end)

    while n1 > 0 do
        task.wait()
    end
end

function t1.clear(p21) -- line: 151
    p21.callbackGroups = {}
end

function t1.destroy(p22) -- line: 155
    if p22.isActive == false then
        return
    end

    p22.isActive = false
    p22.callbackGroups = {}
    p22.janitor:destroy()
end

return t1
