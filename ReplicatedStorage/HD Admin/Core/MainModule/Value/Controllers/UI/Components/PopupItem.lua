-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local UI = Modules.Parent.Controllers.UI
local Icons = require(UI.Config.Icons)
local t1 = {
    info = "Info",
    success = "Success",
    warn = "Warning",
    error = "Error",
    alert = "Warning"
}
local t2 = {
    info = Icons.LogoGlyph,
    success = Icons.CheckMarkFill,
    warn = Icons.WarningFill,
    error = Icons.ProhibitedFill,
    alert = Icons.WarningFill
}
local t3 = {
    info = "Info",
    success = "Success",
    warn = "Warning",
    error = "Error",
    alert = "Alert"
}
local t4 = {
    success = true,
    warn = true,
    error = true
}
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Packages = Modules.Parent.Packages
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Navigate = require(UI.Util.Navigate)
local Pressable = require(UI.Components.Pressable)
local FavouriteButton = require(UI.Components.FavouriteButton)
local UnlockButton = require(UI.Components.UnlockButton)
local EmotePreview = require(UI.Config.EmotePreview)
local Viewport = require(UI.Config.Viewport)
local Platform = require(UI.Util.Platform)
local RoleBadge = require(UI.Components.RoleBadge)
local LoadingSpinner = require(UI.Components.LoadingSpinner)
local VoteBody = require(UI.Components.VoteBody)
local InputObjects = require(UI.Config.InputObjects)
local Popups = require(UI.Util.Popups)
local popupLifecycle = require(UI.Util.popupLifecycle)
local registerSound = require(Modules.AssetUtil.registerSound)
local promptSetFavoriteAsync = require(Modules.AssetUtil.promptSetFavoriteAsync)
local fuseState = require(Modules.DataUtil.fuseState)
local Children, Out = Fusion.Children, Fusion.Out
local Sound, Sound2

local function clampWidth(p1, p2, p3) -- line: 90
    -- upvalues: Viewport (copy)
    return p1:Computed(function(p4) -- line: 91
        -- upvalues: p2 (copy), p3 (copy), Viewport (copy)
        local v1 = if p3 == nil then 1 else p4(p3)

        return (math.min(p2, (p4(Viewport.ViewportSize).X - 32) / v1))
    end)
end

local function ensureSoundsFolder() -- line: 98
    -- upvalues: SoundService (copy)
    local HDNoticeSounds = SoundService:FindFirstChild("HDNoticeSounds")

    if HDNoticeSounds then
        return HDNoticeSounds
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "HDNoticeSounds"
    Folder.Parent = SoundService

    return Folder
end

local function getNoticeSound() -- line: 107
    -- upvalues: SoundService (copy), registerSound (copy), Sound (ref)
    if Sound then
        return Sound
    end

    local Sound2 = Instance.new("Sound")

    Sound2.Name = "Notice"
    Sound2.SoundId = "rbxassetid://2865227271"
    Sound2.Volume = 0.5

    local HDNoticeSounds = SoundService:FindFirstChild("HDNoticeSounds")

    if not HDNoticeSounds then
        HDNoticeSounds = Instance.new("Folder")
        HDNoticeSounds.Name = "HDNoticeSounds"
        HDNoticeSounds.Parent = SoundService
    end

    Sound2.Parent = HDNoticeSounds
    registerSound(Sound2, "Interface")
    Sound = Sound2

    return Sound2
end

local function getWarnSound() -- line: 119
    -- upvalues: SoundService (copy), registerSound (copy), Sound2 (ref)
    if Sound2 then
        return Sound2
    end

    local Sound = Instance.new("Sound")

    Sound.Name = "Warn"
    Sound.SoundId = "rbxassetid://2865228021"
    Sound.Volume = 0.5

    local HDNoticeSounds = SoundService:FindFirstChild("HDNoticeSounds")

    if not HDNoticeSounds then
        HDNoticeSounds = Instance.new("Folder")
        HDNoticeSounds.Name = "HDNoticeSounds"
        HDNoticeSounds.Parent = SoundService
    end

    Sound.Parent = HDNoticeSounds
    registerSound(Sound, "Interface")
    Sound2 = Sound

    return Sound
end

local function playSoundForKind(p5) -- line: 131
    -- upvalues: SoundService (copy), registerSound (copy), Sound (ref), Sound2 (ref)
    local Sound3

    if p5 == "warn" or p5 == "error" then
        if Sound2 then
            Sound3 = Sound2
        else
            Sound3 = Instance.new("Sound")
            Sound3.Name = "Warn"
            Sound3.SoundId = "rbxassetid://2865228021"
            Sound3.Volume = 0.5

            local HDNoticeSounds = SoundService:FindFirstChild("HDNoticeSounds")

            if not HDNoticeSounds then
                HDNoticeSounds = Instance.new("Folder")
                HDNoticeSounds.Name = "HDNoticeSounds"
                HDNoticeSounds.Parent = SoundService
            end

            Sound3.Parent = HDNoticeSounds
            registerSound(Sound3, "Interface")
            Sound2 = Sound3
        end
    elseif Sound then
        Sound3 = Sound
    else
        Sound3 = Instance.new("Sound")
        Sound3.Name = "Notice"
        Sound3.SoundId = "rbxassetid://2865227271"
        Sound3.Volume = 0.5

        local HDNoticeSounds = SoundService:FindFirstChild("HDNoticeSounds")

        if not HDNoticeSounds then
            HDNoticeSounds = Instance.new("Folder")
            HDNoticeSounds.Name = "HDNoticeSounds"
            HDNoticeSounds.Parent = SoundService
        end

        Sound3.Parent = HDNoticeSounds
        registerSound(Sound3, "Interface")
        Sound = Sound3
    end

    Sound3:Play()
end

local function makeAlertSound() -- line: 139
    -- upvalues: SoundService (copy), registerSound (copy)
    local Sound = Instance.new("Sound")

    Sound.Name = "Alert"
    Sound.SoundId = "rbxassetid://6176997734"
    Sound.Looped = true
    Sound.Volume = 0.5

    local HDNoticeSounds = SoundService:FindFirstChild("HDNoticeSounds")

    if not HDNoticeSounds then
        HDNoticeSounds = Instance.new("Folder")
        HDNoticeSounds.Name = "HDNoticeSounds"
        HDNoticeSounds.Parent = SoundService
    end

    Sound.Parent = HDNoticeSounds
    registerSound(Sound, "Interface")

    return Sound
end

local function makeAvatar(p6, p7, p8, p9) -- line: 150
    -- upvalues: Theme (copy), Children (copy)
    local v3 = if typeof(p7) == "number" then ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(p7) else ""

    return p6:New("ImageLabel")({
        Name = "Avatar",
        BackgroundColor3 = Theme.Color.NeutralContent,
        Image = v3,
        LayoutOrder = p9,
        Size = UDim2.fromOffset(p8, p8),
        [Children] = {
            p6:New("UICorner")({
                CornerRadius = UDim.new(1, 0)
            })
        }
    })
end

local function makeServerGlyph(p10, p11, p12) -- line: 167
    -- upvalues: Icons (copy), Theme (copy)
    return p10:New("ImageLabel")({
        Name = "ServerIcon",
        BackgroundTransparency = 1,
        Image = Icons.ServerGlyph,
        ImageColor3 = Theme.Color.BaseContent,
        LayoutOrder = p12,
        Size = UDim2.fromOffset(p11, p11)
    })
end

local function makeIconButton(p13, p14, p15, p16, p17, p18, p19, p20) -- line: 178
    -- upvalues: Theme (copy), Pressable (copy), Platform (copy), Children (copy)
    local v4 = p13:Value(false)
    local v5 = p13:Value(false)
    local v6 = p13:Computed(function(p21) -- line: 181
        -- upvalues: v4 (copy), v5 (copy)
        if p21(v5) then
            return 0.65
        end

        if p21(v4) then
            return 0.82
        end

        return 1
    end)

    if not Platform.isMobile then
        v6 = p13:Spring(v6, 70, 1)
    end

    return Pressable(p13, {
        name = p14,
        layoutOrder = p17,
        size = UDim2.fromOffset(28, 28),
        backgroundColor = nil,
        iconImage = p15,
        iconColor = p19 or Theme.Color.NeutralContentDark,
        iconSize = p20 or 18,
        visible = p18,
        onActivate = p16,
        onHoverChanged = function(p22) -- onHoverChanged | line: 199
            -- upvalues: v4 (copy)
            v4:set(p22)
        end,
        onPressChanged = function(p23) -- onPressChanged | line: 200
            -- upvalues: v5 (copy)
            v5:set(p23)
        end,
        [Children] = {
            p13:New("Frame")({
                Name = "Halo",
                BackgroundColor3 = Theme.Color.NeutralContent,
                BackgroundTransparency = v6,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 0,
                [Children] = {
                    p13:New("UICorner")({
                        CornerRadius = UDim.new(1, 0)
                    })
                }
            })
        }
    })
end

