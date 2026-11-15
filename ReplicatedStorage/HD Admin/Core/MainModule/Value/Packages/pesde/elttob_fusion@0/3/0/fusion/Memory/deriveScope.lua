-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local ExternalDebug = require(ParentParent.ExternalDebug)
local deriveScopeImpl = require(ParentParent.Memory.deriveScopeImpl)

local function deriveScope(...) -- line: 18
    -- upvalues: ExternalDebug (copy), deriveScopeImpl (copy)
    local v1 = deriveScopeImpl(...)

    ExternalDebug.trackScope(v1)

    return v1
end

return deriveScope
