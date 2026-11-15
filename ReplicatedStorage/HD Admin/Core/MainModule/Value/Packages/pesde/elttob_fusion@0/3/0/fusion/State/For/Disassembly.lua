-- https://lua.expert

local ParentParent = script.Parent.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local depend = require(ParentParent.Graph.depend)
local peek = require(ParentParent.State.peek)
local castToState = require(ParentParent.State.castToState)

require(ParentParent.State.For.ForTypes)

local doCleanup = require(ParentParent.Memory.doCleanup)
local deriveScope = require(ParentParent.Memory.deriveScope)
local scopePool = require(ParentParent.Memory.scopePool)
local nameOf = require(ParentParent.Utility.nameOf)
local nicknames = require(ParentParent.Utility.nicknames)
local t1 = {
    type = "Graph",
    kind = "For.Disassembly",
    timeliness = "lazy"
}
local v1 = table.freeze({
    __index = t1
})

local function Disassembly(p1, p2, p3) -- line: 46
    -- upvalues: doCleanup (copy), nicknames (copy), v1 (copy)
    local v2 = setmetatable({
        validity = "invalid",
        createdAt = os.clock(),
        dependencySet = {},
        dependentSet = {},
        scope = p1,
        _inputTable = p2,
        _constructor = p3,
        _subObjects = {}
    }, v1)

    local function v3() -- line: 70
        -- upvalues: v2 (copy), doCleanup (copy)
        v2.scope = nil

        for v4 in pairs(v2.dependencySet) do
            v4.dependentSet[v2] = nil
        end

        for v5 in v2._subObjects do
            if v5.maybeScope ~= nil then
                doCleanup(v5.maybeScope)
                v5.maybeScope = nil
            end
        end
    end

    v2.oldestTask = v3
    nicknames[v2.oldestTask] = "For (internal disassembler)"
    table.insert(p1, v3)

    return v2
end

function t1.populate(p4, p5, p6) -- line: 89
    -- upvalues: External (copy)
    local n1 = 1e999
    local n2 = (-1e999)
    local v6 = false

    for v7 in p4._subObjects do
        local v8, v9 = v7:useOutputPair(p5)

        if v8 == nil or v9 == nil then
            v6 = true
        elseif p6[v8] ~= nil then
            External.logErrorNonFatal("forKeyCollision", nil, (tostring(v8)))
        else
            p6[v8] = v9

            if typeof(v8) == "number" then
                n1 = math.min(n1, v8)
                n2 = math.max(n2, v8)
            end
        end
    end

    if v6 and n1 < n2 then
        for i = n1, n2 do
            local v10 = p6[i]

            if v10 ~= nil then
                p6[i] = nil
                p6[n1] = v10
                n1 += 1
            end
        end
    end
end

function t1._evaluate(p7) -- line: 129
    -- upvalues: External (copy), depend (copy), peek (copy), castToState (copy), doCleanup (copy), deriveScope (copy), scopePool (copy), nameOf (copy)
    local scope = p7.scope
    local v11 = castToState(p7._inputTable)

    if v11 ~= nil then
        if v11.scope == nil then
            External.logError("useAfterDestroy", nil, ("The input %*"):format((nameOf(v11, "table"))), "the For object that is watching it")
        end

        depend(p7, v11)
    end

    local t3 = {}

    for v12, v13 in peek(p7._inputTable) do
        t3[v12] = v13
    end

    local t4 = {}

    for v14 in p7._subObjects do
        local inputKey, inputValue = v14.inputKey, v14.inputValue
        local v15, v16

        if v14.roamKeys or t3[inputKey] == nil then
            v15 = false

            for v17, v18 in t3 do
                if v14.roamValues then
                    v15 = true
                    v16 = v17
                    break
                end

                if v18 == inputValue then
                    v15 = true
                    v16 = v17
                    break
                end

                v16 = v17
                v15 = true
            end
        else
            v16 = inputKey
            v15 = true
        end

        if v15 then
            local v19 = t3[v16]

            t4[v14] = true

            if v16 ~= inputKey then
                v14.inputKey = v16
                v14:invalidateInputKey()
            end

            if v19 ~= inputValue then
                v14.inputValue = v19
                v14:invalidateInputValue()
            end

            t3[v16] = nil
        elseif v14.maybeScope ~= nil then
            doCleanup(v14.maybeScope)
            v14.maybeScope = nil
        end
    end

    for v20, v21 in t3 do
        local v22 = p7._constructor(deriveScope(scope), v20, v21)

        if v22.maybeScope ~= nil then
            v22.maybeScope = scopePool.giveIfEmpty(v22.maybeScope)
        end

        t4[v22] = true
    end

    p7._subObjects = t4

    return true
end

table.freeze(t1)

return Disassembly
