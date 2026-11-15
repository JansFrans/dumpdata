-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local SplitRow = require(UI.Components.SplitRow)
local UserDetails = require(UI.Components.UserDetails)
local Checkbox = require(UI.Components.Checkbox)
local Pressable = require(UI.Components.Pressable)

require(UI.Components.TabBar)

local TabbedScroller = require(UI.Components.TabbedScroller)
local PlaceholderPage = require(UI.Pages.PlaceholderPage)
local SearchBar = require(UI.Components.SearchBar)
local LoadingGate = require(UI.Components.LoadingGate)
local SearchRowToggle = require(UI.Components.SearchRowToggle)
local Icons = require(UI.Config.Icons)
local Permissions = require(UI.Util.Permissions)
local NoPermissionPlaceholder = require(UI.Components.NoPermissionPlaceholder)
local Remote = require(Modules.Objects.Remote)
local Prompt = require(Modules.Prompt)
local clientUser = require(Modules.References.clientUser)
local Children = Fusion.Children
local t1 = {
    {
        label = "Bans",
        icon = Icons.ProhibitedFill
    },
    {
        label = "Warns",
        icon = Icons.WarningFill
    }
}
local t2 = {
    loader = "Loader",
    perm = "Perm",
    expire = "Time",
    server = "Server"
}

