-- https://lua.expert

local Parent = script.Parent
local BikeCatalog = require(Parent:WaitForChild("BikeCatalog"))
local LegendRig = require(Parent:WaitForChild("LegendRig"))
local t1 = {
    W = 775,
    H = 800,
    Stride = 52,
    ListH = 316
}
local t2 = {
    heavy = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy),
    bold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
    med = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
}
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.fromRGB(14, 14, 16)
local v3 = Color3.fromRGB(12, 12, 14)

local function new(p1, p2, p3) -- line: 39
    local v4 = Instance.new(p1)

    for v5, v6 in p2 do
        v4[v5] = v6
    end

    for _, v7 in p3 or {} do
        v7.Parent = v4
    end

    return v4
end

local function label(p4, p5) -- line: 45
    -- upvalues: t2 (copy), v1 (copy), new (copy)
    local v8 = new("TextLabel", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        TextSize = 18,
        Text = "",
        TextColor3 = v1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        FontFace = t2.bold
    })

    for v9, v10 in p4 do
        v8[v9] = v10
    end

    for _, v11 in p5 or {} do
        v11.Parent = v8
    end

    return v8
end

local function tint(p6, p7) -- line: 51
    -- upvalues: v1 (copy)
    return p6:Lerp(v1, p7)
end

function t1.Flag(p8) -- line: 54
    if typeof(p8) ~= "string" or not p8:match("^%u%u$") then
        return utf8.char(127937)
    end

    return utf8.char(127462 + p8:byte(1) - 65) .. utf8.char(127462 + p8:byte(2) - 65)
end

function t1.BikeColor(p9) -- line: 59
    -- upvalues: BikeCatalog (copy)
    return BikeCatalog.ColorFor(p9) or BikeCatalog.Teams.Ducati.Color
end

