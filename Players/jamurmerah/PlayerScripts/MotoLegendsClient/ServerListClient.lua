-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local RaceIcons = require(MotoLegends:WaitForChild("RaceIcons"))
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local JerezRaceHUD = PlayerGui:WaitForChild("JerezRaceHUD")
local v1 = Color3.fromRGB(231, 0, 0)
local v2 = Color3.new(0, 0, 0)
local v3 = Color3.new(1, 1, 1)
local v4 = Color3.fromRGB(20, 22, 28)
local v5 = Color3.fromRGB(150, 154, 162)
local v6 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
local v7 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local t1 = {
    PRACTICE = {
        bg = Color3.fromRGB(110, 114, 122),
        text = v3
    },
    QUALI = {
        bg = v4,
        text = v3
    },
    RACE = {
        bg = v1,
        text = v3
    }
}
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "ServerListHUD"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 41
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local n1 = 1

local function u(p1) -- line: 39
    -- upvalues: n1 (ref)
    return (math.max(1, (math.floor(p1 * n1 + 0.5))))
end

local function corner(p2, p3) -- line: 40
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = p3
    UICorner.Parent = p2

    return UICorner
end

local function stroke(p4, p5, p6) -- line: 41
    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = p5
    UIStroke.Thickness = p6 or 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = p4

    return UIStroke
end

local function label(p7, p8, p9, p10, p11, p12) -- line: 42
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = p8
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p9
    TextLabel.FontFace = p10
    TextLabel.TextSize = p11
    TextLabel.TextColor3 = p12
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = p7

    return TextLabel
end

local function pillStyle(p13, p14) -- line: 46
    -- upvalues: v1 (copy), v3 (copy), v4 (copy)
    p13.BackgroundColor3 = p14 and v1 or v3
    p13.TextColor3 = p14 and v3 or v4

    local UIStroke = p13:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = p14 and v1 or v4
    end
end

local function pill(p15, p16, p17, p18) -- line: 50
    -- upvalues: TweenService (copy), v4 (copy), v6 (copy), n1 (ref)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p16
    TextButton.AutoButtonColor = false
    TextButton:SetAttribute("NoHover", true)
    TextButton.BorderSizePixel = 0
    TextButton.AnchorPoint = Vector2.new(1, 0.5)
    TextButton.Size = UDim2.fromOffset(math.max(1, (math.floor(p17 * n1 + 0.5))), (math.max(1, (math.floor(11 * n1 + 0.5)))))
    TextButton.FontFace = v6
    TextButton.TextSize = math.max(1, (math.floor(7 * n1 + 0.5)))
    TextButton.Text = p18
    TextButton.AutoLocalize = false

    local v17 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v17
    UICorner.Parent = TextButton

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v4
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = TextButton
    TextButton.Parent = p15

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = TextButton
    TextButton.MouseEnter:Connect(function() -- line: 55
        -- upvalues: TextButton (copy), UIScale (copy), TweenService (copy)
        if TextButton.Active then
            TweenService:Create(UIScale, TweenInfo.new(0.12), {
                Scale = 1.06
            }):Play()
        end
    end)
    TextButton.MouseLeave:Connect(function() -- line: 56
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.12), {
            Scale = 1
        }):Play()
    end)

    return TextButton
end

