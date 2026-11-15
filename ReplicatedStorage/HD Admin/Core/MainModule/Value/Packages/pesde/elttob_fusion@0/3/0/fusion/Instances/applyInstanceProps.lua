-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local parseError = require(ParentParent.Logging.parseError)
local checkLifetime = require(ParentParent.Memory.checkLifetime)
local Observer = require(ParentParent.Graph.Observer)
local castToState = require(ParentParent.State.castToState)
local peek = require(ParentParent.State.peek)
local xtypeof = require(ParentParent.Utility.xtypeof)

local function setProperty_unsafe(p1, p2, p3) -- line: 34
    p1[p2] = p3
end

local function testPropertyAssignable(p4, p5) -- line: 42
    p4[p5] = p4[p5]
end

local function setProperty(p6, p7, p8) -- line: 49
    -- upvalues: External (copy), parseError (copy), setProperty_unsafe (copy), testPropertyAssignable (copy)
    local v1, v2 = xpcall(setProperty_unsafe, parseError, p6, p7, p8)

    if v1 then
        return
    end

    if not pcall(testPropertyAssignable, p6, p7) then
        External.logErrorNonFatal("cannotAssignProperty", nil, p6.ClassName, p7)
    else
        local v3 = typeof(p8)
        local v5 = typeof(p6[p7])

        if v3 == v5 then
            External.logErrorNonFatal("propertySetError", v2)
        else
            External.logErrorNonFatal("invalidPropertyType", nil, p6.ClassName, p7, v5, v3)
        end
    end
end

local function bindProperty(p9, p10, p11, p12) -- line: 74
    -- upvalues: checkLifetime (copy), Observer (copy), castToState (copy), peek (copy), setProperty (copy)
    if castToState(p12) then
        checkLifetime.bOutlivesA(p9, p10, p12.scope, p12.oldestTask, checkLifetime.formatters.boundProperty, p11)
        Observer(p9, p12):onBind(function() -- line: 88
            -- upvalues: p10 (copy), p11 (copy), p12 (copy), peek (copy), setProperty (copy)
            setProperty(p10, p11, peek(p12))
        end)
    else
        setProperty(p10, p11, p12)
    end
end

local function applyInstanceProps(p13, p14, p15) -- line: 97
    -- upvalues: External (copy), xtypeof (copy), bindProperty (copy)
    local t1 = {
        self = {},
        descendants = {},
        ancestor = {},
        observer = {}
    }

    for v6, v7 in pairs(p14) do
        local v8 = xtypeof(v6)

        if v8 == "string" then
            if v6 ~= "Parent" then
                bindProperty(p13, p15, v6, v7)
            end
        elseif v8 == "SpecialKey" then
            local stage = v6.stage
            local v9 = t1[stage]

            if v9 ~= nil then
                v9[v6] = v7
            else
                External.logError("unrecognisedPropertyStage", nil, stage)
            end
        else
            External.logError("unrecognisedPropertyKey", nil, v8)
        end
    end

    for v10, v11 in pairs(t1.self) do
        v10:apply(p13, v11, p15)
    end

    for v12, v13 in pairs(t1.descendants) do
        v12:apply(p13, v13, p15)
    end

    if p14.Parent ~= nil then
        bindProperty(p13, p15, "Parent", p14.Parent)
    end

    for v14, v15 in pairs(t1.ancestor) do
        v14:apply(p13, v15, p15)
    end

    for v16, v17 in pairs(t1.observer) do
        v16:apply(p13, v17, p15)
    end
end

return applyInstanceProps