local function thousands(p10) -- line: 62
    return (tostring((math.floor(p10))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

function t1.Format(p11, p12, p13) -- line: 67
    local v13 = tonumber(p12) or 0

    if v13 <= 0 then
        return "-"
    end

    if p11 == "laptime" then
        local v14 = math.floor(v13)

        return string.format("%d:%02d.%03d", v14 // 60000, v14 // 1000 % 60, v14 % 1000)
    end

    if p11 == "robux" then
        return tostring((math.floor(v13))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. string.format("<font size=\"%d\"> R$</font>", p13 or 14)
    end

    return tostring((math.floor(v13))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. string.format("<font size=\"%d\"> PTS</font>", p13 or 14)
end

local function makeCard(p14, p15, p16, p17, p18) -- line: 79
    -- upvalues: t2 (copy), v1 (copy), v3 (copy), new (copy), label (copy)
    local t3 = {
        Frame = new("Frame", {
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Name = "Card" .. p15,
            Position = UDim2.fromOffset(p16, p17),
            Size = UDim2.fromOffset(230, p18),
            BackgroundColor3 = v1
        }),
        Grad = new("UIGradient", {
            Rotation = 115
        })
    }

    t3.Grad.Parent = t3.Frame
    new("Frame", {
        Name = "Shade",
        BorderSizePixel = 0,
        ZIndex = 1,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0)
    }, {
        (new("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.35, 0.85),
                NumberSequenceKeypoint.new(1, 0.05)
            })
        }))
    }).Parent = t3.Frame
    new("Frame", {
        Name = "SideShade",
        BorderSizePixel = 0,
        ZIndex = 1,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0)
    }, {
        (new("UIGradient", {
            Rotation = 0,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.45),
                NumberSequenceKeypoint.new(0.55, 1),
                NumberSequenceKeypoint.new(1, 0.7)
            })
        }))
    }).Parent = t3.Frame
    t3.Num = label({
        Name = "Rank",
        ZIndex = 2,
        Text = tostring(p15),
        FontFace = t2.heavy,
        TextSize = p15 == 1 and 132 or 118,
        Position = UDim2.fromOffset(8, -22),
        Size = UDim2.fromOffset(170, 170),
        TextYAlignment = Enum.TextYAlignment.Top
    })
    t3.Num.Parent = t3.Frame
    t3.Hi = p18 - 86
    t3.View = new("ViewportFrame", {
        BackgroundTransparency = 1,
        LightDirection = Vector3.new(-0.45, -0.7, 1),
        Name = "Avatar" .. p15,
        Position = UDim2.fromOffset(p16 - 40, p17 - 58),
        Size = UDim2.fromOffset(310, t3.Hi + 58),
        ZIndex = p15 == 1 and 4 or 3,
        Ambient = Color3.fromRGB(150, 150, 156),
        LightColor = Color3.fromRGB(255, 250, 240)
    })
    t3.World = new("WorldModel", {})
    t3.World.Parent = t3.View
    t3.Cam = new("Camera", {
        FieldOfView = 30
    })
    t3.Cam.Parent = t3.View
    t3.View.CurrentCamera = t3.Cam
    t3.View.Parent = p14
    t3.ViewBase = t3.View.Position

    local v17 = new("Frame", {
        Name = "Panel",
        BorderSizePixel = 0,
        ZIndex = 4,
        Position = UDim2.new(0, 0, 1, -86),
        Size = UDim2.new(1, 0, 0, 86),
        BackgroundColor3 = v3
    })

    t3.FlagBox = new("Frame", {
        Name = "FlagBox",
        BorderSizePixel = 0,
        ZIndex = 5,
        Position = UDim2.fromOffset(12, 10),
        Size = UDim2.fromOffset(56, 34),
        BackgroundColor3 = v1
    }, {
        (new("UICorner", {
            CornerRadius = UDim.new(0, 3)
        }))
    })
    t3.Flag = label({
        TextSize = 24,
        ZIndex = 6,
        Size = UDim2.fromScale(1, 1),
        TextXAlignment = Enum.TextXAlignment.Center
    })
    t3.Flag.Parent = t3.FlagBox
    t3.FlagBox.Parent = v17
    t3.Value = label({
        Name = "Value",
        TextSize = 30,
        RichText = true,
        ZIndex = 5,
        Position = UDim2.fromOffset(74, 6),
        Size = UDim2.new(1, -86, 0, 38),
        TextXAlignment = Enum.TextXAlignment.Right,
        FontFace = t2.heavy
    })
    t3.Value.Parent = v17
    t3.Display = label({
        Name = "User",
        TextSize = 13,
        ZIndex = 5,
        Position = UDim2.fromOffset(12, 47),
        Size = UDim2.new(1, -24, 0, 15),
        FontFace = t2.med,
        TextColor3 = Color3.fromRGB(205, 205, 210),
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    t3.Display.Parent = v17
    t3.Name = label({
        Name = "RiderName",
        TextSize = 19,
        ZIndex = 5,
        Position = UDim2.fromOffset(12, 61),
        Size = UDim2.new(1, -24, 0, 22),
        FontFace = t2.heavy,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    t3.Name.Parent = v17
    v17.Parent = t3.Frame
    t3.Hit = new("TextButton", {
        Name = "Hit",
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10,
        Size = UDim2.fromScale(1, 1)
    })
    t3.Hit:SetAttribute("NoHover", true)
    t3.Hit.Parent = t3.Frame
    t3.Scale = new("UIScale", {})
    t3.Scale.Parent = t3.Frame
    t3.Hover = new("UIStroke", {
        Name = "Hover",
        Thickness = 4,
        Transparency = 1,
        Color = Color3.fromRGB(220, 35, 45),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    t3.Hover.Parent = t3.Frame
    t3.Frame.Parent = p14
    t3.Base = t3.Frame.Position

    return t3
end

function t1.FillCard(p19, _, p21, p22) -- line: 120
    -- upvalues: t1 (copy), tint (copy)
    local v18 = p21 and t1.BikeColor(p21.b) or Color3.fromRGB(60, 60, 66)

    p19.Grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, tint(v18, 0.25)),
        ColorSequenceKeypoint.new(0.55, v18),
        ColorSequenceKeypoint.new(1, v18:Lerp(Color3.new(0, 0, 0), 0.35))
    })
    p19.FlagBox.BackgroundColor3 = v18
    p19.Flag.Text = p21 and t1.Flag(p21.c) or ""
    p19.Value.Text = p21 and t1.Format(p22, p21.v, 15) or "-"

    local Display = p19.Display

    if p21 then
        Display.Text = "@" .. tostring(p21.n or "") or ""
    else
        Display.Text = ""
    end

    local Name = p19.Name
    local v20, v21

    if p21 then
        local v22 = string.upper((tostring(p21.d or p21.n or "")))

        if v22 then
            v20 = v22
            v21 = true
        else
            v21 = false
        end
    else
        v21 = false
    end

    Name.Text = if not v21 then "NO RIDER YET" else v20
    p19.View.Visible = p21 ~= nil
end

function t1.FrameRig(p23, p24, p25) -- line: 132
    -- upvalues: LegendRig (copy)
    local v23, v24

    if typeof(p25) ~= "string" or p25 == "" then
        v24 = false
    elseif p25 then
        v23 = p25
        v24 = true
    else
        v24 = false
    end

    if not v24 then
        v23 = "Standing"
    end

    p24:PivotTo(CFrame.Angles(0, LegendRig.DisplayYaw(v23), 0))
    LegendRig.PoseAvatar(p24, v23, 0)

    local Head = p24:FindFirstChild("Head")
    local v25 = Head and Head.Position.Y + Head.Size.Y * 0.5 + 0.3 or 2.4
    local v26 = -0.35 * p24:GetScale()
    local v27 = (v25 - v26) / p23.Hi * (p23.Hi + 58)
    local v28 = v26 + v27 / 2
    local v32 = v27 / 2 / math.tan((math.rad(p23.Cam.FieldOfView / 2)))

    p23.Cam.CFrame = CFrame.lookAt(Vector3.new(0, v28 + 0.3, -v32), (Vector3.new(0, v28, 0)))
end

local function flagBox(p26, p27, p28) -- line: 149
    -- upvalues: v1 (copy), new (copy), label (copy)
    local v35 = new("Frame", {
        Name = "FlagBox",
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(p27, p28),
        Size = UDim2.fromOffset(56, 34),
        BackgroundColor3 = v1
    }, {
        (new("UICorner", {
            CornerRadius = UDim.new(0, 3)
        }))
    })
    local v36 = label({
        TextSize = 24,
        Size = UDim2.fromScale(1, 1),
        TextXAlignment = Enum.TextXAlignment.Center
    })

    v36.Parent = v35
    v35.Parent = p26

    return v35, v36
end

function t1.MakeRow(p29) -- line: 157
    -- upvalues: t2 (copy), v3 (copy), new (copy), label (copy), flagBox (copy)
    local t6 = {
        Frame = new("Frame", {
            Name = "Row",
            BorderSizePixel = 0,
            Visible = false,
            Size = UDim2.new(1, -18, 0, 46),
            BackgroundColor3 = v3
        }),
        Hover = new("UIStroke", {
            Name = "Hover",
            Thickness = 3,
            Transparency = 1,
            Color = Color3.fromRGB(220, 35, 45),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
    }

    t6.Hover.Parent = t6.Frame
    t6.Hit = new("TextButton", {
        Name = "Hit",
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10,
        Size = UDim2.fromScale(1, 1)
    })
    t6.Hit:SetAttribute("NoHover", true)
    t6.Hit.Parent = t6.Frame
    t6.Scale = new("UIScale", {})
    t6.Scale.Parent = t6.Frame
    t6.Rank = label({
        Name = "Rank",
        TextScaled = true,
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(0, 60, 1, 0),
        FontFace = t2.heavy
    }, {
        new("UITextSizeConstraint", {
            MaxTextSize = 28
        }),
        (new("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8)
        }))
    })
    t6.Rank.Parent = t6.Frame

    local v37, v38 = flagBox(t6.Frame, 78, 6)

    t6.FlagBox = v37
    t6.Flag = v38
    t6.Name = label({
        Name = "RiderName",
        TextSize = 21,
        Position = UDim2.fromOffset(150, 0),
        Size = UDim2.new(1, -356, 1, 0),
        FontFace = t2.heavy,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    t6.Name.Parent = t6.Frame
    t6.Value = label({
        Name = "Value",
        TextSize = 26,
        RichText = true,
        Position = UDim2.new(1, -206, 0, 0),
        Size = UDim2.new(0, 192, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        FontFace = t2.heavy
    })
    t6.Value.Parent = t6.Frame
    t6.Frame.Parent = p29

    return t6
end

function t1.FillRow(p30, p31, p32, p33) -- line: 174
    -- upvalues: t1 (copy)
    p30.Rank.Text = tostring(p31)

    if p32 then
        p30.FlagBox.BackgroundColor3 = t1.BikeColor(p32.b)
        p30.FlagBox.BackgroundTransparency = 0
        p30.Flag.Text = t1.Flag(p32.c)
        p30.Name.Text = string.upper((tostring(p32.d or p32.n or "")))
        p30.Name.TextTransparency = 0
        p30.Value.Text = t1.Format(p33, p32.v, 14)
    else
        p30.FlagBox.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
        p30.Flag.Text = ""
        p30.Name.Text = ". . ."
        p30.Name.TextTransparency = 0.5
        p30.Value.Text = ""
    end
end

local function makeYou(p34) -- line: 187
    -- upvalues: t2 (copy), v1 (copy), new (copy), label (copy), flagBox (copy)
    local t7 = {
        Frame = new("Frame", {
            Name = "You",
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(28, 730),
            Size = UDim2.new(1, -56, 0, 50),
            BackgroundColor3 = v1
        }, {
            (new("UIGradient", {
                Color = ColorSequence.new(Color3.fromRGB(232, 12, 28), Color3.fromRGB(120, 0, 10))
            }))
        }),
        Hit = new("TextButton", {
            Name = "Hit",
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 10,
            Size = UDim2.fromScale(1, 1)
        })
    }

    t7.Hit:SetAttribute("NoHover", true)
    t7.Hit.Parent = t7.Frame
    t7.Scale = new("UIScale", {})
    t7.Scale.Parent = t7.Frame
    t7.Hover = new("UIStroke", {
        Name = "Hover",
        Thickness = 3,
        Transparency = 1,
        Color = v1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    t7.Hover.Parent = t7.Frame
    t7.Rank = label({
        Name = "Rank",
        TextScaled = true,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(0, 74, 1, 0),
        FontFace = t2.heavy
    }, {
        new("UITextSizeConstraint", {
            MaxTextSize = 28
        }),
        (new("UIPadding", {
            PaddingTop = UDim.new(0, 9),
            PaddingBottom = UDim.new(0, 9)
        }))
    })
    t7.Rank.Parent = t7.Frame

    local v39, v40 = flagBox(t7.Frame, 92, 8)

    t7.FlagBox = v39
    t7.Flag = v40
    new("UIStroke", {
        Thickness = 2,
        Color = v1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }).Parent = t7.FlagBox
    t7.Name = label({
        Name = "RiderName",
        TextSize = 22,
        RichText = true,
        Position = UDim2.fromOffset(164, 0),
        Size = UDim2.new(1, -370, 1, 0),
        FontFace = t2.heavy,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    t7.Name.Parent = t7.Frame
    t7.Value = label({
        Name = "Value",
        TextSize = 26,
        RichText = true,
        Position = UDim2.new(1, -206, 0, 0),
        Size = UDim2.new(0, 192, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        FontFace = t2.heavy
    })
    t7.Value.Parent = t7.Frame
    t7.Support = new("TextButton", {
        Name = "Support",
        BorderSizePixel = 0,
        Text = "SUPPORT",
        TextSize = 17,
        AutoButtonColor = false,
        ZIndex = 12,
        Visible = false,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(124, 34),
        BackgroundColor3 = v1,
        TextColor3 = Color3.fromRGB(200, 10, 24),
        FontFace = t2.heavy
    }, {
        (new("UICorner", {
            CornerRadius = UDim.new(1, 0)
        }))
    })
    t7.Support:SetAttribute("NoHover", true)
    t7.Support.Parent = t7.Frame
    t7.Frame.Parent = p34

    return t7
end

function t1.FillYou(p35, p36, p37) -- line: 214
    -- upvalues: t1 (copy)
    p36 = p36 or {}

    local Rank = p35.Rank
    local v42, v43

    if p36.r then
        local v44 = tostring(p36.r)

        if v44 then
            v42 = v44
            v43 = true
        elseif (p36.plus or 0) > 0 then
            local v45 = p36.plus .. "+"

            if v45 then
                v42 = v45
                v43 = true
            else
                v43 = false
            end
        else
            v43 = false
        end
    elseif (p36.plus or 0) > 0 then
        local v46 = p36.plus .. "+"

        if v46 then
            v42 = v46
            v43 = true
        else
            v43 = false
        end
    else
        v43 = false
    end

    Rank.Text = if not v43 then "-" else v42
    p35.FlagBox.BackgroundColor3 = t1.BikeColor(p36.b)
    p35.Flag.Text = t1.Flag(p36.c)
    p35.Name.Text = p36.n and string.format("YOU <font size=\"14\" color=\"#FFD3D6\">@%s</font>", p36.n) or "YOU"
    p35.Value.Text = t1.Format(p37, p36.v, 14)

    local v47 = p37 == "robux"

    if p35.Support then
        p35.Support.Visible = v47
    end

    p35.Value.Position = UDim2.new(1, v47 and -336 or -206, 0, 0)
    p35.Name.Size = UDim2.new(1, -370 - (v47 and 130 or 0), 1, 0)
end

local t8 = {
    Color3.fromRGB(90, 190, 120),
    Color3.fromRGB(150, 154, 162),
    Color3.fromRGB(205, 127, 50),
    Color3.fromRGB(200, 204, 214),
    Color3.fromRGB(255, 196, 40),
    Color3.fromRGB(232, 12, 28)
}

function t1.BuildSupport(p38) -- line: 232
    -- upvalues: Parent (copy), t2 (copy), v1 (copy), v2 (copy), v3 (copy), new (copy), label (copy), t8 (copy)
    local _require = require
    local ok, result = pcall(_require, Parent:WaitForChild("ShopCatalog"))
    local Support = ok and result.Support or {}
    local v48 = new("Frame", {
        Name = "SupportPanel",
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        Active = true,
        Visible = false,
        ZIndex = 20,
        Position = UDim2.fromOffset(28, 100),
        Size = UDim2.new(1, -56, 0, 620),
        BackgroundColor3 = Color3.fromRGB(6, 6, 8)
    }, {
        (new("UICorner", {
            CornerRadius = UDim.new(0, 10)
        }))
    })

    label({
        Name = "Heading",
        Text = "SUPPORT THE GAME",
        TextSize = 28,
        ZIndex = 21,
        Position = UDim2.fromOffset(110, 12),
        Size = UDim2.new(1, -220, 0, 34),
        FontFace = t2.heavy,
        TextXAlignment = Enum.TextXAlignment.Center
    }).Parent = v48
    label({
        Name = "Sub",
        Text = "EVERY ROBUX COUNTS ON THE TOP SUPPORTERS BOARD",
        TextSize = 14,
        ZIndex = 21,
        Position = UDim2.fromOffset(20, 46),
        Size = UDim2.new(1, -40, 0, 20),
        FontFace = t2.bold,
        TextColor3 = Color3.fromRGB(190, 190, 198),
        TextXAlignment = Enum.TextXAlignment.Center
    }).Parent = v48

    local v49 = new("TextButton", {
        Name = "Back",
        BorderSizePixel = 0,
        Text = "BACK",
        TextSize = 16,
        AutoButtonColor = false,
        ZIndex = 22,
        Position = UDim2.fromOffset(12, 12),
        Size = UDim2.fromOffset(92, 34),
        BackgroundColor3 = v2,
        TextColor3 = v1,
        FontFace = t2.heavy
    }, {
        new("UICorner", {
            CornerRadius = UDim.new(1, 0)
        }),
        (new("UIStroke", {
            Name = "Rim",
            Thickness = 2,
            Transparency = 0.5,
            Color = v1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }))
    })

    v49:SetAttribute("NoHover", true)
    v49.Parent = v48

    local SupportTiers = ok and result.SupportTiers or {}
    local t9 = {
        tiers = SupportTiers,
        marks = {}
    }

    label({
        Name = "YourSupport",
        Text = "YOUR SUPPORT",
        TextSize = 13,
        ZIndex = 21,
        Position = UDim2.fromOffset(24, 70),
        Size = UDim2.fromOffset(200, 16),
        FontFace = t2.bold,
        TextColor3 = Color3.fromRGB(170, 170, 178)
    }).Parent = v48
    t9.value = label({
        Name = "Total",
        Text = "0 R$",
        RichText = true,
        TextSize = 24,
        ZIndex = 21,
        Position = UDim2.fromOffset(24, 84),
        Size = UDim2.fromOffset(300, 26),
        FontFace = t2.heavy
    })
    t9.value.Parent = v48
    t9.next = label({
        Name = "Next",
        Text = "",
        RichText = true,
        TextSize = 15,
        ZIndex = 21,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -24, 0, 86),
        Size = UDim2.fromOffset(380, 22),
        FontFace = t2.bold,
        TextColor3 = Color3.fromRGB(220, 220, 226),
        TextXAlignment = Enum.TextXAlignment.Right
    })
    t9.next.Parent = v48

    local v50 = new("Frame", {
        Name = "Track",
        BorderSizePixel = 0,
        ZIndex = 21,
        Position = UDim2.fromOffset(34, 118),
        Size = UDim2.new(1, -80, 0, 10),
        BackgroundColor3 = Color3.fromRGB(40, 40, 46)
    }, {
        (new("UICorner", {
            CornerRadius = UDim.new(1, 0)
        }))
    })

    v50.Parent = v48
    t9.fill = new("Frame", {
        Name = "Fill",
        BorderSizePixel = 0,
        ZIndex = 22,
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = v1
    }, {
        new("UICorner", {
            CornerRadius = UDim.new(1, 0)
        }),
        (new("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 206, 218)),
                ColorSequenceKeypoint.new(0.34, Color3.fromRGB(255, 200, 30)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(230, 20, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 80, 255))
            })
        }))
    })
    t9.fill.Parent = v50

    for v51, v52 in SupportTiers do
        local v53 = v51 / #SupportTiers
        local v54 = new("Frame", {
            BorderSizePixel = 0,
            ZIndex = 23,
            Name = "Mark" .. v51,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(v53, 0, 0.5, 0),
            Size = UDim2.fromOffset(22, 22),
            BackgroundColor3 = Color3.fromRGB(30, 30, 34)
        }, {
            new("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }),
            (new("UIStroke", {
                Name = "Rim",
                Thickness = 3,
                Color = v52.color
            }))
        })

        v54.Parent = v50

        local t10 = {
            TextSize = 12,
            ZIndex = 23,
            Name = "Tier" .. v51
        }

        t10.AnchorPoint = Vector2.new(v51 == #SupportTiers and 1 or 0.5, 0)
        t10.Position = UDim2.new(v53, v51 == #SupportTiers and 12 or 0, 1, 8)
        t10.Size = UDim2.fromOffset(150, 16)

        local name = v52.name
        local v55

        if v52.robux >= 1000 then
            v55 = v52.robux // 1000 .. "K"

            if not v55 then
                v55 = tostring(v52.robux)
            end
        else
            v55 = tostring(v52.robux)
        end

        t10.Text = name .. " · " .. v55
        t10.FontFace = t2.heavy
        t10.TextColor3 = v52.color
        t10.TextXAlignment = v51 == #SupportTiers and Enum.TextXAlignment.Right or Enum.TextXAlignment.Center

        local v56 = label(t10)

        v56.Parent = v50
        table.insert(t9.marks, {
            dot = v54,
            label = v56,
            tier = v52
        })
    end

    p38.SupportProgress = t9

    local t12 = {}
    local v60 = math.floor((438 - (#Support - 1) * 8) / math.max(1, #Support))

    for v61, v62 in Support do
        local v63 = t8[v61] or v1
        local v64 = new("TextButton", {
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 21,
            Name = "Support" .. v62.Amount,
            Position = UDim2.fromOffset(16, 170 + (v61 - 1) * (v60 + 8)),
            Size = UDim2.new(1, -32, 0, v60),
            BackgroundColor3 = v3
        }, {
            new("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }),
            new("UIStroke", {
                Name = "Hover",
                Thickness = 3,
                Transparency = 1,
                Color = Color3.fromRGB(220, 35, 45),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }),
            (new("UIScale", {
                Name = "Press"
            }))
        })

        v64:SetAttribute("NoHover", true)
        new("Frame", {
            Name = "Tier",
            BorderSizePixel = 0,
            ZIndex = 22,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(0, 10, 1, 0),
            BackgroundColor3 = v63
        }, {
            (new("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }))
        }).Parent = v64
        label({
            Name = "Amount",
            RichText = true,
            TextSize = 30,
            ZIndex = 22,
            Text = tostring((math.floor(v62.Amount))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. "<font size=\"18\"> R$</font>",
            Position = UDim2.fromOffset(30, 0),
            Size = UDim2.new(0.6, 0, 1, 0),
            FontFace = t2.heavy
        }).Parent = v64

        local v67 = new("Frame", {
            Name = "Pill",
            BorderSizePixel = 0,
            ZIndex = 22,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(150, (math.min(44, v60 - 16))),
            BackgroundColor3 = v1
        }, {
            (new("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }))
        })
        local v68 = label({
            Name = "Text",
            Text = "SUPPORT",
            TextSize = 18,
            ZIndex = 23,
            Size = UDim2.fromScale(1, 1),
            TextXAlignment = Enum.TextXAlignment.Center,
            FontFace = t2.heavy,
            TextColor3 = Color3.fromRGB(14, 14, 16)
        })

        v68.Parent = v67
        v67.Parent = v64
        v64.Parent = v48
        table.insert(t12, {
            button = v64,
            product = v62.Product,
            amount = v62.Amount,
            pill = v67,
            pillText = v68
        })
    end

    v48.Parent = p38.Root
    p38.SupportPanel = v48
    p38.SupportBack = v49
    p38.SupportRows = t12

    return v48
end

function t1.SetSupportProgress(p39, p40) -- line: 303
    local SupportProgress = p39.SupportProgress

    if not SupportProgress then
        return
    end

    local v71 = math.max(0, (math.floor(tonumber(p40) or 0)))
    local tiers = SupportProgress.tiers
    local v72 = #tiers
    local n1 = 0
    local n2 = 0

    for v73, v74 in tiers do
        if not (v74.robux <= v71) then
            n2 = (v73 - 1) / v72 + (v71 - n1) / (v74.robux - n1) / v72
            break
        end

        n2 = v73 / v72
        n1 = v74.robux
    end

    SupportProgress.fill.Size = UDim2.fromScale(math.clamp(n2, 0, 1), 1)
    SupportProgress.value.Text = tostring((math.floor(v71))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. "<font size=\"15\"> R$</font>"

    local v76

    for _, v77 in tiers do
        if v71 < v77.robux then
            v76 = v77
            break
        end
    end

    if v76 then
        local v78 = v76.color:ToHex()

        SupportProgress.next.Text = string.format("%s R$ MORE TO <font color=\"#%s\">%s</font>", tostring((math.floor(v76.robux - v71))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""), v78, v76.name)
    else
        SupportProgress.next.Text = "<font color=\"#FFD24A\">ALL SUPPORTER NAMETAGS UNLOCKED</font>"
    end

    for _, v81 in SupportProgress.marks do
        local v82 = v81.tier.robux <= v71

        v81.dot.BackgroundColor3 = v82 and v81.tier.color or Color3.fromRGB(30, 30, 34)
        v81.label.TextTransparency = v82 and 0 or 0.35
    end
end

local v83 = Color3.fromRGB(255, 196, 36)
local v84 = Color3.fromRGB(228, 233, 240)
local v85 = Color3.fromRGB(170, 182, 198)
local v86 = Color3.fromRGB(84, 170, 255)

local function blob(_, p42, p43, p44, p45, p46, p47, p48) -- line: 337
    -- upvalues: new (copy)
    local v87 = if p47 and p47.Offset > 0 then UDim.new(0, p47.Offset * 0.30666666666666664) else p47

    return (new("Frame", {
        BorderSizePixel = 0,
        ZIndex = 8,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(p42 * 0.30666666666666664, p43 * 0.30666666666666664),
        Size = UDim2.fromOffset(p44 * 0.30666666666666664, p45 * 0.30666666666666664),
        BackgroundColor3 = p46,
        Rotation = p48 or 0
    }, {
        (new("UICorner", {
            CornerRadius = v87 or UDim.new(1, 0)
        }))
    }))
end

local function cloud(p49, p50, p51, p52, p53) -- line: 343
    -- upvalues: blob (copy)
    for _, v88 in {
            { 0, 22, 130, 50, 25 },
            { -29, 10, 56, 56 },
            { 9, -8, 78, 78 },
            { 37, 12, 44, 44 }
        } do
        blob(p49, p50 + v88[1] * p52, p51 + v88[2] * p52, v88[3] * p52, v88[4] * p52, p53, v88[5] and UDim.new(0, v88[5] * p52)).Parent = p49
    end
end

local t19 = {
    Sunny = function(p54) -- Sunny | line: 349
        -- upvalues: v83 (copy), blob (copy)
        blob(p54, 75, 75, 66, 66, v83).Parent = p54

        for i = 0, 7 do
            local v89 = math.rad(i * 45)

            blob(p54, math.sin(v89) * 58 + 75, 75 - math.cos(v89) * 58, 12, 28, v83, nil, i * 45).Parent = p54
        end
    end,
    Cloudy = function(p55) -- Cloudy | line: 353
        -- upvalues: v84 (copy), cloud (copy)
        cloud(p55, 75, 70, 1, v84)
    end,
    Rainy = function(p56) -- Rainy | line: 354
        -- upvalues: v85 (copy), v86 (copy), blob (copy), cloud (copy)
        cloud(p56, 75, 50, 0.9, v85)

        for _, v90 in {
                { 56, 110 },
                { 88, 106 },
                { 70, 136 },
                { 102, 132 }
            } do
            blob(p56, v90[1], v90[2] + 3, 16, 16, v86).Parent = p56
            blob(p56, v90[1], v90[2] - 2, 11, 11, v86, UDim.new(0, 2), 45).Parent = p56
        end
    end
}

function t1.SetWeather(p57, p58) -- line: 363
    -- upvalues: t19 (copy)
    local Weather = p57.Weather

    if not Weather or Weather:GetAttribute("Shown") == (p58 or "") then
        return
    end

    Weather:SetAttribute("Shown", p58 or "")
    p57.WeatherArt:ClearAllChildren()

    local v91 = t19[p58 or ""]

    Weather.Visible = v91 ~= nil

    if v91 then
        v91(p57.WeatherArt)
    end
end

function t1.SetHeader(p59, p60, p61, p62, p63) -- line: 375
    -- upvalues: t1 (copy)
    t1.SetWeather(p59, p63)
    p59.Title.Text = p60 or ""

    local v92 = typeof(p61) == "string" and p61 ~= ""

    p59.HeaderFlag.Text = v92 and t1.Flag(p61) or ""
    p59.HeaderFlag.Visible = v92
    p59.PillText.Text = p62 or ""
    p59.Pill.Visible = (p62 or "") ~= ""
end

function t1.Build() -- line: 385
    -- upvalues: t1 (copy), t2 (copy), v1 (copy), v2 (copy), new (copy), label (copy), makeCard (copy), makeYou (copy)
    local v93 = new("SurfaceGui", {
        Name = "CircuitLeaderboard",
        LightInfluence = 0,
        Brightness = 1,
        MaxDistance = 300,
        ResetOnSpawn = false,
        ClipsDescendants = true,
        Face = Enum.NormalId.Front,
        SizingMode = Enum.SurfaceGuiSizingMode.FixedSize,
        CanvasSize = Vector2.new(t1.W, t1.H),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    local v94 = new("Frame", {
        Name = "Root",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1)
    })

    v94.Parent = v93

    local t20 = {
        Gui = v93,
        Root = v94
    }

    t20.Title = label({
        Name = "Title",
        TextSize = 56,
        Position = UDim2.fromOffset(0, 2),
        Size = UDim2.new(1, 0, 0, 60),
        FontFace = t2.heavy,
        TextColor3 = v1,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    t20.Title.Parent = v94

    local v95 = new("Frame", {
        Name = "HeaderRow",
        ZIndex = 6,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 62),
        Size = UDim2.fromOffset(0, 32),
        AutomaticSize = Enum.AutomaticSize.X
    }, {
        (new("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        }))
    })

    t20.Weather = new("Frame", {
        Name = "Weather",
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 7,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(0.5, -170, 0, 33),
        Size = UDim2.fromOffset(56, 56),
        BackgroundColor3 = v2
    }, {
        new("UICorner", {
            CornerRadius = UDim.new(1, 0)
        }),
        (new("UIStroke", {
            Thickness = 2,
            Transparency = 0.5,
            Color = v1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }))
    })
    t20.WeatherArt = new("Frame", {
        Name = "Icon",
        BackgroundTransparency = 1,
        ZIndex = 8,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(46, 46)
    })
    t20.WeatherArt.Parent = t20.Weather
    t20.Weather.Parent = v94

    local function placeBadge() -- line: 405
        -- upvalues: t20 (copy)
        local X = t20.Title.TextBounds.X

        if X > 0 then
            t20.Weather.Position = UDim2.new(0.5, -X / 2 - 14, 0, 33)
        end
    end

    t20.Title:GetPropertyChangedSignal("TextBounds"):Connect(placeBadge)

    local X = t20.Title.TextBounds.X

    if X > 0 then
        t20.Weather.Position = UDim2.new(0.5, -X / 2 - 14, 0, 33)
    end

    t20.HeaderFlag = label({
        Name = "Flag",
        LayoutOrder = 1,
        TextSize = 32,
        Size = UDim2.fromOffset(0, 32),
        AutomaticSize = Enum.AutomaticSize.X,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    t20.HeaderFlag.Parent = v95
    t20.Pill = new("Frame", {
        Name = "Pill",
        LayoutOrder = 2,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = v2
    }, {
        new("UICorner", {
            CornerRadius = UDim.new(1, 0)
        }),
        (new("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12)
        }))
    })
    t20.PillText = label({
        TextSize = 13,
        Size = UDim2.fromOffset(0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        FontFace = t2.bold,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    t20.PillText.Parent = t20.Pill
    t20.Pill.Parent = v95
    v95.Parent = v94

    local function arrow(p64, p65, p66) -- line: 417
        -- upvalues: v94 (copy), v1 (copy), v2 (copy), new (copy)
        local v96 = new("TextButton", {
            Text = "",
            AutoButtonColor = false,
            BorderSizePixel = 0,
            ZIndex = 8,
            Visible = false,
            Name = p64,
            Position = UDim2.fromOffset(p66, 5),
            Size = UDim2.fromOffset(56, 56),
            BackgroundColor3 = v2
        }, {
            new("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }),
            (new("UIStroke", {
                Name = "Rim",
                Thickness = 2,
                Transparency = 0.65,
                Color = v1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }))
        })

        v96:SetAttribute("NoHover", true)

        local v97 = 28 + p65 * 7

        for _, v98 in { -1, 1 } do
            new("Frame", {
                Name = "Arm",
                BorderSizePixel = 0,
                ZIndex = 9,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromOffset(v97 - p65 * 7, 28 + v98 * 7),
                Size = UDim2.fromOffset(22, 5),
                Rotation = -45 * v98 * p65,
                BackgroundColor3 = v1
            }, {
                (new("UICorner", {
                    CornerRadius = UDim.new(1, 0)
                }))
            }).Parent = v96
        end

        v96.Parent = v94

        return v96
    end

    t20.Prev = arrow("Prev", -1, 28)
    t20.Next = arrow("Next", 1, t1.W - 28 - 56)
    t20.Cards = {}

    local v99 = (t1.W - 718) / 2
    local t21 = {}

    t21[2] = v99
    t21[1] = v99 + 230 + 14
    t21[3] = v99 + 488

    for _, v100 in { 2, 3, 1 } do
        local v101 = if v100 == 1 then 104 else 134

        t20.Cards[v100] = makeCard(v94, v100, t21[v100], v101, 390 - v101)
        t1.FillCard(t20.Cards[v100], v100, nil, "points")
    end

    t20.List = new("ScrollingFrame", {
        Name = "List",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        Active = true,
        Position = UDim2.fromOffset(28, 404),
        Size = UDim2.new(1, -56, 0, 316),
        CanvasSize = UDim2.new(),
        ScrollBarImageColor3 = v2,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never
    })
    t20.List.Parent = v94
    t20.Status = label({
        Name = "Status",
        TextSize = 22,
        Visible = false,
        Position = UDim2.fromOffset(28, 404),
        Size = UDim2.new(1, -56, 0, 316),
        FontFace = t2.bold,
        TextColor3 = v1,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    t20.Status.Parent = v94
    t20.You = makeYou(v94)
    t1.FillYou(t20.You, nil, "points")

    return v93, t20
end

return t1
