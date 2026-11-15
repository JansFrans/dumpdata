-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Icons = require(UI.Config.Icons)
local Children = Fusion.Children

return function(p1, p2) -- line: 23
    -- upvalues: Theme (copy), Icons (copy), Children (copy)
    local v1 = p2.text or "You do not have permission to view this page"

    return p1:New("Frame")({
        Name = "NoPermissionPlaceholder",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = p2.visible,
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10)
            }),
            p1:New("ImageLabel")({
                Name = "Icon",
                LayoutOrder = 1,
                BackgroundTransparency = 1,
                ImageTransparency = 0.3,
                Image = Icons.TagLockFill,
                ImageColor3 = Theme.Color.NeutralContentDark,
                Size = UDim2.fromOffset(40, 40)
            }),
            p1:New("TextLabel")({
                Name = "Label",
                LayoutOrder = 2,
                BackgroundTransparency = 1,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                FontFace = p1:Computed(function(p3) -- line: 53
                    -- upvalues: Theme (copy)
                    return Font.new(p3(Theme.Font.Body), p3(Theme.FontWeight.Body))
                end),
                Size = UDim2.new(1, -40, 0, 0),
                Text = v1,
                TextColor3 = Theme.Color.NeutralContentDark,
                TextSize = Theme.TextSize.Subtitle,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Top
            })
        }
    })
end
