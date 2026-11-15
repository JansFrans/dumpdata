-- https://lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local _ = {
    ClockGap = 4,
    Top = 0,
    Gap = 3,
    Height = 13,
    TextSize = 8,
    PadX = 7,
    FadeIn = 0.22,
    FadeOut = 0.3,
    RedText = "SESSION INTERRUPTED"
}
local t1 = {
    Red = {
        order = 1,
        flag = "RED FLAG",
        color = Color3.fromRGB(231, 0, 0),
        ink = Color3.new(1, 1, 1)
    },
    White = {
        order = 2,
        flag = "WHITE FLAG",
        color = Color3.fromRGB(246, 246, 246),
        ink = Color3.fromRGB(14, 14, 18)
    },
    Yellow = {
        order = 3,
        flag = "YELLOW FLAG",
        color = Color3.fromRGB(255, 214, 0),
        ink = Color3.fromRGB(14, 14, 18)
    }
}
local t2 = {
    "Red",
    "White",
    "Yellow"
}
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "FlagBannerHUD"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 14
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")

Frame.Name = "Banners"
Frame.BackgroundTransparency = 1
Frame.AnchorPoint = Vector2.new(0.5, 0)
Frame.Position = UDim2.new(0.5, 0, 0, 64)
Frame.Size = UDim2.fromOffset(0, 0)
Frame.Parent = ScreenGui

local UIScale = Instance.new("UIScale")

UIScale.Parent = Frame

local function rescale() -- line: 44
    -- upvalues: UIScale (copy)
    UIScale.Scale = workspace.CurrentCamera.ViewportSize.Y / 360
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)
UIScale.Scale = workspace.CurrentCamera.ViewportSize.Y / 360

local GuiService = game:GetService("GuiService")

local function topLine() -- line: 48
    -- upvalues: GuiService (copy)
    local v1 = workspace.CurrentCamera.ViewportSize.Y / 360
    local Height = GuiService.TopbarInset.Height
    local v2, v3

    if Height > 0 and Height <= 36 then
        v3 = 2
        v2 = 32
    else
        v3 = 12
        v2 = math.max(32, Height - 14)
    end

    return (math.max(2, (math.floor(v3 + v2 / 2 - 10 * v1 + 0.5))))
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local t3 = {}

local function place() -- line: 57
    -- upvalues: ScreenGui (copy), Frame (copy), UIScale (copy), GuiService (copy), PlayerGui (copy), t3 (copy)
    local v7 = workspace.CurrentCamera.ViewportSize.Y / 360
    local Height = GuiService.TopbarInset.Height
    local v8, v9

    if Height > 0 and Height <= 36 then
        v9 = 2
        v8 = 32
    else
        v9 = 12
        v8 = math.max(32, Height - 14)
    end

    local v13 = math.max(2, (math.floor(v9 + v8 / 2 - 10 * v7 + 0.5)))
    local SessionTimerHUD = PlayerGui:FindFirstChild("SessionTimerHUD")

    SessionTimerHUD = SessionTimerHUD and SessionTimerHUD.Enabled and SessionTimerHUD:FindFirstChild("SessionTimer")

    if SessionTimerHUD and SessionTimerHUD.Visible and SessionTimerHUD.AbsoluteSize.Y > 0 then
        local v14 = Frame.Position.Y.Offset - Frame.AbsolutePosition.Y

        v13 = math.max(v13, (math.floor(SessionTimerHUD.AbsolutePosition.Y + v14 + SessionTimerHUD.AbsoluteSize.Y + 4)))
    end

    local v17 = UDim2.new(0.5, 0, 0, v13)

    if Frame.Position ~= v17 then
        Frame.Position = v17
    end

    local n1 = 0

    for _, v18 in t3 do
        if v18.shown then
            n1 += 1
        end
    end

    local v19 = n1 > 0 and math.floor(v13 + UIScale.Scale * (0 + n1 * 13 + (n1 - 1) * 3) + 0.5) or 0

    if ScreenGui:GetAttribute("BottomPx") ~= v19 then
        ScreenGui:SetAttribute("BottomPx", v19)
    end
end

game:GetService("RunService").Heartbeat:Connect(place)
place()

