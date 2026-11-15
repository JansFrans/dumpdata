-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local InputObjects = require(UI.Config.InputObjects)

require(UI.Components.Pressable)

local ConfirmBar = require(UI.Components.ConfirmBar)
local Children = Fusion.Children
local UserInputService = game:GetService("UserInputService")
local v1 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local areValuesEqual = require(Modules.DataUtil.areValuesEqual)

return function(p1, p2) -- line: 66
    -- upvalues: Modules (copy), Fusion (copy), Theme (copy), InputObjects (copy), ConfirmBar (copy), Children (copy), areValuesEqual (copy), v1 (copy)
    local clientUser = require(Modules.References.clientUser)
    local v2
    local v3 = p2.stateSource or "perm"
    local v4 = if typeof(v3) == "string" then clientUser[v3] else v3
    local v5 = false

    table.insert(p1, function() -- line: 75
        -- upvalues: v5 (ref)
        v5 = true
    end)

    local settingsData, v7 = p2.settingsData, p2.pathPrefix

    local function fullPath(p3) -- line: 80
        -- upvalues: v7 (ref)
        if not v7 then
            return p3
        end

        local v8 = table.clone(v7)

        for _, v9 in p3 do
            table.insert(v8, v9)
        end

        return v8
    end

    local t1 = {}
    local v10 = p1:Value(false)
    local v11 = false
    local t2 = {}
    local t3 = {}
    local v12 = false
    local v13 = false
    local t4 = {}
    local t5 = {}
    local t6 = {}
    local t7 = {}
    local t8 = {}
    local v14 = nil
    local t9 = {}

    local function fetchDefaults() -- line: 107
        -- upvalues: p2 (copy)
        if p2.getDefaults then
            return p2.getDefaults()
        end

        return nil
    end

    local v15, v16, Frame

    for _, v17 in settingsData do
        for _, v18 in v17.objects do
            v16 = v18.settingPath

            if v7 then
                v15 = table.clone(v7)

                for _, v19 in v16 do
                    table.insert(v15, v19)
                end
            else
                v15 = v16
            end

            v16, v15 = p1:Fuse(v3, v15)
            Frame = Fusion.peek(v16)

            if Frame == nil and v18.defaultFromEveryone then
                Frame = clientUser.everyone
                Frame = Frame:get(table.unpack(v18.defaultFromEveryone))
            end

            if Frame == nil and v18.defaultFromFunc then
                Frame = v18.defaultFromFunc()
            end

            t6[v18.title] = p1:Value(Frame)
            t2[v18.title] = v16
            t3[v18.title] = v15
            t8[v18.title] = v18.settingPath
        end
    end

    local t10 = {}

    table.insert(t10, p1:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        VerticalFlex = Enum.UIFlexAlignment.None,
        Padding = UDim.new(0, 18),
        SortOrder = Enum.SortOrder.LayoutOrder
    }))

    local UIListLayout2, objects, v20

    for v21, v22 in settingsData do
        local t12 = {}

        objects = p1:New("UIListLayout")
        v20 = {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder
        }
        table.insert(t12, objects(v20))
        objects = p1:New("TextLabel")
        v20 = {
            Name = "Heading",
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            FontFace = p1:Computed(function(p4) -- line: 154
                -- upvalues: Theme (copy)
                return Font.new(p4(Theme.Font.Heading), p4(Theme.FontWeight.Heading))
            end),
            Text = v22.heading,
            TextColor3 = Theme.Color.BaseContent,
            TextSize = Theme.TextSize.Title,
            TextXAlignment = Enum.TextXAlignment.Left
        }
        table.insert(t12, objects(v20))
        objects = p1:New("Frame")
        v20 = {
            Name = "DividerWrap",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Size = UDim2.new(1, 0, 0, 0),
            [Children] = {
                p1:New("UIPadding")({
                    PaddingTop = UDim.new(0, 6),
                    PaddingBottom = UDim.new(0, 4)
                }),
                p1:New("Frame")({
                    Name = "Divider",
                    BackgroundColor3 = Theme.Color.NeutralContent,
                    Size = UDim2.new(1, 0, 0, 1)
                })
            }
        }
        table.insert(t12, objects(v20))

        local v23 = {}
        local t13 = {}

        UIListLayout2 = p1:New("UIListLayout")
        v16 = {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        }
        table.insert(v23, UIListLayout2(v16))
        UIListLayout2 = p1:New("UIPadding")
        v16 = {
            Name = "UIPadding",
            PaddingBottom = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 4)
        }
        table.insert(v23, UIListLayout2(v16))

        for v24, v25 in v22.objects do
            local v26 = t2[v25.title]
            local v27 = t6[v25.title]
            local v28 = true
            local v29 = nil
            local v30 = false

            p1:Observer(v26):onChange(function() -- line: 208
                -- upvalues: v5 (ref), v7 (ref), v11 (ref), v13 (ref), t4 (copy), t9 (copy), v25 (copy), v26 (copy), v27 (copy), v29 (ref), v30 (ref), Fusion (copy), areValuesEqual (copy)
                if v5 or v11 or v13 then
                    return
                end

                local concat = table.concat
                local settingPath = v25.settingPath
                local v32 = settingPath

                if v7 then
                    v32 = table.clone(v7)

                    for _, v33 in settingPath do
                        table.insert(v32, v33)
                    end
                end

                local v34 = concat(v32, ".")
                local v35 = t9[v25.title]

                if not v35 or Fusion.peek(v35.locked) ~= true then
                    local v36 = Fusion.peek(v26)
                    local v37 = Fusion.peek(v27)
                    local v38 = t4[v34]

                    if v38 then
                        if not areValuesEqual(v36, v38.intendedValue) then
                            return
                        end

                        t4[v34] = nil
                    end

                    if v36 ~= v37 then
                        task.defer(function() -- line: 229
                            -- upvalues: v36 (copy), v5 (ref), v13 (ref), v27 (copy), v29 (ref), v30 (ref)
                            if v5 then
                                return
                            end

                            v29 = v36
                            v30 = true
                            v13 = true
                            v27:set(v36)
                            v13 = false
                        end)
                    end
                end
            end)

            local v39

            if v25.defaultFromEveryone then
                local v40 = p1:Fuse("everyone", v25.defaultFromEveryone)

                v39 = p1:Observer(v40)
                v39:onChange(function() -- line: 244
                    -- upvalues: v5 (ref), v7 (ref), t1 (copy), v11 (ref), v13 (ref), v25 (copy), v26 (copy), v27 (copy), v29 (ref), v30 (ref), v40 (copy), Fusion (copy)
                    if v5 or v11 or v13 then
                        return
                    end

                    local concat = table.concat
                    local settingPath = v25.settingPath
                    local v41 = settingPath

                    if v7 then
                        v41 = table.clone(v7)

                        for _, v42 in settingPath do
                            table.insert(v41, v42)
                        end
                    end

                    local v43 = concat(v41, ".")

                    if Fusion.peek(v26) == nil and not t1[v43] then
                        local v44 = Fusion.peek(v40)

                        if v44 ~= nil and v44 ~= Fusion.peek(v27) then
                            task.defer(function() -- line: 253
                                -- upvalues: v43 (copy), v44 (copy), v5 (ref), t1 (copy), v13 (ref), v26 (copy), v27 (copy), v29 (ref), v30 (ref), Fusion (copy)
                                if v5 or Fusion.peek(v26) ~= nil or t1[v43] then
                                    return
                                end

                                v29 = v44
                                v30 = true
                                v13 = true
                                v27:set(v44)
                                v13 = false
                            end)
                        end
                    end
                end)
            end

            v39 = {
                heading = v22.heading,
                title = v25.title,
                inputValue = v27
            }

            local settingPath = v25.settingPath
            local bindSetting = settingPath

            if v7 then
                bindSetting = table.clone(v7)

                for _, v45 in settingPath do
                    table.insert(bindSetting, v45)
                end
            end

            v39.settingPath = bindSetting
            v39.onChanged = v25.onChanged
            table.insert(t5, v39)

            local settingPath2, v46

            if v25.updateThemeValues then
                for _, v47 in v25.updateThemeValues do
                    bindSetting = Theme.bindSetting

                    local v48 = v47[1]
                    local v49 = v47[2]

                    settingPath2 = v25.settingPath

                    if v7 then
                        v46 = table.clone(v7)

                        for _, v50 in settingPath2 do
                            table.insert(v46, v50)
                        end
                    else
                        v46 = settingPath2
                    end

                    bindSetting(v48, v49, v46)
                end
            end

            task.defer(function() -- line: 280
                -- upvalues: v28 (ref)
                v28 = false
            end)
            p1:Observer(v27):onChange(function() -- line: 284
                -- upvalues: clientUser (copy), v5 (ref), v7 (ref), t1 (copy), v10 (copy), v11 (ref), v12 (ref), v13 (ref), v22 (copy), v25 (copy), v26 (copy), v27 (copy), v28 (ref), v29 (ref), v30 (ref), v4 (copy), Fusion (copy), areValuesEqual (copy)
                if v28 or v12 or v11 or v13 or v5 then
                    return
                end

                local settingPath = v25.settingPath
                local v51 = settingPath

                if v7 then
                    v51 = table.clone(v7)

                    for _, v52 in settingPath do
                        table.insert(v51, v52)
                    end
                end

                local concat = table.concat
                local settingPath2 = v25.settingPath
                local v53 = settingPath2

                if v7 then
                    v53 = table.clone(v7)

                    for _, v54 in settingPath2 do
                        table.insert(v53, v54)
                    end
                end

                local v55 = concat(v53, ".")
                local v56 = Fusion.peek(v27)

                if v30 and areValuesEqual(v56, v29) then
                    v30 = false
                    v29 = nil

                    return
                end

                v30 = false
                v29 = nil

                if v25.inputType ~= "TextInput" and v25.verifier then
                    local v58, v59 = v25.verifier(v25.inputObject or v25, v56)

                    if not v58 then
                        task.defer(function() -- line: 302
                            -- upvalues: v5 (ref), v26 (copy), v27 (copy), Fusion (copy)
                            if v5 then
                                return
                            end

                            v27:set(Fusion.peek(v26))
                        end)

                        return
                    end

                    if not areValuesEqual(v59, v56) then
                        task.defer(function() -- line: 310
                            -- upvalues: v59 (copy), v5 (ref), v27 (copy)
                            if not v5 then
                                v27:set(v59)
                            end
                        end)

                        return
                    end
                end

                if t1[v55] then
                    t1[v55].intendedValue = v56
                else
                    local v60 = Fusion.peek(v26)

                    if v60 == nil and v25.defaultFromEveryone then
                        v60 = clientUser.everyone:get(table.unpack(v25.defaultFromEveryone))
                    end

                    if v60 == nil and v25.defaultFromFunc then
                        v60 = v25.defaultFromFunc()
                    end

                    if areValuesEqual(v56, v60) then
                        return
                    end

                    t1[v55] = {
                        previousValue = v60,
                        intendedValue = v56,
                        settingPath = v51,
                        heading = v22.heading,
                        title = v25.title,
                        inputValue = v27,
                        onChanged = v25.onChanged
                    }
                end

                v4:set(v51, v56)

                if v25.onChanged then
                    v25.onChanged(v56)
                end

                if t1[v55] and areValuesEqual(v56, t1[v55].previousValue) then
                    t1[v55] = nil
                end

                v10:set(next(t1) ~= nil)
            end)

            local v61 = if p2.hiddenByTitle then p2.hiddenByTitle[v25.title] else nil
            local v31 = nil

            if v25.hidden == true then
                v31 = false
            elseif v61 ~= nil then
                v31 = p1:Computed(function(p6) -- line: 360
                    -- upvalues: v61 (copy)
                    return p6(v61) ~= true
                end)
            elseif v25.lockSetting then
                v39 = v25.lockSetting

                local v62 = Theme[v39[1]]

                if v62 then
                    local v63 = v62[v39[2]]

                    if v63 then
                        v31 = p1:Computed(function(p5) -- line: 369
                            -- upvalues: v63 (copy)
                            return p5(v63) ~= true
                        end)
                    end
                end
            end

            settingPath = v31 == nil or v31
            table.insert(t13, settingPath)

            local v64 = nil

            if p2.lockRule then
                v39 = p2.lockRule({
                    obj = v25,
                    heading = v22.heading,
                    valueByTitle = t6
                })
                v64 = v39
            else
                v39 = nil
            end

            local v66 = if p2.softLockRule then p2.softLockRule({
                obj = v25,
                heading = v22.heading,
                valueByTitle = t6
            }) else nil
            local lockedDisplayValue = v25.lockedDisplayValue
            local v67 = nil

            local function staticLockedDisplayValue() -- line: 397
                -- upvalues: v25 (copy), lockedDisplayValue (copy)
                if lockedDisplayValue == nil then
                    if v25.inputType == "Toggle" then
                        return true
                    end

                    if not (v25.inputType ~= "ItemSelector" or v25.inputObject and v25.inputObject.limitPickerToOneItem) then
                        local v68 = v25.inputObject and v25.inputObject.pickerGetter

                        if typeof(v68) == "function" then
                            local ok, result = pcall(v68)

                            if ok and typeof(result) == "table" then
                                local t14 = {}

                                for _, v69 in result do
                                    if typeof(v69) == "table" and not v69.hiddenFromPicker and v69.rawValue ~= nil then
                                        table.insert(t14, v69.rawValue)
                                    end
                                end

                                return t14
                            end
                        end
                    end

                    return nil
                end

                if lockedDisplayValue == "none" then
                    return nil
                end

                if v25.inputType ~= "ItemSelector" or typeof(lockedDisplayValue) == "table" then
                    return lockedDisplayValue
                end

                return { lockedDisplayValue }
            end

            if typeof(lockedDisplayValue) == "function" then
                v67 = p1:Computed(function(p7) -- line: 426
                    -- upvalues: t6 (copy), lockedDisplayValue (copy)
                    local t15 = {
                        use = p7,
                        valueByTitle = t6
                    }
                    local ok, result = pcall(lockedDisplayValue, t15)

                    return if ok then result else nil
                end)
            end

            local function computeLockedDisplayValue() -- line: 432
                -- upvalues: v67 (ref), staticLockedDisplayValue (copy), Fusion (copy)
                if v67 then
                    return Fusion.peek(v67)
                end

                return (staticLockedDisplayValue())
            end

            local v70

            if v39 then
                settingPath2 = if v67 then Fusion.peek(v67) else staticLockedDisplayValue()
                v70 = settingPath2 ~= nil
            else
                v70 = v39
            end

            if v70 then
                t9[v25.title] = {
                    locked = v39,
                    compute = computeLockedDisplayValue
                }

                local function reapply() -- line: 441
                    -- upvalues: v5 (ref), v11 (ref), v13 (ref), v27 (copy), v64 (ref), v67 (ref), staticLockedDisplayValue (copy), Fusion (copy), areValuesEqual (copy)
                    if v5 or v13 or Fusion.peek(v64) ~= true then
                        return
                    end

                    local v71 = v11

                    v11 = true

                    local v72 = if v67 then Fusion.peek(v67) else staticLockedDisplayValue()

                    if v72 ~= nil and not areValuesEqual(Fusion.peek(v27), v72) then
                        v27:set(v72)
                    end

                    v11 = v71
                end

                if v67 then
                    p1:Observer(v67):onChange(reapply)
                end

                v46 = p1:Observer(v64)
                v46:onChange(function() -- line: 455
                    -- upvalues: clientUser (copy), v5 (ref), v11 (ref), v13 (ref), v14 (ref), v25 (copy), v26 (copy), v27 (copy), v64 (ref), v67 (ref), staticLockedDisplayValue (copy), Fusion (copy), areValuesEqual (copy)
                    local v73 = false
                    local v74 = false
                    local v75 = false
                    local v76 = false
                    local v77 = false

                    if v5 then
                        v77 = true
                    else
                        v73 = true
                    end

                    if v73 then
                        if v13 then
                            v77 = true
                        else
                            v74 = true
                        end
                    end

                    v73 = false

                    local v78

                    if v74 then
                        v78 = v11
                        v11 = true

                        if Fusion.peek(v64) == true then
                            v75 = true
                        else
                            v73 = true
                        end
                    end

                    v74 = false

                    if v73 then
                        if v14 then
                            v74 = true
                        else
                            v76 = true
                        end
                    end

                    v73 = false

                    local v79

                    if v74 then
                        v79 = v14[v25.title]
                        v76 = true
                    end

                    v74 = false

                    local v81

                    if v76 then
                        if v79 ~= nil then
                            v81 = v79
                            v73 = true
                        else
                            v74 = true
                        end
                    end

                    v76 = false

                    if v74 then
                        v81 = Fusion.peek(v26)
                        v73 = true
                    end

                    v74 = false

                    local v82

                    if v73 then
                        if v81 ~= nil then
                            v82 = v81
                            v76 = true
                        else
                            v74 = true
                        end
                    end

                    v73 = false

                    if v74 then
                        if v25.defaultFromEveryone then
                            v73 = true
                        else
                            v82 = v81
                            v76 = true
                        end
                    end

                    v74 = false

                    if v73 then
                        v82 = clientUser.everyone:get(table.unpack(v25.defaultFromEveryone))
                        v76 = true
                    end

                    v73 = false

                    local v83

                    if v76 then
                        if v82 ~= nil then
                            v83 = v82
                            v74 = true
                        else
                            v73 = true
                        end
                    end

                    v76 = false

                    if v73 then
                        if v25.defaultFromFunc then
                            v76 = true
                        else
                            v83 = v82
                            v74 = true
                        end
                    end

                    if v76 then
                        v83 = v25.defaultFromFunc()
                        v74 = true
                    end

                    v76 = false

                    if v74 then
                        if areValuesEqual(Fusion.peek(v27), v83) then
                            v77 = false
                        else
                            v76 = true
                        end
                    end

                    v74 = false

                    if v76 then
                        v77 = false
                        v27:set(v83)
                    end

                    v76 = false

                    if v75 then
                        if v67 then
                            v74 = true
                        else
                            v76 = true
                        end
                    end

                    v75 = false

                    local v84

                    if v76 then
                        v84 = staticLockedDisplayValue()
                        v75 = true
                    end

                    if v74 then
                        v84 = Fusion.peek(v67)
                        v75 = true
                    end

                    v74 = false

                    if v75 then
                        if v84 ~= nil then
                            v74 = true
                        else
                            v77 = false
                        end
                    end

                    v75 = false

                    if v74 then
                        if areValuesEqual(Fusion.peek(v27), v84) then
                            v77 = false
                        else
                            v75 = true
                        end
                    end

                    if v75 then
                        v77 = false
                        v27:set(v84)
                    end

                    if not v77 then
                        v11 = v78
                    end
                end)

                if Fusion.peek(v64) == true then
                    local v85 = v11

                    v11 = true
                    v46 = if v67 then Fusion.peek(v67) else staticLockedDisplayValue()

                    if v46 ~= nil and not areValuesEqual(Fusion.peek(v27), v46) then
                        v27:set(v46)
                    end

                    v11 = v85
                end
            end

            local v86 = v25.immutable == true
            local Frame = nil
            local Frame2 = if v64 and v66 then p1:Computed(function(p8) -- line: 498
                -- upvalues: v64 (ref), v66 (copy)
                if p8(v64) == true then
                    return true
                end

                return p8(v66) == true
            end) else v64 or v66 or nil

            if v86 then
                if Frame2 then
                    local Frame = Frame2

                    Frame2 = p1:Computed(function(p9) -- line: 511
                        -- upvalues: Frame (copy)
                        if p9(Frame) == true then
                        end

                        return true
                    end)
                else
                    Frame2 = p1:Computed(function() -- line: 515
                        return true
                    end)
                end

                Frame = Frame2
            elseif Frame2 then
                Frame = Frame2
            else
                Frame2 = nil
            end

            if Frame2 then
                settingPath2 = p1:Computed(function(p10) -- line: 522
                    -- upvalues: Frame (ref)
                    return not p10(Frame)
                end)
            else
                settingPath2 = true
            end

            local v87 = p1:New("Frame")({
                BackgroundTransparency = 1,
                Name = "Setting_" .. (v25.title or tostring(v24)),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = v24,
                Size = UDim2.fromScale(1, 0),
                Visible = v31,
                Interactable = settingPath2
            })

            table.insert(v23, v87)
            table.insert(t7, function() -- line: 538
                -- upvalues: p1 (copy), p2 (copy), v5 (ref), v25 (copy), v27 (copy), v64 (ref), Frame (ref), v87 (copy), v86 (copy), Theme (copy), InputObjects (copy), Children (copy)
                if v5 then
                    return
                end

                local t17 = {
                    inputType = v25.inputType,
                    title = v25.label or v25.title,
                    value = v27,
                    labelSize = UDim2.new(0, 105, 0, 0),
                    slidersHeight = if v25.inputType == "ColorPicker" then 115 else nil
                }

                if v25.inputObject then
                    for v89, v90 in v25.inputObject do
                        t17[v89] = v90
                    end
                end

                if p2.objectOverrides then
                    local v91 = p2.objectOverrides[v25.title]

                    if typeof(v91) == "table" then
                        for v92, v93 in v91 do
                            t17[v92] = v93
                        end
                    end
                end

                if v25.inputType == "ItemSelector" then
                    t17.onOpen = p2.onItemSelectorOpen
                end

                if v25.inputType == "TextInput" and v25.verifier then
                    t17.verifier = function(p11) -- line: 567
                        -- upvalues: v25 (copy), v27 (copy)
                        local v94, v95 = v25.verifier(v25.inputObject or v25, p11)

                        if v94 then
                            v27:set(v95)
                        end

                        return v94, v95
                    end
                end

                local v96 = InputObjects.items[v25.inputType]
                local v97 = if v96 then v96(p1, t17) else nil
                local v98 = typeof(v25.description) == "string" and v25.description ~= ""

                p1:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Vertical,
                    HorizontalFlex = Enum.UIFlexAlignment.None,
                    Padding = if v98 then UDim.new(0, 0) else UDim.new(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }).Parent = v87

                if v98 then
                    p1:New("UIPadding")({
                        PaddingBottom = UDim.new(0, 6)
                    }).Parent = v87

                    local n1 = 0

                    if Frame then
                        if v86 then
                            if v64 then
                                n1 = p1:Computed(function(p12) -- line: 597
                                    -- upvalues: Frame (ref)
                                    if p12(Frame) then
                                        return 0.65
                                    end

                                    return 0
                                end)
                            end
                        else
                            n1 = p1:Computed(function(p13) -- line: 597
                                -- upvalues: Frame (ref)
                                if p13(Frame) then
                                    return 0.65
                                end

                                return 0
                            end)
                        end
                    end

                    local v99 = v25.inputType == "Toggle"

                    p1:New("TextLabel")({
                        Name = "Description",
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        FontFace = p1:Computed(function(p14) -- line: 606
                            -- upvalues: Theme (copy)
                            return Font.new(p14(Theme.Font.Body), p14(Theme.FontWeight.Light))
                        end),
                        LayoutOrder = 3,
                        RichText = true,
                        Size = if v99 then UDim2.fromScale(0.75, 0) else UDim2.fromScale(1, 0),
                        Text = v25.description,
                        TextColor3 = Theme.Color.NeutralContentDark,
                        TextSize = 17,
                        TextTransparency = n1,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        [Children] = if v99 then nil else {
                            p1:New("UIPadding")({
                                PaddingTop = UDim.new(0, 6)
                            })
                        }
                    }).Parent = v87
                end

                if not v97 then
                    return
                end

                local t21 = {
                    v97
                }

                if Frame then
                    local v100 = v86
                    local Frame2, t22

                    if v100 then
                        v100 = not v64
                        Frame2 = p1:New("Frame")
                        t22 = {
                            Name = "LockOverlay",
                            ZIndex = 10
                        }
                        t22.BackgroundColor3 = Theme.Color.Base
                        t22.BackgroundTransparency = p1:Computed(function(p15) -- line: 634
                            -- upvalues: Frame (ref)
                            if p15(Frame) then
                                return 0.35
                            end

                            return 1
                        end)

                        if v100 then
                            t22.Position = UDim2.fromOffset(111, 0)
                            t22.Size = UDim2.new(1, -111, 1, 0)
                        else
                            t22.Position = UDim2.fromScale(0, 0)
                            t22.Size = UDim2.fromScale(1, 1)
                        end
                    else
                        Frame2 = p1:New("Frame")
                        t22 = {
                            Name = "LockOverlay",
                            ZIndex = 10
                        }
                        t22.BackgroundColor3 = Theme.Color.Base
                        t22.BackgroundTransparency = p1:Computed(function(p16) -- line: 634
                            -- upvalues: Frame (ref)
                            if p16(Frame) then
                                return 0.35
                            end

                            return 1
                        end)
                        t22.Position = UDim2.fromScale(0, 0)
                        t22.Size = UDim2.fromScale(1, 1)
                    end

                    table.insert(t21, Frame2(t22))
                end

                p1:New("Frame")({
                    Name = "InputWrapper",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    Size = UDim2.fromScale(1, 0),
                    [Children] = t21
                }).Parent = v87
            end)
        end

        UIListLayout2 = p1:New("Frame")
        v16 = {
            Name = "Rows",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Size = UDim2.fromScale(1, 0),
            [Children] = v23
        }

        local v101

        table.insert(t12, UIListLayout2(v16))

        if #t13 == 0 then
            v101 = false
            objects = false
        else
            v23 = false

            for _, v102 in t13 do
                if v102 == nil or v102 == true then
                    v23 = true
                    break
                end

                v23 = false
            end

            if v23 then
                v101 = true
                objects = true
            else
                objects = p1:Computed(function(p17) -- line: 678
                    -- upvalues: t13 (copy)
                    for _, v104 in t13 do
                        if v104 ~= false and p17(v104) == true then
                            return true
                        end
                    end

                    return false
                end)
                v101 = objects
            end
        end

        if objects == false then
            v20 = UDim2.new()
            UIListLayout2 = Enum.AutomaticSize.None
        elseif objects == true then
            v20 = UDim2.fromScale(1, 0)
            UIListLayout2 = Enum.AutomaticSize.Y
        else
            v20 = p1:Computed(function(p18) -- line: 698
                -- upvalues: v101 (ref)
                if p18(v101) then
                    return (UDim2.fromScale(1, 0))
                end

                return (UDim2.new())
            end)
            UIListLayout2 = p1:Computed(function(p19) -- line: 701
                -- upvalues: v101 (ref)
                if p19(v101) then
                    return Enum.AutomaticSize.Y
                end

                return Enum.AutomaticSize.None
            end)
        end

        Frame = p1:New("Frame")
        table.insert(t10, Frame({
            Name = "Category_" .. tostring(v21),
            AutomaticSize = UIListLayout2,
            BackgroundTransparency = 1,
            LayoutOrder = v21,
            Size = v20,
            Visible = v101,
            [Children] = t12
        }))
    end

    local function requestRestoreDefaults() -- line: 717
        -- upvalues: p2 (copy), v5 (ref), t5 (copy), Fusion (copy), areValuesEqual (copy)
        task.spawn(function() -- line: 718
            -- upvalues: p2 (copy), v5 (ref), t5 (copy), Fusion (copy), areValuesEqual (copy)
            local v105 = if p2.getDefaults then p2.getDefaults() else nil

            if v105 and not v5 then
                for _, v106 in t5 do
                    if v106.title ~= "rank" and v106.title ~= "key" then
                        local v107 = v105[v106.heading]
                        local v108 = if v107 then v107[v106.title] else v105[v106.title]

                        if v108 ~= nil then
                            local v109 = Fusion.peek(v106.inputValue)

                            if typeof(v109) == "table" and typeof(v108) ~= "table" then
                                v108 = { v108 }
                            end

                            if not areValuesEqual(v109, v108) then
                                v106.inputValue:set(v108)
                            end
                        end
                    end
                end
            end
        end)
    end

    task.spawn(function() -- line: 744
        -- upvalues: v5 (ref), t7 (copy)
        local n2 = 0

        while true do
            if n2 < #t7 then
                if v5 then
                    break
                end

                local v112 = math.min(n2 + 2, #t7)

                for i = n2 + 1, v112 do
                    t7[i]()
                end

                if v112 < #t7 then
                    task.wait()
                end

                n2 = v112
                continue
            end

            return
        end
    end)

    local function confirmChanges() -- line: 759
        -- upvalues: p2 (copy), t1 (copy), v10 (copy), v12 (ref), t4 (copy), v4 (copy), Modules (copy)
        if p2.onChangeRemote then
            local changeRemoteArgsBuilder = p2.changeRemoteArgsBuilder or function(p20) -- line: 765
                return p20.heading, p20.title, p20.intendedValue
            end

            for v113, v114 in t1 do
                t4[v113] = {
                    intendedValue = v114.intendedValue
                }
            end

            local t24 = {}

            for v115, v116 in t1 do
                task.spawn(function() -- line: 774
                    -- upvalues: changeRemoteArgsBuilder (copy), t24 (copy), v116 (copy), v115 (copy), p2 (copy), v12 (ref), t4 (copy), v4 (copy), Modules (copy)
                    local v117, v118, v119 = p2.onChangeRemote:invokeServerAsync(changeRemoteArgsBuilder(v116))

                    if v117 then
                        return
                    end

                    t4[v115] = nil
                    v12 = true
                    v116.inputValue:set(v116.previousValue)
                    v4:set(v116.settingPath, v116.previousValue)

                    if v116.onChanged then
                        v116.onChanged(v116.previousValue)
                    end

                    v12 = false

                    local v121 = tostring(v118 or "Failed to save setting")

                    if t24[v121] then
                        return
                    end

                    t24[v121] = true

                    local Prompt = require(Modules.Prompt);

                    (if v119 == "error" then Prompt.error else Prompt.warn)(v121)
                end)
            end
        end

        table.clear(t1)
        v10:set(false)
    end

    local function undoChanges() -- line: 801
        -- upvalues: t1 (copy), v10 (copy), v12 (ref), v4 (copy)
        v12 = true

        for _, v122 in t1 do
            v122.inputValue:set(v122.previousValue)
            v4:set(v122.settingPath, v122.previousValue)

            if v122.onChanged then
                v122.onChanged(v122.previousValue)
            end
        end

        table.clear(t1)
        v10:set(false)
        v12 = false
    end

    if p2.undoRef then
        p2.undoRef:set(undoChanges)
    end

    local function applyLockOverrides() -- line: 819
        -- upvalues: t6 (copy), t9 (copy), Fusion (copy), areValuesEqual (copy)
        for v123, v124 in t9 do
            if Fusion.peek(v124.locked) == true then
                local v125 = t6[v123]
                local v126 = v124.compute()

                if v125 and v126 ~= nil and not areValuesEqual(Fusion.peek(v125), v126) then
                    v125:set(v126)
                end
            end
        end
    end

    local function beginDisplayOverride(p21) -- line: 831
        -- upvalues: v11 (ref), t5 (copy), v14 (ref), applyLockOverrides (copy), Fusion (copy), areValuesEqual (copy)
        v14 = p21
        v11 = true

        for _, v127 in t5 do
            if v127.title ~= "useDefaults" and v127.title ~= "key" and v127.title ~= "rank" then
                local v128 = p21[v127.title]

                if v128 ~= nil then
                    local v129 = Fusion.peek(v127.inputValue)

                    if typeof(v129) == "table" and typeof(v128) ~= "table" then
                        v128 = { v128 }
                    end

                    if not areValuesEqual(v129, v128) then
                        v127.inputValue:set(v128)
                    end
                end
            end
        end

        applyLockOverrides()
        v11 = false
    end

    local function endDisplayOverride() -- line: 852
        -- upvalues: v11 (ref), t2 (copy), t5 (copy), v14 (ref), applyLockOverrides (copy), Fusion (copy), areValuesEqual (copy)
        v14 = nil
        v11 = true

        for _, v130 in t5 do
            if v130.title ~= "useDefaults" and v130.title ~= "key" and v130.title ~= "rank" then
                local v131 = t2[v130.title]
                local v132 = if v131 then Fusion.peek(v131) else nil

                if v132 ~= nil and not areValuesEqual(Fusion.peek(v130.inputValue), v132) then
                    v130.inputValue:set(v132)
                end
            end
        end

        applyLockOverrides()
        v11 = false
    end

    local function rebindToPath(p22) -- line: 870
        -- upvalues: v5 (ref), v7 (ref), t1 (copy), v11 (ref), t2 (copy), t3 (copy), v13 (ref), t5 (copy), t6 (copy), t8 (copy), undoChanges (copy), applyLockOverrides (copy), Fusion (copy)
        if v5 then
            return
        end

        if next(t1) ~= nil then
            undoChanges()
        end

        v13 = true
        v7 = p22

        for v134, v135 in t8 do
            local v136 = v135

            if v7 then
                v136 = table.clone(v7)

                for _, v137 in v135 do
                    table.insert(v136, v137)
                end
            end

            local v138 = t3[v134]

            if v138 then
                v138(v136)
            end

            local v139 = t2[v134]
            local v140 = t6[v134]

            if v140 and v139 then
                local v141 = Fusion.peek(v139)

                if v141 == nil then
                    v141 = ""
                end

                v140:set(v141)
            end

            for _, v142 in t5 do
                if v142.title == v134 then
                    v142.settingPath = v136
                    break
                end
            end
        end

        v13 = false

        local v143 = v11

        v11 = true
        applyLockOverrides()
        v11 = v143
    end

    local function scrollToTop() -- line: 908
        -- upvalues: v2 (ref)
        if v2 then
            local v144 = v2

            v144.CanvasPosition = Vector2.zero
        end
    end

    local function setFieldValue(p23, p24) -- line: 914
        -- upvalues: t6 (copy)
        local v145 = t6[p23]

        if v145 then
            v145:set(p24)
        end
    end

    if p2.controllerRef then
        objects = p2.controllerRef
        UIListLayout2 = {
            hasPendingChanges = v10,
            confirmChanges = confirmChanges,
            undoChanges = undoChanges,
            beginDisplayOverride = beginDisplayOverride,
            endDisplayOverride = endDisplayOverride,
            rebindToPath = rebindToPath
        }

        if p2.getDefaults then
            UIListLayout2.restoreDefaults = requestRestoreDefaults
        else
            UIListLayout2.restoreDefaults = nil
        end

        UIListLayout2.scrollToTop = scrollToTop
        UIListLayout2.setFieldValue = setFieldValue
        objects:set(UIListLayout2)
    end

    if p2.panelClosed then
        p1:Observer(p2.panelClosed):onChange(function() -- line: 935
            -- upvalues: p2 (copy), v5 (ref), undoChanges (copy), Fusion (copy)
            if not v5 and Fusion.peek(p2.panelClosed) == true then
                undoChanges()
            end
        end)
    end

    if p2.undoOnDestroy then
        UIListLayout2 = function() -- line: 944
            -- upvalues: t1 (copy), undoChanges (copy)
            if next(t1) then
                undoChanges()
            end
        end

        table.insert(p1, UIListLayout2)
    end

    if p2.noScroll then
        return p1:New("Frame")({
            Name = "SettingsListContent",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            [Children] = t10
        })
    end

    objects = p1:New("ScrollingFrame")
    v20 = {
        Name = "Scroll",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BottomImage = "rbxassetid://16547643439",
        CanvasSize = UDim2.new(),
        ClipsDescendants = true,
        LayoutOrder = 1,
        MidImage = "rbxassetid://16547330984",
        ScrollBarImageColor3 = Theme.Color.NeutralContentDark
    }

    if v1 then
        v20.ScrollBarImageTransparency = 1
    elseif p2.isVisible ~= nil then
        v20.ScrollBarImageTransparency = p1:Computed(function(p25) -- line: 973
            -- upvalues: p2 (copy)
            if p25(p2.isVisible) then
                return 0
            end

            return 1
        end)
    else
        v20.ScrollBarImageTransparency = 0
    end

    v20.ScrollBarThickness = v1 and 2 or 8
    v20.ScrollingDirection = Enum.ScrollingDirection.Y
    v20.Selectable = false
    v20.Size = UDim2.fromScale(1, 0)
    v20.TopImage = "rbxassetid://16547667444"

    if v1 then
        v20.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    else
        v20.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    end

    v16 = {}
    v15 = p1:New("UIFlexItem")({
        FlexMode = Enum.UIFlexMode.Fill
    })
    Frame = p1:New("UIPadding")({
        Name = "UIPadding",
        PaddingLeft = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 2)
    })

    local Frame2 = if p2.headerSlot then p1:New("Frame")({
        Name = "HeaderSlot",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Size = UDim2.fromScale(1, 0),
        Visible = p2.headerSlotVisible == nil or p2.headerSlotVisible,
        [Children] = { p2.headerSlot }
    }) else nil
    local v146 = if p2.footerSlot then p1:New("Frame")({
        Name = "FooterSlot",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 9999,
        Size = UDim2.fromScale(1, 0),
        [Children] = { p2.footerSlot }
    }) else nil

    v16[1] = v15
    v16[2] = Frame
    v16[3] = Frame2
    v16[4] = t10
    v16[5] = v146
    v20[Children] = v16
    v2 = objects(v20)
    objects = p1:New("Frame")
    v20 = {
        Name = "SettingsList",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }
    v16 = {}
    v15 = p1:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    Frame2 = if p2.hideConfirmBar then nil else ConfirmBar(p1, {
        layoutOrder = 2,
        hasPendingChanges = v10,
        confirmChanges = confirmChanges,
        undoChanges = undoChanges
    })
    v16[1] = v15
    v16[2] = v2
    v16[3] = Frame2
    v20[Children] = v16

    return objects(v20)
end
