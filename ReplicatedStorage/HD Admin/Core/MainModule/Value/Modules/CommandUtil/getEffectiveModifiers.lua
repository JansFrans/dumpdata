-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local t1 = {
    preview = true,
    undo = true
}

return function(p1, p2) -- line: 15
    -- upvalues: Modules (copy), t1 (copy)
    if not p1 or p1.disableModifiers ~= true then
        return p2
    end

    local Modifiers = require(Modules.Parser.Modifiers)
    local t2 = {}

    for v1, v2 in p2 do
        if typeof(v1) ~= "string" or Modifiers.get(v1) == nil or t1[tostring(v1):lower()] then
            t2[v1] = v2
        end
    end

    return t2
end
