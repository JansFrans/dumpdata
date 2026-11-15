-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local AllPowerfulServer = require(Modules.Objects.User).new("AllPowerfulServer")

AllPowerfulServer.temp:set("ElevatedPermissions", true)

return AllPowerfulServer
