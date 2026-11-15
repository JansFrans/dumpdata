-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local ChampionshipEvent = MotoLegends:WaitForChild("ChampionshipEvent")

MotoLegends:WaitForChild("ClaimDailyTask")

local function v1() -- line: 11
    -- upvalues: ChampionshipEvent (copy)
    game:GetService("TextChatService").SendingMessage:Connect(function(p1) -- line: 12
        -- upvalues: ChampionshipEvent (copy)
        if typeof(p1.Text) == "string" and p1.Text:lower():match("^%s*start%s*$") then
            ChampionshipEvent:FireServer("PracticeStart")
        end
    end)
end

pcall(v1)

local NumberFormat = require(MotoLegends:WaitForChild("NumberFormat"))
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "ChampionshipHUD"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 15
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local v2 = Color3.fromRGB(245, 245, 247)
local v3 = Color3.fromRGB(8, 9, 13)
local v4 = Color3.fromRGB(231, 0, 0)
local v5 = Color3.fromRGB(255, 225, 35)
local v6 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local t1 = {}

local function v7() -- line: 21
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
end

pcall(v7)

local function panel(p2, p3, p4, p5) -- line: 22
    -- upvalues: ScreenGui (copy), v3 (copy), t1 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p2
    Frame.Size = UDim2.fromOffset(p3.X, p3.Y)
    Frame.Position = p4
    Frame.AnchorPoint = p5 or Vector2.zero
    Frame.BackgroundColor3 = v3
    Frame.BackgroundTransparency = 0.15
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Instance.new("UIScale", Frame)
    table.insert(t1, Frame)

    return Frame
end

local function label(p6, p7, p8, p9, p10, p11) -- line: 26
    -- upvalues: v2 (copy), v6 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p7
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p8
    TextLabel.FontFace = v6
    TextLabel.TextColor3 = v2
    TextLabel.TextSize = p11 or 12
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Position = UDim2.fromOffset(p9.X, p9.Y)
    TextLabel.Size = UDim2.fromOffset(p10.X, p10.Y)
    TextLabel.Parent = p6

    return TextLabel
end

local function button(p12, p13, p14, p15, p16) -- line: 29
    -- upvalues: v2 (copy), v4 (copy), v6 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p13
    TextButton.Text = p14
    TextButton.FontFace = v6
    TextButton.TextColor3 = v2
    TextButton.TextSize = 10
    TextButton.BackgroundColor3 = v4
    TextButton.BorderSizePixel = 0
    TextButton.Position = UDim2.fromOffset(p15.X, p15.Y)
    TextButton.Size = UDim2.fromOffset(p16.X, p16.Y)
    TextButton.AutoButtonColor = true
    TextButton.Parent = p12

    return TextButton
end

local v8 = panel("DailyTasks", Vector2.new(270, 203), UDim2.new(1, -14, 0.5, 0), Vector2.new(1, 0.5))

v8.BackgroundTransparency = 1
v8.ClipsDescendants = true

local Frame = Instance.new("Frame", v8)

Frame.Name = "Slider"
Frame.Size = UDim2.fromScale(1, 1)
Frame.BackgroundTransparency = 1

local Frame2 = Instance.new("Frame", Frame)

Frame2.Name = "Content"
Frame2.Position = UDim2.fromOffset(34, 0)
Frame2.Size = UDim2.fromOffset(236, 203)
Frame2.BackgroundColor3 = v3
Frame2.BackgroundTransparency = 0.15
Frame2.BorderSizePixel = 0
Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 9)
label(Frame2, "Title", "Daily Tasks", Vector2.new(14, 8), Vector2.new(120, 24), 16)

local v9 = label(Frame2, "ResetTimer", "", Vector2.new(120, 8), Vector2.new(104, 24), 11)

v9.TextXAlignment = Enum.TextXAlignment.Right
v9.TextColor3 = Color3.fromRGB(170, 172, 180)

local v10 = button(Frame, "Collapse", ">>", Vector2.new(0, 8), Vector2.new(34, 30))

v10.BackgroundColor3 = v3
v10.BackgroundTransparency = 0.15
v10.TextSize = 18
v10.ZIndex = 3
v10:SetAttribute("NoHover", true)
Instance.new("UICorner", v10).CornerRadius = UDim.new(0, 7)

local t2 = {}
local t3 = {
    {
        id = "playtime",
        name = "Playtime",
        goal = 900,
        reward = 5000
    },
    {
        id = "laps",
        name = "Complete 5 valid laps",
        goal = 5,
        reward = 15000
    },
    {
        id = "win",
        name = "Finish on the podium",
        goal = 1,
        reward = 35000
    }
}
local v11, v12

for v13, v14 in t3 do
    local MouseLeave = Instance.new("Frame", Frame2)

    MouseLeave.Name = v14.id
    MouseLeave.BackgroundTransparency = 1
    MouseLeave.Size = UDim2.fromOffset(220, 40)
    MouseLeave.Position = UDim2.fromOffset(8, 36 + (v13 - 1) * 43)
    label(MouseLeave, "Name", v14.name, Vector2.new(5, 0), Vector2.new(208, 16), 12)
    v11 = Instance.new("Frame", MouseLeave)
    v11.Name = "Track"
    v11.BorderSizePixel = 0
    v11.BackgroundColor3 = Color3.fromRGB(65, 68, 82)
    v11.Position = UDim2.fromOffset(5, 19)
    v11.Size = UDim2.fromOffset(160, 4)
    v12 = Instance.new("Frame", v11)
    v12.Name = "Progress"
    v12.BackgroundColor3 = v5
    v12.BorderSizePixel = 0
    v12.Size = UDim2.fromScale(0, 1)

    local v15 = label(MouseLeave, "Count", "0 / " .. v14.goal, Vector2.new(5, 25), Vector2.new(160, 14), 10)

    v15.TextXAlignment = Enum.TextXAlignment.Right

    local v16 = label(MouseLeave, "Reward", NumberFormat.Money(v14.reward), Vector2.new(170, 13), Vector2.new(46, 18), 11)

    v16.TextXAlignment = Enum.TextXAlignment.Right
    t2[v14.id] = {
        holder = MouseLeave,
        fill = v12,
        count = v15,
        reward = v16
    }
end

local v17 = button(Frame2, "FreeGift", "FREE GIFT", Vector2.new(13, 165), Vector2.new(210, 30))

v17.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
v17.TextSize = 15
v17.AutoButtonColor = false
v17.ClipsDescendants = true
v17:SetAttribute("NoHover", true)
Instance.new("UICorner", v17).CornerRadius = UDim.new(0, 7)

local Frame3 = Instance.new("Frame")

Frame3.Name = "Shine"
Frame3.BackgroundColor3 = v2
Frame3.BorderSizePixel = 0
Frame3.Size = UDim2.fromScale(1, 1)
Frame3.ZIndex = 2
Frame3.Parent = v17
Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 7)

local UIGradient = Instance.new("UIGradient")

UIGradient.Rotation = 15
UIGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.34, 1),
    NumberSequenceKeypoint.new(0.5, 0.45),
    NumberSequenceKeypoint.new(0.66, 1),
    NumberSequenceKeypoint.new(1, 1)
})
UIGradient.Offset = Vector2.new(-1.2, 0)
UIGradient.Parent = Frame3

local UIScale = Instance.new("UIScale", v17)

v17.MouseEnter:Connect(function() -- line: 67
    -- upvalues: TweenService (copy), v2 (copy), v4 (copy), v17 (copy)
    TweenService:Create(v17, TweenInfo.new(0.15), {
        BackgroundColor3 = v2,
        TextColor3 = v4
    }):Play()
end)
v17.MouseLeave:Connect(function() -- line: 68
    -- upvalues: TweenService (copy), v2 (copy), v4 (copy), v17 (copy), UIScale (copy)
    TweenService:Create(v17, TweenInfo.new(0.15), {
        BackgroundColor3 = v4,
        TextColor3 = v2
    }):Play()
    TweenService:Create(UIScale, TweenInfo.new(0.12), {
        Scale = 1
    }):Play()
end)
v17.MouseButton1Down:Connect(function() -- line: 69
    -- upvalues: TweenService (copy), UIScale (copy)
    TweenService:Create(UIScale, TweenInfo.new(0.08), {
        Scale = 0.95
    }):Play()
end)
v17.MouseButton1Up:Connect(function() -- line: 70
    -- upvalues: TweenService (copy), UIScale (copy)
    TweenService:Create(UIScale, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
        Scale = 1
    }):Play()
end)
v17.Activated:Connect(function() -- line: 71
    -- upvalues: MotoLegends (copy)
    local OpenFreeGift = MotoLegends:FindFirstChild("OpenFreeGift")

    if OpenFreeGift then
        OpenFreeGift:Fire()
    end
end)
v17.Visible = false

local v18

RunService.RenderStepped:Connect(function() -- line: 77
    -- upvalues: v17 (copy), UIGradient (copy)
    if v17.Visible then
        local v20 = math.clamp(os.clock() % 3 / 1.8, 0, 1)
        local v21 = v20 * v20 * (3 - v20 * 2)

        UIGradient.Offset = Vector2.new(v21 * 2.4 + -1.2, 0)
    end
end)

local v22 = false
local v23

v10.Activated:Connect(function() -- line: 84
    -- upvalues: TweenService (copy), Frame (copy), v10 (copy), v22 (ref), v23 (ref)
    v22 = not v22
    v10.Text = v22 and "<<" or ">>"

    if v23 then
        v23:Cancel()
    end

    v23 = TweenService:Create(Frame, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(v22 and 0.8740740740740741 or 0, 0)
    })
    v23:Play()
end)

local v25 = panel("SessionTimer", Vector2.new(360, 44), UDim2.new(0.5, 0, 0, 14), Vector2.new(0.5, 0))
local v26 = label(v25, "Clock", "1 PLAYER REQUIRED", Vector2.new(14, 22), Vector2.new(332, 18), 13)

v26.TextXAlignment = Enum.TextXAlignment.Center
v25.Visible = false
v25.BackgroundTransparency = 1
v11 = Instance.new("ScreenGui")
v11.Name = "SessionTimerHUD"
v11.IgnoreGuiInset = true
v11.ResetOnSpawn = false
v11.DisplayOrder = 31
v11.Parent = LocalPlayer:WaitForChild("PlayerGui")
v25.Parent = v11

local v27 = panel("StartLights", Vector2.new(190, 40), UDim2.new(0.5, 0, 0, 66), Vector2.new(0.5, 0))

v27.Visible = false

local t5 = {}

for i = 1, 5 do
    local Frame = Instance.new("Frame")

    Frame.Name = "Lamp" .. i
    Frame.Size = UDim2.fromOffset(24, 24)
    Frame.Position = UDim2.fromOffset((i - 1) * 36 + 11, 8)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 42, 47)
    Frame.BorderSizePixel = 0
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)
    Frame.Parent = v27
    t5[i] = Frame
end

local v28 = panel("WarningsAndPenalties", Vector2.new(106, 54), UDim2.new(1, -14, 0.5, 0), Vector2.new(1, 0.5))

v28.BackgroundTransparency = 1

local Frame4 = Instance.new("Frame", v28)

Frame4.Name = "WarningStrip"
Frame4.Size = UDim2.fromOffset(106, 27)
Frame4.BackgroundColor3 = v3
Frame4.BorderSizePixel = 0

local function warningEdge(p17, p18, p19, p20) -- line: 101
    -- upvalues: v2 (copy), Frame4 (copy)
    local Frame = Instance.new("Frame", Frame4)

    Frame.Name = p17
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = v2
    Frame.Position = UDim2.fromOffset(p18.X, p18.Y)
    Frame.Size = UDim2.fromOffset(p19.X, p19.Y)
    Frame.Rotation = p20 or 0
