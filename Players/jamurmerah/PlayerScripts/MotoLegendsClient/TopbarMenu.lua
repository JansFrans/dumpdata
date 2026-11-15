-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local RaceIcons = require(MotoLegends:WaitForChild("RaceIcons"))
local SettingsBridge = require(MotoLegends:WaitForChild("SettingsBridge"))
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local JerezRaceHUD = PlayerGui:WaitForChild("JerezRaceHUD")
local v1 = Color3.fromRGB(231, 0, 0)
local v2 = Color3.new(0, 0, 0)
local v3 = Color3.new(1, 1, 1)
local v4 = Color3.fromRGB(20, 22, 28)
local v5 = Color3.fromRGB(150, 154, 162)
local v6 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
local v7 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "TopbarMenuHUD"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 40
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local function corner(p1, p2) -- line: 34
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = p2
    UICorner.Parent = p1

    return UICorner
end

local function stroke(p3, p4, p5) -- line: 35
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p4
    UIStroke.Thickness = p5 or 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = p3

    return UIStroke
end

local function label(p6, p7, p8, p9, p10, p11) -- line: 36
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p7
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p8
    TextLabel.FontFace = p9
    TextLabel.TextSize = p10
    TextLabel.TextColor3 = p11
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = p6

    return TextLabel
end

local function setImage(p12, p13) -- line: 40
    -- upvalues: RaceIcons (copy)
    local v8 = RaceIcons.Get(p13)

    if not v8 then
        return false
    end

    p12.ImageContent = v8

    return true
end

local function humanoid() -- line: 47
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    return Character and Character:FindFirstChildOfClass("Humanoid")
end

local function riding() -- line: 48
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v9 = Humanoid and Humanoid.SeatPart

    return v9 ~= nil and v9.Name == "RiderSeat"
end

local function crashing() -- line: 49
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    return Character ~= nil and Character:GetAttribute("RaceCrashActive") == true
end

local function menuOpen() -- line: 50
    -- upvalues: JerezRaceHUD (copy)
    if JerezRaceHUD:GetAttribute("BikesPreviewOpen") == true or JerezRaceHUD:GetAttribute("LegendsOpen") == true or JerezRaceHUD:GetAttribute("ShopOpen") == true then
        return true
    end

    return JerezRaceHUD:GetAttribute("ProfileOpen") == true
end

local function spectating() -- line: 51
    -- upvalues: JerezRaceHUD (copy)
    return JerezRaceHUD:GetAttribute("LobbySpectating") == true
end

local TextButton = Instance.new("TextButton")

TextButton.Name = "SettingsMenu"
TextButton.Text = ""
TextButton.AutoButtonColor = false
TextButton.BackgroundTransparency = 1
TextButton.BorderSizePixel = 0
TextButton:SetAttribute("NoHover", true)
TextButton:SetAttribute("NoSound", true)
TextButton.Parent = ScreenGui

local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "Plate"
ImageLabel.BackgroundTransparency = 1
ImageLabel.Size = UDim2.fromScale(1, 1)
ImageLabel.ImageColor3 = v2
ImageLabel.ImageTransparency = 0.15
ImageLabel.ZIndex = TextButton.ZIndex
ImageLabel.Parent = TextButton

local UICorner = RaceIcons.Get("ref_top_plate")

if UICorner then
    ImageLabel.ImageContent = UICorner
else
    ImageLabel.BackgroundTransparency = 0.15
    ImageLabel.BackgroundColor3 = v2

    local v10 = UDim.new(0, 8)

    UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = v10
    UICorner.Parent = ImageLabel
end

local ImageLabel2 = Instance.new("ImageLabel")

ImageLabel2.Name = "Icon"
ImageLabel2.BackgroundTransparency = 1
ImageLabel2.ImageColor3 = v3
ImageLabel2.Position = UDim2.fromScale(0.2571428571428571, 0)
ImageLabel2.Size = UDim2.fromScale(0.5142857142857142, 0.9)
ImageLabel2.ZIndex = TextButton.ZIndex + 1
ImageLabel2.Parent = TextButton

local ref_gear = RaceIcons.Get("ref_gear")

if ref_gear then
    ImageLabel2.ImageContent = ref_gear
else
    ref_gear = RaceIcons.Get("gear")

    local v11

    if ref_gear then
        v11 = true
        ImageLabel2.ImageContent = ref_gear
    else
        v11 = false
    end

    if not v11 then
        v11 = Instance.new("TextLabel")
        v11.Name = "Fallback"
        v11.BackgroundTransparency = 1
        v11.Text = "⚙"
        v11.FontFace = v6
        v11.TextSize = 26
        v11.TextColor3 = v3
        v11.TextXAlignment = Enum.TextXAlignment.Left
        v11.AutoLocalize = false
        v11.Parent = ImageLabel2
        v11.Size = UDim2.fromScale(1, 1)
        v11.TextXAlignment = Enum.TextXAlignment.Center
    end
end

local Frame = Instance.new("Frame")

Frame.Name = "Dropdown"
Frame.BackgroundTransparency = 1
Frame.Size = UDim2.fromOffset(185, 0)
Frame.AutomaticSize = Enum.AutomaticSize.Y
Frame.Visible = false
Frame.Parent = ScreenGui
ref_gear = Instance.new("UIListLayout")
ref_gear.Padding = UDim.new(0, 6)
ref_gear.SortOrder = Enum.SortOrder.LayoutOrder
ref_gear.Parent = Frame

local function menuItem(p14, p15, p16, p17) -- line: 73
    -- upvalues: RaceIcons (copy), v2 (copy), v3 (copy), v6 (copy), Frame (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p14
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v2
    TextButton.BackgroundTransparency = 0.2
    TextButton.BorderSizePixel = 0
    TextButton.Size = UDim2.fromOffset(185, 34)
    TextButton.LayoutOrder = p17

    local v12 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v12
    UICorner.Parent = TextButton
    TextButton.Parent = Frame

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Glyph"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.fromOffset(24, 17)
    ImageLabel.Size = UDim2.fromOffset(20, 20)
    ImageLabel.ImageColor3 = v3
    ImageLabel.ZIndex = TextButton.ZIndex + 1
    ImageLabel.Parent = TextButton

    local v13 = RaceIcons.Get(p16)

    if v13 then
        ImageLabel.ImageContent = v13
    else
        ImageLabel.ImageTransparency = 1
    end

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Label"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p15
    TextLabel.FontFace = v6
    TextLabel.TextSize = 15
    TextLabel.TextColor3 = v3
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = TextButton
    TextLabel.Position = UDim2.fromOffset(44, 0)
    TextLabel.Size = UDim2.new(1, -50, 1, 0)
    TextLabel.ZIndex = TextButton.ZIndex + 1

    return TextButton, TextLabel
end

local v14 = menuItem("Settings", "Settings", "ref_gear", 1)
local v15 = menuItem("Profile", "Profile", "ref_character", 2)
local v16 = menuItem("Bottle", "Customization", "", 3)
local Glyph = v16:FindFirstChild("Glyph")

if Glyph then
    Glyph.ImageTransparency = 0
    require(MotoLegends:WaitForChild("UIArt")).Apply(Glyph, "BottleGlyph")
end

Glyph = menuItem("Freecam", "Freecam", "ref_cam", 4)

local n1 = 1

local function u(p18) -- line: 93
    -- upvalues: n1 (ref)
    return (math.max(1, (math.floor(p18 * n1 + 0.5))))
end

local t1 = {
    {
        name = "Gameplay",
        rows = {
            {
                label = "Transmission",
                kind = "cycle",
                id = "transmission",
                options = { "Automatic", "Manual" }
            },
            {
                label = "Anti-lock Brakes",
                kind = "toggle",
                id = "abs"
            },
            {
                label = "AFK Mode",
                kind = "toggle",
                id = "afk"
            },
            {
                label = "Nametags",
                kind = "toggle",
                id = "nametags"
            },
            {
                label = "Mini Map",
                kind = "toggle",
                id = "minimap"
            },
            {
                label = "Camera Shake",
                kind = "toggle",
                id = "camShake"
            },
            {
                label = "Fixed Camera",
                kind = "toggle",
                id = "camFixed"
            },
            {
                label = "Cutscenes",
                kind = "toggle",
                id = "cutscenes"
            },
            {
                label = "Trajectory Aids",
                kind = "toggle",
                id = "apexAssist"
            },
            {
                label = "Controller Vibration",
                kind = "toggle",
                id = "vibration"
            }
        }
    },
    {
        name = "Performance",
        rows = {
            {
                label = "Quality Mode",
                kind = "cycle",
                id = "quality",
                options = { "High", "Medium", "Low" }
            },
            {
                label = "Shadows",
                kind = "toggle",
                id = "shadows"
            },
            {
                label = "Trees",
                kind = "toggle",
                id = "trees"
            },
            {
                label = "Effects & Tyre Marks",
                kind = "toggle",
                id = "effects"
            },
            {
                label = "Audience",
                kind = "toggle",
                id = "audience"
            }
        }
    },
    {
        name = "Controls",
        kind = "controls"
    }
}
local t2 = {
    LeftShift = "L-SHIFT",
    RightShift = "R-SHIFT",
    Space = "SPACE",
    ButtonR2 = "R2",
    ButtonL2 = "L2",
    ButtonR1 = "R1",
    ButtonL1 = "L1",
    ButtonR3 = "R3",
    ButtonL3 = "L3",
    ButtonA = "A",
    ButtonB = "B",
    ButtonX = "X",
    ButtonY = "Y",
    ButtonSelect = "SELECT",
    ButtonStart = "START",
    Thumbstick1 = "L-STICK",
    Thumbstick2 = "R-STICK",
    DPadUp = "D-UP",
    DPadDown = "D-DOWN",
    DPadLeft = "D-LEFT",
    DPadRight = "D-RIGHT",
    Up = "UP",
    Down = "DOWN",
    Left = "LEFT",
    Right = "RIGHT",
    LeftControl = "L-CTRL",
    RightControl = "R-CTRL",
    Unknown = "-"
}

local function keyText(p19) -- line: 121
    -- upvalues: t2 (copy)
    return t2[p19] or string.upper(p19)
end

local t3 = {}
local v19 = false
local v20, v21

local function controlsPad() -- line: 129
    -- upvalues: UserInputService (copy), v21 (ref)
    if v21 then
        return v21 == "pad"
    end

    return UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
end

local v22

local function onOff(p20) -- line: 134
    if p20 then
        return "ON"
    end

    return "OFF"
end

local function pillStyle(p21, p22) -- line: 135
    -- upvalues: v1 (copy), v3 (copy), v4 (copy)
    p21.BackgroundColor3 = p22 and v1 or v3
    p21.TextColor3 = p22 and v3 or v4

    local UIStroke = p21:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = p22 and v1 or v4
    end
end

local function pill(p23, p24, p25, p26) -- line: 139
    -- upvalues: TweenService (copy), v4 (copy), v6 (copy), n1 (ref)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p24
    TextButton.AutoButtonColor = false
    TextButton:SetAttribute("NoHover", true)
    TextButton.BorderSizePixel = 0
    TextButton.AnchorPoint = Vector2.new(1, 0.5)
    TextButton.Size = UDim2.fromOffset(math.max(1, (math.floor(p25 * n1 + 0.5))), (math.max(1, (math.floor(11 * n1 + 0.5)))))
    TextButton.FontFace = v6
    TextButton.TextSize = math.max(1, (math.floor(7 * n1 + 0.5)))
    TextButton.Text = p26
    TextButton.AutoLocalize = false

    local v30 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v30
    UICorner.Parent = TextButton

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v4
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = TextButton
    TextButton.Parent = p23

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = TextButton
    TextButton.MouseEnter:Connect(function() -- line: 144
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.12), {
            Scale = 1.06
        }):Play()
    end)
    TextButton.MouseLeave:Connect(function() -- line: 145
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.12), {
            Scale = 1
        }):Play()
    end)

    return TextButton
end

local function serverCode() -- line: 152
    local PrivateServerCode = workspace:GetAttribute("PrivateServerCode")

    return if typeof(PrivateServerCode) == "string" and #PrivateServerCode == 6 and PrivateServerCode then PrivateServerCode else nil
end

local function serverCodeRow(p27) -- line: 156
    -- upvalues: v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), n1 (ref)
    local PrivateServerCode = workspace:GetAttribute("PrivateServerCode")
    local PrivateServerCode2 = if typeof(PrivateServerCode) == "string" and #PrivateServerCode == 6 and PrivateServerCode then PrivateServerCode else nil

    if not PrivateServerCode2 then
        return
    end

    local v31 = p27("Server Code")

    v31.Name = "Row_ServerCode"

    local TextBox = Instance.new("TextBox")

    TextBox.Name = "Code"
    TextBox.AnchorPoint = Vector2.new(1, 0.5)
    TextBox.Position = UDim2.new(1, -math.max(1, (math.floor(6 * n1 + 0.5))), 0.5, 0)
    TextBox.Size = UDim2.fromOffset(math.max(1, (math.floor(64 * n1 + 0.5))), (math.max(1, (math.floor(11 * n1 + 0.5)))))
    TextBox.BackgroundColor3 = v4
    TextBox.BorderSizePixel = 0
    TextBox.FontFace = v6
    TextBox.TextSize = math.max(1, (math.floor(7.5 * n1 + 0.5)))
    TextBox.TextColor3 = v3
    TextBox.Text = PrivateServerCode2
    TextBox.TextEditable = false
    TextBox.ClearTextOnFocus = false
    TextBox.AutoLocalize = false
    TextBox.SelectionImageObject = nil

    local v41 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v41
    UICorner.Parent = TextBox
    TextBox.Parent = v31
    TextBox.Focused:Connect(function() -- line: 163
        -- upvalues: TextBox (copy)
        task.defer(function() -- line: 163
            -- upvalues: TextBox (copy)
            TextBox.CursorPosition = #TextBox.Text + 1
            TextBox.SelectionStart = 1
        end)
    end)

    local v44 = math.max(1, (math.floor(6 * n1 + 0.5)))
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Hint"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "select to copy"
    TextLabel.FontFace = v7
    TextLabel.TextSize = v44
    TextLabel.TextColor3 = v5
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = v31
    TextLabel.AnchorPoint = Vector2.new(1, 0.5)
    TextLabel.Position = UDim2.new(1, -math.max(1, (math.floor(6 * n1 + 0.5))) - math.max(1, (math.floor(64 * n1 + 0.5))) - math.max(1, (math.floor(6 * n1 + 0.5))), 0.5, 0)
    TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(56 * n1 + 0.5))), (math.max(1, (math.floor(11 * n1 + 0.5)))))
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right
end

