-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local RaceIcons = require(MotoLegends:WaitForChild("RaceIcons"))
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local JerezRaceHUD = PlayerGui:WaitForChild("JerezRaceHUD")
local v1 = Color3.fromRGB(231, 0, 0)
local v2 = Color3.fromRGB(70, 200, 110)
local v3 = Color3.new(0, 0, 0)
local v4 = Color3.new(1, 1, 1)
local v5 = Color3.fromRGB(20, 22, 28)
local v6 = Color3.fromRGB(150, 154, 162)

Color3.fromRGB(28, 30, 36)

local v7 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
local v8 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "RaceDirectorHUD"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 42
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

local function pillStyle(p13, p14) -- line: 47
    -- upvalues: v1 (copy), v4 (copy), v5 (copy)
    p13.BackgroundColor3 = p14 and v1 or v4
    p13.TextColor3 = p14 and v4 or v5

    local UIStroke = p13:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = p14 and v1 or v5
    end
end

local function pill(p15, p16, p17, p18, p19) -- line: 51
    -- upvalues: TweenService (copy), v1 (copy), v4 (copy), v5 (copy), v7 (copy), n1 (ref)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = p16
    TextButton.AutoButtonColor = false
    TextButton:SetAttribute("NoHover", true)
    TextButton.BorderSizePixel = 0
    TextButton.Size = UDim2.fromOffset(math.max(1, (math.floor(p17 * n1 + 0.5))), (math.max(1, (math.floor((p18 or 13) * n1 + 0.5)))))
    TextButton.FontFace = v7
    TextButton.TextSize = math.max(1, (math.floor(7 * n1 + 0.5)))
    TextButton.Text = p19
    TextButton.AutoLocalize = false

    local v18 = UDim.new(1, 0)
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v18
    UICorner.Parent = TextButton

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v5
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = TextButton
    TextButton.Parent = p15

    local UIScale = Instance.new("UIScale")

    UIScale.Parent = TextButton
    TextButton:SetAttribute("On", false)
    TextButton.MouseEnter:Connect(function() -- line: 57
        -- upvalues: TextButton (copy), UIScale (copy), TweenService (copy), v1 (copy), v4 (copy), v5 (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.12), {
            Scale = 1.06
        }):Play()
        TextButton.BackgroundColor3 = v1 or v4
        TextButton.TextColor3 = v4 or v5

        local UIStroke = TextButton:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = v1 or v5
        end
    end)
    TextButton.MouseLeave:Connect(function() -- line: 58
        -- upvalues: TextButton (copy), UIScale (copy), TweenService (copy), v1 (copy), v4 (copy), v5 (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.12), {
            Scale = 1
        }):Play()

        local v19 = TextButton:GetAttribute("On") == true

        TextButton.BackgroundColor3 = v19 and v1 or v4
        TextButton.TextColor3 = v19 and v4 or v5

        local UIStroke = TextButton:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = v19 and v1 or v5
        end
    end)
    TextButton.MouseButton1Down:Connect(function() -- line: 59
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.08), {
            Scale = 0.92
        }):Play()
    end)
    TextButton.MouseButton1Up:Connect(function() -- line: 60
        -- upvalues: UIScale (copy), TweenService (copy)
        TweenService:Create(UIScale, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
            Scale = 1
        }):Play()
    end)
    TextButton.BackgroundColor3 = v4
    TextButton.TextColor3 = v5

    local UIStroke2 = TextButton:FindFirstChildOfClass("UIStroke")

    if UIStroke2 then
        UIStroke2.Color = v5
    end

    return TextButton
end

local function setOn(p20, p21) -- line: 64
    -- upvalues: v1 (copy), v4 (copy), v5 (copy)
    p20:SetAttribute("On", p21 == true)

    local v22 = p21 == true

    p20.BackgroundColor3 = v22 and v1 or v4
    p20.TextColor3 = v22 and v4 or v5

    local UIStroke = p20:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = v22 and v1 or v5
    end
end

local function textBox(p22, p23, p24, p25, p26, p27) -- line: 65
    -- upvalues: v1 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), n1 (ref)
    local TextBox = Instance.new("TextBox")

    TextBox.Name = p23
    TextBox.BackgroundColor3 = v4
    TextBox.BorderSizePixel = 0
    TextBox.Size = UDim2.fromOffset(math.max(1, (math.floor(p24 * n1 + 0.5))), (math.max(1, (math.floor(p25 * n1 + 0.5)))))
    TextBox.FontFace = v7
    TextBox.TextSize = math.max(1, (math.floor(9 * n1 + 0.5)))
    TextBox.TextColor3 = v5
    TextBox.PlaceholderColor3 = v6
    TextBox.PlaceholderText = p27 or ""
    TextBox.Text = p26 or ""
    TextBox.ClearTextOnFocus = false
    TextBox.AutoLocalize = false

    local v32 = UDim.new(0, (math.max(1, (math.floor(3 * n1 + 0.5)))))
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v32
    UICorner.Parent = TextBox
    TextBox.Parent = p22

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v5
    UIStroke.Thickness = 1
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = TextBox
    TextBox.Focused:Connect(function() -- line: 70
        -- upvalues: UIStroke (copy), v1 (copy)
        UIStroke.Color = v1
    end)
    TextBox.FocusLost:Connect(function() -- line: 70
        -- upvalues: UIStroke (copy), v5 (copy)
        UIStroke.Color = v5
    end)

    return TextBox
end

