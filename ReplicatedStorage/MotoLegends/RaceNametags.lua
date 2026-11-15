-- https://lua.expert

local LocalizationService = game:GetService("LocalizationService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local t1 = {
    MaxDistance = 100,
    SpectateMaxDistance = 1200,
    FadeTime = 0.35,
    ExtraHeight = 0.9
}

t1.TagScale = 0.85
t1.RidingMaxDistance = 80
t1.FarCamModes = {
    [5] = true,
    [6] = true
}
t1.NoTagCamModes = {
    [4] = true,
    [7] = true
}
t1.SpectateCamRange = {
    [5] = 1200,
    [6] = 1200
}
t1.RidingMaxShown = 2
t1.MaxShown = 3
t1.KeepBias = 0.85
t1.SpectateMaxShown = 4
t1.ScreenMargin = 60
t1.Hidden = false

if RunService:IsClient() then
    local UserInputService = game:GetService("UserInputService")

    UserInputService.InputBegan:Connect(function(p1, p2) -- line: 36
        -- upvalues: t1 (copy), UserInputService (copy)
        if not p2 and p1.KeyCode == Enum.KeyCode.N and not UserInputService:GetFocusedTextBox() then
            t1.Hidden = not t1.Hidden
        end
    end)
end

t1.BubbleHide = {}

if RunService:IsClient() then
    local TextChatService = game:GetService("TextChatService")

    TextChatService.MessageReceived:Connect(function(p3) -- line: 46
        -- upvalues: t1 (copy), TextChatService (copy)
        local TextSource = p3.TextSource

        if TextSource then
            local BubbleChatConfiguration = TextChatService:FindFirstChildOfClass("BubbleChatConfiguration")

            if BubbleChatConfiguration and BubbleChatConfiguration.Enabled ~= false and (p3.Text or ""):gsub("%s", "") ~= "" then
                t1.BubbleHide[TextSource.UserId] = os.clock() + (BubbleChatConfiguration.BubbleDuration or 15)
            end
        end
    end)
end

local function bubbleShowing(p4) -- line: 54
    -- upvalues: t1 (copy)
    local v1 = t1.BubbleHide[p4.UserId]

    if v1 and v1 <= os.clock() then
        t1.BubbleHide[p4.UserId] = nil

        return false
    end

    return v1 ~= nil
end

local t2 = {}
local v2 = Color3.fromRGB(255, 255, 255)
local v3 = Color3.fromRGB(220, 35, 45)
local v4 = Color3.fromRGB(35, 75, 165)
local v5 = Color3.fromRGB(30, 155, 80)
local v6 = Color3.fromRGB(255, 208, 40)
local v7 = Color3.fromRGB(15, 15, 15)
local t3 = {
    ID = { v3, v2 },
    PL = { v2, v3 },
    UA = { v4, v6 },
    RU = { v2, v4, v3 },
    NL = { v3, v2, v4 },
    DE = { v7, v3, v6 },
    AT = { v3, v2, v3 },
    HU = { v3, v2, v5 },
    BG = { v2, v5, v3 },
    IT = {
        v5,
        v2,
        v3,
        vertical = true
    },
    FR = {
        v4,
        v2,
        v3,
        vertical = true
    },
    IE = {
        v5,
        v2,
        Color3.fromRGB(255, 135, 35),
        vertical = true
    },
    RO = {
        v4,
        v6,
        v3,
        vertical = true
    },
    BE = {
        v7,
        v6,
        v3,
        vertical = true
    }
}

local function rect(p5, p6, p7, p8, p9, p10, p11) -- line: 73
    local Frame = Instance.new("Frame")

    Frame.Name = p6
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = p11
    Frame.Position = UDim2.fromScale(p7, p8)
    Frame.Size = UDim2.fromScale(p9, p10)
    Frame.Parent = p5

    return Frame
end

function t1.CountryCode(p12) -- line: 77
    local v8, v9

    if typeof(p12) == "string" and p12:upper():match("^[A-Z][A-Z]$") then
        local v10 = p12:upper()

        if v10 then
            v8 = v10
            v9 = true
        else
            v9 = false
        end
    else
        v9 = false
    end

    if not v9 then
        v8 = "XX"
    end

    return v8
end

function t1.SetNation(p13, p14) -- line: 80
    -- upvalues: t1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t3 (copy)
    local v11 = t1.CountryCode(p14)

    p13:SetAttribute("NationCode", v11)

    local Flag = p13.Panel.Flag

    Flag:ClearAllChildren()
    Flag.BackgroundTransparency = 1

    local v12 = t3[v11]

    if v12 then
        for v13, v14 in ipairs(v12) do
            if v12.vertical then
                local v15 = "Stripe" .. v13
                local v16 = (v13 - 1) / #v12
                local v17 = 1 / #v12
                local Frame = Instance.new("Frame")

                Frame.Name = v15
                Frame.BorderSizePixel = 0
                Frame.BackgroundColor3 = v14
                Frame.Position = UDim2.fromScale(v16, 0)
                Frame.Size = UDim2.fromScale(v17, 1)
                Frame.Parent = Flag
            else
                local v18 = "Stripe" .. v13
                local v19 = (v13 - 1) / #v12
                local v20 = 1 / #v12
                local Frame = Instance.new("Frame")

                Frame.Name = v18
                Frame.BorderSizePixel = 0
                Frame.BackgroundColor3 = v14
                Frame.Position = UDim2.fromScale(0, v19)
                Frame.Size = UDim2.fromScale(1, v20)
                Frame.Parent = Flag
            end
        end
    elseif v11 == "JP" or v11 == "BD" then
        local v21 = v11 == "JP" and v2 or v5
        local Frame = Instance.new("Frame")

        Frame.Name = "Field"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = v21
        Frame.Position = UDim2.fromScale(0, 0)
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.Parent = Flag

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Disc"
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = v3
        Frame2.Position = UDim2.fromScale(0.31, 0.2)
        Frame2.Size = UDim2.fromScale(0.38, 0.6)
        Frame2.Parent = Flag
        Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)
    elseif v11 == "US" then
        for i = 1, 13 do
            local v22 = "Stripe" .. i
            local v23 = (i - 1) / 13
            local v24 = i % 2 == 1
            local v25 = if v24 then v3 else nil
            local v26 = if not v24 or not v25 then v2 else v25
            local Frame = Instance.new("Frame")

            Frame.Name = v22
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v26
            Frame.Position = UDim2.fromScale(0, v23)
            Frame.Size = UDim2.fromScale(1, 0.07692307692307693)
            Frame.Parent = Flag
        end

        local Frame = Instance.new("Frame")

        Frame.Name = "Canton"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = v4
        Frame.Position = UDim2.fromScale(0, 0)
        Frame.Size = UDim2.fromScale(0.45, 0.5384615384615384)
        Frame.Parent = Flag
    elseif v11 == "GB" then
        local Frame = Instance.new("Frame")

        Frame.Name = "Field"
        Frame.BorderSizePixel = 0
        Frame.BackgroundColor3 = v4
        Frame.Position = UDim2.fromScale(0, 0)
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.Parent = Flag

        for _, v27 in { 33, -33 } do
            local Frame = Instance.new("Frame")

            Frame.Name = "Diagonal"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v2
            Frame.Position = UDim2.fromScale(-0.06, 0.38)
            Frame.Size = UDim2.fromScale(1.12, 0.24)
            Frame.Parent = Flag
            Frame.Rotation = v27
        end

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "VerticalWhite"
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = v2
        Frame2.Position = UDim2.fromScale(0.38, 0)
        Frame2.Size = UDim2.fromScale(0.24, 1)
        Frame2.Parent = Flag

        local Frame3 = Instance.new("Frame")

        Frame3.Name = "HorizontalWhite"
        Frame3.BorderSizePixel = 0
        Frame3.BackgroundColor3 = v2
        Frame3.Position = UDim2.fromScale(0, 0.32)
        Frame3.Size = UDim2.fromScale(1, 0.36)
        Frame3.Parent = Flag

        local Frame4 = Instance.new("Frame")

        Frame4.Name = "VerticalRed"
        Frame4.BorderSizePixel = 0
        Frame4.BackgroundColor3 = v3
        Frame4.Position = UDim2.fromScale(0.44, 0)
        Frame4.Size = UDim2.fromScale(0.12, 1)
        Frame4.Parent = Flag

        local Frame5 = Instance.new("Frame")

        Frame5.Name = "HorizontalRed"
        Frame5.BorderSizePixel = 0
        Frame5.BackgroundColor3 = v3
        Frame5.Position = UDim2.fromScale(0, 0.41)
        Frame5.Size = UDim2.fromScale(1, 0.18)
        Frame5.Parent = Flag
    else
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "FlagSymbol"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.fromScale(1, 1)
        TextLabel.TextSize = 17
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextColor3 = v2
        TextLabel.AutoLocalize = false
        TextLabel.Text = v11 == "XX" and utf8.char(127937) or utf8.char(string.byte(v11, 1) + 127462 - 65, string.byte(v11, 2) + 127462 - 65)
        TextLabel.Parent = Flag
    end

    Flag.Visible = true

    local v28 = Flag:FindFirstChild("Edge") or Instance.new("UIStroke")

    v28.Name = "Edge"
    v28.Color = Color3.fromRGB(20, 20, 24)
    v28.Thickness = 1
    v28.Transparency = 0.35
    v28.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    v28.Parent = Flag
end

function t1.Layout(p15) -- line: 113
    local Panel = p15:FindFirstChild("Panel")

    if Panel then
        local PlayerName = Panel:FindFirstChild("PlayerName")

        if PlayerName then
            local Offset = PlayerName.Size.X.Offset
            local Position = Panel:FindFirstChild("Position")
            local v29 = 8

            if Position and Position.Visible then
                Position.Position = UDim2.fromOffset(8, 6)
                v29 = 8 + Position.Size.X.Offset + 6
            end

            Panel.Flag.Position = UDim2.fromOffset(v29, 8)
            p15:SetAttribute("FlagX", v29)
            PlayerName.Position = UDim2.fromOffset(v29 + 30, 0)

            if Panel:FindFirstChild("DeviceIcon") then
                Panel.DeviceIcon.Visible = false
            end

            p15.Size = UDim2.fromOffset(v29 + 22 + 8 + Offset + 8, 30)
        end
    end
end

function t1.SetName(p16, p17) -- line: 128
    -- upvalues: TextService (copy), t1 (copy)
    local v30 = math.ceil(TextService:GetTextSize(p17, 14, Enum.Font.GothamBold, Vector2.new(1000, 30)).X) + 4
    local PlayerName = p16.Panel.PlayerName

    PlayerName.Text = p17
    PlayerName.Size = UDim2.fromOffset(v30, 30)
    t1.Layout(p16)
end

function t1.SetPosition(p18, p19) -- line: 134
    -- upvalues: TextService (copy), t1 (copy), v2 (copy), v7 (copy)
    local Panel = p18:FindFirstChild("Panel")

    if Panel then
        local Position = Panel:FindFirstChild("Position")

        if typeof(p19) == "number" then
            if not Position then
                Position = Instance.new("Frame")
                Position.Name = "Position"
                Position.BorderSizePixel = 0
                Position.BackgroundColor3 = v2
                Position.BackgroundTransparency = 0
                Instance.new("UICorner", Position).CornerRadius = UDim.new(0, 4)

                local TextLabel = Instance.new("TextLabel")

                TextLabel.Name = "Number"
                TextLabel.BackgroundTransparency = 1
                TextLabel.Size = UDim2.fromScale(1, 1)
                TextLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.ExtraBold)
                TextLabel.TextSize = 13
                TextLabel.TextColor3 = v7
                TextLabel.AutoLocalize = false
                TextLabel.Parent = Position
                Position.Parent = Panel
            end

            local v32 = tostring((math.floor(p19)))
            local v34 = math.max(20, math.ceil(TextService:GetTextSize(v32, 13, Enum.Font.GothamBlack, Vector2.new(100, 30)).X) + 10)

            Position.Number.Text = v32
            Position.Size = UDim2.fromOffset(v34, 18)
            Position.Visible = true
            t1.Layout(p18)
        elseif Position and Position.Visible then
            Position.Visible = false
            t1.Layout(p18)
        end
    end
end

