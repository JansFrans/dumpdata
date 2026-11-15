-- https://lua.expert

local ParentParent = script.Parent.Parent
local Fusion = require(ParentParent.Parent.Fusion)
local Util = require(ParentParent.Util)
local Themer = require(ParentParent.Themer)
local Children = Fusion.Children
local t1 = {
    BaseButton = require(script.Parent.BaseButton),
    Text = require(script.Parent.Text),
    IconButton = require(script.Parent.IconButton)
}

return function(p1, p2) -- line: 41
    -- upvalues: Fusion (copy), Util (copy), Themer (copy), Children (copy), t1 (copy)
    local v1 = Fusion.innerScope(p1, Fusion, Util, t1)
    local v2 = Themer.Theme:now()
    local v3 = Util.Fallback(p2.Options, {})
    local v4 = v1:EnsureValue(Util.Fallback(p2.Selection, 1))
    local v5 = Util.Fallback(p2.Color, v2.Colors.BaseContent.Main)
    local v6 = Util.Fallback(p2.Disabled, false)
    local v7 = Util.Fallback(p2.ContentSize, v2.TextSize["1"])
    local v8 = v1:Value(false)
    local v9 = v1:Value(false)
    local v10 = v1:Value(0)
    local v11 = v1:Computed(function(p3) -- line: 55
        -- upvalues: v3 (copy), v4 (copy)
        return p3(v3)[p3(v4)]
    end)
    local v12 = v1:Computed(function(p4) -- line: 61
        -- upvalues: v2 (copy), v5 (copy), v6 (copy), v8 (copy), v9 (copy), Util (copy)
        if p4(v6) then
            return p4(v2.Colors.BaseContent.Main)
        end

        if p4(v8) then
            return Util.Emphasize(p4(v5), p4(v2.Emphasis.Regular))
        end

        if p4(v9) then
            return Util.Emphasize(p4(v5), p4(v2.Emphasis.Light))
        end

        return p4(v5)
    end)

    v1:Observer(v3):onChange(function() -- line: 75
        -- upvalues: v4 (copy)
        v4:set(1)
    end)

    local function RotateSelection(p5) -- line: 79
        -- upvalues: v3 (copy), v4 (copy), Fusion (copy)
        local v13 = Fusion.peek(v3)
        local v14 = Fusion.peek(v4) + p5

        if #v13 < v14 then
            v14 = 1
        elseif v14 < 1 then
            v14 = #v13
        end

        v4:set(v14)
    end

    local v15 = Fusion.peek(p2.Selection) or 1

    v1:Observer(v4):onChange(function() -- line: 94
        -- upvalues: v4 (copy), v10 (copy), v15 (copy), Fusion (copy)
        v10:set(Fusion.peek(v4) > v15 and 1 or -1)
        task.wait(0.1)
        v10:set(0)
    end)

    local v17 = v1:UDim(0, v2.Spacing["0"])

    return v1:BaseButton(Util.CombineProps(p2, {
        Name = script.Name,
        List = {
            HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center
        },
        Padding = {
            All = v1:UDim(0, v2.Padding["0.5"])
        },
        Stroke = {
            Color = v5,
            Transparency = v1:Spring(v1:Computed(function(p6) -- line: 118
                -- upvalues: v6 (copy)
                if p6(v6) then
                    return 0.9
                end

                return 0.8
            end), v2.SpringSpeed["1"], v2.SpringDampening["1"])
        },
        Corner = {
            Radius = v1:UDim(0, v2.CornerRadius["1"])
        },
        Disabled = v6,
        Holding = v8,
        Hovering = v9,
        OnActivate = function() -- OnActivate | line: 138
            -- upvalues: v3 (copy), v4 (copy), Fusion (copy)
            local v18 = Fusion.peek(v3)
            local v19 = Fusion.peek(v4) + 1

            if #v18 < v19 then
                v19 = 1
            elseif v19 < 1 then
                v19 = #v18
            end

            v4:set(v19)
        end,
        [Children] = {
            v1:IconButton({
                Name = "LeftArrow",
                Image = "rbxassetid://136326079088976",
                Style = "Ghost",
                Color = v5,
                Disabled = v6,
                ContentSize = v1:Spring(v1:Computed(function(p7) -- line: 150
                    -- upvalues: v2 (copy), v7 (copy), v10 (copy)
                    local v20 = p7(v10)
                    local v21 = p7(v7)

                    if v20 < 0 then
                        return v21 * (1 - p7(v2.Emphasis.Regular))
                    end

                    return p7(v21)
                end), v2.SpringSpeed["1"], v2.SpringDampening["1"]),
                Padding = {
                    Top = v17,
                    Left = v17,
                    Right = v17,
                    Bottom = v17
                },
                OnActivate = function() -- OnActivate | line: 170
                    -- upvalues: v3 (copy), v4 (copy), Fusion (copy)
                    local v22 = Fusion.peek(v3)
                    local v23 = Fusion.peek(v4) + -1

                    if #v22 < v23 then
                        v23 = 1
                    elseif v23 < 1 then
                        v23 = #v22
                    end

                    v4:set(v23)
                end
            }),
            v1:Text({
                Text = v1:Computed(function(p8) -- line: 175
                    -- upvalues: v11 (copy)
                    local v25 = p8(v11)

                    if v25 == nil then
                        return ""
                    end

                    return v25
                end),
                TextColor3 = v12,
                TextTransparency = v1:Computed(function(p9) -- line: 184
                    -- upvalues: v6 (copy)
                    if p9(v6) then
                        return 0.75
                    end

                    return 0
                end),
                SizeLimit = {
                    Min = v1:Vector2(0, v7)
                }
            }),
            v1:IconButton({
                Name = "RightArrow",
                Image = "rbxassetid://85293585205481",
                Style = "Ghost",
                Color = v5,
                Disabled = v6,
                ContentSize = v1:Spring(v1:Computed(function(p10) -- line: 202
                    -- upvalues: v2 (copy), v7 (copy), v10 (copy)
                    local v27 = p10(v10)
                    local v28 = p10(v7)

                    if v27 > 0 then
                        return p10(v28 * (1 - p10(v2.Emphasis.Regular)))
                    end

                    return p10(v28)
                end), v2.SpringSpeed["1"], v2.SpringDampening["1"]),
                Padding = {
                    Top = v17,
                    Left = v17,
                    Right = v17,
                    Bottom = v17
                },
                OnActivate = function() -- OnActivate | line: 222
                    -- upvalues: v3 (copy), v4 (copy), Fusion (copy)
                    local v29 = Fusion.peek(v3)
                    local v30 = Fusion.peek(v4) + 1

                    if #v29 < v30 then
                        v30 = 1
                    elseif v30 < 1 then
                        v30 = #v29
                    end

                    v4:set(v30)
                end
            })
        }
    }))
end