local function clock(p28) -- line: 73
    local v34 = math.max(0, (math.floor(p28)))

    return string.format("%d:%02d", v34 // 60, v34 % 60)
end

local v35

task.spawn(function() -- line: 80
    -- upvalues: MotoLegends (copy), v35 (ref)
    v35 = MotoLegends:WaitForChild("RaceDirectorAction", 60)
end)

local t1 = {
    panel = nil,
    root = nil,
    feedback = nil,
    pending = false,
    dyn = {}
}
local t2 = {
    minutes = nil,
    laps = nil,
    time = nil,
    message = ""
}
local t3 = {}
local t4 = {}
local t5 = {
    Qualifying = { 330, 128 },
    Race = { 330, 128 },
    Settings = { 330, 238 },
    Riders = { 330, 256 },
    Announce = { 330, 250 },
    Perms = { 330, 256 }
}
local t6 = {
    Qualifying = "QUALIFYING",
    Race = "RACE",
    Settings = "SETTINGS",
    Riders = "RIDERS",
    Announce = "ANNOUNCE",
    Perms = "PERMISSIONS"
}

local function setFeedback(p29, p30) -- line: 89
    -- upvalues: v6 (copy), t1 (copy)
    if t1.feedback then
        t1.feedback.Text = p29 or ""
        t1.feedback.TextColor3 = p30 or v6
    end
end

local function call(p31, p32, p33) -- line: 92
    -- upvalues: v1 (copy), v2 (copy), v6 (copy), v35 (ref), t1 (copy)
    if t1.pending then
        return
    end

    if v35 then
        t1.pending = true

        if t1.feedback then
            t1.feedback.Text = "..."
            t1.feedback.TextColor3 = v6 or v6
        end

        task.spawn(function() -- line: 96
            -- upvalues: p31 (copy), p32 (copy), p33 (copy), v1 (copy), v2 (copy), v6 (copy), v35 (ref), t1 (copy)
            local InvokeServer = v35.InvokeServer
            local v36 = v35
            local ok, result = pcall(InvokeServer, v36, p31, p32)

            t1.pending = false

            if ok and typeof(result) == "table" then
                local msg = result.msg
                local v37 = result.ok and v2 or v1

                if t1.feedback then
                    t1.feedback.Text = msg or ""
                    t1.feedback.TextColor3 = v37 or v6
                end

                if p33 then
                    p33(result.ok == true)
                end
            else
                if not t1.feedback then
                    return
                end

                t1.feedback.Text = "NO RESPONSE · TRY AGAIN"
                t1.feedback.TextColor3 = v1 or v6
            end
        end)
    elseif t1.feedback then
        t1.feedback.Text = "LOADING..."
        t1.feedback.TextColor3 = v6 or v6
    end
end

local t7 = {
    Waiting = "WAITING",
    Qualifying = "QUALIFYING",
    QualifyingFinish = "CHEQUERED FLAG",
    QualifyingResults = "QUALIFYING RESULTS",
    Grid = "GRID",
    Lights = "LIGHTS",
    Racing = "RACE",
    RaceResults = "RACE RESULTS"
}

local function sessionText() -- line: 106
    -- upvalues: MotoLegends (copy), t7 (copy)
    local v38 = MotoLegends:GetAttribute("SessionPhase") or "Waiting"

    if v38 == "Qualifying" and MotoLegends:GetAttribute("SessionPractice") == true then
        return "PRACTICE"
    end

    local v39 = t7[v38] or string.upper(v38)
    local v40 = MotoLegends:GetAttribute("SessionDeadline") or 0
    local v41, v42, v43, SessionLaps

    if v38 ~= "Qualifying" and v38 ~= "QualifyingFinish" then
        if v38 ~= "QualifyingResults" or not (v40 > 0) then
            if v38 == "Racing" then
                SessionLaps = MotoLegends:GetAttribute("SessionLaps")

                if SessionLaps then
                    v39 ..= "  ·  " .. SessionLaps .. " LAPS"
                end
            end

            return v39
        end

        v41 = v40 - workspace:GetServerTimeNow()
        v42 = math.floor(v41)
        v43 = math.max(0, v42)

        return "RACE IN  " .. string.format("%d:%02d", v43 // 60, v43 % 60)
    end

    if v40 > 0 then
        local v46 = math.max(0, (math.floor(v40 - workspace:GetServerTimeNow())))

        return v39 .. "  " .. string.format("%d:%02d", v46 // 60, v46 % 60)
    end

    if v38 == "QualifyingResults" and v40 > 0 then
        v41 = v40 - workspace:GetServerTimeNow()
        v42 = math.floor(v41)
        v43 = math.max(0, v42)

        return "RACE IN  " .. string.format("%d:%02d", v43 // 60, v43 % 60)
    end

    if v38 == "Racing" then
        SessionLaps = MotoLegends:GetAttribute("SessionLaps")

        if SessionLaps then
            v39 ..= "  ·  " .. SessionLaps .. " LAPS"
        end
    end

    return v39
end

local function sortedPlayers() -- line: 123
    -- upvalues: Players (copy), LocalPlayer (copy)
    local Players2 = Players:GetPlayers()

    table.sort(Players2, function(p34, p35) -- line: 125
        -- upvalues: LocalPlayer (copy)
        if p34 == LocalPlayer == (p35 == LocalPlayer) then
            return p34.DisplayName:lower() < p35.DisplayName:lower()
        end

        return p34 == LocalPlayer
    end)

    return Players2
end

local function playerEntries(p36) -- line: 128
    -- upvalues: Players (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v5 (copy), v6 (copy)
    local t8 = {}
    local Players2 = Players:GetPlayers()

    table.sort(Players2, function(p37, p38) -- line: 125
        -- upvalues: LocalPlayer (copy)
        if p37 == LocalPlayer == (p38 == LocalPlayer) then
            return p37.DisplayName:lower() < p38.DisplayName:lower()
        end

        return p37 == LocalPlayer
    end)

    for _, player in Players2 do
        local t9 = {}

        if player == LocalPlayer then
            table.insert(t9, {
                "YOU",
                v5
            })
        end

        if p36 and player:GetAttribute("RDDisqualified") == true then
            table.insert(t9, {
                "DSQ",
                v1
            })
        end

        if player:GetAttribute("AFKMode") == true then
            table.insert(t9, {
                "AFK",
                v6
            })
        end

        if player:GetAttribute("RaceParticipant") == true then
            table.insert(t9, {
                "RACING",
                v2
            })
        end

        table.insert(t8, {
            id = player.UserId,
            display = player.DisplayName,
            name = player.Name,
            tags = t9
        })
    end

    return t8
end

local function entryList(p39, p40, p41, p42, p43) -- line: 140
    -- upvalues: v1 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), n1 (ref), t1 (copy)
    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "Riders"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.fromOffset(math.max(1, (math.floor(10 * n1 + 0.5))), p40)
    ScrollingFrame.Size = UDim2.new(1, -math.max(1, (math.floor(14 * n1 + 0.5))), 0, p41)
    ScrollingFrame.ScrollBarThickness = math.max(2, (math.max(1, (math.floor(2 * n1 + 0.5)))))
    ScrollingFrame.ScrollBarImageColor3 = v4
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.Parent = p39

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, (math.max(1, (math.floor(3 * n1 + 0.5)))))
    UIListLayout.Parent = ScrollingFrame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingRight = UDim.new(0, (math.max(1, (math.floor(6 * n1 + 0.5)))))
    UIPadding.Parent = ScrollingFrame

    local function render() -- line: 146
        -- upvalues: p42 (copy), p43 (copy), ScrollingFrame (copy), v1 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), n1 (ref), t1 (copy)
        for _, child in ScrollingFrame:GetChildren() do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end

        local v58, v59 = p43()
        local t15 = {}
        local t16 = {}

        for v60, v61 in v58 or {} do
            t15[v61.id] = true
            table.insert(t16, v61.id)

            local TextButton = Instance.new("TextButton")

            TextButton.Name = "Row_" .. v61.id
            TextButton.Text = ""
            TextButton.AutoButtonColor = false
            TextButton:SetAttribute("NoHover", true)
            TextButton.BackgroundColor3 = v4
            TextButton.BorderSizePixel = 0
            TextButton.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(t1.ROW * n1 + 0.5)))))
            TextButton.LayoutOrder = v60

            local v66 = UDim.new(0, (math.max(1, (math.floor(3 * n1 + 0.5)))))
            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = v66
            UICorner.Parent = TextButton
            TextButton.Parent = ScrollingFrame

            local Frame = Instance.new("Frame")

            Frame.Name = "Check"
            Frame.AnchorPoint = Vector2.new(0, 0.5)
            Frame.Position = UDim2.new(0, math.max(1, (math.floor(6 * n1 + 0.5))), 0.5, 0)
            Frame.Size = UDim2.fromOffset(math.max(1, (math.floor(10 * n1 + 0.5))), (math.max(1, (math.floor(10 * n1 + 0.5)))))
            Frame.BorderSizePixel = 0

            local v76 = UDim.new(0, (math.max(1, (math.floor(2 * n1 + 0.5)))))
            local UICorner2 = Instance.new("UICorner")

            UICorner2.CornerRadius = v76
            UICorner2.Parent = Frame

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = v5
            UIStroke.Thickness = 1
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Parent = Frame
            Frame.Parent = TextButton

            local v79 = math.max(1, (math.floor(8 * n1 + 0.5)))
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = "Tick"
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = "✓"
            TextLabel.FontFace = v7
            TextLabel.TextSize = v79
            TextLabel.TextColor3 = v4
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.AutoLocalize = false
            TextLabel.Parent = Frame
            TextLabel.Size = UDim2.fromScale(1, 1)
            TextLabel.TextXAlignment = Enum.TextXAlignment.Center

            local v80 = v61.sub and "  · " .. v61.sub or ""
            local display = v61.display

            if not display then
                display = v61.name

                if not display then
                    display = tostring(v61.id)
                end
            end

            local v85 = display .. "  <font color=\"#969AA2\" size=\"" .. math.max(1, (math.floor(6.5 * n1 + 0.5))) .. "\">@" .. tostring(v61.name or v61.id) .. v80 .. "</font>"
            local v88 = math.max(1, (math.floor(8 * n1 + 0.5)))
            local TextLabel2 = Instance.new("TextLabel")

            TextLabel2.Name = "Name"
            TextLabel2.BackgroundTransparency = 1
            TextLabel2.Text = v85
            TextLabel2.FontFace = v8
            TextLabel2.TextSize = v88
            TextLabel2.TextColor3 = v5
            TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel2.AutoLocalize = false
            TextLabel2.Parent = TextButton
            TextLabel2.RichText = true

            local v89 = v61.tags or {}

            TextLabel2.Position = UDim2.fromOffset(math.max(1, (math.floor(22 * n1 + 0.5))), 0)
            TextLabel2.Size = UDim2.new(1, -math.max(1, (math.floor(22 * n1 + 0.5))) - math.max(1, (math.floor(6 * n1 + 0.5))) - #v89 * math.max(1, (math.floor(37 * n1 + 0.5))), 1, 0)
            TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd

            local v103 = math.max(1, (math.floor(6 * n1 + 0.5)))

            for i = #v89, 1, -1 do
                local v104 = v89[i]
                local TextLabel = Instance.new("TextLabel")

                TextLabel.Name = "Tag"
                TextLabel.AnchorPoint = Vector2.new(1, 0.5)
                TextLabel.Position = UDim2.new(1, -v103, 0.5, 0)
                TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(34 * n1 + 0.5))), (math.max(1, (math.floor(10 * n1 + 0.5)))))
                TextLabel.BackgroundColor3 = v104[2]
                TextLabel.BorderSizePixel = 0
                TextLabel.FontFace = v7
                TextLabel.TextSize = math.max(1, (math.floor(6 * n1 + 0.5)))
                TextLabel.TextColor3 = v4
                TextLabel.Text = v104[1]
                TextLabel.AutoLocalize = false

                local v112 = UDim.new(1, 0)
                local UICorner = Instance.new("UICorner")

                UICorner.CornerRadius = v112
                UICorner.Parent = TextLabel
                TextLabel.Parent = TextButton
                v103 += math.max(1, (math.floor(37 * n1 + 0.5)))
            end

            local v115 = p42[v61.id] == true

            Frame.BackgroundColor3 = v115 and v1 or v4
            UIStroke.Color = v115 and v1 or v5
            TextLabel.Visible = v115
            TextButton.Activated:Connect(function() -- line: 173
                -- upvalues: v61 (copy), Frame (copy), UIStroke (copy), TextLabel (copy), p42 (copy), v1 (copy), v4 (copy), v5 (copy), t1 (copy)
                p42[v61.id] = not p42[v61.id] or nil

                local v116 = p42[v61.id] == true

                Frame.BackgroundColor3 = v116 and v1 or v4
                UIStroke.Color = v116 and v1 or v5
                TextLabel.Visible = v116

                if t1.onSelect then
                    t1.onSelect()
                end
            end)
        end

        if #t16 == 0 then
            local v117 = v59 or "NOBODY HERE"
            local v120 = math.max(1, (math.floor(7.5 * n1 + 0.5)))
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = "Empty"
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = v117
            TextLabel.FontFace = v8
            TextLabel.TextSize = v120
            TextLabel.TextColor3 = v6
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.AutoLocalize = false
            TextLabel.Parent = ScrollingFrame
            TextLabel.Size = UDim2.new(1, 0, 0, (math.max(1, (math.floor(t1.ROW * n1 + 0.5)))))
            TextLabel.TextXAlignment = Enum.TextXAlignment.Center
        end

        t1.listIds = t16

        for v123 in p42 do
            if not t15[v123] then
                p42[v123] = nil
            end
        end

        if t1.onSelect then
            t1.onSelect()
        end
    end

    render()

    return ScrollingFrame, render
end

local function riderList(p44, p45, p46, p47, p48) -- line: 185
    -- upvalues: playerEntries (copy), entryList (copy)
    return entryList(p44, p45, p46, p47, function() -- line: 185
        -- upvalues: p48 (copy), playerEntries (copy)
        return playerEntries(p48), "NO RIDERS"
    end)
end

local function allSelected(p49) -- line: 186
    -- upvalues: t1 (copy)
    local v124 = t1.listIds or {}

    if #v124 == 0 then
        return false
    end

    for _, v125 in v124 do
        if not p49[v125] then
            return false
        end
    end

    return true
end

local function selectedIds(p50) -- line: 192
    local t17 = {}

    for v126 in p50 do
        table.insert(t17, v126)
    end

    return t17
end

local function ago(p51) -- line: 194
    local v128 = math.max(0, os.time() - (tonumber(p51) or os.time()))

    if v128 < 60 then
        return "JUST NOW"
    end

    if v128 < 3600 then
        return v128 // 60 .. "M AGO"
    end

    if v128 < 86400 then
        return v128 // 3600 .. "H AGO"
    end

    return v128 // 86400 .. "D AGO"
end

local function fetchLists(p52) -- line: 199
    -- upvalues: v35 (ref), t1 (copy)
    local v129 = v35

    if not v129 or t1.fetching then
        return
    end

    t1.fetching = true
    task.spawn(function() -- line: 202
        -- upvalues: p52 (copy), v35 (ref), t1 (copy)
        local InvokeServer = v35.InvokeServer
        local v130 = v35
        local lists, lists2 = pcall(InvokeServer, v130, "lists")

        t1.fetching = false

        if lists and typeof(lists2) == "table" and lists2.ok and typeof(lists2.lists) == "table" then
            t1.lists = lists2.lists
            t1.listsAt = os.clock()

            if p52 then
                p52()
            end
        end
    end)
end

local v131

local function frameField(p53, p54, p55, p56) -- line: 211
    -- upvalues: v6 (copy), v8 (copy), n1 (ref)
    local v134 = math.max(1, (math.floor(6.5 * n1 + 0.5)))
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Caption"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p56
    TextLabel.FontFace = v8
    TextLabel.TextSize = v134
    TextLabel.TextColor3 = v6
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = p53
    TextLabel.Position = UDim2.fromOffset(p54, p55)
    TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(200 * n1 + 0.5))), (math.max(1, (math.floor(9 * n1 + 0.5)))))

    return TextLabel
end

