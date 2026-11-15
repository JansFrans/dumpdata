-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local checkLifetime = require(ParentParent.Memory.checkLifetime)
local depend = require(ParentParent.Graph.depend)
local change = require(ParentParent.Graph.change)
local evaluate = require(ParentParent.Graph.evaluate)
local castToState = require(ParentParent.State.castToState)
local peek = require(ParentParent.State.peek)
local ExternalTime = require(ParentParent.Animation.ExternalTime)
local Stopwatch = require(ParentParent.Animation.Stopwatch)
local packType = require(ParentParent.Animation.packType)
local unpackType = require(ParentParent.Animation.unpackType)
local springCoefficients = require(ParentParent.Animation.springCoefficients)
local nicknames = require(ParentParent.Utility.nicknames)
local t1 = {
    type = "State",
    kind = "Spring",
    timeliness = "eager"
}
local v1 = table.freeze({
    __index = t1
})

local function Spring(p1, p2, p3, p4) -- line: 60
    -- upvalues: External (copy), checkLifetime (copy), evaluate (copy), castToState (copy), peek (copy), ExternalTime (copy), Stopwatch (copy), nicknames (copy), v1 (copy)
    local elapsed = os.clock()

    if typeof(p1) ~= "table" or castToState(p1) ~= nil then
        External.logError("scopeMissing", nil, "Springs", "myScope:Spring(goalState, speed, damping)")
    end

    local v2 = castToState(p2)
    local v3

    if v2 ~= nil then
        v3 = Stopwatch(p1, ExternalTime(p1))
        v3:unpause()
    end

    p3 = p3 or 10
    p4 = p4 or 1

    local v6 = setmetatable({
        lastChange = nil,
        validity = "invalid",
        _activeDamping = -1,
        _activeGoal = nil,
        _activeNumSprings = 0,
        _activeSpeed = -1,
        _activeType = "",
        createdAt = elapsed,
        dependencySet = {},
        dependentSet = {},
        scope = p1,
        _activeLatestP = {},
        _activeLatestV = {},
        _activeStartP = {},
        _activeStartV = {},
        _activeTargetP = {},
        _damping = p4,
        _EXTREMELY_DANGEROUS_usedAsValue = peek(p2),
        _goal = p2,
        _speed = p3,
        _stopwatch = v3
    }, v1)

    local function v7() -- line: 107
        -- upvalues: v6 (copy)
        v6.scope = nil

        for v8 in pairs(v6.dependencySet) do
            v8.dependentSet[v6] = nil
        end
    end

    v6.oldestTask = v7
    nicknames[v6.oldestTask] = "Spring"
    table.insert(p1, v7)

    if v2 ~= nil then
        checkLifetime.bOutlivesA(p1, v6.oldestTask, v2.scope, v2.oldestTask, checkLifetime.formatters.animationGoal)
    end

    local v9 = castToState(p3)

    if v9 ~= nil then
        checkLifetime.bOutlivesA(p1, v6.oldestTask, v9.scope, v9.oldestTask, checkLifetime.formatters.parameter, "speed")
    end

    local v10 = castToState(p4)

    if v10 ~= nil then
        checkLifetime.bOutlivesA(p1, v6.oldestTask, v10.scope, v10.oldestTask, checkLifetime.formatters.parameter, "damping")
    end

    evaluate(v6, true)

    return v6
end

function t1.addVelocity(p5, p6) -- line: 148
    -- upvalues: External (copy), change (copy), evaluate (copy), unpackType (copy)
    evaluate(p5, false)

    local v11 = typeof(p6)

    if v11 ~= p5._activeType then
        External.logError("springTypeMismatch", nil, v11, p5._activeType)
    end

    local v12 = unpackType(p6, v11)

    for v13, v14 in p5._activeLatestV do
        v12[v13] += v14
    end

    p5._activeStartP = table.clone(p5._activeLatestP)
    p5._activeStartV = v12
    p5._stopwatch:zero()
    p5._stopwatch:unpause()
    change(p5)
end

function t1.get(_) -- line: 168
    -- upvalues: External (copy)
    return External.logError("stateGetWasRemoved")
end

