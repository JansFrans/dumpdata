-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    TextSwap = require(ParentParent.Components.TextSwap),
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
                Padding = v1:UDim(0, v2.Spacing["0.5"]),
                HorizontalFlex = Enum.UIFlexAlignment.Fill
            },
            [Children] = {
                v1:TextSwap({
                    Options = { "Hamburger", "Pizza", "Ice Cream" }
                }),
                v1:TextSwap({
                    Disabled = true,
                    Options = { "Disabled" }
                }),
                v1:TextSwap({
                    Options = { "Cats", "Dogs", "Zebras" },
                    Color = v2.Colors.Primary.Main
                })
            }
        })
    end,
    fusion = Fusion
}
