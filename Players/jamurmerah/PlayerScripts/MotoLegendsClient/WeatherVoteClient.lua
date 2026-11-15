-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local WeatherVote = MotoLegends:WaitForChild("WeatherVote")
local LocalPlayer = Players.LocalPlayer
local Config = require(MotoLegends:WaitForChild("Config"))
local v1 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v2 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local t1 = {
    "Sunny",
    "Cloudy",
    "Rainy",
    "Dynamic"
}
local t2 = {
    [Enum.KeyCode.One] = 1,
    [Enum.KeyCode.Two] = 2,
    [Enum.KeyCode.Three] = 3,
    [Enum.KeyCode.Four] = 4,
    [Enum.KeyCode.KeypadOne] = 1,
    [Enum.KeyCode.KeypadTwo] = 2,
    [Enum.KeyCode.KeypadThree] = 3,
    [Enum.KeyCode.KeypadFour] = 4
}
local n1 = 780
local v3 = Color3.fromRGB(225, 6, 0)
local v4 = Color3.new(1, 1, 1)

local function new(p1, p2, p3) -- line: 37
    local v5 = Instance.new(p1)

    for v6, v7 in p2 do
        v5[v6] = v7
    end

    v5.Parent = p3

    return v5
end

local function bold(p4) -- line: 43
    return p4
end

local function corner(p5, p6) -- line: 44
    local t3 = {
        CornerRadius = p6 or UDim.new(1, 0)
    }
    local UICorner = Instance.new("UICorner")

    for v8, v9 in t3 do
        UICorner[v8] = v9
    end

    UICorner.Parent = p5

    return p5
end

local function blob(p7, p8, p9, p10, p11, p12, p13, p14) -- line: 46
    -- upvalues: v4 (copy)
    local t4 = {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(p8, p9),
        Size = UDim2.fromOffset(p10, p11),
        BackgroundColor3 = p14 or v4,
        Rotation = p13 or 0
    }
    local Frame = Instance.new("Frame")

    for v10, v11 in t4 do
        Frame[v10] = v11
    end

    Frame.Parent = p7

    local t5 = {
        CornerRadius = p12 or UDim.new(1, 0)
    }
    local UICorner = Instance.new("UICorner")

    for v12, v13 in t5 do
        UICorner[v12] = v13
    end

    UICorner.Parent = Frame

    return Frame
end

Color3.fromRGB(16, 18, 22)

local MoonIcon = require(MotoLegends:WaitForChild("MoonIcon"))

local function sunIcon(p15) -- line: 54
    -- upvalues: blob (copy), MoonIcon (copy)
    if MoonIcon.Night() then
        MoonIcon.Draw(p15, 75, 75, 128)
    else
        blob(p15, 75, 75, 66, 66)

        for i = 0, 7 do
            local v14 = math.rad(i * 45)

            blob(p15, math.sin(v14) * 58 + 75, 75 - math.cos(v14) * 58, 10, 26, nil, i * 45)
        end
    end
end

local function cloudIcon(p16, p17, p18, p19) -- line: 63
    -- upvalues: blob (copy)
    local v15 = p19 or 1

    local function b(p20, p21, p22, p23, p24) -- line: 65
        -- upvalues: v15 (copy), p16 (copy), p17 (copy), p18 (copy), blob (copy)
        blob(p16, p17 + p20 * v15, p18 + p21 * v15, p22 * v15, p23 * v15, p24 and UDim.new(0, p24 * v15))
    end

    blob(p16, p17 + 0 * v15, p18 + 22 * v15, 130 * v15, 50 * v15, (UDim.new(0, 25 * v15)))
    blob(p16, p17 + -29 * v15, p18 + 10 * v15, 56 * v15, 56 * v15, nil)
    blob(p16, p17 + 9 * v15, p18 + -8 * v15, 78 * v15, 78 * v15, nil)
    blob(p16, p17 + 37 * v15, p18 + 12 * v15, 44 * v15, 44 * v15, nil)