local function makeMuteButton(p24, p25, p26, p27, p28) -- line: 219
    -- upvalues: Icons (copy), RunService (copy), Fusion (copy), Theme (copy), makeIconButton (copy)
    local v7 = math.random() * 3.141592653589793 * 2
    local v8 = p24:Value(0)
    local connection = RunService.Heartbeat:Connect(function() -- line: 223
        -- upvalues: p25 (copy), v7 (copy), v8 (copy), Fusion (copy)
        if not Fusion.peek(p25) then
            v8:set((math.sin(os.clock() * 4.5 + v7) + 1) / 2)
        end
    end)

    table.insert(p24, function() -- line: 227
        -- upvalues: connection (copy)
        connection:Disconnect()
    end)

    local v11 = p24:Spring(p24:Computed(function(p29) -- line: 228
        -- upvalues: p25 (copy)
        if p29(p25) then
            return 0
        end

        return 1
    end), 16, 1)
    local v12 = p24:Computed(function(p30) -- line: 231
        -- upvalues: v8 (copy), v11 (copy)
        return p30(v8) * p30(v11)
    end)
    local v13 = p24:Computed(function(p31) -- line: 234
        -- upvalues: p25 (copy), Icons (copy)
        if p31(p25) then
            return Icons.VolumeOff
        end

        return Icons.VolumeOn
    end)
    local v14 = p24:Computed(function(p32) -- line: 237
        -- upvalues: v12 (copy)
        return 18 + 4 * p32(v12)
    end)

    return makeIconButton(p24, "MuteButton", v13, p26, p27, nil, p24:Computed(function(p33) -- line: 240
        -- upvalues: p28 (copy), v12 (copy), Theme (copy)
        return p33(Theme.Color.NeutralContentDark):Lerp(p33(p28), p33(v12) * 0.7)
    end), v14)
end

local function makeProgressFill(p34, p35, p36) -- line: 246
    return p34:New("Frame")({
        Name = "Fill",
        BorderSizePixel = 0,
        BackgroundColor3 = p36,
        Size = p34:Computed(function(p37) -- line: 251
            -- upvalues: p35 (copy)
            return UDim2.new(p37(p35), 0, 1, 0)
        end)
    })
end

local function escapeRich(p38) -- line: 257
    return (p38:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function makeActionButton(p39, p40, p41, p42, p43, p44) -- line: 264
    -- upvalues: Fusion (copy), Theme (copy), Pressable (copy), LoadingSpinner (copy), Children (copy)
    local v16 = if p43 then Theme.Color.NeutralStroke else Theme.Color.Primary
    local v17 = if p43 then Theme.Color.BaseContent else Theme.Color.PrimaryContent
    local v18 = p42 or p39:Value(false)
    local v19 = p39:Value(false)
    local n1 = 0

    local function handleClick() -- line: 270
        -- upvalues: p41 (copy), p42 (copy), p44 (copy), v19 (copy), n1 (ref), v18 (copy), Fusion (copy)
        if Fusion.peek(v18) then
            return
        end

        if not p44 or Fusion.peek(v19) then
            if p44 then
                n1 += 1
                v19:set(false)
            end

            if p42 then
                v18:set(true)
            end

            p41()
        else
            n1 += 1

            local v20 = n1

            v19:set(true)
            task.delay(2, function() -- line: 276
                -- upvalues: v20 (copy), v19 (copy), n1 (ref)
                if n1 == v20 then
                    v19:set(false)
                end
            end)
        end
    end

    local v21 = if p44 then p39:Computed(function(p45) -- line: 294
        -- upvalues: p40 (copy), v19 (copy)
        if p45(v19) then
            return "Confirm?"
        end

        if typeof(p40) == "table" then
            return (p45(p40))
        end

        return p40
    end) else p40
    local v22 = p39:Computed(function(p46) -- line: 301
        -- upvalues: v18 (copy)
        return not p46(v18)
    end)
    local v23 = LoadingSpinner(p39, {
        size = 11,
        thickness = 2,
        paddingY = 0,
        color = v17,
        visible = v18
    })

    v23.AnchorPoint = Vector2.new(0.5, 0.5)
    v23.Position = UDim2.fromScale(0.5, 0.5)

    return Pressable(p39, {
        name = "ActionButton",
        backgroundColor = v16,
        size = UDim2.new(0, 0, 0, 30),
        automaticSize = Enum.AutomaticSize.None,
        onActivate = handleClick,
        interactable = p39:Computed(function(p47) -- line: 318
            -- upvalues: v18 (copy)
            return not p47(v18)
        end),
        [Children] = {
            p39:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p39:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }),
            p39:New("TextLabel")({
                Name = "Label",
                BackgroundTransparency = 1,
                FontFace = p39:Computed(function(p48) -- line: 326
                    -- upvalues: Theme (copy)
                    return Font.new(p48(Theme.Font.Body), Enum.FontWeight.Bold)
                end),
                Size = UDim2.fromScale(1, 1),
                Text = v21,
                TextColor3 = v17,
                TextSize = Theme.TextSize.Body,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                Visible = v22
            }),
            v23
        }
    })
end

local function makeToggleButton(p49, p50, p51) -- line: 342
    -- upvalues: Icons (copy), Fusion (copy), Theme (copy), Pressable (copy), LoadingSpinner (copy), Children (copy)
    local v24 = p49:Value(false)
    local n2 = 0

    p49:Observer(p50):onChange(function() -- line: 346
        -- upvalues: v24 (copy), n2 (ref)
        local v25 = os.clock() - n2

        if v25 >= 0.5 then
            v24:set(false)
        else
            task.delay(0.5 - v25, function() -- line: 351
                -- upvalues: v24 (copy)
                v24:set(false)
            end)
        end
    end)

    local function handlePress() -- line: 356
        -- upvalues: p51 (copy), v24 (copy), n2 (ref), Fusion (copy)
        if Fusion.peek(v24) then
            return
        end

        n2 = os.clock()
        v24:set(true)
        task.delay(30, function() -- line: 361
            -- upvalues: v24 (copy)
            v24:set(false)
        end)
        p51()
    end

    local v26 = p49:Computed(function(p52) -- line: 366
        -- upvalues: p50 (copy)
        return p52(p50) == "active"
    end)
    local v27 = p49:Value(Fusion.peek(v26))

    local function syncDisplay() -- line: 371
        -- upvalues: v24 (copy), v26 (copy), v27 (copy), Fusion (copy)
        if not Fusion.peek(v24) then
            v27:set(Fusion.peek(v26))
        end
    end

    p49:Observer(v24):onChange(syncDisplay)
    p49:Observer(p50):onChange(syncDisplay)

    local v28 = p49:Computed(function(p53) -- line: 378
        -- upvalues: v27 (copy), Icons (copy)
        if p53(v27) then
            return Icons.ZapFill
        end

        return Icons.Zap
    end)
    local v29 = p49:Computed(function(p54) -- line: 381
        -- upvalues: v27 (copy), Theme (copy)
        if p54(v27) then
            return (p54(Theme.Color.Primary))
        end

        return (p54(Theme.Color.BaseContent))
    end)
    local v30 = p49:Computed(function(p55) -- line: 384
        -- upvalues: v27 (copy), Theme (copy)
        if p55(v27) then
            return (p55(Theme.Color.BaseContent))
        end

        return (p55(Theme.Color.PrimaryContent))
    end)
    local v31 = p49:Computed(function(p56) -- line: 387
        -- upvalues: v27 (copy), Theme (copy)
        if p56(v27) then
            return (p56(Theme.Color.NeutralStroke))
        end

        return (p56(Theme.Color.Primary))
    end)
    local v32 = p49:Computed(function(p57) -- line: 390
        -- upvalues: v24 (copy)
        return not p57(v24)
    end)
    local v33 = LoadingSpinner(p49, {
        size = 11,
        thickness = 2,
        paddingY = 0,
        color = Theme.Color.BaseContent,
        visible = v24
    })

    v33.AnchorPoint = Vector2.new(0.5, 0.5)
    v33.Position = UDim2.fromScale(0.5, 0.5)

    return Pressable(p49, {
        name = "ToggleButton",
        backgroundColor = v31,
        size = UDim2.new(0, 0, 0, 30),
        automaticSize = Enum.AutomaticSize.None,
        onActivate = handlePress,
        interactable = p49:Computed(function(p58) -- line: 409
            -- upvalues: v24 (copy)
            return not p58(v24)
        end),
        [Children] = {
            p49:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p49:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }),
            p49:New("Frame")({
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = v32,
                [Children] = {
                    p49:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 6),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p49:New("ImageLabel")({
                        Name = "Glyph",
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                        Image = v28,
                        ImageColor3 = v29,
                        Size = UDim2.fromOffset(16, 16)
                    }),
                    p49:New("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,
                        AutomaticSize = Enum.AutomaticSize.X,
                        FontFace = p49:Computed(function(p59) -- line: 440
                            -- upvalues: Theme (copy)
                            return Font.new(p59(Theme.Font.Body), Enum.FontWeight.Bold)
                        end),
                        Size = UDim2.fromOffset(0, 16),
                        Text = p49:Computed(function(p60) -- line: 445
                            -- upvalues: v27 (copy)
                            if p60(v27) then
                                return "Deactivate"
                            end

                            return "Activate"
                        end),
                        TextColor3 = v30,
                        TextSize = Theme.TextSize.Body,
                        TextYAlignment = Enum.TextYAlignment.Center
                    })
                }
            }),
            v33
        }
    })
end