local function shell(p57) -- line: 215
    -- upvalues: UserInputService (copy), TweenService (copy), RaceIcons (copy), JerezRaceHUD (copy), v1 (copy), v3 (copy), v4 (copy), v6 (copy), v7 (copy), v8 (copy), ScreenGui (copy), n1 (ref), t1 (copy), t5 (copy), t6 (copy)
    local v140 = t5[p57]
    local ViewportSize = workspace.CurrentCamera.ViewportSize

    n1 = math.min(ViewportSize.Y / 360, (ViewportSize.X - 24) / v140[1])
    t1.ROW = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and 20 or 16

    local Frame = Instance.new("Frame")

    Frame.Name = "RaceDirector" .. p57
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(math.max(1, (math.floor(v140[1] * n1 + 0.5))), (math.max(1, (math.floor(v140[2] * n1 + 0.5)))))
    Frame.BackgroundColor3 = v3
    Frame.BorderSizePixel = 0
    Frame.Active = true

    local v151 = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = v151
    UICorner.Parent = Frame
    Frame.Parent = ScreenGui

    local v152 = t6[p57]
    local v155 = math.max(1, (math.floor(12 * n1 + 0.5)))
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Title"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = v152
    TextLabel.FontFace = v7
    TextLabel.TextSize = v155
    TextLabel.TextColor3 = v4
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = Frame
    TextLabel.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(8 * n1 + 0.5)))))
    TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(160 * n1 + 0.5))), (math.max(1, (math.floor(14 * n1 + 0.5)))))

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Divider"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = v4
    Frame2.Position = UDim2.fromOffset(math.max(1, (math.floor(12 * n1 + 0.5))), (math.max(1, (math.floor(27 * n1 + 0.5)))))
    Frame2.Size = UDim2.fromOffset(math.max(1, (math.floor(99 * n1 + 0.5))), (math.max(1, (math.floor(n1 + 0.5)))))
    Frame2.Parent = Frame

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    UIGradient.Parent = Frame2

    local v178 = math.max(1, (math.floor(5.5 * n1 + 0.5)))
    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "Director"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "RACE DIRECTOR"
    TextLabel2.FontFace = v8
    TextLabel2.TextSize = v178
    TextLabel2.TextColor3 = v1
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.AutoLocalize = false
    TextLabel2.Parent = Frame
    TextLabel2.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(29 * n1 + 0.5)))))
    TextLabel2.Size = UDim2.fromOffset(math.max(1, (math.floor(120 * n1 + 0.5))), (math.max(1, (math.floor(8 * n1 + 0.5)))))

    local v191 = math.max(1, (math.floor(7 * n1 + 0.5)))
    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.Name = "Session"
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = ""
    TextLabel3.FontFace = v8
    TextLabel3.TextSize = v191
    TextLabel3.TextColor3 = v6
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.AutoLocalize = false
    TextLabel3.Parent = Frame
    TextLabel3.AnchorPoint = Vector2.new(1, 0)
    TextLabel3.Position = UDim2.new(1, -math.max(1, (math.floor(48 * n1 + 0.5))), 0, (math.max(1, (math.floor(12 * n1 + 0.5)))))
    TextLabel3.Size = UDim2.fromOffset(math.max(1, (math.floor(150 * n1 + 0.5))), (math.max(1, (math.floor(12 * n1 + 0.5)))))
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Right
    t1.dyn.session = TextLabel3

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Close"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.BackgroundTransparency = 1
    TextButton.BorderSizePixel = 0
    TextButton:SetAttribute("NoHover", true)
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.Position = UDim2.new(1, -math.max(1, (math.floor(26 * n1 + 0.5))), 0, (math.max(1, (math.floor(18 * n1 + 0.5)))))
    TextButton.Size = UDim2.fromOffset(math.max(1, (math.floor(30 * n1 + 0.5))), (math.max(1, (math.floor(16 * n1 + 0.5)))))
    TextButton.ZIndex = 3
    TextButton.Parent = Frame

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Plate"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ImageColor3 = v4
    ImageLabel.ZIndex = 3
    ImageLabel.Parent = TextButton

    local ref_top_plate = RaceIcons.Get("ref_top_plate")

    if ref_top_plate then
        ImageLabel.ImageContent = ref_top_plate
    else
        ImageLabel.BackgroundTransparency = 0
        ImageLabel.BackgroundColor3 = v4

        local v214 = UDim.new(0, (math.max(1, (math.floor(4 * n1 + 0.5)))))
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = v214
        UICorner.Parent = ImageLabel
    end

    local v217 = math.max(1, (math.floor(10 * n1 + 0.5)))
    local TextLabel4 = Instance.new("TextLabel")

    TextLabel4.Name = "X"
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Text = "X"
    TextLabel4.FontFace = v7
    TextLabel4.TextSize = v217
    TextLabel4.TextColor3 = v3
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel4.AutoLocalize = false
    TextLabel4.Parent = TextButton
    TextLabel4.Size = UDim2.fromScale(1, 1)
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel4.ZIndex = 4

    local function hover(p58) -- line: 241
        -- upvalues: ImageLabel (copy), TextLabel4 (copy), TweenService (copy), v1 (copy), v3 (copy), v4 (copy)
        TweenService:Create(ImageLabel, TweenInfo.new(0.18), {
            ImageColor3 = p58 and v1 or v4,
            BackgroundColor3 = p58 and v1 or v4
        }):Play()
        TweenService:Create(TextLabel4, TweenInfo.new(0.18), {
            TextColor3 = p58 and v4 or v3
        }):Play()
    end

    TextButton.MouseEnter:Connect(function() -- line: 245
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.MouseLeave:Connect(function() -- line: 245
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.SelectionGained:Connect(function() -- line: 246
        -- upvalues: hover (copy)
        hover(true)
    end)
    TextButton.SelectionLost:Connect(function() -- line: 246
        -- upvalues: hover (copy)
        hover(false)
    end)
    TextButton.Activated:Connect(function() -- line: 247
        -- upvalues: p57 (copy), JerezRaceHUD (copy)
        if p57 == "Riders" or p57 == "Perms" then
            JerezRaceHUD:SetAttribute("RaceDirectorPanel", "Settings")
        else
            JerezRaceHUD:SetAttribute("RaceDirectorPanel", nil)
        end
    end)
    TextButton.Modal = true

    local v222 = math.max(1, (math.floor(7 * n1 + 0.5)))
    local TextLabel5 = Instance.new("TextLabel")

    TextLabel5.Name = "Feedback"
    TextLabel5.BackgroundTransparency = 1
    TextLabel5.Text = ""
    TextLabel5.FontFace = v8
    TextLabel5.TextSize = v222
    TextLabel5.TextColor3 = v6
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel5.AutoLocalize = false
    TextLabel5.Parent = Frame
    TextLabel5.AnchorPoint = Vector2.new(0, 1)
    TextLabel5.Position = UDim2.new(0, math.max(1, (math.floor(13 * n1 + 0.5))), 1, -math.max(1, (math.floor(7 * n1 + 0.5))))
    TextLabel5.Size = UDim2.new(1, -math.max(1, (math.floor(26 * n1 + 0.5))), 0, (math.max(1, (math.floor(10 * n1 + 0.5)))))
    TextLabel5.TextTruncate = Enum.TextTruncate.AtEnd
    t1.feedback = TextLabel5

    return Frame
end

local t20 = {}

local function sessionWindow(p59, p60, p61, p62, p63, p64, p65) -- line: 260
    -- upvalues: v1 (copy), v4 (copy), v6 (copy), v8 (copy), n1 (ref), pill (copy), textBox (copy), t1 (copy), call (copy), frameField (copy)
    frameField(p59, math.max(1, (math.floor(13 * n1 + 0.5))), math.max(1, (math.floor(44 * n1 + 0.5))), p60)

    local v238

    if p61 ~= nil then
        local v253 = textBox(p59, "Value", 70, 20, p61, "")

        v238 = v253
        v253.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(55 * n1 + 0.5)))))

        local v261 = math.max(1, (math.floor(7.5 * n1 + 0.5)))
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "Unit"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p62
        TextLabel.FontFace = v8
        TextLabel.TextSize = v261
        TextLabel.TextColor3 = v4
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.AutoLocalize = false
        TextLabel.Parent = p59
        TextLabel.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))) + math.max(1, (math.floor(76 * n1 + 0.5))), (math.max(1, (math.floor(55 * n1 + 0.5)))))
        TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(60 * n1 + 0.5))), (math.max(1, (math.floor(20 * n1 + 0.5)))))
    else
        local v239 = p62 or ""
        local v242 = math.max(1, (math.floor(7.5 * n1 + 0.5)))
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "Info"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = v239
        TextLabel.FontFace = v8
        TextLabel.TextSize = v242
        TextLabel.TextColor3 = v4
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.AutoLocalize = false
        TextLabel.Parent = p59
        TextLabel.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(55 * n1 + 0.5)))))
        TextLabel.Size = UDim2.new(1, -math.max(1, (math.floor(26 * n1 + 0.5))), 0, (math.max(1, (math.floor(20 * n1 + 0.5)))))
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "Buttons"
    Frame.BackgroundTransparency = 1
    Frame.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(86 * n1 + 0.5)))))
    Frame.Size = UDim2.new(1, -math.max(1, (math.floor(26 * n1 + 0.5))), 0, (math.max(1, (math.floor(16 * n1 + 0.5)))))
    Frame.Parent = p59

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Padding = UDim.new(0, (math.max(1, (math.floor(8 * n1 + 0.5)))))
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame

    for v287, v288 in p63 do
        local v289 = pill(Frame, v288.name, p65 or 84, 16, v288.text)

        v289.LayoutOrder = v287
        v289.TextSize = math.max(1, (math.floor(7.5 * n1 + 0.5)))

        local n2 = 0

        v289.Activated:Connect(function() -- line: 275
            -- upvalues: p64 (copy), v238 (ref), v288 (copy), v289 (copy), n2 (ref), v1 (copy), v6 (copy), t1 (copy), call (copy)
            local v292

            if v288.needsValue and v238 then
                local v293 = p64(v238.Text)

                if v293 then
                    v292 = v293
                else
                    local bad = v288.bad

                    if t1.feedback then
                        t1.feedback.Text = bad or ""
                        t1.feedback.TextColor3 = v1 or v6
                    end

                    return
                end
            end

            if v288.confirm and os.clock() - n2 > 3 then
                n2 = os.clock()
                v289.Text = "CONFIRM " .. v288.text

                local v294 = "PRESS AGAIN TO " .. v288.text

                if t1.feedback then
                    t1.feedback.Text = v294 or ""
                    t1.feedback.TextColor3 = v6 or v6
                end

                task.delay(3, function() -- line: 283
                    -- upvalues: v288 (copy), v289 (copy), n2 (ref)
                    if v289.Parent and os.clock() - n2 >= 3 then
                        v289.Text = v288.text
                    end
                end)
            else
                n2 = 0
                v289.Text = v288.text

                local action = v288.action
                local t21, v295

                if v288.needsValue and v238 then
                    local t22 = {
                        [v288.key] = v292
                    }

                    if t22 then
                        t21 = t22
                        v295 = true
                    else
                        v295 = false
                    end
                else
                    v295 = false
                end

                if not v295 then
                    t21 = nil
                end

                call(action, t21)
            end
        end)
    end

    return v238
end

local function parseNumber(p66) -- line: 290
    return (tonumber((tostring(p66):gsub(",", "."):gsub("%s", ""))))
end

t20.Qualifying = function(p67) -- line: 293
    -- upvalues: MotoLegends (copy), t2 (copy), sessionWindow (copy)
    local minutes = t2.minutes

    if not minutes then
        minutes = tostring(MotoLegends:GetAttribute("RDQualiMinutes") or 10)
    end

    local v298 = sessionWindow(p67, "DURATION", minutes, "MIN", {
        {
            name = "Start",
            text = "START",
            action = "qualiStart",
            needsValue = true,
            key = "minutes",
            bad = "ENTER 1 TO 120 MINUTES"
        },
        {
            name = "Restart",
            text = "RESTART",
            action = "qualiRestart",
            needsValue = true,
            key = "minutes",
            bad = "ENTER 1 TO 120 MINUTES"
        },
        {
            name = "End",
            text = "END",
            action = "qualiEnd",
            confirm = true
        },
        {
            name = "Abort",
            text = "ABORT",
            action = "qualiAbort",
            confirm = true
        }
    }, function(p68) -- line: 299
        local v300 = tonumber((tostring(p68):gsub(",", "."):gsub("%s", "")))

        if v300 and v300 >= 1 and v300 <= 120 then
            return v300
        end
    end, 68)

    v298:GetPropertyChangedSignal("Text"):Connect(function() -- line: 300
        -- upvalues: v298 (copy), t2 (copy)
        t2.minutes = v298.Text
    end)
end

