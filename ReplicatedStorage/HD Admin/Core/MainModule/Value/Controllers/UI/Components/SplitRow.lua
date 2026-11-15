-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local Pressable = require(UI.Components.Pressable)
local ClipHighlight = require(UI.Components.ClipHighlight)

return function(p1, p2) -- line: 51
    -- upvalues: Theme (copy), Children (copy), Pressable (copy), ClipHighlight (copy)
    debug.profilebegin("HD_SplitRow")

    local v1 = p2.height or 38
    local v2 = p2.cornerRadius or 9
    local t1 = {}

    if p2.left then
        table.insert(t1, {
            position = "left",
            slot = p2.left
        })
    end

    if p2.center then
        table.insert(t1, {
            position = "center",
            slot = p2.center
        })
    end

    if p2.right then
        table.insert(t1, {
            position = "right",
            slot = p2.right
        })
    end

    if p2.rights then
        for _, v3 in p2.rights do
            table.insert(t1, {
                position = "right",
                slot = v3
            })
        end
    end

    local v4 = #t1
    local t6 = {}
    local t7 = {}

    for v5, v6 in t1 do
        t6[v5] = v6.slot.isHovered or p1:Value(false)
        t7[v5] = v6.slot.isPressed or p1:Value(false)
    end

    local t8 = {}

    for _ = 1, v4 do
        table.insert(t8, false)
    end

    local v8 = table.create((math.max(0, v4 - 1)))

    local function updateDividers() -- line: 81
        -- upvalues: v4 (copy), t8 (copy), v8 (copy)
        for i = 1, v4 - 1 do
            local v9 = v8[i]

            if v9 then
                v9.BackgroundTransparency = (t8[i] or t8[i + 1]) and 1 or 0.85
            end
        end
    end

    local t9 = {}

    if p2.strokeColor == nil then
        table.insert(t9, p1:New("UIGradient")({
            Rotation = 90,
            Color = p1:Computed(function(p3) -- line: 94
                -- upvalues: Theme (copy)
                local v10 = p3(Theme.Color.NeutralContent)
                local v11 = p3(Theme.Color.Neutral)

                return ColorSequence.new({
                    ColorSequenceKeypoint.new(0, v10),
                    ColorSequenceKeypoint.new(1, v11)
                })
            end)
        }))
    end

    local t12 = {
        p1:New("UICorner")({
            CornerRadius = UDim.new(0, v2)
        }),
        p1:New("UIStroke")({
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = if p2.strokeColor == nil then Color3.new(1, 1, 1) else p2.strokeColor,
            [Children] = t9
        }),
        p1:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.None,
            Padding = UDim.new(0, 1),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
    }

    for v13, v14 in t1 do
        local slot = v14.slot
        local v15 = v13 == 1
        local v16 = v13 == v4
        local v17 = v13 * 2
        local v18, v19

        if v4 == 1 or v15 then
            v18 = "left"
            v19 = false
        else
            v19 = not v16
            v18 = "right"
        end

        local t13 = {
            side = v18,
            cornerRadius = v2,
            hideCorner = v19,
            noExtend = (not v16 or not (v4 >= 2)) and p1:Computed(function(p4) -- line: 152
                -- upvalues: t1 (copy), v4 (copy), v13 (copy)
                for i = v13 + 1, v4 do
                    local slot = t1[i].slot

                    if slot.visible == nil or p4(slot.visible) then
                        return false
                    end
                end

                return true
            end)
        }

        if slot.clipHighlight then
            for v20, v21 in slot.clipHighlight do
                t13[v20] = v21
            end
        end

        t13.color = slot.backgroundColor or p1:Computed(function(p5) -- line: 169
            -- upvalues: t6 (copy), t7 (copy), v13 (copy), Theme (copy), Pressable (copy)
            local v22 = p5(Theme.Color.Neutral)

            return Pressable.applyHighlight(p5, v22, t7[v13], t6[v13])
        end)

        local onHoverChanged, onPressChanged = slot.onHoverChanged, slot.onPressChanged

        local function onHover(p6) -- line: 180
            -- upvalues: t6 (copy), t8 (copy), updateDividers (copy), v13 (copy), onHoverChanged (copy)
            t8[v13] = p6
            t6[v13]:set(p6)
            updateDividers()

            if onHoverChanged then
                onHoverChanged(p6)
            end
        end

        local function onPress(p7) -- line: 187
            -- upvalues: t7 (copy), v13 (copy), onPressChanged (copy)
            t7[v13]:set(p7)

            if onPressChanged then
                onPressChanged(p7)
            end
        end

        local v23 = if slot.fills then UDim2.new(0, 0, 1, 0) elseif slot.width == nil then UDim2.fromScale(0, 1) else UDim2.new(0, slot.width, 1, 0)
        local v24 = if slot.fills then p1:New("UIFlexItem")({
            FlexMode = Enum.UIFlexMode.Fill
        })
            elseif slot.width == nil then p1:New("UIAspectRatioConstraint")({
                AspectType = Enum.AspectType.ScaleWithParentSize,
                DominantAxis = Enum.DominantAxis.Height
            })
            else nil
        local v25 = Pressable(p1, {
            name = slot.name or v14.position,
            size = v23,
            layoutOrder = v17,
            visible = slot.visible,
            interactable = slot.interactable,
            onActivate = slot.onActivate,
            onHoverChanged = onHover,
            onPressChanged = onPress,
            [Children] = {
                ClipHighlight(p1, t13),
                v24,
                slot[Children]
            }
        })

        if slot.ref then
            slot.ref:set(v25)
        end

        table.insert(t12, v25)

        if not v16 and t1[v13 + 1].slot.backgroundColor == nil then
            local visible = slot.visible
            local visible2 = t1[v13 + 1].slot.visible
            local v26 = if visible == nil and visible2 == nil then nil else p1:Computed(function(p8) -- line: 238
                -- upvalues: visible (copy), visible2 (copy)
                local v27 = visible == nil or p8(visible)
                local v28 = visible2 == nil or p8(visible2)

                return v27 and v28
            end)
            local v29 = p1:New("Frame")({
                Name = "Divider",
                BackgroundTransparency = 0.85,
                BorderSizePixel = 0,
                BackgroundColor3 = Theme.Color.NeutralContentDark,
                LayoutOrder = v17 + 1,
                Size = UDim2.new(0, 1, 0, 26),
                Visible = v26
            })

            v8[v13] = v29
            table.insert(t12, v29)
        end
    end

    local v30 = p1:New("Frame")({
        Name = p2.name or "SplitRow",
        BackgroundColor3 = Theme.Color.Neutral,
        LayoutOrder = p2.layoutOrder,
        Size = p2.size or UDim2.new(1, 0, 0, v1),
        ZIndex = p2.zIndex,
        [Children] = t12
    })

    debug.profileend()

    return v30
end
