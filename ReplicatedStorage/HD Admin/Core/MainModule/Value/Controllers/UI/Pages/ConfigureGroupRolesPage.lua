-- https://lua.expert

local GroupService = game:GetService("GroupService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local SearchBar = require(UI.Components.SearchBar)
local CheckItem = require(UI.Components.CheckItem)
local Pressable = require(UI.Components.Pressable)

return function(p1, p2) -- line: 47
    -- upvalues: GroupService (copy), Fusion (copy), Theme (copy), Children (copy), SearchBar (copy), CheckItem (copy), Pressable (copy)
    local v1 = false

    table.insert(p1, function() -- line: 49
        -- upvalues: v1 (ref)
        v1 = true
    end)

    local v3 = p1:Value("")
    local v4 = p1:Value(false)
    local v5 = p1:Value("")
    local v6 = p1:Value({})
    local v7 = p1:Value("")
    local v8 = p1:Value({
        __all_roles = true
    })

    local function seedPendingFromEntry(p3) -- line: 58
        -- upvalues: p2 (copy), v8 (copy), Fusion (copy)
        local v9 = if p2.currentEntry == nil then nil elseif typeof(p2.currentEntry) == "table" then Fusion.peek(p2.currentEntry) else p2.currentEntry

        if (if typeof(v9) == "table" then v9.type else nil) ~= "SpecificRoles" or typeof(v9) ~= "table" then
            v8:set({
                __all_roles = true
            })
        else
            local t1 = {}

            if typeof(v9.roles) == "table" then
                for _, v10 in v9.roles do
                    if typeof(v10) == "table" and typeof(v10.rank) == "number" and typeof(v10.name) == "string" then
                        table.insert(t1, {
                            rank = v10.rank,
                            name = v10.name
                        })
                    end
                end
            end

            if #t1 == 0 and typeof(v9.roleIds) == "table" then
                for _, v11 in v9.roleIds do
                    if typeof(v11) == "number" then
                        table.insert(t1, {
                            name = "",
                            rank = v11
                        })
                    end
                end
            end

            if #t1 == 0 then
                v8:set({
                    __all_roles = true
                })
            else
                local t4 = {}

                for _, v12 in t1 do
                    local v13, v14, v15

                    for _, v16 in p3 do
                        if v16.rank ~= nil then
                            local v17 = v16.rank == v12.rank
                            local v18 = typeof(v16.name) == "string" and #v16.name > 0 and v16.name == v12.name

                            if v17 then
                                if v18 then
                                    v15 = v16
                                    break
                                end

                                if v14 == nil then
                                    v14 = v16
                                end
                            elseif v18 and v13 == nil then
                                v13 = v16
                            end
                        end

                        v15 = nil
                    end

                    local v19 = v15 or v13 or v14

                    if v19 then
                        t4[v19.key] = true
                    end
                end

                if next(t4) ~= nil then
                    v8:set(t4)
                else
                    v8:set({
                        __all_roles = true
                    })
                end
            end
        end
    end

    local function resetAndFetch() -- line: 128
        -- upvalues: p2 (copy), v1 (ref), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), seedPendingFromEntry (copy), GroupService (copy), Fusion (copy)
        v3:set("")
        v5:set("")
        v7:set("")
        v8:set({
            __all_roles = true
        })
        v6:set({})

        local v20 = if p2.groupId then Fusion.peek(p2.groupId) else nil

        if typeof(v20) ~= "number" or v20 <= 0 then
            return
        end

        v4:set(true)
        task.spawn(function() -- line: 137
            -- upvalues: v20 (copy), v1 (ref), v4 (copy), v5 (copy), v6 (copy), v7 (copy), seedPendingFromEntry (copy), GroupService (copy)
            local function v21() -- line: 138
                -- upvalues: v20 (copy), GroupService (copy)
                return GroupService:GetGroupInfoAsync(v20)
            end

            local ok, result = pcall(v21)

            if v1 then
                return
            end

            v4:set(false)

            if not ok or typeof(result) ~= "table" then
                v5:set("Failed to load group roles.")

                return
            end

            v7:set(if typeof(result.Name) == "string" then result.Name else "Group " .. tostring(v20))

            local t5 = {}

            table.insert(t5, {
                key = "__all_roles",
                label = "All Roles",
                body = nil,
                rank = nil,
                name = nil,
                order = 0
            })

            if typeof(result.Roles) == "table" then
                local t7 = {}

                for _, v23 in result.Roles do
                    if typeof(v23) == "table" and typeof(v23.Name) == "string" and typeof(v23.Rank) == "number" then
                        table.insert(t7, {
                            Name = v23.Name,
                            Rank = v23.Rank
                        })
                    end
                end

                table.sort(t7, function(p4, p5) -- line: 157
                    return p4.Rank < p5.Rank
                end)

                for v24, v25 in t7 do
                    table.insert(t5, {
                        key = "role:" .. tostring(v25.Rank) .. ":" .. v25.Name,
                        label = v25.Name,
                        body = "Rank " .. tostring(v25.Rank),
                        rank = v25.Rank,
                        name = v25.Name,
                        order = v24
                    })
                end
            end

            v6:set(t5)
            seedPendingFromEntry(t5)
        end)
    end

    if p2.groupId ~= nil then
        p1:Observer(p2.groupId):onChange(resetAndFetch)
    end

    if p2.currentEntry ~= nil then
        p1:Observer(p2.currentEntry):onChange(function() -- line: 181
            -- upvalues: v6 (copy), seedPendingFromEntry (copy), Fusion (copy)
            local v26 = Fusion.peek(v6)

            if #v26 > 0 then
                seedPendingFromEntry(v26)
            end
        end)
    end

    resetAndFetch()

    local v27 = p1:Computed(function(p6) -- line: 190
        -- upvalues: v3 (copy), v6 (copy)
        local v28 = p6(v6)
        local v29 = string.lower((string.gsub(p6(v3), "%s", "")))

        if #v29 == 0 then
            return v28
        end

        local t10 = {}

        for _, v30 in v28 do
            if v30.key == "__all_roles" or string.find(string.lower(v30.label), v29, 1, true) then
                table.insert(t10, v30)
            end
        end

        return t10
    end)

    local function toggleKey(p7) -- line: 203
        -- upvalues: v8 (copy), Fusion (copy)
        if p7 == "__all_roles" then
            return
        end

        local v31 = Fusion.peek(v8)
        local v32 = table.clone(v31)

        if v32[p7] then
            v32[p7] = nil
        else
            v32[p7] = true
            v32.__all_roles = nil
        end

        local v33 = false

        for v34 in v32 do
            if v34 ~= "__all_roles" then
                v33 = true
                break
            end
        end

        if not v33 then
            v32.__all_roles = true
        end

        v8:set(v32)
    end

    local v35 = p1:Computed(function(p8) -- line: 223
        -- upvalues: v8 (copy)
        local n1 = 0

        for _ in (p8(v8)) do
            n1 += 1
        end

        return n1
    end)

    local function onConfirm() -- line: 230
        -- upvalues: p2 (copy), v6 (copy), v7 (copy), v8 (copy), Fusion (copy)
        local v36 = if p2.groupId then Fusion.peek(p2.groupId) else nil

        if typeof(v36) ~= "number" then
            return
        end

        local v37 = Fusion.peek(v8)
        local v38 = if p2.onConfirm then Fusion.peek(p2.onConfirm) else nil

        if typeof(v38) == "function" then
            local v39 = Fusion.peek(v7)
            local v40 = "group:" .. tostring(v36)
            local t11, v41

            if v37.__all_roles == true then
                t11 = {
                    type = "AnyMember",
                    groupId = v36
                }
                v41 = "All Roles"
            else
                local t12 = {}
                local t13 = {}

                for _, v42 in (Fusion.peek(v6)) do
                    if v42.rank ~= nil and typeof(v42.name) == "string" and v37[v42.key] then
                        table.insert(t12, {
                            rank = v42.rank,
                            name = v42.name
                        })
                        table.insert(t13, v42.label)
                    end
                end

                if #t12 == 0 then
                    t11 = {
                        type = "AnyMember",
                        groupId = v36
                    }
                    v41 = "All Roles"
                else
                    t11 = {
                        type = "SpecificRoles",
                        groupId = v36,
                        roles = t12
                    }
                    v41 = table.concat(t13, ", ")
                end
            end

            v38({
                category = "custom",
                groupConfig = true,
                key = v40,
                label = v39,
                header = v39,
                body = tostring(v36),
                icon = "rbxthumb://type=GroupIcon&id=" .. tostring(v36) .. "&w=150&h=150",
                rawValue = t11,
                roleLabel = v41
            }, v40)
        end

        if p2.onBack then
            p2.onBack()
        end
    end

    local Primary = Theme.Color.Primary
    local v43 = p1:Computed(function(p9) -- line: 281
        -- upvalues: Theme (copy)
        local v44 = p9(Theme.Color.Primary)
        local v45, v46, v47 = Color3.toHSV(v44)
        local v50 = Color3.fromHSV(v45, v46 * 0.92, (math.min(v47 * 1.06, 1)))

        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, v50),
            ColorSequenceKeypoint.new(1, v44)
        })
    end)

    return p1:New("Frame")({
        Name = "ConfigureGroupRolesPage",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p1:New("Frame")({
                Name = "ListArea",
                LayoutOrder = 1,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                [Children] = {
                    p1:New("UIFlexItem")({
                        FlexMode = Enum.UIFlexMode.Fill
                    }),
                    p1:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                        Padding = UDim.new(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    SearchBar(p1, {
                        placeholderText = "Filter roles...",
                        layoutOrder = 0,
                        searchText = v3
                    }),
                    p1:New("TextLabel")({
                        Name = "StatusLabel",
                        LayoutOrder = 1,
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 0),
                        FontFace = p1:Computed(function(p10) -- line: 329
                            -- upvalues: Theme (copy)
                            return Font.new(p10(Theme.Font.Body), p10(Theme.FontWeight.Regular))
                        end),
                        Text = p1:Computed(function(p11) -- line: 332
                            -- upvalues: v4 (copy), v5 (copy)
                            if p11(v4) then
                                return "Loading roles..."
                            end

                            return (p11(v5))
                        end),
                        TextColor3 = p1:Computed(function(p12) -- line: 336
                            -- upvalues: v4 (copy), Theme (copy)
                            if p12(v4) then
                                return p12(Theme.Color.NeutralContentDark)
                            end

                            return p12(Theme.Color.Error)
                        end),
                        TextSize = p1:Computed(function(p13) -- line: 342
                            -- upvalues: Theme (copy)
                            return p13(Theme.TextSize.Small) * 1.5
                        end),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Visible = p1:Computed(function(p14) -- line: 344
                            -- upvalues: v4 (copy), v5 (copy)
                            return p14(v4) or #p14(v5) > 0
                        end),
                        [Children] = {
                            p1:New("UIPadding")({
                                PaddingLeft = UDim.new(0, 12),
                                PaddingRight = UDim.new(0, 12),
                                PaddingBottom = UDim.new(0, 4)
                            })
                        }
                    }),
                    p1:New("ScrollingFrame")({
                        Name = "Results",
                        LayoutOrder = 2,
                        BackgroundTransparency = 1,
                        CanvasSize = UDim2.fromOffset(0, 0),
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarThickness = 4,
                        ScrollBarImageColor3 = Theme.Color.NeutralStroke,
                        Size = UDim2.fromScale(1, 1),
                        [Children] = {
                            p1:New("UIFlexItem")({
                                FlexMode = Enum.UIFlexMode.Fill
                            }),
                            p1:New("UIPadding")({
                                PaddingTop = UDim.new(0, 8),
                                PaddingBottom = UDim.new(0, 8)
                            }),
                            p1:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Vertical,
                                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                Padding = UDim.new(0, 4),
                                SortOrder = Enum.SortOrder.LayoutOrder
                            }),
                            p1:ForValues(v27, function(_, p16, p17) -- line: 377
                                -- upvalues: v8 (copy), toggleKey (copy), Theme (copy), Children (copy), CheckItem (copy)
                                local v59 = p16:Computed(function(p18) -- line: 379
                                    -- upvalues: p17 (copy), v8 (copy)
                                    return p18(v8)[p17.key] == true
                                end)

                                if p17.key == "__all_roles" then
                                    local v60 = CheckItem(p16, {
                                        header = p16:Value(p17.label),
                                        checked = v59,
                                        onCheck = function() -- onCheck | line: 386
                                        end
                                    })

                                    return p16:New("Frame")({
                                        Name = "AllRolesRow",
                                        LayoutOrder = p17.order,
                                        AutomaticSize = Enum.AutomaticSize.Y,
                                        BackgroundTransparency = 1,
                                        Size = UDim2.fromScale(1, 0),
                                        Interactable = false,
                                        [Children] = {
                                            v60,
                                            p16:New("Frame")({
                                                Name = "LockOverlay",
                                                BackgroundTransparency = 0.35,
                                                ZIndex = 10,
                                                BackgroundColor3 = Theme.Color.Base,
                                                Size = UDim2.fromScale(1, 1)
                                            })
                                        }
                                    })
                                end

                                local v61 = CheckItem(p16, {
                                    header = p16:Value(p17.label),
                                    body = if p17.body then p16:Value(p17.body) else nil,
                                    checked = v59,
                                    onCheck = function() -- onCheck | line: 411
                                        -- upvalues: p17 (copy), toggleKey (copy)
                                        toggleKey(p17.key)
                                    end
                                })

                                v61.LayoutOrder = p17.order

                                return v61
                            end)
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
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                [Children] = {
                    p1:New("UIPadding")({
                        PaddingBottom = UDim.new(0, 4),
                        PaddingTop = UDim.new(0, 14)
                    }),
                    Pressable(p1, {
                        name = "ConfirmButton",
                        automaticSize = Enum.AutomaticSize.Y,
                        backgroundColor = Primary,
                        size = UDim2.fromScale(1, 0),
                        onActivate = onConfirm,
                        [Children] = {
                            p1:New("UICorner")({
                                CornerRadius = UDim.new(0, 6)
                            }),
                            p1:New("UIPadding")({
                                PaddingTop = UDim.new(0, 8),
                                PaddingBottom = UDim.new(0, 8),
                                PaddingLeft = UDim.new(0, 24),
                                PaddingRight = UDim.new(0, 24)
                            }),
                            p1:New("UIStroke")({
                                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                                Color = Color3.new(1, 1, 1),
                                [Children] = {
                                    p1:New("UIGradient")({
                                        Rotation = 90,
                                        Color = v43
                                    })
                                }
                            }),
                            p1:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                SortOrder = Enum.SortOrder.LayoutOrder
                            }),
                            p1:New("TextLabel")({
                                Name = "Label",
                                BackgroundTransparency = 1,
                                RichText = true,
                                AutomaticSize = Enum.AutomaticSize.XY,
                                Size = UDim2.fromOffset(0, 0),
                                FontFace = p1:Computed(function(p19) -- line: 476
                                    -- upvalues: Theme (copy)
                                    return Font.new(p19(Theme.Font.Body), p19(Theme.FontWeight.Body))
                                end),
                                Text = p1:Computed(function(p20) -- line: 480
                                    -- upvalues: v8 (copy), v35 (copy)
                                    if p20(v8).__all_roles then
                                        return "Confirm"
                                    end

                                    local v69 = p20(v35)

                                    return string.format("Confirm (%d)", v69)
                                end),
                                TextColor3 = Theme.Color.PrimaryContent,
                                TextSize = Theme.TextSize.Subtitle
                            })
                        }
                    })
                }
            })
        }
    })
end