t20.Race = function(p69) -- line: 302
    -- upvalues: MotoLegends (copy), t1 (copy), t2 (copy), call (copy), sessionWindow (copy)
    local laps = t2.laps

    if not laps then
        laps = tostring(MotoLegends:GetAttribute("SessionLaps") or 5)
    end

    local v302 = sessionWindow(p69, "RACE LENGTH", laps, "LAPS", {
        {
            name = "Start",
            text = "START",
            action = "raceStart",
            needsValue = true,
            key = "laps",
            bad = "ENTER 1 TO 99 LAPS"
        },
        {
            name = "Restart",
            text = "RESTART",
            action = "raceRestart",
            needsValue = true,
            key = "laps",
            bad = "ENTER 1 TO 99 LAPS"
        },
        {
            name = "End",
            text = "END",
            action = "raceEnd",
            confirm = true
        },
        {
            name = "Abort",
            text = "ABORT",
            action = "raceAbort",
            confirm = true
        }
    }, function(p70) -- line: 308
        local v304 = tonumber((tostring(p70):gsub(",", "."):gsub("%s", "")))

        if v304 and v304 % 1 == 0 and v304 >= 1 and v304 <= 99 then
            return v304
        end
    end, 68)

    v302:GetPropertyChangedSignal("Text"):Connect(function() -- line: 309
        -- upvalues: v302 (copy), t2 (copy)
        t2.laps = v302.Text
    end)
    v302.FocusLost:Connect(function() -- line: 312
        -- upvalues: v302 (copy), MotoLegends (copy), t1 (copy), call (copy)
        task.delay(0.2, function() -- line: 313
            -- upvalues: v302 (copy), MotoLegends (copy), t1 (copy), call (copy)
            local v306 = tonumber((tostring(v302.Text):gsub(",", "."):gsub("%s", "")))

            if v306 and v306 % 1 == 0 and v306 >= 1 and v306 <= 99 and v306 ~= MotoLegends:GetAttribute("SessionLaps") and not t1.pending then
                call("raceLaps", {
                    laps = v306
                })
            end
        end)
    end)
end

local function clockText(p71) -- line: 321
    local v307 = tonumber(p71) or 12
    local v308 = math.floor(v307)
    local v310 = math.floor((v307 - v308) * 60 + 0.5)

    if v310 >= 60 then
        v308 += 1
        v310 -= 60
    end

    return string.format("%02d:%02d", v308 % 24, v310)
end

local function parseClock(p72) -- line: 322
    local v311 = tostring(p72):gsub("%s", "")
    local v312, v313 = v311:match("^(%d+)[:%.](%d+)$")

    if v312 then
        local v314 = tonumber(v312)
        local v315 = tonumber(v313)

        return if v314 < 24 and v315 < 60 then v314 + v315 / 60 else nil
    end

    local v316 = tonumber(v311)

    if v316 and v316 >= 0 and v316 < 24 then
        return v316
    end
end

t20.Settings = function(p73) -- line: 328
    -- upvalues: LocalPlayer (copy), MotoLegends (copy), JerezRaceHUD (copy), v1 (copy), v4 (copy), v6 (copy), v7 (copy), v8 (copy), n1 (ref), pill (copy), textBox (copy), t1 (copy), t2 (copy), call (copy), parseClock (copy)
    local v319 = math.max(1, (math.floor(44 * n1 + 0.5)))
    local v322 = math.max(1, (math.floor(24 * n1 + 0.5)))

    local function rowLabel(p74, p75) -- line: 330
        -- upvalues: p73 (copy), v319 (copy), v322 (copy), v4 (copy), v7 (copy), n1 (ref)
        local v323 = "Label" .. p74
        local v326 = math.max(1, (math.floor(8 * n1 + 0.5)))
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = v323
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = p75
        TextLabel.FontFace = v7
        TextLabel.TextSize = v326
        TextLabel.TextColor3 = v4
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.AutoLocalize = false
        TextLabel.Parent = p73
        TextLabel.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), v319 + (p74 - 1) * v322)
        TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(90 * n1 + 0.5))), (math.max(1, (math.floor(16 * n1 + 0.5)))))

        return TextLabel
    end

    local function at(p76, p77, _) -- line: 331
        -- upvalues: v319 (copy), v322 (copy)
        return UDim2.new(0, p77, 0, v319 + (p76 - 1) * v322)
    end

    rowLabel(1, "WEATHER")
    t1.dyn.weather = {}

    for v334, v335 in { "Sunny", "Cloudy", "Rainy", "Dynamic" } do
        local v336 = pill(p73, "Weather" .. v335, 48, 16, string.upper(v335))
        local v343 = math.max(1, (math.floor(110 * n1 + 0.5))) + (v334 - 1) * math.max(1, (math.floor(52 * n1 + 0.5)))

        v336.Position = UDim2.new(0, v343, 0, v319 + 0 * v322)
        v336.TextSize = math.max(1, (math.floor(6.5 * n1 + 0.5)))
        t1.dyn.weather[v335] = v336
        v336.Activated:Connect(function() -- line: 339
            -- upvalues: v335 (copy), call (copy)
            call("weather", {
                weather = v335
            })
        end)
    end

    rowLabel(2, "TIME")

    local time = t2.time

    if not time then
        local v346 = tonumber((MotoLegends:GetAttribute("RDClockTime"))) or 12
        local v347 = math.floor(v346)
        local v349 = math.floor((v346 - v347) * 60 + 0.5)

        if v349 >= 60 then
            v347 += 1
            v349 -= 60
        end

        time = string.format("%02d:%02d", v347 % 24, v349)
    end

    local v350 = textBox(p73, "Clock", 62, 16, time, "HH:MM")
    local v353 = math.max(1, (math.floor(110 * n1 + 0.5)))

    v350.Position = UDim2.new(0, v353, 0, v319 + 1 * v322)
    v350.TextSize = math.max(1, (math.floor(8 * n1 + 0.5)))
    v350:GetPropertyChangedSignal("Text"):Connect(function() -- line: 344
        -- upvalues: v350 (copy), t2 (copy)
        t2.time = v350.Text
    end)

    local SET = pill(p73, "SetTime", 62, 16, "SET")
    local v358 = math.max(1, (math.floor(178 * n1 + 0.5)))

    SET.Position = UDim2.new(0, v358, 0, v319 + 1 * v322)
    SET.Activated:Connect(function() -- line: 346
        -- upvalues: v350 (copy), v1 (copy), v6 (copy), t1 (copy), t2 (copy), call (copy), parseClock (copy)
        local v359 = parseClock(v350.Text)

        if v359 then
            call("time", {
                clock = v359
            }, function(p79) -- line: 348
                -- upvalues: t2 (copy)
                if p79 then
                    t2.time = nil
                end
            end)
        elseif t1.feedback then
            t1.feedback.Text = "ENTER A TIME LIKE 20:30"
            t1.feedback.TextColor3 = v1 or v6
        end
    end)

    local v362 = math.max(1, (math.floor(6.5 * n1 + 0.5)))
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "ClockNow"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.FontFace = v8
    TextLabel.TextSize = v362
    TextLabel.TextColor3 = v6
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = p73

    local v365 = math.max(1, (math.floor(246 * n1 + 0.5)))

    TextLabel.Position = UDim2.new(0, v365, 0, v319 + 1 * v322)
    TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(70 * n1 + 0.5))), (math.max(1, (math.floor(16 * n1 + 0.5)))))
    t1.dyn.clockNow = TextLabel
    t1.dyn.toggles = {}

    for _, v371 in {
            { 3, "MARSHALS", "Marshals", "RDMarshalsDisabled" },
            { 4, "LEGENDS", "Legends", "RDLegendsDisabled" },
            { 5, "BIKES", "Bikes", "RDBikesDisabled" }
        } do
        rowLabel(v371[1], v371[2])

        local ON = pill(p73, v371[3] .. "On", 62, 16, "ON")
        local v372 = v371[1]
        local v375 = math.max(1, (math.floor(110 * n1 + 0.5)))

        ON.Position = UDim2.new(0, v375, 0, v319 + (v372 - 1) * v322)

        local OFF = pill(p73, v371[3] .. "Off", 62, 16, "OFF")
        local v376 = v371[1]
        local v379 = math.max(1, (math.floor(178 * n1 + 0.5)))

        OFF.Position = UDim2.new(0, v379, 0, v319 + (v376 - 1) * v322)
        t1.dyn.toggles[v371[3]] = {
            on = ON,
            off = OFF,
            attr = v371[4]
        }
        ON.Activated:Connect(function() -- line: 358
            -- upvalues: v371 (copy), call (copy)
            call("toggle", {
                on = true,
                key = v371[3]
            })
        end)
        OFF.Activated:Connect(function() -- line: 359
            -- upvalues: v371 (copy), call (copy)
            call("toggle", {
                on = false,
                key = v371[3]
            })
        end)
    end

    rowLabel(6, "RED FLAG")

    local ON = pill(p73, "RedFlagOn", 62, 16, "ON")
    local v382 = math.max(1, (math.floor(110 * n1 + 0.5)))

    ON.Position = UDim2.new(0, v382, 0, v319 + 5 * v322)

    local OFF = pill(p73, "RedFlagOff", 62, 16, "OFF")
    local v385 = math.max(1, (math.floor(178 * n1 + 0.5)))

    OFF.Position = UDim2.new(0, v385, 0, v319 + 5 * v322)
    t1.dyn.redFlag = {
        on = ON,
        off = OFF
    }
    ON.Activated:Connect(function() -- line: 367
        -- upvalues: call (copy)
        call("redFlag", {
            on = true
        })
    end)
    OFF.Activated:Connect(function() -- line: 368
        -- upvalues: call (copy)
        call("redFlag", {
            on = false
        })
    end)
    rowLabel(7, "RIDERS")

    local v386 = pill(p73, "Riders", 100, 16, "MANAGE RIDERS")
    local v389 = math.max(1, (math.floor(110 * n1 + 0.5)))

    v386.Position = UDim2.new(0, v389, 0, v319 + 6 * v322)
    v386.Activated:Connect(function() -- line: 373
        -- upvalues: JerezRaceHUD (copy)
        JerezRaceHUD:SetAttribute("RaceDirectorPanel", "Riders")
    end)

    if LocalPlayer:GetAttribute("RaceDirectorOwner") ~= true then
        return
    end

    local PERMISSIONS = pill(p73, "Permissions", 100, 16, "PERMISSIONS")
    local v392 = math.max(1, (math.floor(216 * n1 + 0.5)))

    PERMISSIONS.Position = UDim2.new(0, v392, 0, v319 + 6 * v322)
    PERMISSIONS.Activated:Connect(function() -- line: 376
        -- upvalues: JerezRaceHUD (copy)
        JerezRaceHUD:SetAttribute("RaceDirectorPanel", "Perms")
    end)
end

local t23 = {
    Riders = t3,
    Dsq = {},
    Bans = {}
}
local t24 = {
    Riders = {
        { "dsq", "DISQUALIFY", false },
        { "kick", "KICK", true },
        { "ban", "BAN", true }
    },
    Dsq = { { "undsq", "REINSTATE", false } },
    Bans = { { "unban", "UNBAN", true } }
}

