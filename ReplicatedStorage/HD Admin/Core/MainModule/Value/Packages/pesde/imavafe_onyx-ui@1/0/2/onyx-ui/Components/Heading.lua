-- https://lua.expert

local ParentParent = script.Parent.Parent
local Util = require(ParentParent.Util)
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local t1 = {
    Text = require(ParentParent.Components.Text)
}

return function(p1, p2) -- line: 31
    -- upvalues: Util (copy), Fusion (copy), Themer (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.HeadingSize, 1.75)
    local v4 = Util.Fallback(p2.TextSize, v2.TextSize["1"])

    return v1:Text(Util.CombineProps(p2, {
        Name = script.Name,
        TextSize = v1:Computed(function(p3) -- line: 40
            -- upvalues: v3 (copy), v4 (copy)
            local v5 = p3(v3)

            return p3(v4) * v5
        end),
        FontFace = v1:Font(v2.Font.Heading, v2.FontWeight.Heading)
    }))
end
