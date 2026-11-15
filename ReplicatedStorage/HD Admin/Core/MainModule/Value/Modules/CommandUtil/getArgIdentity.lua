-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Args = require(Modules.Parser.Args)

return function(p1) -- line: 9
    -- upvalues: Args (copy)
    local v1 = Args.get(p1)

    if not v1 then
        return ""
    end

    return tostring(v1.key or ""):lower()
end