local function updateTabCounts() -- line: 388
    -- upvalues: t1 (copy)
    local tabs = t1.dyn.tabs

    if not tabs then
        return
    end

    local lists = t1.lists

    tabs.Dsq.Text = "DISQUALIFIED" .. (lists and " (" .. #lists.dsq .. ")" or "")
    tabs.Bans.Text = "BANNED" .. (lists and " (" .. #lists.bans .. ")" or "")
end

t20.Riders = function(p80) -- line: 394
    -- upvalues: v1 (copy), v2 (copy), v4 (copy), v5 (copy), v6 (copy), v8 (copy), n1 (ref), pill (copy), textBox (copy), v35 (ref), t1 (copy), t2 (copy), t5 (copy), call (copy), playerEntries (copy), entryList (copy), ago (copy), v131 (ref), t23 (copy), t24 (copy)
    local v393 = t2.ridersTab or "Riders"
    local v394 = t23[v393]
    local Frame = Instance.new("Frame")

    Frame.Name = "Tabs"
    Frame.BackgroundTransparency = 1
    Frame.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(40 * n1 + 0.5)))))

    local fromOffset = UDim2.new
    local v400 = -math.max(1, (math.floor(26 * n1 + 0.5)))
    local v401 = 14 * n1 + 0.5

    Frame.Size = fromOffset(1, v400, 0, (math.max(1, (math.floor(v401)))))
    Frame.Parent = p80
    fromOffset = Instance.new("UIListLayout")
    fromOffset.FillDirection = Enum.FillDirection.Horizontal

    local v397 = UDim.new
    local v399 = 6 * n1 + 0.5

    fromOffset.Padding = v397(0, (math.max(1, (math.floor(v399)))))
    fromOffset.SortOrder = Enum.SortOrder.LayoutOrder
    fromOffset.Parent = Frame
    t1.dyn.tabs = {}

    local Frame2

    for v402, v403 in {
            { "Riders", "RIDERS", 70 },
            { "Dsq", "DISQUALIFIED", 100 },
            { "Bans", "BANNED", 80 }
        } do
        v399 = pill(Frame, "Tab" .. v403[1], v403[3], 14, v403[2])
        v399.LayoutOrder = v402

        local v404 = v403[1] == v393

        v399:SetAttribute("On", v404 == true)
        v401 = v404 == true
        v399.BackgroundColor3 = v401 and v1 or v4
        v399.TextColor3 = v401 and v4 or v5
        Frame2 = v399:FindFirstChildOfClass("UIStroke")

        if Frame2 then
            Frame2.Color = v401 and v1 or v5
        end

        t1.dyn.tabs[v403[1]] = v399
        v399 = v399.Activated
        v399:Connect(function() -- line: 404
            -- upvalues: v403 (copy), t2 (copy), v131 (ref)
            if t2.ridersTab ~= v403[1] then
                t2.ridersTab = v403[1]
                v131("Riders")
            end
        end)
    end

    Frame = t1.dyn.tabs

    local Dsq, v405

    if Frame then
        local lists = t1.lists

        Frame.Dsq.Text = "DISQUALIFIED" .. (lists and " (" .. #lists.dsq .. ")" or "")
        Dsq = Frame.Bans

        if lists then
            v405 = " (" .. #lists.bans .. ")"
        end

        if not lists or not v405 then
            v405 = ""
        end

        Dsq.Text = "BANNED" .. v405
    end

    local v406 = pill(p80, "SelectAll", 70, 13, "SELECT ALL")

    v406.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(62 * n1 + 0.5)))))

    local v395 = math.max(1, (math.floor(7 * n1 + 0.5)))
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Count"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.FontFace = v8
    TextLabel.TextSize = v395
    TextLabel.TextColor3 = v6
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = p80

    local v396 = UDim2.fromOffset
    local v407 = math.max(1, (math.floor(13 * n1 + 0.5)))
    local v408 = 78 * n1 + 0.5

    TextLabel.Position = v396(v407 + math.max(1, (math.floor(v408))), (math.max(1, (math.floor(62 * n1 + 0.5)))))
    v396 = UDim2.fromOffset
    v405 = math.floor(56 * n1 + 0.5)
    v395 = math.max(1, v405)
    Frame2 = 13 * n1 + 0.5
    v401 = math.floor(Frame2)
    TextLabel.Size = v396(v395, (math.max(1, v401)))

    t1.onSelect = function() -- line: 410
        -- upvalues: v394 (copy), v406 (copy), TextLabel (copy), v1 (copy), v4 (copy), v5 (copy), t1 (copy)
        local n3 = 0

        for _ in v394 do
            n3 += 1
        end

        local v409 = t1.listIds or {}
        local v410

        if #v409 == 0 then
            v410 = false
        else
            local v411 = false

            for _, v412 in v409 do
                if not v394[v412] then
                    v410 = false
                    v411 = true
                    break
                end
            end

            if not v411 then
                v410 = true
            end
        end

        TextLabel.Text = n3 .. " SELECTED"
        v406:SetAttribute("On", v410 == true)

        local v413 = v410 == true

        v406.BackgroundColor3 = v413 and v1 or v4
        v406.TextColor3 = v413 and v4 or v5

        local UIStroke = v406:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = v413 and v1 or v5
        end

        v406.Text = v410 and "CLEAR" or "SELECT ALL"
    end

    local v416, v417, v418, v419

    if v393 == "Riders" then
        v396 = pill(p80, "GiveLLP", 64, 13, "GIVE LLP")
        v396.AnchorPoint = Vector2.new(1, 0)
        v395 = UDim2.new
        v416 = 13 * n1 + 0.5
        v408 = math.floor(v416)
        v405 = -math.max(1, v408)
        v418 = 62 * n1 + 0.5
        v416 = math.floor(v418)
        v396.Position = v395(1, v405, 0, (math.max(1, v416)))
        v395 = pill(p80, "RemoveLLP", 74, 13, "REMOVE LLP")
        v395.AnchorPoint = Vector2.new(1, 0)
        v407 = UDim2.new
        v417 = 13 * n1 + 0.5
        v418 = math.floor(v417)
        Frame2 = -math.max(1, v418)
        v417 = 68 * n1 + 0.5
        v418 = math.floor(v417)
        v401 = Frame2 - math.max(1, v418)
        v417 = 62 * n1 + 0.5
        v418 = math.floor(v417)
        v395.Position = v407(1, v401, 0, (math.max(1, v418)))

        local v420 = textBox(p80, "LLPCount", 26, 13, t2.llp or "1", "1")

        v420.AnchorPoint = Vector2.new(1, 0)
        v405 = UDim2.new
        v419 = 13 * n1 + 0.5
        v417 = math.floor(v419)
        v408 = -math.max(1, v417)
        v419 = 146 * n1 + 0.5
        v417 = math.floor(v419)
        Frame2 = v408 - math.max(1, v417)
        v419 = 62 * n1 + 0.5
        v417 = math.floor(v419)
        v420.Position = v405(1, Frame2, 0, (math.max(1, v417)))
        v408 = 8 * n1 + 0.5
        Frame2 = math.floor(v408)
        v420.TextSize = math.max(1, Frame2)
        v420:GetPropertyChangedSignal("Text"):Connect(function() -- line: 422
            -- upvalues: v420 (copy), t2 (copy)
            t2.llp = v420.Text
        end)

        local function send(p81) -- line: 423
            -- upvalues: v394 (copy), v420 (copy), v1 (copy), v6 (copy), t1 (copy), call (copy)
            local v422 = tonumber((tostring(v420.Text):gsub(",", "."):gsub("%s", "")))

            if v422 and v422 % 1 == 0 and not (v422 < 1) and not (v422 > 99) then
                local t25 = {}

                for v423 in v394 do
                    table.insert(t25, v423)
                end

                if #t25 == 0 then
                    if t1.feedback then
                        t1.feedback.Text = "SELECT AT LEAST ONE RIDER"
                        t1.feedback.TextColor3 = v1 or v6
                    end
                else
                    call("riders", {
                        op = p81,
                        ids = t25,
                        count = v422
                    })
                end
            else
                if not t1.feedback then
                    return
                end

                t1.feedback.Text = "ENTER 1 TO 99 PENALTIES"
                t1.feedback.TextColor3 = v1 or v6
            end
        end

        v396.Activated:Connect(function() -- line: 430
            -- upvalues: send (copy)
            send("llp")
        end)
        v395.Activated:Connect(function() -- line: 431
            -- upvalues: send (copy)
            send("llpRemove")
        end)
    end

    v405 = 80 * n1 + 0.5
    v396 = math.max(1, (math.floor(v405)))
    v395 = math.max(1, (math.floor(t5.Riders[2] * n1 + 0.5))) - v396 - math.max(1, (math.floor(46 * n1 + 0.5)))

    if v393 == "Riders" then
        v407 = function() -- line: 435
            -- upvalues: playerEntries (copy)
            return playerEntries(true), "NO RIDERS"
        end
    else
        v407 = function() -- line: 437
            -- upvalues: v393 (copy), v2 (copy), v6 (copy), t1 (copy), ago (copy)
            local lists = t1.lists

            if not lists then
                return {}, "LOADING..."
            end

            local t26 = {}

            for _, v424 in v393 == "Dsq" and lists.dsq or lists.bans do
                local v425

                if v393 == "Dsq" then
                    v425 = {}
                    v425[1] = {
                        if v424.online then "ONLINE" else "OFFLINE",
                        v424.online and v2 or v6
                    }
                    v425 = v425 or {}
                else
                    v425 = {}
                end

                table.insert(t26, {
                    id = v424.id,
                    display = v424.display,
                    name = v424.name,
                    tags = v425,
                    sub = "BY " .. string.upper((tostring(v424.by or "?"))) .. " · " .. ago(v424.at)
                })
            end

            if v393 == "Dsq" then
                return t26, "NO DISQUALIFIED RIDERS"
            end

            return t26, "NO BANNED PLAYERS"
        end
    end

    local v429

    v405, v429 = entryList(p80, v396, v395, v394, v407)
    t1.renderList = v429

    function t1.reloadLists() -- line: 448
        -- upvalues: v429 (ref), v35 (ref), t1 (copy)
        local function v430() -- line: 448
            -- upvalues: v429 (ref), t1 (copy)
            local tabs = t1.dyn.tabs

            if tabs then
                local lists = t1.lists

                tabs.Dsq.Text = "DISQUALIFIED" .. (lists and " (" .. #lists.dsq .. ")" or "")
                tabs.Bans.Text = "BANNED" .. (lists and " (" .. #lists.bans .. ")" or "")
            end

            if t1.panel == "Riders" and t1.renderList == v429 then
                v429()
            end
        end

        if not v35 or t1.fetching then
            return
        end

        t1.fetching = true
        task.spawn(function() -- line: 202
            -- upvalues: v430 (copy), v35 (ref), t1 (copy)
            local InvokeServer = v35.InvokeServer
            local v431 = v35
            local lists, lists2 = pcall(InvokeServer, v431, "lists")

            t1.fetching = false

            if lists and typeof(lists2) == "table" and lists2.ok and typeof(lists2.lists) == "table" then
                t1.lists = lists2.lists
                t1.listsAt = os.clock()

                if v430 then
                    v430()
                end
            end
        end)
    end

    local function v432() -- line: 448
        -- upvalues: v429 (ref), t1 (copy)
        local tabs = t1.dyn.tabs

        if tabs then
            local lists = t1.lists

            tabs.Dsq.Text = "DISQUALIFIED" .. (lists and " (" .. #lists.dsq .. ")" or "")
            tabs.Bans.Text = "BANNED" .. (lists and " (" .. #lists.bans .. ")" or "")
        end

        if t1.panel == "Riders" and t1.renderList == v429 then
            v429()
        end
    end

    if v35 and not t1.fetching then
        t1.fetching = true
        task.spawn(function() -- line: 202
            -- upvalues: v432 (copy), v35 (ref), t1 (copy)
            local InvokeServer = v35.InvokeServer
            local v433 = v35
            local lists, lists2 = pcall(InvokeServer, v433, "lists")

            t1.fetching = false

            if lists and typeof(lists2) == "table" and lists2.ok and typeof(lists2.lists) == "table" then
                t1.lists = lists2.lists
                t1.listsAt = os.clock()

                if v432 then
                    v432()
                end
            end
        end)
    end

    v406.Activated:Connect(function() -- line: 451
        -- upvalues: v394 (copy), v429 (ref), t1 (copy)
        local v434 = t1.listIds or {}
        local v435

        if #v434 == 0 then
            v435 = false
        else
            local v436 = false

            for _, v437 in v434 do
                if not v394[v437] then
                    v435 = false
                    v436 = true
                    break
                end
            end

            if not v436 then
                v435 = true
            end
        end

        if v435 then
            table.clear(v394)
        else
            for _, v438 in t1.listIds or {} do
                v394[v438] = true
            end
        end

        v429()
    end)
    Frame2 = Instance.new("Frame")
    Frame2.Name = "Actions"
    Frame2.BackgroundTransparency = 1
    Frame2.AnchorPoint = Vector2.new(0, 1)
    Frame2.Position = UDim2.new(0, math.max(1, (math.floor(13 * n1 + 0.5))), 1, -math.max(1, (math.floor(22 * n1 + 0.5))))

    local new = UDim2.new

    v416 = -math.max(1, (math.floor(26 * n1 + 0.5)))

    local Activated = math.floor(16 * n1 + 0.5)

    Frame2.Size = new(1, v416, 0, (math.max(1, Activated)))
    Frame2.Parent = p80
    new = Instance.new("UIListLayout")
    new.FillDirection = Enum.FillDirection.Horizontal
    new.Padding = UDim.new(0, (math.max(1, (math.floor(6 * n1 + 0.5)))))
    new.SortOrder = Enum.SortOrder.LayoutOrder
    new.Parent = Frame2

    for v441, v442 in t24[v393] do
        local v443 = pill(Frame2, v442[2], 84, 16, v442[2])

        v443.LayoutOrder = v441

        local n4 = 0

        Activated = v443.Activated

        local v444 = v429

        Activated:Connect(function() -- line: 462
            -- upvalues: v393 (copy), v394 (copy), v442 (copy), v443 (copy), n4 (ref), v444 (copy), v1 (copy), v6 (copy), v35 (ref), t1 (copy), call (copy)
            local t29 = {}

            for v445 in v394 do
                table.insert(t29, v445)
            end

            if #t29 == 0 then
                local v446 = "SELECT AT LEAST ONE " .. (if v393 == "Bans" then "PLAYER" else "RIDER")

                if t1.feedback then
                    t1.feedback.Text = v446 or ""
                    t1.feedback.TextColor3 = v1 or v6
                end
            elseif v442[3] and os.clock() - n4 > 3 then
                n4 = os.clock()
                v443.Text = "CONFIRM"

                local v448 = "PRESS AGAIN TO " .. v442[2] .. " " .. #t29 .. (if v393 == "Bans" then " PLAYER" else " RIDER") .. (if #t29 == 1 then "" else "S")

                if t1.feedback then
                    t1.feedback.Text = v448 or ""
                    t1.feedback.TextColor3 = v6 or v6
                end

                task.delay(3, function() -- line: 466
                    -- upvalues: v442 (copy), v443 (copy), n4 (ref)
                    if v443.Parent and os.clock() - n4 >= 3 then
                        v443.Text = v442[2]
                    end
                end)
            else
                n4 = 0
                v443.Text = v442[2]
                call("riders", {
                    op = v442[1],
                    ids = t29
                }, function(p82) -- line: 468
                    -- upvalues: v394 (copy), v444 (copy), v35 (ref), t1 (copy)
                    if p82 then
                        table.clear(v394)
                    end

                    task.wait(0.3)

                    if t1.panel ~= "Riders" or t1.renderList ~= v444 then
                        return
                    end

                    v444()

                    local function v449() -- line: 448
                        -- upvalues: v444 (copy), t1 (copy)
                        local tabs = t1.dyn.tabs

                        if tabs then
                            local lists = t1.lists

                            tabs.Dsq.Text = "DISQUALIFIED" .. (lists and " (" .. #lists.dsq .. ")" or "")
                            tabs.Bans.Text = "BANNED" .. (lists and " (" .. #lists.bans .. ")" or "")
                        end

                        if t1.panel == "Riders" and t1.renderList == v444 then
                            v444()
                        end
                    end

                    if not v35 or t1.fetching then
                        return
                    end

                    t1.fetching = true
                    task.spawn(function() -- line: 202
                        -- upvalues: v449 (copy), v35 (ref), t1 (copy)
                        local InvokeServer = v35.InvokeServer
                        local v450 = v35
                        local lists, lists2 = pcall(InvokeServer, v450, "lists")

                        t1.fetching = false

                        if lists and typeof(lists2) == "table" and lists2.ok and typeof(lists2.lists) == "table" then
                            t1.lists = lists2.lists
                            t1.listsAt = os.clock()

                            if v449 then
                                v449()
                            end
                        end
                    end)
                end)
            end
        end)
    end
end

local t30 = {}

local function fetchPerms(p83) -- line: 479
    -- upvalues: v35 (ref), t1 (copy)
    local v451 = v35

    if not v451 or t1.fetchingPerms then
        return
    end

    t1.fetchingPerms = true
    task.spawn(function() -- line: 482
        -- upvalues: p83 (copy), v35 (ref), t1 (copy)
        local InvokeServer = v35.InvokeServer
        local v452 = v35
        local permsList, permsList2 = pcall(InvokeServer, v452, "permsList")

        t1.fetchingPerms = false

        if permsList and typeof(permsList2) == "table" and permsList2.ok and typeof(permsList2.lists) == "table" then
            t1.perms = permsList2.lists
            t1.permsAt = os.clock()

            if p83 then
                p83()
            end
        end
    end)
end

t20.Perms = function(p84) -- line: 488
    -- upvalues: Players (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v4 (copy), v5 (copy), v6 (copy), v8 (copy), n1 (ref), pill (copy), v35 (ref), t1 (copy), t5 (copy), call (copy), entryList (copy), ago (copy), t30 (copy)
    local v455 = math.max(1, (math.floor(7 * n1 + 0.5)))
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Owner"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.FontFace = v8
    TextLabel.TextSize = v455
    TextLabel.TextColor3 = v6
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = p84
    TextLabel.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(42 * n1 + 0.5)))))
    TextLabel.Size = UDim2.new(1, -math.max(1, (math.floor(26 * n1 + 0.5))), 0, (math.max(1, (math.floor(12 * n1 + 0.5)))))
    TextLabel.RichText = true

    local v466 = pill(p84, "SelectAll", 70, 13, "SELECT ALL")

    v466.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(60 * n1 + 0.5)))))

    local v474 = math.max(1, (math.floor(7 * n1 + 0.5)))
    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "Count"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = ""
    TextLabel2.FontFace = v8
    TextLabel2.TextSize = v474
    TextLabel2.TextColor3 = v6
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.AutoLocalize = false
    TextLabel2.Parent = p84
    TextLabel2.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))) + math.max(1, (math.floor(78 * n1 + 0.5))), (math.max(1, (math.floor(60 * n1 + 0.5)))))
    TextLabel2.Size = UDim2.fromOffset(math.max(1, (math.floor(150 * n1 + 0.5))), (math.max(1, (math.floor(13 * n1 + 0.5)))))

    t1.onSelect = function() -- line: 492
        -- upvalues: v466 (copy), TextLabel2 (copy), v1 (copy), v4 (copy), v5 (copy), t1 (copy), t30 (copy)
        local n5 = 0

        for _ in t30 do
            n5 += 1
        end

        local v488 = t1.listIds or {}
        local v489

        if #v488 == 0 then
            v489 = false
        else
            local v490 = false

            for _, v491 in v488 do
                if not t30[v491] then
                    v489 = false
                    v490 = true
                    break
                end
            end

            if not v490 then
                v489 = true
            end
        end

        TextLabel2.Text = n5 .. " SELECTED"
        v466:SetAttribute("On", v489 == true)

        local v492 = v489 == true

        v466.BackgroundColor3 = v492 and v1 or v4
        v466.TextColor3 = v492 and v4 or v5

        local UIStroke = v466:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = v492 and v1 or v5
        end

        v466.Text = v489 and "CLEAR" or "SELECT ALL"
    end

    local function entries() -- line: 497
        -- upvalues: TextLabel (copy), Players (copy), LocalPlayer (copy), v2 (copy), v5 (copy), v6 (copy), t1 (copy), ago (copy)
        local perms = t1.perms

        if not perms then
            return {}, "LOADING..."
        end

        local upper = string.upper
        local ownerName = perms.ownerName
        local v495, v496

        if ownerName then
            v495 = ownerName
            v496 = true
        elseif perms.owner == 0 then
            v496 = false
        else
            local v497 = "USER " .. perms.owner

            if v497 then
                v495 = v497
                v496 = true
            else
                v496 = false
            end
        end

        if not v496 then
            v495 = "UNKNOWN"
        end

        TextLabel.Text = "OWNER  <font color=\"#FFFFFF\">" .. upper(v495) .. "</font>" .. (perms.saved == false and "  ·  <font color=\"#E70000\">NOT SAVED (DATASTORE OFF)</font>" or "")

        local t31 = {}

        for _, v498 in perms.granted or {} do
            t31[v498.id] = v498
        end

        local t32 = {}

        for _, v499 in perms.holders or {} do
            t32[v499] = true
        end

        local t33 = {}
        local Players2 = Players:GetPlayers()

        table.sort(Players2, function(p85, p86) -- line: 125
            -- upvalues: LocalPlayer (copy)
            if p85 == LocalPlayer == (p86 == LocalPlayer) then
                return p85.DisplayName:lower() < p86.DisplayName:lower()
            end

            return p85 == LocalPlayer
        end)

        for _, player in Players2 do
            if player.UserId ~= perms.owner and (t32[player.UserId] or t31[player.UserId]) then
                local v500 = t31[player.UserId]
                local t34 = {}

                if player == LocalPlayer then
                    table.insert(t34, {
                        "YOU",
                        v5
                    })
                end

                if not t32[player.UserId] then
                    table.insert(t34, {
                        "NO ROLE",
                        v6
                    })
                end

                if v500 then
                    table.insert(t34, {
                        "ALLOWED",
                        v2
                    })
                end

                table.insert(t33, {
                    id = player.UserId,
                    display = player.DisplayName,
                    name = player.Name,
                    tags = t34,
                    sub = v500 and "BY " .. string.upper((tostring(v500.by or "?"))) .. " · " .. ago(v500.at) or nil
                })
            end
        end

        for _, v502 in perms.granted or {} do
            if not v502.online then
                table.insert(t33, {
                    id = v502.id,
                    display = v502.display,
                    name = v502.name,
                    tags = {
                        { "OFFLINE", v6 },
                        { "ALLOWED", v2 }
                    },
                    sub = "BY " .. string.upper((tostring(v502.by or "?"))) .. " · " .. ago(v502.at)
                })
            end
        end

        return t33, "NO OTHER RIDERS WITH THE RACE DIRECTOR ROLE"
    end

    local v506 = math.max(1, (math.floor(78 * n1 + 0.5)))
    local _, v513 = entryList(p84, v506, math.max(1, (math.floor(t5.Perms[2] * n1 + 0.5))) - v506 - math.max(1, (math.floor(46 * n1 + 0.5))), t30, entries)

    t1.renderList = v513

    function t1.reloadPerms() -- line: 521
        -- upvalues: v513 (copy), v35 (ref), t1 (copy)
        local function v514() -- line: 521
            -- upvalues: v513 (copy), t1 (copy)
            if t1.panel == "Perms" and t1.renderList == v513 then
                v513()
            end
        end

        if not v35 or t1.fetchingPerms then
            return
        end

        t1.fetchingPerms = true
        task.spawn(function() -- line: 482
            -- upvalues: v514 (copy), v35 (ref), t1 (copy)
            local InvokeServer = v35.InvokeServer
            local v515 = v35
            local permsList, permsList2 = pcall(InvokeServer, v515, "permsList")

            t1.fetchingPerms = false

            if permsList and typeof(permsList2) == "table" and permsList2.ok and typeof(permsList2.lists) == "table" then
                t1.perms = permsList2.lists
                t1.permsAt = os.clock()

                if v514 then
                    v514()
                end
            end
        end)
    end

    local function v516() -- line: 521
        -- upvalues: v513 (copy), t1 (copy)
        if t1.panel == "Perms" and t1.renderList == v513 then
            v513()
        end
    end

    if v35 and not t1.fetchingPerms then
        t1.fetchingPerms = true
        task.spawn(function() -- line: 482
            -- upvalues: v516 (copy), v35 (ref), t1 (copy)
            local InvokeServer = v35.InvokeServer
            local v517 = v35
            local permsList, permsList2 = pcall(InvokeServer, v517, "permsList")

            t1.fetchingPerms = false

            if permsList and typeof(permsList2) == "table" and permsList2.ok and typeof(permsList2.lists) == "table" then
                t1.perms = permsList2.lists
                t1.permsAt = os.clock()

                if v516 then
                    v516()
                end
            end
        end)
    end

    v466.Activated:Connect(function() -- line: 524
        -- upvalues: v513 (copy), t1 (copy), t30 (copy)
        local v518 = t1.listIds or {}
        local v519

        if #v518 == 0 then
            v519 = false
        else
            local v520 = false

            for _, v521 in v518 do
                if not t30[v521] then
                    v519 = false
                    v520 = true
                    break
                end
            end

            if not v520 then
                v519 = true
            end
        end

        if v519 then
            table.clear(t30)
        else
            for _, v522 in t1.listIds or {} do
                t30[v522] = true
            end
        end

        v513()
    end)

    local Frame = Instance.new("Frame")

    Frame.Name = "Actions"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0, 1)
    Frame.Position = UDim2.new(0, math.max(1, (math.floor(13 * n1 + 0.5))), 1, -math.max(1, (math.floor(22 * n1 + 0.5))))
    Frame.Size = UDim2.new(1, -math.max(1, (math.floor(26 * n1 + 0.5))), 0, (math.max(1, (math.floor(16 * n1 + 0.5)))))
    Frame.Parent = p84

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.Padding = UDim.new(0, (math.max(1, (math.floor(6 * n1 + 0.5)))))
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame

    for v535, v536 in {
            { "grant", "ALLOW" },
            { "revoke", "REMOVE" }
        } do
        local v537 = pill(Frame, v536[2], 84, 16, v536[2])

        v537.LayoutOrder = v535
        v537.Activated:Connect(function() -- line: 533
            -- upvalues: v513 (copy), v536 (copy), v1 (copy), v6 (copy), v35 (ref), t1 (copy), call (copy), t30 (copy)
            local t40 = {}

            for v538 in t30 do
                table.insert(t40, v538)
            end

            if #t40 == 0 then
                if t1.feedback then
                    t1.feedback.Text = "SELECT AT LEAST ONE RIDER"
                    t1.feedback.TextColor3 = v1 or v6
                end
            else
                call("perms", {
                    op = v536[1],
                    ids = t40
                }, function(p87) -- line: 536
                    -- upvalues: v513 (copy), v35 (ref), t1 (copy), t30 (copy)
                    if p87 then
                        table.clear(t30)
                    end

                    task.wait(0.2)

                    if t1.panel == "Perms" and t1.renderList == v513 then
                        local function v539() -- line: 521
                            -- upvalues: v513 (copy), t1 (copy)
                            if t1.panel == "Perms" and t1.renderList == v513 then
                                v513()
                            end
                        end

                        if v35 then
                            if t1.fetchingPerms then
                                return
                            end

                            t1.fetchingPerms = true
                            task.spawn(function() -- line: 482
                                -- upvalues: v539 (copy), v35 (ref), t1 (copy)
                                local InvokeServer = v35.InvokeServer
                                local v540 = v35
                                local permsList, permsList2 = pcall(InvokeServer, v540, "permsList")

                                t1.fetchingPerms = false

                                if permsList and typeof(permsList2) == "table" and permsList2.ok and typeof(permsList2.lists) == "table" then
                                    t1.perms = permsList2.lists
                                    t1.permsAt = os.clock()

                                    if v539 then
                                        v539()
                                    end
                                end
                            end)
                        end
                    end
                end)
            end
        end)
    end
