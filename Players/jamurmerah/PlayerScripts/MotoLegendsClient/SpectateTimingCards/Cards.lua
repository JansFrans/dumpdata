-- https://lua.expert

local TweenService = game:GetService("TweenService")
local t1 = {
    SETTINGS = {
        MaxCards = 3,
        Width = 176,
        HeaderH = 19,
        BodyH = 50,
        Gap = 6,
        SplitSeconds = 4,
        EstimatedSeconds = 3,
        FlashWordSeconds = 0.5,
        FlashCycles = 2,
        LapSeconds = 6
    }
}
local SETTINGS = t1.SETTINGS

function t1.RowWidth() -- line: 30
    -- upvalues: SETTINGS (copy)
    return SETTINGS.MaxCards * (SETTINGS.Width + SETTINGS.Gap) - SETTINGS.Gap
end

local t2 = {
    header = Color3.fromRGB(10, 11, 15),
    body = Color3.fromRGB(30, 32, 39),
    white = Color3.fromRGB(245, 245, 247),
    grey = Color3.fromRGB(150, 153, 163),
    dim = Color3.fromRGB(64, 68, 78),
    orange = Color3.fromRGB(255, 140, 32),
    red = Color3.fromRGB(255, 58, 44),
    blue = Color3.fromRGB(64, 150, 255),
    flashRed = Color3.fromRGB(230, 40, 28),
    flashOrange = Color3.fromRGB(255, 124, 18)
}
local t3 = {
    num = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
    numB = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
    head = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
    headX = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
}
local Left, Center, Right = Enum.TextXAlignment.Left, Enum.TextXAlignment.Center, Enum.TextXAlignment.Right
local Quart, Quad, Back = Enum.EasingStyle.Quart, Enum.EasingStyle.Quad, Enum.EasingStyle.Back
local Out, In = Enum.EasingDirection.Out, Enum.EasingDirection.In
local t4 = {
    CRASH = { "", "CRASH", "red" },
    PIT = { "", "IN PIT", "grey" },
    OUT = { "", "OUT LAP", "grey" },
    FLAG = { "CHEQUERED", "FLAG", "white" },
    CANCELLED = { "LAP", "CANCELLED", "red" },
    LAST = { "LAST", "FLYING LAP", "white" }
}

local function new(p1, p2, p3) -- line: 57
    local v1 = Instance.new(p1)

    for v2, v3 in p2 do
        v1[v2] = v3
    end

    if p3 then
        v1.Parent = p3
    end

    return v1
end

local function text(p4, p5, p6, p7, p8, p9, p10, p11, p12, p13) -- line: 63
    -- upvalues: Left (copy)
    local t5 = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        ZIndex = 2,
        Name = p5,
        Position = UDim2.fromOffset(p6, p7),
        Size = UDim2.fromOffset(p8, p9),
        FontFace = p10,
        TextSize = p11,
        TextColor3 = p12,
        TextXAlignment = p13 or Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }
    local TextLabel = Instance.new("TextLabel")

    for v4, v5 in t5 do
        TextLabel[v4] = v5
    end

    if p4 then
        TextLabel.Parent = p4
    end

    return TextLabel
end

local function lighten(p14, p15) -- line: 67
    return p14:Lerp(Color3.new(1, 1, 1), p15)
end

local function inkOn(p16) -- line: 68
    -- upvalues: t2 (copy)
    return 0.299 * p16.R + 0.587 * p16.G + 0.114 * p16.B > 0.62 and Color3.fromRGB(12, 14, 20) or t2.white
end

local function flag(p17) -- line: 69
    if typeof(p17) == "string" and #p17 == 2 then
        local v6, v7 = p17:upper():byte(1, 2)

        if not (v6 < 65) and not (v6 > 90) and not (v7 < 65) and not (v7 > 90) then
            return utf8.char(127462 + v6 - 65, 127462 + v7 - 65)
        end
    end

    return ""
end

