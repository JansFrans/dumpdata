-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    Frame = require(script.Parent.Frame),
    IconButton = require(script.Parent.IconButton),
    IconText = require(script.Parent.IconText)
}

return function(p1, p2) -- line: 48
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), Children (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.Content, {})
    local v4 = Util.Fallback(p2.ContentSize, v2.TextSize["1"])
    local v5 = Util.Fallback(p2.ContentColor, v2.Colors.BaseContent.Main)
    local v6 = Util.Fallback(p2.ContentFontFace, v1:Font(v2.Font.Heading, v2.FontWeight.Heading))
    local v7 = Util.Fallback(p2.CloseButtonDisabled, false)
    local v8 = Util.Fallback(p2.CloseButtonIcon, "rbxassetid://80218226919142")
    local v9 = Util.Fallback(p2.OnClose, function() -- line: 59
    end)

    return v1:Frame(Util.CombineProps(p2, {
        Name = script.Name,
        Size = UDim2.fromScale(1, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        [Children] = {
            v1:IconText({
                Name = "Title",
                ContentWrapped = false,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0),
                Content = v3,
                ContentColor = v5,
                ContentSize = v4,
                ContentFontFace = v6,
                List = {
                    Padding = v1:UDim(0, v2.Spacing["0.5"])
                }
            }),
            v1:Computed(function(p3) -- line: 80
                -- upvalues: v1 (copy), v2 (copy), v4 (copy), v5 (copy), v7 (copy), v8 (copy), v9 (copy), Themer (copy)
                if p3(v7) == false then
                    return Themer.Theme:is(v2):during(function() -- line: 82
                        -- upvalues: p3 (copy), v1 (copy), v4 (copy), v5 (copy), v8 (copy), v9 (copy)
                        return v1:IconButton({
                            Name = "CloseButton",
                            Style = "Ghost",
                            Image = v8,
                            ContentSize = v4,
                            ContentColor = v5,
                            Color = v5,
                            AnchorPoint = Vector2.new(1, 0.5),
                            Position = UDim2.fromScale(1, 0.5),
                            OnActivate = function() -- OnActivate | line: 93
                                -- upvalues: p3 (copy), v9 (copy)
                                if p3(v9) then
                                    p3(v9)()
                                end
                            end
                        })
                    end)
                end
            end)
        }
    }))
end
