-- https://lua.expert

local RunService = game:GetService("RunService")
local MainModule = script:FindFirstAncestor("MainModule")
local Modules = MainModule.Value.Modules
local Framework = require(Modules.Framework)
local Name = script.Name

if RunService:IsClient() then
    error((("'%*' can only be accessed on the server! This was moved to the server by %* before replication because it contained the tag (Instance.Tags) 'Server'."):format(Name, Framework.applicationName)))
end

local t1 = {
    Name
}
local Parent = script.Parent

repeat
    table.insert(t1, 1, Parent.Name)
    Parent = Parent.Parent
until not Parent or Parent == MainModule

local serverLocation, serverName = Framework.serverLocation, Framework.serverName
local v1 = game:GetService(serverLocation):WaitForChild(serverName, 999).Core.MainModule

for _, v2 in t1 do
    v1 = v1:WaitForChild(v2, 999)
end

return require(v1)