end

t20.Announce = function(p88) -- line: 544
    -- upvalues: v1 (copy), v4 (copy), v5 (copy), v6 (copy), v8 (copy), n1 (ref), pill (copy), textBox (copy), t1 (copy), t2 (copy), t4 (copy), call (copy), playerEntries (copy), entryList (copy), frameField (copy)
    frameField(p88, math.max(1, (math.floor(13 * n1 + 0.5))), math.max(1, (math.floor(40 * n1 + 0.5))), "MESSAGE")

    local v546 = textBox(p88, "Message", 304, 30, t2.message, "TYPE YOUR MESSAGE...")

    v546.Position = UDim2.fromOffset(math.max(1, (math.floor(13 * n1 + 0.5))), (math.max(1, (math.floor(50 * n1 + 0.5)))))
    v546.MultiLine = true
    v546.TextWrapped = true
    v546.TextXAlignment = Enum.TextXAlignment.Left
    v546.TextYAlignment = Enum.TextYAlignment.Top
    v546.TextSize = math.max(1, (math.floor(8 * n1 + 0.5)))
    v546.FontFace = v8

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, (math.max(1, (math.floor(5 * n1 + 0.5)))))
    UIPadding.PaddingRight = UDim.new(0, (math.max(1, (math.floor(5 * n1 + 0.5)))))
    UIPadding.PaddingTop = UDim.new(0, (math.max(1, (math.floor(3 * n1 + 0.5)))))
    UIPadding.Parent = v546

    local v562 = math.max(1, (math.floor(6.5 * n1 + 0.5)))
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Counter"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.FontFace = v8
    TextLabel.TextSize = v562
    TextLabel.TextColor3 = v6
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.AutoLocalize = false
    TextLabel.Parent = p88
    TextLabel.AnchorPoint = Vector2.new(1, 0)
    TextLabel.Position = UDim2.new(1, -math.max(1, (math.floor(13 * n1 + 0.5))), 0, (math.max(1, (math.floor(40 * n1 + 0.5)))))
    TextLabel.Size = UDim2.fromOffset(math.max(1, (math.floor(60 * n1 + 0.5))), (math.max(1, (math.floor(9 * n1 + 0.5)))))
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right

    local function count() -- line: 550
        -- upvalues: v546 (copy), TextLabel (copy), t2 (copy)
        local v573 = v546.Text:gsub("[\r\n]", " ")

        if v573 == v546.Text then
            local v574 = utf8.len(v573) or #v573

            if v574 > 150 then
                v546.Text = v573:sub(1, utf8.offset(v573, 151) - 1)
            else
                t2.message = v573
                TextLabel.Text = v574 .. " / 150"
            end
        else
            v546.Text = v573
        end
    end

    v546:GetPropertyChangedSignal("Text"):Connect(count)
    count()
    frameField(p88, math.max(1, (math.floor(13 * n1 + 0.5))), math.max(1, (math.floor(86 * n1 + 0.5))), "SEND TO")

    local v580 = pill(p88, "SelectAll", 70, 13, "SELECT ALL")

    v580.AnchorPoint = Vector2.new(1, 0)
    v580.Position = UDim2.new(1, -math.max(1, (math.floor(13 * n1 + 0.5))), 0, (math.max(1, (math.floor(84 * n1 + 0.5)))))

    local v588 = math.max(1, (math.floor(6.5 * n1 + 0.5)))
    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "Selected"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = ""
    TextLabel2.FontFace = v8
    TextLabel2.TextSize = v588
    TextLabel2.TextColor3 = v6
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.AutoLocalize = false
    TextLabel2.Parent = p88
    TextLabel2.AnchorPoint = Vector2.new(1, 0)
    TextLabel2.Position = UDim2.new(1, -math.max(1, (math.floor(13 * n1 + 0.5))) - math.max(1, (math.floor(76 * n1 + 0.5))), 0, (math.max(1, (math.floor(86 * n1 + 0.5)))))
    TextLabel2.Size = UDim2.fromOffset(math.max(1, (math.floor(80 * n1 + 0.5))), (math.max(1, (math.floor(9 * n1 + 0.5)))))
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Right

    t1.onSelect = function() -- line: 561
        -- upvalues: v580 (copy), TextLabel2 (copy), v1 (copy), v4 (copy), v5 (copy), t1 (copy), t4 (copy)
        local n6 = 0

        for _ in t4 do
            n6 += 1
        end

        TextLabel2.Text = n6 .. " SELECTED"

        local v602 = t1.listIds or {}
        local v603

        if #v602 == 0 then
            v603 = false
        else
            local v604 = false

            for _, v605 in v602 do
                if not t4[v605] then
                    v603 = false
                    v604 = true
                    break
                end
            end

            if not v604 then
                v603 = true
            end
        end

        v580:SetAttribute("On", v603 == true)

        local v606 = v603 == true

        v580.BackgroundColor3 = v606 and v1 or v4
        v580.TextColor3 = v606 and v4 or v5

        local UIStroke = v580:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = v606 and v1 or v5
        end

        local v609 = t1.listIds or {}
        local v610

        if #v609 == 0 then
            v610 = false
        else
            local v611 = false

            for _, v612 in v609 do
                if not t4[v612] then
                    v610 = false
                    v611 = true
                    break
                end
            end

            if not v611 then
                v610 = true
            end
        end

        v580.Text = v610 and "CLEAR" or "SELECT ALL"
    end

    local v618 = math.max(1, (math.floor(5 * t1.ROW * n1 + 0.5))) + 4 * math.max(1, (math.floor(3 * n1 + 0.5)))
    local v621 = math.max(1, (math.floor(100 * n1 + 0.5)))
    local v622 = false
    local _, v623 = entryList(p88, v621, v618, t4, function() -- line: 185
        -- upvalues: v622 (copy), playerEntries (copy)
        return playerEntries(v622), "NO RIDERS"
    end)

    t1.renderList = v623
    v580.Activated:Connect(function() -- line: 568
        -- upvalues: v623 (copy), t1 (copy), t4 (copy)
        local v624 = t1.listIds or {}
        local v625

        if #v624 == 0 then
            v625 = false
        else
            local v626 = false

            for _, v627 in v624 do
                if not t4[v627] then
                    v625 = false
                    v626 = true
                    break
                end
            end

            if not v626 then
                v625 = true
            end
        end

        if v625 then
            table.clear(t4)
        else
            for _, v628 in t1.listIds or {} do
                t4[v628] = true
            end
        end

        v623()
    end)

    local SEND = pill(p88, "Send", 84, 16, "SEND")

    SEND.AnchorPoint = Vector2.new(1, 1)
    SEND.Position = UDim2.new(1, -math.max(1, (math.floor(13 * n1 + 0.5))), 1, -math.max(1, (math.floor(20 * n1 + 0.5))))
    SEND:SetAttribute("On", true)
    SEND.BackgroundColor3 = v1 or v4
    SEND.TextColor3 = v4 or v5

    local UIStroke = SEND:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = v1 or v5
    end

    SEND.MouseLeave:Connect(function() -- line: 573
        -- upvalues: SEND (copy), v1 (copy), v4 (copy), v5 (copy)
        SEND:SetAttribute("On", true)
        SEND.BackgroundColor3 = v1 or v4
        SEND.TextColor3 = v4 or v5

        local UIStroke = SEND:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = v1 or v5
        end
    end)
    SEND.Activated:Connect(function() -- line: 574
        -- upvalues: v546 (copy), v1 (copy), v6 (copy), t1 (copy), t2 (copy), t4 (copy), call (copy)
        local v634 = v546.Text:gsub("^%s+", ""):gsub("%s+$", "")

        if v634 == "" then
            if t1.feedback then
                t1.feedback.Text = "TYPE A MESSAGE"
                t1.feedback.TextColor3 = v1 or v6
            end
        else
            local t41 = {}

            for v635 in t4 do
                table.insert(t41, v635)
            end

            if #t41 == 0 then
                if t1.feedback then
                    t1.feedback.Text = "SELECT AT LEAST ONE RIDER"
                    t1.feedback.TextColor3 = v1 or v6
                end
            else
                call("announce", {
                    text = v634,
                    ids = t41
                }, function(p89) -- line: 579
                    -- upvalues: v546 (copy), t2 (copy)
                    if p89 then
                        t2.message = ""

                        if v546.Parent then
                            v546.Text = ""
                        end
                    end
                end)
            end
        end
    end)
