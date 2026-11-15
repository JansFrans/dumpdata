-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Viewport = require(UI.Config.Viewport)
local PageButton = require(UI.Components.PageButton)
local Navigation = require(UI.Config.Navigation)
local DashboardSections = require(UI.Config.DashboardSections)
local Permissions = require(UI.Util.Permissions)
local Prompt = require(Modules.Prompt)
local Children, Out = Fusion.Children, Fusion.Out

return function(p1, p2) -- line: 28
    -- upvalues: Fusion (copy), Theme (copy), Viewport (copy), PageButton (copy), Navigation (copy), DashboardSections (copy), Permissions (copy), Prompt (copy), Children (copy), Out (copy)
    local onPageActivate = p2.onPageActivate
    local v1 = p1:Computed(function(p3) -- line: 31
        -- upvalues: p2 (copy), Viewport (copy)
        local contentHeight = p2.contentHeight

        return (if contentHeight == nil or typeof(contentHeight) ~= "table" then contentHeight or 0 else p3(contentHeight)) > p3(Viewport.MenuHeightPixels)
    end)
    local v2 = p1:Value(Navigation.children or {})
    local v3 = p1:Value(Vector2.zero)

    return p1:New("Frame")({
        Name = "MenuPage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            p1:New("ScrollingFrame")({
                Name = "Scroller",
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BottomImage = "rbxassetid://16547643439",
                CanvasSize = UDim2.new(),
                MidImage = "rbxassetid://16547330984",
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                TopImage = "rbxassetid://16547667444",
                Size = UDim2.fromScale(1, 1),
                [Children] = {
                    p1:New("UIPadding")({
                        PaddingTop = UDim.new(0, 1),
                        PaddingBottom = UDim.new(0, 1),
                        PaddingLeft = UDim.new(0, 1),
                        PaddingRight = UDim.new(0, 1)
                    }),
                    p1:New("UIListLayout")({
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly,
                        Padding = UDim.new(0, 7),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p1:New("Frame")({
                        Name = "Pages",
                        AutomaticSize = Enum.AutomaticSize.XY,
                        BackgroundTransparency = 1,
                        [Children] = {
                            p1:New("UIPadding")({
                                PaddingTop = UDim.new(0, 1),
                                PaddingBottom = UDim.new(0, 1),
                                PaddingLeft = UDim.new(0, 1),
                                PaddingRight = UDim.new(0, 1)
                            }),
                            p1:New("UIListLayout")({
                                Wraps = true,
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                Padding = UDim.new(0, 8),
                                SortOrder = Enum.SortOrder.LayoutOrder
                            }),
                            p1:ForValues(v2, function(_, p5, p6) -- line: 95
                                -- upvalues: onPageActivate (copy), Fusion (copy), PageButton (copy), DashboardSections (copy), Permissions (copy), Prompt (copy)
                                local v8 = DashboardSections[p6.id] or {}
                                local v9 = Permissions.canViewAnyOf(p5, v8)
                                local v10 = Permissions.youReady(p5)
                                local v11 = p5:Computed(function(p7) -- line: 102
                                    -- upvalues: v9 (copy), v10 (copy)
                                    return p7(v10) and not p7(v9)
                                end)

                                return PageButton(p5, {
                                    pageId = p6.id,
                                    size = UDim2.new(0.5, -5, 0, 0),
                                    dimmed = v11,
                                    onActivate = function() -- onActivate | line: 109
                                        -- upvalues: p6 (copy), v11 (copy), onPageActivate (copy), Fusion (copy), Prompt (copy)
                                        if Fusion.peek(v11) then
                                            Prompt.error("You do not have permission to view this section.")
                                        elseif onPageActivate then
                                            local v12 = if typeof(onPageActivate) == "table" then Fusion.peek(onPageActivate) else onPageActivate

                                            if v12 then
                                                v12(p6.id)
                                            end
                                        end
                                    end
                                })
                            end)
                        }
                    }),
                    p1:New("TextButton")({
                        Name = "HiddenContent",
                        AutoButtonColor = false,
                        AutomaticSize = p1:Computed(function(p8) -- line: 130
                            -- upvalues: v1 (copy)
                            if p8(v1) then
                                return Enum.AutomaticSize.Y
                            end

                            return Enum.AutomaticSize.None
                        end),
                        [Out("AbsoluteSize")] = v3,
                        BackgroundColor3 = Theme.Color.Neutral,
                        ClipsDescendants = true,
                        FontFace = p1:Computed(function(p9) -- line: 136
                            -- upvalues: Theme (copy)
                            return Font.new(p9(Theme.Font.Body), p9(Theme.FontWeight.Body))
                        end),
                        Size = UDim2.new(1, -6, 0, 0),
                        Text = "",
                        TextColor3 = Theme.Color.BaseContent,
                        TextSize = Theme.TextSize.Body,
                        [Children] = {
                            p1:New("UIFlexItem")({
                                Name = "UIFlexItem",
                                FlexMode = Enum.UIFlexMode.Fill
                            }),
                            p1:New("UICorner")({
                                Name = "UICorner",
                                CornerRadius = UDim.new(0, 9)
                            }),
                            p1:New("UIPadding")({
                                Name = "UIPadding",
                                PaddingBottom = p1:Computed(function(p10) -- line: 157
                                    -- upvalues: Theme (copy)
                                    return UDim.new(0, p10(Theme.Layout.Padding))
                                end),
                                PaddingLeft = p1:Computed(function(p11) -- line: 158
                                    -- upvalues: Theme (copy)
                                    return UDim.new(0, p11(Theme.Layout.Padding))
                                end),
                                PaddingRight = p1:Computed(function(p12) -- line: 159
                                    -- upvalues: Theme (copy)
                                    return UDim.new(0, p12(Theme.Layout.Padding))
                                end),
                                PaddingTop = p1:Computed(function(p13) -- line: 160
                                    -- upvalues: Theme (copy)
                                    return UDim.new(0, p13(Theme.Layout.Padding))
                                end)
                            }),
                            p1:New("UIStroke")({
                                Name = "UIStroke",
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Color = Theme.Color.NeutralContent,
                                Thickness = Theme.Layout.StrokeThickness,
                                Enabled = p1:Computed(function(p14) -- line: 168
                                    -- upvalues: v3 (copy)
                                    return p14(v3).Y > 0
                                end)
                            }),
                            p1:New("UIListLayout")({
                                Name = "UIListLayout",
                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                Padding = UDim.new(0, 5),
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center
                            })
                        }
                    }),
                    p1:New("Frame")({
                        Name = "PaddingBottom",
                        BackgroundTransparency = 1,
                        ClipsDescendants = true,
                        LayoutOrder = 999,
                        Size = UDim2.fromScale(1, 0),
                        Visible = p1:Computed(function(p15) -- line: 190
                            -- upvalues: v3 (copy)
                            return p15(v3).Y > 0
                        end)
                    })
                }
            })
        }
    })
end
