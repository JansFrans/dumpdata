-- https://lua.expert

require(script.Parent.Parent.Types)

local function castToGraph(p1) -- line: 13
    return if typeof(p1) == "table" and typeof(p1.validity) == "string" and typeof(p1.timeliness) == "string" and typeof(p1.dependencySet) == "table" and typeof(p1.dependentSet) == "table" then p1 else nil
end

return castToGraph
