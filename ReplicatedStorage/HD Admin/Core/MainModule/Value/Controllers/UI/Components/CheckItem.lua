-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local Pressable = require(UI.Components.Pressable)
local Checkbox = require(UI.Components.Checkbox)
local HintIcon = require(UI.Components.HintIcon)
local Icons = require(UI.Config.Icons)

return function(p1, p2) -- line: 38
    -- upvalues: Fusion (copy), Theme (copy), Children (copy), Pressable (copy), Checkbox (copy), HintIcon (copy), Icons (copy)
    local v1 = p1:Value(p2.checked ~= nil and Fusion.peek(p2.checked))

    if p2.checked ~= nil then
        p1:Observer(p2.checked):onBind(function() -- line: 43
            -- upvalues: p2 (copy), v1 (copy), Fusion (copy)
            v1:set(Fusion.peek(p2.checked))
        end)
    end

    local onCheck = p2.onCheck
    local v2 = p1:Computed(function(p3) -- line: 49
        -- upvalues: p2 (copy), Theme (copy)
        local v3 = if p2.header == nil then nil else p3(p2.header)
        local v4 = if p2.body == nil then nil else p3(p2.body)
        local v5 = if p2.content == nil then "" else p3(p2.content)

        if not v3 then
            return v5
        end

        if not v4 or v4 == "" then
            return string.format("<b>%s</b>", v3)
        end

        local v6 = p3(Theme.Color.NeutralContentDark)
        local v12 = string.format("#%02X%02X%02X", math.round(v6.R * 255), math.round(v6.G * 255), (math.round(v6.B * 255)))

        return string.format("<b>%s</b> <font color=\"%s\">(%s)</font>", v3, v12, v4)
    end)
    local v13 = p1:Spring(p1:Computed(function(p4) -- line: 68
        -- upvalues: p2 (copy), Theme (copy)
        if p2.strongSelected ~= nil and p4(p2.strongSelected) then
            return (p4(Theme.Color.Primary))
        end

        return (p4(Theme.Color.Neutral))
    end), Theme.Animation.SpringSpeed, Theme.Animation.SpringDampening)
    local v14 = p1:Spring(p1:Computed(function(p5) -- line: 76
        -- upvalues: p2 (copy), Theme (copy)
        if p2.strongSelected ~= nil and p5(p2.strongSelected) then
            return (p5(Theme.Color.PrimaryContent))
        end

        return (p5(Theme.Color.BaseContent))
    end), Theme.Animation.SpringSpeed, Theme.Animation.SpringDampening)
    local v15 = p1:Spring(p1:Computed(function(p6) -- line: 84
        -- upvalues: p2 (copy)
        if p2.strongSelected ~= nil and p6(p2.strongSelected) then
            return 1
        end

        return 0.3
    end), Theme.Animation.SpringSpeed, Theme.Animation.SpringDampening)

    return Pressable(p1, {
        name = "CheckItem",
        automaticSize = Enum.AutomaticSize.Y,
        backgroundColor = v13,
        size = UDim2.fromScale(1, 0),
        clipsDescendants = true,
        onActivate = function() -- onActivate | line: 100
            -- upvalues: v1 (copy), onCheck (copy), Fusion (copy)
            local v16 = not Fusion.peek(v1)

            v1:set(v16)

            if onCheck then
                local v17 = if typeof(onCheck) == "table" then Fusion.peek(onCheck) else onCheck

                if v17 then
                    v17(v16)
                end
            end
        end,
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 9)
            }),
            p1:New("UIPadding")({
                Name = "UIPadding",
                PaddingBottom = UDim.new(0, 12),
                PaddingLeft = UDim.new(0, p2.hideCheckbox and 6 or 12),
                PaddingRight = UDim.new(0, p2.hideCheckbox and 6 or 12),
                PaddingTop = UDim.new(0, 12)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke,
                Transparency = v15
            }),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6)
            }),
            p1:New("Frame")({
                Name = "Spacer",
                BackgroundTransparency = 1,
                LayoutOrder = 1
            }),
            Checkbox(p1, {
                layoutOrder = 0,
                checked = v1,
                orderNumber = p2.orderNumber,
                visible = if p2.hideCheckbox == nil then nil else p1:Computed(function(p7) -- line: 141
                    -- upvalues: p2 (copy)
                    return not p7(p2.hideCheckbox)
                end)
            }),
            p1:New("Frame")({
                Name = "IconHolder",
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                Size = p1:Computed(function(p8) -- line: 150
                    -- upvalues: p2 (copy)
                    local v24 = if p2.category == nil then nil else p8(p2.category)

                    if v24 == "player" or v24 == "preset" then
                        return (UDim2.fromOffset(24, 0))
                    end

                    return (UDim2.fromOffset(28, 0))
                end),
                Visible = p2.icon ~= nil,
                [Children] = {
                    p1:New("ImageLabel")({
                        Name = "Icon",
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = p1:Computed(function(p9) -- line: 159
                            -- upvalues: p2 (copy)
                            if (if p2.category == nil then nil else p9(p2.category)) == "qualifier" then
                                return (Color3.fromRGB(194, 194, 200))
                            end

                            return (Color3.fromRGB(61, 61, 63))
                        end),
                        Image = p2.icon,
                        LayoutOrder = 2,
                        Position = UDim2.fromScale(1, 0.5),
                        ScaleType = Enum.ScaleType.Fit,
                        Size = p1:Computed(function(p10) -- line: 167
                            -- upvalues: p2 (copy)
                            local v25 = if p2.category == nil then nil else p10(p2.category)

                            if v25 == "player" or v25 == "preset" then
                                return (UDim2.fromOffset(24, 24))
                            end

                            return (UDim2.fromOffset(28, 28))
                        end),
                        [Children] = {
                            p1:New("UICorner")({
                                Name = "UICorner",
                                CornerRadius = UDim.new(0.5, 0)
                            }),
                            p1:New("UIStroke")({
                                Name = "UIStroke",
                                Color = Theme.Color.NeutralStroke,
                                Transparency = p1:Computed(function(p11) -- line: 179
                                    -- upvalues: p2 (copy)
                                    if (if p2.category == nil then nil else p11(p2.category)) == "qualifier" then
                                        return 0
                                    end

                                    return 1
                                end)
                            })
                        }
                    })
                }
            }),
            if p2.colorIndicator then p1:New("Frame")({
                Name = "ColorDot",
                BackgroundColor3 = p2.colorIndicator,
                LayoutOrder = 3,
                Size = UDim2.fromOffset(10, 10),
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            }) else nil,
            if p2.hintIcon then HintIcon(p1, {
                layoutOrder = 9,
                icon = p2.hintIcon,
                hintText = p2.hintText or "",
                iconColor = Theme.Color.Warning
            }) else nil,
            if p2.onRemove then Pressable(p1, {
                name = "RemoveButton",
                layoutOrder = 10,
                size = UDim2.fromOffset(28, 18),
                iconImage = Icons.Close,
                iconSize = 14,
                onActivate = p2.onRemove,
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    })
                }
            }) else nil,
            p1:New("Frame")({
                Name = "ContentArea",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 4,
                Size = if p2.hintIcon then UDim2.new(0.9, -26, 0, 0) else UDim2.fromScale(0.9, 0),
                [Children] = {
                    p1:New("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        RichText = true,
                        TextWrapped = true,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Size = UDim2.new(1, -6, 0, 0),
                        FontFace = if p2.labelFont then p2.labelFont else p1:Computed(function(p12) -- line: 236
                            -- upvalues: Theme (copy)
                            return Font.new(p12(Theme.Font.Body), p12(Theme.FontWeight.Regular))
                        end),
                        Text = v2,
                        TextColor3 = v14,
                        TextSize = Theme.TextSize.Subtitle,
                        TextTruncate = p1:Computed(function(p13) -- line: 243
                            -- upvalues: p2 (copy)
                            local v31 = if p2.category == nil then nil else p13(p2.category)

                            if v31 == "player" or v31 == "custom" or v31 == "in-game" then
                                return Enum.TextTruncate.SplitWord
                            end

                            return Enum.TextTruncate.None
                        end),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top
                    })
                }
            }),
            p1:New("Frame")({
                Name = "RightGutter",
                BackgroundTransparency = 1,
                LayoutOrder = 11,
                Size = UDim2.fromOffset(12, 1)
            })
        }
    })
end