end

local function dropIcon(p25, p26, p27) -- line: 71
    -- upvalues: blob (copy)
    blob(p25, p26, p27 + 3, 14, 14)
    blob(p25, p26, p27 - 1, 10, 10, UDim.new(0, 2), 45)
end

local function rainIcon(p28) -- line: 75
    -- upvalues: blob (copy), cloudIcon (copy)
    cloudIcon(p28, 75, 52, 0.9)
    blob(p28, 58, 113, 14, 14)
    blob(p28, 58, 109, 10, 10, UDim.new(0, 2), 45)
    blob(p28, 88, 109, 14, 14)
    blob(p28, 88, 105, 10, 10, UDim.new(0, 2), 45)
    blob(p28, 72, 137, 14, 14)
    blob(p28, 72, 133, 10, 10, UDim.new(0, 2), 45)
    blob(p28, 102, 133, 14, 14)
    blob(p28, 102, 129, 10, 10, UDim.new(0, 2), 45)
end

local function dynamicIcon(p29) -- line: 81
    -- upvalues: blob (copy), sunIcon (copy), cloudIcon (copy)
    local t6 = {
        Name = "Sun",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(114, 33),
        Size = UDim2.fromOffset(150, 150)
    }
    local Frame = Instance.new("Frame")

    for v16, v17 in t6 do
        Frame[v16] = v17
    end

    Frame.Parent = p29

    local t7 = {
        Scale = 0.6
    }
    local UIScale = Instance.new("UIScale")

    for v18, v19 in t7 do
        UIScale[v18] = v19
    end

    UIScale.Parent = Frame
    sunIcon(Frame)
    cloudIcon(p29, 66, 58, 0.9)
    blob(p29, 49, 119, 14, 14)
    blob(p29, 49, 115, 10, 10, UDim.new(0, 2), 45)
    blob(p29, 79, 115, 14, 14)
    blob(p29, 79, 111, 10, 10, UDim.new(0, 2), 45)
    blob(p29, 63, 143, 14, 14)
    blob(p29, 63, 139, 10, 10, UDim.new(0, 2), 45)
    blob(p29, 93, 139, 14, 14)
    blob(p29, 93, 135, 10, 10, UDim.new(0, 2), 45)
end

local t8 = {
    Sunny = sunIcon,
    Cloudy = function(p30) -- Cloudy | line: 91
        -- upvalues: cloudIcon (copy)
        cloudIcon(p30, 75, 70, 1)
    end,
    Rainy = rainIcon,
    Dynamic = dynamicIcon
}
local t9 = {
    Name = "WeatherVote",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 1000,
    Enabled = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")

for v20, v21 in t9 do
    ScreenGui[v20] = v21
end

ScreenGui.Parent = PlayerGui
t9 = {
    Name = "Root",
    BackgroundTransparency = 1,
    GroupTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.45),
    Size = UDim2.fromOffset(780 + 12, 516)
}

local CanvasGroup = Instance.new("CanvasGroup")

for v22, v23 in t9 do
    CanvasGroup[v22] = v23
end

CanvasGroup.Parent = ScreenGui

local t10 = {}
local UIScale = Instance.new("UIScale")

for v24, v25 in t10 do
    UIScale[v24] = v25
end

UIScale.Parent = CanvasGroup
PlayerGui = {
    Name = "Panel",
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(6, 6),
    Size = UDim2.fromOffset(780, 504)
}

local Frame = Instance.new("Frame")

for v26, v27 in PlayerGui do
    Frame[v26] = v27
end

Frame.Parent = CanvasGroup

local function fit() -- line: 102
    -- upvalues: n1 (ref), UIScale (copy)
    local ViewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)

    UIScale.Scale = math.clamp(math.min((ViewportSize.X - 32) / n1, ViewportSize.Y * 0.45 / 504), 0.3, 0.6)
end

local ViewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
local v31 = (ViewportSize.X - 32) / n1

