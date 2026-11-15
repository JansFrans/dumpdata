-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local t1 = {
    Button = require(script.Parent.Button)
}

return function(p1, p2) -- line: 29
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.Image, "")
    local v4 = v1:UDim(0, v2.Spacing["0.25"])

    return v1:Button(Util.CombineProps(p2, {
        Name = script.Name,
        Padding = {
            Left = v4,
            Right = v4,
            Top = v4,
            Bottom = v4
        },
        Content = v1:Computed(function(p3) -- line: 45
            -- upvalues: v3 (copy)
            return { p3(v3) }
        end)
    }))
end
