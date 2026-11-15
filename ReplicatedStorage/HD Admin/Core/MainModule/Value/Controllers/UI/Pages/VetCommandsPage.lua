-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local CommandButton = require(UI.Components.CommandButton)
local ScrollList = require(UI.Components.ScrollList)
local ConfirmBar = require(UI.Components.ConfirmBar)
local UnderscoreTabBar = require(UI.Components.UnderscoreTabBar)
local InlineToggleRow = require(UI.Components.InlineToggleRow)
local SearchBar = require(UI.Components.SearchBar)
local Icons = require(UI.Config.Icons)
local Permissions = require(UI.Util.Permissions)
local VettingState = require(UI.Config.VettingState)
local Remote = require(Modules.Objects.Remote)
local isVettable = require(Modules.CommandUtil.isVettable)
local GetActiveCommands = Remote.get("GetActiveCommands")
local UpdateActiveCommands = Remote.get("UpdateActiveCommands")

return function(p1, p2) -- line: 36
    -- upvalues: Modules (copy), Fusion (copy), Theme (copy), Children (copy), CommandButton (copy), ScrollList (copy), ConfirmBar (copy), UnderscoreTabBar (copy), InlineToggleRow (copy), SearchBar (copy), Icons (copy), Permissions (copy), VettingState (copy), Remote (copy), isVettable (copy), GetActiveCommands (copy), UpdateActiveCommands (copy)
    local Commands = p1:Fuse("everyone", "Commands")
    local v1 = p1:Fuse("perm", { "YouSettings", "Prefix" })
    local CommandVetting = p1:Fuse("everyone", "CommandVetting")
    local v2 = p1:Value({})

    local function refreshActiveCommands() -- line: 42
        -- upvalues: v2 (copy), GetActiveCommands (copy)
        task.defer(function() -- line: 43
            -- upvalues: v2 (copy), GetActiveCommands (copy)
            local _, v3 = GetActiveCommands:invokeServerAsync()

            if type(v3) == "table" then
                v2:set(v3)
            end
        end)
    end

    task.defer(function() -- line: 43
        -- upvalues: v2 (copy), GetActiveCommands (copy)
        local _, v4 = GetActiveCommands:invokeServerAsync()

        if type(v4) == "table" then
            v2:set(v4)
        end
    end)

    local v5 = UpdateActiveCommands:onClientEvent(function(p3) -- line: 51
        -- upvalues: v2 (copy)
        if type(p3) == "table" then
            v2:set(p3)
        end
    end)

    table.insert(p1, function() -- line: 56
        -- upvalues: v5 (copy)
        v5:Disconnect()
    end)

    local t1 = {
        "pending",
        "approved",
        "disabled"
    }
    local v7 = p1:Value({})
    local v8 = p1:Value(false)
    local v9 = p1:Value({})
    local mayEditSettingsGame = Permissions.hasPermission(p1, "mayEditSettingsGame")
    local v10 = p1:Fuse("everyone", { "GameSettings", "SystemSettings", "AutoApproveNewCommands" })
    local v11 = p1:Value(Fusion.peek(v10) ~= false)
    local v12 = p1:Value(false)

    local function toggleAutoApprove() -- line: 72
        -- upvalues: v10 (copy), v11 (copy), v12 (copy), Fusion (copy)
        local v13 = not Fusion.peek(v11)

        v11:set(v13)
        v12:set(v13 ~= (Fusion.peek(v10) ~= false))
    end

    p1:Observer(v10):onChange(function() -- line: 77
        -- upvalues: v10 (copy), v11 (copy), v12 (copy), Fusion (copy)
        if not Fusion.peek(v12) then
            v11:set(Fusion.peek(v10) ~= false)
        end
    end)

    local function savedStatus(p4, p5) -- line: 82
        -- upvalues: CommandVetting (copy)
        local v14 = p4(CommandVetting)
        local states = if typeof(v14) == "table" then v14.states else nil

        if not (typeof(states) == "table" and typeof(states[p5]) == "string") then
            return "approved"
        end

        return states[p5]
    end

    local function effectiveStatus(p6, p7) -- line: 90
        -- upvalues: CommandVetting (copy), v7 (copy)
        local v18 = p6(v7)[p7]

        if v18 then
            return v18
        end

        local v19 = p6(CommandVetting)
        local states = if typeof(v19) == "table" then v19.states else nil

        if not (typeof(states) == "table" and typeof(states[p7]) == "string") then
            return "approved"
        end

        return states[p7]
    end

    local function setDecision(p8, p9) -- line: 94
        -- upvalues: CommandVetting (copy), v7 (copy), Fusion (copy)
        local v23 = table.clone(Fusion.peek(v7))
        local v24 = Fusion.peek(CommandVetting)
        local states = if typeof(v24) == "table" then v24.states else nil
        local v25 = typeof(states) == "table"
        local v26 = if v25 then typeof(states[p8]) == "string" else nil

        if (if not v25 or not v26 then "approved" else states[p8]) == p9 then
            v23[p8] = nil
        else
            v23[p8] = p9
        end

        v7:set(v23)
    end

    local v28 = p1:Computed(function(p10) -- line: 103
        -- upvalues: Commands (copy), CommandVetting (copy), v7 (copy), isVettable (copy)
        local v29 = p10(Commands)

        if typeof(v29) ~= "table" then
            return 0
        end

        local n1 = 0

        for _, v30 in v29 do
            if typeof(v30) == "table" and isVettable(v30) then
                local v31 = v30.identity or v30.key

                if typeof(v31) == "string" then
                    local v32 = p10(v7)[v31]

                    if not v32 then
                        local v33 = p10(CommandVetting)
                        local states = if typeof(v33) == "table" then v33.states else nil

                        v32 = if typeof(states) ~= "table" then "approved" elseif typeof(states[v31]) == "string" then states[v31] else "approved"
                    end

                    if v32 == "pending" then
                        n1 += 1
                    end
                end
            end
        end

        return n1
    end)
    local v35 = p1:Computed(function(p11) -- line: 117
        -- upvalues: v7 (copy), v12 (copy)
        if next(p11(v7)) == nil then
            return (p11(v12))
        end

        return true
    end)

    local function confirmVet() -- line: 120
        -- upvalues: v7 (copy), v8 (copy), v11 (copy), v12 (copy), v28 (copy), v35 (copy), Modules (copy), Fusion (copy), Remote (copy)
        if not Fusion.peek(v8) and Fusion.peek(v35) then
            v8:set(true)
            task.spawn(function() -- line: 123
                -- upvalues: v7 (copy), v8 (copy), v11 (copy), v12 (copy), v28 (copy), Modules (copy), Fusion (copy), Remote (copy)
                local v36 = Fusion.peek(v7)
                local n2 = 0
                local n3 = 0

                for _, v37 in v36 do
                    if v37 == "approved" then
                        n2 += 1
                    elseif v37 == "disabled" then
                        n3 += 1
                    end
                end

                if Fusion.peek(v12) then
                    local v38 = Fusion.peek(v11)

                    if v38 then
                        n2 += Fusion.peek(v28)
                    end

                    local function v39() -- line: 140
                        -- upvalues: v38 (copy), Remote (copy)
                        return Remote.get("ChangeGameSetting"):invokeServerAsync({ "SystemSettings", "AutoApproveNewCommands" }, v38)
                    end

                    pcall(v39)
                    v12:set(false)
                end

                local v40

                if next(v36) ~= nil then
                    local v41, v42, v43 = Remote.get("VetCommands"):invokeServerAsync(v36)

                    if v41 then
                        v40 = true
                        v7:set({})
                    else
                        local Prompt = require(Modules.Prompt)
                        local v44 = if v43 == "error" then Prompt.error else Prompt.warn
                        local v45 = v42 or "Failed to save the vetting decisions"

                        v40 = false
                        v44((tostring(v45)))
                    end
                else
                    v40 = true
                end

                if v40 and (n2 > 0 or n3 > 0) then
                    local Prompt = require(Modules.Prompt)
                    local v46 = if n2 > 0 and n3 > 0 then ("Approved %* command%* and disabled %* command%*"):format(n2, if n2 == 1 then "" else "s", n3, if n3 == 1 then "" else "s") elseif n2 > 0 then ("Approved %* command%*"):format(n2, if n2 == 1 then "" else "s") else ("Disabled %* command%*"):format(n3, if n3 == 1 then "" else "s")

                    Prompt.info(v46)
                end

                v8:set(false)
            end)
        end
    end

    local v48 = p1:Value(if Fusion.peek(v10) == false then 1 else 2)
    local t3 = {
        {
            label = "Pending",
            visible = p1:Computed(function(p12) -- line: 178
                -- upvalues: v11 (copy)
                return not p12(v11)
            end)
        },
        {
            label = "Approved"
        },
        {
            label = "Disabled"
        }
    }

    local function clampHiddenPending() -- line: 187
        -- upvalues: v10 (copy), v11 (copy), v12 (copy), v48 (copy), Fusion (copy)
        if (if Fusion.peek(v12) then Fusion.peek(v11) else Fusion.peek(v10) ~= false) and Fusion.peek(v48) == 1 then
            v48:set(2)
        end
    end

    p1:Observer(v11):onChange(clampHiddenPending)
    p1:Observer(v10):onChange(clampHiddenPending)

    local function snapshotAndAcknowledge(p13) -- line: 200
        -- upvalues: v9 (copy), Fusion (copy), VettingState (copy)
        local unackedKeys = if typeof(p13) == "table" then p13.unackedKeys else nil

        if typeof(unackedKeys) == "table" and next(unackedKeys) ~= nil then
            local v49 = table.clone(Fusion.peek(v9))

            for v50 in unackedKeys do
                if typeof(v50) == "string" then
                    v49[v50] = true
                end
            end

            v9:set(v49)
        end

        VettingState.acknowledge()
    end

    local v51 = false

    local function onPageOpened() -- line: 214
        -- upvalues: p1 (copy), CommandVetting (copy), v48 (copy), snapshotAndAcknowledge (copy), v51 (ref), Fusion (copy), VettingState (copy)
        local v52 = Fusion.peek(CommandVetting)

        if typeof(v52) == "table" then
            snapshotAndAcknowledge(v52)
        elseif not v51 then
            v51 = true

            local v53

            v53 = p1:Observer(CommandVetting):onChange(function() -- line: 223
                -- upvalues: v53 (ref), CommandVetting (copy), snapshotAndAcknowledge (copy), v51 (ref), Fusion (copy)
                local v54 = Fusion.peek(CommandVetting)

                if typeof(v54) ~= "table" then
                    return
                end

                v51 = false
                snapshotAndAcknowledge(v54)

                if v53 then
                    v53()
                    v53 = nil
                end
            end)
        end

        if VettingState.consumePendingFocus() then
            v48:set(1)
        end
    end

    if p2.isActive then
        p1:Observer(p2.isActive):onChange(function() -- line: 241
            -- upvalues: p2 (copy), onPageOpened (copy), Fusion (copy)
            if Fusion.peek(p2.isActive) then
                onPageOpened()
            end
        end)

        if Fusion.peek(p2.isActive) then
            onPageOpened()
        end
    end

    VettingState.setOpenListener(onPageOpened)
    table.insert(p1, function() -- line: 251
        -- upvalues: VettingState (copy)
        VettingState.setOpenListener(nil)
    end)

    local t4 = {}
    local v56 = p1:Computed(function(p14) -- line: 258
        -- upvalues: Commands (copy), CommandVetting (copy), v7 (copy), v9 (copy), t4 (copy), isVettable (copy)
        local v57 = p14(Commands)

        if typeof(v57) ~= "table" then
            return {}
        end

        local v58 = p14(v9)
        local t5 = {}

        for _, v59 in v57 do
            if typeof(v59) == "table" and isVettable(v59) then
                local v60 = v59.identity or v59.key

                if typeof(v60) == "string" then
                    local v61 = p14(v7)[v60]

                    if not v61 then
                        local v62 = p14(CommandVetting)
                        local states = if typeof(v62) == "table" then v62.states else nil

                        v61 = if typeof(states) ~= "table" then "approved" elseif typeof(states[v60]) == "string" then states[v60] else "approved"
                    end

                    local v64 = v58[v60] == true
                    local roles = v59.roles
                    local v65 = v61 == "approved" and (typeof(roles) ~= "table" or #roles == 0)
                    local v66 = t4[v60]

                    if not v66 or v66.status ~= v61 or v66.commandKey ~= v59.key or v66.isNew == true ~= v64 or v66.isUnused == true ~= v65 then
                        v66 = {}
                        v66.key = "vr_" .. v60
                        v66.identity = v60
                        v66.commandKey = v59.key
                        v66.name = v59.name
                        v66.prefix = v59.prefix
                        v66.status = v61
                        v66.isNew = v64
                        v66.isUnused = v65
                        t4[v60] = v66
                    end

                    table.insert(t5, v66)
                end
            end
        end

        table.sort(t5, function(p15, p16) -- line: 294
            if p15.isNew == true ~= (p16.isNew == true) then
                return p15.isNew == true
            end

            if p15.isUnused == true == (p16.isUnused == true) then
                return p15.name < p16.name
            end

            return p15.isUnused == true
        end)

        return t5
    end)
    local v67 = p1:Value("")
    local v68 = p1:Computed(function(p17) -- line: 306
        -- upvalues: t1 (copy), v48 (copy), v56 (copy), v67 (copy)
        local v69 = t1[p17(v48)] or "pending"
        local v70 = p17(v67):lower()
        local t6 = {}

        for _, v71 in p17(v56) do
            if v71.status == v69 and (v70 == "" or v71.name:lower():find(v70, 1, true)) then
                table.insert(t6, v71)
            end
        end

        return t6
    end)
    local v72 = p1:Computed(function(p18) -- line: 318
        -- upvalues: Commands (copy), v28 (copy), v48 (copy), v67 (copy), v68 (copy)
        local v73 = p18(Commands)

        if typeof(v73) ~= "table" or next(v73) == nil or p18(v67) ~= "" or #p18(v68) > 0 then
            return nil
        end

        local v74 = p18(v48)

        if v74 == 1 then
            return "No pending commands. New commands added to HD Admin will appear here."
        end

        if v74 ~= 3 then
            return nil
        end

        if p18(v28) > 0 then
            return "No disabled commands. All your commands (minus pending) are live and useable."
        end

        return "No disabled commands. All your commands are live and useable."
    end)
    local v75 = p1:New("TextLabel")({
        Name = "EmptyState",
        BackgroundTransparency = 1,
        TextWrapped = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -20, 1, 0),
        Visible = p1:Computed(function(p19) -- line: 341
            -- upvalues: v72 (copy)
            return p19(v72) ~= nil
        end),
        FontFace = p1:Computed(function(p20) -- line: 344
            -- upvalues: Theme (copy)
            return Font.new(p20(Theme.Font.Body), p20(Theme.FontWeight.Regular))
        end),
        Text = p1:Computed(function(p21) -- line: 347
            -- upvalues: v72 (copy)
            return p21(v72) or ""
        end),
        TextColor3 = Theme.Color.NeutralContentDark,
        TextSize = Theme.TextSize.Body,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    return p1:New("Frame")({
        Name = "VetCommands",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p1:New("UIPadding")({
                PaddingBottom = UDim.new(0, 1),
                PaddingLeft = UDim.new(0, 1),
                PaddingRight = UDim.new(0, 1),
                PaddingTop = UDim.new(0, 1)
            }),
            p1:New("UIListLayout")({
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            ScrollList(p1, {
                layoutOrder = 1,
                paddingRight = 10,
                pinBelowHeader = true,
                isReady = p1:Computed(function(p22) -- line: 375
                    -- upvalues: Commands (copy)
                    local v78 = p22(Commands)

                    if type(v78) == "table" then
                        return next(v78) ~= nil
                    end

                    return false
                end),
                items = v56,
                visibleItems = v68,
                itemKey = function(p23) -- itemKey | line: 381
                    return p23.key
                end,
                renderItem = function(p24, p25) -- renderItem | line: 384
                    -- upvalues: p2 (copy), v1 (copy), CommandVetting (copy), v2 (copy), v7 (copy), Fusion (copy), Theme (copy), CommandButton (copy), Icons (copy)
                    local identity, status, commandKey = p25.identity, p25.status, p25.commandKey
                    local t10 = {}

                    if status ~= "approved" then
                        table.insert(t10, {
                            icon = if status == "disabled" then Icons.VetApproveDisabled else Icons.VetApprove,
                            iconColor = if status == "pending" then Theme.Color.PrimaryContent else Theme.Color.BaseContent,
                            backgroundColor = if status == "pending" then Theme.Color.Primary else Theme.Color.NeutralContent,
                            onActivate = function() -- onActivate | line: 395
                                -- upvalues: identity (copy), CommandVetting (copy), v7 (copy), Fusion (copy)
                                local v79 = table.clone(Fusion.peek(v7))
                                local v80 = Fusion.peek(CommandVetting)
                                local states = if typeof(v80) == "table" then v80.states else nil
                                local v81 = typeof(states) == "table"
                                local v82 = if v81 then typeof(states[identity]) == "string" else nil

                                if (if not v81 or not v82 then "approved" else states[identity]) == "approved" then
                                    v79[identity] = nil
                                else
                                    v79[identity] = "approved"
                                end

                                v7:set(v79)
                            end
                        })
                    end

                    if status ~= "disabled" then
                        table.insert(t10, {
                            icon = if status == "approved" then Icons.VetDisableApproved else Icons.VetDisable,
                            iconColor = Theme.Color.BaseContent,
                            backgroundColor = Theme.Color.NeutralContent,
                            onActivate = function() -- onActivate | line: 405
                                -- upvalues: identity (copy), CommandVetting (copy), v7 (copy), Fusion (copy)
                                local v84 = table.clone(Fusion.peek(v7))
                                local v85 = Fusion.peek(CommandVetting)
                                local states = if typeof(v85) == "table" then v85.states else nil
                                local v86 = typeof(states) == "table"
                                local v87 = if v86 then typeof(states[identity]) == "string" else nil

                                if (if not v86 or not v87 then "approved" else states[identity]) == "disabled" then
                                    v84[identity] = nil
                                else
                                    v84[identity] = "disabled"
                                end

                                v7:set(v84)
                            end
                        })
                    end

                    return CommandButton(p24, {
                        commandKey = commandKey,
                        commandName = p25.name,
                        commandPrefix = p25.prefix,
                        customPrefix = v1,
                        nameTag = if p25.isNew == true then "NEW" elseif p25.isUnused == true then "Unused" else nil,
                        nameTagColor = if p25.isNew == true then nil else Theme.Color.NeutralContent,
                        nameTagTextColor = if p25.isNew == true then nil else Theme.Color.BaseContent,
                        activeCommands = v2,
                        onCommandActivate = if p2.onRunPageOpen then function() -- line: 422
                            -- upvalues: commandKey (copy), p2 (copy)
                            p2.onRunPageOpen(commandKey, {
                                showRoles = true
                            })
                        end else nil,
                        trailingButtons = t10
                    })
                end,
                padding = UDim.new(0, 8),
                idle = p2.idle,
                headerGap = UDim.new(0, 8),
                header = p1:New("Frame")({
                    Name = "VetHeader",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = 0,
                    Size = UDim2.fromScale(1, 0),
                    [Children] = {
                        p1:New("UIListLayout")({
                            HorizontalFlex = Enum.UIFlexAlignment.Fill,
                            VerticalFlex = Enum.UIFlexAlignment.None,
                            Padding = UDim.new(0, 8),
                            SortOrder = Enum.SortOrder.LayoutOrder
                        }),
                        InlineToggleRow(p1, {
                            name = "AutoApproveRow",
                            label = "Auto Approve New",
                            layoutOrder = 1,
                            isOn = v11,
                            onToggle = toggleAutoApprove,
                            visible = mayEditSettingsGame
                        }),
                        UnderscoreTabBar(p1, {
                            height = 38,
                            layoutOrder = 2,
                            tabs = t3,
                            activeTab = v48
                        }),
                        SearchBar(p1, {
                            placeholderText = "Search",
                            layoutOrder = 3,
                            searchText = v67
                        })
                    }
                }),
                overlay = v75
            }),
            ConfirmBar(p1, {
                layoutOrder = 999,
                hasPendingChanges = v35,
                confirmChanges = confirmVet,
                undoChanges = function() -- undoChanges | line: 473
                    -- upvalues: v7 (copy), v10 (copy), v11 (copy), v12 (copy), Fusion (copy)
                    v7:set({})
                    v12:set(false)
                    v11:set(Fusion.peek(v10) ~= false)
                end,
                label = p1:Computed(function(p26) -- line: 478
                    -- upvalues: v7 (copy), v8 (copy), v12 (copy)
                    if p26(v8) then
                        return "Saving..."
                    end

                    local n4 = 0
                    local n5 = 0

                    for _, v90 in p26(v7) do
                        if v90 == "approved" then
                            n4 += 1
                        elseif v90 == "disabled" then
                            n5 += 1
                        end
                    end

                    local v91 = if p26(v12) then 1 else 0

                    if v91 == 0 and n4 > 0 and n5 == 0 then
                        return (("%* approved"):format(n4))
                    end

                    if v91 == 0 and n5 > 0 and n4 == 0 then
                        return (("%* disabled"):format(n5))
                    end

                    local v92 = n4 + n5 + v91

                    return (("%* change%*"):format(v92, if v92 == 1 then "" else "s"))
                end)
            })
        }
    })
end