local function makeStopButton(p61, p62) -- line: 459
    -- upvalues: Icons (copy), Theme (copy), Pressable (copy), Children (copy)
    return Pressable(p61, {
        name = "StopButton",
        backgroundColor = Theme.Color.NeutralStroke,
        size = UDim2.fromOffset(30, 30),
        automaticSize = Enum.AutomaticSize.None,
        onActivate = p62,
        iconImage = Icons.StopFill,
        iconColor = Theme.Color.BaseContent,
        iconSize = 14,
        [Children] = {
            p61:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.None
            }),
            p61:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            })
        }
    })
end

local function makeRerunButton(p63, p64) -- line: 478
    -- upvalues: Icons (copy), Fusion (copy), Theme (copy), Pressable (copy), LoadingSpinner (copy), Children (copy)
    local v38 = p63:Value(false)

    local function handlePress() -- line: 480
        -- upvalues: p64 (copy), v38 (copy), Fusion (copy)
        if Fusion.peek(v38) then
            return
        end

        v38:set(true)
        task.delay(0.4, function() -- line: 483
            -- upvalues: v38 (copy)
            v38:set(false)
        end)
        p64()
    end

    local v39 = p63:Computed(function(p65) -- line: 486
        -- upvalues: v38 (copy)
        return not p65(v38)
    end)
    local v40 = LoadingSpinner(p63, {
        size = 11,
        thickness = 2,
        paddingY = 0,
        color = Theme.Color.BaseContent,
        visible = v38
    })

    v40.AnchorPoint = Vector2.new(0.5, 0.5)
    v40.Position = UDim2.fromScale(0.5, 0.5)

    return Pressable(p63, {
        name = "RerunButton",
        backgroundColor = Theme.Color.NeutralStroke,
        size = UDim2.new(0, 0, 0, 30),
        automaticSize = Enum.AutomaticSize.None,
        onActivate = handlePress,
        interactable = p63:Computed(function(p66) -- line: 503
            -- upvalues: v38 (copy)
            return not p66(v38)
        end),
        [Children] = {
            p63:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p63:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }),
            p63:New("Frame")({
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = v39,
                [Children] = {
                    p63:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 6),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }),
                    p63:New("ImageLabel")({
                        Name = "Glyph",
                        BackgroundTransparency = 1,
                        LayoutOrder = 1,
                        Image = Icons.Rerun,
                        ImageColor3 = Theme.Color.Primary,
                        Size = UDim2.fromOffset(16, 16)
                    }),
                    p63:New("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,
                        Text = "Re-run",
                        AutomaticSize = Enum.AutomaticSize.X,
                        FontFace = p63:Computed(function(p67) -- line: 534
                            -- upvalues: Theme (copy)
                            return Font.new(p67(Theme.Font.Body), Enum.FontWeight.Bold)
                        end),
                        Size = UDim2.fromOffset(0, 16),
                        TextColor3 = Theme.Color.BaseContent,
                        TextSize = Theme.TextSize.Body,
                        TextYAlignment = Enum.TextYAlignment.Center
                    })
                }
            }),
            v40
        }
    })
end

local function makeFooterButton(p68, p69, p70, p71, p72, p73, p74, p75, p76) -- line: 552
    -- upvalues: Fusion (copy), Theme (copy), Pressable (copy), LoadingSpinner (copy), Children (copy)
    local v41 = if p71 then Theme.Color.NeutralStroke else Theme.Color.Primary
    local v42 = if p71 then Theme.Color.BaseContent else Theme.Color.PrimaryContent
    local v43 = if p71 then Theme.Color.Primary else Theme.Color.PrimaryContent
    local v44 = p68:Value(false)

    local function handleClick() -- line: 557
        -- upvalues: p72 (copy), p74 (copy), p76 (copy), v44 (copy), Fusion (copy)
        if not Fusion.peek(v44) then
            v44:set(true)
            task.spawn(function() -- line: 560
                -- upvalues: p72 (copy), p74 (copy), p76 (copy), v44 (copy)
                pcall(p72)
                v44:set(false)

                if p76 then
                    p74:set(false)
                end
            end)
        end
    end

    local v45 = p68:Computed(function(p77) -- line: 568
        -- upvalues: v44 (copy)
        return not p77(v44)
    end)
    local v46 = LoadingSpinner(p68, {
        size = 11,
        thickness = 2,
        paddingY = 0,
        color = v42,
        visible = v44
    })

    v46.AnchorPoint = Vector2.new(0.5, 0.5)
    v46.Position = UDim2.fromScale(0.5, 0.5)

    return (Pressable(p68, {
        name = "FooterButton",
        backgroundColor = v41,
        size = UDim2.new(0, 0, 0, p75 and 30 or 26),
        automaticSize = Enum.AutomaticSize.None,
        layoutOrder = p73,
        visible = p74,
        onActivate = handleClick,
        interactable = v45,
        [Children] = {
            p68:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p68:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.Fill
            }),
            p68:New("Frame")({
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = v45,
                [Children] = {
                    p68:New("UIListLayout")({
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        HorizontalFlex = Enum.UIFlexAlignment.None,
                        VerticalFlex = Enum.UIFlexAlignment.None,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 6)
                    }),
                    p68:Computed(function(_, p79) -- line: 608
                        -- upvalues: p70 (copy), v43 (copy)
                        if p70 == nil then
                            return nil
                        end

                        return p79:New("ImageLabel")({
                            Name = "Icon",
                            BackgroundTransparency = 1,
                            LayoutOrder = 1,
                            Size = UDim2.fromOffset(16, 16),
                            Image = p70,
                            ImageColor3 = v43
                        })
                    end),
                    p68:New("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        LayoutOrder = 2,
                        AutomaticSize = Enum.AutomaticSize.X,
                        FontFace = p68:Computed(function(p80) -- line: 623
                            -- upvalues: Theme (copy)
                            return Font.new(p80(Theme.Font.Body), Enum.FontWeight.Bold)
                        end),
                        Size = UDim2.fromOffset(0, p75 and 18 or 15),
                        Text = p69,
                        TextColor3 = v42,
                        TextSize = if p75 then Theme.TextSize.Body else 15,
                        TextYAlignment = Enum.TextYAlignment.Center
                    })
                }
            }),
            v46
        }
    }))
end

local function makeEquipButton(p81, p82, p83, p84) -- line: 640
    -- upvalues: Fusion (copy), Theme (copy), Pressable (copy), LoadingSpinner (copy), Children (copy)
    local v52 = p81:Value(false)
    local v53 = p81:Computed(function(p85) -- line: 642
        -- upvalues: v52 (copy)
        return not p85(v52)
    end)

    local function handlePress() -- line: 645
        -- upvalues: p83 (copy), p84 (copy), v52 (copy), Fusion (copy)
        if Fusion.peek(v52) then
            return
        end

        v52:set(true)

        local v54 = p84 ~= nil and Fusion.peek(p84) == true

        if p84 and not v54 then
            p84:set(true)
        end

        task.spawn(function() -- line: 653
            -- upvalues: v54 (copy), p83 (copy), p84 (copy), v52 (copy)
            p83()
            v52:set(false)

            if p84 and not v54 then
                p84:set(false)
            end
        end)
    end

    local v55 = LoadingSpinner(p81, {
        size = 14,
        thickness = 2,
        paddingY = 0,
        color = Theme.Color.PrimaryContent,
        visible = v52
    })

    v55.AnchorPoint = Vector2.new(0.5, 0.5)
    v55.Position = UDim2.fromScale(0.5, 0.5)

    return Pressable(p81, {
        name = "EquipButton",
        backgroundColor = Theme.Color.Primary,
        size = UDim2.new(1, 0, 0, 32),
        automaticSize = Enum.AutomaticSize.None,
        onActivate = handlePress,
        interactable = v53,
        [Children] = {
            p81:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p81:New("TextLabel")({
                Name = "Label",
                BackgroundTransparency = 1,
                FontFace = p81:Computed(function(p86) -- line: 684
                    -- upvalues: Theme (copy)
                    return Font.new(p86(Theme.Font.Body), Enum.FontWeight.Bold)
                end),
                Size = UDim2.fromScale(1, 1),
                Text = p82,
                TextColor3 = Theme.Color.PrimaryContent,
                TextSize = Theme.TextSize.Body,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                Visible = v53
            }),
            v55
        }
    })
end

