-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local Icons = require(UI.Config.Icons)
local SettingsYou = require(UI.Config.SettingsYou)
local SettingsGame = require(UI.Config.SettingsGame)
local Permissions = require(UI.Util.Permissions)
local NoPermissionPlaceholder = require(UI.Components.NoPermissionPlaceholder)
local t1 = {
    {
        label = "You",
        icon = Icons.UserSettingsFill
    },
    {
        label = "Game",
        icon = Icons.FileSettingsFill
    }
}
local t2 = {
    SettingsYou,
    SettingsGame
}
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)

require(UI.Components.TabBar)

local Pressable = require(UI.Components.Pressable)
local SettingsList = require(UI.Components.SettingsList)
local TabbedScroller = require(UI.Components.TabbedScroller)
local Remote = require(Modules.Objects.Remote)
local ChangeYouSetting = Remote.get("ChangeYouSetting")
local ChangeGameSetting = Remote.get("ChangeGameSetting")
local GetDefaultYouSettings = Remote.get("GetDefaultYouSettings")
local clientUser = require(Modules.References.clientUser)
local Children = Fusion.Children

return function(p1, p2) -- line: 45
    -- upvalues: Modules (copy), Permissions (copy), NoPermissionPlaceholder (copy), t1 (copy), t2 (copy), Fusion (copy), Theme (copy), Pressable (copy), SettingsList (copy), TabbedScroller (copy), ChangeYouSetting (copy), ChangeGameSetting (copy), GetDefaultYouSettings (copy), clientUser (copy), Children (copy)
    local v2 = p2 and p2.onItemSelectorOpen
    local v1 = p2 and p2.panelClosed
    local v3 = p1:Value(1)
    local t3 = {
        Permissions.canViewPage(p1, "YouSettings"),
        (Permissions.canViewPage(p1, "GameSettings"))
    }
    local v4 = false

    table.insert(p1, function() -- line: 58
        -- upvalues: v4 (ref)
        v4 = true
    end)

    local t4 = {
        p1:Value(nil),
        p1:Value(nil)
    }
    local v6 = p1:Fuse("everyone", { "SavedGameSettings", "SystemSettings", "UseDefaultGameSettings" })

    task.spawn(function() -- line: 72
        -- upvalues: clientUser (copy)
        clientUser.everyone:fetchAsync("SavedGameSettings")
        clientUser.everyone:fetchAsync("DefaultGameSettings")
    end)

    local v7 = p1:Value(Fusion.peek(v6) == true)
    local v8 = false

    local function gameTogglePending() -- line: 82
        -- upvalues: v8 (ref)
        return v8
    end

    p1:Observer(v6):onChange(function() -- line: 86
        -- upvalues: v4 (ref), v6 (copy), v7 (copy), v8 (ref), Fusion (copy)
        if not v4 and not v8 then
            v7:set(Fusion.peek(v6) == true)
        end
    end)

    local v10 = p1:Computed(function(p3) -- line: 92
        -- upvalues: v7 (copy)
        return p3(v7) == true
    end)
    local deepCopyTable = require(Modules.TableUtil.deepCopyTable)
    local v11
    local v12 = false

    local function buildForcedView() -- line: 102
        -- upvalues: deepCopyTable (copy), v11 (ref), clientUser (copy)
        local DefaultGameSettings = clientUser.everyone:get("DefaultGameSettings")

        if typeof(DefaultGameSettings) ~= "table" then
            return nil
        end

        local v13 = deepCopyTable(DefaultGameSettings)

        if typeof(v13.SystemSettings) ~= "table" then
            v13.SystemSettings = {}
        end

        local v14 = v11

        if typeof(v14) ~= "table" then
            v14 = clientUser.everyone:get("SavedGameSettings")
        end

        if typeof(v14) == "table" and typeof(v14.SystemSettings) == "table" then
            for _, v15 in { "UseDefaultGameSettings", "UseDefaultRoles" } do
                if v14.SystemSettings[v15] ~= nil then
                    v13.SystemSettings[v15] = v14.SystemSettings[v15]
                end
            end
        end

        v13.SystemSettings.UseDefaultGameSettings = true

        return v13
    end

    local function buildSavedView() -- line: 119
        -- upvalues: deepCopyTable (copy), clientUser (copy)
        local SavedGameSettings = clientUser.everyone:get("SavedGameSettings")

        if typeof(SavedGameSettings) ~= "table" then
            return nil
        end

        local v16 = deepCopyTable(SavedGameSettings)

        if typeof(v16.SystemSettings) ~= "table" then
            v16.SystemSettings = {}
        end

        v16.SystemSettings.UseDefaultGameSettings = false

        return v16
    end

    local function applyPreview(p4) -- line: 127
        -- upvalues: v4 (ref), v6 (copy), v7 (copy), v12 (ref), buildForcedView (copy), buildSavedView (copy), applyPreview (copy), Fusion (copy), clientUser (copy)
        local v17 = if p4 then buildForcedView() else buildSavedView()

        if v17 then
            v12 = true
            clientUser.everyone:set("GameSettings", v17)
            v12 = false

            return
        end

        task.spawn(function() -- line: 131
            -- upvalues: p4 (copy), v4 (ref), v6 (copy), v7 (copy), applyPreview (copy), Fusion (copy), clientUser (copy)
            clientUser.everyone:fetchAsync("SavedGameSettings")
            clientUser.everyone:fetchAsync("DefaultGameSettings")

            if v4 then
                return
            end

            local v18 = Fusion.peek(v7) == true == p4
            local v19 = Fusion.peek(v7) == true ~= (Fusion.peek(v6) == true)

            if v18 and v19 then
                applyPreview(p4)
            end
        end)
    end

    local function startPreview() -- line: 147
        -- upvalues: v7 (copy), v11 (ref), applyPreview (copy), Fusion (copy), clientUser (copy)
        if v11 == nil then
            v11 = clientUser.everyone:get("GameSettings")
            applyPreview(Fusion.peek(v7) == true)
        end
    end

    local function endPreview(p5) -- line: 152
        -- upvalues: v11 (ref), v12 (ref), clientUser (copy)
        if v11 == nil then
            return
        end

        if p5 then
            v12 = true

            local everyone = clientUser.everyone

            everyone:set("GameSettings", v11)
            v12 = false
        end

        v11 = nil
    end

    local GameSettings = p1:Fuse("everyone", "GameSettings")

    p1:Observer(GameSettings):onChange(function() -- line: 163
        -- upvalues: v7 (copy), v11 (ref), v12 (ref), applyPreview (copy), GameSettings (copy), Fusion (copy)
        if not v12 and v11 ~= nil then
            v11 = Fusion.peek(GameSettings)
            applyPreview(Fusion.peek(v7) == true)
        end
    end)
    p1:Observer(v7):onChange(function() -- line: 169
        -- upvalues: v4 (ref), v6 (copy), v7 (copy), v11 (ref), v12 (ref), applyPreview (copy), Fusion (copy), clientUser (copy)
        if v4 then
            return
        end

        local v21 = Fusion.peek(v7) == true

        if v21 == (Fusion.peek(v6) == true) then
            if v11 ~= nil then
                v12 = true
                clientUser.everyone:set("GameSettings", v11)
                v12 = false
                v11 = nil
            end
        elseif v11 ~= nil then
            applyPreview(v21)
        else
            v11 = clientUser.everyone:get("GameSettings")
            applyPreview(Fusion.peek(v7) == true)
        end
    end)

    local v23 = p1:Value(false)
    local v24 = p1:Computed(function(p6) -- line: 185
        -- upvalues: v3 (copy), t4 (copy), v23 (copy)
        local v25 = p6(v3)
        local v26 = p6(t4[v25])
        local v27 = if v26 then p6(v26.hasPendingChanges) else false

        if v25 ~= 2 or not p6(v23) then
            return v27
        end

        return true
    end)

    local function callActiveConfirm() -- line: 195
        -- upvalues: v3 (copy), v4 (ref), t4 (copy), v6 (copy), v7 (copy), v8 (ref), v11 (ref), v23 (copy), Modules (copy), Fusion (copy), ChangeGameSetting (copy)
        local v28 = Fusion.peek(v3)
        local v29 = Fusion.peek(t4[v28])

        if v29 then
            v29.confirmChanges()
        end

        if v28 == 2 and v8 then
            local v30 = Fusion.peek(v7)

            v8 = false
            v23:set(false)
            task.spawn(function() -- line: 203
                -- upvalues: v30 (copy), v4 (ref), v6 (copy), v7 (copy), v11 (ref), Modules (copy), Fusion (copy), ChangeGameSetting (copy)
                local function v31() -- line: 204
                    -- upvalues: v30 (copy), ChangeGameSetting (copy)
                    return ChangeGameSetting:invokeServerAsync({ "SystemSettings", "UseDefaultGameSettings" }, v30)
                end

                local v32, v33, v34, v35 = pcall(v31)

                if not v4 then
                    if not v32 or not v33 then
                        local Prompt = require(Modules.Prompt)
                        local v36 = if v32 then v35 == "error" else nil
                        local v37 = if not v32 or not v36 then Prompt.warn else Prompt.error

                        if not v32 then
                            v34 = v33
                        end

                        v37(tostring(v34) or "Failed to save setting")
                        v7:set(Fusion.peek(v6) == true)
                    elseif v11 ~= nil then
                        v11 = nil
                    end
                end
            end)
        end
    end

    local function callActiveUndo() -- line: 223
        -- upvalues: v3 (copy), t4 (copy), v6 (copy), v7 (copy), v8 (ref), v23 (copy), Fusion (copy)
        local v38 = Fusion.peek(v3)
        local v39 = Fusion.peek(t4[v38])

        if v39 then
            v39.undoChanges()
        end

        if v38 ~= 2 then
            return
        end

        v8 = false
        v23:set(false)
        v7:set(Fusion.peek(v6) == true)
    end

    if v1 then
        local v41 = p1:Observer(v1)

        v41:onChange(function() -- line: 235
            -- upvalues: v4 (ref), t4 (copy), v6 (copy), v7 (copy), v1 (copy), Fusion (copy)
            if not v4 and Fusion.peek(v1) == true then
                for _, v43 in t4 do
                    local v44 = Fusion.peek(v43)

                    if v44 then
                        v44.undoChanges()
                    end
                end

                v7:set(Fusion.peek(v6) == true)
            end
        end)
    end

    local v45 = p1:Fuse("everyone", { "GameSettings", "SystemSettings", "CanChangeYouSettingsTheme" })
    local v46 = p1:Fuse("everyone", { "GameSettings", "SystemSettings", "CanChangeYouSettingsPrimaryColor" })
    local v47 = p1:Fuse("everyone", { "GameSettings", "SystemSettings", "CanChangeYouSettingsFont" })
    local v48 = p1:Fuse("everyone", { "GameSettings", "SystemSettings", "CanChangeYouSettingsPrefix" })
    local v49 = p1:Fuse("everyone", { "GameSettings", "SystemSettings", "CanChangeYouSettingsContentScale" })
    local v50 = p1:Fuse("everyone", { "GameSettings", "SystemSettings", "CanChangeYouSettingsMenuHeight" })
    local v51 = p1:Fuse("everyone", { "GameSettings", "SystemSettings", "CanChangeYouSettingsVolume" })
    local v52 = p1:Fuse("everyone", { "GameSettings", "SystemSettings", "CanChangeYouSettingsPitch" })
    local v53 = p1:Computed(function(p7) -- line: 267
        -- upvalues: v45 (copy)
        return p7(v45) == false
    end)
    local v54 = p1:Computed(function(p8) -- line: 270
        -- upvalues: v46 (copy), Theme (copy)
        if p8(v46) == false then
            return true
        end

        return p8(Theme.Settings.LockPrimaryColor) == true
    end)
    local v55 = p1:Computed(function(p9) -- line: 275
        -- upvalues: v47 (copy), Theme (copy)
        if p9(v47) == false then
            return true
        end

        return p9(Theme.Settings.LockFont) == true
    end)
    local v56 = p1:Computed(function(p10) -- line: 280
        -- upvalues: v48 (copy)
        return p10(v48) == false
    end)
    local v57 = p1:Computed(function(p11) -- line: 283
        -- upvalues: v49 (copy)
        return p11(v49) == false
    end)
    local v58 = p1:Computed(function(p12) -- line: 286
        -- upvalues: v50 (copy)
        return p12(v50) == false
    end)
    local v59 = p1:Computed(function(p13) -- line: 289
        -- upvalues: v51 (copy)
        return p13(v51) == false
    end)
    local v60 = p1:Computed(function(p14) -- line: 292
        -- upvalues: v52 (copy)
        return p14(v52) == false
    end)
    local permitBlockCommands = Permissions.hasPermission(p1, "permitBlockCommands")
    local v61 = p1:Computed(function(p15) -- line: 296
        -- upvalues: permitBlockCommands (copy)
        return p15(permitBlockCommands) ~= true
    end)
    local v62 = p1:Computed(function(p16) -- line: 299
        -- upvalues: v45 (copy), v46 (copy), v47 (copy), v48 (copy), v49 (copy), v50 (copy), v51 (copy), v52 (copy)
        if p16(v45) == false and p16(v46) == false and p16(v47) == false and p16(v49) == false and p16(v50) == false and p16(v48) == false and p16(v51) == false then
            return p16(v52) == false
        end

        return false
    end)

    local function buildContentWithRestore(p17, p18, p19, p20) -- line: 310
        -- upvalues: t4 (copy), Fusion (copy), Theme (copy), Pressable (copy), Children (copy)
        local Neutral, BaseContent = Theme.Color.Neutral, Theme.Color.BaseContent
        local v63 = p17:Value(false)
        local v64 = p17:Value(false)

        local function isLockedValue(p21) -- line: 315
            -- upvalues: p20 (copy)
            return p20 ~= nil and p21(p20) == true
        end

        local v65 = p17:Computed(function(p22) -- line: 319
            -- upvalues: p20 (copy), Neutral (copy), v63 (copy), v64 (copy)
            local v66 = p22(Neutral)
            local v67 = if 0.299 * v66.R + 0.587 * v66.G + 0.114 * v66.B > 0.5 then Color3.new(0, 0, 0) else Color3.new(1, 1, 1)

            if p20 == nil or p22(p20) ~= true then
                if p22(v64) then
                    return v66:Lerp(v67, 0.2)
                end

                if p22(v63) then
                    return v66:Lerp(v67, 0.1)
                end
            end

            return v66
        end)
        local v68 = p17:Computed(function(p23) -- line: 331
            -- upvalues: p20 (copy)
            if p20 ~= nil and p23(p20) == true then
                return 0.65
            end

            return 0
        end)
        local v69 = p17:Computed(function(p24) -- line: 334
            -- upvalues: p20 (copy)
            return not (p20 ~= nil and p24(p20) == true)
        end)
        local v75 = Pressable(p17, {
            name = "RestoreDefaultsButton",
            size = UDim2.new(1, 0, 0, 38),
            backgroundColor = v65,
            layoutOrder = 2,
            interactable = v69,
            onHoverChanged = function(p25) -- onHoverChanged | line: 343
                -- upvalues: v63 (copy)
                v63:set(p25)
            end,
            onPressChanged = function(p26) -- onPressChanged | line: 344
                -- upvalues: v64 (copy)
                v64:set(p26)
            end,
            onActivate = function() -- onActivate | line: 345
                -- upvalues: p18 (copy), p20 (copy), t4 (copy), Fusion (copy)
                if p20 == nil or Fusion.peek(p20) ~= true then
                    local v70 = Fusion.peek(t4[p18])

                    if v70 and v70.restoreDefaults then
                        v70.restoreDefaults()
                    end
                end
            end,
            [Children] = {
                p17:New("UICorner")({
                    CornerRadius = UDim.new(0, 9)
                }),
                p17:New("UIStroke")({
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Color3.new(1, 1, 1),
                    [Children] = {
                        p17:New("UIGradient")({
                            Rotation = 90,
                            Color = p17:Computed(function(p27) -- line: 359
                                -- upvalues: Neutral (copy), Theme (copy)
                                local v72 = p27(Neutral)
                                local v73 = p27(Theme.Color.NeutralContent)

                                return ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, v73),
                                    ColorSequenceKeypoint.new(1, v72)
                                })
                            end)
                        })
                    }
                }),
                p17:New("Frame")({
                    Name = "Content",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.new(0, 0, 1, 0),
                    [Children] = {
                        p17:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Horizontal,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            Padding = UDim.new(0, 6),
                            SortOrder = Enum.SortOrder.LayoutOrder
                        }),
                        p17:New("TextLabel")({
                            Name = "Label",
                            BackgroundTransparency = 1,
                            LayoutOrder = 2,
                            Text = "Restore Defaults",
                            AutomaticSize = Enum.AutomaticSize.X,
                            FontFace = p17:Computed(function(p28) -- line: 390
                                -- upvalues: Theme (copy)
                                return Font.new(p28(Theme.Font.Body), p28(Theme.FontWeight.Body))
                            end),
                            Size = UDim2.new(0, 0, 1, 0),
                            TextColor3 = BaseContent,
                            TextSize = p17:Computed(function(p29) -- line: 397
                                -- upvalues: Theme (copy)
                                return (math.round(p29(Theme.Layout.ContentScale) * 17))
                            end),
                            TextTransparency = v68,
                            TextTruncate = Enum.TextTruncate.SplitWord,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            TextYAlignment = Enum.TextYAlignment.Center
                        })
                    }
                })
            }
        })
        local v76 = p17:New("Frame")({
            Name = "DangerZone",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Size = UDim2.fromScale(1, 0),
            [Children] = {
                p17:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Vertical,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    Padding = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                p17:New("TextLabel")({
                    Name = "Heading",
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Text = "Danger Zone",
                    AutomaticSize = Enum.AutomaticSize.XY,
                    FontFace = p17:Computed(function(p30) -- line: 426
                        -- upvalues: Theme (copy)
                        return Font.new(p30(Theme.Font.Heading), p30(Theme.FontWeight.Heading))
                    end),
                    TextColor3 = Theme.Color.BaseContent,
                    TextSize = Theme.TextSize.Title,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                p17:New("Frame")({
                    Name = "DividerWrap",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = 2,
                    Size = UDim2.new(1, 0, 0, 0),
                    [Children] = {
                        p17:New("UIPadding")({
                            PaddingTop = UDim.new(0, 6),
                            PaddingBottom = UDim.new(0, 4)
                        }),
                        p17:New("Frame")({
                            Name = "Divider",
                            BackgroundColor3 = Theme.Color.NeutralContent,
                            Size = UDim2.new(1, 0, 0, 1)
                        })
                    }
                }),
                p17:New("Frame")({
                    Name = "Rows",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = 3,
                    Size = UDim2.fromScale(1, 0),
                    [Children] = {
                        p17:New("UIPadding")({
                            PaddingTop = UDim.new(0, 6)
                        }),
                        v75
                    }
                })
            }
        })

        p19.LayoutOrder = 1

        return p17:New("Frame")({
            Name = "TabContentStack_" .. tostring(p18),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            [Children] = {
                p17:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Vertical,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    Padding = UDim.new(0, 18),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                p19,
                v76
            }
        })
    end

    local function buildTabContent(p31, p32) -- line: 488
        -- upvalues: p1 (copy), t4 (copy), v6 (copy), v7 (copy), v8 (ref), v10 (copy), v23 (copy), v53 (copy), v54 (copy), v55 (copy), v56 (copy), v57 (copy), v58 (copy), v59 (copy), v60 (copy), v61 (copy), v62 (copy), buildContentWithRestore (copy), v2 (copy), t2 (copy), Fusion (copy), Theme (copy), Pressable (copy), SettingsList (copy), ChangeYouSetting (copy), ChangeGameSetting (copy), GetDefaultYouSettings (copy), clientUser (copy), Children (copy)
        local v77 = t2[p32]

        if p32 == 1 then
            local function getYouDefaults() -- line: 492
                -- upvalues: GetDefaultYouSettings (copy)
                local v78, v79 = GetDefaultYouSettings:invokeServerAsync()

                return if v78 and typeof(v79) == "table" then v79 else nil
            end

            local v81 = buildContentWithRestore(p31, p32, (SettingsList(p31, {
                stateSource = "perm",
                noScroll = true,
                settingsData = v77,
                onItemSelectorOpen = v2,
                onChangeRemote = ChangeYouSetting,
                getDefaults = getYouDefaults,
                hiddenByTitle = {
                    Theme = v53,
                    ["Primary Color"] = v54,
                    Font = v55,
                    ["Content Scale"] = v57,
                    ["Menu Height"] = v58,
                    Prefix = v56,
                    ["SFX Volume"] = v59,
                    ["Music Volume"] = v59,
                    ["Cmd Volume"] = v59,
                    ["SFX Pitch"] = v60,
                    ["Music Pitch"] = v60,
                    ["Cmd Pitch"] = v60,
                    ["Block commands"] = v61,
                    ["Block prompts"] = v61
                },
                controllerRef = t4[p32]
            })))
            local v82 = p31:Computed(function(p33) -- line: 525
                -- upvalues: v62 (copy)
                if p33(v62) then
                    return (UDim2.new())
                end

                return (UDim2.fromScale(1, 0))
            end)
            local v83 = p31:Computed(function(p34) -- line: 528
                -- upvalues: v62 (copy)
                if p34(v62) then
                    return Enum.AutomaticSize.None
                end

                return Enum.AutomaticSize.Y
            end)
            local v84 = p31:Computed(function(p35) -- line: 531
                -- upvalues: v62 (copy)
                return p35(v62) ~= true
            end)
            local v85 = p31:Computed(function(p36) -- line: 534
                -- upvalues: v62 (copy)
                return p36(v62) == true
            end)

            return p31:New("Frame")({
                Name = "YouTabContent",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                [Children] = {
                    p31:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p31:New("Frame")({
                        Name = "RegularWrap",
                        AutomaticSize = v83,
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                        Size = v82,
                        Visible = v84,
                        [Children] = { v81 }
                    }),
                    p31:New("TextLabel")({
                        Name = "EmptyPlaceholder",
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        FontFace = p31:Computed(function(p37) -- line: 561
                            -- upvalues: Theme (copy)
                            return Font.new(p37(Theme.Font.Body), p37(Theme.FontWeight.Body))
                        end),
                        LayoutOrder = 2,
                        Size = UDim2.fromScale(1, 0),
                        Text = "This game has hidden its settings",
                        TextColor3 = Theme.Color.NeutralContentDark,
                        TextSize = Theme.TextSize.Subtitle,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        Visible = v85,
                        [Children] = {
                            p31:New("UIPadding")({
                                PaddingTop = UDim.new(0, 24),
                                PaddingBottom = UDim.new(0, 24)
                            })
                        }
                    })
                }
            })
        end

        local function getGameDefaults() -- line: 583
            -- upvalues: v77 (copy), clientUser (copy)
            local DefaultGameSettings = clientUser.everyone:get("DefaultGameSettings")

            if typeof(DefaultGameSettings) ~= "table" then
                return nil
            end

            local t8 = {}

            for _, v86 in v77 do
                local t9 = {}

                for _, v87 in v86.objects do
                    local v88 = #v87.settingPath
                    local v89 = DefaultGameSettings

                    for i = 2, v88 do
                        if typeof(v89) ~= "table" then
                            v89 = nil
                            break
                        end

                        v89 = v89[v87.settingPath[i]]
                    end

                    t9[v87.title] = v89
                end

                t8[v86.heading] = t9
            end

            return t8
        end

        local v90 = SettingsList(p31, {
            stateSource = "everyone",
            noScroll = true,
            settingsData = v77,
            onItemSelectorOpen = v2,
            onChangeRemote = ChangeGameSetting,
            hiddenByTitle = {
                UseDefaultRoles = true,
                UseDefaultGameSettings = true
            },
            changeRemoteArgsBuilder = function(p38) -- changeRemoteArgsBuilder | line: 617
                local v91 = table.clone(p38.settingPath)

                table.remove(v91, 1)

                return v91, p38.intendedValue
            end,
            getDefaults = getGameDefaults,
            lockRule = function(p39) -- lockRule | line: 623
                -- upvalues: p1 (copy), v10 (copy)
                local v92 = p39.obj.title == "MinimumAccountAge"
                local EnableMinimumAccountAge = if v92 then p39.valueByTitle.EnableMinimumAccountAge else nil

                if not v92 or not EnableMinimumAccountAge then
                    return v10
                end

                return p1:Computed(function(p40) -- line: 627
                    -- upvalues: EnableMinimumAccountAge (copy), v10 (copy)
                    if p40(v10) == true then
                        return true
                    end

                    return p40(EnableMinimumAccountAge) ~= true
                end)
            end,
            contentLocked = v10,
            controllerRef = t4[p32]
        })

        local function toggleUseDefaultGameSettings() -- line: 640
            -- upvalues: v6 (copy), v7 (copy), v8 (ref), v23 (copy), Fusion (copy)
            local v93 = not Fusion.peek(v7)

            v8 = v93 ~= (Fusion.peek(v6) == true)
            v23:set(v8)
            v7:set(v93)
        end

        local v95 = p31:Value(false)
        local v96 = p31:Value(false)
        local v97 = p31:Computed(function(p41) -- line: 650
            -- upvalues: v95 (copy), v96 (copy), v7 (copy), Theme (copy)
            local v98 = if p41(v7) then p41(Theme.Color.Primary) else p41(Theme.Color.NeutralContent)
            local v99 = if 0.299 * v98.R + 0.587 * v98.G + 0.114 * v98.B > 0.5 then Color3.new(0, 0, 0) else Color3.new(1, 1, 1)

            if p41(v96) then
                return v98:Lerp(v99, 0.2)
            end

            if p41(v95) then
                return v98:Lerp(v99, 0.1)
            end

            return v98
        end)
        local v105 = p31:New("Frame")({
            Name = "UseDefaultsRow",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            Size = UDim2.fromScale(1, 0),
            [Children] = {
                p31:New("Frame")({
                    Name = "UseDefaultsLabel",
                    BackgroundColor3 = Theme.Color.Neutral,
                    Size = UDim2.new(1, 0, 0, 38),
                    [Children] = {
                        p31:New("UICorner")({
                            CornerRadius = UDim.new(0, 6)
                        }),
                        p31:New("UIStroke")({
                            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                            Color = Theme.Color.NeutralStroke
                        }),
                        p31:New("UIPadding")({
                            PaddingLeft = UDim.new(0, 12),
                            PaddingRight = UDim.new(0, 8)
                        }),
                        p31:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Horizontal,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                            HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
                            SortOrder = Enum.SortOrder.LayoutOrder
                        }),
                        p31:New("TextLabel")({
                            Name = "Label",
                            BackgroundTransparency = 1,
                            LayoutOrder = 1,
                            Text = "Use Studio Defaults",
                            AutomaticSize = Enum.AutomaticSize.XY,
                            FontFace = p31:Computed(function(p42) -- line: 690
                                -- upvalues: Theme (copy)
                                return Font.new(p42(Theme.Font.Body), p42(Theme.FontWeight.Regular))
                            end),
                            TextColor3 = Theme.Color.NeutralContentDark,
                            TextSize = Theme.TextSize.Subtitle
                        }),
                        Pressable(p31, {
                            name = "UseDefaultsToggle",
                            size = UDim2.fromOffset(48, 26),
                            layoutOrder = 2,
                            onActivate = toggleUseDefaultGameSettings,
                            onHoverChanged = function(p43) -- onHoverChanged | line: 703
                                -- upvalues: v95 (copy)
                                v95:set(p43)
                            end,
                            onPressChanged = function(p44) -- onPressChanged | line: 704
                                -- upvalues: v96 (copy)
                                v96:set(p44)
                            end,
                            [Children] = {
                                p31:New("Frame")({
                                    Name = "Track",
                                    BackgroundColor3 = v97,
                                    Size = UDim2.fromScale(1, 1),
                                    [Children] = {
                                        p31:New("UICorner")({
                                            CornerRadius = UDim.new(1, 0)
                                        }),
                                        p31:New("Frame")({
                                            Name = "Thumb",
                                            AnchorPoint = Vector2.new(0, 0.5),
                                            BackgroundColor3 = Color3.new(1, 1, 1),
                                            Position = p31:Spring(p31:Computed(function(p45) -- line: 716
                                                -- upvalues: v7 (copy)
                                                if p45(v7) then
                                                    return (UDim2.new(1, -22, 0.5, 0))
                                                end

                                                return (UDim2.new(0, 4, 0.5, 0))
                                            end), 40, 1),
                                            Size = UDim2.fromOffset(16, 16),
                                            ZIndex = 2,
                                            [Children] = {
                                                p31:New("UICorner")({
                                                    CornerRadius = UDim.new(1, 0)
                                                })
                                            }
                                        })
                                    }
                                })
                            }
                        })
                    }
                })
            }
        })
        local Frame3 = p31:New("Frame")
        local t13 = {
            Name = "GameTabContent",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0)
        }
        local v106 = p31:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 18),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        v90.LayoutOrder = 1
        t13[Children] = { v106, v105, v90 }

        return buildContentWithRestore(p31, p32, Frame3(t13), v10)
    end

    local v108 = p1:Spring(p1:Computed(function(p46) -- line: 760
        -- upvalues: v24 (copy)
        if p46(v24) then
            return 54
        end

        return 0
    end), 40, 1)
    local v109 = p1:New("Frame")({
        Name = "ConfirmBarWrap",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            p1:New("Frame")({
                Name = "ConfirmBar",
                AnchorPoint = Vector2.new(0, 0.5),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Color.Neutral,
                Position = UDim2.new(0, 2, 0.5, 0),
                Size = UDim2.new(1, -7, 0, -2),
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = UDim.new(0, 6)
                    }),
                    p1:New("UIStroke")({
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = Theme.Color.NeutralContent
                    }),
                    p1:New("UIPadding")({
                        PaddingBottom = UDim.new(0, 14),
                        PaddingLeft = UDim.new(0, 12),
                        PaddingRight = UDim.new(0, 4),
                        PaddingTop = UDim.new(0, 14)
                    }),
                    p1:New("Frame")({
                        Name = "LabelGroup",
                        AnchorPoint = Vector2.new(0, 0.5),
                        AutomaticSize = Enum.AutomaticSize.XY,
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(0, 0.5),
                        [Children] = {
                            p1:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center
                            }),
                            p1:New("TextLabel")({
                                Name = "Label",
                                BackgroundTransparency = 1,
                                Text = "Confirm?",
                                AutomaticSize = Enum.AutomaticSize.XY,
                                FontFace = p1:Computed(function(p47) -- line: 808
                                    -- upvalues: Theme (copy)
                                    return Font.new(p47(Theme.Font.Body), p47(Theme.FontWeight.Body))
                                end),
                                TextColor3 = Theme.Color.BaseContent,
                                TextSize = Theme.TextSize.Subtitle
                            })
                        }
                    }),
                    p1:New("Frame")({
                        Name = "ButtonGroup",
                        AnchorPoint = Vector2.new(1, 0.5),
                        AutomaticSize = Enum.AutomaticSize.XY,
                        BackgroundTransparency = 1,
                        Position = UDim2.fromScale(1, 0.5),
                        [Children] = {
                            p1:New("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                HorizontalFlex = Enum.UIFlexAlignment.None,
                                Padding = UDim.new(0, 6),
                                SortOrder = Enum.SortOrder.LayoutOrder,
                                VerticalAlignment = Enum.VerticalAlignment.Center
                            }),
                            Pressable(p1, {
                                name = "ConfirmButton",
                                size = UDim2.new(0, 0, 0, 0),
                                automaticSize = Enum.AutomaticSize.XY,
                                backgroundColor = Theme.Color.Primary,
                                layoutOrder = 1,
                                onActivate = callActiveConfirm,
                                [Children] = {
                                    p1:New("UICorner")({
                                        CornerRadius = UDim.new(0, 6)
                                    }),
                                    p1:New("UIPadding")({
                                        PaddingBottom = UDim.new(0, 7),
                                        PaddingLeft = UDim.new(0, 12),
                                        PaddingRight = UDim.new(0, 12),
                                        PaddingTop = UDim.new(0, 7)
                                    }),
                                    p1:New("TextLabel")({
                                        Name = "Label",
                                        BackgroundTransparency = 1,
                                        Text = "Confirm",
                                        AutomaticSize = Enum.AutomaticSize.XY,
                                        FontFace = p1:Computed(function(p48) -- line: 852
                                            -- upvalues: Theme (copy)
                                            return Font.new(p48(Theme.Font.Body), p48(Theme.FontWeight.Body))
                                        end),
                                        TextColor3 = Theme.Color.PrimaryContent,
                                        TextSize = Theme.TextSize.Subtitle
                                    })
                                }
                            }),
                            Pressable(p1, {
                                name = "UndoButton",
                                size = UDim2.new(0, 0, 0, 0),
                                automaticSize = Enum.AutomaticSize.XY,
                                backgroundColor = Theme.Color.NeutralContent,
                                layoutOrder = 2,
                                onActivate = callActiveUndo,
                                [Children] = {
                                    p1:New("UICorner")({
                                        CornerRadius = UDim.new(0, 6)
                                    }),
                                    p1:New("UIPadding")({
                                        PaddingBottom = UDim.new(0, 7),
                                        PaddingLeft = UDim.new(0, 12),
                                        PaddingRight = UDim.new(0, 12),
                                        PaddingTop = UDim.new(0, 7)
                                    }),
                                    p1:New("TextLabel")({
                                        Name = "Label",
                                        BackgroundTransparency = 1,
                                        Text = "Undo",
                                        AutomaticSize = Enum.AutomaticSize.XY,
                                        FontFace = p1:Computed(function(p49) -- line: 881
                                            -- upvalues: Theme (copy)
                                            return Font.new(p49(Theme.Font.Body), p49(Theme.FontWeight.Body))
                                        end),
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

    return p1:New("Frame")({
        Name = "SettingsPage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        [Children] = {
            TabbedScroller(p1, {
                tabs = t1,
                activeTabRef = v3,
                buildTabContent = function(p50, p51) -- buildTabContent | line: 906
                    -- upvalues: t3 (copy), buildTabContent (copy), NoPermissionPlaceholder (copy), Children (copy)
                    local v110 = t3[p51]
                    local v111 = buildTabContent(p50, p51)

                    return p50:New("Frame")({
                        Name = "TabGate_" .. p51,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 1),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        [Children] = {
                            p50:New("Frame")({
                                Name = "Body",
                                BackgroundTransparency = 1,
                                Size = UDim2.fromScale(1, 1),
                                AutomaticSize = Enum.AutomaticSize.Y,
                                Visible = v110,
                                [Children] = { v111 }
                            }),
                            p50:New("Frame")({
                                Name = "Denied",
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, 0, 160),
                                Visible = p50:Computed(function(p52) -- line: 927
                                    -- upvalues: v110 (copy)
                                    return not p52(v110)
                                end),
                                [Children] = { NoPermissionPlaceholder(p50, {}) }
                            })
                        }
                    })
                end,
                footerSlot = v109,
                footerHeight = v108
            })
        }
    })
end