local function build() -- line: 168
    -- upvalues: UserInputService (copy), TweenService (copy), RaceIcons (copy), SettingsBridge (copy), JerezRaceHUD (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), ScreenGui (copy), n1 (ref), t1 (copy), t3 (ref), v20 (ref), v21 (ref), v22 (ref), pill (copy), serverCodeRow (copy)
    if t3.root then
        t3.root:Destroy()
    end

    local v58 = t3.content and t3.content.CanvasPosition

    t3 = {
        controls = {},
        sections = {},
        cats = {}
    }

    local v59 = workspace.CurrentCamera.ViewportSize

    n1 = math.min(v59.Y / 360, (v59.X - 24) / 330)
    v59 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    local v60 = if v59 then 22 else 18
    local Frame = Instance.new("Frame")

    Frame.Name = "SettingsWindow"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(math.max(1, (math.floor(330 * n1 + 0.5))), (math.max(1, (math.floor(200 * n1 + 0.5)))))
    Frame.BackgroundColor3 = v2
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Visible = false

    local TextButton = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    local fromOffset = Instance.new("UICorner")

    fromOffset.CornerRadius = TextButton
    fromOffset.Parent = Frame
    Frame.Parent = ScreenGui
    t3.root = Frame

    local v62 = math.max(1, (math.floor(12 * n1 + 0.5)))
    local Frame2 = Instance.new("TextLabel")

    Frame2.Name = "Title"
    Frame2.BackgroundTransparency = 1
    Frame2.Text = "SETTINGS"
    Frame2.FontFace = v6
    Frame2.TextSize = v62
    Frame2.TextColor3 = v3
    Frame2.TextXAlignment = Enum.TextXAlignment.Left
    Frame2.AutoLocalize = false
    Frame2.Parent = Frame
    Frame2.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(8 * n1 + 0.5)))))
    Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(160 * n1 + 0.5))), (math.max(1, (math.floor(14 * n1 + 0.5)))))
    TextButton = Instance.new("Frame")
    TextButton.Name = "Divider"
    TextButton.BorderSizePixel = 0
    TextButton.BackgroundColor3 = v3
    TextButton.Position = UDim2.fromOffset(math.max(1, (math.floor(12 * n1 + 0.5))), (math.max(1, (math.floor(27 * n1 + 0.5)))))
    TextButton.Size = UDim2.fromOffset(math.max(1, (math.floor(99 * n1 + 0.5))), (math.max(1, (math.floor(n1 + 0.5)))))
    TextButton.Parent = Frame
    fromOffset = Instance.new("UIGradient")
    fromOffset.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    fromOffset.Parent = TextButton
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Close"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton:SetAttribute("NoHover", true)
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    fromOffset = UDim2.new

    local v61 = -math.max(1, (math.floor(26 * n1 + 0.5)))
    local v64 = math.floor(18 * n1 + 0.5)

    TextButton.Position = fromOffset(1, v61, 0, (math.max(1, v64)))
    fromOffset = UDim2.fromOffset
    v62 = math.max(1, (math.floor(30 * n1 + 0.5)))

    local v63 = 16 * n1 + 0.5

    TextButton.Size = fromOffset(v62, (math.max(1, (math.floor(v63)))))
    TextButton.ZIndex = 3
    TextButton.Modal = false
    TextButton.Parent = Frame
    t3.close = TextButton

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Plate"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ImageColor3 = v3
    ImageLabel.ZIndex = 3
    ImageLabel.Parent = TextButton
    v61 = RaceIcons.Get("ref_top_plate")

    if v61 then
        ImageLabel.ImageContent = v61
    else
        ImageLabel.BackgroundTransparency = 0
        ImageLabel.BackgroundColor3 = v3
        v62 = UDim.new
        v64 = 4 * n1 + 0.5
        v63 = math.floor(v64)
        v62 = v62(0, (math.max(1, v63)))
        v61 = Instance.new("UICorner")
        v61.CornerRadius = v62
        v61.Parent = ImageLabel
    end

    Frame2 = math.max(1, (math.floor(10 * n1 + 0.5)))

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "X"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "X"
    TextLabel.FontFace = v6
    TextLabel.TextSize = Frame2
    TextLabel.TextColor3 = v2
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = TextButton
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.ZIndex = 4

    local function closeHover(p28) -- line: 192
        -- upvalues: ImageLabel (copy), TextLabel (copy), TweenService (copy), v1 (copy), v2 (copy), v3 (copy)
        local v66 = TweenInfo.new(0.18)

        TweenService:Create(ImageLabel, v66, {
            ImageColor3 = p28 and v1 or v3
        }):Play()

        if ImageLabel.BackgroundTransparency < 1 then
            TweenService:Create(ImageLabel, v66, {
                BackgroundColor3 = p28 and v1 or v3
            }):Play()
        end

        TweenService:Create(TextLabel, v66, {
            TextColor3 = p28 and v3 or v2
        }):Play()
    end

    TextButton.MouseEnter:Connect(function() -- line: 198
        -- upvalues: closeHover (copy)
        closeHover(true)
    end)
    TextButton.MouseLeave:Connect(function() -- line: 198
        -- upvalues: closeHover (copy)
        closeHover(false)
    end)
    TextButton.SelectionGained:Connect(function() -- line: 199
        -- upvalues: closeHover (copy)
        closeHover(true)
    end)
    TextButton.SelectionLost:Connect(function() -- line: 199
        -- upvalues: closeHover (copy)
        closeHover(false)
    end)
    TextButton.Activated:Connect(function() -- line: 200
        -- upvalues: v20 (ref)
        v20()
    end)
    Frame2 = Instance.new("Frame")
    Frame2.Name = "Categories"
    Frame2.BackgroundTransparency = 1
    Frame2.Position = UDim2.fromOffset(0, (math.max(1, (math.floor(36 * n1 + 0.5)))))
    Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(78 * n1 + 0.5))), (math.max(1, (math.floor(156 * n1 + 0.5)))))
    Frame2.Parent = Frame

    local Frame3 = Instance.new("UIListLayout")

    Frame3.SortOrder = Enum.SortOrder.LayoutOrder
    Frame3.Parent = Frame2
    Frame3 = Instance.new("Frame")
    Frame3.Name = "Separator"
    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = Color3.fromRGB(44, 46, 54)
    Frame3.Position = UDim2.fromOffset(math.max(1, (math.floor(80 * n1 + 0.5))), (math.max(1, (math.floor(36 * n1 + 0.5)))))
    Frame3.Size = UDim2.fromOffset(math.max(1, (math.floor(n1 + 0.5))), (math.max(1, (math.floor(156 * n1 + 0.5)))))
    Frame3.Parent = Frame

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "Content"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(math.max(1, (math.floor(86 * n1 + 0.5))), (math.max(1, (math.floor(34 * n1 + 0.5)))))
    ScrollingFrame.Size = UDim2.fromOffset(math.max(1, (math.floor(238 * n1 + 0.5))), (math.max(1, (math.floor(160 * n1 + 0.5)))))
    ScrollingFrame.ScrollBarThickness = math.max(2, (math.max(1, (math.floor(2 * n1 + 0.5)))))
    ScrollingFrame.ScrollBarImageColor3 = v3
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.Parent = Frame
    t3.content = ScrollingFrame

    local UIPadding = Instance.new("UIListLayout")

    UIPadding.SortOrder = Enum.SortOrder.LayoutOrder
    UIPadding.Padding = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    UIPadding.Parent = ScrollingFrame
    UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingRight = UDim.new(0, (math.max(1, (math.floor(8 * n1 + 0.5)))))
    UIPadding.PaddingTop = UDim.new(0, (math.max(1, (math.floor(2 * n1 + 0.5)))))
    UIPadding.PaddingBottom = UDim.new(0, (math.max(1, (math.floor(6 * n1 + 0.5)))))
    UIPadding.Parent = ScrollingFrame

    local n2 = 0

    local function nextOrder() -- line: 213
        -- upvalues: n2 (ref)
        n2 += 1

        return n2
    end

    local function header(p29, p30) -- line: 214
        -- upvalues: ScrollingFrame (copy), n2 (ref), v3 (copy), v6 (copy), n1 (ref)
        local Frame = Instance.new("Frame")

        Frame.Name = "Header_" .. p30
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(20 * n1 + 0.5)))))
        n2 += 1
        Frame.LayoutOrder = n2
        Frame.Parent = ScrollingFrame

        local v73 = math.max(1, (math.floor(11 * n1 + 0.5)))
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "Title"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p30
        TextLabel.FontFace = v6
        TextLabel.TextSize = v73
        TextLabel.TextColor3 = v3
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.AutoLocalize = false
        TextLabel.Parent = Frame
        TextLabel.Size = UDim2.fromScale(1, 1)
        p29.header = Frame

        return Frame
    end

    local function row(p31) -- line: 219
        -- upvalues: ScrollingFrame (copy), n2 (ref), v60 (copy), v3 (copy), v4 (copy), v7 (copy), n1 (ref)
        local Frame = Instance.new("Frame")

        Frame.Name = "Row_" .. p31
        Frame.BackgroundColor3 = v3
        Frame.BorderSizePixel = 0
        Frame.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(v60 * n1 + 0.5)))))
        n2 += 1
        Frame.LayoutOrder = n2

        local v78 = UDim.new(0, (math.max(1, (math.floor(3 * n1 + 0.5)))))
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = v78
        UICorner.Parent = Frame
        Frame.Parent = ScrollingFrame

        local v81 = math.max(1, (math.floor(8.5 * n1 + 0.5)))
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "Label"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p31
        TextLabel.FontFace = v7
        TextLabel.TextSize = v81
        TextLabel.TextColor3 = v4
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.AutoLocalize = false
        TextLabel.Parent = Frame
        TextLabel.Position = UDim2.fromOffset(math.max(1, (math.floor(10 * n1 + 0.5))), 0)
        TextLabel.Size = UDim2.new(1, -math.max(1, (math.floor(120 * n1 + 0.5))), 1, 0)
        TextLabel.TextTruncate = Enum.TextTruncate.AtEnd

        return Frame
    end

    local v67 = if v21 then v21 == "pad" else UserInputService.PreferredInput == Enum.PreferredInput.Gamepad
    local v86, floor, v87, floor2, max, v88, v89

    for _, v90 in t1 do
        if v90.kind == "controls" and v59 then
            v86 = {
                name = "Mobile HUD"
            }
            v88 = t3.sections
            table.insert(v88, v86)
            header(v86, "Mobile HUD")
            v86 = row("Control Type")
            v86.Name = "Row_ControlType"

            local v91 = pill(v86, "Cycle", 96, "")

            v88 = UDim2.new
            v89 = math.floor(6 * n1 + 0.5)
            v91.Position = v88(1, -math.max(1, v89), 0.5, 0)
            v91.BackgroundColor3 = v3
            v91.TextColor3 = v4
            v88 = v91:FindFirstChildOfClass("UIStroke")

            if v88 then
                v88.Color = v4
            end

            v91.Activated:Connect(function() -- line: 237
                -- upvalues: JerezRaceHUD (copy)
                JerezRaceHUD:SetAttribute("MobileControlType", JerezRaceHUD:GetAttribute("MobileControlType") == 2 and 1 or 2)
            end)
            v87 = t3.controls
            max = {
                kind = "mobileType",
                button = v91
            }
            table.insert(v87, max)
            v91 = row("Customize Touch Controls")
            v91.Name = "Row_MobileHud"
            v88 = pill(v91, "Edit", 46, "EDIT")
            v87 = UDim2.new
            v88.Position = v87(1, -math.max(1, (math.floor(6 * n1 + 0.5))), 0.5, 0)
            v88.BackgroundColor3 = v1 or v3
            v88.TextColor3 = v3 or v4
            v87 = v88:FindFirstChildOfClass("UIStroke")

            if v87 then
                v87.Color = v1 or v4
            end

            v88.Activated:Connect(function() -- line: 242
                -- upvalues: JerezRaceHUD (copy), v20 (ref)
                v20()
                JerezRaceHUD:SetAttribute("MobileHudEditing", true)
            end)
        else
            v86 = {}
            v86.name = v90.name
            v88 = t3
            v88 = v88.sections
            table.insert(v88, v86)

            local v94 = header(v86, v90.name)

            v88 = v90.kind

            if v88 == "controls" then
                local TextButton = Instance.new("TextButton")

                TextButton.Name = "ResetControls"
                TextButton.AutoButtonColor = false
                TextButton:SetAttribute("NoHover", true)
                TextButton.AnchorPoint = Vector2.new(1, 0.5)
                TextButton.Position = UDim2.new(1, 0, 0.5, 0)
                v88 = UDim2.fromOffset

                local v95 = n1

                floor2 = 78 * v95 + 0.5
                floor = math.floor(floor2)
                v87 = math.max(1, floor)

                local v96 = n1

                v89 = 12 * v96 + 0.5
                floor2 = math.floor(v89)
                TextButton.Size = v88(v87, (math.max(1, floor2)))
                TextButton.BackgroundColor3 = v2
                TextButton.Text = "Reset All Controls"
                TextButton.FontFace = v7

                local v97 = n1

                floor = 7 * v97 + 0.5
                max = math.floor(floor)
                TextButton.TextSize = math.max(1, max)
                TextButton.TextColor3 = v3
                v88 = UDim.new(1, 0)
                v87 = Instance.new("UICorner")
                v87.CornerRadius = v88
                v87.Parent = TextButton
                v87 = Instance.new("UIStroke")
                v87.Color = v3
                v87.Thickness = 1
                v87.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                v87.Parent = TextButton
                TextButton.Parent = v94
                TextButton.MouseEnter:Connect(function() -- line: 251
                    -- upvalues: TextButton (copy), v1 (copy)
                    TextButton.BackgroundColor3 = v1
                end)
                TextButton.MouseLeave:Connect(function() -- line: 251
                    -- upvalues: TextButton (copy), v2 (copy)
                    TextButton.BackgroundColor3 = v2
                end)
                TextButton.Activated:Connect(function() -- line: 252
                    -- upvalues: SettingsBridge (copy)
                    if SettingsBridge.ready then
                        SettingsBridge.resetBindings()
                    end
                end)
                v88 = row("Input Device")
                v88.Name = "Row_InputDevice"
                v87 = t3
                v87.deviceButtons = {}

                local v98, TextLabel, v99, new, v100, v101, v102, max2

                for v103, v104 in {
                        {
                            "kb",
                            "Keyboard",
                            "KEYBOARD"
                        },
                        {
                            "pad",
                            "Controller",
                            "CONTROLLER"
                        }
                    } do
                    v97 = pill(v88, v104[2], 60, v104[3])
                    v95 = UDim2.new
                    v101 = n1
                    v98 = 6 * v101 + 0.5
                    v99 = math.floor(v98)
                    TextLabel = -math.max(1, v99)
                    new = 2 - v103

                    local floor = n1

                    v101 = 60 * floor + 0.5
                    v100 = math.floor(v101)
                    v98 = math.max(1, v100)
                    v102 = n1
                    max2 = 4 * v102 + 0.5
                    v101 = math.floor(max2)
                    v97.Position = v95(1, TextLabel - new * (v98 + math.max(1, v101)), 0.5, 0)
                    v95 = v104[1] == "pad" == v67
                    v97.BackgroundColor3 = v95 and v1 or v3
                    v97.TextColor3 = v95 and v3 or v4
                    v96 = v97:FindFirstChildOfClass("UIStroke")

                    if v96 then
                        v96.Color = v95 and v1 or v4
                    end

                    v95 = v97.Activated
                    v95:Connect(function() -- line: 259
                        -- upvalues: v104 (copy), v67 (copy), SettingsBridge (copy), v21 (ref), v22 (ref)
                        if v104[1] == "pad" == v67 and v21 then
                            return
                        end

                        v21 = v104[1]

                        if SettingsBridge.ready and SettingsBridge.pending() then
                            SettingsBridge.cancelBind()
                        end

                        v22(true)
                    end)
                    v95 = t3
                    v95.deviceButtons[v104[1]] = v97
                end

                v88 = {}

                for _, v106 in SettingsBridge.ready and SettingsBridge.bindRows() or {} do
                    v95 = if v67 then v106.pad else v106.kb

                    local v107 = v95

                    if v95 then
                        v96 = v88[v95]

                        if not v96 then
                            v88[v95] = true
                            v96 = row(v106.label)

                            local EDIT = pill(v96, "Edit", 38, "EDIT")

                            TextLabel = UDim2.new

                            local floor = n1

                            v100 = 6 * floor + 0.5
                            EDIT.Position = TextLabel(1, -math.max(1, (math.floor(v100))), 0.5, 0)
                            EDIT.BackgroundColor3 = v1 or v3
                            EDIT.TextColor3 = v3 or v4
                            TextLabel = EDIT:FindFirstChildOfClass("UIStroke")

                            if TextLabel then
                                TextLabel.Color = v1 or v4
                            end

                            TextLabel = Instance.new("TextLabel")
                            TextLabel.Name = "Key"
                            TextLabel.AnchorPoint = Vector2.new(1, 0.5)

                            local Frame = UDim2.new
                            local v109 = n1

                            max2 = math.floor(6 * v109 + 0.5)

                            local v108 = -math.max(1, max2)

                            v109 = n1
                            max2 = math.floor(38 * v109 + 0.5)
                            v98 = v108 - math.max(1, max2)
                            v102 = n1
                            max2 = 5 * v102 + 0.5
                            v101 = math.floor(max2)
                            TextLabel.Position = Frame(1, v98 - math.max(1, v101), 0.5, 0)
                            Frame = UDim2.fromOffset
                            max2 = n1
                            v98 = math.floor(40 * max2 + 0.5)
                            new = math.max(1, v98)
                            floor = n1
                            v100 = 11 * floor + 0.5
                            TextLabel.Size = Frame(new, (math.max(1, (math.floor(v100)))))
                            TextLabel.BackgroundColor3 = v3
                            TextLabel.FontFace = v6
                            v101 = n1
                            v98 = 7 * v101 + 0.5
                            v99 = math.floor(v98)
                            TextLabel.TextSize = math.max(1, v99)
                            TextLabel.TextColor3 = v4
                            TextLabel.AutoLocalize = false
                            Frame = UDim.new
                            floor = n1
                            v100 = 2 * floor + 0.5
                            Frame = Frame(0, (math.max(1, (math.floor(v100)))))
                            new = Instance.new("UICorner")
                            new.CornerRadius = Frame
                            new.Parent = TextLabel
                            new = Instance.new("UIStroke")
                            new.Color = v5
                            new.Thickness = 1
                            new.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                            new.Parent = TextLabel
                            TextLabel.Parent = v96
                            EDIT.Activated:Connect(function() -- line: 280
                                -- upvalues: v107 (copy), SettingsBridge (copy)
                                if SettingsBridge.ready then
                                    if SettingsBridge.pending() == v107 then
                                        SettingsBridge.cancelBind()
                                    else
                                        SettingsBridge.beginBind(v107)
                                    end
                                end
                            end)
                            new = t3
                            new = new.controls
                            v99 = {
                                kind = "bind",
                                name = v107,
                                chip = TextLabel,
                                edit = EDIT
                            }
                            table.insert(new, v99)
                        end
                    end
                end
            else
                if v90.name == "Gameplay" then
                    serverCodeRow(row)
                end

                for _, v110 in v90.rows do
                    v89 = row(v110.label)

                    local v111 = v110.kind

                    if v111 == "toggle" then
                        v111 = pill(v89, "Toggle", 46, "OFF")

                        local v112 = UDim2.new
                        local v113 = n1

                        v111.Position = v112(1, -math.max(1, (math.floor(6 * v113 + 0.5))), 0.5, 0)
                        v111.Activated:Connect(function() -- line: 293
                            -- upvalues: v110 (copy), SettingsBridge (copy)
                            if SettingsBridge.ready and (v110.id ~= "afk" or not SettingsBridge.get("afkLocked")) then
                                SettingsBridge.set(v110.id, not SettingsBridge.get(v110.id))
                            end
                        end)

                        local v115 = t3

                        v115 = v115.controls
                        table.insert(v115, {
                            kind = "toggle",
                            id = v110.id,
                            button = v111
                        })
                    else
                        v111 = pill(v89, "Cycle", 64, "")

                        local v116 = UDim2.new
                        local v117 = n1
                        local v118 = 6 * v117 + 0.5
                        local new = math.floor(v118)

                        v111.Position = v116(1, -math.max(1, new), 0.5, 0)
                        v111.BackgroundColor3 = v3
                        v111.TextColor3 = v4
                        v116 = v111:FindFirstChildOfClass("UIStroke")

                        if v116 then
                            v116.Color = v4
                        end

                        v116 = {}

                        for i = 1, #v110.options do
                            local Frame = Instance.new("Frame")

                            Frame.Name = "Dot" .. i
                            Frame.AnchorPoint = Vector2.new(1, 0.5)
                            Frame.BorderSizePixel = 0
                            new = UDim2.fromOffset

                            local floor = n1

                            v117 = 5 * floor + 0.5
                            v118 = math.max(1, (math.floor(v117)))

                            local floor2 = n1

                            v117 = math.floor(5 * floor2 + 0.5)
                            Frame.Size = new(v118, (math.max(1, v117)))
                            new = UDim2.new

                            local v122 = n1
                            local v121 = -math.max(1, (math.floor(6 * v122 + 0.5)))

                            v122 = n1
                            v117 = v121 - math.max(1, (math.floor(64 * v122 + 0.5)))

                            local v124 = n1
                            local v120 = v117 - math.max(1, (math.floor(6 * v124 + 0.5)))

                            v121 = #v110.options - i
                            v122 = n1
                            Frame.Position = new(1, v120 - v121 * math.max(1, (math.floor(8 * v122 + 0.5))), 0.5, 0)
                            new = UDim.new(1, 0)
                            v118 = Instance.new("UICorner")
                            v118.CornerRadius = new
                            v118.Parent = Frame
                            v118 = Instance.new("UIStroke")
                            v118.Color = v4
                            v118.Thickness = 1
                            v118.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                            v118.Parent = Frame
                            Frame.Parent = v89
                            v116[i] = Frame
                        end

                        v111.Activated:Connect(function() -- line: 307
                            -- upvalues: v110 (copy), SettingsBridge (copy)
                            if SettingsBridge.ready then
                                local v125 = SettingsBridge.get(v110.id)
                                local v126 = table.find(v110.options, v125) or 0

                                SettingsBridge.set(v110.id, v110.options[v126 % #v110.options + 1])
                            end
                        end)

                        local EDIT = t3

                        EDIT = EDIT.controls
                        table.insert(EDIT, {
                            kind = "cycle",
                            id = v110.id,
                            button = v111,
                            dots = v116,
                            options = v110.options
                        })
                    end
                end
            end
        end
    end

    for v127, v128 in t3.sections do
        v86 = Instance.new("TextButton")
        v86.Name = "Cat_" .. v128.name
        v86.AutoButtonColor = false
        v86:SetAttribute("NoHover", true)
        v86.BorderSizePixel = 0

        local new = UDim2.new

        v89 = 20 * n1 + 0.5
        floor2 = math.floor(v89)
        v86.Size = new(1, 0, 0, (math.max(1, floor2)))
        v86.LayoutOrder = v127
        v86.BackgroundColor3 = v1
        v86.BackgroundTransparency = 1
        v86.Text = v128.name
        v86.FontFace = v7
        v87 = 9.5 * n1 + 0.5
        v88 = math.floor(v87)
        v86.TextSize = math.max(1, v88)
        v86.TextColor3 = v3
        v86.TextXAlignment = Enum.TextXAlignment.Left
        v86.AutoLocalize = false
        new = Instance.new("UIPadding")

        local new2 = UDim.new

        floor = 10 * n1 + 0.5
        max = math.floor(floor)
        new.PaddingLeft = new2(0, (math.max(1, max)))
        new.Parent = v86
        v86.Parent = Frame2
        v86.MouseEnter:Connect(function() -- line: 324
            -- upvalues: v128 (copy)
            v128.hover = true
        end)
        v86.MouseLeave:Connect(function() -- line: 324
            -- upvalues: v128 (copy)
            v128.hover = false
        end)
        v86.Activated:Connect(function() -- line: 325
            -- upvalues: ScrollingFrame (copy), v128 (copy), TweenService (copy), t3 (ref)
            local v129 = v128.header.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y
            local v131 = math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y)

            t3.scrollTarget = v128
            TweenService:Create(ScrollingFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                CanvasPosition = Vector2.new(0, (math.clamp(v129, 0, v131)))
            }):Play()
        end)
        v128.button = v86
    end

    if v58 then
        task.defer(function() -- line: 333
            -- upvalues: ScrollingFrame (copy), v58 (copy)
            if ScrollingFrame.Parent then
                ScrollingFrame.CanvasPosition = v58
            end
        end)
    end
