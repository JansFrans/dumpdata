-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    Frame = require(ParentParent.Components.Frame),
    Image = require(ParentParent.Components.Image)
}

return {
    story = function(p1) -- story | line: 16
        -- upvalues: Util (copy), Fusion (copy), Themer (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()

        v1:Frame({
            Parent = p1.target,
            AutomaticSize = Enum.AutomaticSize.XY,
            List = {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = v1:UDim(0, v2.Spacing["0.75"])
            },
            [Children] = {
                v1:Image({
                    Image = "rbxassetid://15307540148"
                }),
                v1:Image({}),
                v1:Image({
                    FallbackImage = "rbxassetid://13193902400"
                })
            }
        })
    end,
    fusion = Fusion
}