local function seq(p20) -- line: 161
    local t9 = {}

    for v35, v36 in p20 do
        table.insert(t9, ColorSequenceKeypoint.new((v35 - 1) / (#p20 - 1), v36))
    end

    return ColorSequence.new(t9)
end

local fromRGB = Color3.fromRGB

t1.BlackholeDisk = ColorSequence.new({
    ColorSequenceKeypoint.new(0, fromRGB(255, 96, 8)),
    ColorSequenceKeypoint.new(0.2, fromRGB(255, 190, 30)),
    ColorSequenceKeypoint.new(0.32, fromRGB(255, 248, 205)),
    ColorSequenceKeypoint.new(0.44, fromRGB(255, 190, 30)),
    ColorSequenceKeypoint.new(0.62, fromRGB(255, 110, 10)),
    ColorSequenceKeypoint.new(0.8, fromRGB(255, 210, 60)),
    ColorSequenceKeypoint.new(1, fromRGB(255, 96, 8))
})
t1.SilverDisk = seq({
    fromRGB(120, 126, 140),
    fromRGB(214, 220, 232),
    fromRGB(255, 255, 255),
    fromRGB(170, 178, 192),
    fromRGB(110, 116, 130),
    fromRGB(230, 236, 248),
    fromRGB(120, 126, 140)
})
t1.GoldDisk = seq({
    fromRGB(170, 110, 10),
    fromRGB(255, 196, 40),
    fromRGB(255, 250, 215),
    fromRGB(255, 186, 30),
    fromRGB(150, 95, 5),
    fromRGB(255, 220, 90),
    fromRGB(170, 110, 10)
})
t1.CrimsonDisk = ColorSequence.new({
    ColorSequenceKeypoint.new(0, fromRGB(150, 0, 12)),
    ColorSequenceKeypoint.new(0.18, fromRGB(255, 40, 40)),
    ColorSequenceKeypoint.new(0.32, fromRGB(255, 228, 215)),
    ColorSequenceKeypoint.new(0.46, fromRGB(255, 40, 40)),
    ColorSequenceKeypoint.new(0.64, fromRGB(170, 0, 20)),
    ColorSequenceKeypoint.new(0.82, fromRGB(255, 110, 70)),
    ColorSequenceKeypoint.new(1, fromRGB(150, 0, 12))
})
t1.MythicDisk = ColorSequence.new({
    ColorSequenceKeypoint.new(0, fromRGB(110, 30, 255)),
    ColorSequenceKeypoint.new(0.14, fromRGB(200, 70, 255)),
    ColorSequenceKeypoint.new(0.26, fromRGB(255, 90, 220)),
    ColorSequenceKeypoint.new(0.36, fromRGB(255, 240, 255)),
    ColorSequenceKeypoint.new(0.48, fromRGB(120, 210, 255)),
    ColorSequenceKeypoint.new(0.62, fromRGB(150, 50, 255)),
    ColorSequenceKeypoint.new(0.76, fromRGB(255, 215, 130)),
    ColorSequenceKeypoint.new(0.88, fromRGB(230, 80, 255)),
    ColorSequenceKeypoint.new(1, fromRGB(110, 30, 255))
})
t1.DirectorDisk = seq({
    fromRGB(255, 255, 255),
    fromRGB(190, 196, 210),
    fromRGB(231, 0, 0),
    fromRGB(255, 255, 255),
    fromRGB(60, 62, 70),
    fromRGB(210, 214, 224),
    fromRGB(255, 60, 60),
    fromRGB(255, 255, 255)
})
t1.RoleStyles = {
    owner = {
        transp = 0.04,
        shine = 0.3,
        glow = "blackhole",
        particles = "owner",
        color = Color3.fromRGB(6, 5, 4),
        shineColor = Color3.fromRGB(255, 214, 120),
        text = Color3.fromRGB(255, 222, 150)
    },
    dev = {
        transp = 0.1,
        shine = 0.25,
        glow = "pulse",
        color = Color3.fromRGB(205, 16, 30)
    },
    admin = {
        transp = 0.15,
        shine = 0.6,
        color = Color3.fromRGB(126, 46, 214)
    },
    mod = {
        transp = 0.15,
        color = Color3.fromRGB(30, 96, 224)
    },
    fun = {
        transp = 0.18,
        color = Color3.fromRGB(222, 56, 150)
    },
    racedirector1 = {
        transp = 0.3,
        color = Color3.new(0, 0, 0),
        flag = {
            alpha = 0.3,
            fade = 0.8
        }
    },
    racedirector = {
        transp = 0.1,
        shine = 0.3,
        glow = "disk",
        spin = 120,
        particles = "racedirector",
        color = fromRGB(4, 4, 6),
        flag = {
            alpha = 0.22,
            fade = 0.85,
            wave = true
        },
        shineColor = fromRGB(255, 255, 255),
        disk = t1.DirectorDisk,
        outline = fromRGB(231, 0, 0),
        text = fromRGB(255, 255, 255)
    },
    vip = {
        transp = 0.04,
        shine = 0.3,
        glow = "blackhole",
        color = Color3.fromRGB(8, 6, 14),
        shineColor = Color3.fromRGB(200, 160, 255),
        text = Color3.fromRGB(230, 215, 255)
    },
    fan = {
        transp = 0.06,
        shine = 0.3,
        glow = "disk",
        spin = 80,
        particles = "silver",
        color = fromRGB(22, 24, 30),
        shineColor = fromRGB(235, 240, 255),
        disk = t1.SilverDisk,
        outline = fromRGB(205, 212, 226),
        text = fromRGB(236, 240, 248),
        bar = seq({
            fromRGB(150, 150, 160),
            fromRGB(255, 255, 255),
            fromRGB(150, 150, 160)
        })
    },
    supporter = {
        transp = 0.05,
        shine = 0.26,
        glow = "disk",
        spin = 110,
        particles = "gold",
        color = fromRGB(34, 25, 5),
        shineColor = fromRGB(255, 228, 120),
        disk = t1.GoldDisk,
        outline = fromRGB(255, 200, 30),
        text = fromRGB(255, 234, 160),
        bar = seq({
            fromRGB(130, 120, 110),
            fromRGB(255, 255, 255),
            fromRGB(130, 120, 110)
        })
    },
    patron = {
        transp = 0.04,
        shine = 0.22,
        glow = "crimson",
        spin = 200,
        particles = "crimson",
        color = fromRGB(44, 5, 10),
        shineColor = fromRGB(255, 170, 160),
        outline = fromRGB(235, 25, 40),
        text = fromRGB(255, 214, 206),
        bar = seq({
            fromRGB(120, 110, 110),
            fromRGB(255, 255, 255),
            fromRGB(120, 110, 110)
        })
    },
    benefactor = {
        transp = 0.02,
        shine = 0.1,
        glow = "mythic",
        spin = 240,
        particles = "mythic",
        color = fromRGB(120, 52, 230),
        shineColor = fromRGB(240, 210, 255),
        disk = t1.MythicDisk,
        outline = fromRGB(170, 80, 255),
        text = fromRGB(255, 255, 255),
        bar = seq({
            fromRGB(48, 30, 64),
            fromRGB(92, 64, 112),
            fromRGB(150, 110, 170),
            fromRGB(92, 64, 112),
            fromRGB(48, 30, 64)
        }),
        textGradient = seq({
            fromRGB(225, 195, 255),
            fromRGB(255, 255, 255),
            fromRGB(255, 170, 240),
            fromRGB(255, 255, 255),
            fromRGB(170, 220, 255),
            fromRGB(225, 195, 255)
        })
    }
}

function t1.DiskFor(p21) -- line: 220
    -- upvalues: t1 (copy)
    if not p21 then
        return nil
    end

    if p21.disk then
        return p21.disk
    end

    if p21.glow == "crimson" then
        return t1.CrimsonDisk
    end

    return if p21.glow == "blackhole" then t1.BlackholeDisk else nil
end

function t1.ApplyBar(p22, p23, p24) -- line: 228
    local RoleBar = p22:FindFirstChild("RoleBar")

    if p23 and p23.bar then
        local UIGradient

        if RoleBar then
            UIGradient = RoleBar
        else
            UIGradient = Instance.new("UIGradient")
            UIGradient.Name = "RoleBar"
            UIGradient.Parent = p22
        end

        UIGradient.Color = p23.bar
        UIGradient.Rotation = 0
    elseif RoleBar then
        RoleBar:Destroy()
    end

    p24 = p24 or p22:FindFirstChild("PlayerName", true)

    if not p24 then
        return
    end

    local RoleText = p24:FindFirstChild("RoleText")

    if p23 and p23.textGradient then
        local UIGradient

        if RoleText then
            UIGradient = RoleText
        else
            UIGradient = Instance.new("UIGradient")
            UIGradient.Name = "RoleText"
            UIGradient.Parent = p24
        end

        UIGradient.Color = p23.textGradient
    elseif RoleText then
        RoleText:Destroy()
    end
end

function t1.StepGlow(p25, p26, p27, p28, p29) -- line: 245
    -- upvalues: t1 (copy)
    p28 = p28 or 1

    local Kind = p25:GetAttribute("Kind")
    local Disk = p25:FindFirstChild("Disk")

    if Disk then
        Disk.Rotation = p26 * (p25:GetAttribute("Spin") or 140) % 360

        local v40 = p29 or 2.2

        if Kind == "mythic" then
            p25.Thickness = (v40 + 0.4 + 1.6 * p27) * p28
        else
            p25.Thickness = (v40 + 1.2 * p27) * p28
        end
    elseif Kind == "outline" then
        p25.Thickness = (1.6 + 0.9 * p27) * p28
    else
        p25.Thickness = (1.5 + 2 * p27) * p28
        p25.Color = Color3.fromRGB(255, 70, 70):Lerp(Color3.fromRGB(255, 190, 170), p27)
    end

    local Parent = p25.Parent

    if not Parent then
        return
    end

    local RoleBar = Parent:FindFirstChild("RoleBar")

    if RoleBar then
        RoleBar.Offset = Vector2.new(math.sin(p26 * 0.6) * 0.35, 0)
    end

    local v42 = Parent:FindFirstChild("PlayerName", true)
    local RoleText = v42 and v42:FindFirstChild("RoleText")

    if RoleText then
        RoleText.Offset = Vector2.new(p26 * 0.25 % 2 - 1, 0)
    end

    if t1.StepFlag then
        t1.StepFlag(Parent, p26)
    end
end

function t1.DressGlow(p30, p31) -- line: 267
    -- upvalues: t1 (copy), v2 (copy)
    local v43 = t1.DiskFor(p31)
    local Disk = p30:FindFirstChild("Disk")

    if v43 then
        p30.Color = v2

        if not Disk then
            Disk = Instance.new("UIGradient")
            Disk.Name = "Disk"
            Disk.Parent = p30
        end

        Disk.Color = v43

        local spin = p31.spin

        if not spin then
            spin = if p31.glow == "crimson" then 200 else 140
        end

        p30:SetAttribute("Spin", spin)
    else
        if Disk then
            Disk:Destroy()
        end

        if p31 and p31.glow == "outline" then
            p30.Color = p31.outline or v2
        end
    end
end

t1.ParticleFx = {
    emerald = {
        rise = 9,
        orbit = 0,
        flash = 0,
        colors = {
            Color3.fromRGB(80, 255, 170),
            Color3.fromRGB(205, 255, 228),
            Color3.fromRGB(20, 210, 120)
        },
        size = { 6, 12 },
        speed = { 0.45, 0.7 }
    },
    silver = {
        rise = 4,
        orbit = 0,
        flash = 1,
        colors = {
            Color3.fromRGB(235, 240, 255),
            Color3.fromRGB(190, 198, 214),
            Color3.fromRGB(255, 255, 255)
        },
        size = { 5, 10 },
        speed = { 0.4, 0.6 }
    },
    gold = {
        rise = 7,
        orbit = 2,
        flash = 1,
        colors = {
            Color3.fromRGB(255, 205, 60),
            Color3.fromRGB(255, 240, 180),
            Color3.fromRGB(255, 252, 235),
            Color3.fromRGB(255, 170, 30)
        },
        size = { 6, 12 },
        speed = { 0.45, 0.75 }
    },
    crimson = {
        rise = 13,
        orbit = 4,
        flash = 2,
        colors = {
            Color3.fromRGB(255, 60, 60),
            Color3.fromRGB(255, 205, 90),
            Color3.fromRGB(255, 242, 225),
            Color3.fromRGB(255, 120, 40)
        },
        size = { 7, 15 },
        speed = { 0.5, 0.9 }
    },
    mythic = {
        rise = 18,
        orbit = 6,
        flash = 3,
        infall = 6,
        colors = {
            Color3.fromRGB(175, 95, 255),
            Color3.fromRGB(255, 95, 230),
            Color3.fromRGB(255, 246, 255),
            Color3.fromRGB(125, 215, 255),
            Color3.fromRGB(255, 215, 130)
        },
        size = { 7, 17 },
        speed = { 0.5, 0.95 }
    },
    benefactor = {
        rise = 14,
        orbit = 4,
        flash = 2,
        colors = {
            Color3.fromRGB(255, 60, 60),
            Color3.fromRGB(255, 205, 90),
            Color3.fromRGB(255, 242, 225),
            Color3.fromRGB(255, 120, 40)
        },
        size = { 7, 16 },
        speed = { 0.5, 0.9 }
    },
    owner = {
        rise = 16,
        orbit = 6,
        flash = 3,
        infall = 8,
        colors = {
            Color3.fromRGB(255, 196, 50),
            Color3.fromRGB(255, 120, 15),
            Color3.fromRGB(255, 248, 225),
            Color3.fromRGB(255, 165, 40)
        },
        size = { 7, 16 },
        speed = { 0.5, 0.9 }
    },
    racedirector = {
        rise = 10,
        orbit = 4,
        flash = 2,
        confetti = 7,
        colors = {
            fromRGB(255, 255, 255),
            fromRGB(255, 70, 60),
            fromRGB(255, 250, 240),
            fromRGB(200, 206, 220),
            fromRGB(255, 222, 150)
        },
        size = { 6, 13 },
        speed = { 0.5, 0.85 }
    }
}

local v44 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 176, 28)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 200, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 252, 225)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 200, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 176, 28))
})

