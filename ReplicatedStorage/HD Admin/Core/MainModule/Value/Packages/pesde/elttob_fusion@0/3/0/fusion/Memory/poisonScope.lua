-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local External = require(ParentParent.External)

local function poisonScope(p1, p2) -- line: 14
    -- upvalues: External (copy)
    local mt = getmetatable(p1)

    if typeof(mt) == "table" and mt._FUSION_POISONED then
        return
    end

    table.clear(p1)
    setmetatable(p1, {
        _FUSION_POISONED = true,
        __index = function() -- __index | line: 25
            -- upvalues: p2 (copy), External (copy)
            External.logError("poisonedScope", nil, p2)
        end,
        __newindex = function() -- __newindex | line: 28
            -- upvalues: p2 (copy), External (copy)
            External.logError("poisonedScope", nil, p2)
        end
    })
end

return poisonScope