local function clock(p18, p19) -- line: 75
    local v9 = math.max(0, p18 or 0)

    if p19 then
        local v11 = math.floor(v9 * 10)

        return string.format("%d:%02d.%d", v11 // 600, v11 // 10 % 60, v11 % 10)
    end

    local v13 = math.floor(v9 * 1000 + 0.5)

    return string.format("%d:%02d.%03d", v13 // 60000, v13 // 1000 % 60, v13 % 1000)
end

local function gapText(p20) -- line: 80
    return (if p20 < 0 then "-" else "+") .. string.format("%.3f", (math.abs(p20)))
end

local function sumTo(p21, p22) -- line: 81
    if not p21 then
        return nil
    end

    local n1 = 0

    for i = 1, p22 do
        local v14 = p21[i] or 0

        if v14 <= 0 then
            return nil
        end

        n1 += v14
    end

    return n1
end

local function play(p23, p24, p25, p26, p27, p28) -- line: 89
    -- upvalues: TweenService (copy), Quart (copy), Out (copy)
    local tween = TweenService:Create(p24, TweenInfo.new(p25, p27 or Quart, p28 or Out), p26)

    p23.tweens[tween] = true
    tween.Completed:Once(function() -- line: 92
        -- upvalues: p23 (copy), tween (copy)
        p23.tweens[tween] = nil
    end)
    tween:Play()

    return tween
end

local function stopTweens(p29) -- line: 96
    for v15 in p29.tweens do
        v15:Cancel()
    end

    table.clear(p29.tweens)
end

local function later(p30, p31, p32) -- line: 100
    local gen = p30.gen

    task.delay(p31, function() -- line: 102
        -- upvalues: p30 (copy), p32 (copy), gen (copy)
        if p30.gen == gen and not p30.dead then
            p32()
        end
    end)
end

local function buildBar(p33, p34) -- line: 106
    -- upvalues: SETTINGS (copy), t2 (copy)
    local v16 = (SETTINGS.Width - 10 - 10 - 9) / 4

    p33.barX0 = 10
    p33.segW = v16
    p33.segGap = 3
    p33.barY = p34

    local t6 = {}

    p33.segs = {}
    p33.fills = t6

    for i = 1, 4 do
        local t7 = {
            BorderSizePixel = 0,
            ZIndex = 2,
            Name = "Sector" .. i,
            BackgroundColor3 = t2.dim,
            Position = UDim2.fromOffset(10 + (i - 1) * (v16 + 3), p34 - 1),
            Size = UDim2.fromOffset(v16, 2)
        }
        local frame = p33.frame
        local Frame = Instance.new("Frame")

        for v17, v18 in t7 do
            Frame[v17] = v18
        end

        if frame then
            Frame.Parent = frame
        end

        local fills = p33.fills
        local t8 = {
            Name = "Progress",
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            ZIndex = 3,
            BackgroundColor3 = t2.white,
            Size = UDim2.fromScale(0, 1)
        }
        local Frame2 = Instance.new("Frame")

        for v19, v20 in t8 do
            Frame2[v19] = v20
        end

        if Frame then
            Frame2.Parent = Frame
        end

        fills[i] = Frame2
        p33.segs[i] = Frame
    end

    local t9 = {
        Name = "PoleLap",
        BorderSizePixel = 0,
        ZIndex = 4,
        Visible = false,
        BackgroundColor3 = t2.blue,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(2, 7),
        Position = UDim2.fromOffset(10, p34)
    }
    local frame = p33.frame
    local Frame = Instance.new("Frame")

    for v21, v22 in t9 do
        Frame[v21] = v22
    end

    if frame then
        Frame.Parent = frame
    end

    p33.ghost = Frame

    local t10 = {
        Name = "Rider",
        BorderSizePixel = 0,
        ZIndex = 5,
        Visible = false,
        BackgroundColor3 = t2.white,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(2, 9),
        Position = UDim2.fromOffset(10, p34)
    }
    local frame2 = p33.frame
    local Frame2 = Instance.new("Frame")

    for v23, v24 in t10 do
        Frame2[v23] = v24
    end

    if frame2 then
        Frame2.Parent = frame2
    end

    p33.tick = Frame2
end

local function makePage(p35, p36) -- line: 120
    -- upvalues: SETTINGS (copy), t2 (copy), t3 (copy), Left (copy), Center (copy), Right (copy), t4 (copy), text (copy), buildBar (copy)
    local Width, BodyH = SETTINGS.Width, SETTINGS.BodyH
    local t11 = {
        Name = "Page",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 2,
        Size = UDim2.fromOffset(Width, BodyH)
    }
    local body = p35.body
    local Frame = Instance.new("Frame")

    for v25, v26 in t11 do
        Frame[v25] = v26
    end

    if body then
        Frame.Parent = body
    end

    local v27, v28 = p36:match("^(%a+):?(.*)$")
    local t12 = {
        frame = Frame,
        kind = p36,
        base = v27
    }

    if v27 == "run" then
        t12.small = text(Frame, "LapClock", 6, 4, 70, 12, t3.num, 9, t2.grey)
        t12.big = text(Frame, "Gap", 34, 3, Width - 40, 30, t3.num, 21, t2.white, Right)
        buildBar(t12, 41)
    elseif v27 == "split" then
        t12.big = text(Frame, "SplitTime", 6, 3, Width - 66, 30, t3.num, 19, t2.white, Left)
        t12.small = text(Frame, "Gap", Width - 60, 5, 54, 12, t3.num, 9, t2.white, Right)
        buildBar(t12, 41)
    elseif v27 == "est" then
        t12.small = text(Frame, "Caption", 6, 3, Width - 56, 30, t3.num, 11, t2.white, Left)
        t12.small.Text = "ESTIMATED"
        t12.big = text(Frame, "Position", Width - 50, 1, 44, 33, t3.numB, 25, t2.orange, Right)
        buildBar(t12, 41)
    elseif v27 == "lap" then
        t12.big = text(Frame, "LapTime", 4, 2, Width - 8, 30, t3.numB, 23, t2.white, Center)
        t12.small = text(Frame, "Gap", 24, 33, Width - 48, 12, t3.num, 8, t2.white, Center)
    elseif v27 == "flash" then
        Frame.BackgroundTransparency = 0
        t12.big = text(Frame, "Word", 2, 1, Width - 4, BodyH - 4, t3.numB, 28, t2.white, Center)
    elseif v27 == "two" then
        local v29 = t4[v28] or { "", v28, "white" }

        t12.small = text(Frame, "Top", 0, 6, Width, 12, t3.numB, 10, t2.white, Center)
        t12.small.Text = v29[1]
        t12.big = text(Frame, "Main", 4, v29[1] == "" and 11 or 18, Width - 8, 24, t3.numB, 17, t2[v29[3]], Center)
        t12.big.Text = v29[2]
    end

    return t12
end

local function setPage(p37, p38) -- line: 152
    -- upvalues: TweenService (copy), SETTINGS (copy), Quart (copy), Out (copy), makePage (copy)
    local page = p37.page

    if page and page.kind == p38 then
        return page
    end

    local v30 = makePage(p37, p38)

    p37.page = v30

    if page then
        if p37.state == "open" then
            local BodyH = SETTINGS.BodyH

            v30.frame.Position = UDim2.fromOffset(0, BodyH)
            TweenService:Create(v30.frame, TweenInfo.new(0.26, Quart, Out), {
                Position = UDim2.fromOffset(0, 0)
            }):Play()

            local tween = TweenService:Create(page.frame, TweenInfo.new(0.22, Quart, Out), {
                Position = UDim2.fromOffset(0, -BodyH)
            })

            tween.Completed:Once(function() -- line: 162
                -- upvalues: page (copy)
                page.frame:Destroy()
            end)
            tween:Play()

            return v30
        end

        page.frame:Destroy()
    end

    return v30
end

local function applyHeader(p39, p40) -- line: 169
    -- upvalues: t2 (copy), flag (copy)
    local v31 = p40.teamColor or t2.dim

    p39.team = v31

    local position = p40.position

    p39.pos.Text = position and tostring(position) or ""
    p39.name.Text = tostring(p40.name or ""):upper()
    p39.code.Text = flag(p40.country)
    p39.light.BackgroundColor3 = v31:Lerp(Color3.new(1, 1, 1), 0.55)
end

local function buildCard(p41, p42) -- line: 179
    -- upvalues: SETTINGS (copy), t2 (copy), t3 (copy), Left (copy), Center (copy), text (copy)
    local Width, HeaderH, BodyH = SETTINGS.Width, SETTINGS.HeaderH, SETTINGS.BodyH
    local t13 = {
        gen = 0,
        state = "new",
        eventId = 0,
        userId = p42,
        tweens = {},
        queue = {}
    }
    local t14 = {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Selectable = false,
        Name = "Card_" .. p42,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(Width, HeaderH + BodyH)
    }
    local container = p41.container
    local TextButton = Instance.new("TextButton")

    for v33, v34 in t14 do
        TextButton[v33] = v34
    end

    if container then
        TextButton.Parent = container
    end

    local t15 = {
        Name = "HeaderClip",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = UDim2.fromOffset(0, HeaderH)
    }
    local Frame = Instance.new("Frame")

    for v35, v36 in t15 do
        Frame[v35] = v36
    end

    if TextButton then
        Frame.Parent = TextButton
    end

    local t16 = {
        Name = "Header",
        BackgroundTransparency = 0.03,
        BorderSizePixel = 0,
        BackgroundColor3 = t2.header,
        Size = UDim2.fromOffset(Width, HeaderH)
    }
    local Frame2 = Instance.new("Frame")

    for v37, v38 in t16 do
        Frame2[v37] = v38
    end

    if Frame then
        Frame2.Parent = Frame
    end

    local t17 = {
        Name = "Light",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 1,
        BackgroundColor3 = t2.white,
        Size = UDim2.fromScale(1, 1)
    }
    local Frame3 = Instance.new("Frame")

    for v39, v40 in t17 do
        Frame3[v39] = v40
    end

    if Frame2 then
        Frame3.Parent = Frame2
    end

    t13.light = Frame3
    t13.pos = text(Frame2, "Position", 3, 0, 17, HeaderH, t3.headX, 12, t2.white, Center)
    t13.name = text(Frame2, "Rider", 22, 0, Width - 22 - 24 - 6, HeaderH, t3.head, 11, t2.white, Left)
    t13.name.TextTruncate = Enum.TextTruncate.AtEnd

    local t18 = {
        Name = "Flag",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 2,
        Position = UDim2.fromOffset(Width - 24 - 2, 0),
        Size = UDim2.fromOffset(24, HeaderH)
    }
    local Frame4 = Instance.new("Frame")

    for v41, v42 in t18 do
        Frame4[v41] = v42
    end

    if Frame2 then
        Frame4.Parent = Frame2
    end

    t13.badge = Frame4
    t13.code = text(t13.badge, "Country", 0, 0, 24, HeaderH, t3.head, 15, t2.white, Center)
    t13.code.Font = Enum.Font.SourceSans
    t13.code.ZIndex = 3

    local t19 = {
        Name = "BodyClip",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.fromOffset(0, HeaderH),
        Size = UDim2.fromOffset(Width, 0)
    }
    local Frame5 = Instance.new("Frame")

    for v43, v44 in t19 do
        Frame5[v43] = v44
    end

    if TextButton then
        Frame5.Parent = TextButton
    end

    local t20 = {
        Name = "Body",
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        BackgroundColor3 = t2.body,
        Size = UDim2.fromOffset(Width, BodyH)
    }
    local Frame6 = Instance.new("Frame")

    for v45, v46 in t20 do
        Frame6[v45] = v46
    end

    if Frame5 then
        Frame6.Parent = Frame5
    end

    t13.body = Frame6

    local t21 = {
        Name = "Shade",
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        ZIndex = 8,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Position = UDim2.fromOffset(0, BodyH - 2),
        Size = UDim2.fromOffset(Width, 2)
    }
    local body = t13.body
    local Frame7 = Instance.new("Frame")

    for v47, v48 in t21 do
        Frame7[v47] = v48
    end

    if body then
        Frame7.Parent = body
    end

    local t22 = {
        Name = "HeaderLeft",
        Value = 0
    }
    local NumberValue = Instance.new("NumberValue")

    for v49, v50 in t22 do
        NumberValue[v49] = v50
    end

    if TextButton then
        NumberValue.Parent = TextButton
    end

    t13.L = NumberValue

    local t23 = {
        Name = "HeaderRight",
        Value = 0
    }
    local NumberValue2 = Instance.new("NumberValue")

    for v51, v52 in t23 do
        NumberValue2[v51] = v52
    end

    if TextButton then
        NumberValue2.Parent = TextButton
    end

    t13.R = NumberValue2

    local function wipe() -- line: 199
        -- upvalues: HeaderH (copy), t13 (copy), Frame (copy), Frame2 (copy)
        local Value = t13.L.Value
        local Value2 = t13.R.Value

        Frame.Position = UDim2.fromOffset(Value, 0)
        Frame.Size = UDim2.fromOffset(math.max(0, Value2 - Value), HeaderH)
        Frame2.Position = UDim2.fromOffset(-Value, 0)
    end

    t13.L.Changed:Connect(wipe)
    t13.R.Changed:Connect(wipe)
    wipe()
    t13.root = TextButton
    t13.hclip = Frame
    t13.head = Frame2
    t13.bclip = Frame5
    TextButton.Activated:Connect(function() -- line: 205
        -- upvalues: p41 (copy), t13 (copy)
        if t13.state ~= "closing" and not t13.dead then
            p41:_close(t13)
        end
    end)

    return t13
end

local function spawnAnim(p43) -- line: 209
    -- upvalues: SETTINGS (copy), Quart (copy), Quad (copy), Back (copy), Out (copy), play (copy)
    p43.gen += 1

    for v54 in p43.tweens do
        v54:Cancel()
    end

    table.clear(p43.tweens)
    p43.state = "opening"

    local Width, BodyH = SETTINGS.Width, SETTINGS.BodyH

    p43.L.Value = 0
    p43.R.Value = 0
    p43.light.BackgroundTransparency = 0
    p43.pos.TextTransparency = 1
    p43.name.TextTransparency = 1
    p43.name.Position = UDim2.fromOffset(10, 0)
    p43.badge.Position = UDim2.fromOffset(Width - 24 + 10, 0)
    p43.code.TextTransparency = 1
    p43.bclip.Size = UDim2.fromOffset(Width, 0)
    play(p43, p43.R, 0.2, {
        Value = Width
    }, Quart, Out)

    local function v55() -- line: 220
        -- upvalues: p43 (copy), play (copy)
        play(p43, p43.pos, 0.14, {
            TextTransparency = 0
        })
        play(p43, p43.name, 0.24, {
            TextTransparency = 0,
            Position = UDim2.fromOffset(22, 0)
        })
    end

    local gen = p43.gen

    task.delay(0.05, function() -- line: 102
        -- upvalues: p43 (copy), v55 (copy), gen (copy)
        if p43.gen == gen and not p43.dead then
            v55()
        end
    end)

    local function v56() -- line: 224
        -- upvalues: p43 (copy), Width (copy), Back (copy), Out (copy), play (copy)
        play(p43, p43.badge, 0.26, {
            Position = UDim2.fromOffset(Width - 24 - 2, 0)
        }, Back, Out)
        play(p43, p43.code, 0.2, {
            TextTransparency = 0
        })
    end

    local gen2 = p43.gen

    task.delay(0.12, function() -- line: 102
        -- upvalues: p43 (copy), v56 (copy), gen2 (copy)
        if p43.gen == gen2 and not p43.dead then
            v56()
        end
    end)

    local function v57() -- line: 229
        -- upvalues: p43 (copy), Quad (copy), Out (copy), play (copy)
        play(p43, p43.light, 0.24, {
            BackgroundTransparency = 1
        }, Quad, Out)
    end

    local gen3 = p43.gen

    task.delay(0.26, function() -- line: 102
        -- upvalues: p43 (copy), v57 (copy), gen3 (copy)
        if p43.gen == gen3 and not p43.dead then
            v57()
        end
    end)

    local function v58() -- line: 231
        -- upvalues: p43 (copy), Width (copy), BodyH (copy), Quad (copy), Out (copy), play (copy)
        p43.state = "open"
        play(p43, p43.bclip, 0.18, {
            Size = UDim2.fromOffset(Width, BodyH)
        }, Quad, Out)
    end

    local gen4 = p43.gen

    task.delay(0.44, function() -- line: 102
        -- upvalues: p43 (copy), v58 (copy), gen4 (copy)
        if p43.gen == gen4 and not p43.dead then
            v58()
        end
    end)
end

local function closeAnim(p44, p45) -- line: 237
    -- upvalues: SETTINGS (copy), Quad (copy), In (copy), play (copy)
    p44.gen += 1

    for v59 in p44.tweens do
        v59:Cancel()
    end

    table.clear(p44.tweens)
    p44.state = "closing"

    local Width = SETTINGS.Width

    play(p44, p44.bclip, 0.1, {
        Size = UDim2.fromOffset(Width, 0)
    }, Quad, In)

    local function v60() -- line: 243
        -- upvalues: p44 (copy), Width (copy), Quad (copy), In (copy), play (copy)
        play(p44, p44.L, 0.16, {
            Value = Width - 24 - 4
        }, Quad, In)
    end

    local gen = p44.gen

    task.delay(0.34, function() -- line: 102
        -- upvalues: p44 (copy), v60 (copy), gen (copy)
        if p44.gen == gen and not p44.dead then
            v60()
        end
    end)

    local function v61() -- line: 244
        -- upvalues: p44 (copy), Width (copy), Quad (copy), In (copy), play (copy)
        play(p44, p44.L, 0.1, {
            Value = Width
        }, Quad, In)
    end

    local gen2 = p44.gen

    task.delay(0.52, function() -- line: 102
        -- upvalues: p44 (copy), v61 (copy), gen2 (copy)
        if p44.gen == gen2 and not p44.dead then
            v61()
        end
    end)

    local gen3 = p44.gen

    task.delay(0.64, function() -- line: 102
        -- upvalues: p44 (copy), p45 (copy), gen3 (copy)
        if p44.gen == gen3 and not p44.dead then
            p45()
        end
    end)
end

local function bestOf(p46, p47) -- line: 249
    local best

    for _, v62 in p46 do
        if v62.userId ~= p47 and (v62.best or 0) > 0 and (not best or v62.best < best) then
            best = v62.best
        end
    end

    return best
end

local function push(p48, p49) -- line: 255
    p48.eventId += 1
    p49.id = p48.eventId
    table.insert(p48.queue, p49)
end

local function lapEvent(p50, p51, p52) -- line: 260
    -- upvalues: SETTINGS (copy), t2 (copy), bestOf (copy)
    local last = p51.last
    local v63 = (p51.best or 0) > 0 and math.abs(p51.best - last) < 5E-04
    local v65 = bestOf(p52, p50.userId)
    local v66 = v63 and (not v65 or last <= v65 + 5E-04)
    local v67

    if v66 then
        if v65 then
            v67 = last - v65
        end

        if not v65 or not v67 then
            v67 = nil
        end
    else
        local best = if not ((p51.best or 0) > 0) then v65
            elseif not v65 then p51.best
            elseif p51.best < v65 then p51.best
            else v65

        if best then
            v67 = last - best
        end

        if not best or not v67 then
            v67 = nil
        end
    end

    p50.queue = {}
    p50.cur = nil

    local v68, v69

    if v66 then
        v68 = {
            "FASTEST",
            "LAP"
        } or {
            "BEST",
            "LAP"
        }
        v69 = false
    elseif v63 then
        v68 = {
            "BEST",
            "LAP"
        }
        v69 = false
    else
        v69 = true
    end

    if not v69 then
        for _ = 1, SETTINGS.FlashCycles do
            for _, v70 in v68 do
                local t24 = {
                    kind = "flash",
                    word = v70,
                    color = v66 and t2.flashRed or t2.flashOrange,
                    dur = SETTINGS.FlashWordSeconds
                }

                p50.eventId += 1
                t24.id = p50.eventId
                table.insert(p50.queue, t24)
            end
        end
    end

    local t25 = {
        kind = "lap",
        time = last,
        gap = v67
    }
    local v71, v72

    if v66 then
        local red = t2.red

        if red then
            v71 = red
            v72 = true
        elseif v63 then
            local orange = t2.orange

            if orange then
                v71 = orange
                v72 = true
            else
                v72 = false
            end
        else
            v72 = false
        end
    elseif v63 then
        local orange = t2.orange

        if orange then
            v71 = orange
            v72 = true
        else
            v72 = false
        end
    else
        v72 = false
    end

    t25.color = if not v72 then t2.white else v71
    t25.dur = SETTINGS.LapSeconds
    p50.eventId += 1
    t25.id = p50.eventId
    table.insert(p50.queue, t25)
end

local function splitEvent(p53, p54, p55, p56, p57) -- line: 279
    -- upvalues: SETTINGS (copy), t2 (copy)
    local splits = p54.splits
    local v73

    if splits then
        local n2 = 0
        local v74 = false

        for i = 1, p55 do
            local v75 = splits[i] or 0

            if v75 <= 0 then
                v73 = nil
                v74 = true
                break
            end

            n2 += v75
        end

        if not v74 then
            v73 = n2
        end
    end

    if not v73 then
        return
    end

    local v76

    if p57 and (p57.best or 0) > 0 then
        local bestSplits = p57.bestSplits
        local v77

        if bestSplits then
            local n3 = 0
            local v78 = false

            for i = 1, p55 do
                local v79 = bestSplits[i] or 0

                if v79 <= 0 then
                    v77 = nil
                    v78 = true
                    break
                end

                n3 += v79
            end

            if not v78 then
                v77 = n3
            end
        end

        v76 = v77 or nil
    end

    local v80 = (p54.best or 0) > 0
    local v81

    if v80 then
        local bestSplits = p54.bestSplits

        if bestSplits then
            local n4 = 0
            local v82 = false

            for i = 1, p55 do
                local v83 = bestSplits[i] or 0

                if v83 <= 0 then
                    v81 = nil
                    v82 = true
                    break
                end

                n4 += v83
            end

            if not v82 then
                v81 = n4
            end
        end
    end

    if not v80 or not v81 then
        v81 = nil
    end

    local v84 = v76 and v73 - v76 or nil
    local white = t2.white

    if p54.valid then
        local v85 = if v84 then v84 < 0 else nil

        if not v84 or not v85 then
            local v86 = if v81 then v73 < v81 else nil

            if not v81 or v86 then
                white = t2.orange
            end
        else
            white = t2.red
        end
    end

    p53.lapGap = {
        gap = v84,
        color = white
    }
    p53.queue = {}
    p53.cur = nil

    local t26 = {
        kind = "split",
        time = v73,
        gap = v84,
        color = white,
        dur = SETTINGS.SplitSeconds
    }

    p53.eventId += 1
    t26.id = p53.eventId
    table.insert(p53.queue, t26)

    local v87 = if v81 then p54.best + (v73 - v81) elseif v84 and p57 then p57.best + v84 else nil

    if v87 and p54.valid and ((p54.best or 0) <= 0 or v87 < p54.best) then
        local n5 = 1
        local n6 = 1
        local n7 = 0

        for _, v88 in p56 do
            if (v88.best or 0) > 0 and v88.userId ~= p53.userId then
                n7 += 1

                if v88.best < v87 then
                    n5 += 1
                end

                if (p54.best or 0) > 0 and v88.best < p54.best then
                    n6 += 1
                end
            end
        end

        if (p54.best or 0) <= 0 then
            n6 = n7 + 1
        end

        if n5 < n6 then
            local t27 = {
                kind = "est",
                pos = n5,
                dur = SETTINGS.EstimatedSeconds
            }

            p53.eventId += 1
            t27.id = p53.eventId
            table.insert(p53.queue, t27)
        end
    end
end

local function detect(p58, p59, p60, p61) -- line: 310
    -- upvalues: lapEvent (copy), splitEvent (copy)
    local seen = p58.seen

    if not seen then
        p58.seen = {
            lapStart = p59.lapStart,
            lastFinish = p59.lastFinish,
            splits = table.clone(p59.splits)
        }

        return
    end

    if p59.lastFinish ~= seen.lastFinish then
        local lapStart = seen.lapStart

        seen.lastFinish = p59.lastFinish

        if lapStart > 0 and (p59.last or 0) > 0 and math.abs(p59.last - (p59.lastFinish - lapStart)) < 0.08 then
            lapEvent(p58, p59, p60)
        end
    end

    if p59.lapStart ~= seen.lapStart then
        seen.lapStart = p59.lapStart
        seen.splits = { 0, 0, 0, 0 }
        p58.lapGap = nil

        if p58.cur and (p58.cur.kind == "split" or p58.cur.kind == "est") then
            p58.cur = nil
            p58.queue = {}
        end
    end

    if p59.lapStart > 0 then
        for i = 1, 3 do
            if (p59.splits[i] or 0) > 0 and (seen.splits[i] or 0) <= 0 then
                splitEvent(p58, p59, i, p60, p61)
            end
        end
    end

    seen.splits = table.clone(p59.splits)
end

local function fillBar(p62, p63, p64, p65, p66) -- line: 330
    -- upvalues: t2 (copy), sumTo (copy)
    local v90 = p63.lapStart > 0
    local v91 = if (p63.gate or 1) <= 1 then 4 else math.clamp(p63.gate - 1, 1, 4)
    local v93 = 0

    if v90 then
        local v94 = (p63.bestSectors[v91] or 0) > 0 and p63.bestSectors[v91] or p65 and p65.bestSplits and (p65.bestSplits[v91] or 0) > 0 and p65.bestSplits[v91] or 25

        v93 = math.clamp((p66 - (p63.sectorStart > 0 and p63.sectorStart or p66)) / v94, 0, 0.97)
    end

    for i = 1, 4 do
        local dim = t2.dim
        local v96 = 0

        if v90 then
            local v97 = p63.splits[i] or 0

            if i < v91 and v97 > 0 then
                local v98

                for _, v99 in p64 do
                    local v100 = v99.bestSectors and v99.bestSectors[i] or 0

                    if v100 > 0 and (not v98 or v100 < v98) then
                        v98 = v100
                    end
                end

                if p63.valid then
                    local v101 = if v98 then v97 <= v98 + 5E-04 else nil

                    dim = if v98 and v101 then t2.red elseif not ((p63.bestSectors[i] or 0) > 0 and v97 <= p63.bestSectors[i] + 5E-04) then t2.white else t2.orange
                else
                    dim = t2.grey
                end
            else
                v96 = if i == v91 then v93 else 0
            end
        end

        p62.segs[i].BackgroundColor3 = dim
        p62.fills[i].Size = UDim2.fromScale(v96, 1)
    end

    p62.tick.Visible = v90

    local v102

    if v90 then
        p62.tick.Position = UDim2.fromOffset(p62.barX0 + (v91 - 1) * (p62.segW + p62.segGap) + v93 * p62.segW, p62.barY)

        if p65 and (p65.best or 0) > 0 and sumTo(p65.bestSplits, 4) then
            local v103 = p66 - p63.lapStart
            local n8 = 0

            for i = 1, 4 do
                local v104 = p65.bestSplits[i]

                if v103 < n8 + v104 then
                    v102 = p62.barX0 + (i - 1) * (p62.segW + p62.segGap) + (v103 - n8) / v104 * p62.segW
                    break
                end

                n8 += v104
                v102 = nil
            end
        end
    end

    p62.ghost.Visible = v102 ~= nil

    if v102 then
        p62.ghost.Position = UDim2.fromOffset(v102, p62.barY)
    end
end

local function updateCard(p67, p68, p69, p70, p71, p72, p73) -- line: 369
    -- upvalues: t2 (copy), setPage (copy), applyHeader (copy), detect (copy), fillBar (copy)
    if not p68.position and (p68.best or 0) > 0 then
        local n9 = 1

        for _, v105 in p69 do
            if v105.userId ~= p68.userId and (v105.best or 0) > 0 and v105.best < p68.best then
                n9 += 1
            end
        end

        p68.position = n9
    end

    applyHeader(p67, p68)
    detect(p67, p68, p69, p70)

    if not p68.valid and p67.cur and (p67.cur.kind == "split" or p67.cur.kind == "est") then
        p67.cur = nil
        p67.queue = {}
    end

    if p67.cur and p67.cur.untilT <= p72 then
        p67.cur = nil
    end

    if not p67.cur and #p67.queue > 0 then
        p67.cur = table.remove(p67.queue, 1)
        p67.cur.untilT = p72 + p67.cur.dur
    end

    local cur = p67.cur
    local v107 = setPage(p67, if p68.crashed then "two:CRASH"
        elseif cur then cur.kind .. ":" .. cur.id
        elseif not p68.riding then "two:PIT"
        elseif p68.lapStart <= 0 then if p71 == "QualifyingFinish" then "two:FLAG" else "two:OUT"
        elseif not p68.valid then "two:CANCELLED"
        elseif p71 ~= "QualifyingFinish" or p67.lapGap then "run"
        else "two:LAST")

    if v107.base == "run" then
        local v108 = p73 - p68.lapStart
        local lapGap = p67.lapGap

        if lapGap and lapGap.gap then
            local small = v107.small
            local v111 = math.floor(math.max(0, v108 or 0) * 10)

            small.Text = string.format("%d:%02d.%d", v111 // 600, v111 // 10 % 60, v111 % 10)

            local big = v107.big
            local gap = lapGap.gap

            big.Text = (gap < 0 and "-" or "+") .. string.format("%.3f", (math.abs(gap)))
            v107.big.TextColor3 = lapGap.color
        else
            v107.small.Text = ""

            local big = v107.big
            local v114 = math.floor(math.max(0, v108 or 0) * 10)

            big.Text = string.format("%d:%02d.%d", v114 // 600, v114 // 10 % 60, v114 % 10)
            v107.big.TextColor3 = t2.white
        end

        fillBar(v107, p68, p69, p70, p73)
    elseif v107.base == "split" then
        local big = v107.big
        local v117 = math.floor(math.max(0, cur.time or 0) * 1000 + 0.5)

        big.Text = string.format("%d:%02d.%03d", v117 // 60000, v117 // 1000 % 60, v117 % 1000)
        v107.big.TextColor3 = cur.color

        local small = v107.small
        local v118, v119

        if cur.gap then
            local gap = cur.gap
            local v120 = (if gap < 0 then "-" else "+") .. string.format("%.3f", (math.abs(gap)))

            if v120 then
                v118 = v120
                v119 = true
            else
                v119 = false
            end
        else
            v119 = false
        end

        small.Text = if not v119 then "" else v118
        fillBar(v107, p68, p69, p70, p73)
    elseif v107.base == "est" then
        v107.big.Text = tostring(cur.pos)
        fillBar(v107, p68, p69, p70, p73)
    elseif v107.base == "lap" then
        local big = v107.big
        local v123 = math.floor(math.max(0, cur.time or 0) * 1000 + 0.5)

        big.Text = string.format("%d:%02d.%03d", v123 // 60000, v123 // 1000 % 60, v123 % 1000)
        v107.big.TextColor3 = cur.color

        local small = v107.small
        local v124, v125

        if cur.gap then
            local gap = cur.gap
            local v126 = (if gap < 0 then "-" else "+") .. string.format("%.3f", (math.abs(gap)))

            if v126 then
                v124 = v126
                v125 = true
            else
                v125 = false
            end
        else
            v125 = false
        end

        small.Text = if not v125 then "" else v124
    elseif v107.base == "flash" then
        v107.frame.BackgroundColor3 = cur.color
        v107.big.Text = cur.word
    end
end

function t1.New(p74, p75) -- line: 413
    -- upvalues: TweenService (copy), t1 (copy), SETTINGS (copy), Quart (copy), Out (copy), applyHeader (copy), buildCard (copy), spawnAnim (copy), closeAnim (copy), updateCard (copy)
    local t28 = {
        reader = p75,
        slots = {}
    }
    local t29 = {
        Name = "TimingCards",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 1),
        Size = UDim2.fromOffset(t1.RowWidth(), SETTINGS.HeaderH + SETTINGS.BodyH)
    }
    local Frame = Instance.new("Frame")

    for v127, v128 in t29 do
        Frame[v127] = v128
    end

    if p74 then
        Frame.Parent = p74
    end

    t28.container = Frame

    local t30 = {
        Scale = 1
    }
    local container = t28.container
    local UIScale = Instance.new("UIScale")

    for v129, v130 in t30 do
        UIScale[v129] = v130
    end

    if container then
        UIScale.Parent = container
    end

    t28.scale = UIScale

    local function slotPos(p76) -- line: 420
        -- upvalues: t28 (copy), t1 (copy), SETTINGS (copy)
        local v133 = math.max(1, (math.min(#t28.slots, SETTINGS.MaxCards)))

        return UDim2.fromOffset(t1.RowWidth() / 2 + (p76 - (v133 + 1) / 2) * (SETTINGS.Width + SETTINGS.Gap), (SETTINGS.HeaderH + SETTINGS.BodyH) / 2)
    end

    function t28._layout(p77) -- line: 424
        -- upvalues: slotPos (copy), TweenService (copy), SETTINGS (copy), Quart (copy), Out (copy), spawnAnim (copy)
        for v134, v135 in p77.slots do
            local v136 = slotPos(v134)

            if v135.state == "waiting" then
                if v134 <= SETTINGS.MaxCards then
                    v135.root.Position = v136
                    v135.root.Visible = true
                    v135.placed = true
                    spawnAnim(v135)
                end
            elseif v135.placed then
                if v135.root.Position ~= v136 then
                    if v135.slide then
                        v135.slide:Cancel()
                    end

                    v135.slide = TweenService:Create(v135.root, TweenInfo.new(0.32, Quart, Out), {
                        Position = v136
                    })
                    v135.slide:Play()
                end
            else
                v135.root.Position = v136
                v135.placed = true
            end
        end
    end

    local function remove(p78) -- line: 436
        -- upvalues: t28 (copy)
        p78.dead = true

        local v137 = table.find(t28.slots, p78)

        if v137 then
            table.remove(t28.slots, v137)
        end

        p78.root:Destroy()
        t28:_layout()
    end

    function t28._close(_, p80) -- line: 442
        -- upvalues: t28 (copy), closeAnim (copy)
        if p80.state == "closing" or p80.dead then
            return
        end

        if p80.state ~= "waiting" then
            closeAnim(p80, function() -- line: 445
                -- upvalues: p80 (copy), t28 (copy)
                p80.dead = true

                local v138 = table.find(t28.slots, p80)

                if v138 then
                    table.remove(t28.slots, v138)
                end

                p80.root:Destroy()
                t28:_layout()
            end)

            return
        end

        p80.dead = true

        local v139 = table.find(t28.slots, p80)

        if v139 then
            table.remove(t28.slots, v139)
        end

        p80.root:Destroy()
        t28:_layout()
    end

    function t28.Show(p81, p82) -- line: 448
        -- upvalues: slotPos (copy), SETTINGS (copy), applyHeader (copy), buildCard (copy), spawnAnim (copy)
        for _, v140 in p81.slots do
            if v140.userId == p82 and v140.state ~= "closing" and not v140.dead then
                return v140
            end
        end

        local v141 = buildCard(p81, p82)
        local v142 = p81.reader.rider(p82)

        if v142 then
            applyHeader(v141, v142)
        end

        table.insert(p81.slots, v141)

        local t31 = {}

        for _, v143 in p81.slots do
            if v143.state ~= "closing" then
                table.insert(t31, v143)
            end
        end

        while #t31 > SETTINGS.MaxCards do
            p81:_close(table.remove(t31, 1))
        end

        if #p81.slots <= SETTINGS.MaxCards then
            v141.root.Position = slotPos(#p81.slots)
            v141.placed = true
            spawnAnim(v141)
        else
            v141.state = "waiting"
            v141.root.Visible = false
        end

        p81:_layout()

        return v141
    end

    function t28.Close(p83, p84) -- line: 463
        for _, v144 in p83.slots do
            if v144.userId == p84 then
                p83:_close(v144)
            end
        end
    end

    function t28.CloseAll(p85) -- line: 466
        for _, v145 in table.clone(p85.slots) do
            p85:_close(v145)
        end
    end

    function t28.Count(p86) -- line: 469
        local n10 = 0

        for _, v146 in p86.slots do
            if v146.state ~= "closing" then
                n10 += 1
            end
        end

        return n10
    end

    function t28.Place(p87, p88, p89, p90) -- line: 472
        p87.container.Position = UDim2.fromOffset(p88, p89)
        p87.scale.Scale = p90
    end

    function t28.Update(p91, p92) -- line: 475
        -- upvalues: updateCard (copy)
        if #p91.slots == 0 then
            return
        end

        local elapsed = os.clock()
        local v147 = p91.reader.now()
        local v148 = p91.reader.all()
        local v149

        for _, v150 in v148 do
            if (v150.best or 0) > 0 and (not v149 or v150.best < v149.best) then
                v149 = v150
            end
        end

        for _, v151 in table.clone(p91.slots) do
            if v151.state ~= "closing" and not v151.dead then
                local v152 = p91.reader.rider(v151.userId)

                if v152 then
                    local ok, result = pcall(updateCard, v151, v152, v148, v149, p92, elapsed, v147)

                    if not ok then
                        warn("[SpectateTimingCards] " .. tostring(result))
                    end
                else
                    p91:_close(v151)
                end
            end
        end
    end

    function t28.Destroy(p93) -- line: 492
        p93.container:Destroy()
        p93.slots = {}
    end

    return t28
end

return t1
