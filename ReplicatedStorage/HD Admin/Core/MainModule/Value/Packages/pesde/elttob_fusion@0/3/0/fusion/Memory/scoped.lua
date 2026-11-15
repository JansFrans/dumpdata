-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local ExternalDebug = require(ParentParent.ExternalDebug)
local merge = require(ParentParent.Utility.merge)
local scopePool = require(ParentParent.Memory.scopePool)

local function scoped(...) -- line: 16
    -- upvalues: ExternalDebug (copy), merge (copy), scopePool (copy)
    local v2 = setmetatable(scopePool.reuseAny() or {}, {
        __index = merge(false, {}, ...)
    })

    ExternalDebug.trackScope(v2)

    return v2
end

return scoped
