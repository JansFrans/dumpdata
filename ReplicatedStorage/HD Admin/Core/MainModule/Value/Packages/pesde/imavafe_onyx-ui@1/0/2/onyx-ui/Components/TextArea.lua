-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local t1 = {
    TextInput = require(ParentParent.Components.TextInput)
}

return function(p1, p2) -- line: 25
    -- upvalues: Util (copy), Fusion (copy), t1 (copy)
    return Fusion.innerScope(p1, Fusion, Util, t1):TextInput(Util.CombineProps(p2, {
        TextWrapped = true,
        MultiLine = true,
        AutomaticSize = Enum.AutomaticSize.None
    }))
end
