-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local t1 = {
    Base = require(script.Parent.Base)
}

return function(p1, p2) -- line: 57
    -- upvalues: Fusion (copy), Themer (copy), Util (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.BottomImage, v1:Computed(function(p3) -- line: 63
        -- upvalues: v2 (copy)
        if p3(v2.CornerRadius["1"]) >= 3 then
            return "rbxassetid://16547643439"
        end

        return "rbxassetid://16547330984"
    end))
    local v4 = Util.Fallback(p2.TopImage, v1:Computed(function(p4) -- line: 73
        -- upvalues: v2 (copy)
        if p4(v2.CornerRadius["1"]) >= 3 then
            return "rbxassetid://16547667444"
        end

        return "rbxassetid://16547330984"
    end))
    local v5 = Util.Fallback(p2.MidImage, "rbxassetid://16547330984")
    local v6 = Util.Fallback(p2.ScrollBarImageColor3, v2.Colors.NeutralContent.Dark)
    local v7 = Util.Fallback(p2.ScrollBarImageTransparency, 0)
    local v8 = Util.Fallback(p2.ScrollBarThickness, 8)
    local v9 = Util.Fallback(p2.AutomaticCanvasSize, Enum.AutomaticSize.Y)
    local v10 = Util.Fallback(p2.ScrollingDirection, Enum.ScrollingDirection.Y)

    return v1:Hydrate(v1:Base(Util.CombineProps(p2, {
        ClassName = "ScrollingFrame",
        Selectable = false,
        BackgroundTransparency = 1,
        Name = script.Name,
        AutomaticSize = Enum.AutomaticSize.None
    })))({
        BottomImage = v3,
        TopImage = v4,
        MidImage = v5,
        ScrollBarImageColor3 = v6,
        ScrollBarImageTransparency = v7,
        ScrollBarThickness = v8,
        AutomaticCanvasSize = v9,
        ScrollingDirection = v10,
        CanvasPosition = p2.CanvasPosition,
        CanvasSize = p2.CanvasSize,
        ElasticBehavior = p2.ElasticBehavior,
        HorizontalScrollBarInset = p2.HorizontalScrollBarInset,
        ScrollingEnabled = p2.ScrollingEnabled,
        VerticalScrollBarInset = Util.Fallback(p2.VerticalScrollBarInset, Enum.ScrollBarInset.ScrollBar),
        VerticalScrollBarPosition = p2.VerticalScrollBarPosition
    })
end