end

local function refreshSettings() -- line: 336
    -- upvalues: SettingsBridge (copy), JerezRaceHUD (copy), v1 (copy), v3 (copy), v4 (copy), n1 (ref), t2 (copy), t3 (ref)
    if t3.root then
        local ready = SettingsBridge.ready

        for _, v132 in t3.controls do
            if v132.kind == "toggle" then
                local v133 = ready and SettingsBridge.get(v132.id) == true
                local v134 = v132.id == "afk" and ready and SettingsBridge.get("afkLocked")
                local v135 = if v134 then "LOCKED" elseif v133 then "ON" else "OFF"

                if v132.button.Text ~= v135 then
                    v132.button.Text = v135
                end

                local button = v132.button
                local v136 = v133 and not v134

                button.BackgroundColor3 = v136 and v1 or v3
                button.TextColor3 = v136 and v3 or v4

                local UIStroke = button:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIStroke.Color = v136 and v1 or v4
                end
            elseif v132.kind == "cycle" then
                local v137 = ready and SettingsBridge.get(v132.id) or v132.options[1]
                local v138 = string.upper((tostring(v137)))

                if v132.button.Text ~= v138 then
                    v132.button.Text = v138
                end

                local v139 = table.find(v132.options, v137)

                for v140, v141 in v132.dots do
                    v141.BackgroundColor3 = v140 == v139 and v1 or v3
                    v141.UIStroke.Color = v140 == v139 and v1 or v4
                end
            elseif v132.kind == "mobileType" then
                local v142 = if JerezRaceHUD:GetAttribute("MobileControlType") == 2 then "TYPE 2 · BUTTONS" else "TYPE 1 · STICK"

                if v132.button.Text ~= v142 then
                    v132.button.Text = v142
                end
            elseif v132.kind == "bind" then
                local v143 = ready and SettingsBridge.pending() == v132.name
                local v144

                if v143 then
                    v144 = "PRESS…"
                else
                    local v145 = ready and SettingsBridge.keyName(v132.name) or v132.name

                    v144 = t2[v145] or string.upper(v145)
                end

                if v132.chip.Text ~= v144 then
                    v132.chip.Text = v144
                end

                v132.edit.Text = v143 and "CANCEL" or "EDIT"
            end
        end

        local content = t3.content
        local v146 = t3.sections[1]
        local v148 = math.max(0, content.AbsoluteCanvasSize.Y - content.AbsoluteWindowSize.Y)

        if not (content.CanvasPosition.Y >= v148 - 2 and v148 > 0) then
            for _, v150 in t3.sections do
                if v150.header.AbsolutePosition.Y - content.AbsolutePosition.Y <= math.max(1, (math.floor(8 * n1 + 0.5))) then
                    v146 = v150
                end
            end
        else
            v146 = t3.sections[#t3.sections]
        end

        for _, v154 in t3.sections do
            local v155 = v154 == v146
            local button = v154.button

            if v155 then
                button.BackgroundTransparency = 0
            elseif v154.hover then
                button.BackgroundTransparency = 0.75
            else
                button.BackgroundTransparency = 1
            end
        end
    end
end

local function openSettings() -- line: 379
    -- upvalues: JerezRaceHUD (copy), t3 (ref), v19 (ref), build (copy), refreshSettings (copy)
    if not v19 then
        local MotoLegends = game:GetService("ReplicatedStorage"):FindFirstChild("MotoLegends")
        local CloseMenus = MotoLegends and MotoLegends:FindFirstChild("CloseMenus")

        if CloseMenus then
            CloseMenus:Fire("Settings")
        end
    end

    build()
    v19 = true
    t3.root.Visible = true
    t3.close.Modal = true
    JerezRaceHUD:SetAttribute("LobbySettings", true)
    refreshSettings()
end

v22 = function(p32) -- line: 394
    -- upvalues: UserInputService (copy), GuiService (copy), t3 (ref), v19 (ref), v21 (ref), build (copy), refreshSettings (copy)
    if not v19 then
        return
    end

    local v156 = GuiService.SelectedObject ~= nil

    build()
    t3.root.Visible = true
    t3.close.Modal = true
    refreshSettings()

    if not (p32 and v156 and t3.deviceButtons) then
        return
    end

    GuiService.SelectedObject = t3.deviceButtons[(if v21 then v21 == "pad" else UserInputService.PreferredInput == Enum.PreferredInput.Gamepad) and "pad" or "kb"]
end

UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 401
    -- upvalues: UserInputService (copy), SettingsBridge (copy), v19 (ref), v21 (ref), v22 (ref)
    if not (v21 or not v19 or SettingsBridge.ready and SettingsBridge.pending()) and UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then
        v22(true)
    end
end)

v20 = function() -- line: 405
    -- upvalues: SettingsBridge (copy), JerezRaceHUD (copy), t3 (ref), v19 (ref)
    if not v19 then
        return
    end

    v19 = false

    if SettingsBridge.ready and SettingsBridge.pending() then
        SettingsBridge.cancelBind()
    end

    if t3.root then
        t3.root.Visible = false
        t3.close.Modal = false
    end

    if JerezRaceHUD:GetAttribute("LobbySettings") == true then
        JerezRaceHUD:SetAttribute("LobbySettings", false)
    end
end

workspace:GetAttributeChangedSignal("PrivateServerCode"):Connect(function() -- line: 413
    -- upvalues: v19 (ref), openSettings (copy)
    if v19 then
        openSettings()
    end
end)
JerezRaceHUD:GetAttributeChangedSignal("LobbySettings"):Connect(function() -- line: 415
    -- upvalues: JerezRaceHUD (copy), v19 (ref), v20 (ref)
    if v19 and JerezRaceHUD:GetAttribute("LobbySettings") ~= true then
        v20()
    end
end)
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 418
    -- upvalues: t3 (ref), v19 (ref), build (copy)
    if v19 then
        build()
        t3.root.Visible = true
        t3.close.Modal = true
    end
end)

local ShopCatalog = require(MotoLegends:WaitForChild("ShopCatalog"))
local HttpService = game:GetService("HttpService")
local _require = require
local ok, result = pcall(_require, MotoLegends:WaitForChild("RaceNametags"))
local RoleStyles = ok and result.RoleStyles or {}
local t9 = {
    open = false
}
local v158
local t10 = {
    {
        id = "Default",
        name = "Classic Green",
        color = Color3.fromRGB(34, 110, 62)
    }
}
local v159, t11

for _, v160 in ShopCatalog.BottleOrder do
    v159 = ShopCatalog.Bottles[v160]
    t11 = {
        id = v160,
        name = v159.Short:sub(1, 1) .. v159.Short:sub(2):lower() .. " Bottle",
        color = v159.Glass
    }
    t11.gradient = v159.Rainbow and v159.Foam or nil
    table.insert(t10, t11)
end

for _, v161 in ShopCatalog.ExclusiveOrder or {} do
    v159 = ShopCatalog.Bottles[v161]

    if v159 then
        t11 = {
            id = v161,
            name = v159.Short:sub(1, 1) .. v159.Short:sub(2):lower() .. " Bottle",
            color = v159.Glass
        }
        table.insert(t10, t11)
    end
end

for _, v162 in ShopCatalog.VipOrder or {} do
    v159 = ShopCatalog.Bottles[v162]

    if v159 then
        t11 = {
            name = "Black Hole Bottle · VIP",
            id = v162,
            color = v159.Glass
        }
        table.insert(t10, t11)
    end
end

local t12 = {
    {
        id = "Default",
        name = "Classic"
    },
    {
        id = "benefactor",
        name = "Benefactor"
    },
    {
        id = "patron",
        name = "Patron"
    },
    {
        id = "supporter",
        name = "Supporter"
    },
    {
        id = "fan",
        name = "Fan"
    },
    {
        id = "vip",
        name = "Black Hole · VIP"
    },
    {
        id = "owner",
        name = "Owner"
    },
    {
        id = "dev",
        name = "Developer"
    },
    {
        id = "admin",
        name = "Admin"
    },
    {
        id = "mod",
        name = "Moderator"
    },
    {
        id = "fun",
        name = "Fun"
    },
    {
        id = "racedirector",
        name = "Race Director 2"
    },
    {
        id = "racedirector1",
        name = "Race Director 1"
    }
}

local function ownedBottles() -- line: 454
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local JSONDecode = HttpService.JSONDecode
    local v163 = LocalPlayer:GetAttribute("OwnedBottles") or "[]"
    local ok, result = pcall(JSONDecode, HttpService, v163)
    local t13 = {
        Default = true
    }

    if ok and typeof(result) == "table" then
        for _, v164 in result do
            t13[v164] = true
        end
    end

    return t13
end

local function ownedTags() -- line: 459
    -- upvalues: LocalPlayer (copy), HttpService (copy)
    local JSONDecode = HttpService.JSONDecode
    local v165 = LocalPlayer:GetAttribute("OwnedNametags") or "[]"
    local ok, result = pcall(JSONDecode, HttpService, v165)
    local t14 = {
        Default = true
    }

    if ok and typeof(result) == "table" then
        for _, v166 in result do
            t14[v166] = true
        end
    end

    return t14
end

local function ownedKey() -- line: 464
    -- upvalues: LocalPlayer (copy)
    return tostring(LocalPlayer:GetAttribute("OwnedBottles") or "") .. "|" .. tostring(LocalPlayer:GetAttribute("OwnedNametags") or "")
end

