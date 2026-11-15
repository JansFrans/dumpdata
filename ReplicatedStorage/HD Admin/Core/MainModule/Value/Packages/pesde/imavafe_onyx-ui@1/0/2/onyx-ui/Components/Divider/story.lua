-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local Frame = require(ParentParent.Components.Frame)
local Divider = require(ParentParent.Components.Divider)
local t1 = {
    Frame = Frame,
    Text = require(ParentParent.Components.Text),
    Divider = Divider
}

return {
    story = function(p1) -- story | line: 18
        -- upvalues: Util (copy), Fusion (copy), Themer (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()

        v1:Frame({
            Parent = p1.target,
            Size = UDim2.fromOffset(300, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            List = {
                FillDirection = Enum.FillDirection.Vertical,
                Padding = v1:UDim(0, v2.Spacing["0.5"])
            },
            [Children] = {
                v1:Text({
                    Text = "Some top content.."
                }),
                v1:Divider({
                    FillDirection = Enum.FillDirection.Horizontal
                }),
                v1:Text({
                    Text = "And some bottom content too."
                })
            }
        })
    end,
    fusion = Fusion
}
