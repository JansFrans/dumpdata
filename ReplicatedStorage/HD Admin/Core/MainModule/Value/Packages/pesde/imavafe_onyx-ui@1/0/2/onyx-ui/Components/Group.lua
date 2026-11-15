-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local t1 = {
    Base = require(script.Parent.Base)
}

return function(p1, p2) -- line: 30
    -- upvalues: Util (copy), Fusion (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)

    return v1:Hydrate(v1:Base(Util.CombineProps(p2, {
        ClassName = "CanvasGroup",
        BackgroundTransparency = 1,
        Name = script.Name,
        AutomaticSize = Enum.AutomaticSize.XY
    })))({
        GroupTransparency = p2.GroupTransparency,
        GroupColor3 = p2.GroupColor3
    })
end