local function buildCrown(p32, p33, p34) -- line: 310
    -- upvalues: v44 (copy)
    p34 = p34 or {}

    local v46 = 26 * p33
    local v47 = 19 * p33
    local v48 = v46 * 1.16
    local v49 = 24 * p33
    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "RoleCrown"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
    CanvasGroup.Position = UDim2.fromScale(0.5, 0.5)
    CanvasGroup.Size = UDim2.fromOffset(v48, v49)
    CanvasGroup.ZIndex = 0
    CanvasGroup.GroupTransparency = 0.44999999999999996
    CanvasGroup:SetAttribute("NoFade", true)
    CanvasGroup.Parent = p32

    local t10 = {
        group = CanvasGroup,
        grads = {},
        gems = {},
        k = p33
    }

    local function gold(p35) -- line: 318
        -- upvalues: p33 (copy), t10 (copy), v44 (copy)
        p35.BackgroundColor3 = Color3.new(1, 1, 1)
        p35.BorderSizePixel = 0

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Color = v44
        UIGradient.Rotation = 25
        UIGradient.Parent = p35
        table.insert(t10.grads, UIGradient)

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = Color3.fromRGB(255, 236, 170)
        UIStroke.Thickness = math.max(1, 0.8 * p33)
        UIStroke.Parent = p35
    end

    local v51 = v48 / 2
    local v52 = v49 - 1.5 * p33

    for _, v53 in {
            { -0.34, 0.3, 0.5 },
            { 0, 0.38, 0.66 },
            { 0.34, 0.3, 0.5 }
        } do
        local v54 = v46 * v53[2]
        local Frame = Instance.new("Frame")

        Frame.Name = "Spike"
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Rotation = 45
        Frame.Size = UDim2.fromOffset(v54, v54)

        local v55 = v52 - v47 * v53[3]

        Frame.Position = UDim2.fromOffset(v51 + v46 * v53[1], v55)
        Frame.ZIndex = 2
        gold(Frame)
        Frame.Parent = CanvasGroup

        local v56 = (if v53[1] == 0 then 4.5 else 3.5) * p33
        local Frame2 = Instance.new("Frame")

        Frame2.Name = "TipGem"
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame2.Size = UDim2.fromOffset(v56, v56)
        Frame2.Position = UDim2.fromOffset(v51 + v46 * v53[1], v55 - v54 * 0.707)
        Frame2.BorderSizePixel = 0
        Frame2.ZIndex = 4

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Frame2
        Frame2.Parent = CanvasGroup
        table.insert(t10.gems, {
            f = Frame2,
            base = if v53[1] == 0 then p34.tip or Color3.fromRGB(230, 20, 40) or p34.side or Color3.fromRGB(245, 240, 230) else p34.side or Color3.fromRGB(245, 240, 230)
        })
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "Band"
    Frame.AnchorPoint = Vector2.new(0.5, 1)
    Frame.Position = UDim2.fromOffset(v51, v52)
    Frame.Size = UDim2.fromOffset(v46, v47 * 0.36)
    Frame.ZIndex = 3
    gold(Frame)

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 2 * p33)
    UICorner.Parent = Frame
    Frame.Parent = CanvasGroup

    for _, v57 in { -0.3, 0, 0.3 } do
        local v58 = (if v57 == 0 then 4 else 3) * p33
        local Frame = Instance.new("Frame")

        Frame.Name = "BandGem"
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Size = UDim2.fromOffset(v58, v58)
        Frame.Position = UDim2.fromOffset(v51 + v46 * v57, v52 - v47 * 0.18)
        Frame.BorderSizePixel = 0
        Frame.ZIndex = 4

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Frame
        Frame.Parent = CanvasGroup
        table.insert(t10.gems, {
            f = Frame,
            base = if v57 == 0 then p34.band or Color3.fromRGB(230, 20, 40) or p34.bandSide or Color3.fromRGB(30, 200, 120) else p34.bandSide or Color3.fromRGB(30, 200, 120)
        })
    end

    return t10
end

function t1.BuildFx(p36, p37, p38, p39) -- line: 350
    -- upvalues: t1 (copy), buildCrown (copy)
    local RoleCrown = p36:FindFirstChild("RoleCrown")

    if RoleCrown then
        RoleCrown:Destroy()
    end

    local RoleFx = p36:FindFirstChild("RoleFx")

    if RoleFx and RoleFx:GetAttribute("Kind") ~= p37 then
        RoleFx:Destroy()
        RoleFx = nil
    end

    local v59 = p37 and t1.ParticleFx[p37]

    if not v59 then
        return nil
    end

    local v60 = RoleFx or Instance.new("Frame")

    v60.Name = "RoleFx"
    v60.BackgroundTransparency = 1
    v60.Size = UDim2.fromScale(1, 1)
    v60.ZIndex = 5
    v60:SetAttribute("Kind", p37)
    v60:SetAttribute("NoFade", true)
    v60:ClearAllChildren()
    v60.Parent = p36

    local t13 = {
        holder = v60,
        def = v59,
        parts = {},
        scale = p38 or 1
    }

    local function img(p40) -- line: 360
        -- upvalues: v60 (copy)
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Image = "rbxasset://textures/particles/sparkles_main.dds"
        ImageLabel.ImageTransparency = 1
        ImageLabel.ZIndex = p40
        ImageLabel:SetAttribute("NoFade", true)
        ImageLabel.Parent = v60

        return ImageLabel
    end

    for _ = 1, v59.rise do
        local parts = t13.parts
        local t14 = {
            kind = "rise",
            born = 0,
            life = 0
        }
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Image = "rbxasset://textures/particles/sparkles_main.dds"
        ImageLabel.ImageTransparency = 1
        ImageLabel.ZIndex = 6
        ImageLabel:SetAttribute("NoFade", true)
        ImageLabel.Parent = v60
        t14.gui = ImageLabel
        table.insert(parts, t14)
    end

    for i = 1, v59.orbit do
        local parts = t13.parts
        local t15 = {
            kind = "orbit"
        }
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Image = "rbxasset://textures/particles/sparkles_main.dds"
        ImageLabel.ImageTransparency = 1
        ImageLabel.ZIndex = 7
        ImageLabel:SetAttribute("NoFade", true)
        ImageLabel.Parent = v60
        t15.gui = ImageLabel
        t15.ph = (i - 1) / v59.orbit
        table.insert(parts, t15)
    end

    for _ = 1, v59.flash do
        local parts = t13.parts
        local t16 = {
            kind = "flash",
            born = 0,
            life = 0
        }
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Image = "rbxasset://textures/particles/sparkles_main.dds"
        ImageLabel.ImageTransparency = 1
        ImageLabel.ZIndex = 7
        ImageLabel:SetAttribute("NoFade", true)
        ImageLabel.Parent = v60
        t16.gui = ImageLabel
        table.insert(parts, t16)
    end

    for _ = 1, v59.infall or 0 do
        local parts = t13.parts
        local t17 = {
            kind = "infall",
            born = 0,
            life = 0
        }
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Image = "rbxasset://textures/particles/sparkles_main.dds"
        ImageLabel.ImageTransparency = 1
        ImageLabel.ZIndex = 6
        ImageLabel:SetAttribute("NoFade", true)
        ImageLabel.Parent = v60
        t17.gui = ImageLabel
        table.insert(parts, t17)
    end

    for _ = 1, v59.confetti or 0 do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Image = "rbxasset://textures/particles/sparkles_main.dds"
        ImageLabel.ImageTransparency = 1
        ImageLabel.ZIndex = 6
        ImageLabel:SetAttribute("NoFade", true)
        ImageLabel.Parent = v60

        local v61 = t1.CheckerContent and t1.CheckerContent()

        if v61 then
            ImageLabel.ImageContent = v61
            ImageLabel.ResampleMode = Enum.ResamplerMode.Pixelated
        end

        table.insert(t13.parts, {
            kind = "confetti",
            born = 0,
            life = 0,
            gui = ImageLabel
        })
    end

    if not (not v59.crown or p39 and p39.noCrown) then
        local v62, v63

        if p39 then
            local crownK = p39.crownK

            if crownK then
                v62 = crownK
                v63 = true
            else
                local crownScale = p39.crownScale

                if crownScale then
                    v62 = crownScale
                    v63 = true
                else
                    v63 = false
                end
            end
        else
            v63 = false
        end

        if not v63 then
            v62 = p38 or 1
        end

        t13.crown = buildCrown(p36, v62, v59.gems)
    end

    return t13
end

local function perimeter(p41) -- line: 377
    local v64 = p41 % 1

    if v64 < 0.4166666666666667 then
        return v64 / 0.4166666666666667, 0
    end

    if v64 < 0.5 then
        return 1, (v64 - 0.4166666666666667) * 12
    end

    if v64 < 0.9166666666666667 then
        return 1 - (v64 - 0.4166666666666667 - 0.08333333333333333) / 0.4166666666666667, 1
    end

    return 0, 1 - (v64 - 0.8333333333333334 - 0.08333333333333333) * 12
end

