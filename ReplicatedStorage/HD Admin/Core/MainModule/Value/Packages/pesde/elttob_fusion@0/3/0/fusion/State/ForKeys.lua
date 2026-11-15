-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local doCleanup = require(ParentParent.Memory.doCleanup)
local For = require(ParentParent.State.For)
local Value = require(ParentParent.State.Value)
local Computed = require(ParentParent.State.Computed)

require(ParentParent.State.For.ForTypes)

local parseError = require(ParentParent.Logging.parseError)
local t1 = {
    __index = {
        roamKeys = false,
        roamValues = true,
        invalidateInputKey = function(p1) -- invalidateInputKey | line: 33
            p1._inputKeyState:set(p1.inputKey)
        end,
        invalidateInputValue = function(_) -- invalidateInputValue | line: 36
        end,
        useOutputPair = function(p3, p4) -- useOutputPair | line: 39
            return p4(p3._outputKeyState), p3.inputValue
        end
    }
}

local function SubObject(p5, p6, p7, p8) -- line: 45
    -- upvalues: External (copy), doCleanup (copy), Value (copy), Computed (copy), parseError (copy), t1 (copy)
    local t2 = {
        maybeScope = p5,
        inputKey = p6,
        inputValue = p7,
        _inputKeyState = Value(p5, p6),
        _processor = p8
    }

    t2._outputKeyState = Computed(p5, function(p9, p10) -- line: 57
        -- upvalues: t2 (copy), External (copy), doCleanup (copy), parseError (copy)
        local v1 = p9(t2._inputKeyState)
        local _processor = t2._processor
        local v2, v3 = xpcall(_processor, parseError, p9, p10, v1)

        if v2 then
            return v3
        end

        v3.context = ("while processing key %*"):format((tostring(v1)))
        External.logErrorNonFatal("callbackError", v3)
        doCleanup(p10)
        table.clear(p10)

        return nil
    end)

    return (setmetatable(t2, t1))
end

local function ForKeys(p11, p12, p13, p14) -- line: 74
    -- upvalues: External (copy), For (copy), SubObject (copy)
    if typeof(p12) == "function" then
        External.logError("scopeMissing", nil, "ForKeys", "myScope:ForKeys(inputTable, function(scope, use, key) ... end)")
    elseif p14 ~= nil then
        External.logWarn("destructorRedundant", "ForKeys")
    end

    return For(p11, p12, function(p15, p16, p17) -- line: 88
        -- upvalues: p13 (copy), SubObject (copy)
        return (SubObject(p15, p16, p17, p13))
    end)
end

return ForKeys
