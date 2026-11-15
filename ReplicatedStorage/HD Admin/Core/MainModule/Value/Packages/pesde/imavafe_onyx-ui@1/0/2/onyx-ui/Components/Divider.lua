-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    Frame = require(script.Parent.Frame)
}

return function(p1, p2) -- line: 39
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), Children (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.Length, UDim.new(1, 0))
    local v4 = Util.Fallback(p2.FillDirection, Enum.FillDirection.Horizontal)
    local v5 = Util.Fallback(p2.Color, v2.Colors.BaseContent.Main)
    local v6 = Util.Fallback(p2.Transparency, 0.9)
    local v7 = Util.Fallback(p2.Spacing, v1:UDim(0, v2.Spacing["0.5"]))
    local v8 = v1:Computed(function(p3) -- line: 49
        -- upvalues: v4 (copy), v7 (copy)
        if p3(v4) == Enum.FillDirection.Horizontal then
            return p3(v7)
        end

        return UDim.new()
    end)
    local v9 = v1:Computed(function(p4) -- line: 56
        -- upvalues: v4 (copy), v7 (copy)
        if p4(v4) == Enum.FillDirection.Vertical then
            return p4(v7)
        end

        return UDim.new()
    end)

    return v1:Frame(Util.CombineProps(p2, {
        Name = script.Name,
        Size = v1:Computed(function(p5) -- line: 66
            -- upvalues: v3 (copy), v4 (copy)
            if p5(v4) == Enum.FillDirection.Horizontal then
                return UDim2.new(v3, UDim.new(0, 0))
            end

            return UDim2.new(UDim.new(0, 0), p5(v3))
        end),
        AutomaticSize = v1:Computed(function(p6) -- line: 73
            -- upvalues: v4 (copy)
            if p6(v4) == Enum.FillDirection.Horizontal then
                return Enum.AutomaticSize.Y
            end

            return Enum.AutomaticSize.X
        end),
        Padding = {
            Top = v8,
            Bottom = v8,
            Left = v9,
            Right = v9
        },
        [Children] = {
            v1:Frame({
                Name = "DividingLine",
                Size = v1:Computed(function(p7) -- line: 90
                    -- upvalues: v2 (copy), v4 (copy)
                    if p7(v4) == Enum.FillDirection.Horizontal then
                        return UDim2.new(UDim.new(1, 0), UDim.new(0, p7(v2.StrokeThickness["1"])))
                    end

                    return UDim2.new(UDim.new(0, p7(v2.StrokeThickness["1"])), UDim.new(1, 0))
                end),
                AutomaticSize = Enum.AutomaticSize.None,
                BackgroundColor3 = v5,
                BackgroundTransparency = v6
            })
        }
    }))
end
