-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local parseError = require(ParentParent.Logging.parseError)
local isSimilar = require(ParentParent.Utility.isSimilar)
local never = require(ParentParent.Utility.never)
local depend = require(ParentParent.Graph.depend)
local castToState = require(ParentParent.State.castToState)
local peek = require(ParentParent.State.peek)
local doCleanup = require(ParentParent.Memory.doCleanup)
local deriveScope = require(ParentParent.Memory.deriveScope)
local checkLifetime = require(ParentParent.Memory.checkLifetime)
local scopePool = require(ParentParent.Memory.scopePool)
local nicknames = require(ParentParent.Utility.nicknames)
local t1 = {
    type = "State",
    kind = "Computed",
    timeliness = "lazy"
}
local v1 = table.freeze({
    __index = t1
})

local function Computed(p1, p2, p3) -- line: 46
    -- upvalues: External (copy), doCleanup (copy), nicknames (copy), v1 (copy)
    local elapsed = os.clock()

    if typeof(p1) == "function" then
        External.logError("scopeMissing", nil, "Computeds", "myScope:Computed(function(use, scope) ... end)")
    elseif p3 ~= nil then
        External.logWarn("destructorRedundant", "Computed")
    end

    local v2 = setmetatable({
        lastChange = nil,
        validity = "invalid",
        _EXTREMELY_DANGEROUS_usedAsValue = nil,
        _innerScope = nil,
        createdAt = elapsed,
        dependencySet = {},
        dependentSet = {},
        scope = p1,
        _processor = p2
    }, v1)

    local function v3() -- line: 71
        -- upvalues: v2 (copy), doCleanup (copy)
        v2.scope = nil

        for v4 in pairs(v2.dependencySet) do
            v4.dependentSet[v2] = nil
        end

        if v2._innerScope ~= nil then
            doCleanup(v2._innerScope)
        end
    end

    v2.oldestTask = v3
    nicknames[v2.oldestTask] = "Computed"
    table.insert(p1, v3)

    return v2
end

function t1.get(_) -- line: 86
    -- upvalues: External (copy), never (copy)
    External.logError("stateGetWasRemoved")

    return never()
end

function t1._evaluate(p5) -- line: 93
    -- upvalues: External (copy), parseError (copy), isSimilar (copy), depend (copy), castToState (copy), peek (copy), doCleanup (copy), deriveScope (copy), checkLifetime (copy), scopePool (copy)
    if p5.scope == nil then
        return false
    end

    local scope = p5.scope
    local v5 = deriveScope(scope)

    local function use(p6) -- line: 101
        -- upvalues: p5 (copy), scope (copy), depend (copy), castToState (copy), peek (copy), checkLifetime (copy)
        local v6 = castToState(p6)

        if v6 ~= nil then
            checkLifetime.bOutlivesA(scope, p5.oldestTask, v6.scope, v6.oldestTask, checkLifetime.formatters.useFunction)
            depend(p5, v6)
        end

        return peek(p6)
    end

    local _processor = p5._processor
    local v7, v8 = xpcall(_processor, parseError, use, v5)
    local v9 = scopePool.giveIfEmpty(v5)

    if v7 then
        local v10 = isSimilar(p5._EXTREMELY_DANGEROUS_usedAsValue, v8)

        if p5._innerScope ~= nil then
            doCleanup(p5._innerScope)
        end

        p5._innerScope = v9
        p5._EXTREMELY_DANGEROUS_usedAsValue = v8

        return not v10
    end

    if v9 ~= nil then
        doCleanup(v9)
    end

    External.logErrorNonFatal("callbackError", v8)

    return false
end

table.freeze(t1)

return Computed
