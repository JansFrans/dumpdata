-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local Children = Fusion.Children
local t1 = {
    AutoScaler = require(ParentParent.Components.AutoScaler),
    Card = require(ParentParent.Components.Card)
}

return {
    story = function(p1) -- story | line: 16
        -- upvalues: Fusion (copy), Themer (copy), Util (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()

        v1:AutoScaler({
            Parent = p1.target,
            BaseResolution = Vector2.new(800, 800),
            List = {
                FillDirection = Enum.FillDirection.Vertical,
                Padding = v1:UDim(0, v2.Spacing["0.75"])
            },
            [Children] = {
                v1:Card({
                    Size = v1:UDim2Offset(v2.Sizing["16"], v2.Sizing["8"]),
                    AutomaticSize = Enum.AutomaticSize.None
                })
            }
        })
    end,
    fusion = Fusion
}
