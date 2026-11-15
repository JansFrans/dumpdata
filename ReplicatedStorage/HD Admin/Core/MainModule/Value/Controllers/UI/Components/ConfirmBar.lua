-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Pressable = require(UI.Components.Pressable)
local Children = Fusion.Children

return function(p1, p2) -- line: 27
    -- upvalues: Theme (copy), Pressable (copy), Children (copy)
    local hasPendingChanges = p2.hasPendingChanges
    local v1 = p2.label or "Confirm?"

    return p1:New("Frame")({
        Name = "ConfirmBarWrap",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        LayoutOrder = p2.layoutOrder,
        Size = p1:Spring(p1:Computed(function(p3) -- line: 36
            -- upvalues: hasPendingChanges (copy)
            return UDim2.new(1, 0, 0, if p3(hasPendingChanges) then 54 else 0)
        end), 40, 1),
        [Children] = {
            p1:New("Frame")({
                Name = "ConfirmBar",
                AnchorPoint = Vector2.new(0, 0.5),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Color.Neutral,
                Position = UDim2.new(0, 2, 0.5, 0),
                Size = UDim2.new(1, -7, 0, -2),
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    }),
                    p1:New("UIStroke")({
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = Theme.Color.NeutralContent
                    }),
                    p1:New("UIPadding")({
                        PaddingBottom = UDim.new(0, 14),
                        PaddingLeft = UDim.new(0, 12),
                        PaddingRight = UDim.new(0, 4),
                        PaddingTop = UDim.new(0, 14)
                    }),
                    p1:New("Frame")({
                        Name = "LabelGroup",
                        AnchorPoint = Vector2.new(0, 0.5),
                        AutomaticSize = Enum.AutomaticSize.XY,
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(0, 0.5),
                        [Children] = {
                            p1:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center
                            }),
                            p1:New("TextLabel")({
                                Name = "Label",
                                BackgroundTransparency = 1,
                                AutomaticSize = Enum.AutomaticSize.XY,
                                FontFace = p1:Computed(function(p4) -- line: 79
                                    -- upvalues: Theme (copy)
                                    return Font.new(p4(Theme.Font.Body), p4(Theme.FontWeight.Body))
                                end),
                                Text = v1,
                                TextColor3 = Theme.Color.BaseContent,
                                TextSize = Theme.TextSize.Subtitle
                            })
                        }
                    }),
                    p1:New("Frame")({
                        Name = "ButtonGroup",
                        AnchorPoint = Vector2.new(1, 0.5),
                        AutomaticSize = Enum.AutomaticSize.XY,
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(1, 0.5),
                        [Children] = {
                            p1:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalFlex = Enum.UIFlexAlignment.None,
                                Padding = UDim.new(0, 6),
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center
                            }),
                            Pressable(p1, {
                                name = "ConfirmButton",
                                size = UDim2.new(0, 0, 0, 0),
                                automaticSize = Enum.AutomaticSize.XY,
                                backgroundColor = Theme.Color.Primary,
                                layoutOrder = 1,
                                onActivate = p2.confirmChanges,
                                [Children] = {
                                    p1:New("UICorner")({
                                        CornerRadius = UDim.new(0, 6)
                                    }),
                                    p1:New("UIPadding")({
                                        PaddingBottom = UDim.new(0, 7),
                                        PaddingLeft = UDim.new(0, 12),
                                        PaddingRight = UDim.new(0, 12),
                                        PaddingTop = UDim.new(0, 7)
                                    }),
                                    p1:New("TextLabel")({
                                        Name = "Label",
                                        BackgroundTransparency = 1,
                                        Text = "Confirm",
                                        AutomaticSize = Enum.AutomaticSize.XY,
                                        FontFace = p1:Computed(function(p5) -- line: 123
                                            -- upvalues: Theme (copy)
                                            return Font.new(p5(Theme.Font.Body), p5(Theme.FontWeight.Body))
                                        end),
                                        TextColor3 = Theme.Color.PrimaryContent,
                                        TextSize = Theme.TextSize.Subtitle
                                    })
                                }
                            }),
                            Pressable(p1, {
                                name = "UndoButton",
                                size = UDim2.new(0, 0, 0, 0),
                                automaticSize = Enum.AutomaticSize.XY,
                                backgroundColor = Theme.Color.NeutralContent,
                                layoutOrder = 2,
                                onActivate = p2.undoChanges,
                                [Children] = {
                                    p1:New("UICorner")({
                                        CornerRadius = UDim.new(0, 6)
                                    }),
                                    p1:New("UIPadding")({
                                        PaddingBottom = UDim.new(0, 7),
                                        PaddingLeft = UDim.new(0, 12),
                                        PaddingRight = UDim.new(0, 12),
                                        PaddingTop = UDim.new(0, 7)
                                    }),
                                    p1:New("TextLabel")({
                                        Name = "Label",
                                        BackgroundTransparency = 1,
                                        Text = "Undo",
                                        AutomaticSize = Enum.AutomaticSize.XY,
                                        FontFace = p1:Computed(function(p6) -- line: 152
                                            -- upvalues: Theme (copy)
                                            return Font.new(p6(Theme.Font.Body), p6(Theme.FontWeight.Body))
                                        end),
                                        TextColor3 = Theme.Color.BaseContent,
                                        TextSize = Theme.TextSize.Subtitle
                                    })
                                }
                            })
                        }
                    })
                }
            })
        }
    })
end