end

warningEdge("WarningLeft", Vector2.new(10.5, 13), Vector2.new(1.5, 20), 26.565)
warningEdge("WarningRight", Vector2.new(19.5, 13), Vector2.new(1.5, 20), -26.565)
warningEdge("WarningBase", Vector2.new(15, 22), Vector2.new(18, 1.5))
label(Frame4, "WarningIcon", "!", Vector2.new(11, 8), Vector2.new(8, 14), 12).TextXAlignment = Enum.TextXAlignment.Center

local t6 = {}

for i = 1, 5 do
    local spawn = Instance.new("Frame", Frame4)

    spawn.Name = "Warning" .. i
    spawn.BorderSizePixel = 0
    spawn.BackgroundColor3 = v2
    spawn.Size = UDim2.fromOffset(7, 17)
    spawn.Position = UDim2.fromOffset((i - 1) * 13 + 36, 5)
    t6[i] = spawn
end

local v29 = label(v28, "LongLap", "LLP", Vector2.new(0, 29), Vector2.new(106, 25), 19)

v29.BackgroundTransparency = 0
v29.BackgroundColor3 = v5
v29.TextColor3 = v3
v29.TextXAlignment = Enum.TextXAlignment.Center
v29.Visible = false
v28.Visible = false

local v30 = panel("RaceTower", Vector2.new(130, 267), UDim2.new(0, 14, 0, 68))

v30.BackgroundTransparency = 0.05

local v31 = label(v30, "Brand", "MotoLegends", Vector2.new(8, 3), Vector2.new(114, 24), 14)

v31.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Italic)

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "BrandLogo"
ImageLabel.BackgroundTransparency = 1
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.fromOffset(8, 7)
ImageLabel.Size = UDim2.fromOffset(70, 25)
ImageLabel.ScaleType = Enum.ScaleType.Fit
ImageLabel.Visible = false
ImageLabel.Parent = v30
task.spawn(function() -- line: 118
    -- upvalues: MotoLegends (copy), v31 (copy), ImageLabel (copy)
    local function v32() -- line: 119
        -- upvalues: MotoLegends (copy)
        return require(MotoLegends:WaitForChild("UIArt")).Get("MotoLegendsLogo")
    end

    local ok, result = pcall(v32)

    if not (ok and result) then
        return
    end

    ImageLabel.ImageContent = result
    ImageLabel.Visible = true
    v31.Visible = false
end)

local v33 = label(v30, "Phase", "SPRINT", Vector2.new(8, 36), Vector2.new(114, 19), 13)
local Frame5 = Instance.new("Frame", v30)

Frame5.Name = "RaceProgress"
Frame5.BorderSizePixel = 0
Frame5.BackgroundColor3 = Color3.fromRGB(58, 62, 70)
Frame5.Position = UDim2.fromOffset(8, 58)
Frame5.Size = UDim2.fromOffset(114, 4)
Frame5.ClipsDescendants = true

local Frame6 = Instance.new("Frame", Frame5)

Frame6.Name = "Fill"
Frame6.BorderSizePixel = 0
Frame6.BackgroundColor3 = v4
Frame6.Size = UDim2.fromScale(1, 1)

local Frame7 = require
local ok

ok, Frame7 = pcall(Frame7, MotoLegends:WaitForChild("Config"))

if ok and type(Frame7) == "table" and Frame7.Track == "Sepang" then
    Frame6.BackgroundColor3 = Color3.new(1, 1, 1)

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Name = "OrangeRed"
    UIGradient.Rotation = 0
    UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 140, 0), Color3.fromRGB(231, 0, 0))
    UIGradient.Parent = Frame6
end

local Frame8 = Instance.new("Frame", Frame5)

Frame8.Name = "Chequered"
Frame8.BackgroundTransparency = 1
Frame8.BorderSizePixel = 0
Frame8.ClipsDescendants = true
Frame8.Size = UDim2.fromOffset(0, 4)
Frame8.ZIndex = 2

local TextButton

for i = 0, 56 do
    for j = 0, 1 do
        TextButton = Instance.new("Frame")
        TextButton.BorderSizePixel = 0
        TextButton.Size = UDim2.fromOffset(2, 2)
        TextButton.Position = UDim2.fromOffset(i * 2, j * 2)
        TextButton.ZIndex = 2

        if (i + j) % 2 ~= 0 or not v2 then
            TextButton.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        else
            TextButton.BackgroundColor3 = v2
        end

        TextButton.Parent = Frame8
    end
end

Frame7 = Instance.new("Frame")
Frame7.Name = "LapClip"
Frame7.BackgroundTransparency = 1
Frame7.BorderSizePixel = 0
Frame7.ClipsDescendants = true
Frame7.Position = UDim2.fromOffset(0, 62)
Frame7.Size = UDim2.fromOffset(130, 55)
Frame7.Parent = v30

local v34 = label(Frame7, "LapCaption", "LAP", Vector2.new(8, 3), Vector2.new(114, 15), 11)
local v35 = label(Frame7, "Lap", "1 of 3", Vector2.new(8, 16), Vector2.new(114, 35), 30)
local v36 = label(Frame7, "Finish", "FINISH", Vector2.new(8, 8), Vector2.new(114, 40), 34)

v36.Visible = false
v36.TextScaled = true
Instance.new("UITextSizeConstraint", v36).MaxTextSize = 36

local Frame9 = Instance.new("Frame")

Frame9.Name = "Rows"
Frame9.BackgroundTransparency = 1
Frame9.BorderSizePixel = 0
Frame9.ClipsDescendants = true
Frame9.Position = UDim2.fromOffset(0, 119)
Frame9.Size = UDim2.fromOffset(330, 22)
Frame9.Parent = v30

local v37 = false

TextButton = Instance.new("TextButton")
TextButton.Name = "ToggleRiderBars"
TextButton.Text = ""
TextButton.AutoButtonColor = false
TextButton.BackgroundTransparency = 1
TextButton.BorderSizePixel = 0
TextButton.Size = UDim2.fromOffset(130, 119)
TextButton.ZIndex = 6
TextButton:SetAttribute("NoHover", true)
TextButton.Parent = v30
TextButton.Activated:Connect(function() -- line: 167
    -- upvalues: v37 (ref)
    v37 = not v37
end)

local t7 = {}
local v38

for i = 1, 25 do
    local Frame = Instance.new("Frame")

    Frame.Name = "Position" .. i
    Frame.BackgroundColor3 = v2
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.fromOffset(0, (i - 1) * 22)
    Frame.Size = UDim2.fromOffset(130, 21)
    Frame.Visible = false
    Frame.Parent = Frame9

    local v39 = label(Frame, "Position", tostring(i), Vector2.new(0, 0), Vector2.new(27, 21), 14)

    v39.BackgroundTransparency = 0
    v39.BackgroundColor3 = Color3.fromRGB(26, 36, 43)
    v39.TextXAlignment = Enum.TextXAlignment.Center
    v39.ZIndex = 3

    local v40 = label(Frame, "Rider", "", Vector2.new(34, 1), Vector2.new(61, 20), 14)

    v40.TextColor3 = v3
    v40.TextTruncate = Enum.TextTruncate.AtEnd
    v40.ZIndex = 3

    local v41 = label(Frame, "NationalFlag", "", Vector2.new(98, -1), Vector2.new(28, 22), 19)

    v41.Font = Enum.Font.SourceSans
    v41.TextXAlignment = Enum.TextXAlignment.Center

    local v42 = label(Frame, "LLPWarning", "LLP", Vector2.new(134, 0), Vector2.new(88, 21), 13)

    v42.Font = Enum.Font.GothamBold
    v42.TextColor3 = v5
    v42.TextXAlignment = Enum.TextXAlignment.Left
    v42.TextYAlignment = Enum.TextYAlignment.Center
    v42.TextWrapped = false
    v42.Visible = false
    v38 = {}

    local MouseEnter

    for j = 1, 4 do
        MouseEnter = Instance.new("Frame")
        MouseEnter.Name = "Sector" .. j
        MouseEnter.BorderSizePixel = 0
        MouseEnter.BackgroundColor3 = Color3.fromRGB(71, 78, 83)
        MouseEnter.Position = UDim2.fromOffset((j - 1) * 6 + 101, 3)
        MouseEnter.Size = UDim2.fromOffset(3, 15)
        MouseEnter.Visible = false
        MouseEnter.Parent = Frame
        v38[j] = MouseEnter
    end

    local v43 = label(Frame, "LapTime", "--:--.---", Vector2.new(136, 0), Vector2.new(96, 21), 13)

    v43.Font = Enum.Font.GothamBold
    v43.BackgroundTransparency = 0.18
    v43.BackgroundColor3 = Color3.fromRGB(45, 55, 62)
    v43.TextXAlignment = Enum.TextXAlignment.Center
    v43.Visible = false

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "TimeAccent"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = v4
    Frame2.Position = UDim2.fromOffset(131, 0)
    Frame2.Size = UDim2.fromOffset(3, 21)
    Frame2.Visible = false
    Frame2.Parent = Frame

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Select"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BorderSizePixel = 0
    TextButton.BackgroundColor3 = v2
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromOffset(130, 21)
    TextButton.ZIndex = 5
    TextButton:SetAttribute("NoHover", true)
    TextButton.Parent = Frame
    TextButton.MouseEnter:Connect(function() -- line: 189
        -- upvalues: TextButton (copy)
        TextButton.BackgroundTransparency = 0.82
    end)
    TextButton.MouseLeave:Connect(function() -- line: 189
        -- upvalues: TextButton (copy)
        TextButton.BackgroundTransparency = 1
    end)
    v40.AutoLocalize = false
    v41.AutoLocalize = false
    t7[i] = {
        frame = Frame,
        name = v40,
        flag = v41,
        llp = v42,
        position = v39,
        sectors = v38,
        time = v43,
        accent = Frame2,
        hit = TextButton,
        y = (i - 1) * 22
    }
end

local _require = require
local ok2, result = pcall(_require, MotoLegends:WaitForChild("RaceNametags"))
local RoleStyles = ok2 and result.RoleStyles or {}
local v44 = Color3.fromRGB(43, 55, 61)

local function riderRole(p21) -- line: 202
    -- upvalues: Players (copy)
    local v45 = p21 and Players:GetPlayerByUserId(p21)
    local StaffRole = v45 and v45:GetAttribute("StaffRole")

    return typeof(StaffRole) == "string" and StaffRole:lower() or ""
end