UIScale.Scale = math.clamp(math.min(v31, ViewportSize.Y * 0.45 / 504), 0.3, 0.6)
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
ViewportSize = {
    BackgroundTransparency = 1,
    Text = "WEATHER VOTE",
    TextSize = 36,
    TextStrokeTransparency = 0.55,
    Size = UDim2.fromOffset(n1, 38),
    FontFace = v2,
    TextColor3 = v4
}

local CurrentCamera = Instance.new("TextLabel")

for v34, v35 in ViewportSize do
    CurrentCamera[v34] = v35
end

CurrentCamera.Parent = Frame

local TextLabel = Frame:FindFirstChildOfClass("TextLabel")
local t11 = {}
local t12 = { "Sunny", "Cloudy", "Rainy" }
local v36 = nil
local Frame2, TextLabel2, TextLabel3, Frame3

for v37, v38 in t1 do
    local t13 = {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 0.22,
        BorderSizePixel = 0,
        Name = v38,
        Modal = v37 == 1,
        Position = UDim2.fromOffset((v37 - 1) * 265, 48),
        Size = UDim2.fromOffset(250, 380),
        BackgroundColor3 = Color3.fromRGB(16, 18, 22)
    }
    local TextButton = Instance.new("TextButton")

    for v39, v40 in t13 do
        TextButton[v39] = v40
    end

    TextButton.Parent = Frame

    local v41 = {
        Thickness = 4,
        Transparency = 1,
        Color = v3,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }
    local UIStroke = Instance.new("UIStroke")

    for v42, v43 in v41 do
        UIStroke[v42] = v43
    end

    UIStroke.Parent = TextButton

    local t14 = {
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(250, 92),
        BackgroundColor3 = Color3.new(0, 0, 0)
    }

    Frame2 = Instance.new("Frame")

    for v44, v45 in t14 do
        Frame2[v44] = v45
    end

    Frame2.Parent = TextButton

    local t15 = {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(125, 52),
        Size = UDim2.fromOffset(206, 44),
        BackgroundColor3 = Color3.fromRGB(14, 18, 26)
    }

    TextLabel2 = Instance.new("Frame")

    for v46, v47 in t15 do
        TextLabel2[v46] = v47
    end

    TextLabel2.Parent = Frame2

    local Frame4 = {
        BackgroundTransparency = 1,
        TextSize = 28,
        Size = UDim2.fromScale(1, 1),
        Text = string.upper(v38),
        FontFace = v1,
        TextColor3 = v4
    }

    TextLabel3 = Instance.new("TextLabel")

    for v48, v49 in Frame4 do
        TextLabel3[v48] = v49
    end

    TextLabel3.Parent = TextLabel2
    t15 = {
        Name = "Laps",
        BackgroundTransparency = 1,
        Text = "",
        TextSize = 18,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(125, 16),
        Size = UDim2.fromOffset(250, 22),
        FontFace = v1
    }
    t15.TextColor3 = v38 == "Dynamic" and Color3.fromRGB(150, 255, 170) or Color3.fromRGB(200, 202, 208)
    TextLabel2 = Instance.new("TextLabel")

    for v50, v51 in t15 do
        TextLabel2[v50] = v51
    end

    TextLabel2.Parent = Frame2
    Frame2 = {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(125, 186),
        Size = UDim2.fromOffset(150, 150)
    }
    Frame4 = Instance.new("Frame")

    for v52, v53 in Frame2 do
        Frame4[v52] = v53
    end

    Frame4.Parent = TextButton
    t8[v38](Frame4)
    Frame2 = {
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(125, 294)
    }
    Frame2.Size = UDim2.fromOffset(v38 == "Dynamic" and 176 or 120, 40)
    Frame2.BackgroundColor3 = Color3.fromRGB(44, 46, 52)
    Frame4 = Instance.new("Frame")

    for v54, v55 in Frame2 do
        Frame4[v54] = v55
    end

    Frame4.Parent = TextButton

    local t16 = {
        BackgroundTransparency = 1,
        Text = "--",
        RichText = true,
        TextSize = 22,
        Size = UDim2.fromScale(1, 1),
        FontFace = v1,
        TextColor3 = v4
    }

    TextLabel3 = Instance.new("TextLabel")

    for v56, v57 in t16 do
        TextLabel3[v56] = v57
    end

    TextLabel3.Parent = Frame4
    v41 = ((Config.Championship or {}).WeatherRewardMultiplier or {})[v38] or 1

    local v58 = {
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Name = v38 .. "Reward",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset((v37 - 1) * 265 + 125, 459),
        Size = UDim2.fromOffset(250, 38),
        BackgroundColor3 = v41 > 1 and Color3.fromRGB(28, 92, 48) or Color3.fromRGB(16, 18, 22)
    }

    Frame3 = Instance.new("Frame")

    for v59, v60 in v58 do
        Frame3[v59] = v60
    end

    Frame3.Parent = Frame
    v58 = {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }

    local Activated = Instance.new("UIListLayout")

    for v61, v62 in v58 do
        Activated[v61] = v62
    end

    Activated.Parent = Frame3
    v58 = {
        Name = "MoneyIcon",
        BackgroundTransparency = 1,
        Image = "rbxassetid://91281390931284",
        LayoutOrder = 1,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromOffset(24, 24)
    }
    Activated = Instance.new("ImageLabel")

    for v63, v64 in v58 do
        Activated[v63] = v64
    end

    Activated.Parent = Frame3
    v58 = ("x%s"):format((string.format("%.2f", v41):gsub("0+$", ""):gsub("%.$", "")))

    local TextLabel = {
        BackgroundTransparency = 1,
        TextSize = 20,
        LayoutOrder = 2,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 30),
        Text = v58 .. " REWARD",
        FontFace = v1,
        TextColor3 = v41 > 1 and Color3.fromRGB(150, 255, 170) or v4
    }
    local TextLabel4 = Instance.new("TextLabel")

    for v65, v66 in TextLabel do
        TextLabel4[v65] = v66
    end

    TextLabel4.Parent = Frame3
    Activated = {
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 330),
        Size = UDim2.fromOffset(250, 50),
        BackgroundColor3 = v4
    }

    local Frame5 = Instance.new("Frame")

    for v67, v68 in Activated do
        Frame5[v67] = v68
    end

    Frame5.Parent = TextButton
    Activated = {
        BackgroundTransparency = 1,
        Text = "0 VOTES",
        TextSize = 21,
        Size = UDim2.fromScale(1, 1),
        FontFace = v1,
        TextColor3 = Color3.fromRGB(12, 12, 14)
    }
    TextLabel = Instance.new("TextLabel")

    for v69, v70 in Activated do
        TextLabel[v69] = v70
    end

    TextLabel.Parent = Frame5
    Activated = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 5,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0)
    }
    Frame5 = Instance.new("Frame")

    for v71, v72 in Activated do
        Frame5[v71] = v72
    end

    Frame5.Parent = TextButton
    TextButton.Activated:Connect(function() -- line: 152
        -- upvalues: MotoLegends (copy), WeatherVote (copy), t12 (ref), v36 (ref), v38 (copy)
        if MotoLegends:GetAttribute("WeatherVoteActive") ~= true or not table.find(t12, v38) then
            return
        end

        v36 = v38
        WeatherVote:FireServer(v38)
    end)
    TextButton.MouseEnter:Connect(function() -- line: 153
        -- upvalues: v4 (copy), v36 (ref), v38 (copy), UIStroke (copy)
        if v36 == v38 then
            return
        end

        UIStroke.Color = v4
        UIStroke.Transparency = 0.55
    end)
    TextButton.MouseLeave:Connect(function() -- line: 154
        -- upvalues: v36 (ref), v38 (copy), UIStroke (copy)
        if v36 ~= v38 then
            UIStroke.Transparency = 1
        end
    end)
    t11[v38] = {
        card = TextButton,
        stroke = UIStroke,
        temp = TextLabel3,
        count = TextLabel,
        dim = Frame5,
        reward = Frame3,
        laps = TextLabel2
    }
