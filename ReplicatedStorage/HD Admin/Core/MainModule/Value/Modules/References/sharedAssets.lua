-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules

return require(Modules.Framework).getSharedValue().Assets