local function clock(p19) -- line: 59
    local v19 = math.max(0, (math.floor(p19)))

    return string.format("%d:%02d", v19 // 60, v19 % 60)
end

local t2 = {
    open = false,
    servers = nil,
    loading = false,
    status = "",
    joining = nil,
    serial = 0
}
local v20, v21

task.spawn(function() -- line: 67
    -- upvalues: TeleportService (copy), MotoLegends (copy), t2 (copy), v20 (ref), v21 (ref)
    v20 = MotoLegends:WaitForChild("ServerList", 30)
    v21 = MotoLegends:WaitForChild("JoinServer", 30)

    if v21 then
        v21.OnClientEvent:Connect(function(p20) -- line: 70
            -- upvalues: TeleportService (copy), t2 (copy)
            t2.joining = nil
            t2.status = p20 == "Full" and "THAT SERVER IS FULL" or "JOIN FAILED, TRY AGAIN"

            local function v22() -- line: 73
                -- upvalues: TeleportService (copy)
                TeleportService:SetTeleportGui(nil)
            end

            pcall(v22)

            if t2.open then
                t2.render()
            end
        end)
    end
end)
TeleportService.TeleportInitFailed:Connect(function(p21) -- line: 77
    -- upvalues: LocalPlayer (copy), t2 (copy)
    if p21 ~= LocalPlayer or not t2.joining then
        return
    end

    t2.joining = nil
    t2.status = "JOIN FAILED, TRY AGAIN"

    if t2.open then
        t2.render()
    end
end)

local function build() -- line: 82
    -- upvalues: UserInputService (copy), TweenService (copy), RaceIcons (copy), JerezRaceHUD (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), ScreenGui (copy), n1 (ref), pill (copy), t2 (copy)
    if t2.root then
        t2.root:Destroy()
    end

    local v23 = t2.content and t2.content.CanvasPosition
    local Frame = workspace.CurrentCamera.ViewportSize

    n1 = math.min(Frame.Y / 360, (Frame.X - 24) / 330)
    t2.ROW = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and 22 or 18
    Frame = Instance.new("Frame")
    Frame.Name = "ServerListWindow"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(math.max(1, (math.floor(330 * n1 + 0.5))), (math.max(1, (math.floor(200 * n1 + 0.5)))))
    Frame.BackgroundColor3 = v2
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Visible = false

    local Frame2 = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    local TextButton = Instance.new("UICorner")

    TextButton.CornerRadius = Frame2
    TextButton.Parent = Frame
    Frame.Parent = ScreenGui
    t2.root = Frame

    local v24 = math.max(1, (math.floor(12 * n1 + 0.5)))
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Title"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "SERVERS"
    TextLabel.FontFace = v6
    TextLabel.TextSize = v24
    TextLabel.TextColor3 = v3
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = Frame
    TextLabel.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(8 * n1 + 0.5)))))
    TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(160 * n1 + 0.5))), (math.max(1, (math.floor(14 * n1 + 0.5)))))
    Frame2 = Instance.new("Frame")
    Frame2.Name = "Divider"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = v3
    Frame2.Position = UDim2.fromOffset(math.max(1, (math.floor(12 * n1 + 0.5))), (math.max(1, (math.floor(27 * n1 + 0.5)))))
    Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(99 * n1 + 0.5))), (math.max(1, (math.floor(n1 + 0.5)))))
    Frame2.Parent = Frame
    TextButton = Instance.new("UIGradient")
    TextButton.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    TextButton.Parent = Frame2
    v24 = math.max(1, (math.floor(7 * n1 + 0.5)))
    TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Status"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.FontFace = v7
    TextLabel.TextSize = v24
    TextLabel.TextColor3 = v5
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = Frame
    TextLabel.AnchorPoint = Vector2.new(1, 0)
    TextLabel.Position = UDim2.new(1, -math.max(1, (math.floor(48 * n1 + 0.5))) - math.max(1, (math.floor(52 * n1 + 0.5))) - math.max(1, (math.floor(8 * n1 + 0.5))), 0, (math.max(1, (math.floor(12 * n1 + 0.5)))))
    TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(120 * n1 + 0.5))), (math.max(1, (math.floor(12 * n1 + 0.5)))))
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right
    t2.statusLabel = TextLabel

    local REFRESH = pill(Frame, "Refresh", 52, "REFRESH")

    REFRESH.Position = UDim2.new(1, -math.max(1, (math.floor(48 * n1 + 0.5))), 0, (math.max(1, (math.floor(18 * n1 + 0.5)))))
    REFRESH.BackgroundColor3 = v3
    REFRESH.TextColor3 = v4
    TextButton = REFRESH:FindFirstChildOfClass("UIStroke")

    if TextButton then
        TextButton.Color = v4
    end

    REFRESH.ZIndex = 3
    REFRESH.MouseEnter:Connect(function() -- line: 103
        -- upvalues: REFRESH (copy), v1 (copy), v3 (copy), v4 (copy)
        REFRESH.BackgroundColor3 = v1 or v3
        REFRESH.TextColor3 = v3 or v4

        local UIStroke = REFRESH:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = v1 or v4
        end
    end)
    REFRESH.MouseLeave:Connect(function() -- line: 103
        -- upvalues: REFRESH (copy), v3 (copy), v4 (copy)
        REFRESH.BackgroundColor3 = v3
        REFRESH.TextColor3 = v4

        local UIStroke = REFRESH:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = v4
        end
    end)
    REFRESH.Activated:Connect(function() -- line: 104
        -- upvalues: t2 (copy)
        t2.fetch(true)
    end)
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Close"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton:SetAttribute("NoHover", true)
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    v24 = UDim2.new
    TextLabel = -math.max(1, (math.floor(26 * n1 + 0.5)))

    local TextLabel2 = 18 * n1 + 0.5
    local v28 = math.floor(TextLabel2)

    TextButton.Position = v24(1, TextLabel, 0, (math.max(1, v28)))
    v24 = UDim2.fromOffset

    local Frame3 = math.floor(30 * n1 + 0.5)

    TextButton.Size = v24(math.max(1, Frame3), (math.max(1, (math.floor(16 * n1 + 0.5)))))
    TextButton.ZIndex = 3
    TextButton.Parent = Frame
    t2.close = TextButton

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Plate"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ImageColor3 = v3
    ImageLabel.ZIndex = 3
    ImageLabel.Parent = TextButton

    local v25 = RaceIcons.Get("ref_top_plate")

    if v25 then
        ImageLabel.ImageContent = v25
    else
        ImageLabel.BackgroundTransparency = 0
        ImageLabel.BackgroundColor3 = v3
        TextLabel = UDim.new
        TextLabel2 = 4 * n1 + 0.5
        v28 = math.floor(TextLabel2)
        TextLabel = TextLabel(0, (math.max(1, v28)))
        Frame3 = Instance.new("UICorner")
        Frame3.CornerRadius = TextLabel
        Frame3.Parent = ImageLabel
    end

    Frame3 = math.max(1, (math.floor(10 * n1 + 0.5)))

    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Name = "X"
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = "X"
    TextLabel3.FontFace = v6
    TextLabel3.TextSize = Frame3
    TextLabel3.TextColor3 = v2
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.AutoLocalize = false
    TextLabel3.Parent = TextButton
    TextLabel3.Size = UDim2.fromScale(1, 1)
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel3.ZIndex = 4

    local function hover(p22) -- line: 113
        -- upvalues: ImageLabel (copy), TextLabel3 (copy), TweenService (copy), v1 (copy), v2 (copy), v3 (copy)
        TweenService:Create(ImageLabel, TweenInfo.new(0.18), {
            ImageColor3 = p22 and v1 or v3,
            BackgroundColor3 = p22 and v1 or v3
        }):Play()
        TweenService:Create(TextLabel3, TweenInfo.new(0.18), {
            TextColor3 = p22 and v3 or v2
        }):Play()
    end

    TextButton.MouseEnter:Connect(function() -- line: 117
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.MouseLeave:Connect(function() -- line: 117
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.SelectionGained:Connect(function() -- line: 118
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.SelectionLost:Connect(function() -- line: 118
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.Activated:Connect(function() -- line: 119
        -- upvalues: JerezRaceHUD (copy)
        JerezRaceHUD:SetAttribute("ServerListOpen", false)
    end)
    Frame3 = Instance.new("Frame")
    Frame3.Name = "Columns"
    Frame3.BackgroundTransparency = 1
    Frame3.Position = UDim2.fromOffset(math.max(1, (math.floor(10 * n1 + 0.5))), (math.max(1, (math.floor(34 * n1 + 0.5)))))
    Frame3.Size = UDim2.new(1, -math.max(1, (math.floor(28 * n1 + 0.5))), 0, (math.max(1, (math.floor(10 * n1 + 0.5)))))
    Frame3.Parent = Frame

    local v29 = math.max(1, (math.floor(6.5 * n1 + 0.5)))

    TextLabel2 = Instance.new("TextLabel")
    TextLabel2.Name = "Session"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "SESSION"
    TextLabel2.FontFace = v7
    TextLabel2.TextSize = v29
    TextLabel2.TextColor3 = v5
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.AutoLocalize = false
    TextLabel2.Parent = Frame3
    TextLabel2.Position = UDim2.fromOffset(math.max(1, (math.floor(6 * n1 + 0.5))), 0)
    TextLabel2.Size = UDim2.fromOffset(math.max(1, (math.floor(60 * n1 + 0.5))), (math.max(1, (math.floor(10 * n1 + 0.5)))))
    v29 = math.max(1, (math.floor(6.5 * n1 + 0.5)))
    TextLabel2 = Instance.new("TextLabel")
    TextLabel2.Name = "Server"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "REGION"
    TextLabel2.FontFace = v7
    TextLabel2.TextSize = v29
    TextLabel2.TextColor3 = v5
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.AutoLocalize = false
    TextLabel2.Parent = Frame3
    TextLabel2.Position = UDim2.fromOffset(math.max(1, (math.floor(6 * n1 + 0.5))) + math.max(1, (math.floor(62 * n1 + 0.5))) + math.max(1, (math.floor(8 * n1 + 0.5))), 0)
    TextLabel2.Size = UDim2.fromOffset(math.max(1, (math.floor(80 * n1 + 0.5))), (math.max(1, (math.floor(10 * n1 + 0.5)))))
    v29 = math.max(1, (math.floor(6.5 * n1 + 0.5)))
    TextLabel2 = Instance.new("TextLabel")
    TextLabel2.Name = "Players"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "PLAYERS"
    TextLabel2.FontFace = v7
    TextLabel2.TextSize = v29
    TextLabel2.TextColor3 = v5
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.AutoLocalize = false
    TextLabel2.Parent = Frame3
    TextLabel2.AnchorPoint = Vector2.new(1, 0)
    TextLabel2.Position = UDim2.new(1, -math.max(1, (math.floor(6 * n1 + 0.5))) - math.max(1, (math.floor(54 * n1 + 0.5))) - math.max(1, (math.floor(8 * n1 + 0.5))), 0, 0)
    TextLabel2.Size = UDim2.fromOffset(math.max(1, (math.floor(40 * n1 + 0.5))), (math.max(1, (math.floor(10 * n1 + 0.5)))))
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Center

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "Content"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(math.max(1, (math.floor(10 * n1 + 0.5))), (math.max(1, (math.floor(46 * n1 + 0.5)))))
    ScrollingFrame.Size = UDim2.new(1, -math.max(1, (math.floor(14 * n1 + 0.5))), 1, -math.max(1, (math.floor(46 * n1 + 0.5))) - math.max(1, (math.floor(6 * n1 + 0.5))))
    ScrollingFrame.ScrollBarThickness = math.max(2, (math.max(1, (math.floor(2 * n1 + 0.5)))))
    ScrollingFrame.ScrollBarImageColor3 = v3
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.Parent = Frame
    t2.content = ScrollingFrame

    local v27 = Instance.new("UIListLayout")

    v27.SortOrder = Enum.SortOrder.LayoutOrder
    v27.Padding = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    v27.Parent = ScrollingFrame
    v27 = Instance.new("UIPadding")
    v27.PaddingRight = UDim.new(0, (math.max(1, (math.floor(6 * n1 + 0.5)))))
    v27.PaddingBottom = UDim.new(0, (math.max(1, (math.floor(6 * n1 + 0.5)))))
    v27.Parent = ScrollingFrame

    if v23 then
        task.defer(function() -- line: 132
            -- upvalues: ScrollingFrame (copy), v23 (copy)
            if ScrollingFrame.Parent then
                ScrollingFrame.CanvasPosition = v23
            end
        end)
    end

    t2.render()
end

local function sorted(p23) -- line: 137
    local v39 = table.clone(p23)

    table.sort(v39, function(p24, p25) -- line: 139
        if p24.current == true ~= (p25.current == true) then
            return p24.current == true
        end

        local v40 = p24.players >= p24.max

        if v40 ~= (p25.players >= p25.max) then
            return not v40
        end

        if p24.players == p25.players then
            return p24.jobId < p25.jobId
        end

        return p24.players > p25.players
    end)

    return v39
end

local function serverNames(p26) -- line: 151
    local t5 = {}

    for _, v41 in p26 do
        t5[v41.jobId] = typeof(v41.region) == "string" and v41.region ~= "" and v41.region or "SERVER"
    end

    return t5
end

function t2.render() -- line: 157
    -- upvalues: v1 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), t1 (copy), n1 (ref), pill (copy), t2 (copy), serverNames (copy)
    local content = t2.content

    if not content then
        return
    end

    for _, child in content:GetChildren() do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    t2.timers = {}

    local ROW, servers = t2.ROW, t2.servers

    if servers then
        local t6 = {}

        for _, v42 in servers do
            if not v42.current and v42.players < v42.max then
                table.insert(t6, v42)
            end
        end

        local v43 = table.clone(t6)

        table.sort(v43, function(p27, p28) -- line: 139
            if p27.current == true ~= (p28.current == true) then
                return p27.current == true
            end

            local v44 = p27.players >= p27.max

            if v44 ~= (p28.players >= p28.max) then
                return not v44
            end

            if p27.players == p28.players then
                return p27.jobId < p28.jobId
            end

            return p27.players > p28.players
        end)

        local v45 = serverNames(t6)
        local n2 = 0

        for _, v46 in v43 do
            n2 += v46.players
        end

        local statusLabel = t2.statusLabel
        local v47, v48, v49, v50

        if t2.status == "" then
            v47 = #v43
            v48 = if #v43 == 1 then "" else "S"
            v50 = false
        else
            local status = t2.status

            if status then
                v49 = status
                v50 = true
            else
                v47 = #v43
                v48 = if #v43 == 1 then "" else "S"
                v50 = false
            end
        end

        statusLabel.Text = if not v50 then v47 .. " SERVER" .. v48 .. "  •  " .. n2 .. " PLAYERS" else v49
        t2.statusLabel.TextColor3 = t2.status ~= "" and v1 or v5

        for v51, v52 in v43 do
            local Frame = Instance.new("Frame")

            Frame.Name = string.format("Row_%03d", v51)
            Frame.BackgroundColor3 = v3
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(ROW * n1 + 0.5)))))
            Frame.LayoutOrder = v51

            local v57 = UDim.new(0, (math.max(1, (math.floor(3 * n1 + 0.5)))))
            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = v57
            UICorner.Parent = Frame
            Frame.Parent = content

            if v52.current then
                local v60 = math.max(1, (math.floor(n1 + 0.5)))
                local UIStroke = Instance.new("UIStroke")

                UIStroke.Color = v1
                UIStroke.Thickness = v60 or 1
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                UIStroke.Parent = Frame
            end

            local v61 = t1[v52.session] or t1.PRACTICE
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = "Session"
            TextLabel.AnchorPoint = Vector2.new(0, 0.5)
            TextLabel.Position = UDim2.new(0, math.max(1, (math.floor(6 * n1 + 0.5))), 0.5, 0)
            TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(62 * n1 + 0.5))), (math.max(1, (math.floor(11 * n1 + 0.5)))))
            TextLabel.BackgroundColor3 = v61.bg
            TextLabel.BorderSizePixel = 0
            TextLabel.FontFace = v6
            TextLabel.TextSize = math.max(1, (math.floor(6.5 * n1 + 0.5)))
            TextLabel.TextColor3 = v61.text
            TextLabel.AutoLocalize = false
            TextLabel.Text = v52.session

            local v71 = UDim.new(1, 0)
            local UICorner2 = Instance.new("UICorner")

            UICorner2.CornerRadius = v71
            UICorner2.Parent = TextLabel
            TextLabel.Parent = Frame

            if v52.session == "QUALI" and (v52.deadline or 0) > 0 then
                table.insert(t2.timers, {
                    label = TextLabel,
                    session = v52.session,
                    deadline = v52.deadline
                })
            end

            local v72 = v45[v52.jobId] or "SERVER"
            local v75 = math.max(1, (math.floor(8.5 * n1 + 0.5)))
            local TextLabel2 = Instance.new("TextLabel")

            TextLabel2.Name = "Name"
            TextLabel2.BackgroundTransparency = 1
            TextLabel2.Text = v72
            TextLabel2.FontFace = v7
            TextLabel2.TextSize = v75
            TextLabel2.TextColor3 = v4
            TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel2.AutoLocalize = false
            TextLabel2.Parent = Frame
            TextLabel2.Position = UDim2.fromOffset(math.max(1, (math.floor(6 * n1 + 0.5))) + math.max(1, (math.floor(62 * n1 + 0.5))) + math.max(1, (math.floor(8 * n1 + 0.5))), 0)
            TextLabel2.Size = UDim2.new(1, -math.max(1, (math.floor(6 * n1 + 0.5))) - math.max(1, (math.floor(62 * n1 + 0.5))) - math.max(1, (math.floor(8 * n1 + 0.5))) - math.max(1, (math.floor(130 * n1 + 0.5))), 1, 0)
            TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd

            if v52.current then
                TextLabel2.Text = (v45[v52.jobId] or v52.region or "SERVER") .. "  <font color=\"#E70000\" size=\"" .. math.max(1, (math.floor(6.5 * n1 + 0.5))) .. "\">YOU ARE HERE</font>"
                TextLabel2.RichText = true
            end

            local v98 = v52.players >= v52.max
            local v99 = v52.players .. "/" .. v52.max
            local v102 = math.max(1, (math.floor(8.5 * n1 + 0.5)))
            local v103 = v98 and v1 or v4
            local TextLabel3 = Instance.new("TextLabel")

            TextLabel3.Name = "Players"
            TextLabel3.BackgroundTransparency = 1
            TextLabel3.Text = v99
            TextLabel3.FontFace = v6
            TextLabel3.TextSize = v102
            TextLabel3.TextColor3 = v103
            TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel3.AutoLocalize = false
            TextLabel3.Parent = Frame
            TextLabel3.AnchorPoint = Vector2.new(1, 0.5)
            TextLabel3.Position = UDim2.new(1, -math.max(1, (math.floor(6 * n1 + 0.5))) - math.max(1, (math.floor(54 * n1 + 0.5))) - math.max(1, (math.floor(8 * n1 + 0.5))), 0.5, 0)
            TextLabel3.Size = UDim2.fromOffset(math.max(1, (math.floor(40 * n1 + 0.5))), (math.max(1, (math.floor(11 * n1 + 0.5)))))
            TextLabel3.TextXAlignment = Enum.TextXAlignment.Center

            local JOIN = pill(Frame, "Join", 54, "JOIN")

            JOIN.Position = UDim2.new(1, -math.max(1, (math.floor(6 * n1 + 0.5))), 0.5, 0)

            if v52.current then
                JOIN.Text = "CURRENT"
                JOIN.Active = false
                JOIN.BackgroundColor3 = v3
                JOIN.TextColor3 = v4

                local UIStroke = JOIN:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIStroke.Color = v4
                end

                JOIN.TextColor3 = v5
                JOIN.UIStroke.Color = v5
            elseif v98 then
                JOIN.Text = "FULL"
                JOIN.Active = false
                JOIN.BackgroundColor3 = v3
                JOIN.TextColor3 = v4

                local UIStroke = JOIN:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIStroke.Color = v4
                end

                JOIN.TextColor3 = v5
                JOIN.UIStroke.Color = v5
            elseif t2.joining == v52.jobId then
                JOIN.Text = "JOINING..."
                JOIN.BackgroundColor3 = v1 or v3
                JOIN.TextColor3 = v3 or v4

                local UIStroke = JOIN:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIStroke.Color = v1 or v4
                end
            else
                JOIN.BackgroundColor3 = v1 or v3
                JOIN.TextColor3 = v3 or v4

                local UIStroke = JOIN:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIStroke.Color = v1 or v4
                end

                JOIN.Activated:Connect(function() -- line: 204
                    -- upvalues: v52 (copy), t2 (copy)
                    t2.join(v52)
                end)
            end
        end

        if #v43 == 0 then
            local v121 = math.max(1, (math.floor(7.5 * n1 + 0.5)))
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = "Empty"
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = "NO OTHER SERVERS RIGHT NOW"
            TextLabel.FontFace = v7
            TextLabel.TextSize = v121
            TextLabel.TextColor3 = v5
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.AutoLocalize = false
            TextLabel.Parent = content
            TextLabel.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(ROW * n1 + 0.5)))))
            TextLabel.LayoutOrder = #v43 + 1
            TextLabel.TextXAlignment = Enum.TextXAlignment.Center
        end

        t2.tick()
    else
        local v126 = math.max(1, (math.floor(8 * n1 + 0.5)))
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "Loading"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = "LOADING SERVERS..."
        TextLabel.FontFace = v7
        TextLabel.TextSize = v126
        TextLabel.TextColor3 = v5
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.AutoLocalize = false
        TextLabel.Parent = content
        TextLabel.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(ROW * n1 + 0.5)))))
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center
        t2.statusLabel.Text = t2.status
    end
