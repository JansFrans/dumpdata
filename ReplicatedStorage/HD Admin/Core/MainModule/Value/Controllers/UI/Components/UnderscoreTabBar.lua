-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Viewport = require(UI.Config.Viewport)
local Pressable = require(UI.Components.Pressable)
local ClipHighlight = require(UI.Components.ClipHighlight)
local Children, Out = Fusion.Children, Fusion.Out

return function(p1, p2) -- line: 40
    -- upvalues: Fusion (copy), Theme (copy), Viewport (copy), Pressable (copy), ClipHighlight (copy), Children (copy), Out (copy)
    local tabs, activeTab, onTabChange = p2.tabs, p2.activeTab, p2.onTabChange
    local v1 = p2.underlineHeight or 2
    local v2 = p2.underlineInset or 0
    local height = p2.height
    local t1 = {}
    local t2 = {}

    for i = 1, #tabs do
        t1[i] = p1:Value(Vector2.zero)
        t2[i] = p1:Value(Vector2.zero)
    end

    local v3 = p1:Value(Vector2.zero)
    local t3 = {
        p1:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    }

    for v4, v5 in tabs do
        local v6 = #tabs
        local v7 = p1:Computed(function(p3) -- line: 69
            -- upvalues: activeTab (copy), v4 (copy)
            return p3(activeTab) == v4
        end)
        local v8 = p1:Value(false)
        local v9 = p1:Value(false)
        local v10 = v4 == 1
        local v11 = v4 == v6
        local v12 = if v10 then "left" else "right"
        local v13 = not v10 and not v11
        local v14 = v6 == 1
        local v15 = if typeof(v5.label) == "string" then v5.label else tostring(v4)
        local Frame = p1:New("Frame")
        local t4 = {
            Name = "Tab_" .. v15
        }

        t4.AutomaticSize = if height then Enum.AutomaticSize.None else Enum.AutomaticSize.Y
        t4.BackgroundTransparency = 1
        t4.Size = UDim2.new(0, 0, 0, height or 0)
        t4.LayoutOrder = v4
        t4.Visible = v5.visible
        t4[Out("AbsolutePosition")] = t1[v4]
        t4[Out("AbsoluteSize")] = t2[v4]

        local v16 = p1:New("UIFlexItem")({
            FlexMode = Enum.UIFlexMode.Fill
        })
        local v17 = p1:New("Frame")({
            Name = "Track",
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = Color3.new(1, 1, 1),
            Position = UDim2.new(0, v2, 1, 0),
            Size = UDim2.new(1, -v2 * 2, 0, v1)
        })
        local t5 = {
            name = "TabPressable_" .. v15
        }

        if height then
            t5.size = UDim2.fromScale(1, 1)
            t5.automaticSize = nil
        else
            t5.size = UDim2.new(1, 0, 0, 0)
            t5.automaticSize = Enum.AutomaticSize.Y
        end

        t5.backgroundColor = nil
        t5.clipsDescendants = false

        function t5.onHoverChanged(p4) -- line: 113
            -- upvalues: v8 (copy)
            v8:set(p4)
        end

        function t5.onPressChanged(p5) -- line: 116
            -- upvalues: v9 (copy)
            v9:set(p5)
        end

        function t5.onActivate() -- line: 119
            -- upvalues: activeTab (copy), onTabChange (copy), v4 (copy), Fusion (copy)
            local v18 = Fusion.peek(activeTab)

            if v18 == v4 then
                return
            end

            activeTab:set(v4)

            if onTabChange then
                onTabChange(v4, v18)
            end
        end

        t5[Children] = {
            ClipHighlight(p1, {
                cornerRadius = 6,
                side = v12,
                hideCorner = v13,
                noExtend = v14,
                color = p1:Computed(function(p6) -- line: 134
                    -- upvalues: v8 (copy), v9 (copy), Theme (copy), Pressable (copy)
                    return Pressable.applyHighlight(p6, p6(Theme.Color.Neutral), v9, v8)
                end)
            }),
            p1:New("Frame")({
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 2,
                [Children] = {
                    p1:New("UIPadding")({
                        PaddingTop = UDim.new(0, height and 0 or 8),
                        PaddingBottom = UDim.new(0, if height then v1 else 10),
                        PaddingLeft = UDim.new(0, 4),
                        PaddingRight = UDim.new(0, 4)
                    }),
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        Padding = UDim.new(0, 4),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    }),
                    if v5.icon ~= nil then p1:New("ImageLabel")({
                        Name = "Icon",
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                        Image = v5.icon,
                        ImageColor3 = p1:Computed(function(p7) -- line: 163
                            -- upvalues: v7 (copy), Theme (copy)
                            if p7(v7) then
                                return (p7(Theme.Color.BaseContent))
                            end

                            return (p7(Theme.Color.NeutralContentDark))
                        end),
                        Size = UDim2.fromOffset(18, 18)
                    }) else nil,
                    p1:New("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,
                        RichText = true,
                        AutomaticSize = Enum.AutomaticSize.XY,
                        FontFace = p1:Computed(function(p8) -- line: 177
                            -- upvalues: Theme (copy)
                            return Font.new(p8(Theme.Font.Body), p8(Theme.FontWeight.Body))
                        end),
                        Text = v5.label,
                        TextColor3 = p1:Computed(function(p9) -- line: 182
                            -- upvalues: v7 (copy), Theme (copy)
                            if p9(v7) then
                                return (p9(Theme.Color.BaseContent))
                            end

                            return (p9(Theme.Color.NeutralContentDark))
                        end),
                        TextSize = Theme.TextSize.Subtitle
                    })
                }
            })
        }
        t4[Children] = {
            v16,
            v17,
            Pressable(p1, t5)
        }
        table.insert(t3, Frame(t4))
    end

    local v23 = p1:New("Frame")({
        Name = "Tabs",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 1,
        [Children] = t3
    })

    local function readVisible(p10, p11) -- line: 206
        if p11 == nil then
            return true
        end

        if typeof(p11) == "boolean" then
            return p11
        end

        return p10(p11) == true
    end

    local t11 = {}
    local v24 = p1:Computed(function(p12) -- line: 216
        -- upvalues: activeTab (copy), v2 (copy), t1 (copy), v3 (copy), Viewport (copy)
        local v26 = t1[p12(activeTab)]

        if v26 == nil then
            return 0
        end

        local v27 = p12(Viewport.Scale)

        if v27 <= 0 then
            v27 = 1
        end

        return (p12(v26).X - p12(v3).X) / v27 + v2
    end)
    local v28 = p1:Computed(function(p13) -- line: 225
        -- upvalues: activeTab (copy), v2 (copy), t2 (copy), Viewport (copy)
        local v30 = t2[p13(activeTab)]

        if v30 == nil then
            return 0
        end

        local v31 = p13(Viewport.Scale)

        if v31 <= 0 then
            v31 = 1
        end

        return p13(v30).X / v31 - v2 * 2
    end)
    local v32 = p1:Spring(v24, 45, 1)
    local v33 = p1:Computed(function(p14) -- line: 236
        -- upvalues: tabs (copy), activeTab (copy)
        local v35 = tabs[p14(activeTab)]

        if v35 == nil then
            return false
        end

        local visible = v35.visible

        if visible == nil then
            return true
        end

        if typeof(visible) == "boolean" then
            return visible
        end

        return p14(visible) == true
    end)

    table.insert(t11, p1:New("Frame")({
        Name = "Indicator",
        BorderSizePixel = 0,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0, 1),
        Visible = v33,
        BackgroundColor3 = Theme.Color.Primary,
        Position = p1:Computed(function(p15) -- line: 249
            -- upvalues: v32 (copy)
            return UDim2.new(0, p15(v32), 1, 0)
        end),
        Size = p1:Computed(function(p16) -- line: 252
            -- upvalues: v1 (copy), v28 (copy)
            return UDim2.fromOffset(p16(v28), v1)
        end)
    }))

    local v36 = p1:New("Frame")({
        Name = "Underlines",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 2,
        [Children] = t11
    })

    return p1:New("Frame")({
        Name = "UnderscoreTabBar",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Color.Neutral,
        LayoutOrder = p2.layoutOrder or 0,
        Size = UDim2.new(1, 0, 0, 0),
        [Out("AbsolutePosition")] = v3,
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke,
                [Children] = {
                    p1:New("UIGradient")({
                        Rotation = 90,
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
                        })
                    })
                }
            }),
            v23,
            v36
        }
    })
end
