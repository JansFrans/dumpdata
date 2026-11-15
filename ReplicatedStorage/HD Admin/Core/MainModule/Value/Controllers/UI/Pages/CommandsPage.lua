-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local CommandButton = require(UI.Components.CommandButton)
local ScrollList = require(UI.Components.ScrollList)
local SearchBar = require(UI.Components.SearchBar)
local SearchRowToggle = require(UI.Components.SearchRowToggle)
local HeadingRow = require(UI.Components.HeadingRow)
local Icons = require(UI.Config.Icons)
local CommandAccess = require(UI.Util.CommandAccess)
local RoleInfoPopup = require(UI.Components.RoleInfoPopup)
local VetToggle = require(UI.Components.VetToggle)
local VettingState = require(UI.Config.VettingState)
local Permissions = require(UI.Util.Permissions)
local Remote = require(Modules.Objects.Remote)
local isInternalRole = require(Modules.RoleUtil.isInternalRole)
local GetActiveCommands = Remote.get("GetActiveCommands")
local UpdateActiveCommands = Remote.get("UpdateActiveCommands")

return function(p1, p2) -- line: 56
    -- upvalues: UI (copy), Fusion (copy), Theme (copy), Children (copy), CommandButton (copy), ScrollList (copy), SearchBar (copy), SearchRowToggle (copy), HeadingRow (copy), Icons (copy), CommandAccess (copy), RoleInfoPopup (copy), VetToggle (copy), VettingState (copy), Permissions (copy), isInternalRole (copy), GetActiveCommands (copy), UpdateActiveCommands (copy)
    local Commands = p1:Fuse("everyone", "Commands")
    local RoleInfo = p1:Fuse("everyone", "RoleInfo")
    local YouMember = p1:Fuse("temp", "YouMember")
    local v1 = p1:Fuse("perm", { "YouSettings", "Prefix" })
    local v2 = p1:Value("")
    local v3 = p1:Value({})
    local v4 = p1:Value(nil)

    if not p2.readonly then
        local function refreshActiveCommands() -- line: 67
            -- upvalues: v3 (copy), GetActiveCommands (copy)
            task.defer(function() -- line: 68
                -- upvalues: v3 (copy), GetActiveCommands (copy)
                local _, v5 = GetActiveCommands:invokeServerAsync()

                if type(v5) == "table" then
                    v3:set(v5)
                end
            end)
        end

        if p2.isActive then
            p1:Observer(p2.isActive):onChange(function() -- line: 76
                -- upvalues: p2 (copy), v3 (copy), Fusion (copy), GetActiveCommands (copy)
                if Fusion.peek(p2.isActive) then
                    task.defer(function() -- line: 68
                        -- upvalues: v3 (copy), GetActiveCommands (copy)
                        local _, v6 = GetActiveCommands:invokeServerAsync()

                        if type(v6) == "table" then
                            v3:set(v6)
                        end
                    end)
                end
            end)
        end

        task.defer(function() -- line: 68
            -- upvalues: v3 (copy), GetActiveCommands (copy)
            local _, v7 = GetActiveCommands:invokeServerAsync()

            if type(v7) == "table" then
                v3:set(v7)
            end
        end)

        local v8 = UpdateActiveCommands:onClientEvent(function(p3) -- line: 85
            -- upvalues: v3 (copy)
            if type(p3) == "table" then
                v3:set(p3)
            end
        end)

        table.insert(p1, function() -- line: 90
            -- upvalues: v8 (copy)
            v8:Disconnect()
        end)
    end

    local function cmdPassesSearch(p4, p5) -- line: 95
        if p5 == "" then
            return true
        end

        return p4.name:lower():find(p5, 1, true) ~= nil
    end

    local function cmdHasTag(p6, p7) -- line: 99
        local tags = p6.tags

        if typeof(tags) == "table" then
            for _, v10 in tags do
                if v10 == p7 then
                    return true
                end
            end
        end

        return false
    end

    local function cmdAccessibleByRole(p8, p9) -- line: 107
        local roles = p8.roles

        if typeof(roles) == "table" then
            for _, v11 in roles do
                if v11 == p9 then
                    return true
                end
            end
        end

        return false
    end

    local t1 = {}

    local function getCommandRow(p10, p11) -- line: 119
        -- upvalues: t1 (copy)
        local v13 = (p10 or "") .. "\000" .. tostring(p11.key)
        local v15 = tostring(p11.name) .. "\000" .. tostring(p11.prefix)
        local v16 = t1[v13]

        if not v16 or v16.fingerprint ~= v15 then
            local t2 = {
                isCommandRow = true,
                key = v13,
                entry = p11,
                sectionRole = p10
            }

            t1[v13] = {
                fingerprint = v15,
                row = t2
            }

            return t2
        end

        v16.row.entry = p11

        return v16.row
    end

    local function buildFlat(p12, p13, p14, p15) -- line: 132
        -- upvalues: getCommandRow (copy)
        debug.profilebegin("HD_BuildFlat")

        local t3 = {}

        for _, v17 in p12 do
            if p14 then
                local tags = v17.tags
                local v18

                if typeof(tags) == "table" then
                    local v19 = false

                    for _, v20 in tags do
                        if v20 == p14 then
                            v18 = true
                            v19 = true
                            break
                        end
                    end

                    if not v19 then
                        v18 = false
                    end
                else
                    v18 = false
                end

                if v18 then
                    if p15 then
                        local roles = v17.roles
                        local v21

                        if typeof(roles) == "table" then
                            local v22 = false

                            for _, v23 in roles do
                                if v23 == p15 then
                                    v21 = true
                                    v22 = true
                                    break
                                end
                            end

                            if not v22 then
                                v21 = false
                            end
                        else
                            v21 = false
                        end

                        if v21 and (p13 == "" or v17.name:lower():find(p13, 1, true) ~= nil) then
                            table.insert(t3, (getCommandRow(nil, v17)))
                        end
                    elseif p13 == "" or v17.name:lower():find(p13, 1, true) ~= nil then
                        table.insert(t3, (getCommandRow(nil, v17)))
                    end
                end
            elseif p15 then
                local roles = v17.roles
                local v26

                if typeof(roles) == "table" then
                    local v27 = false

                    for _, v28 in roles do
                        if v28 == p15 then
                            v26 = true
                            v27 = true
                            break
                        end
                    end

                    if not v27 then
                        v26 = false
                    end
                else
                    v26 = false
                end

                if v26 and (p13 == "" or v17.name:lower():find(p13, 1, true) ~= nil) then
                    table.insert(t3, (getCommandRow(nil, v17)))
                end
            elseif p13 == "" or v17.name:lower():find(p13, 1, true) ~= nil then
                table.insert(t3, (getCommandRow(nil, v17)))
            end
        end

        debug.profileend()

        return t3
    end

    local t4 = {}

    local function getHeader(p16) -- line: 146
        -- upvalues: t4 (copy)
        local v31 = t4[p16.key]

        if v31 and v31.name == p16.name and v31.color == p16.color then
            return v31
        end

        local t5 = {
            isHeader = true,
            key = "__role_" .. p16.key,
            roleKey = p16.key,
            name = p16.name,
            color = p16.color
        }

        t4[p16.key] = t5

        return t5
    end

    local t6 = {}

    local function getSpacer(p17) -- line: 163
        -- upvalues: t6 (copy)
        local v32 = t6[p17]

        if v32 then
            return v32
        end

        local t7 = {
            isSpacer = true,
            key = "__spacer_" .. p17
        }

        t6[p17] = t7

        return t7
    end

    local YouMember2 = p1:Fuse("temp", "YouMember")
    local RoleInfo2 = p1:Fuse("everyone", "RoleInfo")

    local function bestGiverForRole(p18) -- line: 175
        -- upvalues: CommandAccess (copy)
        return CommandAccess.bestGiverForRole(p18)
    end

    local function roleInheritsJuniors(p19, p20) -- line: 180
        if typeof(p19) ~= "table" or typeof(p20) ~= "string" then
            return false
        end

        local v33 = p19[p20]

        if typeof(v33) == "table" then
            return v33.inheritCommandsFromJuniorRoles == true
        end

        return false
    end

    local function makeUnlockStateComputed(p21) -- line: 186
        -- upvalues: p1 (copy), YouMember2 (copy), RoleInfo2 (copy), CommandAccess (copy)
        if p21 == "" then
            return nil
        end

        return p1:Computed(function(p22) -- line: 188
            -- upvalues: p21 (copy), YouMember2 (copy), RoleInfo2 (copy), CommandAccess (copy)
            return CommandAccess.unlockStateForRole(p22(YouMember2), p22(RoleInfo2), p21)
        end)
    end

    local function onUnlockRole(p23) -- line: 193
        -- upvalues: RoleInfo2 (copy), Fusion (copy), CommandAccess (copy)
        CommandAccess.promptUnlock(Fusion.peek(RoleInfo2), p23)
    end

    local v34 = p2.activeRoleFilter or p1:Value(nil)
    local v35, CanvasPosition
    local t8 = {}
    local t9 = {}
    local v36 = p1:Value(nil)
    local v37 = p1:Value(nil)
    local v38 = p1:Computed(function(p24) -- line: 209
        -- upvalues: v36 (copy), v37 (copy), v34 (copy)
        local v39 = p24(v37)

        if v39 ~= nil then
            return v39
        end

        local v40 = p24(v34)

        if not v40 or v40 == "" then
            return p24(v36)
        end

        return v40
    end)

    local function rebuildOrderedKeys() -- line: 219
        -- upvalues: RoleInfo (copy), t9 (ref), Fusion (copy), isInternalRole (copy)
        local v41 = Fusion.peek(RoleInfo)

        if typeof(v41) ~= "table" then
            t9 = {}

            return
        end

        local t10 = {}

        for _, v42 in v41 do
            if not isInternalRole(v42) then
                table.insert(t10, v42)
            end
        end

        table.sort(t10, function(p25, p26) -- line: 230
            if p25.rank == p26.rank then
                return p25.key < p26.key
            end

            return p25.rank < p26.rank
        end)

        local t11 = {}

        for _, v43 in t10 do
            table.insert(t11, v43.key)
        end

        t9 = t11
    end

    rebuildOrderedKeys()

    local function updateStickyHeader() -- line: 244
        -- upvalues: v35 (ref), t8 (copy), t9 (ref), v36 (copy), Fusion (copy)
        local v44 = v35

        if v44 then
            if v44.CanvasPosition.Y <= 0 then
                if Fusion.peek(v36) ~= nil then
                    v36:set(nil)
                end
            else
                debug.profilebegin("HD_StickyHeader")

                local Y = v44.AbsolutePosition.Y
                local v45

                for _, v46 in t9 do
                    local v47 = t8[v46]

                    if v47 and v47.Visible then
                        if not (Y + (if v45 == nil then 0 else 12) >= v47.AbsolutePosition.Y) then
                            break
                        end

                        v45 = v46
                    end
                end

                if Fusion.peek(v36) ~= v45 then
                    v36:set(v45)
                end

                debug.profileend()
            end
        end
    end

    local function deferredUpdateStickyHeader() -- line: 276
        -- upvalues: updateStickyHeader (copy)
        task.spawn(function() -- line: 277
            -- upvalues: updateStickyHeader (copy)
            task.wait()
            updateStickyHeader()
        end)
    end

    p1:Observer(RoleInfo):onBind(function() -- line: 283
        -- upvalues: rebuildOrderedKeys (copy), updateStickyHeader (copy)
        rebuildOrderedKeys()
        task.spawn(function() -- line: 277
            -- upvalues: updateStickyHeader (copy)
            task.wait()
            updateStickyHeader()
        end)
    end)
    p1:Observer(v34):onChange(deferredUpdateStickyHeader)
    p1:Observer(v2):onChange(deferredUpdateStickyHeader)

    if p2.filterRole then
        p1:Observer(p2.filterRole):onChange(deferredUpdateStickyHeader)
    end

    if p2.filterTag then
        p1:Observer(p2.filterTag):onChange(deferredUpdateStickyHeader)
    end

    local v48 = p1:Value(false)
    local v49 = p1:Value("")

    local function openRoleInfoPopup(p27) -- line: 298
        -- upvalues: v48 (copy), v49 (copy)
        v49:set(p27)
        v48:set(true)
    end

    local v50 = Fusion.peek(v34)

    p1:Observer(v34):onChange(function() -- line: 304
        -- upvalues: v35 (ref), CanvasPosition (ref), v37 (copy), v34 (copy), updateStickyHeader (copy), v50 (ref), Fusion (copy)
        local v51 = Fusion.peek(v34)
        local v52 = if typeof(v51) ~= "string" or v51 == "" then nil else v51
        local v54 = if typeof(v50) ~= "string" or v50 == "" then nil else v50

        v50 = v51

        if v54 ~= v52 then
            if v52 ~= nil then
                if v54 == nil and v35 then
                    CanvasPosition = v35.CanvasPosition
                end

                if v35 then
                    v35.CanvasPosition = Vector2.zero
                end
            else
                if v54 then
                    v37:set(v54)
                end

                local CanvasPosition2 = CanvasPosition

                CanvasPosition = nil
                task.spawn(function() -- line: 324
                    -- upvalues: CanvasPosition2 (copy), v35 (ref), v37 (copy), updateStickyHeader (copy)
                    task.wait()

                    if CanvasPosition2 and v35 then
                        v35.CanvasPosition = CanvasPosition2

                        local v56 = math.max(0, CanvasPosition2.Y - 1)

                        for i = 1, 16 do
                            task.wait()

                            local v57 = v35

                            if i % 2 == 1 then
                                v57.CanvasPosition = Vector2.new(CanvasPosition2.X, v56)
                            else
                                v57.CanvasPosition = CanvasPosition2
                            end
                        end
                    end

                    for _ = 1, 5 do
                        task.wait()
                        updateStickyHeader()
                    end

                    v37:set(nil)
                end)
            end
        end
    end)

    local v59 = p1:Computed(function(p28) -- line: 348
        -- upvalues: v34 (copy), v38 (copy)
        local v60 = p28(v38)

        return v60 ~= nil and p28(v34) == v60
    end)
    local v61 = p1:Computed(function(p29) -- line: 354
        -- upvalues: v38 (copy)
        local v62 = p29(v38)

        if v62 then
            return {
                color = nil,
                key = v62,
                name = v62
            }
        end

        return {
            key = "",
            name = "",
            color = nil
        }
    end)
    local v63 = p1:New("Frame")
    local t12 = {
        Name = "StickyRoleHeader",
        AnchorPoint = Vector2.new(0, 0),
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, 0, 0, 44),
        Visible = p1:Computed(function(p30) -- line: 368
            -- upvalues: v38 (copy)
            return p30(v38) ~= nil
        end)
    }

    t12[Children] = {
        p1:New("Frame")({
            Name = "BackgroundBlock",
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Theme.Color.Base,
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(1, 10, 0, 38)
        }),
        HeadingRow(p1, {
            hideDrag = true,
            hintText = "Inherits commands from junior roles",
            entry = v61,
            roleInfoFuse = RoleInfo,
            active = v59,
            nameFontWeight = Theme.FontWeight.Bold,
            unlockState = p1:Computed(function(p31) -- line: 388
                -- upvalues: YouMember2 (copy), RoleInfo2 (copy), v38 (copy), CommandAccess (copy)
                local v65 = p31(v38)

                if v65 and v65 ~= "" then
                    local v66 = p31(YouMember2)

                    if typeof(v66) == "table" and typeof(v66.roleKeys) == "table" then
                        for _, v67 in v66.roleKeys do
                            if v67 == v65 then
                                return "unlocked"
                            end
                        end
                    end

                    local v68 = p31(RoleInfo2)

                    if typeof(v68) == "table" then
                        local v69 = v68[v65]

                        if CommandAccess.bestGiverForRole(v69) then
                            return "unlock"
                        end
                    end
                end

                return nil
            end),
            onUnlock = onUnlockRole,
            onActivate = openRoleInfoPopup,
            hintIcon = p1:Computed(function(p32) -- line: 403
                -- upvalues: RoleInfo2 (copy), v38 (copy), Icons (copy)
                local v70 = p32(RoleInfo2)
                local v71 = p32(v38)

                if typeof(v70) == "table" and typeof(v71) == "string" then
                    local v72 = v70[v71]

                    if typeof(v72) == "table" and v72.inheritCommandsFromJuniorRoles == true then
                        return Icons.InheritJuniors
                    end
                end

                return nil
            end)
        }),
        p1:New("Frame")({
            Name = "GapExtension",
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Theme.Color.Base,
            Position = UDim2.new(0.5, 0, 0, 38),
            Size = UDim2.new(1, 10, 0, 6)
        })
    }
    v63 = v63(t12)

    local function buildGrouped(p33, p34, p35, p36, p37) -- line: 422
        -- upvalues: getCommandRow (copy), getHeader (copy), t6 (copy), CommandAccess (copy), isInternalRole (copy)
        debug.profilebegin("HD_BuildGrouped")

        local t13 = {}

        if typeof(p37) == "table" and typeof(p37.roleKeys) == "table" then
            for _, v73 in p37.roleKeys do
                t13[v73] = true
            end
        end

        local v74 = CommandAccess.mayViewAll(p37, p35)
        local t14 = {}

        local function isSectionVisible(p38) -- line: 434
            -- upvalues: p35 (copy), t13 (copy), v74 (copy), t14 (copy), CommandAccess (copy)
            local v75 = t14[p38]

            if v75 ~= nil then
                return v75
            end

            local v76 = v74

            if not v74 then
                if t13[p38] == true then
                    v76 = true
                else
                    local v77 = p35[p38]

                    v76 = CommandAccess.bestGiverForRole(v77) ~= nil
                end
            end

            t14[p38] = v76

            return v76
        end

        local t15 = {}

        for _, v78 in p33 do
            local directRoles = v78.directRoles

            if typeof(directRoles) == "table" and (p34 == "" or v78.name:lower():find(p34, 1, true) ~= nil) then
                for _, v79 in directRoles do
                    if typeof(v79) == "string" and p35[v79] and (p36 == nil or v79 == p36) then
                        local v80 = t14[v79]

                        if v80 == nil then
                            if v74 then
                                v80 = v74
                            elseif t13[v79] == true then
                                v80 = true
                            else
                                local v81 = p35[v79]

                                v80 = CommandAccess.bestGiverForRole(v81) ~= nil
                            end

                            t14[v79] = v80
                        end

                        if v80 then
                            local v82 = t15[v79]

                            if not v82 then
                                v82 = {}
                                t15[v79] = v82
                            end

                            table.insert(v82, (getCommandRow(v79, v78)))
                        end
                    end
                end
            end
        end

        local t16 = {}

        for _, v84 in p35 do
            if not isInternalRole(v84) and (p36 == nil or v84.key == p36) then
                table.insert(t16, v84)
            end
        end

        table.sort(t16, function(p39, p40) -- line: 465
            if p39.rank == p40.rank then
                return p39.key < p40.key
            end

            return p39.rank < p40.rank
        end)

        local t17 = {}

        for _, v85 in t16 do
            local v86 = t15[v85.key]

            if v86 and #v86 ~= 0 then
                local key = v85.key
                local v87 = t6[key]

                if not v87 then
                    v87 = {
                        isSpacer = true,
                        key = "__spacer_" .. key
                    }
                    t6[key] = v87
                end

                table.insert(t17, v87)
                table.insert(t17, (getHeader(v85)))

                for _, v89 in v86 do
                    table.insert(t17, v89)
                end
            end
        end

        debug.profileend()

        return t17
    end

    local mayVetCommands = Permissions.hasPermission(p1, "mayVetCommands")
    local CommandVetting = p1:Fuse("everyone", "CommandVetting")
    local v90 = p1:Computed(function(p41) -- line: 487
        -- upvalues: Commands (copy), RoleInfo (copy), YouMember (copy), CommandVetting (copy), CommandAccess (copy)
        debug.profilebegin("HD_BuildViewable")

        local v91 = CommandAccess.buildViewable(p41(Commands), p41(YouMember), p41(RoleInfo))

        debug.profileend()

        local v92 = p41(CommandVetting)
        local states = if typeof(v92) == "table" then v92.states else nil

        if typeof(states) ~= "table" or next(states) == nil then
            return v91
        end

        local t18 = {}

        for _, v93 in v91 do
            local v94 = v93.identity or v93.key
            local v95 = if typeof(v94) == "string" then states[v94] else nil

            if v95 ~= "disabled" and v95 ~= "pending" then
                table.insert(t18, v93)
            end
        end

        return t18
    end)
    local v96 = p1:Computed(function(p42) -- line: 508
        -- upvalues: p2 (copy), RoleInfo (copy), YouMember (copy), v2 (copy), buildFlat (copy), v34 (copy), buildGrouped (copy), v90 (copy)
        local v97 = p42(v90)

        if type(v97) ~= "table" then
            return {}
        end

        local v98 = p42(v2):lower()
        local v99 = if p2.filterTag then p42(p2.filterTag) else nil

        if v99 == "" then
            v99 = nil
        end

        local v100 = if p2.filterRole then p42(p2.filterRole) else nil

        if v100 == "" then
            v100 = nil
        end

        if v99 or v100 then
            return (buildFlat(v97, v98, v99, v100))
        end

        local v101 = p42(RoleInfo)

        if typeof(v101) ~= "table" then
            return {}
        end

        local v102 = p42(v34)

        if not v102 or v102 == "" then
            return (buildGrouped(v97, v98, v101, nil, p42(YouMember)))
        end

        local t19 = {}

        for _, v103 in (buildGrouped(v97, v98, v101, nil, p42(YouMember))) do
            if v103.isCommandRow == true then
                local roles = v103.entry.roles
                local v104

                if typeof(roles) == "table" then
                    local v105 = false

                    for _, v106 in roles do
                        if v106 == v102 then
                            v104 = true
                            v105 = true
                            break
                        end
                    end

                    if not v105 then
                        v104 = false
                    end
                else
                    v104 = false
                end

                if v104 then
                    table.insert(t19, v103)
                end
            end
        end

        return t19
    end)
    local v64 = p1:Computed(function(p43) -- line: 537
        -- upvalues: p2 (copy), RoleInfo (copy), YouMember (copy), buildFlat (copy), buildGrouped (copy), v90 (copy)
        local v107 = p43(v90)

        if type(v107) ~= "table" then
            return {}
        end

        local v108 = if p2.filterTag then p43(p2.filterTag) else nil

        if v108 == "" then
            v108 = nil
        end

        local v109 = if p2.filterRole then p43(p2.filterRole) else nil

        if v109 == "" then
            v109 = nil
        end

        if v108 or v109 then
            return (buildFlat(v107, "", v108, v109))
        end

        local v110 = p43(RoleInfo)

        if typeof(v110) == "table" then
            return (buildGrouped(v107, "", v110, nil, p43(YouMember)))
        end

        return {}
    end)
    local CmdbarState = require(UI.Config.CmdbarState)
    local visible = CmdbarState.visible
    local Frame = p1:New("Frame")
    local t20 = {
        Name = "Commands",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0)
    }
    local v111 = p1:New("UIPadding")({
        PaddingBottom = UDim.new(0, 1),
        PaddingLeft = UDim.new(0, 1),
        PaddingRight = UDim.new(0, 1),
        PaddingTop = UDim.new(0, 1)
    })
    local v112 = p1:New("UIListLayout")({
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local t21 = {
        layoutOrder = 1,
        paddingRight = 10,
        isReady = p1:Computed(function(p44) -- line: 575
            -- upvalues: Commands (copy)
            local v113 = p44(Commands)

            if type(v113) == "table" then
                return next(v113) ~= nil
            end

            return false
        end),
        items = v64,
        visibleItems = v96,
        itemKey = function(p45) -- itemKey | line: 583
            return (tostring(p45.key))
        end,
        renderItem = function(p46, p47) -- renderItem | line: 586
            -- upvalues: p1 (copy), p2 (copy), RoleInfo (copy), v1 (copy), v3 (copy), v4 (copy), YouMember2 (copy), RoleInfo2 (copy), onUnlockRole (copy), t8 (copy), v34 (copy), updateStickyHeader (copy), openRoleInfoPopup (copy), Fusion (copy), Theme (copy), CommandButton (copy), HeadingRow (copy), Icons (copy), CommandAccess (copy)
            if p47.isSpacer == true then
                return p46:New("Frame")({
                    Name = "RoleGroupSpacer",
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0)
                })
            end

            if p47.isHeader == true then
                local roleKey = p47.roleKey
                local v114 = p46:Computed(function(p48) -- line: 596
                    -- upvalues: roleKey (copy), v34 (copy)
                    return p48(v34) == roleKey
                end)
                local v117 = HeadingRow(p46, {
                    hideDrag = true,
                    hintText = "Inherits commands from junior roles",
                    entry = {
                        key = roleKey,
                        name = p47.name,
                        color = p47.color
                    },
                    roleInfoFuse = RoleInfo,
                    active = v114,
                    nameFontWeight = Theme.FontWeight.Bold,
                    onActivate = openRoleInfoPopup,
                    unlockState = if roleKey == "" then nil else p1:Computed(function(p49) -- line: 188
                        -- upvalues: roleKey (copy), YouMember2 (copy), RoleInfo2 (copy), CommandAccess (copy)
                        return CommandAccess.unlockStateForRole(p49(YouMember2), p49(RoleInfo2), roleKey)
                    end),
                    onUnlock = onUnlockRole,
                    hintIcon = p46:Computed(function(p50) -- line: 612
                        -- upvalues: roleKey (copy), RoleInfo2 (copy), Icons (copy)
                        local v115 = p50(RoleInfo2)

                        if typeof(v115) == "table" and typeof(roleKey) == "string" then
                            local v116 = v115[roleKey]

                            if typeof(v116) == "table" and v116.inheritCommandsFromJuniorRoles == true then
                                return Icons.InheritJuniors
                            end
                        end

                        return nil
                    end)
                })

                t8[roleKey] = v117
                table.insert(p46, function() -- line: 620
                    -- upvalues: roleKey (copy), v117 (copy), t8 (copy), updateStickyHeader (copy)
                    if t8[roleKey] == v117 then
                        t8[roleKey] = nil
                    end

                    task.spawn(function() -- line: 277
                        -- upvalues: updateStickyHeader (copy)
                        task.wait()
                        updateStickyHeader()
                    end)
                end)
                task.spawn(function() -- line: 277
                    -- upvalues: updateStickyHeader (copy)
                    task.wait()
                    updateStickyHeader()
                end)

                return v117
            end

            local sectionRole
            local v119 = p47
            local entry, sectionRole2

            if p47.isCommandRow == true then
                local sectionRole3 = p47.sectionRole

                sectionRole2 = sectionRole3
                sectionRole = sectionRole3
                entry = p47.entry
                v119 = entry
            else
                entry = p47
            end

            return CommandButton(p46, {
                commandKey = entry.key,
                commandName = entry.name,
                commandPrefix = entry.prefix,
                customPrefix = v1,
                unlockRole = sectionRole2,
                activeCommands = v3,
                loading = p46:Computed(function(p51) -- line: 642
                    -- upvalues: v119 (ref), v4 (copy)
                    return p51(v4) == v119.key
                end),
                onCommandActivate = if p2.readonly == true then nil
                    elseif p2.onRunPageOpen then function() -- line: 648
                        -- upvalues: sectionRole (ref), v119 (ref), p2 (copy), v4 (copy), Fusion (copy)
                        v4:set(v119.key)
                        p2.onRunPageOpen(v119.key, {
                            unlockRole = sectionRole,
                            onSettled = function() -- onSettled | line: 652
                                -- upvalues: v119 (ref), v4 (copy), Fusion (copy)
                                if Fusion.peek(v4) == v119.key then
                                    v4:set(nil)
                                end
                            end
                        })
                    end
                    else nil
            })
        end,
        padding = UDim.new(0, 8),
        idle = p2.idle,
        headerGap = UDim.new(0, 8),
        overlay = v63,
        onScrollerReady = function(p52) -- onScrollerReady | line: 668
            -- upvalues: p1 (copy), v35 (ref), v34 (copy), updateStickyHeader (copy), Fusion (copy)
            v35 = p52

            local connection = p52:GetPropertyChangedSignal("CanvasPosition"):Connect(updateStickyHeader)

            table.insert(p1, function() -- line: 671
                -- upvalues: connection (copy)
                connection:Disconnect()
            end)

            local v121 = Fusion.peek(v34)

            if v121 and v121 ~= "" then
                p52.CanvasPosition = Vector2.zero
            end

            task.spawn(function() -- line: 277
                -- upvalues: updateStickyHeader (copy)
                task.wait()
                updateStickyHeader()
            end)
        end
    }
    local Frame2 = p1:New("Frame")
    local t24 = {
        Name = "HeaderArea",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 0,
        Size = UDim2.fromScale(1, 0)
    }
    local v122 = p1:New("UIListLayout")({
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v123 = p1:New("Frame")({
        Name = "StickySpacer",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 1,
        Size = p1:Computed(function(p53) -- line: 695
            -- upvalues: v34 (copy)
            local v124 = p53(v34)
            local v125 = v124 ~= nil and v124 ~= ""

            return UDim2.new(1, 0, 0, if v125 then 44 else 0)
        end)
    })

    t24[Children] = {
        v122,
        v123,
        SearchBar(p1, {
            placeholderText = "Search",
            layoutOrder = 2,
            searchText = v2,
            gap = UDim.new(0, 8),
            slot = if p2.readonly == true then nil else p1:New("Frame")({
                Name = "SearchToggles",
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0, 1),
                [Children] = {
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    VetToggle(p1, {
                        isActive = false,
                        layoutOrder = 1,
                        isVisible = mayVetCommands,
                        onActivate = function() -- onActivate | line: 723
                            -- upvalues: VettingState (copy)
                            VettingState.open()
                        end
                    }),
                    SearchRowToggle(p1, {
                        name = "CommandBarToggle",
                        layoutOrder = 2,
                        icon = Icons.CmdbarDeselected,
                        activeIcon = Icons.CmdbarSelected,
                        isActive = visible,
                        isVisible = CmdbarState.canOpen,
                        onActivate = function() -- onActivate | line: 734
                            -- upvalues: CmdbarState (copy)
                            CmdbarState.toggle()
                        end
                    })
                }
            }),
            slotVisible = p1:Computed(function(p54) -- line: 740
                -- upvalues: p2 (copy), v34 (copy), mayVetCommands (copy), CmdbarState (copy)
                if p2.readonly == true then
                    return false
                end

                local v128 = p54(v34)

                if v128 ~= nil and v128 ~= "" then
                    return false
                end

                return p54(CmdbarState.canOpen) or p54(mayVetCommands)
            end)
        })
    }
    t21.header = Frame2(t24)
    t20[Children] = {
        v111,
        v112,
        ScrollList(p1, t21),
        p1:New("Folder")({
            Name = "RoleInfoPopupHolder",
            [Children] = {
                RoleInfoPopup(p1, {
                    visible = v48,
                    roleKey = v49,
                    roleInfoFuse = RoleInfo,
                    youMemberFuse = YouMember,
                    commandsFuse = Commands
                })
            }
        })
    }

    return Frame(t20)
end