function t1.StepFx(p42, p43, p44) -- line: 382
    -- upvalues: v2 (copy)
    if not (p42 and p42.holder.Parent) then
        return
    end

    p42.holder.Visible = p44 > 0

    if p44 <= 0 then
        return
    end

    local def, scale, crown = p42.def, p42.scale, p42.crown

    if crown then
        crown.group.GroupTransparency = 1 - 0.55 * p44 * (math.sin(p43 * 2.4) * 0.15 + 0.85)

        local v67 = -1.2 + 2.4 * (p43 * 0.55 % 1.6 / 1.6)

        for _, v68 in crown.grads do
            v68.Offset = Vector2.new(v67, 0)
        end

        for v69, v70 in crown.gems do
            v70.f.BackgroundColor3 = v70.base:Lerp(Color3.new(1, 1, 1), (math.sin(p43 * 4 + v69 * 1.7) + 1) / 2 * 0.55)
        end
    end

    for _, v73 in p42.parts do
        local gui = v73.gui

        if v73.kind == "rise" then
            local v74 = p43 - v73.born

            if v74 < 0 or v73.life < v74 then
                v73.born = p43
                v73.life = 1 / (def.speed[1] + math.random() * (def.speed[2] - def.speed[1]))
                v73.x = 0.04 + math.random() * 0.92
                v73.y0 = 0.45 + math.random() * 0.5
                v73.dy = 0.9 + math.random() * 0.9
                v73.size = def.size[1] + math.random() * (def.size[2] - def.size[1])
                v73.sway = math.random() * 6
                gui.ImageColor3 = def.colors[math.random(#def.colors)]
                v74 = 0
                gui.Rotation = math.random(0, 90)
            end

            local v75 = v74 / v73.life
            local v77 = math.sin(v75 * 3.141592653589793)

            gui.Position = UDim2.fromScale(v73.x + math.sin(p43 * 3 + v73.sway) * 0.015, v73.y0 - v75 * v73.dy)

            local v79 = v73.size * (v77 * 0.7 + 0.5) * scale

            gui.Size = UDim2.fromOffset(v79, v79)
            gui.ImageTransparency = 1 - v77 * 0.95 * p44
        elseif v73.kind == "orbit" then
            local v80 = (p43 * 0.16 + v73.ph) % 1
            local v81, v82

            if v80 < 0.4166666666666667 then
                v81 = v80 / 0.4166666666666667
                v82 = 0
            elseif v80 < 0.5 then
                v81 = 1
                v82 = (v80 - 0.4166666666666667) * 12
            elseif v80 < 0.9166666666666667 then
                v81 = 1 - (v80 - 0.4166666666666667 - 0.08333333333333333) / 0.4166666666666667
                v82 = 1
            else
                v81 = 0
                v82 = 1 - (v80 - 0.8333333333333334 - 0.08333333333333333) * 12
            end

            gui.Position = UDim2.fromScale(v81, v82)

            local v84 = (math.sin(p43 * 6 + v73.ph * 6) * 3 + 10) * scale

            gui.Size = UDim2.fromOffset(v84, v84)
            gui.ImageColor3 = def.colors[1]:Lerp(def.colors[2], (math.sin(p43 * 2 + v73.ph * 6) + 1) / 2)
            gui.ImageTransparency = 1 - 0.95 * p44
            gui.Rotation = p43 * 120 % 360
        elseif v73.kind == "infall" then
            local v88 = p43 - v73.born

            if v88 < 0 or v73.life < v88 then
                v73.born = p43 + math.random() * 0.4
                v73.life = 1.1 + math.random() * 0.7
                v73.a0 = math.random() * 3.141592653589793 * 2
                v73.spin = (math.random() < 0.5 and -1 or 1) * (1.6 + math.random())
                v73.size = 6 + math.random() * 7
                gui.ImageColor3 = def.colors[math.random(#def.colors)]
                v88 = p43 - v73.born
            end

            if v88 < 0 then
                gui.ImageTransparency = 1
            else
                local v89 = v88 / v73.life
                local v90 = 1.45 - 0.5 * v89 * v89
                local v91 = v73.a0 + v73.spin * v89

                gui.Position = UDim2.fromScale(0.5 + math.cos(v91) * 0.5 * v90, 0.5 + math.sin(v91) * 0.5 * v90 * 1.9)

                local v92 = v73.size * (1.15 - 0.7 * v89) * scale

                gui.Size = UDim2.fromOffset(v92, v92)
                gui.ImageTransparency = 1 - math.sin(v89 * 3.141592653589793) * 0.9 * p44
                gui.Rotation = (p43 * 200 + v73.a0 * 50) % 360
            end
        elseif v73.kind == "confetti" then
            local v94 = p43 - v73.born

            if v73.life < v94 then
                v73.born = p43 + math.random() * 0.6
                v73.life = 0.9 + math.random() * 0.8
                v73.x0 = 0.3 + math.random() * 0.65
                v73.y0 = 0.2 + math.random() * 0.6
                v73.dx = 0.22 + math.random() * 0.3
                v73.dy = (math.random() - 0.65) * 1.1
                v73.size = 4 + math.random() * 4
                v73.rot0 = math.random(0, 90)
                v73.spin = (math.random() < 0.5 and -1 or 1) * (140 + math.random() * 220)
                gui.ImageColor3 = math.random() < 0.3 and Color3.fromRGB(255, 70, 60) or v2
                v94 = p43 - v73.born
            end

            if v94 < 0 then
                gui.ImageTransparency = 1
            else
                local v95 = v94 / v73.life

                gui.Position = UDim2.fromScale(v73.x0 + v73.dx * v95, v73.y0 + v73.dy * v95 + math.sin(v95 * 7 + v73.rot0) * 0.06)

                local v99 = v73.size * scale * (1 - 0.3 * v95)

                gui.Size = UDim2.fromOffset(v99, v99)
                gui.Rotation = v73.rot0 + v73.spin * v94
                gui.ImageTransparency = 1 - (v95 < 0.15 and v95 / 0.15 or 1) * (1 - v95 * v95) * 0.9 * p44
            end
        else
            local v100 = p43 - v73.born

            if v73.life < v100 then
                v73.born = p43 + 0.3 + math.random() * 1.6
                v73.life = 0.55
                v73.x = math.random()
                v73.y = math.random() < 0.5 and 0 or 1
                v100 = p43 - v73.born
            end

            if v100 < 0 then
                gui.ImageTransparency = 1
            else
                local v102 = math.sin(v100 / v73.life * 3.141592653589793)
                local v103 = (v102 * 20 + 8) * scale

                gui.Size = UDim2.fromOffset(v103, v103)
                gui.Position = UDim2.fromScale(v73.x, v73.y)
                gui.ImageColor3 = def.colors[3] or Color3.new(1, 1, 1)
                gui.ImageTransparency = 1 - v102 * p44
                gui.Rotation = v100 * 220
            end
        end
    end
end

local v104

local function checker() -- line: 461
    -- upvalues: v104 (ref)
    if v104 ~= nil then
        return v104 or nil
    end

    local function v105() -- line: 463
        local v106 = game:GetService("AssetService"):CreateEditableImage({
            Size = Vector2.new(2, 2)
        })
        local v107 = buffer.create(16)

        buffer.writeu32(v107, 0, 4278190080)
        buffer.writeu32(v107, 4, 4294967295)
        buffer.writeu32(v107, 8, 4294967295)
        buffer.writeu32(v107, 12, 4278190080)
        v106:WritePixelsBuffer(Vector2.zero, Vector2.new(2, 2), v107)

        return Content.fromObject(v106)
    end

    local ok, result = pcall(v105)

    v104 = not not (ok and result) and result

    if not ok or not result then
        result = nil
    end

    return result
end

local function setRim(p45, p46) -- line: 473
    -- upvalues: v104 (ref)
    local RDRim = p45:FindFirstChild("RDRim")
    local UICorner = p45:FindFirstChildOfClass("UICorner")

    if p46 then
        if UICorner then
            UICorner.CornerRadius = UDim.new(0, 2)
        end

        if not RDRim then
            local Folder = Instance.new("Folder")

            Folder.Name = "RDRim"
            Folder.Parent = p45

            local result

            if v104 ~= nil then
                result = v104 or nil
            else
                local function v108() -- line: 463
                    local v109 = game:GetService("AssetService"):CreateEditableImage({
                        Size = Vector2.new(2, 2)
                    })
                    local v110 = buffer.create(16)

                    buffer.writeu32(v110, 0, 4278190080)
                    buffer.writeu32(v110, 4, 4294967295)
                    buffer.writeu32(v110, 8, 4294967295)
                    buffer.writeu32(v110, 12, 4278190080)
                    v109:WritePixelsBuffer(Vector2.zero, Vector2.new(2, 2), v110)

                    return Content.fromObject(v109)
                end

                local ok

                ok, result = pcall(v108)
                v104 = ok and result or false

                if not ok or not result then
                    result = nil
                end
            end

            if result then
                for _, v111 in {
                        {
                            "Top",
                            UDim2.new(0, 0, 0, 0),
                            UDim2.new(1, 0, 0, 4)
                        },
                        {
                            "Bottom",
                            UDim2.new(0, 0, 1, -4),
                            UDim2.new(1, 0, 0, 4)
                        },
                        {
                            "Left",
                            UDim2.new(0, 0, 0, 4),
                            UDim2.new(0, 4, 1, -8)
                        },
                        {
                            "Right",
                            UDim2.new(1, -4, 0, 4),
                            UDim2.new(0, 4, 1, -8)
                        }
                    } do
                    local ImageLabel = Instance.new("ImageLabel")

                    ImageLabel.Name = v111[1]
                    ImageLabel.BackgroundTransparency = 1
                    ImageLabel.BorderSizePixel = 0
                    ImageLabel.Position = v111[2]
                    ImageLabel.Size = v111[3]
                    ImageLabel.ImageContent = result
                    ImageLabel.ScaleType = Enum.ScaleType.Tile
                    ImageLabel.TileSize = UDim2.fromOffset(4, 4)
                    ImageLabel.ResampleMode = Enum.ResamplerMode.Pixelated
                    ImageLabel.ZIndex = 4
                    ImageLabel.Parent = Folder
                end
            else
                local UIStroke = Instance.new("UIStroke")

                UIStroke.Name = "RDRimStroke"
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                UIStroke.Thickness = 2
                UIStroke.Color = Color3.new(1, 1, 1)
                UIStroke.Parent = p45

                local t19 = {}

                for i = 0, 9 do
                    local v112 = i % 2 == 0
                    local v113 = if v112 then Color3.new(1, 1, 1) else nil
                    local v114 = if not v112 or not v113 then Color3.new(0, 0, 0) else v113
                    local v115 = i / 10
                    local v116 = (i + 1) / 10 - 5E-04

                    table.insert(t19, ColorSequenceKeypoint.new(v115, v114))
                    table.insert(t19, ColorSequenceKeypoint.new(math.min(v116, 1), v114))
                end

                t19[#t19] = ColorSequenceKeypoint.new(1, t19[#t19].Value)

                local UIGradient = Instance.new("UIGradient")

                UIGradient.Color = ColorSequence.new(t19)
                UIGradient.Parent = UIStroke
                UIStroke:SetAttribute("RDRim", true)
            end
        end
    else
        if RDRim then
            RDRim:Destroy()
        end

        if UICorner then
            UICorner.CornerRadius = UDim.new(0, 6)
        end
    end
end

t1.FlagTile = 10

function t1.CheckerContent() -- line: 513
    -- upvalues: v104 (ref)
    if v104 ~= nil then
        return v104 or nil
    end

    local function v118() -- line: 463
        local v119 = game:GetService("AssetService"):CreateEditableImage({
            Size = Vector2.new(2, 2)
        })
        local v120 = buffer.create(16)

        buffer.writeu32(v120, 0, 4278190080)
        buffer.writeu32(v120, 4, 4294967295)
        buffer.writeu32(v120, 8, 4294967295)
        buffer.writeu32(v120, 12, 4278190080)
        v119:WritePixelsBuffer(Vector2.zero, Vector2.new(2, 2), v120)

        return Content.fromObject(v119)
    end

    local ok, result = pcall(v118)

    v104 = not not (ok and result) and result

    if not ok or not result then
        result = nil
    end

    return result
end

function t1.ApplyFlag(p47, p48, p49, p50, p51) -- line: 514
    -- upvalues: t1 (copy), v104 (ref)
    local RDFlag = p47:FindFirstChild("RDFlag")
    local v121 = p48 and p48.flag
    local v122, v123

    if v121 then
        if v104 ~= nil then
            local v127 = v104 or nil

            if v127 then
                v122 = v127
                v123 = true
            else
                v123 = false
            end
        else
            local function v124() -- line: 463
                local v125 = game:GetService("AssetService"):CreateEditableImage({
                    Size = Vector2.new(2, 2)
                })
                local v126 = buffer.create(16)

                buffer.writeu32(v126, 0, 4278190080)
                buffer.writeu32(v126, 4, 4294967295)
                buffer.writeu32(v126, 8, 4294967295)
                buffer.writeu32(v126, 12, 4278190080)
                v125:WritePixelsBuffer(Vector2.zero, Vector2.new(2, 2), v126)

                return Content.fromObject(v125)
            end

            local ok, result = pcall(v124)

            if ok and result then
                v104 = result
                v122 = result
                v123 = true
            else
                v104 = false
                v123 = false
            end
        end
    else
        v123 = false
    end

    if not v123 then
        v122 = nil
    end

    if v122 then
        local v128 = p49 or 1
        local v131 = math.max(2, math.floor(t1.FlagTile * v128 / 2 + 0.5) * 2)
        local v132 = if p51 then "CanvasGroup" else "Frame"

        if RDFlag and RDFlag.ClassName ~= v132 then
            RDFlag:Destroy()
            RDFlag = nil
        end

        local v133 = RDFlag or Instance.new(v132)

        v133.Name = "RDFlag"
        v133.BorderSizePixel = 0
        v133.Size = UDim2.fromScale(1, 1)
        v133.Position = UDim2.new()
        v133.ClipsDescendants = true
        v133.ZIndex = 0

        if p50 then
            local v134 = p48.transp or 0.5

            v133.BackgroundColor3 = p48.color or Color3.new(0, 0, 0)
            v133.BackgroundTransparency = v134
            v133:SetAttribute("FadeBase_BackgroundTransparency", v134)
            p47.BackgroundTransparency = 1
            p47:SetAttribute("FadeBase_BackgroundTransparency", 1)
            p47:SetAttribute("HoverIdleT", 1)

            local UICorner = p47:FindFirstChildOfClass("UICorner")

            if UICorner then
                UICorner.CornerRadius = UDim.new(0, (math.min(UICorner.CornerRadius.Offset, 3)))
            end

            (v133:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", v133)).CornerRadius = UICorner and UICorner.CornerRadius or UDim.new(0, 2)
        else
            v133.BackgroundTransparency = 1
            v133:SetAttribute("FadeBase_BackgroundTransparency", 1)

            local UICorner = v133:FindFirstChildOfClass("UICorner")

            if p51 then
                (UICorner or Instance.new("UICorner", v133)).CornerRadius = UDim.new(0, p51)
            elseif UICorner then
                UICorner:Destroy()
            end
        end

        local v135 = v133:FindFirstChild("Checker") or Instance.new("ImageLabel")

        v135.Name = "Checker"
        v135.BackgroundTransparency = 1
        v135.BorderSizePixel = 0
        v135.ZIndex = 0
        v135:SetAttribute("FadeBase_BackgroundTransparency", 1)
        v135:SetAttribute("FadeBase_ImageTransparency", 0)
        v135.ImageContent = v122
        v135.ScaleType = Enum.ScaleType.Tile
        v135.TileSize = UDim2.fromOffset(v131, v131)
        v135.ResampleMode = Enum.ResamplerMode.Pixelated
        v135.Size = UDim2.new(1, v131, 1, 0)
        v135.Position = UDim2.fromOffset(-v131, 0)
        v135.Parent = v133

        local v136 = v135:FindFirstChild("Fade") or Instance.new("UIGradient")
        local v137 = v121.alpha or 0.4
        local v138 = v121.fade or 0.8

        v136.Name = "Fade"
        v136.Rotation = 0
        v136.Offset = Vector2.zero
        v136.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, v137),
            NumberSequenceKeypoint.new(v138 * 0.35, v137 + (1 - v137) * 0.2),
            NumberSequenceKeypoint.new(v138 * 0.7, v137 + (1 - v137) * 0.65),
            NumberSequenceKeypoint.new(v138, 1),
            NumberSequenceKeypoint.new(1, 1)
        })
        v136.Parent = v135
        v133:SetAttribute("Tile", v131)
        v133:SetAttribute("Wave", v121.wave == true)

        if not RDFlag then
            v133.Parent = p47
        end

        return v133
    end

    if RDFlag then
        RDFlag:Destroy()
    end

    return nil
end

function t1.StepFlag(p52, p53) -- line: 553
    -- upvalues: t1 (copy)
    local RDFlag = p52:FindFirstChild("RDFlag")

    if RDFlag and RDFlag:GetAttribute("Wave") then
        local Checker = RDFlag:FindFirstChild("Checker")

        if Checker then
            local v139 = RDFlag:GetAttribute("Tile") or t1.FlagTile
            local v140 = p53 * v139 * 1.5 % v139

            Checker.Position = UDim2.fromOffset(-v139 + v140, 0)

            local Fade = Checker:FindFirstChild("Fade")

            if Fade then
                local X = Checker.AbsoluteSize.X
                local X2 = RDFlag.AbsoluteSize.X

                if not (X < 1) and not (X2 < 1) and not (X <= X2) then
                    local v141 = v140 / v139 * (X - X2) / X

                    Fade.Offset = Vector2.new(-v141 + math.sin(p53 * 2.1) * 0.06 + math.sin(p53 * 5.7 + 1) * 0.025, 0)
                end
            end
        end
    end
end

function t1.FlagTextStroke(p54, p55) -- line: 566
    local RDTextStroke = p54:FindFirstChild("RDTextStroke")

    if p55 and p55.flag then
        local UIStroke

        if RDTextStroke then
            UIStroke = RDTextStroke
        else
            UIStroke = Instance.new("UIStroke")
            UIStroke.Name = "RDTextStroke"
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
            UIStroke.Parent = p54
        end

        UIStroke.Color = Color3.new(0, 0, 0)
        UIStroke.Thickness = 1
        UIStroke.Transparency = 0.35
        UIStroke:SetAttribute("FadeBase_Transparency", 0.35)
    elseif RDTextStroke then
        RDTextStroke:Destroy()
    end
end

function t1.SetRole(p56, p57) -- line: 574
    -- upvalues: t1 (copy), v2 (copy), setRim (copy)
    local Panel = p56:FindFirstChild("Panel")

    if not Panel then
        return nil, nil
    end

    local v146 = t1.RoleStyles[typeof(p57) == "string" and p57:lower() or ""]
    local transp

    if v146 then
        transp = v146.transp or 0.5
        Panel.BackgroundColor3 = v146.color or Color3.new(0, 0, 0)
    else
        transp = 0.5
        Panel.BackgroundColor3 = Color3.new(0, 0, 0)
    end

    Panel:SetAttribute("FadeBase_BackgroundTransparency", transp)
    Panel.BackgroundTransparency = transp
    Panel:SetAttribute("HoverIdleColor", Panel.BackgroundColor3)
    Panel:SetAttribute("HoverIdleT", transp)

    local RoleShine = Panel:FindFirstChild("RoleShine")
    local Sweep

    if v146 and v146.shine then
        local Frame

        if RoleShine then
            Frame = RoleShine
        else
            Frame = Instance.new("Frame")
            Frame.Name = "RoleShine"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v2
            Frame.Size = UDim2.fromScale(1, 1)
            Frame.ZIndex = 2

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Frame

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Name = "Sweep"
            UIGradient.Rotation = 15
            UIGradient.Offset = Vector2.new(-1.2, 0)
            UIGradient.Parent = Frame
            Frame.Parent = Panel
        end

        Sweep = Frame.Sweep
        Frame.BackgroundColor3 = v146.shineColor or v2
        Sweep.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.34, 1),
            NumberSequenceKeypoint.new(0.5, v146.shine),
            NumberSequenceKeypoint.new(0.66, 1),
            NumberSequenceKeypoint.new(1, 1)
        })
    elseif RoleShine then
        RoleShine:Destroy()
    end

    local RoleGlow = Panel:FindFirstChild("RoleGlow")
    local UIStroke

    if not RoleGlow or RoleGlow:GetAttribute("Kind") == (v146 and v146.glow) then
        UIStroke = RoleGlow
    else
        RoleGlow:Destroy()
    end

    if not (v146 and v146.glow) then
        if UIStroke then
            UIStroke:Destroy()
            UIStroke = nil
        end
    elseif not UIStroke then
        UIStroke = Instance.new("UIStroke")
        UIStroke.Name = "RoleGlow"
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Thickness = 2
        UIStroke:SetAttribute("Kind", v146.glow)
        UIStroke.Thickness = 2.5
        UIStroke.Parent = Panel
    end

    if UIStroke then
        t1.DressGlow(UIStroke, v146)
    end

    local PlayerName = Panel:FindFirstChild("PlayerName")

    if PlayerName then
        PlayerName.TextColor3 = v146 and v146.text or v2
    end

    t1.ApplyBar(Panel, v146, PlayerName)

    local v147 = v146 ~= nil and v146.rim == "checker"

    setRim(Panel, v147)

    if not v147 then
        for _, child in Panel:GetChildren() do
            if child:IsA("UIStroke") and child:GetAttribute("RDRim") then
                child:Destroy()
            end
        end
    end

    t1.ApplyFlag(Panel, v146, 1, true)

    if PlayerName then
        t1.FlagTextStroke(PlayerName, v146)
    end

    return Sweep, UIStroke, (t1.BuildFx(Panel, v146 and v146.particles or nil, 1, {
        crownK = 1.15
    }))
