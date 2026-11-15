-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local Icons = require(UI.Config.Icons)
local t1 = {
    {
        label = "Members",
        icon = Icons.ShieldPersonFill
    },
    {
        label = "Roles",
        icon = Icons.TagFill
    }
}
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local UserDetails = require(UI.Components.UserDetails)
local SplitRow = require(UI.Components.SplitRow)

require(UI.Components.TabBar)

local UnderscoreTabBar = require(UI.Components.UnderscoreTabBar)
local TabbedScroller = require(UI.Components.TabbedScroller)
local Pressable = require(UI.Components.Pressable)
local SearchRowToggle = require(UI.Components.SearchRowToggle)
local InlineToggleRow = require(UI.Components.InlineToggleRow)
local LoadingSpinner = require(UI.Components.LoadingSpinner)
local HeadingRow = require(UI.Components.HeadingRow)
local StreamList = require(UI.Components.StreamList)
local SearchBar = require(UI.Components.SearchBar)
local LoadingGate = require(UI.Components.LoadingGate)
local extractGivers = require(UI.Util.extractGivers)
local stableRows = require(UI.Util.stableRows)
local Permissions = require(UI.Util.Permissions)
local isInternalRole = require(Modules.RoleUtil.isInternalRole)
local NoPermissionPlaceholder = require(UI.Components.NoPermissionPlaceholder)
local ScrollLock = require(UI.Util.ScrollLock)
local Remote = require(Modules.Objects.Remote)
local clientUser = require(Modules.References.clientUser)
local Children = Fusion.Children
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local onDragMove, onDragEnd
local v1 = false
local n1 = 0
local n2 = 0

local function roleKeysFingerprint(p1, p2) -- line: 77
    -- upvalues: isInternalRole (copy)
    local t2 = {}

    for _, v2 in p2 do
        local v3 = if typeof(p1) == "table" then p1[v2] else nil
        local v4 = ""

        if typeof(v3) == "table" then
            v4 = if isInternalRole(v3) then "x" elseif typeof(v3.color) == "Color3" then v3.color:ToHex() else ""
        end

        table.insert(t2, v2 .. v4)
    end

    return table.concat(t2, ",")
end

local function memberFingerprint(p3, p4) -- line: 92
    -- upvalues: roleKeysFingerprint (copy)
    return (("%*|%*|%*|%*"):format(p4.userId, p4.userName, p4.userDisplayName, (roleKeysFingerprint(p3, p4.roleKeys))))
end

local function giverFingerprint(p5, p6) -- line: 96
    -- upvalues: roleKeysFingerprint (copy)
    return (("%*|%*|%*|%*"):format(p6.type, p6.id, p6.name, (roleKeysFingerprint(p5, p6.roleKeys))))
end

local function memberItemKey(p7) -- line: 100
    if p7.isGiver then
        return (("giver:%*:%*"):format(p7.giver.type, p7.giver.id))
    end

    return (("member:%*"):format(p7.member.userId))
end

local function ensureDragListeners() -- line: 108
    -- upvalues: UserInputService (copy), onDragMove (ref), onDragEnd (ref), v1 (ref), n1 (ref), n2 (ref)
    if v1 then
        return
    end

    v1 = true
    game:GetService("RunService").Heartbeat:Connect(function() -- line: 112
        -- upvalues: n2 (ref)
        n2 += 1
    end)
    UserInputService.InputChanged:Connect(function(p8) -- line: 116
        -- upvalues: onDragMove (ref)
        local onDragMove2 = onDragMove

        if onDragMove2 and (p8.UserInputType == Enum.UserInputType.MouseMovement or p8.UserInputType == Enum.UserInputType.Touch) then
            onDragMove2(p8)
        end
    end)
    UserInputService.InputEnded:Connect(function(p9) -- line: 123
        -- upvalues: onDragEnd (ref)
        local onDragEnd2 = onDragEnd

        if onDragEnd2 and (p9.UserInputType == Enum.UserInputType.MouseButton1 or p9.UserInputType == Enum.UserInputType.Touch) then
            onDragEnd2(p9)
        end
    end)
    UserInputService.InputBegan:Connect(function(p10) -- line: 131
        -- upvalues: onDragEnd (ref), n1 (ref), n2 (ref)
        if not (n2 <= n1) then
            local onDragEnd2 = onDragEnd

            if onDragEnd2 and (p10.UserInputType == Enum.UserInputType.MouseButton1 or p10.UserInputType == Enum.UserInputType.Touch) then
                onDragEnd2(p10)
            end
        end
    end)
    UserInputService.WindowFocusReleased:Connect(function() -- line: 139
        -- upvalues: onDragEnd (ref)
        local onDragEnd2 = onDragEnd

        if onDragEnd2 then
            onDragEnd2(nil)
        end
    end)
end

