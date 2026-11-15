-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children

return function(p1, p2) -- line: 21
    -- upvalues: Theme (copy), Children (copy)
    local v1 = p2.paddingY or 9

    return p1:New("Frame")({
        Name = "Divider",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = p2.layoutOrder,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p1:New("UIPadding")({
                PaddingBottom = UDim.new(0, v1),
                PaddingTop = UDim.new(0, v1)
            }),
            p1:New("Frame")({
                Name = "DividingLine",
                BackgroundTransparency = 0.9,
                BorderSizePixel = 0,
                BackgroundColor3 = Theme.Color.BaseContent,
                Size = UDim2.new(1, 0, 0, 1)
            })
        }
    })
end
