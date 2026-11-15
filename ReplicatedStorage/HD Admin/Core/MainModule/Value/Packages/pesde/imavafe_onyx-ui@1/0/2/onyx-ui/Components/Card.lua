-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local t1 = {
    Frame = require(script.Parent.Frame)
}

return function(p1, p2) -- line: 26
    -- upvalues: Fusion (copy), Themer (copy), Util (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.BackgroundColor3, v2.Colors.Base.Main)

    return v1:Frame(Util.CombineProps(p2, {
        BackgroundTransparency = 0,
        Name = script.Name,
        BackgroundColor3 = v3,
        Corner = {
            Radius = v1:UDim(0, v2.CornerRadius["1"])
        },
        Padding = {
            All = v1:UDim(0, v2.Padding["1"])
        },
        Stroke = {
            Color = v1:Computed(function(p3) -- line: 43
                -- upvalues: v2 (copy), v3 (copy), Util (copy)
                return Util.Emphasize(p3(v3), p3(v2.StrokeEmphasis.Light))
            end)
        }
    }))
end
