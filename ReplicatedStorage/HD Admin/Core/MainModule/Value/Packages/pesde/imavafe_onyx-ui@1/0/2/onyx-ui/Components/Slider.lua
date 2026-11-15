-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local ColorUtils = require(ParentParent.Parent.ColorUtils)
local Children, Out, OnEvent = Fusion.Children, Fusion.Out, Fusion.OnEvent
local t1 = {
    BaseButton = require(script.Parent.BaseButton)
}

function RoundByUnit(p1, p2) -- line: 34
    return math.floor(p1 / p2 + 0.5) * p2
end

return function(p3, p4) -- line: 47
    -- upvalues: Fusion (copy), Themer (copy), Util (copy), ColorUtils (copy), Children (copy), Out (copy), OnEvent (copy), t1 (copy)
    local v2 = Fusion.innerScope(p3, Fusion, Util, t1)
    local v3 = Themer.Theme:now()
    local v4 = Util.Fallback(p4.Unit, 0.01)
    local v5 = v2:EnsureValue(Util.Fallback(p4.Value, 1))
    local v6 = Util.Fallback(p4.Color, v3.Colors.Primary.Main)
    local v7 = Util.Fallback(p4.Disabled, false)
    local v8 = v2:EnsureValue(Util.Fallback(p4.Hovering, false))
    local v9 = v2:EnsureValue(Util.Fallback(p4.Holding, false))
    local v10 = v2:Value(nil)
    local v11 = v2:Value(Vector2.new())
    local v12 = v2:Value(Vector2.new())
    local v13 = v2:Computed(function(p5) -- line: 63
        -- upvalues: v3 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), Util (copy)
        if p5(v7) then
            return p5(v3.Colors.BaseContent.Main)
        end

        if p5(v9) then
            return Util.Emphasize(p5(v6), p5(v3.Emphasis.Regular))
        end

        if p5(v8) then
            return Util.Emphasize(p5(v6), p5(v3.Emphasis.Light))
        end

        return p5(v6)
    end)
    local v14 = v2:Computed(function(p6) -- line: 76
        -- upvalues: v3 (copy), v7 (copy), v8 (copy), v9 (copy)
        local v15 = p6(v3.StrokeEmphasis.Regular)

        if not p6(v7) and not p6(v8) and not p6(v9) then
            return v15
        end

        return 0
    end)

    local function ProcessDrag(p7) -- line: 86
        -- upvalues: v4 (copy), v5 (copy), v11 (copy), v12 (copy), Fusion (copy)
        local v16 = Fusion.peek(v11)
        local v17 = Fusion.peek(v12)
        local v18 = Fusion.peek(v4)
        local v19 = p7.X - v17.X

        v5:set(RoundByUnit(math.clamp(v19 / v16.X, 0, 1), v18))
    end

    local v23 = v2:BaseButton(Util.CombineProps(p4, {
        Name = script.Name,
        Corner = {
            Radius = v2:UDim(0, v3.CornerRadius.Full)
        },
        Size = v2:UDim2Offset(0, v3.TextSize["1"]),
        AutomaticSize = Enum.AutomaticSize.Y,
        Disabled = v7,
        Hovering = v8,
        Holding = v9,
        [Children] = {
            v10,
            v2:Hydrate(v2:Frame({
                Name = "Progress",
                Selectable = false,
                BackgroundTransparency = 0,
                BackgroundColor3 = v3.Colors.Neutral.Main,
                Size = v2:UDim2(1, 0, 0, v3.TextSize["0.75"]),
                Corner = {
                    Radius = v2:UDim(0, v3.CornerRadius.Full)
                },
                Flex = {
                    Mode = Enum.UIFlexMode.Fill
                },
                [Children] = {
                    v2:Frame({
                        Name = "Progress",
                        Selectable = false,
                        Size = v2:Computed(function(p8) -- line: 127
                            -- upvalues: v5 (copy)
                            local v21 = p8(v5)

                            return UDim2.fromScale(v21, 1)
                        end),
                        BackgroundTransparency = v2:Computed(function(p9) -- line: 131
                            -- upvalues: v7 (copy)
                            if p9(v7) then
                                return 0.925
                            end

                            return 0
                        end),
                        BackgroundColor3 = v2:Spring(v13, v3.SpringSpeed["1"], v3.SpringDampening["1"]),
                        AutomaticSize = Enum.AutomaticSize.None,
                        Corner = {
                            Radius = v2:UDim(0, v3.CornerRadius.Full)
                        },
                        Stroke = {
                            Color = Color3.fromRGB(255, 255, 255),
                            Gradient = {
                                Rotation = 90,
                                Color = v2:Computed(function(p10) -- line: 150
                                    -- upvalues: v13 (copy), v14 (copy), ColorUtils (copy)
                                    return ColorSequence.new({
                                        ColorSequenceKeypoint.new(0, ColorUtils.Lighten(p10(v13), p10(v14))),
                                        ColorSequenceKeypoint.new(1, p10(v13))
                                    })
                                end)
                            },
                            Transparency = v2:Computed(function(p11) -- line: 161
                                -- upvalues: v7 (copy)
                                if p11(v7) then
                                    return 0.925
                                end

                                return 0
                            end)
                        },
                        [Children] = {
                            v2:Frame({
                                Name = "Ball",
                                Selectable = false,
                                AnchorPoint = v2:Vector2(v5, 0.5),
                                Position = UDim2.fromScale(1, 0.5),
                                Size = v2:UDim2Offset(v3.TextSize["1"], v3.TextSize["1"]),
                                BackgroundTransparency = 0,
                                BackgroundColor3 = v2:Computed(function(p12) -- line: 178
                                    -- upvalues: v3 (copy), v7 (copy)
                                    if p12(v7) then
                                        return p12(v3.Colors.Neutral.Main)
                                    end

                                    return p12(v3.Colors.BaseContent.Main)
                                end),
                                AutomaticSize = Enum.AutomaticSize.None,
                                Corner = {
                                    Radius = v2:UDim(0, v3.CornerRadius.Full)
                                },
                                Stroke = {
                                    Color = v3.Colors.Neutral.Main,
                                    Thickness = v3.StrokeThickness["1"]
                                },
                                Aspect = {
                                    Ratio = 1
                                },
                                [Children] = {
                                    v2:Frame({
                                        Name = "SmallBall",
                                        Selectable = false,
                                        AspectRatio = 1,
                                        BackgroundTransparency = 0,
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        Size = v2:UDim2Offset(v3.TextSize["0.75"], v3.TextSize["0.75"]),
                                        BackgroundColor3 = v2:Spring(v2:Computed(function(p13) -- line: 207
                                            -- upvalues: v3 (copy), v7 (copy), v13 (copy)
                                            if p13(v7) then
                                                return p13(v3.Colors.Neutral.Dark)
                                            end

                                            return p13(v13)
                                        end), v3.SpringSpeed["1"], v3.SpringDampening["1"]),
                                        AutomaticSize = Enum.AutomaticSize.None,
                                        Corner = {
                                            Radius = v2:UDim(0, v3.CornerRadius.Full)
                                        }
                                    })
                                }
                            })
                        }
                    })
                }
            }))({
                [Out("AbsoluteSize")] = v11,
                [Out("AbsolutePosition")] = v12
            })
        }
    }))

    v10:set(v2:New("UIDragDetector")({
        DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
        DragAxis = Vector2.new(1, 0),
        BoundingUI = v23,
        Enabled = v2:Computed(function(p14) -- line: 238
            -- upvalues: v7 (copy)
            return not p14(v7)
        end),
        [OnEvent("DragContinue")] = function(p15) -- line: 242
            -- upvalues: ProcessDrag (copy)
            ProcessDrag(p15)
        end,
        [OnEvent("DragStart")] = function(p16) -- line: 245
            -- upvalues: v9 (copy), ProcessDrag (copy)
            ProcessDrag(p16)
            v9:set(true)
        end,
        [OnEvent("DragEnd")] = function() -- line: 249
            -- upvalues: v9 (copy)
            v9:set(false)
        end
    }))

    return v23
end
