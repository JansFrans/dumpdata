-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

game:GetService("SoundService")

local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local Config = require(MotoLegends:WaitForChild("Config"))
local RaceIcons = require(MotoLegends:WaitForChild("RaceIcons"))
local UIArt = require(MotoLegends:WaitForChild("UIArt"))
local NumberFormat = require(MotoLegends:WaitForChild("NumberFormat"))
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local JerezRaceHUD = PlayerGui:WaitForChild("JerezRaceHUD")
local v1 = Color3.fromRGB(231, 0, 0)
local v2 = Color3.new(0, 0, 0)
local v3 = Color3.new(1, 1, 1)
local v4 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "RaceLobbyHUD"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local t1 = {}

local function group(p1, p2) -- line: 33
    -- upvalues: ScreenGui (copy), t1 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p1
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromOffset(0, 0)
    Frame.AnchorPoint = p2
    Frame.Position = UDim2.fromScale(p2.X, p2.Y)
    Frame.Parent = ScreenGui
    Instance.new("UIScale", Frame)
    table.insert(t1, Frame)

    return Frame
end

local function corner(p3, p4) -- line: 38
    local UICorner = Instance.new("UICorner", p3)

    UICorner.CornerRadius = p4

    return UICorner
end

local function iconImage(p5, p6, p7) -- line: 39
    -- upvalues: RaceIcons (copy), UIArt (copy), v3 (copy)
    local v5 = RaceIcons.Get("ref_" .. p6) or RaceIcons.Get(p6)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Icon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.Size = UDim2.fromScale(p7 or 0.8, p7 or 0.8)
    ImageLabel.ImageColor3 = v3
    ImageLabel.ZIndex = p5.ZIndex + 1

    if p6 == "retire" then
        ImageLabel.ImageTransparency = 1

        for _, v6 in { 45, -45 } do
            local Frame = Instance.new("Frame")

            Frame.Name = "Bar"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v3
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.fromScale(0.5, 0.5)
            Frame.Size = UDim2.fromScale(1.12, 0.26)
            Frame.Rotation = v6
            Frame.ZIndex = ImageLabel.ZIndex
            Frame.Parent = ImageLabel
        end
    elseif p6 == "exit" then
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Parent = p5
        UIArt.Apply(ImageLabel, "ExitIcon")
    elseif p6 == "servers" then
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Parent = p5
        UIArt.Apply(ImageLabel, "ServerIcon")
    elseif v5 then
        ImageLabel.ImageContent = v5
    else
        ImageLabel.ImageTransparency = 1

        local TextLabel = Instance.new("TextLabel", ImageLabel)

        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.fromScale(1, 1)
        TextLabel.TextScaled = true
        TextLabel.TextColor3 = v3
        TextLabel.Font = Enum.Font.GothamBlack
        TextLabel.ZIndex = ImageLabel.ZIndex
        TextLabel.Text = ({
            bikes = "BIKE",
            character = "☺",
            tracks = "⌖",
            shop = "$",
            laptimes = "⏱",
            eye = "👁",
            music = "♪",
            gear = "⚙",
            rider = "☰",
            cam = "CAM"
        })[p6] or "?"
    end

    ImageLabel.Parent = p5

    return ImageLabel
end

local function tile(p8, p9, p10, p11, p12, p13, p14, p15) -- line: 69
    -- upvalues: RaceIcons (copy), v2 (copy), v3 (copy), v4 (copy), iconImage (copy)
    p13 = p13 or 50
    p14 = p14 or 27

    local TextButton = Instance.new("TextButton")

    TextButton.Name = p9
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v2
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton:SetAttribute("ReferenceTile", true)
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.Position = UDim2.fromOffset(p11 + p13 / 2, p12 + p14 / 2)
    TextButton.Size = UDim2.fromOffset(p13, p14)
    TextButton.Parent = p8

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Plate"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ImageContent = RaceIcons.Get(if p15 == "corner" then "ref_corner" elseif p15 == "top" then "ref_top_plate" else "ref_plate")
    ImageLabel.ImageColor3 = v2
    ImageLabel.ZIndex = TextButton.ZIndex
    ImageLabel.Parent = TextButton

    local v9 = iconImage(TextButton, p10, 1)
    local v10 = ({
        Bikes = { 10, -2, 28, 25 },
        Character = { 12, -4, 26, 26 },
        Tracks = { 17, -5, 18, 28 },
        Shop = { 12, -4, 28, 28 },
        LapTimes = { 12, 10, 35, 35 },
        Spectate = { 9, 3, 19, 12 },
        Settings = { 9, 0, 18, 18 },
        Riders = { 12, -4, 26, 27 },
        CameraMode = { 12, 1, 26, 22 },
        Retire = { 16, 3, 20, 20 },
        Exit = { 10, 2, 16, 16 },
        Servers = { 10, 2, 16, 16 }
    })[p9] or { 0, 0, p13, p14 }

    v9.AnchorPoint = Vector2.zero
    v9.Position = UDim2.fromOffset(v10[1], v10[2])
    v9.Size = UDim2.fromOffset(v10[3], v10[4])

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Caption"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.fromOffset(-4, p14 + 3)
    TextLabel.Size = UDim2.fromOffset(p13 + 8, 10)
    TextLabel.Text = ({
        Bikes = "BIKES",
        Character = "LEGENDS",
        Tracks = "CIRCUITS",
        Shop = "SHOP",
        LapTimes = "LAP TIMES",
        Riders = "RIDERS",
        CameraMode = "CAMERA",
        Retire = "RETIRE"
    })[p9] or ""
    TextLabel.FontFace = v4
    TextLabel.TextColor3 = v3
    TextLabel.TextSize = 6
    TextLabel.Parent = TextButton

    return TextButton
end

local function pill(p16, p17, p18, p19, p20, p21, p22) -- line: 84
    -- upvalues: v2 (copy), v3 (copy), v4 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p17
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v2
    TextButton.BorderSizePixel = 0
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.Position = UDim2.fromOffset(p19 + p21 / 2, p20 + p22 / 2)
    TextButton.Size = UDim2.fromOffset(p21, p22)

    local v11 = UDim.new(1, 0)

    Instance.new("UICorner", TextButton).CornerRadius = v11
    TextButton.Text = p18
    TextButton.FontFace = v4
    TextButton.TextColor3 = v3
    TextButton.TextSize = 12
    TextButton.Parent = p16

    return TextButton
end

local function iconButton(p23, p24, p25, p26, p27, p28) -- line: 91
    -- upvalues: v2 (copy), iconImage (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p24
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v2
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.Position = UDim2.fromOffset(p26 + p28 / 2, p27 + p28 / 2)
    TextButton.Size = UDim2.fromOffset(p28, p28)

    local v12 = UDim.new(0, 8)

    Instance.new("UICorner", TextButton).CornerRadius = v12
    TextButton.Parent = p23
    iconImage(TextButton, p25, 0.82)

    return TextButton
end

local BottomNavigation = group("BottomNavigation", Vector2.new(0.5, 1))
local v13 = tile(BottomNavigation, "Character", "character", -25, -50)
local v14 = tile(BottomNavigation, "Tracks", "tracks", -1, -50)

v14.Visible = false

local v15 = tile(BottomNavigation, "Shop", "shop", 23, -50)
local Money = group("Money", Vector2.new(0, 1))
local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "MoneyCounter"
TextLabel.BackgroundColor3 = v1
TextLabel.BackgroundTransparency = 1
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.fromOffset(36, -55)
TextLabel.Size = UDim2.fromOffset(0, 25)
TextLabel.AutomaticSize = Enum.AutomaticSize.X

local v16 = UDim.new(0, 6)

Instance.new("UICorner", TextLabel).CornerRadius = v16
v16 = Instance.new("UIPadding", TextLabel)
v16.PaddingLeft = UDim.new(0, 0)
v16.PaddingRight = UDim.new(0, 0)
TextLabel.FontFace = v4
TextLabel.TextColor3 = v3
TextLabel.TextSize = 12
TextLabel.Text = "$ 0"
TextLabel.Parent = Money

local NumberValue = Instance.new("NumberValue")

NumberValue.Value = LocalPlayer:GetAttribute("Money") or 0

local v17

LocalPlayer:GetAttributeChangedSignal("Money"):Connect(function() -- line: 111
    -- upvalues: LocalPlayer (copy), NumberValue (copy), v17 (ref)
    local v18 = LocalPlayer:GetAttribute("Money") or 0

    if v17 then
        v17:Cancel()
    end

    local v20 = math.abs(v18 - NumberValue.Value)

    if v20 < 1 then
        NumberValue.Value = v18
    else
        local v23 = math.clamp(math.log10(v20 + 1) * 0.25 + 0.4, 0.4, 1.6)

        v17 = game:GetService("TweenService"):Create(NumberValue, TweenInfo.new(v23, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Value = v18
        })
        v17:Play()
    end
end)

local TopCenter = group("TopCenter", Vector2.new(0.5, 0))
local v24 = tile(BottomNavigation, "Bikes", "bikes", -73, -50)

local function rdTile(p29, p30, p31) -- line: 125
    -- upvalues: RaceIcons (copy), v2 (copy), v3 (copy), v4 (copy), BottomNavigation (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p29
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v2
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton:SetAttribute("ReferenceTile", true)
    TextButton.Visible = false
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.Position = UDim2.fromOffset(p31 + 25, -36.5)
    TextButton.Size = UDim2.fromOffset(50, 27)
    TextButton.Parent = BottomNavigation

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Plate"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ImageContent = RaceIcons.Get("ref_plate")
    ImageLabel.ImageColor3 = v2
    ImageLabel.ZIndex = TextButton.ZIndex
    ImageLabel.Parent = TextButton

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Label"
    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Position = UDim2.fromScale(0.5, 0.5)
    TextLabel.Size = UDim2.new(1, -6, 1, 0)
    TextLabel.Text = p30
    TextLabel.FontFace = v4
    TextLabel.TextColor3 = v3
    TextLabel.TextSize = 7
    TextLabel.TextWrapped = true
    TextLabel.AutoLocalize = false
    TextLabel.ZIndex = TextButton.ZIndex + 1
    TextLabel.Parent = TextButton

    return TextButton
end

local t2 = {
    {
        panel = "Qualifying",
        btn = rdTile("RDQualifying", "QUALIFYING", -97)
    },
    {
        panel = "Race",
        btn = rdTile("RDRace", "RACE", -49)
    },
    {
        panel = "Settings",
        btn = rdTile("RDSettings", "SETTINGS", -1)
    },
    {
        panel = "Announce",
        btn = rdTile("RDAnnounce", "ANNOUNCE", 47)
    }
}
local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Name = "RaceDirectorTitle"
TextLabel2.BackgroundTransparency = 1
TextLabel2.AnchorPoint = Vector2.new(0.5, 1)
TextLabel2.Position = UDim2.fromOffset(0, -53)
TextLabel2.Size = UDim2.fromOffset(194, 9)
TextLabel2.FontFace = v4
TextLabel2.TextSize = 7
TextLabel2.TextColor3 = v3
TextLabel2.RichText = true
TextLabel2.Text = "<font color=\"#E70000\">●</font>  RACE DIRECTOR"
TextLabel2.AutoLocalize = false
TextLabel2.Visible = false
TextLabel2.Parent = BottomNavigation

local RaceDirectorSpectate = group("RaceDirectorSpectate", Vector2.new(1, 0.5))

RaceDirectorSpectate.Visible = false

local v25 = tile(BottomNavigation, "Retire", "retire", -1, -50)

v25.Visible = false

local function popupText(p32, p33) -- line: 149
    -- upvalues: v4 (copy)
    p32.FontFace = v4
    p32.TextColor3 = p33
end

local RetireConfirm = group("RetireConfirm", Vector2.new(0.5, 0.5))

RetireConfirm.Visible = false
RetireConfirm.ZIndex = 70

local Frame = Instance.new("Frame")

Frame.Name = "Panel"
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.fromOffset(0, 0)
Frame.Size = UDim2.fromOffset(248, 100)
Frame.BackgroundColor3 = v2
Frame.BorderSizePixel = 0

local v26 = UDim.new(0, 4)

Instance.new("UICorner", Frame).CornerRadius = v26
Frame.Parent = RetireConfirm
v26 = Instance.new("TextLabel")
v26.Name = "Title"
v26.BackgroundTransparency = 1
v26.Position = UDim2.fromOffset(13, 11)
v26.Size = UDim2.fromOffset(160, 10)
v26.Text = "RETIREMENT"
v26.TextSize = 10
v26.TextXAlignment = Enum.TextXAlignment.Left
v26.FontFace = v4
v26.TextColor3 = v3
v26.Parent = Frame
v26 = Instance.new("Frame")
v26.Name = "Divider"
v26.AnchorPoint = Vector2.new(0, 0.5)
v26.Position = UDim2.fromOffset(12, 27)
v26.Size = UDim2.fromOffset(99, 1)
v26.BorderSizePixel = 0
v26.BackgroundColor3 = v3
v26.Parent = Frame
Instance.new("UIGradient", v26).Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.8, 0),
    NumberSequenceKeypoint.new(1, 1)
})
v26 = Instance.new("TextLabel")
v26.Name = "Message"
v26.BackgroundTransparency = 1
v26.AnchorPoint = Vector2.new(0.5, 0.5)
v26.Position = UDim2.new(0.5, 0, 0, 50)
v26.Size = UDim2.new(1, -24, 0, 12)
v26.Text = "RETIRE FROM THE RACE?"
v26.TextSize = 10
v26.TextWrapped = true
v26.FontFace = v4
v26.TextColor3 = v3
v26.Parent = Frame