end

function t1.SetDevice(p58, p59) -- line: 622
    -- upvalues: v2 (copy), v7 (copy)
    local v148 = if (p59 == "Controller" or p59 == "Mobile") and p59 then p59 else "PC"

    p58:SetAttribute("InputDevice", v148)

    local DeviceIcon = p58.Panel:FindFirstChild("DeviceIcon")

    if DeviceIcon then
        DeviceIcon:ClearAllChildren()
        DeviceIcon.BackgroundTransparency = 1

        local function shape(p60, p61, p62, p63, p64, p65, p66) -- line: 627
            -- upvalues: DeviceIcon (copy)
            local Frame = Instance.new("Frame")

            Frame.Name = p60
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = p65
            Frame.Position = UDim2.fromScale(p61, p62)
            Frame.Size = UDim2.fromScale(p63, p64)
            Frame.Parent = DeviceIcon

            if p66 then
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, p66)
            end

            return Frame
        end

        local function outline(p67) -- line: 632
            -- upvalues: v2 (copy)
            p67.BackgroundTransparency = 1

            local UIStroke = Instance.new("UIStroke", p67)

            UIStroke.Color = v2
            UIStroke.Thickness = 1.5
        end

        if v148 == "Controller" then
            local Frame = Instance.new("Frame")

            Frame.Name = "Body"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v2
            Frame.Position = UDim2.fromScale(0.04, 0.25)
            Frame.Size = UDim2.fromScale(0.92, 0.5)
            Frame.Parent = DeviceIcon
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)

            local Frame2 = Instance.new("Frame")

            Frame2.Name = "LeftGrip"
            Frame2.BorderSizePixel = 0
            Frame2.BackgroundColor3 = v2
            Frame2.Position = UDim2.fromScale(0.04, 0.47)
            Frame2.Size = UDim2.fromScale(0.26, 0.37)
            Frame2.Parent = DeviceIcon
            Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 3)

            local Frame3 = Instance.new("Frame")

            Frame3.Name = "RightGrip"
            Frame3.BorderSizePixel = 0
            Frame3.BackgroundColor3 = v2
            Frame3.Position = UDim2.fromScale(0.7, 0.47)
            Frame3.Size = UDim2.fromScale(0.26, 0.37)
            Frame3.Parent = DeviceIcon
            Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 3)

            local Frame4 = Instance.new("Frame")

            Frame4.Name = "DpadH"
            Frame4.BorderSizePixel = 0
            Frame4.BackgroundColor3 = v7
            Frame4.Position = UDim2.fromScale(0.16, 0.45)
            Frame4.Size = UDim2.fromScale(0.25, 0.08)
            Frame4.Parent = DeviceIcon

            local Frame5 = Instance.new("Frame")

            Frame5.Name = "DpadV"
            Frame5.BorderSizePixel = 0
            Frame5.BackgroundColor3 = v7
            Frame5.Position = UDim2.fromScale(0.245, 0.365)
            Frame5.Size = UDim2.fromScale(0.08, 0.25)
            Frame5.Parent = DeviceIcon

            local Frame6 = Instance.new("Frame")

            Frame6.Name = "ButtonA"
            Frame6.BorderSizePixel = 0
            Frame6.BackgroundColor3 = v7
            Frame6.Position = UDim2.fromScale(0.65, 0.47)
            Frame6.Size = UDim2.fromScale(0.1, 0.1)
            Frame6.Parent = DeviceIcon
            Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 2)

            local Frame7 = Instance.new("Frame")

            Frame7.Name = "ButtonB"
            Frame7.BorderSizePixel = 0
            Frame7.BackgroundColor3 = v7
            Frame7.Position = UDim2.fromScale(0.78, 0.36)
            Frame7.Size = UDim2.fromScale(0.1, 0.1)
            Frame7.Parent = DeviceIcon
            Instance.new("UICorner", Frame7).CornerRadius = UDim.new(0, 2)
        elseif v148 == "Mobile" then
            local Frame = Instance.new("Frame")

            Frame.Name = "Phone"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v2
            Frame.Position = UDim2.fromScale(0.25, 0.03)
            Frame.Size = UDim2.fromScale(0.5, 0.94)
            Frame.Parent = DeviceIcon
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 2)
            Frame.BackgroundTransparency = 1

            local UIStroke = Instance.new("UIStroke", Frame)

            UIStroke.Color = v2
            UIStroke.Thickness = 1.5

            local Frame2 = Instance.new("Frame")

            Frame2.Name = "Speaker"
            Frame2.BorderSizePixel = 0
            Frame2.BackgroundColor3 = v2
            Frame2.Position = UDim2.fromScale(0.4, 0.12)
            Frame2.Size = UDim2.fromScale(0.2, 0.05)
            Frame2.Parent = DeviceIcon

            local Frame3 = Instance.new("Frame")

            Frame3.Name = "Home"
            Frame3.BorderSizePixel = 0
            Frame3.BackgroundColor3 = v2
            Frame3.Position = UDim2.fromScale(0.45, 0.82)
            Frame3.Size = UDim2.fromScale(0.1, 0.06)
            Frame3.Parent = DeviceIcon
            Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 1)
        else
            local Frame = Instance.new("Frame")

            Frame.Name = "Monitor"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v2
            Frame.Position = UDim2.fromScale(0.03, 0.12)
            Frame.Size = UDim2.fromScale(0.94, 0.61)
            Frame.Parent = DeviceIcon
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 1)
            Frame.BackgroundTransparency = 1

            local UIStroke = Instance.new("UIStroke", Frame)

            UIStroke.Color = v2
            UIStroke.Thickness = 1.5

            local Frame2 = Instance.new("Frame")

            Frame2.Name = "Stand"
            Frame2.BorderSizePixel = 0
            Frame2.BackgroundColor3 = v2
            Frame2.Position = UDim2.fromScale(0.45, 0.75)
            Frame2.Size = UDim2.fromScale(0.1, 0.12)
            Frame2.Parent = DeviceIcon

            local Frame3 = Instance.new("Frame")

            Frame3.Name = "Base"
            Frame3.BorderSizePixel = 0
            Frame3.BackgroundColor3 = v2
            Frame3.Position = UDim2.fromScale(0.24, 0.9)
            Frame3.Size = UDim2.fromScale(0.52, 0.07)
            Frame3.Parent = DeviceIcon
        end
    end
end

function t1.Create(p68, p69, p70) -- line: 649
    -- upvalues: t1 (copy), v2 (copy), v7 (copy)
    local Head = p68:FindFirstChild("Head")

    if not Head then
        return nil
    end

    local RaceNametag = Head:FindFirstChild("RaceNametag")

    if RaceNametag then
        RaceNametag:Destroy()
    end

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "RaceNametag"
    BillboardGui.Adornee = Head
    BillboardGui.Size = UDim2.fromOffset(200, 30)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 2.1, 0)
    BillboardGui.MaxDistance = t1.MaxDistance
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.AutoLocalize = false

    local Frame = Instance.new("Frame")

    Frame.Name = "Panel"
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = v7
    Frame.Position = UDim2.fromScale(0, 0)
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = BillboardGui
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = 0.5
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Flag"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = v2
    Frame2.Position = UDim2.fromScale(0, 0)
    Frame2.Size = UDim2.fromScale(0, 0)
    Frame2.Parent = Frame
    Frame2.Position = UDim2.fromOffset(8, 8)
    Frame2.Size = UDim2.fromOffset(22, 14)
    Frame2.ClipsDescendants = true

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "PlayerName"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.fromOffset(38, 0)
    TextLabel.Size = UDim2.fromOffset(127, 30)
    TextLabel.TextSize = 14
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
    TextLabel.TextColor3 = v2
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TextLabel.AutoLocalize = false
    TextLabel.Text = p69
    TextLabel.Parent = Frame

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "DeviceIcon"
    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = v2
    Frame3.Position = UDim2.fromScale(0, 0)
    Frame3.Size = UDim2.fromScale(0, 0)
    Frame3.Parent = Frame
    Frame3.Size = UDim2.fromOffset(18, 18)
    t1.SetName(BillboardGui, p69)
    t1.SetNation(BillboardGui, p70)
    t1.SetDevice(BillboardGui, "PC")
    BillboardGui.Parent = Head

    return BillboardGui
end

local function riderTop() -- line: 667
    local MotoLegends = game:GetService("ReplicatedStorage"):FindFirstChild("MotoLegends")
    local DucatiRider93Template = MotoLegends and MotoLegends:FindFirstChild("DucatiRider93Template")

    return DucatiRider93Template and DucatiRider93Template:GetExtentsSize().Y
end

local function footOffset(p71) -- line: 672
    local MotoLegends = game:GetService("ReplicatedStorage"):FindFirstChild("MotoLegends")
    local DucatiRider93Template = MotoLegends and MotoLegends:FindFirstChild("DucatiRider93Template")
    local v149 = DucatiRider93Template and DucatiRider93Template:GetExtentsSize().Y
    local Head = p71:FindFirstChild("Head")
    local HumanoidRootPart = p71:FindFirstChild("HumanoidRootPart")
    local Humanoid = p71:FindFirstChildOfClass("Humanoid")

    if v149 and Head and HumanoidRootPart and Humanoid then
        local v150 = Head.Position.Y - HumanoidRootPart.Position.Y + HumanoidRootPart.Size.Y / 2 + Humanoid.HipHeight

        return (math.max(2.1, v149 + 0.9 - v150))
    end

    return 2.1
end

local function ridingBike(p72, p73) -- line: 679
    local v152 = p73 and p73.SeatPart
    local v153 = v152 and v152:FindFirstAncestorOfClass("Model")

    return if v153 and v152.Name == "RiderSeat" and v153:GetAttribute("OwnerUserId") == p72.UserId and v153.PrimaryPart then v153 else nil
end