end

local v32 = {
    BackgroundTransparency = 0.1,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(0, 492),
    Size = UDim2.fromOffset(n1, 12),
    BackgroundColor3 = Color3.fromRGB(8, 8, 10)
}
local Frame4 = Instance.new("Frame")

for v73, v74 in v32 do
    Frame4[v73] = v74
end

Frame4.Parent = Frame
v32 = {
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = v3
}

local Frame5 = Instance.new("Frame")

for v75, v76 in v32 do
    Frame5[v75] = v76
end

Frame5.Parent = Frame4

local function relayout() -- line: 164
    -- upvalues: MotoLegends (copy), t1 (copy), n1 (ref), CanvasGroup (copy), UIScale (copy), Frame (copy), TextLabel (copy), t11 (copy), t12 (ref), Frame4 (copy)
    local t17 = {}
    local v77 = MotoLegends:GetAttribute("WeatherVoteOptions") or "Sunny,Cloudy,Rainy"

    for match in tostring(v77):gmatch("[^,]+") do
        if t11[match] then
            table.insert(t17, match)
        end
    end

    if #t17 == 0 then
        t17 = { "Sunny", "Cloudy", "Rainy" }
    end

    t12 = t17
    n1 = #t17 * 250 + (#t17 - 1) * 15
    CanvasGroup.Size = UDim2.fromOffset(n1 + 12, 516)
    Frame.Size = UDim2.fromOffset(n1, 504)

    if TextLabel then
        TextLabel.Size = UDim2.fromOffset(n1, 38)
    end

    Frame4.Size = UDim2.fromOffset(n1, 12)

    for _, v78 in t1 do
        local v79 = t11[v78]
        local v80 = table.find(t17, v78)

        v79.card.Visible = v80 ~= nil
        v79.reward.Visible = v80 ~= nil

        if v80 then
            v79.card.Position = UDim2.fromOffset((v80 - 1) * 265, 48)
            v79.reward.Position = UDim2.fromOffset((v80 - 1) * 265 + 125, 459)
        end
    end

    local ViewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)

    UIScale.Scale = math.clamp(math.min((ViewportSize.X - 32) / n1, ViewportSize.Y * 0.45 / 504), 0.3, 0.6)