local function refreshBottles() -- line: 467
    -- upvalues: LocalPlayer (copy), v1 (copy), v3 (copy), v4 (copy), n1 (ref), t9 (copy)
    if t9.root then
        local v170 = LocalPlayer:GetAttribute("SelectedBottle") or "Default"
        local v171 = LocalPlayer:GetAttribute("SelectedNametag") or "Default"

        for _, v172 in t9.rows do
            local v173 = (v172.kind == "bottle" and v170 or v171) == v172.id
            local v174 = if v173 then "EQUIPPED" else "EQUIP"

            if v172.pill.Text ~= v174 then
                v172.pill.Text = v174
            end

            local pill = v172.pill

            pill.BackgroundColor3 = v173 and v1 or v3
            pill.TextColor3 = v173 and v3 or v4

            local UIStroke = pill:FindFirstChildOfClass("UIStroke")

            if UIStroke then
                UIStroke.Color = v173 and v1 or v4
            end
        end

        local content = t9.content

        if not content then
            return
        end

        local v175 = t9.sections[1]
        local v177 = math.max(0, content.AbsoluteCanvasSize.Y - content.AbsoluteWindowSize.Y)

        if not (content.CanvasPosition.Y >= v177 - 2 and v177 > 0) then
            for _, v179 in t9.sections do
                if v179.header.AbsolutePosition.Y - content.AbsolutePosition.Y <= math.max(1, (math.floor(8 * n1 + 0.5))) then
                    v175 = v179
                end
            end
        else
            v175 = t9.sections[#t9.sections]
        end

        if t9.picked then
            if not t9.pickedCanvas or (content.CanvasPosition - t9.pickedCanvas).Magnitude < 1 then
                v175 = t9.picked
            else
                t9.picked = nil
                t9.pickedCanvas = nil
            end
        end

        for _, v183 in t9.sections do
            if v183.button then
                local button = v183.button

                if v183 == v175 then
                    button.BackgroundTransparency = 0
                elseif v183.hover then
                    button.BackgroundTransparency = 0.75
                else
                    button.BackgroundTransparency = 1
                end
            end
        end
    end
end

local function tagSwatch(p33, p34) -- line: 491
    -- upvalues: v2 (copy), v3 (copy), v4 (copy), n1 (ref), ok (copy), result (copy), RoleStyles (copy)
    local v184 = RoleStyles[p34]
    local Frame = Instance.new("Frame")

    Frame.Name = "Swatch"
    Frame.AnchorPoint = Vector2.new(0, 0.5)
    Frame.Position = UDim2.new(0, math.max(1, (math.floor(7 * n1 + 0.5))), 0.5, 0)
    Frame.Size = UDim2.fromOffset(math.max(1, (math.floor(16 * n1 + 0.5))), (math.max(1, (math.floor(9 * n1 + 0.5)))))
    Frame.BackgroundColor3 = v184 and v184.color or v2
    Frame.BorderSizePixel = 0

    local v194 = UDim.new(0, (math.max(1, (math.floor(2 * n1 + 0.5)))))
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v194
    UICorner.Parent = Frame
    Frame.Parent = p33

    local v195 = v4

    if not v184 or v184.glow ~= "blackhole" then
        local v196 = if v184 then v184.glow == "pulse" else nil

        if not v184 or not v196 then
            local outline = if v184 then v184.outline else nil

            if not v184 or not outline then
                if v184 and v184.glow == "crimson" then
                    v195 = Color3.fromRGB(235, 25, 40)
                end
            else
                v195 = v184.outline
            end
        else
            v195 = Color3.fromRGB(255, 90, 90)
        end
    else
        v195 = Color3.fromRGB(255, 170, 30)
    end

    local v197 = if not (v184 and v184.glow) then 1 else 1.5
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v195
    UIStroke.Thickness = v197 or 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame

    local UIGradient, new3, v198, new4, v199

    if v184 then
        if v184.rim == "checker" then
            UIStroke.Color = v3
            UIStroke.Thickness = 1.5

            local t15 = {}

            for i = 0, 7 do
                local v200 = i % 2 == 0
                local v201 = if v200 then v3 else nil
                local v202 = if not v200 or not v201 then v2 else v201

                table.insert(t15, ColorSequenceKeypoint.new(i / 8, v202))
                table.insert(t15, ColorSequenceKeypoint.new(math.min(1, (i + 1) / 8 - 0.001), v202))
            end

            t15[#t15] = ColorSequenceKeypoint.new(1, t15[#t15].Value)

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Color = ColorSequence.new(t15)
            UIGradient.Parent = UIStroke
        end

        if v184.flag and ok and result.ApplyFlag then
            result.ApplyFlag(Frame, v184, math.max(1, (math.floor(6 * n1 + 0.5))) / result.FlagTile, false)
        end

        if v184.shine then
            UIGradient = Instance.new("UIGradient")
            UIGradient.Rotation = 15
            new3 = ColorSequence.new
            v198 = ColorSequenceKeypoint.new(0, v3)
            new4 = ColorSequenceKeypoint.new
            v199 = v184.shineColor or Color3.fromRGB(255, 255, 255)
            UIGradient.Color = new3({
                v198,
                new4(0.5, v199),
                ColorSequenceKeypoint.new(1, v3)
            })
            UIGradient.Parent = Frame
        end
    end

    return Frame
end

local function buildBottles() -- line: 512
    -- upvalues: UserInputService (copy), TweenService (copy), LocalPlayer (copy), MotoLegends (copy), RaceIcons (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v6 (copy), v7 (copy), ScreenGui (copy), n1 (ref), pill (copy), t9 (copy), v158 (ref), t10 (copy), t12 (copy), ownedBottles (copy), ownedTags (copy), refreshBottles (copy), tagSwatch (copy)
    if t9.root then
        t9.root:Destroy()
    end

    local v208 = t9.content and t9.content.CanvasPosition

    t9.rows = {}
    t9.sections = {}
    t9.builtFor = tostring(LocalPlayer:GetAttribute("OwnedBottles") or "") .. "|" .. tostring(LocalPlayer:GetAttribute("OwnedNametags") or "")
    t9.picked = nil
    t9.pickedCanvas = nil

    local ViewportSize = workspace.CurrentCamera.ViewportSize

    n1 = math.min(ViewportSize.Y / 360, (ViewportSize.X - 24) / 330)

    local v210 = if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then 22 else 18
    local Frame = Instance.new("Frame")

    Frame.Name = "CustomizationWindow"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(math.max(1, (math.floor(330 * n1 + 0.5))), (math.max(1, (math.floor(200 * n1 + 0.5)))))
    Frame.BackgroundColor3 = v2
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Visible = false

    local TextButton = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    local fromOffset = Instance.new("UICorner")

    fromOffset.CornerRadius = TextButton
    fromOffset.Parent = Frame
    Frame.Parent = ScreenGui
    t9.root = Frame

    local v211 = math.max(1, (math.floor(12 * n1 + 0.5)))
    local Frame2 = Instance.new("TextLabel")

    Frame2.Name = "Title"
    Frame2.BackgroundTransparency = 1
    Frame2.Text = "CUSTOMIZATION"
    Frame2.FontFace = v6
    Frame2.TextSize = v211
    Frame2.TextColor3 = v3
    Frame2.TextXAlignment = Enum.TextXAlignment.Left
    Frame2.AutoLocalize = false
    Frame2.Parent = Frame
    Frame2.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(8 * n1 + 0.5)))))
    Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(200 * n1 + 0.5))), (math.max(1, (math.floor(14 * n1 + 0.5)))))
    TextButton = Instance.new("Frame")
    TextButton.Name = "Divider"
    TextButton.BorderSizePixel = 0
    TextButton.BackgroundColor3 = v3
    TextButton.Position = UDim2.fromOffset(math.max(1, (math.floor(12 * n1 + 0.5))), (math.max(1, (math.floor(27 * n1 + 0.5)))))
    TextButton.Size = UDim2.fromOffset(math.max(1, (math.floor(99 * n1 + 0.5))), (math.max(1, (math.floor(n1 + 0.5)))))
    TextButton.Parent = Frame
    fromOffset = Instance.new("UIGradient")
    fromOffset.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    fromOffset.Parent = TextButton
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Close"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton:SetAttribute("NoHover", true)
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    fromOffset = UDim2.new

    local v209 = -math.max(1, (math.floor(26 * n1 + 0.5)))
    local v213 = math.floor(18 * n1 + 0.5)

    TextButton.Position = fromOffset(1, v209, 0, (math.max(1, v213)))
    fromOffset = UDim2.fromOffset
    v211 = math.max(1, (math.floor(30 * n1 + 0.5)))

    local v212 = 16 * n1 + 0.5

    TextButton.Size = fromOffset(v211, (math.max(1, (math.floor(v212)))))
    TextButton.ZIndex = 3
    TextButton.Parent = Frame
    t9.close = TextButton

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Plate"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ImageColor3 = v3
    ImageLabel.ZIndex = 3
    ImageLabel.Parent = TextButton
    v209 = RaceIcons.Get("ref_top_plate")

    if v209 then
        ImageLabel.ImageContent = v209
    else
        ImageLabel.BackgroundTransparency = 0
        ImageLabel.BackgroundColor3 = v3
        v211 = UDim.new
        v213 = 4 * n1 + 0.5
        v212 = math.floor(v213)
        v211 = v211(0, (math.max(1, v212)))
        v209 = Instance.new("UICorner")
        v209.CornerRadius = v211
        v209.Parent = ImageLabel
    end

    Frame2 = math.max(1, (math.floor(10 * n1 + 0.5)))

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "X"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "X"
    TextLabel.FontFace = v6
    TextLabel.TextSize = Frame2
    TextLabel.TextColor3 = v2
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = TextButton
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel.ZIndex = 4

    local function hover(p35) -- line: 534
        -- upvalues: ImageLabel (copy), TextLabel (copy), TweenService (copy), v1 (copy), v2 (copy), v3 (copy)
        TweenService:Create(ImageLabel, TweenInfo.new(0.18), {
            ImageColor3 = p35 and v1 or v3,
            BackgroundColor3 = p35 and v1 or v3
        }):Play()
        TweenService:Create(TextLabel, TweenInfo.new(0.18), {
            TextColor3 = p35 and v3 or v2
        }):Play()
    end

    TextButton.MouseEnter:Connect(function() -- line: 538
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.MouseLeave:Connect(function() -- line: 538
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.SelectionGained:Connect(function() -- line: 539
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.SelectionLost:Connect(function() -- line: 539
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.Activated:Connect(function() -- line: 540
        -- upvalues: v158 (ref)
        v158()
    end)
    Frame2 = Instance.new("Frame")
    Frame2.Name = "Categories"
    Frame2.BackgroundTransparency = 1
    Frame2.Position = UDim2.fromOffset(0, (math.max(1, (math.floor(36 * n1 + 0.5)))))
    Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(78 * n1 + 0.5))), (math.max(1, (math.floor(156 * n1 + 0.5)))))
    Frame2.Parent = Frame

    local Frame3 = Instance.new("UIListLayout")

    Frame3.SortOrder = Enum.SortOrder.LayoutOrder
    Frame3.Parent = Frame2
    Frame3 = Instance.new("Frame")
    Frame3.Name = "Separator"
    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = Color3.fromRGB(44, 46, 54)
    Frame3.Position = UDim2.fromOffset(math.max(1, (math.floor(80 * n1 + 0.5))), (math.max(1, (math.floor(36 * n1 + 0.5)))))
    Frame3.Size = UDim2.fromOffset(math.max(1, (math.floor(n1 + 0.5))), (math.max(1, (math.floor(156 * n1 + 0.5)))))
    Frame3.Parent = Frame

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "Content"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(math.max(1, (math.floor(86 * n1 + 0.5))), (math.max(1, (math.floor(34 * n1 + 0.5)))))
    ScrollingFrame.Size = UDim2.fromOffset(math.max(1, (math.floor(238 * n1 + 0.5))), (math.max(1, (math.floor(160 * n1 + 0.5)))))
    ScrollingFrame.ScrollBarThickness = math.max(2, (math.max(1, (math.floor(2 * n1 + 0.5)))))
    ScrollingFrame.ScrollBarImageColor3 = v3
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.Parent = Frame
    t9.content = ScrollingFrame

    local UIPadding = Instance.new("UIListLayout")

    UIPadding.SortOrder = Enum.SortOrder.LayoutOrder
    UIPadding.Padding = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    UIPadding.Parent = ScrollingFrame
    UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingRight = UDim.new(0, (math.max(1, (math.floor(8 * n1 + 0.5)))))
    UIPadding.PaddingTop = UDim.new(0, (math.max(1, (math.floor(2 * n1 + 0.5)))))
    UIPadding.PaddingBottom = UDim.new(0, (math.max(1, (math.floor(6 * n1 + 0.5)))))
    UIPadding.Parent = ScrollingFrame
    ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(refreshBottles)

    local n3 = 0

    local function nextOrder() -- line: 553
        -- upvalues: n3 (ref)
        n3 += 1

        return n3
    end

    local function header(p36) -- line: 554
        -- upvalues: ScrollingFrame (copy), n3 (ref), v3 (copy), v6 (copy), n1 (ref), t9 (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = "Header_" .. p36
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(20 * n1 + 0.5)))))
        n3 += 1
        Frame.LayoutOrder = n3
        Frame.Parent = ScrollingFrame

        local v223 = math.max(1, (math.floor(11 * n1 + 0.5)))
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "Title"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p36
        TextLabel.FontFace = v6
        TextLabel.TextSize = v223
        TextLabel.TextColor3 = v3
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.AutoLocalize = false
        TextLabel.Parent = Frame
        TextLabel.Size = UDim2.fromScale(1, 1)

        local t18 = {
            name = p36,
            header = Frame
        }

        table.insert(t9.sections, t18)

        return t18
    end

    local function row(p37, p38, p39) -- line: 559
        -- upvalues: ScrollingFrame (copy), n3 (ref), v210 (copy), LocalPlayer (copy), MotoLegends (copy), v3 (copy), v4 (copy), v7 (copy), n1 (ref), pill (copy), t9 (copy), ownedBottles (copy), ownedTags (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = "Row_" .. p39 .. "_" .. p37
        Frame.BackgroundColor3 = v3
        Frame.BorderSizePixel = 0
        Frame.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(v210 * n1 + 0.5)))))
        n3 += 1
        Frame.LayoutOrder = n3

        local v228 = UDim.new(0, (math.max(1, (math.floor(3 * n1 + 0.5)))))
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = v228
        UICorner.Parent = Frame
        Frame.Parent = ScrollingFrame

        local v231 = math.max(1, (math.floor(8.5 * n1 + 0.5)))
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "Label"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p38
        TextLabel.FontFace = v7
        TextLabel.TextSize = v231
        TextLabel.TextColor3 = v4
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.AutoLocalize = false
        TextLabel.Parent = Frame
        TextLabel.Position = UDim2.fromOffset(math.max(1, (math.floor((if p39 == "tag" then 29 else 22) * n1 + 0.5))), 0)
        TextLabel.Size = UDim2.new(1, -math.max(1, (math.floor(110 * n1 + 0.5))), 1, 0)
        TextLabel.TextTruncate = Enum.TextTruncate.AtEnd

        local v236 = pill(Frame, "Pill", 60, "")

        v236.Position = UDim2.new(1, -math.max(1, (math.floor(6 * n1 + 0.5))), 0.5, 0)
        v236.Activated:Connect(function() -- line: 564
            -- upvalues: p37 (copy), p39 (copy), LocalPlayer (copy), MotoLegends (copy), ownedBottles (copy), ownedTags (copy)
            if p39 == "bottle" then
                if (LocalPlayer:GetAttribute("SelectedBottle") or "Default") == p37 or not ownedBottles()[p37] then
                    return
                end

                local ShopAction = MotoLegends:FindFirstChild("ShopAction")

                if ShopAction then
                    task.spawn(function() -- line: 568
                        -- upvalues: ShopAction (copy), p37 (copy)
                        local InvokeServer = ShopAction.InvokeServer

                        pcall(InvokeServer, ShopAction, "Equip", p37)
                    end)
                end
            else
                if (LocalPlayer:GetAttribute("SelectedNametag") or "Default") == p37 or not ownedTags()[p37] then
                    return
                end

                local NametagAction = MotoLegends:FindFirstChild("NametagAction")

                if NametagAction then
                    task.spawn(function() -- line: 572
                        -- upvalues: NametagAction (copy), p37 (copy)
                        local InvokeServer = NametagAction.InvokeServer

                        pcall(InvokeServer, NametagAction, "Equip", p37)
                    end)
                end
            end
        end)
        table.insert(t9.rows, {
            id = p37,
            kind = p39,
            pill = v236
        })

        return Frame
    end

    header("Bottles")

    local v217 = ownedBottles()
    local bottle, Frame4, fromOffset2, v239, v240, v241, v242

    for _, v243 in t10 do
        if v217[v243.id] then
            bottle = row(v243.id, v243.name, "bottle")
            Frame4 = Instance.new("Frame")
            Frame4.Name = "Swatch"
            Frame4.AnchorPoint = Vector2.new(0, 0.5)
            fromOffset2 = UDim2.new
            v241 = 8 * n1 + 0.5
            v242 = math.floor(v241)
            Frame4.Position = fromOffset2(0, math.max(1, v242), 0.5, 0)
            fromOffset2 = UDim2.fromOffset
            v242 = 9 * n1 + 0.5
            v239 = math.floor(v242)
            v240 = math.max(1, v239)
            v241 = 9 * n1 + 0.5
            v242 = math.floor(v241)
            Frame4.Size = fromOffset2(v240, (math.max(1, v242)))
            Frame4.BackgroundColor3 = v243.gradient and v3 or v243.color
            Frame4.BorderSizePixel = 0
            fromOffset2 = UDim.new(1, 0)
            v240 = Instance.new("UICorner")
            v240.CornerRadius = fromOffset2
            v240.Parent = Frame4
            v240 = Instance.new("UIStroke")
            v240.Color = v4
            v240.Thickness = 1
            v240.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            v240.Parent = Frame4
            Frame4.Parent = bottle

            if v243.gradient then
                fromOffset2 = Instance.new("UIGradient")
                fromOffset2.Color = v243.gradient
                fromOffset2.Parent = Frame4
            end
        end
    end

    header("Nametags")
    v217 = ownedTags()

    for _, v244 in t12 do
        if v217[v244.id] then
            bottle = row(v244.id, v244.name, "tag")
            tagSwatch(bottle, v244.id)
        end
    end

    local Frame5 = Instance.new("Frame")

    Frame5.Name = "EndSpacer"
    Frame5.BackgroundTransparency = 1
    Frame5.Size = UDim2.new(1, 0, 0, 0)
    n3 += 1
    Frame5.LayoutOrder = n3
    Frame5.Parent = ScrollingFrame
    task.defer(function() -- line: 595
        -- upvalues: ScrollingFrame (copy), Frame5 (copy), t9 (copy)
        local v245 = t9.sections[#t9.sections]

        if not (Frame5.Parent and v245) then
            return
        end

        local v246 = v245.header.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y
        local v247 = ScrollingFrame.AbsoluteWindowSize.Y - (ScrollingFrame.AbsoluteCanvasSize.Y - v246)

        if v247 > 0 then
            Frame5.Size = UDim2.new(1, 0, 0, v247)
        end
    end)

    for v248, v249 in t9.sections do
        bottle = Instance.new("TextButton")
        bottle.Name = "Cat_" .. v249.name
        bottle.AutoButtonColor = false
        bottle:SetAttribute("NoHover", true)
        bottle.BorderSizePixel = 0

        local new = UDim2.new

        v241 = 20 * n1 + 0.5
        v242 = math.floor(v241)
        bottle.Size = new(1, 0, 0, (math.max(1, v242)))
        bottle.LayoutOrder = v248
        bottle.BackgroundColor3 = v1
        bottle.BackgroundTransparency = 1
        bottle.Text = v249.name
        bottle.FontFace = v7
        v240 = 9.5 * n1 + 0.5
        fromOffset2 = math.floor(v240)
        bottle.TextSize = math.max(1, fromOffset2)
        bottle.TextColor3 = v3
        bottle.TextXAlignment = Enum.TextXAlignment.Left
        bottle.AutoLocalize = false
        new = Instance.new("UIPadding")
        Frame4 = UDim.new
        v242 = 10 * n1 + 0.5
        v239 = math.floor(v242)
        new.PaddingLeft = Frame4(0, (math.max(1, v239)))
        new.Parent = bottle
        bottle.Parent = Frame2
        bottle.MouseEnter:Connect(function() -- line: 609
            -- upvalues: v249 (copy), refreshBottles (copy)
            v249.hover = true
            refreshBottles()
        end)
        bottle.MouseLeave:Connect(function() -- line: 609
            -- upvalues: v249 (copy), refreshBottles (copy)
            v249.hover = false
            refreshBottles()
        end)
        bottle.Activated:Connect(function() -- line: 610
            -- upvalues: ScrollingFrame (copy), v249 (copy), TweenService (copy), t9 (copy), refreshBottles (copy)
            local v250 = v249.header.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y
            local v252 = math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y)

            t9.picked = v249
            t9.pickedCanvas = nil

            local tween = TweenService:Create(ScrollingFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                CanvasPosition = Vector2.new(0, (math.clamp(v250, 0, v252)))
            })

            tween.Completed:Connect(function() -- line: 615
                -- upvalues: ScrollingFrame (copy), v249 (copy), t9 (copy), refreshBottles (copy)
                if t9.picked == v249 then
                    t9.pickedCanvas = ScrollingFrame.CanvasPosition
                    refreshBottles()
                end
            end)
            tween:Play()
            refreshBottles()
        end)
        v249.button = bottle
    end

    if v208 then
        task.defer(function() -- line: 620
            -- upvalues: ScrollingFrame (copy), v208 (copy)
            if ScrollingFrame.Parent then
                ScrollingFrame.CanvasPosition = v208
            end
        end)
    end

    refreshBottles()
