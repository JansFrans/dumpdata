-- https://lua.expert

local t1 = {}
local Utility = require(script.Parent.Parent.Utility)
local Default = require(script.Default)
local v1 = game:GetService("RunService"):IsStudio()
local t2 = {}
local t3 = {
    "Box",
    "Caption",
    "CaptionCorner",
    "Caret",
    "ClickRegion",
    "Contents",
    "ContentsList",
    "DropShadow",
    "Dropdown",
    "DropdownCorner",
    "DropdownList",
    "DropdownPadding",
    "DropdownScroller",
    "DropdownSpeed",
    "Header",
    "Hotkeys",
    "IconButton",
    "IconCorners",
    "IconGradient",
    "IconImage",
    "IconImageCorner",
    "IconImageRatio",
    "IconImageScale",
    "IconLabel",
    "IconLabelContainer",
    "IconOverlay",
    "IconSpot",
    "IconSpotGradient",
    "Indicator",
    "IndicatorButton",
    "Inset",
    "Key1",
    "LabelContent",
    "Layout",
    "Layout1",
    "Menu",
    "MenuGap",
    "MenuUIListLayout",
    "Notice",
    "NoticeLabel",
    "OverlayUICorner",
    "Padding",
    "PaddingCenter",
    "PaddingLeft",
    "PaddingRight",
    "Selection",
    "SelectionContainer",
    "SelectionGradient",
    "UICorner",
    "UIStroke",
    "Widget"
}
local t4 = {}

for _, v2 in pairs(Default) do
    t4[v2[2]] = true
end

local function warnOnce(p1, p2) -- line: 38
    -- upvalues: t2 (copy)
    if not t2[p1] then
        t2[p1] = true
        warn((("TopbarPlus: %* (this warning only shows in Studio)"):format(p2)))
    end
end

function t1.getThemeValue(p3, p4, p5, _) -- line: 49
    if not p3 then
        return nil
    end

    for _, v3 in pairs(p3) do
        local v4, v5, v6 = unpack(v3)

        if p4 == v4 and p5 == v5 then
            return v6
        end
    end

    return nil
end

function t1.getInstanceValue(p7, p8) -- line: 61
    local function v7() -- line: 62
        -- upvalues: p7 (copy), p8 (copy)
        return p7[p8]
    end

    local ok, result = pcall(v7)

    if not ok then
        result = p7:GetAttribute(p8)
    end

    return result
end

function t1.getRealInstance(p9) -- line: 71
    if p9:GetAttribute("IsAClippedClone") then
        local OriginalInstance = p9:FindFirstChild("OriginalInstance")

        if OriginalInstance then
            return OriginalInstance.Value
        end
    end
end

function t1.getClippedClone(p10) -- line: 82
    if p10:GetAttribute("HasAClippedClone") then
        local ClippedClone = p10:FindFirstChild("ClippedClone")

        if ClippedClone then
            return ClippedClone.Value
        end
    end
end

function t1.getActiveGroup(p11) -- line: 93
    local v8 = p11:getStateGroup()

    if p11.activeState ~= "Viewing" then
        return v8
    end

    local v9 = if p11.isSelected then "Selected" else "Deselected"
    local t5 = {}
    local t6 = {}

    for _, v10 in pairs(p11:getStateGroup(v9)) do
        table.insert(t5, v10)
        t6[v10[1] .. "-" .. v10[2]] = #t5
    end

    for _, v11 in pairs(v8) do
        local v12 = v11[4]

        if typeof(v12) == "string" and string.lower(v12) == "viewing" then
            local v13 = t6[v11[1] .. "-" .. v11[2]]

            if v13 then
                t5[v13] = v11
            else
                table.insert(t5, v11)
            end
        end
    end

    return t5
end

function t1.refresh(p12, p13, p14) -- line: 121
    -- upvalues: t1 (copy)
    if p14 then
        local v14 = t1.getActiveGroup(p12)
        local v15 = t1.getThemeValue(v14, p13.Name, p14) or t1.getInstanceValue(p13, p14)

        t1.apply(p12, p13, p14, v15, true)
    else
        local v16 = t1.getActiveGroup(p12)

        if v16 then
            local t7 = {
                [p13.Name] = p13
            }

            for _, descendant in pairs(p13:GetDescendants()) do
                local Collective = descendant:GetAttribute("Collective")

                if Collective then
                    t7[Collective] = descendant
                end

                t7[descendant.Name] = descendant
            end

            for _, v17 in pairs(v16) do
                local v18, v19, v20 = unpack(v17)
                local v21 = t7[v18]

                if v21 then
                    t1.apply(p12, v21.Name, v19, v20, true)
                end
            end
        end
    end
