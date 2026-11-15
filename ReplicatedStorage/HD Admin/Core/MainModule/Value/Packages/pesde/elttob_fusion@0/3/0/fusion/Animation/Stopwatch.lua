-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local checkLifetime = require(ParentParent.Memory.checkLifetime)
local depend = require(ParentParent.Graph.depend)
local change = require(ParentParent.Graph.change)
local peek = require(ParentParent.State.peek)
local nicknames = require(ParentParent.Utility.nicknames)
local t1 = {
    type = "State",
    kind = "Stopwatch",
    timeliness = "lazy"
}
local v1 = table.freeze({
    __index = t1
})

local function Stopwatch(p1, p2) -- line: 44
    -- upvalues: checkLifetime (copy), depend (copy), nicknames (copy), v1 (copy)
    local v2 = setmetatable({
        awake = true,
        lastChange = nil,
        validity = "invalid",
        _EXTREMELY_DANGEROUS_usedAsValue = 0,
        _measureTimeSince = 0,
        _playing = false,
        createdAt = os.clock(),
        dependencySet = {},
        dependentSet = {},
        scope = p1,
        _timer = p2
    }, v1)

    local function v3() -- line: 65
        -- upvalues: v2 (copy)
        v2.scope = nil
    end

    v2.oldestTask = v3
    nicknames[v2.oldestTask] = "Stopwatch"
    table.insert(p1, v3)
    checkLifetime.bOutlivesA(p1, v2.oldestTask, p2.scope, p2.oldestTask, checkLifetime.formatters.parameter, "timer")
    depend(v2, p2)

    return v2
end

function t1.zero(p3) -- line: 81
    -- upvalues: change (copy), peek (copy)
    local v4 = peek(p3._timer)

    if v4 == p3._measureTimeSince then
        return
    end

    p3._measureTimeSince = v4
    p3._EXTREMELY_DANGEROUS_usedAsValue = 0
    change(p3)
end

function t1.pause(p4) -- line: 92
    -- upvalues: change (copy)
    if p4._playing == true then
        p4._playing = false
        change(p4)
    end
end

function t1.unpause(p5) -- line: 101
    -- upvalues: change (copy), peek (copy)
    if p5._playing ~= false then
        return
    end

    p5._playing = true
    p5._measureTimeSince = peek(p5._timer) - p5._EXTREMELY_DANGEROUS_usedAsValue
    change(p5)
end

function t1._evaluate(p6) -- line: 111
    -- upvalues: depend (copy), peek (copy)
    if not p6._playing then
        return false
    end

    depend(p6, p6._timer)

    local v5 = peek(p6._timer)
    local _EXTREMELY_DANGEROUS_usedAsValue = p6._EXTREMELY_DANGEROUS_usedAsValue
    local v6 = v5 - p6._measureTimeSince

    p6._EXTREMELY_DANGEROUS_usedAsValue = v6

    return _EXTREMELY_DANGEROUS_usedAsValue ~= v6
end

table.freeze(t1)

return Stopwatch
