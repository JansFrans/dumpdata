-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Platform = require(UI.Util.Platform)
local Viewport = require(UI.Config.Viewport)
local RoleBadge = require(UI.Components.RoleBadge)
local BanBanner = require(UI.Components.BanBanner)
local extractGivers = require(UI.Util.extractGivers)
local stableRows = require(UI.Util.stableRows)
local isInternalRole = require(Modules.RoleUtil.isInternalRole)
local escapeRichText = require(Modules.DataUtil.escapeRichText)
local Pressable = require(UI.Components.Pressable)
local SearchRowToggle = require(UI.Components.SearchRowToggle)
local nameValueFor = require(UI.Util.nameValueFor)
local Remote = require(Modules.Objects.Remote)
local Players = game:GetService("Players")
local Children, Out = Fusion.Children, Fusion.Out

local function describeAccountAge(p1) -- line: 53
    if p1 >= 365 then
        local v2 = math.floor(p1 / 365)

        if v2 == 1 then
            return "1 year"
        end

        return (("%* years"):format(v2))
    end

    if p1 >= 30 then
        local v4 = math.floor(p1 / 30)

        if v4 == 1 then
            return "1 month"
        end

        return (("%* months"):format(v4))
    end

    if p1 == 1 then
        return "1 day"
    end

    return (("%* days"):format(p1))
end

