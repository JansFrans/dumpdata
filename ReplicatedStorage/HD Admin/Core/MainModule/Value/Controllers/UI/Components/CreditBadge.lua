-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Pressable = require(UI.Components.Pressable)
local Children = Fusion.Children

return function(p1, p2) -- line: 30
    -- upvalues: Theme (copy), Pressable (copy), Children (copy)
    local v1 = p2.text or "0.0.0"
    local v2 = p2.icon or ""
    local v3 = p1:Computed(function(p3) -- line: 34
        -- upvalues: v2 (copy)
        local v4 = if typeof(v2) == "table" then p3(v2) else v2

        return v4 ~= nil and v4 ~= ""
    end)
    local t4 = {
        p1:New("UICorner")({
            CornerRadius = UDim.new(1, 0)
        }),
        p1:New("UIPadding")({
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, p2.paddingRight or 8),
            PaddingTop = UDim.new(0, 8)
        }),
        p1:New("UIStroke")({
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = if p2.strokeColor == nil then Theme.Color.NeutralContent else p2.strokeColor
        }),
        p1:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 9),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }),
        p1:New("ImageLabel")({
            Name = "Icon",
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Image = v2,
            ImageColor3 = if p2.iconColor == nil then Color3.new(1, 1, 1) else p2.iconColor,
            Size = UDim2.fromOffset(18, 18),
            Visible = v3
        }),
        p1:New("TextLabel")({
            Name = "Text",
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            TextWrapped = false,
            AutomaticSize = Enum.AutomaticSize.XY,
            FontFace = p1:Computed(function(p4) -- line: 73
                -- upvalues: Theme (copy)
                return Font.new(p4(Theme.Font.Body), p4(Theme.FontWeight.Body))
            end),
            Text = v1,
            TextColor3 = if p2.textColor == nil then Theme.Color.BaseContent else p2.textColor,
            TextSize = Theme.TextSize.Subtitle
        })
    }

    if p2.onActivate then
        return Pressable(p1, {
            name = "CreditBadge",
            automaticSize = Enum.AutomaticSize.XY,
            backgroundColor = p2.backgroundColor or Theme.Color.Neutral,
            layoutOrder = p2.layoutOrder,
            onActivate = p2.onActivate,
            size = UDim2.new(0, 0, 0, 0),
            [Children] = t4
        })
    end

    return p1:New("Frame")({
        Name = "CreditBadge",
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = if p2.backgroundColor == nil then Theme.Color.Neutral else p2.backgroundColor,
        BackgroundTransparency = if p2.backgroundTransparency == nil then 0 else p2.backgroundTransparency,
        LayoutOrder = p2.layoutOrder,
        [Children] = t4
    })
end