local function styleRow(p22, p23) -- line: 206
    -- upvalues: v2 (copy), ok2 (copy), result (copy), RoleStyles (copy)
    if p22.role == p23 then
        return
    end

    p22.role = p23

    local v46 = RoleStyles[p23]

    p22.style = v46

    local frame = p22.frame
    local RoleShine = frame:FindFirstChild("RoleShine")

    if v46 and v46.shine then
        if not RoleShine then
            RoleShine = Instance.new("Frame")
            RoleShine.Name = "RoleShine"
            RoleShine.BorderSizePixel = 0
            RoleShine.Size = UDim2.fromScale(1, 1)
            RoleShine.ZIndex = 2

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Name = "Sweep"
            UIGradient.Rotation = 15
            UIGradient.Offset = Vector2.new(-1.2, 0)
            UIGradient.Parent = RoleShine
            RoleShine.Parent = frame
        end

        RoleShine.BackgroundColor3 = v46.shineColor or v2
        RoleShine.Sweep.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.34, 1),
            NumberSequenceKeypoint.new(0.5, v46.shine),
            NumberSequenceKeypoint.new(0.66, 1),
            NumberSequenceKeypoint.new(1, 1)
        })
        p22.shine = RoleShine
    else
        if RoleShine then
            RoleShine:Destroy()
        end

        p22.shine = nil
    end

    local RoleGlow = frame:FindFirstChild("RoleGlow")
    local v47 = RoleGlow
    local UIStroke

    if not RoleGlow or RoleGlow:GetAttribute("Kind") == (v46 and v46.glow) then
        UIStroke = RoleGlow
    else
        RoleGlow:Destroy()
        v47 = nil
    end

    if v46 and v46.glow then
        if not UIStroke then
            UIStroke = Instance.new("UIStroke")
            v47 = UIStroke
            UIStroke.Name = "RoleGlow"
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Thickness = 1.5
            UIStroke:SetAttribute("Kind", v46.glow)

            local function v48() -- line: 227
                -- upvalues: v47 (ref)
                v47.BorderStrokePosition = Enum.BorderStrokePosition.Inner
            end

            pcall(v48)
            v47.Parent = frame
        end

        if ok2 and result.DressGlow then
            result.DressGlow(v47, v46)
        end

        p22.glow = v47
    else
        if UIStroke then
            UIStroke:Destroy()
        end

        p22.glow = nil
    end

    if ok2 and result.ApplyBar then
        result.ApplyBar(frame, v46, p22.name)
    end

    if ok2 and result.ApplyFlag then
        result.ApplyFlag(frame, v46, 0.7333333333333333, false)
    end

    p22.bar = frame:FindFirstChild("RoleBar")
    p22.textGrad = p22.name:FindFirstChild("RoleText")
end

local n1 = 0

RunService.RenderStepped:Connect(function(p24) -- line: 243
    -- upvalues: UserInputService (copy), LocalPlayer (copy), v30 (copy), t7 (copy), ok2 (copy), result (copy), n1 (ref)
    if v30.Visible then
        n1 -= p24

        if (not UserInputService.TouchEnabled or UserInputService.KeyboardEnabled) and LocalPlayer:GetAttribute("GfxQuality") ~= "Low" then
            n1 = 0

            local elapsed = os.clock()
            local v51 = math.clamp(elapsed % 3 / 1.8, 0, 1)
            local v52 = v51 * v51 * (3 - v51 * 2)
            local v54 = math.sin(elapsed * 3.2) * 0.5 + 0.5

            for _, v55 in t7 do
                if v55.style and v55.frame.Visible then
                    if v55.shine and v55.shine.Visible then
                        v55.shine.Sweep.Offset = Vector2.new(v52 * 2.4 + -1.2, 0)
                    end

                    if v55.glow and ok2 and result.StepGlow then
                        result.StepGlow(v55.glow, elapsed, v54, 0.6)
                    end

                    if v55.textGrad and v55.textGrad.Parent then
                        v55.textGrad.Offset = Vector2.new(elapsed * 0.25 % 2 - 1, 0)
                    end
                end
            end
        elseif not (n1 > 0) then
            n1 = math.max(n1 + 0.03333333333333333, 0)

            local elapsed = os.clock()
            local v58 = math.clamp(elapsed % 3 / 1.8, 0, 1)
            local v59 = v58 * v58 * (3 - v58 * 2)
            local v61 = math.sin(elapsed * 3.2) * 0.5 + 0.5

            for _, v62 in t7 do
                if v62.style and v62.frame.Visible then
                    if v62.shine and v62.shine.Visible then
                        v62.shine.Sweep.Offset = Vector2.new(v59 * 2.4 + -1.2, 0)
                    end

                    if v62.glow and ok2 and result.StepGlow then
                        result.StepGlow(v62.glow, elapsed, v61, 0.6)
                    end

                    if v62.textGrad and v62.textGrad.Parent then
                        v62.textGrad.Offset = Vector2.new(elapsed * 0.25 % 2 - 1, 0)
                    end
                end
            end
        end
    end
end)

local Frame10 = Instance.new("Frame")

Frame10.Name = "RiderCam"
Frame10.BackgroundColor3 = v3
Frame10.BorderSizePixel = 0
Frame10.ClipsDescendants = true
Frame10.Size = UDim2.fromOffset(232, 0)
Frame10.Visible = false
Frame10.ZIndex = 2
Frame10.Parent = Frame9
v38 = Instance.new("Frame")
v38.Name = "View"
v38.BackgroundTransparency = 1
v38.BorderSizePixel = 0
v38.Size = UDim2.fromOffset(232, 130)
v38.Parent = Frame10

local TowerPiP = require(script:WaitForChild("TowerPiP"))
local v63 = TowerPiP.New(v38)
local t8 = {
    userId = nil,
    wantOpen = false,
    p = 0,
    pending = nil,
    lastMode = nil
}
local t9 = {
    rows = 1,
    room = 1e999,
    slot = nil,
    h = nil
}

local function openPip(p25) -- line: 272
    -- upvalues: TowerPiP (copy), v63 (copy), t8 (copy)
    local v64 = table.clone(TowerPiP.SETTINGS.Modes)

    if #v64 > 1 and t8.lastMode then
        local v65 = table.find(v64, t8.lastMode)

        if v65 then
            table.remove(v64, v65)
        end
    end

    local v66 = v64[math.random(#v64)]

    t8.lastMode = v66
    t8.userId = p25
    t8.wantOpen = true
    t8.pending = nil
    v63:SetTarget(p25, v66)
end

local function closePip() -- line: 279
    -- upvalues: t8 (copy)
    t8.wantOpen = false
    t8.pending = nil
end

local function togglePip(p26) -- line: 280
    -- upvalues: t8 (copy), openPip (copy)
    if p26 then
        if t8.userId == p26 and t8.wantOpen then
            t8.wantOpen = false
            t8.pending = nil
        elseif not (t8.userId and t8.p > 0) then
            openPip(p26)
        else
            t8.wantOpen = false
            t8.pending = p26
        end
    end
end

local Activated

for _, v67 in t7 do
    Activated = v67.hit.Activated
    Activated:Connect(function() -- line: 288
        -- upvalues: LocalPlayer (copy), v67 (copy)
        local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

        if JerezRaceHUD and v67.userId and v67.userId ~= LocalPlayer.UserId then
            JerezRaceHUD:SetAttribute("SpectateRequest", nil)
            JerezRaceHUD:SetAttribute("SpectateRequest", v67.userId)
        end
    end)
end

local function guard(p27) -- line: 296
    if (p27:IsA("TextLabel") or p27:IsA("TextButton")) and (p27.Name == "PlayerName" or p27:FindFirstAncestor("RaceNametag")) or p27:IsA("BillboardGui") and p27.Name == "RaceNametag" then
        p27.AutoLocalize = false
    end
end

task.spawn(function() -- line: 300
    -- upvalues: guard (copy)
    for _, descendant in workspace:GetDescendants() do
        guard(descendant)
    end
end)
workspace.DescendantAdded:Connect(function(p28) -- line: 301
    -- upvalues: guard (copy)
    if p28:IsA("GuiBase") then
        task.defer(guard, p28)
    end
end)

local function shortName(p29) -- line: 303
    local v68 = tostring(p29):match("^%s*(%S+)") or tostring(p29)
    local offset = utf8.offset
    local ok, result = pcall(offset, v68, 5)
    local v69, v70

    if ok then
        if result then
            local v71 = v68:sub(1, result - 1)

            if v71 then
                v69 = v71
                v70 = true
            elseif v68 then
                v69 = v68
                v70 = true
            else
                v70 = false
            end
        elseif v68 then
            v69 = v68
            v70 = true
        else
            v70 = false
        end
    else
        v70 = false
    end

    if not v70 then
        v69 = v68:sub(1, 4)
    end

    return v69:upper()
end

local function nationalFlag(p30) -- line: 308
    if typeof(p30) == "string" and #p30 == 2 then
        local v72, v73 = p30:upper():byte(1, 2)

        if not (v72 < 65) and not (v72 > 90) and not (v73 < 65) and not (v73 > 90) then
            return utf8.char(127462 + v72 - 65, 127462 + v73 - 65)
        end
    end

    return "—"
end

local v74 = label(v30, "Hashtag", ({
    Jerez = "#SpanishGP",
    Lusail = "#QatarGP",
    Mandalika = "#IndonesianGP",
    Mugello = "#ItalianGP",
    Sepang = "#MalaysianGP"
})[require(MotoLegends:WaitForChild("Config")).Track] or "#SpanishGP", Vector2.new(5, 250), Vector2.new(125, 18), 12)

v74.BackgroundTransparency = 0
v74.BackgroundColor3 = Color3.fromRGB(61, 73, 76)

local function lapTimeText(p31) -- line: 315
    if not p31 or p31 <= 0 then
        return "--:--.---"
    end

    local v76 = math.floor(p31 * 1000 + 0.5)

    return string.format("%02d:%02d.%03d", math.floor(v76 / 60000), math.floor(v76 / 1000) % 60, v76 % 1000)
end

v30.Visible = true

local Frame11 = Instance.new("Frame")

Frame11.Name = "RaceDirectionNotice"
Frame11.AnchorPoint = Vector2.new(0.5, 0)
Frame11.Position = UDim2.new(0.5, 0, 0, 64)
Frame11.Size = UDim2.fromOffset(440, 57)
Frame11.BackgroundColor3 = v3
Frame11.BackgroundTransparency = 0.12
Frame11.BorderSizePixel = 0
Frame11.Visible = false
Frame11.Parent = ScreenGui
Instance.new("UIScale", Frame11)
table.insert(t1, Frame11)
label(Frame11, "Series", "FIM  MotoLegends", Vector2.new(12, 8), Vector2.new(112, 16), 10)

local v80 = label(Frame11, "Stewards", "STEWARDS", Vector2.new(12, 25), Vector2.new(112, 22), 16)
local Frame12 = Instance.new("Frame", Frame11)

Frame12.Name = "Divider"
Frame12.BorderSizePixel = 0
Frame12.BackgroundColor3 = v2
Frame12.Position = UDim2.fromOffset(132, 8)
Frame12.Size = UDim2.fromOffset(1, 41)

local v81 = label(Frame11, "Title", "", Vector2.new(144, 8), Vector2.new(284, 23), 12)
local v82 = label(Frame11, "Detail", "", Vector2.new(144, 32), Vector2.new(284, 18), 10)

v82.TextColor3 = v5

local clone = Frame11:Clone()

clone.Name = "QualifyingRequirement"
clone.Parent = ScreenGui
table.insert(t1, clone)

local NumberValue = Instance.new("NumberValue")

NumberValue.Value = 1

local t10 = {}

for _, v83 in {
        Frame11,
        table.unpack(Frame11:GetDescendants())
    } do
    if v83:IsA("GuiObject") then
        t10[v83] = {
            background = v83.BackgroundTransparency,
            text = v83:IsA("TextLabel") and v83.TextTransparency or nil
        }
    end
end

local function applyNoticeAlpha(p32) -- line: 335
    -- upvalues: t10 (copy)
    for v84, v85 in t10 do
        v84.BackgroundTransparency = v85.background + (1 - v85.background) * p32

        if v85.text then
            v84.TextTransparency = v85.text + (1 - v85.text) * p32
        end
    end
end

NumberValue.Changed:Connect(applyNoticeAlpha)
applyNoticeAlpha(1)

local v86, v87

local function animateNotice(p33, p34, p35) -- line: 343
    -- upvalues: TweenService (copy), Frame11 (copy), NumberValue (copy), v86 (ref), v87 (ref)
    if v86 then
        v86:Cancel()
    end

    if v87 then
        v87:Cancel()
    end

    local v88 = TweenInfo.new(p35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    v86 = TweenService:Create(NumberValue, v88, {
        Value = p33
    })
    v87 = TweenService:Create(Frame11, v88, {
        Position = p34
    })
    v86:Play()
    v87:Play()
end

local n2 = 0
local TextSize = v80.TextSize

local function noticeTop() -- line: 356
    -- upvalues: LocalPlayer (copy)
    local v89 = workspace.CurrentCamera.ViewportSize.Y / 360
    local Height = game:GetService("GuiService").TopbarInset.Height
    local v90, v91

    if Height > 0 and Height <= 36 then
        v91 = 2
        v90 = 32
    else
        v91 = 12
        v90 = math.max(32, Height - 14)
    end

    local v95 = math.max(2, (math.floor(v91 + v90 / 2 - 10 * v89 + 0.5)))
    local FlagBannerHUD = LocalPlayer.PlayerGui:FindFirstChild("FlagBannerHUD")

    FlagBannerHUD = FlagBannerHUD and FlagBannerHUD.Enabled and FlagBannerHUD:GetAttribute("BottomPx")

    if typeof(FlagBannerHUD) == "number" and FlagBannerHUD > 0 then
        v95 = math.max(v95, (math.floor(FlagBannerHUD + 4)))
    end

    return v95
end

local function holdFor(p36, p37) -- line: 372
    return (math.clamp(0 + ((utf8.len((tostring(p36 or ""))) or 0) + (utf8.len((tostring(p37 or ""))) or 0)) / 12, 3, 10))
end

local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

UITextSizeConstraint.MaxTextSize = 14
UITextSizeConstraint.MinTextSize = 7
UITextSizeConstraint.Parent = v81
task.spawn(function() -- line: 378
    -- upvalues: TweenService (copy), LocalPlayer (copy), Frame11 (copy), NumberValue (copy), v87 (ref), noticeTop (copy)
    local v102 = LocalPlayer.PlayerGui:WaitForChild("FlagBannerHUD", 30)

    if v102 then
        v102:GetAttributeChangedSignal("BottomPx"):Connect(function() -- line: 381
            -- upvalues: TweenService (copy), Frame11 (copy), NumberValue (copy), v87 (ref), noticeTop (copy)
            if not (Frame11.Visible and NumberValue.Value < 0.5) then
                return
            end

            if v87 then
                v87:Cancel()
            end

            v87 = TweenService:Create(Frame11, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, (noticeTop()))
            })
            v87:Play()
        end)
    end
end)

local function showNotice(p38) -- line: 389
    -- upvalues: Frame11 (copy), v80 (copy), v81 (copy), v82 (copy), clone (copy), NumberValue (copy), animateNotice (copy), n2 (ref), TextSize (copy), noticeTop (copy)
    n2 += 1

    local v103 = n2
    local v104 = typeof(p38.from) == "string" and p38.from ~= ""

    v80.Text = v104 and string.upper(p38.from) or "STEWARDS"
    v80.TextSize = if v104 then 12 else TextSize

    local v107 = v104 and p38.announce == true

    v81.Text = tostring(p38.text or "RACE INFORMATION"):gsub("^RACE STEWARDS%s*|%s*", "")
    v82.Text = p38.detail or ""
    v81.TextWrapped = v107
    v81.TextScaled = v107

    local v109, v110

    if v107 then
        local v111 = UDim2.fromOffset(284, if (p38.detail or "") == "" then 41 else 23)

        if v111 then
            v109 = v111
            v110 = true
        else
            v110 = false
        end
    else
        v110 = false
    end

    v81.Size = if not v110 then UDim2.fromOffset(284, 23) else v109
    clone.Visible = false

    local v112 = noticeTop()

    Frame11.Visible = true
    Frame11.Position = UDim2.new(0.5, 0, 0, v112 - 12)
    NumberValue.Value = 1
    animateNotice(0, UDim2.new(0.5, 0, 0, v112), 0.25)

    local Text = v81.Text
    local Text2 = v82.Text
    local v117 = math.clamp(0 + ((utf8.len((tostring(Text or ""))) or 0) + (utf8.len((tostring(Text2 or ""))) or 0)) / 12, 3, 10)

    task.delay(v117, function() -- line: 403
        -- upvalues: v103 (copy), Frame11 (copy), animateNotice (copy), n2 (ref), noticeTop (copy)
        if v103 == n2 then
            animateNotice(1, UDim2.new(0.5, 0, 0, noticeTop() - 12), 0.4)
            task.delay(0.4, function() -- line: 405
                -- upvalues: v103 (copy), Frame11 (copy), n2 (ref)
                if v103 == n2 then
                    Frame11.Visible = false
                end
            end)
        end
    end)
end

local v118 = {}
local t12 = {}
local n3 = (-1e999)
local v119
local t13 = {}

local function gapText(p39) -- line: 413
    if p39 >= 60 then
        return string.format("+%d:%06.3f", math.floor(p39 / 60), p39 % 60)
    end

    return string.format("+%.3f", p39)
end

local function gapReferenceId() -- line: 417
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("RaceParticipant") == true then
        return LocalPlayer.UserId
    end

    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")
    local SpectateTargetId, v121

    if JerezRaceHUD and JerezRaceHUD:GetAttribute("LobbySpectating") then
        local SpectateTargetId2 = JerezRaceHUD:GetAttribute("SpectateTargetId")

        if SpectateTargetId2 then
            SpectateTargetId = SpectateTargetId2
            v121 = true
        else
            v121 = false
        end
    else
        v121 = false
    end

    if not v121 then
        SpectateTargetId = nil
    end

    return SpectateTargetId
end

local function gapKey(p40, p41, p42) -- line: 423
    return tostring(p40) .. ":" .. tostring(p41) .. ":" .. p42
end

local t14 = {}
local t15 = {}
local SessionPhase

local function flashSession(p43) -- line: 428
    if p43 == "Racing" then
        return "Race"
    end

    return if p43 == "Qualifying" or p43 == "QualifyingFinish" then "Quali" else nil
end

local _ = {
    In = 0.22,
    ArrowAt = 0.4,
    OutStart = 0.55,
    OutEnd = 0.82,
    RetractAt = 2.35,
    Retract = 0.22,
    Total = 2.6
}
local v122 = Color3.fromRGB(70, 205, 45)
local v123 = Color3.fromRGB(255, 222, 20)

local function easeOut(p44) -- line: 441
    local v124 = math.clamp(p44, 0, 1)

    return 1 - (1 - v124) * (1 - v124)
end

local function chevron(p45, p46) -- line: 442
    local Frame = Instance.new("Frame")

    Frame.Name = p46 and "ArrowUp" or "ArrowDown"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(14, 10)
    Frame.ZIndex = 5
    Frame.Visible = false
    Frame.Parent = p45

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Pop"
    UIScale.Parent = Frame

    for _, v125 in { -1, 1 } do
        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Arm"
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = Color3.fromRGB(16, 18, 22)
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame2.Size = UDim2.fromOffset(9, 2.6)
        Frame2.Position = UDim2.fromOffset(7 + v125 * 3.1, 5)
        Frame2.Rotation = (p46 and 45 or -45) * v125
        Frame2.ZIndex = 5

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, 1)
        UICorner.Parent = Frame2
        Frame2.Parent = Frame
    end

    return Frame
