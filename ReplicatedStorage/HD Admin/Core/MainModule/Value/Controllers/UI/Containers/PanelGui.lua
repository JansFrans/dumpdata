-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Log = require(Modules.Log)
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Viewport = require(UI.Config.Viewport)
local Children, Out = Fusion.Children, Fusion.Out
local TitleBar = require(script.Parent.TitleBar)
local PanelState = require(UI.Config.PanelState)
local Pages = require(UI.Config.Pages)
local PlaceholderPage = require(UI.Pages.PlaceholderPage)
local ProfileBody = require(UI.Components.ProfileBody)
local TaskBody = require(UI.Components.TaskBody)
local EmotesPage = require(UI.Pages.EmotesPage)
local CommandsPopupPage = require(UI.Pages.CommandsPopupPage)
local BoosterPage = require(UI.Pages.BoosterPage)
local OutfitsPage = require(UI.Pages.OutfitsPage)
local Navigate = require(UI.Util.Navigate)
local Panels = require(UI.Config.Panels)
local LayerOrder = require(UI.Config.LayerOrder)
local Platform = require(UI.Util.Platform)
local PreviewBanner = require(UI.Components.PreviewBanner)
local UpdateBanner = require(UI.Components.UpdateBanner)
local UpdateLogPopup = require(UI.Components.UpdateLogPopup)
local LoadingSpinner = require(UI.Components.LoadingSpinner)
local Permissions = require(UI.Util.Permissions)
local HintBubble = require(UI.Util.HintBubble)
local t1 = {}

local function getPage(p1) -- line: 40
    -- upvalues: Log (copy), UI (copy), t1 (copy)
    if t1[p1] == nil then
        local v1 = UI.Pages:FindFirstChild(p1 .. "Page")

        if v1 then
            local _require = require
            local ok, result = pcall(_require, v1)

            t1[p1] = if ok and typeof(result) == "function" then result else false

            if not ok then
                Log.debug((("failed to load page '%*': %*"):format(p1, result)))
            end
        else
            t1[p1] = false
        end
    end

    return if t1[p1] then t1[p1] else nil
end