end

relayout()
MotoLegends:GetAttributeChangedSignal("WeatherVoteOptions"):Connect(relayout)

local function refresh() -- line: 189
    -- upvalues: MotoLegends (copy), Config (copy), t1 (copy), v3 (copy), t11 (copy), v36 (ref)
    for _, v84 in t1 do
        local v85 = t11[v84]
        local v86 = MotoLegends:GetAttribute("WeatherVote" .. v84) or 0

        v85.count.Text = v86 .. (v86 == 1 and " VOTE" or " VOTES")

        local Attribute = MotoLegends:GetAttribute("WeatherOption" .. v84 .. "Temp")

        if v84 == "Dynamic" and typeof(Attribute) == "string" then
            local v87, v88 = Attribute:match("^(%-?%d+)>(%-?%d+)$")

            v85.temp.Text = v87 and v87 .. "° → " .. v88 .. "°C" or Attribute .. "°C"
        else
            v85.temp.Text = tostring(Attribute or "--") .. "°C"
        end

        local v90 = Config.Championship or {}
        local DynamicRaceLaps = if v84 == "Dynamic" then MotoLegends:GetAttribute("DynamicRaceLaps") or v90.DynamicRaceLaps or 5 else MotoLegends:GetAttribute("BaseRaceLaps") or v90.RaceLaps or 3

        v85.laps.Text = ("%d LAPS"):format(DynamicRaceLaps)

        local v91 = v36 == v84

        v85.stroke.Color = v3
        v85.stroke.Transparency = v91 and 0 or 1
    end
end

