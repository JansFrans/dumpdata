-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local t1 = {
    Scroller = require(script.Parent.Scroller)
}

return {
    story = function(p1) -- story | line: 11
        -- upvalues: Fusion (copy), Util (copy), t1 (copy)
        Fusion.innerScope(p1.scope, Fusion, Util, t1):Scroller({
            Parent = p1.target,
            Size = UDim2.fromOffset(200, 200),
            CanvasSize = UDim2.new(UDim.new(1, 0), UDim.new(0, 1000)),
            AutomaticCanvasSize = Enum.AutomaticSize.None
        })
    end,
    fusion = Fusion
}
