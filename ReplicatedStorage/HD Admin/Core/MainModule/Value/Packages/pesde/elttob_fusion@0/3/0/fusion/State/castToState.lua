-- https://lua.expert

require(script.Parent.Parent.Types)

local function castToState(p1) -- line: 13
    return if typeof(p1) == "table" and p1.type == "State" then p1 else nil
end

return castToState
