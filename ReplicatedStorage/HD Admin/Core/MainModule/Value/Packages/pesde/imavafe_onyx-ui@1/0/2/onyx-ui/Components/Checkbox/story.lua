-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local Children = Fusion.Children
local t1 = {
    Frame = require(ParentParent.Components.Frame),
    Checkbox = require(ParentParent.Components.Checkbox)
}

return {
    story = function(p1) -- story | line: 16
        -- upvalues: Fusion (copy), Themer (copy), Util (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()

        v1:Frame({
            Parent = p1.target,
            Padding = {
                All = v1:UDim(0, v2.StrokeThickness["1"])
            },
            List = {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = v1:UDim(0, v2.Spacing["0.5"])
            },
            [Children] = {
                v1:Checkbox({}),
                v1:Checkbox({
                    Checked = true
                }),
                v1:Checkbox({
                    Disabled = true
                }),
                v1:Checkbox({
                    Disabled = true,
                    Checked = true
                }),
                v1:Checkbox({
                    Icon = "rbxassetid://16743550373",
                    Checked = true,
                    Color = Util.Colors.Red["500"]
                })
            }
        })
    end,
    fusion = Fusion
}
