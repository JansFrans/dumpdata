-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    Image = require(script.Parent.Image),
    Group = require(script.Parent.Group),
    Icon = require(script.Parent.Icon)
}

return function(p1, p2) -- line: 52
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), Children (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.Image, nil)
    local v4 = Util.Fallback(p2.RingEnabled, false)
    local v5 = Util.Fallback(p2.RingColor, v2.Colors.Primary.Main)
    local v6 = Util.Fallback(p2.RingThickness, v2.StrokeThickness["2"])
    local v7 = Util.Fallback(p2.IndicatorEnabled, false)
    local v8 = Util.Fallback(p2.IndicatorColor, v2.Colors.Primary.Main)
    local v9 = Util.Fallback(p2.IndicatorCornerRadius, v1:UDim(0, v2.CornerRadius.Full))
    local v10 = Util.Fallback(p2.IndicatorIcon, nil)
    local v11 = Util.Fallback(p2.IndicatorIconColor, Util.Colors.White)

    return v1:Image(Util.CombineProps(p2, {
        Name = script.Name,
        Image = v3,
        Size = v1:UDim2Offset(v2.TextSize["4.5"], v2.TextSize["4.5"]),
        BackgroundColor3 = v2.Colors.Neutral.Dark,
        Stroke = {
            Enabled = v4,
            Color = v1:Spring(v5, v2.SpringSpeed["0.5"], v2.SpringDampening["1"]),
            Thickness = v1:Spring(v6, v2.SpringSpeed["0.5"], v2.SpringDampening["1"])
        },
        Corner = {
            Radius = v1:UDim(0, v2.CornerRadius["1"])
        },
        [Children] = {
            v1:Computed(function(p3) -- line: 81
                -- upvalues: v1 (copy), v2 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), Themer (copy), Children (copy)
                if p3(v7) then
                    return Themer.Theme:is(v2):during(function() -- line: 83
                        -- upvalues: v1 (copy), v2 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), Children (copy)
                        return v1:Group({
                            Name = "Indicator",
                            BackgroundColor3 = v1:Spring(v8, v2.SpringSpeed["0.5"], v2.SpringDampening["1"]),
                            BackgroundTransparency = 0,
                            Size = UDim2.fromScale(0.25, 0.25),
                            AutomaticSize = Enum.AutomaticSize.None,
                            AnchorPoint = Vector2.new(1, 1),
                            Position = UDim2.fromScale(1, 1),
                            Aspect = {
                                Ratio = 1
                            },
                            Corner = {
                                Radius = v9
                            },
                            [Children] = {
                                v1:Icon({
                                    Image = v10,
                                    ImageColor3 = v11,
                                    ImageTransparency = v1:Computed(function(p4) -- line: 107
                                        -- upvalues: v10 (copy)
                                        if p4(v10) then
                                            return 0
                                        end

                                        return 1
                                    end),
                                    Size = UDim2.fromScale(1, 1),
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    Position = UDim2.fromScale(0.5, 0.5)
                                })
                            }
                        })
                    end)
                end
            end)
        }
    }))
end