local function makeActionBody(p87, p88) -- line: 700
    -- upvalues: Fusion (copy), Theme (copy), FavouriteButton (copy), UnlockButton (copy), EmotePreview (copy), InputObjects (copy), promptSetFavoriteAsync (copy), fuseState (copy), Children (copy), makeActionButton (copy), makeToggleButton (copy), makeStopButton (copy), makeRerunButton (copy)
    local v56 = p88.options or {}
    local onAction = v56.onAction
    local t16 = {}

    if p88.text and p88.text ~= "" then
        table.insert(t16, p87:New("TextLabel")({
            Name = "ActionText",
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            FontFace = p87:Computed(function(p89) -- line: 710
                -- upvalues: Theme (copy)
                return Font.new(p89(Theme.Font.Body), Enum.FontWeight.Medium)
            end),
            Size = UDim2.new(1, 0, 0, 0),
            Text = p88.text,
            TextColor3 = Theme.Color.NeutralContentMain,
            TextSize = Theme.TextSize.Body,
            TextXAlignment = Enum.TextXAlignment.Left
        }))
    end

    local controlValuesState = v56.controlValuesState

    for v57, v58 in v56.controls or {} do
        local v59 = InputObjects.items[v58.inputType]

        if v59 then
            local v60 = p87:Value(v58.value)
            local v61 = false
            local v62

            p87:Observer(v60):onChange(function() -- line: 730
                -- upvalues: onAction (copy), v58 (copy), v60 (copy), v61 (ref), v62 (ref), Fusion (copy)
                local v64 = Fusion.peek(v60)

                if v62 == nil or v64 ~= v62 then
                    if not v61 then
                        v61 = true
                        task.delay(0.1, function() -- line: 738
                            -- upvalues: onAction (copy), v58 (copy), v60 (copy), v61 (ref), Fusion (copy)
                            v61 = false

                            if onAction then
                                onAction("control", v58.id, Fusion.peek(v60))
                            end
                        end)
                    end
                else
                    v62 = nil
                end
            end)

            if controlValuesState then
                p87:Observer(controlValuesState):onChange(function() -- line: 746
                    -- upvalues: controlValuesState (copy), v58 (copy), v60 (copy), v62 (ref), Fusion (copy)
                    local v66 = Fusion.peek(controlValuesState)
                    local v67 = if typeof(v66) == "table" then v66[v58.id] else nil

                    if v67 ~= nil and v67 ~= Fusion.peek(v60) then
                        v62 = v67
                        v60:set(v67)
                    end
                end)
            end

            local v68 = table.clone(v58.config or {})

            v68.value = v60
            v68.title = v58.label or v68.title

            local v69 = v59(p87, v68)

            v69.LayoutOrder = 1 + v57
            table.insert(t16, v69)
        end
    end

    local iconButtonsState = v56.iconButtonsState

    local function currentIcon(p90, p91) -- line: 764
        -- upvalues: iconButtonsState (copy), Fusion (copy)
        local v70 = iconButtonsState and Fusion.peek(iconButtonsState)

        return v70 and v70[p90] or p91
    end

    local t18 = {}

    for v71, v72 in v56.iconButtons or {} do
        if v72.component == "Favourite" then
            local v73 = p87:Value(v72.active == true)
            local v74 = p87:Value(false)
            local FavoritedEmotes = fuseState(p87, "perm", "FavoritedEmotes")

            local function syncActive() -- line: 774
                -- upvalues: iconButtonsState (copy), v72 (copy), v73 (copy), FavoritedEmotes (copy), v71 (copy), Fusion (copy)
                local v75 = v72
                local v76 = iconButtonsState and Fusion.peek(iconButtonsState)
                local v77 = if v76 then v76[v71] else nil

                if v76 and v77 then
                    v75 = v77
                end

                if v75.assetId then
                    local v78 = Fusion.peek(FavoritedEmotes)

                    v73:set(typeof(v78) == "table" and v78[tostring(v75.assetId)] ~= nil)
                elseif typeof(v75.active) == "boolean" then
                    v73:set(v75.active)
                end
            end

            p87:Observer(FavoritedEmotes):onChange(syncActive)

            if iconButtonsState then
                p87:Observer(iconButtonsState):onChange(syncActive)
            end

            table.insert(t18, FavouriteButton(p87, {
                iconSize = 16,
                flexNone = true,
                isFavourited = v73,
                loading = v74,
                layoutOrder = v71,
                onToggle = function() -- onToggle | line: 793
                    -- upvalues: onAction (copy), iconButtonsState (copy), v72 (copy), v73 (copy), v74 (copy), v71 (copy), Fusion (copy), promptSetFavoriteAsync (copy)
                    if Fusion.peek(v74) then
                        return
                    end

                    local v80 = v72
                    local v81 = iconButtonsState and Fusion.peek(iconButtonsState)
                    local v82 = if v81 then v81[v71] else nil

                    if v81 and v82 then
                        v80 = v82
                    end

                    local v83 = not Fusion.peek(v73)

                    if v80.assetId then
                        v74:set(true)

                        local spawn = task.spawn
                        local v84 = v80

                        spawn(function() -- line: 799
                            -- upvalues: v83 (copy), v84 (copy), onAction (copy), v73 (copy), v74 (copy), promptSetFavoriteAsync (copy)
                            if promptSetFavoriteAsync(v84.assetId, v83) then
                                v73:set(v83)

                                if onAction then
                                    onAction("iconButton", v84.id, v83)
                                end
                            end

                            v74:set(false)
                        end)
                    else
                        v73:set(v83)

                        if onAction then
                            onAction("iconButton", v80.id, v83)
                        end
                    end
                end
            }))
        elseif v72.component == "Unlock" then
            table.insert(t18, UnlockButton(p87, {
                layoutOrder = v71,
                size = UDim2.new(1, 0, 0, 30),
                onUnlock = function() -- onUnlock | line: 821
                    -- upvalues: iconButtonsState (copy), v72 (copy), v71 (copy), Fusion (copy), EmotePreview (copy)
                    local v85 = v72
                    local v86 = iconButtonsState and Fusion.peek(iconButtonsState)
                    local v87 = if v86 then v86[v71] else nil

                    if v86 and v87 then
                        v85 = v87
                    end

                    if v85.assetId then
                        EmotePreview.open(v85.assetId, v85.emoteName, v85.animationId)
                    end
                end
            }))
        end
    end

    if #t18 > 0 then
        table.insert(t18, p87:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }))
        table.insert(t16, p87:New("Frame")({
            Name = "IconButtonRow",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 90,
            Size = UDim2.new(1, 0, 0, 0),
            [Children] = t18
        }))
    end

    local t23 = {}

    if not (v56.toggleable and v56.actionState) then
        if v56.rerun then
            table.insert(t23, makeRerunButton(p87, function() -- line: 861
                -- upvalues: onAction (copy)
                if onAction then
                    onAction("rerun", "", nil)
                end
            end))
            table.insert(t23, makeStopButton(p87, function() -- line: 864
                -- upvalues: onAction (copy)
                if onAction then
                    onAction("end", "", nil)
                end
            end))
        end
    else
        local actionState = v56.actionState

        table.insert(t23, makeToggleButton(p87, actionState, function() -- line: 851
            -- upvalues: onAction (copy), actionState (copy), Fusion (copy)
            if onAction then
                onAction(Fusion.peek(actionState) == "active" and "deactivate" or "activate", "", nil)
            end
        end))
        table.insert(t23, makeStopButton(p87, function() -- line: 857
            -- upvalues: onAction (copy)
            if onAction then
                onAction("end", "", nil)
            end
        end))
    end

    for _, v93 in v56.clientButtons or {} do
        table.insert(t23, makeActionButton(p87, v93.label, function() -- line: 869
            -- upvalues: v93 (copy)
            if v93.onActivate then
                v93.onActivate()
            end
        end, nil, v93.style == "Neutral"))
    end

    local buttonLoadingState = v56.buttonLoadingState

    for _, v96 in v56.buttons or {} do
        local id = v96.id
        local v97 = p87:Value(false)

        if buttonLoadingState then
            p87:Observer(buttonLoadingState):onChange(function() -- line: 878
                -- upvalues: buttonLoadingState (copy), id (copy), v97 (copy), Fusion (copy)
                local v98 = Fusion.peek(buttonLoadingState)

                v97:set(typeof(v98) == "table" and v98[id] == true)
            end)
        end

        table.insert(t23, makeActionButton(p87, v96.label, function() -- line: 883
            -- upvalues: onAction (copy), id (copy)
            if onAction then
                onAction("button", id, nil)
            end
        end, v97, v96.style == "Neutral", v96.confirm == true))
    end

    if #t23 > 0 then
        table.insert(t23, p87:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        }))
        table.insert(t16, p87:New("Frame")({
            Name = "ButtonRow",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 100,
            Size = UDim2.new(1, 0, 0, 0),
            [Children] = t23
        }))
    end

    table.insert(t16, p87:New("UIListLayout")({
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }))
    table.insert(t16, p87:New("UIPadding")({
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 14)
    }))

    return p87:New("Frame")({
        Name = "ActionBody",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 0),
        [Children] = t16
    })
end

