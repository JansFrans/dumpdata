-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local checkLifetime = require(ParentParent.Memory.checkLifetime)
local castToGraph = require(ParentParent.Graph.castToGraph)
local depend = require(ParentParent.Graph.depend)
local evaluate = require(ParentParent.Graph.evaluate)
local nicknames = require(ParentParent.Utility.nicknames)
local t1 = {
    type = "Observer",
    timeliness = "eager",
    dependentSet = table.freeze({})
}
local v1 = table.freeze({
    __index = t1
})

local function Observer(p1, p2) -- line: 36
    -- upvalues: External (copy), checkLifetime (copy), castToGraph (copy), evaluate (copy), nicknames (copy), v1 (copy)
    local elapsed = os.clock()

    if p2 == nil then
        External.logError("scopeMissing", nil, "Observers", "myScope:Observer(watching)")
    end

    local v2 = setmetatable({
        lastChange = nil,
        validity = "invalid",
        scope = p1,
        createdAt = elapsed,
        dependencySet = {},
        _watchingGraph = castToGraph(p2),
        _changeListeners = {}
    }, v1)

    local function v3() -- line: 57
        -- upvalues: v2 (copy)
        v2.scope = nil

        for v4 in pairs(v2.dependencySet) do
            v4.dependentSet[v2] = nil
        end
    end

    v2.oldestTask = v3
    nicknames[v2.oldestTask] = "Observer"
    table.insert(p1, v3)

    if v2._watchingGraph ~= nil then
        checkLifetime.bOutlivesA(p1, v2.oldestTask, v2._watchingGraph.scope, v2._watchingGraph.oldestTask, checkLifetime.formatters.observer)
    end

    evaluate(v2, true)

    return v2
end

function t1.onBind(p3, p4) -- line: 82
    -- upvalues: External (copy)
    External.doTaskImmediate(p4)

    return p3:onChange(p4)
end

function t1.onChange(p5, p6) -- line: 90
    local v5 = table.freeze({})

    p5._changeListeners[v5] = p6

    return function() -- line: 96
        -- upvalues: p5 (copy), v5 (copy)
        p5._changeListeners[v5] = nil
    end
end

function t1._evaluate(p7) -- line: 101
    -- upvalues: External (copy), depend (copy)
    if p7._watchingGraph ~= nil then
        depend(p7, p7._watchingGraph)
    end

    for _, v6 in p7._changeListeners do
        External.doTaskImmediate(v6)
    end

    return true
end

table.freeze(t1)

return Observer
