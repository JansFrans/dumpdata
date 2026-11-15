-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local TitleBar = require(ParentParent.Components.TitleBar)
local t1 = {
    Frame = require(ParentParent.Components.Frame),
    TitleBar = TitleBar
}

return {
    story = function(p1) -- story | line: 16
        -- upvalues: Util (copy), Fusion (copy), Themer (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()

        v1:Frame({
            Parent = p1.target,
            Size = v1:UDim2Offset(v2.Sizing["16"], 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Padding = {
                All = v1:UDim(0, v2.StrokeThickness["1"])
            },
            List = {
                HorizontalFlex = Enum.UIFlexAlignment.Fill
            },
            [Children] = {
                v1:TitleBar({
                    Content = { "Title" }
                }),
                v1:TitleBar({
                    Content = { "rbxassetid://75029721407761", "Shop" }
                })
            }
        })
    end,
    fusion = Fusion
}
