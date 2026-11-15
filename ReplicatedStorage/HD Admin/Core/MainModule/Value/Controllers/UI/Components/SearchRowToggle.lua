-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local Pressable = require(UI.Components.Pressable)

return function(p1, p2) -- line: 32
    -- upvalues: Theme (copy), Children (copy), Pressable (copy)
    local v1 = p1:Value(false)
    local v2 = p1:Computed(function(p3) -- line: 35
        -- upvalues: v1 (copy), Theme (copy)
        local v3 = p3(Theme.Color.Neutral)

        if not p3(v1) then
            return v3
        end

        return v3:Lerp(if 0.299 * v3.R + 0.587 * v3.G + 0.114 * v3.B > 0.5 then Color3.new(0, 0, 0) else Color3.new(1, 1, 1), 0.1)
    end)
    local v4 = p1:Computed(function(p4) -- line: 45
        -- upvalues: p2 (copy)
        local v5 = if p2.activeIcon == nil then nil else p4(p2.activeIcon)

        if not (p2.isActive ~= nil and p4(p2.isActive)) or not v5 then
            return p4(p2.icon)
        end

        return v5
    end)
    local NeutralContentMain = Theme.Color.NeutralContentMain

    return Pressable(p1, {
        name = p2.name or "SearchRowToggle",
        size = p2.size or UDim2.fromOffset(38, 38),
        layoutOrder = p2.layoutOrder,
        visible = p2.isVisible,
        backgroundColor = v2,
        onHoverChanged = function(p5) -- onHoverChanged | line: 63
            -- upvalues: p2 (copy), v1 (copy)
            v1:set(p5)

            if p2.onHoverChanged then
                p2.onHoverChanged(p5)
            end
        end,
        onActivate = p2.onActivate,
        [Children] = {
            p1:New("UIAspectRatioConstraint")({
                AspectRatio = 1,
                AspectType = Enum.AspectType.FitWithinMaxSize,
                DominantAxis = Enum.DominantAxis.Height
            }),
            p1:New("UICorner")({
                CornerRadius = if p2.cornerRadius == nil then UDim.new(0, 6) else p2.cornerRadius
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            if p2.text == nil then p1:New("ImageLabel")({
                Name = "Icon",
                BackgroundTransparency = 1,
                Image = v4,
                ImageColor3 = NeutralContentMain,
                Size = p2.iconSize or UDim2.fromOffset(20, 20)
            }) else p1:New("TextLabel")({
                Name = "Label",
                BackgroundTransparency = 1,
                TextSize = 20,
                AutomaticSize = Enum.AutomaticSize.XY,
                FontFace = p1:Computed(function(p6) -- line: 91
                    -- upvalues: Theme (copy)
                    return Font.new(p6(Theme.Font.Body), p6(Theme.FontWeight.Bold))
                end),
                Text = p2.text,
                TextColor3 = NeutralContentMain
            })
        }
    })
end
