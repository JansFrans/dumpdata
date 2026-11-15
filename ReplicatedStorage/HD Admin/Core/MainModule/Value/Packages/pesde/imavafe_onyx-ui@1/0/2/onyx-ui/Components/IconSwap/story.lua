-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local IconSwap = require(script.Parent.IconSwap)
local Frame = require(script.Parent.Frame)

return {
    story = function(p1) -- story | line: 12
        -- upvalues: Fusion (copy), Util (copy), Themer (copy), Children (copy), IconSwap (copy), Frame (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, {
            IconSwap = IconSwap,
            Frame = Frame
        })
        local v2 = Themer.Theme:now()

        v1:Frame({
            Parent = p1.target,
            List = {
                Padding = v1:UDim(0, v2.Spacing["0.75"])
            },
            Padding = {
                All = v1:UDim(0, v2.StrokeThickness["1"])
            },
            [Children] = {
                v1:IconSwap({
                    Options = { "rbxassetid://13852158988", "rbxassetid://13852161637" }
                })
            }
        })
    end,
    fusion = Fusion
}
