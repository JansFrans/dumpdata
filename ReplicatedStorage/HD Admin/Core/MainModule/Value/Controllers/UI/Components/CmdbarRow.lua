-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local Pressable = require(UI.Components.Pressable)
local Icons = require(UI.Config.Icons)

return function(p1, p2) -- line: 39
    -- upvalues: Theme (copy), Children (copy), Pressable (copy), Icons (copy)
    return Pressable(p1, {
        name = "CmdbarRow",
        size = UDim2.new(1, 0, 0, 34),
        layoutOrder = p2.layoutOrder,
        backgroundColor = p1:Computed(function(p3) -- line: 48
            -- upvalues: p2 (copy), Theme (copy)
            if p3(p2.selected) then
                return (p3(Theme.Color.Neutral))
            end

            return (p3(Theme.Color.Base))
        end),
        onActivate = p2.onActivate,
        onHoverChanged = function(p4) -- onHoverChanged | line: 52
            -- upvalues: p2 (copy)
            if p4 and p2.onHover then
                p2.onHover()
            end
        end,
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p1:New("UIPadding")({
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            }),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalFlex = Enum.UIFlexAlignment.None,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8)
            }),
            p1:New("ImageLabel")({
                Name = "Leading",
                LayoutOrder = 1,
                BackgroundColor3 = Theme.Color.Neutral,
                BackgroundTransparency = p1:Computed(function(_) -- line: 78
                    -- upvalues: p2 (copy)
                    if p2.imageRounded then
                        return 0
                    end

                    return 1
                end),
                Image = p2.image or "",
                ImageTransparency = p1:Computed(function(p6) -- line: 82
                    -- upvalues: p2 (copy)
                    if p6(p2.locked or false) then
                        return 0.55
                    end

                    return 0
                end),
                ImageColor3 = p1:Computed(function(p7) -- line: 85
                    -- upvalues: p2 (copy), Theme (copy)
                    if p2.imageRounded then
                        return (Color3.new(1, 1, 1))
                    end

                    return (p7(Theme.Color.NeutralContentMain))
                end),
                ScaleType = Enum.ScaleType.Fit,
                Size = UDim2.fromOffset(20, 20),
                Visible = p1:Computed(function(p8) -- line: 90
                    -- upvalues: p2 (copy)
                    local v4 = p8(p2.image)

                    if typeof(v4) == "string" then
                        return v4 ~= ""
                    end

                    return false
                end),
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = if p2.imageRounded then UDim.new(1, 0) else UDim.new(0, 4)
                    })
                }
            }),
            p1:New("Frame")({
                Name = "Swatch",
                LayoutOrder = 1,
                BackgroundColor3 = p2.swatch or Color3.new(1, 1, 1),
                BackgroundTransparency = p1:Computed(function(p9) -- line: 105
                    -- upvalues: p2 (copy)
                    if p9(p2.locked or false) then
                        return 0.55
                    end

                    return 0
                end),
                Size = UDim2.fromOffset(18, 18),
                Visible = p2.swatch ~= nil,
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = UDim.new(0, 4)
                    }),
                    p1:New("UIStroke")({
                        Transparency = 0.3,
                        Color = Theme.Color.NeutralStroke
                    })
                }
            }),
            p1:New("TextLabel")({
                Name = "Label",
                LayoutOrder = 2,
                BackgroundTransparency = 1,
                FontFace = p1:Computed(function(p10) -- line: 123
                    -- upvalues: Theme (copy)
                    return Font.new(p10(Theme.Font.Body), p10(Theme.FontWeight.Body))
                end),
                RichText = p2.rich == true,
                Text = p2.display,
                TextColor3 = Theme.Color.BaseContent,
                TextTransparency = p1:Computed(function(p11) -- line: 129
                    -- upvalues: p2 (copy)
                    if p11(p2.locked or false) then
                        return 0.55
                    end

                    return 0
                end),
                TextSize = Theme.TextSize.Body,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.fromScale(0, 1),
                [Children] = {
                    p1:New("UISizeConstraint")({
                        MaxSize = Vector2.new(380, 1e999)
                    })
                }
            }),
            p1:New("TextLabel")({
                Name = "Description",
                LayoutOrder = 3,
                BackgroundTransparency = 1,
                FontFace = p1:Computed(function(p12) -- line: 149
                    -- upvalues: Theme (copy)
                    return Font.new(p12(Theme.Font.Body), p12(Theme.FontWeight.Regular))
                end),
                Text = p2.description or "",
                TextColor3 = Theme.Color.NeutralContentDark,
                TextTransparency = p1:Computed(function(p13) -- line: 154
                    -- upvalues: p2 (copy)
                    if p13(p2.locked or false) then
                        return 0.55
                    end

                    return 0.15
                end),
                TextSize = Theme.TextSize.Small,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Size = UDim2.fromScale(0, 1),
                Visible = p1:Computed(function(p14) -- line: 161
                    -- upvalues: p2 (copy)
                    local v8 = p14(p2.description)

                    if typeof(v8) == "string" then
                        return v8 ~= ""
                    end

                    return false
                end),
                [Children] = {
                    p1:New("UIFlexItem")({
                        FlexMode = Enum.UIFlexMode.Fill
                    })
                }
            }),
            p1:New("ImageLabel")({
                Name = "Unlock",
                LayoutOrder = 4,
                BackgroundTransparency = 1,
                Image = Icons.Unlock,
                ImageColor3 = Theme.Color.Warning,
                Size = UDim2.fromOffset(16, 16),
                Visible = p2.showUnlock or false
            })
        }
    })
end
