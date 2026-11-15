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
    local isOn = p2.isOn
    local v1 = p1:Value(false)
    local v2 = p1:Value(false)
    local v3 = p1:Computed(function(p3) -- line: 31
        -- upvalues: isOn (copy), v1 (copy), v2 (copy), Theme (copy)
        local v4 = if p3(isOn) then p3(Theme.Color.Primary) else p3(Theme.Color.NeutralContent)
        local v5 = if 0.299 * v4.R + 0.587 * v4.G + 0.114 * v4.B > 0.5 then Color3.new(0, 0, 0) else Color3.new(1, 1, 1)

        if p3(v2) then
            return v4:Lerp(v5, 0.2)
        end

        if p3(v1) then
            return v4:Lerp(v5, 0.1)
        end

        return v4
    end)

    return p1:New("Frame")({
        Name = p2.name or "InlineToggleRow",
        BackgroundColor3 = Theme.Color.Neutral,
        LayoutOrder = p2.layoutOrder,
        Size = if p2.fills then UDim2.new(0, 0, 0, 38) else UDim2.new(1, 0, 0, 38),
        Visible = p2.visible,
        [Children] = {
            if p2.fills then p1:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }) else nil,
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p1:New("UIPadding")({
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 8)
            }),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p1:New("TextLabel")({
                Name = "Label",
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                AutomaticSize = Enum.AutomaticSize.XY,
                FontFace = p1:Computed(function(p4) -- line: 67
                    -- upvalues: Theme (copy)
                    return Font.new(p4(Theme.Font.Body), p4(Theme.FontWeight.Regular))
                end),
                Text = p2.label,
                TextColor3 = Theme.Color.NeutralContentDark,
                TextSize = Theme.TextSize.Subtitle
            }),
            Pressable(p1, {
                name = "InlineToggle",
                size = UDim2.fromOffset(48, 26),
                layoutOrder = 2,
                onActivate = p2.onToggle,
                onHoverChanged = function(p5) -- onHoverChanged | line: 80
                    -- upvalues: v1 (copy)
                    v1:set(p5)
                end,
                onPressChanged = function(p6) -- onPressChanged | line: 81
                    -- upvalues: v2 (copy)
                    v2:set(p6)
                end,
                [Children] = {
                    p1:New("Frame")({
                        Name = "Track",
                        BackgroundColor3 = v3,
                        Size = UDim2.fromScale(1, 1),
                        [Children] = {
                            p1:New("UICorner")({
                                CornerRadius = UDim.new(1, 0)
                            }),
                            p1:New("Frame")({
                                Name = "Thumb",
                                AnchorPoint = Vector2.new(0, 0.5),
                                BackgroundColor3 = Color3.new(1, 1, 1),
                                Position = p1:Spring(p1:Computed(function(p7) -- line: 93
                                    -- upvalues: isOn (copy)
                                    if p7(isOn) then
                                        return (UDim2.new(1, -22, 0.5, 0))
                                    end

                                    return (UDim2.new(0, 4, 0.5, 0))
                                end), 40, 1),
                                Size = UDim2.fromOffset(16, 16),
                                ZIndex = 2,
                                [Children] = {
                                    p1:New("UICorner")({
                                        CornerRadius = UDim.new(1, 0)
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
