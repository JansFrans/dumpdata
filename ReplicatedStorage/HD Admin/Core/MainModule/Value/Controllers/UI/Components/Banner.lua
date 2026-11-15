-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Icons = require(UI.Config.Icons)
local Pressable = require(UI.Components.Pressable)
local Children = Fusion.Children

return function(p1, p2) -- line: 32
    -- upvalues: Theme (copy), Icons (copy), Pressable (copy), Children (copy)
    local t1 = {
        p1:New("UIStroke")({
            Thickness = 1,
            Transparency = 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Theme.Color.Primary
        }),
        p1:New("UIPadding")({
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4)
        }),
        p1:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.None,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        }),
        p1:New("TextLabel")({
            Name = "Label",
            BackgroundTransparency = 1,
            FontFace = p1:Computed(function(p3) -- line: 57
                -- upvalues: Theme (copy)
                return Font.new(p3(Theme.Font.Body), p3(Theme.FontWeight.Body))
            end),
            LayoutOrder = 1,
            Size = UDim2.new(0, 0, 1, 0),
            Text = p2.text,
            TextColor3 = Theme.Color.Primary,
            TextSize = Theme.TextSize.Label,
            TextTruncate = Enum.TextTruncate.SplitWord,
            TextXAlignment = Enum.TextXAlignment.Left,
            [Children] = {
                p1:New("UIFlexItem")({
                    FlexMode = Enum.UIFlexMode.Fill
                })
            }
        }),
        Pressable(p1, {
            name = "ActionButton",
            size = UDim2.fromOffset(64, 26),
            backgroundColor = Theme.Color.Primary,
            layoutOrder = 2,
            onActivate = p2.onButton,
            [Children] = {
                p1:New("UICorner")({
                    CornerRadius = UDim.new(0, 4)
                }),
                p1:New("TextLabel")({
                    Name = "Label",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    FontFace = p1:Computed(function(p4) -- line: 84
                        -- upvalues: Theme (copy)
                        return Font.new(p4(Theme.Font.Body), p4(Theme.FontWeight.Body))
                    end),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(1, 1),
                    Text = p2.buttonLabel,
                    TextColor3 = Theme.Color.PrimaryContent,
                    TextSize = Theme.TextSize.Label,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center
                })
            }
        })
    }
    local onClose = p2.onClose

    if onClose then
        table.insert(t1, Pressable(p1, {
            name = "CloseButton",
            layoutOrder = 3,
            iconSize = 14,
            size = UDim2.fromOffset(26, 26),
            iconImage = Icons.Close,
            iconColor = Theme.Color.Primary,
            onActivate = onClose
        }))
    end

    return p1:New("Frame")({
        Name = p2.name or "Banner",
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Theme.Color.Primary,
        BackgroundTransparency = 0.9,
        LayoutOrder = p2.layoutOrder,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = p2.size or UDim2.new(1, 0, 0, 36),
        Visible = p2.visible,
        ZIndex = 10,
        [Children] = t1
    })
end
