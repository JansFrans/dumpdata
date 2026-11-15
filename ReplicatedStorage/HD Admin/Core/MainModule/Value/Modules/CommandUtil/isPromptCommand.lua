-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules

return function(p1) -- line: 7
    -- upvalues: Modules (copy)
    local v1 = if typeof(p1) == "string" then require(Modules.Parent.Services.Commands).getCommand(p1) else p1

    if typeof(v1) == "table" and typeof(v1.groups) == "table" then
        for _, v2 in v1.groups do
            if typeof(v2) == "string" and v2:lower() == "prompt" then
                return true
            end
        end

        return false
    end

    return false
end
