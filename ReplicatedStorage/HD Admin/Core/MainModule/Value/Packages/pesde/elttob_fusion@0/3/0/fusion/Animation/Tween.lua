-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local checkLifetime = require(ParentParent.Memory.checkLifetime)
local depend = require(ParentParent.Graph.depend)
local evaluate = require(ParentParent.Graph.evaluate)
local castToState = require(ParentParent.State.castToState)
local peek = require(ParentParent.State.peek)
local ExternalTime = require(ParentParent.Animation.ExternalTime)
local Stopwatch = require(ParentParent.Animation.Stopwatch)
local lerpType = require(ParentParent.Animation.lerpType)
local getTweenRatio = require(ParentParent.Animation.getTweenRatio)
local getTweenDuration = require(ParentParent.Animation.getTweenDuration)
local nicknames = require(ParentParent.Utility.nicknames)
local t1 = {
    type = "State",
    kind = "Tween",
    timeliness = "eager"
}
local v1 = table.freeze({
    __index = t1
})

local function Tween(p1, p2, p3) -- line: 51
    -- upvalues: External (copy), checkLifetime (copy), evaluate (copy), castToState (copy), peek (copy), ExternalTime (copy), Stopwatch (copy), nicknames (copy), v1 (copy)
    local elapsed = os.clock()

    if castToState(p1) then
        External.logError("scopeMissing", nil, "Tweens", "myScope:Tween(goalState, tweenInfo)")
    end

    local v2 = castToState(p2)
    local v3 = if v2 == nil then nil else Stopwatch(p1, ExternalTime(p1))
    local v4 = setmetatable({
        lastChange = nil,
        validity = "invalid",
        _activeDuration = nil,
        _activeElapsed = nil,
        _activeFrom = nil,
        _activeTo = nil,
        _activeTweenInfo = nil,
        createdAt = elapsed,
        dependencySet = {},
        dependentSet = {},
        scope = p1,
        _EXTREMELY_DANGEROUS_usedAsValue = peek(p2),
        _goal = p2,
        _stopwatch = v3,
        _tweenInfo = p3 or TweenInfo.new()
    }, v1)

    local function v5() -- line: 87
        -- upvalues: v4 (copy)
        v4.scope = nil

        for v6 in pairs(v4.dependencySet) do
            v6.dependentSet[v4] = nil
        end
    end

    v4.oldestTask = v5
    nicknames[v4.oldestTask] = "Tween"
    table.insert(p1, v5)

    if v2 ~= nil then
        checkLifetime.bOutlivesA(p1, v4.oldestTask, v2.scope, v2.oldestTask, checkLifetime.formatters.animationGoal)
    end

    local v7 = castToState(p3)

    if v7 ~= nil then
        checkLifetime.bOutlivesA(p1, v4.oldestTask, v7.scope, v7.oldestTask, checkLifetime.formatters.parameter, "tween info")
    end

    evaluate(v4, true)

    return v4
end

function t1.get(_) -- line: 121
    -- upvalues: External (copy)
    return External.logError("stateGetWasRemoved")
end

function t1._evaluate(p5) -- line: 127
    -- upvalues: External (copy), depend (copy), castToState (copy), peek (copy), lerpType (copy), getTweenRatio (copy), getTweenDuration (copy)
    local v8 = castToState(p5._goal)

    if v8 ~= nil then
        depend(p5, v8)

        local v9 = peek(v8)

        if v9 == v9 then
            local _stopwatch = p5._stopwatch
            local v10 = peek(p5._tweenInfo)

            if p5._activeTo ~= v9 or p5._activeElapsed < p5._activeDuration and p5._activeTweenInfo ~= v10 then
                p5._activeDuration = getTweenDuration(v10)
                p5._activeFrom = p5._EXTREMELY_DANGEROUS_usedAsValue
                p5._activeTo = v9
                p5._activeTweenInfo = v10
                _stopwatch:zero()
                _stopwatch:unpause()
            end

            depend(p5, _stopwatch)
            p5._activeElapsed = peek(_stopwatch)

            if not (p5._activeFrom ~= p5._activeTo and not (p5._activeElapsed >= p5._activeDuration) and typeof(p5._activeTo) == typeof(p5._activeFrom)) then
                p5._activeFrom = p5._activeTo
                p5._activeElapsed = p5._activeDuration
                _stopwatch:pause()
            end

            local v13 = getTweenRatio(v10, p5._activeElapsed)
            local _EXTREMELY_DANGEROUS_usedAsValue = p5._EXTREMELY_DANGEROUS_usedAsValue
            local v14 = lerpType(p5._activeFrom, p5._activeTo, v13)

            if v14 ~= v14 then
                External.logWarn("tweenNanMotion")
                v14 = p5._activeTo
            end

            p5._EXTREMELY_DANGEROUS_usedAsValue = v14

            return _EXTREMELY_DANGEROUS_usedAsValue ~= v14
        end

        External.logWarn("tweenNanGoal")
    else
        p5._EXTREMELY_DANGEROUS_usedAsValue = p5._goal
    end

    return false
end

table.freeze(t1)

return Tween
