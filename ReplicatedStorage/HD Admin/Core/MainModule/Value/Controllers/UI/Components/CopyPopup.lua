-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children, Out = Fusion.Children, Fusion.Out
local Pressable = require(UI.Components.Pressable)
local Platform = require(UI.Util.Platform)
local Icons = require(UI.Config.Icons)

return function(p1, p2) -- line: 26
    -- upvalues: Fusion (copy), Theme (copy), Children (copy), Out (copy), Pressable (copy), Platform (copy), Icons (copy)
    local v1 = p1:Value(Vector2.zero)
    local v2 = p1:New("TextBox")({
        Name = "CommandText",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        FontFace = p1:Computed(function(p3) -- line: 34
            -- upvalues: Theme (copy)
            return Font.new(p3(Theme.Font.Body), p3(Theme.FontWeight.Body))
        end),
        MultiLine = true,
        Size = UDim2.fromScale(1, 0),
        Text = p2.text,
        TextColor3 = Theme.Color.BaseContent,
        TextEditable = false,
        TextSize = Theme.TextSize.Body,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        [Children] = {
            p1:New("UIPadding")({
                PaddingTop = p1:Computed(function(p4) -- line: 48
                    -- upvalues: Theme (copy)
                    return UDim.new(0, (p4(Theme.Layout.Padding)))
                end),
                PaddingBottom = p1:Computed(function(p5) -- line: 49
                    -- upvalues: Theme (copy)
                    return UDim.new(0, (p5(Theme.Layout.Padding)))
                end),
                PaddingLeft = p1:Computed(function(p6) -- line: 50
                    -- upvalues: Theme (copy)
                    return UDim.new(0, (p6(Theme.Layout.Padding)))
                end),
                PaddingRight = p1:Computed(function(p7) -- line: 51
                    -- upvalues: Theme (copy)
                    return UDim.new(0, (p7(Theme.Layout.Padding)))
                end)
            })
        }
    })
    local v6 = p1:New("ScrollingFrame")({
        Name = "TextScroller",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Color.Base,
        BorderSizePixel = 0,
        BottomImage = "rbxassetid://16547643439",
        CanvasSize = UDim2.new(),
        LayoutOrder = 2,
        MidImage = "rbxassetid://16547330984",
        ScrollBarImageColor3 = Theme.Color.NeutralContentDark,
        ScrollBarImageTransparency = Platform.isMobile and 1 or 0,
        ScrollBarThickness = Platform.isMobile and 2 or 8,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Selectable = false,
        Size = UDim2.fromScale(1, 0),
        TopImage = "rbxassetid://16547667444",
        VerticalScrollBarInset = Enum.ScrollBarInset.Always,
        ZIndex = 11,
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = p1:Computed(function(p8) -- line: 79
                    -- upvalues: Theme (copy)
                    return UDim.new(0, (p8(Theme.Layout.CornerRadius)))
                end)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p1:New("UISizeConstraint")({
                MaxSize = p1:Computed(function(p9) -- line: 89
                    -- upvalues: v1 (copy)
                    local Y = p9(v1).Y

                    return Vector2.new(1e999, (math.max(120, Y - 140)))
                end)
            }),
            v2
        }
    })

    p1:Observer(p2.visible):onChange(function() -- line: 98
        -- upvalues: p2 (copy), v2 (copy), Fusion (copy)
        if Fusion.peek(p2.visible) then
            task.defer(function() -- line: 100
                -- upvalues: p2 (copy), v2 (copy), Fusion (copy)
                if Fusion.peek(p2.visible) then
                    v2:CaptureFocus()
                end
            end)
        end
    end)

    return p1:New("Frame")({
        Name = "CopyPopup",
        BackgroundColor3 = Theme.Color.NeutralDark,
        BackgroundTransparency = 0.05,
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.new(1, 1, 1, 0),
        Visible = p2.visible,
        ZIndex = 10,
        [Out("AbsoluteSize")] = v1,
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            Pressable(p1, {
                name = "Backdrop",
                zIndex = 10,
                size = UDim2.fromScale(1, 1),
                onActivate = function() -- onActivate | line: 126
                    -- upvalues: p2 (copy), v2 (copy)
                    p2.visible:set(false)
                    v2:ReleaseFocus()
                end
            }),
            p1:New("TextButton")({
                Name = "Card",
                AnchorPoint = Vector2.new(0.5, 0.5),
                AutomaticSize = Enum.AutomaticSize.Y,
                AutoButtonColor = false,
                BackgroundColor3 = Theme.Color.Neutral,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = p1:Computed(function(p10) -- line: 139
                    -- upvalues: Theme (copy)
                    return UDim2.new(1, -p10(Theme.Layout.Padding) * 2, 0, 0)
                end),
                Text = "",
                ZIndex = 11,
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = p1:Computed(function(p11) -- line: 147
                            -- upvalues: Theme (copy)
                            return UDim.new(0, (p11(Theme.Layout.CornerRadius)))
                        end)
                    }),
                    p1:New("UIStroke")({
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = Theme.Color.NeutralStroke
                    }),
                    p1:New("UIPadding")({
                        PaddingTop = p1:Computed(function(p12) -- line: 156
                            -- upvalues: Theme (copy)
                            return UDim.new(0, (p12(Theme.Layout.Padding)))
                        end),
                        PaddingBottom = p1:Computed(function(p13) -- line: 157
                            -- upvalues: Theme (copy)
                            return UDim.new(0, (p13(Theme.Layout.Padding)))
                        end),
                        PaddingLeft = p1:Computed(function(p14) -- line: 158
                            -- upvalues: Theme (copy)
                            return UDim.new(0, (p14(Theme.Layout.Padding)))
                        end),
                        PaddingRight = p1:Computed(function(p15) -- line: 159
                            -- upvalues: Theme (copy)
                            return UDim.new(0, (p15(Theme.Layout.Padding)))
                        end)
                    }),
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = p1:Computed(function(p16) -- line: 165
                            -- upvalues: Theme (copy)
                            return UDim.new(0, (p16(Theme.Layout.Padding)))
                        end)
                    }),
                    p1:New("Frame")({
                        Name = "Header",
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                        Size = UDim2.fromScale(1, 0),
                        ZIndex = 11,
                        [Children] = {
                            p1:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center
                            }),
                            p1:New("TextLabel")({
                                Name = "Title",
                                AutomaticSize = Enum.AutomaticSize.XY,
                                BackgroundTransparency = 1,
                                FontFace = p1:Computed(function(p17) -- line: 187
                                    -- upvalues: Theme (copy)
                                    return Font.new(p17(Theme.Font.Heading), p17(Theme.FontWeight.Heading))
                                end),
                                LayoutOrder = 1,
                                Text = p2.title or "Copy command",
                                TextColor3 = Theme.Color.BaseContent,
                                TextSize = Theme.TextSize.Subtitle,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                ZIndex = 11,
                                [Children] = {
                                    p1:New("UIFlexItem")({
                                        FlexMode = Enum.UIFlexMode.Fill
                                    })
                                }
                            }),
                            Pressable(p1, {
                                name = "CloseButton",
                                layoutOrder = 2,
                                size = p1:Computed(function(p18) -- line: 203
                                    -- upvalues: Theme (copy)
                                    local v15 = p18(Theme.TextSize.Subtitle)

                                    return UDim2.fromOffset(v15, v15)
                                end),
                                zIndex = 11,
                                iconImage = Icons.Close,
                                iconColor = Theme.Color.NeutralContentDark,
                                iconSize = Theme.TextSize.Subtitle,
                                onActivate = function() -- onActivate | line: 211
                                    -- upvalues: p2 (copy), v2 (copy)
                                    p2.visible:set(false)
                                    v2:ReleaseFocus()
                                end,
                                [Children] = {
                                    p1:New("UIAspectRatioConstraint")({
                                        AspectRatio = 1
                                    })
                                }
                            })
                        }
                    }),
                    v6
                }
            })
        }
    })
end
