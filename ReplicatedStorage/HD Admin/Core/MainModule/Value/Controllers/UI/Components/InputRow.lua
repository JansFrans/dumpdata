-- https://lua.expert

local Packages = script:FindFirstAncestor("MainModule").Value.Packages
local UI = script:FindFirstAncestor("MainModule").Value.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children

return function(p1, p2) -- line: 36
    -- upvalues: Theme (copy), Children (copy)
    local v1 = p2.title or ""
    local labelPaddingTop = p2.labelPaddingTop
    local v2 = p2.fixedHeight or 36
    local Frame = p1:New("Frame")
    local t1 = {
        Name = p2.name or "InputRow"
    }

    t1.AutomaticSize = if p2.autoHeight then Enum.AutomaticSize.Y else Enum.AutomaticSize.None
    t1.BackgroundTransparency = 1
    t1.Size = if p2.autoHeight then UDim2.fromScale(1, 0) else UDim2.new(1, 0, 0, v2)

    local v3 = p1:New("UIListLayout")({
        Name = "UIListLayout",
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = if labelPaddingTop then Enum.VerticalAlignment.Top else Enum.VerticalAlignment.Center
    })
    local v4 = if p2.labelIcon then p1:New("ImageLabel")({
        Name = "InputLabel",
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Image = p2.labelIcon,
        Size = p2.labelSize or UDim2.fromOffset(18, 18),
        ImageColor3 = Theme.Color.NeutralContentMain
    })
        elseif v1 ~= "" then p1:New("TextLabel")({
            Name = "InputLabel",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            FontFace = p1:Computed(function(p3) -- line: 69
                -- upvalues: Theme (copy)
                return Font.new(p3(Theme.Font.Body), Enum.FontWeight.Medium)
            end),
            LayoutOrder = 1,
            RichText = true,
            Size = p2.labelSize or UDim2.fromOffset(72, 0),
            Text = v1 .. ":",
            TextColor3 = Theme.Color.NeutralContentMain,
            TextSize = p2.labelTextSize or Theme.TextSize.Subtitle,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            [Children] = {
                if labelPaddingTop then p1:New("UIPadding")({
                    Name = "UIPadding",
                    PaddingTop = UDim.new(0, labelPaddingTop)
                }) else nil
            }
        })
        else nil

    t1[Children] = {
        v3,
        v4,
        p1:New("Frame")({
            Name = "InputFrame",
            AutomaticSize = if p2.autoHeight then Enum.AutomaticSize.Y else Enum.AutomaticSize.None,
            BackgroundColor3 = Theme.Color.Neutral,
            BackgroundTransparency = p2.frameTransparency or 0,
            ClipsDescendants = p2.clipsDescendants or false,
            LayoutOrder = 2,
            Size = if p2.autoHeight then UDim2.fromOffset(0, 0) else UDim2.new(0, 0, 0, v2),
            [Children] = {
                p1:New("UIFlexItem")({
                    Name = "UIFlexItem",
                    FlexMode = Enum.UIFlexMode.Fill
                }),
                p1:New("UICorner")({
                    Name = "UICorner",
                    CornerRadius = UDim.new(0, 6)
                }),
                p1:New("UIPadding")({
                    Name = "UIPadding",
                    PaddingBottom = UDim.new(0, p2.framePaddingBottom or p2.framePaddingY or 9),
                    PaddingLeft = UDim.new(0, p2.framePaddingX or 8),
                    PaddingRight = UDim.new(0, p2.framePaddingRight or p2.framePaddingX or 8),
                    PaddingTop = UDim.new(0, p2.framePaddingTop or p2.framePaddingY or 9)
                }),
                if not p2.hideStroke then p1:New("UIStroke")({
                    Name = "UIStroke",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = if p2.strokeFocused == nil then Theme.Color.NeutralStroke else p1:Spring(p1:Computed(function(p4) -- line: 118
                        -- upvalues: p2 (copy), Theme (copy)
                        if p4(p2.strokeFocused) then
                            return (p4(Theme.Color.Primary))
                        end

                        return (p4(Theme.Color.NeutralStroke))
                    end), 40, 1)
                }) else nil,
                p2[Children]
            }
        })
    }

    return Frame(t1)
end