end

function t1.apply(p15, p16, p17, p18, p19) -- line: 154
    -- upvalues: t1 (copy), v1 (copy), t2 (copy), t4 (copy)
    if p15.isDestroyed then
        return
    end

    local v23, v24

    if typeof(p16) == "Instance" then
        v24 = { p16 }
        v23 = p16.Name
    else
        v24 = p15:getInstanceOrCollective(p16)
        v23 = p16
    end

    local v25 = v23 .. "-" .. p17
    local v26 = p15.customBehaviours[v25]

    for _, v27 in pairs(v24) do
        local v28 = t1.getClippedClone(v27)

        if v28 then
            table.insert(v24, v28)
        end
    end

    for _, v29 in pairs(v24) do
        if p17 ~= "Position" or not t1.getClippedClone(v29) then
            if p17 == "Size" then
                if not t1.getRealInstance(v29) then
                    local v30 = t1.getInstanceValue(v29, p17)

                    if p19 then
                        if v26 then
                            local v31 = v26(p18, v29, p17)

                            if v31 ~= nil then
                                p18 = v31
                            end
                        end

                        local v32 = if p17 ~= "Image" then p17 elseif typeof(p18) == "Content" then "ImageContent" else p17

                        local function v34() -- line: 202
                            -- upvalues: p18 (ref), v32 (copy), v29 (copy)
                            v29[v32] = p18
                        end

                        if not pcall(v34) then
                            local v35 = v29:GetAttribute(p17) ~= nil

                            v29:SetAttribute(p17, p18)

                            local IsAClippedClone = v29:GetAttribute("IsAClippedClone")

                            if v1 and not IsAClippedClone and not v35 and not t4[p17] then
                                local v37 = ("Property-%*-%*"):format(v23, p17)
                                local v39 = ("couldn't set %* on %* to %*. It's either not a real property or the value is the wrong type"):format(p17, v23, (tostring(p18)))

                                if not t2[v37] then
                                    t2[v37] = true
                                    warn((("TopbarPlus: %* (this warning only shows in Studio)"):format(v39)))
                                end
                            end
                        end
                    else
                        local v40 = p18

                        if v40 ~= v30 then
                            if v26 then
                                local v41 = v26(p18, v29, p17)

                                if v41 ~= nil then
                                    p18 = v41
                                end
                            end

                            local v42 = if p17 ~= "Image" then p17 elseif typeof(p18) == "Content" then "ImageContent" else p17

                            local function v44() -- line: 202
                                -- upvalues: p18 (ref), v29 (copy), v42 (copy)
                                v29[v42] = p18
                            end

                            if not pcall(v44) then
                                local v45 = v29:GetAttribute(p17) ~= nil

                                v29:SetAttribute(p17, p18)

                                local IsAClippedClone = v29:GetAttribute("IsAClippedClone")

                                if v1 and not IsAClippedClone and not v45 and not t4[p17] then
                                    local v47 = ("Property-%*-%*"):format(v23, p17)
                                    local v49 = ("couldn't set %* on %* to %*. It's either not a real property or the value is the wrong type"):format(p17, v23, (tostring(p18)))

                                    if not t2[v47] then
                                        t2[v47] = true
                                        warn((("TopbarPlus: %* (this warning only shows in Studio)"):format(v49)))
                                    end
                                end
                            end
                        end
                    end
                end
            else
                local v50 = t1.getInstanceValue(v29, p17)

                if p19 then
                    if v26 then
                        local v51 = v26(p18, v29, p17)

                        if v51 ~= nil then
                            p18 = v51
                        end
                    end

                    local v52 = if p17 ~= "Image" then p17 elseif typeof(p18) == "Content" then "ImageContent" else p17

                    local function v54() -- line: 202
                        -- upvalues: p18 (ref), v29 (copy), v52 (copy)
                        v29[v52] = p18
                    end

                    if not pcall(v54) then
                        local v55 = v29:GetAttribute(p17) ~= nil

                        v29:SetAttribute(p17, p18)

                        local IsAClippedClone = v29:GetAttribute("IsAClippedClone")

                        if v1 and not IsAClippedClone and not v55 and not t4[p17] then
                            local v57 = ("Property-%*-%*"):format(v23, p17)
                            local v59 = ("couldn't set %* on %* to %*. It's either not a real property or the value is the wrong type"):format(p17, v23, (tostring(p18)))

                            if not t2[v57] then
                                t2[v57] = true
                                warn((("TopbarPlus: %* (this warning only shows in Studio)"):format(v59)))
                            end
                        end
                    end
                else
                    local v60 = p18

                    if v60 ~= v50 then
                        if v26 then
                            local v61 = v26(p18, v29, p17)

                            if v61 ~= nil then
                                p18 = v61
                            end
                        end

                        local v62 = if p17 ~= "Image" then p17 elseif typeof(p18) == "Content" then "ImageContent" else p17

                        local function v64() -- line: 202
                            -- upvalues: p18 (ref), v29 (copy), v62 (copy)
                            v29[v62] = p18
                        end

                        if not pcall(v64) then
                            local v65 = v29:GetAttribute(p17) ~= nil

                            v29:SetAttribute(p17, p18)

                            local IsAClippedClone = v29:GetAttribute("IsAClippedClone")

                            if v1 and not IsAClippedClone and not v65 and not t4[p17] then
                                local v67 = ("Property-%*-%*"):format(v23, p17)
                                local v69 = ("couldn't set %* on %* to %*. It's either not a real property or the value is the wrong type"):format(p17, v23, (tostring(p18)))

                                if not t2[v67] then
                                    t2[v67] = true
                                    warn((("TopbarPlus: %* (this warning only shows in Studio)"):format(v69)))
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function t1.getModifications(p20) -- line: 221
    if typeof(p20[1]) == "table" then
        return p20
    end

    return { p20 }
