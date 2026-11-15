-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    Frame = require(script.Parent.Frame),
    IconText = require(script.Parent.IconText)
}

return function(p1, p2) -- line: 42
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), Children (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.Content, {})
    local v4 = Util.Fallback(p2.ContentWrapped, true)
    local v5 = Util.Fallback(p2.Color, v2.Colors.Base.Main)
    local v6 = Util.Fallback(p2.ContentColor, v1:Computed(function(p3) -- line: 52
        -- upvalues: v2 (copy), v5 (copy), Util (copy)
        return Util.Emphasize(p3(v5), p3(v2.Emphasis.Contrast))
    end))
    local v7 = Util.Fallback(p2.ContentSize, v2.TextSize["1"])

    return v1:Frame(Util.CombineProps(p2, {
        Name = script.Name,
        BackgroundColor3 = v5,
        BackgroundTransparency = 0,
        Padding = {
            All = v1:UDim(0, v2.Padding["0"]),
            Left = v1:UDim(0, v2.Padding["0.25"]),
            Right = v1:UDim(0, v2.Padding["0.25"])
        },
        Corner = {
            Radius = v1:UDim(0, v2.CornerRadius["2"])
        },
        List = {
            Padding = v1:UDim(0, v2.Spacing["0.25"]),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Wraps = v4
        },
        Stroke = {},
        [Children] = {
            v1:IconText({
                Content = v3,
                ContentColor = v6,
                ContentSize = v7,
                ContentWrapped = v4,
                List = {
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = v1:UDim(0, v2.Spacing["0.25"])
                }
            })
        }
    }))
end
