-- https://lua.expert

game:GetService("ReplicatedStorage"):WaitForChild("HD Admin"):WaitForChild("Core"):WaitForChild("ClientAPI"):WaitForChild("Loaded")

local Modules = script:FindFirstAncestor("MainModule").Value.Modules

require(Modules.Framework).startClient()