end

function t2.tick() -- line: 213
    -- upvalues: t2 (copy)
    if t2.timers then
        local ServerTimeNow = workspace:GetServerTimeNow()

        for _, v129 in t2.timers do
            local v130 = v129.deadline - ServerTimeNow
            local v131

            if v130 > 0 then
                local session = v129.session
                local v133 = math.max(0, (math.floor(v130)))

                v131 = session .. "  " .. string.format("%d:%02d", v133 // 60, v133 % 60) or v129.session
            else
                v131 = v129.session
            end

            if v129.label.Text ~= v131 then
                v129.label.Text = v131
            end
        end
    end
end

function t2.fetch(p29) -- line: 223
    -- upvalues: v5 (copy), t2 (copy), v20 (ref)
    if t2.loading then
        return
    end

    if v20 then
        t2.loading = true
        t2.serial += 1

        local serial = t2.serial

        if p29 then
            t2.status = ""
            t2.statusLabel.Text = "REFRESHING..."
            t2.statusLabel.TextColor3 = v5
        end

        task.spawn(function() -- line: 228
            -- upvalues: serial (copy), t2 (copy), v20 (ref)
            local InvokeServer = v20.InvokeServer
            local v134 = v20
            local ok, result = pcall(InvokeServer, v134)

            t2.loading = false

            if serial ~= t2.serial then
                return
            end

            if ok and typeof(result) == "table" then
                t2.servers = result

                if not t2.joining then
                    t2.status = ""
                end
            else
                t2.status = "COULD NOT LOAD SERVERS"
                t2.servers = t2.servers or {}
            end

            t2.lastFetch = os.clock()

            if t2.open then
                t2.render()
            end
        end)
    else
        t2.status = "LOADING..."

        if t2.open then
            t2.render()
        end
    end
end

function t2.join(p30) -- line: 239
    -- upvalues: TeleportService (copy), v2 (copy), t2 (copy), v21 (ref)
    if t2.joining or not v21 then
        return
    end

    t2.joining = p30.jobId
    t2.status = "JOINING SERVER..."

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "ServerJoinCover"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 1000

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = v2
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local function v135() -- line: 244
        -- upvalues: ScreenGui (copy), TeleportService (copy)
        TeleportService:SetTeleportGui(ScreenGui)
    end

    pcall(v135)
    v21:FireServer(p30.jobId)
    t2.render()

    local jobId = p30.jobId

    task.delay(20, function() -- line: 249
        -- upvalues: jobId (copy), t2 (copy)
        if t2.joining ~= jobId then
            return
        end

        t2.joining = nil
        t2.status = "JOIN FAILED, TRY AGAIN"

        if t2.open then
            t2.render()
        end
    end)
end

local function open() -- line: 252
    -- upvalues: t2 (copy), build (copy)
    if t2.open then
        return
    end

    t2.open = true
    t2.status = t2.joining and t2.status or ""
    build()
    t2.root.Visible = true
    t2.close.Modal = true
    t2.fetch(false)
end

local function close() -- line: 258
    -- upvalues: t2 (copy)
    if t2.open then
        t2.open = false

        if t2.root then
            t2.root.Visible = false
            t2.close.Modal = false
        end
    end
end

JerezRaceHUD:GetAttributeChangedSignal("ServerListOpen"):Connect(function() -- line: 263
    -- upvalues: JerezRaceHUD (copy), t2 (copy), build (copy)
    if JerezRaceHUD:GetAttribute("ServerListOpen") == true then
        if not t2.open then
            t2.open = true
            t2.status = t2.joining and t2.status or ""
            build()
            t2.root.Visible = true
            t2.close.Modal = true
            t2.fetch(false)
        end
    elseif t2.open then
        t2.open = false

        if t2.root then
            t2.root.Visible = false
            t2.close.Modal = false
        end
    end
end)
JerezRaceHUD:GetAttributeChangedSignal("LobbySettings"):Connect(function() -- line: 267
    -- upvalues: JerezRaceHUD (copy)
    if JerezRaceHUD:GetAttribute("LobbySettings") == true then
        JerezRaceHUD:SetAttribute("ServerListOpen", false)
    end
end)

for _, v137 in { "BikesPreviewOpen", "LegendsOpen", "ShopOpen", "ProfileOpen", "Freecam" } do
    JerezRaceHUD:GetAttributeChangedSignal(v137):Connect(function() -- line: 269
        -- upvalues: JerezRaceHUD (copy), v137 (copy)
        if JerezRaceHUD:GetAttribute(v137) == true then
            JerezRaceHUD:SetAttribute("ServerListOpen", false)
        end
    end)
end

UserInputService.InputBegan:Connect(function(p31) -- line: 271
    -- upvalues: JerezRaceHUD (copy), t2 (copy)
    if t2.open and p31.KeyCode == Enum.KeyCode.ButtonB then
        JerezRaceHUD:SetAttribute("ServerListOpen", false)
    end
end)
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 272
    -- upvalues: t2 (copy), build (copy)
    if t2.open then
        build()
        t2.root.Visible = true
        t2.close.Modal = true
    end
end)
task.spawn(function() -- line: 276
    -- upvalues: t2 (copy)
    while true do
        task.wait(1)

        if t2.open then
            t2.tick()

            if not t2.loading and (not t2.lastFetch or os.clock() - t2.lastFetch >= 10) then
                t2.fetch(false)
            end
        end
    end
end)

local v138

if JerezRaceHUD:GetAttribute("ServerListOpen") ~= true or t2.open then
    return
else
    t2.open = true
    v138 = t2.joining and t2.status or ""
end

t2.status = v138
build()
t2.root.Visible = true
t2.close.Modal = true
t2.fetch(false)
