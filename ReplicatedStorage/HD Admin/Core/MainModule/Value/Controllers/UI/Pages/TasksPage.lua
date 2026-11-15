-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local SplitRow = require(UI.Components.SplitRow)
local UserDetails = require(UI.Components.UserDetails)
local ScrollList = require(UI.Components.ScrollList)
local SearchBar = require(UI.Components.SearchBar)
local LoadingSpinner = require(UI.Components.LoadingSpinner)
local NoPermissionPlaceholder = require(UI.Components.NoPermissionPlaceholder)
local Icons = require(UI.Config.Icons)
local Permissions = require(UI.Util.Permissions)
local getTaskTitle = require(UI.Util.getTaskTitle)
local Remote = require(Modules.Objects.Remote)
local Prompt = require(Modules.Prompt)
local Children = Fusion.Children

local function formatElapsed(p1) -- line: 54
    local v1 = if p1 < 0 then 0 else p1

    if v1 < 60 then
        return (("%*s"):format(v1))
    end

    if v1 < 3600 then
        return (("%*m %*s"):format(math.floor(v1 / 60), v1 % 60))
    end

    return (("%*h %*m"):format(math.floor(v1 / 3600), (math.floor(v1 % 3600 / 60))))
end

return function(p2, p3) -- line: 70
    -- upvalues: Fusion (copy), Theme (copy), SplitRow (copy), UserDetails (copy), ScrollList (copy), SearchBar (copy), LoadingSpinner (copy), NoPermissionPlaceholder (copy), Icons (copy), Permissions (copy), getTaskTitle (copy), Remote (copy), Prompt (copy), Children (copy)
    local v6 = Permissions.youReady(p2)
    local Tasks = Permissions.canViewPage(p2, "Tasks")
    local onTaskActivate = p3.onTaskActivate

    local function buildBody(p4) -- line: 76
        -- upvalues: onTaskActivate (copy), Fusion (copy), Theme (copy), SplitRow (copy), UserDetails (copy), ScrollList (copy), SearchBar (copy), Icons (copy), Permissions (copy), getTaskTitle (copy), Remote (copy), Prompt (copy), Children (copy)
        local ActiveTasks = p4:Fuse("everyone", "ActiveTasks")
        local PermTasks = p4:Fuse("everyone", "PermTasks")
        local mayEditTasks = Permissions.hasPermission(p4, "mayEditTasks")
        local v7 = p4:Value("")
        local v8 = p4:Value(os.time())
        local v9 = false

        table.insert(p4, function() -- line: 84
            -- upvalues: v9 (ref)
            v9 = true
        end)

        local v11 = p4:Value({})
        local t1 = {}
        local t2 = {}
        local n1 = 1
        local v12 = false

        local function rebuildList() -- line: 94
            -- upvalues: ActiveTasks (copy), PermTasks (copy), v11 (copy), t1 (copy), t2 (copy), n1 (ref), v12 (ref), Fusion (copy)
            v12 = false

            local v13 = Fusion.peek(ActiveTasks)

            if typeof(v13) ~= "table" then
                return
            end

            local elapsed = os.clock()
            local t3 = {}
            local t4 = {}
            local t5 = {}

            for v14, v15 in v13 do
                if typeof(v14) == "string" and typeof(v15) == "table" then
                    t3[v14] = true
                    t2[v14] = nil

                    if typeof(v15.entryUID) == "string" then
                        t4[v15.entryUID] = true
                    end

                    if not t1[v14] then
                        local t6 = {
                            order = 0,
                            UID = v14,
                            commandName = tostring(v15.commandName or v15.commandKey or "Unknown"),
                            callerUserId = v15.callerUserId,
                            callerName = tostring(v15.callerName or ""),
                            callerDisplayName = tostring(v15.callerDisplayName or ""),
                            targetUserId = v15.targetUserId,
                            targetName = v15.targetName,
                            targetUserName = v15.targetUserName,
                            startedAt = tonumber(v15.startedAt) or os.time(),
                            args = v15.args,
                            qualifiers = v15.qualifiers,
                            modifiers = v15.modifiers,
                            entryUID = v15.entryUID
                        }

                        t1[v14] = t6
                        table.insert(t5, t6)
                    end
                end
            end

            local v18 = Fusion.peek(PermTasks)

            if typeof(v18) == "table" then
                for v19, v20 in v18 do
                    if typeof(v19) == "string" and typeof(v20) == "table" then
                        if t4[v19] then
                            local v21 = t1[v19]

                            if v21 and v21.isSaved then
                                t1[v19] = nil
                                t2[v19] = nil
                            end
                        else
                            t3[v19] = true
                            t2[v19] = nil

                            local v22 = t1[v19]

                            if v22 and not v22.isSaved then
                                t1[v19] = nil
                            end

                            if not t1[v19] then
                                local v24 = tostring(v20.commandKey or "Unknown")
                                local t7 = {
                                    order = 0,
                                    isSaved = true,
                                    UID = v19,
                                    commandName = v24:sub(1, 1):upper() .. v24:sub(2),
                                    callerUserId = v20.callerUserId,
                                    callerName = tostring(v20.callerName or ""),
                                    callerDisplayName = tostring(v20.callerDisplayName or ""),
                                    targetUserId = v20.targetUserId,
                                    targetName = v20.targetName,
                                    targetUserName = v20.targetUserName,
                                    startedAt = tonumber(v20.createdAt) or os.time(),
                                    args = v20.args,
                                    qualifiers = v20.qualifiers,
                                    modifiers = v20.modifiers,
                                    kind = tostring(v20.kind or "")
                                }

                                t1[v19] = t7
                                table.insert(t5, t7)
                            end
                        end
                    end
                end
            end

            table.sort(t5, function(p5, p6) -- line: 176
                if p5.startedAt == p6.startedAt then
                    return p5.UID < p6.UID
                end

                return p5.startedAt < p6.startedAt
            end)

            for _, v28 in t5 do
                v28.order = n1
                n1 += 1
            end

            local t8 = {}

            for v29, v30 in t1 do
                if t3[v29] then
                    table.insert(t8, v30)
                else
                    local v31 = t2[v29]

                    if not v31 then
                        v31 = elapsed
                        t2[v29] = elapsed
                    end

                    if elapsed - v31 <= 1 then
                        table.insert(t8, v30)
                    else
                        t1[v29] = nil
                        t2[v29] = nil
                    end
                end
            end

            table.sort(t8, function(p7, p8) -- line: 204
                local v32 = p7.isSaved == true or typeof(p7.entryUID) == "string"

                if v32 == (p8.isSaved == true or typeof(p8.entryUID) == "string") then
                    return p7.order < p8.order
                end

                return v32
            end)
            v11:set(t8)
        end

        local function markDirty() -- line: 217
            -- upvalues: v9 (ref), v11 (copy), v12 (ref), rebuildList (copy), Fusion (copy)
            v12 = true

            if #Fusion.peek(v11) == 0 then
                task.defer(function() -- line: 220
                    -- upvalues: v9 (ref), v12 (ref), rebuildList (copy)
                    if not v9 and v12 then
                        rebuildList()
                    end
                end)
            end
        end

        p4:Observer(ActiveTasks):onBind(markDirty)
        p4:Observer(PermTasks):onBind(markDirty)
        task.spawn(function() -- line: 228
            -- upvalues: ActiveTasks (copy), PermTasks (copy), v8 (copy), v9 (ref), v11 (copy), v12 (ref), rebuildList (copy), Fusion (copy)
            while true do
                if v9 then
                    return
                end

                task.wait(1)

                if v9 then
                    break
                end

                local v34 = Fusion.peek(ActiveTasks)
                local v35 = Fusion.peek(PermTasks)
                local v36 = if typeof(v34) == "table" then next(v34) ~= nil or typeof(v35) == "table" and next(v35) ~= nil else typeof(v35) == "table" and next(v35) ~= nil
                local v37 = #Fusion.peek(v11) > 0

                if v36 or v37 or v12 then
                    v8:set(os.time())
                    rebuildList()
                end
            end
        end)

        local v38 = p4:Computed(function(p9) -- line: 243
            -- upvalues: ActiveTasks (copy)
            return typeof(p9(ActiveTasks)) == "table"
        end)
        local v39 = p4:Computed(function(p10) -- line: 247
            -- upvalues: v7 (copy), v11 (copy), getTaskTitle (copy)
            local v40 = p10(v11)
            local v41 = (p10(v7) or ""):lower()

            if v41 == "" then
                return v40
            end

            local t9 = {}

            for _, v42 in v40 do
                if getTaskTitle(v42.commandName, v42.modifiers):lower():find(v41, 1, true) then
                    table.insert(t9, v42)
                elseif v42.callerName:lower():find(v41, 1, true) then
                    table.insert(t9, v42)
                elseif v42.callerDisplayName:lower():find(v41, 1, true) then
                    table.insert(t9, v42)
                elseif typeof(v42.targetName) == "string" and v42.targetName:lower():find(v41, 1, true) then
                    table.insert(t9, v42)
                end
            end

            return t9
        end)

        local function editTask(p11, p12, p13) -- line: 263
            -- upvalues: v9 (ref), Remote (copy), Prompt (copy)
            task.spawn(function() -- line: 264
                -- upvalues: p11 (copy), p12 (copy), p13 (copy), v9 (ref), Remote (copy), Prompt (copy)
                local v43, v44 = Remote.get("EditTask"):invokeServerAsync(p11, p12)

                if not v9 then
                    if not v43 then
                        Prompt.error((tostring(v44 or "Failed to edit task")))
                    end

                    if p13 then
                        p13(v43)
                    end
                end
            end)
        end

        local function renderTaskRow(p14, p15) -- line: 275
            -- upvalues: ActiveTasks (copy), PermTasks (copy), mayEditTasks (copy), v8 (copy), v9 (ref), onTaskActivate (copy), Theme (copy), SplitRow (copy), UserDetails (copy), Icons (copy), getTaskTitle (copy), Remote (copy), Prompt (copy), Children (copy)
            local v46 = p15.isSaved == true
            local v47 = p14:Computed(function(p16) -- line: 277
                -- upvalues: p15 (copy), v46 (copy), ActiveTasks (copy), PermTasks (copy)
                local v48 = p16(if v46 then PermTasks else ActiveTasks)

                return if typeof(v48) == "table" then v48[p15.UID] else nil
            end)
            local v49 = p14:Computed(function(p17) -- line: 282
                -- upvalues: v47 (copy)
                return p17(v47) == nil
            end)
            local v50 = p14:Computed(function(p18) -- line: 285
                -- upvalues: v47 (copy)
                local v51 = p18(v47)

                if typeof(v51) == "table" then
                    return v51.isPaused == true
                end

                return false
            end)
            local v52 = p14:Computed(function(p19) -- line: 289
                -- upvalues: p15 (copy), v46 (copy), v49 (copy), v50 (copy)
                if p19(v49) then
                    return "Ended"
                end

                if p19(v50) then
                    return "Paused"
                end

                if v46 or p15.entryUID ~= nil then
                    return "Perm"
                end

                return ""
            end)
            local v53 = p14:Computed(function(p20) -- line: 294
                -- upvalues: p15 (copy), v46 (copy), v49 (copy), v8 (copy)
                if v46 or p20(v49) then
                    return ""
                end

                local v54 = p20(v8) - p15.startedAt

                if v54 < 0 then
                    v54 = 0
                end

                if v54 < 60 then
                    return (("%*s"):format(v54))
                end

                if v54 < 3600 then
                    return (("%*m %*s"):format(math.floor(v54 / 60), v54 % 60))
                end

                return (("%*h %*m"):format(math.floor(v54 / 3600), (math.floor(v54 % 3600 / 60))))
            end)
            local v59 = p14:Computed(function(p21) -- line: 298
                -- upvalues: v49 (copy), mayEditTasks (copy)
                return p21(mayEditTasks) and not p21(v49)
            end)
            local v60 = typeof(p15.targetUserId) == "number"
            local v61 = false
            local v62 = p14:New("Frame")({
                Name = "StatusPill",
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = Theme.Color.Primary,
                Size = UDim2.new(0, 0, 0, 22),
                Visible = p14:Computed(function(p22) -- line: 311
                    -- upvalues: v52 (copy)
                    return p22(v52) ~= ""
                end),
                [Children] = {
                    p14:New("UICorner")({
                        CornerRadius = UDim.new(1, 0)
                    }),
                    p14:New("UIPadding")({
                        PaddingLeft = UDim.new(0, 10),
                        PaddingRight = UDim.new(0, 10)
                    }),
                    p14:New("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        AutomaticSize = Enum.AutomaticSize.X,
                        FontFace = p14:Computed(function(p23) -- line: 324
                            -- upvalues: Theme (copy)
                            return Font.new(p23(Theme.Font.Body), p23(Theme.FontWeight.Bold))
                        end),
                        Size = UDim2.new(0, 0, 1, 0),
                        Text = v52,
                        TextColor3 = Theme.Color.PrimaryContent,
                        TextSize = Theme.TextSize.Label
                    })
                }
            })
            local t11 = {
                height = 46,
                center = nil,
                name = "TaskRow_" .. p15.UID,
                layoutOrder = p15.order
            }
            local t12 = {
                name = "TaskRowSlot_" .. p15.UID,
                fills = true,
                onActivate = function() -- onActivate | line: 343
                    -- upvalues: p15 (copy), onTaskActivate (copy)
                    if onTaskActivate then
                        onTaskActivate(p15.UID, p15)
                    end
                end
            }
            local Frame2 = p14:New("Frame")
            local t13 = {
                Name = "ContentGroup",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0.5, 0),
                Size = UDim2.new(1, -24, 1, 0)
            }
            local v63 = p14:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            local t14 = {
                layoutOrder = 1,
                iconSize = 32,
                singleLine = true
            }

            if v60 then
                t14.userId = p15.targetUserId
                t14.iconImage = nil
                t14.iconImageInset = nil
            else
                t14.userId = nil
                t14.iconImage = Icons.Server
                t14.iconImageInset = 5
            end

            t14.displayName = getTaskTitle(p15.commandName, p15.modifiers)
            t14.username = if v60 then p15.targetUserName or p15.targetName else nil

            local v64 = UserDetails(p14, t14)

            p14:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }).Parent = v64
            t13[Children] = {
                v63,
                v64,
                p14:New("TextLabel")({
                    Name = "Elapsed",
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    AutomaticSize = Enum.AutomaticSize.X,
                    FontFace = p14:Computed(function(p24) -- line: 381
                        -- upvalues: Theme (copy)
                        return Font.new(p24(Theme.Font.Body), p24(Theme.FontWeight.Body))
                    end),
                    Size = UDim2.new(0, 0, 1, 0),
                    Text = v53,
                    TextColor3 = Theme.Color.NeutralContentDark,
                    TextSize = Theme.TextSize.Label
                }),
                p14:New("Frame")({
                    Name = "IndicatorSlot",
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundTransparency = 1,
                    LayoutOrder = 3,
                    Visible = p14:Computed(function(p25) -- line: 395
                        -- upvalues: v52 (copy)
                        return p25(v52) ~= ""
                    end),
                    [Children] = { v62 }
                })
            }
            t12[Children] = { Frame2(t13) }
            t11.left = t12
            t11.right = {
                name = "CancelSlot_" .. p15.UID,
                width = 40,
                visible = v59,
                onActivate = function() -- onActivate | line: 468
                    -- upvalues: p15 (copy), v46 (copy), v61 (ref), v9 (ref), Remote (copy), Prompt (copy)
                    if v61 then
                        return
                    end

                    v61 = true

                    local UID = p15.UID
                    local v66 = if v46 then "removeEntry" else "cancel"

                    local function v67() -- line: 471
                        -- upvalues: v61 (ref)
                        v61 = false
                    end

                    task.spawn(function() -- line: 264
                        -- upvalues: UID (copy), v67 (copy), v66 (copy), v9 (ref), Remote (copy), Prompt (copy)
                        local v68, v69 = Remote.get("EditTask"):invokeServerAsync(UID, v66)

                        if not v9 then
                            if not v68 then
                                Prompt.error((tostring(v69 or "Failed to edit task")))
                            end

                            if v67 then
                                v67(v68)
                            end
                        end
                    end)
                end,
                [Children] = {
                    p14:New("ImageLabel")({
                        Name = "CancelIcon",
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromOffset(14, 14),
                        Image = Icons.StopFill,
                        ImageColor3 = Theme.Color.BaseContent
                    })
                }
            }

            return SplitRow(p14, t11)
        end

        local v71 = p4:Computed(function(p26) -- line: 490
            -- upvalues: v7 (copy), v38 (copy), v39 (copy)
            if not p26(v38) or #p26(v39) > 0 then
                return ""
            end

            local v72 = p26(v7)

            if typeof(v72) ~= "string" or v72 == "" then
                return "No tasks are currently running"
            end

            return "No tasks match your search"
        end)

        return ScrollList(p4, {
            useStream = false,
            layoutOrder = 1,
            isReady = v38,
            items = v11,
            visibleItems = v39,
            renderItem = function(p27, p28) -- renderItem | line: 505
                -- upvalues: renderTaskRow (copy)
                return renderTaskRow(p27, p28)
            end,
            padding = UDim.new(0, 6),
            headerGap = UDim.new(0, 8),
            header = p4:New("Frame")({
                Name = "HeaderArea",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 0,
                Size = UDim2.fromScale(1, 0),
                [Children] = {
                    p4:New("UIListLayout")({
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDim.new(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    SearchBar(p4, {
                        placeholderText = "Search",
                        layoutOrder = 1,
                        searchText = v7
                    }),
                    p4:New("TextLabel")({
                        Name = "EmptyLabel",
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        FontFace = p4:Computed(function(p29) -- line: 533
                            -- upvalues: Theme (copy)
                            return Font.new(p29(Theme.Font.Body), p29(Theme.FontWeight.Body))
                        end),
                        Size = UDim2.fromScale(1, 0),
                        Text = v71,
                        TextColor3 = Theme.Color.NeutralContentDark,
                        TextSize = Theme.TextSize.Label,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        Visible = p4:Computed(function(p30) -- line: 541
                            -- upvalues: v71 (copy)
                            return p30(v71) ~= ""
                        end)
                    })
                }
            })
        })
    end

    return p2:New("Frame")({
        Name = "TasksPage",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0),
        [Children] = {
            p2:New("UIPadding")({
                PaddingBottom = UDim.new(0, 1),
                PaddingLeft = UDim.new(0, 1),
                PaddingRight = UDim.new(0, 1),
                PaddingTop = UDim.new(0, 1)
            }),
            p2:New("UIListLayout")({
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p2:Computed(function(p31, p32) -- line: 569
                -- upvalues: v6 (copy), Tasks (copy), buildBody (copy), LoadingSpinner (copy), NoPermissionPlaceholder (copy), Children (copy)
                if not p31(v6) then
                    return LoadingSpinner(p32, {
                        layoutOrder = 1
                    })
                end

                if p31(Tasks) then
                    return buildBody(p32)
                end

                return p32:New("Frame")({
                    Name = "Denied",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 160),
                    [Children] = { NoPermissionPlaceholder(p32, {}) }
                })
            end)
        }
    })
end