end

function t1.checkModifications(p21, p22) -- line: 230
    -- upvalues: t1 (copy), v1 (copy), t2 (copy), t3 (copy)
    if v1 and typeof(p21) == "table" then
        for _, v71 in pairs(t1.getModifications(p21)) do
            local v72 = v71[1]

            if typeof(v72) == "string" and not table.find(t3, v72) then
                task.defer(function() -- line: 239
                    -- upvalues: p22 (copy), v72 (copy), t2 (copy)
                    if p22 and not p22.isDestroyed and #p22:getInstanceOrCollective(v72) > 0 then
                        return
                    end

                    local v73 = "Instance-" .. v72
                    local v74 = ("a theme names \"%*\" but no icon instance has that name, so it won't change anything"):format(v72)

                    if not t2[v73] then
                        t2[v73] = true
                        warn((("TopbarPlus: %* (this warning only shows in Studio)"):format(v74)))
                    end
                end)
            end
        end
    end
end

function t1.merge(p23, p24, p25) -- line: 249
    -- upvalues: t1 (copy)
    local v75, v76, v77, v78 = table.unpack(p24)
    local v79, v80, _, v81 = table.unpack(p23)

    if v75 ~= v79 or v76 ~= v80 or not t1.statesMatch(v78, v81) then
        local v82 = true

        return not v82
    end

    p23[3] = v77

    if p25 then
        p25(p23)
    end

    return not false
end

function t1.modify(p26, p27, p28) -- line: 262
    -- upvalues: t1 (copy), Utility (copy)
    t1.checkModifications(p27, p26)
    task.spawn(function() -- line: 271
        -- upvalues: p26 (copy), p27 (ref), p28 (ref), t1 (copy), Utility (copy)
        p28 = p28 or Utility.generateUID()
        p27 = t1.getModifications(p27)

        for _, v83 in pairs(p27) do
            local v84, v85, v86, v87 = table.unpack(v83)

            if v87 == nil then
                t1.modify(p26, { v84, v85, v86, "Selected" }, p28)
                t1.modify(p26, { v84, v85, v86, "Viewing" }, p28)
            end

            local v88 = Utility.formatStateName(v87 or "Deselected")
            local v89 = p26:getStateGroup(v88)

            local function updateRecord() -- line: 288
                -- upvalues: v83 (copy), v84 (copy), v85 (copy), v86 (copy), v88 (copy), v89 (copy), p26 (copy), p28 (ref), t1 (copy)
                for _, v90 in pairs(v89) do
                    if t1.merge(v90, v83, function(p29) -- line: 290
                        -- upvalues: v84 (copy), v85 (copy), v86 (copy), v88 (copy), p26 (copy), p28 (ref), t1 (copy)
                        p29[5] = p28

                        if v88 == p26.activeState then
                            t1.apply(p26, v84, v85, v86)
                        end
                    end) then
                        return
                    end
                end

                table.insert(v89, {
                    v84,
                    v85,
                    v86,
                    v88,
                    p28
                })

                if v88 == p26.activeState then
                    t1.apply(p26, v84, v85, v86)
                end
            end

            updateRecord()
        end
    end)

    return p28
