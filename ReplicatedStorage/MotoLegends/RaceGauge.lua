-- https://lua.expert

local BikeGearbox = require(script.Parent.BikeGearbox)
local v1 = require(script.Parent.Config).DisplayKphScale or 1
local t1 = {
    Width = 229.50000000000003,
    Height = 145.52,
    Keys = { "tcs", "aw", "ebs" },
    Names = {
        tcs = "TCS",
        aw = "AW",
        ebs = "EBS"
    },
    PeakGears = { 1, 2, 3, 4, 5 }
}
local v2 = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold)
local v3 = Color3.fromRGB(255, 255, 255)
local v4 = Color3.fromRGB(255, 65, 34)
local v5 = Color3.fromRGB(195, 255, 0)
local v6 = Color3.fromRGB(236, 39, 49)
local t2 = {
    W = 42,
    H = 37,
    Top = 365,
    Radius = 0.28,
    Shown = 0,
    Dimmed = 0.55
}

t1.AssistBox = t2

local function u(p1) -- line: 26
    return p1 * 0.34
end

local function frame(p2, p3, p4, p5, p6, p7, p8, p9) -- line: 27
    local Frame = Instance.new("Frame")

    Frame.Name = p3
    Frame.Position = UDim2.fromOffset(p4 * 0.34, p5 * 0.34)
    Frame.Size = UDim2.fromOffset(p6 * 0.34, p7 * 0.34)
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = p8 or Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = p9 or 0
    Frame.Parent = p2

    return Frame
end

local function sizeFor(p10) -- line: 31
    return p10 * 0.34 / 0.57
end

local function place(p11, p12, p13, p14, p15) -- line: 33
    local Weight = p11:FindFirstChild("Weight")
    local v7 = Weight and p15 * 0.035 or 0
    local v8 = (p15 - 2 * v7) * 0.34 / 0.57

    p11.TextSize = v8
    p11.Position = UDim2.fromOffset(p12 * 0.34, (p14 + v7) * 0.34 - 0.241 * v8)
    p11.Size = UDim2.fromOffset(p13 * 0.34, v8 * 1.1)

    if Weight then
        Weight.Thickness = v7 * 0.34
    end
end

local function label(p16, p17, p18, p19, p20, p21, p22, p23, p24, p25) -- line: 38
    -- upvalues: v2 (copy), v3 (copy), place (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p17
    TextLabel:SetAttribute("KeepFont", true)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.FontFace = v2
    TextLabel.TextColor3 = p24 or v3
    TextLabel.Text = p18
    TextLabel.TextXAlignment = p23 or Enum.TextXAlignment.Center
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top

    if p25 then
        local UIStroke = Instance.new("UIStroke")

        UIStroke.Name = "Weight"
        UIStroke.Color = TextLabel.TextColor3
        UIStroke.LineJoinMode = Enum.LineJoinMode.Miter
        UIStroke.Parent = TextLabel
    end

    place(TextLabel, p19, p20, p21, p22)
    TextLabel.Parent = p16

    return TextLabel
end

local function tint(p26, p27, p28) -- line: 47
    p26.TextColor3 = p27
    p26.TextTransparency = p28

    local Weight = p26:FindFirstChild("Weight")

    if Weight then
        Weight.Color = p27
        Weight.Transparency = p28
    end
end

local function button(p29, p30, p31, p32, p33, p34) -- line: 51
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p30
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton:SetAttribute("NoHover", true)
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false
    TextButton.Position = UDim2.fromOffset(p31 * 0.34, p32 * 0.34)
    TextButton.Size = UDim2.fromOffset(p33 * 0.34, p34 * 0.34)
    TextButton.Parent = p29

    return TextButton
end

local function triangle(p35, p36, p37, p38, p39, p40) -- line: 57
    -- upvalues: v2 (copy), v3 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p36
    TextLabel:SetAttribute("KeepFont", true)

    local v9 = p40 * 0.34 / 0.658

    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.FontFace = v2
    TextLabel.TextSize = v9
    TextLabel.TextColor3 = v3
    TextLabel.Text = p37
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top
    TextLabel.Position = UDim2.fromOffset((p38 - 30) * 0.34, p39 * 0.34 - 0.209 * v9)
    TextLabel.Size = UDim2.fromOffset(20.400000000000002, v9 * 1.1)
    TextLabel.Parent = p35

    return TextLabel
end

local function fade(p41, p42, p43, p44, p45, p46, p47) -- line: 65
    -- upvalues: frame (copy)
    local v10 = frame(p41, p42, p43, p45 or 281, p47 or 201, p46 or 31, Color3.fromRGB(230, 230, 230))
    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = p44 and 180 or 0
    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.84),
        NumberSequenceKeypoint.new(0.7, 0.72),
        NumberSequenceKeypoint.new(0.8, 0.64),
        NumberSequenceKeypoint.new(0.9, 0.57),
        NumberSequenceKeypoint.new(1, 0.55)
    })
    UIGradient.Parent = v10

    return v10
