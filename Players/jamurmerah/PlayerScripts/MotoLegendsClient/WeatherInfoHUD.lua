-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local OwnerFeatures14 = require(MotoLegends:WaitForChild("OwnerFeatures14"))
local SettingsMenu = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TopbarMenuHUD"):WaitForChild("SettingsMenu")
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.new(0, 0, 0)
local v3 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)

local function new(p1, p2, p3) -- line: 27
    local v4 = Instance.new(p1)

    for v5, v6 in p2 do
        v4[v5] = v6
    end

    v4.Parent = p3

    return v4
end

local function corner(p4, p5) -- line: 28
    local t1 = {
        CornerRadius = p5 or UDim.new(1, 0)
    }
    local UICorner = Instance.new("UICorner")

    for v7, v8 in t1 do
        UICorner[v7] = v8
    end

    UICorner.Parent = p4

    return p4
end

local function blob(p6, p7, p8, p9, p10, p11, p12) -- line: 29
    -- upvalues: v1 (copy)
    local t2 = {
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(p7, p8),
        Size = UDim2.fromOffset(p9, p10),
        BackgroundColor3 = v1,
        Rotation = p12 or 0
    }
    local Frame = Instance.new("Frame")

    for v9, v10 in t2 do
        Frame[v9] = v10
    end

    Frame.Parent = p6

    local t3 = {
        CornerRadius = p11 or UDim.new(1, 0)
    }
    local UICorner = Instance.new("UICorner")

    for v11, v12 in t3 do
        UICorner[v11] = v12
    end

    UICorner.Parent = Frame

    return Frame
end

local MoonIcon = require(MotoLegends:WaitForChild("MoonIcon"))

local function sunIcon(p13) -- line: 35
    -- upvalues: blob (copy), MoonIcon (copy)
    if MoonIcon.Night() then
        MoonIcon.Draw(p13, 75, 75, 128)
    else
        blob(p13, 75, 75, 66, 66)

        for i = 0, 7 do
            local v13 = math.rad(i * 45)

            blob(p13, math.sin(v13) * 58 + 75, 75 - math.cos(v13) * 58, 10, 26, nil, i * 45)
        end
    end
end

local function cloudIcon(p14, p15, p16, p17) -- line: 40
    -- upvalues: blob (copy)
    local v14 = p17 or 1

    local function b(p18, p19, p20, p21, p22) -- line: 42
        -- upvalues: v14 (copy), p14 (copy), p15 (copy), p16 (copy), blob (copy)
        blob(p14, p15 + p18 * v14, p16 + p19 * v14, p20 * v14, p21 * v14, p22 and UDim.new(0, p22 * v14))
    end

    blob(p14, p15 + 0 * v14, p16 + 22 * v14, 130 * v14, 50 * v14, (UDim.new(0, 25 * v14)))
    blob(p14, p15 + -29 * v14, p16 + 10 * v14, 56 * v14, 56 * v14, nil)
    blob(p14, p15 + 9 * v14, p16 + -8 * v14, 78 * v14, 78 * v14, nil)
    blob(p14, p15 + 37 * v14, p16 + 12 * v14, 44 * v14, 44 * v14, nil)
end

local function dropIcon(p23, p24, p25) -- line: 45
    -- upvalues: blob (copy)
    blob(p23, p24, p25 + 3, 14, 14)
    blob(p23, p24, p25 - 1, 10, 10, UDim.new(0, 2), 45)
end

local function rainIcon(p26) -- line: 46
    -- upvalues: blob (copy), cloudIcon (copy)
    cloudIcon(p26, 75, 52, 0.9)
    blob(p26, 58, 113, 14, 14)
    blob(p26, 58, 109, 10, 10, UDim.new(0, 2), 45)
    blob(p26, 88, 109, 14, 14)
    blob(p26, 88, 105, 10, 10, UDim.new(0, 2), 45)
    blob(p26, 72, 137, 14, 14)
    blob(p26, 72, 133, 10, 10, UDim.new(0, 2), 45)
    blob(p26, 102, 133, 14, 14)
    blob(p26, 102, 129, 10, 10, UDim.new(0, 2), 45)
end