return function(p92, p93) -- line: 926
    -- upvalues: Icons (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), SoundService (copy), GuiService (copy), UserInputService (copy), Fusion (copy), Theme (copy), Navigate (copy), Viewport (copy), RoleBadge (copy), VoteBody (copy), Popups (copy), popupLifecycle (copy), registerSound (copy), Children (copy), Out (copy), Sound (ref), Sound2 (ref), makeAvatar (copy), makeServerGlyph (copy), makeIconButton (copy), makeMuteButton (copy), makeProgressFill (copy), makeFooterButton (copy), makeEquipButton (copy), makeActionBody (copy)
    local entry = p93.entry
    local options, kind, duration = entry.options, entry.kind, entry.duration
    local v103, onActivate

    if options then
        onActivate = options.onActivate
        v103 = options.fromServer == true
    else
        v103 = false
    end

    local fromUserId = if not options or v103 then nil else options.fromUserId
    local v104 = if v103 then nil
        elseif options and options.fromUserDisplayName and options.fromUserDisplayName ~= "" then options.fromUserDisplayName
        elseif options and options.fromUserName and options.fromUserName ~= "" then options.fromUserName
        else nil
    local fromUserName = if options and not v103 and options.fromUserName and options.fromUserName ~= "" then options.fromUserName else nil
    local fromUserTopRole = if options and not v103 and options.fromUserTopRole and options.fromUserTopRole ~= "" then options.fromUserTopRole else nil
    local fromUserTopRoleColor = if not options or v103 then nil else options.fromUserTopRoleColor
    local title = if options and options.title and options.title ~= "" then options.title else nil
    local v105
    local v106 = false

    if options then
        v105 = options.image

        if typeof(v105) == "string" then
            v106 = options.image ~= ""
        end
    end

    local image = if v106 then options.image else nil
    local v107
    local v108 = false

    if options then
        v107 = options.roleBadges

        if typeof(v107) == "table" then
            v108 = #options.roleBadges > 0
        end
    end

    local roleBadges = if v108 then options.roleBadges else nil
    local v109
    local v110 = false

    if options then
        v109 = options.subtext

        if typeof(v109) == "string" then
            v110 = options.subtext ~= ""
        end
    end

    v105 = if v110 then options.subtext else nil

    local v111
    local v112 = false

    if options then
        v111 = options.footerButtons

        if typeof(v111) == "table" then
            v112 = #options.footerButtons > 0
        end
    end

    v107 = if v112 then options.footerButtons else nil
    v109 = title ~= nil and v104 == nil and not v103

    local v113 = false

    if options then
        v111 = options.keepOpenOnActivate == true
        v113 = options.userText == true
    else
        v111 = false
    end

    local v114 = kind == "action"
    local muteState, v115, onAction, onMute, equip
    local v116 = false

    if options then
        equip = options.equip
        onAction = options.onAction
        muteState = options.muteState
        onMute = options.onMute
        v115 = options.countdown

        if typeof(v115) == "number" then
            v116 = options.countdown >= 1
        end
    end

    local countdown = if v116 then options.countdown else nil
    local v117

    if kind == "privateMessage" then
        v117 = "Private Message"
    elseif kind == "alert" then
        v117 = "Alert"
    elseif kind == "vote" then
        v117 = "Click to view poll"
    elseif kind == "voteResults" then
        v117 = "Poll Results"
    elseif countdown then
        v117 = "Countdown"
    end

    v115 = kind == "vote" or kind == "voteResults"

    local v118 = if t4[kind] then Theme.Color[t1[kind]] else fromUserTopRoleColor or Theme.Color.Primary
    local v119 = false

    table.insert(p92, function() -- line: 971
        -- upvalues: v119 (ref)
        v119 = true
    end)

    local v121

    if entry.channel == "sidebar" and kind == "alert" and muteState then
        local Sound = Instance.new("Sound")

        Sound.Name = "Alert"
        Sound.SoundId = "rbxassetid://6176997734"
        Sound.Looped = true
        Sound.Volume = 0.5

        local HDNoticeSounds = SoundService:FindFirstChild("HDNoticeSounds")

        if not HDNoticeSounds then
            HDNoticeSounds = Instance.new("Folder")
            HDNoticeSounds.Name = "HDNoticeSounds"
            HDNoticeSounds.Parent = SoundService
        end

        Sound.Parent = HDNoticeSounds
        registerSound(Sound, "Interface")

        v121 = function() -- line: 974
            -- upvalues: Sound (copy)
            Sound:Stop()
            Sound:Destroy()
        end

        table.insert(p92, v121)
        HDNoticeSounds = p92:Observer(muteState)

        local muteState2 = muteState

        HDNoticeSounds:onChange(function() -- line: 978
            -- upvalues: Sound (copy), muteState2 (copy), Fusion (copy)
            Sound.Volume = Fusion.peek(muteState2) and 0 or 0.5
        end)
        task.defer(function() -- line: 981
            -- upvalues: v119 (ref), Sound (copy)
            if not v119 then
                Sound:Play()
            end
        end)
    end

    local v122

    if entry.channel == "sidebar" and kind ~= "alert" and not v114 then
        v122 = function() -- line: 988
            -- upvalues: kind (copy), SoundService (copy), registerSound (copy), Sound (ref), Sound2 (ref)
            local Sound3

            if kind == "warn" or kind == "error" then
                if Sound2 then
                    Sound3 = Sound2
                else
                    Sound3 = Instance.new("Sound")
                    Sound3.Name = "Warn"
                    Sound3.SoundId = "rbxassetid://2865228021"
                    Sound3.Volume = 0.5

                    local HDNoticeSounds = SoundService:FindFirstChild("HDNoticeSounds")

                    if not HDNoticeSounds then
                        HDNoticeSounds = Instance.new("Folder")
                        HDNoticeSounds.Name = "HDNoticeSounds"
                        HDNoticeSounds.Parent = SoundService
                    end

                    Sound3.Parent = HDNoticeSounds
                    registerSound(Sound3, "Interface")
                    Sound2 = Sound3
                end
            elseif Sound then
                Sound3 = Sound
            else
                Sound3 = Instance.new("Sound")
                Sound3.Name = "Notice"
                Sound3.SoundId = "rbxassetid://2865227271"
                Sound3.Volume = 0.5

                local HDNoticeSounds = SoundService:FindFirstChild("HDNoticeSounds")

                if not HDNoticeSounds then
                    HDNoticeSounds = Instance.new("Folder")
                    HDNoticeSounds.Name = "HDNoticeSounds"
                    HDNoticeSounds.Parent = SoundService
                end

                Sound3.Parent = HDNoticeSounds
                registerSound(Sound3, "Interface")
                Sound = Sound3
            end

            Sound3:Play()
        end
    end

    local v123 = popupLifecycle(p92, entry, v122)
    local v120 = if countdown then p92:Computed(function(p94) -- line: 993
        -- upvalues: v123 (copy), countdown (copy)
        return (tostring((math.max(math.ceil(p94(v123.progress) * countdown), 1))))
    end) else entry.text
    local icon, CanvasGroup, v127, v128, v129, Frame, v130, v131, v132, v133, v134, v135, togglePause, v136, v137, TextBox, v138, v139, v140, v141, v142, v143

    if entry.channel == "sidebar" then
        v143 = if kind == "info" or v114 then Theme.Color.BaseContent else Theme.Color[t1[kind] or "Info"]

        local v144

        if options then
            icon = options.icon
            v144 = typeof(icon) == "string"
        end

        v121 = if not options or not v144 then nil else options.icon

        if not v121 then
            v121 = if v114 then Icons.Pages.Commands else t2[kind] or Icons.Info
        end

        local v145 = if v103 then "Server" else v104 or title or t3[kind] or "Notice"
        local SidebarScale = Viewport.SidebarScale
        local n3 = 280
        local v146 = p92:Computed(function(p95) -- line: 91
            -- upvalues: SidebarScale (copy), n3 (copy), Viewport (copy)
            local v147 = if SidebarScale == nil then 1 else p95(SidebarScale)

            return (math.min(n3, (p95(Viewport.ViewportSize).X - 32) / v147))
        end)

        v139 = p92:Spring(p92:Computed(function(p96) -- line: 1009
            -- upvalues: v123 (copy), v146 (copy), Viewport (copy), Popups (copy)
            local v149 = p96(v123.offset)
            local v150 = if p96(v123.visible) then -16 else p96(v146) * p96(Viewport.SidebarScale) + 64

            return UDim2.new(1, v150, 1, -(v149 + 16 + p96(Popups.sidebarLift)))
        end), 28, 1)
        CanvasGroup = p92:New("CanvasGroup")
        v127 = {
            Name = "Popup_" .. kind,
            Active = true,
            AnchorPoint = Vector2.new(1, 1),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.Color.Base,
            BackgroundTransparency = 0.05,
            Position = v139,
            ZIndex = p93.zIndex
        }
        v127.Size = p92:Computed(function(p97) -- line: 1025
            -- upvalues: v146 (copy)
            return UDim2.fromOffset(p97(v146), 0)
        end)
        v127[Out("AbsoluteSize")] = entry.size
        v128 = p92:New("UIScale")({
            Scale = Viewport.SidebarScale
        })

        local v151 = p92:New("UICorner")({
            CornerRadius = UDim.new(0, 9)
        })
        local v152 = p92:New("UIStroke")({
            Thickness = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Theme.Color.NeutralStroke
        })
        local onActivate2 = onActivate
        local v153 = v111

        v129 = p92:Computed(function(_, p99) -- line: 1040
            -- upvalues: v123 (copy), onActivate2 (copy), v153 (copy), Fusion (copy), Navigate (copy)
            if onActivate2 == nil then
                return nil
            end

            local function activateCard() -- line: 1042
                -- upvalues: v123 (copy), onActivate2 (copy), v153 (copy)
                if onActivate2 then
                    onActivate2()
                end

                if not v153 then
                    v123.requestDismiss()
                end
            end

            return Navigate.makeActivatable(p99:New("TextButton")({
                Name = "CardButton",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
                Size = UDim2.fromScale(1, 1),
                Text = "",
                TextColor3 = Color3.new(),
                TextSize = 1,
                ZIndex = 0,
                [Fusion.OnEvent("Activated")] = activateCard
            }), activateCard)
        end)
        Frame = p92:New("Frame")
        v130 = {
            Name = "Content",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0)
        }
        v131 = p92:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local v154 = p92:New("Frame")
        local v155 = {
            Name = "TitleBar",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, 42)
        }
        local v156 = p92:New("UIPadding")({
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 8)
        })
        local v157 = p92:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local ImageLabel

        if v103 then
            ImageLabel = makeServerGlyph(p92, 16, 1)
        elseif fromUserId ~= nil then
            ImageLabel = makeAvatar(p92, fromUserId, 24, 1)
        else
            ImageLabel = p92:New("ImageLabel")
            v132 = {
                Name = "TypeIcon",
                BackgroundTransparency = 1,
                Image = v121,
                ImageColor3 = v143,
                LayoutOrder = 1,
                Size = UDim2.fromOffset(16, 16)
            }

            if kind == "info" then
                v134 = {
                    p92:New("UICorner")({
                        CornerRadius = UDim.new(0, 3)
                    })
                }
            end

            v132[Children] = v134
            ImageLabel = ImageLabel(v132)
        end

        v132 = p92:New("TextLabel")({
            Name = "Title",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            FontFace = p92:Computed(function(p100) -- line: 1122
                -- upvalues: Theme (copy)
                return Font.new(p100(Theme.Font.Heading), p100(Theme.FontWeight.Heading))
            end),
            LayoutOrder = 2,
            Size = UDim2.new(0, 0, 0, 0),
            Text = v145,
            TextColor3 = Theme.Color.BaseContent,
            TextSize = Theme.TextSize.Subtitle,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            [Children] = {
                p92:New("UIFlexItem")({
                    FlexMode = Enum.UIFlexMode.Fill
                })
            }
        })
        v133 = p92:Computed(function(_, p102) -- line: 1138
            -- upvalues: v104 (copy), fromUserTopRoleColor (copy), fromUserTopRole (copy), Theme (copy), RoleBadge (copy)
            if v104 == nil or fromUserTopRole == nil then
                return nil
            end

            local v159 = RoleBadge(p102, {
                layoutOrder = 3,
                large = true,
                pillHeight = 25,
                name = fromUserTopRole,
                color = fromUserTopRoleColor or Theme.Color.Primary
            })

            p102:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.None,
                Parent = v159
            })

            return v159
        end)
        v135 = p92:Computed(function(p103) -- line: 1151
            -- upvalues: entry (copy), Icons (copy)
            if p103(entry.paused) then
                return Icons.PlayLarge
            end

            return Icons.PauseLarge
        end)
        togglePause = v123.togglePause
        v136 = duration > 0 and countdown == nil and not v114 and not v115
        v134 = makeIconButton(p92, "PauseButton", v135, togglePause, 5, v136)

        local onMute2 = onMute
        local muteState2 = muteState

        v142 = p92:Computed(function(_, p105) -- line: 1154
            -- upvalues: onMute2 (copy), muteState2 (copy), fromUserTopRoleColor (copy), Theme (copy), makeMuteButton (copy)
            if onMute2 == nil or muteState2 == nil then
                return nil
            end

            return makeMuteButton(p105, muteState2, onMute2, 6, fromUserTopRoleColor or Theme.Color.Primary)
        end)

        local onAction2 = onAction

        v155[Children] = {
            v156,
            v157,
            ImageLabel,
            v132,
            v133,
            v134,
            v142,
            p92:Computed(function(_, p107) -- line: 1158
                -- upvalues: options (copy), v123 (copy), onAction2 (copy), v114 (copy), Icons (copy), makeIconButton (copy)
                if not options or options.dismissable ~= false then
                    return makeIconButton(p107, "CloseButton", Icons.Close, function() -- line: 1160
                        -- upvalues: v123 (copy), onAction2 (copy), v114 (copy)
                        if v114 and onAction2 then
                            onAction2("dismiss", "", nil)
                        end

                        v123.requestDismiss()
                    end, 7)
                end

                return nil
            end)
        }
        v154 = v154(v155)

        if v114 then
            v155 = makeActionBody(p92, entry)
        else
            v137 = not v113

            if v137 then
                v137 = string.find(entry.text, "<b>", 1, true) ~= nil or string.find(entry.text, "<font", 1, true) ~= nil
            end

            v140 = p92:New("UIPadding")
            v141 = {}
            v141.PaddingBottom = UDim.new(0, not (roleBadges == nil and v105 == nil) and 6 or 16)
            v141.PaddingLeft = UDim.new(0, 14)
            v141.PaddingRight = UDim.new(0, 14)
            v140 = v140(v141)
            v141 = p92:Computed(function(p108) -- line: 1182
                -- upvalues: Theme (copy)
                return Font.new(p108(Theme.Font.Body), Enum.FontWeight.Medium)
            end)

            if v117 ~= nil then
                TextBox = p92:New("TextLabel")
                v138 = {
                    Name = "Body",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    FontFace = v141,
                    LayoutOrder = 2,
                    RichText = true,
                    Size = UDim2.new(1, 0, 0, 0)
                }

                local v161 = v120
                local v162 = v115
                local v163 = v117

                v138.Text = p92:Computed(function(p109) -- line: 1194
                    -- upvalues: v161 (copy), v162 (copy), v163 (copy), Theme (copy)
                    local v164 = p109(Theme.Color.NeutralContentMain):Lerp(p109(Theme.Color.Base), 0.35)
                    local v170 = ("rgb(%*,%*,%*)"):format(math.round(v164.R * 255), math.round(v164.G * 255), (math.round(v164.B * 255)))
                    local v171 = p109(v161):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

                    if v162 then
                        v171 = ("\"%*\""):format(v171)
                    end

                    return (("<b><i><font color=\"%*\">%*:</font></i> %*</b>"):format(v170, v163, v171))
                end)
                v138.TextColor3 = Theme.Color.NeutralContentMain
                v138.TextSize = Theme.TextSize.Body
                v138.TextTruncate = Enum.TextTruncate.AtEnd
                v138.TextWrapped = false
                v138.TextXAlignment = Enum.TextXAlignment.Left
                v138[Children] = { v140 }
                v155 = TextBox(v138)
            elseif v137 or UserInputService.TouchEnabled then
                v155 = p92:New("TextLabel")({
                    Name = "Body",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    FontFace = v141,
                    LayoutOrder = 2,
                    RichText = v137,
                    Size = UDim2.new(1, 0, 0, 0),
                    Text = v120,
                    TextColor3 = Theme.Color.NeutralContentMain,
                    TextSize = Theme.TextSize.Body,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    [Children] = { v140 }
                })
            else
                TextBox = p92:New("TextBox")
                v138 = {
                    Name = "Body",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    ClearTextOnFocus = false
                }
                v138.Interactable = onActivate == nil
                v138.FontFace = v141
                v138.LayoutOrder = 2
                v138.MultiLine = true
                v138.Size = UDim2.new(1, 0, 0, 0)
                v138.Text = v120
                v138.TextColor3 = Theme.Color.NeutralContentMain
                v138.TextEditable = false
                v138.TextSize = Theme.TextSize.Body
                v138.TextWrapped = true
                v138.TextXAlignment = Enum.TextXAlignment.Left
                v138[Children] = { v140 }
                v155 = TextBox(v138)
            end
        end

        local v172 = v105
        local v173 = v107

        v140 = p92:Computed(function(_, p111) -- line: 1249
            -- upvalues: v172 (copy), v173 (copy), roleBadges (copy), RoleBadge (copy), Children (copy)
            if roleBadges == nil then
                return nil
            end

            local t31 = {
                p111:New("UIListLayout")({
                    Wraps = true,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.None,
                    VerticalFlex = Enum.UIFlexAlignment.None,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4)
                }),
                p111:New("UIPadding")({
                    PaddingBottom = UDim.new(0, not (v172 == nil and v173 == nil) and 8 or 16),
                    PaddingLeft = UDim.new(0, 14),
                    PaddingRight = UDim.new(0, 14)
                })
            }

            for v175, v176 in roleBadges do
                if typeof(v176) == "table" and typeof(v176.name) == "string" then
                    table.insert(t31, RoleBadge(p111, {
                        name = v176.name,
                        color = if typeof(v176.color) == "Color3" then v176.color else nil,
                        layoutOrder = v175
                    }))
                end
            end

            return p111:New("Frame")({
                Name = "RoleBadges",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 3,
                Size = UDim2.new(1, 0, 0, 0),
                [Children] = t31
            })
        end)
        v141 = p92:Computed(function(_, p113) -- line: 1286
            -- upvalues: v172 (copy), Theme (copy), Children (copy)
            if v172 == nil then
                return nil
            end

            return p113:New("TextLabel")({
                Name = "Subtext",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                FontFace = p113:Computed(function(p114) -- line: 1292
                    -- upvalues: Theme (copy)
                    return Font.new(p114(Theme.Font.Body), Enum.FontWeight.Medium)
                end),
                LayoutOrder = 3,
                RichText = true,
                Size = UDim2.new(1, 0, 0, 0),
                Text = ("<i>%*</i>"):format(v172),
                TextColor3 = Theme.Color.NeutralContentDark,
                TextSize = Theme.TextSize.Label,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                [Children] = {
                    p113:New("UIPadding")({
                        PaddingBottom = UDim.new(0, 16),
                        PaddingLeft = UDim.new(0, 14),
                        PaddingRight = UDim.new(0, 14)
                    })
                }
            })
        end)
        TextBox = p92:Computed(function(_, p116) -- line: 1314
            -- upvalues: v173 (copy), Children (copy), makeFooterButton (copy)
            if v173 == nil then
                return nil
            end

            local t33 = {
                p116:New("UIListLayout")({
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    HorizontalFlex = Enum.UIFlexAlignment.None,
                    VerticalFlex = Enum.UIFlexAlignment.None,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 6)
                }),
                p116:New("UIPadding")({
                    PaddingBottom = UDim.new(0, 12),
                    PaddingLeft = UDim.new(0, 14),
                    PaddingRight = UDim.new(0, 14)
                })
            }
            local t34 = {}

            for v177, v178 in v173 do
                if typeof(v178) == "table" and typeof(v178.label) == "string" and typeof(v178.onActivate) == "function" then
                    local v179 = p116:Value(true)

                    table.insert(t34, v179)

                    local icon2 = if typeof(v178.icon) == "string" then v178.icon else nil
                    local v180 = v178.style == "Neutral"

                    table.insert(t33, (makeFooterButton(p116, v178.label, icon2, v180, v178.onActivate, v177, v179, v178.large == true, v178.hideAfterPress == true)))
                end
            end

            return p116:New("Frame")({
                Name = "FooterButtons",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 3,
                Size = UDim2.new(1, 0, 0, 0),
                Visible = p116:Computed(function(p117) -- line: 1348
                    -- upvalues: t34 (copy)
                    for _, v182 in t34 do
                        if p117(v182) then
                            return true
                        end
                    end

                    return false
                end),
                [Children] = t33
            })
        end)

        local equip2 = equip

        v130[Children] = {
            v131,
            v154,
            v155,
            v140,
            v141,
            TextBox,
            p92:Computed(function(_, p119) -- line: 1361
                -- upvalues: entry (copy), equip2 (copy), Children (copy), makeEquipButton (copy)
                if equip2 == nil then
                    return nil
                end

                return p119:New("Frame")({
                    Name = "EquipRow",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    LayoutOrder = 3,
                    Size = UDim2.new(1, 0, 0, 0),
                    [Children] = {
                        p119:New("UIPadding")({
                            PaddingBottom = UDim.new(0, 12),
                            PaddingLeft = UDim.new(0, 14),
                            PaddingRight = UDim.new(0, 14)
                        }),
                        makeEquipButton(p119, equip2.label or "Equip", function() -- line: 1375
                            -- upvalues: equip2 (copy)
                            if equip2.onActivate then
                                equip2.onActivate()
                            end
                        end, entry.paused)
                    }
                })
            end),
            p92:New("Frame")({
                Name = "ProgressBar",
                BackgroundColor3 = Theme.Color.NeutralStroke,
                BorderSizePixel = 0,
                LayoutOrder = 4,
                Size = UDim2.new(1, 0, 0, 3),
                Visible = duration > 0,
                [Children] = { makeProgressFill(p92, v123.progress, v118) }
            })
        }
        v127[Children] = {
            v128,
            v151,
            v152,
            v129,
            Frame(v130)
        }

        return CanvasGroup(v127)
    end

    local v183, CanvasGroup2

    if entry.channel == "centre" then
        v143 = p92:Spring(p92:Computed(function(p120) -- line: 1402
            -- upvalues: v123 (copy)
            if p120(v123.visible) then
                return 0
            end

            return 1
        end), 28, 1)

        local v184 = p92:Spring(p92:Computed(function(p121) -- line: 1405
            -- upvalues: v123 (copy)
            if p121(v123.visible) then
                return 1.05
            end

            return 0.92
        end), 24, 1)

        p92:Observer(v184):onChange(function() -- line: 1409
            -- upvalues: entry (copy), v184 (copy), Fusion (copy)
            if Fusion.peek(v184) >= 1.04 and not Fusion.peek(entry.settled) then
                entry.settled:set(true)
            end
        end)
        v183 = p92:Spring(p92:Computed(function(p122) -- line: 1415
            -- upvalues: v123 (copy)
            return UDim2.new(0.5, 0, 0.5, (math.round((p122(v123.offset)))))
        end), 28, 1)

        local v186

        if options then
            v139 = options.progressScale
            v186 = typeof(v139) == "number"
        end

        if not options or not v186 then
            icon = nil
        else
            v137 = options.progressScale
            icon = math.clamp(v137, 0, 1)
        end

        if icon ~= nil then
            local icon2 = icon

            v137 = p92:Computed(function(p123) -- line: 1423
                -- upvalues: v123 (copy), icon2 (copy)
                return p123(v123.progress) * icon2
            end)
        else
            v137 = v123.progress
        end

        local v187 = false

        if options then
            v127 = options.imageRatio

            if typeof(v127) == "number" then
                v187 = options.imageRatio > 0
            end
        end

        v139 = if v187 then options.imageRatio else nil

        local v188 = p92:Value(Vector2.zero)
        local v189 = v139
        local v190 = p92:Computed(function(p124) -- line: 1430
            -- upvalues: v188 (copy), v189 (copy)
            if v189 then
                return v189
            end

            local v191 = p124(v188)

            if not (v191.X > 0 and v191.Y > 0) then
                return 1.7777777777777777
            end

            return v191.X / v191.Y
        end)
        local n4 = 1.05
        local n5 = 440
        local v192 = p92:Computed(function(p125) -- line: 91
            -- upvalues: n4 (copy), n5 (copy), Viewport (copy)
            local v193 = if n4 == nil then 1 else p125(n4)

            return (math.min(n5, (p125(Viewport.ViewportSize).X - 32) / v193))
        end)

        if image ~= nil then
            v192 = p92:Computed(function(p126) -- line: 1440
                -- upvalues: v188 (copy), v190 (copy), GuiService (copy), Viewport (copy)
                local v195 = p126(Viewport.ViewportSize)
                local v197 = math.min(600, (v195.X - 32) / 1.05)
                local v198 = GuiService:GetGuiInset().Y + 16
                local v199 = ((v195.Y - 2 * v198) / 1.05 - 84) * p126(v190) + 36
                local v200 = p126(v188)

                return (math.max(220, (math.min(v197, v199, if v200.X > 0 then v200.X + 36 else 1e999))))
            end)
        end

        CanvasGroup2 = p92:New("CanvasGroup")
        v128 = {
            Name = "Popup_message",
            Active = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.Color.Base,
            GroupTransparency = v143,
            Position = v183,
            Size = p92:Computed(function(p127) -- line: 1459
                -- upvalues: v192 (ref)
                return UDim2.fromOffset(p127(v192), 0)
            end),
            ZIndex = 2
        }
        v128[Out("AbsoluteSize")] = entry.size
        v129 = p92:New("UIScale")({
            Scale = v184
        })
        Frame = p92:New("UICorner")({
            CornerRadius = UDim.new(0, 12)
        })
        v130 = p92:New("UIStroke")({
            Thickness = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Theme.Color.NeutralStroke,
            Transparency = v143
        })

        local v203 = p92:New("TextButton")({
            Name = "ClickBlocker",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Selectable = false,
            Text = "",
            TextSize = 1,
            ZIndex = 0,
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
            Size = UDim2.fromScale(1, 1),
            TextColor3 = Color3.new()
        })
        local Frame2 = p92:New("Frame")

        v131 = {
            Name = "Content",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0)
        }
        v140 = p92:New("UIPadding")({
            PaddingTop = UDim.new(0, 16),
            PaddingBottom = UDim.new(0, 16),
            PaddingLeft = UDim.new(0, 18),
            PaddingRight = UDim.new(0, 18)
        })
        v141 = p92:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        TextBox = p92:New("Frame")
        v138 = {
            Name = "TopBar",
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, 0)
        }
        v133 = p92:New("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local v204 = v103

        v134 = p92:Computed(function(_, p129) -- line: 1526
            -- upvalues: v204 (copy), fromUserId (copy), makeAvatar (copy), makeServerGlyph (copy)
            if v204 then
                return makeServerGlyph(p129, 28, 1)
            end

            if fromUserId == nil then
                return nil
            end

            return makeAvatar(p129, fromUserId, 28, 1)
        end)

        local v206 = v109

        v142 = p92:Computed(function(_, p131) -- line: 1531
            -- upvalues: v204 (copy), v206 (copy), title (copy), v104 (copy), fromUserName (copy), Theme (copy), Children (copy)
            local v207 = if v204 then "Server" else v104

            if v207 == nil and v206 then
                v207 = title
            end

            if v207 == nil then
                return nil
            end

            if fromUserName ~= nil and fromUserName ~= v207 then
                v207 = ("%* <font weight=\"400\">(@%*)</font>"):format(v207, fromUserName)
            end

            return p131:New("TextLabel")({
                Name = v206 and "Title" or "SenderName",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                FontFace = p131:Computed(function(p132) -- line: 1546
                    -- upvalues: Theme (copy)
                    return Font.new(p132(Theme.Font.Heading), p132(Theme.FontWeight.Heading))
                end),
                LayoutOrder = 2,
                RichText = true,
                Size = UDim2.fromOffset(0, 0),
                Text = v207,
                TextColor3 = Theme.Color.BaseContent,
                TextSize = if v206 then Theme.TextSize.Title else Theme.TextSize.Subtitle,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left,
                [Children] = {
                    p131:New("UIFlexItem")({
                        FlexMode = Enum.UIFlexMode.Fill
                    })
                }
            })
        end)

        local v208 = p92:Computed(function(_, p134) -- line: 1564
            -- upvalues: v104 (copy), fromUserTopRoleColor (copy), fromUserTopRole (copy), Theme (copy), RoleBadge (copy)
            if v104 == nil or fromUserTopRole == nil then
                return nil
            end

            local v209 = RoleBadge(p134, {
                layoutOrder = 3,
                large = true,
                pillHeight = 25,
                name = fromUserTopRole,
                color = fromUserTopRoleColor or Theme.Color.Primary
            })

            p134:New("UIFlexItem")({
                FlexMode = Enum.UIFlexMode.None,
                Parent = v209
            })

            return v209
        end)

        v136 = p92:Computed(function(p135) -- line: 1577
            -- upvalues: entry (copy), Icons (copy)
            if p135(entry.paused) then
                return Icons.PlayLarge
            end

            return Icons.PauseLarge
        end)
        v135 = makeIconButton(p92, "PauseButton", v136, v123.togglePause, 5, duration > 0 and countdown == nil and not v115)

        local onMute2 = onMute
        local muteState2 = muteState

        togglePause = p92:Computed(function(_, p137) -- line: 1580
            -- upvalues: onMute2 (copy), muteState2 (copy), fromUserTopRoleColor (copy), Theme (copy), makeMuteButton (copy)
            if onMute2 == nil or muteState2 == nil then
                return nil
            end

            return makeMuteButton(p137, muteState2, onMute2, 6, fromUserTopRoleColor or Theme.Color.Primary)
        end)

        local onAction2 = onAction

        v138[Children] = {
            v133,
            v134,
            v142,
            v208,
            v135,
            togglePause,
            p92:Computed(function(_, p139) -- line: 1585
                -- upvalues: options (copy), v123 (copy), onAction2 (copy), v114 (copy), Icons (copy), makeIconButton (copy)
                if not options or options.dismissable ~= false then
                    return makeIconButton(p139, "CloseButton", Icons.Close, function() -- line: 1587
                        -- upvalues: v123 (copy), onAction2 (copy), v114 (copy)
                        if v114 and onAction2 then
                            onAction2("dismiss", "", nil)
                        end

                        v123.requestDismiss()
                    end, 7)
                end

                return nil
            end)
        }
        TextBox = TextBox(v138)
        v138 = p92:Computed(function(_, p141) -- line: 1597
            -- upvalues: v206 (copy), title (copy), Theme (copy)
            if title == nil or v206 then
                return nil
            end

            return p141:New("TextLabel")({
                Name = "Title",
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                FontFace = p141:Computed(function(p142) -- line: 1603
                    -- upvalues: Theme (copy)
                    return Font.new(p142(Theme.Font.Heading), p142(Theme.FontWeight.Heading))
                end),
                Size = UDim2.new(1, 0, 0, 0),
                Text = title,
                TextColor3 = Theme.Color.BaseContent,
                TextSize = Theme.TextSize.Title,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end)

        local v212 = v113
        local v213 = v120
        local v214 = p92:Computed(function(_, p144) -- line: 1616
            -- upvalues: entry (copy), v212 (copy), v213 (copy), countdown (copy), Theme (copy)
            if entry.text == "" and countdown == nil then
                return nil
            end

            local v215 = not v212 and (string.find(entry.text, "<b>", 1, true) ~= nil or string.find(entry.text, "<font", 1, true) ~= nil)

            return p144:New("TextLabel")({
                Name = "Body",
                BackgroundTransparency = 1,
                LayoutOrder = 3,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                FontFace = p144:Computed(function(p145) -- line: 1628
                    -- upvalues: Theme (copy)
                    return Font.new(p145(Theme.Font.Body), Enum.FontWeight.Medium)
                end),
                RichText = v215,
                Size = UDim2.new(1, 0, 0, 0),
                Text = v213,
                TextColor3 = Theme.Color.NeutralContentMain,
                TextSize = Theme.TextSize.Subtitle,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end)

        v132 = p92:Computed(function(_, p147) -- line: 1642
            -- upvalues: options (copy), VoteBody (copy)
            local voteConfig = if options then options.voteConfig else nil

            if typeof(voteConfig) == "table" then
                return VoteBody(p147, {
                    layoutOrder = 5,
                    mode = voteConfig.mode,
                    preview = voteConfig.preview,
                    options = voteConfig.options,
                    results = voteConfig.results,
                    votedIndex = voteConfig.votedIndex,
                    endTime = voteConfig.endTime,
                    onVote = voteConfig.onVote,
                    colorSeed = voteConfig.colorSeed
                })
            end

            return nil
        end)
        v131[Children] = {
            v140,
            v141,
            TextBox,
            v138,
            v214,
            v132,
            p92:Computed(function(_, p149) -- line: 1658
                -- upvalues: v188 (copy), v189 (copy), v190 (copy), image (copy), Children (copy)
                if image == nil then
                    return nil
                end

                local v216 = p149:New("ImageLabel")({
                    Name = "BodyImage",
                    BackgroundTransparency = 1,
                    LayoutOrder = 4,
                    Size = UDim2.new(1, 0, 0, 4000),
                    Image = image,
                    ScaleType = Enum.ScaleType.Fit,
                    [Children] = {
                        p149:New("UIAspectRatioConstraint")({
                            AspectRatio = v190
                        }),
                        p149:New("UICorner")({
                            CornerRadius = UDim.new(0, 6)
                        })
                    }
                })

                if v189 == nil then
                    local v217 = false

                    table.insert(p149, function() -- line: 1676
                        -- upvalues: v217 (ref)
                        v217 = true
                    end)
                    task.spawn(function() -- line: 1677
                        -- upvalues: v216 (copy), v217 (ref), v188 (copy)
                        local elapsed = os.clock()

                        while not v217 and not v216.IsLoaded and os.clock() - elapsed < 10 do
                            task.wait(0.1)
                        end

                        if not v217 then
                            local ContentImageSize = v216.ContentImageSize

                            if ContentImageSize.X > 0 and ContentImageSize.Y > 0 then
                                v188:set(ContentImageSize)
                            end
                        end
                    end)
                end

                return v216
            end)
        }
        v128[Children] = {
            v129,
            Frame,
            v130,
            v203,
            Frame2(v131),
            p92:New("Frame")({
                Name = "ProgressBar",
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = Theme.Color.NeutralStroke,
                BorderSizePixel = 0,
                Position = UDim2.fromScale(0, 1),
                Size = UDim2.new(1, 0, 0, 3),
                Visible = duration > 0,
                [Children] = { makeProgressFill(p92, v137, v118) }
            })
        }

        return CanvasGroup2(v128)
    end

    v118 = if not (options and options.color) then Theme.Color.BaseContent else options.color

    local v219
    local n6 = 620
    local v220 = p92:Computed(function(p150) -- line: 91
        -- upvalues: v219 (copy), n6 (copy), Viewport (copy)
        local v221 = if v219 == nil then 1 else p150(v219)

        return (math.min(n6, (p150(Viewport.ViewportSize).X - 32) / v221))
    end)

    if fromUserName ~= nil and countdown == nil then
        v120 = ("@%*: %*"):format(fromUserName, entry.text)
    end

    v121 = p92:Spring(p92:Computed(function(p151) -- line: 1716
        -- upvalues: v123 (copy)
        local v223 = p151(v123.offset)
        local v224 = if p151(v123.visible) then v223 + 16 else -120

        return UDim2.new(0.5, 0, 0, v224)
    end), 28, 1)
    v183 = p92:New("Frame")
    icon = {
        Name = "Popup_hint",
        Active = false,
        AnchorPoint = Vector2.new(0.5, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = Theme.Color.Base,
        BackgroundTransparency = 0.05,
        Position = v121,
        Size = UDim2.fromOffset(0, 0)
    }
    icon[Out("AbsoluteSize")] = entry.size
    CanvasGroup = p92:New("UICorner")({
        CornerRadius = UDim.new(0, 9)
    })
    v127 = p92:New("UIStroke")({
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Theme.Color.NeutralContent
    })

    local v225 = p92:New("UISizeConstraint")

    CanvasGroup2 = {}
    CanvasGroup2.MaxSize = p92:Computed(function(p152) -- line: 1743
        -- upvalues: v220 (copy)
        return Vector2.new(p152(v220), 1e999)
    end)
    icon[Children] = {
        CanvasGroup,
        v127,
        v225(CanvasGroup2),
        p92:New("UIPadding")({
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 16),
            PaddingRight = UDim.new(0, 16)
        }),
        p92:New("TextLabel")({
            Name = "Text",
            BackgroundTransparency = 1,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.XY,
            FontFace = p92:Computed(function(p153) -- line: 1758
                -- upvalues: Theme (copy)
                return Font.new(p153(Theme.Font.Body), p153(Theme.FontWeight.Body))
            end),
            Size = UDim2.fromOffset(0, 0),
            Text = v120,
            TextColor3 = v118,
            TextSize = Theme.TextSize.Subtitle,
            TextXAlignment = Enum.TextXAlignment.Center
        })
    }

    return v183(icon)
end
