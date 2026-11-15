-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local depend = require(ParentParent.Graph.depend)
local peek = require(ParentParent.State.peek)
local castToState = require(ParentParent.State.castToState)

require(ParentParent.State.For.ForTypes)

local never = require(ParentParent.Utility.never)
local nicknames = require(ParentParent.Utility.nicknames)
local Disassembly = require(ParentParent.State.For.Disassembly)
local t1 = {
    type = "State",
    kind = "For",
    timeliness = "lazy"
}
local v1 = table.freeze({
    __index = t1
})

local function For(p1, p2, p3) -- line: 36
    -- upvalues: nicknames (copy), Disassembly (copy), v1 (copy)
    local v2 = setmetatable({
        validity = "invalid",
        createdAt = os.clock(),
        dependencySet = {},
        dependentSet = {},
        scope = p1,
        _EXTREMELY_DANGEROUS_usedAsValue = {},
        _disassembly = Disassembly(p1, p2, p3)
    }, v1)

    local function v3() -- line: 63
        -- upvalues: v2 (copy)
        v2.scope = nil

        for v4 in pairs(v2.dependencySet) do
            v4.dependentSet[v2] = nil
        end
    end

    v2.oldestTask = v3
    nicknames[v2.oldestTask] = "For"
    table.insert(p1, v3)

    return v2
end

function t1.get(_) -- line: 76
    -- upvalues: External (copy), never (copy)
    External.logError("stateGetWasRemoved")

    return never()
end

function t1._evaluate(p5) -- line: 83
    -- upvalues: depend (copy), peek (copy), castToState (copy)
    if p5.scope == nil then
        return false
    end

    local _ = p5.scope

    depend(p5, p5._disassembly)
    table.clear(p5._EXTREMELY_DANGEROUS_usedAsValue)
    p5._disassembly:populate(function(p6) -- line: 94
        -- upvalues: p5 (copy), depend (copy), peek (copy), castToState (copy)
        local v5 = castToState(p6)

        if v5 ~= nil then
            depend(p5, v5)
        end

        return peek(p6)
    end, p5._EXTREMELY_DANGEROUS_usedAsValue)

    return true
end

table.freeze(t1)

return For