for _, v92 in t1 do
    MotoLegends:GetAttributeChangedSignal("WeatherVote" .. v92):Connect(refresh)
    MotoLegends:GetAttributeChangedSignal("WeatherOption" .. v92 .. "Temp"):Connect(refresh)
end

local v93

local function fade(p31, p32) -- line: 216
    -- upvalues: TweenService (copy), CanvasGroup (copy), v93 (ref)
    if v93 then
        v93:Cancel()
    end

    v93 = TweenService:Create(CanvasGroup, TweenInfo.new(p32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        GroupTransparency = p31
    })
    v93:Play()

    return v93
end

local n2 = 0
local v94 = false

ScreenGui:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 229
    -- upvalues: ScreenGui (copy), v94 (ref)
    if ScreenGui.Enabled and not v94 then
        ScreenGui.Enabled = false
    end
end)

local function close(p33) -- line: 238
    -- upvalues: ScreenGui (copy), CanvasGroup (copy), v93 (ref), fade (copy), n2 (ref), v94 (ref)
    n2 += 1

    local v95 = n2

    task.delay(p33 or 0, function() -- line: 240
        -- upvalues: v95 (copy), ScreenGui (copy), CanvasGroup (copy), v93 (ref), fade (copy), n2 (ref), v94 (ref)
        if v95 ~= n2 then
            return
        end

        if ScreenGui.Enabled then
            fade(1, 0.45).Completed:Connect(function(p34) -- line: 247
                -- upvalues: v95 (copy), ScreenGui (copy), n2 (ref), v94 (ref)
                if p34 ~= Enum.PlaybackState.Completed or v95 ~= n2 then
                    return
                end

                v94 = false
                ScreenGui.Enabled = false
            end)
        else
            if v93 then
                v93:Cancel()
            end

            CanvasGroup.GroupTransparency = 1
            v94 = false
        end
    end)
end

local function showResult(p35) -- line: 252
    -- upvalues: TweenService (copy), v4 (copy), ScreenGui (copy), CanvasGroup (copy), t11 (copy), Frame5 (copy), v93 (ref), fade (copy), n2 (ref), v94 (ref)
    for v96, v97 in t11 do
        if v96 == p35 then
            v97.stroke.Color = v4
            v97.stroke.Transparency = 0
        else
            TweenService:Create(v97.dim, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.5
            }):Play()
        end
    end

    Frame5.Size = UDim2.fromScale(0, 1)
    n2 += 1

    local v98 = n2

    task.delay(2.5, function() -- line: 240
        -- upvalues: v98 (copy), ScreenGui (copy), CanvasGroup (copy), v93 (ref), fade (copy), n2 (ref), v94 (ref)
        if v98 ~= n2 then
            return
        end

        if ScreenGui.Enabled then
            fade(1, 0.45).Completed:Connect(function(p36) -- line: 247
                -- upvalues: v98 (copy), ScreenGui (copy), n2 (ref), v94 (ref)
                if p36 ~= Enum.PlaybackState.Completed or v98 ~= n2 then
                    return
                end

                v94 = false
                ScreenGui.Enabled = false
            end)
        else
            if v93 then
                v93:Cancel()
            end

            CanvasGroup.GroupTransparency = 1
            v94 = false
        end
    end)
end