end

local function openBottles() -- line: 623
    -- upvalues: v20 (ref), t9 (copy), refreshBottles (copy), buildBottles (copy)
    v20()
    buildBottles()
    t9.open = true
    t9.root.Visible = true
    t9.close.Modal = true
    task.defer(refreshBottles)
end

v158 = function() -- line: 628
    -- upvalues: t9 (copy)
    if t9.open then
        t9.open = false

        if t9.root then
            t9.root.Visible = false
            t9.close.Modal = false
        end
    end
end

local CloseMenus = MotoLegends:FindFirstChild("CloseMenus") or Instance.new("BindableEvent")

CloseMenus.Name = "CloseMenus"
CloseMenus.Parent = MotoLegends
CloseMenus.Event:Connect(function(p40) -- line: 636
    -- upvalues: v20 (ref), v158 (ref)
    v158()

    if p40 ~= "Settings" then
        v20()
    end
end)

local function ownedChanged() -- line: 642
    -- upvalues: LocalPlayer (copy), t9 (copy), buildBottles (copy)
    if t9.open then
        if t9.builtFor == tostring(LocalPlayer:GetAttribute("OwnedBottles") or "") .. "|" .. tostring(LocalPlayer:GetAttribute("OwnedNametags") or "") then
            return
        end

        buildBottles()
        t9.root.Visible = true
        t9.close.Modal = true
    end
end

LocalPlayer:GetAttributeChangedSignal("OwnedBottles"):Connect(ownedChanged)
LocalPlayer:GetAttributeChangedSignal("OwnedNametags"):Connect(ownedChanged)
LocalPlayer:GetAttributeChangedSignal("SelectedBottle"):Connect(refreshBottles)
LocalPlayer:GetAttributeChangedSignal("SelectedNametag"):Connect(refreshBottles)
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 647
    -- upvalues: t9 (copy), buildBottles (copy)
    if t9.open then
        buildBottles()
        t9.root.Visible = true
        t9.close.Modal = true
    end
end)
UserInputService.InputBegan:Connect(function(p41) -- line: 650
    -- upvalues: t9 (copy), v158 (ref)
    if t9.open and p41.KeyCode == Enum.KeyCode.ButtonB then
        v158()
    end
end)

local t20 = {
    on = false,
    yaw = 0,
    pitch = 0,
    pos = Vector3.new(0, 0, 0),
    vel = Vector3.new(0, 0, 0),
    speed = 32,
    look = nil,
    hintHidden = false,
    hidden = {},
    hum = {}
}

t11 = {
    Default = 70,
    Min = 5,
    Max = 110,
    Rate = 45
}
t20.fov = 70

local _ = {
    LookRate = 2.6,
    MoveRate = 1.4,
    PosRate = 3.2,
    FovRate = 2.2,
    SpeedScale = 0.5,
    BankPerYawRate = 0.06,
    BankMax = 0.12217304763960307,
    BankRate = 2
}

t20.cine = false

local ScreenGui2 = Instance.new("ScreenGui")

ScreenGui2.Name = "FreecamHUD"
ScreenGui2.ResetOnSpawn = false
ScreenGui2.IgnoreGuiInset = true
ScreenGui2.DisplayOrder = 45
ScreenGui2.Enabled = false
ScreenGui2.Parent = PlayerGui

local Frame2 = Instance.new("Frame")

Frame2.Name = "Panel"
Frame2.AnchorPoint = Vector2.new(0.5, 0)
Frame2.BackgroundColor3 = v2
Frame2.BackgroundTransparency = 0.1
Frame2.BorderSizePixel = 0
Frame2.Parent = ScreenGui2

local v256 = UDim.new(0, 4)
local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = v256
UICorner2.Parent = Frame2

local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "Title"
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "FREECAM"
TextLabel.FontFace = v6
TextLabel.TextSize = 10
TextLabel.TextColor3 = v3
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.AutoLocalize = false
TextLabel.Parent = Frame2

local Frame3 = Instance.new("Frame")

Frame3.Name = "Divider"
Frame3.BorderSizePixel = 0
Frame3.BackgroundColor3 = v3
Frame3.Parent = Frame2

local UIGradient = Instance.new("UIGradient")

UIGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.8, 0),
    NumberSequenceKeypoint.new(1, 1)
})
UIGradient.Parent = Frame3

local new = Color3.fromRGB(205, 208, 214)
local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Name = "Hint"
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = ""
TextLabel2.FontFace = v7
TextLabel2.TextSize = 7
TextLabel2.TextColor3 = new
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.AutoLocalize = false
TextLabel2.Parent = Frame2
TextLabel2.TextWrapped = true
TextLabel2.TextYAlignment = Enum.TextYAlignment.Top

local Frame4 = Instance.new("Frame")

Frame4.Name = "FOV"
Frame4.BackgroundTransparency = 1
Frame4.AnchorPoint = Vector2.new(1, 0.5)
Frame4.Parent = Frame2

local function fovButton(p42, p43) -- line: 673
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v6 (copy), Frame4 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p42
    TextButton.AutoButtonColor = false
    TextButton:SetAttribute("NoHover", true)
    TextButton.BackgroundColor3 = v3
    TextButton.BorderSizePixel = 0
    TextButton.Text = p43
    TextButton.FontFace = v6
    TextButton.TextColor3 = v2
    TextButton.AutoLocalize = false

    local v257 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v257
    UICorner.Parent = TextButton
    TextButton.Parent = Frame4
    TextButton.MouseEnter:Connect(function() -- line: 676
        -- upvalues: TextButton (copy), v1 (copy), v3 (copy)
        TextButton.BackgroundColor3 = v1
        TextButton.TextColor3 = v3
    end)
    TextButton.MouseLeave:Connect(function() -- line: 676
        -- upvalues: TextButton (copy), v2 (copy), v3 (copy)
        TextButton.BackgroundColor3 = v3
        TextButton.TextColor3 = v2
    end)

    return TextButton
end

local v258 = fovButton("ZoomIn", "−")
local v259 = fovButton("ZoomOut", "+")
local TextLabel3 = Instance.new("TextLabel")

TextLabel3.Name = "Value"
TextLabel3.BackgroundTransparency = 1
TextLabel3.FontFace = v6
TextLabel3.TextColor3 = v3
TextLabel3.AutoLocalize = false
TextLabel3.Text = "FOV 70"
TextLabel3.Parent = Frame4

local n4 = 0
local t21 = {
    [v258] = -1,
    [v259] = 1
}

for v260, v261 in t21 do
    v260.InputBegan:Connect(function(p44) -- line: 684
        -- upvalues: t20 (copy), n4 (ref), v261 (copy)
        if p44.UserInputType ~= Enum.UserInputType.Touch and p44.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        n4 = v261
        t20.fov = math.clamp(t20.fov + v261, 5, 110)
    end)
    v260.InputEnded:Connect(function(p45) -- line: 685
        -- upvalues: n4 (ref), v261 (copy)
        if (p45.UserInputType == Enum.UserInputType.Touch or p45.UserInputType == Enum.UserInputType.MouseButton1) and n4 == v261 then
            n4 = 0
        end
    end)
end

local TextButton2 = Instance.new("TextButton")

TextButton2.Name = "Exit"
TextButton2.AutoButtonColor = false
TextButton2.AnchorPoint = Vector2.new(1, 0.5)
TextButton2.BackgroundColor3 = v3
TextButton2.BorderSizePixel = 0
TextButton2.Text = "EXIT"
TextButton2.FontFace = v6
TextButton2.TextColor3 = v2
TextButton2:SetAttribute("NoHover", true)

local v263 = UDim.new(1, 0)
local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = v263
UICorner3.Parent = TextButton2
TextButton2.Parent = Frame2

local TextButton3 = Instance.new("TextButton")

TextButton3.Name = "Freeze"
TextButton3.AutoButtonColor = false
TextButton3.AnchorPoint = Vector2.new(1, 0.5)
TextButton3.BackgroundColor3 = v3
TextButton3.BorderSizePixel = 0
TextButton3.Text = "FREEZE"
TextButton3.FontFace = v6
TextButton3.TextColor3 = v2
TextButton3.AutoLocalize = false
TextButton3:SetAttribute("NoHover", true)
UICorner3 = UDim.new(1, 0)

local UICorner4 = Instance.new("UICorner")

UICorner4.CornerRadius = UICorner3
UICorner4.Parent = TextButton3
TextButton3.Parent = Frame2

local TextButton4 = Instance.new("TextButton")

TextButton4.Name = "Cinematic"
TextButton4.AutoButtonColor = false
TextButton4.AnchorPoint = Vector2.new(1, 0.5)
TextButton4.BackgroundColor3 = v3
TextButton4.BorderSizePixel = 0
TextButton4.Text = "CINEMA"
TextButton4.FontFace = v6
TextButton4.TextColor3 = v2
TextButton4.AutoLocalize = false
TextButton4:SetAttribute("NoHover", true)
UICorner4 = UDim.new(1, 0)

local UICorner5 = Instance.new("UICorner")

UICorner5.CornerRadius = UICorner4
UICorner5.Parent = TextButton4
TextButton4.Parent = Frame2

local function riseButton(p46, p47) -- line: 700
    -- upvalues: v2 (copy), v3 (copy), v6 (copy), ScreenGui2 (copy)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p46
    TextButton.AutoButtonColor = false
    TextButton.BackgroundColor3 = v2
    TextButton.BackgroundTransparency = 0.2
    TextButton.BorderSizePixel = 0
    TextButton.Text = p47
    TextButton.FontFace = v6
    TextButton.TextColor3 = v3
    TextButton.AnchorPoint = Vector2.new(1, 0.5)

    local v264 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v264
    UICorner.Parent = TextButton
    TextButton.Parent = ScreenGui2

    return TextButton
end

local v265 = riseButton("Up", "▲")
local v266 = riseButton("Down", "▼")
local t22 = {
    up = false,
    down = false
}

for v267, v268 in {
        up = v265,
        down = v266
    } do
    v268.InputBegan:Connect(function(p48) -- line: 707
        -- upvalues: t22 (copy), v267 (copy)
        if p48.UserInputType == Enum.UserInputType.Touch or p48.UserInputType == Enum.UserInputType.MouseButton1 then
            t22[v267] = true
        end
    end)
    v268.InputEnded:Connect(function(p49) -- line: 708
        -- upvalues: t22 (copy), v267 (copy)
        if p49.UserInputType == Enum.UserInputType.Touch or p49.UserInputType == Enum.UserInputType.MouseButton1 then
            t22[v267] = false
        end
    end)
end

local function hintText() -- line: 710
    -- upvalues: UserInputService (copy)
    if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
        return "L-STICK  MOVE   ·   R-STICK  LOOK   ·   R2 / L2  UP / DOWN   ·   D-PAD  FOV   ·   L3  FAST   ·   X  CINEMATIC   ·   Y  FREEZE   ·   B  EXIT"
    end

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        return "STICK  MOVE   ·   DRAG  LOOK   ·   ▲ ▼  UP / DOWN   ·   CINEMA  SMOOTH   ·   FREEZE  PHOTO"
    end

    return "WASD  MOVE   ·   E / Q  UP / DOWN   ·   HOLD RIGHT MOUSE  LOOK   ·   SHIFT  FAST   ·   WHEEL  SPEED   ·   Z / X  FOV   ·   V  CINEMATIC   ·   P  FREEZE   ·   H  HIDE   ·   F / SHIFT+C  EXIT"
end

local function layoutFreecam() -- line: 718
    -- upvalues: UserInputService (copy), GuiService (copy), Frame2 (copy), UICorner2 (copy), TextLabel (copy), Frame3 (copy), TextLabel2 (copy), Frame4 (copy), v258 (copy), v259 (copy), TextLabel3 (copy), TextButton2 (copy), TextButton3 (copy), TextButton4 (copy), v265 (copy), v266 (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local v271 = math.min(ViewportSize.Y / 360, (ViewportSize.X - 24) / 502)
    local Height = GuiService.TopbarInset.Height

    Frame2.Position = UDim2.new(0.5, 0, 0, Height + math.floor(v271 * 6))
    Frame2.Size = UDim2.fromOffset(math.floor(v271 * 492), (math.floor(v271 * 48)))
    Frame4.Position = UDim2.new(1, -math.floor(v271 * 196), 0.5, 0)
    Frame4.Size = UDim2.fromOffset(math.floor(v271 * 76), (math.floor(v271 * 16)))
    TextButton4.Position = UDim2.new(1, -math.floor(v271 * 134), 0.5, 0)
    TextButton4.Size = UDim2.fromOffset(math.floor(v271 * 58), (math.floor(v271 * 16)))
    TextButton4.TextSize = math.floor(v271 * 8)
    TextButton3.Position = UDim2.new(1, -math.floor(v271 * 72), 0.5, 0)
    TextButton3.Size = UDim2.fromOffset(math.floor(v271 * 56), (math.floor(v271 * 16)))
    TextButton3.TextSize = math.floor(v271 * 8)

    for v290, v291 in { v258, v259 } do
        v291.AnchorPoint = Vector2.new(0, 0.5)
        v291.Size = UDim2.fromOffset(math.floor(v271 * 16), (math.floor(v271 * 16)))
        v291.TextSize = math.floor(v271 * 10)
        v291.Position = UDim2.new(if v290 == 1 then 0 else 1, if v290 == 1 then 0 else -math.floor(v271 * 16), 0.5, 0)
    end

    TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel3.Position = UDim2.fromScale(0.5, 0.5)
    TextLabel3.Size = UDim2.fromOffset(math.floor(v271 * 42), (math.floor(v271 * 16)))
    TextLabel3.TextSize = math.floor(v271 * 7)
    UICorner2.CornerRadius = UDim.new(0, (math.floor(v271 * 4)))
    TextLabel.Position = UDim2.fromOffset(math.floor(v271 * 13), (math.floor(v271 * 6)))
    TextLabel.Size = UDim2.fromOffset(math.floor(v271 * 150), (math.floor(v271 * 12)))
    TextLabel.TextSize = math.floor(v271 * 10)
    Frame3.Position = UDim2.fromOffset(math.floor(v271 * 12), (math.floor(v271 * 21)))
    Frame3.Size = UDim2.fromOffset(math.floor(v271 * 80), (math.max(1, (math.floor(v271 + 0.5)))))
    TextLabel2.Position = UDim2.fromOffset(math.floor(v271 * 13), (math.floor(v271 * 24)))
    TextLabel2.Size = UDim2.fromOffset(math.floor(v271 * 205), (math.floor(v271 * 20)))
    TextLabel2.TextSize = math.floor(v271 * 6)
    TextButton2.Position = UDim2.new(1, -math.floor(v271 * 10), 0.5, 0)
    TextButton2.Size = UDim2.fromOffset(math.floor(v271 * 56), (math.floor(v271 * 16)))
    TextButton2.TextSize = math.floor(v271 * 9)

    local v330 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

    for v331, v332 in { v265, v266 } do
        v332.Visible = v330
        v332.Size = UDim2.fromOffset(math.floor(v271 * 34), (math.floor(v271 * 34)))
        v332.TextSize = math.floor(v271 * 13)
        v332.Position = UDim2.new(1, -math.floor(v271 * 16), 0.5, (if v331 == 1 then -1 else 1) * math.floor(v271 * 22))
    end
end

local function setOtherGuis(p50) -- line: 743
    -- upvalues: PlayerGui (copy), ScreenGui (copy), t20 (copy), ScreenGui2 (copy)
    if p50 then
        for v341 in t20.hidden do
            if v341.Parent then
                v341.Enabled = true
            end
        end

        t20.hidden = {}
    else
        t20.hidden = {}

        for _, child in PlayerGui:GetChildren() do
            if child:IsA("LayerCollector") and child.Enabled and child ~= ScreenGui2 and child ~= ScreenGui and child.Name ~= "TouchGui" then
                t20.hidden[child] = true
                child.Enabled = false
            end
        end
    end
end

local t23 = {
    on = false,
    folder = nil,
    added = nil,
    hidden = {},
    emitters = {},
    solid = {},
    off = {},
    lights = {}
}
local t24 = {}

local function fcStyle(p51) -- line: 766
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), t20 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy)
    local v342, v343

    if t24[p51] == true then
        v342 = true
        v343 = true
    elseif p51 == TextButton4 then
        local cine = t20.cine

        if cine then
            v342 = cine
            v343 = true
        else
            v343 = false
        end
    else
        v343 = false
    end

    if not v343 then
        v342 = p51 == TextButton3 and t23.on
    end

    p51.BackgroundColor3 = v342 and v1 or v3
    p51.TextColor3 = v342 and v3 or v2
