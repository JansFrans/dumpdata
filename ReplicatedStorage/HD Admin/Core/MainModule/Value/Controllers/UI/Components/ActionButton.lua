-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local InputRow = require(script.Parent.InputRow)
local Pressable = require(script.Parent.Pressable)

return function(p1, p2) -- line: 28
    -- upvalues: Theme (copy), Children (copy), InputRow (copy), Pressable (copy)
    local v1 = p2.buttonText or ""
    local buttonIcon = p2.buttonIcon
    local v6 = Pressable(p1, {
        name = "Button",
        size = UDim2.fromScale(1, 1),
        backgroundColor = Theme.Color.Neutral,
        onActivate = p2.onActivate,
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = p1:Computed(function(p3) -- line: 39
                    -- upvalues: Theme (copy)
                    return UDim.new(0, (p3(Theme.Layout.CornerRadius)))
                end)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            if buttonIcon == nil then nil else p1:New("ImageLabel")({
                Name = "Icon",
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Image = buttonIcon,
                ImageColor3 = Theme.Color.NeutralContentMain,
                Size = UDim2.fromOffset(16, 16)
            }),
            p1:New("TextLabel")({
                Name = "Label",
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                FontFace = p1:Computed(function(p4) -- line: 66
                    -- upvalues: Theme (copy)
                    return Font.new(p4(Theme.Font.Body), p4(Theme.FontWeight.Body))
                end),
                Size = UDim2.new(0, 0, 1, 0),
                Text = v1,
                TextColor3 = Theme.Color.BaseContent,
                TextSize = Theme.TextSize.Body,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center
            })
        }
    })

    return InputRow(p1, {
        title = p2.title,
        name = "ActionButton",
        labelSize = p2.labelSize,
        labelTextSize = p2.labelTextSize,
        framePaddingX = 0,
        framePaddingY = 0,
        [Children] = v6
    })
end
