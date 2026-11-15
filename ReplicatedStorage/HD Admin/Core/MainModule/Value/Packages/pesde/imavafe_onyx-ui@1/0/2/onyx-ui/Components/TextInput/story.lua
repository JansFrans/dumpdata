-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local TextInput = require(script.Parent.TextInput)
local t1 = {
    Frame = require(script.Parent.Frame),
    TextInput = TextInput
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
                Padding = v1:UDim(0, v2.Spacing["0.5"]),
                HorizontalFlex = Enum.UIFlexAlignment.Fill
            },
            Padding = {
                All = v1:UDim(0, v2.StrokeThickness["1"])
            },
            [Children] = {
                v1:TextInput({}),
                v1:TextInput({
                    PlaceholderText = "Disabled TextInput.",
                    Disabled = true
                }),
                v1:TextInput({
                    PlaceholderText = "Twenty characters only!",
                    CharacterLimit = 20
                }),
                v1:TextInput({
                    PlaceholderText = "Something dangerous!",
                    Color = v2.Colors.Error.Main
                })
            }
        })
    end,
    fusion = Fusion
}
