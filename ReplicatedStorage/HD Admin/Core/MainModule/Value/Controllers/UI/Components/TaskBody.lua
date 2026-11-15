-- https://lua.expert

local Players = game:GetService("Players")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Permissions = require(UI.Util.Permissions)
local getTaskTitle = require(UI.Util.getTaskTitle)
local Pressable = require(UI.Components.Pressable)
local Remote = require(Modules.Objects.Remote)
local Prompt = require(Modules.Prompt)
local Children = Fusion.Children

local function formatRelativePast(p1, p2) -- line: 41
    if typeof(p1) ~= "number" or p1 <= 0 then
        return ""
    end

    local v2 = math.max(0, p2 - p1)

    if not (v2 < 60) then
        for _, v3 in {
                {
                    name = "day",
                    seconds = 86400
                },
                {
                    name = "hour",
                    seconds = 3600
                },
                {
                    name = "minute",
                    seconds = 60
                }
            } do
            if not (v2 < v3.seconds) then
                local v5 = math.floor(v2 / v3.seconds)

                return (("%* %* ago"):format(v5, if v5 == 1 then v3.name else v3.name .. "s"))
            end
        end
    end

    return "just now"
end

local function formatAbsolute(p3) -- line: 59
    if typeof(p3) ~= "number" or p3 <= 0 then
        return ""
    end

    local v6 = os.date("*t", p3)

    return string.format("%04d-%02d-%02d %02d:%02d", v6.year, v6.month, v6.day, v6.hour, v6.min)
end

local function formatTokens(p4) -- line: 68
    if typeof(p4) ~= "table" then
        return ""
    end

    local t1 = {}

    if #p4 > 0 then
        for _, v7 in p4 do
            table.insert(t1, (tostring(v7)))
        end
    else
        for v9, v10 in p4 do
            if typeof(v10) == "table" and #v10 > 0 then
                local t2 = {}

                for _, v11 in v10 do
                    table.insert(t2, (tostring(v11)))
                end

                table.insert(t1, (("%* (%*)"):format(tostring(v9), (table.concat(t2, ", ")))))
            else
                table.insert(t1, (tostring(v9)))
            end
        end
    end

    return table.concat(t1, ", ")
end

