-- https://lua.expert

local Track = require(game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends"):WaitForChild("Config")).Track
local v1 = workspace:FindFirstChild("RaceCollision", true) or workspace:WaitForChild("RaceCollision")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ChatInputBarConfiguration = game:GetService("TextChatService"):WaitForChild("ChatInputBarConfiguration")
local v2 = false
local v3 = false
local n1 = 0
local v4 = false

ChatInputBarConfiguration:GetPropertyChangedSignal("IsFocused"):Connect(function() -- line: 13
    -- upvalues: v4 (ref)
    v4 = false
end)

local function v5(p1) -- line: 14
    -- upvalues: Players (copy), UserInputService (copy), ChatInputBarConfiguration (copy), v2 (ref), v3 (ref), n1 (ref), v4 (ref)
    if p1 then
        v4 = ChatInputBarConfiguration.IsFocused and UserInputService:GetFocusedTextBox() == nil

        return false
    end

    local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    local JerezRaceHUD = PlayerGui and PlayerGui:FindFirstChild("JerezRaceHUD")

    if JerezRaceHUD and JerezRaceHUD:GetAttribute("Freecam") == true then
        return true
    end

    local v6 = v2
    local v7, v8

    if v6 then
        v7 = v6
        v8 = true
    else
        local v9 = v3

        if v9 then
            v7 = v9
            v8 = true
        elseif os.clock() < n1 then
            v7 = true
            v8 = true
        elseif ChatInputBarConfiguration.IsFocused then
            local v10 = not v4

            if v10 then
                v7 = v10
                v8 = true
            else
                v8 = false
            end
        else
            v8 = false
        end
    end

    if not v8 then
        v7 = UserInputService:GetFocusedTextBox() ~= nil
    end

    return v7
end

local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local Config = require(MotoLegends:WaitForChild("Config"))
local BikeDynamics = require(MotoLegends:WaitForChild("BikeDynamics"))
local BikeGearbox = require(MotoLegends:WaitForChild("BikeGearbox"))
local BikeAudio = require(MotoLegends:WaitForChild("BikeAudio"))
local BikeVisualSlide = require(MotoLegends:WaitForChild("BikeVisualSlide"))
local RaceGauge = require(MotoLegends:WaitForChild("RaceGauge"))
local GamepadControls = require(MotoLegends:WaitForChild("GamepadControls"))
local t1 = {
    { "Throttle", "W", "ButtonR2" },
    { "Front brake", "S", "ButtonL2" },
    { "Steer left", "A" },
    { "Steer right", "D" },
    { "Spawn / rear view", "X", "ButtonR3" },
    { "Rear brake", "LeftShift", "ButtonA" },
    { "Shift down", "Q", "ButtonX" },
    { "Shift up", "E", "ButtonY" },
    { "Wheelie", "F" },
    { "Stoppie", "G" },
    { "Ride height", "R", "ButtonB" },
    { "Clutch (hold)", "T", "ButtonL1" },
    { "Dismount", "Space", "ButtonL3" },
    { "Transmission", "M" },
    { "Camera", "C", "ButtonR1" },
    { "Rear view", "X", "ButtonR3" },
    { "Controls", "H", "ButtonSelect" },
    { "Leaderboard", "B" },
    { "Toggle Anti-lock Brakes", "U" },
    { "Assist: previous (TCS/AW/EBS)", "Left", "DPadLeft" },
    { "Assist: next (TCS/AW/EBS)", "Right", "DPadRight" },
    { "Assist: value up", "Up", "DPadUp" },
    { "Assist: value down", "Down", "DPadDown" },
    { "Steer / wheelie axis", nil, "Thumbstick1" },
    { "Camera orbit axis", nil, "Thumbstick2" },
    { "Rear brake alternate", "RightShift" }
}
local t2 = {}
local t3 = {}
local t4, v11

for _, v12 in t1 do
    local v13 = v12[2]

    if v13 then
        t2[v13] = Enum.KeyCode[v13]
    end

    v13 = v12[3]

    if v13 then
        t2[v13] = Enum.KeyCode[v13]
    end
end

local function mappedKey(p2) -- line: 49
    -- upvalues: t2 (copy)
    for v14, v15 in t2 do
        if v15 == p2 then
            return Enum.KeyCode[v14]
        end
    end

    return t2[p2.Name] and Enum.KeyCode.Unknown or p2
end

local CrashHaptics = require(MotoLegends:WaitForChild("CrashHaptics"))
local BikeSuspension = require(MotoLegends:WaitForChild("BikeSuspension"))
local RiderPose = require(MotoLegends:WaitForChild("RiderPose"))
local RaceMinimap = require(MotoLegends:WaitForChild("RaceMinimap"))
local RaceSocialHUD = require(MotoLegends:WaitForChild("RaceSocialHUD"))
local Layout = require(MotoLegends:WaitForChild("Tracks"):WaitForChild(Track):WaitForChild("Layout"))
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "JerezRaceHUD"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local v17 = RaceMinimap.New(ScreenGui, Layout, Config)
local v18 = RaceSocialHUD.New(ScreenGui)
local v19 = Color3.fromRGB(244, 245, 243)
local v20 = Color3.fromRGB(61, 255, 70)
local v21 = Color3.fromRGB(225, 26, 39)

local function frame(p3, p4, p5, p6, p7, p8, p9, p10) -- line: 66
    local v22 = Instance.new(if p4 == "RaceSettings" then "ScrollingFrame" else "Frame")

    v22.Name = p4
    v22.Position = UDim2.fromOffset(p5, p6)
    v22.Size = UDim2.fromOffset(p7, p8)
    v22.BackgroundColor3 = p9 or Color3.new(0, 0, 0)
    v22.BackgroundTransparency = p10 or 0
    v22.BorderSizePixel = 0
    v22.Parent = p3

    return v22
end

local function text(p11, p12, p13, p14, p15, p16, p17, p18, p19, p20) -- line: 70
    -- upvalues: v19 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p12
    TextLabel.Text = p13
    TextLabel.Position = UDim2.fromOffset(p14, p15)
    TextLabel.Size = UDim2.fromOffset(p16, p17)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = p19 or Enum.Font.Gotham
    TextLabel.TextSize = p18 or 10
    TextLabel.TextColor3 = p20 or v19
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.BorderSizePixel = 0
    TextLabel.Parent = p11

    return TextLabel
end

local function stroke(p21, p22, p23) -- line: 75
    -- upvalues: v19 (copy)
    local UIStroke = Instance.new("UIStroke", p21)

    UIStroke.Color = p22 or v19
    UIStroke.Thickness = p23 or 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    return UIStroke
end

do
    local function round(p24, p25) -- line: 78
        local UICorner = Instance.new("UICorner", p24)

        UICorner.CornerRadius = UDim.new(0, p25)

        return UICorner
    end
end

local v23 = frame(ScreenGui, "LapAnchor", 20, 22, 89, 71)
local UIScale = Instance.new("UIScale", v23)

do
    local v24 = text(v23, "MotoGP", "MotoGP", 5, 3, 78, 15, 13, Enum.Font.GothamBold)

    v24.RichText = true
    v24.Text = "<i>MotoLegends</i>"
    v24.TextScaled = true
    Instance.new("UITextSizeConstraint", v24).MaxTextSize = 13
end

frame(v23, "RedRule", 4, 20, 80, 1, v21)
text(v23, "LapCaption", "LAP", 5, 22, 70, 10, 9)

local v25 = text(v23, "LapNumber", "1", 4, 29, 80, 30, 29, Enum.Font.Gotham)

frame(v23, "Footer", 0, 57, 89, 14, Color3.fromRGB(80, 93, 92), 0.13)
text(v23, "Hashtag", ({
    Jerez = "#SpanishGP",
    Lusail = "#QatarGP",
    Mandalika = "#IndonesianGP",
    Mugello = "#ItalianGP",
    Sepang = "#MalaysianGP"
})[Track] or "#SpanishGP", 4, 58, 80, 11, 9)

local v26 = text(v23, "CurrentSector", "S1 · 00:00.000", 0, 79, 140, 14, 10, Enum.Font.Code)

v26.Visible = false

local v27 = frame(ScreenGui, "TimingAnchor", 0, 23, 72, 139, nil, 1)
local UIScale2 = Instance.new("UIScale", v27)
local v28 = text(v27, "CurrentTime", "--:--.---", 0, 0, 72, 17, 13, Enum.Font.Code)

v28.TextXAlignment = Enum.TextXAlignment.Right
frame(v27, "CurrentRule", 0, 16, 72, 2, v19, 0.3)
frame(v27, "BestShade", 0, 37, 72, 26, Color3.fromRGB(25, 44, 42), 0.38)
text(v27, "RecordIcon", "R", 3, 38, 10, 11, 9, Enum.Font.GothamBold)

local v29 = text(v27, "BestTime", "--:--.---", 16, 38, 55, 11, 9, Enum.Font.Code, v21)

do
    local v30 = frame(v27, "PreviousIcon", 4, 52, 6, 6, nil, 1)

    Instance.new("UICorner", v30).CornerRadius = UDim.new(0, 4)

    local UIStroke = Instance.new("UIStroke", v30)

    UIStroke.Color = v19 or v19
    UIStroke.Thickness = 0.8
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    frame(v30, "MinuteHand", 3, 1, 1, 3, v19)
    frame(v30, "HourHand", 3, 3, 2, 1, v19)
end

local v31 = text(v27, "PreviousTime", "--:--.---", 16, 50, 55, 10, 9, Enum.Font.Code, v21)
local t5 = {}

for i = 1, 5 do
    t5[i] = text(frame(v27, "LapHistory" .. i, 0, (i - 1) * 12 + 64, 72, 12, Color3.new(0, 0, 0), 0.6), "Value", string.format("%d   --:--.---", 6 - i), 3, 0, 69, 12, 9, Enum.Font.Code)
end

local function sponsorLogo(p26, p27, p28, p29, p30) -- line: 109
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "SponsorLogo"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Image = "rbxassetid://137644420642666"
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Position = UDim2.fromOffset(p27, p28)
    ImageLabel.Size = UDim2.fromOffset(p29, p30)
    ImageLabel.Parent = p26

    return ImageLabel
end

frame(v27, "TimingSponsor", 0, 127, 72, 12, Color3.new(0, 0, 0))
sponsorLogo(v27, 2, 128, 68, 10)

local t6 = {}

for i = 1, 4 do
    t6[i] = text(frame(v27, "SectorRow" .. i, 0, (i - 1) * 14 + 145, 72, 13, Color3.fromRGB(13, 19, 23), 0.25), "Value", "S" .. i .. "  --.---", 3, 0, 69, 13, 9, Enum.Font.Code)
end

Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Regular)

local v32 = frame(ScreenGui, "LapTimer", 0, 0, 150, 92, nil, 1)

v32.AnchorPoint = Vector2.new(1, 0)

local UIScale3 = Instance.new("UIScale", v32)
local v33 = text(v32, "Current", "00:00.000", 0, 0, 150, 24, 21, Enum.Font.GothamBlack)

v33.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold)
v33.TextXAlignment = Enum.TextXAlignment.Right
v33.TextStrokeColor3 = v19
v33.TextStrokeTransparency = 0.15

local t7 = {}

for i = 1, 4 do
    t7[i] = frame(v32, "LapBar" .. i, (i - 1) * 17 + 82, 28, 16, 2.5, Color3.fromRGB(95, 97, 102), 0.15)
end

local v34 = frame(v32, "LapBarTick", 0, 25, 1.5, 8.5, v21)
local v35 = frame(v32, "SectorTimes", 82, 92, 68, 56, Color3.fromRGB(6, 8, 12), 0.12)
local t8 = {}
local v36

for i = 1, 4 do
    text(v35, "S" .. i .. "Caption", "S" .. i, 5, (i - 1) * 13 + 2, 16, 13, 10, Enum.Font.GothamBold)
    v36 = text(v35, "S" .. i, "--.---", 20, (i - 1) * 13 + 2, 44, 13, 10, Enum.Font.GothamBold)
    v36.TextXAlignment = Enum.TextXAlignment.Right
    t8[i] = v36
end

local v37 = frame(v32, "InvalidLap", 0, 4, 70, 17, Color3.fromRGB(236, 30, 58))
local v38 = text(v37, "Text", "INVALID LAP", 0, 0, 70, 17, 9, Enum.Font.GothamBlack)

v38.TextXAlignment = Enum.TextXAlignment.Center
v38.ZIndex = 3
v37.AnchorPoint = Vector2.new(1, 0)
v37.Position = UDim2.fromOffset(-6, 5)
v38 = frame(v32, "Records", 82, 40, 68, 31, Color3.fromRGB(6, 8, 12), 0.12)
text(v38, "RIcon", "R", 5, 2, 10, 13, 10, Enum.Font.GothamBold)

local v39 = text(v38, "Best", "--:--.---", 17, 2, 48, 13, 10, Enum.Font.GothamBold, Color3.fromRGB(255, 38, 62))

v39.TextXAlignment = Enum.TextXAlignment.Center
v36 = frame(v38, "Stopwatch", 5, 19, 8, 8, nil, 1)
Instance.new("UICorner", v36).CornerRadius = UDim.new(0, 4)

do
    local UIStroke = Instance.new("UIStroke", v36)

    UIStroke.Color = v19 or v19
    UIStroke.Thickness = 1.2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

frame(v36, "Crown", 3, -3, 2, 2, v19)
frame(v36, "Hand", 3.5, 1.5, 1, 3, v19)

local v40 = text(v38, "Last", "--:--.---", 17, 16, 48, 13, 10, Enum.Font.GothamBold, Color3.fromRGB(255, 140, 38))

v40.TextXAlignment = Enum.TextXAlignment.Center

local v41 = frame(v32, "TimerClip", 0, 0, 150, 24, nil, 1)

v41.ClipsDescendants = true
v33.Parent = v41
v33.Position = UDim2.fromOffset(0, 0)

local v42 = text(v41, "LapDelta", "", 0, 24, 150, 24, 21, Enum.Font.GothamBlack)

v42.FontFace = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold)
v42.TextXAlignment = Enum.TextXAlignment.Right

local TweenService = game:GetService("TweenService")
local v43 = UDim2.fromOffset(0, -24)
local v44 = UDim2.fromOffset(0, 0)
local v45 = UDim2.fromOffset(0, 24)
local v46 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t9 = {
    seen = 0,
    refSectors = nil,
    bestSeen = 0,
    histKey = nil,
    untilT = 0,
    shown = false
}

do
    local function slide(p31, p32, p33) -- line: 169
        -- upvalues: TweenService (copy), v46 (copy)
        p31.Position = p32
        TweenService:Create(p31, v46, {
            Position = p33
        }):Play()
    end
end

local function showDelta(p34) -- line: 170
    -- upvalues: v33 (copy), v41 (copy), v42 (copy), TweenService (copy), v43 (copy), v44 (copy), v45 (copy), v46 (copy), t9 (copy)
    local v47 = math.abs(p34)
    local v48 = if v47 >= 60 then string.format("%d:%06.3f", math.floor(v47 / 60), v47 % 60) or string.format("%.3f", v47) else string.format("%.3f", v47)
    local v50 = p34 <= 0 and Color3.fromRGB(60, 230, 90) or Color3.fromRGB(255, 60, 70)

    if t9.shown then
        local clone = v42:Clone()

        clone.Parent = v41
        clone.Position = v44
        TweenService:Create(clone, v46, {
            Position = v43
        }):Play()
        task.delay(0.4, function() -- line: 180
            -- upvalues: clone (copy)
            clone:Destroy()
        end)
        v42.Text = (p34 <= 0 and "-" or "+") .. v48
        v42.TextColor3 = v50
    else
        v42.Text = (p34 <= 0 and "-" or "+") .. v48
        v42.TextColor3 = v50
        v33.Position = v44
        TweenService:Create(v33, v46, {
            Position = v43
        }):Play()
    end

    v42.Position = v45
    TweenService:Create(v42, v46, {
        Position = v44
    }):Play()
    t9.shown = true
    t9.untilT = os.clock() + 5
end

do
    local function hideDelta() -- line: 187
        -- upvalues: v33 (copy), v42 (copy), TweenService (copy), v43 (copy), v44 (copy), v45 (copy), v46 (copy), t9 (copy)
        if t9.shown then
            t9.shown = false
            v42.Position = v44
            TweenService:Create(v42, v46, {
                Position = v43
            }):Play()
            v33.Position = v45
            TweenService:Create(v33, v46, {
                Position = v44
            }):Play()
        end
    end
end

do
    sponsorLogo(frame(v32, "Tissot", 82, 75, 68, 14, Color3.new(0, 0, 0) or v19), 2, 2, 64, 10)
end

local CanvasGroup = Instance.new("CanvasGroup")

CanvasGroup.Name = "StewardsNotice"
CanvasGroup.Size = UDim2.fromOffset(206, 36)
CanvasGroup.BackgroundColor3 = Color3.fromRGB(5, 7, 10)
CanvasGroup.BackgroundTransparency = 0.06
CanvasGroup.BorderSizePixel = 0
CanvasGroup.AnchorPoint = Vector2.new(0.5, 0)
CanvasGroup.Visible = false
CanvasGroup.GroupTransparency = 1
CanvasGroup.ZIndex = 40
CanvasGroup.Parent = ScreenGui

local v52 = UDim2.fromOffset(0, 0)
local t10 = {}

t10[1] = v52

do
    local n2 = 0;

    (function(p35)
        local function showSteward() -- line: 202
            -- upvalues: p35 (copy), CanvasGroup (copy), n2 (ref)
            n2 += 1

            local v53 = n2
            local TweenService = game:GetService("TweenService")

            CanvasGroup.Visible = true
            CanvasGroup.GroupTransparency = 1
            CanvasGroup.Position = p35[1] - UDim2.fromOffset(0, 18)
            TweenService:Create(CanvasGroup, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                GroupTransparency = 0,
                Position = p35[1]
            }):Play()
            task.delay(3.6, function() -- line: 208
                -- upvalues: p35 (copy), v53 (copy), TweenService (copy), CanvasGroup (copy), n2 (ref)
                if v53 ~= n2 then
                    return
                end

                local tween = TweenService:Create(CanvasGroup, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    GroupTransparency = 1,
                    Position = p35[1] - UDim2.fromOffset(0, 20)
                })

                tween:Play()
                tween.Completed:Wait()

                if v53 == n2 then
                    CanvasGroup.Visible = false
                end
            end)
        end

        return showSteward
    end)(t10)
end

local UIScale4 = Instance.new("UIScale", CanvasGroup)

text(CanvasGroup, "Series", "<i><b>FIM  MotoLegends</b></i>", 9, 4, 84, 12, 9, Enum.Font.GothamBlack).RichText = true
text(CanvasGroup, "Stewards", "STEWARDS", 9, 16, 84, 16, 13, Enum.Font.GothamBlack)
frame(CanvasGroup, "Divider", 96, 6, 1, 24, v19)
text(CanvasGroup, "Message", "TRACK LIMITS\nINVALID LAP", 104, 3, 100, 30, 10, Enum.Font.Gotham)

local v55 = text(ScreenGui, "PitLimiter", "PIT LIMITER  " .. math.floor(require(MotoLegends:WaitForChild("PitLimiter")).LimitKph * (Config.DisplayKphScale or 1) + 0.5) .. " km/h", 0, 0, 180, 24, 14, Enum.Font.GothamBlack, Color3.fromRGB(20, 20, 20))

v55.AnchorPoint = Vector2.new(0.5, 0)
v55.TextXAlignment = Enum.TextXAlignment.Center
v55.BackgroundTransparency = 0
v55.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
Instance.new("UICorner", v55).CornerRadius = UDim.new(0, 4)
v55.Visible = false
Instance.new("UIScale", v55)

do
    local t11 = {
        [Enum.Font.GothamBlack] = Enum.FontWeight.Heavy,
        [Enum.Font.GothamBold] = Enum.FontWeight.Bold,
        [Enum.Font.GothamMedium] = Enum.FontWeight.Medium,
        [Enum.Font.Gotham] = Enum.FontWeight.Regular,
        [Enum.Font.Code] = Enum.FontWeight.SemiBold
    }

    local function unify(p36) -- line: 228
        -- upvalues: t11 (copy)
        if not p36:IsA("TextLabel") and not p36:IsA("TextButton") and not p36:IsA("TextBox") then
            return
        end

        local FontFace = p36.FontFace

        if FontFace.Family == "rbxasset://fonts/families/Montserrat.json" or p36:GetAttribute("KeepFont") then
            return
        end

        local ExtraBold

        if FontFace.Family:find("Michroma") then
            ExtraBold = Enum.FontWeight.ExtraBold

            if not ExtraBold then
                ExtraBold = t11[p36.Font]
                ExtraBold = ExtraBold or FontFace.Weight
            end
        else
            ExtraBold = t11[p36.Font]
            ExtraBold = ExtraBold or FontFace.Weight
        end

        p36.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", ExtraBold, FontFace.Style)
    end

    for _, descendant in ScreenGui:GetDescendants() do
        unify(descendant)
    end

    ScreenGui.DescendantAdded:Connect(function(p37) -- line: 235
        -- upvalues: unify (copy)
        task.defer(unify, p37)
    end)
end

v33.TextStrokeTransparency = 1
v33.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.ExtraBold)

local v56 = frame(ScreenGui, "TelemetryAnchor", 0, 0, 144, 144, nil, 1)
local UIScale5 = Instance.new("UIScale", v56)
local v57 = RaceGauge.New(v56)

v56.Size = UDim2.fromOffset(RaceGauge.Width, RaceGauge.Height)

local v58 = text(v56, "RHDIndicator", "RHD", 102, -20, 42, 18, 10, Enum.Font.GothamBold, Color3.fromRGB(139, 156, 168))

v58.TextXAlignment = Enum.TextXAlignment.Center
v58.BackgroundColor3 = Color3.fromRGB(16, 22, 26)
v58.BackgroundTransparency = 0.18
Instance.new("UICorner", v58).CornerRadius = UDim.new(0, 5)
v58.Visible = false

local TextButton = Instance.new("TextButton")

TextButton.Name = "SpawnBike"
TextButton.BackgroundColor3 = Color3.fromRGB(14, 18, 18)
TextButton.Text = "Spawn bike"
TextButton.TextColor3 = v19
TextButton.Font = Enum.Font.GothamMedium
TextButton.TextSize = 11
TextButton.BorderSizePixel = 0
TextButton.Parent = ScreenGui
Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 12)

do
    local v59 = Color3.fromRGB(67, 78, 87)
    local UIStroke = Instance.new("UIStroke", TextButton)

    UIStroke.Color = v59 or v19
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local UIScale6 = Instance.new("UIScale", TextButton)

do
    local function menuButton(p38, p39) -- line: 249
        -- upvalues: ScreenGui (copy), TextButton (copy)
        local clone = TextButton:Clone()

        clone.Name = p38
        clone.Text = p39
        clone.Parent = ScreenGui

        return clone
    end
end

local clone = TextButton:Clone()

clone.Name = "Transmission"
clone.Text = "⚙"
clone.Parent = ScreenGui
clone.TextSize = 19

local v60 = Config.Transmission
local v61 = frame(ScreenGui, "RaceSettings", 0, 0, 240, 366, Color3.fromRGB(18, 23, 29), 0.05)

v61.CanvasSize = UDim2.new()
v61.ScrollBarThickness = 0
v61.ScrollingDirection = Enum.ScrollingDirection.Y
v61.ScrollingEnabled = UserInputService.TouchEnabled
Instance.new("UICorner", v61).CornerRadius = UDim.new(0, 12)

do
    local v62 = Color3.fromRGB(67, 78, 87)
    local UIStroke = Instance.new("UIStroke", v61)

    UIStroke.Color = v62 or v19
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

v61.Visible = false
text(v61, "Caption", "RIDE SETTINGS", 14, 12, 190, 15, 10, Enum.Font.GothamMedium, Color3.fromRGB(139, 156, 168))

local TextButton2 = Instance.new("TextButton", v61)

TextButton2.Name = "Mode"
TextButton2.Position = UDim2.fromOffset(12, 35)
TextButton2.Size = UDim2.fromOffset(216, 35)
TextButton2.BackgroundColor3 = Color3.fromRGB(30, 39, 47)
TextButton2.TextColor3 = v19
TextButton2.Font = Enum.Font.GothamMedium
TextButton2.TextSize = 11
TextButton2.BorderSizePixel = 0
Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 8)

local t12 = {
    tcs = Config.TCS,
    aw = Config.AW,
    ebs = Config.EBS
}
local t13 = {}

for _, v63 in { "tcs", "aw", "ebs" } do
    t13[v63] = {
        Text = tostring(t12[v63])
    }
end

local clone2 = TextButton2:Clone()

clone2.Name = "CustomInputs"
clone2.Text = "Custom  Inputs"
clone2.TextSize = 12
clone2.Position = UDim2.fromOffset(12, 120)
clone2.Parent = v61
v61.Size = UDim2.fromOffset(240, 248)

local t15 = {
    ready = false
}

t15.nextCam = {
    [0] = 3,
    [3] = 1,
    [1] = 2,
    [2] = 0
}
t15.absButton = TextButton2:Clone()
t15.absButton.Name = "ABS"
t15.absButton.Position = UDim2.fromOffset(12, 80)
t15.absButton.Parent = v61
t15.Nametags = require(MotoLegends:WaitForChild("RaceNametags"))
t15.cams = require(MotoLegends:WaitForChild("BikeCams"))
t15.secHold = {}
t15.gfxButton = TextButton2:Clone()
t15.gfxButton.Name = "GraphicsSettings"
t15.gfxButton.Text = "Graphics  &  Performance"
t15.gfxButton.TextSize = 12
t15.gfxButton.Position = UDim2.fromOffset(12, 160)
t15.gfxButton.Parent = v61
t15.afkButton = TextButton2:Clone()
t15.afkButton.Name = "AFKMode"
t15.afkButton.Position = UDim2.fromOffset(12, 200)
t15.afkButton.Parent = v61

function t15.updateAFKButton() -- line: 278
    -- upvalues: LocalPlayer (copy), t15 (copy)
    t15.afkButton.Text = "AFK mode: " .. (if LocalPlayer:GetAttribute("AFKMode") == true then "ON" elseif LocalPlayer:GetAttribute("RaceRewardPending") == true then "LOCKED" else "OFF")
end

t15.afkButton.Activated:Connect(function() -- line: 279
    -- upvalues: v5 (copy), LocalPlayer (copy), MotoLegends (copy)
    if not v5() then
        MotoLegends.Settings:FireServer({
            afk = LocalPlayer:GetAttribute("AFKMode") ~= true
        })
    end
end)
LocalPlayer:GetAttributeChangedSignal("AFKMode"):Connect(t15.updateAFKButton)
LocalPlayer:GetAttributeChangedSignal("RaceRewardPending"):Connect(t15.updateAFKButton)
t15.updateAFKButton()
t15.ctrlButton = TextButton2:Clone()
t15.ctrlButton.Name = "MobileControlType"
t15.ctrlButton.Position = UDim2.fromOffset(12, 240)
t15.ctrlButton.Visible = UserInputService.TouchEnabled
t15.ctrlButton.Parent = v61

function t15.updateCtrlButton() -- line: 288
    -- upvalues: ScreenGui (copy), t15 (copy)
    t15.ctrlButton.Text = "Mobile controls: " .. (ScreenGui:GetAttribute("MobileControlType") == 2 and "TYPE 2 (buttons)" or "TYPE 1 (stick)")
end

t15.ctrlButton.Activated:Connect(function() -- line: 289
    -- upvalues: v5 (copy), ScreenGui (copy), t15 (copy)
    if not v5() then
        ScreenGui:SetAttribute("MobileControlType", ScreenGui:GetAttribute("MobileControlType") == 2 and 1 or 2)
        t15.send()
    end
end)
ScreenGui:GetAttributeChangedSignal("MobileControlType"):Connect(t15.updateCtrlButton)
t15.updateCtrlButton()

if UserInputService.TouchEnabled then
    v61.Size = UDim2.fromOffset(240, 288)
end

t15.gfxPanel = frame(ScreenGui, "GraphicsSettingsPanel", 0, 0, 240, 348, Color3.fromRGB(18, 23, 29), 0.05)

do
    local Activated = t15.gfxPanel

    Instance.new("UICorner", Activated).CornerRadius = UDim.new(0, 12)
    Activated = t15.gfxPanel

    local Activated2 = Color3.fromRGB(67, 78, 87)
    local UIStroke = Instance.new("UIStroke", Activated)

    UIStroke.Color = Activated2 or v19
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    t15.gfxPanel.Visible = false
    text(t15.gfxPanel, "Title", "GRAPHICS & PERFORMANCE", 14, 12, 160, 24, 11, Enum.Font.GothamBold)
    Activated = TextButton2:Clone()
    Activated.Name = "Close"
    Activated.Text = "Done"
    Activated.Size = UDim2.fromOffset(60, 28)
    Activated.Position = UDim2.fromOffset(168, 10)
    Activated.Parent = t15.gfxPanel
    Activated.Activated:Connect(function() -- line: 295
        -- upvalues: v61 (copy), t15 (copy)
        t15.gfxPanel.Visible = false
        v61.Visible = true
    end)
end

t15.gfxButton.Activated:Connect(function() -- line: 296
    -- upvalues: v5 (copy), v61 (copy), t15 (copy)
    if not v5() then
        t15.gfxPanel.Visible = true
        v61.Visible = false
    end
end)

