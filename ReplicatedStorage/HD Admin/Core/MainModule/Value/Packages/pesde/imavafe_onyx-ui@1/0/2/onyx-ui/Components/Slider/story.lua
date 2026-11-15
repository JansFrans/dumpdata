-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    Slider = require(ParentParent.Components.Slider),
    Frame = require(ParentParent.Components.Frame)
}

return {
    story = function(p1) -- story | line: 14
        -- upvalues: Fusion (copy), Util (copy), Themer (copy), Children (copy), t1 (copy)
        local v1 = Fusion.scoped(Fusion, Util, t1)
        local v2 = Themer.Theme:now()

        v1:Frame({
            Parent = p1.target,
            Size = v1:UDim2Offset(v2.Sizing["16"], 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Padding = {
                All = v1:UDim(0, v2.StrokeThickness["1"])
            },
            List = {
                Padding = v1:UDim(0, v2.Spacing["1"]),
                HorizontalFlex = Enum.UIFlexAlignment.Fill
            },
            [Children] = {
                v1:Slider({}),
                v1:Slider({
                    Value = 0.1,
                    Unit = 0.1,
                    Color = Util.Colors.Cyan["500"]
                }),
                v1:Slider({
                    Value = 0.25,
                    Unit = 0.25,
                    Color = Util.Colors.Fuchsia["500"]
                }),
                v1:Slider({
                    Disabled = true
                })
            }
        })
    end,
    fusion = Fusion
}
