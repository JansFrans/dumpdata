-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local Children = Fusion.Children
local Frame = require(ParentParent.Components.Frame)
local Card = require(ParentParent.Components.Card)
local Text = require(ParentParent.Components.Text)
local t1 = {
    Frame = Frame,
    Divider = require(ParentParent.Components.Divider),
    Text = Text,
    Card = Card
}

return {
    story = function(p1) -- story | line: 20
        -- upvalues: Fusion (copy), Themer (copy), Util (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()

        v1:Frame({
            Parent = p1.target,
            Size = UDim2.fromOffset(300, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            List = {
                FillDirection = Enum.FillDirection.Vertical,
                Padding = v1:UDim(0, v2.Spacing["0.75"])
            },
            [Children] = {
                v1:Card({
                    Size = UDim2.new(UDim.new(1, 0), UDim.new(0, 75)),
                    AutomaticSize = Enum.AutomaticSize.None
                }),
                v1:Card({
                    Size = UDim2.fromScale(1, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    List = {
                        Padding = v1:UDim(0, v2.Spacing["0.5"])
                    },
                    [Children] = {
                        v1:Text({
                            Text = "Title",
                            TextSize = v2.TextSize["1.25"],
                            FontFace = v1:Font(v2.Font.Heading, v2.FontWeight.Heading)
                        }),
                        v1:Divider({}),
                        v1:Text({
                            Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                        })
                    }
                })
            }
        })
    end,
    fusion = Fusion
}
