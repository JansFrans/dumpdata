-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Pressable = require(UI.Components.Pressable)
local Icons = require(UI.Config.Icons)
local Children = Fusion.Children

return function(p1, p2) -- line: 37
    -- upvalues: Theme (copy), Pressable (copy), Icons (copy), Children (copy)
    local v1 = p2.zIndex or 10
    local v2 = v1 + 1
    local v3 = p2.dismissible == nil or p2.dismissible
    local v4 = p2.backdropDismiss == nil or p2.backdropDismiss
    local v5 = p2.showClose == nil or p2.showClose

    local function close() -- line: 44
        -- upvalues: p2 (copy), v3 (copy)
        if v3 then
            if p2.onClose then
                p2.onClose()
            else
                p2.visible:set(false)
            end
        end
    end

    local function onBackdropActivate() -- line: 53
        -- upvalues: p2 (copy), v3 (copy), v4 (copy)
        if v4 and v3 then
            if p2.onClose then
                p2.onClose()
            else
                p2.visible:set(false)
            end
        end
    end

    local t1 = {
        p1:New("UICorner")({
            CornerRadius = p1:Computed(function(p3) -- line: 60
                -- upvalues: Theme (copy)
                return UDim.new(0, (p3(Theme.Layout.CornerRadius)))
            end)
        }),
        p1:New("UIStroke")({
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Theme.Color.NeutralStroke
        }),
        p1:New("UIPadding")({
            PaddingTop = UDim.new(0, p2.topPadding or 8),
            PaddingBottom = p1:Computed(function(p4) -- line: 70
                -- upvalues: Theme (copy)
                return UDim.new(0, (p4(Theme.Layout.Padding)))
            end),
            PaddingLeft = p1:Computed(function(p5) -- line: 71
                -- upvalues: Theme (copy)
                return UDim.new(0, (p5(Theme.Layout.Padding)))
            end),
            PaddingRight = p1:Computed(function(p6) -- line: 72
                -- upvalues: Theme (copy)
                return UDim.new(0, (p6(Theme.Layout.Padding)))
            end)
        }),
        p1:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
    }
    local t2 = {
        p1:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }),
        if p2.titleContent then p1:New("Frame")({
            Name = "TitleContent",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.fromScale(0, 0),
            ZIndex = v2,
            [Children] = {
                p1:New("UIFlexItem")({
                    FlexMode = Enum.UIFlexMode.Fill
                }),
                p1:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.None,
                    VerticalFlex = Enum.UIFlexAlignment.None,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                p2.titleContent
            }
        }) else p1:New("TextLabel")({
            Name = "Title",
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1,
            FontFace = p1:Computed(function(p7) -- line: 112
                -- upvalues: Theme (copy)
                return Font.new(p7(Theme.Font.Heading), p7(Theme.FontWeight.Heading))
            end),
            LayoutOrder = 1,
            Text = p2.title,
            TextColor3 = Theme.Color.BaseContent,
            TextSize = Theme.TextSize.Subtitle,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = v2,
            [Children] = {
                p1:New("UIFlexItem")({
                    FlexMode = Enum.UIFlexMode.Fill
                })
            }
        })
    }

    if v5 then
        table.insert(t2, Pressable(p1, {
            name = "CloseButton",
            layoutOrder = 2,
            size = p1:Computed(function(p8) -- line: 130
                -- upvalues: Theme (copy)
                local v8 = p8(Theme.TextSize.Subtitle)

                return UDim2.fromOffset(v8, v8)
            end),
            zIndex = v2,
            iconImage = Icons.Close,
            iconColor = Theme.Color.NeutralContentDark,
            iconSize = Theme.TextSize.Subtitle,
            onActivate = close,
            [Children] = {
                p1:New("UIAspectRatioConstraint")({
                    AspectRatio = 1
                })
            }
        }))
    end

    table.insert(t1, p1:New("Frame")({
        Name = "Header",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromScale(1, 0),
        ZIndex = v2,
        [Children] = t2
    }))

    local v9 = p2.cardSize ~= nil
    local t6 = {
        p1:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            VerticalFlex = if v9 then Enum.UIFlexAlignment.Fill else Enum.UIFlexAlignment.None,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = p1:Computed(function(p9) -- line: 161
                -- upvalues: Theme (copy)
                return UDim.new(0, (p9(Theme.Layout.Padding)))
            end)
        }),
        table.unpack(p2.content)
    }

    if v9 then
        table.insert(t6, 1, p1:New("UIFlexItem")({
            FlexMode = Enum.UIFlexMode.Fill
        }))
    end

    table.insert(t1, p1:New("Frame")({
        Name = "Body",
        AutomaticSize = if v9 then Enum.AutomaticSize.None else Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ClipsDescendants = false,
        LayoutOrder = 2,
        Size = UDim2.fromScale(1, 0),
        ZIndex = v2,
        [Children] = t6
    }))

    if p2.actions and #p2.actions > 0 then
        table.insert(t1, p1:New("Frame")({
            Name = "Actions",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Size = UDim2.fromScale(1, 0),
            ZIndex = v2,
            [Children] = {
                p1:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = p1:Computed(function(p10) -- line: 193
                        -- upvalues: Theme (copy)
                        return UDim.new(0, (p10(Theme.Layout.Padding)))
                    end)
                }),
                table.unpack(p2.actions)
            }
        }))
    end

    return p1:New("Frame")({
        Name = "Popup",
        BackgroundColor3 = Theme.Color.NeutralDark,
        BackgroundTransparency = if p2.backdropTransparency == nil then 0.05 else p2.backdropTransparency,
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1),
        Visible = p2.visible,
        ZIndex = v1,
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            Pressable(p1, {
                name = "Backdrop",
                size = UDim2.fromScale(1, 1),
                zIndex = v1,
                onActivate = onBackdropActivate
            }),
            p1:New("TextButton")({
                Name = "Card",
                Active = true,
                AutoButtonColor = false,
                AutomaticSize = if v9 then Enum.AutomaticSize.None else Enum.AutomaticSize.Y,
                AnchorPoint = p2.anchorPoint or Vector2.new(0.5, 0.5),
                BackgroundColor3 = Theme.Color.Neutral,
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = p2.cardSize or p1:Computed(function(p11) -- line: 229
                    -- upvalues: p2 (copy), Theme (copy)
                    if p2.cardWidth == nil then
                        return UDim2.new(1, -p11(Theme.Layout.Padding) * 2, 0, 0)
                    end

                    return UDim2.fromOffset(p11(p2.cardWidth), 0)
                end),
                Text = "",
                TextSize = 1,
                TextTransparency = 1,
                ZIndex = v2,
                [Children] = t1
            })
        }
    })
end
