-- https://lua.expert

game:GetService("Workspace")

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local ViewportSize = require(ParentParent.Util.ViewportSize)
local _ = Fusion.Out
local t1 = {
    Base = require(script.Parent.Base),
    Frame = require(script.Parent.Frame)
}

return function(p1, p2) -- line: 41
    -- upvalues: Fusion (copy), Util (copy), ViewportSize (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Util.Fallback(p2.BaseResolution, Vector2.new())
    local v3 = Util.Fallback(p2.MinScale, 0.8)
    local v4 = Util.Fallback(p2.MaxScale, 1e999)
    local v5 = Util.Fallback(p2.ScaleMultiplier, 1)
    local v6 = v1:Value(Vector2.new())

    ViewportSize:Observe(function(p3) -- line: 51
        -- upvalues: v6 (copy)
        v6:set(p3)
    end)

    return v1:Frame(Util.CombineProps(p2, {
        Name = script.Name,
        Scale = {
            Scale = v1:Computed(function(p4) -- line: 58
                -- upvalues: v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy)
                return (math.clamp(p4(v5) / math.max(p4(v2).X / p4(v6).X, p4(v2).Y / p4(v6).Y), p4(v3), (p4(v4))))
            end)
        }
    }))
end
