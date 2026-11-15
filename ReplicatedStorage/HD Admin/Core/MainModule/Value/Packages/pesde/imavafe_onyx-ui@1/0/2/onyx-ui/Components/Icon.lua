-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(script.Parent.Parent.Themer)
local t1 = {
    Image = require(script.Parent.Image)
}

return function(p1, p2) -- line: 26
    -- upvalues: Util (copy), Fusion (copy), Themer (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()

    return v1:Image(Util.CombineProps(p2, {
        BackgroundTransparency = 1,
        Name = script.Name,
        Size = v1:UDim2Offset(v2.TextSize["1"], v2.TextSize["1"])
    }))
end
