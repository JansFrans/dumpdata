-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local t1 = {
    Base = require(script.Parent.Base)
}

return function(p1, p2) -- line: 25
    -- upvalues: Fusion (copy), Util (copy), t1 (copy)
    return Fusion.innerScope(p1, Fusion, Util, t1):Base(Util.CombineProps(p2, {
        ClassName = "Frame",
        BackgroundTransparency = 1,
        Name = script.Name,
        AutomaticSize = Enum.AutomaticSize.XY
    }))
end
