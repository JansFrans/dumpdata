-- https://lua.expert

local Modules = script:FindFirstAncestor("HD Admin").Core.MainModule.Value.Modules
local v1 = require(Modules.Framework).getSharedContainer().Core.MainModule:FindFirstChild("Value").Services.Config[script.Name]

return require(v1)