local TextButton = Instance.new("TextButton")

TextButton.Name = "Confirm"
TextButton.AutoButtonColor = false
TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
TextButton.Position = UDim2.new(0.5, 0, 0, 80)
TextButton.Size = UDim2.fromOffset(95, 19)
TextButton.BackgroundColor3 = v3
TextButton.BorderSizePixel = 0

local TextButton2 = UDim.new(1, 0)

Instance.new("UICorner", TextButton).CornerRadius = TextButton2
TextButton.Text = "CONFIRM"
TextButton.TextSize = 12
TextButton.FontFace = v4
TextButton.TextColor3 = v2
TextButton.ZIndex = 2
TextButton.Parent = Frame
TextButton2 = Instance.new("TextButton")
TextButton2.Name = "Close"
TextButton2.Text = ""
TextButton2.AutoButtonColor = false
TextButton2.BackgroundTransparency = 1
TextButton2.BorderSizePixel = 0
TextButton2:SetAttribute("NoHover", true)
TextButton2.AnchorPoint = Vector2.new(0.5, 0.5)
TextButton2.Position = UDim2.new(1, -26, 0, 18)
TextButton2.Size = UDim2.fromOffset(30, 16)
TextButton2.ZIndex = 3
TextButton2.Parent = Frame

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "Plate"
ImageLabel.BackgroundTransparency = 1
ImageLabel.Size = UDim2.fromScale(1, 1)
ImageLabel.ImageColor3 = v3
ImageLabel.ZIndex = 3
ImageLabel.Parent = TextButton2

local TextLabel3 = RaceIcons.Get("ref_top_plate")

if TextLabel3 then
    ImageLabel.ImageContent = TextLabel3
else
    ImageLabel.BackgroundTransparency = 0
    ImageLabel.BackgroundColor3 = v3

    local v27 = UDim.new(0, 5)

    Instance.new("UICorner", ImageLabel).CornerRadius = v27
end

TextLabel3 = Instance.new("TextLabel")
TextLabel3.Name = "X"
TextLabel3.BackgroundTransparency = 1
TextLabel3.Size = UDim2.fromScale(1, 1)
TextLabel3.Text = "X"
TextLabel3.TextSize = 10
TextLabel3.FontFace = v4
TextLabel3.TextColor3 = v2
TextLabel3.ZIndex = 4
TextLabel3.Parent = TextButton2

local function closeHover(p34, p35, p36) -- line: 169
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), v3 (copy)
    local v28 = TweenInfo.new(0.18)

    TweenService:Create(p34, v28, {
        ImageColor3 = p36 and v1 or v3
    }):Play()

    if p34.BackgroundTransparency < 1 then
        TweenService:Create(p34, v28, {
            BackgroundColor3 = p36 and v1 or v3
        }):Play()
    end

    TweenService:Create(p35, v28, {
        TextColor3 = p36 and v3 or v2
    }):Play()
end

local function hookClose(p37, p38, p39) -- line: 175
    -- upvalues: TweenService (copy), closeHover (copy)
    local v29 = p37:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", p37)

    p37.MouseEnter:Connect(function() -- line: 177
        -- upvalues: p38 (copy), p39 (copy), closeHover (copy)
        closeHover(p38, p39, true)
    end)
    p37.MouseLeave:Connect(function() -- line: 178
        -- upvalues: p38 (copy), p39 (copy), v29 (copy), TweenService (copy), closeHover (copy)
        closeHover(p38, p39, false)
        TweenService:Create(v29, TweenInfo.new(0.12), {
            Scale = 1
        }):Play()
    end)
    p37.SelectionGained:Connect(function() -- line: 179
        -- upvalues: p38 (copy), p39 (copy), closeHover (copy)
        closeHover(p38, p39, true)
    end)
    p37.SelectionLost:Connect(function() -- line: 179
        -- upvalues: p38 (copy), p39 (copy), closeHover (copy)
        closeHover(p38, p39, false)
    end)
    p37.MouseButton1Down:Connect(function() -- line: 180
        -- upvalues: v29 (copy), TweenService (copy)
        TweenService:Create(v29, TweenInfo.new(0.08), {
            Scale = 0.9
        }):Play()
    end)
    p37.MouseButton1Up:Connect(function() -- line: 181
        -- upvalues: v29 (copy), TweenService (copy)
        TweenService:Create(v29, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
            Scale = 1
        }):Play()
    end)
end

hookClose(TextButton2, ImageLabel, TextLabel3)

local clone = RetireConfirm:Clone()

clone.Name = "ExitConfirm"
clone.Visible = false
clone.Parent = ScreenGui
table.insert(t1, clone)
Frame = clone.Panel
Frame.Title.Text = "EXIT"
Frame.Message.Text = "GO TO MAIN MENU?"

local Confirm = Frame.Confirm

Confirm.Text = "EXIT"

local Close = Frame.Close

hookClose(Close, Close.Plate, Close.X)

local TopRight = group("TopRight", Vector2.new(1, 0))
local top = tile(TopRight, "Spectate", "eye", -111, 0, 36, 20, "top")
local top2 = tile(TopRight, "Settings", "gear", -72, 0, 35, 20, "top")

top2.Visible = false

local top3 = tile(TopRight, "Servers", "servers", -73, 0, 36, 20, "top")
local top4 = tile(TopRight, "Exit", "exit", -35, 0, 35, 20, "top")
local LapTimesCorner = group("LapTimesCorner", Vector2.new(1, 1))
local corner2 = tile(LapTimesCorner, "LapTimes", "laptimes", -82, -76, 55, 53, "corner")
local SpectateControls = group("SpectateControls", Vector2.new(1, 1))
local v30 = tile(SpectateControls, "CameraMode", "cam", -98, -50)
local v31 = tile(SpectateControls, "Riders", "rider", -50, -50)

local function listRowHeight() -- line: 208
    -- upvalues: UserInputService (copy)
    if UserInputService.TouchEnabled then
        return 20
    end

    return 15
end

local function listHeight(p40) -- line: 209
    -- upvalues: UserInputService (copy)
    local v32 = math.max(1, p40)

    return 22 + v32 * (if UserInputService.TouchEnabled then 20 else 15) + (v32 - 1) * 2
end

local function popupList(p41, p42, p43, p44) -- line: 210
    -- upvalues: UserInputService (copy), v3 (copy), v4 (copy), SpectateControls (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p41
    Frame.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(1, 1)
    Frame.Position = UDim2.fromOffset(p43, -58)

    local fromOffset = UDim2.fromOffset
    local v33 = math.max(1, 1)

    Frame.Size = fromOffset(92, 22 + v33 * (UserInputService.TouchEnabled and 20 or 15) + (v33 - 1) * 2)

    local v34 = UDim.new(0, 5)

    Instance.new("UICorner", Frame).CornerRadius = v34
    Frame.Visible = false
    Frame.Parent = SpectateControls

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Title"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.fromOffset(6, 3)
    TextLabel.Size = UDim2.new(1, -12, 0, 12)
    TextLabel.FontFace = v4
    TextLabel.Text = p42
    TextLabel.TextSize = 7
    TextLabel.TextColor3 = v3
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Frame

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = p44
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(4, 18)
    ScrollingFrame.Size = UDim2.new(1, -8, 1, -22)
    ScrollingFrame.ScrollBarThickness = 2
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.Parent = Frame

    local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)

    UIListLayout.Padding = UDim.new(0, 2)
    UIListLayout.SortOrder = Enum.SortOrder.Name

    return Frame, ScrollingFrame
end

local Players2, Players3 = popupList("RiderList", "RIDERS", 0, "Players")
local Modes, Modes2 = popupList("CameraList", "CAMERA", -48, "Modes")

local function listRow(p45, p46, p47, p48) -- line: 224
    -- upvalues: UserInputService (copy), v3 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p46
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, -4, 0, UserInputService.TouchEnabled and 20 or 15)
    Frame.Parent = p45

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Row"
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.Position = UDim2.fromScale(0.5, 0.5)
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = p48 and Color3.fromRGB(60, 60, 66) or Color3.fromRGB(28, 30, 36)
    TextButton.BorderSizePixel = 0

    local v35 = UDim.new(0, 5)

    Instance.new("UICorner", TextButton).CornerRadius = v35
    TextButton.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
    TextButton.Text = p47
    TextButton.TextSize = UserInputService.TouchEnabled and 9 or 8
    TextButton.TextTruncate = Enum.TextTruncate.AtEnd
    TextButton.TextColor3 = v3
    TextButton.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UIPadding", TextButton).PaddingLeft = UDim.new(0, 6)
    TextButton.Parent = Frame

    return Frame, TextButton
end

TopCenter.ZIndex = 60

local v36

local function toastTop() -- line: 235
    -- upvalues: v36 (ref)
    if v36 and v36() then
        return 16
    end

    return 58
end

local TextLabel4 = Instance.new("TextLabel")

TextLabel4.Name = "Notice"
TextLabel4.AnchorPoint = Vector2.new(0.5, 0)
TextLabel4.Position = UDim2.fromOffset(0, 58)
TextLabel4.BackgroundColor3 = v2
TextLabel4.BackgroundTransparency = 0.2
TextLabel4.BorderSizePixel = 0
TextLabel4.Size = UDim2.fromOffset(160, 18)
TextLabel4.FontFace = v4
TextLabel4.TextColor3 = v3
TextLabel4.TextSize = 8
TextLabel4.Visible = false

local v37 = UDim.new(1, 0)

Instance.new("UICorner", TextLabel4).CornerRadius = v37
TextLabel4.Parent = TopCenter
TextLabel4.AutomaticSize = Enum.AutomaticSize.XY
TextLabel4.RichText = true
TextLabel4.AutoLocalize = false
v37 = Instance.new("UIPadding")
v37.PaddingLeft = UDim.new(0, 10)
v37.PaddingRight = UDim.new(0, 10)
v37.PaddingTop = UDim.new(0, 2)
v37.PaddingBottom = UDim.new(0, 2)
v37.Parent = TextLabel4

local n1 = 0

