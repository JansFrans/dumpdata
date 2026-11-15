-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Themer = require(ParentParent.Themer)
local Util = require(ParentParent.Util)
local Children = Fusion.Children
local Frame = require(script.Parent.Frame)
local Button = require(script.Parent.Button)

return function(p1, p2) -- line: 37
    -- upvalues: Fusion (copy), Themer (copy), Util (copy), Children (copy), Frame (copy), Button (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, {
        Frame = Frame,
        Button = Button
    })
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.Tabs, {})
    local v4 = Util.Fallback(p2.Disabled, false)
    local v5 = Util.Fallback(p2.Color, v2.Colors.Primary.Main)
    local v6 = Util.Fallback(p2.Corner, {
        Radius = v1:UDim(0, v2.CornerRadius["1"])
    })
    local v7 = Util.Fallback(p2.ButtonProps, {})
    local v8 = v1:EnsureValue(Util.Fallback(p2.Tab, 1))

    return v1:Frame(Util.CombineProps(p2, {
        Name = script.Name,
        Corner = v6,
        List = {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = v1:UDim(0, v2.Spacing["0.5"])
        },
        [Children] = {
            v1:ForPairs(v3, function(_, p4, p5, p6) -- line: 63
                -- upvalues: v2 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), Themer (copy), Util (copy)
                return p5, Themer.Theme:is(v2):during(function() -- line: 65
                    -- upvalues: p4 (copy), p5 (copy), p6 (copy), v2 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), Util (copy)
                    return p4:Button(Util.CombineProps(v7, {
                        Name = "Tab",
                        Content = p6,
                        Disabled = v4,
                        Color = p4:Computed(function(p7) -- line: 70
                            -- upvalues: p5 (copy), v2 (copy), v5 (copy), v8 (copy)
                            if p5 == p7(v8) then
                                return p7(v5)
                            end

                            return p7(v2.Colors.Neutral.Main)
                        end),
                        Corner = v6,
                        OnActivate = function() -- OnActivate | line: 79
                            -- upvalues: p5 (copy), v8 (copy)
                            v8:set(p5)
                        end
                    }))
                end)
            end)
        }
    }))
end
