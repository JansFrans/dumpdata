-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local merge = require(ParentParent.Utility.merge)
local scopePool = require(ParentParent.Memory.scopePool)

local function deriveScopeImpl(p1, p2, ...) -- line: 20
    -- upvalues: merge (copy), scopePool (copy)
    local mt = getmetatable(p1)

    if p2 ~= nil then
        mt = table.clone(mt)
        mt.__index = merge(true, {}, mt.__index, merge(false, {}, p2, ...))
    end

    return (setmetatable(scopePool.reuseAny() or {}, mt))
end

return deriveScopeImpl
