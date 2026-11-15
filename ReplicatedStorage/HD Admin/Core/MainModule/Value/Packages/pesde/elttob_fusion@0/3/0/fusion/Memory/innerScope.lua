-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local ExternalDebug = require(ParentParent.ExternalDebug)
local deriveScopeImpl = require(ParentParent.Memory.deriveScopeImpl)

local function innerScope(p1, ...) -- line: 15
    -- upvalues: ExternalDebug (copy), deriveScopeImpl (copy)
    local v1 = deriveScopeImpl(p1, ...)

    table.insert(p1, v1)
    table.insert(v1, function() -- line: 23
        -- upvalues: p1 (copy), v1 (copy)
        local v3 = table.find(p1, v1)

        if v3 ~= nil then
            table.remove(p1, v3)
        end
    end)
    ExternalDebug.trackScope(v1)

    return v1
end

return innerScope