end

local function refresh() -- line: 584
    -- upvalues: MotoLegends (copy), v1 (copy), v4 (copy), v5 (copy), t1 (copy), sessionText (copy)
    if t1.root then
        if t1.dyn.session then
            t1.dyn.session.Text = sessionText()
        end

        if t1.dyn.weather then
            local v636 = MotoLegends:GetAttribute("Weather") or "Sunny"
            local v637 = MotoLegends:GetAttribute("RDWeatherLock") == "Dynamic"

            for v638, v639 in t1.dyn.weather do
                local v640 = if v638 == "Dynamic" and v637 then v637 else v638 == v636

                v639:SetAttribute("On", v640 == true)

                local v641 = v640 == true

                v639.BackgroundColor3 = v641 and v1 or v4
                v639.TextColor3 = v641 and v4 or v5

                local UIStroke = v639:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIStroke.Color = v641 and v1 or v5
                end
            end
        end

        if t1.dyn.toggles then
            for _, v642 in t1.dyn.toggles do
                local v643 = MotoLegends:GetAttribute(v642.attr) == true
                local on = v642.on
                local v644 = not v643

                on:SetAttribute("On", v644 == true)

                local v645 = v644 == true

                on.BackgroundColor3 = v645 and v1 or v4
                on.TextColor3 = v645 and v4 or v5

                local UIStroke = on:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIStroke.Color = v645 and v1 or v5
                end

                local off = v642.off

                off:SetAttribute("On", v643 == true)

                local v646 = v643 == true

                off.BackgroundColor3 = v646 and v1 or v4
                off.TextColor3 = v646 and v4 or v5

                local UIStroke2 = off:FindFirstChildOfClass("UIStroke")

                if UIStroke2 then
                    UIStroke2.Color = v646 and v1 or v5
                end
            end
        end

        if t1.dyn.clockNow then
            local clockNow = t1.dyn.clockNow
            local v647 = tonumber((MotoLegends:GetAttribute("RDClockTime"))) or 12
            local v648 = math.floor(v647)
            local v650 = math.floor((v647 - v648) * 60 + 0.5)

            if v650 >= 60 then
                v648 += 1
                v650 -= 60
            end

            clockNow.Text = "NOW " .. string.format("%02d:%02d", v648 % 24, v650)
        end

        if not t1.dyn.redFlag then
            return
        end

        local v651 = MotoLegends:GetAttribute("RedFlag") == true
        local on = t1.dyn.redFlag.on

        on:SetAttribute("On", v651 == true)

        local v652 = v651 == true

        on.BackgroundColor3 = v652 and v1 or v4
        on.TextColor3 = v652 and v4 or v5

        local UIStroke = on:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            UIStroke.Color = v652 and v1 or v5
        end

        local off = t1.dyn.redFlag.off
        local v653 = not v651

        off:SetAttribute("On", v653 == true)

        local v654 = v653 == true

        off.BackgroundColor3 = v654 and v1 or v4
        off.TextColor3 = v654 and v4 or v5

        local UIStroke2 = off:FindFirstChildOfClass("UIStroke")

        if UIStroke2 then
            UIStroke2.Color = v654 and v1 or v5
        end
    end
