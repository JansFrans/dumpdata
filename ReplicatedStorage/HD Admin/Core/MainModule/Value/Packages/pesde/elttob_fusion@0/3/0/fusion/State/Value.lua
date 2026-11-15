-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local change = require(ParentParent.Graph.change)
local isSimilar = require(ParentParent.Utility.isSimilar)
local never = require(ParentParent.Utility.never)
local nicknames = require(ParentParent.Utility.nicknames)
local t1 = {
    type = "State",
    kind = "Value",
    timeliness = "lazy",
    dependencySet = table.freeze({})
}
local v1 = table.freeze({
    __index = t1
})

local function Value(p1, p2) -- line: 32
    -- upvalues: External (copy), nicknames (copy), v1 (copy)
    local elapsed = os.clock()

    if p2 == nil and (typeof(p1) ~= "table" or p1[1] == nil and next(p1) ~= nil) then
        External.logError("scopeMissing", nil, "Value", "myScope:Value(initialValue)")
    end

    local v2 = setmetatable({
        validity = "valid",
        createdAt = elapsed,
        dependentSet = {},
        lastChange = os.clock(),
        scope = p1,
        _EXTREMELY_DANGEROUS_usedAsValue = p2
    }, v1)

    local function v3() -- line: 51
        -- upvalues: v2 (copy)
        v2.scope = nil
    end

    v2.oldestTask = v3
    nicknames[v2.oldestTask] = "Value"
    table.insert(p1, v3)

    return v2
end

function t1.get(_, _) -- line: 60
    -- upvalues: External (copy), never (copy)
    External.logError("stateGetWasRemoved")

    return never()
end

function t1.set(p5, p6) -- line: 67
    -- upvalues: change (copy), isSimilar (copy)
    if not isSimilar(p5._EXTREMELY_DANGEROUS_usedAsValue, p6) then
        p5._EXTREMELY_DANGEROUS_usedAsValue = p6
        change(p5)
    end

    return p6
end

function t1._evaluate(_) -- line: 79
    return true
end

table.freeze(t1)

return Value