local function fadeToast(p49, p50) -- line: 243
    -- upvalues: TweenService (copy), v36 (ref), TextLabel4 (copy)
    local v38 = TweenInfo.new(p50, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v39 = if not (v36 and v36()) then 58 else 16
    local t6 = {}

    t6.BackgroundTransparency = p49 and 0.2 or 1
    t6.TextTransparency = p49 and 0 or 1

    local fromOffset = UDim2.fromOffset

    if not p49 or not v39 then
        v39 -= 6
    end

    t6.Position = fromOffset(0, v39)
    TweenService:Create(TextLabel4, v38, t6):Play()
end

local function notice(p51) -- line: 248
    -- upvalues: v36 (ref), TextLabel4 (copy), n1 (ref), fadeToast (copy)
    n1 += 1

    local v40 = n1

    TextLabel4.Text = p51

    if not TextLabel4.Visible then
        TextLabel4.BackgroundTransparency = 1
        TextLabel4.TextTransparency = 1
        TextLabel4.Position = UDim2.fromOffset(0, (v36 and v36() and 16 or 58) - 6)
    end

    TextLabel4.Visible = true
    fadeToast(true, 0.2)
    task.delay(2, function() -- line: 253
        -- upvalues: v40 (copy), TextLabel4 (copy), n1 (ref), fadeToast (copy)
        if v40 == n1 then
            fadeToast(false, 0.3)
            task.delay(0.3, function() -- line: 254
                -- upvalues: v40 (copy), TextLabel4 (copy), n1 (ref)
                if v40 == n1 then
                    TextLabel4.Visible = false
                end
            end)
        end
    end)
end

MotoLegends:WaitForChild("RaceEvent").OnClientEvent:Connect(function(p52, p53) -- line: 258
    -- upvalues: notice (copy)
    if p52 ~= "LobbyNotice" then
        return
    end

    local v42 = if typeof(p53) == "table" then tostring(p53.text or "") or tostring(p53) else tostring(p53)
    local v44 = typeof(p53) == "table" and p53.detail
    local v45, v46

    if not v44 or v44 == "" then
        v46 = false
    else
        local v47 = v42 .. "\n<font size=\"6\">" .. v44 .. "</font>"

        if v47 then
            v45 = v47
            v46 = true
        else
            v46 = false
        end
    end

    if not v46 then
        v45 = v42
    end

    notice(v45)
end)

local t7 = {}

for _, v48 in {
        v24,
        v13,
        v14,
        v15,
        v25,
        top,
        top2,
        top3,
        top4,
        corner2,
        v30,
        v31,
        t2[1].btn,
        t2[2].btn,
        t2[3].btn,
        t2[4].btn
    } do
    for _, v49 in {
            v48,
            v48:FindFirstChild("Icon"),
            v48:FindFirstChild("Caption")
        } do
        if v49 then
            t7[v49] = {
                position = v49.Position,
                size = v49.Size,
                isButton = v49 == v48
            }
        end
    end
end

local TextLabelPosition = TextLabel.Position

local function rescale() -- line: 274
    -- upvalues: GuiService (copy), t1 (copy), TextLabel (copy), TopRight (copy), SpectateControls (copy), t7 (copy), TextLabelPosition (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local v50 = ViewportSize.Y / 360
    local v51 = ViewportSize.X / 640 / v50

    for _, v52 in t1 do
        v52.UIScale.Scale = v50
    end

    local function map(p54) -- line: 280
        -- upvalues: v51 (copy)
        return UDim2.new(p54.X.Scale, p54.X.Offset * v51, p54.Y.Scale, p54.Y.Offset)
    end

    for v53, v54 in t7 do
        if not v54.isButton or v53:IsDescendantOf(TopRight) or v53:IsDescendantOf(SpectateControls) then
            v53.Position = v54.position
        else
            local position = v54.position

            v53.Position = UDim2.new(position.X.Scale, position.X.Offset * v51, position.Y.Scale, position.Y.Offset) or v54.position
        end

        v53.Size = v54.size
    end

    TextLabel.Position = UDim2.new(TextLabelPosition.X.Scale, TextLabelPosition.X.Offset * v51, TextLabelPosition.Y.Scale, TextLabelPosition.Y.Offset)

    local Height = GuiService.TopbarInset.Height
    local v55, v56, v57

    if Height > 0 and Height <= 36 then
        v56 = 4
        v57 = 2
        v55 = 32
    else
        v56 = 12
        v57 = 12
        v55 = math.max(32, Height - 14)
    end

    local v59 = v57 + v55 / 2

    TopRight.Position = UDim2.new(1, -v56, 0, v59 - 10 * v50)
    SpectateControls.Position = UDim2.new(1, -v56, 1, 0)
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)
GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(rescale)
rescale()

local function placeLapTimes() -- line: 304
    -- upvalues: UserInputService (copy), LocalPlayer (copy), LapTimesCorner (copy)
    local v60 = 0

    if UserInputService.TouchEnabled then
        local TouchGui = LocalPlayer.PlayerGui:FindFirstChild("TouchGui")

        TouchGui = TouchGui and TouchGui.Enabled and TouchGui:FindFirstChild("JumpButton", true)

        if TouchGui then
            local TouchGuiParent = TouchGui.Parent

            if TouchGui.Visible and TouchGuiParent and TouchGuiParent:IsA("GuiObject") and TouchGui.AbsoluteSize.Y > 0 then
                local v61 = TouchGuiParent.AbsolutePosition.Y + TouchGuiParent.AbsoluteSize.Y - TouchGui.AbsolutePosition.Y
                local v62 = 10 * LapTimesCorner.UIScale.Scale

                v60 = math.max(0, (math.ceil(v61 + 8 - v62)))
            end
        end
    end

    local v65 = UDim2.new(1, 0, 1, -v60)

    if LapTimesCorner.Position ~= v65 then
        LapTimesCorner.Position = v65
    end
end

local position = t7[v24].position
local v66 = UDim2.fromOffset(-24, -36.5)
local v67 = false

local function setSprintLayout(p55) -- line: 324
    -- upvalues: v13 (copy), v14 (copy), v15 (copy), v24 (copy), v25 (copy), t7 (copy), rescale (copy), position (copy), v66 (copy), v67 (ref)
    if p55 == v67 then
        return
    end

    v67 = p55
    t7[v24].position = p55 and v66 or position
    v13.Visible = not p55
    v14.Visible = false
    v15.Visible = not p55
    v25.Visible = p55
    rescale()
end

local t8 = {}

local function hookButton(p56) -- line: 335
    -- upvalues: TweenService (copy), JerezRaceHUD (copy), v1 (copy), v2 (copy), v3 (copy), t7 (copy), t8 (copy)
    if p56:IsA("GuiButton") and not p56:GetAttribute("HoverHooked") and not p56:GetAttribute("NoHover") then
        local TouchControls = JerezRaceHUD:FindFirstChild("TouchControls")

        if TouchControls and p56:IsDescendantOf(TouchControls) then
            return
        end

        p56:SetAttribute("HoverHooked", true)

        local Icon = p56:FindFirstChild("Icon")
        local v69 = p56:GetAttribute("ReferenceTile") == true
        local v70 = Icon ~= nil and p56.BackgroundTransparency >= 0.99 and not p56:FindFirstChild("Plate")
        local TextLabel = Icon and Icon:FindFirstChildOfClass("TextLabel")
        local v71 = false
        local BackgroundColor3, BackgroundTransparency
        local v72 = Icon and Icon.Position
        local v73 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween, tween2, tween3

        local function swap(p57, p58) -- line: 354
            if p57 then
                p57:Cancel()
            end

            p58:Play()

            return p58
        end

        local function set(p59) -- line: 355
            -- upvalues: p56 (copy), Icon (copy), v71 (ref), BackgroundColor3 (ref), BackgroundTransparency (ref), v72 (ref), v73 (copy), tween (ref), tween2 (ref), tween3 (ref), v69 (copy), v70 (copy), TextLabel (copy), TweenService (copy), v1 (copy), v2 (copy), v3 (copy), t7 (copy), t8 (copy)
            if not p59 then
                t8[p56] = nil
            end

            if p59 == v71 then
                return
            end

            v71 = p59

            local v74 = Icon and t7[Icon]
            local v75

            if v74 then
                local _ = workspace.CurrentCamera.ViewportSize

                v75 = v74.position
            else
                v75 = v72
            end

            v72 = v75

            if v69 then
                local Plate = p56:FindFirstChild("Plate")

                if Plate then
                    local tween2 = tween
                    local tween3 = TweenService:Create(Plate, v73, {
                        ImageColor3 = p59 and v1 or v2
                    })

                    if tween2 then
                        tween2:Cancel()
                    end

                    tween3:Play()
                    tween = tween3
                end
            elseif v70 then
                local tween = tween2
                local v76 = if p59 then v1 else nil

                if not p59 or not v76 then
                    v76 = v3
                end

                local tween3 = TweenService:Create(Icon, v73, {
                    ImageColor3 = v76
                })

                if tween then
                    tween:Cancel()
                end

                tween3:Play()
                tween2 = tween3

                if TextLabel then
                    TextLabel.TextColor3 = p59 and v1 or v3
                end
            else
                if p59 and (not tween or tween.PlaybackState ~= Enum.PlaybackState.Playing) then
                    BackgroundColor3 = p56.BackgroundColor3
                    BackgroundTransparency = p56.BackgroundTransparency
                end

                local t11, v78, t12, v79

                if p59 then
                    local t13 = {
                        BackgroundColor3 = v1,
                        BackgroundTransparency = math.min(BackgroundTransparency or 0, 0.05)
                    }

                    if t13 then
                        t12 = t13
                        v79 = true
                    else
                        t11 = {}
                        v78 = BackgroundColor3 or p56.BackgroundColor3
                        v79 = false
                    end
                else
                    t11 = {}
                    v78 = BackgroundColor3 or p56.BackgroundColor3
                    v79 = false
                end

                if not v79 then
                    t12 = t11
                    t11.BackgroundColor3 = v78
                    t11.BackgroundTransparency = BackgroundTransparency or p56.BackgroundTransparency
                end

                local tween2 = tween
                local tween3 = TweenService:Create(p56, v73, t12)

                if tween2 then
                    tween2:Cancel()
                end

                tween3:Play()
                tween = tween3
            end

            if not Icon then
                return
            end

            local v81 = math.max(p56.Size.Y.Offset, 1)
            local v83 = v72
            local v82 = v83 + UDim2.fromScale(0, -4 / v81)
            local tween4 = tween3
            local tween5 = TweenService:Create(Icon, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = p59 and v82 or v72
            })

            if tween4 then
                tween4:Cancel()
            end

            tween5:Play()
            tween3 = tween5
        end

        local v85 = p56:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", p56)
        local v86 = p56.Parent and p56.Parent:FindFirstChildWhichIsA("UIGridStyleLayout") ~= nil
        local v87 = false
        local Scale
        local t15 = {}

        t15[1] = nil

        local tween4, v88

        local function down() -- line: 386
            -- upvalues: p56 (copy), v87 (ref), Scale (ref), t15 (copy), tween4 (ref), v88 (ref), v86 (copy), v85 (copy), TweenService (copy)
            if v87 then
                return
            end

            if not tween4 or tween4.PlaybackState ~= Enum.PlaybackState.Playing then
                Scale = v85.Scale
                t15[1] = p56.Position
            end

            v87 = true

            local v89 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = tween4
            local tween2 = TweenService:Create(v85, v89, {
                Scale = Scale * 0.86
            })

            if tween then
                tween:Cancel()
            end

            tween2:Play()
            tween4 = tween2

            if v86 then
                return
            end

            local AbsoluteSize = p56.AbsoluteSize
            local v90 = (0.5 - p56.AnchorPoint.X) * 0.14
            local v91 = (0.5 - p56.AnchorPoint.Y) * 0.14
            local v92 = v88
            local tween3 = TweenService:Create(p56, v89, {
                Position = t15[1] + UDim2.fromOffset(AbsoluteSize.X * v90, AbsoluteSize.Y * v91)
            })

            if v92 then
                v92:Cancel()
            end

            tween3:Play()
            v88 = tween3
        end

        local function up() -- line: 400
            -- upvalues: p56 (copy), v87 (ref), Scale (ref), t15 (copy), tween4 (ref), v88 (ref), v86 (copy), v85 (copy), TweenService (copy)
            if not v87 then
                return
            end

            v87 = false

            local v93 = TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local tween = tween4
            local tween2 = TweenService:Create(v85, v93, {
                Scale = Scale
            })

            if tween then
                tween:Cancel()
            end

            tween2:Play()
            tween4 = tween2

            if not v86 and t15[1] then
                local v95 = v88
                local v94 = TweenService:Create(p56, v93, {
                    Position = t15[1]
                })

                if v95 then
                    v95:Cancel()
                end

                v94:Play()
                v88 = v94
            end
        end

        p56.MouseEnter:Connect(function() -- line: 408
            -- upvalues: p56 (copy), set (copy), up (copy), t8 (copy)
            for v96, v97 in t8 do
                if v96 ~= p56 then
                    v97()
                end
            end

            set(true)

            t8[p56] = function() -- line: 410
                -- upvalues: set (copy), up (copy)
                set(false)
                up()
            end
        end)
        p56.MouseLeave:Connect(function() -- line: 412
            -- upvalues: set (copy), up (copy)
            set(false)
            up()
        end)
        p56.InputBegan:Connect(function(p60) -- line: 413
            -- upvalues: set (copy), down (copy)
            if p60.UserInputType == Enum.UserInputType.Touch then
                set(true)
                down()
            elseif p60.UserInputType == Enum.UserInputType.MouseButton1 then
                down()
            end
        end)
        p56.InputEnded:Connect(function(p61) -- line: 417
            -- upvalues: set (copy), up (copy)
            if p61.UserInputType == Enum.UserInputType.Touch then
                set(false)
                up()
            elseif p61.UserInputType == Enum.UserInputType.MouseButton1 then
                up()
            end
        end)
        p56.SelectionGained:Connect(function() -- line: 421
            -- upvalues: set (copy)
            set(true)
        end)
        p56.SelectionLost:Connect(function() -- line: 421
            -- upvalues: set (copy)
            set(false)
        end)
        p56:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 422
            -- upvalues: p56 (copy), Icon (copy), v71 (ref), BackgroundColor3 (ref), BackgroundTransparency (ref), v72 (ref), tween (ref), tween2 (ref), tween3 (ref), up (copy), v69 (copy), v70 (copy), TextLabel (copy), v2 (copy), v3 (copy), t8 (copy)
            if not p56.Visible and v71 then
                v71 = false
                t8[p56] = nil

                if tween then
                    tween:Cancel()
                end

                if tween2 then
                    tween2:Cancel()
                end

                if tween3 then
                    tween3:Cancel()
                end

                if v69 and p56:FindFirstChild("Plate") then
                    p56.Plate.ImageColor3 = v2
                end

                if v70 then
                    Icon.ImageColor3 = v3

                    if TextLabel then
                        TextLabel.TextColor3 = v3
                    end
                else
                    p56.BackgroundColor3 = BackgroundColor3 or p56.BackgroundColor3
                    p56.BackgroundTransparency = BackgroundTransparency or p56.BackgroundTransparency
                end

                if Icon then
                    Icon.Position = v72
                end
            end

            up()
        end)
    end
end

local t16 = {}

local function addHoverRoot(p62) -- line: 436
    -- upvalues: hookButton (copy), t16 (copy)
    if t16[p62]
        or not p62:IsA("LayerCollector")
        or p62.Name == "HDAdmin"
        or p62.Name == "TopbarStandard"
        or p62.Name == "TouchGui"
        or p62.Name == "ProximityPrompts" then
        return
    end

    t16[p62] = true

    for _, descendant in p62:GetDescendants() do
        hookButton(descendant)
    end

    p62.DescendantAdded:Connect(function(p63) -- line: 441
        -- upvalues: hookButton (copy)
        task.defer(hookButton, p63)
    end)
end

addHoverRoot(JerezRaceHUD)
addHoverRoot(ScreenGui)

for _, child in LocalPlayer.PlayerGui:GetChildren() do
    addHoverRoot(child)
end

LocalPlayer.PlayerGui.ChildAdded:Connect(addHoverRoot)

local function myBike() -- line: 448
    -- upvalues: LocalPlayer (copy)
    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if RaceBikes then
        for _, child in RaceBikes:GetChildren() do
            if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                return child
            end
        end
    end
end

local function riding() -- line: 452
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v99 = Humanoid and Humanoid.SeatPart

    return v99 ~= nil and v99.Name == "RiderSeat"
end

local function crashing() -- line: 456
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    return Character ~= nil and Character:GetAttribute("RaceCrashActive") == true
end