end

local function flashParts(p47) -- line: 454
    -- upvalues: chevron (copy)
    if p47.flashFx then
        return p47.flashFx
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "FlashBox"
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromOffset(0, 21)
    Frame.ZIndex = 4
    Frame.ClipsDescendants = true
    Frame.Visible = false
    Frame.Parent = p47.frame

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Arrows"
    Frame2.BackgroundTransparency = 1
    Frame2.Size = UDim2.fromOffset(27, 21)
    Frame2.ZIndex = 5
    Frame2.Parent = Frame

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "FlashFill"
    Frame3.BorderSizePixel = 0
    Frame3.Size = UDim2.fromOffset(0, 21)
    Frame3.ZIndex = 2
    Frame3.Visible = false
    Frame3.Parent = p47.frame
    p47.flashFx = {
        box = Frame,
        fill = Frame3,
        up = chevron(Frame2, true),
        down = chevron(Frame2, false)
    }

    return p47.flashFx
end

local function flashCover(p48, p49) -- line: 463
    -- upvalues: v2 (copy), v3 (copy)
    p48.flashCover = p49
    p48.name.TextColor3 = p49 and v3 or p48.nameColour or v2

    if p48.bar then
        p48.bar.Enabled = not p49
    end

    if p48.textGrad then
        p48.textGrad.Enabled = not p49
    end

    if p48.shine then
        p48.shine.Visible = not p49
    end
end

local function stepFlash(p50, p51) -- line: 470
    -- upvalues: v2 (copy), v3 (copy), t15 (ref), v122 (copy), v123 (copy), flashParts (copy)
    local v126, v127

    if p50.frame.Visible and p50.userId then
        local t16 = t15
        local v128 = t16[p50.userId]

        if v128 then
            v126 = v128
            v127 = true
        else
            v127 = false
        end
    else
        v127 = false
    end

    if not v127 then
        v126 = nil
    end

    local v129 = v126 and v126.at and p51 - v126.at
    local flashFx = p50.flashFx

    if not v129 or v129 < 0 or v129 >= 2.6 then
        if flashFx and (flashFx.box.Visible or flashFx.fill.Visible) then
            flashFx.box.Visible = false
            flashFx.fill.Visible = false
            flashFx.up.Visible = false
            flashFx.down.Visible = false
        end

        if not p50.flashCover then
            return
        end

        p50.flashCover = false
        p50.name.TextColor3 = p50.nameColour or v2

        if p50.bar then
            p50.bar.Enabled = true
        end

        if p50.textGrad then
            p50.textGrad.Enabled = true
        end

        if p50.shine then
            p50.shine.Visible = true
        end
    else
        local v130 = flashFx or flashParts(p50)
        local v132 = v126.up and v122 or v123
        local v134 = math.clamp(v129 / 0.22, 0, 1)
        local v135 = 130 * (1 - (1 - v134) * (1 - v134))
        local v136 = math.min(27, v135)

        if v129 >= 2.35 then
            local v138 = math.clamp((v129 - 2.35) / 0.22, 0, 1)

            v136 = 27 * (1 - (1 - (1 - v138) * (1 - v138)))
        end

        v130.box.Visible = v136 > 0.5
        v130.box.Size = UDim2.fromOffset(math.floor(v136 + 0.5), 21)
        v130.box.BackgroundColor3 = v132

        local v140 = math.max(27, v135)
        local v141 = 27

        if v129 >= 0.55 then
            local v143 = math.clamp((v129 - 0.55) / 0.2699999999999999, 0, 1)

            v141 = 27 + 103 * (1 - (1 - v143) * (1 - v143))
        end

        v130.fill.Visible = v140 - v141 > 0.5
        v130.fill.Position = UDim2.fromOffset(math.floor(v141), 0)
        v130.fill.Size = UDim2.fromOffset(math.ceil(v140 - v141), 21)
        v130.fill.BackgroundColor3 = v132

        local up = v126.up and v130.up or v130.down;

        (v126.up and v130.down or v130.up).Visible = false

        local v145 = (v129 - 0.4) / 0.18

        if v145 > 0 then
            up.Visible = v129 < 2.35
        else
            up.Visible = false
        end

        if up.Visible then
            local v146 = math.clamp(v145, 0, 1)

            up.Pop.Scale = math.max(0.05, 1 + 2.70158 * (v146 - 1) ^ 3 + 1.70158 * (v146 - 1) ^ 2)

            local v149 = math.clamp((v129 - 2.21) / 0.14, 0, 1)

            for _, child in up:GetChildren() do
                if child:IsA("Frame") then
                    child.BackgroundTransparency = v149
                end
            end
        end

        local Visible = v130.fill.Visible and v141 < 95 and v140 > 34

        if Visible ~= (p50.flashCover == true) then
            p50.flashCover = Visible

            local name = p50.name
            local v150

            if Visible then
                v150 = v3

                if not v3 then
                    v150 = p50.nameColour or v2
                end
            else
                v150 = p50.nameColour or v2
            end

            name.TextColor3 = v150

            if p50.bar then
                p50.bar.Enabled = not Visible
            end

            if p50.textGrad then
                p50.textGrad.Enabled = not Visible
            end

            if p50.shine then
                p50.shine.Visible = not Visible
            end
        end
    end