local function dynamicIcon(p27) -- line: 47
    -- upvalues: blob (copy), sunIcon (copy), cloudIcon (copy)
    local t4 = {
        Name = "Sun",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(114, 33),
        Size = UDim2.fromOffset(150, 150)
    }
    local Frame = Instance.new("Frame")

    for v15, v16 in t4 do
        Frame[v15] = v16
    end

    Frame.Parent = p27

    local t5 = {
        Scale = 0.6
    }
    local UIScale = Instance.new("UIScale")

    for v17, v18 in t5 do
        UIScale[v17] = v18
    end

    UIScale.Parent = Frame
    sunIcon(Frame)
    cloudIcon(p27, 66, 58, 0.9)
    blob(p27, 49, 119, 14, 14)
    blob(p27, 49, 115, 10, 10, UDim.new(0, 2), 45)
    blob(p27, 79, 115, 14, 14)
    blob(p27, 79, 111, 10, 10, UDim.new(0, 2), 45)
    blob(p27, 63, 143, 14, 14)
    blob(p27, 63, 139, 10, 10, UDim.new(0, 2), 45)
    blob(p27, 93, 139, 14, 14)
    blob(p27, 93, 135, 10, 10, UDim.new(0, 2), 45)
end

local t6 = {
    Sunny = sunIcon,
    Cloudy = function(p28) -- Cloudy | line: 52
        -- upvalues: cloudIcon (copy)
        cloudIcon(p28, 75, 70, 1)
    end,
    Rainy = rainIcon,
    Dynamic = dynamicIcon
}
local t7 = {
    Name = "WeatherInfo",
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Active = false,
    Visible = false,
    BackgroundColor3 = v2,
    Position = UDim2.new(1, 8, 0, 0),
    Size = UDim2.new(0, 0, 1, 0),
    AutomaticSize = Enum.AutomaticSize.X,
    ZIndex = SettingsMenu.ZIndex + 2
}
local Frame = Instance.new("Frame")

for v19, v20 in t7 do
    Frame[v19] = v20
end

Frame.Parent = SettingsMenu
Frame:SetAttribute("NoHover", true)
Frame:SetAttribute("NoSound", true)

local t8 = {
    CornerRadius = UDim.new(1, 0)
}
local UICorner = Instance.new("UICorner")

for v21, v22 in t8 do
    UICorner[v21] = v22
end

UICorner.Parent = Frame

local t9 = {
    PaddingLeft = UDim.new(0, 11),
    PaddingRight = UDim.new(0, 15)
}
local UIPadding = Instance.new("UIPadding")

for v23, v24 in t9 do
    UIPadding[v23] = v24
end

UIPadding.Parent = Frame

local t10 = {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 9),
    SortOrder = Enum.SortOrder.LayoutOrder
}
local UIListLayout = Instance.new("UIListLayout")

for v25, v26 in t10 do
    UIListLayout[v25] = v26
end

UIListLayout.Parent = Frame

local t11 = {
    Name = "Icon",
    BackgroundTransparency = 1,
    LayoutOrder = 1,
    Size = UDim2.fromOffset(28, 28),
    ZIndex = Frame.ZIndex + 1
}
local Frame2 = Instance.new("Frame")

for v27, v28 in t11 do
    Frame2[v27] = v28
end

Frame2.Parent = Frame

