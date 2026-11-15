-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local Heading = require(script.Parent.Heading)
local Frame = require(script.Parent.Frame)
local t1 = {
    Heading = Heading,
    Text = require(script.Parent.Text),
    Frame = Frame
}

return {
    story = function(p1) -- story | line: 18
        -- upvalues: Util (copy), Fusion (copy), Themer (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()

        v1:Frame({
            Parent = p1.target,
            List = {
                Padding = v1:UDim(0, v2.Spacing["0.5"])
            },
            [Children] = {
                v1:Heading({
                    Text = "Heading",
                    Parent = p1.target
                }),
                v1:Text({
                    Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
                })
            }
        })
    end,
    fusion = Fusion
}
