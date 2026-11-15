-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Pressable = require(UI.Components.Pressable)
local Children = Fusion.Children

return function(p1, p2) -- line: 30
    -- upvalues: Fusion (copy), Theme (copy), Pressable (copy), Children (copy)
    local tabs, activeTab, onTabChange = p2.tabs, p2.activeTab, p2.onTabChange
    local v1 = p2.collapseInactive or false
    local t1 = {
        p1:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 9),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    }

    for v2, v3 in tabs do
        local v4 = p1:Computed(function(p3) -- line: 49
            -- upvalues: activeTab (copy), v2 (copy)
            return p3(activeTab) == v2
        end)
        local v5 = p1:Computed(function(p4) -- line: 54
            -- upvalues: v1 (copy), v4 (copy), v3 (copy)
            if p4(v1) == true then
                return not p4(v4) and v3.icon ~= nil
            end

            return false
        end)
        local t2 = {
            name = "Tab_" .. v3.label
        }

        t2.automaticSize = p1:Computed(function(p5) -- line: 60
            -- upvalues: v1 (copy), v4 (copy)
            if p5(v1) ~= true or not p5(v4) then
                return Enum.AutomaticSize.Y
            end

            return Enum.AutomaticSize.XY
        end)
        t2.size = UDim2.new(0, 0, 0, 0)
        t2.visible = v3.visible
        t2.backgroundColor = p1:Computed(function(p6) -- line: 67
            -- upvalues: v4 (copy), Theme (copy)
            if p6(v4) then
                return (p6(Theme.Color.Primary))
            end

            return (p6(Theme.Color.Neutral))
        end)
        t2.layoutOrder = v2
        t2.clipsDescendants = true

        function t2.onActivate() -- line: 72
            -- upvalues: activeTab (copy), onTabChange (copy), v2 (copy), Fusion (copy)
            local v6 = Fusion.peek(activeTab)

            if v6 == v2 then
                return
            end

            activeTab:set(v2)

            if onTabChange then
                onTabChange(v2, v6)
            end
        end

        local v7 = p1:New("UIFlexItem")({
            FlexMode = p1:Computed(function(p7) -- line: 83
                -- upvalues: v1 (copy), v4 (copy)
                if p7(v1) ~= true or not p7(v4) then
                    return Enum.UIFlexMode.Fill
                end

                return Enum.UIFlexMode.None
            end)
        })
        local v8 = p1:New("UICorner")({
            CornerRadius = UDim.new(0, 6)
        })
        local UIPadding = p1:New("UIPadding")
        local t4 = {}

        t4.PaddingTop = p1:Computed(function(p8) -- line: 91
            -- upvalues: v1 (copy)
            return UDim.new(0, if p8(v1) == true then 8 else 6)
        end)
        t4.PaddingBottom = p1:Computed(function(p9) -- line: 94
            -- upvalues: v1 (copy)
            return UDim.new(0, if p9(v1) == true then 8 else 6)
        end)
        t4.PaddingBottom = p1:Computed(function(p10) -- line: 97
            -- upvalues: v1 (copy)
            return UDim.new(0, if p10(v1) == true then 8 else 6)
        end)
        t4.PaddingBottom = p1:Computed(function(p11) -- line: 100
            -- upvalues: v1 (copy)
            return UDim.new(0, if p11(v1) == true then 8 else 6)
        end)
        t4.PaddingLeft = p1:Computed(function(p12) -- line: 103
            -- upvalues: v5 (copy)
            return UDim.new(0, if p12(v5) then 0 else 16)
        end)
        t4.PaddingRight = p1:Computed(function(p13) -- line: 106
            -- upvalues: v5 (copy)
            return UDim.new(0, if p13(v5) then 0 else 16)
        end)
        t2[Children] = {
            v7,
            v8,
            UIPadding(t4),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = p1:Computed(function(p14) -- line: 119
                    -- upvalues: v4 (copy), Theme (copy)
                    if p14(v4) then
                        return (p14(Theme.Color.Primary))
                    end

                    return (p14(Theme.Color.NeutralStroke))
                end),
                [Children] = {
                    p1:New("UIGradient")({
                        Rotation = 90,
                        Color = p1:Computed(function(p15) -- line: 124
                            -- upvalues: v4 (copy), Theme (copy)
                            if not p15(v4) then
                                return ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                                    ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
                                })
                            end

                            local v11 = p15(Theme.Color.Primary)

                            return ColorSequence.new({
                                ColorSequenceKeypoint.new(0, v11:Lerp(Color3.new(1, 1, 1), 0.1)),
                                ColorSequenceKeypoint.new(1, v11)
                            })
                        end)
                    })
                }
            }),
            p1:New("Frame")({
                Name = "IconText",
                AutomaticSize = p1:Computed(function(p16) -- line: 145
                    -- upvalues: v1 (copy)
                    if p16(v1) == true then
                        return Enum.AutomaticSize.X
                    end

                    return Enum.AutomaticSize.XY
                end),
                Size = p1:Computed(function(p17) -- line: 148
                    -- upvalues: v1 (copy)
                    if p17(v1) == true then
                        return (UDim2.fromOffset(0, 18))
                    end

                    return (UDim2.new())
                end),
                BackgroundTransparency = 1,
                [Children] = {
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        Padding = UDim.new(0, 4),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    }),
                    if v3.icon ~= nil then p1:New("ImageLabel")({
                        Name = "Icon",
                        BackgroundTransparency = 1,
                        Image = v3.icon,
                        ImageColor3 = p1:Computed(function(p18) -- line: 165
                            -- upvalues: v4 (copy), Theme (copy)
                            if p18(v4) then
                                return (p18(Theme.Color.PrimaryContent))
                            end

                            return (p18(Theme.Color.NeutralContentDark))
                        end),
                        Size = UDim2.fromOffset(18, 18)
                    }) else nil,
                    p1:New("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        AutomaticSize = Enum.AutomaticSize.XY,
                        Visible = p1:Computed(function(p19) -- line: 177
                            -- upvalues: v5 (copy)
                            return not p19(v5)
                        end),
                        FontFace = p1:Computed(function(p20) -- line: 180
                            -- upvalues: Theme (copy)
                            return Font.new(p20(Theme.Font.Body), p20(Theme.FontWeight.Body))
                        end),
                        Text = v3.label,
                        TextColor3 = p1:Computed(function(p21) -- line: 184
                            -- upvalues: v4 (copy), Theme (copy)
                            if p21(v4) then
                                return (p21(Theme.Color.PrimaryContent))
                            end

                            return (p21(Theme.Color.NeutralContentDark))
                        end),
                        TextSize = Theme.TextSize.Subtitle,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top
                    })
                }
            })
        }
        table.insert(t1, Pressable(p1, t2))
    end

    return p1:New("Frame")({
        Name = "TabBar",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = p2.layoutOrder or 0,
        Size = UDim2.new(1, 0, 0, 0),
        [Children] = t1
    })
end