return function(p11, p12) -- line: 149
    -- upvalues: Modules (copy), Icons (copy), t1 (copy), Fusion (copy), Theme (copy), UserDetails (copy), SplitRow (copy), UnderscoreTabBar (copy), TabbedScroller (copy), Pressable (copy), SearchRowToggle (copy), InlineToggleRow (copy), LoadingSpinner (copy), HeadingRow (copy), StreamList (copy), SearchBar (copy), LoadingGate (copy), extractGivers (copy), stableRows (copy), Permissions (copy), isInternalRole (copy), NoPermissionPlaceholder (copy), ScrollLock (copy), Remote (copy), clientUser (copy), Children (copy), Players (copy), onDragMove (ref), onDragEnd (ref), n1 (ref), n2 (ref), roleKeysFingerprint (copy), memberItemKey (copy), ensureDragListeners (copy)
    local Roles = p11:Fuse("everyone", "Roles")
    local DefaultRoleInfo = p11:Fuse("everyone", "DefaultRoleInfo")
    local SavedRoles = p11:Fuse("everyone", "SavedRoles")
    local SavedRoleInfo = p11:Fuse("everyone", "SavedRoleInfo")
    local v6 = p11:Fuse("everyone", { "GameSettings", "SystemSettings", "UseDefaultRoles" })
    local v7 = p11:Computed(function(p13) -- line: 158
        -- upvalues: Roles (copy)
        return typeof((p13(Roles))) == "table"
    end)
    local v9 = p11:Value(Fusion.peek(v6) == true)
    local v10 = p11:Value({})
    local v11 = p11:Computed(function(p14) -- line: 171
        -- upvalues: DefaultRoleInfo (copy), SavedRoles (copy), v9 (copy), v10 (copy), isInternalRole (copy)
        local v12 = p14(v10)
        local v13 = p14(v9) == true
        local v14 = p14(SavedRoles)
        local v15 = p14(DefaultRoleInfo)
        local t3 = {}

        if typeof(v14) == "table" then
            for _, v16 in v14 do
                if typeof(v16) == "table" and typeof(v16.key) == "string" then
                    t3[v16.key] = v16
                end
            end
        end

        local t4 = {}

        for _, v17 in v12 do
            local v18

            if v13 then
                if typeof(v15) == "table" then
                    local v19 = v15[v17]

                    if typeof(v19) == "table" then
                        v18 = {
                            key = v17,
                            name = v19.name or v17,
                            color = v19.color,
                            hide = v19.hide
                        }
                    end
                end
            else
                v18 = t3[v17]

                if v18 == nil and typeof(v15) == "table" then
                    local v20 = v15[v17]

                    if typeof(v20) == "table" then
                        v18 = {
                            key = v17,
                            name = v20.name or v17,
                            color = v20.color,
                            hide = v20.hide
                        }
                    end
                end
            end

            if typeof(v18) == "table" and v18.hide ~= true then
                table.insert(t4, v18)
            end
        end

        if #t4 == 0 and #v12 == 0 and typeof(v14) == "table" then
            for _, v21 in v14 do
                if typeof(v21) == "table" and v21.hide ~= true and not isInternalRole(v21) then
                    table.insert(t4, v21)
                end
            end
        end

        return t4
    end)
    local onRoleActivate, onMemberActivate = p12.onRoleActivate, p12.onMemberActivate
    local YouMember = p11:Fuse("temp", "YouMember")
    local ServerMembers = p11:Fuse("everyone", "ServerMembers")
    local PermanentMembers = p11:Fuse("everyone", "PermanentMembers")
    local RoleInfo = p11:Fuse("everyone", "RoleInfo")
    local _ = Players.LocalPlayer.UserId

    if p12.onRunPageOpen then
        task.spawn(function() -- line: 230
            -- upvalues: clientUser (copy)
            clientUser.everyone:fetchAsync("CommandInfo", "givepermrole")
        end)
    end

    local v22, v23 = stableRows()
    local v24, v25 = stableRows()

    local function topRankOfKeys(p15, p16) -- line: 238
        local v26

        if typeof(p15) ~= "table" or typeof(p16) ~= "table" then
            v26 = 0

            return v26
        end

        local n3 = 0
        local v27 = false

        v26 = 0

        for _, v28 in p16 do
            local v29 = p15[v28]

            if typeof(v29) == "table" and typeof(v29.rank) == "number" then
                local rank = v29.rank

                if not v27 or n3 < rank then
                    n3 = rank
                    v27 = true
                end
            end

            v26 = n3
        end

        return v26
    end

    local v30 = p11:Computed(function(p17) -- line: 256
        -- upvalues: ServerMembers (copy), RoleInfo (copy), v22 (copy), v23 (copy), roleKeysFingerprint (copy)
        local v31 = p17(ServerMembers)
        local v32 = p17(RoleInfo)
        local t5 = {}

        if typeof(v31) == "table" then
            for _, v33 in v31 do
                if typeof(v33) == "table" and typeof(v33.userId) == "number" then
                    table.insert(t5, v33)
                end
            end

            table.sort(t5, function(p18, p19) -- line: 266
                return (p18.userDisplayName or "") < (p19.userDisplayName or "")
            end)
        end

        local t6 = {}

        for _, v34 in t5 do
            table.insert(t6, v22(("member:%*"):format(v34.userId), ("%*|%*|%*|%*"):format(v34.userId, v34.userName, v34.userDisplayName, (roleKeysFingerprint(v32, v34.roleKeys))), function() -- line: 272
                -- upvalues: v34 (copy)
                return {
                    isMember = true,
                    sectionKey = "Server",
                    member = v34
                }
            end))
        end

        v23()

        return t6
    end)
    local v38 = p11:Computed(function(p20) -- line: 280
        -- upvalues: PermanentMembers (copy), RoleInfo (copy), v24 (copy), v25 (copy), topRankOfKeys (copy), extractGivers (copy), roleKeysFingerprint (copy)
        local v39 = p20(RoleInfo)
        local t7 = {}
        local v40 = extractGivers.extract(v39)

        table.sort(v40, function(p21, p22) -- line: 286
            -- upvalues: v39 (copy), topRankOfKeys (copy)
            local v41 = topRankOfKeys(v39, p21.roleKeys)
            local v42 = topRankOfKeys(v39, p22.roleKeys)

            if v41 == v42 then
                return (p21.name or "") < (p22.name or "")
            end

            return v42 < v41
        end)

        for _, v43 in v40 do
            table.insert(t7, v24(("giver:%*:%*"):format(v43.type, v43.id), ("%*|%*|%*|%*"):format(v43.type, v43.id, v43.name, (roleKeysFingerprint(v39, v43.roleKeys))), function() -- line: 293
                -- upvalues: v43 (copy)
                return {
                    isGiver = true,
                    sectionKey = "Permanent",
                    giver = v43
                }
            end))
        end

        local v47 = p20(PermanentMembers)
        local t8 = {}

        if typeof(v47) == "table" then
            for _, v48 in v47 do
                if typeof(v48) == "table" and typeof(v48.userId) == "number" then
                    table.insert(t8, v48)
                end
            end

            table.sort(t8, function(p23, p24) -- line: 306
                -- upvalues: v39 (copy), topRankOfKeys (copy)
                local v49 = topRankOfKeys(v39, p23.roleKeys)
                local v50 = topRankOfKeys(v39, p24.roleKeys)

                if v49 == v50 then
                    return (p23.userDisplayName or "") < (p24.userDisplayName or "")
                end

                return v50 < v49
            end)
        end

        for _, v51 in t8 do
            table.insert(t7, v24(("member:%*"):format(v51.userId), ("%*|%*|%*|%*"):format(v51.userId, v51.userName, v51.userDisplayName, (roleKeysFingerprint(v39, v51.roleKeys))), function() -- line: 314
                -- upvalues: v51 (copy)
                return {
                    isMember = true,
                    sectionKey = "Permanent",
                    member = v51
                }
            end))
        end

        v25()

        return t7
    end)
    local v55 = p11:Value("")
    local v56 = p11:Value("")

    local function filterMembersByText(p25, p26) -- line: 324
        local v57 = string.lower(p26)

        if v57 == "" then
            return p25
        end

        local t9 = {}

        for _, v58 in p25 do
            if v58.isGiver then
                local giver = v58.giver

                if typeof(giver) == "table" then
                    local v59 = string.lower(giver.name or "")
                    local v60 = string.lower(giver.id or "")

                    if string.find(v59, v57, 1, true) or string.find(v60, v57, 1, true) then
                        table.insert(t9, v58)
                    end
                end
            elseif v58.isMember then
                local member = v58.member

                if typeof(member) == "table" then
                    local v61 = string.lower(member.userName or "")
                    local v62 = string.lower(member.userDisplayName or "")

                    if string.find(v61, v57, 1, true) or string.find(v62, v57, 1, true) then
                        table.insert(t9, v58)
                    end
                end
            end
        end

        return t9
    end

    local v63 = p11:Computed(function(p27) -- line: 350
        -- upvalues: v30 (copy), v55 (copy), filterMembersByText (copy)
        return (filterMembersByText(p27(v30), p27(v55)))
    end)
    local v64 = p11:Computed(function(p28) -- line: 353
        -- upvalues: v38 (copy), v56 (copy), filterMembersByText (copy)
        return (filterMembersByText(p28(v38), p28(v56)))
    end)
    local MembersServer = Permissions.canViewPage(p11, "MembersServer")
    local MembersPermanent = Permissions.canViewPage(p11, "MembersPermanent")
    local Roles2 = Permissions.canViewPage(p11, "Roles")
    local PreviewingRoles = p11:Fuse("temp", "PreviewingRoles")
    local v65 = p11:Computed(function(p29) -- line: 363
        -- upvalues: YouMember (copy), RoleInfo (copy)
        local v66 = p29(YouMember)
        local v67 = p29(RoleInfo)

        if typeof(v66) == "table" and typeof(v67) == "table" then
            local roleKeys = v66.roleKeys

            if typeof(roleKeys) == "table" then
                for _, v68 in roleKeys do
                    local v69 = v67[v68]

                    if typeof(v69) == "table" and v69.mayPreviewRoles == true then
                        return true
                    end
                end
            end
        end

        return false
    end)
    local v70 = p11:Computed(function(p30) -- line: 375
        -- upvalues: YouMember (copy), RoleInfo (copy)
        local v71 = p30(YouMember)
        local v72 = p30(RoleInfo)

        if typeof(v71) ~= "table" or typeof(v72) ~= "table" then
            return 0
        end

        local roleKeys = v71.roleKeys

        if typeof(roleKeys) ~= "table" then
            return 0
        end

        local n4 = 0

        for _, v73 in roleKeys do
            local v74 = v72[v73]

            if typeof(v74) == "table" and typeof(v74.rank) == "number" and n4 < v74.rank then
                n4 = v74.rank
            end
        end

        return n4
    end)

    local function snapshotServerPreview() -- line: 392
        -- upvalues: PreviewingRoles (copy), Fusion (copy)
        local v75 = Fusion.peek(PreviewingRoles)
        local t10 = {}

        if typeof(v75) == "table" then
            for _, v76 in v75 do
                if typeof(v76) == "string" then
                    table.insert(t10, v76)
                end
            end
        end

        return t10
    end

    local v77 = p11:Value((snapshotServerPreview()))

    p11:Observer(PreviewingRoles):onChange(function() -- line: 403
        -- upvalues: snapshotServerPreview (copy), v77 (copy)
        v77:set((snapshotServerPreview()))
    end)
    task.defer(function() -- line: 406
        -- upvalues: snapshotServerPreview (copy), v77 (copy)
        v77:set((snapshotServerPreview()))
    end)

    local v78 = p11:Computed(function(p31) -- line: 410
        -- upvalues: v77 (copy)
        local t11 = {}

        for _, v79 in (p31(v77)) do
            t11[v79] = true
        end

        return t11
    end)
    local v80 = p11:Computed(function(p32) -- line: 417
        -- upvalues: PreviewingRoles (copy), v77 (copy)
        local v81 = p32(v77)
        local v82 = p32(PreviewingRoles)

        if typeof(v82) ~= "table" then
            v82 = {}
        end

        if #v81 ~= #v82 then
            return true
        end

        local t12 = {}

        for _, v83 in v82 do
            t12[v83] = true
        end

        for _, v84 in v81 do
            if not t12[v84] then
                return true
            end
        end

        return false
    end)
    local SetPreviewingRoles = Remote.get("SetPreviewingRoles")
    local ClearPreviewingRoles = Remote.get("ClearPreviewingRoles")

    local function makePreviewStateComputed(p33, p34) -- line: 435
        -- upvalues: RoleInfo (copy), v65 (copy), v70 (copy), v78 (copy)
        return p33:Computed(function(p35) -- line: 436
            -- upvalues: p34 (copy), RoleInfo (copy), v65 (copy), v70 (copy), v78 (copy)
            if not p35(v65) then
                return nil
            end

            if p35(v78)[p34.key] then
                return "active"
            end

            local v85 = p35(RoleInfo)
            local v86 = if typeof(v85) == "table" then v85[p34.key] else nil
            local v87 = typeof(v86) == "table"
            local v88 = if v87 then typeof(v86.rank) == "number" else nil

            return if not ((if not v87 or not v88 then 0 else v86.rank) >= p35(v70)) then "inactive" else nil
        end)
    end

    local function onPreviewToggle(p36) -- line: 448
        -- upvalues: v77 (copy), Fusion (copy)
        local t13 = {}
        local v89 = false

        for _, v90 in (Fusion.peek(v77)) do
            if v90 == p36 then
                v89 = true
            else
                table.insert(t13, v90)
            end
        end

        if not v89 then
            table.insert(t13, p36)
        end

        v77:set(t13)
    end

    local function confirmPreview() -- line: 466
        -- upvalues: v77 (copy), SetPreviewingRoles (copy), ClearPreviewingRoles (copy), Modules (copy), Fusion (copy)
        local v91 = Fusion.peek(v77)

        if #v91 == 0 then
            task.spawn(function() -- line: 469
                -- upvalues: ClearPreviewingRoles (copy)
                ClearPreviewingRoles:invokeServerAsync()
            end)
        else
            task.spawn(function() -- line: 473
                -- upvalues: v91 (copy), SetPreviewingRoles (copy), Modules (copy)
                local v92, v93 = SetPreviewingRoles:invokeServerAsync(v91)

                if v92 then
                    return
                end

                require(Modules.Prompt).error((tostring(v93 or "Failed to enter preview")))
            end)
        end
    end

    local function cancelPreview() -- line: 482
        -- upvalues: snapshotServerPreview (copy), v77 (copy)
        v77:set((snapshotServerPreview()))
    end

    local t14 = {
        "Server",
        "Permanent"
    }
    local t15 = {
        {
            label = "Server"
        },
        {
            label = "Permanent"
        }
    }
    local v95 = p11:Value(1)
    local v96 = p11:Computed(function(p37) -- line: 494
        -- upvalues: t14 (copy), v95 (copy)
        return t14[p37(v95)] or ""
    end)
    local v98 = p11:Value(1)
    local ChangeGameSetting = Remote.get("ChangeGameSetting")

    Remote.get("ChangeRoleSetting")

    local ChangeRolesOrder = Remote.get("ChangeRolesOrder")
    local v99 = {}
    local v100 = {}

    local function setLocalKeys(p38) -- line: 506
        -- upvalues: v10 (copy), v99 (ref)
        v99 = p38
        v10:set(table.clone(p38))
    end

    local function syncLocalKeysValue() -- line: 510
        -- upvalues: v10 (copy), v99 (ref)
        v10:set(table.clone(v99))
    end

    local t16 = {}
    local v102 = p11:Value(false)
    local v103, v104, v105

    local function getLayoutOrder(p39) -- line: 520
        -- upvalues: p11 (copy), t16 (copy)
        if not t16[p39] then
            t16[p39] = p11:Value(1)
        end

        return t16[p39]
    end

    local function syncLayoutOrders() -- line: 527
        -- upvalues: p11 (copy), v99 (ref), t16 (copy), Fusion (copy)
        for v106, v107 in v99 do
            if not t16[v107] then
                t16[v107] = p11:Value(1)
            end

            local v108 = t16[v107]

            if Fusion.peek(v108) ~= v106 then
                v108:set(v106)
            end
        end
    end

    local function findKeyIndex(p40) -- line: 536
        -- upvalues: v99 (ref)
        for v109, v110 in v99 do
            if v110 == p40 then
                return v109
            end
        end

        return 1
    end

    local function getDefaultKeys() -- line: 543
        -- upvalues: DefaultRoleInfo (copy), Fusion (copy), isInternalRole (copy)
        local v111 = Fusion.peek(DefaultRoleInfo)

        if typeof(v111) ~= "table" then
            return {}
        end

        local t17 = {}

        for v112, v113 in v111 do
            if typeof(v113) == "table" and v113.hide ~= true and not isInternalRole(v113) then
                table.insert(t17, {
                    key = v112,
                    rank = if typeof(v113.rank) == "number" then v113.rank else 1
                })
            end
        end

        table.sort(t17, function(p41, p42) -- line: 552
            return p41.rank > p42.rank
        end)

        local t19 = {}

        for _, v114 in t17 do
            table.insert(t19, v114.key)
        end

        return t19
    end

    local function getSavedKeys() -- line: 561
        -- upvalues: SavedRoles (copy), Fusion (copy), isInternalRole (copy)
        local v115 = Fusion.peek(SavedRoles)
        local t20 = {}

        if typeof(v115) == "table" then
            for _, v116 in v115 do
                if typeof(v116) == "table" and typeof(v116.key) == "string" and v116.hide ~= true and not isInternalRole(v116) then
                    table.insert(t20, v116.key)
                end
            end
        end

        return t20
    end

    local function syncFromFused() -- line: 574
        -- upvalues: v9 (copy), v10 (copy), v99 (ref), v100 (ref), v102 (copy), syncLayoutOrders (copy), getDefaultKeys (copy), getSavedKeys (copy), Fusion (copy)
        if Fusion.peek(v102) then
            return
        end

        v100 = getSavedKeys()

        if Fusion.peek(v9) then
            local v117 = getDefaultKeys()

            v99 = v117
            v10:set(table.clone(v117))
        else
            local v118 = getSavedKeys()

            v99 = v118
            v10:set(table.clone(v118))
        end

        syncLayoutOrders()
    end

    p11:Observer(SavedRoles):onChange(syncFromFused)
    syncFromFused()
    p11:Observer(DefaultRoleInfo):onChange(syncFromFused)
    p11:Observer(v6):onChange(function() -- line: 587
        -- upvalues: v6 (copy), v9 (copy), v102 (copy), syncFromFused (copy), Fusion (copy)
        if not Fusion.peek(v102) then
            v9:set(Fusion.peek(v6) == true)
            syncFromFused()
        end
    end)

    local t21 = {}
    local v119 = ""
    local v120
    local n5 = 44
    local ScreenGui, clone, v121
    local n6 = 0
    local n7 = 0
    local t22 = {}
    local n8 = 0
    local n9 = 1
    local v122

    local function cleanupDrag() -- line: 610
        -- upvalues: v119 (ref), ScreenGui (ref), clone (ref), v121 (ref), t22 (copy), v122 (ref), ScrollLock (copy), Players (copy), onDragMove (ref), onDragEnd (ref)
        for v123, v124 in t22 do
            for v125, v126 in v124 do
                v123[v125] = v126
            end
        end

        table.clear(t22)
        v121 = nil

        local v127 = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")

        if v127 then
            for _, child in v127:GetChildren() do
                if child.Name == "DragOverlay" then
                    child:Destroy()
                end
            end
        end

        ScreenGui = nil
        clone = nil

        local v128 = v119 ~= ""

        v119 = ""
        onDragMove = nil
        onDragEnd = nil
        ScrollLock.unlock()

        if v128 then
            v122()
        end
    end

    table.insert(p11, cleanupDrag)
    ensureDragListeners()

    local function onDragMove2(p43) -- line: 642
        -- upvalues: v10 (copy), v99 (ref), syncLayoutOrders (copy), v119 (ref), v120 (ref), n5 (ref), clone (ref), n6 (ref), n7 (ref), n8 (ref), n9 (ref)
        if v119 == "" then
            return
        end

        if clone then
            local clone2 = clone

            clone2.Position = UDim2.fromOffset(p43.Position.X - n7, p43.Position.Y - n6)
        end

        if v120 then
            local v129 = n8
            local Y = p43.Position.Y
            local v130 = n5 + 8
            local v131 = v119
            local v132 = false
            local v133

            for v134, v135 in v99 do
                if v135 == v131 then
                    v133 = v134
                    v132 = true
                    break
                end
            end

            if not v132 then
                v133 = 1
            end

            local v137 = math.floor((Y - v129 + v130 / 2) / v130) + 1
            local v138 = n9
            local v140 = math.clamp(v137, v138, #v99)

            if v140 ~= v133 then
                table.remove(v99, v133)
                table.insert(v99, v140, v119)
                v10:set(table.clone(v99))
                syncLayoutOrders()
            end
        end
    end

    v122 = function() -- line: 668
        -- upvalues: SavedRoleInfo (copy), v6 (copy), v9 (copy), v99 (ref), v100 (ref), v102 (copy), v103 (ref), v104 (ref), v105 (ref), Fusion (copy)
        if typeof((Fusion.peek(SavedRoleInfo))) ~= "table" then
            return
        end

        v103 = nil

        local v145 = if Fusion.peek(v9) then v105 else v99

        if v145 then
            local v146 = #v145 ~= #v100

            if not v146 then
                for v147, v148 in v145 do
                    if v100[v147] ~= v148 then
                        v146 = true
                        break
                    end
                end
            end

            if v146 then
                v103 = table.clone(v145)
            end
        end

        local v149 = Fusion.peek(v6) == true
        local v150 = Fusion.peek(v9)

        v104 = if v150 == v149 then nil else v150
        v102:set(v103 ~= nil or v104 ~= nil)
    end

    local function toggleUseDefaultRoles() -- line: 708
        -- upvalues: v9 (copy), v10 (copy), v99 (ref), v105 (ref), syncLayoutOrders (copy), getDefaultKeys (copy), getSavedKeys (copy), v122 (ref), Fusion (copy)
        local v152 = not Fusion.peek(v9)

        v9:set(v152)

        if v152 then
            v105 = table.clone(v99)

            local v153 = getDefaultKeys()

            v99 = v153
            v10:set(table.clone(v153))
        elseif v105 then
            local v154 = table.clone(v105)

            v99 = v154
            v10:set(table.clone(v154))
            v105 = nil
        else
            local v155 = getSavedKeys()

            v99 = v155
            v10:set(table.clone(v155))
        end

        syncLayoutOrders()
        v122()
    end

    local function confirmChanges() -- line: 728
        -- upvalues: v9 (copy), v10 (copy), ChangeGameSetting (copy), ChangeRolesOrder (copy), v99 (ref), v100 (ref), v102 (copy), v103 (ref), v104 (ref), v105 (ref), syncLayoutOrders (copy), v122 (ref), Modules (copy), Fusion (copy)
        local v156 = table.clone(v100)

        local function restoreSavedView() -- line: 731
            -- upvalues: v156 (copy), v10 (copy), v99 (ref), v100 (ref), syncLayoutOrders (copy), v122 (ref)
            local v157 = table.clone(v156)

            v99 = v157
            v10:set(table.clone(v157))
            syncLayoutOrders()
            v100 = v156
            v122()
        end

        if v103 then
            local v158 = v103

            task.spawn(function() -- line: 739
                -- upvalues: v156 (copy), v158 (copy), v10 (copy), ChangeRolesOrder (copy), v99 (ref), v100 (ref), syncLayoutOrders (copy), v122 (ref), Modules (copy)
                local v159, v160, v161 = ChangeRolesOrder:invokeServerAsync(v158)

                if v159 then
                    return
                end

                local Prompt = require(Modules.Prompt);

                (if v161 == "error" then Prompt.error else Prompt.warn)((tostring(v160 or "Failed to save roles order")))

                local v164 = table.clone(v156)

                v99 = v164
                v10:set(table.clone(v164))
                syncLayoutOrders()
                v100 = v156
                v122()
            end)
            v103 = nil
        end

        if v104 ~= nil then
            local v165 = v104

            task.spawn(function() -- line: 752
                -- upvalues: v156 (copy), v165 (copy), v9 (copy), v10 (copy), ChangeGameSetting (copy), v99 (ref), v100 (ref), v105 (ref), syncLayoutOrders (copy), v122 (ref), Modules (copy)
                local function v166() -- line: 753
                    -- upvalues: v165 (copy), ChangeGameSetting (copy)
                    return ChangeGameSetting:invokeServerAsync({ "SystemSettings", "UseDefaultRoles" }, v165)
                end

                local v167, v168, v169, v170 = pcall(v166)
                local warn

                if v167 then
                    if v168 then
                        return
                    else
                        local Prompt = require(Modules.Prompt)

                        warn = if v170 == "error" then Prompt.error else Prompt.warn
                    end
                else
                    warn = require(Modules.Prompt).warn
                end

                if not v167 then
                    v169 = v168
                end

                warn(tostring(v169) or "Failed to save roles")
                v9:set(not v165)
                v105 = nil

                local v171 = table.clone(v156)

                v99 = v171
                v10:set(table.clone(v171))
                syncLayoutOrders()
                v100 = v156
                v122()
            end)
            v104 = nil
        end

        v102:set(false)

        if Fusion.peek(v9) and v105 then
            v100 = table.clone(v105)
            v105 = nil
        elseif not Fusion.peek(v9) then
            v100 = table.clone(v99)
        end
    end

    local function undoChanges() -- line: 777
        -- upvalues: v6 (copy), v9 (copy), v10 (copy), v99 (ref), v100 (ref), v102 (copy), v103 (ref), v104 (ref), v105 (ref), syncLayoutOrders (copy), Fusion (copy)
        local v172 = table.clone(v100)

        v99 = v172
        v10:set(table.clone(v172))
        syncLayoutOrders()
        v103 = nil
        v104 = nil
        v105 = nil
        v9:set(Fusion.peek(v6) == true)
        v102:set(false)
    end

    local function onDragEnd2(_) -- line: 787
        -- upvalues: cleanupDrag (copy)
        cleanupDrag()
    end

    local function startDrag(p45, p46, p47, p48) -- line: 791
        -- upvalues: v9 (copy), v99 (ref), t21 (copy), v119 (ref), n5 (ref), ScreenGui (ref), clone (ref), v121 (ref), n6 (ref), n7 (ref), t22 (copy), n8 (ref), n9 (ref), cleanupDrag (copy), onDragMove2 (copy), onDragEnd2 (copy), Fusion (copy), ScrollLock (copy), clientUser (copy), Players (copy), onDragMove (ref), onDragEnd (ref), n1 (ref), n2 (ref)
        if Fusion.peek(v9) then
            return
        end

        n9 = 1

        local YouMember = clientUser.temp:get("YouMember")
        local RoleInfo = clientUser.everyone:get("RoleInfo")

        if typeof(YouMember) == "table" and typeof(RoleInfo) == "table" then
            local roleKeys = YouMember.roleKeys

            if typeof(roleKeys) == "table" then
                local v173 = false
                local n10 = 0

                for _, v174 in roleKeys do
                    local v175 = RoleInfo[v174]

                    if typeof(v175) == "table" then
                        local v176 = if typeof(v175.rank) == "number" then v175.rank else 0

                        if n10 < v176 then
                            n10 = v176
                        end

                        if v175.mayEditRoles == true or v175.mayEditAll == true then
                            v173 = true
                        end
                    end
                end

                if not v173 then
                    return
                end

                local v177 = RoleInfo[p45]
                local v178 = if typeof(v177) ~= "table" then 0 elseif typeof(v177.rank) == "number" then v177.rank else 0

                if n10 <= v178 then
                    return
                end

                local n11 = 0

                for _, v179 in v99 do
                    local v180 = RoleInfo[v179]
                    local v181 = if typeof(v180) ~= "table" then 0 elseif typeof(v180.rank) == "number" then v180.rank else 0

                    if n10 <= v181 then
                        n11 += 1
                    end
                end

                n9 = n11 + 1
            end
        end

        if v119 ~= "" then
            cleanupDrag()
        end

        n1 = n2
        v119 = p45

        if #v99 > 0 then
            local v182 = t21[v99[1]]

            if v182 and v182:IsA("GuiObject") then
                n5 = v182.AbsoluteSize.Y
                n8 = v182.AbsolutePosition.Y
            end
        end

        onDragMove = onDragMove2
        onDragEnd = onDragEnd2
        ScrollLock.lock(p46)

        local v183 = t21[p45]

        if not v183 then
            return
        end

        v121 = v183

        local child

        for _, child2 in v183:GetChildren() do
            if child2:IsA("Frame") and child2.Name:sub(1, 11) == "HeadingRow_" then
                child = child2
                break
            end
        end

        if child then
            n7 = p48 - child.AbsolutePosition.X
            n6 = p47 - child.AbsolutePosition.Y

            local X, Y = child.AbsoluteSize.X, child.AbsoluteSize.Y
            local v184 = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")

            if v184 then
                ScreenGui = Instance.new("ScreenGui")
                ScreenGui.Name = "DragOverlay"
                ScreenGui.DisplayOrder = 999
                ScreenGui.IgnoreGuiInset = false

                local ScreenGui2 = ScreenGui

                ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                ScreenGui.Parent = v184
                clone = child:Clone()

                local clone2 = clone

                clone2.Size = UDim2.fromOffset(X, Y)

                local clone3 = clone

                clone3.AutomaticSize = Enum.AutomaticSize.None

                local clone4 = clone

                clone4.Position = UDim2.fromOffset(p48 - n7, p47 - n6)
                clone.Parent = ScreenGui

                local UIStroke = Instance.new("UIStroke")

                UIStroke.Name = "DragShadow"
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                UIStroke.Color = Color3.new(0, 0, 0)
                UIStroke.Transparency = 0.7
                UIStroke.Thickness = 3
                UIStroke.Parent = clone
                table.clear(t22)
                t22[child] = {
                    BackgroundTransparency = child.BackgroundTransparency
                }
                child.BackgroundTransparency = 0.85

                for _, descendant in child:GetDescendants() do
                    if descendant:IsA("TextLabel") then
                        t22[descendant] = {
                            TextTransparency = descendant.TextTransparency
                        }
                        descendant.TextTransparency = 0.85
                    elseif descendant:IsA("ImageLabel") then
                        t22[descendant] = {
                            ImageTransparency = descendant.ImageTransparency
                        }
                        descendant.ImageTransparency = 0.85
                    elseif descendant:IsA("Frame") then
                        t22[descendant] = {
                            BackgroundTransparency = descendant.BackgroundTransparency
                        }
                        descendant.BackgroundTransparency = math.max(descendant.BackgroundTransparency, 0.85)
                    end
                end
            end
        end
    end

    local function ensureRow(p49) -- line: 902
        -- upvalues: p11 (copy), DefaultRoleInfo (copy), SavedRoleInfo (copy), v9 (copy), onRoleActivate (copy), RoleInfo (copy), v65 (copy), v70 (copy), v78 (copy), onPreviewToggle (copy), t16 (copy), t21 (copy), startDrag (copy), Modules (copy), Fusion (copy), HeadingRow (copy), Permissions (copy), Children (copy)
        if t21[p49.key] then
            return t21[p49.key]
        end

        local key = p49.key

        if not t16[key] then
            t16[key] = p11:Value(1)
        end

        local v185 = t16[key]
        local v186 = p11:Computed(function(p50) -- line: 436
            -- upvalues: p49 (copy), RoleInfo (copy), v65 (copy), v70 (copy), v78 (copy)
            if not p50(v65) then
                return nil
            end

            if p50(v78)[p49.key] then
                return "active"
            end

            local v187 = p50(RoleInfo)
            local v188 = if typeof(v187) == "table" then v187[p49.key] else nil
            local v189 = typeof(v188) == "table"
            local v190 = if v189 then typeof(v188.rank) == "number" else nil

            return if not ((if not v189 or not v190 then 0 else v188.rank) >= p50(v70)) then "inactive" else nil
        end)
        local v191 = Permissions.canEditRoleByKey(p11, p49.key)
        local mayEditRoles = Permissions.hasPermission(p11, "mayEditRoles")
        local v192 = p11:Computed(function(p51) -- line: 909
            -- upvalues: v191 (copy), v9 (copy)
            if p51(v9) == true then
                return true
            end

            return p51(v191) ~= true
        end)
        local v194 = p11:New("Frame")({
            Name = "RoleEntry_" .. p49.key,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = v185,
            Size = UDim2.new(1, 0, 0, 0),
            [Children] = {
                HeadingRow(p11, {
                    entry = p49,
                    onActivate = function(p52) -- onActivate | line: 922
                        -- upvalues: mayEditRoles (copy), onRoleActivate (copy), Modules (copy), Fusion (copy)
                        if Fusion.peek(mayEditRoles) == true then
                            if onRoleActivate then
                                local v193 = if typeof(onRoleActivate) == "table" then Fusion.peek(onRoleActivate) else onRoleActivate

                                if v193 then
                                    v193(p52)
                                end
                            end
                        else
                            require(Modules.Prompt).warn("You don't have permission to edit roles.")
                        end
                    end,
                    onDragStart = startDrag,
                    hideDrag = v192,
                    roleInfoFuse = SavedRoleInfo,
                    defaultRoleInfoFuse = DefaultRoleInfo,
                    useDefaults = v9,
                    previewState = v186,
                    onPreviewToggle = onPreviewToggle
                })
            }
        })

        t21[p49.key] = v194

        return v194
    end

    local function buildTabContent(p53, p54) -- line: 948
        -- upvalues: p12 (copy), v7 (copy), v9 (copy), v11 (copy), onMemberActivate (copy), ServerMembers (copy), PermanentMembers (copy), RoleInfo (copy), v30 (copy), v38 (copy), v55 (copy), v56 (copy), v63 (copy), v64 (copy), MembersServer (copy), MembersPermanent (copy), Roles2 (copy), t15 (copy), v95 (copy), v96 (copy), v120 (ref), toggleUseDefaultRoles (copy), ensureRow (copy), Icons (copy), Fusion (copy), Theme (copy), UserDetails (copy), SplitRow (copy), UnderscoreTabBar (copy), SearchRowToggle (copy), InlineToggleRow (copy), LoadingSpinner (copy), StreamList (copy), SearchBar (copy), LoadingGate (copy), extractGivers (copy), Permissions (copy), isInternalRole (copy), NoPermissionPlaceholder (copy), Children (copy), memberItemKey (copy)
        if p54 == 2 then
            local v195 = p53:ForValues(v11, function(_, _, p57) -- line: 950
                -- upvalues: ensureRow (copy)
                return (ensureRow(p57))
            end)

            p53:Value(false)

            local v196 = Permissions.canEditRoles(p53)
            local v197 = p53:Computed(function(p58) -- line: 957
                -- upvalues: v196 (copy), v9 (copy)
                if p58(v9) == true then
                    return false
                end

                return p58(v196) == true
            end)
            local v198 = SearchRowToggle(p53, {
                name = "AddRoleButton",
                layoutOrder = 0,
                icon = Icons.AddFill,
                iconSize = UDim2.fromOffset(14, 14),
                isVisible = v197,
                onActivate = function() -- onActivate | line: 967
                    -- upvalues: p12 (copy)
                    if p12.onRoleCreate then
                        p12.onRoleCreate()
                    end
                end
            })
            local mayEditSettingsGame = Permissions.hasPermission(p53, "mayEditSettingsGame")
            local v199 = p53:New("Frame")({
                Name = "UseDefaultsRow",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 0,
                Size = UDim2.fromScale(1, 0),
                Visible = mayEditSettingsGame,
                [Children] = {
                    p53:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        Padding = UDim.new(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    }),
                    v198,
                    InlineToggleRow(p53, {
                        name = "UseDefaultsLabel",
                        label = "Use Studio Defaults",
                        fills = true,
                        layoutOrder = 1,
                        isOn = v9,
                        onToggle = toggleUseDefaultRoles
                    })
                }
            })
            local v200 = p53:New("Frame")({
                Name = "RolesList",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Visible = v7,
                [Children] = {
                    p53:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDim.new(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    v199,
                    v195
                }
            })

            v120 = v200

            local v201 = LoadingSpinner(p53, {
                visible = p53:Computed(function(p59) -- line: 1022
                    -- upvalues: v7 (copy)
                    return not p59(v7)
                end)
            })
            local v202 = p53:New("Frame")({
                Name = "RolesContentInner",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Size = UDim2.fromScale(1, 0),
                Visible = Roles2,
                [Children] = {
                    p53:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    v200,
                    v201
                }
            })
            local v203 = p53:New("Frame")({
                Name = "RolesTab_Denied",
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Size = UDim2.new(1, 0, 0, 160),
                Visible = p53:Computed(function(p60) -- line: 1049
                    -- upvalues: Roles2 (copy)
                    return not p60(Roles2)
                end),
                [Children] = { NoPermissionPlaceholder(p53, {}) }
            })

            return p53:New("Frame")({
                Name = "RolesTabContent",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                [Children] = {
                    p53:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    v202,
                    v203
                }
            })
        end

        local function buildDotsStrip(p61, p62) -- line: 1073
            -- upvalues: RoleInfo (copy), Fusion (copy), Theme (copy), Children (copy)
            local v204 = Fusion.peek(RoleInfo)
            local t25 = {}

            if typeof(v204) == "table" then
                for _, v205 in p62 do
                    local v206 = v204[v205]

                    if typeof(v206) == "table" then
                        table.insert(t25, v206.color or Color3.fromRGB(161, 161, 170))
                    end
                end
            end

            return p61:New("Frame")({
                Name = "RoleDots",
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                [Children] = {
                    p61:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 4),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p61:ForValues(t25, function(_, p64, p65, p66) -- line: 1095
                        -- upvalues: Theme (copy), Children (copy)
                        return p64:New("Frame")({
                            Name = "Dot_" .. tostring(p66),
                            BackgroundColor3 = p65,
                            LayoutOrder = p66,
                            Size = UDim2.fromOffset(10, 10),
                            [Children] = {
                                p64:New("UICorner")({
                                    CornerRadius = UDim.new(1, 0)
                                }),
                                p64:New("UIStroke")({
                                    Transparency = 0.5,
                                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                    Color = Theme.Color.NeutralStroke
                                })
                            }
                        })
                    end)
                }
            })
        end

        local function renderGiverRow(p67, p68) -- line: 1116
            -- upvalues: buildDotsStrip (copy), p12 (copy), UserDetails (copy), SplitRow (copy), extractGivers (copy), Children (copy)
            local giver = p68.giver
            local v208 = tostring(giver.type)

            tostring(giver.name)

            local v209 = ("GiverRow_%*_%*"):format(v208, (tostring(giver.id)))
            local v210 = buildDotsStrip(p67, giver.roleKeys)
            local t26 = {
                height = 46,
                name = v209
            }
            local t27 = {
                name = v209 .. "_Slot",
                fills = true,
                onActivate = function() -- onActivate | line: 1128
                    -- upvalues: giver (copy), p12 (copy)
                    local onGiverActivate = p12.onGiverActivate

                    if onGiverActivate then
                        onGiverActivate(giver)
                    end
                end
            }
            local Frame = p67:New("Frame")
            local t28 = {
                Name = "ContentGroup",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, 0),
                Size = UDim2.new(1, -24, 1, 0)
            }
            local v211 = p67:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            local v212 = UserDetails(p67, {
                layoutOrder = 1,
                iconSize = 32,
                singleLine = true,
                displayName = extractGivers.makeNameComputed(p67, giver),
                subtitle = extractGivers.compactSubtitleFor(giver),
                iconImage = extractGivers.imageUrl(giver)
            })

            p67:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }).Parent = v212
            t28[Children] = {
                v211,
                v212,
                p67:New("Frame")({
                    Name = "DotsSlot",
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    [Children] = { v210 }
                })
            }
            t27[Children] = { Frame(t28) }
            t26.left = t27

            return SplitRow(p67, t26)
        end

        local function renderMemberRow(p69, p70) -- line: 1173
            -- upvalues: onMemberActivate (copy), RoleInfo (copy), Fusion (copy), Theme (copy), UserDetails (copy), SplitRow (copy), isInternalRole (copy), Children (copy)
            local member = p70.member
            local v213 = Fusion.peek(RoleInfo)
            local t29 = {}

            if typeof(v213) == "table" then
                for _, v214 in member.roleKeys do
                    local v215 = v213[v214]

                    if typeof(v215) == "table" and not isInternalRole(v215) then
                        table.insert(t29, v215.color or Color3.fromRGB(161, 161, 170))
                    end
                end
            end

            local v217 = p69:New("Frame")({
                Name = "RoleDots",
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                [Children] = {
                    p69:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 4),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p69:ForValues(t29, function(_, p72, p73, p74) -- line: 1196
                        -- upvalues: Theme (copy), Children (copy)
                        return p72:New("Frame")({
                            Name = "Dot_" .. tostring(p74),
                            BackgroundColor3 = p73,
                            LayoutOrder = p74,
                            Size = UDim2.fromOffset(10, 10),
                            [Children] = {
                                p72:New("UICorner")({
                                    CornerRadius = UDim.new(1, 0)
                                }),
                                p72:New("UIStroke")({
                                    Transparency = 0.5,
                                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                    Color = Theme.Color.NeutralStroke
                                })
                            }
                        })
                    end)
                }
            })
            local t30 = {
                height = 46
            }

            t30.name = "MemberRow_" .. tostring(member.userId)

            local t31 = {
                name = "MemberRowSlot_" .. tostring(member.userId),
                fills = true,
                onActivate = function() -- onActivate | line: 1220
                    -- upvalues: member (copy), onMemberActivate (copy), Fusion (copy)
                    if onMemberActivate then
                        local v218 = if typeof(onMemberActivate) == "table" then Fusion.peek(onMemberActivate) else onMemberActivate

                        if v218 then
                            v218(member.userId)
                        end
                    end
                end
            }
            local Frame = p69:New("Frame")
            local t32 = {
                Name = "ContentGroup",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, 0),
                Size = UDim2.new(1, -24, 1, 0)
            }
            local v219 = p69:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            local v220 = UserDetails(p69, {
                layoutOrder = 1,
                iconSize = 32,
                singleLine = true,
                userId = member.userId,
                displayName = member.userDisplayName,
                username = member.userName
            })

            p69:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }).Parent = v220
            t32[Children] = {
                v219,
                v220,
                p69:New("Frame")({
                    Name = "DotsSlot",
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    [Children] = { v217 }
                })
            }
            t31[Children] = { Frame(t32) }
            t30.left = t31

            return SplitRow(p69, t30)
        end

        local function renderRow(p75, p76) -- line: 1268
            -- upvalues: renderGiverRow (copy), renderMemberRow (copy)
            if p76.isGiver then
                return renderGiverRow(p75, p76)
            end

            return renderMemberRow(p75, p76)
        end

        local v221 = UnderscoreTabBar(p53, {
            layoutOrder = 0,
            tabs = t15,
            activeTab = v95
        })
        local v222 = p53:New("Frame")({
            Name = "MembersSubTab_Server",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.fromScale(1, 0),
            Visible = p53:Computed(function(p77) -- line: 1287
                -- upvalues: MembersServer (copy), v96 (copy)
                if p77(v96) == "Server" then
                    return (p77(MembersServer))
                end

                return false
            end),
            [Children] = {
                p53:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Vertical,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                SearchBar(p53, {
                    placeholderText = "Search",
                    layoutOrder = 0,
                    searchText = v55
                }),
                p53:New("Frame")({
                    Name = "ListWrap",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Size = UDim2.fromScale(1, 0),
                    [Children] = {
                        LoadingGate(p53, {
                            isReady = p53:Computed(function(p78) -- line: 1310
                                -- upvalues: ServerMembers (copy)
                                return typeof(p78(ServerMembers)) == "table"
                            end),
                            [Children] = {
                                StreamList(p53, {
                                    items = v30,
                                    visibleItems = v63,
                                    itemKey = memberItemKey,
                                    padding = UDim.new(0, 8),
                                    renderItem = renderMemberRow
                                })
                            }
                        })
                    }
                })
            }
        })
        local v223 = p53:New("Frame")({
            Name = "MembersSubTab_Permanent",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.fromScale(1, 0),
            Visible = p53:Computed(function(p79) -- line: 1334
                -- upvalues: MembersPermanent (copy), v96 (copy)
                if p79(v96) == "Permanent" then
                    return (p79(MembersPermanent))
                end

                return false
            end),
            [Children] = {
                p53:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Vertical,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                SearchBar(p53, {
                    placeholderText = "Search",
                    layoutOrder = 0,
                    searchText = v56,
                    leadingSlot = SearchRowToggle(p53, {
                        name = "GivePermRoleToggle",
                        icon = Icons.AddFill,
                        iconSize = UDim2.fromOffset(14, 14),
                        onActivate = function() -- onActivate | line: 1352
                            -- upvalues: p12 (copy)
                            if p12.onRunPageOpen then
                                p12.onRunPageOpen("givepermrole", {
                                    autoOpenUserArg = true
                                })
                            end
                        end
                    })
                }),
                p53:New("Frame")({
                    Name = "ListWrap",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Size = UDim2.fromScale(1, 0),
                    [Children] = {
                        LoadingGate(p53, {
                            isReady = p53:Computed(function(p80) -- line: 1367
                                -- upvalues: PermanentMembers (copy)
                                return typeof(p80(PermanentMembers)) == "table"
                            end),
                            [Children] = {
                                StreamList(p53, {
                                    items = v38,
                                    visibleItems = v64,
                                    itemKey = memberItemKey,
                                    padding = UDim.new(0, 8),
                                    renderItem = renderRow
                                })
                            }
                        })
                    }
                })
            }
        })
        local v224 = p53:New("Frame")({
            Name = "MembersSubTab_Denied",
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, 160),
            Visible = p53:Computed(function(p81) -- line: 1390
                -- upvalues: MembersServer (copy), MembersPermanent (copy), v96 (copy)
                local v225 = p81(v96)

                if v225 == "Server" then
                    return not p81(MembersServer)
                end

                if v225 == "Permanent" then
                    return not p81(MembersPermanent)
                end

                return false
            end),
            [Children] = { NoPermissionPlaceholder(p53, {}) }
        })

        return p53:New("Frame")({
            Name = "MembersTabContent",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            [Children] = {
                p53:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Vertical,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                v221,
                v222,
                v223,
                v224
            }
        })
    end

    local v226 = p11:Computed(function(p82) -- line: 1423
        -- upvalues: v98 (copy), v102 (copy)
        if p82(v98) == 2 then
            return p82(v102)
        end

        return false
    end)
    local v227 = p11:Computed(function(p83) -- line: 1429
        -- upvalues: v80 (copy), v226 (copy)
        return p83(v226) or p83(v80)
    end)
    local v228 = p11:Computed(function(p84) -- line: 1433
        -- upvalues: v77 (copy), v80 (copy), v226 (copy)
        if p84(v226) then
            return "Confirm?"
        end

        if not p84(v80) then
            return ""
        end

        if #p84(v77) == 0 then
            return "Stop?"
        end

        return "Preview?"
    end)
    local v229 = p11:Computed(function(p85) -- line: 1442
        -- upvalues: v77 (copy), v80 (copy), v226 (copy)
        if p85(v226) or not p85(v80) then
            return "Confirm"
        end

        if #p85(v77) == 0 then
            return "Stop"
        end

        return "Preview"
    end)
    local v230 = p11:Computed(function(p86) -- line: 1451
        -- upvalues: v226 (copy)
        if p86(v226) then
            return "Undo"
        end

        return "Cancel"
    end)

    local function activeConfirm() -- line: 1456
        -- upvalues: v80 (copy), confirmPreview (copy), confirmChanges (copy), v226 (copy), Fusion (copy)
        if Fusion.peek(v226) then
            confirmChanges()
        elseif Fusion.peek(v80) then
            confirmPreview()
        end
    end

    local function activeUndo() -- line: 1463
        -- upvalues: snapshotServerPreview (copy), v77 (copy), v80 (copy), undoChanges (copy), v226 (copy), Fusion (copy)
        if Fusion.peek(v226) then
            undoChanges()
        elseif Fusion.peek(v80) then
            v77:set((snapshotServerPreview()))
        end
    end

    local v231 = p11:Spring(p11:Computed(function(p87) -- line: 1471
        -- upvalues: v227 (copy)
        if p87(v227) then
            return 54
        end

        return 0
    end), 40, 1)
    local v232 = p11:New("Frame")({
        Name = "ConfirmBarWrap",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            p11:New("Frame")({
                Name = "ConfirmBar",
                AnchorPoint = Vector2.new(0, 0.5),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Color.Neutral,
                Position = UDim2.new(0, 2, 0.5, 0),
                Size = UDim2.new(1, -7, 0, -2),
                [Children] = {
                    p11:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    }),
                    p11:New("UIStroke")({
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = Theme.Color.NeutralContent
                    }),
                    p11:New("UIPadding")({
                        PaddingBottom = UDim.new(0, 14),
                        PaddingLeft = UDim.new(0, 12),
                        PaddingRight = UDim.new(0, 4),
                        PaddingTop = UDim.new(0, 14)
                    }),
                    p11:New("Frame")({
                        Name = "LabelGroup",
                        AnchorPoint = Vector2.new(0, 0.5),
                        AutomaticSize = Enum.AutomaticSize.XY,
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(0, 0.5),
                        [Children] = {
                            p11:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center
                            }),
                            p11:New("TextLabel")({
                                Name = "Label",
                                BackgroundTransparency = 1,
                                AutomaticSize = Enum.AutomaticSize.XY,
                                FontFace = p11:Computed(function(p88) -- line: 1519
                                    -- upvalues: Theme (copy)
                                    return Font.new(p88(Theme.Font.Body), p88(Theme.FontWeight.Body))
                                end),
                                Text = v228,
                                TextColor3 = Theme.Color.BaseContent,
                                TextSize = Theme.TextSize.Subtitle,
                                TextTruncate = Enum.TextTruncate.AtEnd
                            })
                        }
                    }),
                    p11:New("Frame")({
                        Name = "ButtonGroup",
                        AnchorPoint = Vector2.new(1, 0.5),
                        AutomaticSize = Enum.AutomaticSize.XY,
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(1, 0.5),
                        [Children] = {
                            p11:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalFlex = Enum.UIFlexAlignment.None,
                                Padding = UDim.new(0, 6),
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center
                            }),
                            Pressable(p11, {
                                name = "ConfirmButton",
                                size = UDim2.new(0, 0, 0, 0),
                                automaticSize = Enum.AutomaticSize.XY,
                                backgroundColor = Theme.Color.Primary,
                                layoutOrder = 1,
                                onActivate = activeConfirm,
                                [Children] = {
                                    p11:New("UICorner")({
                                        CornerRadius = UDim.new(0, 6)
                                    }),
                                    p11:New("UIPadding")({
                                        PaddingBottom = UDim.new(0, 7),
                                        PaddingLeft = UDim.new(0, 12),
                                        PaddingRight = UDim.new(0, 12),
                                        PaddingTop = UDim.new(0, 7)
                                    }),
                                    p11:New("TextLabel")({
                                        Name = "Label",
                                        BackgroundTransparency = 1,
                                        AutomaticSize = Enum.AutomaticSize.XY,
                                        FontFace = p11:Computed(function(p89) -- line: 1564
                                            -- upvalues: Theme (copy)
                                            return Font.new(p89(Theme.Font.Body), p89(Theme.FontWeight.Body))
                                        end),
                                        Text = v229,
                                        TextColor3 = Theme.Color.PrimaryContent,
                                        TextSize = Theme.TextSize.Subtitle
                                    })
                                }
                            }),
                            Pressable(p11, {
                                name = "UndoButton",
                                size = UDim2.new(0, 0, 0, 0),
                                automaticSize = Enum.AutomaticSize.XY,
                                backgroundColor = Theme.Color.NeutralContent,
                                layoutOrder = 2,
                                onActivate = activeUndo,
                                [Children] = {
                                    p11:New("UICorner")({
                                        CornerRadius = UDim.new(0, 6)
                                    }),
                                    p11:New("UIPadding")({
                                        PaddingBottom = UDim.new(0, 7),
                                        PaddingLeft = UDim.new(0, 12),
                                        PaddingRight = UDim.new(0, 12),
                                        PaddingTop = UDim.new(0, 7)
                                    }),
                                    p11:New("TextLabel")({
                                        Name = "Label",
                                        BackgroundTransparency = 1,
                                        AutomaticSize = Enum.AutomaticSize.XY,
                                        FontFace = p11:Computed(function(p90) -- line: 1593
                                            -- upvalues: Theme (copy)
                                            return Font.new(p90(Theme.Font.Body), p90(Theme.FontWeight.Body))
                                        end),
                                        Text = v230,
                                        TextColor3 = Theme.Color.BaseContent,
                                        TextSize = Theme.TextSize.Subtitle
                                    })
                                }
                            })
                        }
                    })
                }
            })
        }
    })

    return p11:New("Frame")({
        Name = "RolesPage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            TabbedScroller(p11, {
                tabs = t1,
                activeTabRef = v98,
                buildTabContent = buildTabContent,
                footerSlot = v232,
                footerHeight = v231,
                headerPadding = UDim.new(0, 10)
            })
        }
    })
end
