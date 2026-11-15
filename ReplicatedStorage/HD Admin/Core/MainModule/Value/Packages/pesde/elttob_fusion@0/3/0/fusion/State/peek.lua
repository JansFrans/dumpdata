-- https://lua.expert

local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local castToState = require(ParentParent.State.castToState)
local evaluate = require(ParentParent.Graph.evaluate)

local function peek(p1) -- line: 19
    -- upvalues: castToState (copy), evaluate (copy)
    local v1 = castToState(p1)

    if v1 == nil then
        return p1
    end

    evaluate(v1, false)

    return v1._EXTREMELY_DANGEROUS_usedAsValue
end

return peek
