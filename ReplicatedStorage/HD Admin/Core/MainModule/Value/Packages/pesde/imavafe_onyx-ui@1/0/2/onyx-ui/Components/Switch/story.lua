-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    Switch = require(script.Parent.Switch),
    Frame = require(script.Parent.Frame)
}

return {
    story = function(p1) -- story | line: 16
        -- upvalues: Util (copy), Fusion (copy), Themer (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()

        v1:Frame({
            Parent = p1.target,
            Padding = {
                All = v1:UDim(0, v2.StrokeThickness["1"])
            },
            List = {
                Padding = v1:UDim(0, v2.Spacing["0.5"])
            },
            [Children] = {
                v1:Switch({}),
                v1:Switch({
                    Disabled = true
                })
            }
        })
    end,
    fusion = Fusion
}
