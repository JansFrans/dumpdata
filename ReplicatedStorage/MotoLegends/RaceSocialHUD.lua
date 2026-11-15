-- https://lua.expert

local v1

local function __raceRC() -- line: 3
    -- upvalues: v1 (ref)
    if not (v1 and v1.Parent) then
        v1 = workspace:FindFirstChild("RaceCollision", true)
    end

    return v1
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local NumberFormat = require(script.Parent:WaitForChild("NumberFormat"))
local t1 = {
    Jerez = {
        tag = "#SPANISHGP",
        title = "GRAN PREMIO DE ESPAÑA",
        sub = "CIRCUITO DE JEREZ – ÁNGEL NIETO"
    },
    Lusail = {
        tag = "#QATARGP",
        title = "GRAND PRIX OF QATAR",
        sub = "LUSAIL INTERNATIONAL CIRCUIT"
    },
    Mandalika = {
        tag = "#INDONESIANGP",
        title = "PERTAMINA GRAND PRIX OF INDONESIA",
        sub = "PERTAMINA MANDALIKA INTERNATIONAL CIRCUIT"
    },
    Mugello = {
        tag = "#ITALIANGP",
        title = "GRAN PREMIO D'ITALIA",
        sub = "AUTODROMO INTERNAZIONALE DEL MUGELLO"
    },
    Sepang = {
        tag = "#MALAYSIANGP",
        title = "PETRONAS GRAND PRIX OF MALAYSIA",
        sub = "PETRONAS SEPANG INTERNATIONAL CIRCUIT"
    },
    Catalunya = {
        tag = "#CATALANGP",
        title = "GRAN PREMI DE CATALUNYA",
        sub = "CIRCUIT DE BARCELONA-CATALUNYA"
    }
}
local _require = require
local Parent = script.Parent
local ok, result = pcall(_require, Parent:WaitForChild("Config"))
local v2, v3

if ok and type(result) == "table" then
    local v4 = t1[result.Track]

    if v4 then
        v2 = v4
        v3 = true
    else
        v3 = false
    end
else
    v3 = false
end

if not v3 then
    v2 = t1.Jerez
end

local t2 = {
    LapOrder = function(p1) -- LapOrder | line: 22
        local v5 = table.clone(p1)

        table.sort(v5, function(p2, p3) -- line: 24
            local v6 = p2:GetAttribute("BestLapTime") or 0
            local v7 = p3:GetAttribute("BestLapTime") or 0

            if v6 <= 0 then
                v6 = 1e999
            end

            if v7 <= 0 then
                v7 = 1e999
            end

            if v6 ~= v7 then
                return v6 < v7
            end

            local v8 = p2:GetAttribute("JoinOrder") or 1e999
            local v9 = p3:GetAttribute("JoinOrder") or 1e999

            if v8 == v9 then
                return p2.UserId < p3.UserId
            end

            return v8 < v9
        end)

        return v5
    end,
    LapTime = function(p4) -- LapTime | line: 35
        if not p4 or p4 <= 0 then
            return "--:--.---"
        end

        local v11 = math.floor(p4 * 1000 + 0.5)

        return string.format("%02d:%02d.%03d", math.floor(v11 / 60000), math.floor(v11 / 1000) % 60, v11 % 1000)
    end
}

local function boardTime(p5) -- line: 40
    if not p5 or p5 <= 0 then
        return "-:--.---"
    end

    local v16 = math.floor(p5 * 1000 + 0.5)

    return string.format("%d:%02d.%03d", math.floor(v16 / 60000), math.floor(v16 / 1000) % 60, v16 % 1000)
end

