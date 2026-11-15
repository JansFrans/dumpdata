-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children

return function(p1, p2) -- line: 28
    -- upvalues: Theme (copy), Children (copy)
    local v1 = p2.userId or p1:Value(1)
    local displayName, username, subtitle, iconImage = p2.displayName, p2.username, p2.subtitle, p2.iconImage
    local v2 = p2.iconImageInset or 0
    local v3 = p2.iconSize or 24
    local v4 = p2.singleLine == true
    local v5 = p1:Computed(function(p3) -- line: 38
        -- upvalues: iconImage (copy), v1 (copy)
        if iconImage ~= nil then
            local v6 = if typeof(iconImage) == "table" then p3(iconImage) else iconImage

            if typeof(v6) == "string" then
                return v6
            end
        end

        return (("rbxthumb://type=AvatarHeadShot&id=%*&w=48&h=48"):format((p3(v1))))
    end)
    local v7 = p1:Computed(function(p4) -- line: 47
        -- upvalues: displayName (copy), username (copy), subtitle (copy), v1 (copy), Theme (copy)
        local v8 = p4(v1)
        local v9 = if displayName == nil then nil elseif typeof(displayName) == "table" then p4(displayName) else displayName

        if typeof(v9) ~= "string" or #v9 == 0 then
            v9 = tostring(v8)
        end

        local v10 = if subtitle == nil then nil elseif typeof(subtitle) == "table" then p4(subtitle) else subtitle

        if typeof(v10) ~= "string" or not (#v10 > 0) then
            local v11 = if username == nil then nil elseif typeof(username) == "table" then p4(username) else username

            if typeof(v11) ~= "string" or not (#v11 > 0) then
                return string.format("<b>%s</b>", v9)
            end

            local v12 = p4(Theme.Color.NeutralContentDark)
            local v18 = string.format("#%02X%02X%02X", math.round(v12.R * 255), math.round(v12.G * 255), (math.round(v12.B * 255)))

            return string.format("<b>%s</b> <font color=\"%s\">(@%s)</font>", v9, v18, v11)
        end

        local v19 = p4(Theme.Color.NeutralContentDark)
        local v25 = string.format("#%02X%02X%02X", math.round(v19.R * 255), math.round(v19.G * 255), (math.round(v19.B * 255)))

        return string.format("<b>%s</b> <font color=\"%s\">(%s)</font>", v9, v25, v10)
    end)
    local Frame = p1:New("Frame")
    local t1 = {
        Name = "UserDetails",
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        LayoutOrder = p2.layoutOrder
    }
    local v26 = p1:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6)
    })
    local v27 = p1:New("UIFlexItem")({
        FlexMode = Enum.UIFlexMode.Fill
    })
    local Frame2 = p1:New("Frame")
    local t2 = {
        Name = "IconHolder",
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.fromOffset(v3, 0)
    }
    local ImageLabel = p1:New("ImageLabel")
    local t3 = {
        Name = "Icon",
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(61, 61, 63),
        Image = if v2 > 0 then "" else v5,
        Position = UDim2.fromScale(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromOffset(v3 - 2, v3 - 2)
    }
    local t4 = {
        p1:New("UICorner")({
            CornerRadius = UDim.new(0.5, 0)
        })
    }

    if v2 > 0 then
        local v29 = math.max(0, v3 - 2 - v2 * 2)

        table.insert(t4, p1:New("ImageLabel")({
            Name = "Glyph",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = v5,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromOffset(v29, v29)
        }))
    end

    t3[Children] = t4
    t2[Children] = { ImageLabel(t3) }
    t1[Children] = {
        v26,
        v27,
        Frame2(t2),
        p1:New("TextLabel")({
            Name = "ContentArea",
            LayoutOrder = 2,
            AutomaticSize = if v4 then Enum.AutomaticSize.None else Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = if v4 then UDim2.new(1, 0, 1, 0) else UDim2.fromOffset(0, 0),
            FontFace = p1:Computed(function(p5) -- line: 133
                -- upvalues: Theme (copy)
                return Font.new(p5(Theme.Font.Body), p5(Theme.FontWeight.Regular))
            end),
            RichText = true,
            Text = v7,
            TextColor3 = Theme.Color.BaseContent,
            TextSize = Theme.TextSize.Subtitle,
            TextTruncate = Enum.TextTruncate.SplitWord,
            TextWrapped = not v4,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = if v4 then Enum.TextYAlignment.Center else Enum.TextYAlignment.Top,
            [Children] = {
                p1:New("UIFlexItem")({
                    FlexMode = Enum.UIFlexMode.Fill
                })
            }
        })
    }

    return Frame(t1)
end