MotoLegends:GetAttributeChangedSignal("WeatherVoteActive"):Connect(function() -- line: 261
    -- upvalues: MotoLegends (copy), n1 (ref), ScreenGui (copy), CanvasGroup (copy), UIScale (copy), t11 (copy), v36 (ref), relayout (copy), refresh (copy), v93 (ref), fade (copy), n2 (ref), v94 (ref)
    if MotoLegends:GetAttribute("WeatherVoteActive") == true then
        n2 += 1
        v36 = nil
        v94 = true

        for _, v99 in t11 do
            v99.dim.BackgroundTransparency = 1
        end

        relayout()
        refresh()

        local ViewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)

        UIScale.Scale = math.clamp(math.min((ViewportSize.X - 32) / n1, ViewportSize.Y * 0.45 / 504), 0.3, 0.6)
        ScreenGui.Enabled = true
        fade(0, 0.35)
    elseif v94 then
        local v103 = n2

        task.delay(1.5, function() -- line: 266
            -- upvalues: v103 (copy), ScreenGui (copy), CanvasGroup (copy), v93 (ref), fade (copy), n2 (ref), v94 (ref)
            if v103 ~= n2 or not v94 then
                return
            end

            n2 += 1

            local v104 = n2

            task.delay(0, function() -- line: 240
                -- upvalues: v104 (copy), ScreenGui (copy), CanvasGroup (copy), v93 (ref), fade (copy), n2 (ref), v94 (ref)
                if v104 ~= n2 then
                    return
                end

                if ScreenGui.Enabled then
                    fade(1, 0.45).Completed:Connect(function(p37) -- line: 247
                        -- upvalues: v104 (copy), ScreenGui (copy), n2 (ref), v94 (ref)
                        if p37 ~= Enum.PlaybackState.Completed or v104 ~= n2 then
                            return
                        end

                        v94 = false
                        ScreenGui.Enabled = false
                    end)
                else
                    if v93 then
                        v93:Cancel()
                    end

                    CanvasGroup.GroupTransparency = 1
                    v94 = false
                end
            end)
        end)
    end
end)
MotoLegends:GetAttributeChangedSignal("WeatherVoteResult"):Connect(function() -- line: 269
    -- upvalues: MotoLegends (copy), v94 (ref), showResult (copy)
    local WeatherVoteResult = MotoLegends:GetAttribute("WeatherVoteResult")

    if v94 and WeatherVoteResult and WeatherVoteResult ~= "" and MotoLegends:GetAttribute("WeatherVoteActive") ~= true then
        showResult(WeatherVoteResult)
    end
end)

if MotoLegends:GetAttribute("WeatherVoteActive") == true then
    n2 += 1
    v36 = nil
    v94 = true

    for _, v105 in t11 do
        v105.dim.BackgroundTransparency = 1
    end

    relayout()
    refresh()
    Frame2 = workspace.CurrentCamera

    local ViewportSize = if Frame2 then workspace.CurrentCamera.ViewportSize else nil

    if not Frame2 or not ViewportSize then
        ViewportSize = Vector2.new(1280, 720)
    end

    TextLabel3 = (ViewportSize.X - 32) / n1
    Frame3 = ViewportSize.Y * 0.45 / 504
    TextLabel2 = math.min(TextLabel3, Frame3)
    UIScale.Scale = math.clamp(TextLabel2, 0.3, 0.6)
    ScreenGui.Enabled = true
    fade(0, 0.35)
end

UserInputService.InputBegan:Connect(function(p38, p39) -- line: 275
    -- upvalues: MotoLegends (copy), WeatherVote (copy), t2 (copy), ScreenGui (copy), t12 (ref), v36 (ref), refresh (copy)
    if not p39 and ScreenGui.Enabled then
        local v107 = t2[p38.KeyCode]
        local v106 = v107 and t12[v107]

        if v106 then
            if MotoLegends:GetAttribute("WeatherVoteActive") == true and table.find(t12, v106) then
                v36 = v106
                WeatherVote:FireServer(v106)
            end

            refresh()
        end
    end
end)

for _, v108 in t11 do
    v108.card.Activated:Connect(refresh)
end

RunService.RenderStepped:Connect(function() -- line: 284
    -- upvalues: MotoLegends (copy), ScreenGui (copy), Frame5 (copy)
    if not ScreenGui.Enabled or MotoLegends:GetAttribute("WeatherVoteActive") ~= true then
        return
    end

    local v109 = (MotoLegends:GetAttribute("WeatherVoteDeadline") or 0) - workspace:GetServerTimeNow()

    Frame5.Size = UDim2.fromScale(math.clamp(v109 / (MotoLegends:GetAttribute("WeatherVoteSeconds") or 15), 0, 1), 1)
end)