function t2.New(p6, p7) -- line: 44
    -- upvalues: v1 (ref), Players (copy), TweenService (copy), NumberFormat (copy), t2 (copy), v2 (ref)
    local _ = game:GetService("UserInputService").TouchEnabled
    local v20 = p7 or Players
    local LocalPlayer = v20.LocalPlayer
    local v21 = Color3.fromRGB(243, 245, 246)
    local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")

    local function panel(p8, p9) -- line: 49
        -- upvalues: p6 (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = p8
        Frame.Size = p9
        Frame.BackgroundColor3 = Color3.fromRGB(17, 23, 28)
        Frame.BackgroundTransparency = 0.08
        Frame.BorderSizePixel = 0
        Frame.Parent = p6
        Frame.Visible = false
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

        return Frame
    end

    local function label(p10, p11, p12, p13, p14) -- line: 53
        -- upvalues: v21 (copy)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p11
        TextLabel.TextColor3 = v21
        TextLabel.Font = Enum.Font.GothamMedium
        TextLabel.TextSize = p14 or 13
        TextLabel.Position = p12
        TextLabel.Size = p13
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.ZIndex = p10:IsA("GuiObject") and p10.ZIndex + 1 or 1
        TextLabel.Parent = p10

        return TextLabel
    end

    local function button(p15, p16, p17, p18, p19) -- line: 56
        -- upvalues: v21 (copy)
        local TextButton = Instance.new("TextButton")

        TextButton.Name = p16
        TextButton.Text = p17
        TextButton.TextColor3 = v21
        TextButton.Font = Enum.Font.GothamMedium
        TextButton.TextSize = 12
        TextButton.BackgroundColor3 = Color3.fromRGB(30, 40, 48)
        TextButton.BorderSizePixel = 0
        TextButton.Position = p18
        TextButton.Size = p19
        TextButton.ZIndex = p15:IsA("GuiObject") and p15.ZIndex + 1 or 1
        TextButton.Parent = p15
        Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)

        return TextButton
    end

    local MoneyBalance = panel("MoneyBalance", UDim2.fromOffset(150, 42))

    MoneyBalance.AnchorPoint = Vector2.new(1, 0)
    MoneyBalance.Position = UDim2.new(1, -20, 0, 58)

    local v22 = label(MoneyBalance, "$0", UDim2.fromOffset(12, 8), UDim2.fromOffset(126, 26), 21)

    v22.TextXAlignment = Enum.TextXAlignment.Right

    local v23 = button(p6, "SpectateButton", "Spectate", UDim2.new(1, -150, 0.5, -20), UDim2.fromOffset(130, 40))
    local SpectatePlayers = panel("SpectatePlayers", UDim2.fromOffset(260, 300))

    SpectatePlayers.AnchorPoint = Vector2.new(1, 0.5)
    SpectatePlayers.Position = UDim2.new(1, -20, 0.5, 0)
    SpectatePlayers.ZIndex = 30
    label(SpectatePlayers, "SPECTATE", UDim2.fromOffset(12, 10), UDim2.fromOffset(195, 24), 15)

    local v24 = button(SpectatePlayers, "StopSpectating", "Stop spectating", UDim2.new(0, 12, 1, -46), UDim2.new(1, -24, 0, 34))
    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "Players"
    ScrollingFrame.Position = UDim2.fromOffset(12, 42)
    ScrollingFrame.Size = UDim2.new(1, -24, 1, -98)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 3
    ScrollingFrame.ZIndex = SpectatePlayers.ZIndex + 1
    ScrollingFrame.Parent = SpectatePlayers

    local v25 = label(SpectatePlayers, "No other players to spectate", UDim2.fromOffset(12, 60), UDim2.fromOffset(232, 42), 12)
    local t3 = {
        Target = nil,
        Selection = SpectatePlayers,
        Money = MoneyBalance,
        Watch = v23
    }
    local v26 = label(p6, "", UDim2.new(0.5, 0, 0, 94), UDim2.fromOffset(240, 34), 24)

    v26.Name = "RewardToast"
    v26.AnchorPoint = Vector2.new(0.5, 0.5)
    v26.TextXAlignment = Enum.TextXAlignment.Center
    v26.Font = Enum.Font.GothamBold
    v26.TextColor3 = Color3.fromRGB(99, 255, 132)
    v26.TextStrokeTransparency = 1
    v26.TextTransparency = 1
    v26.ZIndex = 50
    v26.Visible = false
    t3.RewardToast = v26

    local v27 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
    local v28 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium)
    local v29 = Color3.fromRGB(7, 12, 21)
    local v30 = Color3.fromRGB(228, 8, 32)
    local v31 = Color3.fromRGB(250, 250, 252)
    local v32 = Color3.fromRGB(10, 10, 14)
    local v33 = Color3.new(0, 0, 0)
    local Left, Center, Right = Enum.TextXAlignment.Left, Enum.TextXAlignment.Center, Enum.TextXAlignment.Right
    local Frame = Instance.new("Frame")

    Frame.Name = "LapLeaderboard"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new()
    Frame.Visible = false
    Frame.Parent = p6

    local Parent = p6.Parent
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "LapTimesBackdrop"
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Enabled = false
    ScreenGui.DisplayOrder = 29
    ScreenGui.Archivable = false
    ScreenGui.Parent = Parent

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Background"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = v29
    Frame2.Size = UDim2.fromScale(1, 1)
    Frame2.Active = true
    Frame2.Parent = ScreenGui

    local ScreenGui2 = Instance.new("ScreenGui")

    ScreenGui2.Name = "LapTimesBoard"
    ScreenGui2.IgnoreGuiInset = true
    ScreenGui2.ResetOnSpawn = false
    ScreenGui2.Enabled = false
    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui2.DisplayOrder = 30
    ScreenGui2.Archivable = false
    ScreenGui2.Parent = Parent

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "Root"
    Frame3.BackgroundTransparency = 1
    Frame3.Size = UDim2.fromScale(1, 1)
    Frame3.Active = true
    Frame3.Parent = ScreenGui2

    local Frame4 = Instance.new("Frame")

    Frame4.Name = "ReferenceCanvas"
    Frame4.BackgroundTransparency = 1
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame4.Position = UDim2.fromScale(0.5, 0.5)
    Frame4.Size = UDim2.fromOffset(2000, 1125)
    Frame4.Parent = Frame3

    local UIScale = Instance.new("UIScale", Frame4)

    local function fit() -- line: 104
        -- upvalues: Frame3 (copy), UIScale (copy)
        local AbsoluteSize = Frame3.AbsoluteSize

        if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
            AbsoluteSize = workspace.CurrentCamera.ViewportSize
        end

        UIScale.Scale = math.min(AbsoluteSize.X / 2000, AbsoluteSize.Y / 1125)
    end

    Frame3:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)

    local AbsoluteSize = Frame3.AbsoluteSize

    if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
        AbsoluteSize = workspace.CurrentCamera.ViewportSize
    end

    UIScale.Scale = math.min(AbsoluteSize.X / 2000, AbsoluteSize.Y / 1125)

    local function syncGuis() -- line: 106
        -- upvalues: p6 (copy), Frame (copy), ScreenGui (copy), ScreenGui2 (copy)
        local Visible = Frame.Visible and (p6.Enabled or p6:GetAttribute("SpectateHudHidden") == true)

        ScreenGui2.Enabled = Visible
        ScreenGui.Enabled = Visible
    end

    p6:GetAttributeChangedSignal("SpectateHudHidden"):Connect(function() -- line: 111
        -- upvalues: p6 (copy), Frame (copy), ScreenGui (copy), ScreenGui2 (copy)
        local Visible = Frame.Visible and (p6.Enabled or p6:GetAttribute("SpectateHudHidden") == true)

        ScreenGui2.Enabled = Visible
        ScreenGui.Enabled = Visible
    end)
    Frame:GetPropertyChangedSignal("Visible"):Connect(syncGuis)
    p6:GetPropertyChangedSignal("Enabled"):Connect(syncGuis)
    p6.Destroying:Connect(function() -- line: 113
        -- upvalues: ScreenGui (copy), ScreenGui2 (copy)
        ScreenGui2:Destroy()
        ScreenGui:Destroy()
    end)

    local SpectateHudHidden = require(MotoLegends:WaitForChild("BikeCatalog"))
    local MenuFX = MotoLegends:FindFirstChild("MenuFX")
    local t4 = {}

    for v38, v39 in SpectateHudHidden.Teams do
        t4[v38] = v39.Color
    end

    local t5 = {
        ColorSpeed = 2.5,
        LengthBreath = 0.12,
        ThicknessBreath = 0.22,
        DesignSize = Vector2.new(2000, 1125),
        Colors = t4,
        LightLanes = {
            {
                Top = 0,
                Bottom = 24,
                Center = 0.18,
                Height = 0.25
            },
            {
                Top = 24,
                Bottom = 39,
                Center = 0.47,
                Height = 0.19
            },
            {
                Top = 39,
                Bottom = 58,
                Center = 0.76,
                Height = 0.22
            }
        }
    }
    local Folder = Instance.new("Folder")

    Folder.Name = "LapTimesLightSignal"
    Folder:SetAttribute("SelectedBike", "Ducati")

    local function teamId(p20) -- line: 125
        -- upvalues: t4 (copy)
        if typeof(p20) ~= "string" then
            return "Ducati"
        end

        if t4[p20] then
            return p20
        end

        for v40 in t4 do
            if v40:upper() == p20:upper() then
                return v40
            end
        end

        return "Ducati"
    end

    local function setLeaderBike(p21) -- line: 131
        -- upvalues: Folder (copy), teamId (copy)
        local v41 = teamId(p21)

        if Folder:GetAttribute("SelectedBike") ~= v41 then
            Folder:SetAttribute("SelectedBike", v41)
        end
    end

    local Frame5 = Instance.new("Frame")

    Frame5.Name = "LightHolder"
    Frame5.BackgroundTransparency = 1
    Frame5.Size = UDim2.fromScale(1, 1)
    Frame5.ZIndex = 1
    Frame5.Parent = Frame2

    local function placeLights() -- line: 138
        -- upvalues: ScreenGui (copy), Frame3 (copy), Frame5 (copy)
        local v43 = math.max(0, Frame3.AbsolutePosition.Y - ScreenGui.AbsolutePosition.Y)
        local v45 = math.ceil(ScreenGui.AbsoluteSize.X * 0.2)

        Frame5.Position = UDim2.fromOffset(-v45, v43)
        Frame5.Size = UDim2.new(1, v45 * 2, 0, Frame3.AbsoluteSize.Y)
    end

    for _, v46 in { Frame3, ScreenGui } do
        v46:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeLights)
        v46:GetPropertyChangedSignal("AbsolutePosition"):Connect(placeLights)
    end

    placeLights()

    local function text(p22, p23, p24, p25, p26, p27, p28, p29, p30) -- line: 145
        -- upvalues: v21 (copy), v27 (copy), Left (copy)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = p23
        TextLabel.Text = p24
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.fromOffset(p25, p26)
        TextLabel.Size = UDim2.fromOffset(p27, p28)
        TextLabel.TextColor3 = v21
        TextLabel.FontFace = p30 or v27
        TextLabel.TextSize = p29
        TextLabel.TextXAlignment = Left
        TextLabel.ZIndex = 5
        TextLabel.Parent = p22

        return TextLabel
    end

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Halftone"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.fromOffset(60, 300)
    ImageLabel.Size = UDim2.fromOffset(600, 620)
    ImageLabel.ImageTransparency = 0.2
    ImageLabel.ZIndex = 1
    ImageLabel.Parent = Frame4

    local result = require
    local Parent2 = script.Parent
    local ok

    ok, result = pcall(result, Parent2:WaitForChild("UIArt", 5))

    if not ok then
        result = nil
    end

    if result and result.Apply then
        result.Apply(ImageLabel, "LegendsDots")
    end

    local v47 = UDim2.fromOffset(154, 576)
    local v48 = text(Frame4, "LeaderName", "", 0, 0, 720, 96, 110)

    v48.AnchorPoint = Vector2.new(0.5, 0.5)
    v48.AutoLocalize = false
    v48.Position = v47
    v48.Rotation = -90
    v48.TextXAlignment = Center
    v48.TextScaled = true
    v48.ZIndex = 2
    Instance.new("UITextSizeConstraint", v48).MaxTextSize = 110

    local v49 = UDim2.fromOffset(120, 255)
    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "LeaderPortrait"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Position = v49
    ViewportFrame.Size = UDim2.fromOffset(660, 860)
    ViewportFrame.ZIndex = 4
    ViewportFrame.Ambient = Color3.fromRGB(150, 150, 160)
    ViewportFrame.LightColor = Color3.fromRGB(255, 245, 235)
    ViewportFrame.LightDirection = Vector3.new(-0.6, -0.5, -1)
    ViewportFrame.Parent = Frame4

    local WorldModel = Instance.new("WorldModel", ViewportFrame)
    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 28
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera

    local v50, result2, v51

    if MenuFX then
        result2 = require
        v51 = MenuFX.MenuPreviewLighting

        local ok

        ok, result2 = pcall(result2, v51)

        if ok then
            v50 = result2.Attach(ViewportFrame, WorldModel, {
                Strength = 0.88,
                RimWidth = 6,
                FrontAmbient = ViewportFrame.Ambient
            }, Folder)
        else
            warn("[LapTimes] rim light: " .. tostring(result2))
        end
    end

    local function refreshRim() -- line: 180
        -- upvalues: v50 (ref)
        if v50 then
            v50.Refresh()
        end
    end

    result2 = text(Frame4, "Hashtag", v2.tag or "", 680, 122, 600, 28, 24)
    v51 = text(Frame4, "EventName", string.upper(v2.title), 680, 163, 1000, 40, 32, v28)

    local v52 = text(Frame4, "SessionTitle", "QUALIFYING TIME", 676, 200, 1040, 84, 86)
    local Frame6 = Instance.new("Frame")

    Frame6.Name = "Rule"
    Frame6.BackgroundTransparency = 1
    Frame6.ClipsDescendants = true
    Frame6.Position = UDim2.fromOffset(680, 298)
    Frame6.Size = UDim2.fromOffset(660, 8)
    Frame6.ZIndex = 4
    Frame6.Parent = Frame4

    local result3

    for i = 0, 40 do
        result3 = Instance.new("Frame")
        result3.BorderSizePixel = 0
        result3.BackgroundColor3 = Color3.fromRGB(64, 68, 78)
        result3.Position = UDim2.fromOffset(i * 16, 0)
        result3.Size = UDim2.fromOffset(8, 8)
        result3.ZIndex = 4
        result3.Parent = Frame6
        Instance.new("UICorner", result3).CornerRadius = UDim.new(1, 0)
    end

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "CloseLeaderboard"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Position = UDim2.fromOffset(1737, 117)
    TextButton.Size = UDim2.fromOffset(141, 76)
    TextButton.ZIndex = 20
    TextButton.AutoButtonColor = false
    TextButton:SetAttribute("NoHover", true)
    TextButton.Parent = Frame4

    local ImageLabel2 = Instance.new("ImageLabel")

    ImageLabel2.Name = "ClosePlate"
    ImageLabel2.BackgroundTransparency = 1
    ImageLabel2.Size = UDim2.fromScale(1, 1)
    ImageLabel2.ImageColor3 = v21
    ImageLabel2.ZIndex = 20
    ImageLabel2.Parent = TextButton

    result3 = function() -- line: 195
        return require(script.Parent:WaitForChild("RaceIcons")).Get("ref_top_plate")
    end

    local ok2

    ok2, result3 = pcall(result3)

    if not ok2 or not result3 then
        ImageLabel2.BackgroundTransparency = 0
        ImageLabel2.BackgroundColor3 = v21
    else
        ImageLabel2.ImageContent = result3
    end

    local v53 = text(TextButton, "X", "X", 0, 0, 141, 76, 44)

    v53.TextXAlignment = Center
    v53.TextColor3 = v33
    v53.ZIndex = 21

    local UIScale2 = Instance.new("UIScale", TextButton)

    local function hover(p31) -- line: 199
        -- upvalues: v21 (copy), v30 (copy), v33 (copy), ImageLabel2 (copy), v53 (copy), TweenService (copy)
        TweenService:Create(ImageLabel2, TweenInfo.new(0.18), {
            ImageColor3 = p31 and v30 or v21
        }):Play()
        TweenService:Create(v53, TweenInfo.new(0.18), {
            TextColor3 = p31 and v21 or v33
        }):Play()
    end

    TextButton.MouseEnter:Connect(function() -- line: 200
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.MouseLeave:Connect(function() -- line: 200
        -- upvalues: UIScale2 (copy), hover (copy), TweenService (copy)
        hover(false)
        TweenService:Create(UIScale2, TweenInfo.new(0.12), {
            Scale = 1
        }):Play()
    end)
    TextButton.SelectionGained:Connect(function() -- line: 201
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.SelectionLost:Connect(function() -- line: 201
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.MouseButton1Down:Connect(function() -- line: 202
        -- upvalues: UIScale2 (copy), TweenService (copy)
        TweenService:Create(UIScale2, TweenInfo.new(0.08), {
            Scale = 0.94
        }):Play()
    end)
    TextButton.MouseButton1Up:Connect(function() -- line: 203
        -- upvalues: UIScale2 (copy), TweenService (copy)
        TweenService:Create(UIScale2, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
            Scale = 1
        }):Play()
    end)
    TextButton.Activated:Connect(function() -- line: 205
        -- upvalues: Frame (copy)
        Frame.Visible = false
    end)

    local v56 = text(Frame4, "NextSessionTimer", "", 850, 1010, 300, 64, 52)

    v56.TextXAlignment = Center
    v56.Visible = false

    local ImageLabel3 = Instance.new("ImageLabel")

    ImageLabel3.Name = "MotoLegendsLogo"
    ImageLabel3.BackgroundTransparency = 1
    ImageLabel3.Position = UDim2.fromOffset(1786, 1012)
    ImageLabel3.Size = UDim2.fromOffset(180, 64)
    ImageLabel3.ScaleType = Enum.ScaleType.Fit
    ImageLabel3.ZIndex = 6
    ImageLabel3.Parent = Frame4

    if result and result.Apply then
        result.Apply(ImageLabel3, "MotoLegendsLogo")
    end

    local Frame7 = Instance.new("Frame")

    Frame7.Name = "LeaderRow"
    Frame7.BackgroundTransparency = 1
    Frame7.ZIndex = 8
    Frame7.Parent = Frame4

    local ScrollingFrame2 = Instance.new("ScrollingFrame")

    ScrollingFrame2.Name = "RankedRiders"
    ScrollingFrame2.BackgroundTransparency = 1
    ScrollingFrame2.BorderSizePixel = 0
    ScrollingFrame2.ZIndex = 7
    ScrollingFrame2.ScrollBarThickness = 6
    ScrollingFrame2.ScrollBarImageColor3 = v30
    ScrollingFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame2.ElasticBehavior = Enum.ElasticBehavior.Always
    ScrollingFrame2.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame2.CanvasSize = UDim2.new()
    ScrollingFrame2.Parent = Frame4

    local MouseLeave = Instance.new("UIPadding", ScrollingFrame2)

    MouseLeave.PaddingLeft = UDim.new(0, 6)
    MouseLeave.PaddingRight = UDim.new(0, 6)
    MouseLeave.PaddingTop = UDim.new(0, 4)
    MouseLeave.PaddingBottom = UDim.new(0, 8)
    MouseLeave = Instance.new("UIListLayout")
    MouseLeave.SortOrder = Enum.SortOrder.LayoutOrder
    MouseLeave.Padding = UDim.new(0, 14)
    MouseLeave.Parent = ScrollingFrame2

    local v57 = text(Frame4, "NoLapTimes", "NO LAP TIMES SET YET", 680, 322, 1178, 40, 32)

    v57.TextColor3 = Color3.fromRGB(190, 195, 205)
    v57.ZIndex = 9
    v57.Visible = false

    local t8 = {}
    local v58

    local function leaderHeight() -- line: 224
        -- upvalues: v58 (ref)
        return v58 and v58.slot.Size.Y.Offset or 52
    end

    local function listFrame(p32) -- line: 225
        return UDim2.fromOffset(674, 316 + p32 + 14 - 4), UDim2.fromOffset(1190, 970 - (316 + p32 + 14 - 4))
    end

    local function placeList(p33) -- line: 228
        -- upvalues: Frame7 (copy), ScrollingFrame2 (copy)
        Frame7.Position = UDim2.fromOffset(680, 316)
        Frame7.Size = UDim2.fromOffset(1178, p33)

        local v59 = UDim2.fromOffset(674, 316 + p33 + 14 - 4)
        local v60 = UDim2.fromOffset(1190, 970 - (316 + p33 + 14 - 4))

        ScrollingFrame2.Position = v59
        ScrollingFrame2.Size = v60
    end

    Frame7.Position = UDim2.fromOffset(680, 316)
    Frame7.Size = UDim2.fromOffset(1178, 52)

    local v61 = UDim2.fromOffset(674, 378)
    local v62 = UDim2.fromOffset(1190, 592)

    ScrollingFrame2.Position = v61
    ScrollingFrame2.Size = v62

    local t9 = {}
    local t10 = {
        pos = { 14, 94, Center },
        flag = { 118, 56, Center },
        name = { 215, 360, Left },
        time = { 590, 220, Left },
        pts = { 830, 100, Center },
        bike = { 950, 200, Right }
    }

    local function cell(p34, p35, p36) -- line: 239
        -- upvalues: v27 (copy), v32 (copy), t10 (copy)
        local v63 = t10[p35]
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = p35
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.fromOffset(v63[1], 0)
        TextLabel.Size = UDim2.new(0, v63[2], 1, 0)
        TextLabel.FontFace = v27
        TextLabel.TextSize = 30
        TextLabel.TextXAlignment = v63[3]
        TextLabel.TextColor3 = v32
        TextLabel.Text = ""
        TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
        TextLabel.ZIndex = 4
        TextLabel.Parent = p34

        if p35 == "flag" then
            TextLabel.FontFace = Font.fromEnum(Enum.Font.BuilderSans)
            TextLabel.TextSize = 34
            TextLabel.TextTruncate = Enum.TextTruncate.None
        end

        p36.cells[p35] = TextLabel

        return TextLabel
    end

    local t11 = {}

    local function tween(p37, p38, p39, p40, p41, p42) -- line: 250
        -- upvalues: t11 (copy), TweenService (copy)
        local tween = TweenService:Create(p37, TweenInfo.new(p38, p41 or Enum.EasingStyle.Quint, p42 or Enum.EasingDirection.Out, 0, false, p40 or 0), p39)

        tween:Play()
        table.insert(t11, tween)

        return tween
    end

    local function revealRow(p43, p44) -- line: 254
        -- upvalues: tween (copy)
        p43.bar.Size = UDim2.fromOffset(0, 52)
        p43.bar.Position = UDim2.fromOffset(-48, 0)
        tween(p43.bar, 0.42, {
            Size = UDim2.fromOffset(1178, 52),
            Position = UDim2.new()
        }, p44)
    end

    local v64

    local function makeRow(p45) -- line: 262
        -- upvalues: v21 (copy), v27 (copy), v30 (copy), v31 (copy), Left (copy), Frame7 (copy), ScrollingFrame2 (copy), v58 (ref), cell (copy), v64 (ref), TweenService (copy)
        local t12 = {
            expanded = false,
            cells = {},
            sectors = {},
            id = p45
        }
        local Frame = Instance.new("Frame")

        Frame.Name = "Rider_" .. p45
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromOffset(1178, 52)
        Frame.ZIndex = 2

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "Bar"
        Frame2.BorderSizePixel = 0
        Frame2.BackgroundColor3 = v31
        Frame2.Size = UDim2.fromOffset(1178, 52)
        Frame2.ClipsDescendants = true
        Frame2.ZIndex = 3
        Frame2.Parent = Frame
        Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 18)

        local UIStroke = Instance.new("UIStroke")

        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Color = v30
        UIStroke.Thickness = 4
        UIStroke.Enabled = false
        UIStroke.Parent = Frame2
        t12.mineStroke = UIStroke

        local Frame3 = Instance.new("Frame")

        Frame3.Name = "Content"
        Frame3.BackgroundTransparency = 1
        Frame3.Size = UDim2.fromOffset(1178, 52)
        Frame3.ZIndex = 4
        Frame3.Parent = Frame2

        for _, v65 in { "pos", "flag", "name", "time", "pts", "bike" } do
            cell(Frame3, v65, t12)
        end

        local Frame4 = Instance.new("Frame")

        Frame4.Name = "LapSectors"
        Frame4.BackgroundColor3 = Color3.fromRGB(28, 32, 44)
        Frame4.BorderSizePixel = 0
        Frame4.Visible = false
        Frame4.ZIndex = 2
        Frame4.Position = UDim2.fromOffset(24, 56)
        Frame4.Size = UDim2.fromOffset(1130, 36)
        Frame4.Parent = Frame
        Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 10)

        local UIListLayout = Instance.new("UIListLayout")

        UIListLayout.FillDirection = Enum.FillDirection.Horizontal
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = Frame4
        Instance.new("UIPadding", Frame4).PaddingLeft = UDim.new(0, 20)

        for i = 0, 4 do
            local TextLabel = Instance.new("TextLabel")

            if i == 0 then
                TextLabel.Name = "LastLap"
            else
                TextLabel.Name = "Sector" .. i
            end

            TextLabel.LayoutOrder = i
            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.fromOffset(i == 0 and 300 or 200, 36)
            TextLabel.FontFace = v27
            TextLabel.TextSize = 22
            TextLabel.TextColor3 = v21
            TextLabel.TextXAlignment = Left
            TextLabel.Text = ""
            TextLabel.ZIndex = 3
            TextLabel.Parent = Frame4
            t12.sectors[i] = TextLabel
        end

        t12.detail = Frame4

        local TextButton = Instance.new("TextButton")

        TextButton.Name = "ToggleSectors"
        TextButton.Text = ""
        TextButton.BackgroundTransparency = 1
        TextButton.Size = UDim2.fromScale(1, 1)
        TextButton.ZIndex = 6
        TextButton.AutoButtonColor = false
        TextButton:SetAttribute("NoHover", true)
        TextButton.Parent = Frame2
        TextButton.InputBegan:Connect(function(p46) -- line: 283
            -- upvalues: t12 (copy), v64 (ref)
            if v64 then
                v64(t12, p46)
            end
        end)
        TextButton.Activated:Connect(function() -- line: 284
            -- upvalues: t12 (copy), Frame (copy), Frame4 (copy), Frame7 (copy), ScrollingFrame2 (copy), v58 (ref), TweenService (copy)
            if t12.suppressClick then
                t12.suppressClick = false
            else
                t12.expanded = not t12.expanded
                Frame:SetAttribute("SectorsExpanded", t12.expanded)

                local v66 = if t12.expanded then 92 else 52

                if t12.tween then
                    t12.tween:Cancel()
                end

                Frame4.Visible = t12.expanded

                local v67 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                t12.tween = TweenService:Create(Frame, v67, {
                    Size = UDim2.fromOffset(1178, v66)
                })
                t12.tween:Play()

                if t12 == v58 then
                    local v68 = UDim2.fromOffset(674, 316 + v66 + 14 - 4)
                    local v69 = UDim2.fromOffset(1190, 970 - (316 + v66 + 14 - 4))

                    TweenService:Create(Frame7, v67, {
                        Size = UDim2.fromOffset(1178, v66)
                    }):Play()
                    TweenService:Create(ScrollingFrame2, v67, {
                        Position = v68,
                        Size = v69
                    }):Play()
                end
            end
        end)
        t12.slot = Frame
        t12.bar = Frame2
        t12.row = Frame

        return t12
    end

    local function paint(p47, p48, p49) -- line: 301
        -- upvalues: v21 (copy), v30 (copy), v31 (copy), v32 (copy)
        if p47.lead == p48 and p47.mine == p49 then
            return
        end

        p47.lead = p48
        p47.mine = p49
        p47.bar.BackgroundColor3 = p48 and v30 or v31

        for v70, v71 in p47.cells do
            local v72

            if v70 == "time" or v70 == "pts" then
                if p48 then
                    v72 = v21

                    if not v21 then
                        v72 = v30

                        if not v30 then
                            v72 = v21 or v32
                        end
                    end
                else
                    v72 = v30 or v32
                end
            else
                v72 = p48 and v21 or v32
            end

            v71.TextColor3 = v72
        end

        p47.mineStroke.Enabled = p49
        p47.mineStroke.Color = p48 and v21 or v30
    end

    local v73, v74, v75, result4
    local n1 = 0
    local LegendRig = require(game.ReplicatedStorage.MotoLegends:WaitForChild("LegendRig"))
    local PodiumMedal = require(game.ReplicatedStorage.MotoLegends:WaitForChild("PodiumMedal"))

    local function wornMedals(p50) -- line: 316
        local t13 = {}

        for _, child in p50:GetChildren() do
            if child:IsA("Model") and child:GetAttribute("PodiumMedal") then
                table.insert(t13, child)
            end
        end

        return t13
    end

    local t14 = {
        { "LowerTorso", "HumanoidRootPart", "Root" },
        { "UpperTorso", "LowerTorso", "Waist" },
        { "Head", "UpperTorso", "Neck" },
        { "RightUpperArm", "UpperTorso", "RightShoulder" },
        { "RightLowerArm", "RightUpperArm", "RightElbow" },
        { "RightHand", "RightLowerArm", "RightWrist" },
        { "LeftUpperArm", "UpperTorso", "LeftShoulder" },
        { "LeftLowerArm", "LeftUpperArm", "LeftElbow" },
        { "LeftHand", "LeftLowerArm", "LeftWrist" },
        { "RightUpperLeg", "LowerTorso", "RightHip" },
        { "RightLowerLeg", "RightUpperLeg", "RightKnee" },
        { "RightFoot", "RightLowerLeg", "RightAnkle" },
        { "LeftUpperLeg", "LowerTorso", "LeftHip" },
        { "LeftLowerLeg", "LeftUpperLeg", "LeftKnee" },
        { "LeftFoot", "LeftLowerLeg", "LeftAnkle" }
    }

    local function posePortrait(p51, p52) -- line: 329
        -- upvalues: PodiumMedal (copy), wornMedals (copy), t14 (copy)
        local t15 = {}

        for _, child in p51:GetChildren() do
            if child:IsA("BasePart") then
                for _, child2 in child:GetChildren() do
                    if child2:IsA("Attachment") then
                        t15[child2.Name] = {
                            part = child,
                            attachment = child2
                        }
                    end
                end
            end
        end

        local t16 = {}

        for _, child in p51:GetChildren() do
            if child:IsA("Accessory") then
                local Handle = child:FindFirstChild("Handle")

                if Handle and Handle:IsA("BasePart") then
                    local t17 = {
                        handle = Handle,
                        parts = {}
                    }

                    for _, descendant in child:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            t17.parts[descendant] = Handle.CFrame:ToObjectSpace(descendant.CFrame)
                        end
                    end

                    for _, child in Handle:GetChildren() do
                        if child:IsA("Attachment") and t15[child.Name] then
                            t17.body = t15[child.Name].part
                            t17.offset = t15[child.Name].attachment.CFrame * child.CFrame:Inverse()
                            break
                        end
                    end

                    if not t17.body then
                        for _, descendant in p51:GetDescendants() do
                            if descendant:IsA("JointInstance") or descendant:IsA("WeldConstraint") then
                                local Part0, Part1 = descendant.Part0, descendant.Part1

                                if Part0 ~= Handle or not Part1 then
                                    Part1 = Part1 == Handle and Part0
                                end

                                if Part1 and Part1.Parent == p51 then
                                    t17.body = Part1
                                    t17.offset = if descendant:IsA("JointInstance") then Part0 == Part1 and descendant.C0 * descendant.C1:Inverse() or descendant.C1 * descendant.C0:Inverse() else Part1.CFrame:ToObjectSpace(Handle.CFrame)
                                    break
                                end
                            end
                        end
                    end

                    if t17.body then
                        table.insert(t16, t17)
                    end
                end
            end
        end

        local v76 = wornMedals(p51)

        for _, descendant in p51:GetDescendants() do
            if descendant:IsA("JointInstance") then
                descendant:Destroy()
            elseif descendant:IsA("Constraint") then
                descendant:Destroy()
            elseif descendant:IsA("WeldConstraint") then
                descendant:Destroy()
            elseif descendant:IsA("Animator") then
                descendant:Destroy()
            end
        end

        local v77 = p52 or {
            Waist = CFrame.Angles(0, -0.10471975511965978, 0),
            Neck = CFrame.Angles(-0.05235987755982989, 0.13962634015954636, 0.03490658503988659),
            RightShoulder = CFrame.Angles(0.13962634015954636, -0.13962634015954636, -0.24434609527920614),
            RightElbow = CFrame.Angles(1.3089969389957472, 0.7853981633974483, 0),
            RightWrist = CFrame.Angles(0, 0.13962634015954636, -0.13962634015954636),
            LeftShoulder = CFrame.Angles(0, 0.13962634015954636, 0.24434609527920614),
            LeftElbow = CFrame.Angles(1.53588974175501, -0.9599310885968813, 0),
            LeftWrist = CFrame.Angles(0, -0.13962634015954636, 0.13962634015954636)
        }

        for _, v78 in t14 do
            local v79 = p51:FindFirstChild(v78[1])
            local v80 = p51:FindFirstChild(v78[2])
            local v81 = v80 and v80:FindFirstChild(v78[3] .. "RigAttachment")

            if v79 then
                local v82 = v79:FindFirstChild(v78[3] .. "RigAttachment")

                if v80 and v81 and v82 then
                    v79.CFrame = v80.CFrame * v81.CFrame * (v77[v78[3]] or CFrame.identity) * v82.CFrame:Inverse()
                end
            end
        end

        local UpperTorso = p51:FindFirstChild("UpperTorso")

        local function aim(p53, p54, p55, p56) -- line: 379
            local Unit = p53.CFrame:VectorToWorldSpace(p55).Unit
            local Unit2 = p56.Unit
            local v83 = Unit:Cross(Unit2)

            if not (v83.Magnitude > 1E-05) then
                return
            end

            local v86 = CFrame.fromAxisAngle(v83.Unit, (math.acos((math.clamp(Unit:Dot(Unit2), -1, 1)))))

            p53.CFrame = CFrame.new(p54) * v86 * CFrame.new(-p54) * p53.CFrame
        end

        if UpperTorso and not p52 then
            for _, v87 in {
                    { "Right", 1 },
                    { "Left", -1 }
                } do
                local v88 = v87[1]
                local v89 = v87[2]
                local v90 = p51:FindFirstChild(v88 .. "UpperArm")
                local v91 = p51:FindFirstChild(v88 .. "LowerArm")
                local v92 = p51:FindFirstChild(v88 .. "Hand")
                local v93 = UpperTorso:FindFirstChild(v88 .. "ShoulderRigAttachment")
                local v94, v95

                if v90 then
                    v94 = v90:FindFirstChild(v88 .. "ShoulderRigAttachment")
                    v95 = v90:FindFirstChild(v88 .. "ElbowRigAttachment")
                else
                    v95 = v90
                    v94 = v90
                end

                local v96, v97

                if v91 then
                    v96 = v91:FindFirstChild(v88 .. "ElbowRigAttachment")
                    v97 = v91:FindFirstChild(v88 .. "WristRigAttachment")
                else
                    v97 = v91
                    v96 = v91
                end

                local v98 = v92 and v92:FindFirstChild(v88 .. "WristRigAttachment")

                if v93 and v94 and v95 and v96 and v97 and v98 then
                    local Position = (UpperTorso.CFrame * v93.CFrame).Position
                    local v100 = UpperTorso.CFrame:PointToWorldSpace((Vector3.new(v89 * 0.15, -0.25, -0.85)))
                    local Magnitude = (v95.Position - v94.Position).Magnitude
                    local Magnitude2 = (v97.Position - v96.Position).Magnitude
                    local v101 = v100 - Position
                    local Unit = v101.Unit
                    local v105 = math.clamp(v101.Magnitude, math.abs(Magnitude - Magnitude2) + 0.001, Magnitude + Magnitude2 - 0.001)
                    local v106 = Position + Unit * v105
                    local v107 = UpperTorso.CFrame.RightVector * v89 * 0.7 - UpperTorso.CFrame.UpVector * 0.7
                    local Unit2 = (v107 - Unit * v107:Dot(Unit)).Unit
                    local v108 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v105 * v105) / (v105 * 2)
                    local v112 = Position + Unit * v108 + Unit2 * math.sqrt((math.max(0, Magnitude * Magnitude - v108 * v108)))

                    v90.CFrame = UpperTorso.CFrame * v93.CFrame * v94.CFrame:Inverse()
                    aim(v90, Position, v95.Position - v94.Position, v112 - Position)
                    v91.CFrame = v90.CFrame * v95.CFrame * v96.CFrame:Inverse()
                    aim(v91, v112, v97.Position - v96.Position, v106 - v112)
                    v92.CFrame = v91.CFrame * v97.CFrame * v98.CFrame:Inverse()
                end
            end
        end

        for _, v113 in t16 do
            local v114 = v113.body.CFrame * v113.offset

            for v115, v116 in v113.parts do
                v115.CFrame = v114 * v116
            end
        end

        local v117 = p51:FindFirstChild("UpperTorso") or p51:FindFirstChild("Torso")

        if v117 then
            for _, v118 in v76 do
                local v119, v120, v121 = PodiumMedal.Worn(v117.CFrame, v117.Size)
                local _CFrame = v117.CFrame
                local v122 = _CFrame:ToObjectSpace(v119)
                local v123 = v122.Position.Z

                for _, v124 in { "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand", "Left Arm", "Right Arm" } do
                    local v125 = p51:FindFirstChild(v124)

                    if v125 and v125:IsA("BasePart") then
                        local v126 = v125.Size / 2

                        for _, v128 in { Vector3.new(1, 1, 1), Vector3.new(1, 1, -1), Vector3.new(1, -1, 1), Vector3.new(1, -1, -1), Vector3.new(-1, 1, 1), Vector3.new(-1, 1, -1), Vector3.new(-1, -1, 1), (Vector3.new(-1, -1, -1)) } do
                            local v129 = _CFrame:PointToObjectSpace(v125.CFrame:PointToWorldSpace(v126 * v128))

                            if math.abs(v129.X - v122.Position.X) < 0.5 and math.abs(v129.Y - v122.Position.Y) < 0.45 then
                                v123 = math.min(v123, v129.Z - 0.06)
                            end
                        end
                    end
                end

                local v133 = _CFrame * CFrame.new(v122.Position.X, v122.Position.Y, v123) * v122.Rotation

                for v134, v135 in PodiumMedal.Layout(v118, v133, v120, v121) do
                    v134.CFrame = v135
                end
            end
        end
    end

    local v136

    local function framePortrait() -- line: 444
        -- upvalues: ViewportFrame (copy), Camera (copy), v136 (ref)
        if not v136 then
            return
        end

        local v137 = v136[1]
        local v138 = v136[2]
        local AbsoluteSize = ViewportFrame.AbsoluteSize
        local v139, v140

        if AbsoluteSize.X > 1 and AbsoluteSize.Y > 1 then
            local v141 = AbsoluteSize.X / AbsoluteSize.Y

            if v141 then
                v139 = v141
                v140 = true
            else
                v140 = false
            end
        else
            v140 = false
        end

        if not v140 then
            v139 = 0.75
        end

        local v144 = math.tan((math.rad(Camera.FieldOfView / 2)))
        local v145 = v138.Y / 2
        local v146 = v138.X / 2
        local v149 = math.max(v145 / v144, v146 / (v144 * v139)) * 1.02 + v138.Z / 2

        Camera.CFrame = CFrame.lookAt(v137 + Vector3.new(0, 0, v149), v137)
    end

    ViewportFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(framePortrait)

    local function measurePortrait(p57) -- line: 454
        local v150 = Vector3.new(1e999, 1e999, 1e999)
        local v151 = Vector3.new((-1e999), (-1e999), (-1e999))

        for _, descendant in p57:GetDescendants() do
            if descendant:IsA("BasePart") and descendant.Transparency < 1 and descendant.Name ~= "HumanoidRootPart" then
                local v152 = descendant.Size / 2

                for _, v155 in { Vector3.new(1, 1, 1), Vector3.new(1, 1, -1), Vector3.new(1, -1, 1), Vector3.new(1, -1, -1), Vector3.new(-1, 1, 1), Vector3.new(-1, 1, -1), Vector3.new(-1, -1, 1), (Vector3.new(-1, -1, -1)) } do
                    local v156 = descendant.CFrame:PointToWorldSpace(v152 * v155)

                    v150 = v150:Min(v156)
                    v151 = v151:Max(v156)
                end
            end
        end

        return if v150.X ~= 1e999 then {
            (v150 + v151) / 2,
            v151 - v150
        } else nil
    end

    local function updatePortrait(p58) -- line: 468
        -- upvalues: v48 (copy), WorldModel (copy), v50 (ref), v73 (ref), v74 (ref), v75 (ref), result4 (ref), n1 (ref), LegendRig (copy), wornMedals (copy), posePortrait (copy), v136 (ref), framePortrait (copy), measurePortrait (copy)
        local SelectedLegend, v157

        if p58 then
            v157 = p58.Character
            SelectedLegend = p58:GetAttribute("SelectedLegend")
        else
            v157 = p58
        end

        if not p58 or not SelectedLegend then
            SelectedLegend = nil
        end

        if SelectedLegend == "" then
            SelectedLegend = nil
        end

        local v158, v159

        if p58 then
            local v160 = string.upper(p58.DisplayName or p58.Name or "")

            if v160 then
                v158 = v160
                v159 = true
            else
                v159 = false
            end
        else
            v159 = false
        end

        if not v159 then
            v158 = ""
        end

        if v48.Text ~= v158 then
            v48.Text = v158
        end

        local v161 = v157 and #wornMedals(v157) or 0

        if p58 == v73 and v157 == v74 and SelectedLegend == v75 and v161 == n1 and #WorldModel:GetChildren() > 0 then
            return
        end

        WorldModel:ClearAllChildren()
        v73 = p58
        v74 = v157
        v75 = SelectedLegend
        n1 = v161
        result4 = nil
        v136 = nil

        if v157 and v157:FindFirstChild("HumanoidRootPart") then
            local Archivable = v157.Archivable

            v157.Archivable = true

            local v162 = v157

            local function v163() -- line: 478
                -- upvalues: v162 (copy)
                return v162:Clone()
            end

            local ok, result = pcall(v163)

            v157.Archivable = Archivable

            if ok and result then
                for _, descendant in result:GetDescendants() do
                    if descendant:IsA("BaseScript")
                        or descendant:IsA("Sound")
                        or descendant:IsA("BillboardGui")
                        or descendant:IsA("ForceField")
                        or descendant:IsA("ParticleEmitter")
                        or descendant:IsA("Animator") then
                        descendant:Destroy()
                    elseif descendant:IsA("BasePart") then
                        descendant.Anchored = true
                        descendant.CanCollide = false
                        descendant.LocalTransparencyModifier = 0
                    end
                end

                local Humanoid = result:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    Humanoid.PlatformStand = true
                    Humanoid.EvaluateStateMachine = false
                end

                local v164 = LegendRig.JointRotations(SelectedLegend)

                posePortrait(result, v164)

                local v165 = v164 and 3.141592653589793 + LegendRig.DisplayYaw(SelectedLegend) or 2.792526803190927

                result:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, v165, 0))
                result.Parent = WorldModel
                result4 = result
                v136 = measurePortrait(result)

                if v136 and v164 then
                    local v166 = v136

                    v166[2] = v136[2] * 1.08
                end

                framePortrait()
            end
        end

        if v50 then
            v50.Refresh()
        end
    end

    game:GetService("RunService").RenderStepped:Connect(function() -- line: 498
        -- upvalues: Frame (copy), v75 (ref), result4 (ref), LegendRig (copy), posePortrait (copy)
        if result4 and result4.Parent and v75 and Frame.Visible then
            posePortrait(result4, LegendRig.JointRotations(v75, os.clock()))
        end
    end)

    local v167, t18
    local v168 = false
    local t19 = {}
    local v169
    local v170 = false

    local function canEdit() -- line: 511
        -- upvalues: p6 (copy), MotoLegends (copy), Players (copy)
        local LocalPlayer = Players.LocalPlayer

        if MotoLegends:GetAttribute("RaceDirectorServer") == true and LocalPlayer ~= nil and LocalPlayer:GetAttribute("RaceDirectorAccess") == true and p6:GetAttribute("RaceDirectorMode") == true then
            return MotoLegends:FindFirstChild("RaceDirectorAction") ~= nil
        end

        return false
    end

    local function canDrag() -- line: 516
        -- upvalues: v170 (ref), canEdit (copy)
        return v170 and canEdit()
    end

    local function applyManualOrder(p59) -- line: 517
        -- upvalues: MotoLegends (copy), v169 (ref)
        local v171 = v169 or MotoLegends:GetAttribute("RDLapOrder") or ""

        if v171 == "" then
            return p59
        end

        local t20 = {}
        local n2 = 0

        for match in tostring(v171):gmatch("%-?%d+") do
            n2 += 1
            t20[tonumber(match)] = n2
        end

        local t21 = {}

        for v172, v173 in p59 do
            t21[v173] = v172
        end

        local v174 = table.clone(p59)

        table.sort(v174, function(p60, p61) -- line: 524
            -- upvalues: t20 (copy), t21 (copy)
            local v175 = t20[p60.UserId]
            local v176 = t20[p61.UserId]

            if v175 and v176 then
                return v175 < v176
            end

            if v175 or v176 then
                return v175 ~= nil
            end

            return t21[p60] < t21[p61]
        end)

        return v174
    end

    local v177 = text(Frame4, "DirectorHint", "RACE DIRECTOR · DRAG A BAR TO MOVE A RIDER", 1098, 262, 760, 30, 22)

    v177.TextXAlignment = Right
    v177.TextColor3 = v30
    v177.Visible = false

    local TextButton2 = Instance.new("TextButton")

    TextButton2.Name = "EditOrder"
    TextButton2.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton2.Position = UDim2.fromOffset(870, 1042)
    TextButton2.Size = UDim2.fromOffset(240, 60)
    TextButton2.AutoButtonColor = false
    TextButton2:SetAttribute("NoHover", true)
    TextButton2.BorderSizePixel = 0
    TextButton2.BackgroundColor3 = v21
    TextButton2.FontFace = v27
    TextButton2.TextSize = 30
    TextButton2.TextColor3 = v32
    TextButton2.Text = "EDIT"
    TextButton2.ZIndex = 20
    TextButton2.Visible = false
    TextButton2.Parent = Frame4
    Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(1, 0)

    local UIScale3 = Instance.new("UIScale", TextButton2)

    local function paintEdit(p62) -- line: 540
        -- upvalues: v21 (copy), v30 (copy), v32 (copy), v170 (ref), TextButton2 (copy)
        local v178 = v170 or p62

        TextButton2.BackgroundColor3 = v178 and v30 or v21
        TextButton2.TextColor3 = v178 and v21 or v32
        TextButton2.Text = v170 and "DONE" or "EDIT"
    end

    TextButton2.MouseEnter:Connect(function() -- line: 545
        -- upvalues: v21 (copy), v30 (copy), v32 (copy), v170 (ref), TextButton2 (copy), UIScale3 (copy), TweenService (copy)
        TweenService:Create(UIScale3, TweenInfo.new(0.12), {
            Scale = 1.05
        }):Play()
        TextButton2.BackgroundColor3 = v30 or v21
        TextButton2.TextColor3 = v21 or v32
        TextButton2.Text = v170 and "DONE" or "EDIT"
    end)
    TextButton2.MouseLeave:Connect(function() -- line: 546
        -- upvalues: v21 (copy), v30 (copy), v32 (copy), v170 (ref), TextButton2 (copy), UIScale3 (copy), TweenService (copy)
        TweenService:Create(UIScale3, TweenInfo.new(0.12), {
            Scale = 1
        }):Play()

        local v183 = v170 or false

        TextButton2.BackgroundColor3 = v183 and v30 or v21
        TextButton2.TextColor3 = v183 and v21 or v32
        TextButton2.Text = v170 and "DONE" or "EDIT"
    end)

    local clone = TextButton2:Clone()

    clone.Name = "ResetOrder"
    clone.Position = UDim2.fromOffset(1130, 1042)
    clone.Text = "RESET"
    clone.Parent = Frame4

    local UIScale4 = clone:FindFirstChildOfClass("UIScale")

    local function manualOrder() -- line: 549
        -- upvalues: MotoLegends (copy), v169 (ref)
        return (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") ~= ""
    end

    local function paintReset(p63) -- line: 550
        -- upvalues: v21 (copy), MotoLegends (copy), v30 (copy), v32 (copy), v169 (ref), clone (copy)
        local v186 = (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") ~= ""

        clone.BackgroundColor3 = if p63 and v186 and v30 then v30 else v21
        clone.TextColor3 = if p63 and v186 and v21 then v21 else v32
        clone.BackgroundTransparency = v186 and 0 or 0.45
        clone.TextTransparency = v186 and 0 or 0.45
    end

    clone.MouseEnter:Connect(function() -- line: 555
        -- upvalues: v21 (copy), MotoLegends (copy), v30 (copy), v32 (copy), v169 (ref), clone (copy), UIScale4 (copy), TweenService (copy)
        if (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") ~= "" then
            TweenService:Create(UIScale4, TweenInfo.new(0.12), {
                Scale = 1.05
            }):Play()
        end

        local v189 = (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") ~= ""

        clone.BackgroundColor3 = v189 and v30 or v21
        clone.TextColor3 = v189 and v21 or v32
        clone.BackgroundTransparency = v189 and 0 or 0.45
        clone.TextTransparency = v189 and 0 or 0.45
    end)
    clone.MouseLeave:Connect(function() -- line: 556
        -- upvalues: v21 (copy), MotoLegends (copy), v32 (copy), v169 (ref), clone (copy), UIScale4 (copy), TweenService (copy)
        TweenService:Create(UIScale4, TweenInfo.new(0.12), {
            Scale = 1
        }):Play()

        local v192 = (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") ~= ""

        clone.BackgroundColor3 = v21
        clone.TextColor3 = v32
        clone.BackgroundTransparency = v192 and 0 or 0.45
        clone.TextTransparency = v192 and 0 or 0.45
    end)

    local function syncEdit() -- line: 557
        -- upvalues: v21 (copy), MotoLegends (copy), v30 (copy), v32 (copy), v169 (ref), v170 (ref), canEdit (copy), v177 (copy), TextButton2 (copy), clone (copy)
        local v193 = canEdit()

        if not v193 then
            v170 = false
        end

        TextButton2.Visible = v193
        clone.Visible = v193

        local v194 = (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") ~= ""

        clone.BackgroundColor3 = v21
        clone.TextColor3 = v32
        clone.BackgroundTransparency = v194 and 0 or 0.45
        clone.TextTransparency = v194 and 0 or 0.45
        v177.Visible = v193 and v170

        local v195 = v170 or false

        TextButton2.BackgroundColor3 = v195 and v30 or v21
        TextButton2.TextColor3 = v195 and v21 or v32
        TextButton2.Text = v170 and "DONE" or "EDIT"
    end

    local function setText(p64, p65) -- line: 565
        if p64.Text ~= p65 then
            p64.Text = p65
        end
    end

    local function flag(p66) -- line: 566
        if typeof(p66) ~= "string" or #p66 ~= 2 then
            return "🏁"
        end

        local v198 = p66:upper()
        local v199 = v198:byte(1)
        local v200 = v198:byte(2)

        if not (v199 < 65) and not (v199 > 90) and not (v200 < 65) and not (v200 > 90) then
            return utf8.char(127462 + v199 - 65, 127462 + v200 - 65)
        end

        return "🏁"
    end

    local function sessionTitle() -- line: 572
        -- upvalues: MotoLegends (copy), v167 (ref)
        if v167 then
            local v201 = v167.title or ""

            if v201 == "QUALIFYING RESULTS" then
                return "QUALIFYING RESULT"
            end

            if v201 == "SPRINT RESULTS" then
                return "SPRINT RESULT"
            end

            return v201
        end

        local SessionPhase = MotoLegends:GetAttribute("SessionPhase")

        if SessionPhase == "Racing" then
            return "SPRINT RACE"
        end

        local v202 = MotoLegends:GetAttribute("SessionPractice") == true

        if (SessionPhase == "Qualifying" or SessionPhase == "QualifyingFinish") and not v202 then
            return "QUALIFYING TIME"
        end

        if SessionPhase ~= "QualifyingResults" and SessionPhase ~= "Grid" and SessionPhase ~= "Lights" then
            return "PRACTICE TIME"
        end

        return "QUALIFYING TIME"
    end

    local function rebuildLaps() -- line: 587
        -- upvalues: v20 (copy), LocalPlayer (copy), v21 (copy), MotoLegends (copy), v30 (copy), v32 (copy), Frame (copy), Folder (copy), teamId (copy), v48 (copy), WorldModel (copy), v50 (ref), v52 (copy), Frame7 (copy), ScrollingFrame2 (copy), v57 (copy), t8 (copy), v58 (ref), t9 (copy), revealRow (copy), makeRow (copy), paint (copy), v73 (ref), v74 (ref), v75 (ref), result4 (ref), n1 (ref), v136 (ref), updatePortrait (copy), v167 (ref), t18 (ref), v168 (ref), t19 (copy), v169 (ref), v170 (ref), canEdit (copy), applyManualOrder (copy), v177 (copy), TextButton2 (copy), clone (copy), flag (copy), sessionTitle (copy), t2 (copy)
        local t22 = {}
        local v203 = sessionTitle()

        if v52.Text ~= v203 then
            v52.Text = v203
        end

        local v204 = not v167 and MotoLegends:GetAttribute("SessionPhase") == "Racing"

        v203 = v167 and v167.title ~= "QUALIFYING RESULTS"

        local v205 = {}

        if v167 then
            v205 = t18
        else
            for _, player in v20:GetPlayers() do
                if not v204 or player:GetAttribute("RaceParticipant") == true then
                    table.insert(v205, player)
                end
            end
        end

        if v204 then
            table.sort(v205, function(p67, p68) -- line: 599
                local v206 = if p67:GetAttribute("RaceParticipant") then p67:GetAttribute("RacePosition") or 999 else 10000
                local v207 = if p68:GetAttribute("RaceParticipant") then p68:GetAttribute("RacePosition") or 999 else 10000

                if v206 ~= v207 then
                    return v206 < v207
                end

                local v208 = p67:GetAttribute("BestLapTime") or 0
                local v209 = p68:GetAttribute("BestLapTime") or 0

                if not (v208 > 0) or not v208 then
                    v208 = 1e999
                end

                if not (v209 > 0) or not v209 then
                    v209 = 1e999
                end

                if v208 == v209 then
                    return p67.UserId < p68.UserId
                end

                return v208 < v209
            end)
        end

        v57.Visible = #v205 == 0

        local t23 = {}
        local v211 = applyManualOrder(if (v204 or v167) and v205 then v205 else t2.LapOrder(v205))

        table.clear(t19)

        local v210 = canEdit()

        if not v210 then
            v170 = false
        end

        TextButton2.Visible = v210
        clone.Visible = v210
        v204 = (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") ~= ""
        clone.BackgroundColor3 = v21
        clone.TextColor3 = v32
        clone.BackgroundTransparency = v204 and 0 or 0.45
        clone.TextTransparency = v204 and 0 or 0.45
        v177.Visible = v210 and v170
        v205 = v170 or false

        local v212 = v205 and v30 or v21

        TextButton2.BackgroundColor3 = v212
        TextButton2.TextColor3 = v205 and v21 or v32
        TextButton2.Text = v170 and "DONE" or "EDIT"

        local v214

        for v215, v216 in v211 do
            t19[v215] = v216.UserId

            local v217 = v216.UserId == LocalPlayer.UserId

            t22[v216.UserId] = true

            local v218 = t8[v216.UserId]

            if v218 then
                if not v218.slot.Parent then
                    v218.slot:Destroy()
                    v218 = makeRow(v216.UserId)
                    t8[v216.UserId] = v218
                    table.insert(t23, v218)
                end
            else
                v218 = makeRow(v216.UserId)
                t8[v216.UserId] = v218
                table.insert(t23, v218)
            end

            local v219 = v215 == 1
            local cells = v219 and Frame7 or ScrollingFrame2

            if v218.slot.Parent ~= cells then
                if v218.expanded then
                    v218.expanded = false
                    v218.detail.Visible = false

                    if v218.tween then
                        v218.tween:Cancel()
                    end

                    v218.slot.Size = UDim2.fromOffset(1178, 52)
                end

                v218.slot.Parent = cells
            end

            if v219 then
                v214 = v218
            end

            v218.slot.LayoutOrder = v215
            paint(v218, v219, v217)
            cells = v218.cells

            local time = cells.pos
            local upper = tostring(v215)

            if time.Text ~= upper then
                time.Text = upper
            end

            time = cells.flag
            upper = flag(v216:GetAttribute("Country"))

            if time.Text ~= upper then
                time.Text = upper
            end

            cells.name.AutoLocalize = false
            time = cells.name
            upper = string.upper(v216.DisplayName or v216.Name or "")

            if time.Text ~= upper then
                time.Text = upper
            end

            cells.pts.Visible = v203 == true
            time = cells.time

            local DisplayName, v220, v221, format, v222, v223, format2

            if v203 then
                if v216.Result.finish then
                    if v215 == 1 then
                        DisplayName = v216.Result.adjustedTime or v216.Result.elapsed

                        if not DisplayName or DisplayName <= 0 then
                            upper = "-:--.---"
                        else
                            format = DisplayName * 1000 + 0.5
                            v220 = math.floor(format)

                            local format3 = string.format

                            format2 = v220 / 60000
                            v223 = math.floor(format2)
                            v221 = v220 / 1000
                            upper = format3("%d:%02d.%03d", v223, math.floor(v221) % 60, v220 % 1000)
                        end

                        upper = upper or v216.Result.resultGap ~= nil and string.format("+%.3f", v216.Result.resultGap) or "—"
                    else
                        upper = v216.Result.resultGap ~= nil and string.format("+%.3f", v216.Result.resultGap) or "—"
                    end
                else
                    DisplayName = v216.Result.status or "DNF"
                    upper = tostring(DisplayName)
                end

                if time.Text ~= upper then
                    time.Text = upper
                end

                time = cells.pts
                format = v216.Result.sprintPoints or 0
                DisplayName = "+" .. tostring(format)

                if time.Text ~= DisplayName then
                    time.Text = DisplayName
                end
            else
                DisplayName = v216:GetAttribute("BestLapTime")

                if not DisplayName or DisplayName <= 0 then
                    upper = "-:--.---"
                else
                    format = DisplayName * 1000 + 0.5
                    v220 = math.floor(format)
                    format = string.format
                    format2 = math.floor(v220 / 60000)
                    v222 = v220 / 1000
                    upper = format("%d:%02d.%03d", format2, math.floor(v222) % 60, v220 % 1000)
                end

                if time.Text ~= upper then
                    time.Text = upper
                end
            end

            time = v218.sectors[0]
            format = v216:GetAttribute("LastLapTime")

            if not format or format <= 0 then
                v220 = "-:--.---"
            else
                format2 = format * 1000 + 0.5
                v223 = math.floor(format2)
                format2 = string.format
                v222 = v223 / 60000
                v221 = math.floor(v222)
                v220 = format2("%d:%02d.%03d", v221, math.floor(v223 / 1000) % 60, v223 % 1000)
            end

            DisplayName = "LAST  " .. v220

            if time.Text ~= DisplayName then
                time.Text = DisplayName
            end

            for i = 1, 4 do
                v220 = v216:GetAttribute("LastSectorTime" .. i)
                format = v218.sectors[i]

                local v226, v227

                if v220 and v220 > 0 then
                    v222 = string.format("%.3f", v220)

                    if v222 then
                        v226 = v222
                        v227 = true
                    else
                        v227 = false
                    end
                else
                    v227 = false
                end

                if not v227 then
                    v226 = "--.---"
                end

                format2 = "S" .. i .. "  " .. v226

                if format.Text ~= format2 then
                    format.Text = format2
                end
            end

            time = (v216:GetAttribute("BikeName") or "DUCATI"):upper()

            local bike = cells.bike

            upper = t9[time] or time

            if bike.Text ~= upper then
                bike.Text = upper
            end

            if v219 then
                updatePortrait(v216)
                time = v216:GetAttribute("BikeName")
                upper = teamId(time)

                if Folder:GetAttribute("SelectedBike") ~= upper then
                    Folder:SetAttribute("SelectedBike", upper)
                end
            end
        end

        for v228, v229 in t8 do
            if not t22[v228] then
                v229.slot:Destroy()
                t8[v228] = nil
            end
        end

        if v58 ~= v214 then
            v58 = v214
            v212 = v58

            local Offset = if v212 then v58.slot.Size.Y.Offset else nil

            if not v212 or not Offset then
                Offset = 52
            end

            Frame7.Position = UDim2.fromOffset(680, 316)
            Frame7.Size = UDim2.fromOffset(1178, Offset)

            local v230 = UDim2.fromOffset(674, 316 + Offset + 14 - 4)
            local insert = UDim2.fromOffset(1190, 970 - (316 + Offset + 14 - 4))

            ScrollingFrame2.Position = v230
            ScrollingFrame2.Size = insert
        end

        if next(t22) == nil then
            v211 = nil

            if v48.Text ~= "" then
                v48.Text = ""
            end

            if v73 ~= nil or v74 ~= nil or v211 ~= v75 or n1 ~= 0 or not (#WorldModel:GetChildren() > 0) then
                WorldModel:ClearAllChildren()
                v73 = nil
                v74 = nil
                v75 = v211
                n1 = 0
                result4 = nil
                v136 = nil

                if v50 then
                    v50.Refresh()
                end
            end

            if Folder:GetAttribute("SelectedBike") ~= "Ducati" then
                Folder:SetAttribute("SelectedBike", "Ducati")
            end
        end

        if Frame.Visible and not v168 then
            for _, v231 in t23 do
                revealRow(v231, 0)
            end
        end

        return t23
    end

    local result5
    local v232 = false
    local v233 = false

    local function fadeInLights(p69) -- line: 660
        -- upvalues: tween (copy), result5 (ref)
        if result5 and result5.Parent then
            for _, child in result5:GetChildren() do
                if child:IsA("ImageLabel") then
                    child.ImageTransparency = 1
                    tween(child, 0.8, {
                        ImageTransparency = 0
                    }, p69 or 0, Enum.EasingStyle.Quad)
                end
            end
        end
    end

    local function startFX() -- line: 666
        -- upvalues: Frame (copy), MenuFX (copy), t5 (copy), Folder (copy), Frame5 (copy), result5 (ref), v232 (ref), v233 (ref), fadeInLights (copy)
        if v232 or v233 or result5 and result5.Parent or not MenuFX then
            return
        end

        v232 = true
        task.spawn(function() -- line: 669
            -- upvalues: Frame (copy), MenuFX (copy), t5 (copy), Folder (copy), Frame5 (copy), result5 (ref), v232 (ref), v233 (ref), fadeInLights (copy)
            local function v234() -- line: 670
                -- upvalues: MenuFX (copy), t5 (copy), Folder (copy), Frame5 (copy)
                return require(MenuFX.MenuBackgroundFX).Start(Frame5, Folder, t5)
            end

            local ok, result = pcall(v234)

            v232 = false

            if ok then
                if result then
                    result5 = result

                    if Frame.Visible then
                        fadeInLights(0)
                    end
                else
                    v233 = true
                end
            else
                v233 = true
                warn("[LapTimes] light FX: " .. tostring(result))
            end
        end)
    end

    game:GetService("RunService").RenderStepped:Connect(function() -- line: 678
        -- upvalues: Frame (copy), t4 (copy), Folder (copy), result5 (ref)
        if Frame.Visible then
            if not (result5 and result5.Parent) then
                local v235 = t4[Folder:GetAttribute("SelectedBike")] or t4.Ducati

                if Folder:GetAttribute("CurrentColor") ~= v235 then
                    Folder:SetAttribute("CurrentColor", v235)
                end
            else
                for _, v236 in { "CurrentColor", "LeftBrightness", "RightBrightness" } do
                    local Attribute = result5:GetAttribute(v236)

                    if Attribute ~= nil and Folder:GetAttribute(v236) ~= Attribute then
                        Folder:SetAttribute(v236, Attribute)
                    end
                end
            end
        end
    end)

    local t24 = {
        result2,
        v51,
        v52
    }
    local t25 = {}

    for _, v237 in t24 do
        t25[v237] = v237.Position
    end

    local n3 = 0

    local function playIntro() -- line: 695
        -- upvalues: ImageLabel (copy), v47 (copy), v48 (copy), v49 (copy), ViewportFrame (copy), Frame6 (copy), v56 (copy), ImageLabel3 (copy), v57 (copy), t8 (copy), v58 (ref), t11 (copy), tween (copy), revealRow (copy), v168 (ref), fadeInLights (copy), t24 (copy), t25 (copy), n3 (ref)
        for _, v238 in t11 do
            v238:Cancel()
        end

        table.clear(t11)
        n3 += 1

        local v239 = n3

        v168 = true

        for v240, v241 in t24 do
            v241.Position = t25[v241] + UDim2.fromOffset(-60, 0)
            v241.TextTransparency = 1
            tween(v241, 0.5, {
                TextTransparency = 0,
                Position = t25[v241]
            }, 0.05 * (v240 - 1))
        end

        Frame6.Size = UDim2.fromOffset(0, 8)
        tween(Frame6, 0.6, {
            Size = UDim2.fromOffset(660, 8)
        }, 0.15)
        ViewportFrame.ImageTransparency = 1
        ViewportFrame.Position = v49 + UDim2.fromOffset(-90, 0)
        tween(ViewportFrame, 0.65, {
            ImageTransparency = 0,
            Position = v49
        }, 0.08)
        v48.Position = v47 + UDim2.fromOffset(0, 80)
        v48.TextTransparency = 1
        tween(v48, 0.7, {
            TextTransparency = 0,
            Position = v47
        }, 0.05)
        ImageLabel.ImageTransparency = 1
        tween(ImageLabel, 0.8, {
            ImageTransparency = 0.2
        }, 0, Enum.EasingStyle.Quad)
        fadeInLights(0)

        local t26 = {}

        if v58 then
            table.insert(t26, v58)
        end

        local t27 = {}

        for _, v243 in t8 do
            if v243 ~= v58 then
                table.insert(t27, v243)
            end
        end

        table.sort(t27, function(p70, p71) -- line: 714
            return p70.slot.LayoutOrder < p71.slot.LayoutOrder
        end)

        for _, v244 in t27 do
            table.insert(t26, v244)
        end

        for v245, v246 in t26 do
            revealRow(v246, math.min(v245 - 1, 10) * 0.065 + 0.18)
        end

        v56.TextTransparency = 1
        tween(v56, 0.4, {
            TextTransparency = 0
        }, 0.5)
        ImageLabel3.ImageTransparency = 1
        tween(ImageLabel3, 0.4, {
            ImageTransparency = 0
        }, 0.55, Enum.EasingStyle.Quad)
        v57.TextTransparency = 1
        tween(v57, 0.4, {
            TextTransparency = 0
        }, 0.2)
        task.delay(1.4, function() -- line: 720
            -- upvalues: v239 (copy), v168 (ref), n3 (ref)
            if n3 == v239 then
                v168 = false
            end
        end)
    end

    local UserInputService = game:GetService("UserInputService")
    local GuiService = game:GetService("GuiService")
    local t28

    local function pointer(p72) -- line: 728
        -- upvalues: GuiService (copy)
        local GuiInset = GuiService:GetGuiInset()

        return Vector2.new(p72.Position.X, p72.Position.Y) + GuiInset
    end

    local function rowsInOrder() -- line: 729
        -- upvalues: t8 (copy), t19 (copy)
        local t29 = {}

        for _, v248 in t19 do
            local v249 = t8[v248]

            if v249 and v249.slot.Parent then
                table.insert(t29, v249)
            end
        end

        return t29
    end

    local function targetRank(p73) -- line: 734
        -- upvalues: t28 (ref), rowsInOrder (copy)
        local n4 = 0

        for _, v250 in rowsInOrder() do
            if v250 ~= t28.r and v250.slot.AbsolutePosition.Y + v250.slot.AbsoluteSize.Y / 2 < p73 then
                n4 += 1
            end
        end

        return n4 + 1
    end

    local function moveGhost() -- line: 741
        -- upvalues: Frame4 (copy), UIScale (copy), t28 (ref), targetRank (copy)
        local Scale = UIScale.Scale

        if Scale <= 0 then
            return
        end

        local v251 = (t28.pos.Y - Frame4.AbsolutePosition.Y) / Scale

        t28.ghost.Position = UDim2.fromOffset(680, v251)

        local t30 = t28

        t30.target = targetRank(t28.pos.Y)

        local Content = t28.ghost:FindFirstChild("Content")
        local pos = Content and Content:FindFirstChild("pos")

        if pos then
            pos.Text = tostring(t28.target)
        end
    end

    local function finish(p74) -- line: 749
        -- upvalues: MotoLegends (copy), Frame (copy), ScrollingFrame2 (copy), t19 (copy), v169 (ref), rebuildLaps (copy), t28 (ref)
        local t31 = t28

        t28 = nil

        if not t31 then
            return
        end

        ScrollingFrame2.ScrollingEnabled = true

        if t31.ghost then
            t31.ghost:Destroy()
        end

        if t31.r.bar.Parent then
            t31.r.bar.BackgroundTransparency = 0
        end

        if p74 or not t31.active or not t31.target then
            return
        end

        local t32 = {}

        for _, v252 in t19 do
            if v252 ~= t31.r.id then
                table.insert(t32, v252)
            end
        end

        table.insert(t32, math.clamp(t31.target, 1, #t32 + 1), t31.r.id)

        local v255 = true

        for v256, v257 in t32 do
            if t19[v256] ~= v257 then
                v255 = false
                break
            end
        end

        if not v255 then
            local t33 = {}

            for v258, v259 in t32 do
                t33[v258] = tostring(v259)
            end

            v169 = table.concat(t33, ",")
            rebuildLaps()

            local RaceDirectorAction = MotoLegends:FindFirstChild("RaceDirectorAction")

            task.spawn(function() -- line: 764
                -- upvalues: t32 (copy), RaceDirectorAction (copy), Frame (copy), v169 (ref), rebuildLaps (copy)
                local InvokeServer = RaceDirectorAction.InvokeServer
                local t34 = {
                    ids = t32
                }
                local ok, result = pcall(InvokeServer, RaceDirectorAction, "lapOrder", t34)

                if not ok or typeof(result) ~= "table" or not result.ok then
                    local _warn = warn
                    local v260, v261

                    if ok and typeof(result) == "table" then
                        local msg = result.msg

                        if msg then
                            v260 = msg
                            v261 = true
                        else
                            v261 = false
                        end
                    else
                        v261 = false
                    end

                    if not v261 then
                        v260 = result
                    end

                    _warn("[LapTimes] order not saved: " .. tostring(v260))
                    v169 = nil
                end

                task.delay(0.5, function() -- line: 770
                    -- upvalues: Frame (copy), v169 (ref), rebuildLaps (copy)
                    v169 = nil

                    if Frame.Visible then
                        rebuildLaps()
                    end
                end)
            end)
        end
    end

    v64 = function(p75, p76) -- line: 773
        -- upvalues: v168 (ref), v170 (ref), canEdit (copy), GuiService (copy), t28 (ref)
        local UserInputType = p76.UserInputType

        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch or t28 or not v170 or not canEdit() or v168 then
            return
        end

        local t35 = {
            active = false,
            r = p75,
            input = p76
        }
        local GuiInset = GuiService:GetGuiInset()

        t35.start = Vector2.new(p76.Position.X, p76.Position.Y) + GuiInset

        local GuiInset2 = GuiService:GetGuiInset()

        t35.pos = Vector2.new(p76.Position.X, p76.Position.Y) + GuiInset2
        t28 = t35
    end

    UserInputService.InputChanged:Connect(function(p77) -- line: 779
        -- upvalues: v30 (copy), Frame (copy), Frame4 (copy), ScrollingFrame2 (copy), GuiService (copy), t28 (ref), moveGhost (copy)
        if not t28 then
            return
        end

        local UserInputType = p77.UserInputType

        if UserInputType ~= Enum.UserInputType.MouseMovement and (UserInputType ~= Enum.UserInputType.Touch or p77 ~= t28.input) then
            return
        end

        local t36 = t28
        local GuiInset = GuiService:GetGuiInset()

        t36.pos = Vector2.new(p77.Position.X, p77.Position.Y) + GuiInset

        if not t28.active and (t28.pos - t28.start).Magnitude > 8 then
            if not (Frame.Visible and t28.r.bar.Parent) then
                local t37 = t28

                t28 = nil

                if t37 then
                    ScrollingFrame2.ScrollingEnabled = true

                    if t37.ghost then
                        t37.ghost:Destroy()
                    end

                    if t37.r.bar.Parent then
                        t37.r.bar.BackgroundTransparency = 0
                    end
                end

                return
            end

            t28.active = true
            t28.r.suppressClick = true
            ScrollingFrame2.ScrollingEnabled = false

            local clone = t28.r.bar:Clone()

            clone.Name = "DragGhost"

            local ToggleSectors = clone:FindFirstChild("ToggleSectors")

            if ToggleSectors then
                ToggleSectors:Destroy()
            end

            clone.AnchorPoint = Vector2.new(0, 0.5)
            clone.Size = UDim2.fromOffset(1178, 52)
            clone.ZIndex = 40
            clone.BackgroundTransparency = 0

            local UIStroke = clone:FindFirstChildOfClass("UIStroke")

            if UIStroke then
                UIStroke.Enabled = true
                UIStroke.Color = v30
                UIStroke.Thickness = 5
            end

            clone.Parent = Frame4
            t28.ghost = clone
            t28.r.bar.BackgroundTransparency = 0.65
        end

        if t28.active then
            moveGhost()
        end
    end)
    UserInputService.InputEnded:Connect(function(p78) -- line: 797
        -- upvalues: t28 (ref), finish (copy)
        if not t28 then
            return
        end

        local UserInputType = p78.UserInputType

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch and p78 == t28.input then
            local r, active = t28.r, t28.active

            finish(false)

            if active then
                task.delay(0.2, function() -- line: 803
                    -- upvalues: r (copy)
                    r.suppressClick = false
                end)
            end
        end
    end)
    game:GetService("RunService").RenderStepped:Connect(function(p79) -- line: 807
        -- upvalues: Frame (copy), UIScale (copy), ScrollingFrame2 (copy), t28 (ref), moveGhost (copy)
        if not t28 or not t28.active then
            return
        end

        if Frame.Visible then
            local Y = ScrollingFrame2.AbsolutePosition.Y
            local v262 = Y + ScrollingFrame2.AbsoluteSize.Y
            local v263 = 60 * UIScale.Scale
            local v264 = 900 * UIScale.Scale * p79
            local Y2 = t28.pos.Y
            local CanvasPosition = ScrollingFrame2.CanvasPosition
            local v266 = math.max(0, ScrollingFrame2.AbsoluteCanvasSize.Y - ScrollingFrame2.AbsoluteWindowSize.Y)

            if not (v262 - v263 < Y2 and Y2 < v262 + v263 * 2) then
                if Y2 < Y + v263 and Y - v263 < Y2 then
                    ScrollingFrame2.CanvasPosition = Vector2.new(CanvasPosition.X, (math.max(0, CanvasPosition.Y - v264)))
                end
            else
                ScrollingFrame2.CanvasPosition = Vector2.new(CanvasPosition.X, (math.min(v266, CanvasPosition.Y + v264)))
            end

            moveGhost()
        else
            local t38 = t28

            t28 = nil

            if t38 then
                ScrollingFrame2.ScrollingEnabled = true

                if t38.ghost then
                    t38.ghost:Destroy()
                end

                if t38.r.bar.Parent then
                    t38.r.bar.BackgroundTransparency = 0
                end
            end
        end
    end)
    MotoLegends:GetAttributeChangedSignal("RDLapOrder"):Connect(function() -- line: 818
        -- upvalues: Frame (copy), v169 (ref), rebuildLaps (copy)
        v169 = nil

        if Frame.Visible then
            rebuildLaps()
        end
    end)
    clone.Activated:Connect(function() -- line: 819
        -- upvalues: MotoLegends (copy), Frame (copy), ScrollingFrame2 (copy), v169 (ref), canEdit (copy), rebuildLaps (copy), t28 (ref)
        if not canEdit() or (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") == "" then
            return
        end

        local t39 = t28

        t28 = nil

        if t39 then
            ScrollingFrame2.ScrollingEnabled = true

            if t39.ghost then
                t39.ghost:Destroy()
            end

            if t39.r.bar.Parent then
                t39.r.bar.BackgroundTransparency = 0
            end
        end

        v169 = ""
        rebuildLaps()

        local RaceDirectorAction = MotoLegends:FindFirstChild("RaceDirectorAction")

        task.spawn(function() -- line: 824
            -- upvalues: RaceDirectorAction (copy), Frame (copy), v169 (ref), rebuildLaps (copy)
            local InvokeServer = RaceDirectorAction.InvokeServer
            local lapOrderReset, lapOrderReset2 = pcall(InvokeServer, RaceDirectorAction, "lapOrderReset")

            if not lapOrderReset or typeof(lapOrderReset2) ~= "table" or not lapOrderReset2.ok then
                local _warn = warn
                local v269, v270

                if lapOrderReset and typeof(lapOrderReset2) == "table" then
                    local msg = lapOrderReset2.msg

                    if msg then
                        v269 = msg
                        v270 = true
                    else
                        v270 = false
                    end
                else
                    v270 = false
                end

                if not v270 then
                    v269 = lapOrderReset2
                end

                _warn("[LapTimes] reset not saved: " .. tostring(v269))
            end

            task.delay(0.5, function() -- line: 827
                -- upvalues: Frame (copy), v169 (ref), rebuildLaps (copy)
                v169 = nil

                if Frame.Visible then
                    rebuildLaps()
                end
            end)
        end)
    end)
    TextButton2.Activated:Connect(function() -- line: 830
        -- upvalues: v21 (copy), MotoLegends (copy), v30 (copy), v32 (copy), ScrollingFrame2 (copy), v169 (ref), v170 (ref), canEdit (copy), v177 (copy), TextButton2 (copy), clone (copy), t28 (ref)
        if canEdit() then
            v170 = not v170

            if not v170 then
                local t40 = t28

                t28 = nil

                if t40 then
                    ScrollingFrame2.ScrollingEnabled = true

                    if t40.ghost then
                        t40.ghost:Destroy()
                    end

                    if t40.r.bar.Parent then
                        t40.r.bar.BackgroundTransparency = 0
                    end
                end
            end

            local v271 = canEdit()

            if not v271 then
                v170 = false
            end

            TextButton2.Visible = v271
            clone.Visible = v271

            local v272 = (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") ~= ""

            clone.BackgroundColor3 = v21
            clone.TextColor3 = v32
            clone.BackgroundTransparency = v272 and 0 or 0.45
            clone.TextTransparency = v272 and 0 or 0.45
            v177.Visible = v271 and v170

            local v273 = v170 or false

            TextButton2.BackgroundColor3 = v273 and v30 or v21
            TextButton2.TextColor3 = v273 and v21 or v32
        else
            local v276 = canEdit()

            if not v276 then
                v170 = false
            end

            TextButton2.Visible = v276
            clone.Visible = v276

            local v277 = (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") ~= ""

            clone.BackgroundColor3 = v21
            clone.TextColor3 = v32
            clone.BackgroundTransparency = v277 and 0 or 0.45
            clone.TextTransparency = v277 and 0 or 0.45
            v177.Visible = v276 and v170

            local v278 = v170 or false

            TextButton2.BackgroundColor3 = v278 and v30 or v21
            TextButton2.TextColor3 = v278 and v21 or v32
        end

        TextButton2.Text = v170 and "DONE" or "EDIT"
    end)
    p6:GetAttributeChangedSignal("RaceDirectorMode"):Connect(function() -- line: 836
        -- upvalues: v21 (copy), MotoLegends (copy), v30 (copy), v32 (copy), ScrollingFrame2 (copy), v169 (ref), v170 (ref), canEdit (copy), v177 (copy), TextButton2 (copy), clone (copy), t28 (ref)
        if not canEdit() then
            local t41 = t28

            t28 = nil

            if t41 then
                ScrollingFrame2.ScrollingEnabled = true

                if t41.ghost then
                    t41.ghost:Destroy()
                end

                if t41.r.bar.Parent then
                    t41.r.bar.BackgroundTransparency = 0
                end
            end
        end

        local v281 = canEdit()

        if not v281 then
            v170 = false
        end

        TextButton2.Visible = v281
        clone.Visible = v281

        local v282 = (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") ~= ""

        clone.BackgroundColor3 = v21
        clone.TextColor3 = v32
        clone.BackgroundTransparency = v282 and 0 or 0.45
        clone.TextTransparency = v282 and 0 or 0.45
        v177.Visible = v281 and v170

        local v283 = v170 or false

        TextButton2.BackgroundColor3 = v283 and v30 or v21
        TextButton2.TextColor3 = v283 and v21 or v32
        TextButton2.Text = v170 and "DONE" or "EDIT"
    end)
    Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 837
        -- upvalues: v21 (copy), MotoLegends (copy), v30 (copy), v32 (copy), Frame (copy), ScrollingFrame2 (copy), v169 (ref), v170 (ref), canEdit (copy), v177 (copy), TextButton2 (copy), clone (copy), t28 (ref)
        if not Frame.Visible then
            v170 = false

            local t42 = t28

            t28 = nil

            if t42 then
                ScrollingFrame2.ScrollingEnabled = true

                if t42.ghost then
                    t42.ghost:Destroy()
                end

                if t42.r.bar.Parent then
                    t42.r.bar.BackgroundTransparency = 0
                end
            end
        end

        local v286 = canEdit()

        if not v286 then
            v170 = false
        end

        TextButton2.Visible = v286
        clone.Visible = v286

        local v287 = (v169 or MotoLegends:GetAttribute("RDLapOrder") or "") ~= ""

        clone.BackgroundColor3 = v21
        clone.TextColor3 = v32
        clone.BackgroundTransparency = v287 and 0 or 0.45
        clone.TextTransparency = v287 and 0 or 0.45
        v177.Visible = v286 and v170

        local v288 = v170 or false

        TextButton2.BackgroundColor3 = v288 and v30 or v21
        TextButton2.TextColor3 = v288 and v21 or v32
        TextButton2.Text = v170 and "DONE" or "EDIT"
    end)

    if Players.LocalPlayer then
        Players.LocalPlayer:GetAttributeChangedSignal("RaceDirectorAccess"):Connect(function() -- line: 838
            -- upvalues: Frame (copy), ScrollingFrame2 (copy), v170 (ref), canEdit (copy), rebuildLaps (copy), t28 (ref)
            if not v170 or not canEdit() then
                local t43 = t28

                t28 = nil

                if t43 then
                    ScrollingFrame2.ScrollingEnabled = true

                    if t43.ghost then
                        t43.ghost:Destroy()
                    end

                    if t43.r.bar.Parent then
                        t43.r.bar.BackgroundTransparency = 0
                    end
                end
            end

            if Frame.Visible then
                rebuildLaps()
            end
        end)
    end

    local n5 = 0

    Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 841
        -- upvalues: Frame (copy), Frame3 (copy), UIScale (copy), MenuFX (copy), t5 (copy), Folder (copy), Frame5 (copy), placeLights (copy), ScrollingFrame2 (copy), v168 (ref), rebuildLaps (copy), result5 (ref), v232 (ref), v233 (ref), fadeInLights (copy), n3 (ref), playIntro (copy), n5 (ref)
        if not Frame.Visible then
            n3 += 1
            v168 = false

            return
        end

        local AbsoluteSize = Frame3.AbsoluteSize

        if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
            AbsoluteSize = workspace.CurrentCamera.ViewportSize
        end

        UIScale.Scale = math.min(AbsoluteSize.X / 2000, AbsoluteSize.Y / 1125)
        placeLights()
        rebuildLaps()
        n5 = 0
        ScrollingFrame2.CanvasPosition = Vector2.zero
        playIntro()

        if not (v232 or v233 or result5 and result5.Parent) and MenuFX then
            v232 = true
            task.spawn(function() -- line: 669
                -- upvalues: Frame (copy), MenuFX (copy), t5 (copy), Folder (copy), Frame5 (copy), result5 (ref), v232 (ref), v233 (ref), fadeInLights (copy)
                local function v293() -- line: 670
                    -- upvalues: MenuFX (copy), t5 (copy), Folder (copy), Frame5 (copy)
                    return require(MenuFX.MenuBackgroundFX).Start(Frame5, Folder, t5)
                end

                local ok, result = pcall(v293)

                v232 = false

                if ok then
                    if result then
                        result5 = result

                        if Frame.Visible then
                            fadeInLights(0)
                        end
                    else
                        v233 = true
                    end
                else
                    v233 = true
                    warn("[LapTimes] light FX: " .. tostring(result))
                end
            end)
        end
    end)

    function t3.ShowResults(p80) -- line: 849
        -- upvalues: p6 (copy), v20 (copy), Frame (copy), v56 (copy), v167 (ref), t18 (ref), rebuildLaps (copy), playIntro (copy), n5 (ref)
        v167 = p80
        t18 = {}

        for _, v294 in p80.rows do
            local PlayerByUserId = v20:GetPlayerByUserId(v294.userId)
            local t44 = {
                BestLapTime = v294.best or 0,
                LastLapTime = v294.last or 0,
                Country = v294.country or PlayerByUserId and PlayerByUserId:GetAttribute("Country"),
                BikeName = v294.bike or "Ducati",
                SelectedLegend = PlayerByUserId and PlayerByUserId:GetAttribute("SelectedLegend") or nil,
                ["LastSectorTime" .. 1] = v294.sectors and v294.sectors[1] or 0,
                ["LastSectorTime" .. 2] = v294.sectors and v294.sectors[2] or 0,
                ["LastSectorTime" .. 3] = v294.sectors and v294.sectors[3] or 0
            }

            t44["LastSectorTime" .. 4] = v294.sectors and v294.sectors[4] or 0

            local t45 = t18

            table.insert(t45, {
                UserId = v294.userId,
                DisplayName = v294.name,
                Name = v294.name,
                Character = PlayerByUserId and PlayerByUserId.Character,
                Result = v294,
                GetAttribute = function(_, p82) -- GetAttribute | line: 855
                    -- upvalues: t44 (copy)
                    return t44[p82]
                end
            })
        end

        p6:SetAttribute("ResultsShowing", true)
        v56.Visible = false

        if not Frame.Visible then
            Frame.Visible = true

            return
        end

        rebuildLaps()
        n5 = 0
        playIntro()
    end

    function t3.CloseResults() -- line: 860
        -- upvalues: p6 (copy), Frame (copy), v56 (copy), v167 (ref), t18 (ref), rebuildLaps (copy)
        if not v167 then
            return
        end

        v167 = nil
        t18 = nil
        p6:SetAttribute("ResultsShowing", false)
        v56.Visible = false
        Frame.Visible = false
        rebuildLaps()
    end

    local v295 = nil

    task.spawn(function() -- line: 866
        -- upvalues: t3 (copy), v295 (ref)
        local ChampionshipEvent = game.ReplicatedStorage.MotoLegends:WaitForChild("ChampionshipEvent")

        ChampionshipEvent.OnClientEvent:Connect(function(p83, p84) -- line: 868
            -- upvalues: t3 (copy), v295 (ref)
            if p83 == "Results" then
                v295 = p84

                local MotoLegends = game.ReplicatedStorage.MotoLegends
                local LocalPlayer = game:GetService("Players").LocalPlayer

                task.spawn(function() -- line: 874
                    -- upvalues: p84 (copy), MotoLegends (copy), LocalPlayer (copy), t3 (copy), v295 (ref)
                    local v296 = os.clock() + 45

                    while true do
                        if v295 == p84 and os.clock() < v296 then
                            local PodiumCutsceneEnd = MotoLegends:GetAttribute("PodiumCutsceneEnd")

                            if typeof(PodiumCutsceneEnd) == "number" and PodiumCutsceneEnd > 0 and workspace:GetServerTimeNow() < PodiumCutsceneEnd or LocalPlayer:GetAttribute("PodiumCutscenePlaying") == true then
                                task.wait(0.1)
                                continue
                            end
                        end

                        break
                    end

                    if v295 == p84 then
                        v295 = nil
                        t3.ShowResults(p84)
                    end
                end)
            elseif p83 == "CloseResults" then
                v295 = nil
                t3.CloseResults()
            end
        end)
        task.wait(1.1)
        ChampionshipEvent:FireServer("Sync")
    end)
    t3.Leaderboard = Frame

    local n6 = 0

    function t3.ToggleLeaderboard() -- line: 892
        -- upvalues: Frame (copy), n6 (ref)
        if not (os.clock() - n6 < 0.25) then
            n6 = os.clock()
            Frame.Visible = not Frame.Visible
        end
    end

    local v298 = button(p6, "LapTimesButton", "Lap times", UDim2.new(1, -150, 0.5, 28), UDim2.fromOffset(130, 40))

    v298.Activated:Connect(function() -- line: 898
        -- upvalues: t3 (copy), n6 (ref)
        n6 = 0
        t3.ToggleLeaderboard()
    end)
    t3.LapTimesButton = v298

    local t47 = {}
    local v299 = false

    function t3.Reward(p85) -- line: 901
        -- upvalues: p6 (copy), v26 (copy), t47 (copy), v299 (ref), TweenService (copy), NumberFormat (copy)
        local t48, v300

        if typeof(p85) ~= "number" or p85 ~= p85 or p85 == 0 then
            return
        else
            t48 = t47

            if p85 > 0 then
                v300 = math.floor(p85)

                if not v300 then
                    v300 = -math.floor(-p85)
                end
            else
                v300 = -math.floor(-p85)
            end
        end

        table.insert(t48, v300)

        if not v299 then
            v299 = true
            task.spawn(function() -- line: 906
                -- upvalues: p6 (copy), v26 (copy), t47 (copy), v299 (ref), TweenService (copy), NumberFormat (copy)
                while #t47 > 0 and p6.Parent do
                    local v304 = table.remove(t47, 1)

                    v26.TextColor3 = v304 < 0 and Color3.fromRGB(255, 72, 72) or Color3.fromRGB(99, 255, 132)
                    v26.Text = (v304 < 0 and "-" or "+") .. NumberFormat.Short((math.abs(v304))) .. "$"
                    v26.Position = UDim2.new(0.5, 0, 0, 94)
                    v26.TextTransparency = 1
                    v26.TextStrokeTransparency = 1
                    v26.Visible = true

                    local tween = TweenService:Create(v26, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextTransparency = 0,
                        TextStrokeTransparency = 0.65,
                        Position = UDim2.new(0.5, 0, 0, 76)
                    })

                    tween:Play()
                    tween.Completed:Wait()
                    task.wait(0.9)

                    local tween2 = TweenService:Create(v26, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        TextTransparency = 1,
                        TextStrokeTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0, 56)
                    })

                    tween2:Play()
                    tween2.Completed:Wait()
                    v26.Visible = false
                end

                v299 = false
            end)
        end
    end

    local t49 = {}
    local v306 = true
    local n7 = 0
    local v307, v308
    local v309 = false
    local FieldOfView = workspace.CurrentCamera.FieldOfView

    local function restore() -- line: 920
        -- upvalues: p6 (copy), LocalPlayer (copy), v23 (copy), t3 (copy), v307 (ref), v308 (ref), v309 (ref), FieldOfView (copy)
        t3.Target = nil
        v307 = nil
        v308 = nil

        if v309 then
            local CurrentCamera = workspace.CurrentCamera

            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            CurrentCamera.FieldOfView = FieldOfView
        end

        v309 = false
        v23.Text = "Spectate"
        p6:SetAttribute("SpectatingUserId", nil)
    end

    function t3.Select(p86) -- line: 925
        -- upvalues: v20 (copy), LocalPlayer (copy), SpectatePlayers (copy), t3 (copy), v307 (ref), v308 (ref)
        if p86 == LocalPlayer.UserId or not v20:GetPlayerByUserId(p86) then
            return false
        end

        t3.Target = p86
        v307 = nil
        v308 = nil
        SpectatePlayers.Visible = false

        return true
    end

    function t3.Stop() -- line: 929
        -- upvalues: restore (copy)
        restore()
    end

    v23.Activated:Connect(function() -- line: 930
        -- upvalues: SpectatePlayers (copy), v306 (ref)
        SpectatePlayers.Visible = not SpectatePlayers.Visible
        v306 = true
    end)
    v24.Activated:Connect(function() -- line: 931
        -- upvalues: SpectatePlayers (copy), restore (copy)
        restore()
        SpectatePlayers.Visible = false
    end)
    v20.PlayerAdded:Connect(function() -- line: 932
        -- upvalues: v306 (ref)
        v306 = true
    end)
    v20.PlayerRemoving:Connect(function(p87) -- line: 933
        -- upvalues: t3 (copy), v306 (ref), restore (copy)
        v306 = true

        if t3.Target == p87.UserId then
            restore()
        end
    end)

    local function rebuild() -- line: 934
        -- upvalues: v20 (copy), LocalPlayer (copy), button (copy), ScrollingFrame (copy), v25 (copy), t3 (copy), t49 (ref), v306 (ref)
        for _, v310 in t49 do
            v310:Destroy()
        end

        t49 = {}

        local Players = v20:GetPlayers()

        table.sort(Players, function(p88, p89) -- line: 936
            return p88.Name:lower() < p89.Name:lower()
        end)

        local n8 = 0

        for _, player in Players do
            if player ~= LocalPlayer then
                local v311 = button(ScrollingFrame, "Watch_" .. player.UserId, player.DisplayName, UDim2.fromOffset(0, n8 * 40), UDim2.new(1, -4, 0, 34))

                v311.AutoLocalize = false
                v311.Activated:Connect(function() -- line: 940
                    -- upvalues: player (copy), t3 (copy)
                    t3.Select(player.UserId)
                end)

                local t50 = t49

                t50[player] = v311
                n8 += 1
            end
        end

        ScrollingFrame.CanvasSize = UDim2.fromOffset(0, n8 * 40)
        v25.Visible = n8 == 0
        v306 = false
    end

    local function updateTimer() -- line: 946
        -- upvalues: MotoLegends (copy), v56 (copy)
        MotoLegends:GetAttribute("SessionPhase")
        MotoLegends:GetAttribute("SessionDeadline")
        v56.Visible = false
    end

    function t3.Update(p90, p91, p92) -- line: 959
        -- upvalues: p6 (copy), v20 (copy), LocalPlayer (copy), MotoLegends (copy), MoneyBalance (copy), v22 (copy), v23 (copy), SpectatePlayers (copy), t3 (copy), Frame (copy), v56 (copy), rebuildLaps (copy), n5 (ref), v298 (copy), v306 (ref), n7 (ref), v307 (ref), v308 (ref), v309 (ref), restore (copy), rebuild (copy), v1 (ref), NumberFormat (copy)
        if Frame.Visible then
            MotoLegends:GetAttribute("SessionPhase")
            MotoLegends:GetAttribute("SessionDeadline")
            v56.Visible = false
            n5 += p90

            if n5 > 0.5 then
                n5 = 0
                rebuildLaps()
            end
        end

        MoneyBalance.Visible = false
        v22.Text = NumberFormat.Money(LocalPlayer:GetAttribute("Money") or 0)
        v23.Visible = false
        v298.Visible = false

        if p91 or p92 then
            SpectatePlayers.Visible = false

            if t3.Target then
                restore()
            end
        end

        n7 += p90

        if v306 then
            rebuild()
        end

        if t3.Target then
            local PlayerByUserId = v20:GetPlayerByUserId(t3.Target)

            if PlayerByUserId then
                local v312 = PlayerByUserId.Character and PlayerByUserId.Character:FindFirstChild("HumanoidRootPart")
                local RaceBikes = workspace:FindFirstChild("RaceBikes")
                local v313 = false

                if RaceBikes then
                    for _, child in RaceBikes:GetChildren() do
                        if child:GetAttribute("OwnerUserId") == t3.Target and child.PrimaryPart and child:GetAttribute("Crash") == "" then
                            local RiderSeat = child:FindFirstChild("RiderSeat")

                            if RiderSeat and RiderSeat.Occupant then
                                v312 = child.PrimaryPart
                                v313 = true
                                break
                            end
                        end

                        v313 = false
                    end
                end

                if v312 then
                    local v314 = Vector3.new(v312.CFrame.LookVector.X, 0, v312.CFrame.LookVector.Z)

                    if v314.Magnitude < 0.01 then
                        v314 = Vector3.new(0, 0, -1)
                    end

                    local Unit = v314.Unit
                    local Magnitude = v313 and v312.AssemblyLinearVelocity.Magnitude or 0
                    local v316 = v312.Position - Unit * (math.clamp(Magnitude / 250, 0, 1) * 7 + 14) + Vector3.new(0, 6, 0)
                    local v317 = v312.Position + Unit * 3 + Vector3.new(0, 2, 0)
                    local v318 = RaycastParams.new()

                    v318.FilterType = Enum.RaycastFilterType.Include

                    if not (v1 and v1.Parent) then
                        v1 = workspace:FindFirstChild("RaceCollision", true)
                    end

                    v318.FilterDescendantsInstances = {
                        v1,
                        workspace.Terrain
                    }

                    local v320 = workspace:Raycast(v317, v316 - v317, v318)

                    if v320 then
                        v316 = v320.Position + v320.Normal * 0.7
                    end

                    if v307 and (v316 - v307).Magnitude > 150 then
                        v307 = nil
                        v308 = nil
                    end

                    local v321 = v307
                    local v322 = if v321 then v307:Lerp(v316, 1 - math.exp(-p90 * 16)) else nil

                    if v321 and v322 then
                        v316 = v322
                    end

                    v307 = v316

                    local v325 = v308
                    local v326 = if v325 then v308:Lerp(v317, 1 - math.exp(-p90 * 18)) else nil

                    if v325 and v326 then
                        v317 = v326
                    end

                    v308 = v317

                    local CurrentCamera = workspace.CurrentCamera

                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    CurrentCamera.CFrame = CFrame.lookAt(v307, v308)
                    CurrentCamera.Focus = CFrame.new(v308)
                    CurrentCamera.FieldOfView = math.clamp(Magnitude / 360, 0, 1) * 15 + 68
                    v309 = true
                    v23.AutoLocalize = false
                    v23.Text = "Watching " .. PlayerByUserId.DisplayName
                    p6:SetAttribute("SpectatingUserId", t3.Target)
                end
            else
                restore()
            end
        end
    end

    return t3
end

return t2