end

function t1.remove(p30, p31) -- line: 308
    -- upvalues: t1 (copy)
    for _, v91 in pairs(p30.appearance) do
        for i = #v91, 1, -1 do
            if v91[i][5] == p31 then
                table.remove(v91, i)
            end
        end
    end

    t1.rebuild(p30)
end

function t1.removeWith(p32, p33, p34, p35) -- line: 321
    -- upvalues: t1 (copy)
    for v92, v93 in pairs(p32.appearance) do
        if p35 == v92 or not p35 then
            for i = #v93, 1, -1 do
                local v94 = v93[i]
                local v95 = v94[1]
                local v96 = v94[2]

                if v95 == p33 and v96 == p34 then
                    table.remove(v93, i)
                end
            end
        end
    end

    t1.rebuild(p32)
end

function t1.change(p36) -- line: 337
    -- upvalues: t1 (copy)
    local v97 = t1.getActiveGroup(p36)

    for _, v98 in pairs(v97) do
        local v99, v100, v101 = unpack(v98)

        t1.apply(p36, v99, v100, v101)
    end
end

function t1.set(p37, p38) -- line: 347
    -- upvalues: t1 (copy), Default (copy)
    local themesJanitor = p37.themesJanitor

    themesJanitor:clean()
    themesJanitor:add(p37.stateChanged:Connect(function() -- line: 353
        -- upvalues: p37 (copy), t1 (copy)
        t1.change(p37)
    end))

    local v102 = if typeof(p38) == "Instance" and p38:IsA("ModuleScript") then require(p38) else p38

    if v102 ~= Default then
        t1.checkModifications(v102, p37)
    end

    p37.appliedTheme = v102
    t1.rebuild(p37)
end

function t1.statesMatch(p39, p40) -- line: 367
    if (p39 and string.lower(p39)) == (p40 and string.lower(p40)) then
        return true
    end

    return not p39 or not p40
end

function t1.rebuild(p41) -- line: 374
    -- upvalues: t1 (copy), Utility (copy), Default (copy)
    local appliedTheme = p41.appliedTheme
    local t9 = { "Deselected", "Selected", "Viewing" }

    local function generateTheme() -- line: 381
        -- upvalues: p41 (copy), appliedTheme (copy), t9 (copy), t1 (copy), Utility (copy), Default (copy)
        for _, v103 in pairs(t9) do
            local t10 = {}

            local function updateDetails(p42, p43) -- line: 387
                -- upvalues: t10 (copy), t1 (copy), Utility (copy)
                if not p42 then
                    return
                end

                for _, v104 in pairs(p42) do
                    local v105 = v104[5]
                    local v106 = v104[4]

                    if t1.statesMatch(p43, v106) then
                        local v107 = v104[1] .. "-" .. v104[2]
                        local v108 = Utility.copyTable(v104)

                        v108[5] = v105
                        t10[v107] = v108
                    end
                end
            end

            if v103 == "Selected" then
                updateDetails(Default, "Deselected")
            end

            updateDetails(Default, "Empty")
            updateDetails(Default, v103)

            if appliedTheme ~= Default then
                if v103 == "Selected" then
                    updateDetails(appliedTheme, "Deselected")
                end

                updateDetails(appliedTheme, v103)
            end

            local t11 = {}
            local v109 = p41.appearance[v103]

            if v109 then
                for _, v110 in pairs(v109) do
                    local v111 = v110[5]

                    if v111 ~= nil then
                        table.insert(t11, {
                            v110[1],
                            v110[2],
                            v110[3],
                            v103,
                            v111
                        })
                    end
                end
            end

            updateDetails(t11, v103)

            local t13 = {}

            for _, v112 in pairs(t10) do
                table.insert(t13, v112)
            end

            p41.appearance[v103] = t13
        end

        t1.change(p41)
    end

    generateTheme()
end

return t1