function t1.setPosition(p8, p9) -- line: 174
    -- upvalues: External (copy), change (copy), evaluate (copy), unpackType (copy)
    evaluate(p8, false)

    local v15 = typeof(p9)

    if v15 ~= p8._activeType then
        External.logError("springTypeMismatch", nil, v15, p8._activeType)
    end

    p8._activeStartP = unpackType(p9, v15)
    p8._activeStartV = table.clone(p8._activeLatestV)
    p8._stopwatch:zero()
    p8._stopwatch:unpause()
    change(p8)
end

function t1.setVelocity(p10, p11) -- line: 190
    -- upvalues: External (copy), change (copy), evaluate (copy), unpackType (copy)
    evaluate(p10, false)

    local v16 = typeof(p11)

    if v16 ~= p10._activeType then
        External.logError("springTypeMismatch", nil, v16, p10._activeType)
    end

    p10._activeStartP = table.clone(p10._activeLatestP)
    p10._activeStartV = unpackType(p11, v16)
    p10._stopwatch:zero()
    p10._stopwatch:unpause()
    change(p10)
end

function t1._evaluate(p12) -- line: 206
    -- upvalues: External (copy), depend (copy), castToState (copy), peek (copy), packType (copy), unpackType (copy), springCoefficients (copy)
    local v17 = castToState(p12._goal)

    if v17 ~= nil then
        local v18 = peek(v17)

        if v18 == v18 then
            local v19 = typeof(v18)
            local v20 = v19 ~= p12._activeType
            local _stopwatch = p12._stopwatch
            local v21 = peek(_stopwatch)

            depend(p12, _stopwatch)

            local _EXTREMELY_DANGEROUS_usedAsValue = p12._EXTREMELY_DANGEROUS_usedAsValue
            local v22

            if v20 then
                v22 = v18
            elseif v21 <= 0 then
                v22 = _EXTREMELY_DANGEROUS_usedAsValue
            else
                local v23, v24, v25, v26 = springCoefficients(v21, p12._activeDamping, p12._activeSpeed)
                local _activeNumSprings = p12._activeNumSprings
                local v27 = false

                for i = 1, _activeNumSprings do
                    local v28 = p12._activeStartP[i]
                    local v29 = p12._activeTargetP[i]
                    local v30 = p12._activeStartV[i]
                    local v31 = v28 - v29
                    local v32 = v31 * v23 + v30 * v24
                    local v33 = v31 * v25 + v30 * v26

                    if v32 ~= v32 or v33 ~= v33 then
                        v32 = 0
                        v33 = 0
                        External.logWarn("springNanMotion")
                    end

                    if math.abs(v32) > 1E-05 or math.abs(v33) > 1E-05 then
                        v27 = true
                    end

                    local v34 = v32 + v29

                    p12._activeLatestP[i] = v34
                    p12._activeLatestV[i] = v33
                end

                if not v27 then
                    for i = 1, p12._activeNumSprings do
                        p12._activeLatestP[i] = p12._activeTargetP[i]
                    end
                end

                v22 = packType(p12._activeLatestP, p12._activeType)
            end

            local v35 = peek(p12._speed)
            local v36 = peek(p12._damping)

            if v20 or v18 ~= p12._activeGoal or v35 ~= p12._activeSpeed or v36 ~= p12._activeDamping then
                p12._activeTargetP = unpackType(v18, v19)
                p12._activeNumSprings = #p12._activeTargetP

                if v20 then
                    p12._activeStartP = table.clone(p12._activeTargetP)
                    p12._activeLatestP = table.clone(p12._activeTargetP)
                    p12._activeStartV = table.create(p12._activeNumSprings, 0)
                    p12._activeLatestV = table.create(p12._activeNumSprings, 0)
                else
                    p12._activeStartP = table.clone(p12._activeLatestP)
                    p12._activeStartV = table.clone(p12._activeLatestV)
                end

                p12._activeType = v19
                p12._activeGoal = v18
                p12._activeDamping = v36
                p12._activeSpeed = v35
                _stopwatch:zero()
                _stopwatch:unpause()
            end

            p12._EXTREMELY_DANGEROUS_usedAsValue = v22

            return _EXTREMELY_DANGEROUS_usedAsValue ~= v22
        end

        External.logWarn("springNanGoal")
    else
        p12._EXTREMELY_DANGEROUS_usedAsValue = p12._goal
    end

    return false
end

table.freeze(t1)

return Spring