end

local function destroy() -- line: 600
    -- upvalues: t1 (copy)
    if t1.root then
        t1.root:Destroy()
    end

    t1.root = nil
    t1.feedback = nil
    t1.dyn = {}
    t1.onSelect = nil
    t1.renderList = nil
    t1.reloadLists = nil
    t1.listIds = nil
    t1.reloadPerms = nil
end

v131 = function(p90) -- line: 604
    -- upvalues: v6 (copy), t1 (copy), shell (copy), t20 (copy), refresh (copy)
    local feedback = t1.feedback and t1.panel == p90 and t1.feedback.Text

    if t1.root then
        t1.root:Destroy()
    end

    t1.root = nil
    t1.feedback = nil
    t1.dyn = {}
    t1.onSelect = nil
    t1.renderList = nil
    t1.reloadLists = nil
    t1.listIds = nil
    t1.reloadPerms = nil

    if not t20[p90] then
        t1.panel = nil

        return
    end

    t1.panel = p90
    t1.root = shell(p90)
    t20[p90](t1.root)
    refresh()

    local feedback2, v655

    if feedback then
        local TextColor3 = t1.feedback.TextColor3

        if t1.feedback then
            t1.feedback.Text = feedback or ""
            feedback2 = t1.feedback
            v655 = TextColor3 or v6
            feedback2.TextColor3 = v655
        end
    end
end

local function v656() -- line: 614
    -- upvalues: t1 (copy)
    t1.panel = nil

    if t1.root then
        t1.root:Destroy()
    end

    t1.root = nil
    t1.feedback = nil
    t1.dyn = {}
    t1.onSelect = nil
    t1.renderList = nil
    t1.reloadLists = nil
    t1.listIds = nil
    t1.reloadPerms = nil
end

local function sync() -- line: 615
    -- upvalues: JerezRaceHUD (copy), t1 (copy), v131 (ref), v656 (copy)
    local RaceDirectorPanel = JerezRaceHUD:GetAttribute("RaceDirectorPanel")

    if JerezRaceHUD:GetAttribute("RaceDirectorMode") ~= true then
        RaceDirectorPanel = nil
    end

    if RaceDirectorPanel == t1.panel and t1.root then
        return
    end

    if not RaceDirectorPanel then
        v656()

        return
    end

    JerezRaceHUD:SetAttribute("ServerListOpen", false)

    if JerezRaceHUD:GetAttribute("LobbySettings") == true then
        JerezRaceHUD:SetAttribute("LobbySettings", false)

        for _, v657 in { "RaceSettings", "GraphicsSettingsPanel", "CustomInputs" } do
            local v658 = JerezRaceHUD:FindFirstChild(v657)

            if v658 then
                v658.Visible = false
            end
        end
    end

    v131(RaceDirectorPanel)
end

JerezRaceHUD:GetAttributeChangedSignal("RaceDirectorPanel"):Connect(sync)
JerezRaceHUD:GetAttributeChangedSignal("RaceDirectorMode"):Connect(sync)

for _, v659 in { "LobbySettings", "ServerListOpen", "BikesPreviewOpen", "LegendsOpen", "ShopOpen", "ProfileOpen" } do
    JerezRaceHUD:GetAttributeChangedSignal(v659):Connect(function() -- line: 629
        -- upvalues: JerezRaceHUD (copy), t1 (copy), v659 (copy)
        if JerezRaceHUD:GetAttribute(v659) == true and t1.panel then
            JerezRaceHUD:SetAttribute("RaceDirectorPanel", nil)
        end
    end)
end

UserInputService.InputBegan:Connect(function(p91) -- line: 631
    -- upvalues: JerezRaceHUD (copy), t1 (copy)
    if t1.panel and p91.KeyCode == Enum.KeyCode.ButtonB then
        JerezRaceHUD:SetAttribute("RaceDirectorPanel", nil)
    end
end)
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 632
    -- upvalues: t1 (copy), v131 (ref)
    if t1.panel then
        v131(t1.panel)
    end
end)

local function relist() -- line: 634
    -- upvalues: t1 (copy)
    if t1.renderList then
        task.defer(function() -- line: 634
            -- upvalues: t1 (copy)
            if t1.renderList then
                t1.renderList()
            end

            if t1.panel == "Riders" and t1.reloadLists then
                t1.reloadLists()
            end

            if t1.panel == "Perms" and t1.reloadPerms then
                t1.reloadPerms()
            end
        end)
    end
end

LocalPlayer:GetAttributeChangedSignal("RaceDirectorAccess"):Connect(function() -- line: 636
    -- upvalues: LocalPlayer (copy), JerezRaceHUD (copy), t1 (copy)
    if LocalPlayer:GetAttribute("RaceDirectorAccess") ~= true and t1.panel then
        JerezRaceHUD:SetAttribute("RaceDirectorPanel", nil)
    end
end)
LocalPlayer:GetAttributeChangedSignal("RaceDirectorOwner"):Connect(function() -- line: 637
    -- upvalues: LocalPlayer (copy), JerezRaceHUD (copy), t1 (copy), v131 (ref)
    if t1.panel == "Settings" then
        v131("Settings")
    elseif t1.panel == "Perms" and LocalPlayer:GetAttribute("RaceDirectorOwner") ~= true then
        JerezRaceHUD:SetAttribute("RaceDirectorPanel", "Settings")
    end
end)
Players.PlayerAdded:Connect(function(p92) -- line: 638
    -- upvalues: t1 (copy), relist (copy)
    if t1.renderList then
        task.defer(function() -- line: 634
            -- upvalues: t1 (copy)
            if t1.renderList then
                t1.renderList()
            end

            if t1.panel == "Riders" and t1.reloadLists then
                t1.reloadLists()
            end

            if t1.panel == "Perms" and t1.reloadPerms then
                t1.reloadPerms()
            end
        end)
    end

    p92:GetAttributeChangedSignal("RDDisqualified"):Connect(relist)
end)
Players.PlayerRemoving:Connect(relist)

for _, player in Players:GetPlayers() do
    player:GetAttributeChangedSignal("RDDisqualified"):Connect(relist)
end

task.spawn(function() -- line: 641
    -- upvalues: t1 (copy), refresh (copy)
    while true do
        task.wait(0.5)

        if t1.root then
            refresh()

            if t1.panel == "Riders" and t1.reloadLists and os.clock() - (t1.listsAt or 0) > 5 then
                t1.reloadLists()
            end
        end
    end
end)
sync()
