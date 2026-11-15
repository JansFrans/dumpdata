-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Pressable = require(UI.Components.Pressable)
local ClipHighlight = require(UI.Components.ClipHighlight)
local Icons = require(UI.Config.Icons)
local Children = Fusion.Children

local function makeContent(p1, p2, p3) -- line: 30
    -- upvalues: Theme (copy), Icons (copy)
    local v1 = p2 ~= nil

    return {
        p1:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }),
        p1:New("ImageLabel")({
            Name = "Icon",
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Image = if v1 then Icons.RobuxFill else Icons.Unlock,
            ImageColor3 = p3,
            Size = UDim2.fromOffset(16, 16)
        }),
        p1:New("TextLabel")({
            Name = "Label",
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            AutomaticSize = Enum.AutomaticSize.X,
            FontFace = p1:Computed(function(p4) -- line: 52
                -- upvalues: Theme (copy)
                return Font.new(p4(Theme.Font.Body), p4(Theme.FontWeight.Bold))
            end),
            Text = if v1 then p1:Computed(function(p5) -- line: 57
                -- upvalues: p2 (copy)
                return (tostring(p5(p2)))
            end) else "Unlock",
            TextColor3 = p3,
            TextSize = Theme.TextSize.Body
        })
    }
end

return function(p6, p7) -- line: 69
    -- upvalues: Theme (copy), Pressable (copy), ClipHighlight (copy), Children (copy), makeContent (copy)
    local v4 = p7.size or UDim2.new(1, 0, 0, 28)
    local v5, v6

    if p7.style == "Neutral" then
        v5 = Theme.Color.NeutralContent
        v6 = Theme.Color.BaseContent
    else
        v5 = Theme.Color.Primary
        v6 = Theme.Color.PrimaryContent
    end

    local t3 = {}

    if p7.flexNone then
        table.insert(t3, p6:New("UIFlexItem")({
            FlexMode = Enum.UIFlexMode.None
        }))
    end

    if p7.flatTop then
        local v7 = p6:Value(false)
        local v8 = p6:Value(false)
        local v9 = v5

        table.insert(t3, ClipHighlight(p6, {
            side = "bottom",
            cornerRadius = 9,
            color = p6:Computed(function(p8) -- line: 82
                -- upvalues: v7 (copy), v8 (copy), v9 (copy), Pressable (copy)
                return Pressable.applyHighlight(p8, p8(v9), v8, v7)
            end)
        }))
        table.insert(t3, p6:New("Frame")({
            Name = "Content",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            [Children] = makeContent(p6, p7.robuxPrice, v6)
        }))

        return Pressable(p6, {
            name = "UnlockButton",
            size = v4,
            automaticSize = Enum.AutomaticSize.None,
            layoutOrder = p7.layoutOrder,
            visible = p7.visible,
            onActivate = function() -- onActivate | line: 98
                -- upvalues: p7 (copy)
                if p7.onUnlock then
                    p7.onUnlock()
                end
            end,
            onHoverChanged = function(p9) -- onHoverChanged | line: 101
                -- upvalues: v7 (copy)
                v7:set(p9)
            end,
            onPressChanged = function(p10) -- onPressChanged | line: 102
                -- upvalues: v8 (copy)
                v8:set(p10)
            end,
            [Children] = t3
        })
    end

    table.insert(t3, p6:New("UICorner")({
        CornerRadius = UDim.new(0, 6)
    }))

    for _, v10 in makeContent(p6, p7.robuxPrice, v6) do
        table.insert(t3, v10)
    end

    return Pressable(p6, {
        name = "UnlockButton",
        backgroundColor = v5,
        size = v4,
        automaticSize = Enum.AutomaticSize.None,
        layoutOrder = p7.layoutOrder,
        visible = p7.visible,
        onActivate = function() -- onActivate | line: 118
            -- upvalues: p7 (copy)
            if p7.onUnlock then
                p7.onUnlock()
            end
        end,
        [Children] = t3
    })
end
