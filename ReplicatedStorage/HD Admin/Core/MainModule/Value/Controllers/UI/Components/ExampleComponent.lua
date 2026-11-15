-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI

require(Packages.Fusion)

local Theme = require(UI.Util.Theme)

return function(p1, p2) -- line: 21
    -- upvalues: Theme (copy)
    return p1:New("TextButton")({
        BackgroundColor3 = Theme.Color.Base,
        Text = p2.example1
    })
end
