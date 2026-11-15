-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local checkLifetime = require(ParentParent.Memory.checkLifetime)
local castToState = require(ParentParent.State.castToState)
local t1 = {}

local function Out(p1) -- line: 21
    -- upvalues: External (copy), checkLifetime (copy), castToState (copy), t1 (copy)
    local v1 = t1[p1]

    if v1 == nil then
        v1 = {
            type = "SpecialKey",
            kind = "Out",
            stage = "observer"
        }

        function v1.apply(_, p3, p4, p5) -- line: 30
            -- upvalues: p1 (copy), External (copy), checkLifetime (copy), castToState (copy)
            local GetPropertyChangedSignal = p5.GetPropertyChangedSignal
            local ok, result = pcall(GetPropertyChangedSignal, p5, p1)

            if not ok then
                External.logError("invalidOutProperty", nil, p5.ClassName, p1)
            end

            if not castToState(p4) then
                External.logError("invalidOutType")
            end

            if p4.kind ~= "Value" then
                External.logError("invalidOutType")
            end

            checkLifetime.bOutlivesA(p3, p5, p4.scope, p4.oldestTask, checkLifetime.formatters.propertyOutputsTo, p1)
            p4:set(p5[p1])
            table.insert(p3, result:Connect(function() -- line: 58
                -- upvalues: p4 (copy), p5 (copy), p1 (copy)
                p4:set(p5[p1])
            end))
        end

        t1[p1] = v1
    end

    return v1
end

return Out
