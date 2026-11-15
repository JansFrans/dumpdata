-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local t1 = {
    Icon = require(script.Parent.Icon)
}

return {
    story = function(p1) -- story | line: 11
        -- upvalues: Fusion (copy), Util (copy), t1 (copy)
        Fusion.innerScope(p1.scope, Fusion, Util, t1):Icon({
            Image = "rbxassetid://11560341132",
            Parent = p1.target
        })
    end,
    fusion = Fusion
}
