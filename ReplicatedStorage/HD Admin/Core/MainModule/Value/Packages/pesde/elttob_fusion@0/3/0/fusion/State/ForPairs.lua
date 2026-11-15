-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local For = require(ParentParent.State.For)
local Value = require(ParentParent.State.Value)
local Computed = require(ParentParent.State.Computed)

require(ParentParent.State.For.ForTypes)

local parseError = require(ParentParent.Logging.parseError)
local doCleanup = require(ParentParent.Memory.doCleanup)
local t1 = {
    __index = {
        roamKeys = false,
        roamValues = false,
        invalidateInputKey = function(p1) -- invalidateInputKey | line: 33
            p1._inputKeyState:set(p1.inputKey)
        end,
        invalidateInputValue = function(p2) -- invalidateInputValue | line: 36
            p2._inputValueState:set(p2.inputValue)
        end,
        useOutputPair = function(p3, p4) -- useOutputPair | line: 39
            local v1 = p4(p3._outputPairState)

            return v1.key, v1.value
        end
    }
}

local function SubObject(p5, p6, p7, p8) -- line: 46
    -- upvalues: External (copy), Value (copy), Computed (copy), parseError (copy), doCleanup (copy), t1 (copy)
    local t2 = {
        maybeScope = p5,
        inputKey = p6,
        inputValue = p7,
        _inputKeyState = Value(p5, p6),
        _inputValueState = Value(p5, p7),
        _processor = p8
    }

    t2._outputPairState = Computed(p5, function(p9, p10) -- line: 59
        -- upvalues: t2 (copy), External (copy), parseError (copy), doCleanup (copy)
        local v2 = p9(t2._inputKeyState)
        local v3 = p9(t2._inputValueState)
        local _processor = t2._processor
        local v4, v5, v6 = xpcall(_processor, parseError, p9, p10, v2, v3)

        if v4 then
            return {
                key = v5,
                value = v6
            }
        end

        v5.context = ("while processing key %* and value %*"):format(tostring(v3), (tostring(v3)))
        External.logErrorNonFatal("callbackError", v5)
        doCleanup(p10)
        table.clear(p10)

        return {
            key = nil,
            value = nil
        }
    end)

    return (setmetatable(t2, t1))
end

local function ForPairs(p11, p12, p13, p14) -- line: 77
    -- upvalues: External (copy), For (copy), SubObject (copy)
    if typeof(p12) == "function" then
        External.logError("scopeMissing", nil, "ForPairs", "myScope:ForPairs(inputTable, function(scope, use, key, value) ... end)")
    elseif p14 ~= nil then
        External.logWarn("destructorRedundant", "ForPairs")
    end

    return For(p11, p12, function(p15, p16, p17) -- line: 91
        -- upvalues: p13 (copy), SubObject (copy)
        return (SubObject(p15, p16, p17, p13))
    end)
end

return ForPairs