end

local t25 = {
    TextButton4,
    TextButton3,
    TextButton2
}

local function fcClearHover() -- line: 771
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), t20 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy), t25 (copy)
    table.clear(t24)

    for _, v344 in t25 do
        local cine

        if t24[v344] == true then
            cine = true
        elseif v344 == TextButton4 then
            cine = t20.cine

            if not cine then
                cine = v344 == TextButton3 and t23.on
            end
        else
            cine = v344 == TextButton3 and t23.on
        end

        v344.BackgroundColor3 = cine and v1 or v3
        v344.TextColor3 = cine and v3 or v2
    end
end

for _, v345 in t25 do
    v345.MouseEnter:Connect(function() -- line: 774
        -- upvalues: v1 (copy), v2 (copy), v3 (copy), t20 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy), v345 (copy)
        t24[v345] = true

        local v346, v347

        if t24[v345] == true then
            v346 = true
            v347 = true
        elseif v345 == TextButton4 then
            local cine = t20.cine

            if cine then
                v346 = cine
                v347 = true
            else
                v347 = false
            end
        else
            v347 = false
        end

        if not v347 then
            v346 = v345 == TextButton3 and t23.on
        end

        if v346 then
            v345.BackgroundColor3 = v1 or v3
            v345.TextColor3 = v3 or v2
        else
            v345.BackgroundColor3 = v3
            v345.TextColor3 = v2
        end
    end)
    v345.MouseLeave:Connect(function() -- line: 774
        -- upvalues: v1 (copy), v2 (copy), v3 (copy), t20 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy), v345 (copy)
        t24[v345] = nil

        local v348, v349

        if t24[v345] == true then
            v348 = true
            v349 = true
        elseif v345 == TextButton4 then
            local cine = t20.cine

            if cine then
                v348 = cine
                v349 = true
            else
                v349 = false
            end
        else
            v349 = false
        end

        if not v349 then
            v348 = v345 == TextButton3 and t23.on
        end

        if v348 then
            v345.BackgroundColor3 = v1 or v3
            v345.TextColor3 = v3 or v2
        else
            v345.BackgroundColor3 = v3
            v345.TextColor3 = v2
        end
    end)
    v345.SelectionGained:Connect(function() -- line: 775
        -- upvalues: v1 (copy), v2 (copy), v3 (copy), t20 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy), v345 (copy)
        t24[v345] = true

        local v350, v351

        if t24[v345] == true then
            v350 = true
            v351 = true
        elseif v345 == TextButton4 then
            local cine = t20.cine

            if cine then
                v350 = cine
                v351 = true
            else
                v351 = false
            end
        else
            v351 = false
        end

        if not v351 then
            v350 = v345 == TextButton3 and t23.on
        end

        if v350 then
            v345.BackgroundColor3 = v1 or v3
            v345.TextColor3 = v3 or v2
        else
            v345.BackgroundColor3 = v3
            v345.TextColor3 = v2
        end
    end)
    v345.SelectionLost:Connect(function() -- line: 775
        -- upvalues: v1 (copy), v2 (copy), v3 (copy), t20 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy), v345 (copy)
        t24[v345] = nil

        local v352, v353

        if t24[v345] == true then
            v352 = true
            v353 = true
        elseif v345 == TextButton4 then
            local cine = t20.cine

            if cine then
                v352 = cine
                v353 = true
            else
                v353 = false
            end
        else
            v353 = false
        end

        if not v353 then
            v352 = v345 == TextButton3 and t23.on
        end

        if v352 then
            v345.BackgroundColor3 = v1 or v3
            v345.TextColor3 = v3 or v2
        else
            v345.BackgroundColor3 = v3
            v345.TextColor3 = v2
        end
    end)
    v345.InputEnded:Connect(function(p52) -- line: 777
        -- upvalues: v1 (copy), v2 (copy), v3 (copy), t20 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy), v345 (copy)
        if p52.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        t24[v345] = nil

        local cine

        if t24[v345] == true then
            cine = true
        elseif v345 == TextButton4 then
            cine = t20.cine

            if not cine then
                cine = v345 == TextButton3 and t23.on
            end
        else
            cine = v345 == TextButton3 and t23.on
        end

        if cine then
            v345.BackgroundColor3 = v1 or v3
            v345.TextColor3 = v3 or v2
        else
            v345.BackgroundColor3 = v3
            v345.TextColor3 = v2
        end
    end)
    v345:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 778
        -- upvalues: v1 (copy), v2 (copy), v3 (copy), t20 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy), v345 (copy)
        if v345.Visible then
            return
        end

        t24[v345] = nil

        local cine

        if t24[v345] == true then
            cine = true
        elseif v345 == TextButton4 then
            cine = t20.cine

            if not cine then
                cine = v345 == TextButton3 and t23.on
            end
        else
            cine = v345 == TextButton3 and t23.on
        end

        if cine then
            v345.BackgroundColor3 = v1 or v3
            v345.TextColor3 = v3 or v2
        else
            v345.BackgroundColor3 = v3
            v345.TextColor3 = v2
        end
    end)
end

local t26 = {
    JointInstance = true,
    Constraint = true,
    WeldConstraint = true,
    NoCollisionConstraint = true,
    BaseScript = true,
    ModuleScript = true,
    Sound = true,
    ProximityPrompt = true,
    ClickDetector = true,
    BillboardGui = true,
    Trail = true,
    Animator = true,
    BodyMover = true,
    Highlight = true,
    ForceField = true
}

function t23.strippable(p53) -- line: 782
    -- upvalues: t26 (copy)
    for v354 in t26 do
        if p53:IsA(v354) then
            return true
        end
    end

    return false
end

local function moverModel(p54) -- line: 783
    while true do
        if not p54 or p54 == workspace then
            return false
        end

        if not (p54:FindFirstChildOfClass("Humanoid") or p54:FindFirstChildOfClass("AnimationController") or p54.Parent and (p54.Parent.Name == "RaceBikes" or p54.Parent.Name == "CrashedBikes")) then
            p54 = p54.Parent and p54.Parent:FindFirstAncestorOfClass("Model")
            continue
        end

        local v356 = p54.Parent and p54.Parent:FindFirstAncestorOfClass("Model")

        if not v356 or not v356:FindFirstChildOfClass("Humanoid") and (not v356.Parent or v356.Parent.Name ~= "RaceBikes" and v356.Parent.Name ~= "CrashedBikes") then
            break
        end

        p54 = v356
    end

    return p54
end

function t23.mover(p55, p56) -- line: 792
    -- upvalues: moverModel (copy)
    local Model = p55:FindFirstAncestorOfClass("Model")

    if Model then
        local v357 = p56[Model]

        if v357 == nil then
            v357 = moverModel(Model)
            p56[Model] = v357
        end

        if v357 then
            return v357
        end
    end

    return if not (p55.Anchored or p55.AssemblyRootPart and p55.AssemblyRootPart.Anchored) then p55 else nil
end

function t23.copy(p57) -- line: 801
    -- upvalues: t23 (copy)
    local t27 = {
        p57
    }

    for _, descendant in p57:GetDescendants() do
        table.insert(t27, descendant)
    end

    local function seatish(p58) -- line: 806
        return p58:IsA("Seat") or p58:IsA("VehicleSeat") or p58:IsA("Weld") and p58.Name == "SeatWeld"
    end

    local t28 = {}

    for v358, v359 in t27 do
        t28[v358] = v359.Archivable
        v359.Archivable = not seatish(v359)
    end

    local Clone = p57.Clone
    local ok, result = pcall(Clone, p57)

    for v360, v361 in t27 do
        if v361.Parent or v361 == p57 then
            v361.Archivable = t28[v360]
        end
    end

    if not ok or not result then
        return
    end

    local function walk(p59, p60) -- line: 812
        -- upvalues: walk (copy)
        if p59:IsA("BasePart") and p60:IsA("BasePart") then
            p60.Anchored = true
            p60.CanCollide = false
            p60.CanQuery = false
            p60.CanTouch = false
            p60.CFrame = p59.CFrame
            p60.LocalTransparencyModifier = p59.LocalTransparencyModifier
        end

        local Children = p59:GetChildren()
        local n5 = 1

        for _, child in (p60:GetChildren()) do
            while true do
                if Children[n5] then
                    local v362 = Children[n5]

                    if v362:IsA("Seat") or v362:IsA("VehicleSeat") or v362:IsA("Weld") and v362.Name == "SeatWeld" or Children[n5].ClassName ~= child.ClassName or Children[n5].Name ~= child.Name then
                        n5 += 1
                        continue
                    end
                end

                if Children[n5] then
                    walk(Children[n5], child)
                    n5 += 1
                end

                break
            end
        end
    end

    walk(p57, result)

    for _, descendant in result:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanTouch = false
            descendant.CanCollide = false
            descendant.CanQuery = false
        end
    end

    for _, descendant in result:GetDescendants() do
        if t23.strippable(descendant) then
            descendant:Destroy()
        elseif descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false
        elseif descendant:IsA("Humanoid") then
            descendant.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            descendant.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            descendant.EvaluateStateMachine = false
        end
    end

    result.Parent = t23.folder

    local v363 = result:FindFirstChildOfClass("Humanoid") ~= nil

    for _, descendant in result:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false

            if v363 then
                table.insert(t23.solid, descendant)
            end
        end
    end
end

function t23.freeze() -- line: 843
    -- upvalues: JerezRaceHUD (copy), v1 (copy), v2 (copy), v3 (copy), t20 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy)
    if t23.on then
        return
    end

    t23.on = true
    t23.hidden = {}
    t23.emitters = {}
    t23.solid = {}
    t23.off = {}
    t23.lights = {}

    local Folder = Instance.new("Folder")

    Folder.Name = "FreecamPhotoFreeze"
    Folder.Parent = workspace
    t23.folder = Folder

    local t29 = {}
    local t30 = {}
    local t31 = {}
    local t32 = {
        RaceCollision = true,
        Landmarks = true,
        Paint = true,
        Fencing = true,
        Vegetation = true,
        Grandstands = true,
        TrackLimits = true
    }

    local function visit(p61) -- line: 851
        -- upvalues: t29 (copy), t30 (copy), t31 (copy), t32 (copy), visit (copy), t23 (copy)
        for _, child in p61:GetChildren() do
            if not child:IsA("Folder") or not t32[child.Name] or not child.Parent or child.Parent.Parent ~= workspace then
                if child:IsA("BasePart") then
                    if child.Transparency < 1 then
                        local v365 = t23.mover(child, t30)

                        if v365 then
                            t29[v365] = true
                        end
                    end
                elseif child:IsA("ParticleEmitter") then
                    t23.emitters[child] = child.TimeScale
                    child.TimeScale = 0
                elseif child:IsA("Light") then
                    table.insert(t31, child)
                elseif child:IsA("Trail") then
                    table.insert(t31, child)
                elseif child:IsA("Beam") then
                    table.insert(t31, child)
                end

                visit(child)
            end
        end
    end

    visit(workspace)

    for v366 in t29 do
        t23.copy(v366)

        local v367 = v366:IsA("BasePart") and {
            v366
        } or v366:GetDescendants()

        if v366:IsA("Model") then
            table.insert(v367, v366)
        end

        for _, v368 in v367 do
            if v368:IsA("BasePart") and t23.hidden[v368] == nil then
                t23.hidden[v368] = v368.LocalTransparencyModifier
                v368.LocalTransparencyModifier = 1
            end
        end
    end

    for _, v369 in t31 do
        local BasePart = v369:FindFirstAncestorWhichIsA("BasePart")

        if not BasePart or t23.hidden[BasePart] == nil then
            if v369:IsA("Light") then
                t23.lights[v369] = {
                    v369.Enabled,
                    v369.Brightness
                }
            end
        else
            t23.off[v369] = v369.Enabled
            v369.Enabled = false
        end
    end

    t23.added = workspace.DescendantAdded:Connect(function(p62) -- line: 876
        -- upvalues: t23 (copy)
        if not (not t23.on or t23.folder and p62:IsDescendantOf(t23.folder)) then
            if p62:IsA("ParticleEmitter") then
                if t23.emitters[p62] == nil then
                    t23.emitters[p62] = p62.TimeScale
                end

                p62.TimeScale = 0
            elseif not (p62:IsA("Light")
                or p62:IsA("Trail")
                or p62:IsA("Beam")
                or p62:IsA("Fire")
                or p62:IsA("Smoke")
                or p62:IsA("Sparkles")) then
                if p62:IsA("BasePart") and p62.Transparency < 1 then
                    if t23.hidden[p62] == nil then
                        t23.hidden[p62] = p62.LocalTransparencyModifier
                    end

                    p62.LocalTransparencyModifier = 1
                end
            else
                if t23.off[p62] == nil then
                    t23.off[p62] = p62.Enabled
                end

                p62.Enabled = false
            end
        end
    end)

    local v370, v371

    if t24[TextButton3] == true then
        v370 = true
        v371 = true
    elseif TextButton3 == TextButton4 then
        local cine = t20.cine

        if cine then
            v370 = cine
            v371 = true
        else
            v371 = false
        end
    else
        v371 = false
    end

    if not v371 then
        v370 = TextButton3 == TextButton3 and t23.on
    end

    TextButton3.BackgroundColor3 = v370 and v1 or v3
    TextButton3.TextColor3 = v370 and v3 or v2
    TextButton3.Text = "FROZEN"
    JerezRaceHUD:SetAttribute("FreecamFrozen", true)
end

function t23.unfreeze() -- line: 889
    -- upvalues: JerezRaceHUD (copy), v1 (copy), v2 (copy), v3 (copy), t20 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy)
    if t23.on then
        t23.on = false

        if t23.added then
            t23.added:Disconnect()
            t23.added = nil
        end

        if t23.folder then
            t23.folder:Destroy()
            t23.folder = nil
        end

        for v374, v375 in t23.hidden do
            if v374.Parent then
                v374.LocalTransparencyModifier = v375
            end
        end

        for v376, v377 in t23.emitters do
            if v376.Parent then
                v376.TimeScale = v377
            end
        end

        for v378, v379 in t23.off do
            if v378.Parent then
                v378.Enabled = v379
            end
        end

        t23.hidden = {}
        t23.emitters = {}
        t23.solid = {}
        t23.off = {}
        t23.lights = {}

        local v380, v381

        if t24[TextButton3] == true then
            v380 = true
            v381 = true
        elseif TextButton3 == TextButton4 then
            local cine = t20.cine

            if cine then
                v380 = cine
                v381 = true
            else
                v381 = false
            end
        else
            v381 = false
        end

        if not v381 then
            v380 = TextButton3 == TextButton3 and t23.on
        end

        TextButton3.BackgroundColor3 = v380 and v1 or v3
        TextButton3.TextColor3 = v380 and v3 or v2
        TextButton3.Text = "FREEZE"
        JerezRaceHUD:SetAttribute("FreecamFrozen", false)
    end
end

