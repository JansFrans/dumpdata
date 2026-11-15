-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    TextArea = require(script.Parent.TextArea),
    Frame = require(script.Parent.Frame)
}

return {
    story = function(p1) -- story | line: 16
        -- upvalues: Util (copy), Fusion (copy), Themer (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()

        v1:Frame({
            Parent = p1.target,
            Size = UDim2.fromOffset(250, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            List = {
                Padding = v1:UDim(0, v2.Spacing["0.5"])
            },
            Padding = {
                All = v1:UDim(0, v2.StrokeThickness["1"])
            },
            [Children] = {
                v1:TextArea({
                    Size = v1:Computed(function(p2) -- line: 33
                        -- upvalues: v2 (copy)
                        return UDim2.new(UDim.new(1, 0), UDim.new(0, p2(v2.TextSize["1"]) * 2 + p2(v2.Spacing["0.5"]) * 2))
                    end)
                }),
                v1:TextArea({
                    CharacterLimit = 60,
                    PlaceholderText = "This TextArea has a character limit.",
                    Size = UDim2.new(UDim.new(1, 0), UDim.new(0, 100))
                }),
                v1:TextArea({
                    PlaceholderText = "This one will expand as you type.",
                    Size = UDim2.new(UDim.new(1, 0), UDim.new(0, 0)),
                    AutomaticSize = Enum.AutomaticSize.Y
                })
            }
        })
    end,
    fusion = Fusion
}
