-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local ColorUtils = require(ParentParent.Parent.ColorUtils)
local Children = Fusion.Children
local t1 = {
    Frame = require(script.Parent.Frame)
}

return function(p1, p2) -- line: 41
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), ColorUtils (copy), Children (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.Progress, 0)
    local v4 = Util.Fallback(p2.Color, v2.Colors.Primary.Main)
    local v5 = Util.Fallback(p2.Direction, Enum.FillDirection.Horizontal)
    local v6 = Util.Fallback(p2.Inverted, false)
    local v7 = Util.Fallback(p2.Length, v1:UDim(0, v2.Sizing["6"]))
    local v8 = Util.Fallback(p2.Stroke, {
        Thickness = v2.StrokeThickness["1"]
    })

    return v1:Frame(Util.CombineProps(p2, {
        Name = script.Name,
        Size = v1:Computed(function(p3) -- line: 56
            -- upvalues: v2 (copy), v5 (copy), v7 (copy)
            local v9 = p3(v5)
            local v10 = p3(v7)

            if v9 == Enum.FillDirection.Horizontal then
                return UDim2.new(v10, UDim.new(0, p3(v2.TextSize["0.75"])))
            end

            return UDim2.new(UDim.new(0, p3(v2.TextSize["0.75"])), v10)
        end),
        AutomaticSize = Enum.AutomaticSize.None,
        BackgroundTransparency = 0,
        BackgroundColor3 = v2.Colors.Neutral.Dark,
        Corner = {
            Radius = v1:UDim(0, v2.CornerRadius.Full)
        },
        Padding = {
            All = v1:Computed(function(p4) -- line: 72
                -- upvalues: v8 (copy)
                return UDim.new(0, p4(p4(v8).Thickness))
            end)
        },
        [Children] = {
            v1:Frame({
                Name = "ProgressFill",
                Selectable = false,
                BackgroundTransparency = 0,
                Size = v1:Spring(v1:Computed(function(p5) -- line: 82
                    -- upvalues: v3 (copy), v5 (copy)
                    if p5(v5) == Enum.FillDirection.Horizontal then
                        return UDim2.fromScale(p5(v3), 1)
                    end

                    return UDim2.fromScale(1, p5(v3))
                end), v2.SpringSpeed["0.5"], v2.SpringDampening["1"]),
                AnchorPoint = v1:Computed(function(p6) -- line: 92
                    -- upvalues: v5 (copy), v6 (copy)
                    if not p6(v6) then
                        return Vector2.new(0, 0)
                    end

                    if p6(v5) == Enum.FillDirection.Horizontal then
                        return Vector2.new(1, 0)
                    end

                    return Vector2.new(0, 1)
                end),
                Position = v1:Computed(function(p7) -- line: 103
                    -- upvalues: v5 (copy), v6 (copy)
                    if not p7(v6) then
                        return UDim2.fromScale(0, 0)
                    end

                    if p7(v5) == Enum.FillDirection.Horizontal then
                        return UDim2.fromScale(1, 0)
                    end

                    return UDim2.fromScale(0, 1)
                end),
                AutomaticSize = Enum.AutomaticSize.None,
                BackgroundColor3 = v4,
                Stroke = {
                    Color = Color3.fromRGB(255, 255, 255),
                    Gradient = {
                        Rotation = 90,
                        Color = v1:Computed(function(p8) -- line: 120
                            -- upvalues: v2 (copy), v4 (copy), ColorUtils (copy)
                            return ColorSequence.new({
                                ColorSequenceKeypoint.new(0, ColorUtils.Lighten(p8(v4), p8(v2.StrokeEmphasis.Regular))),
                                ColorSequenceKeypoint.new(1, p8(v4))
                            })
                        end)
                    }
                },
                Corner = {
                    Radius = v1:UDim(0, v2.CornerRadius.Full)
                }
            })
        }
    }))
end
