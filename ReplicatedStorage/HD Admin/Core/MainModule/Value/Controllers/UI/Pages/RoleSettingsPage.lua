-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local SettingsList = require(UI.Components.SettingsList)
local SettingsRole = require(UI.Config.SettingsRole)
local RoleLockRules = require(UI.Config.RoleLockRules)
local Pressable = require(UI.Components.Pressable)
local Popup = require(UI.Components.Popup)
local DataPopup = require(UI.Components.DataPopup)
local Toggle = require(UI.Components.Toggle)
local SerializeRole = require(UI.Util.SerializeRole)
local ParseRole = require(UI.Util.ParseRole)
local Icons = require(UI.Config.Icons)
local Permissions = require(UI.Util.Permissions)
local Remote = require(Modules.Objects.Remote)
local ChangeRoleSetting = Remote.get("ChangeRoleSetting")
local Children = Fusion.Children

return function(p1, p2) -- line: 37
    -- upvalues: Modules (copy), Fusion (copy), Theme (copy), SettingsList (copy), SettingsRole (copy), RoleLockRules (copy), Pressable (copy), Popup (copy), DataPopup (copy), Toggle (copy), SerializeRole (copy), ParseRole (copy), Icons (copy), Permissions (copy), Remote (copy), ChangeRoleSetting (copy), Children (copy)
    local v1 = p2.targetRoleKey or p1:Value("")
    local v2 = p1:Value(Fusion.peek(v1))
    local v3 = p1:Fuse("everyone", { "GameSettings", "SystemSettings", "UseDefaultRoles" })
    local v4 = p1:Computed(function(p3) -- line: 45
        -- upvalues: v3 (copy)
        return p3(v3) == true
    end)

    local function v5(p4) -- line: 50
        -- upvalues: p1 (copy), v4 (copy), RoleLockRules (copy)
        local title = p4.obj.title

        if typeof(title) ~= "string" or title == "key" or title == "rank" or title == "data" then
            return nil
        end

        local v6 = RoleLockRules.getRulesFor(title)
        local valueByTitle = p4.valueByTitle

        return p1:Computed(function(p5) -- line: 56
            -- upvalues: v6 (copy), valueByTitle (copy), v4 (copy)
            if p5(v4) == true then
                return true
            end

            for _, v7 in v6 do
                if v7.parent then
                    local v8 = valueByTitle[v7.parent]

                    if v8 and p5(v8) == true then
                        return true
                    end
                end

                if v7.parents then
                    for _, v9 in v7.parents do
                        local v10 = valueByTitle[v9]

                        if v10 and p5(v10) == true then
                            return true
                        end
                    end
                end

                if v7.requiredTrue then
                    for _, v11 in v7.requiredTrue do
                        local v12 = valueByTitle[v11]

                        if v12 and p5(v12) ~= true then
                            return true
                        end
                    end
                end
            end

            return false
        end)
    end

    local v13 = Permissions.canEditRoleByKey(p1, v2)
    local mayEditAll = Permissions.hasPermission(p1, "mayEditAll")

    local function v14(p6) -- line: 84
        -- upvalues: p1 (copy), v13 (copy), mayEditAll (copy), Permissions (copy)
        local obj = p6.obj
        local title = obj.title

        if typeof(title) ~= "string" or title == "key" or title == "rank" or title == "data" then
            return nil
        end

        local valueByTitle = p6.valueByTitle
        local v15 = obj.inputType == "Toggle"
        local v16 = if v15 then Permissions.hasPermission(p1, title) else nil

        return p1:Computed(function(p7) -- line: 92
            -- upvalues: title (copy), valueByTitle (copy), v15 (copy), v16 (copy), v13 (copy), mayEditAll (copy)
            if p7(v13) ~= true then
                return true
            end

            if p7(mayEditAll) == true or not v15 or p7(v16) == true then
                return false
            end

            local v17 = valueByTitle[title]

            return (if v17 then p7(v17) else nil) ~= true
        end)
    end

    local v18 = p1:Value(nil)

    local function getDefaults() -- line: 108
        -- upvalues: v2 (copy), Modules (copy), Fusion (copy)
        local v19 = Fusion.peek(v2)

        if v19 ~= "" then
            local DefaultRoleInfo = require(Modules.References.clientUser).everyone:get("DefaultRoleInfo")

            if typeof(DefaultRoleInfo) == "table" then
                return DefaultRoleInfo[v19]
            end
        end

        return nil
    end

    local function syncDisplayOverride() -- line: 119
        -- upvalues: v2 (copy), v4 (copy), v18 (copy), Modules (copy), Fusion (copy)
        local v20 = Fusion.peek(v18)

        if v20 then
            if Fusion.peek(v4) == true then
                local v21 = Fusion.peek(v2)
                local v22

                if v21 ~= "" then
                    local DefaultRoleInfo = require(Modules.References.clientUser).everyone:get("DefaultRoleInfo")

                    if typeof(DefaultRoleInfo) == "table" then
                        v22 = DefaultRoleInfo[v21]
                    end
                end

                if v22 then
                    v20.beginDisplayOverride(v22)
                end
            else
                v20.endDisplayOverride()
            end
        end
    end

    p1:Observer(v4):onChange(syncDisplayOverride)
    p1:Observer(v18):onChange(syncDisplayOverride)

    local v23, v24 = p1:Fuse("everyone", { "RoleInfo", "_", "name" })
    local v25 = p1:Computed(function(p8) -- line: 136
        -- upvalues: v2 (copy), v23 (copy)
        local v26 = p8(v23)

        if typeof(v26) == "string" and v26 ~= "" then
            return v26
        end

        local v27 = p8(v2)

        if typeof(v27) == "string" then
            return v27
        end

        return ""
    end)
    local DefaultRoleInfo = p1:Fuse("everyone", "DefaultRoleInfo")
    local v28 = p1:Computed(function(p9) -- line: 146
        -- upvalues: v2 (copy), DefaultRoleInfo (copy)
        local v29 = p9(v2)

        if typeof(v29) == "string" and v29 ~= "" then
            local v31 = p9(DefaultRoleInfo)

            return typeof(v31) == "table" and v31[v29] ~= nil
        end

        return false
    end)
    local v32 = p1:New("Frame")({
        Name = "RoleSettingsPage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })
    local v33 = nil
    local v34

    local function closeDeletePopup() -- line: 164
        -- upvalues: v33 (ref), v34 (ref), Fusion (copy)
        if v34 then
            v34:Destroy()
            v34 = nil
        end

        if v33 then
            Fusion.doCleanup(v33)
            v33 = nil
        end
    end

    local function v35() -- line: 177
        -- upvalues: p2 (copy), v2 (copy), v25 (copy), v32 (copy), v33 (ref), v34 (ref), Modules (copy), Fusion (copy), Theme (copy), Pressable (copy), Popup (copy), Toggle (copy), Remote (copy), Children (copy)
        if v34 then
            v34:Destroy()
            v34 = nil
        end

        if v33 then
            Fusion.doCleanup(v33)
            v33 = nil
        end

        local v36 = Fusion.scoped(Fusion)

        v33 = v36

        local v37 = v36:Value(true)
        local v38 = v36:Value(false)
        local v39 = v36:Value(false)
        local v40 = v36:Computed(function(p10) -- line: 186
            -- upvalues: v38 (copy), v39 (copy), v25 (copy)
            if p10(v39) then
                return false
            end

            if p10(v38) == true then
                return p10(v25) ~= ""
            end

            return false
        end)

        local function confirmDelete() -- line: 191
            -- upvalues: v36 (copy), v39 (copy), v40 (copy), p2 (copy), v2 (copy), v33 (ref), v34 (ref), Modules (copy), Fusion (copy), Remote (copy)
            if Fusion.peek(v40) then
                local v41 = Fusion.peek(v2)

                if typeof(v41) == "string" and v41 ~= "" then
                    v39:set(true)
                    task.spawn(function() -- line: 196
                        -- upvalues: v41 (copy), v36 (copy), v39 (copy), p2 (copy), v33 (ref), v34 (ref), Modules (copy), Fusion (copy), Remote (copy)
                        local v42, v43, v44 = Remote.get("DeleteRole"):invokeServerAsync(v41)

                        if v33 == v36 then
                            v39:set(false)

                            if v42 then
                                if v34 then
                                    v34:Destroy()
                                    v34 = nil
                                end

                                if v33 then
                                    Fusion.doCleanup(v33)
                                    v33 = nil
                                end

                                if p2.onDeleted then
                                    p2.onDeleted()
                                end
                            else
                                local Prompt = require(Modules.Prompt);

                                (if v44 == "error" then Prompt.error else Prompt.warn)((tostring(v43 or "Failed to delete role")))
                            end
                        end
                    end)
                end
            end
        end

        local v50 = Popup(v36, {
            title = "Delete Role",
            dismissible = true,
            backdropDismiss = true,
            zIndex = 100,
            visible = v37,
            onClose = function() -- onClose | line: 220
                -- upvalues: v39 (copy), v33 (ref), v34 (ref), Fusion (copy)
                if not Fusion.peek(v39) then
                    if v34 then
                        v34:Destroy()
                        v34 = nil
                    end

                    if v33 then
                        Fusion.doCleanup(v33)
                        v33 = nil
                    end
                end
            end,
            content = {
                v36:New("TextLabel")({
                    Name = "Prompt",
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    RichText = true,
                    Text = "This action cannot be undone.",
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    FontFace = v36:Computed(function(p11) -- line: 229
                        -- upvalues: Theme (copy)
                        return Font.new(p11(Theme.Font.Body), p11(Theme.FontWeight.Light))
                    end),
                    Size = UDim2.fromScale(1, 0),
                    TextColor3 = Theme.Color.NeutralContentDark,
                    TextSize = Theme.TextSize.Body,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                Toggle(v36, {
                    title = "Confirm",
                    value = v38
                })
            },
            actions = {
                Pressable(v36, {
                    name = "CancelButton",
                    size = UDim2.fromOffset(96, 34),
                    backgroundColor = Theme.Color.Neutral,
                    onActivate = function() -- onActivate | line: 251
                        -- upvalues: v39 (copy), v33 (ref), v34 (ref), Fusion (copy)
                        if not Fusion.peek(v39) then
                            if v34 then
                                v34:Destroy()
                                v34 = nil
                            end

                            if v33 then
                                Fusion.doCleanup(v33)
                                v33 = nil
                            end
                        end
                    end,
                    layoutOrder = 1,
                    [Children] = {
                        v36:New("UICorner")({
                            CornerRadius = v36:Computed(function(p12) -- line: 258
                                -- upvalues: Theme (copy)
                                return UDim.new(0, (p12(Theme.Layout.CornerRadius)))
                            end)
                        }),
                        v36:New("UIStroke")({
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            Color = Theme.Color.NeutralStroke
                        }),
                        v36:New("TextLabel")({
                            Name = "Label",
                            BackgroundTransparency = 1,
                            Text = "Cancel",
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            FontFace = v36:Computed(function(p13) -- line: 270
                                -- upvalues: Theme (copy)
                                return Font.new(p13(Theme.Font.Body), p13(Theme.FontWeight.Body))
                            end),
                            Position = UDim2.fromScale(0.5, 0.5),
                            Size = UDim2.fromScale(1, 1),
                            TextColor3 = Theme.Color.BaseContent,
                            TextSize = Theme.TextSize.Body,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            TextYAlignment = Enum.TextYAlignment.Center
                        })
                    }
                }),
                Pressable(v36, {
                    name = "ConfirmDeleteButton",
                    size = UDim2.fromOffset(140, 34),
                    backgroundColor = v36:Computed(function(p14) -- line: 286
                        -- upvalues: v40 (copy), Theme (copy)
                        if p14(v40) then
                            return (p14(Theme.Color.Primary))
                        end

                        return (p14(Theme.Color.Primary):Lerp(Color3.new(0, 0, 0), 0.3))
                    end),
                    interactable = v40,
                    onActivate = confirmDelete,
                    layoutOrder = 2,
                    [Children] = {
                        v36:New("UICorner")({
                            CornerRadius = v36:Computed(function(p15) -- line: 296
                                -- upvalues: Theme (copy)
                                return UDim.new(0, (p15(Theme.Layout.CornerRadius)))
                            end)
                        }),
                        v36:New("UIStroke")({
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            Color = Theme.Color.NeutralStroke
                        }),
                        v36:New("TextLabel")({
                            Name = "Label",
                            BackgroundTransparency = 1,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            FontFace = v36:Computed(function(p16) -- line: 308
                                -- upvalues: Theme (copy)
                                return Font.new(p16(Theme.Font.Body), p16(Theme.FontWeight.Body))
                            end),
                            Position = UDim2.fromScale(0.5, 0.5),
                            Size = UDim2.fromScale(1, 1),
                            Text = v36:Computed(function(p17) -- line: 313
                                -- upvalues: v39 (copy)
                                if p17(v39) then
                                    return "Deleting..."
                                end

                                return "Delete"
                            end),
                            TextColor3 = Theme.Color.PrimaryContent,
                            TextSize = Theme.TextSize.Body,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            TextYAlignment = Enum.TextYAlignment.Center,
                            TextTransparency = v36:Computed(function(p18) -- line: 320
                                -- upvalues: v40 (copy)
                                if p18(v40) then
                                    return 0
                                end

                                return 0.35
                            end)
                        })
                    }
                })
            }
        })

        v50.Parent = v32
        v34 = v50
    end

    local v51 = false

    local function buildDangerZoneButton(p19) -- line: 336
        -- upvalues: p1 (copy), Theme (copy), Pressable (copy), Children (copy)
        local v52 = p1:Value(false)
        local v53 = p1:Value(false)
        local v54 = p1:Computed(function(p20) -- line: 347
            -- upvalues: p19 (copy), v52 (copy), v53 (copy)
            local v55 = p20(p19.baseColor)
            local v56 = if 0.299 * v55.R + 0.587 * v55.G + 0.114 * v55.B > 0.5 then Color3.new(0, 0, 0) else Color3.new(1, 1, 1)

            if p20(v53) then
                return v55:Lerp(v56, 0.2)
            end

            if p20(v52) then
                return v55:Lerp(v56, 0.1)
            end

            return v55
        end)

        return Pressable(p1, {
            name = p19.name,
            size = UDim2.new(1, 0, 0, 38),
            backgroundColor = v54,
            onHoverChanged = function(p21) -- onHoverChanged | line: 362
                -- upvalues: v52 (copy)
                v52:set(p21)
            end,
            onPressChanged = function(p22) -- onPressChanged | line: 363
                -- upvalues: v53 (copy)
                v53:set(p22)
            end,
            onActivate = p19.onActivate,
            [Children] = {
                p1:New("UICorner")({
                    CornerRadius = UDim.new(0, 9)
                }),
                if p19.strokeColor then p1:New("UIStroke")({
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = p19.strokeColor
                }) else p1:New("UIStroke")({
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Color3.new(1, 1, 1),
                    [Children] = {
                        p1:New("UIGradient")({
                            Rotation = 90,
                            Color = p1:Computed(function(p23) -- line: 377
                                -- upvalues: p19 (copy), Theme (copy)
                                local v59 = p23(p19.baseColor)
                                local v60 = p23(Theme.Color.NeutralContent)

                                return ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, v60),
                                    ColorSequenceKeypoint.new(1, v59)
                                })
                            end)
                        })
                    }
                }),
                p1:New("Frame")({
                    Name = "Content",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.new(0, 0, 1, 0),
                    [Children] = {
                        p1:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            Padding = UDim.new(0, 6),
                            SortOrder = Enum.SortOrder.LayoutOrder
                        }),
                        if p19.icon then p1:New("ImageLabel")({
                            Name = "Icon",
                            BackgroundTransparency = 1,
                            LayoutOrder = 1,
                            Image = p19.icon,
                            ImageColor3 = p19.textColor,
                            Size = UDim2.fromOffset(20, 20)
                        }) else nil,
                        p1:New("TextLabel")({
                            Name = "Label",
                            BackgroundTransparency = 1,
                            LayoutOrder = 2,
                            AutomaticSize = Enum.AutomaticSize.X,
                            FontFace = p1:Computed(function(p24) -- line: 416
                                -- upvalues: Theme (copy)
                                return Font.new(p24(Theme.Font.Body), p24(Theme.FontWeight.Body))
                            end),
                            Size = UDim2.new(0, 0, 1, 0),
                            Text = p19.label,
                            TextColor3 = p19.textColor,
                            TextSize = p1:Computed(function(p25) -- line: 423
                                -- upvalues: Theme (copy)
                                return (math.round(p25(Theme.Layout.ContentScale) * 17))
                            end),
                            TextTruncate = Enum.TextTruncate.SplitWord,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            TextYAlignment = Enum.TextYAlignment.Center
                        })
                    }
                })
            }
        })
    end

    local function buildReadOnlyNotice() -- line: 438
        -- upvalues: p1 (copy), v13 (copy), v25 (copy), Theme (copy), Children (copy)
        return p1:New("Frame")({
            Name = "ReadOnlyNotice",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.Color.Primary,
            BackgroundTransparency = 0.88,
            LayoutOrder = -1,
            Size = UDim2.new(1, 0, 0, 0),
            Visible = p1:Computed(function(p26) -- line: 446
                -- upvalues: v13 (copy)
                return p26(v13) ~= true
            end),
            [Children] = {
                p1:New("UIStroke")({
                    Thickness = 1,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Theme.Color.Primary
                }),
                p1:New("UICorner")({
                    CornerRadius = UDim.new(0, 6)
                }),
                p1:New("UIPadding")({
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8)
                }),
                p1:New("TextLabel")({
                    Name = "Label",
                    BackgroundTransparency = 1,
                    RichText = true,
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    FontFace = p1:Computed(function(p27) -- line: 466
                        -- upvalues: Theme (copy)
                        return Font.new(p27(Theme.Font.Body), p27(Theme.FontWeight.Body))
                    end),
                    Size = UDim2.new(1, 0, 0, 0),
                    Text = p1:Computed(function(p28) -- line: 471
                        -- upvalues: v25 (copy)
                        if p28(v25) == "" then
                            return "Read-only: you don't have permission to edit this role. Its rank is at or above your own."
                        end

                        return "This role is read-only: you can only edit ranks in-game lower than yours"
                    end),
                    TextColor3 = Theme.Color.Primary,
                    TextSize = Theme.TextSize.Body,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            }
        })
    end

    local function buildDangerZone() -- line: 487
        -- upvalues: p1 (copy), v4 (copy), v13 (copy), v18 (copy), v25 (copy), v28 (copy), v35 (copy), buildDangerZoneButton (copy), Fusion (copy), Theme (copy), Icons (copy), Children (copy)
        local v64 = buildDangerZoneButton({
            name = "RestoreDefaultsButton",
            label = "Restore Defaults",
            baseColor = Theme.Color.Neutral,
            textColor = Theme.Color.BaseContent,
            onActivate = function() -- onActivate | line: 495
                -- upvalues: v18 (copy), Fusion (copy)
                local v65 = Fusion.peek(v18)

                if v65 and v65.restoreDefaults then
                    v65.restoreDefaults()
                end
            end
        })
        local v66 = buildDangerZoneButton({
            name = "DeleteRoleButton",
            label = p1:Computed(function(p29) -- line: 505
                -- upvalues: v25 (copy)
                local v67 = p29(v25)

                if v67 == "" then
                    return "Delete Role"
                end

                return (("Delete '%*'"):format(v67))
            end),
            baseColor = Theme.Color.Primary,
            textColor = Theme.Color.PrimaryContent,
            icon = Icons.WarningFill,
            onActivate = v35
        })

        return p1:New("Frame")({
            Name = "DangerZone",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            Visible = v13,
            [Children] = {
                p1:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Vertical,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                p1:New("UIPadding")({
                    PaddingTop = UDim.new(0, 18)
                }),
                p1:New("TextLabel")({
                    Name = "Heading",
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Text = "Danger Zone",
                    AutomaticSize = Enum.AutomaticSize.XY,
                    FontFace = p1:Computed(function(p30) -- line: 536
                        -- upvalues: Theme (copy)
                        return Font.new(p30(Theme.Font.Heading), p30(Theme.FontWeight.Heading))
                    end),
                    TextColor3 = Theme.Color.BaseContent,
                    TextSize = Theme.TextSize.Title,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTransparency = p1:Computed(function(p31) -- line: 544
                        -- upvalues: v4 (copy)
                        if p31(v4) == true then
                            return 0.65
                        end

                        return 0
                    end)
                }),
                p1:New("Frame")({
                    Name = "DividerWrap",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    Size = UDim2.new(1, 0, 0, 0),
                    [Children] = {
                        p1:New("UIPadding")({
                            PaddingTop = UDim.new(0, 6),
                            PaddingBottom = UDim.new(0, 10)
                        }),
                        p1:New("Frame")({
                            Name = "Divider",
                            BackgroundColor3 = Theme.Color.NeutralContent,
                            Size = UDim2.new(1, 0, 0, 1)
                        })
                    }
                }),
                p1:New("Frame")({
                    Name = "ButtonStack",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    ClipsDescendants = false,
                    LayoutOrder = 3,
                    Size = UDim2.fromScale(1, 0),
                    Interactable = p1:Computed(function(p32) -- line: 573
                        -- upvalues: v4 (copy)
                        return p32(v4) ~= true
                    end),
                    [Children] = {
                        p1:New("Frame")({
                            Name = "Inner",
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            Size = UDim2.fromScale(1, 0),
                            [Children] = {
                                p1:New("UIListLayout")({
                                    FillDirection = Enum.FillDirection.Vertical,
                                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                    Padding = UDim.new(0, 8),
                                    SortOrder = Enum.SortOrder.LayoutOrder
                                }),
                                p1:New("Frame")({
                                    Name = "RestoreWrap",
                                    BackgroundTransparency = 1,
                                    LayoutOrder = 1,
                                    Size = UDim2.new(1, 0, 0, 38),
                                    Visible = p1:Computed(function(p33) -- line: 594
                                        -- upvalues: v13 (copy), v28 (copy)
                                        if p33(v28) == true then
                                            return p33(v13) == true
                                        end

                                        return false
                                    end),
                                    [Children] = { v64 }
                                }),
                                p1:New("Frame")({
                                    Name = "DeleteWrap",
                                    BackgroundTransparency = 1,
                                    LayoutOrder = 3,
                                    Size = UDim2.new(1, 0, 0, 38),
                                    Visible = v13,
                                    [Children] = { v66 }
                                })
                            }
                        }),
                        p1:New("Frame")({
                            Name = "LockOverlay",
                            ZIndex = 20,
                            BackgroundColor3 = Theme.Color.Base,
                            BackgroundTransparency = p1:Computed(function(p34) -- line: 612
                                -- upvalues: v4 (copy)
                                if p34(v4) == true then
                                    return 0.35
                                end

                                return 1
                            end),
                            Size = UDim2.fromScale(1, 1)
                        })
                    }
                })
            }
        })
    end

    local v73, v74

    local function closeDataPopup() -- line: 628
        -- upvalues: v73 (ref), v74 (ref), Fusion (copy)
        if v74 then
            v74:Destroy()
            v74 = nil
        end

        if v73 then
            Fusion.doCleanup(v73)
            v73 = nil
        end
    end

    local function openDataPopup() -- line: 639
        -- upvalues: v2 (copy), v4 (copy), v18 (copy), v32 (copy), v73 (ref), v74 (ref), Modules (copy), Fusion (copy), DataPopup (copy), SerializeRole (copy), ParseRole (copy)
        if v74 then
            v74:Destroy()
            v74 = nil
        end

        if v73 then
            Fusion.doCleanup(v73)
            v73 = nil
        end

        local v75 = Fusion.scoped(Fusion)

        v73 = v75

        local v76 = v75:Value(true)
        local clientUser = require(Modules.References.clientUser)
        local v77 = Fusion.peek(v2)
        local RoleInfo = clientUser.everyone:get("RoleInfo")
        local v78 = if typeof(RoleInfo) == "table" and typeof(v77) == "string" then RoleInfo[v77] else nil
        local v80 = DataPopup(v75, {
            visible = v76,
            copyText = if typeof(v78) == "table" then SerializeRole(v78) else "return {}",
            hideLoad = v4,
            onClose = function() -- onClose | line: 658
                -- upvalues: v73 (ref), v74 (ref), Fusion (copy)
                if v74 then
                    v74:Destroy()
                    v74 = nil
                end

                if v73 then
                    Fusion.doCleanup(v73)
                    v73 = nil
                end
            end,
            onLoad = function(p35) -- onLoad | line: 661
                -- upvalues: v18 (copy), Fusion (copy), ParseRole (copy)
                local v81, v82, v83 = ParseRole(p35)

                if not v81 then
                    return false, "Failed loading data, please re-write"
                end

                local v84 = Fusion.peek(v18)

                if v84 and v84.setFieldValue then
                    for v85, v86 in v82 do
                        v84.setFieldValue(v85, v86)
                    end

                    return true, (("Successfully updated %* role values"):format(v83 or 0))
                end

                return false, "Settings list not ready"
            end
        })

        v80.Parent = v32
        v74 = v80
    end

    local function buildSettingsList(p36) -- line: 682
        -- upvalues: p1 (copy), p2 (copy), v2 (copy), v4 (copy), v5 (copy), v13 (copy), v14 (copy), v18 (copy), getDefaults (copy), v24 (copy), v32 (copy), v51 (ref), buildReadOnlyNotice (copy), buildDangerZone (copy), openDataPopup (copy), Fusion (copy), SettingsList (copy), SettingsRole (copy), ChangeRoleSetting (copy)
        v51 = true
        v2:set(p36)
        v24({ "RoleInfo", p36, "name" })
        SettingsList(p1, {
            stateSource = "everyone",
            undoOnDestroy = true,
            settingsData = SettingsRole,
            pathPrefix = { "RoleInfo", p36 },
            onItemSelectorOpen = p2.onItemSelectorOpen,
            onChangeRemote = ChangeRoleSetting,
            changeRemoteArgsBuilder = function(p37) -- changeRemoteArgsBuilder | line: 693
                -- upvalues: v2 (copy), Fusion (copy)
                return Fusion.peek(v2), p37.title, p37.intendedValue
            end,
            getDefaults = getDefaults,
            panelClosed = p2.panelClosed,
            lockRule = v5,
            softLockRule = v14,
            controllerRef = v18,
            contentLocked = v4,
            headerSlot = buildReadOnlyNotice(),
            headerSlotVisible = p1:Computed(function(p38) -- line: 706
                -- upvalues: v13 (copy)
                return p38(v13) ~= true
            end),
            footerSlot = buildDangerZone(),
            objectOverrides = {
                data = {
                    onActivate = openDataPopup,
                    buttonText = p1:Computed(function(p39) -- line: 713
                        -- upvalues: v4 (copy)
                        if p39(v4) == true then
                            return "Copy"
                        end

                        return "Copy or Load"
                    end)
                },
                viewCommands = {
                    onActivate = function() -- onActivate | line: 718
                        -- upvalues: p2 (copy), v2 (copy), Fusion (copy)
                        local v87 = Fusion.peek(v2)

                        if typeof(v87) == "string" and v87 ~= "" and p2.onOpenViewCommandsForRole then
                            p2.onOpenViewCommandsForRole(v87)
                        end
                    end
                }
            }
        }).Parent = v32
    end

    local function switchToRole(p40) -- line: 730
        -- upvalues: v2 (copy), v18 (copy), syncDisplayOverride (copy), v24 (copy), v51 (ref), buildSettingsList (copy), Fusion (copy)
        if not v51 then
            buildSettingsList(p40)

            return
        end

        v2:set(p40)
        v24({ "RoleInfo", p40, "name" })

        local v88 = Fusion.peek(v18)

        if v88 and v88.rebindToPath then
            v88.rebindToPath({ "RoleInfo", p40 })
        end

        task.defer(syncDisplayOverride)
    end

    p1:Observer(v1):onChange(function() -- line: 744
        -- upvalues: v1 (copy), v18 (copy), switchToRole (copy), Fusion (copy)
        local v89 = Fusion.peek(v1)

        if typeof(v89) ~= "string" or v89 == "" then
            local v90 = Fusion.peek(v18)

            if v90 then
                v90.undoChanges()
            end
        else
            switchToRole(v89)
        end
    end)

    local v91 = Fusion.peek(v1)

    if typeof(v91) == "string" and v91 ~= "" then
        switchToRole(v91)
    end

    table.insert(p1, closeDeletePopup)
    table.insert(p1, closeDataPopup)

    return v32
end
