-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local Children = Fusion.Children
local t1 = {
    Frame = require(script.Parent.Frame),
    Avatar = require(script.Parent.Avatar)
}
local t2 = {
    Util.Colors.Red["500"],
    Util.Colors.Green["400"],
    Util.Colors.Orange["500"],
    Util.Colors.Stone["600"]
}

return {
    story = function(p1) -- story | line: 20
        -- upvalues: Fusion (copy), Themer (copy), Util (copy), Children (copy), t1 (copy), t2 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()
        local v3 = v1:Value(t2[2])
        local v4 = v1:Value(Fusion.peek(v2.StrokeThickness["2"]))
        local v5 = task.spawn(function() -- line: 27
            -- upvalues: v2 (copy), v3 (copy), v4 (copy), Fusion (copy), t2 (copy)
            while task.wait(1) do
                v3:set(t2[math.random(1, #t2)])

                if Fusion.peek(v4) == Fusion.peek(v2.StrokeThickness["2"]) then
                    v4:set(Fusion.peek(v2.StrokeThickness["3"]))
                else
                    v4:set(Fusion.peek(v2.StrokeThickness["2"]))
                end
            end
        end)

        v1:innerScope({
            function() -- line: 40
                -- upvalues: v5 (copy)
                task.cancel(v5)
            end
        })
        v1:Frame({
            Parent = p1.target,
            Padding = {
                All = v1:UDim(0, v2.StrokeThickness["4"])
            },
            List = {
                Padding = v1:UDim(0, v2.Spacing["1"]),
                FillDirection = Enum.FillDirection.Horizontal
            },
            [Children] = {
                v1:Avatar({
                    Image = "rbxthumb://type=AvatarHeadShot&id=144146784&w=150&h=150"
                }),
                v1:Avatar({
                    Image = "rbxthumb://type=AvatarHeadShot&id=144146784&w=150&h=150",
                    Corner = {
                        Radius = v1:UDim(0, v2.CornerRadius.Full)
                    }
                }),
                v1:Avatar({
                    Image = "rbxthumb://type=AvatarHeadShot&id=144146784&w=150&h=150",
                    RingEnabled = true,
                    Corner = {
                        Radius = v1:UDim(0, v2.CornerRadius.Full)
                    },
                    RingColor = v3
                }),
                v1:Avatar({
                    Image = "rbxthumb://type=AvatarHeadShot&id=144146784&w=150&h=150",
                    IndicatorEnabled = true,
                    Corner = {
                        Radius = v1:UDim(0, v2.CornerRadius.Full)
                    },
                    IndicatorColor = v3
                }),
                v1:Avatar({
                    Image = "rbxthumb://type=AvatarHeadShot&id=144146784&w=150&h=150",
                    RingEnabled = true,
                    Corner = {
                        Radius = v1:UDim(0, v2.CornerRadius.Full)
                    },
                    RingColor = Util.Colors.Green["400"],
                    RingThickness = v4
                }),
                v1:Avatar({
                    Image = "rbxthumb://type=AvatarHeadShot&id=144146784&w=150&h=150",
                    IndicatorEnabled = true,
                    IndicatorIcon = "rbxassetid://13805569043",
                    Corner = {
                        Radius = v1:UDim(0, v2.CornerRadius.Full)
                    },
                    IndicatorColor = Util.Colors.Sky["500"]
                })
            }
        })
    end,
    fusion = Fusion
}
