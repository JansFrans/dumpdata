-- https://lua.expert

if not script:WaitForChild("Loaded", 999) then
    error("HD Admin failed to load, so its API cannot be used")
end

local Modules = script:FindFirstAncestor("HD Admin").Core.MainModule.Value.Modules

return require(Modules.Internal.API.Client)