function t23.toggle() -- line: 901
    -- upvalues: t23 (copy)
    if t23.on then
        t23.unfreeze()
    else
        t23.freeze()
    end
end

function t23.keepHidden() -- line: 902
    -- upvalues: t23 (copy)
    for v384 in t23.hidden do
        if v384.LocalTransparencyModifier ~= 1 then
            v384.LocalTransparencyModifier = 1
        end
    end

    for _, v385 in t23.solid do
        if v385.CanCollide then
            v385.CanCollide = false
        end
    end

    for v386 in t23.emitters do
        if v386.TimeScale ~= 0 then
            v386.TimeScale = 0
        end
    end

    for v387 in t23.off do
        if v387.Enabled then
            v387.Enabled = false
        end
    end

    for v388, v389 in t23.lights do
        if v388.Enabled ~= v389[1] then
            v388.Enabled = v389[1]
        end

        if v388.Brightness ~= v389[2] then
            v388.Brightness = v389[2]
        end
    end
end

local function stopFreecam() -- line: 913
    -- upvalues: RunService (copy), UserInputService (copy), LocalPlayer (copy), JerezRaceHUD (copy), v1 (copy), v2 (copy), v3 (copy), t20 (copy), ScreenGui2 (copy), n4 (ref), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy), t25 (copy)
    if t20.on then
        t20.on = false
        n4 = 0
        t20.any = false
        t23.unfreeze()
        t20.cine = false
        table.clear(t24)

        for _, v390 in t25 do
            local cine

            if t24[v390] == true then
                cine = true
            elseif v390 == TextButton4 then
                cine = t20.cine

                if not cine then
                    cine = v390 == TextButton3 and t23.on
                end
            else
                cine = v390 == TextButton3 and t23.on
            end

            v390.BackgroundColor3 = cine and v1 or v3
            v390.TextColor3 = cine and v3 or v2
        end

        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local seat = t20.seat

        t20.seat = nil

        if Humanoid and seat and seat.Parent and not seat.Disabled and Humanoid.SeatPart ~= seat and Humanoid.Health > 0 then
            local Sit = seat.Sit

            pcall(Sit, seat, Humanoid)
        end

        RunService:UnbindFromRenderStep("MotoLegendsFreecam")
        workspace.CurrentCamera.FieldOfView = 70

        for v391 in t20.hidden do
            if v391.Parent then
                v391.Enabled = true
            end
        end

        t20.hidden = {}
        ScreenGui2.Enabled = false

        if t20.ppWas ~= nil then
            game:GetService("ProximityPromptService").Enabled = t20.ppWas
            t20.ppWas = nil
        end

        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true

        local Character2 = LocalPlayer.Character
        local Humanoid2 = Character2 and Character2:FindFirstChildOfClass("Humanoid")

        if Humanoid2 and t20.hum.h == Humanoid2 then
            if Humanoid2.WalkSpeed == 0 then
                Humanoid2.WalkSpeed = t20.hum.walk
            end

            if Humanoid2.JumpPower == 0 then
                Humanoid2.JumpPower = t20.hum.jumpPower
            end

            if Humanoid2.JumpHeight == 0 then
                Humanoid2.JumpHeight = t20.hum.jumpHeight
            end

            if Humanoid2.AutoRotate == false then
                Humanoid2.AutoRotate = t20.hum.rotate
            end

            if not (Humanoid2.AutoRotate or Humanoid2.SeatPart or Humanoid2.PlatformStand) then
                local Character = LocalPlayer.Character

                if (Character == nil or Character:GetAttribute("RaceCrashActive") ~= true) and t20.hum.rotate == false and not t20.hum.lockedBefore then
                    Humanoid2.AutoRotate = true
                end
            end
        end

        t20.hum = {}

        local CurrentCamera = workspace.CurrentCamera

        CurrentCamera.CameraType = Enum.CameraType.Custom

        if Humanoid2 then
            CurrentCamera.CameraSubject = Humanoid2
        end

        JerezRaceHUD:SetAttribute("Freecam", false)
    end
end

local function moveVector(p63) -- line: 946
    -- upvalues: UserInputService (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local MoveDirection = Humanoid and Humanoid.MoveDirection or Vector3.new(0, 0, 0)
    local v392 = CFrame.fromOrientation(0, p63, 0)
    local v393 = MoveDirection:Dot(v392.RightVector)
    local v394 = MoveDirection:Dot(v392.LookVector)
    local v395, v396

    if math.abs(v393) + math.abs(v394) < 0.01 then
        v395 = (if UserInputService:IsKeyDown(Enum.KeyCode.D) then 1 else 0) - (if UserInputService:IsKeyDown(Enum.KeyCode.A) then 1 else 0)
        v396 = (if UserInputService:IsKeyDown(Enum.KeyCode.W) then 1 else 0) - (if UserInputService:IsKeyDown(Enum.KeyCode.S) then 1 else 0)
    else
        v396 = v394
        v395 = v393
    end

    return v395, v396
end

local v397

local function startFreecam(p64) -- line: 963
    -- upvalues: RunService (copy), UserInputService (copy), LocalPlayer (copy), JerezRaceHUD (copy), v1 (copy), v2 (copy), v3 (copy), v20 (ref), t20 (copy), ScreenGui2 (copy), Frame2 (copy), TextLabel2 (copy), TextLabel3 (copy), n4 (ref), TextButton3 (copy), TextButton4 (copy), t22 (copy), layoutFreecam (copy), setOtherGuis (copy), t23 (copy), t24 (copy), t25 (copy), stopFreecam (copy), moveVector (copy)
    if t20.on or JerezRaceHUD:GetAttribute("BikesPreviewOpen") == true or JerezRaceHUD:GetAttribute("LegendsOpen") == true or JerezRaceHUD:GetAttribute("ShopOpen") == true or JerezRaceHUD:GetAttribute("ProfileOpen") == true then
        return
    end

    if not p64 then
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local v398 = Humanoid and Humanoid.SeatPart
        local v399

        if v398 ~= nil and v398.Name == "RiderSeat" then
            v399 = false
        else
            local Character = LocalPlayer.Character

            v399 = not (Character ~= nil and Character:GetAttribute("RaceCrashActive") == true)
        end

        if not v399 then
            return
        end
    end

    t20.any = p64 == true

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    t20.seat = Humanoid and Humanoid.SeatPart or nil
    v20()

    local CurrentCamera = workspace.CurrentCamera
    local _CFrame = CurrentCamera.CFrame

    t20.startedAt = os.clock()
    t20.pos = _CFrame.Position
    t20.vel = Vector3.new(0, 0, 0)

    local v400, v401 = _CFrame:ToOrientation()

    t20.pitch = v400
    t20.yaw = v401

    local Character2 = LocalPlayer.Character
    local Humanoid2 = Character2 and Character2:FindFirstChildOfClass("Humanoid")

    if Humanoid2 then
        local t33 = {
            h = Humanoid2,
            walk = Humanoid2.WalkSpeed,
            jumpPower = Humanoid2.JumpPower,
            jumpHeight = Humanoid2.JumpHeight,
            rotate = Humanoid2.AutoRotate
        }
        local v402

        if Humanoid2.AutoRotate == false then
            v402 = not Humanoid2.SeatPart

            if v402 then
                v402 = not Humanoid2.PlatformStand

                if v402 then
                    local Character = LocalPlayer.Character

                    v402 = not (Character ~= nil and Character:GetAttribute("RaceCrashActive") == true)
                end
            end
        else
            v402 = false
        end

        t33.lockedBefore = v402
        t20.hum = t33
        Humanoid2.WalkSpeed = 0
        Humanoid2.JumpPower = 0
        Humanoid2.JumpHeight = 0
        Humanoid2.AutoRotate = false
    end

    t20.on = true
    t20.hintHidden = false
    Frame2.Visible = true
    t20.fov = 70
    n4 = 0
    t20.cine = false
    table.clear(t24)

    for _, v403 in t25 do
        local cine

        if t24[v403] == true then
            cine = true
        elseif v403 == TextButton4 then
            cine = t20.cine

            if not cine then
                cine = v403 == TextButton3 and t23.on
            end
        else
            cine = v403 == TextButton3 and t23.on
        end

        v403.BackgroundColor3 = cine and v1 or v3
        v403.TextColor3 = cine and v3 or v2
    end

    JerezRaceHUD:SetAttribute("Freecam", true)
    TextLabel2.Text = if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then "L-STICK  MOVE   ·   R-STICK  LOOK   ·   R2 / L2  UP / DOWN   ·   D-PAD  FOV   ·   L3  FAST   ·   X  CINEMATIC   ·   Y  FREEZE   ·   B  EXIT" elseif UserInputService.PreferredInput == Enum.PreferredInput.Touch then "STICK  MOVE   ·   DRAG  LOOK   ·   ▲ ▼  UP / DOWN   ·   CINEMA  SMOOTH   ·   FREEZE  PHOTO" else "WASD  MOVE   ·   E / Q  UP / DOWN   ·   HOLD RIGHT MOUSE  LOOK   ·   SHIFT  FAST   ·   WHEEL  SPEED   ·   Z / X  FOV   ·   V  CINEMATIC   ·   P  FREEZE   ·   H  HIDE   ·   F / SHIFT+C  EXIT"
    layoutFreecam()
    ScreenGui2.Enabled = true
    setOtherGuis(false)

    local ProximityPromptService = game:GetService("ProximityPromptService")

    if t20.ppWas == nil then
        t20.ppWas = ProximityPromptService.Enabled or JerezRaceHUD:GetAttribute("SpectatePromptsBlocked") == true
    end

    ProximityPromptService.Enabled = false
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    RunService:BindToRenderStep("MotoLegendsFreecam", Enum.RenderPriority.Camera.Value + 5, function(p65) -- line: 991
        -- upvalues: UserInputService (copy), LocalPlayer (copy), JerezRaceHUD (copy), t20 (copy), TextLabel3 (copy), n4 (ref), t22 (copy), t23 (copy), stopFreecam (copy), moveVector (copy)
        local v406 = p65
        local v407 = math.min(p65, 0.1)

        v406 = v407

        local v408 = false
        local v409 = false
        local v410 = false
        local v411 = false
        local v412 = false

        if t20.any then
        else
            v408 = true
        end

        local Character, v413

        if v408 then
            Character = LocalPlayer.Character

            if Character then
                v409 = true
            else
                v413 = Character
                v410 = true
            end
        end

        v408 = false

        if v409 then
            v413 = Character:FindFirstChildOfClass("Humanoid")
            v410 = true
        end

        v409 = false

        local v414

        if v410 then
            if v413 then
                v409 = true
            else
                v414 = v413
                v408 = true
            end
        end

        v410 = false

        if v409 then
            v414 = v413.SeatPart
            v408 = true
        end

        v409 = false

        local v415

        if v408 then
            if v414 ~= nil then
                v409 = true
            else
                v415 = false
                v410 = true
            end
        end

        v408 = false

        if v409 then
            if v414.Name == "RiderSeat" then
                v411 = true
            else
                v408 = true
            end
        end

        v409 = false

        if v408 then
            v415 = false
            v410 = true
        end

        v408 = false

        if v411 then
            v415 = true
            v410 = true
        end

        v411 = false

        if v410 then
            if v415 then
                v412 = true
            else
                v411 = true
            end
        end

        v410 = false

        local Character2, v416

        if v411 then
            Character2 = LocalPlayer.Character

            if Character2 ~= nil then
                v410 = true
            else
                v416 = false
                v408 = true
            end
        end

        v411 = false

        if v410 then
            if Character2:GetAttribute("RaceCrashActive") == true then
                v409 = true
            else
                v411 = true
            end
        end

        if v411 then
            v416 = false
            v408 = true
        end

        v411 = false

        if v409 then
            v416 = true
            v408 = true
        end

        v409 = false

        if v408 then
            if v416 then
                v412 = true
            else
                v409 = true
            end
        end

        v408 = false

        if v409 then
            if JerezRaceHUD:GetAttribute("LobbySpectating") == true then
                v411 = true
            else
                v408 = true
            end
        end

        v409 = false

        local v417

        if v408 then
            v417 = false
            v409 = true
        end

        if v411 then
            v417 = true
            v409 = true
        end

        v411 = false

        if v409 then
            if v417 then
                v411 = true
            else
                v412 = false
            end
        end

        if v411 then
            v412 = os.clock() - (t20.startedAt or 0) > 1
        end

        if not v412 and JerezRaceHUD:GetAttribute("BikesPreviewOpen") ~= true and JerezRaceHUD:GetAttribute("LegendsOpen") ~= true and JerezRaceHUD:GetAttribute("ShopOpen") ~= true and JerezRaceHUD:GetAttribute("ProfileOpen") ~= true then
            local Character = LocalPlayer.Character

            if Character and Character:FindFirstChildOfClass("Humanoid") then
                local Character = LocalPlayer.Character

                if not ((Character and Character:FindFirstChildOfClass("Humanoid")).Health <= 0) then
                    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                        UserInputService.MouseIconEnabled = false

                        local MouseDelta = UserInputService:GetMouseDelta()

                        t20.yaw -= MouseDelta.X * 0.0032
                        t20.pitch -= MouseDelta.Y * 0.0032
                    elseif UserInputService.MouseBehavior == Enum.MouseBehavior.LockCurrentPosition then
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                        UserInputService.MouseIconEnabled = true
                    end

                    local v418 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
                    local n6 = 0
                    local n7 = 0

                    for _, v419 in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
                        if v419.KeyCode == Enum.KeyCode.Thumbstick2 then
                            local Position = v419.Position

                            if Position.Magnitude > 0.15 then
                                t20.yaw -= Position.X * 2.4 * v407
                                t20.pitch += Position.Y * 1.8 * v407
                            end
                        elseif v419.KeyCode == Enum.KeyCode.ButtonR2 then
                            n6 = math.max(n6, v419.Position.Z)
                        elseif v419.KeyCode == Enum.KeyCode.ButtonL2 then
                            n7 = math.max(n7, v419.Position.Z)
                        elseif v419.KeyCode == Enum.KeyCode.ButtonL3 and v419.UserInputState == Enum.UserInputState.Begin then
                            v418 = true
                        end
                    end

                    t20.pitch = math.clamp(t20.pitch, -1.45, 1.45)

                    local v420 = n4
                    local v421

                    if UserInputService:GetFocusedTextBox() then
                        v421 = v420
                    else
                        local v422 = if UserInputService:IsKeyDown(Enum.KeyCode.Z) then v420 - 1 else v420

                        v421 = if UserInputService:IsKeyDown(Enum.KeyCode.X) then v422 + 1 else v422
                    end

                    if UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.DPadUp) then
                        v421 -= 1
                    end

                    if UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.DPadDown) then
                        v421 += 1
                    end

                    if v421 ~= 0 then
                        t20.fov = math.clamp(t20.fov + math.sign(v421) * 45 * v407 * (t20.fov / 70) ^ 0.5, 5, 110)
                    end

                    local v425 = "FOV " .. math.floor(t20.fov + 0.5)

                    if TextLabel3.Text ~= v425 then
                        TextLabel3.Text = v425
                    end

                    local v426 = if UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsKeyDown(Enum.KeyCode.Space) or t22.up then 1 else n6
                    local v427 = if UserInputService:IsKeyDown(Enum.KeyCode.Q) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or t22.down then 1 else n7
                    local v428 = CFrame.fromOrientation(t20.pitch, t20.yaw, 0)
                    local v429, v430 = moveVector(t20.yaw)
                    local v431 = v428.RightVector * v429 + v428.LookVector * v430 + Vector3.new(0, 1, 0) * (v426 - v427)

                    if v431.Magnitude > 1 then
                        v431 = v431.Unit
                    end

                    local v432 = v431 * t20.speed * (if v418 then 3 else 1) * (if t20.cine then 0.5 else 1)

                    t20.vel = t20.vel:Lerp(v432, 1 - math.exp(-v407 * (if t20.cine then 1.4 else 7)))
                    t20.pos += t20.vel * v407

                    local CurrentCamera = workspace.CurrentCamera

                    if CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
                        CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    end

                    if t20.cine then
                        local cs = t20.cs

                        local function ease(p66) -- line: 1036
                            -- upvalues: v406 (ref)
                            return 1 - math.exp(-v406 * p66)
                        end

                        local v436 = 1 - math.exp(-v406 * 2.6)
                        local v438 = 1 - math.exp(-v406 * 3.2)
                        local v440 = 1 - math.exp(-v406 * 2.2)

                        local function toward(p67, p68) -- line: 1039
                            return p67 + math.atan2(math.sin(p68 - p67), (math.cos(p68 - p67)))
                        end

                        local yaw1, yaw1_2 = cs.yaw1, cs.yaw1
                        local yaw = t20.yaw

                        cs.yaw1 = yaw1 + (yaw1_2 + math.atan2(math.sin(yaw - yaw1_2), (math.cos(yaw - yaw1_2))) - cs.yaw1) * v436
                        cs.pitch1 += (t20.pitch - cs.pitch1) * v436

                        local yaw2, yaw3, yaw4, yaw1_3 = cs.yaw, cs.yaw, cs.yaw, cs.yaw1

                        cs.yaw = yaw3 + (yaw4 + math.atan2(math.sin(yaw1_3 - yaw4), (math.cos(yaw1_3 - yaw4))) - cs.yaw) * v436
                        cs.pitch += (cs.pitch1 - cs.pitch) * v436
                        cs.pos1 = cs.pos1:Lerp(t20.pos, v438)
                        cs.pos = cs.pos:Lerp(cs.pos1, v438)
                        cs.fov1 += (t20.fov - cs.fov1) * v440
                        cs.fov += (cs.fov1 - cs.fov) * v440

                        local v460 = math.clamp(math.atan2(math.sin(cs.yaw - yaw2), (math.cos(cs.yaw - yaw2))) / math.max(v406, 0.001) * 0.06, -0.12217304763960307, 0.12217304763960307)

                        cs.bank = cs.bank + (v460 - cs.bank) * (1 - math.exp(-v406 * 2))
                        CurrentCamera.CFrame = CFrame.new(cs.pos) * CFrame.fromOrientation(cs.pitch, cs.yaw, 0) * CFrame.Angles(0, 0, cs.bank)
                        CurrentCamera.FieldOfView = cs.fov
                    else
                        CurrentCamera.CFrame = CFrame.new(t20.pos) * v428
                        CurrentCamera.FieldOfView = t20.fov
                    end

                    CurrentCamera.Focus = CurrentCamera.CFrame * CFrame.new(0, 0, -10)

                    if t23.on then
                        t23.keepHidden()
                    end

                    return
                end
            end
        end

        stopFreecam()
    end)