function t1.UpdateVisibility(p74, p75, p76) -- line: 687
    local v154 = p76 and p76.SeatPart
    local v155 = v154 and v154:FindFirstAncestorOfClass("Model")

    if not v155 or v154.Name ~= "RiderSeat" or v155:GetAttribute("OwnerUserId") ~= p75.UserId or not v155.PrimaryPart then
        v155 = nil
    end

    local v156 = v155 ~= nil
    local v157 = if not v156 or not p75 then nil else p75

    if p74.PlayerToHideFrom ~= v157 then
        p74.PlayerToHideFrom = v157
    end

    return v156
end

local t20 = {}
local Folder
local Config = require(script.Parent.Config)
local BikeDynamics = require(script.Parent.BikeDynamics)

local function anchorPart(p77) -- line: 700
    -- upvalues: t20 (copy), Folder (ref)
    if not (Folder and Folder.Parent) then
        Folder = Instance.new("Folder")
        Folder.Name = "NametagAnchors"

        local Folder2 = Folder

        Folder2.Parent = workspace.CurrentCamera
    end

    local v158 = t20[p77]

    if v158 and v158.part and v158.part.Parent then
        return v158.part
    end

    local Part = Instance.new("Part")

    Part.Name = "NametagAnchor_" .. p77.UserId
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.05, 0.05, 0.05)
    Part.Parent = Folder

    return Part
end

local function findTag(p78) -- line: 710
    local child, child2

    for _, child3 in p78:GetChildren() do
        if child3.Name == "RaceNametag" and child3:IsA("BillboardGui") then
            if child3:GetAttribute("LocalFallback") then
                child2 = child3
            else
                child = child3
            end
        end
    end

    return child or child2
end

local function fadeProps(p79) -- line: 721
    if p79:IsA("TextLabel") or p79:IsA("TextButton") then
        return "BackgroundTransparency", "TextTransparency"
    end

    if p79:IsA("ImageLabel") then
        return "BackgroundTransparency", "ImageTransparency"
    end

    if p79:IsA("GuiObject") then
        return "BackgroundTransparency"
    end

    return if p79:IsA("UIStroke") then "Transparency" else nil
end

local function applyFade(p80, p81) -- line: 728
    -- upvalues: fadeProps (copy)
    if p80:GetAttribute("NoFade") then
        return
    end

    local v159, v160 = fadeProps(p80)

    if v159 then
        for _, v161 in { v159, v160 } do
            local v162 = "FadeBase_" .. v161
            local Attribute = p80:GetAttribute(v162)

            if Attribute == nil then
                Attribute = p80[v161]
                p80:SetAttribute(v162, Attribute)
            end

            local v163 = 1 - (1 - Attribute) * p81

            if p80[v161] ~= v163 then
                p80[v161] = v163
            end
        end
    end
end

local function setOpacity(p82, p83) -- line: 739
    -- upvalues: applyFade (copy)
    local Panel = p82:FindFirstChild("Panel")

    if Panel then
        local alpha = p83.alpha

        if alpha <= 0 then
            if Panel.Visible then
                Panel.Visible = false
            end

            p83.applied = 0
        else
            if not Panel.Visible then
                Panel.Visible = true
            end

            if alpha >= 1 and p83.applied == 1 then
                return
            end

            local v164 = alpha * alpha * (3 - 2 * alpha)

            applyFade(Panel, v164)

            for _, descendant in Panel:GetDescendants() do
                applyFade(descendant, v164)
            end

            p83.applied = alpha
        end
    end
end

t1.SpeedChip = {
    Delay = 2.5,
    FadeTime = 0.3,
    Width = 76,
    Height = 24,
    Gap = 3,
    Response = 10,
    CamModes = {
        [5] = true,
        [6] = true
    }
}
t1.SpeedChip.MinKph = 1
t1.SpeedChip.HideBelowKph = 0.5

local v165
local n1 = 0

local function spectateState(p84) -- line: 766
    local PlayerGui = p84 and p84:FindFirstChildOfClass("PlayerGui")
    local JerezRaceHUD = PlayerGui and PlayerGui:FindFirstChild("JerezRaceHUD")

    if not JerezRaceHUD then
        return false, false, nil
    end

    local v166 = JerezRaceHUD:GetAttribute("LobbySpectating") == true

    return v166, v166 and JerezRaceHUD:GetAttribute("SpectateHudHidden") == true, JerezRaceHUD:GetAttribute("SpectateCamMode")
end

local function chipFont(p85) -- line: 773
    return Font.new("rbxasset://fonts/families/Montserrat.json", p85)
end

local t21 = {
    brake = {
        Color3.fromRGB(168, 20, 24),
        Color3.fromRGB(255, 65, 34)
    },
    gas = {
        Color3.fromRGB(74, 100, 0),
        Color3.fromRGB(195, 255, 0)
    }
}

local function chipFill(p86, p87, p88, p89) -- line: 779
    local Frame = Instance.new("Frame")

    Frame.Name = p87
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = p88[1]
    Frame.ZIndex = 2
    Frame.AnchorPoint = Vector2.new(p89 and 1 or 0, 0)
    Frame.Position = UDim2.fromScale(0.56, 0)
    Frame.Size = UDim2.fromScale(0, 1)
    Frame.ClipsDescendants = true
    Frame.Parent = p86

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Strip"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = p88[2]
    Frame2.ZIndex = 2
    Frame2.Position = UDim2.new(0, 0, 1, -2)
    Frame2.Size = UDim2.new(1, 0, 0, 2)
    Frame2.Parent = Frame

    return Frame
end

local function buildChip(p90) -- line: 787
    -- upvalues: t1 (copy), v2 (copy), t21 (copy), chipFill (copy)
    local SpeedChip = t1.SpeedChip
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "RaceSpeedChip"
    BillboardGui.Size = UDim2.fromOffset(SpeedChip.Width, SpeedChip.Height + 6)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 1e999
    BillboardGui.AutoLocalize = false
    BillboardGui.ResetOnSpawn = false
    BillboardGui.Adornee = p90.part
    BillboardGui.Parent = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")

    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Body"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.BorderSizePixel = 0
    CanvasGroup.Size = UDim2.fromOffset(SpeedChip.Width, SpeedChip.Height)
    CanvasGroup.GroupTransparency = 1
    CanvasGroup.Parent = BillboardGui

    local Frame = Instance.new("Frame")

    Frame.Name = "Plate"
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = Color3.fromRGB(34, 36, 40)
    Frame.BackgroundTransparency = 0.06
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = CanvasGroup

    local v167 = chipFill(CanvasGroup, "Brake", t21.brake, true)
    local v168 = chipFill(CanvasGroup, "Throttle", t21.gas, false)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Speed"
    TextLabel.BackgroundTransparency = 1
    TextLabel.ZIndex = 3
    TextLabel.Size = UDim2.new(0.56, 0, 1, -1)

    local ExtraBold = Enum.FontWeight.ExtraBold

    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", ExtraBold)
    TextLabel.TextSize = 17
    TextLabel.TextColor3 = v2
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.AutoLocalize = false
    TextLabel.Text = "0"
    TextLabel.Parent = CanvasGroup

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "Unit"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.ZIndex = 3
    TextLabel2.Position = UDim2.fromScale(0.56, 0)
    TextLabel2.Size = UDim2.new(0.43999999999999995, 0, 1, -1)

    local Bold = Enum.FontWeight.Bold

    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Bold)
    TextLabel2.TextSize = 8
    TextLabel2.TextColor3 = v2
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel2.AutoLocalize = false
    TextLabel2.Text = "KM/H"
    TextLabel2.Parent = CanvasGroup
    p90.chip = {
        brakeW = 0,
        gasW = 0,
        gui = BillboardGui,
        body = CanvasGroup,
        value = TextLabel,
        brake = v167,
        gas = v168
    }

    return p90.chip
end

local function bikeKph(p91, p92) -- line: 808
    -- upvalues: RunService (copy), Config (copy), v165 (ref)
    if v165 == nil and RunService:IsClient() then
        local _require = require
        local Parent = script.Parent
        local ok, result = pcall(_require, Parent:FindFirstChild("RemoteBikes"))

        v165 = ok and result or false
    end

    local v169 = v165 and v165.Velocity(p91.UserId)

    if v169 then
        return Vector3.new(v169.X, 0, v169.Z).Magnitude * (Config.StudMetres or 0.28) * 3.6
    end

    local SpeedKph = p92:GetAttribute("SpeedKph")

    if typeof(SpeedKph) ~= "number" then
        local v170 = p92.PrimaryPart and p92.PrimaryPart.AssemblyLinearVelocity or Vector3.new(0, 0, 0)

        SpeedKph = Vector3.new(v170.X, 0, v170.Z).Magnitude * (Config.StudMetres or 0.28) * 3.6
    end

    return SpeedKph * (Config.DisplayKphScale or 1)
end

local function updateChip(p93, p94, p95) -- line: 819
    -- upvalues: t1 (copy), buildChip (copy), bikeKph (copy)
    local SpeedChip = t1.SpeedChip
    local v171 = p95 / math.max(SpeedChip.FadeTime, 0.01)

    p93.chipA = p93.chipA or 0

    local v172 = p93.chipTarget > p93.chipA
    local v173 = if v172 then math.min(1, p93.chipA + v171) else nil

    p93.chipA = if not v172 or not v173 then math.max(0, p93.chipA - v171) else v173

    local chipA = p93.chipA
    local v176 = chipA * chipA * (3 - 2 * chipA)
    local tag = p93.tag

    if tag then
        local v177 = math.max(1, tag.Size.Y.Offset)
        local v178 = (SpeedChip.Height / 2 + SpeedChip.Gap + v177 / 2) / v177 * v176
        local v179 = Vector2.new(0, v178)

        if tag.SizeOffset ~= v179 then
            tag.SizeOffset = v179
        end
    end

    if chipA <= 0 then
        if p93.chip and p93.chip.gui.Enabled then
            p93.chip.gui.Enabled = false
        end

        p93.kph = nil
    else
        local v180 = p93.chip or buildChip(p93)

        if v180.gui.Adornee ~= p93.part then
            v180.gui.Adornee = p93.part
        end

        if v180.gui.Parent then
            if not v180.gui.Enabled then
                v180.gui.Enabled = true
            end

            v180.body.GroupTransparency = 1 - v176
            v180.body.Position = UDim2.fromOffset(0, 6 * (1 - v176))

            local bike = p93.bike

            if bike and bike.Parent then
                local v181 = bikeKph(p94, bike)

                p93.kph = p93.kph and p93.kph + (v181 - p93.kph) * (1 - math.exp(-p95 * SpeedChip.Response)) or v181

                local v187 = tostring((math.max(0, (math.floor(p93.kph + 0.5)))))

                if v180.value.Text ~= v187 then
                    v180.value.Text = v187
                end

                local v189 = math.clamp(tonumber(bike:GetAttribute("Brake")) or 0, 0, 1)
                local v191 = math.clamp(tonumber(bike:GetAttribute("Throttle")) or 0, 0, 1)

                v180.brakeW = v180.brakeW + (v189 - v180.brakeW) * (1 - math.exp(-p95 * 20))
                v180.gasW = v180.gasW + (v191 - v180.gasW) * (1 - math.exp(-p95 * 18))

                local function shown(p96) -- line: 856
                    if p96 >= 0.96 then
                        return 1
                    end

                    if p96 < 0.01 then
                        return 0
                    end

                    return p96
                end

                local brake = v180.brake
                local fromScale = UDim2.fromScale
                local brakeW2 = v180.brakeW

                if brakeW2 >= 0.96 then
                    brakeW2 = 1
                elseif brakeW2 < 0.01 then
                    brakeW2 = 0
                end

                brake.Size = fromScale(0.56 * brakeW2, 1)

                local gas = v180.gas
                local fromScale2 = UDim2.fromScale
                local gasW2 = v180.gasW

                if gasW2 >= 0.96 then
                    gasW2 = 1
                elseif gasW2 < 0.01 then
                    gasW2 = 0
                end

                gas.Size = fromScale2(0.43999999999999995 * gasW2, 1)
            end
        else
            p93.chip = nil
        end
    end
end