local function esc(p1) -- line: 77
    return (tostring(p1):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function make(p2) -- line: 78
    -- upvalues: t1 (copy), Frame (copy), t3 (copy)
    local v21 = t1[p2]
    local Frame2 = Instance.new("Frame")

    Frame2.Name = p2 .. "Flag"
    Frame2.AnchorPoint = Vector2.new(0.5, 0)
    Frame2.BackgroundColor3 = v21.color
    Frame2.BorderSizePixel = 0
    Frame2.AutomaticSize = Enum.AutomaticSize.X
    Frame2.Size = UDim2.fromOffset(0, 13)
    Frame2.BackgroundTransparency = 1
    Frame2.Visible = false
    Frame2.Parent = Frame

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 2)
    UICorner.Parent = Frame2

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Text"
    TextLabel.BackgroundTransparency = 1
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.Size = UDim2.fromOffset(0, 13)
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold)
    TextLabel.TextSize = 8
    TextLabel.TextColor3 = v21.ink
    TextLabel.RichText = true
    TextLabel.AutoLocalize = false
    TextLabel.TextTransparency = 1
    TextLabel.Parent = Frame2

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 7)
    UIPadding.PaddingRight = UDim.new(0, 7)
    UIPadding.Parent = TextLabel
    t3[p2] = {
        shown = false,
        id = 0,
        frame = Frame2,
        text = TextLabel
    }

    return t3[p2]
end

make("Red")
make("White")
make("Yellow")

local function setText(p3, p4) -- line: 95
    -- upvalues: t1 (copy), t3 (copy)
    t3[p3].text.Text = "<font weight=\"900\">" .. t1[p3].flag .. "</font>  <font weight=\"300\">|</font>  " .. tostring(p4):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

local function layout(p5) -- line: 100
    -- upvalues: TweenService (copy), t2 (copy), t3 (copy)
    local n2 = 0

    for _, v22 in t2 do
        local v23 = t3[v22]

        if v23.shown then
            local v24 = UDim2.fromOffset(0, n2)

            if p5 and v23.frame.Visible then
                TweenService:Create(v23.frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = v24
                }):Play()
            else
                v23.frame.Position = v24
            end

            n2 += 16
        end
    end
end

local function show(p6, p7) -- line: 111
    -- upvalues: TweenService (copy), t3 (copy), layout (copy)
    local v25 = t3[p6]

    if v25.shown == p7 then
        return
    end

    v25.shown = p7
    v25.id += 1

    local id, frame = v25.id, v25.frame

    if p7 then
        layout(true)

        local framePosition = frame.Position

        frame.Visible = true
        frame.BackgroundTransparency = 1
        v25.text.TextTransparency = 1
        frame.Position = framePosition - UDim2.fromOffset(0, 4)

        local v26 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        TweenService:Create(frame, v26, {
            BackgroundTransparency = 0,
            Position = framePosition
        }):Play()
        TweenService:Create(v25.text, v26, {
            TextTransparency = 0
        }):Play()
    else
        local v27 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        TweenService:Create(frame, v27, {
            BackgroundTransparency = 1,
            Position = frame.Position - UDim2.fromOffset(0, 4)
        }):Play()
        TweenService:Create(v25.text, v27, {
            TextTransparency = 1
        }):Play()
        task.delay(0.3, function() -- line: 127
            -- upvalues: v25 (copy), id (copy), frame (copy)
            if v25.id == id then
                frame.Visible = false
            end
        end)
        layout(true)
    end
end

local function update() -- line: 132
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), t1 (copy), t3 (copy), show (copy)
    local v28 = MotoLegends:GetAttribute("RedFlag") == true

    if v28 then
        t3.Red.text.Text = "<font weight=\"900\">" .. t1.Red.flag .. "</font>  <font weight=\"300\">|</font>  " .. tostring("SESSION INTERRUPTED"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    end

    show("Red", v28)

    local v29 = MotoLegends:GetAttribute("FlagToFlag") == true and MotoLegends:GetAttribute("SessionPhase") == "Racing" and LocalPlayer:GetAttribute("F2FSwapped") ~= true

    if v29 then
        t3.White.text.Text = "<font weight=\"900\">" .. t1.White.flag .. "</font>  <font weight=\"300\">|</font>  " .. tostring("RIDERS ARE NOW ALLOWED TO SWAP BIKES"):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    end

    show("White", v29)

    local t4 = {}
    local v30 = MotoLegends:GetAttribute("YellowFlagSectors") or ""

    for match in tostring(v30):gmatch("%d+") do
        table.insert(t4, match)
    end

    if #t4 > 0 then
        local v31 = (if #t4 > 1 then "SECTORS " else "SECTOR ") .. table.concat(t4, " · ")

        t3.Yellow.text.Text = "<font weight=\"900\">" .. t1.Yellow.flag .. "</font>  <font weight=\"300\">|</font>  " .. tostring(v31):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    end

    show("Yellow", #t4 > 0)
end

MotoLegends:GetAttributeChangedSignal("RedFlag"):Connect(update)
MotoLegends:GetAttributeChangedSignal("YellowFlagSectors"):Connect(update)
MotoLegends:GetAttributeChangedSignal("FlagToFlag"):Connect(update)
MotoLegends:GetAttributeChangedSignal("FlagToFlagTyre"):Connect(update)
MotoLegends:GetAttributeChangedSignal("SessionPhase"):Connect(update)
LocalPlayer:GetAttributeChangedSignal("F2FSwapped"):Connect(update)
update()
