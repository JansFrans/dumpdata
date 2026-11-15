-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local ColorUtils = require(ParentParent.Parent.ColorUtils)
local Children = Fusion.Children
local t1 = {
    Frame = require(script.Parent.Frame),
    BaseButton = require(script.Parent.BaseButton)
}

return function(p1, p2) -- line: 38
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), ColorUtils (copy), Children (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = v1:EnsureValue(Util.Fallback(p2.Switched, false))
    local v4 = v1:EnsureValue(Util.Fallback(p2.Disabled, false))
    local v5 = Util.Fallback(p2.Color, v2.Colors.Primary.Main)
    local v6 = Util.Fallback(p2.Size, v1:Computed(function(p3) -- line: 47
        -- upvalues: v2 (copy)
        return UDim2.fromOffset(p3(v2.TextSize["1"]) * 2, p3(v2.TextSize["1"]))
    end))
    local v7 = Util.Fallback(p2.AutomaticSize, Enum.AutomaticSize.None)
    local v8 = Util.Fallback(p2.Corner, {
        Radius = v1:UDim(0, v2.CornerRadius.Full)
    })
    local v9 = v1:EnsureValue(Util.Fallback(p2.Hovering, false))
    local v10 = v1:EnsureValue(Util.Fallback(p2.Holding, false))
    local v11 = v1:Computed(function(p4) -- line: 59
        -- upvalues: v2 (copy), v3 (copy), v4 (copy), v5 (copy), v9 (copy), v10 (copy), Util (copy)
        local v12 = if p4(v3) then p4(v5) else p4(v2.Colors.NeutralContent.Dark)

        if not p4(v4) then
            if p4(v10) then
                return Util.Emphasize(p4(v12), p4(v2.Emphasis.Regular))
            end

            if p4(v9) then
                return Util.Emphasize(p4(v12), p4(v2.Emphasis.Light))
            end
        end

        return v12
    end)
    local v13 = v1:Computed(function(p5) -- line: 77
        -- upvalues: v2 (copy), v3 (copy), v4 (copy), v9 (copy), v10 (copy), Util (copy)
        local v14 = if p5(v3) then p5(v2.Colors.Base.Main) else p5(v2.Colors.NeutralContent.Dark)

        if not p5(v4) then
            if p5(v10) then
                if p5(v3) then
                    return v14
                end

                return Util.Emphasize(p5(v14), p5(v2.Emphasis.Regular))
            end

            if p5(v9) then
                if p5(v3) then
                    return v14
                end

                return Util.Emphasize(p5(v14), p5(v2.Emphasis.Light))
            end
        end

        return v14
    end)
    local v15 = v1:Computed(function(p6) -- line: 103
        -- upvalues: v2 (copy), v4 (copy), v9 (copy), v10 (copy)
        local v16 = p6(v2.StrokeEmphasis.Regular)

        if not p6(v4) and not p6(v9) and not p6(v10) then
            return v16
        end

        return 0
    end)

    return v1:BaseButton(Util.CombineProps(p2, {
        Name = script.Name,
        Size = v6,
        AutomaticSize = v7,
        Disabled = v4,
        Stroke = {
            Color = Color3.fromRGB(255, 255, 255),
            Gradient = {
                Rotation = 90,
                Color = v1:Computed(function(p7) -- line: 121
                    -- upvalues: v11 (copy), v15 (copy), ColorUtils (copy)
                    return ColorSequence.new({
                        ColorSequenceKeypoint.new(0, ColorUtils.Lighten(p7(v11), p7(v15))),
                        ColorSequenceKeypoint.new(1, p7(v11))
                    })
                end)
            },
            Transparency = v1:Spring(v1:Computed(function(p8) -- line: 133
                -- upvalues: v3 (copy), v4 (copy)
                if p8(v4) then
                    return 0.8
                end

                if p8(v3) then
                    return 0
                end

                return 0.6
            end), v2.SpringSpeed["1"], v2.SpringDampening["1"])
        },
        Corner = v8,
        Hovering = v9,
        Holding = v10,
        ClickSound = v2.Sound.Switch,
        OnActivate = function() -- OnActivate | line: 154
            -- upvalues: v3 (copy), Fusion (copy)
            v3:set(not Fusion.peek(v3))
        end,
        [Children] = {
            v1:Frame({
                Name = "Switch",
                Size = v6,
                AutomaticSize = v7,
                BackgroundColor3 = v1:Spring(v11, v2.SpringSpeed["1"], v2.SpringDampening["1"]),
                BackgroundTransparency = v1:Spring(v1:Computed(function(p9) -- line: 165
                    -- upvalues: v3 (copy)
                    if p9(v3) then
                        return 0
                    end

                    return 1
                end), v2.SpringSpeed["1"], v2.SpringDampening["1"]),
                Padding = {
                    All = UDim.new(0, 2)
                },
                Corner = v8,
                [Children] = {
                    v1:Frame({
                        Name = "Ball",
                        AnchorPoint = v1:Spring(v1:Computed(function(p10) -- line: 184
                            -- upvalues: v3 (copy)
                            if p10(v3) then
                                return Vector2.new(1, 0.5)
                            end

                            return Vector2.new(0, 0.5)
                        end), v2.SpringSpeed["1"], v2.SpringDampening["1"]),
                        Position = v1:Spring(v1:Computed(function(p11) -- line: 195
                            -- upvalues: v3 (copy)
                            if p11(v3) then
                                return UDim2.fromScale(1, 0.5)
                            end

                            return UDim2.fromScale(0, 0.5)
                        end), v2.SpringSpeed["1"], v2.SpringDampening["1"]),
                        Size = v1:Spring(v1:Computed(function(p12) -- line: 206
                            -- upvalues: v9 (copy)
                            local v17 = if p12(v9) then 0.85 * 1.1 else 0.85

                            return UDim2.fromScale(0, v17)
                        end), v2.SpringSpeed["1"], v2.SpringDampening["1"]),
                        AutomaticSize = Enum.AutomaticSize.None,
                        BackgroundTransparency = v1:Spring(v1:Computed(function(p13) -- line: 219
                            -- upvalues: v3 (copy), v4 (copy)
                            if p13(v4) then
                                return 0.7
                            end

                            if p13(v3) then
                            end

                            return 0
                        end), v2.SpringSpeed["1"], v2.SpringDampening["1"]),
                        BackgroundColor3 = v1:Spring(v13, v2.SpringSpeed["1"], v2.SpringDampening["1"]),
                        Aspect = {
                            Ratio = v1:Spring(v1:Computed(function(p14) -- line: 239
                                -- upvalues: v10 (copy)
                                if p14(v10) then
                                    return 1.2
                                end

                                return 1
                            end), v2.SpringSpeed["1"], v2.SpringDampening["1"]),
                            Type = Enum.AspectType.ScaleWithParentSize,
                            DominantAxis = Enum.DominantAxis.Height
                        },
                        Corner = v8
                    })
                }
            })
        }
    }, { "Size", "AutomaticSize" }))
end