return function(p1, p2) -- line: 53
    -- upvalues: Fusion (copy), Theme (copy), SplitRow (copy), UserDetails (copy), Checkbox (copy), Pressable (copy), TabbedScroller (copy), PlaceholderPage (copy), SearchBar (copy), LoadingGate (copy), SearchRowToggle (copy), Icons (copy), Permissions (copy), NoPermissionPlaceholder (copy), Remote (copy), Prompt (copy), clientUser (copy), Children (copy), t1 (copy), t2 (copy)
    local ServerBans = p1:Fuse("everyone", "ServerBans")
    local PermanentBans = p1:Fuse("everyone", "PermanentBans")

    if p2.onRunPageOpen then
        task.spawn(function() -- line: 60
            -- upvalues: clientUser (copy)
            clientUser.everyone:fetchAsync("CommandInfo", "ban")
        end)
    end

    local v1 = p1:Computed(function(p3) -- line: 65
        -- upvalues: ServerBans (copy), PermanentBans (copy)
        local t3 = {}
        local t4 = {}

        for _, v2 in {
                p3(ServerBans),
                (p3(PermanentBans))
            } do
            if typeof(v2) == "table" then
                for v3, _ in v2 do
                    local v4 = tonumber(v3)

                    if v4 and not t3[v4] then
                        t3[v4] = true
                        table.insert(t4, v4)
                    end
                end
            end
        end

        table.sort(t4)

        return t4
    end)
    local v5 = p1:Value("")

    local function lookupNames(p4) -- line: 86
        -- upvalues: ServerBans (copy), PermanentBans (copy), Fusion (copy)
        local v6 = tostring(p4)

        for _, v7 in {
                Fusion.peek(ServerBans),
                Fusion.peek(PermanentBans)
            } do
            if typeof(v7) == "table" then
                local v8 = v7[v6]

                if typeof(v8) == "table" then
                    local UserInfo = v8.UserInfo

                    if typeof(UserInfo) == "table" then
                        return tostring(UserInfo.userName or ""), (tostring(UserInfo.userDisplayName or ""))
                    end
                end
            end
        end

        return "", ""
    end

    local v12 = p1:Computed(function(p5) -- line: 102
        -- upvalues: ServerBans (copy), PermanentBans (copy), v1 (copy), v5 (copy), lookupNames (copy)
        local v13 = p5(v1)
        local v14 = (p5(v5) or ""):lower()

        if v14 == "" then
            return v13
        end

        p5(ServerBans)
        p5(PermanentBans)

        local t5 = {}

        for _, v15 in v13 do
            local v16, v17 = lookupNames(v15)

            if v16:lower():find(v14, 1, true) then
                table.insert(t5, v15)
            elseif v17:lower():find(v14, 1, true) then
                table.insert(t5, v15)
            elseif tostring(v15):find(v14, 1, true) then
                table.insert(t5, v15)
            end
        end

        return t5
    end)
    local v18 = p1:Computed(function(p6) -- line: 121
        -- upvalues: ServerBans (copy), PermanentBans (copy), v5 (copy), v12 (copy)
        if typeof(p6(ServerBans)) ~= "table" or typeof(p6(PermanentBans)) ~= "table" or #p6(v12) > 0 then
            return ""
        end

        if (p6(v5) or "") == "" then
            return "No users are currently banned"
        end

        return "No users match your search"
    end)
    local v19 = p1:Value({})
    local v20 = p2.tabUserIds or { v12, v19 }
    local onUserActivate = p2.onUserActivate
    local v21 = p1:Value(1)

    local function resolveIndicatorKey(p7, p8, p9) -- line: 138
        local v22 = os.time()
        local v23 = false
        local v24 = false
        local v25 = false
        local v26 = false

        for _, v27 in { p8, p9 } do
            if typeof(v27) == "table" then
                local v28 = v27[tostring(p7)]

                if typeof(v28) == "table" then
                    local Bans = v28.Bans

                    if typeof(Bans) == "table" then
                        for _, v33 in Bans do
                            if typeof(v33) == "table" then
                                local v34 = v33.type or "perm"

                                if v34 == "expire" then
                                    local expiresAt = v33.expiresAt

                                    if typeof(expiresAt) == "number" and not (expiresAt <= v22) then
                                        if v33.source == "loader" then
                                            v23 = true
                                        end

                                        if v33.source == "admin" then
                                            if v34 == "perm" then
                                                v24 = true
                                            end

                                            if v34 == "expire" then
                                                v25 = true
                                            end

                                            if v34 == "server" then
                                                v26 = true
                                            end
                                        end
                                    end
                                else
                                    if v33.source == "loader" then
                                        v23 = true
                                    end

                                    if v33.source == "admin" then
                                        if v34 == "perm" then
                                            v24 = true
                                        end

                                        if v34 == "expire" then
                                            v25 = true
                                        end

                                        if v34 == "server" then
                                            v26 = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if v23 then
            return "loader"
        end

        if v24 then
            return "perm"
        end

        if v25 then
            return "expire"
        end

        return if v26 then "server" else nil
    end

    local v35 = p1:Value({})

    local function toggleSelection(p10, p11) -- line: 172
        -- upvalues: v35 (copy), Fusion (copy)
        local v36 = table.clone(Fusion.peek(v35))

        if p11 then
            if not table.find(v36, p10) then
                table.insert(v36, p10)
            end
        else
            local v37 = table.find(v36, p10)

            if v37 then
                table.remove(v36, v37)
            end
        end

        v35:set(v36)
    end

    local function isLoaderOnly(p12, p13, p14) -- line: 184
        local v38 = false
        local v39 = false

        for _, v40 in { p13, p14 } do
            if typeof(v40) == "table" then
                local v41 = v40[tostring(p12)]

                if typeof(v41) == "table" then
                    local Bans = v41.Bans

                    if typeof(Bans) == "table" then
                        for _, v44 in Bans do
                            if typeof(v44) == "table" then
                                if v44.source == "admin" then
                                    v38 = true
                                end

                                v39 = true
                            end
                        end
                    end
                end
            end
        end

        return v39 and not v38
    end

    local function renderBanRow(p15, p16, p17) -- line: 202
        -- upvalues: ServerBans (copy), PermanentBans (copy), onUserActivate (copy), resolveIndicatorKey (copy), v35 (copy), toggleSelection (copy), isLoaderOnly (copy), Fusion (copy), Theme (copy), SplitRow (copy), UserDetails (copy), Checkbox (copy), Children (copy), t2 (copy)
        local v45 = p15:Computed(function(p18) -- line: 203
            -- upvalues: p16 (copy), ServerBans (copy), PermanentBans (copy)
            for _, v46 in {
                    p18(ServerBans),
                    p18(PermanentBans)
                } do
                if typeof(v46) == "table" then
                    local v47 = v46[tostring(p16)]

                    if typeof(v47) == "table" then
                        local UserInfo = v47.UserInfo

                        if typeof(UserInfo) == "table" then
                            return (tostring(UserInfo.userDisplayName or ""))
                        end
                    end
                end
            end

            return nil
        end)
        local v49 = p15:Computed(function(p19) -- line: 216
            -- upvalues: p16 (copy), ServerBans (copy), PermanentBans (copy)
            for _, v50 in {
                    p19(ServerBans),
                    p19(PermanentBans)
                } do
                if typeof(v50) == "table" then
                    local v51 = v50[tostring(p16)]

                    if typeof(v51) == "table" then
                        local UserInfo = v51.UserInfo

                        if typeof(UserInfo) == "table" then
                            return (tostring(UserInfo.userName or ""))
                        end
                    end
                end
            end

            return nil
        end)
        local v53 = p15:Computed(function(p20) -- line: 230
            -- upvalues: p16 (copy), ServerBans (copy), PermanentBans (copy), resolveIndicatorKey (copy)
            return (resolveIndicatorKey(p16, p20(ServerBans), p20(PermanentBans)))
        end)
        local v54 = p15:Computed(function(p21) -- line: 233
            -- upvalues: v53 (copy), t2 (copy)
            local v55 = p21(v53)

            return v55 and t2[v55] or ""
        end)
        local v56 = p15:New("Frame")({
            Name = "TypeIndicator",
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = Theme.Color.Primary,
            Size = UDim2.new(0, 0, 0, 22),
            [Children] = {
                p15:New("UICorner")({
                    CornerRadius = UDim.new(1, 0)
                }),
                p15:New("UIPadding")({
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10)
                }),
                p15:New("TextLabel")({
                    Name = "Label",
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    FontFace = p15:Computed(function(p22) -- line: 254
                        -- upvalues: Theme (copy)
                        return Font.new(p22(Theme.Font.Body), p22(Theme.FontWeight.Bold))
                    end),
                    Size = UDim2.new(0, 0, 1, 0),
                    Text = v54,
                    TextColor3 = Theme.Color.PrimaryContent,
                    TextSize = Theme.TextSize.Label
                })
            }
        })
        local v57 = p15:Computed(function(p23) -- line: 266
            -- upvalues: p16 (copy), v35 (copy)
            return table.find(p23(v35), p16) ~= nil
        end)
        local v58 = p15:Computed(function(p24) -- line: 269
            -- upvalues: p16 (copy), ServerBans (copy), PermanentBans (copy), isLoaderOnly (copy)
            return (isLoaderOnly(p16, p24(ServerBans), p24(PermanentBans)))
        end)
        local v59 = p15:Computed(function(p25) -- line: 272
            -- upvalues: v58 (copy)
            return not p25(v58)
        end)
        local v60 = p15:New("Frame")({
            Name = "CheckboxWrap",
            AnchorPoint = Vector2.new(0.5, 0.5),
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.53, 0.5),
            Size = UDim2.fromOffset(0, 0),
            [Children] = {
                Checkbox(p15, {
                    checked = v57,
                    disabled = v58
                })
            }
        })
        local t6 = {
            height = 46,
            name = "BanRow_" .. tostring(p16),
            layoutOrder = p17
        }

        t6.left = {
            name = "CheckboxSlot_" .. tostring(p16),
            width = 36,
            interactable = v59,
            onActivate = function() -- onActivate | line: 301
                -- upvalues: p16 (copy), v57 (copy), v59 (copy), toggleSelection (copy), Fusion (copy)
                if Fusion.peek(v59) then
                    toggleSelection(p16, not Fusion.peek(v57))
                end
            end,
            [Children] = { v60 }
        }

        local t8 = {
            name = "BanRowSlot_" .. tostring(p16),
            fills = true,
            onActivate = function() -- onActivate | line: 311
                -- upvalues: p16 (copy), onUserActivate (copy), Fusion (copy)
                if onUserActivate then
                    local v61 = if typeof(onUserActivate) == "table" then Fusion.peek(onUserActivate) else onUserActivate

                    if v61 then
                        v61(p16)
                    end
                end
            end
        }
        local Frame = p15:New("Frame")
        local t9 = {
            Name = "ContentGroup",
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0.5, 0),
            Size = UDim2.new(1, -24, 1, 0)
        }
        local v62 = p15:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v63 = UserDetails(p15, {
            layoutOrder = 1,
            iconSize = 32,
            singleLine = true,
            userId = p16,
            displayName = v45,
            username = v49
        })

        p15:New("UIFlexItem")({
            FlexMode = Enum.UIFlexMode.Fill
        }).Parent = v63
        t9[Children] = {
            v62,
            v63,
            p15:New("Frame")({
                Name = "IndicatorSlot",
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                [Children] = { v56 }
            })
        }
        t8[Children] = { Frame(t9) }
        t6.center = t8

        return SplitRow(p15, t6)
    end

    local function buildTabContent(p26, p27) -- line: 359
        -- upvalues: renderBanRow (copy), v20 (copy), Children (copy)
        local v64 = v20[p27] or p26:Value({})
        local v65 = p26:Computed(function(p28) -- line: 363
            -- upvalues: v64 (copy)
            local t10 = {}

            for v66, v67 in (p28(v64)) do
                t10[v67] = v66
            end

            return t10
        end)

        return p26:New("Frame")({
            Name = "UserList_" .. p27,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            [Children] = {
                p26:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Vertical,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                p26:ForValues(v64, function(_, p30, p31) -- line: 382
                    -- upvalues: v65 (copy), renderBanRow (copy)
                    return renderBanRow(p30, p31, (p30:Computed(function(p32) -- line: 383
                        -- upvalues: p31 (copy), v65 (copy)
                        return p32(v65)[p31] or 0
                    end)))
                end)
            }
        })
    end

    local v70 = false

    table.insert(p1, function() -- line: 395
        -- upvalues: v70 (ref)
        v70 = true
    end)
    p1:Observer(v21):onChange(function() -- line: 397
        -- upvalues: v35 (copy)
        v35:set({})
    end)

    local v72 = p1:Computed(function(p33) -- line: 402
        -- upvalues: ServerBans (copy), PermanentBans (copy), v35 (copy), isLoaderOnly (copy)
        local v73 = p33(v35)
        local v74 = p33(ServerBans)
        local v75 = p33(PermanentBans)
        local t12 = {}

        for _, v76 in v73 do
            if not isLoaderOnly(v76, v74, v75) then
                table.insert(t12, v76)
            end
        end

        return t12
    end)
    local v77 = p1:Computed(function(p34) -- line: 414
        -- upvalues: v72 (copy)
        return #p34(v72) > 0
    end)
    local v78 = p1:Computed(function(p35) -- line: 417
        -- upvalues: v35 (copy)
        return #p35(v35)
    end)
    local v79 = p1:Value(false)
    local v80 = p1:Value(false)
    local n1 = 0

    p1:Observer(v35):onChange(function() -- line: 439
        -- upvalues: v79 (copy), n1 (ref), Fusion (copy)
        if Fusion.peek(v79) then
            n1 += 1
            v79:set(false)
        end
    end)

    local function runBulkUnban() -- line: 443
        -- upvalues: v35 (copy), v70 (ref), v72 (copy), v79 (copy), v80 (copy), n1 (ref), Fusion (copy), Remote (copy), Prompt (copy)
        if Fusion.peek(v80) then
            return
        end

        local v81 = Fusion.peek(v72)

        if #v81 ~= 0 then
            if Fusion.peek(v79) then
                n1 += 1
                v79:set(false)
                v80:set(true)
                task.spawn(function() -- line: 453
                    -- upvalues: v81 (copy), v35 (copy), v70 (ref), v80 (copy), Remote (copy), Prompt (copy)
                    local UnbanUser = Remote.get("UnbanUser")

                    if UnbanUser then
                        local t13 = {}
                        local n2 = 0
                        local v82

                        for _, v83 in v81 do
                            if v70 then
                                return
                            end

                            local v84, v85 = UnbanUser:invokeServerAsync(v83, nil)

                            if v84 then
                                n2 += 1
                            else
                                local v86 = tostring(v85)

                                v82 = if #t13 == 0 or v82 == v86 then v86 else ""
                                table.insert(t13, (("%* (%*)"):format(v83, v86)))
                            end
                        end

                        if not v70 then
                            v80:set(false)

                            if n2 > 0 then
                                Prompt.success((("Unbanned %* %*"):format(n2, n2 == 1 and "user" or "users")))
                            end

                            if #t13 > 0 and v82 ~= nil and v82 ~= "" then
                                Prompt.error(v82)
                            elseif #t13 > 0 then
                                Prompt.error((("Failed: %*"):format((table.concat(t13, ", ")))))
                            end

                            v35:set({})
                        end
                    elseif not v70 then
                        v80:set(false)
                        Prompt.error("Unban remote not available")
                    end
                end)
            else
                n1 += 1

                local v88 = n1

                v79:set(true)
                task.delay(2, function() -- line: 432
                    -- upvalues: v88 (copy), v70 (ref), v79 (copy), n1 (ref)
                    if not v70 and n1 == v88 then
                        v79:set(false)
                    end
                end)
            end
        end
    end

    local v89 = p1:Computed(function(p36) -- line: 489
        -- upvalues: v72 (copy), v78 (copy), v79 (copy), v80 (copy)
        if p36(v80) then
            return (`Unbanning ({#p36(v72)})...`)
        end

        if p36(v79) then
            return "Confirm?"
        end

        return (("Unban (%*)"):format((p36(v78))))
    end)
    local v90 = p1:Computed(function(p37) -- line: 499
        -- upvalues: v78 (copy)
        if p37(v78) > 0 then
            return 50
        end

        return 0
    end)
    local v94 = p1:New("Frame")({
        Name = "BulkActionSlot",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = p1:Computed(function(p38) -- line: 507
            -- upvalues: v78 (copy)
            return p38(v78) > 0
        end),
        [Children] = {
            p1:New("UIPadding")({
                PaddingTop = UDim.new(0, 8)
            }),
            Pressable(p1, {
                name = "BulkUnbanButton",
                size = UDim2.new(1, 0, 0, 0),
                automaticSize = Enum.AutomaticSize.Y,
                backgroundColor = p1:Computed(function(p39) -- line: 518
                    -- upvalues: v77 (copy), Theme (copy)
                    if p39(v77) then
                        return (p39(Theme.Color.Primary))
                    end

                    return (p39(Theme.Color.NeutralContent))
                end),
                interactable = p1:Computed(function(p40) -- line: 523
                    -- upvalues: v77 (copy), v80 (copy)
                    return p40(v77) and not p40(v80)
                end),
                onActivate = runBulkUnban,
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    }),
                    p1:New("UIPadding")({
                        PaddingTop = UDim.new(0, 10),
                        PaddingBottom = UDim.new(0, 10),
                        PaddingLeft = UDim.new(0, 18),
                        PaddingRight = UDim.new(0, 18)
                    }),
                    p1:New("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        FontFace = p1:Computed(function(p41) -- line: 539
                            -- upvalues: Theme (copy)
                            return Font.new(p41(Theme.Font.Body), p41(Theme.FontWeight.Bold))
                        end),
                        Size = UDim2.new(1, 0, 0, 0),
                        Text = v89,
                        TextColor3 = p1:Computed(function(p42) -- line: 544
                            -- upvalues: v77 (copy), Theme (copy)
                            if p42(v77) then
                                return (p42(Theme.Color.PrimaryContent))
                            end

                            return (p42(Theme.Color.NeutralContentDark))
                        end),
                        TextSize = Theme.TextSize.Body,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        TextYAlignment = Enum.TextYAlignment.Center
                    })
                }
            })
        }
    })
    local t17 = {
        Permissions.canViewPage(p1, "Bans"),
        (Permissions.canViewPage(p1, "Warns"))
    }

    return p1:New("Frame")({
        Name = "ModerationPage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            TabbedScroller(p1, {
                tabs = t1,
                activeTabRef = v21,
                buildTabContent = function(p43, p44) -- buildTabContent | line: 574
                    -- upvalues: p2 (copy), ServerBans (copy), PermanentBans (copy), v5 (copy), v18 (copy), buildTabContent (copy), t17 (copy), Theme (copy), PlaceholderPage (copy), SearchBar (copy), LoadingGate (copy), SearchRowToggle (copy), Icons (copy), NoPermissionPlaceholder (copy), Children (copy)
                    local v95 = t17[p44]
                    local v96

                    if p44 == 2 then
                        v96 = PlaceholderPage(p43, {
                            pageName = "Warns",
                            centered = true
                        })
                    else
                        local v97 = buildTabContent(p43, p44)

                        v96 = p43:New("Frame")({
                            Name = "BansWithSearch",
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            Size = UDim2.fromScale(1, 0),
                            [Children] = {
                                p43:New("UIListLayout")({
                                    FillDirection = Enum.FillDirection.Vertical,
                                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                    SortOrder = Enum.SortOrder.LayoutOrder,
                                    Padding = UDim.new(0, 8)
                                }),
                                SearchBar(p43, {
                                    placeholderText = "Search",
                                    layoutOrder = 0,
                                    searchText = v5,
                                    leadingSlot = SearchRowToggle(p43, {
                                        name = "BanToggle",
                                        icon = Icons.AddFill,
                                        iconSize = UDim2.fromOffset(14, 14),
                                        onActivate = function() -- onActivate | line: 601
                                            -- upvalues: p2 (copy)
                                            if p2.onRunPageOpen then
                                                p2.onRunPageOpen("ban", {
                                                    autoOpenUserArg = true
                                                })
                                            end
                                        end
                                    }),
                                    leadingSlotVisible = p43:Computed(function() -- line: 607
                                        -- upvalues: p2 (copy)
                                        return p2.onRunPageOpen ~= nil
                                    end)
                                }),
                                p43:New("TextLabel")({
                                    Name = "EmptyLabel",
                                    BackgroundTransparency = 1,
                                    LayoutOrder = 1,
                                    AutomaticSize = Enum.AutomaticSize.Y,
                                    FontFace = p43:Computed(function(p45) -- line: 616
                                        -- upvalues: Theme (copy)
                                        return Font.new(p45(Theme.Font.Body), p45(Theme.FontWeight.Body))
                                    end),
                                    Size = UDim2.fromScale(1, 0),
                                    Text = v18,
                                    TextColor3 = Theme.Color.NeutralContentDark,
                                    TextSize = Theme.TextSize.Label,
                                    TextXAlignment = Enum.TextXAlignment.Center,
                                    Visible = p43:Computed(function(p46) -- line: 624
                                        -- upvalues: v18 (copy)
                                        return p46(v18) ~= ""
                                    end)
                                }),
                                p43:New("Frame")({
                                    Name = "ListWrap",
                                    AutomaticSize = Enum.AutomaticSize.Y,
                                    BackgroundTransparency = 1,
                                    LayoutOrder = 2,
                                    Size = UDim2.fromScale(1, 0),
                                    [Children] = {
                                        LoadingGate(p43, {
                                            isReady = p43:Computed(function(p47) -- line: 636
                                                -- upvalues: ServerBans (copy), PermanentBans (copy)
                                                if typeof(p47(ServerBans)) == "table" then
                                                    return typeof(p47(PermanentBans)) == "table"
                                                end

                                                return false
                                            end),
                                            [Children] = { v97 }
                                        })
                                    }
                                })
                            }
                        })
                    end

                    return p43:New("Frame")({
                        Name = "TabGate_" .. p44,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 1),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        [Children] = {
                            p43:New("Frame")({
                                Name = "Body",
                                BackgroundTransparency = 1,
                                Size = UDim2.fromScale(1, 1),
                                AutomaticSize = Enum.AutomaticSize.Y,
                                Visible = v95,
                                [Children] = { v96 }
                            }),
                            p43:New("Frame")({
                                Name = "Denied",
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, 0, 160),
                                Visible = p43:Computed(function(p48) -- line: 664
                                    -- upvalues: v95 (copy)
                                    return not p48(v95)
                                end),
                                [Children] = { NoPermissionPlaceholder(p43, {}) }
                            })
                        }
                    })
                end,
                footerSlot = v94,
                footerHeight = v90
            })
        }
    })
end