function t1.Follow(p97) -- line: 861
    -- upvalues: t1 (copy), t20 (copy), Config (copy), BikeDynamics (copy), anchorPart (copy), findTag (copy), setOpacity (copy), n1 (ref), spectateState (copy), bikeKph (copy), updateChip (copy)
    local v196 = math.clamp(p97 or 0, 0, 0.1)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local v197, v198, v199 = spectateState(LocalPlayer)

    v198 = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")

    local SpeedChip = v198 and v198:FindFirstChild("JerezRaceHUD")
    local SpectateTargetId = SpeedChip and SpeedChip:GetAttribute("SpectateTargetId") or nil

    SpeedChip = t1.SpeedChip

    local v200, v201

    if v197 and SpeedChip.CamModes[v199 or -1] then
        local v202 = n1 + v196

        if v202 then
            v200 = v202
            v201 = true
        else
            v201 = false
        end
    else
        v201 = false
    end

    if not v201 then
        v200 = 0
    end

    n1 = v200
    v200 = n1 >= SpeedChip.Delay

    local t22 = {}
    local t23 = {}
    local Rotation = LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local v204 = not v197
    local v205, v206, v207

    if v204 then
        if LocalPlayer ~= nil then
            v205 = Rotation and Rotation.SeatPart
            v206 = v205 and v205:FindFirstAncestorOfClass("Model")

            if not v206 or v205.Name ~= "RiderSeat" or v206:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId or not v206.PrimaryPart then
                v206 = nil
            end

            v207 = v206 ~= nil
        else
            v207 = false
        end
    else
        v207 = v204
    end

    local Position, v208, v209

    for _, player in Players:GetPlayers() do
        Rotation = player.Character

        local v210

        if Rotation then
            v208 = Rotation:FindFirstChild("Head")
            v209 = Rotation:FindFirstChildOfClass("Humanoid")
            v210 = Rotation:FindFirstChild("HumanoidRootPart")
        else
            v210 = Rotation
            v208 = Rotation
            v209 = Rotation
        end

        local v211 = v208 and findTag(v208)

        if v211 and v209 then
            if v210 then
                t22[player] = true

                local v212 = t20[player]

                v212 = v212 or {}
                t20[player] = v212
                v212.part = anchorPart(player)

                local v213 = v209.SeatPart
                local CurrentCamera = v213 and v213:FindFirstAncestorOfClass("Model")

                if not CurrentCamera or v213.Name ~= "RiderSeat" or CurrentCamera:GetAttribute("OwnerUserId") ~= player.UserId or not CurrentCamera.PrimaryPart then
                    CurrentCamera = nil
                end

                v212.bike = CurrentCamera

                if CurrentCamera then
                    v210 = CurrentCamera.PrimaryPart or v210
                end

                if v212.character ~= Rotation then
                    v212.character = Rotation
                    v212.footHeight = nil
                end

                Position = v210.Position

                local v214, v215, v216, v217

                if CurrentCamera then
                    Rotation = v210.CFrame.Rotation
                    CurrentCamera = CFrame.Angles
                    v217 = -v210.CFrame.LookVector.X
                    v214 = -v210.CFrame.LookVector.Z
                    CurrentCamera = CurrentCamera(0, math.atan2(v217, v214), 0)

                    local function support(p98) -- line: 897
                        -- upvalues: Config (copy), BikeDynamics (copy)
                        return (math.max(BikeDynamics.SupportHeight(p98, Config.FrontAxle, Config.FrontWheelRadius, Config.FrontTyreHalfWidth), BikeDynamics.SupportHeight(p98, Config.RearAxle, Config.RearWheelRadius, Config.RearTyreHalfWidth)))
                    end

                    local v221 = 4.4 + t1.ExtraHeight + math.max(BikeDynamics.SupportHeight(CurrentCamera, Config.FrontAxle, Config.FrontWheelRadius, Config.FrontTyreHalfWidth), BikeDynamics.SupportHeight(CurrentCamera, Config.RearAxle, Config.RearWheelRadius, Config.RearTyreHalfWidth))

                    v215 = BikeDynamics.SupportHeight(Rotation, Config.FrontAxle, Config.FrontWheelRadius, Config.FrontTyreHalfWidth)
                    v213 = Position + Vector3.new(0, 1, 0) * (v221 - math.max(v215, BikeDynamics.SupportHeight(Rotation, Config.RearAxle, Config.RearWheelRadius, Config.RearTyreHalfWidth)))
                else
                    CurrentCamera = v212.footHeight

                    if not CurrentCamera then
                        v216 = v208.Position.Y - v210.Position.Y
                        CurrentCamera = math.clamp(v216, -1, 3) + 2.1
                    end

                    v212.footHeight = CurrentCamera
                    v213 = Position + Vector3.new(0, 1, 0) * (v212.footHeight + t1.ExtraHeight)
                end

                v212.last = v213
                v212.part.CFrame = CFrame.new(v213)
                CurrentCamera = player:GetAttribute("NametagPosition")

                local ViewRange = v211:FindFirstChild("Panel") and v211.Panel:FindFirstChild("Flag")

                v209 = ViewRange ~= nil and v211:GetAttribute("FlagX") ~= nil and ViewRange.Position.X.Offset ~= v211:GetAttribute("FlagX")

                if v212.posShown == CurrentCamera and v212.posTag == v211 and v212.posSize == v211.Size then
                    if v209 then
                        t1.SetPosition(v211, CurrentCamera)
                        t1.Layout(v211)
                        v212.posShown = CurrentCamera
                        v212.posTag = v211
                        v212.posSize = v211.Size
                    end
                else
                    t1.SetPosition(v211, CurrentCamera)

                    if v209 then
                        t1.Layout(v211)
                    end

                    v212.posShown = CurrentCamera
                    v212.posTag = v211
                    v212.posSize = v211.Size
                end

                for _, child in v208:GetChildren() do
                    if child ~= v211 and child.Name == "RaceNametag" and child:IsA("BillboardGui") and child.Enabled then
                        child.Enabled = false
                    end
                end

                CurrentCamera = v212.scaleTag

                if CurrentCamera ~= v211 then
                    CurrentCamera = v211:FindFirstChild("Panel")

                    if CurrentCamera then
                        ViewRange = CurrentCamera:FindFirstChild("PressScale") or Instance.new("UIScale")
                        ViewRange.Name = "PressScale"
                        ViewRange.Scale = t1.TagScale
                        ViewRange.Parent = CurrentCamera
                        CurrentCamera:SetAttribute("BaseScale", t1.TagScale)
                        v212.scaleTag = v211
                    end
                end

                CurrentCamera = player:GetAttribute("StaffRole")
                ViewRange = v212.roleShown

                local v222

                if ViewRange == CurrentCamera then
                    ViewRange = v212.roleTag

                    if ViewRange ~= v211 then
                        ViewRange, v222, v216 = t1.SetRole(v211, CurrentCamera)
                        v212.roleShine = ViewRange
                        v212.roleGlow = v222
                        v212.roleFx = v216
                        v212.roleShown = CurrentCamera
                        v212.roleTag = v211
                        v212.applied = nil
                    end
                else
                    ViewRange, v222, v216 = t1.SetRole(v211, CurrentCamera)
                    v212.roleShine = ViewRange
                    v212.roleGlow = v222
                    v212.roleFx = v216
                    v212.roleShown = CurrentCamera
                    v212.roleTag = v211
                    v212.applied = nil
                end

                if v211.Adornee ~= v212.part then
                    v211.Adornee = v212.part
                end

                if v211.StudsOffsetWorldSpace ~= Vector3.new(0, 0, 0) then
                    v211.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
                end

                if v211.StudsOffset ~= Vector3.new(0, 0, 0) then
                    v211.StudsOffset = Vector3.new(0, 0, 0)
                end

                if v211.MaxDistance ~= 1e999 then
                    v211.MaxDistance = 1e999
                end

                ViewRange = v211:GetAttribute("ViewRange") or t1.MaxDistance

                if v207 then
                    v216 = t1.RidingMaxDistance
                    ViewRange = math.min(ViewRange, v216)
                end

                if v197 then
                    v222 = t1.FarCamModes
                    v216 = v199 or -1

                    if not v222[v216] then
                        v216 = t1.RidingMaxDistance
                        ViewRange = math.min(ViewRange, v216)
                    end
                end

                v208 = v197 and t1.NoTagCamModes[v199 or -1] == true

                if v208 then
                    ViewRange = 0
                end

                if v197 then
                    v222 = t1.SpectateCamRange
                    v216 = v199 or -1

                    if v222[v216] then
                        v216 = t1.SpectateCamRange[v199]
                        ViewRange = math.min(ViewRange, v216)
                    end
                end

                CurrentCamera = workspace.CurrentCamera
                v222 = CurrentCamera and (CurrentCamera.CFrame.Position - v213).Magnitude or 1e999

                if v197 then
                    v216 = not v208

                    if v216 then
                        v216 = SpectateTargetId ~= nil and player.UserId == SpectateTargetId
                    end
                else
                    v216 = v197
                end

                if v222 <= ViewRange or v216 then
                    v214 = t1.Hidden

                    if v214 then
                        v212.target = 0
                    else
                        v208 = t1.BubbleHide[player.UserId]

                        if v208 and v208 <= os.clock() then
                            v214 = false
                            t1.BubbleHide[player.UserId] = nil
                        else
                            v214 = v208 ~= nil
                        end

                        if v214 then
                            v212.target = 0
                        else
                            v212.target = 1
                        end
                    end
                else
                    v212.target = 0
                end

                v217 = v212.target

                if v217 == 1 and player ~= LocalPlayer then
                    v217 = CurrentCamera and CurrentCamera:WorldToViewportPoint(v213)
                    CurrentCamera = CurrentCamera and CurrentCamera.ViewportSize
                    v214 = v217 ~= nil and v217.Z > 0 and v217.X >= -t1.ScreenMargin and v217.X <= CurrentCamera.X + t1.ScreenMargin and v217.Y >= -t1.ScreenMargin and v217.Y <= CurrentCamera.Y + t1.ScreenMargin
                    v217 = if v197 and v212.bike == nil then 1E+07 else 0

                    if v214 then
                        v215 = {
                            rec = v212
                        }

                        if v216 then
                            v215.score = (-1e999)
                        else
                            v215.score = v222 * (v212.shown and t1.KeepBias or 1) + v217
                        end

                        table.insert(t23, v215)
                    else
                        v212.target = 0
                    end
                end

                if v212.tag ~= v211 then
                    if v212.tag and v212.tag.Parent then
                        v212.tag.SizeOffset = Vector2.zero
                    end

                    v212.tag = v211
                    v212.alpha = nil
                    v212.applied = nil
                end
            elseif v208 then
                t22[player] = true

                local v223 = t20[player]

                v223 = v223 or {}
                t20[player] = v223
                v223.part = anchorPart(player)

                local v224 = v209.SeatPart
                local CurrentCamera = v224 and v224:FindFirstAncestorOfClass("Model")

                if not CurrentCamera or v224.Name ~= "RiderSeat" or CurrentCamera:GetAttribute("OwnerUserId") ~= player.UserId or not CurrentCamera.PrimaryPart then
                    CurrentCamera = nil
                end

                v223.bike = CurrentCamera
                v210 = CurrentCamera and CurrentCamera.PrimaryPart or v208

                if v223.character ~= Rotation then
                    v223.character = Rotation
                    v223.footHeight = nil
                end

                Position = v210.Position

                local v225, v226, v227, v228

                if CurrentCamera then
                    Rotation = v210.CFrame.Rotation
                    CurrentCamera = CFrame.Angles
                    v228 = -v210.CFrame.LookVector.X
                    v225 = -v210.CFrame.LookVector.Z
                    CurrentCamera = CurrentCamera(0, math.atan2(v228, v225), 0)

                    local function support(p99) -- line: 897
                        -- upvalues: Config (copy), BikeDynamics (copy)
                        return (math.max(BikeDynamics.SupportHeight(p99, Config.FrontAxle, Config.FrontWheelRadius, Config.FrontTyreHalfWidth), BikeDynamics.SupportHeight(p99, Config.RearAxle, Config.RearWheelRadius, Config.RearTyreHalfWidth)))
                    end

                    local v232 = 4.4 + t1.ExtraHeight + math.max(BikeDynamics.SupportHeight(CurrentCamera, Config.FrontAxle, Config.FrontWheelRadius, Config.FrontTyreHalfWidth), BikeDynamics.SupportHeight(CurrentCamera, Config.RearAxle, Config.RearWheelRadius, Config.RearTyreHalfWidth))

                    v226 = BikeDynamics.SupportHeight(Rotation, Config.FrontAxle, Config.FrontWheelRadius, Config.FrontTyreHalfWidth)
                    v224 = Position + Vector3.new(0, 1, 0) * (v232 - math.max(v226, BikeDynamics.SupportHeight(Rotation, Config.RearAxle, Config.RearWheelRadius, Config.RearTyreHalfWidth)))
                else
                    CurrentCamera = v223.footHeight

                    if not CurrentCamera then
                        v227 = v208.Position.Y - v210.Position.Y
                        CurrentCamera = math.clamp(v227, -1, 3) + 2.1
                    end

                    v223.footHeight = CurrentCamera
                    v224 = Position + Vector3.new(0, 1, 0) * (v223.footHeight + t1.ExtraHeight)
                end

                v223.last = v224
                v223.part.CFrame = CFrame.new(v224)
                CurrentCamera = player:GetAttribute("NametagPosition")

                local ViewRange = v211:FindFirstChild("Panel") and v211.Panel:FindFirstChild("Flag")

                v209 = ViewRange ~= nil and v211:GetAttribute("FlagX") ~= nil and ViewRange.Position.X.Offset ~= v211:GetAttribute("FlagX")

                if v223.posShown == CurrentCamera and v223.posTag == v211 and v223.posSize == v211.Size then
                    if v209 then
                        t1.SetPosition(v211, CurrentCamera)
                        t1.Layout(v211)
                        v223.posShown = CurrentCamera
                        v223.posTag = v211
                        v223.posSize = v211.Size
                    end
                else
                    t1.SetPosition(v211, CurrentCamera)

                    if v209 then
                        t1.Layout(v211)
                    end

                    v223.posShown = CurrentCamera
                    v223.posTag = v211
                    v223.posSize = v211.Size
                end

                for _, child in v208:GetChildren() do
                    if child ~= v211 and child.Name == "RaceNametag" and child:IsA("BillboardGui") and child.Enabled then
                        child.Enabled = false
                    end
                end

                CurrentCamera = v223.scaleTag

                if CurrentCamera ~= v211 then
                    CurrentCamera = v211:FindFirstChild("Panel")

                    if CurrentCamera then
                        ViewRange = CurrentCamera:FindFirstChild("PressScale") or Instance.new("UIScale")
                        ViewRange.Name = "PressScale"
                        ViewRange.Scale = t1.TagScale
                        ViewRange.Parent = CurrentCamera
                        CurrentCamera:SetAttribute("BaseScale", t1.TagScale)
                        v223.scaleTag = v211
                    end
                end

                CurrentCamera = player:GetAttribute("StaffRole")
                ViewRange = v223.roleShown

                local v233

                if ViewRange == CurrentCamera then
                    ViewRange = v223.roleTag

                    if ViewRange ~= v211 then
                        ViewRange, v233, v227 = t1.SetRole(v211, CurrentCamera)
                        v223.roleShine = ViewRange
                        v223.roleGlow = v233
                        v223.roleFx = v227
                        v223.roleShown = CurrentCamera
                        v223.roleTag = v211
                        v223.applied = nil
                    end
                else
                    ViewRange, v233, v227 = t1.SetRole(v211, CurrentCamera)
                    v223.roleShine = ViewRange
                    v223.roleGlow = v233
                    v223.roleFx = v227
                    v223.roleShown = CurrentCamera
                    v223.roleTag = v211
                    v223.applied = nil
                end

                if v211.Adornee ~= v223.part then
                    v211.Adornee = v223.part
                end

                if v211.StudsOffsetWorldSpace ~= Vector3.new(0, 0, 0) then
                    v211.StudsOffsetWorldSpace = Vector3.new(0, 0, 0)
                end

                if v211.StudsOffset ~= Vector3.new(0, 0, 0) then
                    v211.StudsOffset = Vector3.new(0, 0, 0)
                end

                if v211.MaxDistance ~= 1e999 then
                    v211.MaxDistance = 1e999
                end

                ViewRange = v211:GetAttribute("ViewRange") or t1.MaxDistance

                if v207 then
                    v227 = t1.RidingMaxDistance
                    ViewRange = math.min(ViewRange, v227)
                end

                if v197 then
                    v233 = t1.FarCamModes
                    v227 = v199 or -1

                    if not v233[v227] then
                        v227 = t1.RidingMaxDistance
                        ViewRange = math.min(ViewRange, v227)
                    end
                end

                v208 = v197 and t1.NoTagCamModes[v199 or -1] == true

                if v208 then
                    ViewRange = 0
                end

                if v197 then
                    v233 = t1.SpectateCamRange
                    v227 = v199 or -1

                    if v233[v227] then
                        v227 = t1.SpectateCamRange[v199]
                        ViewRange = math.min(ViewRange, v227)
                    end
                end

                CurrentCamera = workspace.CurrentCamera
                v233 = CurrentCamera and (CurrentCamera.CFrame.Position - v224).Magnitude or 1e999

                if v197 then
                    v227 = not v208

                    if v227 then
                        v227 = SpectateTargetId ~= nil and player.UserId == SpectateTargetId
                    end
                else
                    v227 = v197
                end

                if v233 <= ViewRange or v227 then
                    v225 = t1.Hidden

                    if v225 then
                        v223.target = 0
                    else
                        v208 = t1.BubbleHide[player.UserId]

                        if v208 and v208 <= os.clock() then
                            v225 = false
                            t1.BubbleHide[player.UserId] = nil
                        else
                            v225 = v208 ~= nil
                        end

                        if v225 then
                            v223.target = 0
                        else
                            v223.target = 1
                        end
                    end
                else
                    v223.target = 0
                end

                v228 = v223.target

                if v228 == 1 and player ~= LocalPlayer then
                    v228 = CurrentCamera and CurrentCamera:WorldToViewportPoint(v224)
                    CurrentCamera = CurrentCamera and CurrentCamera.ViewportSize
                    v225 = v228 ~= nil and v228.Z > 0 and v228.X >= -t1.ScreenMargin and v228.X <= CurrentCamera.X + t1.ScreenMargin and v228.Y >= -t1.ScreenMargin and v228.Y <= CurrentCamera.Y + t1.ScreenMargin
                    v228 = if v197 and v223.bike == nil then 1E+07 else 0

                    if v225 then
                        v226 = {
                            rec = v223
                        }

                        if v227 then
                            v226.score = (-1e999)
                        else
                            v226.score = v233 * (v223.shown and t1.KeepBias or 1) + v228
                        end

                        table.insert(t23, v226)
                    else
                        v223.target = 0
                    end
                end

                if v223.tag ~= v211 then
                    if v223.tag and v223.tag.Parent then
                        v223.tag.SizeOffset = Vector2.zero
                    end

                    v223.tag = v211
                    v223.alpha = nil
                    v223.applied = nil
                end
            end
        end
    end

    local v234, v235

    if v197 then
        local SpectateMaxShown = t1.SpectateMaxShown

        if SpectateMaxShown then
            v234 = SpectateMaxShown
            v235 = true
        elseif v207 then
            SpectateMaxShown = t1.RidingMaxShown

            if SpectateMaxShown then
                v234 = SpectateMaxShown
                v235 = true
            else
                v235 = false
            end
        else
            v235 = false
        end
    elseif v207 then
        local SpectateMaxShown = t1.RidingMaxShown

        if SpectateMaxShown then
            v234 = SpectateMaxShown
            v235 = true
        else
            v235 = false
        end
    else
        v235 = false
    end

    if not v235 then
        v234 = t1.MaxShown
    end

    table.sort(t23, function(p100, p101) -- line: 974
        return p100.score < p101.score
    end)

    for v236, v237 in t23 do
        v237.rec.target = v236 <= v234 and 1 or 0
    end

    v207 = v196 / math.max(t1.FadeTime, 0.01)

    local elapsed = os.clock()
    local v238 = math.clamp(elapsed % 3 / 1.8, 0, 1)

    v234 = v238 * v238 * (3 - v238 * 2)
    v199 = math.sin(elapsed * 3.2) * 0.5 + 0.5

    for v239, v240 in t20 do
        if t22[v239] and v240.tag then
            if v240.roleShine and v240.roleShine.Parent then
                v240.roleShine.Offset = Vector2.new(v234 * 2.4 + -1.2, 0)
            end

            if v240.roleGlow and v240.roleGlow.Parent then
                t1.StepGlow(v240.roleGlow, elapsed, v199, 1)
            end

            v240.shown = v240.target == 1

            if v240.alpha == nil then
                v240.alpha = v240.target
            end

            if v240.target > v240.alpha then
                v209 = v240.target
                Position = v240.alpha + v207
                v208 = math.min(v209, Position)

                if not v208 then
                    v209 = v240.target
                    Position = v240.alpha - v207
                    v208 = math.max(v209, Position)
                end
            else
                v209 = v240.target
                Position = v240.alpha - v207
                v208 = math.max(v209, Position)
            end

            v240.alpha = v208
            setOpacity(v240.tag, v240)

            if v240.roleFx then
                t1.StepFx(v240.roleFx, elapsed, (v240.alpha or 0) * (v240.tag.Enabled and 1 or 0))
            end

            if not v200 or not v240.bike or not v240.bike.Parent or v239 == LocalPlayer then
                v208 = false
            else
                Players = (v240.bike:GetAttribute("Crash") or "") ~= "" or v239.Character ~= nil and v239.Character:GetAttribute("RaceCrashActive") == true
                v208 = not Players and bikeKph(v239, v240.bike) >= (v240.chipTarget == 1 and SpeedChip.HideBelowKph or SpeedChip.MinKph)
            end

            local v241 = v240.tag ~= nil and v240.tag.Parent ~= nil and v240.tag.Enabled

            if v200 and v241 and v240.target == 1 and v240.alpha >= 0.99 and v208 then
                v240.chipTarget = 1
            else
                v240.chipTarget = 0
            end

            updateChip(v240, v239, v196)
        end
    end

    for v242, v243 in t20 do
        if not t22[v242] then
            if v243.part then
                v243.part:Destroy()
            end

            if v243.chip then
                v243.chip.gui:Destroy()
            end

            t20[v242] = nil
        end
    end