return function(p2, p3) -- line: 66
    -- upvalues: Modules (copy), Fusion (copy), Theme (copy), Platform (copy), Viewport (copy), RoleBadge (copy), BanBanner (copy), extractGivers (copy), stableRows (copy), isInternalRole (copy), escapeRichText (copy), Pressable (copy), SearchRowToggle (copy), nameValueFor (copy), Remote (copy), Players (copy), Children (copy), Out (copy), describeAccountAge (copy)
    local v5 = p3.inline == true
    local v6 = Fusion.peek(p3.giverIdentity)

    if v6 then
        local RoleInfo = p2:Fuse("everyone", "RoleInfo")
        local v7, v8 = stableRows()
        local v9 = p2:Computed(function(p4) -- line: 74
            -- upvalues: v6 (copy), RoleInfo (copy), v7 (copy), v8 (copy)
            local v10 = p4(RoleInfo)

            if typeof(v10) ~= "table" then
                return {}
            end

            local t1 = {}

            for _, v11 in v6.roleKeys do
                local v12 = v10[v11]

                if typeof(v12) == "table" then
                    local v13 = v12.name or v11
                    local v14 = v12.color or Color3.fromRGB(161, 161, 170)
                    local v15 = v12.rank or 0

                    table.insert(t1, v7(v11, ("%*|%*|%*"):format(v13, v14:ToHex(), v15), function() -- line: 84
                        -- upvalues: v11 (copy), v13 (copy), v15 (copy), v14 (copy)
                        return {
                            id = v11,
                            name = v13,
                            color = v14,
                            level = v15
                        }
                    end))
                end
            end

            v8()
            table.sort(t1, function(p5, p6) -- line: 90
                return p5.level > p6.level
            end)

            return t1
        end)
        local v18 = if v6.type == "Group" then p2:Computed(function(p7) -- line: 94
            -- upvalues: v6 (copy), RoleInfo (copy), extractGivers (copy)
            local v19 = p7(RoleInfo)

            return extractGivers.buildGroupBreakdown(v19, v6.id)
        end) else nil
        local v20, v21 = stableRows()
        local v22 = if v18 then p2:Computed(function(p8) -- line: 101
            -- upvalues: v20 (copy), v21 (copy), v18 (copy)
            local sections = p8(v18).sections
            local t2 = {}

            for _, v23 in sections do
                table.insert(t2, v20(("%*:%*"):format(v23.kind, v23.rank or "all"), ("%*|%*"):format(v23.name or "", (table.concat(v23.hdAdminRoleKeys, ","))), function() -- line: 107
                    -- upvalues: v23 (copy)
                    return v23
                end))
            end

            v21()

            return t2
        end) else nil

        local function buildSection(_, p10, p11) -- line: 116
            -- upvalues: RoleInfo (copy), Theme (copy), RoleBadge (copy), escapeRichText (copy), Children (copy), Out (copy)
            local v27 = p10:Computed(function(p12) -- line: 117
                -- upvalues: p11 (copy), Theme (copy), escapeRichText (copy)
                if p11.kind == "AllMembers" then
                    return "All Members"
                end

                local v28 = p12(Theme.Color.NeutralContentDark)
                local v34 = string.format("#%02X%02X%02X", math.round(v28.R * 255), math.round(v28.G * 255), (math.round(v28.B * 255)))
                local v35 = if typeof(p11.name) ~= "string" or not (#p11.name > 0) then "Rank " .. tostring(p11.rank) else escapeRichText(p11.name)

                return string.format("%s <font color=\"%s\">(Rank %d)</font>", v35, v34, p11.rank or 0)
            end)
            local Frame = p10:New("Frame")
            local t3 = {
                Name = "Section",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0)
            }
            local v36 = p10:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6)
            })
            local v37 = p10:New("TextLabel")({
                Name = "Header",
                LayoutOrder = 1,
                BackgroundTransparency = 1,
                RichText = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                FontFace = p10:Computed(function(p13) -- line: 145
                    -- upvalues: Theme (copy)
                    return Font.new(p13(Theme.Font.Body), p13(Theme.FontWeight.Bold))
                end),
                Size = UDim2.new(1, 0, 0, 0),
                Text = v27,
                TextColor3 = Theme.Color.BaseContent,
                TextSize = Theme.TextSize.Label,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local function v38() -- line: 155
                -- upvalues: p10 (copy), p11 (copy), RoleInfo (copy), RoleBadge (copy), Children (copy), Out (copy)
                local v39 = p10:Value(Vector2.zero)

                return p10:New("Frame")({
                    Name = "Badges",
                    LayoutOrder = 2,
                    BackgroundTransparency = 1,
                    Size = p10:Computed(function(p14) -- line: 163
                        -- upvalues: v39 (copy)
                        return UDim2.new(1, 0, 0, p14(v39).Y)
                    end),
                    [Children] = {
                        p10:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalAlignment = Enum.HorizontalAlignment.Left,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            Wraps = true,
                            Padding = UDim.new(0, 6),
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            [Out("AbsoluteContentSize")] = v39
                        }),
                        p10:ForValues(p11.hdAdminRoleKeys, function(_, p16, p17) -- line: 176
                            -- upvalues: RoleInfo (copy), RoleBadge (copy)
                            local v40 = p16:Computed(function(p18) -- line: 177
                                -- upvalues: p17 (copy), RoleInfo (copy)
                                local v41 = p18(RoleInfo)
                                local v42 = if typeof(v41) == "table" then v41[p17] else nil

                                if not (typeof(v42) == "table" and typeof(v42.name) == "string") then
                                    return p17
                                end

                                return v42.name
                            end)
                            local v45 = p16:Computed(function(p19) -- line: 182
                                -- upvalues: p17 (copy), RoleInfo (copy)
                                local v46 = p19(RoleInfo)
                                local v47 = if typeof(v46) == "table" then v46[p17] else nil

                                if not (typeof(v47) == "table" and typeof(v47.color) == "Color3") then
                                    return (Color3.fromRGB(161, 161, 170))
                                end

                                return v47.color
                            end)

                            return RoleBadge(p16, {
                                large = true,
                                id = p16:Value(p17),
                                name = v40,
                                color = v45,
                                isGiver = p16:Value(true)
                            })
                        end)
                    }
                })
            end

            t3[Children] = {
                v36,
                v37,
                v38()
            }

            return Frame(t3)
        end

        local Frame = p2:New("Frame")
        local t6 = {
            Name = "ProfileBody"
        }

        t6.AutomaticSize = if v5 then Enum.AutomaticSize.Y else Enum.AutomaticSize.None
        t6.BackgroundTransparency = 1
        t6.Size = if v5 then UDim2.new(1, 0, 0, 0) else UDim2.fromScale(1, 1)

        local v50 = p2:New("UIPadding")({
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6)
        })
        local v51 = p2:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 14),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v52 = p2:New("Frame")({
            Name = "Header",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, 0),
            [Children] = {
                p2:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                p2:New("ImageLabel")({
                    Name = "Icon",
                    BackgroundColor3 = Theme.Color.NeutralDark,
                    Image = extractGivers.imageUrl(v6),
                    LayoutOrder = 1,
                    Size = UDim2.fromOffset(60, 60),
                    [Children] = {
                        p2:New("UICorner")({
                            CornerRadius = UDim.new(1, 0)
                        })
                    }
                }),
                p2:New("Frame")({
                    Name = "Names",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    Size = UDim2.new(1, -70, 0, 0),
                    [Children] = {
                        p2:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Vertical,
                            SortOrder = Enum.SortOrder.LayoutOrder
                        }),
                        p2:New("TextLabel")({
                            Name = "DisplayName",
                            BackgroundTransparency = 1,
                            LayoutOrder = 1,
                            TextSize = 24,
                            AutomaticSize = Enum.AutomaticSize.Y,
                            FontFace = p2:Computed(function(p20) -- line: 257
                                -- upvalues: Theme (copy)
                                return Font.new(p20(Theme.Font.Heading), p20(Theme.FontWeight.Heading))
                            end),
                            Size = UDim2.new(1, 0, 0, 0),
                            Text = extractGivers.makeNameComputed(p2, v6),
                            TextColor3 = Theme.Color.BaseContent,
                            TextTruncate = Enum.TextTruncate.AtEnd,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextYAlignment = Enum.TextYAlignment.Top
                        }),
                        p2:New("TextLabel")({
                            Name = "Subtitle",
                            BackgroundTransparency = 1,
                            LayoutOrder = 2,
                            AutomaticSize = Enum.AutomaticSize.Y,
                            FontFace = p2:Computed(function(p21) -- line: 273
                                -- upvalues: Theme (copy)
                                return Font.new(p21(Theme.Font.Body), p21(Theme.FontWeight.Body))
                            end),
                            Size = UDim2.new(1, 0, 0, 0),
                            Text = ("(%*)"):format((extractGivers.subtitleFor(v6))),
                            TextColor3 = Theme.Color.NeutralContentDark,
                            TextSize = Theme.TextSize.Subtitle,
                            TextTruncate = Enum.TextTruncate.AtEnd,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextYAlignment = Enum.TextYAlignment.Top
                        })
                    }
                })
            }
        })
        local v53 = if v6.type == "Group" then "The members of this group will receive these roles:"
            elseif v6.type == "Product" or v6.type == "ProductPreset" then "Everyone with this product will receive these roles:"
            elseif v6.type == "Friend" then if v6.id == "friends" then "Everyone friended with the creator will receive these roles:" else "Everyone friended with this user will receive these roles:"
            elseif v6.type == "UserPreset" then if v6.id == "Creator" then "The creator of this game (or its group owner) will receive these roles:" elseif v6.id == "FriendsOfCreator" then "Friends of the creator of this game (or its group owner) will receive these roles:" else "Everyone matching this preset will receive these roles:"
            elseif v6.type == "UserList" then "Everyone matching this list will receive these roles:"
            elseif v6.type == "Everyone" then "Everyone in this game will receive these roles:"
            elseif v6.type == "PrivateServerOwner" then "The owner of a private server will receive these roles:"
            else "These roles will be granted:"
        local v54 = p2:New("TextLabel")({
            Name = "IntroNote",
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            FontFace = p2:Computed(function(p22) -- line: 320
                -- upvalues: Theme (copy)
                return Font.new(p22(Theme.Font.Body), p22(Theme.FontWeight.Body))
            end),
            Size = UDim2.new(1, 0, 0, 0),
            Text = v53,
            TextColor3 = Theme.Color.NeutralContentDark,
            TextSize = Theme.TextSize.Label,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        if v6.type == "Group" then
            v53 = p2:New("Frame")({
                Name = "Sections",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 3,
                Size = UDim2.new(1, 0, 0, 0),
                [Children] = {
                    p2:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 12)
                    }),
                    p2:ForValues(v22, buildSection)
                }
            })
        else
            local v55 = p2:Value(Vector2.zero)

            v53 = p2:New("Frame")({
                Name = "Roles",
                BackgroundTransparency = 1,
                LayoutOrder = 3,
                Size = p2:Computed(function(p23) -- line: 353
                    -- upvalues: v55 (copy)
                    return UDim2.new(1, 0, 0, p23(v55).Y)
                end),
                [Children] = {
                    p2:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Wraps = true,
                        Padding = UDim.new(0, 6),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        [Out("AbsoluteContentSize")] = v55
                    }),
                    p2:ForValues(v9, function(_, p25, p26, _) -- line: 366
                        -- upvalues: RoleBadge (copy)
                        return RoleBadge(p25, {
                            large = true,
                            id = p25:Value(p26.id),
                            name = p25:Value(p26.name),
                            color = p25:Value(p26.color),
                            isGiver = p25:Value(true)
                        })
                    end)
                }
            })
        end

        t6[Children] = {
            v50,
            v51,
            v52,
            v54,
            v53,
            p2:New("TextLabel")({
                Name = "ConfiguredNote",
                BackgroundTransparency = 1,
                LayoutOrder = 4,
                Text = "This can be configured within Roles",
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                FontFace = p2:Computed(function(p28) -- line: 382
                    -- upvalues: Theme (copy)
                    return Font.new(p28(Theme.Font.Body), p28(Theme.FontWeight.Body))
                end),
                Size = UDim2.new(1, 0, 0, 0),
                TextColor3 = Theme.Color.NeutralContentDark,
                TextSize = Theme.TextSize.Label,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        }

        return Frame(t6)
    end

    local userId = p3.userId
    local v56 = p2:Computed(function(p29) -- line: 399
        -- upvalues: userId (copy)
        return "rbxthumb://type=AvatarBust&id=" .. tostring(if typeof(userId) == "table" then p29(userId) else userId) .. "&w=150&h=150"
    end)
    local YouMember = p2:Fuse("temp", "YouMember")
    local ServerMembers = p2:Fuse("everyone", "ServerMembers")
    local PermanentMembers = p2:Fuse("everyone", "PermanentMembers")
    local v58 = p2:Computed(function(p30) -- line: 407
        -- upvalues: userId (copy), YouMember (copy), ServerMembers (copy), PermanentMembers (copy)
        local v59 = if typeof(userId) == "table" then p30(userId) else userId

        if typeof(v59) ~= "number" then
            return nil
        end

        local v60 = p30(YouMember)

        if typeof(v60) == "table" and typeof(v60.userId) == "number" and v60.userId == v59 then
            return v60
        end

        local v61 = tostring(v59)
        local v62 = p30(ServerMembers)
        local v63 = typeof(v62) == "table"
        local v64 = if v63 then typeof(v62[v61]) == "table" else nil

        if v63 and v64 then
            return v62[v61]
        end

        local v66 = p30(PermanentMembers)

        return if typeof(v66) == "table" and typeof(v66[v61]) == "table" then v66[v61] else nil
    end)
    local v70 = nameValueFor(p2, userId)
    local v71 = p2:Value({})
    local v72 = p2:Value({})
    local n1 = 0
    local RoleInfo = p2:Fuse("everyone", "RoleInfo")
    local v73, v74 = stableRows()
    local v75 = p2:Computed(function(p31) -- line: 434
        -- upvalues: v58 (copy), v71 (copy), v72 (copy), RoleInfo (copy), v73 (copy), v74 (copy), isInternalRole (copy)
        local v76 = p31(RoleInfo)

        if typeof(v76) ~= "table" then
            return {}
        end

        local v77 = p31(v58)
        local v78 = if v77 then typeof(v77.roleKeys) == "table" else nil
        local v79 = if not v77 or not v78 then {} else v77.roleKeys
        local v80 = if v77 then typeof(v77.permanentRoleKeys) == "table" else nil
        local v81 = if not v77 or not v80 then {} else v77.permanentRoleKeys
        local v82 = if v77 then typeof(v77.giverRoleKeys) == "table" else nil
        local v83 = if not v77 or not v82 then {} else v77.giverRoleKeys
        local v84 = p31(v71)
        local v85 = p31(v72)
        local t9 = {}

        for _, v86 in v79 do
            local v87 = v81[v86] == true
            local v88 = v83[v86] == true

            if v85[v86] then
                if v88 then
                    t9[v86] = {
                        isPermanent = false,
                        isGiver = v88
                    }
                end
            else
                t9[v86] = {
                    isPermanent = v87,
                    isGiver = v88
                }
            end
        end

        for v89, v90 in v84 do
            local v91 = t9[v89] and t9[v89].isGiver or false

            t9[v89] = {
                isPermanent = t9[v89] and t9[v89].isPermanent or false or v90.isPermanent,
                isGiver = v91
            }
        end

        local t11 = {}

        for v93, v94 in t9 do
            local v95 = v76[v93]

            if typeof(v95) == "table" and not isInternalRole(v95) then
                local v96 = v95.name or v93
                local v97 = v95.color or Color3.fromRGB(161, 161, 170)
                local v98 = v95.rank or 0

                table.insert(t11, v73(v93, ("%*|%*|%*|%*|%*"):format(v96, v97:ToHex(), v98, tostring(v94.isPermanent), (tostring(v94.isGiver))), function() -- line: 475
                    -- upvalues: v93 (copy), v96 (copy), v98 (copy), v97 (copy), v94 (copy)
                    return {
                        id = v93,
                        name = v96,
                        color = v97,
                        level = v98,
                        isPermanent = v94.isPermanent,
                        isGiver = v94.isGiver
                    }
                end))
            end
        end

        v74()
        table.sort(t11, function(p32, p33) -- line: 487
            return p32.level > p33.level
        end)

        return t11
    end)
    local v103 = p2:Value(false)
    local v104, v105 = stableRows()
    local v106 = p2:Computed(function(p34) -- line: 493
        -- upvalues: YouMember (copy), v58 (copy), v71 (copy), v72 (copy), RoleInfo (copy), v104 (copy), v105 (copy), isInternalRole (copy)
        local v107 = p34(RoleInfo)

        if typeof(v107) ~= "table" then
            return {}
        end

        local v108 = p34(v58)
        local t12 = {}

        if v108 and typeof(v108.roleKeys) == "table" then
            for _, v109 in v108.roleKeys do
                t12[v109] = true
            end
        end

        local v110 = p34(v71)
        local v111 = p34(v72)

        for v112 in v110 do
            t12[v112] = true
        end

        for v113 in v111 do
            t12[v113] = nil
        end

        local v114 = p34(YouMember)
        local v115 = 0

        if typeof(v114) == "table" then
            if typeof(v114.roleKeys) == "table" then
                for _, v116 in v114.roleKeys do
                    local v117 = v107[v116]

                    if typeof(v117) == "table" and typeof(v117.rank) == "number" and v115 < v117.rank then
                        v115 = v117.rank
                    end
                end
            end
        end

        local t13 = {}

        for v118, v119 in v107 do
            if typeof(v118) == "string" and typeof(v119) == "table" and not isInternalRole(v119) and not t12[v118] then
                local v120 = if typeof(v119.rank) == "number" then v119.rank else 0

                if not (v115 <= v120) then
                    local v121 = v119.name or v118
                    local v122 = v119.color or Color3.fromRGB(161, 161, 170)

                    table.insert(t13, v104(v118, ("%*|%*|%*"):format(v121, v122:ToHex(), v120), function() -- line: 525
                        -- upvalues: v118 (copy), v120 (copy), v121 (copy), v122 (copy)
                        return {
                            key = v118,
                            name = v121,
                            color = v122,
                            rank = v120
                        }
                    end))
                end
            end
        end

        v105()
        table.sort(t13, function(p35, p36) -- line: 530
            return p35.rank > p36.rank
        end)

        return t13
    end)
    local v125 = p2:Computed(function(p37) -- line: 533
        -- upvalues: v106 (copy)
        return #p37(v106) > 0
    end)
    local GiveRoleToUser = Remote.get("GiveRoleToUser")
    local TakeRoleFromUser = Remote.get("TakeRoleFromUser")
    local CommandInfo = p2:Fuse("everyone", "CommandInfo")

    local function makeCanUseCommandComputed(p38) -- line: 542
        -- upvalues: p2 (copy), YouMember (copy), CommandInfo (copy)
        return p2:Computed(function(p39) -- line: 543
            -- upvalues: p38 (copy), YouMember (copy), CommandInfo (copy)
            local v126 = p39(YouMember)
            local v127 = p39(CommandInfo)

            if typeof(v126) == "table" and typeof(v127) == "table" then
                local v128 = v127[p38]

                if typeof(v128) == "table" then
                    local roles = v128.roles

                    if typeof(roles) == "table" then
                        local t14 = {}

                        for _, v129 in roles do
                            t14[v129] = true
                        end

                        local roleKeys = v126.roleKeys

                        if typeof(roleKeys) == "table" then
                            for _, v130 in roleKeys do
                                if t14[v130] then
                                    return true
                                end
                            end
                        end
                    end
                end
            end

            return false
        end)
    end

    local v131 = "giveserverrole"
    local v132 = p2:Computed(function(p40) -- line: 543
        -- upvalues: YouMember (copy), CommandInfo (copy), v131 (copy)
        local v133 = p40(YouMember)
        local v134 = p40(CommandInfo)

        if typeof(v133) == "table" and typeof(v134) == "table" then
            local v135 = v134[v131]

            if typeof(v135) == "table" then
                local roles = v135.roles

                if typeof(roles) == "table" then
                    local t15 = {}

                    for _, v136 in roles do
                        t15[v136] = true
                    end

                    local roleKeys = v133.roleKeys

                    if typeof(roleKeys) == "table" then
                        for _, v137 in roleKeys do
                            if t15[v137] then
                                return true
                            end
                        end
                    end
                end
            end
        end

        return false
    end)
    local v138 = "givepermrole"
    local v139 = p2:Computed(function(p41) -- line: 543
        -- upvalues: YouMember (copy), CommandInfo (copy), v138 (copy)
        local v140 = p41(YouMember)
        local v141 = p41(CommandInfo)

        if typeof(v140) == "table" and typeof(v141) == "table" then
            local v142 = v141[v138]

            if typeof(v142) == "table" then
                local roles = v142.roles

                if typeof(roles) == "table" then
                    local t16 = {}

                    for _, v143 in roles do
                        t16[v143] = true
                    end

                    local roleKeys = v140.roleKeys

                    if typeof(roleKeys) == "table" then
                        for _, v144 in roleKeys do
                            if t16[v144] then
                                return true
                            end
                        end
                    end
                end
            end
        end

        return false
    end)
    local v145 = "takeserverrole"
    local v146 = p2:Computed(function(p42) -- line: 543
        -- upvalues: YouMember (copy), CommandInfo (copy), v145 (copy)
        local v147 = p42(YouMember)
        local v148 = p42(CommandInfo)

        if typeof(v147) == "table" and typeof(v148) == "table" then
            local v149 = v148[v145]

            if typeof(v149) == "table" then
                local roles = v149.roles

                if typeof(roles) == "table" then
                    local t17 = {}

                    for _, v150 in roles do
                        t17[v150] = true
                    end

                    local roleKeys = v147.roleKeys

                    if typeof(roleKeys) == "table" then
                        for _, v151 in roleKeys do
                            if t17[v151] then
                                return true
                            end
                        end
                    end
                end
            end
        end

        return false
    end)
    local v152 = "takepermrole"
    local v153 = p2:Computed(function(p43) -- line: 543
        -- upvalues: YouMember (copy), CommandInfo (copy), v152 (copy)
        local v154 = p43(YouMember)
        local v155 = p43(CommandInfo)

        if typeof(v154) == "table" and typeof(v155) == "table" then
            local v156 = v155[v152]

            if typeof(v156) == "table" then
                local roles = v156.roles

                if typeof(roles) == "table" then
                    local t18 = {}

                    for _, v157 in roles do
                        t18[v157] = true
                    end

                    local roleKeys = v154.roleKeys

                    if typeof(roleKeys) == "table" then
                        for _, v158 in roleKeys do
                            if t18[v158] then
                                return true
                            end
                        end
                    end
                end
            end
        end

        return false
    end)
    local v159 = p2:Computed(function(p44) -- line: 567
        -- upvalues: userId (copy), YouMember (copy), ServerMembers (copy)
        local v160 = if typeof(userId) == "table" then p44(userId) else userId

        if typeof(v160) ~= "number" then
            return false
        end

        local v161 = p44(YouMember)

        if typeof(v161) == "table" and typeof(v161.userId) == "number" and v161.userId == v160 then
            return true
        end

        local v162 = p44(ServerMembers)

        if typeof(v162) ~= "table" then
            return false
        end

        return typeof(v162[tostring(v160)]) == "table"
    end)
    local v164 = p2:Computed(function(p45) -- line: 577
        -- upvalues: v132 (copy), v159 (copy)
        return p45(v132) and p45(v159)
    end)
    local v166 = p2:Value(if Fusion.peek(v139) then "perm" else "server")

    local function normaliseGiveScope() -- line: 584
        -- upvalues: v139 (copy), v164 (copy), v166 (copy), Fusion (copy)
        local v167 = Fusion.peek(v139)
        local v168 = Fusion.peek(v164)
        local v169 = Fusion.peek(v166)

        if v167 and not v168 and v169 ~= "perm" then
            v166:set("perm")
        elseif v168 and not v167 and v169 ~= "server" or v169 == "perm" and not v167 and v168 then
            v166:set("server")
        elseif v169 == "server" and not v168 and v167 then
            v166:set("perm")
        end
    end

    p2:Observer(v139):onChange(normaliseGiveScope)
    p2:Observer(v132):onChange(normaliseGiveScope)
    p2:Observer(v159):onChange(normaliseGiveScope)
    task.defer(normaliseGiveScope)

    local function clearOptimisticAdd(p46, p47) -- line: 606
        -- upvalues: v71 (copy), Fusion (copy)
        local v170 = Fusion.peek(v71)
        local v171 = v170[p46]

        if v171 ~= nil and (p47 == nil or v171.token == p47) then
            local v172 = table.clone(v170)

            v172[p46] = nil
            v71:set(v172)
        end
    end

    local function clearOptimisticRemove(p48, p49) -- line: 615
        -- upvalues: v72 (copy), Fusion (copy)
        local v173 = Fusion.peek(v72)
        local v174 = v173[p48]

        if v174 ~= nil and (p49 == nil or v174 == p49) then
            local v175 = table.clone(v173)

            v175[p48] = nil
            v72:set(v175)
        end
    end

    local function onGiveRole(p50) -- line: 625
        -- upvalues: userId (copy), v71 (copy), v72 (copy), n1 (ref), v103 (copy), GiveRoleToUser (copy), v166 (copy), Modules (copy), Fusion (copy)
        v103:set(false)

        local v176 = if typeof(userId) == "table" then Fusion.peek(userId) else userId

        if typeof(v176) ~= "number" then
            return
        end

        local v177 = Fusion.peek(v166)
        local v178 = v177 == "perm"

        if Fusion.peek(v72)[p50] then
            local v179 = Fusion.peek(v72)

            if v179[p50] ~= nil then
                local v180 = table.clone(v179)

                v180[p50] = nil
                v72:set(v180)
            end
        end

        n1 += 1

        local v181 = n1
        local v182 = table.clone(Fusion.peek(v71))

        v182[p50] = {
            isPermanent = v178,
            token = v181
        }
        v71:set(v182)
        task.spawn(function() -- line: 641
            -- upvalues: p50 (copy), v176 (copy), v177 (copy), v181 (copy), v71 (copy), GiveRoleToUser (copy), Modules (copy), Fusion (copy)
            local v183, v184, v185 = GiveRoleToUser:invokeServerAsync(v176, p50, v177)

            if v183 then
                return
            end

            local v186 = Fusion.peek(v71)
            local v187 = v186[p50]

            if v187 ~= nil and (v181 == nil or v187.token == v181) then
                local v188 = table.clone(v186)

                v188[p50] = nil
                v71:set(v188)
            end

            local Prompt = require(Modules.Prompt);

            (if v185 == "error" then Prompt.error else Prompt.warn)((tostring(v184 or "Failed to give role")))
        end)
        task.delay(30, function() -- line: 650
            -- upvalues: p50 (copy), v181 (copy), v71 (copy), Fusion (copy)
            local v191 = Fusion.peek(v71)
            local v192 = v191[p50]

            if v192 ~= nil and (v181 == nil or v192.token == v181) then
                local v193 = table.clone(v191)

                v193[p50] = nil
                v71:set(v193)
            end
        end)
    end

    local function onRemoveRole(p51, p52) -- line: 655
        -- upvalues: userId (copy), v71 (copy), v72 (copy), n1 (ref), TakeRoleFromUser (copy), Modules (copy), Fusion (copy)
        local v194 = if typeof(userId) == "table" then Fusion.peek(userId) else userId

        if typeof(v194) ~= "number" then
            return
        end

        if Fusion.peek(v71)[p51] then
            local v195 = Fusion.peek(v71)

            if v195[p51] ~= nil then
                local v196 = table.clone(v195)

                v196[p51] = nil
                v71:set(v196)
            end
        end

        n1 += 1

        local v197 = n1
        local v198 = table.clone(Fusion.peek(v72))

        v198[p51] = v197
        v72:set(v198)
        task.spawn(function() -- line: 668
            -- upvalues: p51 (copy), p52 (copy), v194 (copy), v197 (copy), v72 (copy), TakeRoleFromUser (copy), Modules (copy), Fusion (copy)
            local v199, v200, v201 = TakeRoleFromUser:invokeServerAsync(v194, p51, p52)

            if v199 then
                return
            end

            local v202 = Fusion.peek(v72)
            local v203 = v202[p51]

            if v203 ~= nil and (v197 == nil or v203 == v197) then
                local v204 = table.clone(v202)

                v204[p51] = nil
                v72:set(v204)
            end

            local Prompt = require(Modules.Prompt);

            (if v201 == "error" then Prompt.error else Prompt.warn)((tostring(v200 or "Failed to remove role")))
        end)
        task.delay(30, function() -- line: 677
            -- upvalues: p51 (copy), v197 (copy), v72 (copy), Fusion (copy)
            local v207 = Fusion.peek(v72)
            local v208 = v207[p51]

            if v208 ~= nil and (v197 == nil or v208 == v197) then
                local v209 = table.clone(v207)

                v209[p51] = nil
                v72:set(v209)
            end
        end)
    end

    p2:Observer(v58):onChange(function() -- line: 682
        -- upvalues: v58 (copy), v71 (copy), v72 (copy), Fusion (copy)
        local v210 = Fusion.peek(v58)
        local t19 = {}
        local t20 = {}

        if v210 then
            if typeof(v210.roleKeys) == "table" then
                for _, v211 in v210.roleKeys do
                    t19[v211] = true
                end
            end

            if typeof(v210.permanentRoleKeys) == "table" then
                for v212 in v210.permanentRoleKeys do
                    t20[v212] = true
                end
            end
        end

        local v213 = Fusion.peek(v71)
        local v214 = v213
        local v215 = false

        for v216, v217 in v213 do
            if if v217.isPermanent then t20[v216] == true else t19[v216] == true then
                if not v215 then
                    v214 = table.clone(v213)
                    v215 = true
                end

                v214[v216] = nil
            end
        end

        if v215 then
            v71:set(v214)
        end

        local v218 = Fusion.peek(v72)
        local v219 = false
        local v220 = v218

        for v221 in v218 do
            if not t19[v221] then
                if not v219 then
                    v219 = true
                    v220 = table.clone(v218)
                end

                v220[v221] = nil
            end
        end

        if v219 then
            v72:set(v220)
        end
    end)

    local v222 = p2:Value(Vector2.zero)
    local v223 = p2:Value(Vector2.zero)
    local v224 = p2:Value(Vector2.zero)
    local v225 = p2:Value(Vector2.zero)
    local v226 = p2:Value(Vector2.zero)
    local v227 = p2:Value(Vector2.zero)
    local CurrentCamera = workspace.CurrentCamera
    local v229 = p2:Value(if CurrentCamera then CurrentCamera.ViewportSize else Vector2.new(1920, 1080))

    if CurrentCamera then
        local connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 728
            -- upvalues: CurrentCamera (copy), v229 (copy)
            v229:set(CurrentCamera.ViewportSize)
        end)

        table.insert(p2, function() -- line: 731
            -- upvalues: connection (copy)
            connection:Disconnect()
        end)
    end

    local v231 = p2:Value(Vector2.zero)
    local v228 = Vector2.new(0, 0)
    local v232 = p2:Value(Vector2.zero)
    local v233 = p2:Value(Vector2.zero)
    local v234 = p2:Value(false)
    local v235 = p2:Computed(function(p53) -- line: 745
        -- upvalues: v232 (copy)
        local v236 = p53(v232)

        return UDim2.fromOffset(v236.X, v236.Y)
    end)
    local v237 = p2:Value(Vector2.zero)

    local function relButtonPos() -- line: 751
        -- upvalues: v224 (copy), v226 (copy), Fusion (copy)
        return Fusion.peek(v224) - Fusion.peek(v226)
    end

    local function snapshotPopupGeometry() -- line: 755
        -- upvalues: v222 (copy), v223 (copy), v224 (copy), v225 (copy), v226 (copy), v229 (copy), v231 (copy), v232 (copy), v233 (copy), v234 (copy), Fusion (copy), Viewport (copy)
        local v238 = Fusion.peek(v224)
        local v239 = Fusion.peek(v225)
        local v240 = Fusion.peek(v223)
        local v241 = Fusion.peek(v222)
        local v242 = Fusion.peek(v226)
        local v243 = Fusion.peek(v229)
        local v244 = Fusion.peek(Viewport.Scale)

        if v244 <= 0 then
            v244 = 1
        end

        local v245 = Fusion.peek(v231).Y / v244

        if v245 <= 0 then
            v245 = 240
        end

        if v245 > 240 then
            v245 = 240
        end

        local v246 = (v243.Y - (v238.Y + v239.Y) - 12 - 6) / v244
        local v247 = (v238.Y - 12 - 6) / v244
        local v248 = v246 < v245 and v246 < v247

        if not v248 then
            v247 = v246
        end

        local v249 = math.min(v245, v247)

        if v249 < 60 then
            v249 = 60
        end

        local v250 = v241.X / v244
        local v251 = if v248 then v238.Y - 6 - v249 * v244 else v238.Y + v239.Y + 6
        local v252 = (v240.X - v242.X) / v244
        local v253 = (v251 - v242.Y) / v244

        v232:set(Vector2.new(v252, v253))
        v233:set(Vector2.new(v250, v249))
        v234:set(v248)
    end

    p2:Observer(v103):onChange(function() -- line: 793
        -- upvalues: v103 (copy), v224 (copy), v226 (copy), v237 (copy), snapshotPopupGeometry (copy), Fusion (copy)
        if Fusion.peek(v103) then
            snapshotPopupGeometry()
            v237:set(Fusion.peek(v224) - Fusion.peek(v226))
        end
    end)

    local v254 = false

    local function maybeClose() -- line: 800
        -- upvalues: v103 (copy), v224 (copy), v226 (copy), v237 (copy), v254 (ref), Fusion (copy)
        if Fusion.peek(v103) and not v254 then
            v254 = true
            task.defer(function() -- line: 804
                -- upvalues: v103 (copy), v224 (copy), v226 (copy), v237 (copy), v254 (ref), Fusion (copy)
                v254 = false

                if not Fusion.peek(v103) then
                    return
                end

                local v255 = Fusion.peek(v224) - Fusion.peek(v226) - Fusion.peek(v237)
                local v256 = math.abs(v255.Y) > 4
                local v257 = if not v256 then math.abs(v255.X) > 4 else nil

                if v256 or v257 then
                    v103:set(false)
                end
            end)
        end
    end

    p2:Observer(v224):onChange(maybeClose)
    p2:Observer(v226):onChange(maybeClose)

    local v258 = p2:Computed(function(p54) -- line: 817
        -- upvalues: v103 (copy), v231 (copy), v234 (copy), Viewport (copy)
        if not p54(v103) or p54(v234) then
            return 0
        end

        local v259 = p54(Viewport.Scale)

        if v259 <= 0 then
            v259 = 1
        end

        local v260 = p54(v231).Y / v259

        if v260 > 240 then
            v260 = 240
        end

        return v260 + 6
    end)
    local ScrollingFrame, t21, v261, v262, Frame, v263, v264, Frame2, v265, v266, Frame3, v267, v268

    if p3.popupParent then
        ScrollingFrame = p2:New("ScrollingFrame")
        t21 = {
            Name = "AddRolePopup",
            AnchorPoint = v228,
            Position = v235
        }
        t21.Size = p2:Computed(function(p55) -- line: 832
            -- upvalues: v233 (copy)
            local v269 = p55(v233)

            return UDim2.fromOffset(v269.X, v269.Y)
        end)
        t21.AutomaticCanvasSize = Enum.AutomaticSize.Y
        t21.Visible = p2:Computed(function(p56) -- line: 837
            -- upvalues: v103 (copy), v125 (copy)
            return p56(v103) and p56(v125)
        end)
        t21.ZIndex = 1000
        t21.BackgroundColor3 = Theme.Color.Base
        t21.BackgroundTransparency = 0
        t21.BorderSizePixel = 0
        t21.BottomImage = "rbxassetid://16547643439"
        t21.CanvasSize = UDim2.new()
        t21.MidImage = "rbxassetid://16547330984"
        t21.ScrollBarImageColor3 = Theme.Color.NeutralContentDark
        t21.ScrollBarImageTransparency = Platform.isMobile and 1 or 0
        t21.ScrollBarThickness = Platform.isMobile and 2 or 8
        t21.ScrollingDirection = Enum.ScrollingDirection.Y
        t21.Selectable = false
        t21.TopImage = "rbxassetid://16547667444"
        t21.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        v264 = p2:New("UICorner")({
            CornerRadius = UDim.new(0, 6)
        })
        Frame2 = p2:New("UIStroke")({
            Transparency = 0.5,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Theme.Color.NeutralStroke
        })
        v265 = p2:New("Frame")

        local t22 = {
            Name = "Items",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            [Out("AbsoluteSize")] = v231
        }

        v261 = p2:New("UIPadding")({
            PaddingTop = UDim.new(0, 6),
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6)
        })
        v262 = p2:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        Frame = p2:New("Frame")
        v263 = {
            Name = "ScopeToggle",
            LayoutOrder = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0)
        }
        v263.Visible = p2:Computed(function(p57) -- line: 887
            -- upvalues: v139 (copy), v164 (copy)
            return p57(v164) or p57(v139)
        end)
        Frame3 = p2:New("UIListLayout")({
            Wraps = true,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            HorizontalFlex = Enum.UIFlexAlignment.None,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        v267 = p2:New("TextLabel")({
            Name = "Label",
            LayoutOrder = 1,
            BackgroundTransparency = 1,
            Text = "Scope:",
            AutomaticSize = Enum.AutomaticSize.XY,
            FontFace = p2:Computed(function(p58) -- line: 905
                -- upvalues: Theme (copy)
                return Font.new(p58(Theme.Font.Body), p58(Theme.FontWeight.Body))
            end),
            TextColor3 = Theme.Color.NeutralContentDark,
            TextSize = Theme.TextSize.Label
        })

        v268 = function() -- line: 913
            -- upvalues: p2 (copy), v139 (copy), v164 (copy), v166 (copy), Fusion (copy), Theme (copy), Pressable (copy), Children (copy)
            local function makeScopePill(p59) -- line: 915
                -- upvalues: p2 (copy), v166 (copy), Fusion (copy), Theme (copy), Pressable (copy), Children (copy)
                return Pressable(p2, {
                    name = p59.name,
                    layoutOrder = p59.layoutOrder,
                    automaticSize = Enum.AutomaticSize.XY,
                    visible = p59.visible,
                    backgroundColor = p2:Computed(function(p60) -- line: 928
                        -- upvalues: p59 (copy), v166 (copy), Theme (copy)
                        if p60(v166) == p59.value then
                            return (p60(Theme.Color.Primary))
                        end

                        return (p60(Theme.Color.Neutral))
                    end),
                    onActivate = function() -- onActivate | line: 933
                        -- upvalues: p59 (copy), v166 (copy), Fusion (copy)
                        if Fusion.peek(p59.canUse) then
                            v166:set(p59.value)
                        end
                    end,
                    [Children] = {
                        p2:New("UICorner")({
                            CornerRadius = UDim.new(1, 0)
                        }),
                        p2:New("UIStroke")({
                            Transparency = 0.5,
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            Color = Theme.Color.NeutralStroke
                        }),
                        p2:New("UIPadding")({
                            PaddingTop = UDim.new(0, 6),
                            PaddingBottom = UDim.new(0, 6),
                            PaddingLeft = UDim.new(0, 11),
                            PaddingRight = UDim.new(0, 11)
                        }),
                        p2:New("TextLabel")({
                            Name = "Label",
                            BackgroundTransparency = 1,
                            TextSize = 17,
                            AutomaticSize = Enum.AutomaticSize.XY,
                            FontFace = p2:Computed(function(p61) -- line: 955
                                -- upvalues: Theme (copy)
                                return Font.new(p61(Theme.Font.Body), p61(Theme.FontWeight.Body))
                            end),
                            Text = p59.label,
                            TextColor3 = p2:Computed(function(p62) -- line: 959
                                -- upvalues: p59 (copy), v166 (copy), Theme (copy)
                                if p62(v166) == p59.value then
                                    return (p62(Theme.Color.PrimaryContent))
                                end

                                return (p62(Theme.Color.BaseContent))
                            end)
                        })
                    }
                })
            end

            return p2:New("Frame")({
                Name = "ScopePillsHolder",
                LayoutOrder = 2,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                [Children] = {
                    p2:New("UIListLayout")({
                        Wraps = true,
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalFlex = Enum.UIFlexAlignment.None,
                        Padding = UDim.new(0, 6),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Center
                    }),
                    makeScopePill({
                        name = "ScopePill_Server",
                        value = "server",
                        label = "Server",
                        layoutOrder = 1,
                        visible = v164,
                        canUse = v164
                    }),
                    makeScopePill({
                        name = "ScopePill_Permanent",
                        value = "perm",
                        label = "Permanent",
                        layoutOrder = 2,
                        visible = v139,
                        canUse = v139
                    })
                }
            })
        end

        v263[Children] = {
            Frame3,
            v267,
            v268()
        }
        Frame = Frame(v263)
        v263 = p2:New("Frame")
        v266 = {
            Name = "RolesFlow",
            LayoutOrder = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0)
        }
        v267 = p2:New("UIListLayout")({
            Wraps = true,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        v266[Children] = {
            v267,
            p2:ForValues(v106, function(_, p64, p65, _) -- line: 1019
                -- upvalues: v166 (copy), onGiveRole (copy), Theme (copy), Pressable (copy), Children (copy)
                return Pressable(p64, {
                    name = "RoleOption_" .. p65.key,
                    automaticSize = Enum.AutomaticSize.XY,
                    backgroundColor = Theme.Color.Neutral,
                    onActivate = function() -- onActivate | line: 1026
                        -- upvalues: p65 (copy), onGiveRole (copy)
                        onGiveRole(p65.key)
                    end,
                    [Children] = {
                        p64:New("UICorner")({
                            CornerRadius = UDim.new(1, 0)
                        }),
                        p64:New("UIPadding")({
                            PaddingTop = UDim.new(0, 6),
                            PaddingBottom = UDim.new(0, 6),
                            PaddingLeft = UDim.new(0, 11),
                            PaddingRight = UDim.new(0, 11)
                        }),
                        p64:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Horizontal,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            Padding = UDim.new(0, 6)
                        }),
                        p64:New("ImageLabel")({
                            Name = "PermIcon",
                            LayoutOrder = 0,
                            BackgroundTransparency = 1,
                            Image = "rbxassetid://132613467203568",
                            ImageColor3 = Theme.Color.BaseContent,
                            Size = UDim2.fromOffset(14, 14),
                            Visible = p64:Computed(function(p67) -- line: 1050
                                -- upvalues: v166 (copy)
                                return p67(v166) == "perm"
                            end)
                        }),
                        p64:New("Frame")({
                            Name = "Dot",
                            LayoutOrder = 1,
                            Size = UDim2.fromOffset(10, 10),
                            BackgroundColor3 = p65.color,
                            [Children] = {
                                p64:New("UICorner")({
                                    CornerRadius = UDim.new(1, 0)
                                })
                            }
                        }),
                        p64:New("TextLabel")({
                            Name = "Name",
                            LayoutOrder = 2,
                            BackgroundTransparency = 1,
                            TextSize = 17,
                            TextWrapped = false,
                            AutomaticSize = Enum.AutomaticSize.XY,
                            FontFace = p64:Computed(function(p68) -- line: 1068
                                -- upvalues: Theme (copy)
                                return Font.new(p68(Theme.Font.Body), p68(Theme.FontWeight.Body))
                            end),
                            Text = p65.name,
                            TextColor3 = Theme.Color.BaseContent
                        })
                    }
                })
            end)
        }
        t22[Children] = {
            v261,
            v262,
            Frame,
            v263(v266)
        }
        t21[Children] = {
            v264,
            Frame2,
            v265(t22)
        }
        ScrollingFrame(t21).Parent = p3.popupParent

        local popupParent = p3.popupParent

        v226:set(popupParent.AbsolutePosition)
        v227:set(popupParent.AbsoluteSize)

        local connection = popupParent:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 1090
            -- upvalues: v226 (copy), popupParent (copy)
            v226:set(popupParent.AbsolutePosition)
        end)
        local connection2 = popupParent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 1093
            -- upvalues: v227 (copy), popupParent (copy)
            v227:set(popupParent.AbsoluteSize)
        end)

        Frame2 = function() -- line: 1096
            -- upvalues: connection (copy), connection2 (copy)
            connection:Disconnect()
            connection2:Disconnect()
        end

        table.insert(p2, Frame2)
    end

    ScrollingFrame = p2:New("Frame")
    t21 = {
        Name = "ProfileBody"
    }

    if v5 then
        t21.AutomaticSize = Enum.AutomaticSize.Y
    else
        t21.AutomaticSize = Enum.AutomaticSize.None
    end

    t21.BackgroundTransparency = 1

    if v5 then
        t21.Size = UDim2.new(1, 0, 0, 0)
    else
        t21.Size = UDim2.fromScale(1, 1)
    end

    v264 = p2:New("UIPadding")({
        Name = "UIPadding",
        PaddingBottom = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 6)
    })
    Frame2 = p2:New("Frame")
    v265 = {
        Name = "Content"
    }

    if v5 then
        v265.AutomaticSize = Enum.AutomaticSize.Y
    else
        v265.AutomaticSize = Enum.AutomaticSize.None
    end

    v265.BackgroundTransparency = 1

    if v5 then
        v265.Size = UDim2.new(1, 0, 0, 0)
    else
        v265.Size = UDim2.new(1, 0, 1, 0)
    end

    v265.ZIndex = 2

    local v273 = p2:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalFlex = Enum.UIFlexAlignment.None,
        Padding = UDim.new(0, 14),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    v261 = p2:New("Frame")
    v262 = {
        Name = "Header",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 0)
    }
    v266 = p2:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local v274 = p2:New("ImageLabel")({
        Name = "Avatar",
        BackgroundColor3 = Theme.Color.NeutralDark,
        Image = v56,
        LayoutOrder = 1,
        Size = UDim2.fromOffset(60, 60),
        [Children] = {
            p2:New("UICorner")({
                CornerRadius = UDim.new(1, 0)
            })
        }
    })

    Frame3 = p2:New("Frame")
    v267 = {
        Name = "Names",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.new(1, -70, 0, 0)
    }

    local v275 = p2:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v276 = p2:New("TextLabel")({
        Name = "DisplayName",
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        TextSize = 24,
        FontFace = p2:Computed(function(p69) -- line: 1170
            -- upvalues: Theme (copy)
            return Font.new(p69(Theme.Font.Heading), p69(Theme.FontWeight.Heading))
        end),
        Size = UDim2.new(1, 0, 0, 26),
        Text = p2:Computed(function(p70) -- line: 1175
            -- upvalues: userId (copy), v58 (copy), v70 (copy)
            local v277 = p70(v58)
            local v278 = if v277 then typeof(v277.userDisplayName) == "string" else nil

            if v277 and v278 then
                return v277.userDisplayName
            end

            local v279 = p70(v70)

            if v279 ~= "" then
                return v279
            end

            return (tostring(if typeof(userId) == "table" then p70(userId) else userId))
        end),
        TextColor3 = Theme.Color.BaseContent,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    local TextLabel = p2:New("TextLabel")({
        Name = "Username",
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        FontFace = p2:Computed(function(p71) -- line: 1194
            -- upvalues: Theme (copy)
            return Font.new(p71(Theme.Font.Body), p71(Theme.FontWeight.Body))
        end),
        Size = p2:Computed(function(p72) -- line: 1198
            -- upvalues: Theme (copy)
            return UDim2.new(1, 0, 0, p72(Theme.TextSize.Subtitle) + 2)
        end),
        Text = p2:Computed(function(p73) -- line: 1201
            -- upvalues: userId (copy), v58 (copy), v70 (copy)
            local v282 = if typeof(userId) == "table" then p73(userId) else userId
            local v283 = p73(v58)
            local v284 = if v283 then typeof(v283.userName) == "string" else nil

            if v283 and v284 then
                return (("@%* (%*)"):format(v283.userName, (tostring(v282))))
            end

            local v285 = p73(v70)

            if v285 == "" then
                return ""
            end

            return (("@%* (%*)"):format(v285, (tostring(v282))))
        end),
        TextColor3 = Theme.Color.NeutralContentDark,
        TextSize = Theme.TextSize.Subtitle,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })

    v267[Children] = {
        v275,
        v276,
        TextLabel,
        p2:New("TextLabel")({
            Name = "Details",
            BackgroundTransparency = 1,
            FontFace = p2:Computed(function(p74) -- line: 1220
                -- upvalues: Theme (copy)
                return Font.new(p74(Theme.Font.Body), p74(Theme.FontWeight.Regular))
            end),
            LayoutOrder = 3,
            Size = p2:Computed(function(p75) -- line: 1224
                -- upvalues: Theme (copy)
                return UDim2.new(1, 0, 0, p75(Theme.TextSize.Label) + 4 + 1)
            end),
            Text = p2:Computed(function(p76) -- line: 1227
                -- upvalues: userId (copy), Players (copy), describeAccountAge (copy)
                local v286 = if typeof(userId) == "table" then p76(userId) else userId
                local v287 = if typeof(v286) == "number" then Players:GetPlayerByUserId(v286) else nil

                if v287 then
                    return (("Account is %* old"):format((describeAccountAge(v287.AccountAge))))
                end

                return ""
            end),
            TextColor3 = Theme.Color.NeutralContentDark,
            TextSize = Theme.TextSize.Label,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            [Children] = p2:New("UIPadding")({
                PaddingTop = UDim.new(0, 1)
            })
        })
    }
    v262[Children] = {
        v266,
        v274,
        Frame3(v267)
    }
    v261 = v261(v262)
    v263 = {
        layoutOrder = 2
    }

    if typeof(userId) == "table" then
    end

    v263.userId = userId
    v262 = BanBanner(p2, v263)

    local v288 = p2:Value(Vector2.zero)

    Frame = p2:New("Frame")
    v263 = {
        Name = "Roles",
        BackgroundTransparency = 1,
        LayoutOrder = 3
    }
    v263.Size = p2:Computed(function(p77) -- line: 1262
        -- upvalues: v288 (copy)
        return UDim2.new(1, 0, 0, p77(v288).Y)
    end)
    v263[Out("AbsoluteSize")] = v222
    v263[Out("AbsolutePosition")] = v223
    Frame3 = p2:New("UIListLayout")
    v267 = {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Wraps = true,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }
    v267[Out("AbsoluteContentSize")] = v288
    Frame3 = Frame3(v267)
    v267 = p2:ForValues(v75, function(_, p79, p80, _) -- line: 1277
        -- upvalues: userId (copy), v146 (copy), v153 (copy), onRemoveRole (copy), RoleBadge (copy)
        return RoleBadge(p79, {
            large = true,
            id = p79:Value(p80.id),
            name = p79:Value(p80.name),
            color = p79:Value(p80.color),
            isPermanent = p79:Value(p80.isPermanent),
            isGiver = p79:Value(p80.isGiver),
            userId = p79:Computed(function(p82) -- line: 1285
                -- upvalues: p80 (copy), userId (copy), v146 (copy), v153 (copy)
                if p80.isGiver and not p80.isPermanent then
                    return nil
                end

                local isPermanent = p80.isPermanent
                local v289, v290

                if isPermanent then
                    v289 = p82(v153)
                else
                    v290 = p82(v146)
                end

                if isPermanent and v289 or not isPermanent and v290 then
                    if typeof(userId) == "table" then
                        return (p82(userId))
                    end

                    return userId
                end

                return nil
            end),
            onRemove = function(p83, _) -- onRemove | line: 1298
                -- upvalues: p80 (copy), onRemoveRole (copy)
                onRemoveRole(p83, p80.isPermanent and "perm" or "server")
            end
        })
    end)
    v268 = p2:New("Frame")

    local t28 = {
        Name = "AddButton",
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        LayoutOrder = 9999,
        Visible = v125,
        [Out("AbsolutePosition")] = v224,
        [Out("AbsoluteSize")] = v225
    }
    local t26 = {
        name = "AddRoleToggle"
    }

    t26.text = p2:Computed(function(p85) -- line: 1314
        -- upvalues: v103 (copy)
        if p85(v103) then
            return "x"
        end

        return "+"
    end)
    t26.size = UDim2.fromOffset(28, 28)
    t26.isActive = v103
    t26.cornerRadius = UDim.new(1, 0)

    function t26.onActivate() -- line: 1320
        -- upvalues: v103 (copy), Fusion (copy)
        v103:set(not Fusion.peek(v103))
    end

    t28[Children] = { SearchRowToggle(p2, t26) }
    v263[Children] = {
        Frame3,
        v267,
        v268(t28)
    }
    Frame = Frame(v263)
    v263 = p2:New("Frame")
    v266 = {
        Name = "BottomReservation",
        BackgroundTransparency = 1,
        LayoutOrder = 4
    }
    v266.Size = p2:Computed(function(p86) -- line: 1334
        -- upvalues: v258 (copy)
        return UDim2.new(1, 0, 0, p86(v258))
    end)
    v265[Children] = {
        v273,
        v261,
        v262,
        Frame,
        v263(v266)
    }
    t21[Children] = {
        v264,
        Frame2(v265)
    }

    return ScrollingFrame(t21)
end