end

RunService.RenderStepped:Connect(function() -- line: 505
    -- upvalues: v30 (copy), t7 (copy), t15 (ref), stepFlash (copy)
    if v30.Visible then
        local elapsed = os.clock()

        for _, v151 in t7 do
            local v152 = v151.flashFx

            if not v152 then
                local v153 = v151.flashCover

                if not v153 then
                    local v154 = v151.userId

                    v154 = v154 and t15[v151.userId]
                    v153 = v154
                end

                v152 = v153
            end

            if v152 then
                stepFlash(v151, elapsed)
            end
        end
    end
end)
ChampionshipEvent.OnClientEvent:Connect(function(p52, p53) -- line: 512
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), v118 (ref), t12 (ref), n3 (ref), v119 (ref), t13 (ref), t14 (ref), t15 (ref), SessionPhase (ref)
    if p52 ~= "Standings" then
        return
    end

    local SessionPhase2 = MotoLegends:GetAttribute("SessionPhase")
    local t18 = {}

    for v155, v156 in p53 do
        local v157 = t14[v156.userId]

        if SessionPhase2 == "Racing" or SessionPhase2 == "Qualifying" or SessionPhase2 == "QualifyingFinish" then
            local v158 = if SessionPhase2 == "Racing" then "Race" elseif SessionPhase2 == "Qualifying" or SessionPhase2 == "QualifyingFinish" then "Quali" else nil
            local SessionPhase3 = SessionPhase
            local v159 = if SessionPhase3 == "Racing" then "Race" elseif SessionPhase3 == "Qualifying" or SessionPhase3 == "QualifyingFinish" then "Quali" else nil

            if v158 == v159 and v157 and v157 ~= v155 then
                t15[v156.userId] = {
                    up = v155 < v157,
                    at = os.clock(),
                    untilAt = os.clock() + 2.6
                }
            end
        end

        t18[v156.userId] = v155
    end

    if SessionPhase2 ~= "Racing" and SessionPhase2 ~= "Qualifying" and SessionPhase2 ~= "QualifyingFinish" then
        t15 = {}
    end

    t14 = t18
    SessionPhase = SessionPhase2
    v118 = p53
    t13 = {}

    if SessionPhase2 == "Racing" or SessionPhase2 == "RaceResults" then
        local n4 = 0

        for v160, v161 in p53 do
            if v160 == 1 then
                t13[v161.userId] = 0
            elseif n4 then
                if typeof(v161.gapAhead) == "number" then
                    n4 += v161.gapAhead
                    t13[v161.userId] = n4
                else
                    n4 = nil
                end
            else
                n4 = nil
            end
        end
    end

    local v162

    if LocalPlayer:GetAttribute("RaceParticipant") == true then
        v162 = LocalPlayer.UserId
    else
        local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")
        local v163 = false

        if JerezRaceHUD and JerezRaceHUD:GetAttribute("LobbySpectating") then
            local SpectateTargetId = JerezRaceHUD:GetAttribute("SpectateTargetId")

            if SpectateTargetId then
                v162 = SpectateTargetId
                v163 = true
            end
        end

        if not v163 then
            v162 = nil
        end
    end

    if SessionPhase2 ~= "Racing" or not v162 then
        t12 = {}
        n3 = (-1e999)
        v119 = nil
    elseif v162 ~= v119 or os.clock() - n3 >= 5 then
        t12 = {}
        n3 = os.clock()
        v119 = v162

        for v164, v165 in p53 do
            if v165.userId == v162 then
                local v166 = p53[v164 - 1]
                local v167 = p53[v164 + 1]

                if v166 then
                    local t23 = t12
                    local userId = v166.userId

                    t23[tostring(v162) .. ":" .. tostring(userId) .. ":" .. "ahead"] = {
                        gap = v165.gapAhead
                    }
                end

                if v167 then
                    local t24 = t12
                    local userId = v167.userId

                    t24[tostring(v162) .. ":" .. tostring(userId) .. ":" .. "behind"] = {
                        gap = v167.gapAhead
                    }

                    return
                end

                break
            end
        end
    end
end)

local function showTrackLimits() -- line: 547
    -- upvalues: MotoLegends (copy), showNotice (copy)
    showNotice({
        text = "TRACK LIMITS WARNING",
        detail = MotoLegends:GetAttribute("SessionPhase") == "Qualifying" and "LAP INVALIDATED" or "TRACK LIMITS EXCEEDED"
    })
end

local function stewardAfterFinish(p54, p55) -- line: 551
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("RaceFinished") ~= true or typeof(p55) == "table" and p55.from then
        return false
    end

    if p54 == "TrackLimits" then
        return true
    end

    local v168 = if typeof(p55) == "table" then tostring(p55.text or "") or "" else ""

    if v168:find("STEWARDS") == nil and v168:find("TRACK LIMITS") == nil and v168:find("LONG LAP") == nil and v168:find("OFF CIRCUIT") == nil then
        return v168:find("LAP INVALID") ~= nil
    end

    return true
end

local Sound = Instance.new("Sound")

Sound.Name = "StewardNotice"
Sound.SoundId = "rbxassetid://8968249401"
Sound.Volume = 5
Sound.Parent = game:GetService("SoundService")

local SoundGroup = Instance.new("SoundGroup")

SoundGroup.Name = "BikeAudioDuck"
SoundGroup.Volume = 1
SoundGroup.Parent = game:GetService("SoundService")

local n5 = 0

local function duckBikes() -- line: 568
    -- upvalues: TweenService (copy), SoundGroup (copy), n5 (ref)
    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if RaceBikes then
        for _, descendant in RaceBikes:GetDescendants() do
            if descendant:IsA("Sound") and descendant.SoundGroup == nil then
                descendant.SoundGroup = SoundGroup
            end
        end
    end

    n5 += 1

    local v170 = n5

    TweenService:Create(SoundGroup, TweenInfo.new(0.12), {
        Volume = 0.4
    }):Play()
    task.delay(1.1, function() -- line: 573
        -- upvalues: v170 (copy), TweenService (copy), SoundGroup (copy), n5 (ref)
        if n5 == v170 then
            TweenService:Create(SoundGroup, TweenInfo.new(0.6), {
                Volume = 1
            }):Play()
        end
    end)
end

local n6 = 0

local function isSteward(p56, p57) -- line: 579
    if p56 == "TrackLimits" then
        return true
    end

    if p56 ~= "RaceNotice" or typeof(p57) ~= "table" then
        return false
    end

    if p57.from then
        return true
    end

    local v172 = tostring(p57.text or "")

    if v172:find("STEWARDS") == nil and v172:find("TRACK LIMITS") == nil and v172:find("LONG LAP") == nil and v172:find("OFF CIRCUIT") == nil then
        return v172:find("LAP INVALID") ~= nil
    end

    return true
end

local function playSteward() -- line: 586
    -- upvalues: Sound (copy), duckBikes (copy), n6 (ref)
    if os.clock() - n6 < 0.4 then
        return
    end

    n6 = os.clock()
    Sound.TimePosition = 0
    Sound:Play()
    duckBikes()
end

MotoLegends.RaceEvent.OnClientEvent:Connect(function(p58, p59) -- line: 592
    -- upvalues: MotoLegends (copy), showNotice (copy), stewardAfterFinish (copy), Sound (copy), duckBikes (copy), n6 (ref), isSteward (copy)
    if stewardAfterFinish(p58, p59) then
        return
    end

    if isSteward(p58, p59) and not (os.clock() - n6 < 0.4) then
        n6 = os.clock()
        Sound.TimePosition = 0
        Sound:Play()
        duckBikes()
    end

    if p58 == "TrackLimits" then
        showNotice({
            text = "TRACK LIMITS WARNING",
            detail = MotoLegends:GetAttribute("SessionPhase") == "Qualifying" and "LAP INVALIDATED" or "TRACK LIMITS EXCEEDED"
        })
    elseif p58 == "RaceNotice" then
        if typeof(p59) == "table" and p59.text == "TRACK LIMITS WARNING" then
            showNotice({
                text = "TRACK LIMITS WARNING",
                detail = MotoLegends:GetAttribute("SessionPhase") == "Qualifying" and "LAP INVALIDATED" or "TRACK LIMITS EXCEEDED"
            })
        else
            showNotice(p59)
        end
    end
end)

