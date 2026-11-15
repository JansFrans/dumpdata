-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules

return function(p1) -- line: 3
    -- upvalues: Modules (copy)
    if typeof(p1) ~= "string" then
        return {}
    end

    local Collective = require(Modules.Parser.ParserSettings).Collective

    return (string.split(p1, Collective))
end