local t16 = {
    quality = "High",
    shadows = true,
    trees = true,
    effects = true,
    marshals = true,
    fps = false,
    nametags = true,
    vibration = true,
    minimap = true,
    camShake = true,
    camFixed = false,
    audienceSet = false,
    cutscenes = true,
    apexAssist = true,
    audience = not (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
}
local t17 = {}
local t18 = {}

local function showLocal(p40, p41, p42) -- line: 302
    -- upvalues: t18 (copy)
    if p42 then
        local v65 = t18[p40]

        if v65 and v65.obj then
            v65.obj.Parent = v65.parent
        end

        t18[p40] = nil
    else
        local v66 = p41()

        if v66 and v66.Parent then
            t18[p40] = {
                obj = v66,
                parent = v66.Parent
            }
            v66.Parent = nil
        end
    end
end

local v67

local function applyGraphics() -- line: 307
    -- upvalues: Track (copy), Players (copy), LocalPlayer (copy), CrashHaptics (copy), ScreenGui (copy), t15 (copy), t16 (copy), t17 (copy), t18 (copy), showLocal (copy), v67 (ref)
    local Lighting = game:GetService("Lighting")

    LocalPlayer:SetAttribute("GfxEffects", t16.effects ~= false)
    LocalPlayer:SetAttribute("CamFixed", t16.camFixed == true)
    LocalPlayer:SetAttribute("GfxAudience", t16.audience ~= false)
    LocalPlayer:SetAttribute("ApexAssist", t16.apexAssist ~= false)
    LocalPlayer:SetAttribute("GfxCutscenes", t16.cutscenes ~= false)
    Lighting.GlobalShadows = t16.shadows

    for _, child in Lighting:GetChildren() do
        if child:IsA("PostEffect") then
            if child:GetAttribute("GfxDefault") == nil then
                child:SetAttribute("GfxDefault", child.Enabled)
            end

            child.Enabled = t16.effects and child:GetAttribute("GfxDefault")
        end
    end

    showLocal("trees", function() -- line: 316
        -- upvalues: Track (copy)
        return workspace:FindFirstChild(Track) and workspace[Track]:FindFirstChild("Vegetation")
    end, t16.trees)
    t16.marshals = true

    local function v68() -- line: 320
        -- upvalues: Track (copy)
        return workspace:FindFirstChild(Track) and workspace[Track]:FindFirstChild("MarshalPosts")
    end

    local marshals = t18.marshals

    if marshals and marshals.obj then
        marshals.obj.Parent = marshals.parent
    end

    t18.marshals = nil
    showLocal("marks", function() -- line: 321
        return workspace:FindFirstChild("RaceTyreMarks")
    end, t16.effects)

    if v67 then
        v67.Visible = false
    end

    local function v69(p43) -- line: 323
        if p43 then
            return "On"
        end

        return "Off"
    end

    t17.quality.Text = "Quality: " .. t16.quality
    t17.shadows.Text = "Shadows: " .. (t16.shadows and "On" or "Off")
    t17.trees.Text = "Trees: " .. (t16.trees and "On" or "Off")
    t17.effects.Text = "Effects & tyre marks: " .. (t16.effects and "On" or "Off")
    t17.minimap.Text = "Mini Map: " .. (t16.minimap and "On" or "Off")
    t17.nametags.Text = "Nametags: " .. (t16.nametags and "On" or "Off")
    t17.vibration.Text = "Controller vibration: " .. (t16.vibration and "On" or "Off")

    if not t16.vibration then
        CrashHaptics.Stop()
    end

    for _, player in Players:GetPlayers() do
        t15.Nametags.SyncLocal(player, t16.nametags, ScreenGui:GetAttribute("LobbySpectating") == true)
    end
end

local t19 = {
    level = 0,
    dof = Instance.new("DepthOfFieldEffect")
}

t19.dof.Name = "SpeedBlur"
t19.dof.Enabled = false
t19.dof.NearIntensity = 0
t19.dof.FarIntensity = 0

function t19.update() -- line: 338
    -- upvalues: t19 (copy)
    if t19.dof.Enabled then
        t19.dof.Enabled = false
    end
end

local t20 = {
    High = {
        shadows = true,
        trees = true,
        effects = true,
        marshals = true,
        audience = true,
        audienceSet = true
    },
    Medium = {
        shadows = true,
        trees = true,
        effects = false,
        marshals = true,
        audience = true,
        audienceSet = true
    },
    Low = {
        shadows = false,
        trees = false,
        effects = false,
        marshals = true,
        audience = false,
        audienceSet = true
    }
}
local v70

for v71, v72 in { "quality", "shadows", "trees", "effects", "nametags", "vibration", "minimap" } do
    v70 = TextButton2:Clone()
    v70.Name = "Gfx_" .. v72
    v70.Position = UDim2.fromOffset(12, 52 + (v71 - 1) * 36)
    v70.Size = UDim2.fromOffset(216, 31)
    v70.Parent = t15.gfxPanel
    t17[v72] = v70
    v70.Activated:Connect(function() -- line: 346
        -- upvalues: t15 (copy), t16 (copy), applyGraphics (copy), t20 (copy), v72 (copy)
        if v72 == "quality" then
            t16.quality = if t16.quality == "High" then "Medium" elseif t16.quality == "Medium" then "Low" else "High"

            for v73, v74 in t20[t16.quality] do
                t16[v73] = v74
            end
        else
            t16[v72] = not t16[v72]

            if v72 ~= "fps" and v72 ~= "nametags" and v72 ~= "vibration" and v72 ~= "minimap" then
                t16.quality = "Custom"
            end
        end

        applyGraphics()

        if t15.send then
            t15.send()
        end
    end)
end

v67 = text(ScreenGui, "FPSCounter", "", 0, 0, 90, 18, 12, Enum.Font.GothamBold, Color3.fromRGB(120, 255, 140))

do
    local v75 = Vector2.new(1, 1)
    local v76 = v67

    v76.AnchorPoint = v75
    v76.TextXAlignment = Enum.TextXAlignment.Right
    v76.Visible = false
end

do
    local n3 = 0
    local n4 = 0

    RunService.RenderStepped:Connect(function(p44) -- line: 354
        -- upvalues: Players (copy), ScreenGui (copy), t15 (copy), t16 (copy), v67 (ref), n3 (ref), n4 (ref)
        n3 += p44
        n4 += 1

        if n3 >= 0.5 then
            v67.Text = math.floor(n4 / n3 + 0.5) .. " FPS"
            n3 = 0
            n4 = 0

            for _, player in Players:GetPlayers() do
                t15.Nametags.SyncLocal(player, t16.nametags, ScreenGui:GetAttribute("LobbySpectating") == true)
            end
        end

        local ViewportSize = workspace.CurrentCamera.ViewportSize

        v67.Position = UDim2.fromOffset(ViewportSize.X - 12, ViewportSize.Y - 6)
    end)
end

task.defer(applyGraphics)

local Activated = Enum.RenderPriority.Last.Value

RunService:BindToRenderStep("RaceNametagFollow", Activated, function(p45) -- line: 360
    -- upvalues: t15 (copy)
    t15.Nametags.Follow(p45)
end)

local v80 = frame(ScreenGui, "CustomInputs", 0, 0, 440, 360, Color3.fromRGB(18, 23, 29), 0.02)

Instance.new("UICorner", v80).CornerRadius = UDim.new(0, 12)
v80.Visible = false
text(v80, "Title", "CUSTOM INPUTS", 14, 10, 230, 24, 15, Enum.Font.GothamBold)

do
    local clone = TextButton2:Clone()

    clone.Name = "Close"
    clone.Text = "Done"
    clone.Size = UDim2.fromOffset(65, 28)
    clone.Position = UDim2.fromOffset(360, 8)
    clone.Parent = v80

    local ScrollingFrame = clone:Clone()

    ScrollingFrame.Name = "ResetBindings"
    ScrollingFrame.Text = "Reset"
    ScrollingFrame.Position = UDim2.fromOffset(285, 8)
    ScrollingFrame.Parent = v80
    ScrollingFrame.Activated:Connect(function() -- line: 365
        -- upvalues: v2 (ref), t2 (copy), t3 (copy), t4 (ref), v11 (ref), t15 (copy)
        for v81 in t2 do
            t2[v81] = Enum.KeyCode[v81]

            if t3[v81] then
                t3[v81].Text = v81
            end
        end

        t4 = nil
        v2 = false

        if v11 then
            v11()
        end

        if t15.send then
            t15.send()
        end
    end)
    text(v80, "ActionHeader", "CONTROL", 14, 43, 166, 20, 10)
    text(v80, "KeyboardHeader", "KEYBOARD", 190, 43, 108, 20, 10)
    text(v80, "ControllerHeader", "CONTROLLER", 303, 43, 108, 20, 10)
    v80.ZIndex = 20
    ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "Bindings"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(10, 70)
    ScrollingFrame.Size = UDim2.new(1, -20, 1, -82)
    ScrollingFrame.CanvasSize = UDim2.fromOffset(0, #t1 * 36 + 60)
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.Parent = v80
    text(ScrollingFrame, "MouseControls", "Mouse: right-drag orbit · wheel zoom (third person)\nBindings are saved when you leave the game.", 4, #t1 * 36, 410, 48, 10)

    for v82, v83 in t1 do
        text(ScrollingFrame, "Action" .. v82, v83[1], 4, (v82 - 1) * 36, 166, 30, 10)

        for j = 2, 3 do
            local v84 = v83[j]

            if v84 then
                local clone = TextButton2:Clone()

                clone.Name = v84
                clone.Text = t2[v84].Name
                clone.Size = UDim2.fromOffset(108, 30)
                clone.Position = UDim2.fromOffset(180 + (j - 2) * 113, (v82 - 1) * 36)
                clone.TextSize = 10
                clone.Parent = ScrollingFrame
                t3[v84] = clone
                clone.Activated:Connect(function() -- line: 380
                    -- upvalues: v2 (ref), t2 (copy), t3 (copy), t4 (ref), j (copy), v84 (copy), clone (copy)
                    if t4 then
                        t3[t4.name].Text = t2[t4.name].Name
                    end

                    t4 = {
                        name = v84,
                        column = j
                    }
                    v2 = true
                    clone.Text = "Press input…"
                end)
            end
        end
    end

    for _, descendant in v80:GetDescendants() do
        if descendant:IsA("GuiObject") then
            descendant.ZIndex = 21
        end
    end

    clone2.Activated:Connect(function() -- line: 387
        -- upvalues: v3 (ref), v61 (copy), v80 (copy)
        v80.Visible = true
        v3 = true
        v61.Visible = false
    end)
    clone.Activated:Connect(function() -- line: 388
        -- upvalues: v2 (ref), v3 (ref), t2 (copy), t3 (copy), t4 (ref), v61 (copy), v80 (copy)
        if t4 then
            t3[t4.name].Text = t2[t4.name].Name
        end

        t4 = nil
        v2 = false
        v80.Visible = false
        v3 = false
        v61.Visible = true
    end)
end

local function captureBinding(p46) -- line: 392
    -- upvalues: v2 (ref), n1 (ref), t2 (copy), t3 (copy), t4 (ref), v11 (ref), t15 (copy)
    if not t4 then
        return false
    end

    local KeyCode = p46.KeyCode

    if KeyCode == Enum.KeyCode.Escape then
        t3[t4.name].Text = t2[t4.name].Name
        t4 = nil
        v2 = false
    else
        local v85 = p46.UserInputType.Name:find("Gamepad") ~= nil

        if KeyCode ~= Enum.KeyCode.Unknown and v85 == (t4.column == 3) then
            local name = t4.name

            if name:find("Thumbstick") ~= nil == (KeyCode.Name:find("Thumbstick") ~= nil) then
                local v86 = t2[name]

                for v87, v88 in t2 do
                    if v87 ~= name and v88 == KeyCode then
                        t2[v87] = v86
                        t3[v87].Text = v86.Name
                    end
                end

                t2[name] = KeyCode
                t3[name].Text = KeyCode.Name
                t4 = nil
                v2 = false
                n1 = os.clock() + 0.2

                if v11 then
                    v11()
                end

                if t15.send then
                    t15.send()
                end
            end

            return true
        end
    end

    return true
end

local v89 = frame(ScreenGui, "Controls", 0, 0, 350, 327, Color3.fromRGB(12, 17, 18), 0.05)

v89.Visible = false

do
    local v90

    Activated, v90 = Color3.fromRGB(110, 130, 135)
    v70 = Instance.new("UIStroke", v89)
    v70.Color = Activated or v19
    v70.Thickness = v90 or 1
end

v70.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Instance.new("UICorner", v89).CornerRadius = UDim.new(0, 6)
text(v89, "Title", "JEREZ · DUCATI LENOVO", 18, 14, 310, 25, 16, Enum.Font.GothamBold)
frame(v89, "Line", 18, 45, 314, 2, v21)
text(v89, "Keys", "W           Throttle\nS           Front brake (hold when stopped: walk back)\nShift       Rear brake\nA / D       Steer & lean\nQ / E       Shift down / up (N at rest)\nM           Automatic / manual\n← / →       Select TCS / AW / EBS\n↑ / ↓       Change selected assist\nF / G       Wheelie / stoppie\nT (hold)    Clutch\nSpace       Dismount\nR           Ride height device\nB           Lap leaderboard\nC           Chase / first person\nX (hold)    Rear view / look back", 18, 56, 314, 192, 11, Enum.Font.Code)
text(v89, "Gamepad", "Pad: RT/LT gas/brake · LS steer/lift · RS orbit · RB view · LB clutch\nX/Y down/up · A rear brake · L3 (press) dismount · R3 rear · B ride height\nD-pad ←/→ select TCS/AW/EBS · ↑/↓ change it · X spawn on foot", 18, 250, 316, 36, 8)
text(v89, "Credit", Config.TrackCredit .. "\n" .. Config.BikeCredit, 18, 292, 316, 20, 7)

local v91 = text(ScreenGui, "Notification", "", 0, 0, 460, 36, 20, Enum.Font.GothamBold)

v91.TextXAlignment = Enum.TextXAlignment.Center

local n5 = 0
local v92 = false
local v93 = false
local t21 = {
    speed = 0,
    rpm = 1800,
    gear = 1,
    lap = 1,
    start = 0,
    best = 0,
    previous = 0,
    abs = true
}
local v94 = t21

t21.tcs = Config.TCS
t21.history = {}
t21.aw = Config.AW
t21.ebs = Config.EBS
t15.absButton.Activated:Connect(function() -- line: 424
    -- upvalues: v5 (copy), MotoLegends (copy), v94 (ref)
    if v5() then
        return
    end

    v94.abs = v94.abs == false
    MotoLegends.Settings:FireServer({
        abs = v94.abs
    })
end)

local t22 = {}
local v96 = GamepadControls.New()
local t23 = {
    throttle = 0,
    brake = 0,
    steer = 0
}
local v97 = false
local v98 = UserInputService:GetConnectedGamepads()[1]
local v99 = v98
local v100 = v98 ~= nil
local v101 = true

local function pollPad() -- line: 433
    -- upvalues: UserInputService (copy), v5 (copy), GamepadControls (copy), t2 (copy), v96 (ref), v99 (ref), v101 (ref)
    if not v101 or v5() or not v99 then
        GamepadControls.Reset(v96)

        return
    end

    for _, v102 in UserInputService:GetGamepadState(v99) do
        local UpdateMapped = GamepadControls.UpdateMapped
        local v103 = v96
        local KeyCode = v102.KeyCode
        local v104 = false
        local v105

        for v106, v107 in t2 do
            if v107 == KeyCode then
                v105 = Enum.KeyCode[v106]
                v104 = true
                break
            end
        end

        if not v104 then
            v105 = t2[KeyCode.Name] and Enum.KeyCode.Unknown or KeyCode
        end

        UpdateMapped(v103, v105, v102.KeyCode, v102.UserInputState, v102.Position)
    end
end

UserInputService.GamepadConnected:Connect(function(p47) -- line: 437
    -- upvalues: v99 (ref), v100 (ref)
    v99 = p47
    v100 = true
end)
UserInputService.GamepadDisconnected:Connect(function(p48) -- line: 438
    -- upvalues: UserInputService (copy), GamepadControls (copy), CrashHaptics (copy), v96 (ref), v97 (ref), v99 (ref)
    if v99 ~= p48 then
        return
    end

    CrashHaptics.Stop()
    v99 = UserInputService:GetConnectedGamepads()[1]
    GamepadControls.Reset(v96)
    v97 = false
end)

do
    local function reportDevice() -- line: 439
        -- upvalues: UserInputService (copy), MotoLegends (copy), ScreenGui (copy), v100 (ref)
        local PreferredInput = UserInputService.PreferredInput
        local v108 = if PreferredInput == Enum.PreferredInput.Touch then "Mobile" elseif PreferredInput == Enum.PreferredInput.Gamepad or PreferredInput.Name == "MicroGamepad" then "Controller" else "PC"

        v100 = v108 == "Controller"
        ScreenGui:SetAttribute("InputDevice", v108)
        MotoLegends:WaitForChild("InputDevice"):FireServer(v108)
    end

    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(reportDevice)
    task.defer(reportDevice)
end

local n6 = 0
local n7 = 0
local v109 = false
local v110 = false
local v111 = false
local v112 = false
local v113 = false
local n8 = 0
local v114 = false
local t24 = {}

t24[1] = 0

local v115 = Config.ChaseCameraPitch
local n9 = 1
local n10 = 0
local n11 = 0
local n12 = -1

t15.pad = {
    blend = 0,
    phase = 0
}

local n13 = -1
local n14 = 0
local t25 = {}

t15.headAccCache = setmetatable({}, {
    __mode = "k"
})
t15.HEAD_ATT = {
    HatAttachment = true,
    HairAttachment = true,
    FaceFrontAttachment = true,
    FaceCenterAttachment = true
}
t15.HEAD_TYPE = {
    Hat = true,
    Hair = true,
    Face = true,
    Eyebrow = true,
    Eyelash = true
}

t15.onHead = function(p49) -- line: 467
    -- upvalues: t15 (copy)
    local v116 = t15.headAccCache[p49]

    if v116 ~= nil then
        return v116
    end

    local Handle = p49:FindFirstChild("Handle")

    if not Handle then
        return false
    end

    local v117 = t15.HEAD_TYPE[p49.AccessoryType.Name] == true

    for _, child in Handle:GetChildren() do
        if v117 then
            break
        end

        if child:IsA("Attachment") then
            v117 = t15.HEAD_ATT[child.Name] == true
        elseif child:IsA("JointInstance") or child:IsA("WeldConstraint") then
            v117 = if child.Part0 and child.Part0.Name == "Head" then true elseif child.Part1 then child.Part1.Name == "Head" else false
        elseif child:IsA("Constraint") then
            local Attachment0, Attachment1 = child.Attachment0, child.Attachment1

            v117 = if Attachment0 and Attachment0.Parent and Attachment0.Parent.Name == "Head" then true elseif Attachment1 and Attachment1.Parent then Attachment1.Parent.Name == "Head" else false
        end
    end

    t15.headAccCache[p49] = v117

    return v117
end

local FieldOfView = workspace.CurrentCamera.FieldOfView
local Unit = nil
local Attribute = nil
local Position, Unit2
local v118 = false
local t28 = {}
local v119, result

local function cancelInputs() -- line: 489
    -- upvalues: UserInputService (copy), GamepadControls (copy), CrashHaptics (copy), ScreenGui (copy), t22 (ref), v96 (ref), t23 (ref), v97 (ref), n7 (ref), v109 (ref), v110 (ref), v111 (ref), v113 (ref), v114 (ref), v119 (ref)
    t22 = {}
    GamepadControls.Reset(v96)
    t23 = {
        throttle = 0,
        brake = 0,
        rearBrake = 0,
        steer = 0,
        clutch = t23 and t23.clutch or nil
    }
    n7 = 0
    v109 = false
    v110 = false
    v111 = false
    v113 = false
    v97 = false
    v114 = false

    if ScreenGui:GetAttribute("Freecam") ~= true then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end

    CrashHaptics.Stop()

    if v119 then
        for _, v120 in {
                "throttle",
                "brake",
                "rearBrake",
                "steer",
                "manualWheelie",
                "manualStoppie",
                "smoothThrottle",
                "smoothBrake",
                "smoothRearBrake",
                "smoothSteer"
            } do
            local v121 = v119

            v121[v120] = 0
        end
    end
end

do
    local function refreshInputFocus() -- line: 497
        -- upvalues: v5 (copy), MotoLegends (copy), ScreenGui (copy), result (ref), cancelInputs (copy)
        local v122 = v5()

        ScreenGui:SetAttribute("InputsBlocked", v122)

        if v122 then
            cancelInputs()
            MotoLegends.Input:FireServer({
                throttle = 0,
                brake = 0,
                rearBrake = 0,
                steer = 0,
                manualWheelie = 0,
                manualStoppie = 0
            })
        end

        if result then
            if v122 then
                result:Disable()
            else
                result:Enable()
            end
        end
    end

    ChatInputBarConfiguration:GetPropertyChangedSignal("IsFocused"):Connect(refreshInputFocus)
    UserInputService.TextBoxFocused:Connect(refreshInputFocus)
    UserInputService.TextBoxFocusReleased:Connect(function() -- line: 503
        -- upvalues: refreshInputFocus (copy)
        task.defer(refreshInputFocus)
    end)

    local function attachCharacterControls(p50) -- line: 504
        -- upvalues: result (ref), refreshInputFocus (copy)
        if p50.Name ~= "PlayerModule" or not p50:IsA("ModuleScript") then
            return
        end

        local function v123() -- line: 506
            -- upvalues: p50 (copy)
            return require(p50):GetControls()
        end

        local ok, result2 = pcall(v123)

        if ok then
            result = result2
            refreshInputFocus()
        end
    end

    local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

    PlayerScripts.ChildAdded:Connect(attachCharacterControls)

    local PlayerModule = PlayerScripts:FindFirstChild("PlayerModule")

    if PlayerModule then
        task.defer(attachCharacterControls, PlayerModule)
    end
end

local v124 = false
local n15 = 0
local t30 = {}
local t31 = {}
local v125
local n16 = 0
local t32 = {}

t32[1] = 0

local t33 = {}

t33[1] = 0

local n17 = 0
local t34 = {}
local v126, Humanoid, v127
local n18 = 0
local n19 = 0
local n20 = 0
local v128 = Config.ChaseBaseFOV
local self = setmetatable({}, {
    __mode = "k"
})

local function fpEye(p51, p52) -- line: 529
    -- upvalues: self (copy)
    local v131 = self[p51]

    if not v131 then
        local n21 = (-1e999)
        local Z

        for _, descendant in p51:GetDescendants() do
            if descendant:IsA("BasePart") and descendant.Transparency < 0.95 and not descendant:FindFirstAncestorOfClass("Humanoid") then
                local v132 = p52:PointToObjectSpace(descendant.Position)

                if v132.Z < -1.6 and v132.Z > -3.6 and math.abs(v132.X) < 0.8 then
                    local v133 = descendant.Size / 2
                    local n22 = (-1e999)

                    for _, v134 in { Vector3.new(1, 1, 1), Vector3.new(-1, 1, 1), Vector3.new(1, 1, -1), Vector3.new(-1, 1, -1), Vector3.new(1, -1, 1), Vector3.new(-1, -1, 1), Vector3.new(1, -1, -1), (Vector3.new(-1, -1, -1)) } do
                        n22 = math.max(n22, p52:PointToObjectSpace(descendant.CFrame:PointToWorldSpace(v133 * v134)).Y)
                    end

                    if n21 < n22 then
                        n21 = n22
                        Z = v132.Z
                    end
                end
            end
        end

        local v135, v136

        if Z and n21 > 2.6 and n21 < 4.6 then
            local v139 = Vector3.new(0, n21 + 0.08, Z + 1.35)

            if v139 then
                v135 = v139
                v136 = true
            else
                v136 = false
            end
        else
            v136 = false
        end

        if not v136 then
            v135 = Vector3.new(0, 3.6, -1.05)
        end

        v131 = v135
        self[p51] = v135
    end

    return p52:PointToWorldSpace(v131)
end

local v140 = -math.rad(Config.ChasePitchSlowDeg or 0)
local t36 = {}

t36[1] = v140

local n23 = 0

local function followCrashBike() -- line: 552
    -- upvalues: UserInputService (copy), LocalPlayer (copy), v114 (ref), v118 (ref), t28 (ref)
    if v118 then
        return
    end

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    v118 = true
    v114 = false
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true

    local CurrentCamera = workspace.CurrentCamera

    t28 = {
        minZoom = LocalPlayer.CameraMinZoomDistance,
        playerMode = LocalPlayer.CameraMode,
        cf = CurrentCamera.CFrame,
        position = HumanoidRootPart.Position,
        fov = CurrentCamera.FieldOfView,
        follow = HumanoidRootPart.Position
    }

    local Part = Instance.new("Part")

    Part.Name = "CrashCameraFocus"
    Part.Size = Vector3.new(0.1, 0.1, 0.1)
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CFrame = CFrame.new(HumanoidRootPart.Position + Vector3.new(0, 2.4, 0))
    Part.Parent = CurrentCamera
    t28.focusPart = Part

    local v141 = RaycastParams.new()

    v141.FilterType = Enum.RaycastFilterType.Include
    v141.FilterDescendantsInstances = {
        workspace:FindFirstChild("RaceCollision", true),
        workspace.Terrain
    }
    t28.groundParams = v141
    LocalPlayer.CameraMinZoomDistance = math.max(LocalPlayer.CameraMinZoomDistance, 7)
end

local function pose(p53) -- line: 571
    -- upvalues: UserInputService (copy), LocalPlayer (copy), RiderPose (copy), t15 (copy), v97 (ref), v114 (ref), n10 (ref), n11 (ref), t25 (ref), t30 (ref), t31 (ref), v125 (ref), n16 (ref), t32 (copy), t33 (copy), t34 (ref), v126 (ref), n19 (ref)
    local Character = LocalPlayer.Character

    if Character then
        if p53 then
            t34 = {}
            v126 = nil
            t25 = {}

            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.LocalTransparencyModifier = 0
                end
            end

            v125 = Character:FindFirstChild("Animate")

            if v125 then
                v125.Enabled = false
            end

            local v142 = Character:FindFirstChildWhichIsA("Animator", true)

            if v142 then
                for _, v143 in v142:GetPlayingAnimationTracks() do
                    v143:Stop(0)
                end
            end

            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("Motor6D") or descendant:IsA("AnimationConstraint") then
                    local t37 = t30

                    t37[descendant] = descendant.Name
                    descendant.Transform = CFrame.identity
                end
            end

            RiderPose.Reset(Character)
            n16 = 0
            t32[1] = 0
            t33[1] = 0
            n19 = 0
            n11 = 0
            n10 = 0

            if t15.pad then
                t15.pad.blend = 0
            end
        else
            if not Character:GetAttribute("RaceCrashActive") then
                n11 = 0
                n10 = 0
                v97 = false
                v114 = false
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                UserInputService.MouseIconEnabled = true
            end

            for v144, v145 in t25 do
                if v144.Parent then
                    v144.LocalTransparencyModifier = v145
                end
            end

            t25 = {}

            local RaceCrashActive = Character:GetAttribute("RaceCrashActive")

            if RaceCrashActive and next(t30) then
                t34 = t30
                v126 = v125
            end

            for v146 in t30 do
                if v146.Parent and not RaceCrashActive then
                    v146.Transform = CFrame.identity
                end
            end

            for v147, v148 in t31 do
                if v147.Parent then
                    v147.LocalTransparencyModifier = v148
                end
            end

            if v125 and v125.Parent and not RaceCrashActive then
                v125.Enabled = true
            end

            t30 = {}
            t31 = {}
            v125 = nil
        end
    end
end

do
    t15.contact = {
        yaw = 0,
        lean = 0,
        wobble = 0,
        phase = 0,
        predicted = setmetatable({}, {
            __mode = "k"
        })
    }

    local BikeContact = require(MotoLegends:WaitForChild("BikeContact"))
    local contact = t15.contact

    function contact.step(p54, p55, p56) -- line: 611
        -- upvalues: LocalPlayer (copy), MotoLegends (copy), v92 (ref), BikeContact (copy), contact (copy)
        if contact.owner ~= p54 then
            contact.owner = p54
            contact.yaw = 0
            contact.lean = 0
            contact.wobble = 0
        end

        if contact.yaw ~= 0 or contact.lean ~= 0 or contact.wobble > 0 then
            p54.yaw += contact.yaw * p56
            p54.lean = (p54.lean or 0) + contact.lean * p56

            if contact.wobble > 0 then
                contact.phase += p56 * 17
                p54.yaw = p54.yaw + math.sin(contact.phase) * contact.wobble * 0.9 * p56
                p54.lean = p54.lean + math.cos(contact.phase * 0.9) * contact.wobble * 0.5 * p56
                contact.wobble = math.max(0, contact.wobble - p56 * 1.4)
            end

            local v152 = math.exp(-p56 * 7)

            contact.yaw *= v152
            contact.lean *= v152

            if math.abs(contact.yaw) < 0.01 then
                contact.yaw = 0
            end

            if math.abs(contact.lean) < 0.01 then
                contact.lean = 0
            end
        end

        if BikeContact.Enabled() then
            local v153 = BikeContact.Body(v92)

            if v153 then
                local RaceBikes = workspace:FindFirstChild("RaceBikes")

                if RaceBikes then
                    local ServerTimeNow = workspace:GetServerTimeNow()

                    if not (ServerTimeNow < (v92:GetAttribute("ContactReadyAt") or 1e999)) then
                        local n24 = 0

                        local function v154() -- line: 629
                            -- upvalues: n24 (ref), LocalPlayer (copy)
                            n24 = LocalPlayer:GetNetworkPing() * 0.5
                        end

                        pcall(v154)

                        local t40 = {
                            cf = v153.CFrame,
                            size = v153.Size,
                            vel = p55.AssemblyLinearVelocity,
                            mass = BikeContact.Mass(v92),
                            com = v153.Position
                        }

                        for _, child in RaceBikes:GetChildren() do
                            if child ~= v92 and child:IsA("Model") and child:GetAttribute("Crash") == "" and (child:GetAttribute("ContactReadyAt") or 1e999) <= ServerTimeNow then
                                local v155 = BikeContact.Body(child)
                                local PrimaryPart = child.PrimaryPart

                                if v155 and PrimaryPart and (PrimaryPart.Position - p55.Position).Magnitude < 40 then
                                    local AssemblyLinearVelocity = PrimaryPart.AssemblyLinearVelocity
                                    local v157 = math.clamp((child:GetAttribute("NetLag") or 0.05) + n24 + 0.03, 0, 0.45)
                                    local v158 = v155.CFrame + BikeContact.Flat(AssemblyLinearVelocity) * v157
                                    local v159, v160 = BikeContact.Touch(t40.cf, t40.size, v158, v155.Size)

                                    if v159 then
                                        local t41 = {
                                            cf = v158,
                                            size = v155.Size,
                                            vel = AssemblyLinearVelocity,
                                            mass = BikeContact.Mass(child),
                                            com = v158.Position
                                        }
                                        local elapsed = os.clock()
                                        local v161 = elapsed - (contact.predicted[child] or (-1e999)) > BikeContact.Get("PairCooldown") and BikeContact.Resolve(t40, t41, v159, BikeContact.ContactPoint(t40.cf, t40.size, v158, v155.Size)) or nil

                                        if v161 then
                                            contact.predicted[child] = elapsed
                                            p55.AssemblyLinearVelocity += BikeContact.Flat(v161.a.dv)
                                            contact.yaw += v161.a.yaw
                                            contact.lean += v161.a.lean
                                            MotoLegends.RaceControl:FireServer("BikeHit", child)
                                        else
                                            local v162 = t41.mass / (t40.mass + t41.mass)
                                            local v164 = math.min(v160 * BikeContact.Get("PushStiffness"), BikeContact.Get("MaxPush"))
                                            local v165 = -BikeContact.Flat(p55.AssemblyLinearVelocity - AssemblyLinearVelocity):Dot(v159)

                                            if v165 < v164 then
                                                p55.AssemblyLinearVelocity = p55.AssemblyLinearVelocity + -v159 * (v164 - v165) * v162 * math.min(p56 * 10, 1)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    function contact.hit(p57) -- line: 660
        -- upvalues: CrashHaptics (copy), t16 (copy), v92 (ref), v93 (ref), v99 (ref), BikeContact (copy), contact (copy)
        if typeof(p57) ~= "table" then
            return
        end

        local other = p57.other

        if (typeof(other) ~= "Instance" or not (os.clock() - (contact.predicted[other] or (-1e999)) < 0.6)) and p57.crash ~= true and v93 and v92 then
            local PrimaryPart = v92.PrimaryPart

            if PrimaryPart and not PrimaryPart.Anchored and typeof(p57.dv) == "Vector3" then
                PrimaryPart.AssemblyLinearVelocity += BikeContact.Flat(p57.dv)
            end

            if typeof(p57.yaw) == "number" then
                contact.yaw = contact.yaw + math.clamp(p57.yaw, -2, 2)
            end

            if typeof(p57.lean) == "number" then
                contact.lean = contact.lean + math.clamp(p57.lean, -1, 1)
            end
        end

        if typeof(p57.wobble) == "number" and p57.wobble > 0 and p57.crash ~= true then
            contact.wobble = math.max(contact.wobble, (math.clamp(p57.wobble, 0, 1)))
        end

        if not t16.vibration or p57.crash == true then
            return
        end

        local Play = CrashHaptics.Play
        local v169 = v99
        local v171 = math.clamp(0.25 + (tonumber(p57.risk) or 0) * 0.5, 0.25, 0.8)

        pcall(Play, v169, v171)
    end

    RunService.PreSimulation:Connect(function(p58) -- line: 674
        -- upvalues: v5 (copy), LocalPlayer (copy), MotoLegends (copy), Config (copy), BikeDynamics (copy), BikeVisualSlide (copy), RiderPose (copy), Layout (copy), v60 (ref), t15 (copy), v92 (ref), v93 (ref), v94 (ref), t22 (ref), v96 (ref), t23 (ref), v97 (ref), pollPad (copy), v112 (ref), n10 (ref), n11 (ref), n12 (ref), n13 (ref), n14 (ref), v119 (ref), cancelInputs (copy), v124 (ref), n16 (ref), t32 (copy), t33 (copy), n17 (ref), n19 (ref)
        if v5() then
            cancelInputs()
        end

        pollPad()

        local spawnHold = t15.spawnHold
        local v172

        if spawnHold then
            v172 = spawnHold.bike.PrimaryPart

            if not v93 and spawnHold.bike == v92 and v172 and v172.Parent and not (os.clock() > spawnHold.untilT) then
                if not v172.Anchored then
                    v172.CFrame = spawnHold.cf
                    v172.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v172.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            else
                t15.spawnHold = nil
            end
        end

        if not (v93 and v92 and v92.Parent and v92.PrimaryPart) then
            return
        end

        if LocalPlayer:GetAttribute("RaceGridLocked") then
            v124 = false
        end

        local PrimaryPart, ok, v173, v174

        if v92 and v92.Parent and v92:GetAttribute("Crash") == "" then
            PrimaryPart = v92.PrimaryPart

            if not PrimaryPart or PrimaryPart.Anchored then
                v174 = true
            else
                if not v119 then
                    v172 = {
                        throttle = 0,
                        brake = 0,
                        steer = 0,
                        smoothThrottle = 0,
                        smoothBrake = 0,
                        smoothSteer = 0,
                        lean = 0,
                        followServerGear = true,
                        slip = 0,
                        root = PrimaryPart,
                        force = PrimaryPart:FindFirstChildOfClass("VectorForce"),
                        align = PrimaryPart:FindFirstChildOfClass("AlignOrientation")
                    }
                    v173 = -PrimaryPart.CFrame.LookVector.X
                    ok = -PrimaryPart.CFrame.LookVector.Z
                    v172.yaw = math.atan2(v173, ok)
                    v172.gear = v92:GetAttribute("Gear") or 1
                    v119 = v172
                end

                v174 = false
            end
        else
            v174 = true
        end

        local result, ok2

        if not v174 then
            v172 = v119
            v173 = if t22[Enum.KeyCode.W] then 1 else 0
            ok = v96.throttle
            v172.throttle = math.max(v173, ok, t23.throttle)
            v172 = v119

            local v175 = t22[Enum.KeyCode.T] == true

            if not v175 then
                v175 = t22[Enum.KeyCode.ButtonL1] == true
            end

            if v175 then
                v172.clutch = true
            else
                v172.clutch = t23.clutch == true
            end

            v172 = v119
            v173 = if t22[Enum.KeyCode.S] then 1 else 0
            ok = v96.brake
            v172.brake = math.max(v173, ok, t23.brake)
            v172 = v119
            v173 = if t22[Enum.KeyCode.F] then 1 else 0
            result = -(v96.lift or 0)
            ok = math.max(0, result)
            v172.manualWheelie = math.max(v173, ok, (math.max(0, -(t23.lift or 0))))
            v172 = v119
            v173 = if t22[Enum.KeyCode.G] then 1 else 0
            result = v96.lift or 0
            ok = math.max(0, result)

            local v176 = t23.lift or 0

            v172.manualStoppie = math.max(v173, ok, (math.max(0, v176)))
            v172 = v119

            local v177 = t22[Enum.KeyCode.LeftShift]

            if not v177 then
                v177 = t22[Enum.KeyCode.RightShift]
            end

            v173 = if v177 then 1 else 0
            ok = v96.rearBrake or 0

            local throttle = t23.rearBrake or 0

            v172.rearBrake = math.max(v173, ok, throttle)
            v172 = v119
            v173 = if t22[Enum.KeyCode.D] then 1 else 0
            v172.steer = v173 - (t22[Enum.KeyCode.A] and 1 or 0)

            if math.abs(v96.steer) > 0.08 then
                v172 = v119
                v172.steer = v96.steer
            end

            if t23.steer ~= 0 then
                v172 = v119
                v172.steer = t23.steer
            end

            v172 = v124 or v92:GetAttribute("ExitRequested") == true

            local gearPred = v119

            gearPred.exitHold = v172

            if v172 then
                gearPred = v119
                gearPred.throttle = 0
                gearPred = v119
                gearPred.brake = 0.85
                gearPred = v119
                gearPred.rearBrake = 0
                gearPred = v119
                gearPred.steer = 0
                gearPred = v119
                gearPred.manualWheelie = 0
                gearPred = v119
                gearPred.manualStoppie = 0
            end

            if not (v124 and PrimaryPart.AssemblyLinearVelocity.Magnitude < 3) then
                t15.exitStill = 0
            else
                t15.exitStill = (t15.exitStill or 0) + p58

                if t15.exitStill > 1.5 then
                    v124 = false
                    t15.exitStill = 0
                end
            end

            v173 = v119.brake
            ok = v119.rearBrake

            if math.max(v173, ok) > 0.045 then
                v112 = false
            end

            v119.rhd = v112
            v172 = v92:GetAttribute("Gear") or 1
            gearPred = t15.gearPred
            v173 = v92:GetAttribute("ShiftAck")

            local gearPred2

            if gearPred and (typeof(v173) == "number" and (gearPred.seq or 0) <= v173 or os.clock() >= gearPred.untilT) then
                t15.gearPred = nil
            else
                gearPred2 = gearPred
            end

            if gearPred2 then
                if v119.gear ~= gearPred2.gear then
                    ok = v119
                    ok.gear = gearPred2.gear
                end
            elseif v119.gear ~= v172 then
                ok = v119
                ok.gear = v172
                ok = v119
                ok.shiftAt = os.clock()
            end

            ok = v119
            ok.transmission = v60
            ok = v119
            ok.tcs = v94.tcs or Config.TCS
            ok = v119
            ok.aw = v94.aw or Config.AW
            ok = v119
            ok.ebs = v94.ebs or Config.EBS
            ok = v119
            ok.abs = v94.abs ~= false
            v173 = (PrimaryPart:GetAttribute("LossStage") or "") ~= ""

            if v119.gripLossActive and not v173 then
                ok = v119
                result = -PrimaryPart.CFrame.LookVector.X
                v176 = -PrimaryPart.CFrame.LookVector.Z
                ok.yaw = math.atan2(result, v176)
                ok = v119
                result = PrimaryPart.CFrame.RightVector.Y
                v176 = PrimaryPart.CFrame.UpVector.Y
                ok.lean = math.atan2(result, v176)
                ok = v119
                ok.slip = 0
                ok = v119
                ok.tractionSlip = 0
                ok = v119
                ok.exitSlip = 0
                ok = v119
                ok.rearYaw = 0
                ok = v119
                ok.rearYawVelocity = 0
                ok = v119
                ok.impactReported = false
            end

            ok = v119
            ok.gripLossActive = v173

            if v173 then
                if PrimaryPart:GetAttribute("LossOwnerPhysics") == true then
                    if t15.crashPhysics == nil then
                        throttle = require
                        ok, throttle = pcall(throttle, MotoLegends:WaitForChild("BikeCrashPhysics"))
                        t15.crashPhysics = ok and throttle or false
                    end

                    v172 = t15.crashPhysics

                    if v172 and v172.BeginLocal then
                        ok = PrimaryPart:GetAttribute("LossStarted")

                        if not v119.loss or not v119.loss.owner or v119.loss.root ~= PrimaryPart or v119.loss.key ~= ok then
                            result = v172.BeginLocal
                            v176 = v119
                            throttle, result = pcall(result, v176, PrimaryPart:GetAttribute("LossStage"))

                            if not throttle then
                                v176 = v119
                                v176.loss = nil

                                if not t15.ownLossWarned then
                                    t15.ownLossWarned = true
                                    warn("[OwnerCrash] " .. tostring(result))
                                end
                            end
                        end

                        ok2 = v119.loss ~= nil and v119.loss.owner == true
                    else
                        ok2 = false
                    end
                else
                    ok2 = false
                end
            else
                ok2 = false
                t15.contact.step(v119, PrimaryPart, p58)
            end

            ok = BikeDynamics.Step(v119, p58, if (PrimaryPart:GetAttribute("LossStage") or "") == "" then true else ok2)
            v112 = ok.rhd == true
            ok2 = v94
            ok2.rhd = v112
            ok2 = v94
            ok2.speed = ok.kph
            ok2 = v94
            ok2.lean = v119.lean
            ok2 = v94
            ok2.gear = v119.gear
            ok2 = v94
            ok2.rpm = ok.rpm
            ok2 = v94
            ok2.slip = v119.slip
            ok2 = v94
            ok2.brake = ok.brake
            ok2 = v94
            ok2.rearBrake = ok.rearBrake or 0
            ok2 = v94
            ok2.throttle = ok.throttle
            ok2 = v94
            ok2.surface = ok.surface
            ok2 = v94
            ok2.burnout = ok.burnout or 0
            ok2 = v94
            ok2.roughBlend = ok.roughBlend or 0
            ok2 = v94
            ok2.roughPhase = ok.roughPhase or 0
            t15.ownAudio = {
                rpm = ok.rpm,
                throttle = ok.throttle,
                gear = v119.gear,
                t = os.clock(),
                bike = v92
            }

            if ok.impact and ok.speed >= BikeDynamics.WallCrashSpeed() and (not v119.impactReported or os.clock() - (v119.impactReportedAt or 0) > 0.25) then
                ok2 = v119
                ok2.impactReported = true
                ok2 = v119
                ok2.impactReportedAt = os.clock()
                MotoLegends.RaceControl:FireServer("Impact", ok.impact)
            end

            if not v173 then
                if t15.clientLoss then
                    t15.clientLoss(v119, ok, p58, PrimaryPart)
                end

                if t15.localMarks == nil then
                    result = require
                    ok2, result = pcall(result, MotoLegends:WaitForChild("LocalTyreMarks"))
                    t15.localMarks = ok2 and result or false
                end

                if t15.localMarks then
                    result = t15.localMarks.Step
                    v176 = v119
                    ok2, result = pcall(result, v176, p58)

                    if not ok2 and not t15.localMarksWarned then
                        t15.localMarksWarned = true
                        warn("[LocalTyreMarks] " .. tostring(result))
                    end
                end
            end
        end

        n17 = 0
        PrimaryPart = BikeVisualSlide.Apply
        v172 = v92
        PrimaryPart(v172, v119 and v119.rearYaw or v92:GetAttribute("VisualRearYaw") or 0, nil, v119 and v119.brakeSlideShare)
        n14 += p58

        local rearYaw, number

        if v92 and n14 > 0.12 then
            n14 = 0
            rearYaw = #Layout.Points
            PrimaryPart = 1
            v172 = 1e999

            for i = 1, rearYaw, 4 do
                ok2 = (Layout.Points[i] - v92.PrimaryPart.Position).Magnitude

                if ok2 < v172 then
                    v172 = ok2
                    PrimaryPart = i
                end
            end

            rearYaw = nil
            v173 = 1e999

            for _, v178 in Layout.Corners do
                v172 = (v178.index - PrimaryPart) % #Layout.Points

                if v172 < v173 then
                    v173 = v172
                    rearYaw = v178
                end
            end

            n13 = if not rearYaw or rearYaw.direction ~= "Right" then -1 else 1
            ok = v92

            if rearYaw then
                number = rearYaw.number
            end

            if not rearYaw or not number then
                number = 1
            end

            ok:SetAttribute("UpcomingCorner", number)
        end

        PrimaryPart = false

        if (v94.brake or 0) > 0.28 and (v94.speed or 0) > 35 then
            rearYaw = v94.lean or 0

            if math.abs(rearYaw) < 0.4 then
                PrimaryPart = not v124 and v92.PrimaryPart:GetAttribute("LossStage") == nil
            end
        end

        local v179

        if v92.PrimaryPart:GetAttribute("LossStage") == "" then
            v179 = false

            if (v94.brake or 0) > 0.28 and (v94.speed or 0) > 35 then
                v173 = v94.lean or 0

                if math.abs(v173) < 0.4 then
                    v179 = not v124
                end
            end
        else
            v179 = PrimaryPart
        end

        if n11 < 0.08 then
            n12 = n13
        end

        local v180 = n11

        ok = if v179 then 1 else 0
        n11 = v180 + (ok - n11) * (1 - math.exp(-p58 * 6))
        v180 = n10
        ok = if v97 then 1 else 0
        v173 = ok - n10
        result = -p58 * 8
        n10 = v180 + v173 * (1 - math.exp(result))
        v179 = 1 - math.exp(-p58 * 8)
        n16 += ((v94.lean or 0) - n16) * v179
        v180 = math.clamp(((v94.speed or 0) - 45) / 145, 0, 1)
        rearYaw = v180 * v180 * (3 - v180 * 2)
        v173 = math.clamp((60 - (v94.speed or 0)) / 30, 0, 1)

        if (v94.throttle or 0) > 0.1 then
            result = v173 * 0.75
            ok2 = result * math.min(1, (v94.throttle or 0) * 1.4)
            rearYaw = math.max(rearYaw, ok2)
        end

        if LocalPlayer:GetAttribute("RaceGridLocked") then
            rearYaw = 0.55
        end

        rearYaw *= 1 - t33[1] * 0.65

        local v183 = math.min(p58, 0.04)

        n19 += ((rearYaw - t32[1]) * 16 - n19 * 8) * v183
        n19 = math.clamp(n19, -0.9, 0.9)
        t32[1] = math.clamp(t32[1] + n19 * v183, 0, 1)

        if LocalPlayer:GetAttribute("RaceGridLocked") then
            t33[1] = 0
        end

        ok = t33[1]

        local impact = v94.brake or 0
        local v185 = (v94.throttle or 0) < 0.1 and v173 * 0.7 or 0

        t33[1] = ok + (math.max(impact, v185) - t33[1]) * v179
        v173 = -n16
        rearYaw = LocalPlayer.Character
        v180 = not LocalPlayer:GetAttribute("RaceGridLocked")

        local v186 = v180 and (if v119 and v119.paddling == true then true else not v119 and v92:GetAttribute("Paddle") == true)

        ok = t15.pad
        ok2 = ok.blend
        impact = if v186 then 1 else 0
        number = impact - t15.pad.blend
        ok.blend = ok2 + number * (1 - math.exp(-p58 * 7))

        if v186 then
            ok = t15.pad
            ok2 = ok.phase
            number = p58 * 7
            v185 = (v94.speed or 0) / 3
            ok.phase = ok2 + number * math.clamp(v185, 0.4, 1.2)
        end

        if not (v92 and v92.PrimaryPart and rearYaw) then
            return
        end

        ok2 = n10

        local v187 = math.max(ok2, t15.pad.blend)

        RiderPose.Apply(rearYaw, v92.PrimaryPart, {
            vibrate = true,
            lean = n16,
            tuck = t32[1] * (1 - t15.pad.blend),
            brake = t33[1] * (1 - t15.pad.blend),
            brace = n17,
            look = v187,
            dangle = n11,
            dangleSide = n12,
            paddle = t15.pad.blend,
            paddlePhase = t15.pad.phase,
            throttle = v94.throttle or 0,
            speed = v94.speed or 0,
            gear = v94.gear
        })

        local v188 = v92
        local v189 = n17

        v188:SetAttribute("HighsideBrace", v189)
        v188 = v92
        v188:SetAttribute("RiderTuck", t32[1])
        v92:SetAttribute("RiderHangOff", v173)
        v188 = v92
        v189 = n11
        v188:SetAttribute("LegDangle", v189)
        v188 = v92
        v189 = if n12 == 1 then "Right" else "Left"
        v188:SetAttribute("DangleLeg", v189)
        v92:SetAttribute("RiderLookBack", v187)
    end)

    t15.clientLoss = function(p59, p60, p61, p62) -- line: 830
        -- upvalues: LocalPlayer (copy), MotoLegends (copy), Config (copy), BikeDynamics (copy), t15 (copy)
        local clientLossState = t15.clientLossState

        if not clientLossState or clientLossState.root ~= p62 then
            clientLossState = {
                root = p62
            }
            t15.clientLossState = clientLossState
        end

        local function reset() -- line: 832
            -- upvalues: p59 (copy)
            p59.frontLoss = 0
            p59.stoppieRisk = 0
            p59.loopRisk = 0
            p59.liftCornerRisk = 0
            p59.offtrackLeanRisk = 0
            p59.clAirTime = 0
            p59.maxSlideTime = 0
            p59.powerSlide = 0
            p59.looseBrakeRisk = 0
            p59.wetBrakeRisk = 0
            p59.rhdScrapeRisk = 0
            p59.combinedBrakeRisk = 0
            p59.kerbLeanRisk = 0
            p59.looseLeanRisk = 0
            p59.slideLossRisk = 0
            p59.wetSlickRisk = 0
            p59.kerbEdgeRisk = 0
            p59.kerbEdgeWash = 0
            p59.kerbEdgeOn = false
        end

        if not p62.Anchored and not p59.exitHold and not LocalPlayer:GetAttribute("RaceGridLocked") and not (os.clock() < (p59.legendRecoverUntil or 0)) then
            if not (clientLossState.sentAt and os.clock() - clientLossState.sentAt < 0.5) then
                local function check() -- line: 838
                    -- upvalues: p59 (copy), p60 (copy), p61 (copy), p62 (copy), Config (copy), BikeDynamics (copy)
                    if BikeDynamics.LooseBrakeLoss(p59, p60, p61) then
                        return "LOWSIDE", "LooseBrake"
                    end

                    if BikeDynamics.WetBrakeLoss(p59, p60, p61) then
                        return "LOWSIDE", "WetBrake"
                    end

                    if BikeDynamics.RHDScrapeLoss(p59, p60, p61) then
                        return "LOWSIDE", "RHDScrape"
                    end

                    if BikeDynamics.CombinedBrakeLoss(p59, p60, p61) then
                        return "LOWSIDE", "CombinedBrake"
                    end

                    local v190, v191, v192, v193 = BikeDynamics.Contact(p59)

                    if BikeDynamics.KerbCornerLoss(p59, p60, v190, v191, v192, v193, p61) then
                        return "LOWSIDE", "KerbCorner"
                    end

                    if BikeDynamics.LooseLeanLoss(p59, p60, v190, v192, p61, v191, v193) then
                        return "LOWSIDE", "LooseLean"
                    end

                    if BikeDynamics.WetSlickLoss and BikeDynamics.WetSlickLoss(p59, p60, p61) then
                        return "LOWSIDE", "WetSlick"
                    end

                    local v194 = BikeDynamics.LiftCornerLoss(p59, p60, v190, v191)

                    p59.liftCornerRisk = v194 and (p59.liftCornerRisk or 0) + p61 or 0

                    if v194 and p59.liftCornerRisk > BikeDynamics.LiftCornerCrashSeconds(p59, v194) then
                        return v194, "LiftCorner"
                    end

                    local surface = p60.surface

                    p59.offtrackLeanRisk = 0

                    local function onWater(p63) -- line: 853
                        if not p63 then
                            return p63
                        end

                        if p63.Instance == workspace.Terrain then
                            return p63.Material == Enum.Material.Water
                        end

                        return false
                    end

                    if v192 then
                    end

                    local instance = v192 and v192.Instance == workspace.Terrain and v192.Material == Enum.Material.Water
                    local speed, velocity, v196, v197, v198, FrontBrakeRate, ebs, v199, v200, v201, Y, v202, v203, v204, v205, v206, frontLoss, CrashFrontDuration, v207, v208, v209

                    if not instance and not (v193 and v193.Instance == workspace.Terrain and v193.Material == Enum.Material.Water) then
                        speed = p60.speed
                        velocity = p60.velocity
                        v196 = if p60.onGround then 0 else (p59.clAirTime or 0) + p61
                        p59.clAirTime = v196

                        if p59.clAirTime > 1.6 and velocity and velocity.Y < -18 and speed > 55 then
                            return "LOWSIDE", "Air"
                        end

                        v197 = BikeDynamics.FrontBrakeOver(p59.lean, p60.brake, p59.abs ~= false, p59.wet, p59.ebs, p59.tyreFBrake or p59.tyreF)

                        local v210 = false

                        if v197 > 1 and speed > 45 then
                            v198 = p59.frontLoss or 0
                            FrontBrakeRate = BikeDynamics.FrontBrakeRate
                            ebs = p59.ebs
                            v199 = v198 + p61 * FrontBrakeRate(v197, ebs, p59.abs ~= false)

                            if v199 then
                                v201 = v199
                                v210 = true
                            end
                        end

                        if not v210 then
                            v200 = (p59.frontLoss or 0) - p61 * 3
                            v201 = math.max(0, v200)
                        end

                        p59.frontLoss = v201

                        if p60.onGround then
                            Y = p62.CFrame.LookVector.Y
                            v202 = math.clamp(Y, -1, 1)
                            v203 = math.asin(v202)

                            if surface == "Asphalt" and Config.WheelieCrashPitch < v203 and (p59.aw or Config.AW) <= 2 then
                                v204 = p59.loopRisk or 0
                                p59.loopRisk = v204 + p61
                            else
                                p59.loopRisk = 0
                            end

                            if surface ~= "Asphalt" or not (v203 < -Config.StoppieCrashPitch) then
                                v206 = (p59.stoppieRisk or 0) - p61 * 3
                                p59.stoppieRisk = math.max(0, v206)
                            else
                                v205 = p59.stoppieRisk or 0
                                p59.stoppieRisk = v205 + p61
                            end

                            if surface == "Asphalt" and v203 < -Config.StoppieCrashPitch and p59.stoppieRisk >= (Config.StoppieCrashDuration or 0) then
                                return "STOPPIE", "Stoppie"
                            end

                            if p59.loopRisk > 0.22 then
                                return "LOOPOVER", "Loop"
                            end

                            frontLoss = p59.frontLoss
                            CrashFrontDuration = Config.CrashFrontDuration
                            v207 = if p59.wet then Config.WetCrashTimeScale or 0.6 else 1

                            if CrashFrontDuration * v207 < frontLoss then
                                return "LOWSIDE", "FrontTuck"
                            end

                            v208, v209 = BikeDynamics.RearLoss(p59, p60, p61, workspace:GetServerTimeNow())

                            if v208 then
                                return v209, "RearSlide"
                            end
                        end

                        return
                    end

                    if (p60.kph or 0) > 2 then
                        return "LOWSIDE", "Water"
                    end

                    speed = p60.speed
                    velocity = p60.velocity
                    v196 = if p60.onGround then 0 else (p59.clAirTime or 0) + p61
                    p59.clAirTime = v196

                    if p59.clAirTime > 1.6 and velocity and velocity.Y < -18 and speed > 55 then
                        return "LOWSIDE", "Air"
                    end

                    v197 = BikeDynamics.FrontBrakeOver(p59.lean, p60.brake, p59.abs ~= false, p59.wet, p59.ebs, p59.tyreFBrake or p59.tyreF)

                    if v197 > 1 and speed > 45 then
                        v198 = p59.frontLoss or 0
                        FrontBrakeRate = BikeDynamics.FrontBrakeRate
                        ebs = p59.ebs
                        v199 = v198 + p61 * FrontBrakeRate(v197, ebs, p59.abs ~= false)

                        if v199 then
                            v201 = v199
                        else
                            v200 = (p59.frontLoss or 0) - p61 * 3
                            v201 = math.max(0, v200)
                        end
                    else
                        v200 = (p59.frontLoss or 0) - p61 * 3
                        v201 = math.max(0, v200)
                    end

                    p59.frontLoss = v201

                    if p60.onGround then
                        Y = p62.CFrame.LookVector.Y
                        v202 = math.clamp(Y, -1, 1)
                        v203 = math.asin(v202)

                        if surface == "Asphalt" and Config.WheelieCrashPitch < v203 and (p59.aw or Config.AW) <= 2 then
                            v204 = p59.loopRisk or 0
                            p59.loopRisk = v204 + p61
                        else
                            p59.loopRisk = 0
                        end

                        if surface == "Asphalt" and v203 < -Config.StoppieCrashPitch then
                            v205 = p59.stoppieRisk or 0
                            p59.stoppieRisk = v205 + p61
                        else
                            v206 = (p59.stoppieRisk or 0) - p61 * 3
                            p59.stoppieRisk = math.max(0, v206)
                        end

                        if surface == "Asphalt" and v203 < -Config.StoppieCrashPitch and p59.stoppieRisk >= (Config.StoppieCrashDuration or 0) then
                            return "STOPPIE", "Stoppie"
                        end

                        if p59.loopRisk > 0.22 then
                            return "LOOPOVER", "Loop"
                        end

                        frontLoss = p59.frontLoss
                        CrashFrontDuration = Config.CrashFrontDuration
                        v207 = if p59.wet then Config.WetCrashTimeScale or 0.6 else 1

                        if CrashFrontDuration * v207 < frontLoss then
                            return "LOWSIDE", "FrontTuck"
                        end

                        v208, v209 = BikeDynamics.RearLoss(p59, p60, p61, workspace:GetServerTimeNow())

                        if v208 then
                            return v209, "RearSlide"
                        end
                    end
                end

                local v211, v212, v213 = pcall(check)

                if v211 and v212 then
                    clientLossState.sentAt = os.clock()
                    MotoLegends.RaceControl:FireServer("ClientLoss", {
                        why = v213,
                        kind = v212,
                        overSlide = p59.lossOverSlide == true,
                        gripCatch = p59.lossGripCatch == true,
                        rearYaw = p59.rearYaw
                    })
                    p59.frontLoss = 0
                    p59.stoppieRisk = 0
                    p59.loopRisk = 0
                    p59.liftCornerRisk = 0
                    p59.offtrackLeanRisk = 0
                    p59.clAirTime = 0
                    p59.maxSlideTime = 0
                    p59.powerSlide = 0
                    p59.looseBrakeRisk = 0
                    p59.wetBrakeRisk = 0
                    p59.rhdScrapeRisk = 0
                    p59.combinedBrakeRisk = 0
                    p59.kerbLeanRisk = 0
                    p59.looseLeanRisk = 0
                    p59.slideLossRisk = 0
                    p59.wetSlickRisk = 0
                    p59.kerbEdgeRisk = 0
                    p59.kerbEdgeWash = 0
                    p59.kerbEdgeOn = false
                end
            end
        else
            p59.frontLoss = 0
            p59.stoppieRisk = 0
            p59.loopRisk = 0
            p59.liftCornerRisk = 0
            p59.offtrackLeanRisk = 0
            p59.clAirTime = 0
            p59.maxSlideTime = 0
            p59.powerSlide = 0
            p59.looseBrakeRisk = 0
            p59.wetBrakeRisk = 0
            p59.rhdScrapeRisk = 0
            p59.combinedBrakeRisk = 0
            p59.kerbLeanRisk = 0
            p59.looseLeanRisk = 0
            p59.slideLossRisk = 0
            p59.wetSlickRisk = 0
            p59.kerbEdgeRisk = 0
            p59.kerbEdgeWash = 0
            p59.kerbEdgeOn = false
        end
    end

    local PreSimulation = {
        NEAR = 180,
        MID = 500,
        FAR = 800,
        VFAR = 1200,
        CLOSE = 45,
        CONE = 0.25,
        PIP = 350,
        frame = 0
    }

    PreSimulation.state = setmetatable({}, {
        __mode = "k"
    })
    t15.lod = PreSimulation
end

do
    function t15.lod.visible(_, p65) -- line: 882
        -- upvalues: LocalPlayer (copy), ScreenGui (copy), t15 (copy)
        local lod = t15.lod

        if ScreenGui:GetAttribute("LobbySpectating") then
            return true, 0
        end

        local PoseLODFocus = LocalPlayer:GetAttribute("PoseLODFocus")

        if typeof(PoseLODFocus) == "Vector3" and (p65.Position - PoseLODFocus).Magnitude < lod.PIP then
            return true, 0
        end

        local CurrentCamera = workspace.CurrentCamera

        if not CurrentCamera then
            return true, 0
        end

        local v214 = p65.Position - CurrentCamera.CFrame.Position
        local Magnitude = v214.Magnitude

        if Magnitude < lod.CLOSE then
            return true, Magnitude
        end

        return CurrentCamera.CFrame.LookVector:Dot(v214 / Magnitude) >= lod.CONE, Magnitude
    end
end

do
    function t15.lod.due(p66, p67, p68) -- line: 894
        -- upvalues: LocalPlayer (copy), ScreenGui (copy), t15 (copy)
        local lod = t15.lod
        local v215 = lod.state[p66]

        if not v215 then
            v215 = {
                acc = 0,
                phase = math.random(0, 7)
            }
            lod.state[p66] = v215
        end

        v215.acc += p68

        local v216, v217

        if ScreenGui:GetAttribute("LobbySpectating") then
            local SpectateTargetId = ScreenGui:GetAttribute("SpectateTargetId")
            local PoseLODFocus = LocalPlayer:GetAttribute("PoseLODFocus")
            local CurrentCamera = workspace.CurrentCamera

            v216 = true
            v217 = if (SpectateTargetId == nil or p66:GetAttribute("OwnerUserId") ~= SpectateTargetId) and CurrentCamera and (typeof(PoseLODFocus) ~= "Vector3" or not ((p67.Position - PoseLODFocus).Magnitude < lod.PIP)) then (p67.Position - CurrentCamera.CFrame.Position).Magnitude else 0
        else
            v216, v217 = lod.visible(p66, p67)
        end

        if not v216 then
            return nil
        end

        local v218 = if (v217 or 0) < lod.NEAR then 1 elseif v217 < lod.MID then 2 else 4

        if v218 > 1 and (lod.frame + v215.phase) % v218 ~= 0 then
            return nil, true
        end

        local acc = v215.acc

        v215.acc = 0

        return (math.min(acc, 0.25))
    end
end

do
    local t54 = {}

    RunService.PostSimulation:Connect(function() -- line: 923
        -- upvalues: BikeDynamics (copy), v92 (ref), v93 (ref), v119 (ref)
        if v93 and v119 and v92 and v92.Parent and v92:GetAttribute("Crash") == "" and (v92.PrimaryPart:GetAttribute("LossStage") or "") == "" then
            BikeDynamics.ResolveContact(v119)
        end
    end)
    RunService.PreSimulation:Connect(function(p69) -- line: 926
        -- upvalues: Players (copy), UserInputService (copy), LocalPlayer (copy), BikeAudio (copy), BikeVisualSlide (copy), RiderPose (copy), Layout (copy), t15 (copy), v92 (ref), v93 (ref), v94 (ref), t54 (copy)
        t15.lod.frame += 1

        if t15.lod.frame % 30 == 1 then
            local v219 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

            t15.lod.NEAR = (v219 or LocalPlayer:GetAttribute("GfxQuality") == "Low") and 70 or 180
        end

        local RaceBikes = workspace:FindFirstChild("RaceBikes")
        local t55 = {}
        local CrashedBikes = workspace:FindFirstChild("CrashedBikes")

        if BikeAudio.UpdateListener then
            BikeAudio.UpdateListener(p69)
        end

        if CrashedBikes then
            for _, child in CrashedBikes:GetChildren() do
                if child:IsA("Model") then
                    BikeAudio.UpdateBike(child, p69)
                end
            end
        end

        if RaceBikes then
            for _, child in RaceBikes:GetChildren() do
                local v220 = child == v92 and v93
                local v221 = v220 and t15.ownAudio

                if v221 and (v221.bike ~= v92 or os.clock() - v221.t > 0.3) then
                    v221 = nil
                end

                local UpdateBike = BikeAudio.UpdateBike
                local rpm, throttle

                if v220 then
                    if v221 then
                        rpm = v221.rpm

                        if not rpm then
                            rpm = v94.rpm or nil
                        end
                    else
                        rpm = v94.rpm or nil
                    end

                    if v221 then
                        throttle = v221.throttle

                        if not throttle then
                            throttle = v94.throttle or nil
                        end
                    else
                        throttle = v94.throttle or nil
                    end
                end

                UpdateBike(child, p69, rpm, throttle, v221 and v221.gear or nil)

                if child:GetAttribute("VisualSlideBaked") then
                    BikeVisualSlide.Apply(child, 0)
                end

                if child ~= v92 and child.PrimaryPart and child:GetAttribute("Crash") == "" then
                    local RiderSeat = child:FindFirstChild("RiderSeat")
                    local v226 = RiderSeat and RiderSeat.Occupant

                    if v226 then
                        local Parent = v226.Parent

                        t55[Parent] = true

                        local v227, v228 = t15.lod.due(child, child.PrimaryPart, p69)

                        if v228 and not RiderPose.Hold(Parent) then
                            v227 = p69
                        end

                        if v227 then
                            local v229 = t54[Parent] or {
                                lean = 0,
                                tuck = 0,
                                brake = 0
                            }

                            t54[Parent] = v229

                            local v231 = 1 - math.exp(-v227 * 7)
                            local v232 = child:GetAttribute("SpeedKph") or 0

                            v229.lean += ((child:GetAttribute("Lean") or 0) - v229.lean) * v231

                            local v233 = child:GetAttribute("Throttle") or 0
                            local v235 = math.clamp((60 - v232) / 30, 0, 1)
                            local v237 = math.clamp((v232 - 45) / 145, 0, 1)

                            if v233 > 0.1 then
                                v237 = math.max(v237, v235 * 0.75 * math.min(1, v233 * 1.4))
                            end

                            local v243 = math.max(child:GetAttribute("Brake") or 0, v233 < 0.1 and v235 * 0.7 or 0)

                            if v226.Parent and Players:GetPlayerFromCharacter(v226.Parent) and Players:GetPlayerFromCharacter(v226.Parent):GetAttribute("RaceGridLocked") then
                                v237 = 0.55
                                v243 = 0
                            end

                            v229.tuck += (v237 * (1 - v243 * 0.6) - v229.tuck) * v231
                            v229.brake += (v243 - v229.brake) * v231

                            local PrimaryPart = child.PrimaryPart

                            BikeVisualSlide.Apply(child, child:GetAttribute("VisualRearYaw") or 0)

                            local v244 = (child:GetAttribute("Brake") or 0) > 0.28 and v232 > 35 and math.abs(child:GetAttribute("Lean") or 0) < 0.4

                            v229.sideClock = (v229.sideClock or 0) - v227

                            if (v229.dangle or 0) < 0.08 and v229.sideClock <= 0 then
                                v229.sideClock = 0.15

                                local PrimaryPartPosition = PrimaryPart.Position
                                local n25 = 1
                                local n26 = 1e999

                                for i = 1, #Layout.Points, 4 do
                                    local Magnitude = (Layout.Points[i] - PrimaryPartPosition).Magnitude

                                    if Magnitude < n26 then
                                        n26 = Magnitude
                                        n25 = i
                                    end
                                end

                                local n27 = 1e999
                                local v247

                                for _, v248 in Layout.Corners do
                                    local v249 = (v248.index - n25) % #Layout.Points

                                    if v249 < n27 then
                                        n27 = v249
                                        v247 = v248
                                    end
                                end

                                v229.dangleSide = v247 and v247.direction == "Right" and 1 or -1
                            end

                            v229.dangle = (v229.dangle or 0) + ((if v244 then 1 else 0) - (v229.dangle or 0)) * (1 - math.exp(-v227 * 6))
                            v229.speed = v232
                            v229.throttle = v233

                            local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")
                            local SpectatingUserId = JerezRaceHUD and JerezRaceHUD:GetAttribute("SpectatingUserId")
                            local PlayerFromCharacter = Players:GetPlayerFromCharacter(Parent)

                            if SpectatingUserId == nil or PlayerFromCharacter == nil then
                                v229.vibrate = false
                            else
                                v229.vibrate = PlayerFromCharacter.UserId == SpectatingUserId
                            end

                            v229.brace = 0

                            local v253 = child:GetAttribute("Paddle") == true

                            v229.paddle = (v229.paddle or 0) + ((v253 and 1 or 0) - (v229.paddle or 0)) * v231

                            if v253 then
                                v229.paddlePhase = (v229.paddlePhase or 0) + v227 * 7
                            end

                            v229.lookBack = (v229.lookBack or 0) + ((child:GetAttribute("RiderLookBack") or 0) - (v229.lookBack or 0)) * (1 - math.exp(-v227 * 8))
                            v229.look = math.max(v229.lookBack, v229.paddle)
                            RiderPose.Apply(Parent, PrimaryPart, v229)
                        end
                    end
                end
            end
        end

        for v257 in t54 do
            if not t55[v257] then
                if v257.Parent and not v257:GetAttribute("RaceCrashActive") then
                    RiderPose.Reset(v257)
                end

                t54[v257] = nil
            end
        end
    end)
end

do
    local function notify(p70, p71) -- line: 999
        -- upvalues: v19 (copy), v91 (copy), n5 (ref)
        v91.Text = p70
        v91.TextColor3 = p71 or v19
        n5 = os.clock() + 3.5
    end
end

local function requestSpawn() -- line: 1002
    -- upvalues: v5 (copy), LocalPlayer (copy), MotoLegends (copy), ScreenGui (copy), v93 (ref)
    if v5() or ScreenGui:GetAttribute("Freecam") == true then
        return
    end

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid and (Humanoid.SeatPart ~= nil or Humanoid.PlatformStand) then
        return
    end

    if (not Character or Character:GetAttribute("RaceCrashActive") ~= true) and not v93 then
        MotoLegends.SpawnBike:FireServer()
    end
end

TextButton.Activated:Connect(requestSpawn)

do
    local v258

    local function sendFreecam() -- line: 1016
        -- upvalues: MotoLegends (copy), ScreenGui (copy), v258 (ref)
        local v259 = ScreenGui:GetAttribute("Freecam") == true

        if v259 ~= v258 then
            v258 = v259
            MotoLegends.Settings:FireServer({
                freecam = v259
            })
        end
    end

    ScreenGui:GetAttributeChangedSignal("Freecam"):Connect(sendFreecam)
    sendFreecam()
end

do
    local function changeTransmission() -- line: 1022
        -- upvalues: v5 (copy), MotoLegends (copy), v60 (ref)
        if v5() then
            return
        end

        v60 = v60 == "Automatic" and "Manual" or "Automatic"
        MotoLegends.Settings:FireServer({
            transmission = v60
        })
    end

    clone.Activated:Connect(function() -- line: 1027
        -- upvalues: v5 (copy), v61 (copy), t15 (copy)
        if not v5() then
            if t15.gfxPanel.Visible then
                t15.gfxPanel.Visible = false
            else
                v61.Visible = not v61.Visible
            end
        end
    end)
    TextButton2.Activated:Connect(changeTransmission)
end

function t15.streamBikeSurface(p72) -- line: 1030
    -- upvalues: LocalPlayer (copy), Config (copy)
    local v260 = p72 and (p72.PrimaryPart or p72:WaitForChild("Chassis", 5))

    if v260 then
        local v261 = os.clock() + 6
        local v262 = not workspace.StreamingEnabled

        while p72.Parent and v260.Parent do
            local v263 = workspace:FindFirstChild("RaceCollision", true)

            if v263 then
                local v264 = RaycastParams.new()

                v264.FilterType = Enum.RaycastFilterType.Include
                v264.FilterDescendantsInstances = {
                    v263,
                    workspace.Terrain
                }

                local v265 = true

                for _, v266 in {
                        Config.FrontAxle,
                        Config.RearAxle
                    } do
                    local v267 = v260.CFrame:PointToWorldSpace(v266)
                    local v268 = workspace:Raycast(v267 + Vector3.new(0, 5, 0), Vector3.new(-0, -30, -0, -0), v264)

                    if not v268 or v268.Normal.Y < 0.55 or v268.Instance:GetAttribute("Surface") == "Barrier" then
                        v265 = false
                        break
                    end
                end

                if v265 then
                    return true
                end
            end

            if v262 then
                task.wait(0.05)
            else
                local function v269() -- line: 1050
                    -- upvalues: v260 (copy), LocalPlayer (copy)
                    LocalPlayer:RequestStreamAroundAsync(v260.Position, 5)
                end

                v262 = true
                pcall(v269)
            end

            if v261 < os.clock() then
                return false
            end
        end
    end

    return false
end

do
    function t15.resolveStreamedBike(p73) -- line: 1056
        local v270 = os.clock() + 15

        while true do
            local RaceBikes = workspace:FindFirstChild("RaceBikes")

            if RaceBikes then
                for _, child in RaceBikes:GetChildren() do
                    if child:GetAttribute("SpawnToken") == p73 then
                        return child
                    end
                end
            end

            task.wait(0.03)

            if v270 < os.clock() then
                return nil
            end
        end
    end
end

MotoLegends.RaceEvent.OnClientEvent:Connect(function(p74, p75, p76) -- line: 1065
    -- upvalues: RunService (copy), StarterGui (copy), LocalPlayer (copy), MotoLegends (copy), Config (copy), CrashHaptics (copy), RaceSocialHUD (copy), ScreenGui (copy), v18 (copy), v19 (copy), v60 (ref), t12 (copy), t15 (copy), t16 (copy), v91 (copy), n5 (ref), v92 (ref), v93 (ref), v94 (ref), v99 (ref), v112 (ref), Unit (ref), Attribute (ref), Position (ref), Unit2 (ref), v119 (ref), cancelInputs (copy), v124 (ref), followCrashBike (copy), pose (copy)
    local v271 = p75
    local v272

    if p74 ~= "Bike" or typeof(p75) == "Instance" then
        v272 = p75
    else
        if typeof(p76) ~= "number" then
            return
        end

        v272 = t15.resolveStreamedBike(p76)
        v271 = v272

        if not v272 then
            return
        end
    end

    if p74 == "GridTeleport" then
        if typeof(v272) ~= "table" or typeof(v272.cframe) ~= "CFrame" or not LocalPlayer:GetAttribute("RaceGridLocked") then
            return
        end

        local Character = LocalPlayer.Character

        if not Character or Character ~= v272.character then
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local bike = v272.bike
        local v274 = bike and bike:FindFirstChildWhichIsA("Seat", true)

        if not (Humanoid and HumanoidRootPart and v274) then
            return
        end

        if v92 ~= bike then
            if v93 then
                pose(false)
            end

            v93 = false
            v119 = nil
            v124 = false
            cancelInputs()
            v92 = bike
            Unit = nil
            Attribute = nil
            Position = nil
            Unit2 = nil
        end

        Humanoid.PlatformStand = false
        Humanoid.Jump = false
        Character.PrimaryPart = HumanoidRootPart

        if Humanoid.SeatPart ~= v274 then
            local SeatPart = Humanoid.SeatPart
            local SeatWeld = SeatPart and SeatPart:FindFirstChild("SeatWeld")

            if SeatWeld then
                SeatWeld:Destroy()
            end

            Humanoid.Sit = false
            Character:PivotTo(v272.cframe)
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end

        task.spawn(function() -- line: 1089
            -- upvalues: v271 (ref), Character (copy), bike (copy), RunService (copy), LocalPlayer (copy), MotoLegends (copy), t15 (copy)
            RunService.Heartbeat:Wait()
            RunService.Heartbeat:Wait()

            if LocalPlayer.Character == Character and LocalPlayer:GetAttribute("RaceGridLocked") and t15.streamBikeSurface(bike) then
                MotoLegends.ChampionshipEvent:FireServer("GridReady", v271.token)
            end
        end)
    elseif p74 == "PaddockTeleport" then
        local Character, Humanoid, v275

        if typeof(v272) == "table" then
            if typeof(v272.cframe) == "CFrame" then
                Character = LocalPlayer.Character
                Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                v275 = false
            else
                v275 = true
            end
        else
            v275 = true
        end

        if v275 then
            return
        end

        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not Humanoid or not HumanoidRootPart or LocalPlayer:GetAttribute("RaceGridLocked") then
            return
        end

        if v93 then
            pose(false)
        end

        v93 = false
        v92 = nil
        v119 = nil
        v124 = false
        cancelInputs()
        Humanoid.Sit = false
        Humanoid.PlatformStand = false
        Humanoid.Jump = false

        local SeatPart = Humanoid.SeatPart
        local SeatWeld = SeatPart and SeatPart:FindFirstChild("SeatWeld")

        if SeatWeld then
            SeatWeld:Destroy()
        end

        Character.PrimaryPart = HumanoidRootPart
        Character:PivotTo(v272.cframe)
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

        local CurrentCamera = workspace.CurrentCamera

        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.CameraSubject = Humanoid

        local v276 = t15.teleportCamToken ~= v272.token

        t15.teleportCamToken = v272.token

        local function aimCamera() -- line: 1108
            -- upvalues: v271 (ref)
            local LookVector = v271.cframe.LookVector
            local v277 = Vector3.new(LookVector.X, 0, LookVector.Z)

            if v277.Magnitude < 0.1 then
                return
            end

            local Unit = v277.Unit
            local cframePosition = v271.cframe.Position

            workspace.CurrentCamera.CFrame = CFrame.lookAt(cframePosition - Unit * 12 + Vector3.new(0, 5, 0), cframePosition + Unit * 10 + Vector3.new(0, 1.5, 0))
        end

        if v276 then
            local LookVector = v271.cframe.LookVector
            local v278 = Vector3.new(LookVector.X, 0, LookVector.Z)

            if not (v278.Magnitude < 0.1) then
                local Unit = v278.Unit
                local cframePosition = v271.cframe.Position

                workspace.CurrentCamera.CFrame = CFrame.lookAt(cframePosition - Unit * 12 + Vector3.new(0, 5, 0), cframePosition + Unit * 10 + Vector3.new(0, 1.5, 0))
            end
        end

        task.spawn(function() -- line: 1115
            -- upvalues: v271 (ref), Character (ref), v276 (copy), Humanoid (ref), RunService (copy), LocalPlayer (copy), MotoLegends (copy)
            RunService.Heartbeat:Wait()
            RunService.Heartbeat:Wait()

            if LocalPlayer.Character == Character and not LocalPlayer:GetAttribute("RaceGridLocked") then
                Humanoid.Sit = false
                Character:PivotTo(v271.cframe)

                if v276 then
                    local LookVector = v271.cframe.LookVector
                    local v279 = Vector3.new(LookVector.X, 0, LookVector.Z)

                    if not (v279.Magnitude < 0.1) then
                        local Unit = v279.Unit
                        local cframePosition = v271.cframe.Position

                        workspace.CurrentCamera.CFrame = CFrame.lookAt(cframePosition - Unit * 12 + Vector3.new(0, 5, 0), cframePosition + Unit * 10 + Vector3.new(0, 1.5, 0))
                    end
                end

                MotoLegends.ChampionshipEvent:FireServer("PaddockReady", v271.token)
            end
        end)
    elseif p74 == "Bike" then
        v92 = v272
        Unit = nil
        Attribute = nil
        Position = nil
        Unit2 = nil
        v119 = nil
        v124 = false
        v94.frozen = nil
        v94.frozenSector = nil
        t15.gearPred = nil
        task.spawn(function() -- line: 1123
            -- upvalues: v271 (ref), MotoLegends (copy), t15 (copy)
            if not (t15.streamBikeSurface(v271) and v271.Parent) then
                return
            end

            local PrimaryPart = v271.PrimaryPart

            if PrimaryPart then
                t15.spawnHold = {
                    bike = v271,
                    cf = PrimaryPart.CFrame,
                    untilT = os.clock() + 4
                }
            end

            local SpawnReady = MotoLegends:WaitForChild("SpawnReady")
            local v280 = v271

            SpawnReady:FireServer(v280, v280:GetAttribute("SpawnToken"))
        end)
    elseif p74 == "Crash" then
        if LocalPlayer.Character then
            LocalPlayer.Character:SetAttribute("RaceCrashActive", true)
        end

        followCrashBike()

        if t16.vibration then
            CrashHaptics.Play(v99, typeof(v272) == "table" and v272.severity or 1)
        end

        local v282 = v94
        local v283, v284

        if v94.sectorStart and v94.sectorStart > 0 then
            local v285 = workspace:GetServerTimeNow() - v94.sectorStart

            if v285 then
                v283 = v285
                v284 = true
            else
                v284 = false
            end
        else
            v284 = false
        end

        v282.frozenSector = if not v284 then 0 else v283

        local v286 = v94
        local v287, v288

        if v94.start and v94.start > 0 then
            local v289 = workspace:GetServerTimeNow() - v94.start

            if v289 then
                v287 = v289
                v288 = true
            else
                v288 = false
            end
        else
            v288 = false
        end

        v286.frozen = if not v288 then 0 else v287
        n5 = 0
        v94.valid = false
        pose(false)

        local v290 = typeof(v272) == "table" and v272.wall

        if typeof(v290) == "table" then
            local v291 = v92
            local elapsed = os.clock()

            local function throw() -- line: 1136
                -- upvalues: v290 (copy), v291 (copy), elapsed (copy), LocalPlayer (copy), Config (copy)
                local v292 = Vector3.new(0, 1, 0) * -(Config.Gravity * (os.clock() - elapsed))
                local Character = LocalPlayer.Character
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart and typeof(v290.rider) == "Vector3" and Character:GetAttribute("RaceCrashServerSim") ~= true then
                    local v293 = typeof(v290.riderSpin) == "Vector3" and v290.riderSpin or Vector3.new(0, 0, 0)
                    local t56 = {}
                    local Position = HumanoidRootPart.Position
                    local v294 = Vector3.new(0, 0, 0)
                    local n28 = 0

                    for _, child in Character:GetChildren() do
                        if child:IsA("BasePart") and not child.Massless then
                            v294 += child.Position * child.Mass
                            n28 += child.Mass
                        end
                    end

                    if n28 > 0 then
                        Position = v294 / n28
                    end

                    for _, descendant in Character:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            local v295 = descendant.AssemblyRootPart or descendant

                            if not t56[v295] then
                                t56[v295] = true
                                v295.AssemblyLinearVelocity = v290.rider + v292 + v293:Cross(v295.AssemblyCenterOfMass - Position)
                                v295.AssemblyAngularVelocity = v293
                            end
                        end
                    end
                end

                local v296 = v291 and v291.PrimaryPart

                if v296 and typeof(v290.bike) == "Vector3" then
                    v296.AssemblyLinearVelocity = v290.bike + v292

                    local v297 = typeof(v290.bikeSpin) == "Vector3" and v290.bikeSpin or Vector3.new(0, 0, 0)

                    v296.AssemblyAngularVelocity = v297
                end
            end

            throw()
            task.delay(0.05, throw)
            task.delay(0.12, throw)

            if typeof(v290.bike) == "Vector3" then
                local elapsed = os.clock()
                local connection

                connection = RunService.PostSimulation:Connect(function() -- line: 1157
                    -- upvalues: v290 (copy), v291 (copy), elapsed (copy), connection (ref), Config (copy)
                    local v298 = v291 and v291.PrimaryPart

                    if v298 and v298.Parent and not (os.clock() - elapsed > 0.2) then
                        local v299 = v290.bike + Vector3.new(0, 1, 0) * -(Config.Gravity * (os.clock() - elapsed))

                        if (v298.AssemblyLinearVelocity - v299).Magnitude > v299.Magnitude * 0.6 + 6 then
                            v298.AssemblyLinearVelocity = v299

                            if typeof(v290.bikeSpin) == "Vector3" then
                                v298.AssemblyAngularVelocity = v290.bikeSpin
                            end
                        end

                        return
                    end

                    connection:Disconnect()
                end)
            end
        end
    elseif p74 == "BikeHit" then
        t15.contact.hit(v272)
    elseif p74 == "LegendSave" then
        local v300 = typeof(v272) == "table" and tonumber(v272.recover) or 0.8

        if v119 then
            v119.legendRecoverUntil = os.clock() + v300
            v119.impactReported = false
        end

        v112 = false

        if t16.vibration then
            CrashHaptics.Play(v99, 0.35)
        end
    elseif p74 == "Timing" then
        for v302, v303 in v272 do
            v94[v302] = v303
        end

        v94.frozen = nil
        v94.frozenSector = nil
    elseif p74 == "TrackLimits" then
        v94.valid = false
    elseif p74 ~= "Notice" then
        if p74 == "Reward" then
            v18.Reward(v272)
        elseif p74 == "Transmission" then
            v60 = v272
        elseif p74 == "Assists" then
            v60 = v272.transmission or v60

            if typeof(v272.abs) == "boolean" then
                v94.abs = v272.abs
            end

            for _, v306 in { "tcs", "aw", "ebs" } do
                if v272[v306] ~= nil then
                    v94[v306] = v272[v306]
                    t12[v306] = v272[v306]
                end
            end
        elseif p74 == "ChatAnnouncement" then
            local v308, v309, v310

            if typeof(v272) == "table" then
                if typeof(v272.text) == "string" then
                    v308 = v272.text:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                    v309 = typeof(v272.color) == "string" and v272.color:match("^#%x%x%x%x%x%x$") and v272.color or "#FFFFFF"
                    v310 = false
                else
                    v310 = true
                end
            else
                v310 = true
            end

            if v310 then
                return
            end

            local v311 = "<font color=\"" .. v309 .. "\">" .. v308 .. "</font>"

            ScreenGui:SetAttribute("LastRaceAnnouncement", v272.text)
            ScreenGui:SetAttribute("LastRaceAnnouncementColor", v309)
            ScreenGui:SetAttribute("RaceAnnouncementCount", (ScreenGui:GetAttribute("RaceAnnouncementCount") or 0) + 1)
            t15.chatQueue = t15.chatQueue or {}
            table.insert(t15.chatQueue, {
                rich = v311,
                text = v272.text,
                color = v309
            })

            if not t15.chatBusy then
                t15.chatBusy = true
                task.spawn(function() -- line: 1193
                    -- upvalues: StarterGui (copy), t15 (copy)
                    local TextChatService = game:GetService("TextChatService")

                    while #t15.chatQueue > 0 do
                        local v312 = t15.chatQueue[1]

                        v312.queuedAt = v312.queuedAt or os.clock()

                        local v313 = TextChatService:FindFirstChild("TextChannels") or TextChatService:WaitForChild("TextChannels", 5)
                        local RBXGeneral = v313 and (v313:FindFirstChild("RBXGeneral") or v313:WaitForChild("RBXGeneral", 3) or v313:FindFirstChild("RBXSystem"))

                        if RBXGeneral then
                            local RBXGeneral2 = RBXGeneral

                            local function v314() -- line: 1200
                                -- upvalues: v312 (copy), RBXGeneral2 (copy)
                                RBXGeneral2:DisplaySystemMessage(v312.rich, "MotoLegendsRace")
                            end

                            RBXGeneral = pcall(v314)
                        end

                        if not RBXGeneral then
                            local function v315() -- line: 1201
                                -- upvalues: v312 (copy), StarterGui (copy)
                                StarterGui:SetCore("ChatMakeSystemMessage", {
                                    Text = v312.text,
                                    Color = Color3.fromHex(v312.color)
                                })
                            end

                            RBXGeneral = pcall(v315)
                        end

                        if RBXGeneral then
                            table.remove(t15.chatQueue, 1)
                        elseif os.clock() - v312.queuedAt > 60 then
                            warn("[Sprint chat] Channel unavailable: " .. v312.text)
                            table.remove(t15.chatQueue, 1)
                        end

                        task.wait(0.2)
                    end

                    t15.chatBusy = false
                end)
            end
        elseif p74 == "LapAnnouncement" then
            if MotoLegends:GetAttribute("SessionPhase") == "Racing" then
                return
            end

            local v316 = RaceSocialHUD.LapTime(v272.time)
            local v317 = v272.player .. " sets a lap time of " .. v316
            local v318 = v272.player:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
            local v319 = string.format("<font color=\"#64CEFF\"><b>%s</b></font> <font color=\"#F4F5F3\">sets a lap time of</font> <font color=\"%s\"><b>%s</b></font>", v318, if v272.serverBest then "#FF4141" else "#F4F5F3", v316)
            local TextChannels = game:GetService("TextChatService"):FindFirstChild("TextChannels")

            TextChannels = TextChannels and (TextChannels:FindFirstChild("RBXGeneral") or TextChannels:FindFirstChild("RBXSystem"))

            if TextChannels then
                TextChannels:DisplaySystemMessage(v319, "JerezLap")
            end

            ScreenGui:SetAttribute("LastLapAnnouncement", v317)
            ScreenGui:SetAttribute("LastLapAnnouncementRichText", v319)
        else
            local v320, v321

            if p74 == "Lap" and typeof(v272) == "table" and typeof(v272.time) == "number" and v272.time > 0 then
                v320 = RaceSocialHUD.LapTime(v272.time)
                v321 = v272.serverBest and Color3.fromRGB(255, 65, 65) or v19
                v91.Text = v320
                v91.TextColor3 = v321 or v19
                n5 = os.clock() + 3.5
                ScreenGui:SetAttribute("LastValidLapTime", v272.time)
                ScreenGui:SetAttribute("LastLapServerBest", v272.serverBest == true)
            end
        end
    end
end)
MotoLegends.Telemetry.OnClientEvent:Connect(function(p77) -- line: 1228
    -- upvalues: t15 (copy), v94 (ref)
    local frozen, frozenSector = v94.frozen, v94.frozenSector

    v94 = p77
    v94.frozen = frozen
    v94.frozenSector = frozenSector

    local assistHold = t15.assistHold
    local v322 = assistHold

    if v322 then
        local v323 = os.clock() < assistHold.untilT

        v323 = v323 and v94[assistHold.key] ~= assistHold.value
        v322 = v323
    end

    if v322 then
        v94[assistHold.key] = assistHold.value
    end
end)

do
    local function timeString(p78) -- line: 1234
        if not p78 or p78 <= 0 then
            return "--:--.---"
        end

        local v327 = math.floor(p78 * 1000)

        return string.format("%02d:%02d.%03d", math.floor(v327 / 60000), math.floor(v327 / 1000) % 60, v327 % 1000)
    end

    local function control(_, p80, p81) -- line: 1239
        -- upvalues: v5 (copy), MotoLegends (copy), GamepadControls (copy), t2 (copy), t4 (ref), ScreenGui (copy), v18 (copy), v60 (ref), t15 (copy), captureBinding (copy), v92 (ref), v93 (ref), t22 (ref), v96 (ref), v97 (ref), v110 (ref), v112 (ref), n8 (ref), requestSpawn (copy)
        local v331 = p80 == Enum.UserInputState.Begin or p80 == Enum.UserInputState.Change

        if t4 then
            if p80 == Enum.UserInputState.Begin then
                captureBinding(p81)
            end

            return Enum.ContextActionResult.Sink
        end

        local KeyCode = p81.KeyCode
        local v332 = false
        local v333

        for v334, v335 in t2 do
            if v335 == KeyCode then
                v333 = Enum.KeyCode[v334]
                v332 = true
                break
            end
        end

        if not v332 then
            v333 = t2[KeyCode.Name] and Enum.KeyCode.Unknown or KeyCode
        end

        if v5() then
            if not v331 then
                t22[v333] = nil
                GamepadControls.UpdateMapped(v96, v333, p81.KeyCode, p80, p81.Position)
            end
        else
            GamepadControls.UpdateMapped(v96, v333, p81.KeyCode, p80, p81.Position)
            t22[v333] = v331

            if v333 == Enum.KeyCode.X then
                v97 = v93 and v331
            end

            if p80 == Enum.UserInputState.Begin then
                if v333 == Enum.KeyCode.B then
                    v18.ToggleLeaderboard()
                elseif v333 == Enum.KeyCode.M then
                    if not v5() then
                        v60 = v60 == "Automatic" and "Manual" or "Automatic"
                        MotoLegends.Settings:FireServer({
                            transmission = v60
                        })
                    end
                elseif v333 == Enum.KeyCode.C then
                    n8 = t15.nextCam[n8] or 0
                end
            end

            if v333 == Enum.KeyCode.ButtonR3 then
                v97 = v93 and v331
            end

            if v93 then
                if p80 == Enum.UserInputState.Begin then
                    if v333 == Enum.KeyCode.Q or v333 == Enum.KeyCode.ButtonX then
                        t15.shiftGear(-1)
                    elseif v333 == Enum.KeyCode.E or v333 == Enum.KeyCode.ButtonY then
                        t15.shiftGear(1)
                    elseif v333 == Enum.KeyCode.U then
                        v110 = true
                    elseif v333 == Enum.KeyCode.Space or v333 == Enum.KeyCode.ButtonL3 then
                        t15.requestDismount()
                    elseif v333 == Enum.KeyCode.R or v333 == Enum.KeyCode.ButtonB then
                        if v92 then
                            v112 = not v112
                        end
                    elseif v333 == Enum.KeyCode.Left or v333 == Enum.KeyCode.DPadLeft then
                        t15.assistInput("select", -1)
                    elseif v333 == Enum.KeyCode.Right or v333 == Enum.KeyCode.DPadRight then
                        t15.assistInput("select", 1)
                    elseif v333 == Enum.KeyCode.Up or v333 == Enum.KeyCode.DPadUp then
                        t15.assistInput("change", 1)
                    elseif v333 == Enum.KeyCode.Down or v333 == Enum.KeyCode.DPadDown then
                        t15.assistInput("change", -1)
                    elseif v333 == Enum.KeyCode.ButtonR1 then
                        n8 = t15.nextCam[n8] or 0
                    end
                end

                return Enum.ContextActionResult.Sink
            end

            if p80 == Enum.UserInputState.Begin and (v333 == Enum.KeyCode.X or v333 == Enum.KeyCode.ButtonX) and ScreenGui:GetAttribute("Freecam") ~= true then
                requestSpawn()

                return Enum.ContextActionResult.Sink
            end
        end

        return Enum.ContextActionResult.Pass
    end

    local t60 = {
        Enum.KeyCode.W,
        Enum.KeyCode.S,
        Enum.KeyCode.A,
        Enum.KeyCode.D,
        Enum.KeyCode.Up,
        Enum.KeyCode.Down,
        Enum.KeyCode.Left,
        Enum.KeyCode.Right,
        Enum.KeyCode.Q,
        Enum.KeyCode.E,
        Enum.KeyCode.F,
        Enum.KeyCode.R,
        Enum.KeyCode.G,
        Enum.KeyCode.T,
        Enum.KeyCode.U,
        Enum.KeyCode.Space,
        Enum.KeyCode.LeftShift,
        Enum.KeyCode.RightShift,
        Enum.KeyCode.ButtonR2,
        Enum.KeyCode.ButtonL2,
        Enum.KeyCode.Thumbstick1,
        Enum.KeyCode.Thumbstick2,
        Enum.KeyCode.ButtonR1,
        Enum.KeyCode.ButtonL1,
        Enum.KeyCode.ButtonY,
        Enum.KeyCode.ButtonX,
        Enum.KeyCode.ButtonA,
        Enum.KeyCode.ButtonB,
        Enum.KeyCode.ButtonR3,
        Enum.KeyCode.C,
        Enum.KeyCode.M,
        Enum.KeyCode.H,
        Enum.KeyCode.B,
        Enum.KeyCode.X,
        Enum.KeyCode.DPadUp,
        Enum.KeyCode.DPadDown,
        Enum.KeyCode.DPadLeft,
        Enum.KeyCode.DPadRight,
        Enum.KeyCode.ButtonSelect,
        Enum.KeyCode.ButtonL3
    }

    v11 = function() -- line: 1284
        -- upvalues: ContextActionService (copy), t2 (copy), cancelInputs (copy), control (copy), t60 (copy)
        cancelInputs()
        ContextActionService:UnbindAction("RaceControls")

        local t61 = {}
        local t62 = {}

        for _, v336 in t60 do
            local v337 = t2[v336.Name] or v336

            if not t62[v337] then
                table.insert(t61, v337)
                t62[v337] = true
            end
        end

        ContextActionService:BindActionAtPriority("RaceControls", control, false, 3000, table.unpack(t61))
    end

    v11()

    function t15.collect() -- line: 1293
        -- upvalues: t2 (copy), ScreenGui (copy), t16 (copy)
        local t63 = {}

        for v338, v339 in t2 do
            if v339 ~= Enum.KeyCode[v338] then
                t63[v338] = v339.Name
            end
        end

        local t64 = {}

        for v340, v341 in t16 do
            t64[v340] = v341
        end

        return {
            gfx = t64,
            bindings = t63,
            music = ScreenGui:GetAttribute("MusicOn") ~= false,
            mobileHud = ScreenGui:GetAttribute("MobileHudLayout"),
            mobileType = ScreenGui:GetAttribute("MobileControlType") == 2 and 2 or 1
        }
    end

    function t15.send() -- line: 1298
        -- upvalues: MotoLegends (copy), t15 (copy)
        if t15.ready then
            MotoLegends.Settings:FireServer({
                prefs = t15.collect()
            })
        end
    end

    function t15.assistInput(p82, p83) -- line: 1300
        -- upvalues: MotoLegends (copy), Config (copy), RaceGauge (copy), v57 (copy), t12 (copy), t15 (copy), v93 (ref), v94 (ref)
        if v93 then
            if p82 == "select" then
                v57.Select(v57.assistIndex + p83)
            elseif p82 == "set" then
                v57.Select(p83)
            else
                local v342 = RaceGauge.Keys[v57.assistIndex]
                local assistHold = t15.assistHold
                local v343, v344

                if assistHold and assistHold.key == v342 and os.clock() < assistHold.untilT then
                    local value = assistHold.value

                    if value then
                        v343 = value
                        v344 = true
                    else
                        v344 = false
                    end
                else
                    v344 = false
                end

                if not v344 then
                    v343 = v94[v342] or t12[v342] or Config[v342:upper()]
                end

                local v346 = math.clamp(v343 + p83, 1, 5)

                if v346 ~= v343 then
                    v94[v342] = v346
                    t12[v342] = v346
                    t15.assistHold = {
                        key = v342,
                        value = v346,
                        untilT = os.clock() + 1
                    }
                    MotoLegends.Settings:FireServer({
                        [v342] = v346
                    })
                end
            end
        end
    end

    v57.OnAssist = function(p84, p85) -- line: 1313
        -- upvalues: v5 (copy), t15 (copy)
        if not v5() then
            t15.assistInput(p84, p85)
        end
    end

    function t15.requestDismount() -- line: 1314
        -- upvalues: LocalPlayer (copy), v92 (ref), v111 (ref)
        if not LocalPlayer:GetAttribute("RaceGridLocked") and v92 and v92.PrimaryPart and (v92.PrimaryPart:GetAttribute("LossStage") or "") == "" then
            v111 = true
        end
    end

    t15.GEAR_PREDICT = 2.5
    t15.shiftSeq = 0

    function t15.shiftGear(p86) -- line: 1329
        -- upvalues: MotoLegends (copy), Config (copy), BikeGearbox (copy), t15 (copy), v92 (ref), v93 (ref), v119 (ref)
        local v348 = v119

        t15.shiftSeq += 1

        local shiftSeq = t15.shiftSeq
        local v349

        if v348 and v93 and v92 and v92.PrimaryPart and (v92.PrimaryPart:GetAttribute("LossStage") or "") == "" then
            local elapsed = os.clock()
            local gearPred = t15.gearPred
            local gear = gearPred and elapsed < gearPred.untilT and gearPred.gear or v348.gear
            local AssemblyLinearVelocity = v92.PrimaryPart.AssemblyLinearVelocity

            v349 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude * Config.StudMetres * 3.6

            if elapsed - (t15.gearTapAt or -100) >= BikeGearbox.ShiftInterval then
                local v350 = BikeGearbox.Target(gear, p86, v349, true)

                if v350 then
                    v348.gear = v350
                    v348.shiftAt = elapsed
                    t15.gearTapAt = elapsed
                    t15.gearPred = {
                        gear = v350,
                        seq = shiftSeq,
                        untilT = elapsed + t15.GEAR_PREDICT
                    }
                end
            end
        end

        MotoLegends:WaitForChild("ShiftGear"):FireServer(p86, v349, shiftSeq)
    end

    function t15.apply(p87) -- line: 1349
        -- upvalues: UserInputService (copy), t2 (copy), t3 (copy), v11 (ref), ScreenGui (copy), v60 (ref), t12 (copy), t15 (copy), t16 (copy), applyGraphics (copy), v94 (ref)
        local function v351() -- line: 1350
            -- upvalues: p87 (copy)
            return game:GetService("HttpService"):JSONDecode(p87)
        end

        local ok, result = pcall(v351)

        if ok and typeof(result) == "table" then
            if result.transmission == "Automatic" or result.transmission == "Manual" then
                v60 = result.transmission
            end

            if typeof(result.abs) == "boolean" then
                v94.abs = result.abs
            end

            for _, v353 in { "tcs", "aw", "ebs" } do
                local v354 = result[v353]

                if typeof(v354) == "number" and v354 >= 1 and v354 <= 5 then
                    v94[v353] = v354
                    t12[v353] = v354
                end
            end

            local client2 = typeof(result.client) == "table" and result.client or {}

            if typeof(client2.gfx) == "table" then
                for v356, v357 in client2.gfx do
                    if t16[v356] ~= nil and typeof(v357) == typeof(t16[v356]) then
                        t16[v356] = v357
                    end
                end
            end

            t16.fps = false

            if not t16.audienceSet then
                t16.audience = not (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled)
            end

            if typeof(client2.music) == "boolean" then
                ScreenGui:SetAttribute("MusicOn", client2.music)
            end

            if typeof(client2.mobileHud) == "string" then
                ScreenGui:SetAttribute("MobileHudLayout", client2.mobileHud)
            end

            if client2.mobileType == 1 or client2.mobileType == 2 then
                ScreenGui:SetAttribute("MobileControlType", client2.mobileType)
            end

            if typeof(client2.bindings) == "table" then
                for v361, v362 in client2.bindings do
                    local function v363() -- line: 1364
                        -- upvalues: v362 (copy)
                        return Enum.KeyCode[v362]
                    end

                    local ok, result = pcall(v363)

                    if t2[v361] and ok and result then
                        t2[v361] = result

                        if t3[v361] then
                            t3[v361].Text = result.Name
                        end
                    end
                end

                v11()
            end

            applyGraphics()
        end

        t15.ready = true
    end

    ScreenGui:GetAttributeChangedSignal("MusicOn"):Connect(function() -- line: 1373
        -- upvalues: t15 (copy)
        t15.send()
    end)
    task.spawn(function() -- line: 1374
        -- upvalues: LocalPlayer (copy), t15 (copy)
        local elapsed = os.clock()

        while LocalPlayer:GetAttribute("SavedSettings") == nil and os.clock() - elapsed < 20 do
            task.wait(0.25)
        end

        t15.apply(LocalPlayer:GetAttribute("SavedSettings") or "")
    end)
    UserInputService.InputBegan:Connect(function(p88, p89) -- line: 1379
        -- upvalues: UserInputService (copy), v5 (copy), MotoLegends (copy), t2 (copy), t4 (ref), v18 (copy), v60 (ref), t15 (copy), t16 (copy), captureBinding (copy), v93 (ref), v97 (ref), n8 (ref), v114 (ref), v118 (ref)
        if t4 then
            captureBinding(p88)
        elseif not v5() then
            local KeyCode = p88.KeyCode
            local v364 = false
            local v365

            for v366, v367 in t2 do
                if v367 == KeyCode then
                    v365 = Enum.KeyCode[v366]
                    v364 = true
                    break
                end
            end

            if not v364 then
                v365 = t2[KeyCode.Name] and Enum.KeyCode.Unknown or KeyCode
            end

            if (v93 or v118) and v365 == Enum.KeyCode.X and not v5() then
                v97 = true
            elseif v93 and not t16.camFixed and n8 % 3 == 0 and p88.UserInputType == Enum.UserInputType.MouseButton2 then
                v114 = true
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                UserInputService.MouseIconEnabled = false
            elseif not p89 then
                if v365 == Enum.KeyCode.B then
                    v18.ToggleLeaderboard()
                elseif v365 == Enum.KeyCode.M then
                    if not v5() then
                        v60 = v60 == "Automatic" and "Manual" or "Automatic"
                        MotoLegends.Settings:FireServer({
                            transmission = v60
                        })
                    end
                elseif v365 == Enum.KeyCode.C then
                    n8 = t15.nextCam[n8] or 0
                end
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(p90) -- line: 1392
        -- upvalues: UserInputService (copy), t2 (copy), v97 (ref), v114 (ref)
        local KeyCode = p90.KeyCode
        local v368 = false
        local v369

        for v370, v371 in t2 do
            if v371 == KeyCode then
                v369 = Enum.KeyCode[v370]
                v368 = true
                break
            end
        end

        if not v368 then
            v369 = t2[KeyCode.Name] and Enum.KeyCode.Unknown or KeyCode
        end

        if v369 == Enum.KeyCode.X then
            v97 = false
        end

        if p90.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return
        end

        v114 = false
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end)
    UserInputService.InputChanged:Connect(function(p91, p92) -- line: 1396
        -- upvalues: v5 (copy), Config (copy), t4 (ref), t15 (copy), t16 (copy), captureBinding (copy), v93 (ref), n8 (ref), v114 (ref), t24 (copy), v115 (ref), n9 (ref), v118 (ref)
        if t4 then
            if p91.Position.Magnitude > 0.7 then
                captureBinding(p91)
            end
        elseif not v5() and (v93 or v118) then
            if p91.UserInputType == Enum.UserInputType.MouseMovement and v114 then
                t24[1] -= p91.Delta.X * 0.006

                local v373 = v115

                v115 = math.clamp(v373 + p91.Delta.Y * 0.005, -0.12, 1.1)
            end

            if p91.UserInputType == Enum.UserInputType.MouseWheel and not p92 and v93 and n8 % 3 == 0 and not t16.camFixed then
                local v374 = t15.zoomTarget or n9

                t15.zoomTarget = math.clamp(v374 - p91.Position.Z * (Config.ChaseZoomStep or 0.05), Config.ChaseMinZoom or 0.98, Config.ChaseMaxZoom or 1.15)
            end
        end
    end)
    UserInputService.WindowFocused:Connect(function() -- line: 1410
        -- upvalues: v101 (ref)
        v101 = true
    end)
    UserInputService.WindowFocusReleased:Connect(function() -- line: 1411
        -- upvalues: UserInputService (copy), GamepadControls (copy), CrashHaptics (copy), t22 (ref), v96 (ref), t23 (ref), v97 (ref), v101 (ref), v114 (ref)
        CrashHaptics.Stop()
        v101 = false
        v97 = false
        v114 = false
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        t22 = {}
        v96 = GamepadControls.New()
        t23 = {
            throttle = 0,
            brake = 0,
            rearBrake = 0,
            steer = 0
        }
    end)
    UserInputService.InputBegan:Connect(function(p93, p94) -- line: 1416
        -- upvalues: v2 (ref), v3 (ref), v5 (copy), t4 (ref), v80 (copy), v101 (ref)
        local UserInputType = p93.UserInputType

        if UserInputType == Enum.UserInputType.Touch or UserInputType == Enum.UserInputType.Keyboard or UserInputType.Name:find("Gamepad") then
            v101 = true

            if not p94 and not t4 then
                v5(true)
            end
        end

        if not v3 or v80.Visible then
            return
        end

        v3 = false
        v2 = false
        t4 = nil
    end)
    UserInputService.InputChanged:Connect(function(p95) -- line: 1424
        -- upvalues: v101 (ref)
        local UserInputType = p95.UserInputType

        if UserInputType == Enum.UserInputType.Touch or UserInputType.Name:find("Gamepad") then
            v101 = true
        end
    end)
    UserInputService.JumpRequest:Connect(function() -- line: 1428
        -- upvalues: v5 (copy), LocalPlayer (copy), v93 (ref), t22 (ref), v96 (ref)
        if v5() or not v93 then
            return
        end

        local v378 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if v378 then
            v378.Jump = false
        end

        if t22[Enum.KeyCode.ButtonA] or (v96.rearBrake or 0) > 0.5 then
        end
    end)

    local v379 = frame(ScreenGui, "TouchControls", 0, 0, 0, 0, nil, 1)

    v379.Size = UDim2.fromScale(1, 1)
    v379.Visible = UserInputService.TouchEnabled

    local v380

    local function v381() -- line: 1442
        -- upvalues: RunService (copy), UserInputService (copy), v5 (copy), MotoLegends (copy), RaceGauge (copy), GamepadControls (copy), ScreenGui (copy), v19 (copy), v21 (copy), frame (copy), v57 (copy), t12 (copy), t15 (copy), v92 (ref), v93 (ref), v94 (ref), t23 (ref), v97 (ref), v101 (ref), v112 (ref), n8 (ref), t24 (copy), v115 (ref), v379 (copy), v380 (ref)
        local t67 = {
            steer = 0,
            throttle = 0,
            brake = 0,
            rearBrake = 0,
            lift = 0
        }
        local t68 = {}

        local function isPad(p96) -- line: 1448
            return p96.Name:sub(1, 7) == "Gamepad"
        end

        local function setPad(p97) -- line: 1449
            -- upvalues: t67 (copy), t68 (copy), UserInputService (copy), ScreenGui (copy), v57 (copy)
            local v382 = p97.Name:sub(1, 7) == "Gamepad"
            local v383 = p97 == Enum.UserInputType.Touch

            if not v383 and v382 or v383 then
                if v383 then
                    v382 = false
                end

                if ScreenGui:GetAttribute("GamepadInput") ~= v382 then
                    ScreenGui:SetAttribute("GamepadInput", v382)

                    if v382 then
                        table.clear(t68)

                        for v384 in t67 do
                            t67[v384] = 0
                        end
                    end

                    v57.hideAssists = UserInputService.TouchEnabled and not v382
                end
            end
        end

        setPad(UserInputService:GetLastInputType())
        UserInputService.LastInputTypeChanged:Connect(setPad)
        UserInputService.GamepadDisconnected:Connect(function() -- line: 1460
            -- upvalues: setPad (copy), UserInputService (copy)
            if #UserInputService:GetConnectedGamepads() == 0 then
                setPad(Enum.UserInputType.Touch)
            end
        end)

        t15.touchLooking = function() -- line: 1463
            -- upvalues: t68 (copy)
            for _, v385 in t68 do
                if v385.kind == "look" then
                    return true
                end
            end

            return false
        end

        local v386 = Color3.fromRGB(46, 51, 71)
        local v387 = Color3.fromRGB(170, 173, 190)
        local v388 = Color3.fromRGB(84, 92, 120)
        local v389 = Color3.fromRGB(195, 255, 0)
        local v390 = Color3.fromRGB(255, 65, 34)
        local v391 = Font.new("rbxasset://fonts/families/Michroma.json", Enum.FontWeight.Bold)

        local function lit(p98, p99, p100) -- line: 1471
            -- upvalues: v388 (copy)
            p98.BackgroundColor3 = p100 or v388
            p98.BackgroundTransparency = p99 and 0.5 or 1
        end

        local function shape(p101, p102, p103) -- line: 1472
            -- upvalues: v386 (copy)
            local Frame = Instance.new("Frame")

            Frame.Name = p102
            Frame.BackgroundColor3 = v386
            Frame.BackgroundTransparency = 1
            Frame.BorderSizePixel = 0
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.ZIndex = p103 or 1
            Frame.Parent = p101
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0.5, 0)

            return Frame
        end

        local function pad(p104) -- line: 1477
            -- upvalues: v387 (copy), shape (copy), v379 (copy)
            local v392 = shape(v379, p104)
            local UIStroke = Instance.new("UIStroke")

            UIStroke.Name = "Rim"
            UIStroke.Color = v387
            UIStroke.Transparency = 0.5
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Parent = v392

            local Frame = Instance.new("Frame")

            Frame.Name = "Hit"
            Frame.BackgroundTransparency = 1
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.fromScale(0.5, 0.5)
            Frame.Size = UDim2.fromScale(1, 1)
            Frame.Active = true
            Frame.ZIndex = 6
            Frame.Parent = v392

            return v392, Frame
        end

        local function label(p105, p106, p107) -- line: 1485
            -- upvalues: v391 (copy), v19 (copy)
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = p106
            TextLabel:SetAttribute("KeepFont", true)
            TextLabel.BackgroundTransparency = 1
            TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            TextLabel.Position = UDim2.fromScale(0.5, 0.5)
            TextLabel.Size = UDim2.fromScale(1, 1)
            TextLabel.FontFace = v391
            TextLabel.TextColor3 = v19
            TextLabel.TextTransparency = 0.5
            TextLabel.Text = p107
            TextLabel.ZIndex = 4
            TextLabel.Parent = p105

            return TextLabel
        end

        local function over(p108, p109, p110) -- line: 1490
            p110 = p110 or 0

            local AbsolutePosition, AbsoluteSize = p108.AbsolutePosition, p108.AbsoluteSize

            if p109.X >= AbsolutePosition.X - p110 and p109.X <= AbsolutePosition.X + AbsoluteSize.X + p110 and p109.Y >= AbsolutePosition.Y - p110 then
                return p109.Y <= AbsolutePosition.Y + AbsoluteSize.Y + p110
            end

            return false
        end

        local Steer, Steer2 = pad("Steer")
        local v394 = shape(Steer, "AnalogKnob", 2)

        v394.BackgroundColor3 = Color3.fromRGB(152, 156, 164)
        v394.Position = UDim2.fromScale(0.5, 0.5)
        v394.Size = UDim2.fromScale(0.35, 0.35)
        v394.BackgroundTransparency = 0.5

        local Pedal, Pedal2 = pad("Pedal")
        local CanvasGroup = Instance.new("CanvasGroup")

        CanvasGroup.Name = "Track"
        CanvasGroup.BackgroundTransparency = 1
        CanvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
        CanvasGroup.Position = UDim2.fromScale(0.5, 0.5)
        CanvasGroup.Size = UDim2.fromScale(1, 1)
        CanvasGroup.ZIndex = 2
        CanvasGroup.Parent = Pedal
        Instance.new("UICorner", CanvasGroup).CornerRadius = UDim.new(0.5, 0)

        local v395 = frame(CanvasGroup, "Throttle", 0, 0, 0, 0, v389)

        v395.AnchorPoint = Vector2.new(0, 1)
        v395.Position = UDim2.fromScale(0, 0.5)
        v395.Size = UDim2.fromScale(1, 0)

        local v396 = frame(CanvasGroup, "Brake", 0, 0, 0, 0, v390)

        v396.Position = UDim2.fromScale(0, 0.5)
        v396.Size = UDim2.fromScale(1, 0)
        v395.BackgroundTransparency = 0.5
        v396.BackgroundTransparency = 0.5

        local v397 = frame(CanvasGroup, "Zero", 0, 0, 0, 0, v387, 0.35)

        v397.AnchorPoint = Vector2.new(0.5, 0.5)
        v397.Position = UDim2.fromScale(0.5, 0.5)
        v397.Size = UDim2.new(0.7, 0, 0, 2)

        local THROTTLE = label(v379, "ThrottleCaption", "THROTTLE")
        local FRONT = label(v379, "FrontCaption", "FRONT")
        local RearBrake, RearBrake2 = pad("RearBrake")
        local REAR = label(RearBrake, "Label", "REAR")
        local Leave, Leave2 = pad("Leave")
        local CanvasGroup2 = Instance.new("CanvasGroup")

        CanvasGroup2.Name = "Charge"
        CanvasGroup2.BackgroundTransparency = 1
        CanvasGroup2.Size = UDim2.fromScale(1, 1)
        CanvasGroup2.ZIndex = 2
        CanvasGroup2.Parent = Leave
        Instance.new("UICorner", CanvasGroup2).CornerRadius = UDim.new(0.5, 0)

        local v398 = frame(CanvasGroup2, "Fill", 0, 0, 0, 0, v21)

        v398.AnchorPoint = Vector2.new(0, 1)
        v398.Position = UDim2.fromScale(0, 1)
        v398.Size = UDim2.fromScale(1, 0)
        v398.BackgroundTransparency = 0.5

        local LEAVE = label(Leave, "Label", "LEAVE")

        LEAVE.Size = UDim2.fromScale(0.8, 0.3)
        LEAVE.TextScaled = true

        local UITextSizeConstraint = Instance.new("UITextSizeConstraint", LEAVE)
        local Cam, Cam2 = pad("Cam")
        local CAM = label(Cam, "Label", "CAM")

        CAM.Size = UDim2.fromScale(0.8, 0.3)
        CAM.TextScaled = true

        local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint", CAM)
        local Clutch, Clutch2 = pad("Clutch")
        local CLUTCH = label(Clutch, "Label", "CLUTCH")

        CLUTCH.Size = UDim2.fromScale(0.8, 0.3)
        CLUTCH.TextScaled = true

        local UITextSizeConstraint3 = Instance.new("UITextSizeConstraint", CLUTCH)
        local GearUp, GearUp2 = pad("GearUp")
        local v399 = label(GearUp, "Label", "+")
        local GearDown, GearDown2 = pad("GearDown")
        local v400 = label(GearDown, "Label", "-")
        local RHD, RHD2 = pad("RHD")
        local RHD3 = label(RHD, "Label", "RHD")
        local LookBack, LookBack2 = pad("LookBack")
        local BACK = label(LookBack, "Label", "BACK")
        local t69 = {}
        local t70 = {}
        local v401

        for _, v402 in {
                { "ArrowLeft", "◀" },
                { "ArrowRight", "▶" },
                { "ArrowUp", "▲" },
                { "ArrowDown", "▼" },
                { "Gas2", "GAS" },
                { "Front2", "FRONT" },
                { "Rear2", "REAR" }
            } do
            local v403

            v403, v401 = pad(v402[1])
            t69[v402[1]] = {
                pad = v403,
                hit = v401,
                label = label(v403, "Label", v402[2])
            }
            v403.Visible = false
        end

        local function type2() -- line: 1537
            -- upvalues: ScreenGui (copy)
            return ScreenGui:GetAttribute("MobileControlType") == 2
        end

        local t71 = {}
        local Frame

        for v404, v405 in RaceGauge.Keys do
            v401 = frame(v379, "Assist" .. RaceGauge.Names[v405], 0, 0, 0, 0, nil, 1)
            v401.AnchorPoint = Vector2.new(0.5, 0.5)

            local v406 = frame(v401, "Increase", 0, 0, 0, 0, nil, 1)

            v406.Active = true
            v406.Size = UDim2.fromScale(1, 0.42)

            local v407 = frame(v401, "Decrease", 0, 0, 0, 0, nil, 1)

            v407.Active = true
            v407.AnchorPoint = Vector2.new(0, 1)
            v407.Position = UDim2.fromScale(0, 1)
            v407.Size = UDim2.fromScale(1, 0.42)
            Frame = Instance.new("Frame")
            Frame.Name = "Value"
            Frame.BackgroundTransparency = 1
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.fromScale(0.5, 0.5)
            Frame.Size = UDim2.fromScale(1.3, 0.16)
            Frame.ZIndex = 4
            Frame.Parent = v401

            local UIListLayout = Instance.new("UIListLayout")

            UIListLayout.FillDirection = Enum.FillDirection.Horizontal
            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 4)
            UIListLayout.Parent = Frame
            UIListLayout = label(Frame, "Name", RaceGauge.Names[v405])
            UIListLayout.AutomaticSize = Enum.AutomaticSize.X
            UIListLayout.Size = UDim2.fromScale(0, 1)
            UIListLayout.LayoutOrder = 1

            local Frame2 = Instance.new("Frame")

            Frame2.Name = "Box"
            Frame2.BackgroundColor3 = Color3.fromRGB(236, 39, 49)
            Frame2.BackgroundTransparency = 0.15
            Frame2.BorderSizePixel = 0
            Frame2.ZIndex = 4
            Frame2.LayoutOrder = 2
            Frame2.Parent = Frame
            Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0.28, 0)

            local v408 = label(Frame2, "Digit", "-")

            v408.TextColor3 = v19
            v408.TextTransparency = 0
            v408.ZIndex = 5
            v408 = {
                key = v405,
                col = v401,
                up = label(v406, "Glyph", "▲"),
                down = label(v407, "Glyph", "▼"),
                caption = UIListLayout,
                box = Frame2,
                digit = v408
            }

            for _, v409 in {
                    {
                        v406,
                        v408.up,
                        1
                    },
                    {
                        v407,
                        v408.down,
                        -1
                    }
                } do
                v409[1].InputBegan:Connect(function(p111) -- line: 1555
                    -- upvalues: v389 (copy), v409 (copy), v404 (copy), v5 (copy), v19 (copy), v57 (copy), t15 (copy), v93 (ref)
                    if p111.UserInputType == Enum.UserInputType.Touch and p111.UserInputState == Enum.UserInputState.Begin and not v5() and v93 then
                        v57.Select(v404)
                        t15.assistInput("change", v409[3])
                        v409[2].TextColor3 = v389
                        task.delay(0.15, function() -- line: 1558
                            -- upvalues: v409 (copy), v19 (copy)
                            v409[2].TextColor3 = v19
                        end)
                    end
                end)
            end

            t71[v404] = v408
        end

        v57.hideAssists = UserInputService.TouchEnabled and ScreenGui:GetAttribute("GamepadInput") ~= true

        local function steerTo(p112) -- line: 1566
            -- upvalues: t67 (copy), Steer (copy), v394 (copy), GamepadControls (copy)
            local AbsoluteSize = Steer.AbsoluteSize
            local v410 = Vector2.new(p112.Position.X, p112.Position.Y) - (Steer.AbsolutePosition + AbsoluteSize * 0.5)
            local v412 = math.max(AbsoluteSize.X * 0.34, 1)

            if v412 < v410.Magnitude then
                v410 = v410.Unit * v412
            end

            t67.steer = GamepadControls.Steer(v410.X / v412)
            t67.lift = GamepadControls.Axis(-v410.Y / v412, 0.3, 1)
            v394.Position = UDim2.new(0.5, v410.X, 0.5, v410.Y)
        end

        local function refreshRight() -- line: 1576
            -- upvalues: t67 (copy), t68 (copy), Pedal (copy), RearBrake (copy)
            local n29 = 0
            local n30 = 0
            local v413 = false

            for v414, v415 in t68 do
                if v415.kind == "right" then
                    local Position = v414.Position
                    local n31 = 4
                    local AbsolutePosition, AbsoluteSize = RearBrake.AbsolutePosition, RearBrake.AbsoluteSize

                    if Position.X >= AbsolutePosition.X - n31 and Position.X <= AbsolutePosition.X + AbsoluteSize.X + n31 and Position.Y >= AbsolutePosition.Y - n31 and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y + n31 then
                        v413 = true
                    end

                    if v415.pedal then
                        local AbsolutePosition, AbsoluteSize = Pedal.AbsolutePosition, Pedal.AbsoluteSize
                        local v417 = math.max(AbsoluteSize.Y / 2 - AbsoluteSize.X * 0.3, 1)
                        local v419 = math.clamp((AbsolutePosition.Y + AbsoluteSize.Y / 2 - Position.Y) / v417, -1, 1)
                        local v420 = math.abs(v419)
                        local v421 = if v420 < 0.06 then 0 else math.sign(v419) * (v420 - 0.06) / 0.94

                        n29 = math.max(n29, v421)
                        n30 = math.max(n30, -v421)
                    else
                        local n32 = 0
                        local AbsolutePosition, AbsoluteSize = Pedal.AbsolutePosition, Pedal.AbsoluteSize

                        if Position.X >= AbsolutePosition.X - n32 and Position.X <= AbsolutePosition.X + AbsoluteSize.X + n32 and Position.Y >= AbsolutePosition.Y - n32 and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y + n32 then
                            local AbsolutePosition, AbsoluteSize = Pedal.AbsolutePosition, Pedal.AbsoluteSize
                            local v424 = math.max(AbsoluteSize.Y / 2 - AbsoluteSize.X * 0.3, 1)
                            local v426 = math.clamp((AbsolutePosition.Y + AbsoluteSize.Y / 2 - Position.Y) / v424, -1, 1)
                            local v427 = math.abs(v426)
                            local v428 = if v427 < 0.06 then 0 else math.sign(v426) * (v427 - 0.06) / 0.94

                            n29 = math.max(n29, v428)
                            n30 = math.max(n30, -v428)
                        end
                    end
                end
            end

            t67.throttle = n29
            t67.brake = n30
            t67.rearBrake = v413 and 1 or 0
        end

        local function refresh2() -- line: 1594
            -- upvalues: t67 (copy), t68 (copy), t69 (copy), t70 (copy)
            table.clear(t70)

            for v430, v431 in t68 do
                if v431.kind == "btn2" then
                    local Position = v430.Position

                    for v432, v433 in t69 do
                        if v433.pad.Visible then
                            local pad = v433.pad
                            local v434 = (if v432 == "Front2" or v432 == "Rear2" then 10 else 4) or 0
                            local AbsolutePosition, AbsoluteSize = pad.AbsolutePosition, pad.AbsoluteSize

                            if Position.X >= AbsolutePosition.X - v434 and Position.X <= AbsolutePosition.X + AbsoluteSize.X + v434 and Position.Y >= AbsolutePosition.Y - v434 and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y + v434 then
                                t70[v432] = true
                            end
                        end
                    end
                end
            end

            t67.steer = (t70.ArrowRight and 1 or 0) - (t70.ArrowLeft and 1 or 0)
            t67.lift = (t70.ArrowDown and 1 or 0) - (t70.ArrowUp and 1 or 0)
            t67.throttle = t70.Gas2 and 1 or 0
            t67.brake = t70.Front2 and 1 or 0
            t67.rearBrake = t70.Rear2 and 1 or 0
        end

        local function starts(p113) -- line: 1608
            -- upvalues: t68 (copy), v5 (copy), v93 (ref)
            if p113.UserInputType == Enum.UserInputType.Touch and p113.UserInputState == Enum.UserInputState.Begin then
                return not v5() and v93 and t68[p113] == nil
            end

            return false
        end

        Steer2.InputBegan:Connect(function(p114) -- line: 1611
            -- upvalues: t68 (copy), steerTo (copy), v5 (copy), v93 (ref)
            if p114.UserInputType == Enum.UserInputType.Touch and p114.UserInputState == Enum.UserInputState.Begin and not v5() and v93 and t68[p114] == nil then
                for _, v437 in t68 do
                    if v437.kind == "steer" then
                        return
                    end
                end

                t68[p114] = {
                    kind = "steer"
                }
                steerTo(p114)
            end
        end)
        Pedal2.InputBegan:Connect(function(p115) -- line: 1616
            -- upvalues: t68 (copy), refreshRight (copy), v5 (copy), v93 (ref)
            if p115.UserInputType == Enum.UserInputType.Touch and p115.UserInputState == Enum.UserInputState.Begin and not v5() and v93 and t68[p115] == nil then
                t68[p115] = {
                    kind = "right",
                    pedal = true
                }
                refreshRight()
            end
        end)
        RearBrake2.InputBegan:Connect(function(p116) -- line: 1617
            -- upvalues: t68 (copy), refreshRight (copy), v5 (copy), v93 (ref)
            if p116.UserInputType == Enum.UserInputType.Touch and p116.UserInputState == Enum.UserInputState.Begin and not v5() and v93 and t68[p116] == nil then
                t68[p116] = {
                    kind = "right",
                    pedal = false
                }
                refreshRight()
            end
        end)

        for _, v438 in t69 do
            Frame = v438.hit.InputBegan
            Frame:Connect(function(p117) -- line: 1618
                -- upvalues: t68 (copy), refresh2 (copy), v5 (copy), ScreenGui (copy), v93 (ref)
                if not (p117.UserInputType == Enum.UserInputType.Touch and p117.UserInputState == Enum.UserInputState.Begin and not v5() and v93 and t68[p117] == nil) or ScreenGui:GetAttribute("MobileControlType") ~= 2 then
                    return
                end

                t68[p117] = {
                    kind = "btn2"
                }
                refresh2()
            end)
        end

        ScreenGui:GetAttributeChangedSignal("MobileControlType"):Connect(function() -- line: 1620
            -- upvalues: t67 (copy), t68 (copy), v394 (copy), t70 (copy), t23 (ref)
            table.clear(t68)
            table.clear(t70)

            for v439 in t67 do
                t67[v439] = 0
                t23[v439] = 0
            end

            v394.Position = UDim2.fromScale(0.5, 0.5)
        end)
        Leave2.InputBegan:Connect(function(p118) -- line: 1624
            -- upvalues: t68 (copy), v5 (copy), v93 (ref)
            if p118.UserInputType == Enum.UserInputType.Touch and p118.UserInputState == Enum.UserInputState.Begin and not v5() and v93 and t68[p118] == nil then
                t68[p118] = {
                    kind = "leave",
                    t0 = os.clock()
                }
            end
        end)

        local function tap(p119, p120, p121) -- line: 1625
            -- upvalues: t68 (copy), v5 (copy), v93 (ref)
            p119.InputBegan:Connect(function(p122) -- line: 1626
                -- upvalues: p120 (copy), p121 (copy), t68 (copy), v5 (copy), v93 (ref)
                if p122.UserInputType ~= Enum.UserInputType.Touch or p122.UserInputState ~= Enum.UserInputState.Begin or v5() or not v93 or t68[p122] ~= nil then
                    return
                end

                t68[p122] = {
                    kind = "tap",
                    pad = p120
                }
                p121()
            end)
        end

        local function v440() -- line: 1628
            -- upvalues: t15 (copy)
            t15.shiftGear(1)
        end

        GearUp2.InputBegan:Connect(function(p123) -- line: 1626
            -- upvalues: t68 (copy), GearUp (copy), v440 (copy), v5 (copy), v93 (ref)
            if p123.UserInputType ~= Enum.UserInputType.Touch or p123.UserInputState ~= Enum.UserInputState.Begin or v5() or not v93 or t68[p123] ~= nil then
                return
            end

            t68[p123] = {
                kind = "tap",
                pad = GearUp
            }
            v440()
        end)

        local function v441() -- line: 1629
            -- upvalues: t15 (copy)
            t15.shiftGear(-1)
        end

        GearDown2.InputBegan:Connect(function(p124) -- line: 1626
            -- upvalues: t68 (copy), GearDown (copy), v441 (copy), v5 (copy), v93 (ref)
            if p124.UserInputType ~= Enum.UserInputType.Touch or p124.UserInputState ~= Enum.UserInputState.Begin or v5() or not v93 or t68[p124] ~= nil then
                return
            end

            t68[p124] = {
                kind = "tap",
                pad = GearDown
            }
            v441()
        end)

        local function v442() -- line: 1630
            -- upvalues: v92 (ref), v112 (ref)
            if v92 then
                v112 = not v112
            end
        end

        RHD2.InputBegan:Connect(function(p125) -- line: 1626
            -- upvalues: t68 (copy), RHD (copy), v442 (copy), v5 (copy), v93 (ref)
            if p125.UserInputType ~= Enum.UserInputType.Touch or p125.UserInputState ~= Enum.UserInputState.Begin or v5() or not v93 or t68[p125] ~= nil then
                return
            end

            t68[p125] = {
                kind = "tap",
                pad = RHD
            }
            v442()
        end)

        local function v443() -- line: 1631
            -- upvalues: t15 (copy), n8 (ref)
            n8 = t15.nextCam[n8] or 0
        end

        Cam2.InputBegan:Connect(function(p126) -- line: 1626
            -- upvalues: t68 (copy), Cam (copy), v443 (copy), v5 (copy), v93 (ref)
            if p126.UserInputType ~= Enum.UserInputType.Touch or p126.UserInputState ~= Enum.UserInputState.Begin or v5() or not v93 or t68[p126] ~= nil then
                return
            end

            t68[p126] = {
                kind = "tap",
                pad = Cam
            }
            v443()
        end)

        local function v444() -- line: 1632
            -- upvalues: t23 (ref)
            local t73 = t23

            t73.clutch = not t23.clutch
        end

        Clutch2.InputBegan:Connect(function(p127) -- line: 1626
            -- upvalues: t68 (copy), Clutch (copy), v444 (copy), v5 (copy), v93 (ref)
            if p127.UserInputType ~= Enum.UserInputType.Touch or p127.UserInputState ~= Enum.UserInputState.Begin or v5() or not v93 or t68[p127] ~= nil then
                return
            end

            t68[p127] = {
                kind = "tap",
                pad = Clutch
            }
            v444()
        end)
        LookBack2.InputBegan:Connect(function(p128) -- line: 1633
            -- upvalues: t68 (copy), v5 (copy), v93 (ref), v97 (ref)
            if p128.UserInputType == Enum.UserInputType.Touch and p128.UserInputState == Enum.UserInputState.Begin and not v5() and v93 and t68[p128] == nil then
                t68[p128] = {
                    kind = "lookback"
                }
                v97 = true
            end
        end)

        local function touchLooksBack() -- line: 1634
            -- upvalues: t68 (copy)
            for _, v445 in t68 do
                if v445.kind == "lookback" then
                    return true
                end
            end

            return false
        end

        UserInputService.InputBegan:Connect(function(p129, p130) -- line: 1637
            -- upvalues: t68 (copy), v5 (copy), v93 (ref)
            if not p130 and p129.UserInputType == Enum.UserInputType.Touch and p129.UserInputState == Enum.UserInputState.Begin and not v5() and v93 and t68[p129] == nil then
                t68[p129] = {
                    kind = "look",
                    last = Vector2.new(p129.Position.X, p129.Position.Y),
                    moved = os.clock()
                }
            end
        end)
        UserInputService.InputChanged:Connect(function(p131) -- line: 1641
            -- upvalues: t68 (copy), Leave (copy), steerTo (copy), refreshRight (copy), refresh2 (copy), t24 (copy), v115 (ref)
            local v446 = t68[p131]

            if v446 then
                if v446.kind == "look" then
                    local v447 = Vector2.new(p131.Position.X, p131.Position.Y)
                    local v448 = v447 - v446.last

                    v446.last = v447

                    if v448.Magnitude > 0.5 then
                        v446.moved = os.clock()
                    end

                    local ViewportSize = workspace.CurrentCamera.ViewportSize

                    t24[1] = t24[1] - v448.X / math.max(ViewportSize.X, 1) * 5

                    local v450 = v115

                    v115 = math.clamp(v450 + v448.Y / math.max(ViewportSize.Y, 1) * 2.4, -0.12, 1.1)
                elseif v446.kind == "steer" then
                    steerTo(p131)
                elseif v446.kind == "right" then
                    refreshRight()
                elseif v446.kind == "btn2" then
                    refresh2()
                elseif v446.kind == "leave" then
                    local Position = p131.Position
                    local n33 = 6
                    local AbsolutePosition, AbsoluteSize = Leave.AbsolutePosition, Leave.AbsoluteSize

                    if not (Position.X >= AbsolutePosition.X - n33 and Position.X <= AbsolutePosition.X + AbsoluteSize.X + n33 and Position.Y >= AbsolutePosition.Y - n33 and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y + n33) then
                        v446.cancelled = true
                    end
                end
            end
        end)

        local function endTouch(p132) -- line: 1653
            -- upvalues: t67 (copy), t68 (copy), v394 (copy), Leave (copy), refreshRight (copy), refresh2 (copy), t15 (copy), v97 (ref)
            local v452 = t68[p132]

            if v452 then
                t68[p132] = nil

                if v452.kind == "steer" then
                    t67.steer = 0
                    t67.lift = 0
                    v394.Position = UDim2.fromScale(0.5, 0.5)
                elseif v452.kind == "right" then
                    refreshRight()
                elseif v452.kind == "btn2" then
                    refresh2()
                elseif v452.kind == "lookback" then
                    local v453 = false
                    local v454

                    for _, v455 in t68 do
                        if v455.kind == "lookback" then
                            v454 = true
                            v453 = true
                            break
                        end
                    end

                    if not v453 then
                        v454 = false
                    end

                    if not v454 then
                        v97 = false
                    end
                elseif v452.kind == "leave" and not v452.cancelled and os.clock() - v452.t0 >= 0.6 then
                    local Position = p132.Position
                    local n34 = 6
                    local AbsolutePosition, AbsoluteSize = Leave.AbsolutePosition, Leave.AbsoluteSize

                    if Position.X >= AbsolutePosition.X - n34 and Position.X <= AbsolutePosition.X + AbsoluteSize.X + n34 and Position.Y >= AbsolutePosition.Y - n34 and Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y + n34 then
                        t15.requestDismount()
                    end
                end
            end
        end

        UserInputService.InputEnded:Connect(endTouch)

        local function pruneTouches() -- line: 1669
            -- upvalues: t68 (copy), endTouch (copy)
            for v457 in t68 do
                local UserInputState = v457.UserInputState

                if UserInputState == Enum.UserInputState.End or UserInputState == Enum.UserInputState.Cancel then
                    endTouch(v457)
                end
            end
        end

        RunService.PreSimulation:Connect(function(p133) -- line: 1675
            -- upvalues: t67 (copy), t68 (copy), v394 (copy), pruneTouches (copy), v5 (copy), v93 (ref), t23 (ref), v97 (ref), v101 (ref)
            pruneTouches()

            if v93 and v101 and not v5() then
                for v458, v459 in t67 do
                    if v458 == "steer" then
                        t23.steer = v459
                    else
                        local v460 = if v459 == 0 then 35 else 14

                        t23[v458] = (t23[v458] or 0) + (v459 - (t23[v458] or 0)) * (1 - math.exp(-v460 * p133))

                        if v459 == 0 then
                            local v464 = t23[v458]

                            if math.abs(v464) < 0.001 then
                                t23[v458] = 0
                            end
                        end
                    end
                end
            else
                local v465 = false
                local v466

                for _, v467 in t68 do
                    if v467.kind == "lookback" then
                        v466 = true
                        v465 = true
                        break
                    end
                end

                if not v465 then
                    v466 = false
                end

                if v466 then
                    v97 = false
                end

                table.clear(t68)

                for v468 in t67 do
                    t67[v468] = 0
                    t23[v468] = 0
                end

                if not v93 then
                    t23.clutch = false
                end

                v394.Position = UDim2.fromScale(0.5, 0.5)
            end
        end)
        RunService.RenderStepped:Connect(function() -- line: 1695
            -- upvalues: t67 (copy), t68 (copy), v387 (copy), v388 (copy), v389 (copy), v390 (copy), v395 (copy), v396 (copy), RearBrake (copy), Leave (copy), v398 (copy), LEAVE (copy), Cam (copy), Clutch (copy), CLUTCH (copy), GearUp (copy), GearDown (copy), RHD (copy), RHD3 (copy), LookBack (copy), BACK (copy), t69 (copy), t70 (copy), t71 (copy), v19 (copy), t12 (copy), v94 (ref), t23 (ref), v97 (ref), v112 (ref), v379 (copy)
            if v379.Visible then
                v395.Size = UDim2.fromScale(1, 0.5 * t67.throttle)
                v396.Size = UDim2.fromScale(1, 0.5 * t67.brake)

                local v469 = t67.rearBrake > 0

                RearBrake.BackgroundColor3 = v390 or v388
                RearBrake.BackgroundTransparency = v469 and 0.5 or 1

                for v470, v471 in t69 do
                    local pad = v471.pad
                    local v472 = t70[v470] == true
                    local v473

                    if v470 == "Gas2" then
                        v473 = v389

                        if not v389 then
                            local v474 = v470 == "Front2"
                            local v475, v476

                            if v474 then
                                v476 = v390
                            else
                                v475 = v470 == "Rear2"
                            end

                            if v474 and not v476 or not v474 and not v475 then
                                v473 = nil
                            elseif v474 then
                                v473 = v476
                            else
                                v476 = v390
                                v473 = v390 or nil
                            end
                        end
                    elseif v470 == "Front2" or v470 == "Rear2" then
                        v473 = v390 or nil
                    end

                    pad.BackgroundColor3 = v473 or v388
                    pad.BackgroundTransparency = v472 and 0.5 or 1
                end

                local t77 = {}
                local v477

                for _, v478 in t68 do
                    if v478.kind == "tap" then
                        t77[v478.pad] = true
                    elseif v478.kind == "leave" then
                        v477 = v478
                    end
                end

                for _, v479 in { GearUp, GearDown, RHD, Cam, Clutch } do
                    local v480 = t77[v479] == true

                    v479.BackgroundColor3 = v388
                    v479.BackgroundTransparency = v480 and 0.5 or 1
                end

                if t23.clutch then
                    Clutch.BackgroundColor3 = v388
                    Clutch.BackgroundTransparency = 0.5
                end

                CLUTCH.TextColor3 = t23.clutch and v389 or v19

                local v482, v483

                if not v477 or v477.cancelled then
                    v483 = false
                else
                    local v485 = math.clamp((os.clock() - v477.t0) / 0.6, 0, 1)

                    if v485 then
                        v482 = v485
                        v483 = true
                    else
                        v483 = false
                    end
                end

                if not v483 then
                    v482 = 0
                end

                v398.Size = UDim2.fromScale(1, v482)
                Leave.Rim.Color = v482 >= 1 and v19 or v387
                LEAVE.Text = v482 >= 1 and "RELEASE" or "LEAVE"
                RHD3.TextColor3 = v112 and v389 or v19

                local v487 = false
                local v488

                for _, v489 in t68 do
                    if v489.kind == "lookback" then
                        v488 = true
                        v487 = true
                        break
                    end
                end

                if not v487 then
                    v488 = false
                end

                LookBack.BackgroundColor3 = v388
                LookBack.BackgroundTransparency = v488 and 0.5 or 1
                BACK.TextColor3 = v97 and v389 or v19

                for _, v491 in t71 do
                    local v493 = v94
                    local v494 = tostring(v493[v491.key] or t12[v491.key] or "-")

                    if v491.digit.Text ~= v494 then
                        v491.digit.Text = v494
                    end
                end
            end
        end)

        v380 = function(p134, p135) -- line: 1716
            -- upvalues: Steer (copy), Pedal (copy), Pedal2 (copy), THROTTLE (copy), FRONT (copy), RearBrake (copy), REAR (copy), Leave (copy), UITextSizeConstraint (copy), Cam (copy), UITextSizeConstraint2 (copy), Clutch (copy), UITextSizeConstraint3 (copy), GearUp (copy), v399 (copy), GearDown (copy), v400 (copy), RHD (copy), RHD3 (copy), LookBack (copy), BACK (copy), t69 (copy), t71 (copy), MotoLegends (copy), RaceGauge (copy), ScreenGui (copy), v379 (copy)
            local v496 = math.min(p134.Y / 1125, p134.X / 2000)
            local X = p134.X
            local Y = p134.Y

            local function place(p136, p137, p138, p139, p140) -- line: 1719
                p136.Position = UDim2.fromOffset(p137, p138)
                p136.Size = UDim2.fromOffset(p139, p140)
            end

            local v497 = v496 * 306
            local v498 = Y - v496 * 256
            local v499 = v496 * 372
            local ok = v496 * 372

            Steer.Position = UDim2.fromOffset(v497, v498)
            Steer.Size = UDim2.fromOffset(v499, ok)

            local v500 = (p134.X / 2 - RaceGauge.Width / 2 * 0.72 * p135) / v496

            local function around(p141, p142, p143, p144) -- line: 1730
                -- upvalues: v496 (copy), Y (copy), v500 (copy)
                local v501 = p142 - 343
                local v502 = p143 - 225
                local v504 = math.sqrt(v501 * v501 + v502 * v502)
                local v505 = (v504 + 186 - 155) / v504
                local v508 = math.min(306 + v501 * v505, v500 - 40 - p144 / 2) * v496
                local v509 = Y - (256 + v502 * v505) * v496
                local v510 = p144 * v496
                local v511 = p144 * v496

                p141.Position = UDim2.fromOffset(v508, v509)
                p141.Size = UDim2.fromOffset(v510, v511)
            end

            v499 = math.min(534.7620469797438, v500 - 40 - 52) * v496
            ok = Y - 488.07743896495754 * v496

            local result = 104 * v496
            local v512 = 104 * v496

            Leave.Position = UDim2.fromOffset(v499, ok)
            Leave.Size = UDim2.fromOffset(result, v512)
            UITextSizeConstraint.MaxTextSize = math.max(6, (math.floor(v496 * 28)))
            v499 = math.min(668.7989143880924, v500 - 40 - 52) * v496
            ok = Y - 214.47482305196533 * v496
            result = 104 * v496
            v512 = 104 * v496
            Cam.Position = UDim2.fromOffset(v499, ok)
            Cam.Size = UDim2.fromOffset(result, v512)
            UITextSizeConstraint2.MaxTextSize = math.max(6, (math.floor(v496 * 28)))
            v499 = math.min(647.5207509293043, v500 - 40 - 52) * v496
            ok = Y - 365.4617791440078 * v496
            result = 104 * v496
            v512 = 104 * v496
            Clutch.Position = UDim2.fromOffset(v499, ok)
            Clutch.Size = UDim2.fromOffset(result, v512)
            UITextSizeConstraint3.MaxTextSize = math.max(6, (math.floor(v496 * 28)))
            v499 = X - v496 * 175
            ok = Y - v496 * 338
            result = v496 * 120
            v512 = v496 * 445
            Pedal.Position = UDim2.fromOffset(v499, ok)
            Pedal.Size = UDim2.fromOffset(result, v512)
            Pedal2.AnchorPoint = Vector2.new(0, 0.5)
            Pedal2.Position = UDim2.fromScale(0, 0.5)
            Pedal2.Size = UDim2.new(1, v496 * 115, 1, 0)
            v499 = X - v496 * 292
            ok = Y - v496 * 225
            result = v496 * 115
            v512 = v496 * 220
            RearBrake.Position = UDim2.fromOffset(v499, ok)
            RearBrake.Size = UDim2.fromOffset(result, v512)
            REAR.TextSize = v496 * 28
            v499 = X - v496 * 175
            ok = Y - v496 * 586
            result = v496 * 240
            v512 = v496 * 34
            THROTTLE.Position = UDim2.fromOffset(v499, ok)
            THROTTLE.Size = UDim2.fromOffset(result, v512)
            THROTTLE.TextSize = v496 * 28
            v499 = X - v496 * 175
            ok = Y - v496 * 91
            result = v496 * 240
            v512 = v496 * 34
            FRONT.Position = UDim2.fromOffset(v499, ok)
            FRONT.Size = UDim2.fromOffset(result, v512)
            FRONT.TextSize = v496 * 28

            local Rim, v513

            for _, v514 in { Steer, Leave, Cam, Clutch, Pedal, RearBrake } do
                Rim = v514.Rim
                v513 = v496 * 8
                Rim.Thickness = math.max(1.5, v513)
            end

            v498 = X - 14 * p135 - 150 * p135
            v499 = 16 * p135
            v497 = 37.7 * p135
            result = v498 + 43.5 * p135
            v512 = v499 + 59.6 * p135
            GearUp.Position = UDim2.fromOffset(result, v512)
            GearUp.Size = UDim2.fromOffset(v497, v497)
            result = v498 + 43.5 * p135
            v512 = v499 + 104 * p135
            GearDown.Position = UDim2.fromOffset(result, v512)
            GearDown.Size = UDim2.fromOffset(v497, v497)
            result = v498 + 3.5 * p135
            v512 = v499 + 104 * p135
            RHD.Position = UDim2.fromOffset(result, v512)
            RHD.Size = UDim2.fromOffset(v497, v497)
            result = v498 + 3.5 * p135
            v512 = v499 + 59.6 * p135
            LookBack.Position = UDim2.fromOffset(result, v512)
            LookBack.Size = UDim2.fromOffset(v497, v497)
            v399.TextSize = v497 * 0.62
            v400.TextSize = v497 * 0.62
            RHD3.TextSize = v497 * 0.3
            BACK.TextSize = v497 * 0.26

            local col, v515

            for _, v516 in { GearUp, GearDown, RHD, LookBack } do
                col = v516.Rim
                v515 = v497 * 0.08
                col.Thickness = math.max(1.5, v515)
                v516.Hit.Size = UDim2.fromScale(1.15, 1.15)
            end

            v499 = p134.X / 2 + RaceGauge.Width / 2 * 0.72 * p135
            v498 = v496 * 122
            result = X - v496 * 715
            v512 = v499 + v498 / 2 + 6
            ok = math.max(result, v512)

            local v517, v518

            for v519, v520 in t71 do
                col = v520.col
                v513 = ok + (v519 - 1) * 130 * v496
                v517 = Y - v496 * 170
                v515 = v496 * 240
                col.Position = UDim2.fromOffset(v513, v517)
                col.Size = UDim2.fromOffset(v498, v515)
                v520.up.TextSize = v496 * 72
                v520.down.TextSize = v496 * 72
                v520.caption.TextSize = v496 * 30
                v520.digit.TextSize = v496 * 30
                col = v520.box
                v513 = UDim2.fromOffset
                v515 = v496 * 44 + 0.5
                v517 = math.floor(v515)
                v518 = v496 * 40 + 0.5
                col.Size = v513(v517, (math.floor(v518)))
            end

            v497 = ScreenGui:GetAttribute("MobileControlType") == 2

            for _, v521 in { Steer, Pedal, RearBrake, THROTTLE, FRONT } do
                v521.Visible = not v497
            end

            for _, v522 in t69 do
                v522.pad.Visible = v497
            end

            if v497 then
                ok = t69.ArrowLeft.pad
                result = v496 * 176
                v512 = Y - v496 * 256
                Rim = v496 * 140

                local v523 = v496 * 140

                ok.Position = UDim2.fromOffset(result, v512)
                ok.Size = UDim2.fromOffset(Rim, v523)
                ok = t69.ArrowRight.pad
                result = v496 * 436
                v512 = Y - v496 * 256
                Rim = v496 * 140
                v523 = v496 * 140
                ok.Position = UDim2.fromOffset(result, v512)
                ok.Size = UDim2.fromOffset(Rim, v523)
                ok = t69.ArrowUp.pad
                result = v496 * 306
                v512 = Y - v496 * 371
                Rim = v496 * 100
                v523 = v496 * 100
                ok.Position = UDim2.fromOffset(result, v512)
                ok.Size = UDim2.fromOffset(Rim, v523)
                ok = t69.ArrowDown.pad
                result = v496 * 306
                v512 = Y - v496 * 141
                Rim = v496 * 100
                v523 = v496 * 100
                ok.Position = UDim2.fromOffset(result, v512)
                ok.Size = UDim2.fromOffset(Rim, v523)
                v512 = math.min(426, v500 - 40 - 52)
                ok = math.max(300, v512)

                for v524, v525 in { Leave, Clutch, Cam } do
                    v513 = (ok + (v524 - 3) * 120) * v496
                    v517 = Y - v496 * 491
                    v515 = v496 * 104
                    v518 = v496 * 104
                    v525.Position = UDim2.fromOffset(v513, v517)
                    v525.Size = UDim2.fromOffset(v515, v518)
                end

                result = t69.Gas2.pad
                v512 = X - v496 * 165
                Rim = Y - v496 * 250
                v523 = v496 * 230
                col = v496 * 230
                result.Position = UDim2.fromOffset(v512, Rim)
                result.Size = UDim2.fromOffset(v523, col)
                result = t69.Front2.pad
                v512 = X - v496 * 410
                Rim = Y - v496 * 170
                v523 = v496 * 170
                col = v496 * 170
                result.Position = UDim2.fromOffset(v512, Rim)
                result.Size = UDim2.fromOffset(v523, col)
                result = t69.Rear2.pad
                v512 = X - v496 * 410
                Rim = Y - v496 * 345
                v523 = v496 * 140
                col = v496 * 140
                result.Position = UDim2.fromOffset(v512, Rim)
                result.Size = UDim2.fromOffset(v523, col)

                for v526, v527 in t69 do
                    ok = v526 == "ArrowLeft" or v526 == "ArrowRight"
                    v513 = v527.label
                    v515 = if v526:sub(1, 5) ~= "Arrow" then 30 elseif ok then 64 else 48
                    v513.TextSize = v515 * v496
                    v513 = v527.pad.Rim
                    v518 = v496 * 8
                    v513.Thickness = math.max(1.5, v518)
                    v527.hit.Size = UDim2.fromScale(1.08, 1.08)
                end

                v512 = X - v496 * 495 - v496 * 12 - v498 / 2 - v496 * 260
                result = Y - v496 * 170

                if v512 - v498 / 2 < v499 + 6 then
                    v512 = X - v496 * 100 - v496 * 260
                    result = Y - v496 * 560
                end

                for v528, v529 in t71 do
                    v515 = v529.col
                    v518 = v512 + (v528 - 1) * 130 * v496

                    local v530 = v496 * 240

                    v515.Position = UDim2.fromOffset(v518, result)
                    v515.Size = UDim2.fromOffset(v498, v530)
                end
            end

            result = require
            ok, result = pcall(result, MotoLegends:FindFirstChild("MobileHudLayout"))

            if not (ok and result) then
                return
            end

            local MobileHudPreview = ScreenGui:GetAttribute("MobileHudEditing") == true and ScreenGui:GetAttribute("MobileHudPreview") or ScreenGui:GetAttribute("MobileHudLayout")

            if ScreenGui:GetAttribute("MobileControlType") == 2 then
                MobileHudPreview = result.Decode(MobileHudPreview)

                for _, v531 in { "Leave", "Clutch", "Cam", "AssistTCS", "AssistAW", "AssistEBS" } do
                    MobileHudPreview[v531] = nil
                end
            end

            Rim = result.Apply
            pcall(Rim, v379, MobileHudPreview)
        end
    end

    v381()

    local v532 = nil
    local HapticService = game:GetService("HapticService")
    local v533 = RaycastParams.new()

    v533.FilterType = Enum.RaycastFilterType.Include

    local n35 = 0
    local n36 = 0

    RunService.RenderStepped:Connect(function(p145) -- line: 1810
        -- upvalues: Track (copy), MotoLegends (copy), Config (copy), BikeDynamics (copy), t16 (copy), v92 (ref), v93 (ref), v94 (ref), v99 (ref), v119 (ref), HapticService (copy), v533 (copy), n35 (ref), n36 (ref)
        local v534 = workspace:FindFirstChild(Track) and workspace[Track].RaceCollision:FindFirstChild("Kerbs")
        local v535

        if v93 and v92 and v92.PrimaryPart and v534 then
            v533.FilterDescendantsInstances = { v534 }

            local PrimaryPart = v92.PrimaryPart
            local v536 = PrimaryPart.CFrame.LookVector * (Config.Wheelbase / 2)

            v535 = false

            for _, v538 in { v536, -v536 } do
                if workspace:Raycast(PrimaryPart.Position + v538 + Vector3.new(0, 2, 0), Vector3.new(-0, -6, -0, -0), v533) then
                    v535 = true
                end
            end
        else
            v535 = false
        end

        local v539 = v94.speed or 0
        local v540, v541

        if v535 and v539 > 4 then
            local v543 = math.clamp(v539 / 90, 0.55, 1)

            if v543 then
                v540 = v543
                v541 = true
            else
                v541 = false
            end
        else
            v541 = false
        end

        if not v541 then
            v540 = 0
        end

        local n37 = 0
        local n38 = 0

        if v535 and v539 > 4 then
            n37 = 0.6
            n38 = 0.6
        end

        local v544, v545, v546

        if v93 and v92 and v92.Parent then
            local v547, v548

            if v92:GetAttribute("TyreMarkSound") == true then
                v547 = math.max(v540, 0.9)
                v548 = math.max(n38, 0.75)
                n37 = v548
            else
                v548 = n38
                v547 = v540
            end

            local surface = v94.surface
            local v549, v550

            if v539 > 3 and (surface == "Grass" or surface == "Gravel") then
                local v551 = surface == "Gravel"
                local v552 = if v551 then math.clamp(0.65 + v539 / 150, 0.65, 1) else nil

                if not v551 or not v552 then
                    v552 = math.clamp(0.45 + v539 / 220, 0.45, 0.9)
                end

                v549 = math.max(v547, v552)
                v550 = math.max(v548, if surface == "Gravel" then 1 else 0.8)
                n37 = v550
            else
                v550 = v548
                v549 = v547
            end

            local v556 = v119
            local v557, v558

            if v556 then
                local smoothBrake = v556.smoothBrake

                if smoothBrake then
                    v557 = smoothBrake
                    v558 = true
                else
                    local brake = v556.brake

                    if brake then
                        v557 = brake
                        v558 = true
                    else
                        v558 = false
                    end
                end
            else
                v558 = false
            end

            if not v558 then
                v557 = 0
            end

            local v559, v560, v561

            if v556 and v557 > 0.05 and v539 > 15 then
                local v562 = BikeDynamics.FrontBrakeOver(v556.lean or 0, v557, v556.abs ~= false, v556.wet == true or MotoLegends:GetAttribute("Raining") == true, v556.ebs, v556.tyreFBrake or v556.tyreF)
                local v564 = math.clamp((v562 - 0.6) / 0.4, 0, 1)
                local v567 = math.max(0.12 + 0.16 * v557, v564 > 0 and v564 * 0.45 + 0.3 or 0)

                if v562 > 1 then
                    v561 = 1
                    v567 = 1
                else
                    v561 = 0
                end

                v559 = math.max(v549, v567)
                v560 = math.max(v550, v564 * 0.55 + 0.35)
                n37 = v560
            else
                v560 = v550
                v561 = 0
                v559 = v549
            end

            v545 = v561
            v544 = v559

            if v556 and v539 > 10 then
                local SlideHold = BikeDynamics.SlideHold
                local v572 = math.abs(v556.rearYaw or 0) / math.max(Config.RearYaw or 0.17453292519943295, 0.001)

                if SlideHold then
                    local v573 = SlideHold.Active - (SlideHold.Band or 0) or 1

                    if v573 <= v572 then
                        if math.abs(v556.lean or 0) >= SlideHold.SafeLean then
                            local v576 = math.clamp((v572 - v573) / (1 - v573), 0, 1)

                            v544 = math.max(v559, v576 * 0.7 + 0.3)
                            n37 = math.max(v560, v576 * 0.5 + 0.5)
                            v546 = if (v556.slideHoldRecover or 1) < 0.5 then 1 else 0
                        else
                            v546 = 0
                        end
                    else
                        v546 = 0
                    end
                else
                    v546 = 0
                end
            else
                v546 = 0
            end
        else
            v544 = v540
            v545 = 0
            v546 = 0
        end

        if not t16.vibration then
            v544 = 0
        end

        n35 += (v544 - n35) * (1 - math.exp(-p145 * 20))

        if not v99 then
            return
        end

        local v582

        if v545 > 0 then
            v582 = if math.sin(os.clock() * 2 * 3.141592653589793 * 13) > 0 then 1 else 0.35
        elseif v546 > 0 then
            v582 = math.sin(os.clock() * 2 * 3.141592653589793 * 6) * 0.35 + 0.65

            if not v582 then
                v582 = math.sin(os.clock() * 55) * 0.2 + 0.8
            end
        else
            v582 = math.sin(os.clock() * 55) * 0.2 + 0.8
        end

        local v587 = n35 > 0.03 and math.clamp(n35 * v582, 0, 1) or 0

        if math.abs(v587 - n36) > 0.02 or v587 == 0 and n36 ~= 0 then
            local function v590() -- line: 1863
                -- upvalues: n37 (ref), v587 (copy), v99 (ref), HapticService (copy)
                HapticService:SetMotor(v99, Enum.VibrationMotor.Small, v587)

                local v592 = v99

                HapticService:SetMotor(v592, Enum.VibrationMotor.Large, v587 * math.max(n37, 0.5))
            end

            pcall(v590)
            n36 = v587
        end
    end)

    local function resize() -- line: 1869
        -- upvalues: UserInputService (copy), RaceGauge (copy), v17 (copy), v23 (copy), UIScale (copy), v27 (copy), UIScale2 (copy), v32 (copy), UIScale3 (copy), t10 (copy), UIScale4 (copy), v56 (copy), UIScale5 (copy), TextButton (copy), UIScale6 (copy), clone (copy), v61 (copy), TextButton2 (copy), clone2 (copy), t15 (copy), v80 (copy), v89 (copy), v91 (copy), v380 (ref)
        local ViewportSize = workspace.CurrentCamera.ViewportSize
        local v596 = math.min(ViewportSize.X / 737, ViewportSize.Y / 412)

        UIScale.Scale = v596
        UIScale2.Scale = v596
        UIScale5.Scale = v596 * 0.72
        UIScale6.Scale = v596
        v17.Resize(ViewportSize, v596)
        v23.Position = UDim2.fromOffset(v596 * 20, (math.max(v596 * 22, 64)))
        v27.Position = UDim2.fromOffset(ViewportSize.X - v596 * 87, v596 * 23)
        UIScale3.Scale = v596
        v32.Position = UDim2.fromOffset(ViewportSize.X - v596 * 14, v596 * 16)
        UIScale4.Scale = v596 * ((not UserInputService.TouchEnabled or UserInputService.KeyboardEnabled) and 1 or 0.7)
        t10[1] = UDim2.fromOffset(ViewportSize.X / 2, (math.max(v596 * 14, 58)))
        v56.Position = UDim2.fromOffset(ViewportSize.X - (RaceGauge.Width * 0.72 + 14) * v596, ViewportSize.Y - (RaceGauge.Height * 0.72 + 12) * v596)
        TextButton.Position = UDim2.fromOffset(v596 * 20, ViewportSize.Y - v596 * 75)
        TextButton.Size = UDim2.fromOffset(150, 34)
        clone.UIScale.Scale = v596
        TextButton.Size = UDim2.fromOffset(128, 32)
        clone.Size = UDim2.fromOffset(32, 32)
        clone.Position = UDim2.fromOffset(ViewportSize.X - (RaceGauge.Width * 0.72 + 58) * v596, ViewportSize.Y - (RaceGauge.Height * 0.72 / 2 + 28) * v596)

        local v602 = v61:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", v61)

        v602.Scale = math.min(1, (ViewportSize.Y - 16) / v61.Size.Y.Offset)
        v61.Position = UDim2.fromOffset(ViewportSize.X / 2 - 120 * v602.Scale, (math.max(8, (ViewportSize.Y - v61.Size.Y.Offset * v602.Scale) / 2)))

        local gfxPanel = t15.gfxPanel
        local v606 = gfxPanel:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", gfxPanel)

        v606.Scale = math.min(1, (ViewportSize.Y - 16) / gfxPanel.Size.Y.Offset)
        gfxPanel.Position = UDim2.fromOffset(ViewportSize.X / 2 - 120 * v606.Scale, (math.max(8, (ViewportSize.Y - gfxPanel.Size.Y.Offset * v606.Scale) / 2)))

        local v610 = v80:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", v80)

        v610.Scale = math.min(1, (ViewportSize.X - 16) / 440, (ViewportSize.Y - 16) / 360)
        v80.Position = UDim2.fromOffset((ViewportSize.X - 440 * v610.Scale) / 2, (math.max(8, (ViewportSize.Y - 360 * v610.Scale) / 2)))
        v89.Position = UDim2.fromOffset(ViewportSize.X / 2 - 175, ViewportSize.Y / 2 - 111)
        v91.Position = UDim2.fromOffset(ViewportSize.X / 2 - 230, ViewportSize.Y * 0.22)

        if UserInputService.TouchEnabled then
            local v617 = math.min(ViewportSize.Y / 1125, ViewportSize.X / 2000)

            v56.Position = UDim2.fromOffset(ViewportSize.X / 2 - RaceGauge.Width / 2 * 0.72 * v596, ViewportSize.Y - v617 * 125 - RaceGauge.Height * 0.8317757009345794 * 0.72 * v596)
            clone.Size = UDim2.fromOffset(48 / v596, 48 / v596)
            clone.TextSize = 26 / v596
            clone.Position = UDim2.fromOffset(ViewportSize.X / 2 - (RaceGauge.Width / 2 * 0.72 * v596 + 58), ViewportSize.Y - v596 * 90)
            v380(ViewportSize, v596)
            v61.ScrollingEnabled = true
            v61.ScrollBarThickness = 5
            v61.CanvasSize = UDim2.fromOffset(0, 494)
            TextButton2.Size = UDim2.fromOffset(216, 44)
            TextButton2.TextSize = 14
            v61.CanvasSize = UDim2.fromOffset(0, 318)

            for v618, v619 in {
                    t15.absButton,
                    clone2,
                    t15.gfxButton,
                    t15.afkButton,
                    t15.ctrlButton
                } do
                v619.Position = UDim2.fromOffset(12, 88 + (v618 - 1) * 58)
                v619.Size = UDim2.fromOffset(216, 48)
                v619.TextSize = 14
            end

            v61.CanvasSize = UDim2.fromOffset(0, 376)
        end
    end

    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
    resize()
    ScreenGui:GetAttributeChangedSignal("MobileHudLayout"):Connect(function() -- line: 1908
        -- upvalues: t15 (copy), resize (copy)
        resize()

        if t15.ready then
            t15.send()
        end
    end)
    ScreenGui:GetAttributeChangedSignal("MobileHudPreview"):Connect(resize)
    ScreenGui:GetAttributeChangedSignal("MobileHudEditing"):Connect(resize)
    ScreenGui:GetAttributeChangedSignal("MobileControlType"):Connect(function() -- line: 1911
        -- upvalues: t15 (copy), resize (copy)
        resize()

        if t15.ready then
            t15.send()
        end
    end)
    ContextActionService:UnbindAction("RacePlayerList")

    local function v620() -- line: 1913
        -- upvalues: StarterGui (copy)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
    end

    pcall(v620)

    for _, child in ScreenGui:GetChildren() do
        if child:IsA("GuiObject") and child ~= TextButton then
            child.Visible = false
        end
    end

    local v621, v622

    local function updateGridJumpLock() -- line: 1916
        -- upvalues: ContextActionService (copy), LocalPlayer (copy), v621 (ref), v622 (ref)
        local v623 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if LocalPlayer:GetAttribute("RaceGridLocked") then
            ContextActionService:BindActionAtPriority("GridJumpLock", function() -- line: 1919
                return Enum.ContextActionResult.Sink
            end, false, 4000, Enum.KeyCode.Space, Enum.KeyCode.ButtonL3, Enum.KeyCode.ButtonA)

            if v623 then
                if v621 ~= v623 then
                    v621 = v623
                    v622 = v623:GetStateEnabled(Enum.HumanoidStateType.Jumping)
                end

                v623.Jump = false
                v623:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
            end
        else
            ContextActionService:UnbindAction("GridJumpLock")

            if v621 and v621.Parent then
                local v624 = v621

                v624:SetStateEnabled(Enum.HumanoidStateType.Jumping, v622 ~= false)
            end

            v621 = nil
            v622 = nil
        end
    end

    LocalPlayer:GetAttributeChangedSignal("RaceGridLocked"):Connect(updateGridJumpLock)
    LocalPlayer.CharacterAdded:Connect(function() -- line: 1931
        -- upvalues: updateGridJumpLock (copy)
        task.defer(updateGridJumpLock)
    end)
    updateGridJumpLock()

    local t78 = {}

    RunService.Heartbeat:Connect(function(p146) -- line: 1934
        -- upvalues: LocalPlayer (copy), t15 (copy), v93 (ref), v125 (ref), t34 (ref), v126 (ref), Humanoid (ref), v127 (ref)
        local Character = LocalPlayer.Character

        t15.poseGuard = (t15.poseGuard or 0) + p146

        if v93 and Character and t15.poseGuard > 0.25 then
            t15.poseGuard = 0

            local Animate = Character:FindFirstChild("Animate")

            if Animate and Animate.Enabled then
                Animate.Enabled = false
                v125 = v125 or Animate
            end

            local v625 = Character:FindFirstChildWhichIsA("Animator", true)

            if v625 then
                for _, v626 in v625:GetPlayingAnimationTracks() do
                    v626:Stop(0.1)
                end
            end
        end

        if not (Character and Character:GetAttribute("RaceCrashActive")) then
            if Humanoid then
                if Humanoid.Parent then
                    Humanoid.EvaluateStateMachine = v127
                end

                Humanoid = nil
                v127 = nil
            end
        else
            local Humanoid2 = Character:FindFirstChildOfClass("Humanoid")

            if Humanoid2 then
                if Humanoid ~= Humanoid2 then
                    Humanoid = Humanoid2
                    v127 = Character:GetAttribute("RaceCrashEvaluationOriginal") ~= false
                end

                Humanoid2.EvaluateStateMachine = false
            end
        end

        if Character and not v93 and not Character:GetAttribute("RaceCrashActive") and next(t34) then
            for v627 in t34 do
                if v627.Parent then
                    v627.Transform = CFrame.identity
                end
            end

            t34 = {}

            if v126 and v126.Parent then
                v126.Enabled = true
            end

            v126 = nil
        end
    end)
    RunService:BindToRenderStep("JerezRiderCamera", Enum.RenderPriority.Camera.Value + 1, function(p147) -- line: 1959
        -- upvalues: UserInputService (copy), v2 (ref), v3 (ref), v5 (copy), ReplicatedStorage (copy), LocalPlayer (copy), MotoLegends (copy), Config (copy), GamepadControls (copy), t4 (ref), BikeSuspension (copy), ScreenGui (copy), v17 (copy), v18 (copy), v19 (copy), v20 (copy), v21 (copy), v23 (copy), v25 (copy), v26 (copy), v27 (copy), v28 (copy), v29 (copy), v31 (copy), t5 (copy), t6 (copy), v32 (copy), v33 (copy), t7 (copy), v34 (copy), v35 (copy), t8 (copy), v37 (copy), v39 (copy), v40 (copy), v42 (copy), TweenService (copy), v43 (copy), v44 (copy), v45 (copy), v46 (copy), t9 (copy), showDelta (copy), CanvasGroup (copy), v55 (copy), v56 (copy), v57 (copy), v58 (copy), TextButton (copy), clone (copy), v60 (ref), v61 (copy), TextButton2 (copy), t12 (copy), t13 (copy), t15 (copy), t16 (copy), t19 (copy), v80 (copy), v89 (copy), v91 (copy), n5 (ref), v92 (ref), v93 (ref), v94 (ref), t22 (ref), v96 (ref), t23 (ref), v97 (ref), n6 (ref), n7 (ref), v109 (ref), v110 (ref), v111 (ref), v112 (ref), v113 (ref), n8 (ref), v114 (ref), t24 (copy), v115 (ref), n9 (ref), n10 (ref), t25 (ref), FieldOfView (copy), Unit (ref), Attribute (ref), Position (ref), Unit2 (ref), v118 (ref), t28 (ref), v119 (ref), cancelInputs (copy), v124 (ref), n15 (ref), t31 (ref), n16 (ref), t32 (copy), t33 (copy), n17 (ref), n18 (ref), n19 (ref), n20 (ref), v128 (ref), fpEye (copy), t36 (copy), n23 (ref), followCrashBike (copy), pose (copy), timeString (copy), v379 (copy), v532 (ref), t78 (copy), v1 (copy)
        if v5() then
            cancelInputs()
        end

        local Character = LocalPlayer.Character
        local v629 = Character and Character:FindFirstChildOfClass("Humanoid")
        local v630 = v629 and v629.SeatPart
        local v631 = not not (v92 and v92.Parent and v630 and v630:IsDescendantOf(v92) and v92:GetAttribute("Crash") == "")
        local v632

        if v631 ~= v93 then
            v93 = v631
            pose(v93)
            v124 = false
            v111 = false
            v113 = false
            n7 = 0
            v119 = nil
            t22 = {}
            v96 = GamepadControls.New()
            t23 = {
                throttle = 0,
                brake = 0,
                steer = 0
            }

            local RaceControl

            if v93 then
                t24[1] = 0
                v115 = Config.ChaseCameraPitch
                Unit = nil
                Attribute = nil
                Position = nil

                if LocalPlayer:GetAttribute("RaceGridLocked") then
                    t32[1] = 0.55
                    t33[1] = 0
                    n19 = 0
                end

                if not LocalPlayer:GetAttribute("RaceGridLocked") then
                    RaceControl = MotoLegends.RaceControl
                    v632 = v92
                    RaceControl:FireServer("Mounted", v632)
                end
            end

            if not v93 then
                v112 = false
                RaceControl = v94
                RaceControl.rhd = false
                n16 = 0
                t32[1] = 0
                t33[1] = 0
                n19 = 0
                n17 = 0
                v630 = workspace.CurrentCamera

                if Character and Character:GetAttribute("RaceCrashActive") == true then
                    followCrashBike()
                else
                    v630.CameraType = Enum.CameraType.Custom

                    if v629 then
                        v630.CameraSubject = v629
                    end

                    v630.FieldOfView = FieldOfView
                    Unit = nil
                    Attribute = nil
                end

                Position = nil
                Unit2 = nil
                v119 = nil
                v124 = false
            end
        end

        TextButton.Visible = false

        local v633 = if not (v629 and v629.PlatformStand) then "Spawn bike" else "Recovering…"

        TextButton.Text = v633
        TextButton.Active = not (v629 and v629.PlatformStand)
        v631 = Character and Character:FindFirstChild("HumanoidRootPart")
        v23.Visible = false
        v27.Visible = false
        v32.Visible = v93
        v35.Visible = not ({
            Grid = true,
            Lights = true,
            Racing = true,
            RaceResults = true
        })[ReplicatedStorage.MotoLegends:GetAttribute("SessionPhase") or ""]
        v56.Visible = v93

        if not v93 then
            CanvasGroup.Visible = false
        end

        v55.Visible = false

        local v634

        if v93 then
            v17.Update(p147, t16.minimap)
        else
            v634 = ScreenGui:GetAttribute("LobbySpectating") and ScreenGui:GetAttribute("SpectateTargetId")
            v633 = v17.Update
            v632 = t16.minimap

            if v632 then
                v632 = v634 ~= nil and v634 ~= false
            end

            v633(p147, v632, v634 or nil)
        end

        clone.Visible = false

        if not v93 and not ScreenGui:GetAttribute("LobbySettings") then
            v61.Visible = false
            t15.gfxPanel.Visible = false
            v89.Visible = false
            v80.Visible = false
            v3 = false
            v2 = false
            t4 = nil
        end

        TextButton2.Text = "Transmission: " .. v60
        t15.absButton.Text = "Anti-lock Brakes: " .. (v94.abs == false and "OFF" or "ON")
        ScreenGui:SetAttribute("InputsBlocked", v5())

        local v635 = not not (UserInputService.TouchEnabled and v93 and not v5() and ScreenGui:GetAttribute("GamepadInput") ~= true) or ScreenGui:GetAttribute("MobileHudEditing") == true

        v379.Visible = v635

        local v637

        if UserInputService.TouchEnabled then
            v634 = LocalPlayer.PlayerGui:FindFirstChild("TouchGui")

            if v634 and v634:IsA("ScreenGui") then
                v634.Enabled = not v93
            end

            if v532 ~= not v93 then
                v532 = not v93

                local PlayerModule = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")

                if PlayerModule then
                    v637 = function() -- line: 2007
                        -- upvalues: PlayerModule (copy), v532 (ref)
                        local Controls = require(PlayerModule):GetControls()

                        if v532 then
                            Controls:Enable()
                        else
                            Controls:Disable()
                        end
                    end

                    pcall(v637)
                end
            end
        end

        v91.Visible = v93 and os.clock() < n5
        v25.Text = tostring(v94.lap or 1)
        v634 = v94.frozen

        local v639

        if v634 then
            v639 = v634
        else
            local v640 = false

            if v94.start and v94.start > 0 then
                v634 = workspace:GetServerTimeNow() - v94.start

                if v634 then
                    v639 = v634
                    v640 = true
                end
            end

            if not v640 then
                v639 = 0
            end
        end

        local format, v641, v642, v643

        if v639 == 0 then
            v637 = "00:00.000"
        else
            local v644 = if v639 then v639 <= 0 else nil

            if not v639 or v644 then
                v637 = "--:--.---"
            else
                format = v639 * 1000
                v632 = math.floor(format)
                format = string.format
                v641 = v632 / 60000
                v642 = math.floor(v641)
                v643 = v632 / 1000
                v637 = format("%02d:%02d.%03d", v642, math.floor(v643) % 60, v632 % 1000)
            end
        end

        v28.Text = v637

        local v645 = if ReplicatedStorage.MotoLegends:GetAttribute("SessionPhase") == "Qualifying" and v94.valid == false and v21 then v21 else v19

        v28.TextColor3 = v645

        if v94.gate == 1 then
            v639 = if v94.armed then 4 else 1
        else
            v645 = (v94.gate or 2) - 1
            v639 = math.max(1, v645)
        end

        v635 = v94.frozenSector

        local v646

        if v635 then
            v646 = v635
        else
            local v647 = false

            if v94.sectorStart and v94.sectorStart > 0 then
                v635 = workspace:GetServerTimeNow() - v94.sectorStart

                if v635 then
                    v646 = v635
                    v647 = true
                end
            end

            if not v647 then
                v646 = 0
            end
        end

        local v648, v649, v650, ok

        if v646 == 0 then
            v641 = "00:00.000"
        else
            local v651 = if v646 then v646 <= 0 else nil

            if not v646 or v651 then
                v641 = "--:--.---"
            else
                v643 = v646 * 1000
                v648 = math.floor(v643)
                v643 = string.format
                v649 = v648 / 60000
                v650 = math.floor(v649)
                ok = v648 / 1000
                v641 = v643("%02d:%02d.%03d", v650, math.floor(ok) % 60, v648 % 1000)
            end
        end

        v26.Text = "S" .. v639 .. " · " .. v641

        for v652, v653 in t6 do
            if v94.sectorTimes then
                v641 = v94.sectorTimes[v652]

                if not v641 then
                    v641 = v94
                    v641 = v641.history

                    if v641 then
                        v648 = v94
                        v641 = v648.history[1]

                        if v641 then
                            v648 = v94
                            v641 = v648.history[1].sectors

                            if v641 then
                                v643 = v94
                                v641 = v643.history[1].sectors[v652]
                            end
                        end
                    end
                end
            else
                v641 = v94
                v641 = v641.history

                if v641 then
                    v648 = v94
                    v641 = v648.history[1]

                    if v641 then
                        v648 = v94
                        v641 = v648.history[1].sectors

                        if v641 then
                            v643 = v94
                            v641 = v643.history[1].sectors[v652]
                        end
                    end
                end
            end

            v653.Text = "S" .. v652 .. "  " .. (v641 and string.format("%.3f", v641) or "--.---")
            v648 = v94.sectorBests and v94.sectorBests[v652]
            v653.TextColor3 = v641 and v648 and v641 <= v648 + 0.005 and v20 or v19
        end

        format = v94.best

        local v654

        if not format or format <= 0 then
            v632 = "--:--.---"
        else
            v642 = format * 1000
            v654 = math.floor(v642)
            v642 = string.format
            v643 = v654 / 60000
            v648 = math.floor(v643)
            v650 = v654 / 1000
            v632 = v642("%02d:%02d.%03d", v648, math.floor(v650) % 60, v654 % 1000)
        end

        v29.Text = v632
        format = v94.previous

        if not format or format <= 0 then
            v632 = "--:--.---"
        else
            v642 = format * 1000
            v654 = math.floor(v642)
            v642 = string.format
            v643 = v654 / 60000
            v648 = math.floor(v643)
            v650 = v654 / 1000
            v632 = v642("%02d:%02d.%03d", v648, math.floor(v650) % 60, v654 % 1000)
        end

        v31.Text = v632
        v33.Text = v28.Text

        local v655, v656

        if (v94.best or 0) > 0 then
            format = v94.best

            if not format or format <= 0 then
                v655 = "--:--.---"
                v656 = true
            else
                v642 = format * 1000
                v654 = math.floor(v642)
                v642 = string.format
                v643 = v654 / 60000
                v648 = math.floor(v643)
                v650 = v654 / 1000
                v632 = v642("%02d:%02d.%03d", v648, math.floor(v650) % 60, v654 % 1000)

                if v632 then
                    v655 = v632
                    v656 = true
                else
                    v656 = false
                end
            end
        else
            v656 = false
        end

        if not v656 then
            v655 = "--:--.---"
        end

        v39.Text = v655

        local v657, v658

        if (v94.previous or 0) > 0 then
            format = v94.previous

            if not format or format <= 0 then
                v657 = "--:--.---"
                v658 = true
            else
                v642 = format * 1000
                v654 = math.floor(v642)
                v642 = string.format
                v643 = v654 / 60000
                v648 = math.floor(v643)
                v650 = v654 / 1000
                v655 = v642("%02d:%02d.%03d", v648, math.floor(v650) % 60, v654 % 1000)

                if v655 then
                    v657 = v655
                    v658 = true
                else
                    v658 = false
                end
            end
        else
            v658 = false
        end

        if not v658 then
            v657 = "--:--.---"
        end

        v40.Text = v657
        v645 = (v94.start or 0) > 0
        v657 = v94.history or {}
        format = v657[1]

        if format then
            v641 = format.lap
            v642 = tostring(v641)
            v643 = format.time
            v654 = v642 .. ":" .. tostring(v643)
        else
            v654 = format
        end

        if #v657 == 0 and (v94.best or 0) == 0 then
            t9.refSectors = nil
            t9.bestSeen = 0
            t9.histKey = nil
        end

        if v654 and v654 ~= t9.histKey then
            if t9.histKey ~= nil and format.time and format.time > 0 and t9.bestSeen > 0 then
                showDelta(format.time - t9.bestSeen)
            end

            t9.histKey = v654

            if format.time and format.time > 0 and (t9.bestSeen <= 0 or format.time <= t9.bestSeen + 5E-04) and format.sectors and #format.sectors >= 4 then
                t9.refSectors = table.clone(format.sectors)
            end

            if format.time and format.time > 0 and (t9.bestSeen <= 0 or format.time < t9.bestSeen) then
                t9.bestSeen = format.time
            end
        end

        if t9.bestSeen <= 0 and (v94.best or 0) > 0 then
            t9.bestSeen = v94.best
        end

        local n39 = 0

        if v645 then
            v642 = v639 - 1
            n39 = math.clamp(v642, 0, 3) or 0
        end

        if n39 < t9.seen then
            t9.seen = n39
        end

        if t9.seen < n39 then
            t9.seen = n39
            format = t9.refSectors
            v657 = v94.sectorTimes

            if format and v657 then
                v642 = 0
                v641 = 0
                v648 = true

                for i = 1, n39 do
                    if not (v657[i] and format[i]) then
                        v648 = false
                        break
                    end

                    v642 += v657[i]
                    v641 += format[i]
                end

                if v648 then
                    showDelta(v642 - v641)
                end
            end
        end

        if t9.shown and os.clock() >= t9.untilT and t9.shown then
            t9.shown = false
            v42.Position = v44
            TweenService:Create(v42, v46, {
                Position = v43
            }):Play()
            v33.Position = v45
            TweenService:Create(v33, v46, {
                Position = v44
            }):Play()
        end

        format = ReplicatedStorage.MotoLegends:GetAttribute("SessionPhase") == "Qualifying" and v645 and v94.valid == false
        v37.Visible = format
        v657 = t15.secHold
        format = v94.history and v94.history[1]

        if format then
            v641 = format.lap
            v642 = tostring(v641)
            v643 = format.time
            n39 = v642 .. ":" .. tostring(v643)
        else
            n39 = format
        end

        if n39 and n39 ~= v657.key then
            if v657.key ~= nil and format.sectors then
                v657.sectors = format.sectors
                v657.untilT = os.clock() + 4
            end

            v657.key = n39
        end

        if v657.untilT ~= nil then
            v657.active = os.clock() < v657.untilT
        else
            v657.active = false
        end

        local Attribute2, v659

        for v660, v661 in t7 do
            v648 = Color3.fromRGB(95, 97, 102)
            v643 = Color3.fromRGB(150, 152, 156)
            v659 = v645 and v660 < v639 and v94.sectorTimes and v94.sectorTimes[v660]

            if t15.secHold.active then
                v659 = t15.secHold.sectors[v660]
            end

            if v659 and v659 > 0 then
                v650 = 1e999

                for _, player in game:GetService("Players"):GetPlayers() do
                    Attribute2 = player:GetAttribute("BestSector" .. v660)

                    if Attribute2 and Attribute2 > 0 and Attribute2 < v650 then
                        v650 = Attribute2
                    end
                end

                v649 = v94.sectorBests and v94.sectorBests[v660]
                v648 = if v659 <= v650 + 5E-04 then Color3.fromRGB(236, 30, 58) elseif v649 and v659 <= v649 + 5E-04 then Color3.fromRGB(255, 140, 38) else Color3.fromRGB(242, 242, 242)
                v643 = v648
            end

            v661.BackgroundColor3 = v648
            v650 = t8[v660]
            v650.Text = v659 and v659 > 0 and string.format("%.3f", v659) or "--.---"
            t8[v660].TextColor3 = v643
        end

        local v662 = v94.sectorBests and v94.sectorBests[v639] or 25
        local n40 = 0

        if v645 then
            n39 = v646 / math.max(v662, 1)
            n40 = math.clamp(n39, 0, 1) or 0
        end

        v34.Position = UDim2.fromOffset(82 + (v639 - 1) * 17 + n40 * 15, 25)
        v34.Visible = v645 and not t15.secHold.active

        for v663, v664 in t5 do
            n40 = v94.history and v94.history[v663]
            v664.Text = n40 and string.format("%d  %s", n40.lap, timeString(n40.time)) or "—  --:--.---"
        end

        n39 = n15
        v641 = (v93 and v94.speed or 0) - n15
        v659 = -p147 * 12
        n15 = n39 + v641 * (1 - math.exp(v659))
        v57.rhd = v93 and v112
        v641 = v93

        local v665 = false
        local v666 = false
        local v667 = false
        local v668 = false

        if v641 then
            v665 = true
        end

        local v669

        if v665 then
            v669 = {}

            if t22[Enum.KeyCode.W] then
                v667 = true
            else
                v666 = true
            end
        end

        v665 = false

        local v670

        if v666 then
            v670 = 0
            v665 = true
        end

        v666 = false

        if v667 then
            v670 = 1
            v665 = true
        end

        v667 = false

        if v665 then
            v643 = v96.throttle
            v659 = t23.throttle
            v669.throttle = math.max(v670, v643, v659)

            if t22[Enum.KeyCode.S] then
                v666 = true
            else
                v667 = true
            end
        end

        v665 = false

        local v671

        if v667 then
            v671 = 0
            v665 = true
        end

        v667 = false

        if v666 then
            v671 = 1
            v665 = true
        end

        v666 = false

        if v665 then
            v643 = v96.brake
            v659 = t23.brake
            v669.brake = math.max(v671, v643, v659)

            if t22[Enum.KeyCode.LeftShift] then
                v667 = true
            else
                v666 = true
            end
        end

        v665 = false

        if v666 then
            if t22[Enum.KeyCode.RightShift] then
                v667 = true
            else
                v665 = true
            end
        end

        v666 = false

        local v672

        if v665 then
            v672 = 0
            v666 = true
        end

        if v667 then
            v672 = 1
            v666 = true
        end

        local v673

        if v666 then
            v643 = v96.rearBrake or 0
            v659 = t23.rearBrake or 0
            v669.rearBrake = math.max(v672, v643, v659)

            if v669 then
                v673 = v669
                v668 = true
            else
                v668 = false
            end
        end

        v57.input = if not v668 then nil else v673
        v57.Update(p147, v94, n15)
        v58.TextColor3 = v112 and v20 or Color3.fromRGB(139, 156, 168)
        v58.Text = v112 and "RHD ON" or "RHD"

        for _, v675 in { "tcs", "aw", "ebs" } do
            t12[v675] = v94[v675] or t12[v675]
            v659 = t13[v675]
            v649 = t12[v675]
            v659.Text = tostring(v649)
        end

        n39 = t19.update
        v641 = v93 and v94.speed or 0

        local v676, v677

        if v93 and v92 then
            v672 = v92.PrimaryPart

            if v672 then
                v676 = v672
                v677 = true
            else
                v677 = false
            end
        else
            v677 = false
        end

        if not v677 then
            v676 = nil
        end

        n39(p147, v641, v676)

        local Players, v678, v679, Unit3, v680, result, Unit4, v681, v682, v683

        if v118 and v631 and Character and Character:GetAttribute("RaceCrashActive") then
            v662 = workspace.CurrentCamera
            v683 = v631.AssemblyLinearVelocity.X
            Unit3 = v631.AssemblyLinearVelocity.Z
            n39 = Vector3.new(v683, 0, Unit3)
            v646 = t28.heading

            if not v646 then
                v683 = v662.CFrame.LookVector.X
                Unit3 = v662.CFrame.LookVector.Z
                v646 = Vector3.new(v683, 0, Unit3)
            end

            if v646.Magnitude < 0.05 then
                v646 = Vector3.new(0, 0, -1)
            end

            if n39.Magnitude > 3 then
                v654 = v646.Unit
                v641 = n39.Unit
                v659 = -p147 * 2.5
                v646 = v654:Lerp(v641, 1 - math.exp(v659))
            end

            local v684 = v646.Magnitude > 0.05
            local Unit = if v684 then v646.Unit else nil

            if not v684 or not Unit then
                Unit = Vector3.new(0, 0, -1)
            end

            n39 = t28
            n39.heading = Unit
            n39 = t28.followPos

            if n39 then
                v678 = t28.followPos
                v641 = v631.Position
                v659 = -p147 * 10
                v678 = v678:Lerp(v641, 1 - math.exp(v659))
            end

            if not n39 or not v678 then
                v678 = v631.Position
            end

            n39 = t28
            n39.followPos = v678
            v639 = v678 - Unit * 15 + Vector3.new(0, 7, 0)
            Unit = t28.camPos

            if Unit then
                v679 = t28.camPos
                v659 = -p147 * 5
                v679 = v679:Lerp(v639, 1 - math.exp(v659))
            end

            if Unit and v679 then
                v639 = v679
            end

            for _, v685 in { "RaceBikes", "CrashedBikes" } do
                v659 = workspace:FindFirstChild(v685)
                v646 = v639

                for _, v686 in v659 and v659:GetChildren() or {} do
                    result = v686:IsA("Model") and v686.PrimaryPart

                    if result and (result.Position - v646).Magnitude < 16 then
                        v681, Attribute2 = v686:GetBoundingBox()
                        v682 = Attribute2 * 0.5 + Vector3.new(1.3, 1.3, 1.3)

                        local v687 = v646.X
                        local v688 = v681.Position.Y
                        local v689 = v646.Z
                        local RearTyre = v681:PointToObjectSpace((Vector3.new(v687, v688, v689)))
                        local v690 = RearTyre.X

                        if math.abs(v690) < v682.X then
                            v690 = RearTyre.Y

                            if math.abs(v690) < v682.Y then
                                v690 = RearTyre.Z

                                if math.abs(v690) < v682.Z then
                                    v687 = v681.Position.Y

                                    local v691 = v687 + math.abs(v681.RightVector.Y) * v682.X

                                    v689 = v681.UpVector.Y
                                    v690 = v691 + math.abs(v689) * v682.Y
                                    v688 = v681.LookVector.Y
                                    RearTyre = v690 + math.abs(v688) * v682.Z
                                    v691 = v646.X
                                    v688 = v646.Y
                                    v689 = RearTyre + 0.3
                                    v687 = math.max(v688, v689)
                                    v688 = v646.Z
                                    v646 = Vector3.new(v691, v687, v688)
                                end
                            end
                        end
                    end

                    v639 = v646
                end
            end

            v683 = v639.X
            v643 = v639.Y
            v659 = v678.Y
            v641 = math.max(v643, v659) + 6
            Unit3 = v639.Z
            v679 = Vector3.new(v683, v641, Unit3)
            v683 = t28.groundParams and workspace:Raycast(v679, Vector3.new(0, 1, 0) * -(v679.Y - v639.Y + 16), t28.groundParams)

            if v683 and v683.Normal.Y > 0.35 and v639.Y < v683.Position.Y + 1.5 then
                Unit3 = v639.X
                v643 = v683.Position.Y + 1.5
                v659 = v639.Z
                v639 = Vector3.new(Unit3, v643, v659)
            end

            v679 = t28
            v679.camPos = v639
            v662.CameraType = Enum.CameraType.Scriptable
            v662.CFrame = CFrame.lookAt(v639, v678 + Vector3.new(0, 1.5, 0))
        else
            local Unit5 = v93
            local v692 = false
            local v693 = false
            local v694 = false
            local v695 = false
            local v696 = false

            if Unit5 then
                v692 = true
            else
                v696 = true
            end

            if v692 then
                if t16.camFixed then
                    v694 = true
                else
                    v693 = true
                end
            end

            v692 = false

            if v693 then
                if n8 % 3 == 0 then
                    v692 = true
                else
                    v694 = true
                end
            end

            v693 = false

            if v694 then
                t24[1] = 0
                v115 = Config.ChaseCameraPitch
                n9 = 1
                t15.zoomTarget = nil
                v114 = false
                v696 = false
            end

            v694 = false

            if v692 then
                v669 = t15.zoomTarget or 1
                v641 = Config.ChaseMinZoom or 0.98
                v676 = Config.ChaseMaxZoom or 1.15
                v679 = math.clamp(v669, v641, v676)
                v669 = n9
                v676 = v679 - n9
                v650 = -p147 * 8
                n9 = v669 + v676 * (1 - math.exp(v650))
                v641 = v679 - n9

                if math.abs(v641) < 1E-04 then
                    v694 = true
                else
                    v693 = true
                end
            end

            v692 = false

            if v694 then
                n9 = v679
                v693 = true
            end

            v694 = false

            if v693 then
                t24[1] -= v96.cameraX * p147 * 2.2
                v641 = v115 - v96.cameraY * p147 * 1.2
                v115 = math.clamp(v641, -0.12, 1.1)
                v641 = v96.cameraX or 0

                if math.abs(v641) > 0.08 then
                    v678 = true
                    v692 = true
                else
                    v694 = true
                end
            end

            v693 = false

            if v694 then
                v641 = v96.cameraY or 0

                if math.abs(v641) > 0.08 then
                    v695 = true
                else
                    v693 = true
                end
            end

            if v693 then
                v678 = false
                v692 = true
            end

            v693 = false

            if v695 then
                v678 = true
                v692 = true
            end

            v695 = false

            if v692 then
                v669 = t15.touchLooking

                if v669 then
                    v695 = true
                else
                    v683 = v669
                    v693 = true
                end
            end

            if v695 then
                v683 = t15.touchLooking()
                v693 = true
            end

            v695 = false

            if v693 then
                if v114 then
                    v696 = false
                else
                    v695 = true
                end
            end

            v693 = false

            if v695 then
                if v678 then
                    v696 = false
                else
                    v693 = true
                end
            end

            v695 = false

            if v693 then
                if v683 then
                    v696 = false
                else
                    v695 = true
                end
            end

            v693 = false

            if v695 then
                t24[1] = (t24[1] + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                v643 = -p147 * (Config.ChaseRecenterRate or 3.5)
                v641 = 1 - math.exp(v643)
                t24[1] += (0 - t24[1]) * v641
                v115 += (Config.ChaseCameraPitch - v115) * v641
                v643 = t24[1]

                if math.abs(v643) < 0.001 then
                    v693 = true
                else
                    v696 = false
                end
            end

            if v693 then
                v696 = false
                t24[1] = 0
            end

            if not v696 then
                v678 = v92.PrimaryPart
                v683 = v678.CFrame
                v676 = v683.LookVector.X
                v659 = v683.LookVector.Z
                v641 = Vector3.new(v676, 0, v659)
                Unit3 = v641.Magnitude > 0.05 and v641.Unit or Unit2 or Vector3.new(0, 0, -1)
                v676 = workspace.CurrentCamera
                v676.CameraType = Enum.CameraType.Scriptable
                v676.Focus = CFrame.new(v678.Position + Vector3.new(0, 1.5, 0))
                v650 = v683.RightVector.Y
                v659 = math.clamp(v650, -1, 1)
                v643 = math.asin(v659)
                v659 = n20
                v649 = v643 - n20
                n20 = v659 + v649 * (1 - math.exp(-p147 * 9))
                v659 = (v94.speed or 0) / Config.TopSpeedKph
                v643 = math.clamp(v659, 0, 1)
                v643 = v643 * v643 * (3 - v643 * 2)
                v649 = (v94.speed or 0) - (Config.ChaseFOVFromKph or 0)
                v650 = v649 / math.max(1, (Config.ChaseFOVFullKph or Config.TopSpeedKph) - (Config.ChaseFOVFromKph or 0))
                v659 = math.clamp(v650, 0, 1)
                v659 = v659 * v659 * (3 - v659 * 2)

                local v701 = n8 == 1

                if v701 then
                    v649 = Config.FirstPersonFOVScale
                    ok = 80 * n9 + v643 * 10
                    v680 = v649 * math.clamp(ok, 55, 100)
                end

                if not v701 or not v680 then
                    v680 = Config.ChaseBaseFOV + v659 * Config.ChaseSpeedFOV
                end

                v649 = v128
                ok = v680 - v128
                Attribute2 = -p147 * 4
                v128 = v649 + ok * (1 - math.exp(Attribute2))
                v676.FieldOfView = v128

                local v700 = v128

                ScreenGui:SetAttribute("SpeedFov", v700)
                Players = v94.speed or 0
                v649 = Players / math.max(Config.ChasePitchFullKph or 250, 1)
                v680 = math.clamp(v649, 0, 1)
                v680 = v680 * v680 * (3 - v680 * 2)
                v649 = Config.ChasePitchSlowDeg or 0
                Players = Config.ChasePitchFastDeg or 0
                v700 = if t22[Enum.KeyCode.S] then 1 else 0

                local v702 = v96.brake or 0

                Attribute2 = t23.brake or 0
                ok = math.max(v700, v702, Attribute2)

                local v703 = t22[Enum.KeyCode.LeftShift]

                if not v703 then
                    v703 = t22[Enum.KeyCode.RightShift]
                end

                v700 = if v703 then 1 else 0
                v702 = v96.rearBrake or 0
                Attribute2 = t23.rearBrake or 0
                Attribute2 = ok + math.max(v700, v702, Attribute2) * 0.5
                v700 = math.clamp(Attribute2, 0, 1) * math.clamp(((v94.speed or 0) - 20) / 20, 0, 1)
                v702 = n23

                local v704 = v700 - n23
                local v705 = -p147
                local ChaseBrakeTiltIn = if n23 < v700 then Config.ChaseBrakeTiltIn or 2.5 else Config.ChaseBrakeTiltOut or 1.5

                n23 = v702 + v704 * (1 - math.exp(v705 * ChaseBrakeTiltIn))
                v700 = n23 * n23 * (3 - n23 * 2)
                Attribute2 = -v649 + (v649 + Players) * v680 - (Config.ChaseBrakeTiltDeg or 0) * v700

                local v708 = math.rad(Attribute2)

                v702 = t36[1]
                v704 = v708 - t36[1]

                local v706 = -p147 * 3

                t36[1] = v702 + v704 * (1 - math.exp(v706))

                if t16.camFixed then
                    t36[1] = 0
                end

                v702 = Position

                if v702 then
                    result = v678.Position - Position
                end

                if not v702 or not result then
                    result = Vector3.new(0, 0, 0)
                end

                Position = v678.Position

                if result.Magnitude > 100 then
                    Unit = nil
                    Attribute = nil
                    Unit2 = nil
                end

                if Unit2 and Unit and Unit2:Dot(Unit3) > 0.3 then
                    v702 = Unit2
                    v706 = -p147 * 18
                    v702 = v702:Lerp(Unit3, 1 - math.exp(v706))
                    Unit4 = v702.Magnitude > 0.05 and v702.Unit or Unit3
                    Unit2 = Unit4
                else
                    Unit2 = Unit3
                end

                t15.camAnchorY = v678.Position.Y

                local v710 = n8 % 3 == 0
                local Z

                if v710 then
                    Attribute2 = v678.Position.X
                    v704 = t15.camAnchorY
                    Z = v678.Position.Z
                    v681 = Vector3.new(Attribute2, v704, Z)
                end

                if not v710 or not v681 then
                    v681 = v678.Position
                end

                v702 = CFrame.lookAt(v681, v681 + Unit2)
                v680 = n10 * 3.141592653589793
                v659 = v702 * CFrame.Angles(0, t24[1] * (1 - n10) + v680, 0)

                local v711, new, v712, v713, v714, v715

                if n8 % 3 == 0 then
                    new = Config.ChaseDistance
                    ChaseBrakeTiltIn = (v94.speed or 0) / 220
                    v682 = (new + math.clamp(ChaseBrakeTiltIn, 0, 1) * Config.ChaseSpeedDistance) * n9
                    v715 = if n8 == 3 then Config.HighChaseDistanceScale or 1.15 else 1
                    v680 = v682 * v715
                    v706 = Config.ChaseBaseFOV * 0.5
                    new = math.rad(v706)
                    v715 = math.tan(new)
                    v711 = v128
                    v705 = math.max(v711, 1) * 0.5
                    v706 = math.rad(v705)
                    v682 = v715 / math.tan(v706)
                    v680 *= 1 + (math.min(v682, 1) - 1) * (Config.ChaseFOVKeepSize or 0)
                    v682 = if t16.camFixed then 0 else -n20 * Config.CameraSway
                    new = CFrame.new

                    local v716 = v115
                    local v717 = false

                    if n8 == 3 then
                        local rad = math.rad(Config.HighChasePitchDeg or 14)

                        if rad then
                            v712 = rad
                            v717 = true
                        end
                    end

                    if not v717 then
                        v712 = 0
                    end

                    v713 = v716 + v712
                    Unit4 = (v659 * new(0, 1.8 + math.tan(v713) * (v680 + 6), v680)).Position + v702.RightVector * v682
                    Attribute2 = v681 + v659.LookVector * 6 + Vector3.new(0, 1.8, 0) + v702.RightVector * v682
                    v714 = Unit2:Dot(Unit3)
                    v711 = math.clamp(v714, -1, 1)
                    ChaseBrakeTiltIn = math.acos(v711)
                    ScreenGui:SetAttribute("CameraFacingError", (math.deg(ChaseBrakeTiltIn)))
                    ScreenGui:SetAttribute("CameraSideShift", v682)
                    ScreenGui:SetAttribute("CameraDistance", v680)
                    ChaseBrakeTiltIn = v115
                    ScreenGui:SetAttribute("CameraOrbitPitchDegrees", (math.deg(ChaseBrakeTiltIn)))
                else
                    v682 = Character and Character:FindFirstChild("Head")

                    local v719 = false

                    if v682 and v682:IsA("BasePart") then
                        Z = (v682.CFrame * CFrame.new(0, 0.12, -0.3)).Position

                        if Z then
                            v715 = Z
                            v719 = true
                        end
                    end

                    if not v719 then
                        v715 = fpEye(v92, v683)
                    end

                    Unit4 = v715 + v659.RightVector * (n10 * 0.28)
                    new = v115 - Config.ChaseCameraPitch
                    v715 = math.clamp(new, -0.5, 0.7)
                    Attribute2 = Unit4 + (v659 * CFrame.Angles(-v715, 0, 0)).LookVector * 30
                end

                for _, descendant in Character:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        v649 = t31[descendant] ~= nil
                        v683 = n8 == 1 and descendant:FindFirstAncestorWhichIsA("Accessory")
                        ChaseBrakeTiltIn = v683 and t15.onHead(v683) or false
                        v683 = n8 == 1 and Unit4 ~= nil and (descendant.Position - Unit4).Magnitude < descendant.Size.Magnitude * 0.5 + 0.25
                        v711 = n8 == 1 and (descendant.Name == "Head" or ChaseBrakeTiltIn or v683)
                        v714 = t25

                        if not v711 or v649 then
                            v714[descendant] = nil
                        else
                            v714[descendant] = 0
                        end

                        if v649 or v711 then
                            descendant.LocalTransparencyModifier = 1
                        else
                            descendant.LocalTransparencyModifier = 0
                        end
                    end
                end

                v682 = RaycastParams.new()
                v682.FilterType = Enum.RaycastFilterType.Include
                v682.FilterDescendantsInstances = {
                    v1,
                    workspace.Terrain
                }

                if n8 % 3 == 0 then
                    v715 = v681 + Vector3.new(0, 2, 0)
                    new = workspace:Raycast(v715, Unit4 - v715, v682)

                    if new then
                        Unit4 = new.Position + new.Normal * 0.7
                    end
                end

                v682 = if n8 == 1 or v114 then 24 else 26
                new = Unit

                local v721

                if new then
                    v721 = Unit + result
                    v711 = -p147 * v682
                    v721 = v721:Lerp(Unit4, 1 - math.exp(v711))
                end

                if new and v721 then
                    Unit4 = v721
                end

                Unit = Unit4
                new = Attribute

                local v722

                if new then
                    v722 = Attribute + result
                    v711 = -p147 * v682
                    v722 = v722:Lerp(Attribute2, 1 - math.exp(v711))
                end

                if new and v722 then
                    Attribute2 = v722
                end

                Attribute = Attribute2

                if n8 % 3 == 0 then
                    v682 = Attribute - Unit
                    new = v682.X
                    v705 = v682.Z
                    v682 = Vector3.new(new, 0, v705).Magnitude
                    Attribute2 = Unit + v659.LookVector * math.max(v682, 1) + Vector3.new(0, 1, 0) * (Attribute.Y - Unit.Y)
                    v676.CFrame = CFrame.lookAt(Unit, Attribute2) * CFrame.Angles(t36[1] * (1 - n10), 0, 0)
                    ChaseBrakeTiltIn = t36[1]
                    ScreenGui:SetAttribute("CameraTiltDegrees", (math.deg(ChaseBrakeTiltIn)))
                    v714 = -v676.CFrame.LookVector.Y
                    v711 = math.clamp(v714, -1, 1)
                    ChaseBrakeTiltIn = math.asin(v711)
                    ScreenGui:SetAttribute("CameraElevationDegrees", (math.deg(ChaseBrakeTiltIn)))
                    v713 = v676.CFrame.LookVector.X
                    v712 = v676.CFrame.LookVector.Z
                    v714 = Vector3.new(v713, 0, v712).Unit:Dot(Unit3)
                    v711 = math.clamp(v714, -1, 1)
                    ChaseBrakeTiltIn = math.acos(v711)
                    ScreenGui:SetAttribute("CameraActualFacingError", (math.deg(ChaseBrakeTiltIn)))
                else
                    v676.CFrame = CFrame.lookAt(Unit, Attribute)
                end

                v681 = Config.ChaseShakeFromKph or 250
                v706 = (v94.speed or 0) - v681
                v722 = math.clamp(v706 / math.max((Config.ChaseShakeFullKph or 340) - v681, 1), 0, 1)

                local v723, v724

                if v722 > 0 and n8 ~= 2 and not v114 and t16.camShake ~= false then
                    v723 = Config.ChaseShakeDegrees or 0.35
                    v724 = if n8 == 1 then 1.4 else 1
                    v706 = v723 * v724
                    v681 = math.rad(v706) * v722 * v722
                    Players = os.clock() * (Config.ChaseShakeFrequency or 11)
                    v676.CFrame *= CFrame.Angles(math.noise(Players, 7.1, 0.5) * v681, math.noise(0.5, Players, 3.3) * v681, math.noise(5.7, 0.5, Players) * v681 * 0.5)
                end

                if n8 == 2 then
                    local v725 = n10

                    v659 = math.max(v725, t15.pad and t15.pad.blend or 0) > 0.5

                    local RearTyre = if v659 then t15.cams.RearTyre else nil

                    if not v659 or not RearTyre then
                        RearTyre = t15.cams.FrontTyre
                    end

                    RearTyre, v725 = RearTyre(v678)
                    v676.CFrame = RearTyre
                    v676.FieldOfView = v725 + v643 * 14
                    Unit = nil
                    Attribute = nil
                end

                v723 = if n8 == 1 then "First person"
                    elseif n8 == 2 then "Front tyre"
                    elseif n8 == 3 then "High chase"
                    else "Chase"
                ScreenGui:SetAttribute("CameraMode", v723)
                ScreenGui:SetAttribute("OrbitYaw", t24[1])
                v723 = n9
                ScreenGui:SetAttribute("ZoomScale", v723)
                v723 = v97
                ScreenGui:SetAttribute("RearView", v723)
            end
        end

        if not v93 and Character and Character:GetAttribute("RaceCrashActive") then
            followCrashBike()
        end

        v678 = workspace.CurrentCamera
        v683 = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")
        v641 = v93

        local BikesPreviewOpen

        if v641 then
            BikesPreviewOpen = v641
        else
            v641 = v118

            local v727 = false

            if v641 then
                BikesPreviewOpen = v641
                v727 = true
            elseif Character then
                v641 = Character:GetAttribute("RaceCrashActive")

                if v641 then
                    BikesPreviewOpen = v641
                    v727 = true
                end
            end

            if not v727 then
                BikesPreviewOpen = v683 and (v683:GetAttribute("BikesPreviewOpen") or v683:GetAttribute("LobbySpectating") or v683:GetAttribute("ResultsShowing") or v683:GetAttribute("SpectatingUserId") or v683:GetAttribute("Freecam"))
            end
        end

        if not BikesPreviewOpen and v629 and v629.Health > 0 and (v678.CameraType == Enum.CameraType.Scriptable or v678.CameraSubject ~= v629) then
            v678.CameraType = Enum.CameraType.Custom
            v678.CameraSubject = v629
        end

        if not v93 and not (not v118 or Character and Character:GetAttribute("RaceCrashActive") and v631) then
            v678 = workspace.CurrentCamera
            v678.CameraType = Enum.CameraType.Custom
            v678.CameraSubject = v629
            v678.FieldOfView = FieldOfView

            if t28.minZoom then
                LocalPlayer.CameraMinZoomDistance = t28.minZoom
            end

            if t28.focusPart then
                t28.focusPart:Destroy()
            end

            v118 = false
            t28 = {}
            ScreenGui:SetAttribute("CrashCameraTarget", nil)
            Unit = nil
            Attribute = nil
            Position = nil
        end

        v678 = workspace:FindFirstChild("RaceBikes")

        if v678 then
            for _, child in v678:GetChildren() do
                v629 = child.PrimaryPart

                if v629 and (child == v92 or t15.lod.visible(child, v629)) then
                    v659 = t78[child]

                    if not v659 then
                        v659 = {
                            front = 0,
                            rear = 0
                        }
                        v659.phase = math.random(0, 7)
                    end

                    t78[child] = v659
                    v659.acc = (v659.acc or 0) + p147
                    v680 = v92

                    if child == v680 then
                        v649 = v659.acc
                        v680 = math.min(v649, 0.25)
                        v659.acc = 0
                        v649 = v629.CFrame.LookVector
                        ok = v92

                        if child == ok then
                            v681 = nil
                        else
                            ok = t15.remoteBikes

                            if ok == nil then
                                result = require
                                ok, result = pcall(result, MotoLegends:FindFirstChild("RemoteBikes"))
                                t15.remoteBikes = ok and result or false
                            end

                            ok = child:GetAttribute("OwnerUserId")
                            ok = t15.remoteBikes and ok and t15.remoteBikes.Velocity(ok)
                            v681 = if ok then ok:Dot(v649) else nil
                        end

                        v681 = v681 or v629.AssemblyLinearVelocity:Dot(v649)
                        ok = v629.Position
                        result = os.clock()
                        Unit4 = v659.pos

                        if Unit4 then
                            Unit4 = ok - v659.pos
                            Attribute2 = Unit4.Magnitude

                            if Attribute2 > 0.001 then
                                Attribute2 = result - v659.posT
                                v682 = Attribute2 > 0 and Unit4:Dot(v649) / Attribute2 or 0

                                if not (math.abs(v682) < 700) then
                                    v682 = 0
                                end

                                v659.moved = v682
                                v659.pos = ok
                                v659.posT = result
                            elseif result - v659.posT > 0.3 then
                                v659.moved = 0
                            end
                        else
                            v659.pos = ok
                            v659.posT = result
                        end

                        if math.abs(v681) < 2 then
                            Attribute2 = v659.moved or 0

                            if math.abs(Attribute2) > 4 then
                                v681 = v659.moved
                            end
                        end

                        Unit4 = v92
                        result = child ~= Unit4 and (child:GetAttribute("Parked") == true or v629.Anchored)

                        if result then
                            v681 = 0
                        end

                        Unit4 = child:GetAttribute("Crash")

                        if Unit4 ~= "" then
                            ok = 0
                        else
                            Unit4 = v92

                            if child == Unit4 then
                                Unit4 = v92

                                if child == Unit4 then
                                    Unit4 = v119

                                    if Unit4 then
                                        ok = v119
                                        ok = ok.burnout or child:GetAttribute("Burnout") or 0
                                    else
                                        ok = child:GetAttribute("Burnout") or 0
                                    end
                                else
                                    ok = child:GetAttribute("Burnout") or 0
                                end
                            else
                                Unit4 = child:GetAttribute("Parked")

                                if Unit4 == true then
                                    ok = 0
                                else
                                    Unit4 = v92

                                    if child == Unit4 then
                                        Unit4 = v119

                                        if Unit4 then
                                            ok = v119
                                            ok = ok.burnout or child:GetAttribute("Burnout") or 0
                                        else
                                            ok = child:GetAttribute("Burnout") or 0
                                        end
                                    else
                                        ok = child:GetAttribute("Burnout") or 0
                                    end
                                end
                            end
                        end

                        result = Config.WheelMaxVisualStep or 0.4
                        Attribute2 = v681 * v680 / Config.FrontWheelRadius
                        v682 = -result
                        Unit4 = math.clamp(Attribute2, v682, result)
                        Attribute2 = (v681 / Config.RearWheelRadius + ok * Config.BurnoutSpinRate) * v680
                        v682 = -result
                        v681 = math.clamp(Attribute2, v682, result)
                        v659.front = (v659.front + Unit4) % 6.283185307179586
                        v659.rear = (v659.rear + v681) % 6.283185307179586
                        Attribute2 = v92

                        if child == Attribute2 then
                            Attribute2 = v119

                            if Attribute2 then
                                v681 = v119
                                v681 = v681.frontCompression or child:GetAttribute("FrontCompression") or 0
                            else
                                v681 = child:GetAttribute("FrontCompression") or 0
                            end
                        else
                            v681 = child:GetAttribute("FrontCompression") or 0
                        end

                        Attribute2 = v92

                        if child == Attribute2 then
                            Attribute2 = v119

                            if Attribute2 then
                                result = v119
                                result = result.rearCompression or child:GetAttribute("RearCompression") or 0
                            else
                                result = child:GetAttribute("RearCompression") or 0
                            end
                        else
                            result = child:GetAttribute("RearCompression") or 0
                        end

                        BikeSuspension.ApplyVisual(child, v681, result)

                        for _, child in v629:GetChildren() do
                            if child:IsA("Motor6D") and child.Part1 and not child.Part1:GetAttribute("Detached") and child.Name:find("Wheel") then
                                v681 = child.Name == "RearWheel"
                                child.Transform = BikeSuspension.WheelTransform(child, v681 and v659.rear or v659.front)
                            end
                        end
                    else
                        v680 = ScreenGui:GetAttribute("LobbySpectating")

                        if v680 then
                            v649 = v659.acc
                            v680 = math.min(v649, 0.25)
                            v659.acc = 0
                            v649 = v629.CFrame.LookVector
                            ok = v92

                            if child == ok then
                                v681 = nil
                            else
                                ok = t15.remoteBikes

                                if ok == nil then
                                    result = require
                                    ok, result = pcall(result, MotoLegends:FindFirstChild("RemoteBikes"))
                                    t15.remoteBikes = ok and result or false
                                end

                                ok = child:GetAttribute("OwnerUserId")
                                ok = t15.remoteBikes and ok and t15.remoteBikes.Velocity(ok)
                                v681 = if ok then ok:Dot(v649) else nil
                            end

                            v681 = v681 or v629.AssemblyLinearVelocity:Dot(v649)
                            ok = v629.Position
                            result = os.clock()
                            Unit4 = v659.pos

                            if Unit4 then
                                Unit4 = ok - v659.pos
                                Attribute2 = Unit4.Magnitude

                                if Attribute2 > 0.001 then
                                    Attribute2 = result - v659.posT
                                    v682 = Attribute2 > 0 and Unit4:Dot(v649) / Attribute2 or 0

                                    if not (math.abs(v682) < 700) then
                                        v682 = 0
                                    end

                                    v659.moved = v682
                                    v659.pos = ok
                                    v659.posT = result
                                elseif result - v659.posT > 0.3 then
                                    v659.moved = 0
                                end
                            else
                                v659.pos = ok
                                v659.posT = result
                            end

                            if math.abs(v681) < 2 then
                                Attribute2 = v659.moved or 0

                                if math.abs(Attribute2) > 4 then
                                    v681 = v659.moved
                                end
                            end

                            Unit4 = v92
                            result = child ~= Unit4 and (child:GetAttribute("Parked") == true or v629.Anchored)

                            if result then
                                v681 = 0
                            end

                            Unit4 = child:GetAttribute("Crash")

                            if Unit4 ~= "" then
                                ok = 0
                            else
                                Unit4 = v92

                                if child == Unit4 then
                                    Unit4 = v92

                                    if child == Unit4 then
                                        Unit4 = v119

                                        if Unit4 then
                                            ok = v119
                                            ok = ok.burnout or child:GetAttribute("Burnout") or 0
                                        else
                                            ok = child:GetAttribute("Burnout") or 0
                                        end
                                    else
                                        ok = child:GetAttribute("Burnout") or 0
                                    end
                                else
                                    Unit4 = child:GetAttribute("Parked")

                                    if Unit4 == true then
                                        ok = 0
                                    else
                                        Unit4 = v92

                                        if child == Unit4 then
                                            Unit4 = v119

                                            if Unit4 then
                                                ok = v119
                                                ok = ok.burnout or child:GetAttribute("Burnout") or 0
                                            else
                                                ok = child:GetAttribute("Burnout") or 0
                                            end
                                        else
                                            ok = child:GetAttribute("Burnout") or 0
                                        end
                                    end
                                end
                            end

                            result = Config.WheelMaxVisualStep or 0.4
                            Attribute2 = v681 * v680 / Config.FrontWheelRadius
                            v682 = -result
                            Unit4 = math.clamp(Attribute2, v682, result)
                            Attribute2 = (v681 / Config.RearWheelRadius + ok * Config.BurnoutSpinRate) * v680
                            v682 = -result
                            v681 = math.clamp(Attribute2, v682, result)
                            v659.front = (v659.front + Unit4) % 6.283185307179586
                            v659.rear = (v659.rear + v681) % 6.283185307179586
                            Attribute2 = v92

                            if child == Attribute2 then
                                Attribute2 = v119

                                if Attribute2 then
                                    v681 = v119
                                    v681 = v681.frontCompression or child:GetAttribute("FrontCompression") or 0
                                else
                                    v681 = child:GetAttribute("FrontCompression") or 0
                                end
                            else
                                v681 = child:GetAttribute("FrontCompression") or 0
                            end

                            Attribute2 = v92

                            if child == Attribute2 then
                                Attribute2 = v119

                                if Attribute2 then
                                    result = v119
                                    result = result.rearCompression or child:GetAttribute("RearCompression") or 0
                                else
                                    result = child:GetAttribute("RearCompression") or 0
                                end
                            else
                                result = child:GetAttribute("RearCompression") or 0
                            end

                            BikeSuspension.ApplyVisual(child, v681, result)

                            for _, child in v629:GetChildren() do
                                if child:IsA("Motor6D") and child.Part1 and not child.Part1:GetAttribute("Detached") and child.Name:find("Wheel") then
                                    v681 = child.Name == "RearWheel"
                                    child.Transform = BikeSuspension.WheelTransform(child, v681 and v659.rear or v659.front)
                                end
                            end
                        else
                            v680 = t15.lod
                            v649 = workspace.CurrentCamera
                            Players = v649 and (v629.Position - v649.CFrame.Position).Magnitude or 0
                            v649 = if Players < v680.NEAR then 1 elseif Players < v680.MID then 2 else 4

                            if v649 > 1 then
                                ok = (v680.frame + v659.phase) % v649

                                if ok == 0 then
                                    v649 = v659.acc
                                    v680 = math.min(v649, 0.25)
                                    v659.acc = 0
                                    v649 = v629.CFrame.LookVector
                                    ok = v92

                                    if child == ok then
                                        v681 = nil
                                    else
                                        ok = t15.remoteBikes

                                        if ok == nil then
                                            result = require
                                            ok, result = pcall(result, MotoLegends:FindFirstChild("RemoteBikes"))
                                            t15.remoteBikes = ok and result or false
                                        end

                                        ok = child:GetAttribute("OwnerUserId")
                                        ok = t15.remoteBikes and ok and t15.remoteBikes.Velocity(ok)
                                        v681 = if ok then ok:Dot(v649) else nil
                                    end

                                    v681 = v681 or v629.AssemblyLinearVelocity:Dot(v649)
                                    ok = v629.Position
                                    result = os.clock()
                                    Unit4 = v659.pos

                                    if Unit4 then
                                        Unit4 = ok - v659.pos
                                        Attribute2 = Unit4.Magnitude

                                        if Attribute2 > 0.001 then
                                            Attribute2 = result - v659.posT
                                            v682 = Attribute2 > 0 and Unit4:Dot(v649) / Attribute2 or 0

                                            if not (math.abs(v682) < 700) then
                                                v682 = 0
                                            end

                                            v659.moved = v682
                                            v659.pos = ok
                                            v659.posT = result
                                        elseif result - v659.posT > 0.3 then
                                            v659.moved = 0
                                        end
                                    else
                                        v659.pos = ok
                                        v659.posT = result
                                    end

                                    if math.abs(v681) < 2 then
                                        Attribute2 = v659.moved or 0

                                        if math.abs(Attribute2) > 4 then
                                            v681 = v659.moved
                                        end
                                    end

                                    Unit4 = v92
                                    result = child ~= Unit4 and (child:GetAttribute("Parked") == true or v629.Anchored)

                                    if result then
                                        v681 = 0
                                    end

                                    Unit4 = child:GetAttribute("Crash")

                                    if Unit4 ~= "" then
                                        ok = 0
                                    else
                                        Unit4 = v92

                                        if child == Unit4 then
                                            Unit4 = v92

                                            if child == Unit4 then
                                                Unit4 = v119

                                                if Unit4 then
                                                    ok = v119
                                                    ok = ok.burnout or child:GetAttribute("Burnout") or 0
                                                else
                                                    ok = child:GetAttribute("Burnout") or 0
                                                end
                                            else
                                                ok = child:GetAttribute("Burnout") or 0
                                            end
                                        else
                                            Unit4 = child:GetAttribute("Parked")

                                            if Unit4 == true then
                                                ok = 0
                                            else
                                                Unit4 = v92

                                                if child == Unit4 then
                                                    Unit4 = v119

                                                    if Unit4 then
                                                        ok = v119
                                                        ok = ok.burnout or child:GetAttribute("Burnout") or 0
                                                    else
                                                        ok = child:GetAttribute("Burnout") or 0
                                                    end
                                                else
                                                    ok = child:GetAttribute("Burnout") or 0
                                                end
                                            end
                                        end
                                    end

                                    result = Config.WheelMaxVisualStep or 0.4
                                    Attribute2 = v681 * v680 / Config.FrontWheelRadius
                                    v682 = -result
                                    Unit4 = math.clamp(Attribute2, v682, result)
                                    Attribute2 = (v681 / Config.RearWheelRadius + ok * Config.BurnoutSpinRate) * v680
                                    v682 = -result
                                    v681 = math.clamp(Attribute2, v682, result)
                                    v659.front = (v659.front + Unit4) % 6.283185307179586
                                    v659.rear = (v659.rear + v681) % 6.283185307179586
                                    Attribute2 = v92

                                    if child == Attribute2 then
                                        Attribute2 = v119

                                        if Attribute2 then
                                            v681 = v119
                                            v681 = v681.frontCompression or child:GetAttribute("FrontCompression") or 0
                                        else
                                            v681 = child:GetAttribute("FrontCompression") or 0
                                        end
                                    else
                                        v681 = child:GetAttribute("FrontCompression") or 0
                                    end

                                    Attribute2 = v92

                                    if child == Attribute2 then
                                        Attribute2 = v119

                                        if Attribute2 then
                                            result = v119
                                            result = result.rearCompression or child:GetAttribute("RearCompression") or 0
                                        else
                                            result = child:GetAttribute("RearCompression") or 0
                                        end
                                    else
                                        result = child:GetAttribute("RearCompression") or 0
                                    end

                                    BikeSuspension.ApplyVisual(child, v681, result)

                                    for _, child in v629:GetChildren() do
                                        if child:IsA("Motor6D") and child.Part1 and not child.Part1:GetAttribute("Detached") and child.Name:find("Wheel") then
                                            v681 = child.Name == "RearWheel"
                                            child.Transform = BikeSuspension.WheelTransform(child, v681 and v659.rear or v659.front)
                                        end
                                    end
                                end
                            else
                                v649 = v659.acc
                                v680 = math.min(v649, 0.25)
                                v659.acc = 0
                                v649 = v629.CFrame.LookVector
                                ok = v92

                                if child == ok then
                                    v681 = nil
                                else
                                    ok = t15.remoteBikes

                                    if ok == nil then
                                        result = require
                                        ok, result = pcall(result, MotoLegends:FindFirstChild("RemoteBikes"))
                                        t15.remoteBikes = ok and result or false
                                    end

                                    ok = child:GetAttribute("OwnerUserId")
                                    ok = t15.remoteBikes and ok and t15.remoteBikes.Velocity(ok)
                                    v681 = if ok then ok:Dot(v649) else nil
                                end

                                v681 = v681 or v629.AssemblyLinearVelocity:Dot(v649)
                                ok = v629.Position
                                result = os.clock()
                                Unit4 = v659.pos

                                if Unit4 then
                                    Unit4 = ok - v659.pos
                                    Attribute2 = Unit4.Magnitude

                                    if Attribute2 > 0.001 then
                                        Attribute2 = result - v659.posT
                                        v682 = Attribute2 > 0 and Unit4:Dot(v649) / Attribute2 or 0

                                        if not (math.abs(v682) < 700) then
                                            v682 = 0
                                        end

                                        v659.moved = v682
                                        v659.pos = ok
                                        v659.posT = result
                                    elseif result - v659.posT > 0.3 then
                                        v659.moved = 0
                                    end
                                else
                                    v659.pos = ok
                                    v659.posT = result
                                end

                                if math.abs(v681) < 2 then
                                    Attribute2 = v659.moved or 0

                                    if math.abs(Attribute2) > 4 then
                                        v681 = v659.moved
                                    end
                                end

                                Unit4 = v92
                                result = child ~= Unit4 and (child:GetAttribute("Parked") == true or v629.Anchored)

                                if result then
                                    v681 = 0
                                end

                                Unit4 = child:GetAttribute("Crash")

                                if Unit4 ~= "" then
                                    ok = 0
                                else
                                    Unit4 = v92

                                    if child == Unit4 then
                                        Unit4 = v92

                                        if child == Unit4 then
                                            Unit4 = v119

                                            if Unit4 then
                                                ok = v119
                                                ok = ok.burnout or child:GetAttribute("Burnout") or 0
                                            else
                                                ok = child:GetAttribute("Burnout") or 0
                                            end
                                        else
                                            ok = child:GetAttribute("Burnout") or 0
                                        end
                                    else
                                        Unit4 = child:GetAttribute("Parked")

                                        if Unit4 == true then
                                            ok = 0
                                        else
                                            Unit4 = v92

                                            if child == Unit4 then
                                                Unit4 = v119

                                                if Unit4 then
                                                    ok = v119
                                                    ok = ok.burnout or child:GetAttribute("Burnout") or 0
                                                else
                                                    ok = child:GetAttribute("Burnout") or 0
                                                end
                                            else
                                                ok = child:GetAttribute("Burnout") or 0
                                            end
                                        end
                                    end
                                end

                                result = Config.WheelMaxVisualStep or 0.4
                                Attribute2 = v681 * v680 / Config.FrontWheelRadius
                                v682 = -result
                                Unit4 = math.clamp(Attribute2, v682, result)
                                Attribute2 = (v681 / Config.RearWheelRadius + ok * Config.BurnoutSpinRate) * v680
                                v682 = -result
                                v681 = math.clamp(Attribute2, v682, result)
                                v659.front = (v659.front + Unit4) % 6.283185307179586
                                v659.rear = (v659.rear + v681) % 6.283185307179586
                                Attribute2 = v92

                                if child == Attribute2 then
                                    Attribute2 = v119

                                    if Attribute2 then
                                        v681 = v119
                                        v681 = v681.frontCompression or child:GetAttribute("FrontCompression") or 0
                                    else
                                        v681 = child:GetAttribute("FrontCompression") or 0
                                    end
                                else
                                    v681 = child:GetAttribute("FrontCompression") or 0
                                end

                                Attribute2 = v92

                                if child == Attribute2 then
                                    Attribute2 = v119

                                    if Attribute2 then
                                        result = v119
                                        result = result.rearCompression or child:GetAttribute("RearCompression") or 0
                                    else
                                        result = child:GetAttribute("RearCompression") or 0
                                    end
                                else
                                    result = child:GetAttribute("RearCompression") or 0
                                end

                                BikeSuspension.ApplyVisual(child, v681, result)

                                for _, child in v629:GetChildren() do
                                    if child:IsA("Motor6D") and child.Part1 and not child.Part1:GetAttribute("Detached") and child.Name:find("Wheel") then
                                        v681 = child.Name == "RearWheel"
                                        child.Transform = BikeSuspension.WheelTransform(child, v681 and v659.rear or v659.front)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        n6 += p147

        if v93 and n6 > 0.016666666666666666 then
            n6 = 0

            local v728 = if t22[Enum.KeyCode.W] then 1 else 0

            BikesPreviewOpen = v96.throttle
            Unit3 = t23.throttle
            v678 = math.max(v728, BikesPreviewOpen, Unit3)
            v728 = if t22[Enum.KeyCode.S] then 1 else 0
            BikesPreviewOpen = v96.brake
            Unit3 = t23.brake
            v679 = math.max(v728, BikesPreviewOpen, Unit3)

            local v729 = t22[Enum.KeyCode.LeftShift]

            if not v729 then
                v729 = t22[Enum.KeyCode.RightShift]
            end

            BikesPreviewOpen = if v729 then 1 else 0
            Unit3 = v96.rearBrake or 0
            v643 = t23.rearBrake or 0
            v728 = math.max(BikesPreviewOpen, Unit3, v643)
            Unit3 = if t22[Enum.KeyCode.D] then 1 else 0
            v643 = if t22[Enum.KeyCode.A] then 1 else 0
            BikesPreviewOpen = Unit3 - v643
            v643 = v96.steer

            if math.abs(v643) > 0.08 then
                BikesPreviewOpen = v96.steer
            end

            if t23.steer ~= 0 then
                BikesPreviewOpen = t23.steer
            end

            if LocalPlayer:GetAttribute("RaceGridLocked") then
                v111 = false
                v124 = false
            end

            if v111 then
                v124 = true
            end

            n18 += n6 + p147

            local Character, t92

            if n18 > 0.08 then
                n18 = 0
                Character = LocalPlayer.Character

                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart then
                    t92 = {}

                    for _, child in Character:GetChildren() do
                        if child:IsA("BasePart") and child ~= HumanoidRootPart and child.Name ~= "CollisionPart" then
                            t92[child.Name] = HumanoidRootPart.CFrame:ToObjectSpace(child.CFrame)
                        end
                    end
                end
            end

            Character = MotoLegends.Input
            v680 = {}

            local v731 = t22[Enum.KeyCode.T] == true

            if not v731 then
                v731 = t22[Enum.KeyCode.ButtonL1] == true
            end

            if v731 then
                v680.clutch = true
            else
                v680.clutch = t23.clutch == true
            end

            Players = if t22[Enum.KeyCode.F] then 1 else 0
            v681 = -(v96.lift or 0)
            ok = math.max(0, v681)
            Attribute2 = -(t23.lift or 0)
            result = math.max(0, Attribute2)
            v680.manualWheelie = math.max(Players, ok, result)
            Players = if t22[Enum.KeyCode.G] then 1 else 0
            v681 = v96.lift or 0
            ok = math.max(0, v681)
            Attribute2 = t23.lift or 0
            result = math.max(0, Attribute2)
            v680.manualStoppie = math.max(Players, ok, result)
            v680.riderPose = t92
            v680.rhd = v112
            v680.lookBack = v97 == true
            v680.throttle = v678
            v680.brake = v679
            v680.rearBrake = v728
            v680.steer = BikesPreviewOpen
            v680.shift = n7
            v680.tcs = v109
            v680.abs = v110
            v680.dismount = v111
            Players = v119

            local rearYaw = if Players then v119.rearYaw else nil

            if not Players or not rearYaw then
                rearYaw = 0
            end

            v680.tyreYaw = rearYaw
            Players = v119

            local slip = if Players then v119.slip else nil

            if not Players or not slip then
                slip = 0
            end

            v680.tyreSlip = slip
            Character:FireServer(v680)
            n7 = 0
            v109 = false
            v110 = false
            v111 = false
            v113 = false
        end

        v678 = v18.Update
        BikesPreviewOpen = v93
        v678(p147, BikesPreviewOpen, Character and Character:GetAttribute("RaceCrashActive") == true)
    end)
end

local v732 = RaycastParams.new()

v732.FilterType = Enum.RaycastFilterType.Include

local t97 = {}
local v733

RunService.PostSimulation:Connect(function() -- line: 2402
    -- upvalues: LocalPlayer (copy), BikeDynamics (copy), v732 (copy), t97 (ref), v733 (ref), v1 (copy)
    local Character = LocalPlayer.Character

    if Character and Character:GetAttribute("RaceCrashActive") == true then
        local v734

        if v1 and v1.Parent then
            v734 = v1

            if not v1 then
                v734 = BikeDynamics.RaceCollision()
            end
        else
            v734 = BikeDynamics.RaceCollision()
        end

        if v733 ~= v734 then
            v733 = v734
            v732.FilterDescendantsInstances = v734 and {
                v734,
                workspace.Terrain
            } or {
                workspace.Terrain
            }
        end

        for _, child in Character:GetChildren() do
            if child:IsA("BasePart") and not child.Anchored and child.Name ~= "HumanoidRootPart" and child.Name ~= "RaceCrashCollider" and child.Name ~= "CollisionPart" and not child.Name:find("Hand") and not child.Name:find("Foot") then
                local Position = child.Position
                local v737 = math.max(Position.Y, t97[child] or Position.Y) + 4
                local v740 = workspace:Raycast(Vector3.new(Position.X, v737, Position.Z), Vector3.new(0, Position.Y - v737 - 6, 0), v732)

                if v740 and v740.Normal.Y > 0.3 then
                    local v741 = v740.Position.Y + math.min(child.Size.X, child.Size.Y, child.Size.Z) * 0.5

                    if Position.Y < v741 then
                        child.CFrame += Vector3.new(0, 1, 0) * (v741 - Position.Y)

                        local AssemblyLinearVelocity = child.AssemblyLinearVelocity

                        if AssemblyLinearVelocity.Y < 0 then
                            child.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X * 0.9, 0, AssemblyLinearVelocity.Z * 0.9)
                        end
                    else
                        t97[child] = Position.Y
                    end
                end
            end
        end
    elseif next(t97) then
        t97 = {}
    end
end)
LocalPlayer.CharacterAdded:Connect(function() -- line: 2428
    -- upvalues: LocalPlayer (copy), v92 (ref), v93 (ref), t22 (ref), Unit (ref), v118 (ref), t28 (ref), v119 (ref), v124 (ref), t30 (ref), t31 (ref), v125 (ref)
    if t28.focusPart then
        t28.focusPart:Destroy()
    end

    if t28.minZoom then
        LocalPlayer.CameraMinZoomDistance = t28.minZoom
        LocalPlayer.CameraMode = t28.playerMode or Enum.CameraMode.Classic
    end

    v93 = false
    v92 = nil
    v118 = false
    t28 = {}
    t30 = {}
    t31 = {}
    v125 = nil
    t22 = {}
    Unit = nil
    v119 = nil
    v124 = false
end)

