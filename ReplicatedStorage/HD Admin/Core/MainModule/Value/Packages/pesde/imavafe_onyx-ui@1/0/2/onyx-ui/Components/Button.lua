-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local ColorUtils = require(ParentParent.Parent.ColorUtils)
local Children = Fusion.Children
local t1 = {
    BaseButton = require(script.Parent.BaseButton),
    IconText = require(script.Parent.IconText)
}

return function(p1, p2) -- line: 54
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), ColorUtils (copy), Children (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local Medium = Util.Fallback(p2.SizeVariant, "Medium")
    local v3 = Util.Fallback(p2.Disabled, false)
    local v4 = Util.Fallback(p2.Content, {})
    local Filled = Util.Fallback(p2.Style, "Filled")
    local v5 = Util.Fallback(p2.Color, v2.Colors.Neutral.Main)
    local v6 = Util.Fallback(p2.ContentColor, v1:Computed(function(p3) -- line: 65
        -- upvalues: v2 (copy), v5 (copy), Util (copy)
        return Util.Emphasize(p3(v5), p3(v2.Emphasis.Contrast))
    end))
    local v7 = Util.Fallback(p2.ContentSize, v1:Computed(function(p4) -- line: 71
        -- upvalues: v2 (copy), Medium (copy)
        return ({
            ExtraSmall = p4(v2.TextSize["0.875"]),
            Small = p4(v2.TextSize["1"]),
            Medium = p4(v2.TextSize["1"]),
            Large = p4(v2.TextSize["1.25"]),
            ExtraLarge = p4(v2.TextSize["1.25"])
        })[p4(Medium)]
    end))
    local v8 = Util.Fallback(p2.ContentWrapped, false)
    local v9 = v1:EnsureValue(Util.Fallback(p2.Hovering, false))
    local v10 = v1:EnsureValue(Util.Fallback(p2.Holding, false))
    local v11 = v1:Computed(function(p5) -- line: 88
        -- upvalues: v2 (copy), v3 (copy), v5 (copy), v9 (copy), v10 (copy), Util (copy)
        if p5(v3) then
            return p5(v2.Colors.BaseContent.Main)
        end

        local v12 = p5(v5)

        if p5(v10) then
            return Util.Emphasize(v12, p5(v2.Emphasis.Regular))
        end

        if p5(v9) then
            return Util.Emphasize(v12, p5(v2.Emphasis.Light))
        end

        return v12
    end)
    local v13 = v1:Computed(function(p6) -- line: 103
        -- upvalues: v2 (copy), v3 (copy), Filled (copy), v6 (copy), v11 (copy)
        if p6(v3) then
            return p6(v2.Colors.BaseContent.Main)
        end

        if p6(Filled) ~= "Filled" and (p6(Filled) == "Outlined" or p6(Filled) == "Ghost") then
            return p6(v11)
        end

        return p6(v6)
    end)
    local v14 = v1:Computed(function(p7) -- line: 118
        -- upvalues: v2 (copy), v3 (copy), Filled (copy), v9 (copy), v10 (copy)
        local v15 = p7(v2.StrokeEmphasis.Regular)

        if p7(Filled) == "Filled" and not p7(v3) and not p7(v9) and not p7(v10) then
            return v15
        end

        return 0
    end)
    local v16 = v1:Computed(function(p8) -- line: 127
        -- upvalues: v3 (copy)
        if p8(v3) then
            return 0.75
        end

        return 0
    end)
    local v17 = v1:Computed(function(p9) -- line: 134
        -- upvalues: v2 (copy), Medium (copy)
        local t2 = {
            ExtraSmall = p9(v2.Padding["0.25"]),
            Small = p9(v2.Padding["0.5"]),
            Medium = p9(v2.Padding["0.75"]),
            Large = p9(v2.Padding["1"]),
            ExtraLarge = p9(v2.Padding["1.5"])
        }

        return UDim.new(0, t2[p9(Medium)])
    end)
    local v18 = v1:Computed(function(p10) -- line: 145
        -- upvalues: v2 (copy), Medium (copy)
        local t3 = {
            ExtraSmall = 0.5,
            Small = 0.75,
            Medium = 1.25,
            Large = 1.5,
            ExtraLarge = 2
        }

        return UDim.new(0, p10(v2.Padding["0.25"]) * t3[p10(Medium)])
    end)

    return v1:BaseButton(Util.CombineProps(p2, {
        Name = script.Name,
        BackgroundTransparency = v1:Computed(function(p11) -- line: 159
            -- upvalues: v3 (copy), Filled (copy)
            if p11(Filled) ~= "Filled" then
                return 1
            end

            if p11(v3) then
                return 0.925
            end

            return 0
        end),
        BackgroundColor3 = v1:Spring(v11, v2.SpringSpeed["1"], v2.SpringDampening["1"]),
        Padding = {
            Left = v17,
            Right = v17,
            Top = v18,
            Bottom = v18
        },
        Corner = {
            Radius = v1:UDim(0, v2.CornerRadius["1"])
        },
        List = {
            Wraps = false,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center
        },
        Stroke = {
            Color = Color3.fromRGB(255, 255, 255),
            Gradient = {
                Rotation = 90,
                Color = v1:Computed(function(p12) -- line: 189
                    -- upvalues: v11 (copy), v14 (copy), ColorUtils (copy)
                    return ColorSequence.new({
                        ColorSequenceKeypoint.new(0, ColorUtils.Lighten(p12(v11), p12(v14))),
                        ColorSequenceKeypoint.new(1, p12(v11))
                    })
                end)
            },
            Transparency = v1:Computed(function(p13) -- line: 200
                -- upvalues: v3 (copy), Filled (copy)
                if p13(Filled) == "Ghost" then
                    return 1
                end

                if p13(v3) then
                    return 0.925
                end

                return 0
            end)
        },
        Holding = v10,
        Hovering = v9,
        [Children] = {
            v1:IconText({
                Content = v4,
                ContentColor = v13,
                ContentTransparency = v16,
                ContentSize = v7,
                ContentWrapped = v8,
                List = {
                    Padding = v1:UDim(0, v2.Spacing["0.25"]),
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center
                }
            })
        }
    }))
end
