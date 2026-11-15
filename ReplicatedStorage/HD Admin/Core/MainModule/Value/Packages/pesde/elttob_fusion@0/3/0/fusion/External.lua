-- https://lua.expert

local Parent = script.Parent
local formatError = require(Parent.Logging.formatError)

require(Parent.Types)

local t1 = {
    safetyTimerMultiplier = 1
}
local t2 = {}
local v1
local n1 = 0

function t1.setExternalProvider(p1) -- line: 36
    -- upvalues: v1 (ref)
    local v2 = v1

    if v2 ~= nil then
        v2.stopScheduler()
    end

    v1 = p1

    if p1 ~= nil then
        p1.startScheduler()
    end

    return v2
end

function t1.isTimeCritical() -- line: 53
    return false
end

function t1.doTaskImmediate(p2) -- line: 60
    -- upvalues: t1 (copy), v1 (ref)
    if v1 ~= nil then
        v1.doTaskImmediate(p2)
    else
        t1.logError("noTaskScheduler")
    end
end

function t1.doTaskDeferred(p3) -- line: 73
    -- upvalues: t1 (copy), v1 (ref)
    if v1 ~= nil then
        v1.doTaskDeferred(p3)
    else
        t1.logError("noTaskScheduler")
    end
end

function t1.logError(p4, p5, ...) -- line: 86
    -- upvalues: formatError (copy), v1 (ref)
    error(formatError(v1, p4, p5, ...), 0)
end

function t1.logErrorNonFatal(p6, p7, ...) -- line: 97
    -- upvalues: formatError (copy), v1 (ref)
    local v3 = formatError(v1, p6, p7, ...)

    if v1 ~= nil then
        v1.logErrorNonFatal(v3)
    else
        print(v3)
    end
end

function t1.logWarn(p8, ...) -- line: 113
    -- upvalues: formatError (copy), v1 (ref)
    local v4 = formatError(v1, p8, debug.traceback(nil, 2), ...)

    if v1 ~= nil then
        v1.logWarn(v4)
    else
        print(v4)
    end
end

function t1.bindToUpdateStep(p9) -- line: 135
    -- upvalues: t2 (copy)
    local t3 = {}

    t2[t3] = p9

    return function() -- line: 142
        -- upvalues: t3 (copy), t2 (copy)
        t2[t3] = nil
    end
end

function t1.performUpdateStep(p10) -- line: 152
    -- upvalues: t2 (copy), n1 (ref)
    n1 = p10

    for _, v5 in t2 do
        v5(p10)
    end
end

function t1.lastUpdateStep() -- line: 164
    -- upvalues: n1 (ref)
    return n1
end

return t1