return function(p2, p3) -- line: 72
    -- upvalues: Modules (copy), Fusion (copy), Theme (copy), Viewport (copy), Children (copy), Out (copy), TitleBar (copy), PanelState (copy), Pages (copy), PlaceholderPage (copy), ProfileBody (copy), TaskBody (copy), EmotesPage (copy), CommandsPopupPage (copy), BoosterPage (copy), OutfitsPage (copy), Navigate (copy), Panels (copy), LayerOrder (copy), Platform (copy), PreviewBanner (copy), UpdateBanner (copy), UpdateLogPopup (copy), LoadingSpinner (copy), Permissions (copy), HintBubble (copy), getPage (copy)
    local v3, v4, v5

    if p3.mode == "fitContent" then
        local profilePanel = p3.profilePanel
        local v6 = p2:Computed(function(p4) -- line: 76
            -- upvalues: p3 (copy)
            local visible = p3.visible

            if typeof(visible) == "table" then
                return p4(visible)
            end

            if visible == nil then
                return true
            end

            return visible
        end)
        local v7 = p3.dragOffset or p2:Value(Vector2.zero)
        local v8 = p2:Computed(function(p5) -- line: 84
            -- upvalues: p3 (copy), v7 (copy)
            local position = p3.position
            local v9 = if typeof(position) == "table" then p5(position) else position or UDim2.fromScale(0.5, 0.5)
            local v10 = p5(v7)

            return v9 + UDim2.fromOffset(v10.X, v10.Y)
        end)
        local v11 = p2:New("Frame")({
            Name = "PopupOverlay",
            BackgroundTransparency = 1,
            ZIndex = 100,
            Size = UDim2.fromScale(1, 1)
        })
        local v12 = profilePanel and profilePanel.kind or "profile"
        local v13 = v12 == "preview"
        local v14 = v12 == "task"
        local v15 = v12 == "emotes"
        local v16 = v12 == "commands"
        local v17 = v12 == "booster"
        local v18 = v12 == "outfits"
        local v19 = v13 or v15 or v16 or v17 or v18
        local v20, v21, canGoBack, v22, CanvasGroup, v23

        if v13 then
            local v24 = profilePanel and profilePanel.previewCommandKey or ""

            v22 = p2:Value(v24)

            local v25 = PanelState.new(p2)

            v25.page:set("Run")
            v25.pageHistory:set({
                "Run"
            })

            local v26 = p2:Value({ "Run" })

            local function navigateTo(p6) -- line: 120
                -- upvalues: v25 (copy), v26 (copy), Fusion (copy)
                local v27 = Fusion.peek(v26)

                if not table.find(v27, p6) then
                    local v28 = table.clone(v27)

                    table.insert(v28, p6)
                    v26:set(v28)
                end

                v25:toPage(p6)
            end

            local v29 = p2:Value(nil)

            CanvasGroup = p2:Value({})

            local t2 = {}
            local t3 = {
                commandKey = v22
            }

            if profilePanel then
                t3.initialArgTokens = profilePanel.previewArgTokens
            else
                t3.initialArgTokens = nil
            end

            if profilePanel then
                t3.initialModifierTokens = profilePanel.previewModifierTokens
            else
                t3.initialModifierTokens = nil
            end

            t3.sharedCustomUsers = CanvasGroup

            function t3.onItemSelectorOpen(p7) -- line: 140
                -- upvalues: navigateTo (copy), v29 (copy), Fusion (copy)
                p7.release = function() -- line: 142
                    -- upvalues: p7 (copy), v29 (copy), Fusion (copy)
                    if Fusion.peek(v29) == p7 then
                        v29:set(nil)
                    end
                end

                v29:set(p7)
                navigateTo("ItemSelector")
            end

            t2.Run = t3
            t3 = {
                config = v29
            }

            function t3.onConfirmBack() -- line: 153
                -- upvalues: v25 (copy)
                v25:goBack()
            end

            t2.ItemSelector = t3

            local function buildPageSlide(_, p9, p10) -- line: 158
                -- upvalues: v25 (copy), t2 (copy), Children (copy), PlaceholderPage (copy), getPage (copy)
                local v30 = p9:Spring(p9:Computed(function(p11) -- line: 159
                    -- upvalues: p10 (copy), v25 (copy)
                    local v31 = p11(v25.page)
                    local v32 = p11(v25.prevPage)
                    local v33 = p11(v25.navDirection)
                    local v34 = p11(v25.pageHistory)

                    if v31 == p10 then
                        return UDim2.fromScale(0, 0)
                    end

                    if v32 == p10 then
                        return UDim2.fromScale(-v33, 0)
                    end

                    if (table.find(v34, v31) or 0) > (table.find(v34, p10) or #v34 + 1) then
                        return (UDim2.fromScale(-1, 0))
                    end

                    return (UDim2.fromScale(1, 0))
                end), p9:Computed(function(p12) -- line: 176
                    -- upvalues: p10 (copy), v25 (copy)
                    if p12(v25.page) == p10 or p12(v25.prevPage) == p10 then
                        return 120
                    end

                    return 9999
                end), 2.25)
                local v35 = p9:Computed(function(p13) -- line: 182
                    -- upvalues: p10 (copy), v25 (copy)
                    if p13(v25.page) == p10 then
                        return true
                    end

                    return p13(v25.prevPage) == p10
                end)
                local v36 = getPage(p10)
                local v37 = t2[p10] or {}
                local v38 = if v36 == nil then PlaceholderPage(p9, {
                    pageName = p10
                }) else v36(p9, v37)

                return p9:New("CanvasGroup")({
                    Name = "PageSlide_" .. p10,
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    GroupTransparency = 0,
                    Position = v30,
                    Size = UDim2.fromScale(1, 1),
                    Visible = v35,
                    [Children] = {
                        p9:New("UIListLayout")({
                            FillDirection = Enum.FillDirection.Vertical,
                            HorizontalFlex = Enum.UIFlexAlignment.Fill,
                            VerticalFlex = Enum.UIFlexAlignment.Fill,
                            SortOrder = Enum.SortOrder.LayoutOrder
                        }),
                        p9:New("Frame")({
                            Name = "PageWrap",
                            BackgroundTransparency = 1,
                            LayoutOrder = 1,
                            Size = UDim2.fromScale(1, 1),
                            [Children] = {
                                p9:New("UIListLayout")({
                                    FillDirection = Enum.FillDirection.Vertical,
                                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                    VerticalFlex = Enum.UIFlexAlignment.Fill,
                                    SortOrder = Enum.SortOrder.LayoutOrder
                                }),
                                v38
                            }
                        })
                    }
                })
            end

            v20 = p2:New("Frame")({
                Name = "PreviewPageStack",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                [Children] = { p2:ForValues(v26, buildPageSlide) }
            })
            v21 = p2:Computed(function(p14) -- line: 233
                -- upvalues: v24 (copy), v25 (copy), v29 (copy)
                if p14(v25.page) == "ItemSelector" then
                    local v39 = p14(v29)

                    if typeof(v39) == "table" and typeof(v39.title) == "string" and v39.title ~= "" then
                        return v39.title
                    end

                    return "Select"
                end

                if typeof(v24) ~= "string" or v24 == "" then
                    return "Preview"
                end

                return v24:sub(1, 1):upper() .. v24:sub(2)
            end)
            canGoBack = v25.canGoBack

            v23 = function() -- line: 249
                -- upvalues: v25 (copy)
                v25:goBack()
            end
        else
            if v14 then
                v20 = TaskBody(p2, {
                    taskUID = profilePanel and profilePanel.taskUID or "",
                    snapshot = if profilePanel then profilePanel.taskSnapshot else nil,
                    onOpenProfile = function(p15) -- onOpenProfile | line: 254
                        -- upvalues: Panels (copy)
                        Panels.openProfile(p15)
                    end
                })
                v21 = "Task"
            elseif v15 then
                v20 = EmotesPage(p2, {})
                v21 = "Emotes"
            elseif v16 then
                v20 = CommandsPopupPage(p2, {
                    display = if profilePanel then profilePanel.commandDisplay else nil
                })
                v21 = "/commands"
            elseif v17 then
                v20 = BoosterPage(p2, {})
                v21 = "Chat Commands"
            elseif v18 then
                v20 = OutfitsPage(p2, {})
                v21 = "Cosmetics"
            else
                v20 = ProfileBody(p2, {
                    inline = true,
                    userId = if profilePanel then profilePanel.userId else nil,
                    giverIdentity = if profilePanel then profilePanel.giverIdentity else nil,
                    popupParent = v11
                })
                v21 = "Profile"
            end

            canGoBack = false
        end

        v18 = if profilePanel then profilePanel.id else "Popup"
        v3 = p2:New("Frame")
        v22 = {
            Name = "PanelGui",
            Active = true,
            AnchorPoint = Vector2.new(0.5, 0),
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1,
            Position = v8,
            ZIndex = LayerOrder.register(p2, v18),
            Visible = v6
        }

        local v40 = p2:New("UIScale")({
            Scale = Viewport.Scale
        })
        local v41 = p2:New("TextButton")({
            Name = "InputBlocker",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Text = "",
            TextSize = 1,
            ZIndex = 0,
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
            Size = UDim2.fromScale(1, 1),
            TextColor3 = Color3.new()
        })

        CanvasGroup = p2:New("CanvasGroup")

        local t7 = {
            Name = "Group",
            Active = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.Color.Base,
            GroupTransparency = p2:Spring(p2:Computed(function(p16) -- line: 316
                -- upvalues: v6 (copy)
                if p16(v6) then
                    return 0
                end

                return 1
            end), 60, 1.5),
            Size = UDim2.fromOffset(320, 0)
        }
        local v42 = p2:New("UICorner")({
            CornerRadius = UDim.new(0, 12)
        })
        local v43 = p2:New("UIPadding")({})
        local v44 = p2:New("UIStroke")({
            Transparency = 0.5,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Theme.Color.NeutralStroke
        })

        v4 = p2:New("UIListLayout")({
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        v5 = TitleBar(p2, {
            showLogo = false,
            title = v21,
            canGoBack = canGoBack,
            onBack = v23,
            onClose = p3.onClose,
            onDrag = function(p17) -- onDrag | line: 345
                -- upvalues: v7 (copy), Fusion (copy)
                v7:set(Fusion.peek(v7) + p17)
            end
        })

        local function v45() -- line: 353
            -- upvalues: p2 (copy), v11 (copy), v20 (ref), v19 (copy), Theme (copy), Viewport (copy), Children (copy), Out (copy), Platform (copy)
            if v19 then
                return p2:New("Frame")({
                    Name = "Content",
                    Active = true,
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    LayoutOrder = 2,
                    Size = p2:Computed(function(p18) -- line: 361
                        -- upvalues: Viewport (copy)
                        return UDim2.new(1, 0, 0, p18(Viewport.MaxContentHeight))
                    end),
                    [Children] = {
                        p2:New("Frame")({
                            Name = "PaddingFrame",
                            AnchorPoint = Vector2.new(0.5, 0),
                            BackgroundTransparency = 1,
                            ClipsDescendants = true,
                            Position = UDim2.new(0.5, 0, 0, 14),
                            Size = UDim2.new(1, -28, 1, -34),
                            [Children] = { v20 }
                        })
                    }
                })
            end

            local v47 = math.max(0, 10 - (if Platform.isMobile then 2 else 6))
            local v48 = p2:Value(Vector2.zero)
            local v49 = p2:Computed(function(p19) -- line: 382
                -- upvalues: v48 (copy), Viewport (copy)
                local v50 = p19(Viewport.Scale)

                if v50 <= 0 then
                    v50 = 1
                end

                return p19(v48).Y / v50 + 20
            end)
            local v51 = p2:Computed(function(p20) -- line: 387
                -- upvalues: v49 (copy), Viewport (copy)
                return (math.min(p20(v49), p20(Viewport.MaxContentHeight)))
            end)

            return p2:New("Frame")({
                Name = "Content",
                Active = true,
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                LayoutOrder = 2,
                Size = p2:Computed(function(p21) -- line: 396
                    -- upvalues: v51 (copy)
                    return UDim2.new(1, 0, 0, p21(v51))
                end),
                [Children] = {
                    p2:New("ScrollingFrame")({
                        Name = "Scroller",
                        AutomaticCanvasSize = Enum.AutomaticSize.None,
                        CanvasSize = p2:Computed(function(p22) -- line: 404
                            -- upvalues: v49 (copy)
                            return UDim2.fromOffset(0, p22(v49))
                        end),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        ScrollBarImageColor3 = Theme.Color.NeutralContentDark,
                        ScrollBarImageTransparency = Platform.isMobile and 1 or 0,
                        ScrollBarThickness = Platform.isMobile and 2 or 6,
                        ScrollingDirection = Enum.ScrollingDirection.Y,
                        Selectable = false,
                        Size = UDim2.fromScale(1, 1),
                        VerticalScrollBarInset = Enum.ScrollBarInset.Always,
                        [Children] = {
                            p2:New("UIPadding")({
                                PaddingTop = UDim.new(0, 10),
                                PaddingBottom = UDim.new(0, 10),
                                PaddingLeft = UDim.new(0, 10),
                                PaddingRight = UDim.new(0, v47)
                            }),
                            p2:New("Frame")({
                                Name = "Inner",
                                AutomaticSize = Enum.AutomaticSize.Y,
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, -(v47 + 10), 0, 0),
                                [Children] = {
                                    p2:New("UIListLayout")({
                                        FillDirection = Enum.FillDirection.Vertical,
                                        HorizontalFlex = Enum.UIFlexAlignment.Fill,
                                        SortOrder = Enum.SortOrder.LayoutOrder,
                                        [Out("AbsoluteContentSize")] = v48
                                    }),
                                    v20
                                }
                            }),
                            v11
                        }
                    })
                }
            })
        end

        t7[Children] = {
            v42,
            v43,
            v44,
            v4,
            v5,
            v45()
        }
        v22[Children] = {
            v40,
            v41,
            CanvasGroup(t7)
        }
        v3 = v3(v22)
        LayerOrder.attach(v18, v3)

        return v3
    end

    Theme.bindSetting("Color", "Primary", { "YouSettings", "Display", "PrimaryColor" }, {
        gamePath = { "GameSettings", "PlayerSettings", "Display", "PrimaryColor" },
        gameLockPath = { "GameSettings", "SystemSettings", "CanChangeYouSettingsPrimaryColor" }
    })
    Theme.bindSetting("Font", "Heading", { "YouSettings", "Display", "Font" }, {
        gamePath = { "GameSettings", "PlayerSettings", "Display", "Font" },
        gameLockPath = { "GameSettings", "SystemSettings", "CanChangeYouSettingsFont" }
    })
    Theme.bindSetting("Font", "Body", { "YouSettings", "Display", "Font" }, {
        gamePath = { "GameSettings", "PlayerSettings", "Display", "Font" },
        gameLockPath = { "GameSettings", "SystemSettings", "CanChangeYouSettingsFont" }
    })
    Theme.bindSetting("Layout", "ContentScale", { "YouSettings", "Display", "ContentScale" })
    Theme.bindSetting("Layout", "MenuHeight", { "YouSettings", "Display", "MenuHeight" })
    Theme.bindThemeName({ "YouSettings", "Display", "Theme" }, { "GameSettings", "PlayerSettings", "Display", "Theme" }, { "GameSettings", "SystemSettings", "CanChangeYouSettingsTheme" })

    local v54 = PanelState.new(p2)
    local v55 = p2:Value(if not p3.initialPage or p3.initialPage == "Menu" then { "Menu" } else {
        "Menu",
        p3.initialPage
    })

    if p3.initialPage and p3.initialPage ~= "Menu" then
        task.defer(function() -- line: 489
            -- upvalues: p3 (copy), v54 (copy), Fusion (copy)
            if not Fusion.peek(v54.page) == p3.initialPage then
                v54:toPage(p3.initialPage)
            end
        end)
    end

    local function navigateTo(p23) -- line: 496
        -- upvalues: v54 (copy), v55 (copy), Fusion (copy)
        local v56 = Fusion.peek(v55)

        if not table.find(v56, p23) then
            local v57 = table.clone(v56)

            table.insert(v57, p23)
            v55:set(v57)
        end

        v54:toPage(p23)
    end

    local v58 = Permissions.iconMode(p2)
    local v59 = p2:Computed(function(p24) -- line: 508
        -- upvalues: v58 (copy)
        if p24(v58) == "Commands" then
            return "Commands"
        end

        return "Menu"
    end)

    local function applyRootPage() -- line: 511
        -- upvalues: v54 (copy), v55 (copy), v59 (copy), Fusion (copy)
        local v60 = Fusion.peek(v59)
        local v61 = Fusion.peek(v55)

        if not table.find(v61, v60) then
            local v62 = table.clone(v61)

            table.insert(v62, v60)
            v55:set(v62)
        end

        v54.prevPage:set(nil)
        v54.pageHistory:set({
            v60
        })
        v54.page:set(v60)
    end

    if Fusion.peek(v59) ~= "Menu" then
        applyRootPage()
    end

    p2:Observer(v59):onChange(applyRootPage)

    local function openProfile(p25) -- line: 529
        -- upvalues: Panels (copy)
        Panels.openProfile(p25)
    end

    local function openGiverProfile(p26) -- line: 533
        -- upvalues: Panels (copy)
        Panels.openGiverProfile(p26)
    end

    local v63 = p2:Value("")

    local function openRoleSettings(p27) -- line: 539
        -- upvalues: navigateTo (copy), v63 (copy)
        v63:set(p27)
        navigateTo("RoleSettings")
    end

    local function openRoleCreate() -- line: 544
        -- upvalues: navigateTo (copy)
        navigateTo("RoleCreate")
    end

    local v64 = p2:Value("")
    local v65 = p2:Value(nil)
    local v66 = p2:Value(false)
    local v67 = p2:Value(false)

    local function openRunPage(p28, p29) -- line: 554
        -- upvalues: navigateTo (copy), v64 (copy), v65 (copy), v66 (copy), v67 (copy), Modules (copy)
        local onSettled = if p29 then p29.onSettled else nil

        task.spawn(function() -- line: 556
            -- upvalues: p28 (copy), p29 (copy), onSettled (copy), navigateTo (copy), v64 (copy), v65 (copy), v66 (copy), v67 (copy), Modules (copy)
            local everyone = require(Modules.References.clientUser).everyone
            local v68 = everyone:get("CommandInfo", p28)
            local v69 = false

            if v68 == nil then
                for i = 1, 3 do
                    local v70, v71 = everyone:fetchAsync("CommandInfo", p28)

                    v69 = not v70

                    if v70 then
                        v68 = v71
                        break
                    end

                    task.wait(i * 0.5)
                end
            end

            if onSettled then
                onSettled()
            end

            if v68 ~= nil then
                v64:set(p28)

                local v72 = if p29 then typeof(p29.unlockRole) == "string" else nil

                v65:set(if not p29 or not v72 then nil else p29.unlockRole)
                v67:set(p29 ~= nil and p29.showRoles == true)
                navigateTo("Run")
                v66:set(p29 ~= nil and p29.autoOpenUserArg == true)
            else
                local Prompt = require(Modules.Prompt)

                if v69 then
                    Prompt.error((("Couldn't load <b>%*</b> just now. Try again in a moment."):format(p28)))
                else
                    Prompt.error((("This requires the <b>%*</b> command to be loaded in <b><i>Config &gt; Commands</i></b>"):format(p28)))
                end
            end
        end)
    end

    local v75 = p2:Value(nil)

    v3 = p2:Value({})

    local function openItemSelectorPage(p30) -- line: 599
        -- upvalues: navigateTo (copy), v75 (copy), Fusion (copy)
        p30.release = function() -- line: 601
            -- upvalues: p30 (copy), v75 (copy), Fusion (copy)
            if Fusion.peek(v75) == p30 then
                v75:set(nil)
            end
        end

        v75:set(p30)
        navigateTo("ItemSelector")
    end

    local v76 = p2:Value(nil)
    local v77 = p2:Value(nil)
    local v78 = p2:Value(nil)

    local function openConfigureGroupRoles(p31, p32) -- line: 615
        -- upvalues: navigateTo (copy), v75 (copy), v76 (copy), v77 (copy), v78 (copy), Fusion (copy)
        v76:set(p31)
        v78:set(p32)

        local v79 = Fusion.peek(v75)

        if v79 and v79.onAddItem then
            v77:set(v79.onAddItem)
        end

        navigateTo("ConfigureGroupRoles")
    end

    local v80 = p2:Value("")
    local v81 = p2:Value("")
    local v82 = p2:Value(nil)

    local function openViewCommandsForTag(p33) -- line: 630
        -- upvalues: navigateTo (copy), v80 (copy), v81 (copy)
        v81:set("")
        v80:set(p33)
        navigateTo("CommandsFiltered")
    end

    local function openViewCommandsForRole(p34) -- line: 636
        -- upvalues: navigateTo (copy), v82 (copy)
        v82:set(p34)
        navigateTo("Commands")
    end

    p2:Observer(v54.page):onChange(function() -- line: 643
        -- upvalues: v54 (copy), v82 (copy), Fusion (copy)
        local v83 = Fusion.peek(v54.page)
        local v84 = Fusion.peek(v54.navDirection)

        if v83 ~= "Commands" and v84 < 0 then
            v82:set(nil)
        end
    end)

    local v85 = p2:Value(false)
    local t14 = {
        Menu = {
            onPageActivate = navigateTo
        }
    }

    v4 = {}

    function v4.onBooster() -- line: 657
        -- upvalues: navigateTo (copy)
        navigateTo("Booster")
    end

    t14.About = v4
    v4 = {}
    v4.isActive = p2:Computed(function(p35) -- line: 660
        -- upvalues: v54 (copy)
        return p35(v54.page) == "Commands"
    end)
    v4.onRunPageOpen = openRunPage
    v4.activeRoleFilter = v82
    t14.Commands = v4
    v4 = {
        readonly = true
    }
    v4.isActive = p2:Computed(function(p36) -- line: 667
        -- upvalues: v54 (copy)
        return p36(v54.page) == "CommandsFiltered"
    end)
    v4.filterTag = v80
    v4.filterRole = v81
    t14.CommandsFiltered = v4
    v4 = {}
    v4.isActive = p2:Computed(function(p37) -- line: 675
        -- upvalues: v54 (copy)
        return p37(v54.page) == "VetCommands"
    end)
    v4.onRunPageOpen = openRunPage
    t14.VetCommands = v4
    t14.Run = {
        commandKey = v64,
        unlockRole = v65,
        showRoles = v67,
        activeCommands = p2:Value({}),
        onItemSelectorOpen = openItemSelectorPage,
        sharedCustomUsers = v3,
        autoOpenUserArg = v66
    }
    t14.Settings = {
        onItemSelectorOpen = openItemSelectorPage
    }
    v4 = {
        config = v75
    }

    function v4.onConfirmBack() -- line: 684
        -- upvalues: v54 (copy)
        v54:goBack()
    end

    v4.onOpenConfigureGroupRoles = openConfigureGroupRoles
    v4.onOpenViewCommandsForTag = openViewCommandsForTag
    t14.ItemSelector = v4
    v4 = {
        groupId = v76,
        currentEntry = v78,
        onConfirm = v77
    }

    function v4.onBack() -- line: 692
        -- upvalues: v54 (copy)
        v54:goBack()
    end

    t14.ConfigureGroupRoles = v4
    t14.Moderation = {
        onUserActivate = openProfile,
        onRunPageOpen = openRunPage
    }
    t14.Tasks = {
        onTaskActivate = function(p38, p39) -- onTaskActivate | line: 696
            -- upvalues: Panels (copy)
            Panels.openTask(p38, p39)
        end
    }
    t14.Roles = {
        onMemberActivate = openProfile,
        onRoleActivate = openRoleSettings,
        onRoleCreate = openRoleCreate,
        onRunPageOpen = openRunPage,
        onGiverActivate = openGiverProfile
    }
    v4 = {
        targetRoleKey = v63,
        onItemSelectorOpen = openItemSelectorPage,
        onOpenViewCommandsForRole = openViewCommandsForRole
    }

    function v4.onDeleted() -- line: 711
        -- upvalues: v54 (copy), v63 (copy)
        v63:set("")
        v54:goBack()
    end

    t14.RoleSettings = v4
    v4 = {
        onItemSelectorOpen = openItemSelectorPage
    }

    function v4.onCancel() -- line: 719
        -- upvalues: v54 (copy)
        v54:goBack()
    end

    function v4.onCreated(_) -- line: 722
        -- upvalues: v54 (copy)
        v54:goBack()
    end

    t14.RoleCreate = v4
    t14.Users = {
        onUserActivate = openProfile
    }

    local CommandInfo = p2:Fuse("everyone", "CommandInfo")
    local v86 = p2:Computed(function(p41) -- line: 730
        -- upvalues: v64 (copy), CommandInfo (copy)
        local v87 = p41(v64)

        if v87 ~= "" then
            local v88 = p41(CommandInfo)

            if typeof(v88) == "table" then
                return v88[v87]
            end
        end

        return nil
    end)
    local RoleInfo = p2:Fuse("everyone", "RoleInfo")
    local v89 = "Role"
    local v90 = p2:Computed(function(p42) -- line: 741
        -- upvalues: v54 (copy), v63 (copy), v64 (copy), v75 (copy), v80 (copy), v86 (copy), RoleInfo (copy), v89 (ref), Pages (copy)
        local v91 = p42(v54.page)

        if v91 == "Run" then
            local v92 = p42(v86)

            if type(v92) == "table" then
                return (v92.prefix or ";") .. (v92.name or p42(v64))
            end

            local v93 = p42(v64)

            if v93 == "" then
                return "Run"
            end

            return ";" .. v93
        end

        if v91 == "ItemSelector" then
            local v94 = p42(v75)

            if type(v94) ~= "table" or not v94.title then
                return "Select"
            end

            return "Select " .. v94.title
        end

        if v91 == "CommandsFiltered" then
            local v95 = p42(v80)

            if typeof(v95) ~= "string" or v95 == "" then
                return "Commands"
            end

            return (("'%*' Commands"):format(v95))
        end

        if v91 == "RoleSettings" then
            local v96 = p42(v63)

            if v96 == "" then
                return "Role"
            end

            local v97 = p42(RoleInfo)

            if typeof(v97) ~= "table" or not v97[v96] or not v97[v96].name then
                return v89
            end

            v89 = v97[v96].name

            return v89
        end

        local v98 = Pages[v91]
        local Name = v91

        if v98 then
            Name = v98.Name

            if not Name then
                Name = v98.Id

                if not Name then
                    return v91
                end
            end
        end

        return Name
    end)
    local v99 = p2:Computed(function(p43) -- line: 781
        -- upvalues: v54 (copy)
        local v100 = p43(v54.page)

        if v100 == "Menu" then
            return true
        end

        return v100 == "About"
    end)
    local v101 = p2:Computed(function(p44) -- line: 786
        -- upvalues: v54 (copy)
        return p44(v54.page) == "Menu"
    end)

    v5 = p2:Computed(function(p45) -- line: 790
        -- upvalues: v54 (copy)
        local v102 = p45(v54.page)

        if v102 == "Menu" then
            return true
        end

        return v102 == "About"
    end)

    local v103 = p2:Computed(function(p46) -- line: 795
        -- upvalues: p3 (copy)
        local visible = p3.visible

        if typeof(visible) == "table" then
            return p46(visible)
        end

        if visible == nil then
            return true
        end

        return visible
    end)

    p2:Observer(v103):onChange(function() -- line: 801
        -- upvalues: v103 (copy), Fusion (copy), LayerOrder (copy)
        if Fusion.peek(v103) then
            LayerOrder.raise("MainPanel")
        end
    end)

    local v104 = Permissions.youReady(p2)

    local function buildPageSlide(_, p48, p49) -- line: 811
        -- upvalues: v54 (copy), t14 (copy), v103 (copy), v104 (copy), Children (copy), Pages (copy), PlaceholderPage (copy), LoadingSpinner (copy), getPage (copy)
        local v105 = p48:Spring(p48:Computed(function(p50) -- line: 812
            -- upvalues: p49 (copy), v54 (copy)
            local v106 = p50(v54.page)
            local v107 = p50(v54.prevPage)
            local v108 = p50(v54.navDirection)
            local v109 = p50(v54.pageHistory)

            if v106 == p49 then
                return UDim2.fromScale(0, 0)
            end

            if v107 == p49 then
                return UDim2.fromScale(-v108, 0)
            end

            if (table.find(v109, v106) or 0) > (table.find(v109, p49) or #v109 + 1) then
                return (UDim2.fromScale(-1, 0))
            end

            return (UDim2.fromScale(1, 0))
        end), p48:Computed(function(p51) -- line: 829
            -- upvalues: p49 (copy), v54 (copy)
            if p51(v54.page) == p49 or p51(v54.prevPage) == p49 then
                return 120
            end

            return 9999
        end), 2.25)
        local v110 = p48:Computed(function(p52) -- line: 836
            -- upvalues: p49 (copy), v54 (copy)
            if p52(v54.page) == p49 then
                return true
            end

            return p52(v54.prevPage) == p49
        end)
        local v111 = p48:Computed(function(p53) -- line: 841
            -- upvalues: p49 (copy), v54 (copy), v103 (copy)
            if not p53(v103) then
                return true
            end

            local v112 = p53(v54.page)
            local v113 = p53(v54.prevPage)

            if v112 == p49 or v113 == p49 then
                return false
            end

            local v114 = p53(v54.pageHistory)

            return table.find(v114, p49) == nil
        end)
        local v115 = getPage(p49)
        local v116 = t14[p49] or {}

        v116.idle = v111
        v116.panelClosed = p48:Computed(function(p54) -- line: 853
            -- upvalues: v103 (copy)
            return not p54(v103)
        end)

        local v117 = if v115 == nil then PlaceholderPage(p48, {
            pageName = p49
        }) else v115(p48, v116)
        local v118 = p49 ~= "Menu"
        local v119 = Pages[p49]
        local v120 = v119 ~= nil and v119.FullBleed == true
        local t15 = {
            p48:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                VerticalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            v117
        }

        if not v120 then
            table.insert(t15, p48:New("UIPadding")({
                PaddingBottom = UDim.new(0, 20),
                PaddingLeft = UDim.new(0, 14),
                PaddingRight = UDim.new(0, 14),
                PaddingTop = UDim.new(0, 14)
            }))
        end

        local v121 = p48:New("Frame")({
            Name = "PageWrap",
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.fromScale(1, 1),
            Visible = if v118 then v104 else nil,
            [Children] = t15
        })
        local v122 = if v118 then p48:New("Frame")({
            Name = "PageLoading",
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.fromScale(1, 1),
            Visible = p48:Computed(function(p55) -- line: 898
                -- upvalues: v104 (copy)
                return not p55(v104)
            end),
            [Children] = { LoadingSpinner(p48, {}) }
        }) else nil
        local v123 = if v120 then nil else p48:New("UIPadding")({
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2)
        })

        return p48:New("CanvasGroup")({
            Name = "PageSlide_" .. p49,
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            GroupTransparency = 0,
            Position = v105,
            Size = UDim2.fromScale(1, 1),
            Visible = v110,
            [Children] = {
                v123,
                p48:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Vertical,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    VerticalFlex = Enum.UIFlexAlignment.Fill,
                    SortOrder = Enum.SortOrder.LayoutOrder
                }),
                v121,
                v122
            }
        })
    end

    local v124 = p3.dragOffset or p2:Value(Vector2.zero)

    local function clampDragOffset(p56, p57, p58, p59) -- line: 942
        local v125 = p57.X.Scale * p58.X + p57.X.Offset
        local v126 = p57.Y.Scale * p58.Y + p57.Y.Offset
        local v127 = p59 * 320
        local v128 = p59 * 38
        local v129 = -v126
        local v130 = p58.Y - v126 - v128
        local v131 = math.clamp(p56.Y, v129, v130)
        local v132 = v127 * 0.2
        local v133 = v132 - v127 / 2 - v125
        local v134 = p58.X - v132 + v127 / 2 - v125
        local v135 = math.clamp(p56.X, v133, v134)

        return Vector2.new(v135, v131)
    end

    p2:Observer(Viewport.ViewportSize):onChange(function() -- line: 961
        -- upvalues: v124 (copy)
        v124:set(Vector2.zero)
    end)

    local v136 = p2:Value(nil)
    local v137 = p2:Computed(function(p60) -- line: 967
        -- upvalues: v136 (copy), Viewport (copy)
        local v138 = p60(v136)

        if v138 == nil then
            return (p60(Viewport.MaxContentHeight))
        end

        return v138
    end)

    t14.Menu.contentHeight = v137

    local v139 = p2:Value(Fusion.peek(Viewport.MaxContentHeight))
    local v140 = p2:Value(false)

    p2:Observer((p2:Fuse("perm", { "YouSettings", "Display", "MenuHeight" }))):onChange(function() -- line: 979
        -- upvalues: v136 (copy), v140 (copy), Fusion (copy)
        if not Fusion.peek(v140) then
            v136:set(nil)
        end
    end)

    local v142 = p2:Spring(p2:Computed(function(p61) -- line: 986
        -- upvalues: v103 (copy), v137 (copy)
        if p61(v103) then
            return (p61(v137))
        end

        return 0
    end), p2:Computed(function(p62) -- line: 989
        -- upvalues: v140 (copy)
        if p62(v140) then
            return 9999
        end

        return 120
    end), 1.5)
    local PreviewingRoles = p2:Fuse("temp", "PreviewingRoles")
    local v143 = p2:Value(false)
    local v144 = p2:Computed(function(p63) -- line: 1000
        -- upvalues: PreviewingRoles (copy), v143 (copy)
        local v145 = p63(PreviewingRoles)
        local v146 = if typeof(v145) == "table" and #v145 > 0 then 0 + 36 else 0

        if p63(v143) then
            v146 += 36
        end

        return v146
    end)
    local v147 = p2:Computed(function(p64) -- line: 1012
        -- upvalues: v139 (copy), v140 (copy), v142 (copy), v144 (copy)
        return (math.max((if p64(v140) then p64(v139) else p64(v142)) - p64(v144), 0))
    end)
    local v149 = p2:Computed(function(p65) -- line: 1018
        -- upvalues: p3 (copy), v124 (copy)
        local v150 = if typeof(p3.position) == "table" then p65(p3.position) else p3.position or UDim2.fromScale(0.95, 0.5)
        local v151 = p65(v124)

        return v150 + UDim2.fromOffset(v151.X, v151.Y)
    end)
    local n1 = 0
    local n2 = 0
    local v152 = false
    local Frame = p2:New("Frame")
    local v153 = {
        Name = "PanelGui",
        Active = true,
        AnchorPoint = Vector2.new(0.5, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        Position = v149,
        ZIndex = LayerOrder.register(p2, "MainPanel"),
        Visible = v103
    }
    local v154 = p2:New("UIScale")({
        Scale = Viewport.Scale
    })
    local v155 = p2:New("TextButton")({
        Name = "InputBlocker",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Text = "",
        TextSize = 1,
        ZIndex = 0,
        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
        Size = UDim2.fromScale(1, 1),
        TextColor3 = Color3.new()
    })
    local CanvasGroup = p2:New("CanvasGroup")
    local t18 = {
        Name = "Group",
        Active = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Color.Base,
        GroupTransparency = p2:Spring(p2:Computed(function(p66) -- line: 1071
            -- upvalues: v103 (copy)
            if p66(v103) then
                return 0
            end

            return 1
        end), 60, 1.5),
        Size = UDim2.fromOffset(320, 0)
    }
    local v156 = p2:New("UICorner")({
        CornerRadius = UDim.new(0, 12)
    })
    local v157 = p2:New("UIPadding")({})
    local v158 = p2:New("UIStroke")({
        Transparency = 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Theme.Color.NeutralStroke
    })
    local v159 = p2:New("UIListLayout")({
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v160 = p2:New("Frame")({
        Name = "HintOverlay",
        BackgroundTransparency = 1,
        LayoutOrder = 999,
        ZIndex = 60,
        Size = UDim2.new(1, 0, 0, 0)
    })

    HintBubble.registerHost(v160)

    local v166 = TitleBar(p2, {
        title = v90,
        showLogo = v99,
        showBeta = v101,
        onBeta = function() -- onBeta | line: 1111
            -- upvalues: v85 (copy), Fusion (copy)
            v85:set(not Fusion.peek(v85))
        end,
        canGoBack = v54.canGoBack,
        onBack = function() -- onBack | line: 1115
            -- upvalues: v54 (copy), v63 (copy), Fusion (copy)
            if Fusion.peek(v54.page) == "RoleSettings" and Fusion.peek(v63) ~= "" then
                v63:set("")
            end

            v54:goBack()
        end,
        onClose = p3.onClose,
        onDrag = function(p67) -- onDrag | line: 1123
            -- upvalues: clampDragOffset (copy), v124 (copy), Fusion (copy), Viewport (copy)
            local v162 = Fusion.peek(v124)
            local v163 = Fusion.peek(Viewport.MenuDefaultPosition)
            local v164 = Fusion.peek(Viewport.ViewportSize)
            local v165 = Fusion.peek(Viewport.Scale)

            v124:set(clampDragOffset(v162 + p67, v163, v164, v165))
        end
    })
    local v167 = PreviewBanner(p2, {
        layoutOrder = 1
    })
    local v161 = UpdateBanner(p2, {
        layoutOrder = 2,
        pageVisible = v5,
        visibleValue = v143,
        onView = function() -- onView | line: 1141
            -- upvalues: v85 (copy)
            v85:set(true)
        end
    })
    local Frame2 = p2:New("Frame")
    local t19 = {
        Name = "Content",
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        LayoutOrder = 3
    }

    t19.Size = p2:Computed(function(p68) -- line: 1151
        -- upvalues: v147 (copy)
        return UDim2.fromOffset(0, p68(v147))
    end)
    t19[Children] = {
        p2:New("Frame")({
            Name = "PaddingFrame",
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            [Children] = { p2:ForValues(v55, buildPageSlide) }
        }),
        p2:New("Frame")({
            Name = "UpdateLogOverlay",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 10,
            [Children] = {
                p2:New("UIPadding")({
                    PaddingBottom = UDim.new(0, 20),
                    PaddingLeft = UDim.new(0, 14),
                    PaddingRight = UDim.new(0, 14),
                    PaddingTop = UDim.new(0, 14)
                }),
                UpdateLogPopup(p2, {
                    visible = v85
                })
            }
        }),
        p2:New("TextButton")({
            Name = "Expander",
            AnchorPoint = Vector2.new(0.5, 1),
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.new(1, 0, 0, 20),
            Text = "",
            TextColor3 = Color3.new(),
            TextSize = 14,
            [Children] = {
                p2:New("UIDragDetector")({
                    Name = "UIDragDetector",
                    DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
                    ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
                    [Fusion.OnEvent("DragStart")] = function(p69) -- line: 1205
                        -- upvalues: v137 (copy), v139 (copy), v140 (copy), n1 (ref), n2 (ref), v152 (ref), Fusion (copy)
                        n1 = p69.Y
                        n2 = Fusion.peek(v137)
                        v139:set(n2)
                        v152 = false
                        v140:set(true)
                    end,
                    [Fusion.OnEvent("DragContinue")] = function(p70) -- line: 1213
                        -- upvalues: v124 (copy), v136 (copy), v139 (copy), n1 (ref), n2 (ref), v152 (ref), Fusion (copy), Viewport (copy)
                        local v171 = p70.Y - n1
                        local v172 = Fusion.peek(Viewport.MenuDefaultPosition)
                        local v173 = Fusion.peek(Viewport.ViewportSize)
                        local v174 = Fusion.peek(Viewport.Scale)
                        local v175 = Fusion.peek(v124)
                        local v176 = v172.Y.Scale * v173.Y + v172.Y.Offset + v175.Y
                        local v177 = (v173.Y - v176 - 38 * v174 - Viewport.MinScreenEdgeGap) / v174
                        local v180 = math.min(Fusion.peek(Viewport.DragMaxHeight), (math.floor(v177)))
                        local v183 = math.round((math.clamp(n2 + v171, 120, v180)))

                        v139:set(v183)
                        v136:set(v183)
                        v152 = true
                    end,
                    [Fusion.OnEvent("DragEnd")] = function() -- line: 1228
                        -- upvalues: v136 (copy), v140 (copy), v152 (ref)
                        v140:set(false)

                        if not v152 then
                            v136:set(nil)
                        end
                    end
                }),
                p2:New("Frame")({
                    Name = "Bar1",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(61, 61, 63),
                    BackgroundTransparency = 0.5,
                    Position = UDim2.new(0.5, 0, 0.51, -2),
                    Size = UDim2.new(0.3, 0, 0, 4),
                    [Children] = { p2:New("UICorner")({}) }
                })
            }
        })
    }
    t18[Children] = {
        v156,
        v157,
        v158,
        v159,
        v160,
        v166,
        v167,
        v161,
        Frame2(t19)
    }
    v153[Children] = {
        v154,
        v155,
        CanvasGroup(t18)
    }

    local v184 = Frame(v153)

    LayerOrder.attach("MainPanel", v184)
    Navigate.register({
        navigateTo = navigateTo,
        goBack = function() -- goBack | line: 1260
            -- upvalues: v54 (copy)
            v54:goBack()
        end,
        currentPage = function() -- currentPage | line: 1261
            -- upvalues: v54 (copy), Fusion (copy)
            return Fusion.peek(v54.page)
        end,
        pageHistory = function() -- pageHistory | line: 1262
            -- upvalues: v54 (copy), Fusion (copy)
            return Fusion.peek(v54.pageHistory)
        end,
        panelRoot = function() -- panelRoot | line: 1263
            -- upvalues: v184 (copy)
            return v184
        end
    })

    return v184
end