local t12 = {
    Name = "TrackTemp",
    BackgroundTransparency = 1,
    TextSize = 21,
    Text = "--°C",
    AutoLocalize = false,
    LayoutOrder = 2,
    FontFace = v3,
    TextColor3 = v1,
    AutomaticSize = Enum.AutomaticSize.X,
    Size = UDim2.new(0, 0, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = Frame.ZIndex + 1
}
local TextLabel = Instance.new("TextLabel")

for v29, v30 in t12 do
    TextLabel[v29] = v30
end

TextLabel.Parent = Frame

local n1 = -1

local function fit() -- line: 68
    -- upvalues: SettingsMenu (copy), Frame (copy), UIPadding (copy), UIListLayout (copy), Frame2 (copy), TextLabel (copy), n1 (ref)
    local Y = SettingsMenu.AbsoluteSize.Y
    local v31 = Y <= 0
    local v32 = if not v31 then math.abs(Y - n1) < 0.5 else nil

    if v31 or v32 then
        return
    end

    n1 = Y

    local v34 = Y / 42

    Frame2.Size = UDim2.fromOffset(math.floor(28 * v34 + 0.5), (math.floor(28 * v34 + 0.5)))

    for _, child in Frame2:GetChildren() do
        local Frame = child:FindFirstChildWhichIsA("Frame")
        local UIScale = Frame and Frame:FindFirstChildOfClass("UIScale")

        if UIScale then
            UIScale.Scale = 28 * v34 / 150
        end
    end

    TextLabel.TextSize = math.max(8, (math.floor(21 * v34 + 0.5)))
    UIPadding.PaddingLeft = UDim.new(0, (math.floor(11 * v34 + 0.5)))
    UIPadding.PaddingRight = UDim.new(0, (math.floor(15 * v34 + 0.5)))
    UIListLayout.Padding = UDim.new(0, (math.floor(9 * v34 + 0.5)))
    Frame.Position = UDim2.new(1, math.floor(8 * v34 + 0.5), 0, 0)
end

local CanvasGroup, v44

local function showIcon(p29) -- line: 82
    -- upvalues: TweenService (copy), sunIcon (copy), t6 (copy), Frame (copy), Frame2 (copy), CanvasGroup (ref), v44 (ref)
    if p29 == v44 then
        return
    end

    v44 = p29

    local t13 = {
        BackgroundTransparency = 1,
        Name = p29,
        Size = UDim2.fromScale(1, 1),
        GroupTransparency = CanvasGroup and 1 or 0,
        ZIndex = Frame.ZIndex + 1
    }
    local CanvasGroup2 = Instance.new("CanvasGroup")

    for v45, v46 in t13 do
        CanvasGroup2[v45] = v46
    end

    CanvasGroup2.Parent = Frame2

    local t14 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(150, 150),
        ZIndex = Frame.ZIndex + 1
    }
    local Frame3 = Instance.new("Frame")

    for v47, v48 in t14 do
        Frame3[v47] = v48
    end

    Frame3.Parent = CanvasGroup2

    local t15 = {
        Scale = Frame2.AbsoluteSize.X > 0 and Frame2.AbsoluteSize.X / 150 or 0.18666666666666668
    }
    local UIScale = Instance.new("UIScale")

    for v49, v50 in t15 do
        UIScale[v49] = v50
    end

    UIScale.Parent = Frame3;
    (t6[p29] or sunIcon)(Frame3)

    if CanvasGroup then
        local CanvasGroup3 = CanvasGroup

        TweenService:Create(CanvasGroup2, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
            GroupTransparency = 0
        }):Play()

        local tween = TweenService:Create(CanvasGroup3, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
            GroupTransparency = 1
        })

        tween:Play()
        tween.Completed:Once(function() -- line: 94
            -- upvalues: CanvasGroup3 (copy)
            CanvasGroup3:Destroy()
        end)
    end

    CanvasGroup = CanvasGroup2
end

local function kindNow() -- line: 98
    -- upvalues: MotoLegends (copy), t6 (copy)
    if MotoLegends:GetAttribute("WeatherDynamic") == true then
        return "Dynamic"
    end

    local Weather = MotoLegends:GetAttribute("Weather")

    if not t6[Weather] or not Weather then
        Weather = "Sunny"
    end

    return Weather
end

for _, v51 in { "Weather", "WeatherDynamic" } do
    MotoLegends:GetAttributeChangedSignal(v51):Connect(function() -- line: 103
        -- upvalues: MotoLegends (copy), t6 (copy), showIcon (copy)
        local Weather

        if MotoLegends:GetAttribute("WeatherDynamic") == true then
            Weather = "Dynamic"
        else
            Weather = MotoLegends:GetAttribute("Weather")

            if not t6[Weather] or not Weather then
                Weather = "Sunny"
            end
        end

        showIcon(Weather)
    end)
end

local Weather

if MotoLegends:GetAttribute("WeatherDynamic") == true then
    Weather = "Dynamic"
else
    Weather = MotoLegends:GetAttribute("Weather")

    if not t6[Weather] or not Weather then
        Weather = "Sunny"
    end
end

showIcon(Weather)

local v52

RunService.RenderStepped:Connect(function(p30) -- line: 108
    -- upvalues: MotoLegends (copy), Frame (copy), TextLabel (copy), fit (copy), v52 (ref)
    if Frame.Visible then
        fit()

        local TrackTemp = MotoLegends:GetAttribute("TrackTemp")

        if typeof(TrackTemp) ~= "number" then
            TextLabel.Text = "--°C"

            return
        end

        v52 = v52 or TrackTemp

        local v53 = TrackTemp - v52

        if v53 ~= 0 then
            local v55 = math.max(4, math.abs(v53) / 2)

            v52 += math.clamp(v53, -v55 * p30, v55 * p30)
        end

        TextLabel.Text = ("%d°C"):format((math.floor(v52 + 0.5)))
    end
end)

local function refresh() -- line: 123
    -- upvalues: OwnerFeatures14 (copy), Frame (copy)
    Frame.Visible = OwnerFeatures14.On()
end

workspace:GetAttributeChangedSignal("OwnerFeatures14"):Connect(refresh)
Frame.Visible = OwnerFeatures14.On()
