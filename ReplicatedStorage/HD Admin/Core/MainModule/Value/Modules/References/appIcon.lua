-- https://lua.expert

local MainModule = script:FindFirstAncestor("MainModule")
local Icon = require(MainModule.Value.Modules.Objects.Icon)
local Menu = require(MainModule.Value.Controllers.UI.Config.Icons).Topbar.Menu

return Icon.new():setImage(Menu.deselected, "deselected"):setImage(Menu.selected, "selected"):setImageScale(Menu.deselectedScale, "deselected"):setImageScale(Menu.selectedScale, "selected"):autoDeselect(false):setOrder(0)
