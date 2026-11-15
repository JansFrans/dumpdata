-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Permissions = require(UI.Util.Permissions)
local Pressable = require(UI.Components.Pressable)
local nameValueFor = require(UI.Util.nameValueFor)
local Remote = require(Modules.Objects.Remote)
local Prompt = require(Modules.Prompt)
local Children = Fusion.Children
local t1 = {
    loader = "Loader",
    perm = "Perm",
    expire = "Time",
    server = "Server"
}

local function isEntryActive(p1, p2) -- line: 42
    if (p1.type or "perm") ~= "expire" then
        return true
    end

    local expiresAt = p1.expiresAt

    if typeof(expiresAt) == "number" then
        return p2 < expiresAt
    end

    return false
end

local function resolveDominantBan(p3, p4, p5) -- line: 51
    local v1 = tostring(p3)
    local v2 = os.time()

    local function rank(p6) -- line: 60
        if p6 == "loader" then
            return 4
        end

        if p6 == "perm" then
            return 3
        end

        if p6 == "expire" then
            return 2
        end

        if p6 == "server" then
            return 1
        end

        return 0
    end

    local n1 = (-1e999)
    local v3

    for _, v4 in { p4, p5 } do
        if typeof(v4) == "table" then
            local v5 = v4[v1]

            if typeof(v5) == "table" then
                local Bans = v5.Bans

                if typeof(Bans) == "table" then
                    for v8, v9 in Bans do
                        if typeof(v8) == "string" and typeof(v9) == "table" then
                            local v10 = true

                            if (v9.type or "perm") == "expire" then
                                local expiresAt = v9.expiresAt

                                v10 = typeof(expiresAt) == "number" and v2 < expiresAt
                            end

                            if v10 then
                                local v11 = if v9.source == "loader" then "loader" else v9.type or "perm"
                                local v12 = if typeof(v9.bannedAt) == "number" then v9.bannedAt else 0
                                local v13 = true

                                if v3 then
                                    local v14 = if v11 == "loader" then 4
                                        elseif v11 == "perm" then 3
                                        elseif v11 == "expire" then 2
                                        elseif v11 == "server" then 1
                                        else 0
                                    local key = v3.key

                                    if (if key == "loader" then 4
                                        elseif key == "perm" then 3
                                        elseif key == "expire" then 2
                                        elseif key == "server" then 1
                                        else 0) < v14 then
                                    else
                                        local v15 = if v11 == "loader" then 4
                                            elseif v11 == "perm" then 3
                                            elseif v11 == "expire" then 2
                                            elseif v11 == "server" then 1
                                            else 0
                                        local key = v3.key

                                        v13 = v15 == (if key == "loader" then 4
                                            elseif key == "perm" then 3
                                            elseif key == "expire" then 2
                                            elseif key == "server" then 1
                                            else 0) and n1 < v12
                                    end
                                end

                                if v13 then
                                    n1 = v12
                                    v3 = {
                                        ban = v9,
                                        banId = v8,
                                        key = v11
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return v3
end

local function formatRemaining(p7) -- line: 102
    if p7 <= 0 then
        return "Soon"
    end

    local t2 = {}
    local v16 = p7

    for _, v17 in {
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
            },
            {
                name = "second",
                seconds = 1
            }
        } do
        if not (v16 < v17.seconds) then
            local v19 = math.floor(v16 / v17.seconds)

            v16 -= v19 * v17.seconds
            table.insert(t2, (("%* %*"):format(v19, if v19 == 1 then v17.name else v17.name .. "s")))

            if #t2 >= 2 then
                break
            end
        end
    end

    if #t2 == 0 then
        return "Soon"
    end

    return "in " .. table.concat(t2, " ")
end

