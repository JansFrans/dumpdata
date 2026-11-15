-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    Button = require(script.Parent.Button),
    Frame = require(script.Parent.Frame),
    Divider = require(script.Parent.Divider)
}

return {
    story = function(p1) -- story | line: 18
        -- upvalues: Fusion (copy), Util (copy), Themer (copy), Children (copy), t1 (copy)
        local v1 = Fusion.innerScope(p1.scope, Fusion, Util, t1)
        local v2 = Themer.Theme:now()

        v1:Frame({
            Parent = p1.target,
            List = {
                Padding = v1:UDim(0, v2.Spacing["0.5"])
            },
            Padding = {
                All = v1:UDim(0, v2.StrokeThickness["1"])
            },
            [Children] = {
                v1:Button({
                    Content = { "Button" }
                }),
                v1:Button({
                    Content = { "Button" },
                    Color = v2.Colors.BaseContent.Main
                }),
                v1:Button({
                    Content = { "Button" },
                    Color = v2.Colors.Primary.Main
                }),
                v1:Button({
                    Style = "Outlined",
                    Content = { "Button" },
                    Color = v2.Colors.Primary.Main
                }),
                v1:Button({
                    Content = { "rbxassetid://11560341132", "Purchase" },
                    Color = Color3.fromRGB(86, 255, 70)
                }),
                v1:Button({
                    Style = "Outlined",
                    Content = { "rbxassetid://13405228418", "Delete" },
                    Color = v2.Colors.Error.Main
                }),
                v1:Button({
                    Style = "Ghost",
                    Content = { "Ghost" },
                    Color = v2.Colors.BaseContent.Main
                }),
                v1:Button({
                    Disabled = true,
                    Content = { "rbxassetid://11560341132", "Bobux" },
                    Color = Color3.fromRGB(86, 255, 70)
                }),
                v1:Button({
                    Disabled = true,
                    Style = "Outlined",
                    Content = { "Testing" },
                    Color = Color3.fromRGB(86, 255, 70)
                }),
                v1:Divider({}),
                v1:Frame({
                    List = {
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    },
                    Padding = {
                        All = v1:UDim(0, v2.Padding["1"])
                    },
                    [Children] = {
                        v1:Button({
                            SizeVariant = "ExtraSmall",
                            Content = { "Button (xs)" },
                            Color = v2.Colors.Primary.Main
                        }),
                        v1:Button({
                            SizeVariant = "Small",
                            Content = { "Button (sm)" },
                            Color = v2.Colors.Primary.Main
                        }),
                        v1:Button({
                            SizeVariant = "Medium",
                            Content = { "Button (md)" },
                            Color = v2.Colors.Primary.Main
                        }),
                        v1:Button({
                            SizeVariant = "Large",
                            Content = { "Button (lg)" },
                            Color = v2.Colors.Primary.Main
                        }),
                        v1:Button({
                            SizeVariant = "ExtraLarge",
                            Content = { "Button (xl)" },
                            Color = v2.Colors.Primary.Main
                        })
                    }
                })
            }
        })
    end,
    fusion = Fusion
}
