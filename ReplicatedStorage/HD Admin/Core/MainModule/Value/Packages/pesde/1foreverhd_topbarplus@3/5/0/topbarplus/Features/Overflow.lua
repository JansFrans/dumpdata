-- https://lua.expert

local t2 = {}
local t3 = {}
local iconsDictionary
local CurrentCamera = workspace.CurrentCamera
local t4 = {}
local t5 = {}
local Utility = require(script.Parent.Parent.Utility)
local v1 = false
local v2 = false
local v3
local t1 = {}

function t1.start(p1) -- line: 25
    -- upvalues: t1 (copy), t2 (copy), iconsDictionary (ref), CurrentCamera (copy), Utility (copy), v1 (ref), v3 (ref)
    v3 = p1
    iconsDictionary = v3.iconsDictionary

    local v4

    for _, v5 in pairs(v3.container) do
        if v4 == nil and v5.ScreenInsets == Enum.ScreenInsets.TopbarSafeInsets then
            v4 = v5
        end

        for _, child in pairs(v5.Holders:GetChildren()) do
            if child:GetAttribute("IsAHolder") then
                t2[child.Name] = child
            end
        end
    end

    local v6 = false
    local v7 = Utility.createStagger(0.1, function(p2) -- line: 43
        -- upvalues: v6 (ref), t1 (copy)
        if not v6 then
            return
        end

        if not p2 then
            t1.updateAvailableIcons("Center")
        end

        t1.updateBoundary("Left")
        t1.updateBoundary("Right")
    end)

    task.delay(0.5, function() -- line: 53
        -- upvalues: v6 (ref), v7 (copy)
        v6 = true
        v7()
    end)
    task.delay(2, function() -- line: 57
        -- upvalues: v7 (copy), v1 (ref)
        v1 = true
        v7()
    end)
    v3.iconAdded:Connect(v7)
    v3.iconRemoved:Connect(v7)
    v3.iconChanged:Connect(v7)
    CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 67
        -- upvalues: v7 (copy)
        v7(true)
    end)
    v4:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 70
        -- upvalues: v7 (copy)
        v7(true)
    end)

    for _, v8 in pairs(t2) do
        v8:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 77
            -- upvalues: v7 (copy)
            v7(true)
        end)
        v8:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 80
            -- upvalues: v7 (copy)
            v7(true)
        end)
    end
end

function t1.getWidth(p3, _) -- line: 86
    local widget = p3.widget

    return widget:GetAttribute("TargetWidth") or widget.AbsoluteSize.X
end

function t1.getAvailableIcons(p5) -- line: 91
    -- upvalues: t1 (copy), t3 (copy)
    return t3[p5] or t1.updateAvailableIcons(p5)
end

function t1.updateAvailableIcons(p6) -- line: 99
    -- upvalues: t3 (copy), iconsDictionary (ref), t5 (copy)
    local t6 = {}
    local n1 = 0

    for _, v9 in pairs(iconsDictionary) do
        local parentIconUID = v9.parentIconUID
        local v10 = not parentIconUID or t5[parentIconUID]
        local v11 = t5[v9.UID]

        if v10 and v9.alignment == p6 and not v11 and v9.isEnabled then
            table.insert(t6, v9)
            n1 += 1
        end
    end

    if n1 <= 0 then
        return {}
    end

    table.sort(t6, function(p7, p8) -- line: 121
        local LayoutOrder = p7.widget.LayoutOrder
        local LayoutOrder2 = p8.widget.LayoutOrder
        local parentIconUID = p7.parentIconUID
        local parentIconUID2 = p8.parentIconUID

        if parentIconUID == parentIconUID2 then
            if LayoutOrder < LayoutOrder2 then
                return true
            end

            if LayoutOrder2 < LayoutOrder then
                return false
            end

            return p7.widget.AbsolutePosition.X < p8.widget.AbsolutePosition.X
        end

        if parentIconUID2 then
            return false
        end

        return if parentIconUID then true else nil
    end)
    t3[p6] = t6

    return t6
end

