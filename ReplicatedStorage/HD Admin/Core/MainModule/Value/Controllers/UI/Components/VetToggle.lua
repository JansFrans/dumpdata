-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI

require(Modules.Parent.Packages.Fusion)

local Icons = require(UI.Config.Icons)
local SearchRowToggle = require(UI.Components.SearchRowToggle)

return function(p1, p2) -- line: 21
    -- upvalues: Icons (copy), SearchRowToggle (copy)
    return SearchRowToggle(p1, {
        name = "VetToggle",
        icon = Icons.VetDeselected,
        activeIcon = Icons.VetSelected,
        isActive = p2.isActive,
        isVisible = p2.isVisible,
        layoutOrder = p2.layoutOrder,
        onActivate = p2.onActivate
    })
end