local t17 = {
    Grid = true,
    Lights = true,
    Racing = true
}

local function sprintMode() -- line: 459
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), t17 (copy)
    if LocalPlayer:GetAttribute("RaceParticipant") ~= true or LocalPlayer:GetAttribute("RaceFinished") == true then
        return false
    end

    return t17[MotoLegends:GetAttribute("SessionPhase") or ""] == true
end

local function resetLocked() -- line: 465
    -- upvalues: LocalPlayer (copy), MotoLegends (copy)
    if LocalPlayer:GetAttribute("RaceRewardPending") == true then
        return true
    end

    return MotoLegends:GetAttribute("PodiumActive") == true
end

local function applyResetLock() -- line: 466
    -- upvalues: LocalPlayer (copy), MotoLegends (copy)
    local v100 = not (LocalPlayer:GetAttribute("RaceRewardPending") == true or MotoLegends:GetAttribute("PodiumActive") == true)

    task.spawn(function() -- line: 468
        -- upvalues: v100 (copy), LocalPlayer (copy), MotoLegends (copy)
        local StarterGui = game:GetService("StarterGui")

        for _ = 1, 20 do
            if (LocalPlayer:GetAttribute("RaceRewardPending") == true or MotoLegends:GetAttribute("PodiumActive") == true) ~= not v100 then
                return
            end

            local SetCore = StarterGui.SetCore

            if pcall(SetCore, StarterGui, "ResetButtonCallback", v100) then
                return
            end

            task.wait(0.5)
        end
    end)
end

LocalPlayer:GetAttributeChangedSignal("RaceRewardPending"):Connect(applyResetLock)
MotoLegends:GetAttributeChangedSignal("PodiumActive"):Connect(applyResetLock)

local v101

if LocalPlayer:GetAttribute("RaceRewardPending") == true or MotoLegends:GetAttribute("PodiumActive") == true then
    v101 = LocalPlayer:GetAttribute("RaceRewardPending") == true or MotoLegends:GetAttribute("PodiumActive") == true

    local v102 = not v101

    task.spawn(function() -- line: 468
        -- upvalues: LocalPlayer (copy), MotoLegends (copy), v102 (copy)
        local StarterGui = game:GetService("StarterGui")

        for _ = 1, 20 do
            if (LocalPlayer:GetAttribute("RaceRewardPending") == true or MotoLegends:GetAttribute("PodiumActive") == true) ~= not v102 then
                return
            end

            local SetCore = StarterGui.SetCore

            if pcall(SetCore, StarterGui, "ResetButtonCallback", v102) then
                return
            end

            task.wait(0.5)
        end
    end)
end

local v103 = false

local function closeSettings() -- line: 486
    -- upvalues: JerezRaceHUD (copy)
    JerezRaceHUD:SetAttribute("LobbySettings", false)

    for _, v104 in { "RaceSettings", "GraphicsSettingsPanel", "CustomInputs" } do
        local v105 = JerezRaceHUD:FindFirstChild(v104)

        if v105 then
            v105.Visible = false
        end
    end
end

v101 = require(MotoLegends:WaitForChild("BikeMenu")).New(ScreenGui, JerezRaceHUD, LocalPlayer, notice)

local Frame2, _ = v101.Frame, v101.SpawnButton
local Frame3 = require(MotoLegends:WaitForChild("LegendsMenu")).New(ScreenGui, JerezRaceHUD, LocalPlayer, notice).Frame

v36 = function() -- line: 494
    -- upvalues: Frame2 (copy), Frame3 (copy)
    return Frame2.Visible or Frame3.Visible
end

v24.Activated:Connect(function() -- line: 495
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), notice (copy), t17 (copy), closeSettings (copy), Frame2 (copy), Frame3 (copy)
    if LocalPlayer:GetAttribute("RaceRewardPending") == true then
        notice("WAIT FOR THE RACE RESULTS")
    else
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid and Humanoid.PlatformStand then
            return
        end

        if LocalPlayer:GetAttribute("RaceParticipant") == true and LocalPlayer:GetAttribute("RaceFinished") ~= true and t17[MotoLegends:GetAttribute("SessionPhase") or ""] == true then
            local Character = LocalPlayer.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local v106 = Humanoid and Humanoid.SeatPart

            if v106 == nil or v106.Name ~= "RiderSeat" then
                local Character = LocalPlayer.Character

                if Character == nil or Character:GetAttribute("RaceCrashActive") ~= true then
                    closeSettings()
                    Frame3.Visible = false
                    Frame2.Visible = false
                    MotoLegends.SpawnBike:FireServer()
                end
            end
        else
            closeSettings()
            Frame3.Visible = false
            Frame2.Visible = not Frame2.Visible
        end
    end
end)

local ChampionshipEvent = MotoLegends:WaitForChild("ChampionshipEvent")
local v107 = false

local function setExitOpen(p64) -- line: 511
    -- upvalues: clone (copy), Confirm (copy), v107 (ref)
    v107 = p64
    clone.Visible = p64
    Confirm.Modal = p64
end

local v108 = false

local function setRetireOpen(p65) -- line: 516
    -- upvalues: RetireConfirm (copy), TextButton (copy), v108 (ref)
    v108 = p65
    RetireConfirm.Visible = p65
    TextButton.Modal = p65
end

v25.Activated:Connect(function() -- line: 520
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), RetireConfirm (copy), TextButton (copy), clone (copy), Confirm (copy), t17 (copy), closeSettings (copy), v107 (ref), v108 (ref)
    if LocalPlayer:GetAttribute("RaceParticipant") == true and LocalPlayer:GetAttribute("RaceFinished") ~= true and t17[MotoLegends:GetAttribute("SessionPhase") or ""] == true then
        closeSettings()
        v107 = false
        clone.Visible = false
        Confirm.Modal = false

        local v109 = not v108

        v108 = v109
        RetireConfirm.Visible = v109
        TextButton.Modal = v109
    end
end)
TextButton2.Activated:Connect(function() -- line: 524
    -- upvalues: RetireConfirm (copy), TextButton (copy), v108 (ref)
    v108 = false
    RetireConfirm.Visible = false
    TextButton.Modal = false
end)

local v110 = MotoLegends:FindFirstChild("CloseMenus") or Instance.new("BindableEvent")

v110.Name = "CloseMenus"
v110.Parent = MotoLegends

local function closeAll(p66) -- line: 529
    -- upvalues: RetireConfirm (copy), TextButton (copy), clone (copy), Confirm (copy), Frame2 (copy), Frame3 (copy), v107 (ref), v108 (ref)
    if p66 ~= "Legends" and Frame3.Visible then
        Frame3.Visible = false
    end

    if p66 ~= "Bikes" and Frame2.Visible then
        Frame2.Visible = false
    end

    if v108 then
        v108 = false
        RetireConfirm.Visible = false
        TextButton.Modal = false
    end

    if not v107 then
        return
    end

    v107 = false
    clone.Visible = false
    Confirm.Modal = false
end

v110.Event:Connect(closeAll)
Frame2:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 537
    -- upvalues: Frame2 (copy), v110 (copy)
    if Frame2.Visible then
        v110:Fire("Bikes")
    end
end)
Frame3:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 538
    -- upvalues: Frame3 (copy), v110 (copy)
    if Frame3.Visible then
        v110:Fire("Legends")
    end
end)
JerezRaceHUD:GetAttributeChangedSignal("LobbySettings"):Connect(function() -- line: 539
    -- upvalues: JerezRaceHUD (copy), RetireConfirm (copy), TextButton (copy), clone (copy), Confirm (copy), Frame2 (copy), Frame3 (copy), v107 (ref), v108 (ref)
    if JerezRaceHUD:GetAttribute("LobbySettings") ~= true then
        return
    end

    if Frame3.Visible then
        Frame3.Visible = false
    end

    if Frame2.Visible then
        Frame2.Visible = false
    end

    if v108 then
        v108 = false
        RetireConfirm.Visible = false
        TextButton.Modal = false
    end

    if not v107 then
        return
    end

    v107 = false
    clone.Visible = false
    Confirm.Modal = false
end)
TextButton.Activated:Connect(function() -- line: 541
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), RetireConfirm (copy), TextButton (copy), t17 (copy), ChampionshipEvent (copy), v108 (ref)
    if not v108 then
        return
    end

    v108 = false
    RetireConfirm.Visible = false
    TextButton.Modal = false

    if LocalPlayer:GetAttribute("RaceParticipant") == true and LocalPlayer:GetAttribute("RaceFinished") ~= true and t17[MotoLegends:GetAttribute("SessionPhase") or ""] == true then
        ChampionshipEvent:FireServer("Retire")
    end
end)

local v111 = false
local n2 = 0
local v112 = MotoLegends:WaitForChild("ExitToMenu", 10)

local function exitFailed() -- line: 554
    -- upvalues: notice (copy), v111 (ref)
    if v111 then
        v111 = false
        notice("EXIT FAILED, TRY AGAIN")
    end
end

local function exitToMenu() -- line: 558
    -- upvalues: TeleportService (copy), LocalPlayer (copy), MotoLegends (copy), v2 (copy), notice (copy), v111 (ref), n2 (ref), v112 (ref)
    if v111 then
        return
    end

    v111 = true
    n2 += 1

    local v113 = n2

    notice("RETURNING TO MAIN MENU...")

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "ExitTeleportCover"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 1000

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = v2
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local function v114() -- line: 564
        -- upvalues: ScreenGui (copy), TeleportService (copy)
        TeleportService:SetTeleportGui(ScreenGui)
    end

    pcall(v114)
    v112 = v112 or MotoLegends:FindFirstChild("ExitToMenu")

    if v112 then
        v112:FireServer()
    else
        local function v115() -- line: 568
            -- upvalues: TeleportService (copy), LocalPlayer (copy)
            TeleportService:Teleport(111858957359750, LocalPlayer)
        end

        if not pcall(v115) then
            if v111 then
                v111 = false
                notice("EXIT FAILED, TRY AGAIN")
            end

            return
        end
    end

    task.delay(20, function() -- line: 571
        -- upvalues: v113 (copy), notice (copy), v111 (ref), n2 (ref)
        if not v111 or n2 ~= v113 or not v111 then
            return
        end

        v111 = false
        notice("EXIT FAILED, TRY AGAIN")
    end)
end

if v112 then
    v112.OnClientEvent:Connect(function(p67) -- line: 573
        -- upvalues: notice (copy), v111 (ref)
        if p67 ~= "Failed" or not v111 then
            return
        end

        v111 = false
        notice("EXIT FAILED, TRY AGAIN")
    end)
end

TeleportService.TeleportInitFailed:Connect(function(p68) -- line: 574
    -- upvalues: LocalPlayer (copy), notice (copy), v111 (ref)
    if p68 ~= LocalPlayer or not v111 or not v111 then
        return
    end

    v111 = false
    notice("EXIT FAILED, TRY AGAIN")
end)
top4.Activated:Connect(function() -- line: 575
    -- upvalues: JerezRaceHUD (copy), RetireConfirm (copy), TextButton (copy), clone (copy), Confirm (copy), closeSettings (copy), v107 (ref), v108 (ref)
    closeSettings()
    v108 = false
    RetireConfirm.Visible = false
    TextButton.Modal = false
    JerezRaceHUD:SetAttribute("ServerListOpen", false)

    local v116 = not v107

    v107 = v116
    clone.Visible = v116
    Confirm.Modal = v116
end)

local function rdAvailable() -- line: 581
    -- upvalues: LocalPlayer (copy), MotoLegends (copy)
    if MotoLegends:GetAttribute("RaceDirectorServer") == true then
        return LocalPlayer:GetAttribute("RaceDirectorAccess") == true
    end

    return false
end

local v117 = false

local function setRDMode(p69) -- line: 583
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), JerezRaceHUD (copy), RetireConfirm (copy), TextButton (copy), clone (copy), Confirm (copy), closeSettings (copy), Frame2 (copy), Frame3 (copy), v107 (ref), v108 (ref), v117 (ref)
    local v118 = p69 == true and MotoLegends:GetAttribute("RaceDirectorServer") == true and LocalPlayer:GetAttribute("RaceDirectorAccess") == true

    if v118 == v117 then
        return
    end

    v117 = v118
    JerezRaceHUD:SetAttribute("RaceDirectorMode", v118)

    if not v118 then
        JerezRaceHUD:SetAttribute("RaceDirectorPanel", nil)

        return
    end

    closeSettings()
    v108 = false
    RetireConfirm.Visible = false
    TextButton.Modal = false
    v107 = false
    clone.Visible = false
    Confirm.Modal = false
    Frame2.Visible = false
    Frame3.Visible = false
    JerezRaceHUD:SetAttribute("ServerListOpen", false)
end

local v119

local function applyRDTile() -- line: 592
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), UIArt (copy), top3 (copy), setRDMode (copy), v119 (ref)
    local v120 = if MotoLegends:GetAttribute("RaceDirectorServer") == true and LocalPlayer:GetAttribute("RaceDirectorAccess") == true then "RaceDirectorIcon" else "ServerIcon"

    if v120 ~= v119 then
        v119 = v120

        local Icon = top3:FindFirstChild("Icon")

        if Icon then
            UIArt.Apply(Icon, v120)
        end
    end

    if MotoLegends:GetAttribute("RaceDirectorServer") ~= true or LocalPlayer:GetAttribute("RaceDirectorAccess") ~= true then
        setRDMode(false)
    end
end

