-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local t1 = {
    IconText = require(script.Parent.IconText)
}

return {
    story = function(p1) -- story | line: 11
        -- upvalues: Fusion (copy), Util (copy), t1 (copy)
        Fusion.innerScope(p1.scope, Fusion, Util, t1):IconText({
            Parent = p1.target,
            Content = { "Here's a shop icon: ", "rbxassetid://75029721407761", ".", " And also the Loneka logo: ", "rbxassetid://16735398592", ". Now you can easily have both text and icons!" }
        })
    end,
    fusion = Fusion
}
