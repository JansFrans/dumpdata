-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local parseError = require(ParentParent.Logging.parseError)
local t1 = {
    type = "Contextual"
}
local v1 = table.freeze({
    __index = t1
})
local v2 = table.freeze({
    __mode = "k"
})

local function Contextual(p1) -- line: 28
    -- upvalues: v1 (copy), v2 (copy)
    return (setmetatable({
        _valuesNow = setmetatable({}, v2),
        _defaultValue = p1
    }, v1))
end

function t1.now(p2) -- line: 48
    local thread = coroutine.running()
    local v3 = p2._valuesNow[thread]

    if typeof(v3) == "table" then
        return v3.value
    end

    return p2._defaultValue
end

function t1.is(p3, p4) -- line: 63
    -- upvalues: External (copy), parseError (copy)
    return {
        during = function(_, p6, ...) -- during | line: 69
            -- upvalues: p3 (copy), p4 (copy), External (copy), parseError (copy)
            local thread = coroutine.running()
            local v4 = p3._valuesNow[thread]

            p3._valuesNow[thread] = {
                value = p4
            }

            local v5, v6 = xpcall(p6, parseError, ...)

            p3._valuesNow[thread] = v4

            if not v5 then
                External.logError("callbackError", v6)
            end

            return v6
        end
    }
end

table.freeze(t1)

return Contextual