MotoLegends:GetAttributeChangedSignal("RaceDirectorServer"):Connect(applyRDTile)
LocalPlayer:GetAttributeChangedSignal("RaceDirectorAccess"):Connect(applyRDTile)
applyRDTile()

for _, v121 in t2 do
    v121.btn.Activated:Connect(function() -- line: 601
        -- upvalues: JerezRaceHUD (copy), v117 (ref), v121 (copy)
        if not v117 then
            return
        end

        JerezRaceHUD:SetAttribute("RaceDirectorPanel", JerezRaceHUD:GetAttribute("RaceDirectorPanel") ~= v121.panel and v121.panel or nil)
    end)
end

top3.Activated:Connect(function() -- line: 608
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), JerezRaceHUD (copy), RetireConfirm (copy), TextButton (copy), clone (copy), Confirm (copy), v103 (ref), closeSettings (copy), Frame2 (copy), Frame3 (copy), v107 (ref), v108 (ref), v117 (ref), setRDMode (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v122 = Humanoid and Humanoid.SeatPart
    local v123, v124, v125

    if v122 == nil or v122.Name ~= "RiderSeat" then
        local Character = LocalPlayer.Character

        if Character == nil or Character:GetAttribute("RaceCrashActive") ~= true then
            v123 = MotoLegends:GetAttribute("RaceDirectorServer") == true and LocalPlayer:GetAttribute("RaceDirectorAccess") == true

            if v123 then
                v124 = v117
                setRDMode(not v124)
            else
                v125 = JerezRaceHUD:GetAttribute("ServerListOpen") == true

                if not v125 then
                    closeSettings()
                    v108 = false
                    RetireConfirm.Visible = false
                    TextButton.Modal = false
                    v107 = false
                    clone.Visible = false
                    Confirm.Modal = false
                    Frame2.Visible = false
                    Frame3.Visible = false
                end

                JerezRaceHUD:SetAttribute("ServerListOpen", not v125)
            end

            return
        end
    end

    if not v103 then
        return
    end

    v123 = MotoLegends:GetAttribute("RaceDirectorServer") == true and LocalPlayer:GetAttribute("RaceDirectorAccess") == true

    if v123 then
        v124 = v117
        setRDMode(not v124)
    else
        v125 = JerezRaceHUD:GetAttribute("ServerListOpen") == true

        if not v125 then
            closeSettings()
            v108 = false
            RetireConfirm.Visible = false
            TextButton.Modal = false
            v107 = false
            clone.Visible = false
            Confirm.Modal = false
            Frame2.Visible = false
            Frame3.Visible = false
        end

        JerezRaceHUD:SetAttribute("ServerListOpen", not v125)
    end
end)
Close.Activated:Connect(function() -- line: 615
    -- upvalues: clone (copy), Confirm (copy), v107 (ref)
    v107 = false
    clone.Visible = false
    Confirm.Modal = false
end)
Confirm.Activated:Connect(function() -- line: 616
    -- upvalues: clone (copy), Confirm (copy), v107 (ref), exitToMenu (copy)
    if not v107 then
        return
    end

    v107 = false
    clone.Visible = false
    Confirm.Modal = false
    exitToMenu()
end)
v13.Activated:Connect(function() -- line: 620
    -- upvalues: LocalPlayer (copy), closeSettings (copy), Frame2 (copy), Frame3 (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v126 = Humanoid and Humanoid.SeatPart

    if v126 == nil or v126.Name ~= "RiderSeat" then
        local Character = LocalPlayer.Character

        if Character == nil or Character:GetAttribute("RaceCrashActive") ~= true then
            closeSettings()
            Frame2.Visible = false
            Frame3.Visible = not Frame3.Visible
        end
    end
end)

local n3 = 0

corner2.Activated:Connect(function() -- line: 625
    -- upvalues: JerezRaceHUD (copy), n3 (ref)
    if os.clock() - n3 < 0.25 then
        return
    end

    n3 = os.clock()

    local LapLeaderboard = JerezRaceHUD:FindFirstChild("LapLeaderboard")

    if LapLeaderboard then
        LapLeaderboard.Visible = not LapLeaderboard.Visible
    end
end)
top2.Activated:Connect(function() -- line: 629
    -- upvalues: JerezRaceHUD (copy), closeSettings (copy)
    local RaceSettings = JerezRaceHUD:FindFirstChild("RaceSettings")

    if not RaceSettings then
        return
    end

    local v127 = false

    for _, v128 in { "RaceSettings", "GraphicsSettingsPanel", "CustomInputs" } do
        local v129 = JerezRaceHUD:FindFirstChild(v128)

        if v129 and v129.Visible then
            v127 = true
        end
    end

    if v127 then
        closeSettings()
    else
        JerezRaceHUD:SetAttribute("LobbySettings", true)
        RaceSettings.Visible = true
    end
end)
v14.Activated:Connect(function() -- line: 634
    -- upvalues: notice (copy)
    notice("COMING SOON")
end)
v15.Activated:Connect(function() -- line: 636
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), notice (copy), closeSettings (copy), Frame2 (copy), Frame3 (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v130 = Humanoid and Humanoid.SeatPart

    if v130 == nil or v130.Name ~= "RiderSeat" then
        local Character = LocalPlayer.Character

        if Character == nil or Character:GetAttribute("RaceCrashActive") ~= true then
            closeSettings()
            Frame2.Visible = false
            Frame3.Visible = false

            local OpenShop = MotoLegends:FindFirstChild("OpenShop")

            if OpenShop then
                OpenShop:Fire()
            else
                notice("LOADING...")
            end
        end
    end
end)

local BikeCams = require(MotoLegends:WaitForChild("BikeCams"))
local t18 = {
    "THIRD PERSON",
    "FIRST PERSON",
    "FRONT TYRE CAM",
    "REAR TYRE CAM",
    "TAIL CAM",
    "TV CAM",
    "HELICOPTER",
    "RIDER DASHCAM",
    "HIGH CHASE"
}
local t19 = {
    0, 8, 1, 2, 3, 4, 5, 6,
    7
}
local v131 = Config.Track == "Sepang" and {
    Gain = 0.16,
    Max = 0.20943951023931956,
    Ease = 4
} or nil
local v132 = false
local UserId
local n4 = 0
local t20 = {}
local t21 = t20

t20.tv = {}
t20.heli = {}

local t22 = {}
local v133 = nil
local v134 = nil
local t23 = {}
local v135 = nil
local v136
local t24 = {}

t24[1] = nil

local v137
local RemoteBikes = require(MotoLegends:WaitForChild("RemoteBikes"))
local v138

local function restoreHidden() -- line: 667
    -- upvalues: t23 (ref)
    for v139, v140 in t23 do
        if v139.Parent then
            v139.LocalTransparencyModifier = v140
        end
    end

    t23 = {}
end

local function pickTarget() -- line: 668
    -- upvalues: Players (copy), LocalPlayer (copy)
    local t25 = {}

    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer then
            table.insert(t25, player)
        end
    end

    if #t25 == 0 then
        return nil
    end

    local n5 = 1e999
    local v141

    for _, v142 in t25 do
        local v143 = v142:GetAttribute("BestLapTime") or 0

        if v143 > 0 and v143 < n5 then
            n5 = v143
            v141 = v142
        end
    end

    return v141 or t25[math.random(#t25)]
end

local function stopSpectate() -- line: 675
    -- upvalues: RunService (copy), LocalPlayer (copy), JerezRaceHUD (copy), Players2 (copy), Modes (copy), v132 (ref), UserId (ref), t23 (ref)
    if not v132 then
        return
    end

    v132 = false
    UserId = nil
    Players2.Visible = false
    Modes.Visible = false

    for v144, v145 in t23 do
        if v144.Parent then
            v144.LocalTransparencyModifier = v145
        end
    end

    t23 = {}
    JerezRaceHUD:SetAttribute("SpectateTargetId", nil)
    JerezRaceHUD:SetAttribute("SpectateCamMode", nil)
    RunService:UnbindFromRenderStep("LobbySpectate")

    local CurrentCamera = workspace.CurrentCamera

    CurrentCamera.CameraType = Enum.CameraType.Custom

    local v146 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if v146 then
        CurrentCamera.CameraSubject = v146
    end

    CurrentCamera.FieldOfView = 70
    JerezRaceHUD:SetAttribute("LobbySpectating", false)
end

JerezRaceHUD:GetAttributeChangedSignal("Freecam"):Connect(function() -- line: 684
    -- upvalues: JerezRaceHUD (copy), v132 (ref), stopSpectate (copy)
    if JerezRaceHUD:GetAttribute("Freecam") == true and v132 then
        stopSpectate()
    end
end)

local function targetRoot(p70) -- line: 687
    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if RaceBikes then
        for _, child in RaceBikes:GetChildren() do
            if child:GetAttribute("OwnerUserId") == p70.UserId and child.PrimaryPart and child:GetAttribute("Crash") == "" then
                local RiderSeat = child:FindFirstChild("RiderSeat")

                if RiderSeat and RiderSeat.Occupant then
                    return child.PrimaryPart, true
                end
            end
        end
    end

    return p70.Character and p70.Character:FindFirstChild("HumanoidRootPart"), false
end

local function crashedBikeRoot(p71) -- line: 694
    for _, v147 in { "RaceBikes", "CrashedBikes" } do
        local v148 = workspace:FindFirstChild(v147)

        if v148 then
            for _, child in v148:GetChildren() do
                if child:GetAttribute("OwnerUserId") == p71.UserId and child.PrimaryPart and (child:GetAttribute("Crash") or "") ~= "" then
                    return child.PrimaryPart
                end
            end
        end
    end
end

local function startSpectate(p72) -- line: 702
    -- upvalues: Players (copy), RunService (copy), LocalPlayer (copy), Config (copy), JerezRaceHUD (copy), notice (copy), closeSettings (copy), BikeCams (copy), v131 (copy), v132 (ref), UserId (ref), n4 (ref), t21 (ref), t22 (ref), v133 (ref), v134 (ref), t23 (ref), v135 (ref), v136 (ref), t24 (copy), v137 (ref), RemoteBikes (copy), v138 (ref), pickTarget (copy), stopSpectate (copy), targetRoot (copy)
    p72 = p72 or pickTarget()

    if not p72 then
        notice("NO RIDERS TO SPECTATE")

        return
    end

    UserId = p72.UserId
    v133 = nil
    v134 = nil
    v135 = nil
    v136 = nil
    t24[1] = nil
    v137 = nil
    v138 = nil
    t21 = {
        tv = {},
        heli = {}
    }
    t22 = {}

    for v150, v151 in t23 do
        if v150.Parent then
            v150.LocalTransparencyModifier = v151
        end
    end

    t23 = {}

    local UserId2 = UserId

    JerezRaceHUD:SetAttribute("SpectateTargetId", UserId2)

    if not v132 then
        v132 = true
        JerezRaceHUD:SetAttribute("LobbySpectating", true)
        closeSettings()
        RunService:BindToRenderStep("LobbySpectate", Enum.RenderPriority.Camera.Value + 2, function(p73) -- line: 708
            -- upvalues: Players (copy), LocalPlayer (copy), Config (copy), JerezRaceHUD (copy), BikeCams (copy), v131 (copy), UserId (ref), n4 (ref), t21 (ref), t22 (ref), v133 (ref), v134 (ref), t23 (ref), v135 (ref), v136 (ref), t24 (copy), RemoteBikes (copy), v138 (ref), pickTarget (copy), stopSpectate (copy), targetRoot (copy)
            local v152 = Players:GetPlayerByUserId(UserId or 0)
            local Unit

            if not v152 then
                v152 = pickTarget()

                if not v152 then
                    stopSpectate()

                    return
                end

                UserId = v152.UserId
                Unit = UserId
                JerezRaceHUD:SetAttribute("SpectateTargetId", Unit)
            end

            local v153, v154 = targetRoot(v152)

            if not v153 then
                return
            end

            local v155 = v154 and RemoteBikes.Velocity(v152.UserId) or nil
            local CurrentCamera = workspace.CurrentCamera

            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.Focus = CFrame.new(v153.Position + Vector3.new(0, 1.5, 0))

            local X = v153.CFrame.LookVector.X

            Unit = Vector3.new(X, 0, v153.CFrame.LookVector.Z)

            if Unit.Magnitude < 0.01 then
                Unit = Vector3.new(0, 0, -1)
            end

            Unit = Unit.Unit

            local Magnitude = v154 and v153.AssemblyLinearVelocity.Magnitude or 0
            local Character = v152.Character

            v152 = Character and Character:FindFirstChild("Head")

            local v156 = n4
            local v157 = n4 == 8

            if v157 then
                v156 = 0
            end

            local v158 = n4 == 2 or n4 == 3 or n4 == 4 or n4 == 7

            if Character and Character:GetAttribute("RaceCrashActive") == true and v158 then
                v156 = 0
            end

            v158 = v155 or v153.AssemblyLinearVelocity

            local v159 = v135
            local Position, v160, Unit2

            if not v159 or (v153.Position - v135).Magnitude > 60 then
                v135 = v153.Position
                v136 = Unit
            elseif v155 then
                v135 = v153.Position
                v159 = v136
                v160 = -p73 * 8
                v159 = v159:Lerp(Unit, 1 - math.exp(v160))
                v136 = v159.Magnitude > 0.05 and v159.Unit or Unit
            else
                v159 = v135 + v158 * p73
                Position = v153.Position
                v160 = -p73 * 9
                v135 = v159:Lerp(Position, 1 - math.exp(v160))
                v159 = v136
                v160 = -p73 * 8
                v159 = v159:Lerp(Unit, 1 - math.exp(v160))
                Unit2 = v159.Magnitude > 0.05 and v159.Unit or Unit
                v136 = Unit2
            end

            v159 = math.clamp(Magnitude / 360, 0, 1)

            local v163

            if JerezRaceHUD:GetAttribute("SpectateCamMode") ~= n4 then
                v163 = n4
                JerezRaceHUD:SetAttribute("SpectateCamMode", v163)
            end

            local v164 = (v156 == 2 or v156 == 3 or v156 == 4 or v156 == 7) and v154 and ({
                [2] = BikeCams.FrontTyre,
                [3] = BikeCams.RearTyre,
                [4] = BikeCams.Tail,
                [7] = BikeCams.Dash
            })[v156]

            if not v164 and v156 ~= 5 and v156 ~= 6 then
                if v156 ~= 1 or not v152 then
                    if v156 == 0 and Character and Character:GetAttribute("RaceCrashActive") == true and Character:FindFirstChild("HumanoidRootPart") then
                        if next(t23) then
                            for v165, v166 in t23 do
                                if v165.Parent then
                                    v165.LocalTransparencyModifier = v166
                                end
                            end

                            t23 = {}
                        end

                        t24[1] = nil
                        v133 = nil
                        v134 = nil
                        Position = t22
                        Position.pos = nil
                        Position = t22
                        Position.look = nil
                        Position = t22
                        Position.prev = nil
                        Position = Character.HumanoidRootPart

                        local v167 = Vector3.new(Position.AssemblyLinearVelocity.X, 0, Position.AssemblyLinearVelocity.Z)
                        local Unit = t22.crashHeading
                        local v168

                        if not Unit then
                            Unit = t22.heading

                            if not Unit then
                                v160 = CurrentCamera.CFrame.LookVector.X
                                v168 = CurrentCamera.CFrame.LookVector.Z
                                Unit = Vector3.new(v160, 0, v168)
                            end
                        end

                        if Unit.Magnitude < 0.05 then
                            Unit = Vector3.new(0, 0, -1)
                        end

                        local v169

                        if v167.Magnitude > 3 then
                            v160 = Unit.Unit
                            v168 = v167.Unit
                            v169 = -p73 * 2.5
                            Unit = v160:Lerp(v168, 1 - math.exp(v169))
                        end

                        local v170 = Unit.Magnitude > 0.05
                        local Unit2 = if v170 then Unit.Unit else nil

                        if not v170 or not Unit2 then
                            Unit2 = Vector3.new(0, 0, -1)
                        end

                        v160 = t22
                        v160.crashHeading = Unit2
                        v160 = t22
                        v168 = t22.crashFollow

                        local v171, v172, v173

                        if v168 then
                            v171 = t22.crashFollow
                            v172 = Position.Position
                            v173 = -p73 * 10
                            v171 = v171:Lerp(v172, 1 - math.exp(v173))
                        end

                        if not v168 or not v171 then
                            v171 = Position.Position
                        end

                        v160.crashFollow = v171
                        v171 = t22.crashFollow
                        v172 = if v157 then 17 else 15
                        Unit2 = v171 - Unit2 * v172
                        v172 = if v157 then 9.5 else 7
                        v167 = Unit2 + Vector3.new(0, 1, 0) * v172
                        Unit2 = t22
                        v168 = t22.crashPos

                        local v174

                        if v168 then
                            v174 = t22.crashPos
                            v173 = -p73 * 5
                            v174 = v174:Lerp(v167, 1 - math.exp(v173))
                        end

                        if v168 and v174 then
                            v167 = v174
                        end

                        Unit2.crashPos = v167

                        local v175 = t22.crashPos

                        for _, v176 in { "RaceBikes", "CrashedBikes" } do
                            v169 = workspace:FindFirstChild(v176)
                            Unit = v175

                            for _, v177 in v169 and v169:GetChildren() or {} do
                                Position = v177:IsA("Model") and v177.PrimaryPart

                                if Position and (Position.Position - Unit).Magnitude < 16 then
                                    local v178, v179 = v177:GetBoundingBox()
                                    local v180 = v179 * 0.5 + Vector3.new(1.3, 1.3, 1.3)
                                    local X = Unit.X
                                    local Y = v178.Position.Y
                                    local Z = Unit.Z
                                    local v181 = v178:PointToObjectSpace((Vector3.new(X, Y, Z)))
                                    local v182 = v181.X

                                    if math.abs(v182) < v180.X then
                                        v182 = v181.Y

                                        if math.abs(v182) < v180.Y then
                                            v182 = v181.Z

                                            if math.abs(v182) < v180.Z then
                                                X = v178.Position.Y

                                                local X2 = X + math.abs(v178.RightVector.Y) * v180.X

                                                Z = v178.UpVector.Y
                                                v182 = X2 + math.abs(Z) * v180.Y
                                                Y = v178.LookVector.Y
                                                v181 = v182 + math.abs(Y) * v180.Z
                                                X2 = Unit.X
                                                Y = Unit.Y
                                                Z = v181 + 0.3
                                                X = math.max(Y, Z)
                                                Y = Unit.Z
                                                Unit = Vector3.new(X2, X, Y)
                                            end
                                        end
                                    end
                                end

                                v175 = Unit
                            end
                        end

                        Unit2 = RaycastParams.new()
                        Unit2.FilterType = Enum.RaycastFilterType.Include
                        Unit2.FilterDescendantsInstances = {
                            workspace:FindFirstChild("RaceCollision", true),
                            workspace.Terrain
                        }
                        v168 = v175.X
                        v169 = v175.Y
                        v173 = t22.crashFollow.Y
                        v172 = math.max(v169, v173) + 6

                        local Unit3 = v175.Z

                        v174 = Vector3.new(v168, v172, Unit3)
                        v168 = workspace:Raycast(v174, Vector3.new(0, 1, 0) * -(v174.Y - v175.Y + 16), Unit2)

                        if v168 and v168.Normal.Y > 0.35 and v175.Y < v168.Position.Y + 1.5 then
                            Unit3 = v175.X
                            v169 = v168.Position.Y + 1.5
                            v173 = v175.Z
                            v175 = Vector3.new(Unit3, v169, v173)
                        end

                        t22.crashPos = v175
                        CurrentCamera.CFrame = CFrame.lookAt(t22.crashPos, t22.crashFollow + Vector3.new(0, 1.5, 0))
                        v174 = t22
                        v174.fov = t22.fov or Config.ChaseBaseFOV
                        CurrentCamera.FieldOfView = t22.fov
                    elseif v156 ~= 0 or not v154 then
                        if next(t23) then
                            for v183, v184 in t23 do
                                if v183.Parent then
                                    v183.LocalTransparencyModifier = v184
                                end
                            end

                            t23 = {}
                        end

                        t24[1] = nil
                        t22 = {}

                        local Unit = v135
                        local v185 = v136
                        local v186 = Magnitude / 250
                        local v188 = Unit - v185 * ((math.clamp(v186, 0, 1) * 7 + 14) * (if v157 then 1.15 else 1))

                        v185 = if v157 then 8.5 else 6
                        Position = v188 + Vector3.new(0, 1, 0) * v185
                        v188 = v135 + v136 * 3 + Vector3.new(0, 2, 0)
                        Unit = RaycastParams.new()
                        Unit.FilterType = Enum.RaycastFilterType.Include
                        Unit.FilterDescendantsInstances = {
                            workspace:FindFirstChild("RaceCollision", true),
                            workspace.Terrain
                        }

                        local Unit3 = workspace:Raycast(v188, Position - v188, Unit)

                        if Unit3 then
                            Position = Unit3.Position + Unit3.Normal * 0.7
                        end

                        if v133 and (Position - v133).Magnitude > 150 then
                            v133 = nil
                        end

                        if v155 then
                            v133 = Position
                        else
                            local v190 = Position

                            if v133 then
                                v190 = v133 + v158 * p73
                                v186 = -p73 * 12
                                v190 = v190:Lerp(Position, 1 - math.exp(v186)) or Position
                            end

                            v133 = v190

                            local v192 = v134
                            local v193

                            if v192 then
                                v193 = v134 + v158 * p73
                                v186 = -p73 * 16
                                v193 = v193:Lerp(v188, 1 - math.exp(v186))
                            end

                            if v192 and v193 then
                                v188 = v193
                            end
                        end

                        v134 = v188
                        CurrentCamera.CFrame = CFrame.lookAt(v133, v134)
                        CurrentCamera.FieldOfView = math.clamp(Magnitude / 360, 0, 1) * 20 + 62
                    else
                        if next(t23) then
                            for v195, v196 in t23 do
                                if v195.Parent then
                                    v195.LocalTransparencyModifier = v196
                                end
                            end

                            t23 = {}
                        end

                        t24[1] = nil
                        v133 = nil
                        v134 = nil
                        Position = t22
                        Position.crashHeading = nil
                        Position = t22
                        Position.crashFollow = nil
                        Position = t22
                        Position.crashPos = nil
                        Position = v153.CFrame

                        local v199 = Vector3.new(Position.LookVector.X, 0, Position.LookVector.Z)
                        local v200 = v199.Magnitude > 0.05
                        local Unit = if v200 then v199.Unit else nil

                        if not v200 or not Unit then
                            Unit = t22.heading or Vector3.new(0, 0, -1)
                        end

                        local v197 = Vector3.new(v158.X, 0, v158.Z).Magnitude * Config.StudMetres * 3.6
                        local Unit2 = math.asin((math.clamp(Position.RightVector.Y, -1, 1)))
                        local v198 = t22
                        local v201 = t22.lean
                        local v202, v203, v204, v205

                        if v201 then
                            v205 = t22.lean
                            v202 = Unit2 - t22.lean
                            v203 = -p73 * 9
                            v204 = v205 + v202 * (1 - math.exp(v203))
                        end

                        if v201 and v204 then
                            Unit2 = v204
                        end

                        v198.lean = Unit2
                        Unit2 = math.clamp(v197 / (Config.TopSpeedKph or 340), 0, 1)
                        Unit2 = Unit2 * Unit2 * (3 - Unit2 * 2)
                        Position = Config.ChaseBaseFOV + Unit2 * Config.ChaseSpeedFOV
                        v198 = t22
                        v201 = t22.fov

                        local v206

                        if v201 then
                            v205 = t22.fov
                            v202 = Position - t22.fov
                            v203 = -p73 * 4
                            v206 = v205 + v202 * (1 - math.exp(v203))
                        end

                        if v201 and v206 then
                            Position = v206
                        end

                        v198.fov = Position
                        Unit2 = math.clamp(v197 / math.max(Config.ChasePitchFullKph or 250, 1), 0, 1)
                        Unit2 = Unit2 * Unit2 * (3 - Unit2 * 2)
                        v198 = Config.ChasePitchSlowDeg or 0
                        v206 = Config.ChasePitchFastDeg or 0
                        v201 = math.rad(-v198 + (v198 + v206) * Unit2)
                        v205 = t22
                        v202 = t22.tilt

                        local v207, v208

                        if v202 then
                            local tilt = t22.tilt

                            v207 = v201 - t22.tilt
                            v208 = tilt + v207 * (1 - math.exp(-p73 * 3))
                        end

                        if v202 and v208 then
                            v201 = v208
                        end

                        v205.tilt = v201
                        v206 = LocalPlayer:GetAttribute("CamFixed") == true

                        if v206 then
                            v201 = t22
                            v201.tilt = 0
                        end

                        v201 = t22.prev

                        local v210 = if v201 then v153.Position - t22.prev else nil

                        if not v201 or not v210 then
                            v210 = Vector3.new(0, 0, 0)
                        end

                        v201 = t22
                        v201.prev = v153.Position

                        if v210.Magnitude > 100 then
                            v201 = t22
                            v201.pos = nil
                            v201 = t22
                            v201.look = nil
                            v201 = t22
                            v201.heading = nil
                        end

                        local Unit3

                        if t22.heading and t22.pos and t22.heading:Dot(Unit) > 0.3 then
                            v201 = t22.heading
                            v203 = -p73 * 18
                            v201 = v201:Lerp(Unit, 1 - math.exp(v203))
                            v205 = t22

                            local v211 = v201.Magnitude > 0.05

                            if v211 then
                                Unit3 = v201.Unit
                            end

                            if v211 and Unit3 then
                                Unit = Unit3
                            end

                            v205.heading = Unit
                        else
                            v201 = t22
                            v201.heading = Unit
                        end

                        v201 = t22
                        v201.anchorY = v153.Position.Y
                        v205 = Vector3.new(v153.Position.X, t22.anchorY, v153.Position.Z)
                        v201 = CFrame.lookAt(v205, v205 + t22.heading)

                        local v213 = Config.ChaseDistance + math.clamp(v197 / 220, 0, 1) * Config.ChaseSpeedDistance

                        if v157 then
                            v213 *= Config.HighChaseDistanceScale or 1.15
                        end

                        v213 *= 1 + (math.min(math.tan((math.rad(Config.ChaseBaseFOV * 0.5))) / math.tan((math.rad(math.max(t22.fov, 1) * 0.5))), 1) - 1) * (Config.ChaseFOVKeepSize or 0)
                        Unit = if v206 then 0 else -t22.lean * Config.CameraSway
                        v202 = CFrame.new

                        local ChaseCameraPitch = Config.ChaseCameraPitch
                        local v214 = if v157 then math.rad(Config.HighChasePitchDeg or 14) else nil

                        if not v157 or not v214 then
                            v214 = 0
                        end

                        v206 = (v201 * v202(0, 1.8 + math.tan(ChaseCameraPitch + v214) * (v213 + 6), v213)).Position + v201.RightVector * Unit
                        v213 = v205 + v201.LookVector * 6 + Vector3.new(0, 1.8, 0) + v201.RightVector * Unit
                        Unit3 = RaycastParams.new()
                        Unit3.FilterType = Enum.RaycastFilterType.Include
                        Unit3.FilterDescendantsInstances = {
                            workspace:FindFirstChild("RaceCollision", true),
                            workspace.Terrain
                        }
                        v208 = v205 + Vector3.new(0, 2, 0)
                        v202 = workspace:Raycast(v208, v206 - v208, Unit3)

                        if v202 then
                            v206 = v202.Position + v202.Normal * 0.7
                        end

                        Unit3 = 1 - math.exp(-p73 * 26)
                        v202 = t22
                        v207 = t22.pos

                        local v217 = if v207 then (t22.pos + v210):Lerp(v206, Unit3) else nil

                        if v207 and v217 then
                            v206 = v217
                        end

                        v202.pos = v206
                        v202 = t22
                        v207 = t22.look

                        local v218 = if v207 then (t22.look + v210):Lerp(v213, Unit3) else nil

                        if v207 and v218 then
                            v213 = v218
                        end

                        v202.look = v213
                        Unit3 = Vector3.new(t22.look.X - t22.pos.X, 0, t22.look.Z - t22.pos.Z).Magnitude
                        CurrentCamera.CFrame = CFrame.lookAt(t22.pos, t22.pos + v201.LookVector * math.max(Unit3, 1) + Vector3.new(0, 1, 0) * (t22.look.Y - t22.pos.Y)) * CFrame.Angles(t22.tilt or 0, 0, 0)
                        CurrentCamera.FieldOfView = t22.fov
                    end
                else
                    local v219

                    if not next(t23) then
                        for _, descendant in Character:GetDescendants() do
                            if descendant:IsA("BasePart") and (descendant.Name == "Head" or descendant.Parent:IsA("Accessory")) then
                                v219 = t23
                                v219[descendant] = descendant.LocalTransparencyModifier
                                descendant.LocalTransparencyModifier = 1
                            end
                        end
                    end

                    t24[1] = (v152.CFrame * CFrame.new(0, 0.15, -0.35)).Position

                    if v138 then
                        Position = v138
                        v219 = -p73 * 25
                        Position = Position:Lerp(Unit, 1 - math.exp(v219))
                        v138 = Position.Magnitude > 0.05 and Position.Unit or Unit
                    else
                        v138 = Unit
                    end

                    CurrentCamera.CFrame = CFrame.lookAt(t24[1], t24[1] + v138 * 30 + Vector3.new(-0, -1.5, -0, -0))
                    CurrentCamera.FieldOfView = math.clamp(Magnitude / 120, 0, 1) * 10 + 88
                    v133 = nil
                end
            else
                if next(t23) then
                    for v220, v221 in t23 do
                        if v220.Parent then
                            v220.LocalTransparencyModifier = v221
                        end
                    end

                    t23 = {}
                end

                Position = t22
                Position.crashHeading = nil
                Position = t22
                Position.crashFollow = nil
                Position = t22
                Position.crashPos = nil

                local Unit2, v222

                if v164 then
                    v163, v160 = v164(v153)

                    local v223 = v160 + v159 * 14

                    Unit2 = v223

                    if v156 == 7 and v131 then
                        local Unit3 = t21.dash or {}

                        Unit2 = t21
                        Unit2.dash = Unit3

                        local v224, v225

                        if Unit3.fwd and p73 > 0 then
                            v225 = Unit3.fwd:Cross(Unit).Y
                            v224 = Unit3.fwd:Dot(Unit)
                            Unit2 = math.atan2(v225, v224) / p73
                        else
                            Unit2 = 0
                        end

                        Unit3.fwd = Unit
                        v225 = math.clamp(Unit2, -3, 3)
                        v224 = Unit3.rate

                        local v226, v227, v228, Unit4

                        if v224 then
                            v227 = Unit3.rate
                            Unit4 = v225 - Unit3.rate
                            v228 = -p73 * 6
                            v226 = v227 + Unit4 * (1 - math.exp(v228))
                        end

                        Unit3.rate = if not v224 or not v226 then 0 else v226
                        Unit2 = math.clamp(Unit3.rate * v131.Gain, -v131.Max, v131.Max)
                        v224 = Unit3.yaw

                        local v229

                        if v224 then
                            v227 = Unit3.yaw
                            Unit4 = Unit2 - Unit3.yaw
                            v228 = -p73 * v131.Ease
                            v229 = v227 + Unit4 * (1 - math.exp(v228))
                        end

                        Unit2 = v223
                        Unit3.yaw = if not v224 or not v229 then 0 else v229
                        v222 = CFrame.new(v163.Position) * CFrame.Angles(0, Unit3.yaw, 0) * v163.Rotation
                    else
                        v222 = v163
                    end
                elseif v156 == 5 then
                    v222, Unit2 = BikeCams.TV(v153, t21.tv, p73)
                else
                    v222, Unit2 = BikeCams.Heli(v153, t21.heli, p73)
                end

                CurrentCamera.CFrame = v222
                CurrentCamera.FieldOfView = Unit2
                v133 = nil
                v134 = nil
            end
        end)
    end
end

top.Activated:Connect(function() -- line: 879
    -- upvalues: v132 (ref), stopSpectate (copy), startSpectate (copy)
    if v132 then
        stopSpectate()
    else
        startSpectate()
    end
end)

local v230

local function setCamMode(p74) -- line: 882
    -- upvalues: Modes (copy), t18 (copy), n4 (ref), t21 (ref), t22 (ref), v133 (ref), v134 (ref), v230 (ref)
    if p74 < 0 or #t18 <= p74 then
        return
    end

    n4 = p74
    v133 = nil
    v134 = nil
    t21 = {
        tv = {},
        heli = {}
    }
    t22 = {}

    if Modes.Visible then
        v230()
    end
end

v230 = function() -- line: 887
    -- upvalues: UserInputService (copy), Modes (copy), Modes2 (copy), listRow (copy), t18 (copy), t19 (copy), n4 (ref), setCamMode (copy)
    for _, child in Modes2:GetChildren() do
        if child:IsA("Frame") and child:GetAttribute("CamRow") then
            child:Destroy()
        end
    end

    for v231, v232 in t19 do
        local v235, v236 = listRow(Modes2, string.format("%02d", v231), (UserInputService.KeyboardEnabled and v231 .. "  " or "") .. t18[v232 + 1], v232 == n4)

        v235:SetAttribute("CamRow", true)
        v236.Activated:Connect(function() -- line: 891
            -- upvalues: v232 (copy), Modes (copy), setCamMode (copy)
            setCamMode(v232)
            Modes.Visible = false
        end)
    end

    local fromOffset = UDim2.fromOffset
    local v239 = math.max(1, (math.min(#t18, 4)))

    Modes.Size = fromOffset(92, 22 + v239 * (UserInputService.TouchEnabled and 20 or 15) + (v239 - 1) * 2)
end

v30.Activated:Connect(function() -- line: 896
    -- upvalues: Players2 (copy), Modes (copy), v230 (ref)
    Players2.Visible = false
    Modes.Visible = not Modes.Visible

    if Modes.Visible then
        v230()
    end
end)

local t26 = {}

for v240, v241 in {
        "One",
        "Two",
        "Three",
        "Four",
        "Five",
        "Six",
        "Seven",
        "Eight",
        "Nine"
    } do
    t26[Enum.KeyCode[v241]] = t19[v240]
    t26[Enum.KeyCode["Keypad" .. v241]] = t19[v240]
end

UserInputService.InputBegan:Connect(function(p75, p76) -- line: 902
    -- upvalues: v132 (ref), setCamMode (copy), t26 (copy)
    if not p76 and v132 then
        local v242 = t26[p75.KeyCode]

        if v242 ~= nil then
            setCamMode(v242)
        end
    end
end)

local v243 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.ExtraBold)

local function riderPos(p77) -- line: 910
    local NametagPosition = p77:GetAttribute("NametagPosition")

    if typeof(NametagPosition) ~= "number" or not NametagPosition then
        NametagPosition = nil
    end

    return NametagPosition
end

local function sortedRiders() -- line: 911
    -- upvalues: Players (copy), LocalPlayer (copy)
    local t27 = {}

    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer then
            table.insert(t27, player)
        end
    end

    table.sort(t27, function(p78, p79) -- line: 914
        local NametagPosition = p78:GetAttribute("NametagPosition")

        if typeof(NametagPosition) ~= "number" or not NametagPosition then
            NametagPosition = nil
        end

        local NametagPosition2 = p79:GetAttribute("NametagPosition")

        if typeof(NametagPosition2) ~= "number" or not NametagPosition2 then
            NametagPosition2 = nil
        end

        if NametagPosition and NametagPosition2 and NametagPosition ~= NametagPosition2 then
            return NametagPosition < NametagPosition2
        end

        if NametagPosition ~= nil == (NametagPosition2 ~= nil) then
            return p78.DisplayName:lower() < p79.DisplayName:lower()
        end

        return NametagPosition ~= nil
    end)

    return t27
end

local function riderKey(p80) -- line: 922
    local t28 = {}

    for _, v245 in p80 do
        local UserId = v245.UserId
        local NametagPosition = v245:GetAttribute("NametagPosition")

        table.insert(t28, UserId .. ":" .. tostring(typeof(NametagPosition) == "number" and NametagPosition or nil))
    end

    return table.concat(t28, ",")
end

local v248

local function rebuildList() -- line: 924
    -- upvalues: UserInputService (copy), v2 (copy), v3 (copy), Players2 (copy), Players3 (copy), listRow (copy), UserId (ref), startSpectate (copy), v243 (copy), sortedRiders (copy), riderKey (copy), v248 (ref)
    for _, child in Players3:GetChildren() do
        if child:IsA("GuiButton") or child:IsA("Frame") and child:GetAttribute("RiderRow") then
            child:Destroy()
        end
    end

    local v249 = sortedRiders()
    local n6 = 0

    for v250, v251 in v249 do
        n6 += 1

        local NametagPosition = v251:GetAttribute("NametagPosition")
        local v252 = typeof(NametagPosition) == "number" and NametagPosition or nil
        local v253, v254 = listRow(Players3, string.format("%03d", v250), v251.DisplayName, v251.UserId == UserId)

        v253:SetAttribute("RiderRow", true)

        if v252 then
            local v255 = (if UserInputService.TouchEnabled then 20 else 15) - 4
            local v257 = tostring((math.floor(v252)))
            local Frame = Instance.new("Frame")

            Frame.Name = "Position"
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = v3
            Frame.AnchorPoint = Vector2.new(0, 0.5)
            Frame.Position = UDim2.new(0, 2, 0.5, 0)
            Frame.Size = UDim2.fromOffset(math.max(v255 + 2, #v257 * math.floor(v255 * 0.55) + 6), v255)

            local v262 = UDim.new(0, 3)

            Instance.new("UICorner", Frame).CornerRadius = v262
            Frame.ZIndex = v254.ZIndex + 1

            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = "Number"
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.fromScale(1, 1)
            TextLabel.FontFace = v243
            TextLabel.Text = v257
            TextLabel.TextSize = math.floor(v255 * 0.75)
            TextLabel.TextColor3 = v2
            TextLabel.AutoLocalize = false
            TextLabel.ZIndex = v254.ZIndex + 2
            TextLabel.Parent = Frame
            Frame.Parent = v253

            local UIPadding = v254:FindFirstChildOfClass("UIPadding")

            if UIPadding then
                UIPadding.PaddingLeft = UDim.new(0, Frame.Size.X.Offset + 6)
            end
        end

        v254.Activated:Connect(function() -- line: 948
            -- upvalues: v251 (copy), Players2 (copy), startSpectate (copy)
            startSpectate(v251)
            Players2.Visible = false
        end)
    end

    v248 = riderKey(v249)

    local fromOffset = UDim2.fromOffset
    local v265 = math.max(1, (math.min(n6, 4)))

    Players2.Size = fromOffset(92, 22 + v265 * (UserInputService.TouchEnabled and 20 or 15) + (v265 - 1) * 2)
end

task.spawn(function() -- line: 954
    -- upvalues: Players2 (copy), sortedRiders (copy), riderKey (copy), v248 (ref), rebuildList (copy)
    while true do
        task.wait(0.5)

        if Players2.Visible and riderKey((sortedRiders())) ~= v248 then
            rebuildList()
        end
    end
end)
v31.Activated:Connect(function() -- line: 960
    -- upvalues: Players2 (copy), Modes (copy), rebuildList (copy)
    Modes.Visible = false
    Players2.Visible = not Players2.Visible

    if Players2.Visible then
        rebuildList()
    end
end)
JerezRaceHUD:GetAttributeChangedSignal("SpectateRequest"):Connect(function() -- line: 963
    -- upvalues: Players (copy), LocalPlayer (copy), JerezRaceHUD (copy), Frame2 (copy), Frame3 (copy), startSpectate (copy)
    local SpectateRequest = JerezRaceHUD:GetAttribute("SpectateRequest")

    if not SpectateRequest then
        return
    end

    JerezRaceHUD:SetAttribute("SpectateRequest", nil)

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v266 = Humanoid and Humanoid.SeatPart

    if v266 ~= nil and v266.Name == "RiderSeat" then
        return
    end

    local Character2 = LocalPlayer.Character

    if not (Character2 ~= nil and Character2:GetAttribute("RaceCrashActive") == true or Frame2.Visible or Frame3.Visible or JerezRaceHUD:GetAttribute("Freecam") == true) then
        local PlayerByUserId = Players:GetPlayerByUserId(SpectateRequest)

        if PlayerByUserId and PlayerByUserId ~= LocalPlayer then
            startSpectate(PlayerByUserId)
        end
    end
end)
Players.PlayerAdded:Connect(function() -- line: 970
    -- upvalues: Players2 (copy), rebuildList (copy)
    if Players2.Visible then
        rebuildList()
    end
end)
Players.PlayerRemoving:Connect(function() -- line: 971
    -- upvalues: Players2 (copy), rebuildList (copy)
    if Players2.Visible then
        task.defer(rebuildList)
    end
end)

local t29 = {
    Idle = 7.5,
    FadeOut = 0.45,
    FadeIn = 0.25,
    Order = 1010,
    ListOrder = 1011,
    Key = Enum.KeyCode.H
}
local v267 = false
local t30 = {}

t30[1] = 0

local n7 = 0
local t31 = {}
local DisplayOrder = ScreenGui.DisplayOrder
local DisplayOrder2

local function collectCutFade() -- line: 986
    -- upvalues: top3 (copy), top4 (copy), t31 (copy)
    table.clear(t31)

    for _, v268 in { top3, top4 } do
        for _, descendant in v268:GetDescendants() do
            local v269 = if descendant:IsA("ImageLabel") then "ImageTransparency"
                elseif descendant:IsA("TextLabel") then "TextTransparency"
                elseif descendant:IsA("Frame") and descendant.BackgroundTransparency < 1 then "BackgroundTransparency"
                else nil

            if v269 then
                table.insert(t31, {
                    descendant,
                    v269,
                    descendant[v269]
                })
            end
        end
    end
end

local function applyCut(p81) -- line: 995
    -- upvalues: t31 (copy)
    for _, v270 in t31 do
        local v271 = 1 - (1 - v270[3]) * p81

        if v270[1][v270[2]] ~= v271 then
            v270[1][v270[2]] = v271
        end
    end
end

local function setCutscene(p82) -- line: 998
    -- upvalues: PlayerGui (copy), JerezRaceHUD (copy), ScreenGui (copy), RetireConfirm (copy), TextButton (copy), top (copy), top4 (copy), v103 (ref), closeSettings (copy), Frame2 (copy), Frame3 (copy), v108 (ref), t29 (copy), v267 (ref), t30 (copy), n7 (ref), t31 (copy), DisplayOrder (copy), DisplayOrder2 (ref), collectCutFade (copy), applyCut (copy)
    if p82 == v103 then
        return
    end

    v103 = p82

    local ServerListHUD = PlayerGui:FindFirstChild("ServerListHUD")

    if p82 then
        closeSettings()
        v108 = false
        RetireConfirm.Visible = false
        TextButton.Modal = false
        Frame2.Visible = false
        Frame3.Visible = false
        table.clear(t31)
        v267 = false
        t30[1] = 0
        n7 = 0
        task.spawn(function() -- line: 1008
            -- upvalues: JerezRaceHUD (copy), v103 (ref), t30 (copy), collectCutFade (copy), applyCut (copy)
            task.wait()

            for _ = 1, 30 do
                if not v103 then
                    return
                end

                if JerezRaceHUD:GetAttribute("SpectateHudHidden") ~= true then
                    break
                end

                task.wait()
            end

            if v103 then
                collectCutFade()
                applyCut(t30[1] * t30[1] * (3 - t30[1] * 2))
            end
        end)
        ScreenGui.DisplayOrder = t29.Order

        if ServerListHUD then
            DisplayOrder2 = ServerListHUD.DisplayOrder
            ServerListHUD.DisplayOrder = t29.ListOrder
        end
    else
        applyCut(1)
        table.clear(t31)
        t30[1] = 0
        v267 = false
        top4.Modal = false
        top.Visible = true
        ScreenGui.DisplayOrder = DisplayOrder

        if ServerListHUD and DisplayOrder2 then
            ServerListHUD.DisplayOrder = DisplayOrder2
            DisplayOrder2 = nil
        end
    end
end

LocalPlayer:GetAttributeChangedSignal("CutscenePlaying"):Connect(function() -- line: 1027
    -- upvalues: LocalPlayer (copy), setCutscene (copy)
    setCutscene(LocalPlayer:GetAttribute("CutscenePlaying") == true)
end)

local t33 = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.MouseButton2] = true,
    [Enum.UserInputType.MouseButton3] = true,
    [Enum.UserInputType.Touch] = true,
    [Enum.UserInputType.Keyboard] = true
}

UserInputService.InputBegan:Connect(function(p83) -- line: 1030
    -- upvalues: UserInputService (copy), v103 (ref), t29 (copy), v267 (ref), n7 (ref), t33 (copy)
    if not v103 then
        return
    end

    local UserInputType = p83.UserInputType

    if UserInputType == Enum.UserInputType.Keyboard and p83.KeyCode == t29.Key and not UserInputService:GetFocusedTextBox() then
        n7 = 0
        v267 = not v267
    else
        local v272 = UserInputType.Name:sub(1, 7) == "Gamepad" and p83.KeyCode ~= Enum.KeyCode.Thumbstick1 and p83.KeyCode ~= Enum.KeyCode.Thumbstick2

        if t33[UserInputType] or v272 then
            n7 = 0
            v267 = true
        end
    end
end)

local function cutFrame(p84) -- line: 1040
    -- upvalues: JerezRaceHUD (copy), BottomNavigation (copy), Money (copy), TopCenter (copy), RaceDirectorSpectate (copy), TopRight (copy), top (copy), top3 (copy), top4 (copy), LapTimesCorner (copy), SpectateControls (copy), Players2 (copy), Modes (copy), v103 (ref), v107 (ref), t29 (copy), v267 (ref), t30 (copy), n7 (ref), applyCut (copy)
    if not v103 then
        return
    end

    local v274 = math.min(p84 or 0, 0.1)

    if v107 or JerezRaceHUD:GetAttribute("ServerListOpen") == true then
        n7 = 0
        v267 = true
    end

    n7 += v274

    local v275 = v267

    if v275 then
        local v276 = n7

        v275 = v276 >= t29.Idle
    end

    if v275 then
        v267 = false
    end

    local v277 = if v267 then 1 else 0

    if t30[1] ~= v277 then
        local v278

        if v277 < t30[1] then
            v278 = math.max(0, t30[1] - v274 / t29.FadeOut)

            if not v278 then
                v278 = math.min(1, t30[1] + v274 / t29.FadeIn)
            end
        else
            v278 = math.min(1, t30[1] + v274 / t29.FadeIn)
        end

        t30[1] = v278
        applyCut(t30[1] * t30[1] * (3 - t30[1] * 2))
    end

    BottomNavigation.Visible = false
    Money.Visible = false
    LapTimesCorner.Visible = false
    SpectateControls.Visible = false
    SpectateControls.Visible = false
    Players2.Visible = false
    Modes.Visible = false
    RaceDirectorSpectate.Visible = false
    TopCenter.Visible = true
    top.Visible = false
    top3.Visible = true
    top4.Visible = true
    TopRight.Visible = t30[1] > 0
    top4.Modal = t30[1] > 0
end

local v284 = false

local function placeRDTiles(p85) -- line: 1061
    -- upvalues: BottomNavigation (copy), t2 (copy), TextLabel2 (copy), RaceDirectorSpectate (copy), rescale (copy), v284 (ref)
    if p85 == v284 and not p85 then
        return
    end

    v284 = p85

    for v285, v286 in t2 do
        local btn = v286.btn

        if p85 then
            btn.Parent = RaceDirectorSpectate
            btn.Position = UDim2.fromOffset(-37, (v285 - 2.5) * 32)
        else
            btn.Parent = BottomNavigation
        end
    end

    if p85 then
        TextLabel2.Parent = RaceDirectorSpectate
        TextLabel2.AnchorPoint = Vector2.new(1, 1)
        TextLabel2.Position = UDim2.fromOffset(-12, -80)
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Right
    else
        TextLabel2.Parent = BottomNavigation
        TextLabel2.AnchorPoint = Vector2.new(0.5, 1)
        TextLabel2.Position = UDim2.fromOffset(0, -53)
        TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
        rescale()
    end
end

local v287 = false

RunService.RenderStepped:Connect(function(p86) -- line: 1077
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), NumberFormat (copy), JerezRaceHUD (copy), BottomNavigation (copy), v13 (copy), v14 (copy), v15 (copy), Money (copy), TextLabel (copy), NumberValue (copy), TopCenter (copy), v24 (copy), t2 (copy), TextLabel2 (copy), RaceDirectorSpectate (copy), v25 (copy), RetireConfirm (copy), TextButton (copy), clone (copy), Confirm (copy), TopRight (copy), LapTimesCorner (copy), SpectateControls (copy), Players2 (copy), Modes (copy), t7 (copy), rescale (copy), placeLapTimes (copy), position (copy), v66 (copy), v67 (ref), t17 (copy), v103 (ref), closeSettings (copy), Frame2 (copy), Frame3 (copy), v107 (ref), v108 (ref), v117 (ref), v132 (ref), stopSpectate (copy), cutFrame (copy), placeRDTiles (copy), v287 (ref)
    placeLapTimes()

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v288 = Humanoid and Humanoid.SeatPart
    local v289 = v288 ~= nil and v288.Name == "RiderSeat"
    local Character2 = LocalPlayer.Character
    local v290 = Character2 ~= nil and Character2:GetAttribute("RaceCrashActive") == true

    if MotoLegends:GetAttribute("CircuitClosed") == true and LocalPlayer:GetAttribute("RaceParticipant") == true then
    end

    if v289 ~= v287 then
        v287 = v289

        if v289 then
            stopSpectate()
            closeSettings()
        end
    end

    local v291 = LocalPlayer:GetAttribute("RaceParticipant") == true and LocalPlayer:GetAttribute("RaceFinished") ~= true and t17[MotoLegends:GetAttribute("SessionPhase") or ""] == true

    if v291 ~= v67 then
        v67 = v291
        t7[v24].position = v291 and v66 or position
        v13.Visible = not v291
        v14.Visible = false
        v15.Visible = not v291
        v25.Visible = v291
        rescale()
    end

    local v293 = LocalPlayer:GetAttribute("RaceRewardPending") == true

    v24.Visible = true
    v25.Visible = v67 and not v293

    if v117 then
        v24.Visible = false
        v25.Visible = false
        v13.Visible = false
        v15.Visible = false
        Frame2.Visible = false
        Frame3.Visible = false
    else
        v13.Visible = not v67
        v15.Visible = not v67
    end

    for _, v295 in t2 do
        v295.btn.Visible = v117
    end

    TextLabel2.Visible = v117

    if v293 then
        Frame2.Visible = false
    end

    if v291 then
        Frame2.Visible = false
        Frame3.Visible = false
    end

    if v108 and (not v291 or v289 or v132) then
        v108 = false
        RetireConfirm.Visible = false
        TextButton.Modal = false
    end

    if v107 and (v289 or v290) and not v103 then
        v107 = false
        clone.Visible = false
        Confirm.Modal = false
    end

    local v296 = if v289 or v290 then not not (v103 and not Frame2.Visible) and not Frame3.Visible else not Frame2.Visible and not Frame3.Visible

    if not v296 and JerezRaceHUD:GetAttribute("ServerListOpen") == true then
        JerezRaceHUD:SetAttribute("ServerListOpen", false)
    end

    local v298 = not v289 and not v290
    local v299 = v291 and v290 and not v289

    if v289 or v290 then
        Frame2.Visible = false
        Frame3.Visible = false
    end

    local v300 = Frame2.Visible or Frame3.Visible
    local v301, v302

    if v298 or v299 then
        if v132 then
            v302 = false
        else
            local v304 = not v300

            if v304 then
                v301 = v304
                v302 = true
            else
                v302 = false
            end
        end
    else
        v302 = false
    end

    BottomNavigation.Visible = if not v302 then v117 and v298 and not v300 and not v132 else v301
    Money.Visible = v298 and not v132 and not v300
    TopCenter.Visible = if v298 or v299 then not v132 else v299
    LapTimesCorner.Visible = v298 and not v132 and not v300
    TopRight.Visible = not v289 and not v290 and not v300
    SpectateControls.Visible = v132
    SpectateControls.Visible = v132

    local v308 = v117 and v132 and v298 and not v300

    placeRDTiles(v308 == true)
    RaceDirectorSpectate.Visible = v308 == true

    if not SpectateControls.Visible then
        Players2.Visible = false
        Modes.Visible = false
    end

    local v309 = "$ " .. NumberFormat.Full((math.round(NumberValue.Value)))

    if TextLabel.Text ~= v309 then
        TextLabel.Text = v309
    end

    local Character3 = LocalPlayer.Character
    local Humanoid2 = Character3 and Character3:FindFirstChildOfClass("Humanoid")
    local v310 = Humanoid2 ~= nil and Humanoid2.PlatformStand

    v24.Text = ""
    v24.Active = not v310
    cutFrame(p86)
end)

if LocalPlayer:GetAttribute("CutscenePlaying") == true then
    setCutscene(true)
end