end

function t1.SyncLocal(p102, p103, p104) -- line: 1010
    -- upvalues: t1 (copy)
    local Character = p102.Character
    local v244, v245

    if Character then
        v244 = Character:FindFirstChild("Head")
        v245 = Character:FindFirstChildOfClass("Humanoid")
    else
        v245 = Character
        v244 = Character
    end

    if not v244 or not v245 then
        return nil
    end

    local child, child2

    for _, child3 in v244:GetChildren() do
        if child3.Name == "RaceNametag" and child3:IsA("BillboardGui") then
            if child3:GetAttribute("LocalFallback") then
                child2 = child3
            else
                child = child3
            end
        end
    end

    if child and child2 then
        child2:Destroy()
        child2 = nil
    end

    local v246 = child or child2

    if not v246 then
        v246 = t1.Create(Character, p102.DisplayName, p102:GetAttribute("NationCode"))

        if not v246 then
            return nil
        end

        v246:SetAttribute("LocalFallback", true)
        v246:SetAttribute("LocalDisplayName", p102.DisplayName)
    end

    if v246:GetAttribute("LocalFallback") then
        if v246:GetAttribute("LocalDisplayName") ~= p102.DisplayName then
            t1.SetName(v246, p102.DisplayName)
            v246:SetAttribute("LocalDisplayName", p102.DisplayName)
        end

        local v247 = t1.CountryCode(p102:GetAttribute("NationCode"))

        if v246:GetAttribute("NationCode") ~= v247 then
            t1.SetNation(v246, v247)
        end

        local v248 = p102:GetAttribute("InputDevice") or "PC"

        if v246:GetAttribute("InputDevice") ~= v248 then
            t1.SetDevice(v246, v248)
        end
    end

    v245.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    t1.UpdateVisibility(v246, p102, v245)
    v246.Enabled = p103 == true
    v246:SetAttribute("ViewRange", p104 and t1.SpectateMaxDistance or t1.MaxDistance)
    v246.AlwaysOnTop = true

    return v246
end

function t1.Remove(p105) -- line: 1046
    -- upvalues: t2 (copy)
    local v249 = t2[p105]

    if not v249 then
        return
    end

    for _, v250 in v249.connections do
        v250:Disconnect()
    end

    if v249.seatConnection then
        v249.seatConnection:Disconnect()
    end

    if v249.anchorConnection then
        v249.anchorConnection:Disconnect()
    end

    t2[p105] = nil
end

function t1.Attach(p106) -- line: 1053
    -- upvalues: LocalizationService (copy), RunService (copy), t1 (copy), t2 (copy)
    if t2[p106] then
        return
    end

    local t24 = {
        connections = {}
    }

    t2[p106] = t24

    local function characterAdded(p107) -- line: 1056
        -- upvalues: p106 (copy), t24 (copy), RunService (copy), t1 (copy), t2 (copy)
        if t24.seatConnection then
            t24.seatConnection:Disconnect()
            t24.seatConnection = nil
        end

        if t24.anchorConnection then
            t24.anchorConnection:Disconnect()
            t24.anchorConnection = nil
        end

        t24.tag = nil
        task.spawn(function() -- line: 1060
            -- upvalues: p107 (copy), p106 (copy), t24 (copy), RunService (copy), t1 (copy), t2 (copy)
            local v251 = p107:WaitForChild("Head", 10)
            local v252 = p107:WaitForChild("Humanoid", 10)

            if t2[p106] ~= t24 or p106.Character ~= p107 or not v251 or not v252 then
                return
            end

            v252.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

            local v253 = t1.Create(p107, p106.DisplayName, p106:GetAttribute("NationCode"))

            t24.tag = v253
            t1.SetDevice(v253, p106:GetAttribute("InputDevice"))
            t24.seatConnection = v252:GetPropertyChangedSignal("SeatPart"):Connect(function() -- line: 1065
                -- upvalues: v252 (copy), v253 (copy), p106 (copy), t1 (copy)
                t1.UpdateVisibility(v253, p106, v252)
            end)
            t1.UpdateVisibility(v253, p106, v252)
            t24.anchorConnection = RunService.Heartbeat:Connect(function() -- line: 1067
                -- upvalues: v252 (copy), v253 (copy), p106 (copy), t1 (copy)
                if v253.Parent and v252.Parent then
                    t1.UpdateVisibility(v253, p106, v252)
                end
            end)
        end)
    end

    table.insert(t24.connections, p106.CharacterAdded:Connect(characterAdded))
    table.insert(t24.connections, p106:GetAttributeChangedSignal("NationCode"):Connect(function() -- line: 1073
        -- upvalues: p106 (copy), t24 (copy), t1 (copy)
        if t24.tag and t24.tag.Parent then
            t1.SetNation(t24.tag, p106:GetAttribute("NationCode"))
        end
    end))
    table.insert(t24.connections, p106:GetAttributeChangedSignal("InputDevice"):Connect(function() -- line: 1076
        -- upvalues: p106 (copy), t24 (copy), t1 (copy)
        if t24.tag and t24.tag.Parent then
            t1.SetDevice(t24.tag, p106:GetAttribute("InputDevice"))
        end
    end))
    table.insert(t24.connections, p106:GetPropertyChangedSignal("DisplayName"):Connect(function() -- line: 1079
        -- upvalues: p106 (copy), t24 (copy), t1 (copy)
        if t24.tag and t24.tag.Parent then
            t1.SetName(t24.tag, p106.DisplayName)
        end
    end))

    if p106.Character then
        characterAdded(p106.Character)
    end

    task.spawn(function() -- line: 1083
        -- upvalues: p106 (copy), t24 (copy), LocalizationService (copy), t1 (copy), t2 (copy)
        local GetCountryRegionForPlayerAsync = LocalizationService.GetCountryRegionForPlayerAsync
        local ok, result = pcall(GetCountryRegionForPlayerAsync, LocalizationService, p106)

        if t2[p106] == t24 and p106.Parent then
            p106:SetAttribute("NationCode", t1.CountryCode(ok and result or nil))
        end
    end)
end

return t1
