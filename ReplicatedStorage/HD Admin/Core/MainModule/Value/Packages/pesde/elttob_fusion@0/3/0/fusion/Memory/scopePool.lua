-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local poisonScope = require(ParentParent.Memory.poisonScope)
local ExternalDebug = require(ParentParent.ExternalDebug)
local t1 = {}
local n1 = 0

return {
    giveIfEmpty = function(p1) -- giveIfEmpty | line: 18
        -- upvalues: poisonScope (copy), ExternalDebug (copy)
        if next(p1) ~= nil then
            return p1
        end

        ExternalDebug.untrackScope(p1)
        poisonScope(p1, "previously passed to the internal scope pool, which indicates a Fusion bug.")

        return nil
    end,
    clearAndGive = function(p2) -- clearAndGive | line: 34
        -- upvalues: poisonScope (copy), ExternalDebug (copy)
        ExternalDebug.untrackScope(p2)
        table.clear(p2)
        poisonScope(p2, "previously passed to the internal scope pool, which indicates a Fusion bug.")
    end,
    reuseAny = function() -- reuseAny | line: 46
        -- upvalues: t1 (copy), n1 (ref)
        if n1 == 0 then
            return nil
        end

        local v1 = t1[n1]

        n1 -= 1

        return v1
    end
}