end

local function lerp(p48, p49, p50) -- line: 72
    return p48 + (p49 - p48) * p50
end

local _ = {
    X = 136,
    Y = 92,
    W = 403,
    H = 177,
    CX = 201.5,
    CY = 88.5,
    Step = 133.952,
    Cap = 92,
    CapSmall = 44.896,
    LabelW = 132.48,
    FadeY = 157,
    FadeH = 46,
    FadeW = 161
}
local _ = {
    CX = 287,
    Step = 80.33288043478261,
    W = 81.52173913043478,
    CapTop = 263.75,
    Cap = 62.5,
    UnitX = 424,
    UnitTop = 279,
    UnitCap = 17
}
local t3 = {
    { 183, 206, 216 },
    { 335.5, 350, 361 },
    { 490, 512, 524 }
}

function t1.New(p51) -- line: 83
    -- upvalues: BikeGearbox (copy), v1 (copy), t1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), t2 (copy), frame (copy), place (copy), label (copy), button (copy), triangle (copy), fade (copy), t3 (copy)
    local t4 = {
        throttle = 0,
        brake = 0,
        gear = 1,
        assistIndex = 1,
        peak = false
    }
    local v11 = frame(p51, "Speedometer", 0, 0, 675, 428, nil, 1)
    local Right = Enum.TextXAlignment.Right
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "LeanAngle"
    TextLabel:SetAttribute("KeepFont", true)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.FontFace = v2
    TextLabel.TextColor3 = v3
    TextLabel.Text = "0°"
    TextLabel.TextXAlignment = Right or Enum.TextXAlignment.Center
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top
    place(TextLabel, 30, 300, 17, 23.5)
    TextLabel.Parent = v11
    t4.angle = TextLabel
    t4.angle.RichText = true

    local Left = Enum.TextXAlignment.Left
    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "RHD"
    TextLabel2:SetAttribute("KeepFont", true)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.BorderSizePixel = 0
    TextLabel2.FontFace = v2
    TextLabel2.TextColor3 = v3
    TextLabel2.Text = "RHD"
    TextLabel2.TextXAlignment = Left or Enum.TextXAlignment.Center
    TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
    place(TextLabel2, 352, 150, 17, 23.5)
    TextLabel2.Parent = v11
    t4.rhdLabel = TextLabel2

    local v12 = frame(v11, "InputBar", 89, 72, 495, 21, Color3.new(0, 0, 0), 0.5)

    t4.brakeFill = frame(v12, "Brake", 248, 0, 0, 21, v4)
    t4.brakeFill.AnchorPoint = Vector2.new(1, 0)
    t4.throttleFill = frame(v12, "Throttle", 248, 0, 0, 21, v5)
    t4.brakeFill.Position = UDim2.fromScale(0.501010101010101, 0)
    t4.throttleFill.Position = UDim2.fromScale(0.501010101010101, 0)

    t4.fill = function(p52, p53, p54) -- line: 96
        p52.Size = UDim2.fromScale(p53 * p54, 1)
    end

    t4.centre = 0.501010101010101
    t4.digits = {}

    for v13, v14 in { -1, 0, 1 } do
        local v15 = 287 + v14 * 80.33288043478261

        t4.digits[v13] = label(v11, "SpeedDigit" .. v13, "0", v15 - 40.76086956521739, 81.52173913043478, 263.75, 62.5, nil, nil, true)
    end

    local Left2 = Enum.TextXAlignment.Left
    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Name = "SpeedUnit"
    TextLabel3:SetAttribute("KeepFont", true)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.BorderSizePixel = 0
    TextLabel3.FontFace = v2
    TextLabel3.TextColor3 = v3
    TextLabel3.Text = "KM/H"
    TextLabel3.TextXAlignment = Left2 or Enum.TextXAlignment.Center
    TextLabel3.TextYAlignment = Enum.TextYAlignment.Top
    place(TextLabel3, 424, 160, 279, 17)
    TextLabel3.Parent = v11
    t4.unit = TextLabel3
    fade(v11, "GearFadeLeft", 0, false, 157, 46, 161)
    fade(v11, "GearFadeRight", 514, true, 157, 46, 161)

    local v16 = frame(v11, "GearReel", 136, 92, 403, 177, nil, 1)

    v16.ClipsDescendants = true
    t4.gears = {}

    for i = 0, 6 do
        local gears = t4.gears
        local v17 = "Gear" .. i
        local v18 = if i == 0 then "N" else tostring(i)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = v17
        TextLabel:SetAttribute("KeepFont", true)
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderSizePixel = 0
        TextLabel.FontFace = v2
        TextLabel.TextColor3 = v3
        TextLabel.Text = v18
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel.TextYAlignment = Enum.TextYAlignment.Top
        place(TextLabel, 0, 132.48, 0, 92)
        TextLabel.Parent = v16
        gears[i] = TextLabel
    end

    t4.assists = {}

    for v19, v20 in t1.Keys do
        local v22, v23, v24 = table.unpack(t3[v19])
        local v25 = "Assist" .. t1.Names[v20]
        local v26 = t1.Names[v20]
        local v27 = v23 - 150
        local Right = Enum.TextXAlignment.Right
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = v25
        TextLabel:SetAttribute("KeepFont", true)
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderSizePixel = 0
        TextLabel.FontFace = v2
        TextLabel.TextColor3 = v3
        TextLabel.Text = v26
        TextLabel.TextXAlignment = Right or Enum.TextXAlignment.Center
        TextLabel.TextYAlignment = Enum.TextYAlignment.Top
        place(TextLabel, v27, 150, 372, 22.5)
        TextLabel.Parent = v11

        local v28 = frame(v11, "Assist" .. t1.Names[v20] .. "ValueBox", v24 + 1, t2.Top, t2.W, t2.H, v6, t2.Shown)

        v28.ZIndex = 1
        Instance.new("UICorner", v28).CornerRadius = UDim.new(t2.Radius, 0)

        local v29 = "Assist" .. t1.Names[v20] .. "Value"
        local v30 = v24 + 1
        local W = t2.W
        local Center = Enum.TextXAlignment.Center
        local TextLabel2 = Instance.new("TextLabel")

        TextLabel2.Name = v29
        TextLabel2:SetAttribute("KeepFont", true)
        TextLabel2.BackgroundTransparency = 1
        TextLabel2.BorderSizePixel = 0
        TextLabel2.FontFace = v2
        TextLabel2.TextColor3 = v3 or v3
        TextLabel2.Text = "-"
        TextLabel2.TextXAlignment = Center or Enum.TextXAlignment.Center
        TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
        place(TextLabel2, v30, W, 372, 22.5)
        TextLabel2.Parent = v11
        TextLabel2.ZIndex = 2

        local v31 = triangle(v11, "Assist" .. t1.Names[v20] .. "Up", "▲", v22, 344, 19)
        local v32 = triangle(v11, "Assist" .. t1.Names[v20] .. "Down", "▼", v22, 408, 19)
        local v33 = button(v11, "Assist" .. t1.Names[v20] .. "Select", v22 - 76, 366, 152, 36)
        local v34 = button(v11, "Assist" .. t1.Names[v20] .. "Increase", v22 - 76, 330, 152, 36)
        local v35 = button(v11, "Assist" .. t1.Names[v20] .. "Decrease", v22 - 76, 402, 152, 26)

        v33.Activated:Connect(function() -- line: 121
            -- upvalues: t4 (copy), v19 (copy)
            if t4.OnAssist then
                t4.OnAssist("set", v19)
            end
        end)
        v34.Activated:Connect(function() -- line: 122
            -- upvalues: t4 (copy), v19 (copy)
            if t4.OnAssist then
                if t4.assistIndex == v19 then
                    t4.OnAssist("change", 1)
                else
                    t4.OnAssist("set", v19)
                end
            end
        end)
        v35.Activated:Connect(function() -- line: 123
            -- upvalues: t4 (copy), v19 (copy)
            if t4.OnAssist then
                if t4.assistIndex == v19 then
                    t4.OnAssist("change", -1)
                else
                    t4.OnAssist("set", v19)
                end
            end
        end)
        t4.assists[v19] = {
            key = v20,
            name = TextLabel,
            value = TextLabel2,
            box = v28,
            up = v31,
            down = v32,
            buttons = { v33, v34, v35 }
        }
    end

    t4.root = v11

    function t4.Select(p55) -- line: 127
        -- upvalues: p51 (copy), t4 (copy), t1 (copy)
        t4.assistIndex = (math.round(p55) - 1) % #t1.Keys + 1
        p51:SetAttribute("AssistSelected", t1.Keys[t4.assistIndex])
    end

    function t4.Update(p56, p57, p58) -- line: 128
        -- upvalues: p51 (copy), t4 (copy), BikeGearbox (copy), v1 (copy), t1 (copy), v3 (copy), v4 (copy), v5 (copy), t2 (copy), place (copy)
        local v36 = math.min(p56, 0.1)
        local v37 = t4.input or p57

        t4.throttle = t4.throttle + (math.clamp(v37.throttle or 0, 0, 1) - t4.throttle) * (1 - math.exp(-v36 * 18))

        local v45 = math.clamp(math.clamp(v37.brake or 0, 0, 1) + math.clamp(v37.rearBrake or 0, 0, 1) * 0.25, 0, 1)

        t4.brake = t4.brake + (v45 - t4.brake) * (1 - math.exp(-v36 * 20))

        local function shown(p59) -- line: 137
            if p59 >= 0.96 then
                return 1
            end

            if p59 < 0.01 then
                return 0
            end

            return p59
        end

        local fill, brakeFill, centre, brake2 = t4.fill, t4.brakeFill, t4.centre, t4.brake

        if brake2 >= 0.96 then
            brake2 = 1
        elseif brake2 < 0.01 then
            brake2 = 0
        end

        fill(brakeFill, centre, brake2)

        local fill2, throttleFill = t4.fill, t4.throttleFill
        local v48 = 1 - t4.centre
        local throttle2 = t4.throttle

        if throttle2 >= 0.96 then
            throttle2 = 1
        elseif throttle2 < 0.01 then
            throttle2 = 0
        end

        fill2(throttleFill, v48, throttle2)

        local v50 = math.clamp(p57.gear or 1, 0, 6)

        t4.gear = t4.gear + (v50 - t4.gear) * (1 - math.exp(-v36 * 18))

        if math.abs(v50 - t4.gear) < 0.001 then
            t4.gear = v50
        end

        for v54, v55 in t4.gears do
            local v56 = v54 - t4.gear
            local v57 = math.abs(v56)

            v55.Visible = v57 < 1.6

            if v55.Visible then
                local v58 = 44.896 + 47.104 * (1 - math.clamp(v57, 0, 1))

                place(v55, 201.5 + v56 * 133.952 - 66.24, 132.48, 88.5 - v58 / 2, v58)

                local v59

                if v57 <= 1 then
                    v59 = v57 * 0.5

                    if not v59 then
                        v59 = math.clamp((v57 - 1) / 0.6 * 0.5 + 0.5, 0, 1)
                    end
                else
                    v59 = math.clamp((v57 - 1) / 0.6 * 0.5 + 0.5, 0, 1)
                end

                v55.TextColor3 = v3
                v55.TextTransparency = v59

                local Weight = v55:FindFirstChild("Weight")

                if Weight then
                    Weight.Color = v3
                    Weight.Transparency = v59
                end
            end
        end

        local v63 = math.max(0, p58 or p57.speed or 0)
        local v64 = math.round(v50)
        local v65 = p57.rpm or BikeGearbox.RPM(v64, v63, p57.throttle or 0, 0)
        local v66 = t4.peak and BikeGearbox.OverRevRPM - 300 or BikeGearbox.OverRevRPM

        t4.peak = table.find(t1.PeakGears, v64) ~= nil and v66 <= v65

        local v68 = t4.peak and v4 or v3
        local v72 = tostring((math.clamp(math.floor(v63 * v1 + 0.5), 0, 999)))

        for v73, v74 in t4.digits do
            local v75 = v73 - (3 - #v72)

            v74.Visible = v75 >= 1

            if v75 >= 1 then
                v74.Text = v72:sub(v75, v75)
            end

            v74.TextColor3 = v68
            v74.TextTransparency = 0

            local Weight = v74:FindFirstChild("Weight")

            if Weight then
                Weight.Color = v68
                Weight.Transparency = 0
            end
        end

        local rhd = t4.rhd

        if rhd == nil then
            rhd = p57.rhd == true
        end

        t4.rhdLabel.TextColor3 = rhd and v5 or v3
        p51:SetAttribute("RHD", rhd)
        t4.angle.Text = string.format("%d<font family=\"%s\">°</font>", math.floor(math.abs((math.deg(p57.lean or 0))) + 0.5), "rbxasset://fonts/families/Montserrat.json")

        local v79 = t4.hideAssists == true

        for v80, v81 in t4.assists do
            v81.name.Visible = not v79
            v81.value.Visible = not v79
            v81.box.Visible = not v79

            for _, v82 in v81.buttons do
                v82.Visible = not v79
            end

            local v83 = v80 == t4.assistIndex and not v79
            local v84 = p57[v81.key]

            v81.value.Text = v84 and tostring(v84) or "-"

            local name = v81.name
            local v85 = if v83 then 0 else 0.5

            name.TextColor3 = v3
            name.TextTransparency = v85

            local Weight = name:FindFirstChild("Weight")

            if Weight then
                Weight.Color = v3
                Weight.Transparency = v85
            end

            local value = v81.value
            local v86 = if v83 then 0 else 0.5

            value.TextColor3 = v3
            value.TextTransparency = v86

            local Weight2 = value:FindFirstChild("Weight")

            if Weight2 then
                Weight2.Color = v3
                Weight2.Transparency = v86
            end

            v81.box.BackgroundTransparency = v83 and t2.Shown or t2.Dimmed
            v81.up.Visible = v83
            v81.down.Visible = v83
        end

        p51:SetAttribute("GearReelPosition", t4.gear)
        p51:SetAttribute("Throttle", t4.throttle)
        p51:SetAttribute("Brake", t4.brake)
        p51:SetAttribute("LeanDegrees", (math.deg(p57.lean or 0)))
        p51:SetAttribute("GearRPM", v65)
        p51:SetAttribute("SpeedPeak", t4.peak)
        p51:SetAttribute("RingRed", t4.peak)
    end

    t4.Select(1)
    t4.Update(0, {
        gear = 1
    }, 0)

    return t4
end

return t1
