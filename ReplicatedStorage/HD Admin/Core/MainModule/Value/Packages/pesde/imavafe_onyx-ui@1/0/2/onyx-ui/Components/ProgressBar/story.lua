-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local ColorUtils = require(ParentParent.Parent.ColorUtils)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local Children = Fusion.Children
local t1 = {
    Frame = require(script.Parent.Frame),
    ProgressBar = require(script.Parent.ProgressBar),
    Text = require(script.Parent.Text)
}

return {
    story = function(p1) -- story | line: 20
        -- upvalues: Fusion (copy), ColorUtils (copy), Themer (copy), Util (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()
        local v3 = v1:Value(0)
        local v4 = v1:Value(Color3.fromRGB(255, 0, 0))
        local v5 = task.spawn(function() -- line: 27
            -- upvalues: v3 (copy), v4 (copy), Fusion (copy), ColorUtils (copy)
            while task.wait(1) do
                v3:set(math.random(0, 1000) / 1000)
                v4:set(ColorUtils.Rotate(Fusion.peek(v4), 100))
            end
        end)

        v1:innerScope({
            function() -- line: 35
                -- upvalues: v5 (copy)
                task.cancel(v5)
            end
        })
        v1:Frame({
            Parent = p1.target,
            List = {
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = v1:UDim(0, v2.Spacing["1.5"])
            },
            [Children] = {
                v1:Frame({
                    List = {
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = v1:UDim(0, v2.Spacing["0.5"])
                    },
                    [Children] = {
                        v1:Text({
                            Text = "Horizontal"
                        }),
                        v1:ProgressBar({
                            Progress = 0.75
                        }),
                        v1:ProgressBar({
                            Progress = v3,
                            Color = v4
                        })
                    }
                }),
                v1:Frame({
                    List = {
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = v1:UDim(0, v2.Spacing["0.5"])
                    },
                    [Children] = {
                        v1:Text({
                            Text = "With text"
                        }),
                        v1:Frame({
                            List = {
                                FillDirection = Enum.FillDirection.Horizontal,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                Padding = v1:UDim(0, v2.Spacing["0.5"])
                            },
                            [Children] = {
                                v1:Text({
                                    Text = "HP"
                                }),
                                v1:ProgressBar({
                                    Progress = v3,
                                    Color = Util.Colors.Red["500"],
                                    FlexMode = Enum.UIFlexMode.Fill
                                })
                            }
                        })
                    }
                }),
                v1:Frame({
                    List = {
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = v1:UDim(0, v2.Spacing["0.5"])
                    },
                    [Children] = {
                        v1:Text({
                            Text = "Inverted"
                        }),
                        v1:ProgressBar({
                            Inverted = true,
                            Progress = v3
                        })
                    }
                }),
                v1:Frame({
                    List = {
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = v1:UDim(0, v2.Spacing["0.75"])
                    },
                    [Children] = {
                        v1:Text({
                            Text = "Vertical"
                        }),
                        v1:Frame({
                            List = {
                                FillDirection = Enum.FillDirection.Horizontal,
                                Padding = v1:UDim(0, v2.Spacing["0.5"])
                            },
                            [Children] = {
                                v1:ProgressBar({
                                    Direction = Enum.FillDirection.Vertical,
                                    Progress = v3,
                                    Color = v4
                                }),
                                v1:ProgressBar({
                                    Inverted = true,
                                    Direction = Enum.FillDirection.Vertical,
                                    Progress = v3,
                                    Color = v4
                                }),
                                v1:ProgressBar({
                                    Direction = Enum.FillDirection.Vertical,
                                    Progress = v3,
                                    Color = v4
                                }),
                                v1:ProgressBar({
                                    Inverted = true,
                                    Direction = Enum.FillDirection.Vertical,
                                    Progress = v3,
                                    Color = v4
                                }),
                                v1:ProgressBar({
                                    Direction = Enum.FillDirection.Vertical,
                                    Progress = v3,
                                    Color = v4
                                }),
                                v1:ProgressBar({
                                    Inverted = true,
                                    Direction = Enum.FillDirection.Vertical,
                                    Progress = v3,
                                    Color = v4
                                }),
                                v1:ProgressBar({
                                    Direction = Enum.FillDirection.Vertical,
                                    Progress = v3,
                                    Color = v4
                                }),
                                v1:ProgressBar({
                                    Inverted = true,
                                    Direction = Enum.FillDirection.Vertical,
                                    Progress = v3,
                                    Color = v4
                                }),
                                v1:ProgressBar({
                                    Direction = Enum.FillDirection.Vertical,
                                    Progress = v3,
                                    Color = v4
                                }),
                                v1:ProgressBar({
                                    Inverted = true,
                                    Direction = Enum.FillDirection.Vertical,
                                    Progress = v3,
                                    Color = v4
                                })
                            }
                        })
                    }
                })
            }
        })
    end,
    fusion = Fusion
}
