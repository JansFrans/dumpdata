-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)
local change = require(ParentParent.Graph.change)
local nicknames = require(ParentParent.Utility.nicknames)
local t1 = {
    type = "State",
    kind = "ExternalTime",
    timeliness = "lazy",
    dependencySet = table.freeze({}),
    _EXTREMELY_DANGEROUS_usedAsValue = External.lastUpdateStep()
}
local v1 = table.freeze({
    __index = t1
})
local t2 = {}

local function ExternalTime(p1) -- line: 33
    -- upvalues: nicknames (copy), v1 (copy), t2 (copy)
    local v2 = setmetatable({
        lastChange = nil,
        validity = "invalid",
        createdAt = os.clock(),
        dependentSet = {},
        scope = p1
    }, v1)

    local function v3() -- line: 47
        -- upvalues: v2 (copy), t2 (copy)
        v2.scope = nil

        local v4 = table.find(t2, v2)

        if v4 ~= nil then
            table.remove(t2, v4)
        end
    end

    v2.oldestTask = v3
    nicknames[v2.oldestTask] = "ExternalTime"
    table.insert(p1, v3)
    table.insert(t2, v2)

    return v2
end

function t1._evaluate(_) -- line: 61
    return true
end

External.bindToUpdateStep(function(_) -- line: 72
    -- upvalues: External (copy), change (copy), t1 (copy), t2 (copy)
    t1._EXTREMELY_DANGEROUS_usedAsValue = External.lastUpdateStep()

    for _, v5 in t2 do
        change(v5)
    end
end)

return ExternalTime
