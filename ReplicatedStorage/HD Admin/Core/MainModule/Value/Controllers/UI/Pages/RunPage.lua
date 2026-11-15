-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local CommandButton = require(UI.Components.CommandButton)
local CopyPopup = require(UI.Components.CopyPopup)

require(UI.Components.Pressable)

local RoleBadge = require(UI.Components.RoleBadge)

require(UI.Config.Icons)

local InputObjects = require(UI.Config.InputObjects)
local ItemSelector = require(UI.Components.ItemSelector)
local Args = require(Modules.Parser.Args)
local Modifiers = require(Modules.Parser.Modifiers)
local Parser = require(Modules.Parser)
local ParserSettings = require(Modules.Parser.ParserSettings)
local everyone = require(Modules.References.clientUser).everyone
local Platform = require(UI.Util.Platform)
local Permissions = require(UI.Util.Permissions)
local ModifierUtil = require(UI.Util.Cmdbar.ModifierUtil)
local Players = game:GetService("Players")

return function(p1, p2) -- line: 45
    -- upvalues: Fusion (copy), Theme (copy), Children (copy), CommandButton (copy), CopyPopup (copy), RoleBadge (copy), InputObjects (copy), ItemSelector (copy), Args (copy), Modifiers (copy), Parser (copy), ParserSettings (copy), everyone (copy), Platform (copy), Permissions (copy), ModifierUtil (copy), Players (copy)
    local commandKey = p2.commandKey
    local v1 = p1:Value(nil)
    local v2 = false

    table.insert(p1, {
        Destroy = function() -- Destroy | line: 50
            -- upvalues: v2 (ref)
            v2 = true
        end
    })
    p1:Observer(commandKey):onBind(function() -- line: 51
        -- upvalues: commandKey (copy), v1 (copy), v2 (ref), Fusion (copy), everyone (copy)
        local v3 = Fusion.peek(commandKey)

        if v3 ~= "" then
            local v4 = everyone:get("CommandInfo", v3)

            if v4 ~= nil then
                if not v2 then
                    v1:set(v4)
                end
            else
                task.spawn(function() -- line: 61
                    -- upvalues: v3 (copy), v1 (copy), v2 (ref), everyone (copy)
                    local v5, v6 = everyone:fetchAsync("CommandInfo", v3)

                    if not v2 and v5 then
                        v1:set(v6)
                    end
                end)
            end
        end
    end)

    local v8 = p1:Value(if p2.initialModifierTokens then table.clone(p2.initialModifierTokens) else {})
    local v9 = false
    local v10 = p1:Value(os.time())

    task.spawn(function() -- line: 79
        -- upvalues: v2 (ref), v10 (copy)
        while not v2 do
            task.wait(1)

            if not v2 then
                v10:set(os.time())
            end
        end
    end)

    local function modifierPickerGetter() -- line: 88
        -- upvalues: p1 (copy), v1 (copy), v10 (copy), Fusion (copy), Modifiers (copy), Permissions (copy), ModifierUtil (copy)
        local v11 = Modifiers.getAll()
        local t2 = {}

        for v12, v13 in v11 do
            if not v13.aliasOf and typeof(v13.displayOrder) == "number" and Permissions.canUseModifierNow(v13) and not ModifierUtil.isRejectedOn(v12, Fusion.peek(v1)) then
                local description = v13.description

                if v13.configurable == "epochTime" then
                    description = p1:Computed(function(p3) -- line: 100
                        -- upvalues: v13 (copy), v10 (copy)
                        return (("%*. Epoch time now: %*"):format(v13.description, (p3(v10))))
                    end)
                end

                table.insert(t2, {
                    category = "qualifier",
                    key = "modifier:" .. tostring(v12):lower(),
                    label = tostring(v12),
                    header = tostring(v12),
                    body = description,
                    rawValue = tostring(v12),
                    configurable = v13.configurable,
                    displayOrder = v13.displayOrder
                })
            end
        end

        table.sort(t2, function(p4, p5) -- line: 115
            return p4.displayOrder < p5.displayOrder
        end)

        return t2
    end

    local t4 = {}
    local t5 = {}
    local t6 = {}
    local v14 = p1:Value(0)

    local function touchCommandCache(p6) -- line: 130
        -- upvalues: t4 (copy), t5 (copy), t6 (copy)
        local v15 = table.find(t6, p6)

        if v15 then
            table.remove(t6, v15)
        end

        table.insert(t6, p6)

        while #t6 > 20 do
            local v16 = table.remove(t6, 1)

            for v17 in t4 do
                if v17:match("^(.+):") == v16 then
                    t4[v17] = nil
                    t5[v17] = nil
                end
            end
        end
    end

    local function getArgValidationStatus(p7) -- line: 145
        -- upvalues: p1 (copy), t5 (copy)
        if not t5[p7] then
            t5[p7] = p1:Value(nil)
        end

        return t5[p7]
    end

    local function getArgValue(p8, p9) -- line: 153
        -- upvalues: p1 (copy), commandKey (copy), t4 (copy), v14 (copy), Fusion (copy)
        if t4[p8] then
            return t4[p8]
        end

        local v18 = p1:Value(p9)

        t4[p8] = v18
        p1:Observer(v18):onChange(function() -- line: 157
            -- upvalues: p8 (copy), commandKey (copy), v14 (copy), Fusion (copy)
            if Fusion.peek(commandKey) == p8:match("^(.+):") then
                task.defer(function() -- line: 161
                    -- upvalues: v14 (copy), Fusion (copy)
                    v14:set(Fusion.peek(v14) + 1)
                end)
            end
        end)

        return t4[p8]
    end

    local v19 = p1:Value({})

    p1:Observer(v1):onBind(function() -- line: 180
        -- upvalues: p1 (copy), p2 (copy), commandKey (copy), v1 (copy), v8 (copy), v9 (ref), t4 (copy), t5 (copy), touchCommandCache (copy), getArgValue (copy), v19 (copy), Fusion (copy), Args (copy), ModifierUtil (copy), Players (copy)
        local v20 = Fusion.peek(v1)
        local v21 = Fusion.peek(commandKey)

        if type(v20) ~= "table" then
            v19:set({})

            return
        end

        touchCommandCache(v21)

        local t7 = {}
        local v22 = false

        for _, v23 in Fusion.peek(v8) do
            if ModifierUtil.isRejectedOn(v23, v20) then
                v22 = true
            else
                table.insert(t7, v23)
            end
        end

        if v22 then
            v8:set(t7)
        end

        local v24 = v20.args or {}
        local t8 = {}
        local v26 = false
        local v25

        for v27, v28 in v24 do
            local v29 = Args.get(v28)

            if v29 then
                local inputObject = v29.inputObject

                if inputObject then
                    local inputType = inputObject.inputType

                    if inputType then
                        local default = inputObject.default

                        if inputObject.allowEmpty == true then
                            default = nil
                        end

                        if default == nil and v29.playerArg == true then
                            default = "me"
                        end

                        local v30 = v21 .. ":" .. v27
                        local v31 = getArgValue(v30, default)

                        if v27 == 1 then
                            v25 = v31
                        end

                        local v32 = table.clone(inputObject)

                        v32.value = v31
                        v32.title = v32.title or v29.display or v29.key or tostring(v28)

                        if inputType == "ItemSelector" then
                            v32.onOpen = p2.onItemSelectorOpen

                            if inputObject.canAnyUserBeAddedToPicker then
                                v32.sharedCustomUsers = p2.sharedCustomUsers
                            end

                            local v33 = v29.playerArg == true or inputObject.canAnyUserBeAddedToPicker == true or inputObject.displayServerPlayersInPicker == true

                            if not v26 and v33 then
                                v26 = true
                                v32.autoOpen = p2.autoOpenUserArg
                            end
                        end

                        if (inputType == "TextInput" or inputType == "InputFields") and inputObject.filterText then
                            v32.firstArgValue = v25
                        end

                        local v34

                        if inputType == "TextInput" and (inputObject.filterText == true or inputObject.mustBeStringSafe == true) or inputType == "InputFields" and inputObject.filterText == true then
                            if not t5[v30] then
                                t5[v30] = p1:Value(nil)
                            end

                            v34 = t5[v30]
                            v32.validationStatus = v34
                        end

                        table.insert(t8, {
                            inputType = inputType,
                            inputConfig = v32,
                            argVal = v31,
                            argKey = v29.key or tostring(v28),
                            uiHidden = v29.uiHidden == true,
                            revealedBy = v29.revealedBy,
                            validationStatus = v34
                        })
                    end
                end
            end
        end

        v19:set(t8)

        local initialArgTokens, v35

        if not v9 and p2.initialArgTokens then
            v9 = true
            initialArgTokens = p2.initialArgTokens

            local LocalPlayer = Players.LocalPlayer

            v35 = if LocalPlayer then LocalPlayer.UserId else 0

            for v36, v37 in v24 do
                local v38 = initialArgTokens[v36]

                if typeof(v38) == "string" and v38 ~= "" then
                    local v39 = Args.get(v37)

                    if v39 and typeof(v39.parse) == "function" then
                        local v41 = t4[v21 .. ":" .. v36]

                        if v41 then
                            local v42 = v35

                            local function v43() -- line: 280
                                -- upvalues: v38 (copy), v39 (copy), v42 (copy)
                                return v39:parse(v38, v42)
                            end

                            local ok, result = pcall(v43)

                            if ok and result ~= nil then
                                v41:set(result)
                            end
                        end
                    end
                end
            end
        end
    end)

    local function isSlotRevealed(p10, p11) -- line: 289
        -- upvalues: Fusion (copy)
        if not p10.uiHidden then
            return true
        end

        if p10.revealedBy then
            local dependsOn, equals, equalsAny = p10.revealedBy.dependsOn, p10.revealedBy.equals, p10.revealedBy.equalsAny

            for _, v44 in p11 do
                if v44.argKey == dependsOn then
                    local v45 = Fusion.peek(v44.argVal)

                    if not equalsAny then
                        return v45 == equals
                    end

                    for _, v46 in equalsAny do
                        if v45 == v46 then
                            return true
                        end
                    end

                    return false
                end
            end
        end

        return false
    end

    local function evaluateRunGate() -- line: 311
        -- upvalues: v19 (copy), isSlotRevealed (copy), Fusion (copy)
        local v47 = Fusion.peek(v19)

        for _, v48 in v47 do
            local validationStatus = v48.validationStatus

            if validationStatus and isSlotRevealed(v48, v47) and Fusion.peek(validationStatus) == false then
                return false, "Text checks failed, please review and retry"
            end
        end

        return true, nil
    end

    local v49 = p1:Value("")
    local n1 = 0
    local v50 = false

    local function flushCommandStringUpdate() -- line: 327
        -- upvalues: commandKey (copy), v1 (copy), v2 (ref), v8 (copy), v19 (copy), isSlotRevealed (copy), v49 (copy), n1 (ref), v50 (ref), Fusion (copy), Parser (copy), ParserSettings (copy), Players (copy)
        if not v50 then
            return
        end

        v50 = false
        n1 += 1

        local v51 = n1
        local v52 = Fusion.peek(v1)
        local v53 = Fusion.peek(commandKey)
        local v54 = Fusion.peek(v19)
        local v55 = if type(v52) ~= "table" or not v52.disableModifiers then Fusion.peek(v8) else {}

        if type(v52) ~= "table" then
            v49:set("")

            return
        end

        local v56 = v52.args or {}
        local t10 = {}

        for i = 1, #v56 do
            local v57 = v54[i]

            if v57 then
                local v58 = Fusion.peek(v57.argVal)
                local EmptyUnparsedValue = ParserSettings.EmptyUnparsedValue

                if isSlotRevealed(v57, v54) then
                    local v59

                    if v57.inputType == "TextInput" and v58 == "" or v57.inputType == "NumberInput" and v58 == nil then
                        v59 = EmptyUnparsedValue
                    elseif v57.inputType == "InputFields" and typeof(v58) == "table" then
                        local v60 = true

                        for _, v61 in v58 do
                            if typeof(v61) == "string" and v61 ~= "" then
                                v60 = false
                                break
                            end
                        end

                        if v60 then
                            v59 = { EmptyUnparsedValue }
                        else
                            v59 = v58
                        end
                    elseif v57.inputType == "Options" and (v58 == nil or v58 == "") then
                        local inputConfig = v57.inputConfig
                        local optionsArray = inputConfig.optionsArray

                        v59 = if typeof(optionsArray) ~= "table" or not (#optionsArray > 0) then inputConfig.default or EmptyUnparsedValue else optionsArray[1]
                    elseif v57.inputType == "ItemSelector" and (v58 == nil or typeof(v58) == "table" and #v58 == 0 or v58 == "") then
                        local inputConfig = v57.inputConfig

                        if inputConfig.canAnyUserBeAddedToPicker then
                            local LocalPlayer = Players.LocalPlayer

                            v59 = {}
                            v59[1] = if LocalPlayer then LocalPlayer.UserId else 0
                        elseif inputConfig.displayQualifiersInPicker then
                            v59 = { "me" }
                        else
                            v59 = { EmptyUnparsedValue }
                        end
                    else
                        v59 = v58
                    end

                    t10[i] = v59
                else
                    t10[i] = EmptyUnparsedValue
                end
            else
                local v62

                t10[i] = v62
            end
        end

        task.spawn(function() -- line: 388
            -- upvalues: v51 (copy), v53 (copy), t10 (copy), v55 (copy), v2 (ref), v49 (copy), n1 (ref), Parser (copy)
            local unparse = Parser.unparse
            local unpack = table.unpack
            local ok, result = pcall(unparse, v53, v55, unpack(t10))
            local v63, v64

            if not v2 and v51 == n1 then
                v63 = v49
                v64 = if ok and type(result) == "string" then result else ""
                v63:set(v64)
            end
        end)
    end

    local function scheduleCommandStringUpdate() -- line: 395
        -- upvalues: v50 (ref), flushCommandStringUpdate (copy)
        if not v50 then
            v50 = true
            task.defer(flushCommandStringUpdate)
        end
    end

    p1:Observer(v1):onBind(function() -- line: 401
        -- upvalues: v50 (ref), flushCommandStringUpdate (copy)
        if not v50 then
            v50 = true
            task.defer(flushCommandStringUpdate)
        end
    end)
    p1:Observer(v14):onChange(function() -- line: 404
        -- upvalues: v50 (ref), flushCommandStringUpdate (copy)
        if not v50 then
            v50 = true
            task.defer(flushCommandStringUpdate)
        end
    end)
    p1:Observer(v8):onChange(function() -- line: 407
        -- upvalues: v50 (ref), flushCommandStringUpdate (copy)
        if not v50 then
            v50 = true
            task.defer(flushCommandStringUpdate)
        end
    end)

    local v65 = p1:Value(false)
    local v66 = p1:Fuse("perm", { "YouSettings", "Prefix" })
    local RoleInfo = p1:Fuse("everyone", "RoleInfo")
    local v67 = p1:Computed(function(p12) -- line: 416
        -- upvalues: p2 (copy), v1 (copy)
        local showRoles = p2.showRoles
        local directRoles, v68

        if showRoles ~= nil then
            if p12(showRoles) then
                local v69 = p12(v1)

                if type(v69) == "table" then
                    directRoles = v69.directRoles
                end

                v68 = false
            else
                v68 = true
            end
        else
            v68 = true
        end

        if v68 then
            return false
        end

        if typeof(directRoles) == "table" then
            return #directRoles > 0
        end

        return false
    end)
    local v70 = p1:Computed(function(p13, p14) -- line: 423
        -- upvalues: v1 (copy), RoleInfo (copy), v67 (copy), Children (copy), RoleBadge (copy)
        if not p13(v67) then
            return nil
        end

        local directRoles = p13(v1).directRoles
        local v71 = p13(RoleInfo)
        local t12 = {
            p14:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                HorizontalFlex = Enum.UIFlexAlignment.None,
                VerticalFlex = Enum.UIFlexAlignment.None,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        }

        for v72, v73 in directRoles do
            local v74 = if typeof(v71) == "table" then v71[v73] else nil

            table.insert(t12, RoleBadge(p14, {
                large = true,
                pillHeight = 31,
                textSize = 18,
                id = v73,
                name = if typeof(v74) ~= "table" then v73 elseif typeof(v74.name) == "string" then v74.name else v73,
                color = if typeof(v74) ~= "table" then nil elseif typeof(v74.color) == "Color3" then v74.color else nil,
                layoutOrder = v72
            }))
        end

        return p14:New("Frame")({
            Name = "CommandRoles",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = -3,
            Size = UDim2.fromScale(1, 0),
            [Children] = t12
        })
    end)
    local v75 = p1:Computed(function(p15, p16) -- line: 460
        -- upvalues: v1 (copy), Theme (copy), Children (copy)
        local v76 = p15(v1)
        local description = if type(v76) == "table" then v76.description else nil

        if typeof(description) ~= "string" or description == "" then
            return nil
        end

        return p16:New("TextLabel")({
            Name = "Description",
            LayoutOrder = -4,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            FontFace = p16:Computed(function(p17) -- line: 470
                -- upvalues: Theme (copy)
                return Font.new(p17(Theme.Font.Body), Enum.FontWeight.Medium)
            end),
            Text = description,
            TextColor3 = Theme.Color.NeutralContentMain,
            TextSize = Theme.TextSize.Body,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            [Children] = {
                p16:New("UIPadding")({
                    PaddingLeft = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                    PaddingTop = UDim.new(0, -8),
                    PaddingBottom = UDim.new(0, 2)
                })
            }
        })
    end)
    local v77 = p1:Computed(function(p18) -- line: 489
        -- upvalues: v1 (copy), v66 (copy), Args (copy)
        local v78 = p18(v1)

        if type(v78) ~= "table" then
            return ""
        end

        local prefix = v78.prefix or p18(v66) or ";"
        local v79 = v78.name or ""
        local v80 = v78.args or {}
        local t14 = {}

        for _, v81 in v80 do
            local v82 = Args.get(v81)

            table.insert(t14, "<" .. tostring(if v82 then v82.display or v82.key or tostring(v81) else tostring(v81)) .. ">")
        end

        local v84 = prefix .. v79

        if #t14 > 0 then
            v84 ..= " " .. table.concat(t14, " ")
        end

        return v84
    end)

    return p1:New("Frame")({
        Name = "RunPage",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        [Children] = {
            p1:New("Frame")({
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                [Children] = {
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p1:New("ScrollingFrame")({
                        Name = "ArgsScroller",
                        LayoutOrder = 1,
                        Size = UDim2.fromScale(1, 0),
                        BackgroundTransparency = 1,
                        CanvasSize = UDim2.new(),
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BottomImage = "rbxassetid://16547643439",
                        MidImage = "rbxassetid://16547330984",
                        ScrollBarImageColor3 = Theme.Color.NeutralContentDark,
                        ScrollBarImageTransparency = Platform.isMobile and 1 or 0,
                        ScrollBarThickness = Platform.isMobile and 2 or 8,
                        ScrollingDirection = Enum.ScrollingDirection.Y,
                        TopImage = "rbxassetid://16547667444",
                        VerticalScrollBarInset = if Platform.isMobile then Enum.ScrollBarInset.Always else Enum.ScrollBarInset.ScrollBar,
                        [Children] = {
                            p1:New("UIFlexItem")({
                                FlexMode = Enum.UIFlexMode.Fill
                            }),
                            p1:New("UIListLayout")({
                                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                FillDirection = Enum.FillDirection.Vertical,
                                Padding = UDim.new(0, 12),
                                SortOrder = Enum.SortOrder.LayoutOrder
                            }),
                            p1:New("UIPadding")({
                                Name = "UIPadding",
                                PaddingLeft = UDim.new(0, 1),
                                PaddingRight = UDim.new(0, 6),
                                PaddingBottom = UDim.new(0, 6)
                            }),
                            p1:New("TextLabel")({
                                Name = "SignatureTitle",
                                LayoutOrder = -5,
                                AutomaticSize = Enum.AutomaticSize.Y,
                                BackgroundTransparency = 1,
                                Size = UDim2.fromScale(1, 0),
                                FontFace = p1:Computed(function(p19) -- line: 564
                                    -- upvalues: Theme (copy)
                                    return Font.new(p19(Theme.Font.Body), p19(Theme.FontWeight.Body))
                                end),
                                Text = v77,
                                TextColor3 = Theme.Color.BaseContent,
                                TextSize = Theme.TextSize.Subtitle,
                                TextWrapped = true,
                                TextXAlignment = Enum.TextXAlignment.Center,
                                [Children] = {
                                    p1:New("UICorner")({
                                        CornerRadius = UDim.new(0, 6)
                                    }),
                                    p1:New("UIPadding")({
                                        PaddingLeft = UDim.new(0, 2),
                                        PaddingRight = UDim.new(0, 2),
                                        PaddingTop = UDim.new(0, 4),
                                        PaddingBottom = p1:Computed(function(p20) -- line: 580
                                            -- upvalues: v67 (copy)
                                            return UDim.new(0, if p20(v67) then 0 else 4)
                                        end)
                                    })
                                }
                            }),
                            v75,
                            p1:New("Frame")({
                                Name = "Divider",
                                LayoutOrder = -1,
                                BorderSizePixel = 0,
                                BackgroundColor3 = Theme.Color.NeutralStroke,
                                Size = UDim2.new(1, 0, 0, 1)
                            }),
                            v70,
                            p1:ForValues(v19, function(_, p22, p23) -- line: 599
                                -- upvalues: v19 (copy), Fusion (copy), Children (copy), InputObjects (copy)
                                local v93 = InputObjects.items[p23.inputType]

                                if not v93 then
                                    return nil
                                end

                                local v94 = v93(p22, p23.inputConfig)

                                if not p23.uiHidden then
                                    return v94
                                end

                                local v95

                                if not p23.revealedBy then
                                    v95 = false

                                    return p22:New("Frame")({
                                        Name = "ArgWrap_" .. p23.argKey,
                                        AutomaticSize = Enum.AutomaticSize.Y,
                                        BackgroundTransparency = 1,
                                        Size = UDim2.fromScale(1, 0),
                                        Visible = v95,
                                        [Children] = { v94 }
                                    })
                                end

                                local dependsOn, equals, equalsAny = p23.revealedBy.dependsOn, p23.revealedBy.equals, p23.revealedBy.equalsAny
                                local v96 = Fusion.peek(v19)
                                local argVal, argVal2

                                for _, v97 in v96 do
                                    if v97.argKey == dependsOn then
                                        local argVal3 = v97.argVal

                                        argVal = argVal3
                                        argVal2 = argVal3
                                        break
                                    end
                                end

                                if argVal2 then
                                    v95 = p22:Computed(function(p24) -- line: 620
                                        -- upvalues: equals (copy), equalsAny (copy), argVal (ref)
                                        local v98 = p24(argVal)

                                        if not equalsAny then
                                            return v98 == equals
                                        end

                                        for _, v99 in equalsAny do
                                            if v98 == v99 then
                                                return true
                                            end
                                        end

                                        return false
                                    end)
                                else
                                    v95 = false
                                end

                                return p22:New("Frame")({
                                    Name = "ArgWrap_" .. p23.argKey,
                                    AutomaticSize = Enum.AutomaticSize.Y,
                                    BackgroundTransparency = 1,
                                    Size = UDim2.fromScale(1, 0),
                                    Visible = v95,
                                    [Children] = { v94 }
                                })
                            end),
                            p1:New("Frame")({
                                Name = "ModifierSelectorWrapper",
                                LayoutOrder = 9999,
                                AutomaticSize = Enum.AutomaticSize.Y,
                                Size = UDim2.fromScale(1, 0),
                                BackgroundTransparency = 1,
                                Visible = p1:Computed(function(p25) -- line: 646
                                    -- upvalues: v1 (copy)
                                    local v100 = p25(v1)

                                    if typeof(v100) == "table" then
                                        return not v100.disableModifiers
                                    end

                                    return true
                                end),
                                [Children] = {
                                    ItemSelector(p1, {
                                        title = "Modifiers",
                                        isOrderedPicker = true,
                                        singleSelection = true,
                                        value = v8,
                                        pickerGetter = modifierPickerGetter,
                                        onOpen = p2.onItemSelectorOpen
                                    })
                                }
                            })
                        }
                    }),
                    p1:New("Frame")({
                        Name = "Divider",
                        LayoutOrder = 2,
                        Size = UDim2.new(1, 0, 0, 1),
                        BackgroundColor3 = Theme.Color.NeutralStroke
                    }),
                    p1:New("Frame")({
                        Name = "BottomBar",
                        LayoutOrder = 3,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Size = UDim2.fromScale(1, 0),
                        BackgroundTransparency = 1,
                        [Children] = {
                            p1:New("UIPadding")({
                                Name = "UIPadding",
                                PaddingBottom = UDim.new(0, 4),
                                PaddingTop = UDim.new(0, 14),
                                PaddingLeft = UDim.new(0, 1),
                                PaddingRight = UDim.new(0, 1)
                            }),
                            p1:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                Padding = p1:Computed(function(p26) -- line: 694
                                    -- upvalues: Theme (copy)
                                    return UDim.new(0, (math.round(p26(Theme.Layout.Spacing) * 0.5)))
                                end)
                            }),
                            CommandButton(p1, {
                                chatSource = "ClientPreviewRun",
                                runOnly = true,
                                layoutOrder = 1,
                                textSize = 18,
                                commandKey = commandKey,
                                text = v49,
                                commandText = v49,
                                unlockRole = p2.unlockRole,
                                runGate = evaluateRunGate,
                                activeCommands = p2.activeCommands,
                                size = UDim2.new(1, 0, 0, 44),
                                onCommandActivate = function() -- onCommandActivate | line: 709
                                    -- upvalues: v65 (copy)
                                    v65:set(true)
                                end,
                                onCopy = function() -- onCopy | line: 712
                                    -- upvalues: v65 (copy)
                                    v65:set(true)
                                end
                            })
                        }
                    })
                }
            }),
            CopyPopup(p1, {
                text = v49,
                visible = v65
            })
        }
    })
end
