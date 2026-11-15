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
        roamKeys = true,
        roamValues = false,
        invalidateInputKey = function(_) -- invalidateInputKey | line: 33
        end,
        invalidateInputValue = function(p2) -- invalidateInputValue | line: 36
            p2._inputValueState:set(p2.inputValue)
        end,
        useOutputPair = function(p3, p4) -- useOutputPair | line: 39
            return p3.inputKey, p4(p3._outputValueState)
        end
    }
}

local function SubObject(p5, p6, p7, p8) -- line: 45
    -- upvalues: External (copy), Value (copy), Computed (copy), parseError (copy), doCleanup (copy), t1 (copy)
    local t2 = {
        maybeScope = p5,
        inputKey = p6,
        inputValue = p7,
        _inputValueState = Value(p5, p7),
        _processor = p8
    }

    t2._outputValueState = Computed(p5, function(p9, p10) -- line: 57
        -- upvalues: t2 (copy), External (copy), parseError (copy), doCleanup (copy)
        local v1 = p9(t2._inputValueState)
        local _processor = t2._processor
        local v2, v3 = xpcall(_processor, parseError, p9, p10, v1)

        if v2 then
            return v3
        end

        v3.context = ("while processing value %*"):format((tostring(v1)))
        External.logErrorNonFatal("callbackError", v3)
        doCleanup(p10)
        table.clear(p10)

        return nil
    end)

    return (setmetatable(t2, t1))
end

local function ForValues(p11, p12, p13, p14) -- line: 74
    -- upvalues: External (copy), For (copy), SubObject (copy)
    if typeof(p12) == "function" then
        External.logError("scopeMissing", nil, "ForValues", "myScope:ForValues(inputTable, function(scope, use, value) ... end)")
    elseif p14 ~= nil then
        External.logWarn("destructorRedundant", "ForValues")
    end

    return For(p11, p12, function(p15, p16, p17) -- line: 88
        -- upvalues: p13 (copy), SubObject (copy)
        return (SubObject(p15, p16, p17, p13))
    end)
end

return ForValues
