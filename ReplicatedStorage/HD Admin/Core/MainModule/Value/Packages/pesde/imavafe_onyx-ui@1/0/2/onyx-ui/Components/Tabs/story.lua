-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    Tabs = require(script.Parent.Tabs),
    Frame = require(script.Parent.Frame)
}

return {
    story = function(p1) -- story | line: 16
        -- upvalues: Fusion (copy), Util (copy), Themer (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
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
                v1:Tabs({
                    Tabs = {
                        { "Tab 1" },
                        { "Tab 2" }
                    }
                }),
                v1:Tabs({
                    Disabled = true,
                    Tabs = {
                        { "Tab 1" },
                        { "Tab 2" }
                    }
                }),
                v1:Tabs({
                    Tabs = {
                        { "1" },
                        { "2" },
                        { "3" }
                    },
                    Color = v2.Colors.BaseContent.Main,
                    Corner = {
                        Radius = v1:UDim(0, v2.CornerRadius["0"])
                    },
                    List = {
                        Padding = v1:UDim(0, v2.Spacing["0"])
                    }
                })
            }
        })
    end,
    fusion = Fusion
}
