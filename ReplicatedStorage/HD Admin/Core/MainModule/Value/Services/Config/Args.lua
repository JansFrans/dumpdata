-- https://lua.expert

local Modules = script:FindFirstAncestor("HD Admin").Core.MainModule.Value.Modules

require(Modules.Parser.Args.ArgTypes)

local function register(p1) -- line: 12
    return p1
end

return function(_) -- line: 22
    return {}
end