local function formatRelativePast(p8, p9) -- line: 123
    if typeof(p8) ~= "number" or p8 <= 0 then
        return ""
    end

    local v22 = math.max(0, p9 - p8)

    if not (v22 < 60) then
        for _, v23 in {
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
            if not (v22 < v23.seconds) then
                local v25 = math.floor(v22 / v23.seconds)

                return (("%* %* ago"):format(v25, if v25 == 1 then v23.name else v23.name .. "s"))
            end
        end
    end

    return "just now"
end

local function formatAbsolute(p10) -- line: 141
    if typeof(p10) ~= "number" or p10 <= 0 then
        return ""
    end

    local v26 = os.date("*t", p10)

    return string.format("%04d-%02d-%02d %02d:%02d", v26.year, v26.month, v26.day, v26.hour, v26.min)
end

return function(p11, p12) -- line: 150
    -- upvalues: Fusion (copy), Theme (copy), Permissions (copy), Pressable (copy), nameValueFor (copy), Remote (copy), Prompt (copy), Children (copy), t1 (copy), resolveDominantBan (copy), formatRemaining (copy), formatRelativePast (copy)
    local userId = p12.userId
    local v27 = false

    table.insert(p11, function() -- line: 153
        -- upvalues: v27 (ref)
        v27 = true
    end)

    local v29 = p11:Value(os.time())
    local ServerBans = p11:Fuse("everyone", "ServerBans")
    local PermanentBans = p11:Fuse("everyone", "PermanentBans")
    local v30 = p11:Computed(function(p13) -- line: 159
        -- upvalues: userId (copy), ServerBans (copy), PermanentBans (copy), resolveDominantBan (copy)
        local v31 = if typeof(userId) == "table" then p13(userId) else userId

        return if typeof(v31) == "number" and not (v31 <= 0) then resolveDominantBan(v31, p13(ServerBans), p13(PermanentBans)) else nil
    end)
    local v32 = p11:Computed(function(p14) -- line: 166
        -- upvalues: v30 (copy)
        local v33 = p14(v30)

        return v33 ~= nil and v33.ban.type == "expire"
    end)

    task.spawn(function() -- line: 170
        -- upvalues: v27 (ref), v29 (copy), v32 (copy), Fusion (copy)
        while true do
            if v27 then
                return
            end

            task.wait(1)

            if v27 then
                break
            end

            if Fusion.peek(v32) then
                v29:set(os.time())
            end
        end
    end)

    local v34 = p11:Computed(function(p15) -- line: 179
        -- upvalues: v30 (copy)
        return p15(v30) ~= nil
    end)
    local v35 = p11:Computed(function(p16) -- line: 183
        -- upvalues: v30 (copy), t1 (copy)
        local v36 = p16(v30)

        return v36 and t1[v36.key] or ""
    end)
    local v37 = p11:Computed(function(p17) -- line: 189
        -- upvalues: v30 (copy)
        local v38 = p17(v30)

        if not v38 then
            return ""
        end

        if v38.key == "server" then
            return "Banned from this server"
        end

        return "Banned from all servers"
    end)
    local v39 = p11:Computed(function(p18) -- line: 196
        -- upvalues: v30 (copy)
        local v40 = p18(v30)

        if not v40 then
            return ""
        end

        local reason = v40.ban.reason

        if typeof(reason) ~= "string" or reason == "" then
            return "No reason given"
        end

        return reason
    end)
    local v41 = p11:Value(nil)

    p11:Observer(v30):onChange(function() -- line: 205
        -- upvalues: v30 (copy), v41 (copy), Fusion (copy)
        local v42 = Fusion.peek(v30)

        if not v42 or v42.key == "loader" then
            v41:set(nil)
        else
            local bannedBy = v42.ban.bannedBy

            if typeof(bannedBy) ~= "number" or bannedBy <= 0 then
                v41:set(nil)
            else
                v41:set(bannedBy)
            end
        end
    end)

    local v43 = Fusion.peek(v30)

    if v43 and v43.key ~= "loader" then
        local bannedBy = v43.ban.bannedBy

        if typeof(bannedBy) == "number" and bannedBy > 0 then
            v41:set(bannedBy)
        end
    end

    local v44 = nameValueFor(p11, v41)
    local v45 = p11:Computed(function(p19) -- line: 222
        -- upvalues: v30 (copy), v44 (copy)
        local v46 = p19(v30)

        if not v46 then
            return ""
        end

        if v46.key == "loader" then
            return "System (loader file)"
        end

        local bannedBy = v46.ban.bannedBy

        if typeof(bannedBy) ~= "number" or bannedBy <= 0 then
            return "System"
        end

        local v47 = p19(v44)

        if v47 == "" then
            return (tostring(bannedBy))
        end

        return (("%* (@%*)"):format(v47, v47))
    end)
    local v48 = p11:Computed(function(p20) -- line: 233
        -- upvalues: v29 (copy), v30 (copy), formatRelativePast (copy)
        local v49 = p20(v30)

        if not v49 then
            return ""
        end

        local bannedAt = v49.ban.bannedAt
        local v50, v51

        if typeof(bannedAt) ~= "number" or bannedAt <= 0 then
            return "Unknown"
        else
            v50 = formatRelativePast(bannedAt, (p20(v29)))

            if typeof(bannedAt) ~= "number" or bannedAt <= 0 then
                v51 = ""
            else
                local v54 = os.date("*t", bannedAt)

                v51 = string.format("%04d-%02d-%02d %02d:%02d", v54.year, v54.month, v54.day, v54.hour, v54.min)
            end
        end

        if v50 == "" then
            return v51
        end

        return (("%* (%*)"):format(v50, v51))
    end)
    local v55 = p11:Computed(function(p21) -- line: 245
        -- upvalues: v29 (copy), v30 (copy), formatRemaining (copy)
        local v56 = p21(v30)

        if not v56 then
            return ""
        end

        local ban = v56.ban

        if ban.type ~= "expire" then
            return "Never"
        end

        local expiresAt = ban.expiresAt

        if typeof(expiresAt) ~= "number" then
            return "Unknown"
        end

        return (formatRemaining(expiresAt - p21(v29)))
    end)
    local v58 = p11:Computed(function(p22) -- line: 255
        -- upvalues: v30 (copy)
        local v59 = p22(v30)

        return v59 ~= nil and v59.ban.type == "expire"
    end)
    local v60 = p11:Computed(function(p23) -- line: 260
        -- upvalues: v30 (copy)
        local v61 = p23(v30)

        return v61 ~= nil and v61.ban.banAlts == true
    end)
    local unban = Permissions.canUseCommand(p11, "unban")
    local unserverban = Permissions.canUseCommand(p11, "unserverban")
    local v62 = p11:Computed(function(p24) -- line: 268
        -- upvalues: v30 (copy), unban (copy), unserverban (copy)
        local v63 = p24(v30)

        if not v63 then
            return {
                enabled = false
            }
        end

        if v63.key == "loader" then
            return {
                enabled = false,
                reason = "Loader bans are immutable. Edit Loader/Config/Bans.luau"
            }
        end

        if v63.key == "server" then
            if p24(unserverban) then
                return {
                    enabled = true
                }
            end

            return {
                enabled = false,
                reason = "You don't have permission (;unServerBan)"
            }
        end

        if p24(unban) then
            return {
                enabled = true
            }
        end

        return {
            enabled = false,
            reason = "You don't have permission (;unban)"
        }
    end)
    local v64 = p11:Value(false)
    local v65 = p11:Value(false)
    local n2 = 0

    p11:Observer(v30):onChange(function() -- line: 301
        -- upvalues: v64 (copy), n2 (ref), Fusion (copy)
        if Fusion.peek(v64) then
            n2 += 1
            v64:set(false)
        end
    end)

    local function fireUnban() -- line: 305
        -- upvalues: userId (copy), v27 (ref), v30 (copy), v62 (copy), v64 (copy), v65 (copy), n2 (ref), Fusion (copy), Remote (copy), Prompt (copy)
        if Fusion.peek(v65) or not Fusion.peek(v30) or not Fusion.peek(v62).enabled then
            return
        end

        if Fusion.peek(v64) then
            n2 += 1
            v64:set(false)

            local v66 = if typeof(userId) == "table" then Fusion.peek(userId) else userId

            if typeof(v66) == "number" and not (v66 <= 0) then
                local UnbanUser = Remote.get("UnbanUser")

                if UnbanUser then
                    v65:set(true)
                    task.spawn(function() -- line: 324
                        -- upvalues: v66 (copy), UnbanUser (copy), v27 (ref), v65 (copy), Prompt (copy)
                        local v67, v68 = UnbanUser:invokeServerAsync(v66, nil)

                        if not v27 then
                            v65:set(false)

                            if v67 then
                                Prompt.success("Unbanned")
                            else
                                Prompt.error((tostring(v68 or "Failed to unban")))
                            end
                        end
                    end)
                else
                    Prompt.error("Unban remote not available")
                end
            end
        else
            n2 += 1

            local v70 = n2

            v64:set(true)
            task.delay(2, function() -- line: 294
                -- upvalues: v70 (copy), v27 (ref), v64 (copy), n2 (ref)
                if not v27 and n2 == v70 then
                    v64:set(false)
                end
            end)
        end
    end

    local function fieldRow(p25, p26, p27, p28) -- line: 339
        -- upvalues: p11 (copy), Theme (copy), Children (copy)
        return p11:New("Frame")({
            Name = "Field_" .. p26,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = p25,
            Size = UDim2.new(1, 0, 0, 0),
            Visible = p28,
            [Children] = {
                p11:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    VerticalAlignment = Enum.VerticalAlignment.Top,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                p11:New("TextLabel")({
                    Name = "Label",
                    LayoutOrder = 1,
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    FontFace = p11:Computed(function(p29) -- line: 360
                        -- upvalues: Theme (copy)
                        return Font.new(p29(Theme.Font.Body), p29(Theme.FontWeight.Body))
                    end),
                    Size = UDim2.new(0, 68, 0, 0),
                    Text = p26 .. ":",
                    TextColor3 = Theme.Color.NeutralContentDark,
                    TextSize = Theme.TextSize.Label,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top
                }),
                p11:New("TextLabel")({
                    Name = "Value",
                    LayoutOrder = 2,
                    BackgroundTransparency = 1,
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    FontFace = p11:Computed(function(p30) -- line: 375
                        -- upvalues: Theme (copy)
                        return Font.new(p30(Theme.Font.Body), p30(Theme.FontWeight.Body))
                    end),
                    Size = UDim2.new(1, -76, 0, 0),
                    Text = p27,
                    TextColor3 = Theme.Color.BaseContent,
                    TextSize = Theme.TextSize.Label,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top
                })
            }
        })
    end

    return p11:New("Frame")({
        Name = "BanBanner",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Color.Primary,
        BackgroundTransparency = 0.88,
        LayoutOrder = p12.layoutOrder or 0,
        Size = UDim2.new(1, 0, 0, 0),
        Visible = v34,
        [Children] = {
            p11:New("UIStroke")({
                Thickness = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.Primary
            }),
            p11:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p11:New("UIPadding")({
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10)
            }),
            p11:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p11:New("Frame")({
                Name = "Title",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Size = UDim2.new(1, 0, 0, 0),
                [Children] = {
                    p11:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p11:New("TextLabel")({
                        Name = "ScopeLabel",
                        LayoutOrder = 1,
                        BackgroundTransparency = 1,
                        AutomaticSize = Enum.AutomaticSize.XY,
                        FontFace = p11:Computed(function(p31) -- line: 440
                            -- upvalues: Theme (copy)
                            return Font.new(p31(Theme.Font.Body), p31(Theme.FontWeight.Bold))
                        end),
                        Size = UDim2.new(0, 0, 0, 0),
                        Text = p11:Computed(function(p32) -- line: 444
                            -- upvalues: v37 (copy)
                            return (("🚫 %*"):format((p32(v37))))
                        end),
                        TextColor3 = Theme.Color.Primary,
                        TextSize = Theme.TextSize.Body,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    p11:New("Frame")({
                        Name = "TypePill",
                        LayoutOrder = 2,
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = Theme.Color.Primary,
                        Size = UDim2.new(0, 0, 0, 22),
                        [Children] = {
                            p11:New("UICorner")({
                                CornerRadius = UDim.new(1, 0)
                            }),
                            p11:New("UIPadding")({
                                PaddingLeft = UDim.new(0, 10),
                                PaddingRight = UDim.new(0, 10)
                            }),
                            p11:New("TextLabel")({
                                Name = "Label",
                                BackgroundTransparency = 1,
                                AutomaticSize = Enum.AutomaticSize.X,
                                FontFace = p11:Computed(function(p33) -- line: 468
                                    -- upvalues: Theme (copy)
                                    return Font.new(p33(Theme.Font.Body), p33(Theme.FontWeight.Bold))
                                end),
                                Size = UDim2.new(0, 0, 1, 0),
                                Text = v35,
                                TextColor3 = Theme.Color.PrimaryContent,
                                TextSize = Theme.TextSize.Label
                            })
                        }
                    })
                }
            }),
            fieldRow(2, "Reason", v39, nil),
            fieldRow(3, "Banned by", v45, nil),
            fieldRow(4, "Banned at", v48, nil),
            fieldRow(5, "Expires", v55, v58),
            fieldRow(6, "Roblox", p11:Computed(function() -- line: 486
                return "Includes Roblox Web Ban"
            end), v60),
            p11:New("Frame")({
                Name = "ActionFooter",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 7,
                Size = UDim2.new(1, 0, 0, 0),
                [Children] = {
                    p11:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDim.new(0, 4),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    Pressable(p11, {
                        name = "UnbanButton",
                        layoutOrder = 1,
                        size = UDim2.fromOffset(0, 0),
                        automaticSize = Enum.AutomaticSize.Y,
                        backgroundColor = p11:Computed(function(p34) -- line: 508
                            -- upvalues: v62 (copy), Theme (copy)
                            if p34(v62).enabled then
                                return (p34(Theme.Color.Primary))
                            end

                            return (p34(Theme.Color.NeutralContent))
                        end),
                        interactable = p11:Computed(function(p35) -- line: 512
                            -- upvalues: v62 (copy), v65 (copy)
                            return p35(v62).enabled and not p35(v65)
                        end),
                        onActivate = fireUnban,
                        [Children] = {
                            p11:New("UICorner")({
                                CornerRadius = UDim.new(0, 6)
                            }),
                            p11:New("UIPadding")({
                                PaddingLeft = UDim.new(0, 18),
                                PaddingRight = UDim.new(0, 18),
                                PaddingTop = UDim.new(0, 6),
                                PaddingBottom = UDim.new(0, 6)
                            }),
                            p11:New("TextLabel")({
                                Name = "Label",
                                BackgroundTransparency = 1,
                                AutomaticSize = Enum.AutomaticSize.Y,
                                FontFace = p11:Computed(function(p36) -- line: 528
                                    -- upvalues: Theme (copy)
                                    return Font.new(p36(Theme.Font.Body), p36(Theme.FontWeight.Bold))
                                end),
                                Size = UDim2.new(1, 0, 0, 0),
                                Text = p11:Computed(function(p37) -- line: 532
                                    -- upvalues: v64 (copy), v65 (copy)
                                    if p37(v65) then
                                        return "Unbanning..."
                                    end

                                    if p37(v64) then
                                        return "Confirm?"
                                    end

                                    return "Unban"
                                end),
                                TextColor3 = p11:Computed(function(p38) -- line: 536
                                    -- upvalues: v62 (copy), Theme (copy)
                                    if p38(v62).enabled then
                                        return (p38(Theme.Color.PrimaryContent))
                                    end

                                    return (p38(Theme.Color.NeutralContentDark))
                                end),
                                TextSize = Theme.TextSize.Body,
                                TextXAlignment = Enum.TextXAlignment.Center,
                                TextYAlignment = Enum.TextYAlignment.Center
                            })
                        }
                    }),
                    p11:New("TextLabel")({
                        Name = "DisabledReason",
                        LayoutOrder = 2,
                        BackgroundTransparency = 1,
                        TextWrapped = true,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        FontFace = p11:Computed(function(p39) -- line: 552
                            -- upvalues: Theme (copy)
                            return Font.new(p39(Theme.Font.Body), p39(Theme.FontWeight.Body))
                        end),
                        Size = UDim2.new(1, 0, 0, 0),
                        Text = p11:Computed(function(p40) -- line: 556
                            -- upvalues: v62 (copy)
                            return p40(v62).reason or ""
                        end),
                        TextColor3 = Theme.Color.NeutralContentDark,
                        TextSize = Theme.TextSize.Small,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        Visible = p11:Computed(function(p41) -- line: 564
                            -- upvalues: v62 (copy)
                            local v87 = p41(v62)

                            return not v87.enabled and v87.reason ~= nil
                        end)
                    })
                }
            })
        }
    })
end
