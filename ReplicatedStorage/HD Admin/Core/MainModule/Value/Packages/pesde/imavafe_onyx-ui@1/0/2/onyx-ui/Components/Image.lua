-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local t1 = {
    Base = require(script.Parent.Base)
}

return function(p1, p2) -- line: 48
    -- upvalues: Fusion (copy), Util (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Util.Fallback(p2.FallbackImage, "rbxasset://textures/ui/GuiImagePlaceholder.png")
    local v3 = Util.Fallback(p2.Image, nil)
    local v4 = v1:Computed(function(p3) -- line: 54
        -- upvalues: v2 (copy), v3 (copy)
        if p3(v3) then
            return p3(v3)
        end

        return p3(v2)
    end)

    return v1:Hydrate(v1:Base(Util.CombineProps(p2, {
        ClassName = "ImageLabel",
        Name = script.Name,
        Size = UDim2.fromOffset(100, 100),
        AutomaticSize = Enum.AutomaticSize.None
    })))({
        Image = v4,
        ImageColor3 = p2.ImageColor3,
        ImageTransparency = p2.ImageTransparency,
        ImageRectOffset = p2.ImageRectOffset,
        ImageRectSize = p2.ImageRectSize,
        ResampleMode = p2.ResampleMode,
        ScaleType = p2.ScaleType,
        SliceCenter = p2.SliceCenter,
        SliceScale = p2.SliceScale,
        TileSize = p2.TileSize
    })
end