local function resize() -- line: 600
    -- upvalues: UserInputService (copy), ScreenGui (copy), t1 (copy), v8 (copy), v28 (copy), v30 (copy), Frame11 (copy), clone (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local v176 = math.clamp(math.min(ViewportSize.X / 960, ViewportSize.Y / 540), 0.55, 1.5)

    for _, v177 in t1 do
        v177.UIScale.Scale = v176
    end

    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        Frame11.UIScale.Scale = v176 * 0.65
        clone.UIScale.Scale = v176 * 0.65
    end

    ScreenGui:SetAttribute("HudScale", v176)
    v30.UIScale.Scale = v176 * 0.85
    v8.UIScale.Scale = v176 * 0.85
    v28.UIScale.Scale = v176 * 0.72
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
resize()

local SettingsBridge = require(MotoLegends:WaitForChild("SettingsBridge"))

local function spectateHidden() -- line: 612
    -- upvalues: LocalPlayer (copy)
    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

    if JerezRaceHUD ~= nil and JerezRaceHUD:GetAttribute("LobbySpectating") == true then
        return JerezRaceHUD:GetAttribute("SpectateHudHidden") == true
    end

    return false
end

local function v178() -- line: 617
    -- upvalues: UserInputService (copy), LocalPlayer (copy), SettingsBridge (copy)
    if UserInputService.TouchEnabled or SettingsBridge.ready and SettingsBridge.get("minimap") == false then
        return true
    end

    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")
    local RaceMinimap = JerezRaceHUD and JerezRaceHUD:FindFirstChild("RaceMinimap")

    return not (RaceMinimap and RaceMinimap:IsA("GuiObject") and RaceMinimap.Visible and JerezRaceHUD.Enabled)
end

local function onScreen(p60) -- line: 625
    while p60 and p60:IsA("GuiObject") do
        if not p60.Visible then
            return false
        end

        p60 = p60.Parent
    end

    return p60 ~= nil and p60:IsA("LayerCollector") and p60.Enabled
end

local function measureRoom() -- line: 632
    -- upvalues: LocalPlayer (copy), v30 (copy), onScreen (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local Scale = v30.UIScale.Scale
    local Y, X = v30.AbsolutePosition.Y, v30.AbsolutePosition.X
    local v180 = X + 232 * Scale + 6
    local v181 = ViewportSize.Y - game:GetService("GuiService"):GetGuiInset().Y - 10
    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")
    local v182 = JerezRaceHUD ~= nil and JerezRaceHUD:GetAttribute("LobbySpectating") == true and JerezRaceHUD:GetAttribute("SpectateHudHidden") == true
    local PlayerGui = LocalPlayer.PlayerGui
    local JerezRaceHUD2 = PlayerGui:FindFirstChild("JerezRaceHUD")
    local RaceLobbyHUD = PlayerGui:FindFirstChild("RaceLobbyHUD")
    local t28 = {}

    if JerezRaceHUD2 then
        local RaceMinimap = JerezRaceHUD2:FindFirstChild("RaceMinimap")

        if RaceMinimap then
            t28[#t28 + 1] = RaceMinimap
        end

        if not v182 then
            local CornerLabel = JerezRaceHUD2:FindFirstChild("CornerLabel")

            if CornerLabel then
                t28[#t28 + 1] = CornerLabel
            end

            local TouchControls = JerezRaceHUD2:FindFirstChild("TouchControls")

            if TouchControls then
                for _, child in TouchControls:GetChildren() do
                    if child:IsA("GuiObject") then
                        t28[#t28 + 1] = child
                    end
                end
            end
        end
    end

    if RaceLobbyHUD and not v182 then
        local Money = RaceLobbyHUD:FindFirstChild("Money")

        if Money then
            t28[#t28 + 1] = Money
        end

        local BottomNavigation = RaceLobbyHUD:FindFirstChild("BottomNavigation")

        if BottomNavigation then
            for _, child in BottomNavigation:GetChildren() do
                if child:IsA("GuiObject") then
                    t28[#t28 + 1] = child
                end
            end
        end
    end

    local function consider(p61) -- line: 656
        -- upvalues: Scale (copy), Y (copy), X (copy), v180 (copy), v181 (ref), consider (copy)
        local AbsolutePosition, AbsoluteSize = p61.AbsolutePosition, p61.AbsoluteSize

        if not (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then
            for _, child in p61:GetChildren() do
                if child:IsA("GuiObject") and child.Visible then
                    consider(child)
                end
            end
        elseif AbsolutePosition.X < v180 and AbsolutePosition.X + AbsoluteSize.X > X and AbsolutePosition.Y > Y + 119 * Scale then
            local v183 = v181

            v181 = math.min(v183, AbsolutePosition.Y - 8)
        end
    end

    for _, v185 in t28 do
        if v185:IsA("GuiObject") and onScreen(v185) then
            consider(v185)
        end
    end

    return (v181 - Y) / Scale - 119 - 20
end

RunService.RenderStepped:Connect(function(p62) -- line: 671
    -- upvalues: v2 (copy), v3 (copy), v30 (copy), Frame9 (copy), v37 (ref), t7 (copy), Frame10 (copy), v63 (copy), t8 (copy), t9 (copy), openPip (copy), v74 (copy), measureRoom (copy)
    local v186 = math.min(p62, 0.1)

    t9.room = math.max(22, (measureRoom()))

    local v188 = if t8.wantOpen then 0.45 else 0.3

    t8.p = math.clamp(t8.p + (if t8.wantOpen and v186 then v186 else -v186) / v188, 0, 1)

    if t8.p <= 0 and not t8.wantOpen and t8.userId then
        v63:Clear()
        t8.userId = nil
        Frame10.Visible = false

        local pending = t8.pending

        t8.pending = nil

        if pending then
            openPip(pending)
        end
    end

    local p = t8.p
    local v190 = p * p * p * (p * (p * 6 - 15) + 10)
    local slot = t8.userId and t9.slot or nil

    if slot and not t7[slot].frame.Visible then
        slot = nil
    end

    local v191 = slot and v190 * 133 or 0
    local v192 = t8.p > 0 and t8.p < 1

    for v193, v194 in t7 do
        local v195 = (v193 - 1) * 22 + (slot and slot < v193 and v191 or 0)

        if not v194.slideAt or not (os.clock() < v194.slideAt) then
            if v192 and not v194.slide or math.abs(v195 - v194.y) < 0.5 then
                v194.y = v195

                if v194.slide then
                    v194.slide = nil
                    v194.frame.ZIndex = 1
                end
            else
                v194.y = v194.y + (v195 - v194.y) * (1 - math.exp(-v186 * (if v194.slide then 9 else 16)))
            end
        end

        v194.frame.Position = UDim2.fromOffset(0, v194.y)

        local v208 = slot == v193
        local v209 = v208 and math.floor(math.min(1, v190 * 1.6) * 102 + 130 + 0.5) or 130

        if v194.frame.Size.X.Offset ~= v209 then
            v194.frame.Size = UDim2.fromOffset(v209, 21)
            v194.hit.Size = UDim2.fromOffset(v209, 21)
        end

        if v208 then
            v194.frame.BackgroundColor3 = v3
            v194.name.TextColor3 = v2

            if v194.fullName and v194.name.Text ~= v194.fullName then
                v194.name.Text = v194.fullName
            end
        end
    end

    if slot then
        Frame10.Visible = v190 > 0
        Frame10.Position = UDim2.fromOffset(0, t7[slot].y + 22)
        Frame10.Size = UDim2.fromOffset(232, (math.floor(130 * v190 + 0.5)))

        if v190 > 0 and not v63:Update(v186) then
            t8.wantOpen = false
            t8.pending = nil
        end
    else
        Frame10.Visible = false
    end

    local v214 = if v37 then 0 else math.clamp(t9.rows * 22 + v191, 22, (math.max(22, t9.room)))

    t9.foot = (t9.foot or 1) + ((if v37 then 0 else 1) - (t9.foot or 1)) * (1 - math.exp(-v186 * 14))

    local foot = t9.foot

    v74.Visible = foot > 0.02
    v74.BackgroundTransparency = 1 - foot
    v74.TextTransparency = 1 - foot
    t9.h = if not t9.h or v192 then v214 else t9.h + (v214 - t9.h) * (1 - math.exp(-v186 * 12))
    Frame9.Size = UDim2.fromOffset(330, t9.h)
    v30.Size = UDim2.fromOffset(130, 119 + t9.h + 20 * foot)
    v74.Position = UDim2.fromOffset(0, 119 + t9.h)
end)

local CheckpointFractions
local t29 = {}

local function checkpointFractions() -- line: 718
    -- upvalues: MotoLegends (copy), CheckpointFractions (ref), t29 (ref)
    local CheckpointFractions2 = MotoLegends:GetAttribute("CheckpointFractions")

    if CheckpointFractions2 ~= CheckpointFractions then
        CheckpointFractions = CheckpointFractions2
        t29 = {}

        if typeof(CheckpointFractions2) == "string" then
            for match in CheckpointFractions2:gmatch("[^,]+") do
                local v222 = tonumber(match)

                if v222 then
                    table.insert(t29, v222)
                end
            end
        end
    end

    return t29
end

local v223

local function setProgress(p63) -- line: 727
    -- upvalues: TweenService (copy), Frame6 (copy), v223 (ref)
    local v224 = math.clamp(p63, 0, 1)
    local v225 = v223
    local v226 = if v225 then math.abs(v223 - v224) < 1E-04 else nil

    if v225 and v226 then
        return
    end

    local v228 = v223 == nil or v224 < v223

    v223 = v224

    if v228 then
        Frame6.Size = UDim2.fromScale(v224, 1)
    else
        TweenService:Create(Frame6, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(v224, 1)
        }):Play()
    end
end

local t31 = {
    on = false,
    watch = nil
}
local t32 = {}

local function playFinish(p64, p65, p66) -- line: 739
    -- upvalues: TweenService (copy), t32 (copy)
    local tween = TweenService:Create(p64, p65, p66)

    table.insert(t32, tween)
    tween:Play()
end

local function setFinish(p67, p68) -- line: 740
    -- upvalues: TweenService (copy), Frame8 (copy), v34 (copy), v35 (copy), v36 (copy), t31 (copy), t32 (copy)
    if p67 == t31.on then
        return
    end

    t31.on = p67

    for _, v229 in t32 do
        v229:Cancel()
    end

    table.clear(t32)

    if not p67 then
        v36.Visible = false
        Frame8.Size = UDim2.fromOffset(0, 4)

        return
    end

    v36.Visible = true

    if p68 then
        local v230 = TweenInfo.new(0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        v36.Position = UDim2.fromOffset(-122, 8)

        local tween = TweenService:Create(v36, v230, {
            Position = UDim2.fromOffset(8, 8)
        })

        table.insert(t32, tween)
        tween:Play()

        local tween2 = TweenService:Create(v35, v230, {
            Position = v35.Position + UDim2.fromOffset(130, 0)
        })

        table.insert(t32, tween2)
        tween2:Play()

        local tween3 = TweenService:Create(v34, v230, {
            Position = v34.Position + UDim2.fromOffset(130, 0)
        })

        table.insert(t32, tween3)
        tween3:Play()
        Frame8.Size = UDim2.fromOffset(0, 4)

        local tween4 = TweenService:Create(Frame8, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(114, 4)
        })

        table.insert(t32, tween4)
        tween4:Play()
    else
        v36.Position = UDim2.fromOffset(8, 8)
        Frame8.Size = UDim2.fromOffset(114, 4)
        v35.Visible = false
        v34.Visible = false
    end
end

local t37 = {
    on = false
}

local function setQualiFlag(p69, p70) -- line: 766
    -- upvalues: TweenService (copy), Frame8 (copy), t31 (copy), t37 (copy)
    if p69 == t37.on then
        return
    end

    t37.on = p69

    if t37.tween then
        t37.tween:Cancel()
        t37.tween = nil
    end

    if p69 then
        if p70 then
            Frame8.Size = UDim2.fromOffset(0, 4)
            t37.tween = TweenService:Create(Frame8, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(114, 4)
            })
            t37.tween:Play()
        else
            Frame8.Size = UDim2.fromOffset(114, 4)
        end
    elseif not t31.on then
        Frame8.Size = UDim2.fromOffset(0, 4)
    end
end

local function qualiDone(p71, p72) -- line: 780
    -- upvalues: Players (copy)
    if p72 == "QualifyingResults" then
        return true
    end

    if p72 ~= "QualifyingFinish" then
        return false
    end

    local PlayerByUserId = Players:GetPlayerByUserId(p71.userId)

    if not PlayerByUserId then
        return true
    end

    return not ((PlayerByUserId:GetAttribute("LiveLapStart") or 0) > 0 and PlayerByUserId:GetAttribute("LiveLapValid") ~= false)
end

local v232
local t38 = {}

local function rowChecker(p73) -- line: 791
    if p73.checker then
        return p73.checker
    end

    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Chequered"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.BorderSizePixel = 0
    CanvasGroup.Size = UDim2.fromOffset(72, 21)
    CanvasGroup.ZIndex = 2
    CanvasGroup.Visible = false
    CanvasGroup.Parent = p73.frame

    for i = 0, 23 do
        for j = 0, 6 do
            local Frame = Instance.new("Frame")

            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.fromOffset(3, 3)
            Frame.Position = UDim2.fromOffset(i * 3, j * 3)
            Frame.ZIndex = 2

            if (i + j) % 2 == 0 then
                Frame.BackgroundColor3 = Color3.new(1, 1, 1)
                Frame.BackgroundTransparency = 0.7
            else
                Frame.BackgroundColor3 = Color3.new(0, 0, 0)
                Frame.BackgroundTransparency = 0.4
            end

            Frame.Parent = CanvasGroup
        end
    end

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.45, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = CanvasGroup
    p73.checker = CanvasGroup

    return CanvasGroup
end

local function updateRowFinish(p74, p75, p76) -- line: 802
    -- upvalues: TweenService (copy), t38 (copy), rowChecker (copy)
    if p76 then
        local v233 = rowChecker(p74)

        if p74.checkerFor ~= p75.userId then
            p74.checkerFor = p75.userId
            v233.Visible = true
            p74.position.TextStrokeTransparency = 0.45

            local userId = p75.userId

            if t38[userId] then
                v233.GroupTransparency = 0
                v233.Position = UDim2.fromOffset(0, 0)
                p74.position.BackgroundTransparency = 1
            else
                t38[userId] = true
                v233.GroupTransparency = 1
                v233.Position = UDim2.fromOffset(-16, 0)
                task.delay(0.3, function() -- line: 811
                    -- upvalues: p74 (copy), v233 (copy), userId (copy), TweenService (copy)
                    if p74.checkerFor ~= userId then
                        return
                    end

                    local v234 = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                    TweenService:Create(v233, v234, {
                        GroupTransparency = 0,
                        Position = UDim2.fromOffset(0, 0)
                    }):Play()
                    TweenService:Create(p74.position, v234, {
                        BackgroundTransparency = 1
                    }):Play()
                end)
            end
        end
    elseif p74.checkerFor then
        p74.checkerFor = nil

        if p74.checker then
            p74.checker.Visible = false
        end

        p74.position.BackgroundTransparency = 0
        p74.position.TextStrokeTransparency = 1
    end
end

local n7 = 0

RunService.Heartbeat:Connect(function(p77) -- line: 827
    -- upvalues: Players (copy), TweenService (copy), LocalPlayer (copy), MotoLegends (copy), NumberFormat (copy), ScreenGui (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v8 (copy), Frame2 (copy), v9 (copy), t2 (copy), t3 (copy), v17 (copy), v18 (ref), v25 (copy), v26 (copy), v27 (copy), t5 (copy), v28 (copy), t6 (copy), v29 (copy), v30 (copy), v33 (copy), v34 (copy), v35 (copy), t7 (copy), v44 (copy), styleRow (copy), t8 (copy), t9 (copy), shortName (copy), nationalFlag (copy), v74 (copy), Frame11 (copy), clone (copy), v118 (ref), t12 (ref), t13 (ref), t15 (ref), v178 (copy), checkpointFractions (copy), setProgress (copy), t31 (copy), setFinish (copy), t37 (copy), setQualiFlag (copy), v232 (ref), t38 (copy), updateRowFinish (copy), n7 (ref)
    n7 += p77

    if n7 < 0.2 then
        return
    end

    n7 = 0

    local v235 = MotoLegends:GetAttribute("SessionPhase") or "Waiting"
    local RaceLobbyHUD = LocalPlayer.PlayerGui:FindFirstChild("RaceLobbyHUD")

    if RaceLobbyHUD then
        RaceLobbyHUD:FindFirstChild("BikeSelection")
    end

    local SeatPart = LocalPlayer.Character

    RaceLobbyHUD = SeatPart and SeatPart:FindFirstChildOfClass("Humanoid")
    RaceLobbyHUD = RaceLobbyHUD and RaceLobbyHUD.SeatPart and RaceLobbyHUD.SeatPart.Name == "RiderSeat"

    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

    v8.Visible = not RaceLobbyHUD and not (JerezRaceHUD and (JerezRaceHUD:GetAttribute("BikesPreviewOpen") or JerezRaceHUD:GetAttribute("ResultsShowing") or JerezRaceHUD:GetAttribute("LobbySpectating") or JerezRaceHUD:GetAttribute("SpectatingUserId")))

    local v239 = math.max(0, (math.ceil((MotoLegends:GetAttribute("SessionDeadline") or 0) - workspace:GetServerTimeNow())))
    local v236 = MotoLegends:GetAttribute("SessionLaps") or 3
    local v238 = MotoLegends:GetAttribute("SessionMinPlayers") or 1

    clone.Visible = false
    clone.Title.Text = "QUALIFYING REQUIREMENT"
    clone.Detail.Text = (MotoLegends:GetAttribute("SessionEligiblePlayers") or #Players:GetPlayers()) .. " / " .. v238 .. (v238 == 1 and " PLAYER REQUIRED" or " PLAYERS REQUIRED")
    v238 = (v235 == "Racing" or v235 == "QualifyingFinish") and MotoLegends:GetAttribute("FinishWindowActive") == true

    if (v235 == "RaceResults" or v235 == "QualifyingResults") and MotoLegends:GetAttribute("SessionDeadline") then
        v238 = true
    end

    local v237 = (MotoLegends:GetAttribute("SessionDeadline") or 0) <= 0

    if v237 then
        v238 = false
    end

    v25.BackgroundTransparency = 1
    v26.Position = UDim2.fromOffset(0, 0)
    v26.Size = UDim2.fromOffset(360, 44)
    v26.TextSize = 28

    local format, v240

    v26.Text = string.format("%02d:%02d", math.floor(v239 / 60), v239 % 60)
    v25.Visible = v238 and not Frame11.Visible
    format = v235 == "Lights" or MotoLegends:GetAttribute("PracticeStartLights") == true
    v27.Visible = format
    v238 = MotoLegends:GetAttribute("StartRedLights") or 0

    for v241, v242 in t5 do
        v242.BackgroundColor3 = v241 <= v238 and v4 or Color3.fromRGB(40, 42, 47)
    end

    v28.Visible = RaceLobbyHUD == true and (v235 == "Racing" or v235 == "Lights" or v235 == "Grid") and LocalPlayer:GetAttribute("RaceParticipant") == true
    v238 = LocalPlayer:GetAttribute("RaceWarnings") or 0

    local v244 = v238 > 0 and (v238 - 1) % 5 + 1 or 0

    for v245, v246 in t6 do
        v246.BackgroundColor3 = v245 <= v244 and v5 or v2
    end

    v244 = LocalPlayer:GetAttribute("LongLapPenalties") or 0
    v238 = v244 > 0
    v28.Size = UDim2.fromOffset(106, v238 and 54 or 27)
    v29.Visible = v238

    local v247

    if v244 > 0 then
        v247 = v244 > 1 and "LLP ×" .. v244 or "LLP"
        v29.Text = v247
        v29.BackgroundColor3 = v5
        v29.TextColor3 = v3
    else
        v29.Text = "LLP SERVED"
        v29.BackgroundColor3 = Color3.fromRGB(58, 62, 70)
        v29.TextColor3 = v2
    end

    v244 = v235 == "Qualifying" or v235 == "QualifyingFinish"

    local JerezRaceHUD2 = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

    JerezRaceHUD2 = JerezRaceHUD2 and (JerezRaceHUD2:GetAttribute("BikesPreviewOpen") or JerezRaceHUD2:GetAttribute("LegendsOpen"))
    v30.Visible = not JerezRaceHUD2
    v33.Text = ({
        Waiting = "WAITING",
        Qualifying = "QUALIFYING",
        QualifyingFinish = "QUALIFYING",
        QualifyingResults = "QUALI RESULTS",
        Grid = "STARTING GRID",
        Lights = "STARTING GRID",
        Racing = "SPRINT",
        RaceResults = "SPRINT RESULTS"
    })[v235] or v235
    v238 = MotoLegends:GetAttribute("SessionPractice") == true and v244

    if v238 then
        v33.Text = "PRACTICE"
    end

    local room, v248

    if LocalPlayer:GetAttribute("RaceParticipant") == true then
        v248 = LocalPlayer.UserId
    else
        v247 = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

        local v249 = false

        if v247 and v247:GetAttribute("LobbySpectating") then
            room = v247:GetAttribute("SpectateTargetId")

            if room then
                v248 = room
                v249 = true
            end
        end

        if not v249 then
            v248 = nil
        end
    end

    v247 = nil

    for v250, v251 in v118 do
        if v251.userId == v248 then
            v247 = v250
            break
        end
    end

    v30.UIScale.Scale = (ScreenGui:GetAttribute("HudScale") or 1) * 0.85

    if t8.wantOpen then
        t8.wantOpen = false
        t8.pending = nil
    end

    room = t9.room
    v240 = if v178() then 25 elseif v244 then 14 else 7

    local v252

    if t8.userId and t8.wantOpen then
        for v253, v254 in v118 do
            if v254.userId == t8.userId then
                v252 = v253
                break
            end
        end

        if not v252 then
            t8.wantOpen = false
            t8.pending = nil
        end
    end

    local v255 = room / 22
    local v257 = math.max(1, (math.floor(v255)))
    local v258 = math.floor((room - 133) / 22)

    if v252 and v258 < 1 then
        t8.wantOpen = false
        v252 = nil
        t8.pending = nil
    end

    local v259 = #v118

    if v252 and v258 then
        v257 = v258
    end

    local v261 = math.max(1, (math.min(v240, v259, v257)))

    if v235 == "Racing" and v247 then
        v255 = (v261 - 1) / 2
        v258 = v247 - math.floor(v255)
    else
        v258 = 1
    end

    if v252 then
        if not (v252 < v258) then
            v252 = if v258 + v261 - 1 < v252 then v252 - v261 + 1 else v258
        end
    else
        v252 = v258
    end

    local v262 = #v118 - v261 + 1
    local v263 = math.max(1, v262)
    local v256 = math.clamp(v252, 1, v263)

    v261 = math.max(1, (math.min(v261, #v118 - v256 + 1)))
    t9.rows = v261

    local v264

    if t8.userId and (t8.wantOpen or t8.p > 0) then
        for i = 1, v261 do
            v252 = v118[v256 + i - 1]

            if v252 and v252.userId == t8.userId then
                v264 = i
                break
            end

            v264 = nil
        end
    end

    t9.slot = v264
    v74.Size = UDim2.fromOffset(130, 20)
    v240 = v235 == "Racing" or v235 == "RaceResults"

    local v266, v267

    if JerezRaceHUD and JerezRaceHUD:GetAttribute("LobbySpectating") then
        v255 = JerezRaceHUD:GetAttribute("SpectateTargetId")

        if v255 then
            v266 = v255
            v267 = true
        else
            v267 = false
        end
    else
        v267 = false
    end

    if not v267 then
        v266 = LocalPlayer:GetAttribute("RaceParticipant") and LocalPlayer.UserId
    end

    local v268 = v118[1]

    for _, v269 in v118 do
        if v269.userId == v266 then
            v268 = v269
            break
        end
    end

    v266 = (v235 == "QualifyingFinish" or v235 == "QualifyingResults") and MotoLegends:GetAttribute("SessionPractice") ~= true

    if not v240 then
        v268 = nil

        if not v266 then
            table.clear(t38)
        end
    end

    setQualiFlag(v266, v232 == "Qualifying")
    v232 = v235
    v255 = v240 and (not RaceLobbyHUD or LocalPlayer:GetAttribute("RaceParticipant") ~= true)

    local v260 = v268 and v268.userId

    v259 = v268 ~= nil and v268.finish ~= nil
    setFinish(v259, t31.watch == v260)
    t31.watch = v260

    if not t31.on then
        v34.Visible = not v244
        v34.Position = UDim2.fromOffset(8, 3)
        v35.Position = UDim2.fromOffset(8, v244 and 7 or 16)
        v35.Size = UDim2.fromOffset(114, v244 and 44 or 35)
        v35.Visible = not v238 and not (v244 and v237)
    end

    local v270, v271

    if v244 then
        local v272

        if v235 == "QualifyingFinish" then
            v272 = "00:00"
        else
            v272 = string.format
            v270 = v239 / 60
            v272 = v272("%02d:%02d", math.floor(v270), v239 % 60)
        end

        v35.Text = v272
    else
        local v273, v274

        if v268 then
            v260 = v268.laps

            if v260 then
                v273 = v260
                v274 = true
            else
                v271 = v118[1]

                if v271 then
                    v271 = v118
                    v260 = v271[1].laps

                    if v260 then
                        v273 = v260
                        v274 = true
                    else
                        v274 = false
                    end
                else
                    v274 = false
                end
            end
        else
            v271 = v118[1]

            if v271 then
                v271 = v118
                v260 = v271[1].laps

                if v260 then
                    v273 = v260
                    v274 = true
                else
                    v274 = false
                end
            else
                v274 = false
            end
        end

        if not v274 then
            v273 = 0
        end

        v270 = v273 + 1
        v35.Text = math.min(v236, v270) .. " of " .. v236
    end

    v271 = t31.on

    local v277, v278

    if v271 or t37.on then
        setProgress(1)
    elseif not v240 or not v268 then
        if not v240 and v235 ~= "Grid" and v235 ~= "Lights" and not v238 and (v235 ~= "Qualifying" or not v237) then
            if v235 == "Qualifying" then
                v271 = (require(MotoLegends:WaitForChild("Config")).Championship or {}).QualifyingSeconds or 600
                v278 = ((MotoLegends:GetAttribute("SessionDeadline") or 0) - workspace:GetServerTimeNow()) / math.max(1, v271)
                setProgress(1 - math.clamp(v278, 0, 1))
            else
                setProgress(1)
            end
        else
            setProgress(0)
        end
    else
        v263 = checkpointFractions()
        v271 = #v263 + 1
        v262 = v268.progress or 0
        v277 = 0

        for _, v279 in v263 do
            if v279 <= v262 then
                v277 += 1
            end
        end

        setProgress(((v268.laps or 0) * v271 + v277) / (math.max(1, v236) * v271))
    end

    v237 = {
        1e999, 1e999, 1e999, 1e999
    }

    local name

    if v244 then
        for _, v280 in v118 do
            for j = 1, 4 do
                v238 = v280.sectorBests and v280.sectorBests[j]

                if v238 and v238 > 0 then
                    name = v237[j]
                    v237[j] = math.min(name, v238)
                end
            end
        end
    end

    v236 = t9.slotOf or {}

    local t39 = {}
    local v281 = {}

    for v282, v283 in t7 do
        v281[v282] = v283.y
    end

    t9.slotOf = t39

    local v284, v285, v286

    for v287, v288 in t7 do
        v284 = v256 + v287 - 1
        v285 = v287 <= v261 and v118[v284] or nil
        v288.frame.Visible = v285 ~= nil

        local v289

        if v285 then
            t39[v285.userId] = v287
            v289 = v236[v285.userId]

            if v288.userId ~= v285.userId and v289 and v289 ~= v287 and t7[v289].frame.Visible then
                v288.y = v281[v289]
                v288.slide = true
                name = t15[v285.userId]
                v288.slideAt = name and os.clock() - name.at < 0.22 and name.at + 0.22 or nil
                v288.frame.Position = UDim2.fromOffset(0, v288.y)
                v288.frame.ZIndex = v287 < v289 and 2 or 1
            end
        end

        v289 = v288.hit
        name = not RaceLobbyHUD

        if name then
            name = v285 ~= nil and v285.userId ~= LocalPlayer.UserId
        end

        v289.Visible = name

        if v285 then
            v289 = v264 == v287
            v286 = v285.name or ""
            v288.fullName = tostring(v286):upper()
            v288.position.Text = tostring(v284)
            v288.name.Text = v289 and v288.fullName or shortName(v285.name)
            v288.flag.Text = nationalFlag(v285.country)
            v288.flag.Visible = not v244 and not v289
            name = v288.name
            v286 = UDim2.fromOffset
            name.Size = v286(if not v289 then 61 elseif v244 then 98 else 180, 20)
            v288.llp.Visible = not v244 and (v285.penalties or 0) > 0
            v286 = v285.penalties or 0
            name = math.floor(v286)
            v286 = name > 1 and "LLP ×" .. name or "LLP"

            if v288.llp.Text ~= v286 then
                v288.llp.Text = v286
            end

            name = t15[v285.userId]

            local style = if v235 == "Racing" then "Race" elseif v235 == "Qualifying" or v235 == "QualifyingFinish" then "Quali" else nil

            if style == nil or name and name.untilAt > os.clock() then
            end

            local v290 = v285.userId

            v286 = v290 and Players:GetPlayerByUserId(v290)
            name = v286 and v286:GetAttribute("StaffRole")

            local v291 = typeof(name) == "string" and name:lower() or ""

            styleRow(v288, v291)
            style = v288.style

            local color = style and style.color or v285.userId == LocalPlayer.UserId and v2 or v44

            if v288.userId ~= v285.userId then
                if v288.colourTween then
                    v288.colourTween:Cancel()
                end

                v288.frame.BackgroundColor3 = color
                v288.targetColour = nil
                v288.userId = v285.userId
            end

            if v289 then
                if v288.colourTween then
                    v288.colourTween:Cancel()
                    v288.colourTween = nil
                end

                v288.targetColour = nil
                v288.frame.BackgroundColor3 = v3
                v291 = v2

                if not v2 then
                    if style then
                        v291 = style.text

                        if not v291 then
                            v291 = v2

                            if not v2 then
                                v291 = v285.userId == LocalPlayer.UserId and v3 or v2
                            end
                        end
                    else
                        v291 = v285.userId == LocalPlayer.UserId and v3 or v2
                    end
                end
            else
                if v288.targetColour ~= color then
                    if v288.colourTween then
                        v288.colourTween:Cancel()
                    end

                    v288.targetColour = color
                    v288.colourTween = TweenService:Create(v288.frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = color
                    })
                    v288.colourTween:Play()
                end

                if style then
                    v291 = style.text

                    if not v291 then
                        v291 = v2

                        if not v2 then
                            v291 = v285.userId == LocalPlayer.UserId and v3 or v2
                        end
                    end
                else
                    v291 = v285.userId == LocalPlayer.UserId and v3 or v2
                end
            end

            v288.nameColour = v291

            if not v288.flashCover then
                v288.name.TextColor3 = v288.nameColour
            end

            color = not v288.flashCover and not v289

            if v288.bar and v288.bar.Enabled ~= color then
                v288.bar.Enabled = color
            end

            if v288.textGrad and v288.textGrad.Enabled ~= color then
                v288.textGrad.Enabled = color
            end

            if v288.shine and v288.shine.Visible ~= color then
                v288.shine.Visible = color
            end

            v288.position.BackgroundColor3 = v244 and v2 or Color3.fromRGB(26, 36, 43)
            v288.position.TextColor3 = v244 and v3 or v2

            if style and v285.userId == LocalPlayer.UserId and not v244 and not v288.checkerFor then
                v288.position.BackgroundColor3 = v2
                v288.position.TextColor3 = v3
            end

            local v292, v293, v294

            if v235 ~= "Racing" or not v247 or v285.userId == v248 or v285.userId == LocalPlayer.UserId then
                v291 = nil
                v290 = nil
            else
                local v296 = v118[v247 - 1]

                v296 = v296 and v285.userId == v118[v247 - 1].userId

                if v296 then
                    v290 = "−"
                    v292 = "ahead"
                else
                    v293 = v118[v247 + 1]

                    if v293 then
                        v293 = v285.userId
                        v294 = v118

                        if v293 == v294[v247 + 1].userId then
                            v290 = "+"
                            v292 = "behind"
                        else
                            v290 = nil
                        end
                    else
                        v290 = nil
                    end
                end

                if v292 then
                    v293 = t12
                    v294 = v285.userId
                    style = v293[tostring(v248) .. ":" .. tostring(v294) .. ":" .. v292]
                else
                    style = v292
                end

                v291 = style and style.gap
            end

            v293 = not v255

            if v293 then
                v293 = v292 ~= nil and typeof(v291) == "number"
            end

            local v299

            if v255 then
                if v284 == 1 then
                    v294 = "LEADER"
                else
                    v292 = t13[v285.userId]

                    if v292 then
                        if v292 >= 60 then
                            v294 = string.format
                            v299 = v292 / 60
                            v294 = v294("+%d:%06.3f", math.floor(v299), v292 % 60)
                        else
                            v294 = string.format("+%.3f", v292)
                        end

                        v294 = v294 or "--.---"
                    else
                        v294 = "--.---"
                    end
                end
            else
                v294 = nil
            end

            local time = v288.time

            if v244 and (v285.best or 0) > 0 then
                time.Visible = true
            else
                time.Visible = v293 or v294 ~= nil
            end

            time = v288.time

            local format

            if v244 then
                local best = v285.best
                local v300 = "--:--.---"

                if best then
                    if best <= 0 then
                        v300 = "--:--.---"
                    else
                        format = best * 1000 + 0.5
                        v299 = math.floor(format)
                        v300 = string.format("%02d:%02d.%03d", math.floor(v299 / 60000), math.floor(v299 / 1000) % 60, v299 % 1000)
                    end
                end

                time.Text = v300 or v294 or v291 and string.format("%s%.3f", v290, v291) or "--.---"
            else
                time.Text = v294 or v291 and string.format("%s%.3f", v290, v291) or "--.---"
            end

            if not v240 or v285.finish == nil then
                if v266 then
                    if v235 == "QualifyingResults" then
                        v299 = true
                    elseif v235 == "QualifyingFinish" then
                        format = Players:GetPlayerByUserId(v285.userId)

                        if format then
                            v290 = (format:GetAttribute("LiveLapStart") or 0) > 0 and format:GetAttribute("LiveLapValid") ~= false
                            v299 = not v290
                        else
                            v299 = true
                        end
                    else
                        v299 = false
                    end
                else
                    v299 = v266
                end
            else
                v299 = true
            end

            updateRowFinish(v288, v285, v299)

            if v244 and v288.checkerFor then
                v288.position.TextColor3 = v285.userId == LocalPlayer.UserId and v3 or v2
            end

            v288.time:SetAttribute("GapRiderId", v293 and v285.userId or nil)
            v288.time:SetAttribute("GapReferenceId", v293 and v248 or nil)
            v288.accent.Visible = v288.time.Visible
            v288.llp.Position = UDim2.fromOffset(v288.time.Visible and 238 or 135, 0)

            for v304, v305 in v288.sectors do
                v305.Visible = v244 and not v289
                v293 = v285.sectors and v285.sectors[v304]
                v291 = v285.sectorBests and v285.sectorBests[v304]

                local LiveLapStart = Color3.fromRGB(71, 78, 83)

                if v293 and v293 > 0 and v285.valid ~= false then
                    LiveLapStart = if v293 <= v237[v304] + 5E-04 then v4 elseif v291 and v291 > 0 and v293 <= v291 + 5E-04 then Color3.fromRGB(255, 140, 38) else v2
                end

                v305.BackgroundColor3 = LiveLapStart
            end
        end
    end

    v8.Position = UDim2.new(1, -14, 0.5, 0)

    for _, v306 in t3 do
        v281 = t2[v306.id]
        v255 = LocalPlayer:GetAttribute("Daily_" .. v306.id) or 0
        v284 = LocalPlayer:GetAttribute("Daily_" .. v306.id .. "_Claimed")

        local Attribute = LocalPlayer:GetAttribute("Daily_" .. v306.id .. "_Pending")
        local count = v281.fill

        v285 = UDim2.fromScale
        name = v255 / v306.goal
        count.Size = v285(math.clamp(name, 0, 1), 1)
        count = v281.count

        if v306.id == "playtime" then
            v285 = string.format
            v286 = v255 / 60
            count.Text = v285("%dm %02ds / 15m", math.floor(v286), v255 % 60) or v255 .. " / " .. v306.goal
        else
            count.Text = v255 .. " / " .. v306.goal
        end

        count = v281.reward

        if v284 then
            count.Text = ""
        elseif Attribute then
            count.Text = "SAVING"
        else
            count.Text = NumberFormat.Money(v306.reward)
        end

        v281.reward.Visible = not v284
        v281.reward.TextColor3 = v2
    end

    v257 = LocalPlayer:GetAttribute("ProgressLoaded") == true and LocalPlayer:GetAttribute("Community_Claimed") ~= true

    if v257 ~= v18 then
        v18 = v257
        v17.Visible = v257
        v240 = if v257 then 203 else 168
        v8.Size = UDim2.fromOffset(270, v240)
        Frame2.Size = UDim2.fromOffset(236, v240)
    end

    v277 = math.max(0, (LocalPlayer:GetAttribute("DailyResetAt") or 0) - os.time())
    v9.Text = string.format("Reset %02d:%02d:%02d", math.floor(v277 / 3600), math.floor(v277 / 60) % 60, v277 % 60)
end)
ChampionshipEvent:FireServer("Sync")
