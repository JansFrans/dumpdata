-- https://lua.expert

local MainModule = script:FindFirstAncestor("MainModule")
local Modules = MainModule.Value.Modules
local Framework = require(Modules.Framework)
local t1 = {
    script.Name
}
local Parent = script.Parent

repeat
    table.insert(t1, 1, Parent.Name)
    Parent = Parent.Parent
until not Parent or Parent == MainModule

local sharedLocation, sharedName = Framework.sharedLocation, Framework.sharedName
local v1 = game:GetService(sharedLocation):WaitForChild(sharedName, 999).MainModule

for _, v2 in t1 do
    v1 = v1:WaitForChild(v2, 999)
end

return require(v1)