end

TextButton2.Activated:Connect(stopFreecam)
TextButton3.Activated:Connect(function() -- line: 1060
    -- upvalues: t20 (copy), t23 (copy)
    if t20.on then
        t23.toggle()
    end
end)

local function toggleCinematic() -- line: 1062
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), t20 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy)
    if t20.on then
        t20.cine = not t20.cine

        if t20.cine then
            local CFrame = workspace.CurrentCamera.CFrame
            local v463, v464 = CFrame:ToOrientation()

            t20.cs = {
                bank = 0,
                yaw1 = v464,
                yaw = v464,
                pitch1 = v463,
                pitch = v463,
                pos1 = CFrame.Position,
                pos = CFrame.Position,
                fov1 = t20.fov,
                fov = t20.fov
            }
            t20.yaw = v464
            t20.pitch = v463
            t20.pos = CFrame.Position
        else
            local cs = t20.cs

            if cs then
                t20.pos = cs.pos
                t20.yaw = cs.yaw
                t20.pitch = cs.pitch
                t20.vel = Vector3.new(0, 0, 0)
            end
        end

        local v465, v466

        if t24[TextButton4] == true then
            v465 = true
            v466 = true
        elseif TextButton4 == TextButton4 then
            local cine = t20.cine

            if cine then
                v465 = cine
                v466 = true
            else
                v466 = false
            end
        else
            v466 = false
        end

        if not v466 then
            v465 = TextButton4 == TextButton3 and t23.on
        end

        TextButton4.BackgroundColor3 = v465 and v1 or v3
        TextButton4.TextColor3 = v465 and v3 or v2
    end
end

TextButton4.Activated:Connect(toggleCinematic)
UserInputService.InputBegan:Connect(function(p69, p70) -- line: 1077
    -- upvalues: SettingsBridge (copy), v1 (copy), v2 (copy), v3 (copy), v19 (ref), v20 (ref), t20 (copy), Frame2 (copy), TextButton3 (copy), TextButton4 (copy), t23 (copy), t24 (copy), t25 (copy), stopFreecam (copy), v397 (ref), toggleCinematic (copy)
    if t20.on then
        if p69.KeyCode == Enum.KeyCode.ButtonB then
            stopFreecam()
        elseif p69.KeyCode == Enum.KeyCode.ButtonY then
            t23.toggle()
        elseif p69.KeyCode == Enum.KeyCode.ButtonX then
            toggleCinematic()
        elseif not p70 then
            if p69.KeyCode == Enum.KeyCode.F then
                stopFreecam()
            elseif p69.KeyCode == Enum.KeyCode.P then
                t23.toggle()
            elseif p69.KeyCode == Enum.KeyCode.V then
                toggleCinematic()
            elseif p69.KeyCode == Enum.KeyCode.H then
                t20.hintHidden = not t20.hintHidden
                Frame2.Visible = not t20.hintHidden

                if t20.hintHidden then
                    table.clear(t24)

                    for _, v469 in t25 do
                        local cine

                        if t24[v469] == true then
                            cine = true
                        elseif v469 == TextButton4 then
                            cine = t20.cine

                            if not cine then
                                cine = v469 == TextButton3 and t23.on
                            end
                        else
                            cine = v469 == TextButton3 and t23.on
                        end

                        v469.BackgroundColor3 = cine and v1 or v3
                        v469.TextColor3 = cine and v3 or v2
                    end
                end
            elseif p69.UserInputType == Enum.UserInputType.Touch then
                local ViewportSize = workspace.CurrentCamera.ViewportSize

                if p69.Position.X > ViewportSize.X * 0.35 then
                    v397 = p69
                end
            end
        end
    elseif not (not v19 or p69.KeyCode ~= Enum.KeyCode.ButtonB or SettingsBridge.ready and SettingsBridge.pending()) then
        v20()
    end
end)
UserInputService.InputChanged:Connect(function(p71) -- line: 1095
    -- upvalues: t20 (copy), v397 (ref)
    if t20.on then
        if p71.UserInputType == Enum.UserInputType.MouseWheel then
            t20.speed = math.clamp(t20.speed * (if p71.Position.Z > 0 then 1.2 else 0.8333333333333334), 4, 300)
        elseif p71 == v397 then
            t20.yaw -= p71.Delta.X * 0.006
            t20.pitch -= p71.Delta.Y * 0.006
        end
    end
end)
UserInputService.InputEnded:Connect(function(p72) -- line: 1103
    -- upvalues: v397 (ref)
    if p72 == v397 then
        v397 = nil
    end
end)
LocalPlayer.CharacterAdded:Connect(function() -- line: 1104
    -- upvalues: t20 (copy), stopFreecam (copy)
    if t20.on then
        stopFreecam()
    end
end)
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 1105
    -- upvalues: t20 (copy), layoutFreecam (copy)
    if t20.on then
        layoutFreecam()
    end
end)

local MarketplaceService = game:GetService("MarketplaceService")
local v471

local function ownsFreecam() -- line: 1113
    -- upvalues: LocalPlayer (copy), MarketplaceService (copy), v471 (ref)
    if LocalPlayer:GetAttribute("FreecamFree") == true then
        return true
    end

    if v471 == nil then
        local UserOwnsGamePassAsync = MarketplaceService.UserOwnsGamePassAsync
        local UserId = LocalPlayer.UserId
        local ok, result = pcall(UserOwnsGamePassAsync, MarketplaceService, UserId, 2064281279)

        if not ok then
            return false
        end

        v471 = result == true
    end

    return v471
end

task.spawn(ownsFreecam)
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p73, p74, p75) -- line: 1123
    -- upvalues: LocalPlayer (copy), startFreecam (copy), v471 (ref)
    if p73 == LocalPlayer and p74 == 2064281279 and p75 then
        v471 = true
        startFreecam()
    end
end)

local v472 = false

local function gearLook() -- line: 1129
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), ImageLabel (copy), ImageLabel2 (copy), Frame (copy), v472 (ref)
    local v473 = v472 or Frame.Visible

    TweenService:Create(ImageLabel, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageColor3 = v473 and v1 or v2,
        BackgroundColor3 = v473 and v1 or v2
    }):Play()
    TweenService:Create(ImageLabel2, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.2571428571428571, v473 and -0.09090909090909091 or 0)
    }):Play()
end

local SoundService = game:GetService("SoundService")

local function uiSound(p76) -- line: 1136
    -- upvalues: SoundService (copy)
    local v476 = SoundService:FindFirstChild(p76)

    if v476 then
        SoundService:PlayLocalSound(v476)
    end
end

TextButton.MouseEnter:Connect(function() -- line: 1137
    -- upvalues: v472 (ref), gearLook (copy), SoundService (copy)
    v472 = true
    gearLook()

    local UIButtonHover = SoundService:FindFirstChild("UIButtonHover")

    if UIButtonHover then
        SoundService:PlayLocalSound(UIButtonHover)
    end
end)
TextButton.Activated:Connect(function() -- line: 1138
    -- upvalues: SoundService (copy)
    local UIButtonClick = SoundService:FindFirstChild("UIButtonClick")

    if UIButtonClick then
        SoundService:PlayLocalSound(UIButtonClick)
    end
end)
TextButton.MouseLeave:Connect(function() -- line: 1139
    -- upvalues: v472 (ref), gearLook (copy)
    v472 = false
    gearLook()
end)
TextButton.SelectionGained:Connect(function() -- line: 1140
    -- upvalues: v472 (ref), gearLook (copy)
    v472 = true
    gearLook()
end)
TextButton.SelectionLost:Connect(function() -- line: 1140
    -- upvalues: v472 (ref), gearLook (copy)
    v472 = false
    gearLook()
end)

local function setDropdown(p77) -- line: 1141
    -- upvalues: Frame (copy), gearLook (copy)
    if Frame.Visible ~= p77 then
        Frame.Visible = p77
        gearLook()
    end
end

TextButton.Activated:Connect(function() -- line: 1142
    -- upvalues: Frame (copy), gearLook (copy)
    local v477 = not Frame.Visible

    if Frame.Visible ~= v477 then
        Frame.Visible = v477
        gearLook()
    end
end)
v14.Activated:Connect(function() -- line: 1143
    -- upvalues: Frame (copy), v19 (ref), v20 (ref), openSettings (copy), v158 (ref), gearLook (copy)
    if Frame.Visible ~= false then
        Frame.Visible = false
        gearLook()
    end

    v158()

    if v19 then
        v20()
    else
        openSettings()
    end
end)
v16.Activated:Connect(function() -- line: 1147
    -- upvalues: Frame (copy), v20 (ref), t9 (copy), v158 (ref), refreshBottles (copy), buildBottles (copy), gearLook (copy)
    if Frame.Visible ~= false then
        Frame.Visible = false
        gearLook()
    end

    if t9.open then
        v158()
    else
        v20()
        buildBottles()
        t9.open = true
        t9.root.Visible = true
        t9.close.Modal = true
        task.defer(refreshBottles)
    end
end)
Glyph.Activated:Connect(function() -- line: 1151
    -- upvalues: LocalPlayer (copy), Frame (copy), startFreecam (copy), MarketplaceService (copy), v471 (ref), gearLook (copy)
    if Frame.Visible ~= false then
        Frame.Visible = false
        gearLook()
    end

    local v478

    if LocalPlayer:GetAttribute("FreecamFree") == true then
        v478 = true
    else
        local v479 = true

        if v471 ~= nil then
            v479 = false
        else
            local UserOwnsGamePassAsync = MarketplaceService.UserOwnsGamePassAsync
            local UserId = LocalPlayer.UserId
            local ok, result = pcall(UserOwnsGamePassAsync, MarketplaceService, UserId, 2064281279)

            if ok then
                v471 = result == true
                v479 = false
            end
        end

        v478 = not v479 and v471
    end

    if v478 then
        startFreecam()
    else
        MarketplaceService:PromptGamePassPurchase(LocalPlayer, 2064281279)
    end
end)
game:GetService("ContextActionService"):BindActionAtPriority("FreecamShortcut", function(_, p79, p80) -- line: 1159
    -- upvalues: UserInputService (copy), LocalPlayer (copy), JerezRaceHUD (copy), Frame (copy), v19 (ref), t9 (copy), t20 (copy), t23 (copy), stopFreecam (copy), startFreecam (copy), v471 (ref), gearLook (copy)
    if p79 ~= Enum.UserInputState.Begin or p80.KeyCode ~= Enum.KeyCode.C then
        return Enum.ContextActionResult.Pass
    end

    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
        if UserInputService:GetFocusedTextBox() then
            return Enum.ContextActionResult.Pass
        end

        if t20.on then
            stopFreecam()
        else
            if v471 ~= true and LocalPlayer:GetAttribute("FreecamFree") ~= true
                or JerezRaceHUD:GetAttribute("BikesPreviewOpen") == true
                or JerezRaceHUD:GetAttribute("LegendsOpen") == true
                or JerezRaceHUD:GetAttribute("ShopOpen") == true
                or JerezRaceHUD:GetAttribute("ProfileOpen") == true
                or v19
                or t9.open then
                return Enum.ContextActionResult.Pass
            end

            if Frame.Visible ~= false then
                Frame.Visible = false
                gearLook()
            end

            startFreecam(true)

            if t20.on then
                t23.freeze()
            end
        end

        return Enum.ContextActionResult.Sink
    end

    return Enum.ContextActionResult.Pass
end, false, 4000, Enum.KeyCode.C)
v15.Activated:Connect(function() -- line: 1171
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), Frame (copy), gearLook (copy)
    if Frame.Visible ~= false then
        Frame.Visible = false
        gearLook()
    end

    local OpenProfile = MotoLegends:FindFirstChild("OpenProfile")

    if OpenProfile then
        OpenProfile:Fire(LocalPlayer.UserId)
    end
end)
UserInputService.InputBegan:Connect(function(p81) -- line: 1176
    -- upvalues: GuiService (copy), TextButton (copy), Frame (copy), gearLook (copy)
    if Frame.Visible and (p81.UserInputType == Enum.UserInputType.MouseButton1 or p81.UserInputType == Enum.UserInputType.Touch) then
        task.defer(function() -- line: 1179
            -- upvalues: p81 (copy), GuiService (copy), TextButton (copy), Frame (copy), gearLook (copy)
            local Position = p81.Position
            local v480 = false

            for _, v481 in { TextButton, Frame } do
                local AbsolutePosition, AbsoluteSize = v481.AbsolutePosition, v481.AbsoluteSize
                local GuiInset = GuiService:GetGuiInset()
                local X = Position.X
                local v482 = Position.Y + GuiInset.Y

                if AbsolutePosition.X + 0 <= X and X <= AbsolutePosition.X + AbsoluteSize.X and AbsolutePosition.Y + GuiInset.Y <= v482 and v482 <= AbsolutePosition.Y + GuiInset.Y + AbsoluteSize.Y then
                    v480 = true
                end
            end

            if not v480 and Frame.Visible ~= false then
                Frame.Visible = false
                gearLook()
            end
        end)
    end
end)

local function topbarRight() -- line: 1190
    -- upvalues: GuiService (copy), PlayerGui (copy)
    local X = GuiService.TopbarInset.Min.X
    local TopbarStandard = PlayerGui:FindFirstChild("TopbarStandard")

    TopbarStandard = TopbarStandard and TopbarStandard.Enabled and TopbarStandard:FindFirstChild("Holders")

    local Left = TopbarStandard and TopbarStandard:FindFirstChild("Left")

    if Left then
        for _, child in Left:GetChildren() do
            if child:IsA("GuiObject") and child.Visible and child.AbsoluteSize.X > 1 then
                X = math.max(X, child.AbsolutePosition.X + child.AbsoluteSize.X)
            end
        end
    end

    return X
end

RunService.RenderStepped:Connect(function() -- line: 1202
    -- upvalues: GuiService (copy), LocalPlayer (copy), JerezRaceHUD (copy), TextButton (copy), Frame (copy), v19 (ref), refreshSettings (copy), v158 (ref), t20 (copy), gearLook (copy), topbarRight (copy)
    local TopbarInset = GuiService.TopbarInset
    local v485 = TopbarInset.Height > 0 and TopbarInset.Height <= 36
    local v486 = workspace.CurrentCamera.ViewportSize.Y / 360
    local v488 = math.floor(20 * v486 + 0.5)
    local v490 = if v485 then 32 else math.max(32, TopbarInset.Height - 14)
    local v489 = if v485 then 2 else 12
    local v492 = v489 + v490 / 2 - v488 / 2
    local v493 = topbarRight() + (if v485 then 4 else 8)
    local v495 = math.floor(35 * v486 + 0.5)

    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.Position = UDim2.fromOffset(v493 + v495 / 2, v492 + v488 / 2)
    TextButton.Size = UDim2.fromOffset(v495, v488)
    Frame.Position = UDim2.fromOffset(v493 + 8, v492 + v488 + 6)

    local Character = LocalPlayer.Character
    local v496 = not (Character ~= nil and Character:GetAttribute("RaceCrashActive") == true)

    v496 = v496 and not (JerezRaceHUD:GetAttribute("BikesPreviewOpen") == true or JerezRaceHUD:GetAttribute("LegendsOpen") == true or JerezRaceHUD:GetAttribute("ShopOpen") == true or JerezRaceHUD:GetAttribute("ProfileOpen") == true) and not t20.on
    TextButton.Visible = v496

    if not v496 then
        if Frame.Visible ~= false then
            Frame.Visible = false
            gearLook()
        end

        v158()
    end

    if v19 then
        refreshSettings()
    end
end)