local Heartbeat = require(MotoLegends:WaitForChild("SettingsBridge"))
local t99 = {
    quality = true,
    shadows = true,
    trees = true,
    effects = true,
    marshals = true,
    nametags = true,
    vibration = true,
    minimap = true,
    camShake = true,
    camFixed = true,
    audience = true,
    cutscenes = true,
    apexAssist = true
}

function Heartbeat.get(p148) -- line: 2437
    -- upvalues: LocalPlayer (copy), v60 (ref), t16 (copy), v94 (ref), t99 (copy)
    if p148 == "transmission" then
        return v60
    end

    if p148 == "abs" then
        return v94.abs ~= false
    end

    if p148 == "afk" then
        return LocalPlayer:GetAttribute("AFKMode") == true
    end

    if p148 == "afkLocked" then
        if LocalPlayer:GetAttribute("RaceRewardPending") == true then
            return LocalPlayer:GetAttribute("AFKMode") ~= true
        end

        return false
    end

    return if t99[p148] then t16[p148] else nil
end

function Heartbeat.set(p149, p150) -- line: 2445
    -- upvalues: MotoLegends (copy), v60 (ref), t15 (copy), t16 (copy), applyGraphics (copy), t20 (copy), v94 (ref), t99 (copy)
    if p149 == "transmission" then
        if (p150 == "Automatic" or p150 == "Manual") and p150 ~= v60 then
            v60 = p150
            MotoLegends.Settings:FireServer({
                transmission = v60
            })
        end
    elseif p149 == "abs" then
        v94.abs = p150 == true
        MotoLegends.Settings:FireServer({
            abs = v94.abs
        })
    elseif p149 == "afk" then
        MotoLegends.Settings:FireServer({
            afk = p150 == true
        })
    elseif p149 == "quality" then
        if t20[p150] then
            t16.quality = p150

            for v746, v747 in t20[p150] do
                t16[v746] = v747
            end
        end

        applyGraphics()

        if t15.send then
            t15.send()
        end
    elseif t99[p149] then
        t16[p149] = p150 == true

        if p149 == "audience" then
            t16.audienceSet = true
        end

        if p149 ~= "nametags" and p149 ~= "vibration" and p149 ~= "minimap" and p149 ~= "camShake" and p149 ~= "camFixed" and p149 ~= "cutscenes" and p149 ~= "apexAssist" then
            t16.quality = "Custom"
        end

        applyGraphics()

        if t15.send then
            t15.send()
        end
    end
