-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local Children = Fusion.Children
local t1 = {
    IconButton = require(script.Parent.IconButton),
    Frame = require(script.Parent.Frame)
}

return {
    story = function(p1) -- story | line: 17
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
                v1:IconButton({
                    Image = "rbxassetid://10814531047"
                }),
                v1:IconButton({
                    Image = "rbxassetid://10814531047",
                    Color = v2.Colors.Primary.Main
                }),
                v1:IconButton({
                    Image = "rbxassetid://11560341132",
                    Color = Util.Colors.Amber["500"]
                }),
                v1:IconButton({
                    Image = "rbxassetid://13405228418",
                    Style = "Outlined",
                    Color = Util.Colors.Red["500"]
                }),
                v1:IconButton({
                    Image = "rbxassetid://13405228418",
                    Style = "Ghost",
                    Color = Util.Colors.Red["500"]
                }),
                v1:IconButton({
                    Image = "rbxassetid://10814531047",
                    Disabled = true
                }),
                v1:IconButton({
                    Image = "rbxassetid://10814531047",
                    Style = "Ghost",
                    Disabled = true
                })
            }
        })
    end,
    fusion = Fusion
}
