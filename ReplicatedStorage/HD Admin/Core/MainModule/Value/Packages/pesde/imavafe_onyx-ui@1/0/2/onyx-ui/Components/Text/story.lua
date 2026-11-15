-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local t1 = {
    Text = require(ParentParent.Components.Text)
}

return {
    story = function(p1) -- story | line: 10
        -- upvalues: Fusion (copy), Util (copy), t1 (copy)
        Fusion.scoped(Fusion, Util, t1):Text({
            Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
            Parent = p1.target
        })
    end,
    fusion = Fusion
}