end

function Heartbeat.bindRows() -- line: 2458
    -- upvalues: t1 (copy)
    local t101 = {}

    for _, v749 in t1 do
        table.insert(t101, {
            label = v749[1],
            kb = v749[2],
            pad = v749[3]
        })
    end

    return t101
end

function Heartbeat.keyName(p151) -- line: 2463
    -- upvalues: t2 (copy)
    local v750 = t2[p151]

    return v750 and v750.Name or "-"
end

function Heartbeat.beginBind(p152) -- line: 2464
    -- upvalues: v2 (ref), t2 (copy), t3 (copy), t4 (ref)
    if t2[p152] then
        if t4 and t3[t4.name] then
            t3[t4.name].Text = t2[t4.name].Name
        end

        t4 = {
            name = p152,
            column = (p152:find("Button") ~= nil or p152:find("Thumbstick") ~= nil or p152:find("DPad") ~= nil) and 3 or 2
        }
        v2 = true
    end
end

function Heartbeat.pending() -- line: 2470
    -- upvalues: t4 (ref)
    return t4 and t4.name or nil
end

function Heartbeat.cancelBind() -- line: 2471
    -- upvalues: v2 (ref), t2 (copy), t3 (copy), t4 (ref)
    if t4 and t3[t4.name] then
        t3[t4.name].Text = t2[t4.name].Name
    end

    t4 = nil
    v2 = false
end

function Heartbeat.resetBindings() -- line: 2475
    -- upvalues: v2 (ref), t2 (copy), t3 (copy), t4 (ref), v11 (ref), t15 (copy)
    for v752 in t2 do
        t2[v752] = Enum.KeyCode[v752]

        if t3[v752] then
            t3[v752].Text = v752
        end
    end

    t4 = nil
    v2 = false

    if v11 then
        v11()
    end

    if t15.send then
        t15.send()
    end
end

Heartbeat.ready = true
