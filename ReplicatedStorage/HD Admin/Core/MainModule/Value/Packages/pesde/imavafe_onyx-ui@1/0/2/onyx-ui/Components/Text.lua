-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local t1 = {
    Base = require(script.Parent.Base)
}

return function(p1, p2) -- line: 57
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.TextColor3, v2.Colors.BaseContent.Main)
    local v4 = Util.Fallback(p2.TextSize, v2.TextSize["1"])
    local v5 = Util.Fallback(p2.RichText, true)
    local v6 = Util.Fallback(p2.FontFace, v1:Font(v2.Font.Body, v2.FontWeight.Body))
    local v7 = Util.Fallback(p2.TextWrapped, true)
    local v8 = Util.Fallback(p2.TextXAlignment, Enum.TextXAlignment.Left)
    local v9 = Util.Fallback(p2.TextYAlignment, Enum.TextYAlignment.Top)

    return v1:Hydrate(v1:Base(Util.CombineProps(p2, {
        ClassName = "TextLabel",
        ClipsDescendants = false,
        BackgroundTransparency = 1,
        Name = script.Name,
        AutomaticSize = Enum.AutomaticSize.XY
    })))({
        TextColor3 = v3,
        TextSize = v4,
        RichText = v5,
        FontFace = v6,
        TextWrapped = v7,
        TextXAlignment = v8,
        TextYAlignment = v9,
        Text = p2.Text,
        TextTransparency = p2.TextTransparency,
        MaxVisibleGraphemes = p2.MaxVisibleGraphemes,
        LocalizedText = p2.LocalizedText,
        LineHeight = p2.LineHeight,
        TextTruncate = p2.TextTruncate,
        TextScaled = p2.TextScaled,
        Font = p2.Font
    })
end
