-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules

return require(Modules.Objects.Remote).new("OpenBooster", "Event")
