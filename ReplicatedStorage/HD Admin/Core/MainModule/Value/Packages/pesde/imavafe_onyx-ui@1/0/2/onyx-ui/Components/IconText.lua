-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local Frame = require(ParentParent.Components.Frame)
local t1 = {
    Text = require(ParentParent.Components.Text),
    Icon = require(ParentParent.Components.Icon),
    Frame = Frame
}

return function(p1, p2) -- line: 47
    -- upvalues: Util (copy), Fusion (copy), Themer (copy), Children (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.Content, {})
    local v4 = Util.Fallback(p2.ContentSize, v2.TextSize["1"])
    local v5 = Util.Fallback(p2.ContentColor, v2.Colors.BaseContent.Main)
    local v6 = Util.Fallback(p2.ContentTransparency, 0)
    local v7 = Util.Fallback(p2.ContentWrapped, true)
    local v8 = Util.Fallback(p2.ContentRichText, true)
    local v9 = Util.Fallback(p2.ContentFontFace, v1:Font(v2.Font.Body, v2.FontWeight.Body))

    return v1:Frame(Util.CombineProps(p2, {
        Name = script.Name,
        List = {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = v1:UDim(0, v2.Spacing["0"])
        },
        [Children] = {
            v1:ForPairs(v3, function(_, p4, p5, p6) -- line: 67
                -- upvalues: v2 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), Themer (copy)
                return p5, Themer.Theme:is(v2):during(function() -- line: 69
                    -- upvalues: p4 (copy), p6 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy)
                    if string.find(p6, "rbxassetid://", 1, true) then
                        return p4:Icon({
                            Image = p6,
                            ImageColor3 = v5,
                            Size = p4:UDim2Offset(v4, v4),
                            ImageTransparency = v6
                        })
                    end

                    return p4:Text({
                        Text = p6,
                        TextColor3 = v5,
                        TextSize = v4,
                        TextTransparency = v6,
                        TextWrapped = v7,
                        RichText = v8,
                        FontFace = v9
                    })
                end)
            end)
        }
    }))
end
