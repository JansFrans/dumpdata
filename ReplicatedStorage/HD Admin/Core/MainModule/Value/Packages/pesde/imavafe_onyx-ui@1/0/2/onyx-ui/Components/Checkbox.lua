-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local ColorUtils = require(ParentParent.Parent.ColorUtils)
local Children = Fusion.Children
local t1 = {
    BaseButton = require(script.Parent.BaseButton),
    Icon = require(script.Parent.Icon)
}

return function(p1, p2) -- line: 41
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), ColorUtils (copy), Children (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = v1:EnsureValue(Util.Fallback(p2.Checked, false))
    local v4 = Util.Fallback(p2.Disabled, false)
    local v5 = Util.Fallback(p2.Color, v2.Colors.Primary.Main)
    local v6 = Util.Fallback(p2.Icon, "rbxassetid://13858821963")
    local v7 = v1:EnsureValue(Util.Fallback(p2.Hovering, false))
    local v8 = v1:EnsureValue(Util.Fallback(p2.Holding, false))
    local v9 = v1:Computed(function(p3) -- line: 53
        -- upvalues: v2 (copy), v4 (copy), v5 (copy), v7 (copy), v8 (copy), Util (copy)
        if p3(v4) then
            return p3(v2.Colors.BaseContent.Main)
        end

        if p3(v8) then
            return Util.Emphasize(p3(v5), p3(v2.Emphasis.Regular))
        end

        if p3(v7) then
            return Util.Emphasize(p3(v5), p3(v2.Emphasis.Light))
        end

        return p3(v5)
    end)
    local v10 = v1:Computed(function(p4) -- line: 66
        -- upvalues: v2 (copy), v3 (copy), v4 (copy), v7 (copy), v8 (copy)
        local v11 = p4(v2.StrokeEmphasis.Regular)

        if not p4(v4) and p4(v3) and not p4(v7) and not p4(v8) then
            return v11
        end

        return 0
    end)

    return v1:BaseButton(Util.CombineProps(p2, {
        Name = script.Name,
        BackgroundColor3 = v9,
        BackgroundTransparency = v1:Spring(v1:Computed(function(p5) -- line: 80
            -- upvalues: v3 (copy), v4 (copy)
            if p5(v4) then
                return 0.925
            end

            if p5(v3) then
                return 0
            end

            return 1
        end), v2.SpringSpeed["1"], v2.SpringDampening["1"]),
        Disabled = v4,
        Corner = {
            Radius = v1:UDim(0, v2.CornerRadius["0.5"])
        },
        Stroke = {
            Color = Color3.fromRGB(255, 255, 255),
            Gradient = {
                Rotation = 90,
                Color = v1:Computed(function(p6) -- line: 101
                    -- upvalues: v9 (copy), v10 (copy), ColorUtils (copy)
                    return ColorSequence.new({
                        ColorSequenceKeypoint.new(0, ColorUtils.Lighten(p6(v9), p6(v10))),
                        ColorSequenceKeypoint.new(1, p6(v9))
                    })
                end)
            },
            Transparency = v1:Computed(function(p7) -- line: 112
                -- upvalues: v4 (copy)
                if p7(v4) then
                    return 0.925
                end

                return 0
            end)
        },
        Hovering = v7,
        Holding = v8,
        OnActivate = function() -- OnActivate | line: 124
            -- upvalues: v3 (copy), Fusion (copy)
            v3:set(not Fusion.peek(v3))
        end,
        [Children] = {
            v1:Icon({
                Name = "Checkmark",
                Image = v6,
                ImageTransparency = v1:Spring(v1:Computed(function(p8) -- line: 133
                    -- upvalues: v3 (copy), v4 (copy)
                    if not p8(v3) then
                        return 1
                    end

                    if p8(v4) then
                        return 0.75
                    end

                    return 0
                end), v2.SpringSpeed["1"], v2.SpringDampening["1"]),
                ImageColor3 = v1:Computed(function(p9) -- line: 147
                    -- upvalues: v2 (copy), v5 (copy), Util (copy)
                    return Util.Emphasize(p9(v5), p9(v2.Emphasis.Contrast))
                end),
                Rotation = v1:Spring(v1:Computed(function(p10) -- line: 151
                    -- upvalues: v3 (copy)
                    if p10(v3) then
                        return 0
                    end

                    return -30
                end), v2.SpringSpeed["1"], v2.SpringDampening["1"])
            })
        }
    }))
end