function t1.getRealXPositions(p9, p10) -- line: 148
    -- upvalues: t1 (copy), t2 (copy), Utility (copy)
    local v12 = p9 == "Left"
    local v13 = t2[p9]
    local X = v13.AbsolutePosition.X
    local X2 = v13.AbsoluteSize.X
    local Offset = v13.UIListLayout.Padding.Offset

    if not v12 or not X then
        X += X2
    end

    local t7 = {}

    if v12 then
        Utility.reverseTable(p10)
    end

    for i = #p10, 1, -1 do
        local v14 = p10[i]
        local v15 = t1.getWidth(v14)

        if not v12 then
            X -= v15
        end

        t7[v14.UID] = X

        if v12 then
            X += v15
        end

        X += if v12 and Offset then Offset else -Offset
    end

    return t7
end

function t1.updateBoundary(p11) -- line: 177
    -- upvalues: t1 (copy), t2 (copy), t4 (copy), t5 (copy), Utility (copy), v1 (ref), v2 (ref), v3 (ref)
    local v16 = t2[p11]
    local UIListLayout = v16.UIListLayout
    local X = v16.AbsolutePosition.X
    local X2 = v16.AbsoluteSize.X
    local Offset, Offset2 = UIListLayout.Padding.Offset, UIListLayout.Padding.Offset
    local v17 = t1.updateAvailableIcons(p11)
    local n2 = 0
    local n3 = 0

    for _, v18 in pairs(v17) do
        n2 += t1.getWidth(v18) + Offset2
        n3 += 1
    end

    if n3 <= 0 then
        return
    end

    local v19 = p11 == "Center"
    local v20 = p11 == "Left"
    local v21 = not v20
    local v22 = t4[p11]
    local v24
    local v23 = v22

    if v22 or v19 then
    elseif #v17 > 0 then
        v24 = if v20 then -9999999 else 9999999
        v23 = v3.new()
        v23:setImage(6069276526, "Deselected")
        v23:setName("Overflow" .. p11)
        v23:setOrder(v24)
        v23:setAlignment(p11)
        v23:autoDeselect(false)
        v23.isAnOverflow = true
        v23:select("OverflowStart", v23)
        v23:setEnabled(false)
        t4[p11] = v23
        t5[v23.UID] = true

        if not v3.closeableOverflowMenus then
            v23:getInstance("IconSpot").Visible = false
        end
    end

    local v25 = if p11 == "Left" then "Right" else "Left"
    local v26 = t1.updateAvailableIcons(v25)
    local v27 = v20 and v26[1] or v21 and v26[#v26]
    local v28 = t4[v25]
    local v29 = v20 and X + X2 or X

    if v27 then
        local v30 = t1.getRealXPositions(v25, v26)[v27.UID]
        local v31 = t1.getWidth(v27)

        v29 = v20 and v30 - Offset or v30 + v31 + Offset
    end

    local n4 = 0

    local function checkToShiftCentralIcon() -- line: 244
        -- upvalues: p11 (copy), Offset (copy), v17 (copy), v20 (copy), v21 (copy), n4 (ref), checkToShiftCentralIcon (copy), t1 (copy), v1 (ref), v2 (ref)
        local Center = t1.getAvailableIcons("Center")
        local v32 = Center[if v20 then 1 else #Center]

        local function secondaryCheck() -- line: 248
            -- upvalues: p11 (copy), t1 (copy), v2 (ref)
            if not v2 then
                v2 = true
                task.delay(3, t1.updateBoundary, p11)
            end
        end

        local v33

        if not v32 or v32.hasRelocatedInOverflow then
            return
        elseif v20 then
            v33 = v17[#v17]

            if not v33 then
                v33 = v21

                if v21 then
                    v33 = v17[1]
                end
            end
        else
            v33 = v21

            if v21 then
                v33 = v17[1]
            end
        end

        local X = v32.widget.AbsolutePosition.X
        local X2 = v33.widget.AbsolutePosition.X
        local v35 = t1.getWidth(v33)
        local v36 = v20 and X - Offset or X + t1.getWidth(v32) + Offset
        local v37 = if v20 then X2 + v35 else nil

        if v20 and v37 then
            X2 = v37
        end

        local v38

        if v20 then
            if v36 < X2 then
                if not v1 then
                    if not v2 then
                        v2 = true
                        task.delay(3, t1.updateBoundary, p11)
                    end

                    return
                end

                v32:align("Left")
                v38 = true
                v32.hasRelocatedInOverflow = true
            else
                v38 = false
            end
        elseif v21 and X2 < v36 then
            if not v1 or X2 < 0 then
                if not v2 then
                    v2 = true
                    task.delay(3, t1.updateBoundary, p11)
                end

                return
            end

            v32:align("Right")
            v38 = true
            v32.hasRelocatedInOverflow = true
        else
            v38 = false
        end

        if v38 then
            n4 += 1

            if n4 <= 4 then
                t1.updateAvailableIcons("Center")
                checkToShiftCentralIcon()
            end
        end
    end

    checkToShiftCentralIcon()

    local v42 = false
    local v43 = false
    local v44 = false
    local v45 = false

    if v23 then
        v42 = true
    else
        v45 = true
    end

    local Menu, v46, v47

    if v42 then
        Menu = v23:getInstance("Menu")
        v46 = X + X2

        if Menu then
            v43 = true
        else
            v47 = X2
            v45 = false
        end
    end

    v42 = false

    if v43 then
        if v28 then
            v42 = true
        else
            v47 = X2
            v45 = false
        end
    end

    v43 = false

    local X3, v48

    if v42 then
        X3 = v28.widget.AbsolutePosition.X
        v48 = t1.getWidth(v28)

        if v20 then
            v43 = true
        else
            v44 = true
        end
    end

    v42 = false

    local v49

    if v43 then
        local v50 = X3 - Offset

        if v50 then
            v49 = v50
            v42 = true
        else
            v44 = true
        end
    end

    v43 = false

    if v44 then
        v49 = X3 + v48 + Offset
        v42 = true
    end

    v44 = false

    if v42 then
        local Menu2 = v28:getInstance("Menu")

        if Menu.AbsoluteCanvasSize.X >= Menu2.AbsoluteCanvasSize.X then
            v43 = true
        else
            v44 = true
        end
    end

    v42 = false

    local v51

    if v44 then
        v51 = false
        v42 = true
    end

    v44 = false

    if v43 then
        v51 = true
        v42 = true
    end

    v43 = false

    local v52

    if v42 then
        v52 = X + X2 / 2

        if v20 then
            v43 = true
        else
            v44 = true
        end
    end

    v42 = false

    local v53

    if v43 then
        local v54 = v52 - Offset / 2

        if v54 then
            v53 = v54
            v42 = true
        else
            v44 = true
        end
    end

    v43 = false

    if v44 then
        v53 = v52 + Offset / 2
        v42 = true
    end

    v44 = false

    local v55

    if v42 then
        if v51 then
            v44 = true
        else
            v55 = v53
            v43 = true
        end
    end

    v42 = false

    if v44 then
        v55 = v49
        v43 = true
    end

    v44 = false

    if v43 then
        if v20 then
            v44 = true
        else
            v42 = true
        end
    end

    v43 = false

    local v56

    if v44 then
        local v57 = v55 - X

        if v57 then
            v56 = v57
            v43 = true
        else
            v42 = true
        end
    end

    if v42 then
        v56 = v46 - v55
        v43 = true
    end

    if v43 then
        v47 = v56
        v45 = false
    end

    if not v45 then
        local MaxWidth = Menu and Menu:GetAttribute("MaxWidth")
        local v58 = Utility.round(v47)

        if Menu and MaxWidth ~= v58 then
            Menu:SetAttribute("MaxWidth", v58)
        end
    end

    local v59 = t1.getRealXPositions(p11, v17)
    local v60 = #v17
    local v61 = false

    for i = v60, 1, -1 do
        local v62 = v17[i]
        local v63 = t1.getWidth(v62)
        local v64 = v59[v62.UID]

        if v20 and v29 <= v64 + v63 or v21 and v64 <= v29 then
            v61 = true
        end
    end

    for i = #v17, 1, -1 do
        local v65 = v17[i]

        if not t5[v65.UID] then
            local parentIconUID = if v61 then v65.parentIconUID else nil

            if not v61 or parentIconUID then
                if not v61 and v65.parentIconUID then
                    v65:leave()
                end
            else
                v65:joinMenu(v23)
            end
        end
    end

    if v23.isEnabled ~= v61 then
        v23:setEnabled(v61)
    end

    if v23.isEnabled and not v23.overflowAlreadyOpened then
        v23.overflowAlreadyOpened = true
        v23:select()
    end
end

return t1
