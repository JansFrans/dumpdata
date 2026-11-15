-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local Components = require(ParentParent.Components)
local Children = Fusion.Children

return {
    story = function(p1) -- story | line: 10
        -- upvalues: Fusion (copy), Themer (copy), Util (copy), Components (copy), Children (copy)
        local v1 = Themer.Theme:now()
        local v2 = Fusion.innerScope(p1.scope, Fusion, Util, Components)

        v2:Base({
            Parent = p1.target,
            BackgroundTransparency = 1,
            List = {},
            Padding = {
                All = v2:UDim(0, v1.StrokeThickness["1"])
            },
            [Children] = {
                v2:Base({
                    ClassName = "Frame",
                    Size = UDim2.fromOffset(100, 100),
                    Corner = {
                        Radius = UDim.new(0, 100)
                    },
                    Padding = {
                        Left = UDim.new(0, 50)
                    },
                    Stroke = {
                        Thickness = 5,
                        ZIndex = 34,
                        Color = Color3.fromRGB(255, 0, 0),
                        Offset = UDim.new(0, 5),
                        Position = Enum.BorderStrokePosition.Outer,
                        SizingMode = Enum.StrokeSizingMode.FixedSize
                    }
                }),
                v2:Base({
                    ClassName = "Frame",
                    AutomaticSize = Enum.AutomaticSize.XY,
                    Padding = {
                        All = UDim.new(0, 30),
                        Left = UDim.new(0, 10)
                    },
                    List = {
                        Padding = UDim.new(0, 15)
                    },
                    [Children] = {
                        v2:Base({
                            ClassName = "TextButton",
                            Size = UDim2.fromOffset(200, 50),
                            BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                            Stroke = {
                                Thickness = 3,
                                Transparency = 0.5,
                                ApplyMode = Enum.ApplyStrokeMode.Border,
                                LineJoinMode = Enum.LineJoinMode.Miter
                            }
                        }),
                        v2:Base({
                            ClassName = "TextButton",
                            Text = "Button",
                            Size = UDim2.fromOffset(200, 50),
                            BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                            Scale = {
                                Scale = 0.95
                            },
                            Stroke = {
                                Thickness = 3,
                                Color = Color3.fromRGB(0, 0, 0),
                                ApplyMode = Enum.ApplyStrokeMode.Border
                            },
                            Corner = {
                                Radius = UDim.new(0, 15)
                            },
                            Gradient = {
                                Rotation = 90,
                                Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                                }),
                                Transparency = NumberSequence.new(0, 0.5)
                            }
                        }),
                        v2:Base({
                            ClassName = "TextButton",
                            Size = UDim2.fromOffset(200, 50),
                            BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                            Stroke = {
                                Thickness = 3,
                                ApplyMode = Enum.ApplyStrokeMode.Border
                            },
                            Aspect = {
                                Ratio = 1,
                                DominantAxis = Enum.DominantAxis.Height,
                                AspectType = Enum.AspectType.ScaleWithParentSize
                            }
                        })
                    }
                }),
                v2:Base({
                    ClassName = "Frame",
                    Size = UDim2.fromOffset(200, 200),
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                    Grid = {
                        CellSize = UDim2.fromOffset(50, 50)
                    },
                    Padding = {
                        All = UDim.new(0, 10)
                    },
                    Corner = {
                        Radius = UDim.new(0, 10)
                    },
                    [Children] = {
                        v2:Base({
                            ClassName = "Frame"
                        }),
                        v2:Base({
                            ClassName = "Frame",
                            Stroke = {
                                Thickness = 2,
                                Color = Color3.fromRGB(0, 0, 255)
                            }
                        }),
                        v2:Base({
                            ClassName = "Frame"
                        }),
                        v2:Base({
                            ClassName = "Frame"
                        }),
                        v2:Base({
                            ClassName = "Frame"
                        })
                    }
                })
            }
        })
    end,
    fusion = Fusion
}