return function(p5, p6) -- line: 93
    -- upvalues: Players (copy), Fusion (copy), Theme (copy), Permissions (copy), getTaskTitle (copy), Pressable (copy), Remote (copy), Prompt (copy), Children (copy), formatRelativePast (copy), formatTokens (copy)
    local taskUID, onOpenProfile = p6.taskUID, p6.onOpenProfile
    local v15 = false

    table.insert(p5, function() -- line: 97
        -- upvalues: v15 (ref)
        v15 = true
    end)

    local v17 = p5:Value(os.time())
    local ActiveTasks = p5:Fuse("everyone", "ActiveTasks")
    local PermTasks = p5:Fuse("everyone", "PermTasks")
    local v18 = p5:Fuse("temp", "OwnTaskArgs", taskUID)
    local mayEditTasks = Permissions.hasPermission(p5, "mayEditTasks")
    local v19 = typeof(p6.snapshot) == "table" and p6.snapshot.isSaved == true
    local v20 = p5:Computed(function(p7) -- line: 108
        -- upvalues: taskUID (copy), PermTasks (copy)
        local v21 = p7(PermTasks)

        return if typeof(v21) == "table" then v21[taskUID] else nil
    end)
    local v22 = p5:Computed(function(p8) -- line: 113
        -- upvalues: taskUID (copy), ActiveTasks (copy)
        local v23 = p8(ActiveTasks)

        return if typeof(v23) == "table" then v23[taskUID] else nil
    end)
    local v24 = p5:Computed(function(p9) -- line: 119
        -- upvalues: v20 (copy), v22 (copy), v19 (copy)
        return p9(v22) == nil and (v19 or p9(v20) ~= nil)
    end)
    local v25 = p5:Computed(function(p10) -- line: 126
        -- upvalues: v20 (copy), v22 (copy), v24 (copy)
        if p10(v24) then
            return p10(v20)
        end

        return p10(v22)
    end)
    local v26 = p5:Computed(function(p11) -- line: 132
        -- upvalues: v25 (copy)
        return p11(v25) ~= nil
    end)
    local v27 = p5:Value(p6.snapshot)

    local function captureEntry() -- line: 138
        -- upvalues: taskUID (copy), ActiveTasks (copy), PermTasks (copy), v24 (copy), v27 (copy), Fusion (copy)
        if Fusion.peek(v24) then
            local v28 = Fusion.peek(PermTasks)
            local v29 = if typeof(v28) == "table" then v28[taskUID] else nil

            if typeof(v29) == "table" then
                local v31 = tostring(v29.commandKey or "Task")

                v27:set({
                    isSaved = true,
                    commandName = v31:sub(1, 1):upper() .. v31:sub(2),
                    callerUserId = v29.callerUserId,
                    callerName = v29.callerName,
                    callerDisplayName = v29.callerDisplayName,
                    targetUserId = v29.targetUserId,
                    targetName = v29.targetName,
                    startedAt = v29.createdAt,
                    args = v29.args,
                    qualifiers = v29.qualifiers,
                    modifiers = v29.modifiers,
                    kind = v29.kind
                })
            end
        else
            local v32 = Fusion.peek(ActiveTasks)
            local v33 = if typeof(v32) == "table" then v32[taskUID] else nil

            if typeof(v33) == "table" then
                v27:set(v33)
            end
        end
    end

    captureEntry()
    p5:Observer(ActiveTasks):onChange(captureEntry)
    p5:Observer(PermTasks):onChange(captureEntry)
    task.spawn(function() -- line: 171
        -- upvalues: v15 (ref), v17 (copy), v26 (copy), Fusion (copy)
        while true do
            if v15 then
                return
            end

            task.wait(1)

            if v15 then
                break
            end

            if Fusion.peek(v26) then
                v17:set(os.time())
            end
        end
    end)

    local v34 = p5:Computed(function(p12) -- line: 180
        -- upvalues: v20 (copy), v24 (copy), v25 (copy), v27 (copy)
        if p12(v24) then
            if p12(v20) == nil then
                return "Ended"
            end

            return "Perm"
        end

        local v35 = p12(v25)

        if v35 == nil then
            return "Ended"
        end

        if v35.isPaused == true then
            return "Paused"
        end

        local v36 = p12(v27)

        if typeof(v36) == "table" and typeof(v36.entryUID) == "string" then
            return "Perm"
        end

        return ""
    end)
    local v37 = p5:Computed(function(p13) -- line: 192
        -- upvalues: v27 (copy), getTaskTitle (copy)
        local v38 = p13(v27)

        if typeof(v38) ~= "table" then
            return "Task"
        end

        return getTaskTitle(tostring(v38.commandName or v38.commandKey or "Task"), v38.modifiers)
    end)
    local v40 = p5:Computed(function(p14) -- line: 198
        -- upvalues: v27 (copy)
        local v41 = p14(v27)

        if typeof(v41) == "table" then
            local callerUserId = v41.callerUserId

            if typeof(callerUserId) == "number" then
                return callerUserId
            end
        end

        return nil
    end)
    local v42 = p5:Computed(function(p15) -- line: 205
        -- upvalues: v27 (copy)
        local v43 = p15(v27)

        if typeof(v43) ~= "table" then
            return nil
        end

        local targetUserId = v43.targetUserId

        return if typeof(targetUserId) == "number" and v43.callerUserId ~= targetUserId then targetUserId else nil
    end)
    local v44 = p5:Computed(function(p16) -- line: 213
        -- upvalues: v27 (copy)
        local v45 = p16(v27)

        if typeof(v45) ~= "table" then
            return "Unknown"
        end

        local callerUserId = v45.callerUserId

        if typeof(callerUserId) ~= "number" then
            return "Server"
        end

        local v47 = tostring(v45.callerDisplayName or "")
        local v49 = tostring(v45.callerName or "")

        if v47 == "" then
            return (tostring(callerUserId))
        end

        if v49 == "" then
            return v47
        end

        return (("%* (@%*)"):format(v47, v49))
    end)
    local v50 = p5:Computed(function(p17) -- line: 224
        -- upvalues: v27 (copy)
        local v51 = p17(v27)

        if typeof(v51) == "table" then
            local targetName = v51.targetName

            if typeof(targetName) == "string" then
                return targetName
            end
        end

        return ""
    end)
    local v52 = p5:Computed(function(p18) -- line: 230
        -- upvalues: v27 (copy)
        local v53 = p18(v27)

        if typeof(v53) == "table" then
            return v53.targetUserId ~= nil
        end

        return false
    end)
    local v54 = p5:Computed(function(p19) -- line: 234
        -- upvalues: v17 (copy), v27 (copy), formatRelativePast (copy)
        local v55 = p19(v27)

        if typeof(v55) ~= "table" then
            return "Unknown"
        end

        local v56 = tonumber(v55.startedAt)

        if not v56 then
            return "Unknown"
        end

        local v58 = formatRelativePast(v56, (p19(v17)))
        local v59

        if typeof(v56) ~= "number" or v56 <= 0 then
            v59 = ""
        else
            local v60 = os.date("*t", v56)

            v59 = string.format("%04d-%02d-%02d %02d:%02d", v60.year, v60.month, v60.day, v60.hour, v60.min)
        end

        if v58 == "" then
            return v59
        end

        return (("%* (%*)"):format(v58, v59))
    end)
    local v61 = p5:Computed(function(p20) -- line: 246
        -- upvalues: v24 (copy), v27 (copy)
        if not p20(v24) then
            return ""
        end

        local v62 = p20(v27)
        local kind = if typeof(v62) == "table" then v62.kind else nil

        if kind == "permPinned" then
            return "Whenever they join any server"
        end

        if kind == "joinPlayers" then
            return "For every player who joins any server"
        end

        if kind == "joinServer" then
            return "On every server startup"
        end

        return ""
    end)
    local v63 = p5:Computed(function(p21) -- line: 260
        -- upvalues: v18 (copy), v27 (copy), Players (copy), formatTokens (copy)
        local v64 = p21(v27)

        if typeof(v64) ~= "table" then
            return ""
        end

        local v65 = p21(v18)

        if not (Players.LocalPlayer ~= nil and v64.callerUserId == Players.LocalPlayer.UserId) or typeof(v65) ~= "table" then
            return formatTokens(v64.args)
        end

        return formatTokens(v65)
    end)
    local v66 = p5:Computed(function(p22) -- line: 270
        -- upvalues: v27 (copy), formatTokens (copy)
        local v67 = p22(v27)

        if typeof(v67) == "table" then
            return (formatTokens(v67.qualifiers))
        end

        return ""
    end)
    local v68 = p5:Computed(function(p23) -- line: 274
        -- upvalues: v27 (copy), formatTokens (copy)
        local v69 = p23(v27)

        if typeof(v69) == "table" then
            return (formatTokens(v69.modifiers))
        end

        return ""
    end)
    local v70 = p5:Value(false)

    local function cancelTask() -- line: 280
        -- upvalues: taskUID (copy), v15 (ref), v24 (copy), v70 (copy), Fusion (copy), Remote (copy), Prompt (copy)
        if Fusion.peek(v70) then
            return
        end

        v70:set(true)

        local v71 = Fusion.peek(v24)

        task.spawn(function() -- line: 284
            -- upvalues: v71 (copy), taskUID (copy), v15 (ref), v70 (copy), Remote (copy), Prompt (copy)
            local v73, v74 = Remote.get("EditTask"):invokeServerAsync(taskUID, if v71 then "removeEntry" else "cancel")

            if not v15 then
                v70:set(false)

                if not v73 then
                    local v75 = if v71 then "Failed to remove perm task" else "Failed to cancel task"

                    Prompt.error((tostring(v74 or v75)))
                end
            end
        end)
    end

    local v77 = p5:Computed(function(p24) -- line: 296
        -- upvalues: mayEditTasks (copy), v26 (copy)
        return p24(mayEditTasks) and p24(v26)
    end)
    local v78 = p5:Computed(function(p25) -- line: 301
        -- upvalues: v27 (copy)
        local v79 = p25(v27)

        if typeof(v79) ~= "table" then
            return false
        end

        return typeof(v79.entryUID) == "string"
    end)
    local v80 = if Players.LocalPlayer then Players.LocalPlayer.UserId else 0
    local v81 = p5:Computed(function(p26) -- line: 308
        -- upvalues: v24 (copy), v26 (copy), v27 (copy), v80 (copy)
        if p26(v24) or not p26(v26) then
            return false
        end

        local v82 = p26(v27)

        if typeof(v82) ~= "table" then
            return false
        end

        if v82.hasPrompt == true then
            return v82.callerUserId == v80
        end

        return false
    end)
    local v83 = p5:Value(false)

    local function retrievePrompt() -- line: 319
        -- upvalues: taskUID (copy), v15 (ref), v83 (copy), Fusion (copy), Remote (copy), Prompt (copy)
        if not Fusion.peek(v83) then
            v83:set(true)
            task.spawn(function() -- line: 322
                -- upvalues: taskUID (copy), v15 (ref), v83 (copy), Remote (copy), Prompt (copy)
                local retrievePrompt, retrievePrompt2 = Remote.get("EditTask"):invokeServerAsync(taskUID, "retrievePrompt")

                if not v15 then
                    v83:set(false)

                    if not retrievePrompt then
                        Prompt.error((tostring(retrievePrompt2 or "Failed to open controls")))
                    end
                end
            end)
        end
    end

    local function fieldRow(p27, p28, p29, p30) -- line: 335
        -- upvalues: p5 (copy), Theme (copy), Children (copy)
        return p5:New("Frame")({
            Name = "Field_" .. p28,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = p27,
            Size = UDim2.new(1, 0, 0, 0),
            Visible = p30,
            [Children] = {
                p5:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    VerticalAlignment = Enum.VerticalAlignment.Top,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                p5:New("TextLabel")({
                    Name = "Label",
                    LayoutOrder = 1,
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    FontFace = p5:Computed(function(p31) -- line: 356
                        -- upvalues: Theme (copy)
                        return Font.new(p31(Theme.Font.Body), p31(Theme.FontWeight.Body))
                    end),
                    Size = UDim2.new(0, 76, 0, 0),
                    Text = p28 .. ":",
                    TextColor3 = Theme.Color.NeutralContentDark,
                    TextSize = Theme.TextSize.Label,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top
                }),
                p5:New("TextLabel")({
                    Name = "Value",
                    LayoutOrder = 2,
                    BackgroundTransparency = 1,
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    FontFace = p5:Computed(function(p32) -- line: 371
                        -- upvalues: Theme (copy)
                        return Font.new(p32(Theme.Font.Body), p32(Theme.FontWeight.Body))
                    end),
                    Size = UDim2.new(1, -84, 0, 0),
                    Text = p29,
                    TextColor3 = Theme.Color.BaseContent,
                    TextSize = Theme.TextSize.Label,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top
                })
            }
        })
    end

    local function actionButton(p33, p34, p35, p36, p37, p38) -- line: 386
        -- upvalues: p5 (copy), Theme (copy), Pressable (copy), Children (copy)
        return Pressable(p5, {
            name = "ActionButton",
            layoutOrder = p33,
            size = UDim2.fromOffset(0, 0),
            automaticSize = Enum.AutomaticSize.Y,
            visible = p36,
            backgroundColor = p5:Computed(function(p39) -- line: 393
                -- upvalues: p35 (copy), p37 (copy), Theme (copy)
                if not p39(p35) then
                    return p39(Theme.Color.NeutralContent)
                end

                if p37 then
                    return (p39(Theme.Color.Primary))
                end

                return (p39(Theme.Color.NeutralContent))
            end),
            interactable = p35,
            onActivate = p38,
            [Children] = {
                p5:New("UICorner")({
                    CornerRadius = UDim.new(0, 6)
                }),
                p5:New("UIPadding")({
                    PaddingLeft = UDim.new(0, 18),
                    PaddingRight = UDim.new(0, 18),
                    PaddingTop = UDim.new(0, 6),
                    PaddingBottom = UDim.new(0, 6)
                }),
                p5:New("TextLabel")({
                    Name = "Label",
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    FontFace = p5:Computed(function(p40) -- line: 411
                        -- upvalues: Theme (copy)
                        return Font.new(p40(Theme.Font.Body), p40(Theme.FontWeight.Bold))
                    end),
                    Size = UDim2.new(1, 0, 0, 0),
                    Text = p34,
                    TextColor3 = p5:Computed(function(p41) -- line: 416
                        -- upvalues: p35 (copy), p37 (copy), Theme (copy)
                        if not p41(p35) then
                            return p41(Theme.Color.NeutralContentDark)
                        end

                        if p37 then
                            return (p41(Theme.Color.PrimaryContent))
                        end

                        return (p41(Theme.Color.BaseContent))
                    end),
                    TextSize = Theme.TextSize.Body,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center
                })
            }
        })
    end

    return p5:New("Frame")({
        Name = "TaskBody",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Color.Neutral,
        LayoutOrder = p6.layoutOrder or 0,
        Size = UDim2.new(1, 0, 0, 0),
        [Children] = {
            p5:New("UIStroke")({
                Transparency = 0.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p5:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p5:New("UIPadding")({
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10)
            }),
            p5:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p5:New("Frame")({
                Name = "Title",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Size = UDim2.new(1, 0, 0, 0),
                Visible = p5:Computed(function(p42) -- line: 463
                    -- upvalues: v34 (copy)
                    return p42(v34) ~= ""
                end),
                [Children] = {
                    p5:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        HorizontalAlignment = Enum.HorizontalAlignment.Right,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p5:New("Frame")({
                        Name = "StatusPill",
                        LayoutOrder = 1,
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = Theme.Color.Primary,
                        Size = UDim2.new(0, 0, 0, 22),
                        [Children] = {
                            p5:New("UICorner")({
                                CornerRadius = UDim.new(1, 0)
                            }),
                            p5:New("UIPadding")({
                                PaddingLeft = UDim.new(0, 10),
                                PaddingRight = UDim.new(0, 10)
                            }),
                            p5:New("TextLabel")({
                                Name = "Label",
                                BackgroundTransparency = 1,
                                AutomaticSize = Enum.AutomaticSize.X,
                                FontFace = p5:Computed(function(p43) -- line: 490
                                    -- upvalues: Theme (copy)
                                    return Font.new(p43(Theme.Font.Body), p43(Theme.FontWeight.Bold))
                                end),
                                Size = UDim2.new(0, 0, 1, 0),
                                Text = v34,
                                TextColor3 = Theme.Color.PrimaryContent,
                                TextSize = Theme.TextSize.Label
                            })
                        }
                    })
                }
            }),
            fieldRow(2, "Name", v37, nil),
            fieldRow(3, "Caller", v44, nil),
            fieldRow(4, "Target", v50, v52),
            fieldRow(5, "Started", v54, p5:Computed(function(p44) -- line: 506
                -- upvalues: v24 (copy)
                return not p44(v24)
            end)),
            fieldRow(6, "Created", v54, v24),
            fieldRow(7, "Reapplies", v61, p5:Computed(function(p45) -- line: 510
                -- upvalues: v61 (copy)
                return p45(v61) ~= ""
            end)),
            fieldRow(8, "Args", v63, p5:Computed(function(p46) -- line: 513
                -- upvalues: v63 (copy)
                return p46(v63) ~= ""
            end)),
            fieldRow(9, "Qualifiers", v66, p5:Computed(function(p47) -- line: 516
                -- upvalues: v66 (copy)
                return p47(v66) ~= ""
            end)),
            fieldRow(10, "Modifiers", v68, p5:Computed(function(p48) -- line: 519
                -- upvalues: v68 (copy)
                return p48(v68) ~= ""
            end)),
            fieldRow(11, "Task ID", taskUID, nil),
            p5:New("Frame")({
                Name = "ActionFooter",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 12,
                Size = UDim2.new(1, 0, 0, 0),
                [Children] = {
                    p5:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDim.new(0, 4),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    actionButton(1, p5:Computed(function(p49) -- line: 540
                        -- upvalues: v83 (copy)
                        if p49(v83) then
                            return "Opening..."
                        end

                        return "Edit Command"
                    end), p5:Computed(function(p50) -- line: 543
                        -- upvalues: v81 (copy), v83 (copy)
                        return p50(v81) and not p50(v83)
                    end), v81, false, retrievePrompt),
                    actionButton(2, p5:Computed(function() -- line: 551
                        return "View Caller's Profile"
                    end), p5:Computed(function(p51) -- line: 552
                        -- upvalues: v40 (copy)
                        return p51(v40) ~= nil
                    end), p5:Computed(function(p52) -- line: 555
                        -- upvalues: onOpenProfile (copy), v40 (copy)
                        return p52(v40) ~= nil and onOpenProfile ~= nil
                    end), false, function() -- line: 559
                        -- upvalues: onOpenProfile (copy), v40 (copy), Fusion (copy)
                        local v105 = Fusion.peek(v40)

                        if typeof(v105) == "number" and onOpenProfile then
                            onOpenProfile(v105)
                        end
                    end),
                    actionButton(3, p5:Computed(function() -- line: 567
                        return "View Target's Profile"
                    end), p5:Computed(function(p53) -- line: 568
                        -- upvalues: v42 (copy)
                        return p53(v42) ~= nil
                    end), p5:Computed(function(p54) -- line: 571
                        -- upvalues: onOpenProfile (copy), v42 (copy)
                        return p54(v42) ~= nil and onOpenProfile ~= nil
                    end), false, function() -- line: 575
                        -- upvalues: onOpenProfile (copy), v42 (copy), Fusion (copy)
                        local v107 = Fusion.peek(v42)

                        if typeof(v107) == "number" and onOpenProfile then
                            onOpenProfile(v107)
                        end
                    end),
                    actionButton(4, p5:Computed(function(p55) -- line: 583
                        -- upvalues: v24 (copy), v70 (copy), v78 (copy)
                        if p55(v24) then
                            if p55(v70) then
                                return "Removing..."
                            end

                            return "Remove Perm Task"
                        end

                        if p55(v70) then
                            return "Cancelling..."
                        end

                        if p55(v78) then
                            return "Cancel Task (All Servers)"
                        end

                        return "Cancel Task"
                    end), p5:Computed(function(p56) -- line: 590
                        -- upvalues: v70 (copy), v77 (copy)
                        return p56(v77) and not p56(v70)
                    end), v77, true, cancelTask),
                    p5:New("TextLabel")({
                        Name = "FooterNote",
                        LayoutOrder = 5,
                        BackgroundTransparency = 1,
                        TextWrapped = true,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        FontFace = p5:Computed(function(p57) -- line: 602
                            -- upvalues: Theme (copy)
                            return Font.new(p57(Theme.Font.Body), p57(Theme.FontWeight.Body))
                        end),
                        Size = UDim2.new(1, 0, 0, 0),
                        Text = p5:Computed(function(p58) -- line: 606
                            -- upvalues: v24 (copy)
                            if p58(v24) then
                                return "This perm task has ended"
                            end

                            return "This task has ended"
                        end),
                        TextColor3 = Theme.Color.NeutralContentDark,
                        TextSize = Theme.TextSize.Small,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        Visible = p5:Computed(function(p59) -- line: 613
                            -- upvalues: v26 (copy)
                            return not p59(v26)
                        end)
                    })
                }
            })
        }
    })
end
