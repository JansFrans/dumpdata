-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "CrashFeedHUD"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 16
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")

Frame.Name = "CrashFeed"
Frame.BackgroundTransparency = 1
Frame.AnchorPoint = Vector2.new(1, 0)
Frame.Size = UDim2.fromOffset(130, 66)
Frame.Parent = ScreenGui

local UIScale = Instance.new("UIScale")

UIScale.Parent = Frame

local v1 = Color3.fromRGB(8, 9, 13)
local v2 = Color3.fromRGB(245, 245, 247)
local v3 = Color3.fromRGB(225, 6, 0)
local v4 = Color3.fromRGB(0, 0, 0)
local v5 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v6 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)

local function shortName(p1) -- line: 31
    local v7 = tostring(p1):match("^%s*(%S+)") or tostring(p1)
    local offset = utf8.offset
    local ok, result = pcall(offset, v7, 5)
    local v8, v9

    if ok then
        if result then
            local v10 = v7:sub(1, result - 1)

            if v10 then
                v8 = v10
                v9 = true
            elseif v7 then
                v8 = v7
                v9 = true
            else
                v9 = false
            end
        elseif v7 then
            v8 = v7
            v9 = true
        else
            v9 = false
        end
    else
        v9 = false
    end

    if not v9 then
        v8 = v7:sub(1, 4)
    end

    return v8:upper()
end

local function nationalFlag(p2) -- line: 36
    if typeof(p2) == "string" and #p2 == 2 then
        local v11, v12 = p2:upper():byte(1, 2)

        if not (v11 < 65) and not (v11 > 90) and not (v12 < 65) and not (v12 > 90) then
            return utf8.char(127462 + v11 - 65, 127462 + v12 - 65)
        end
    end

    return ""
end

local v13, TopRight
local n1 = 0

local function visibleTop(p3) -- line: 48
    local Y

    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("GuiObject") and descendant.Visible and descendant.AbsoluteSize.Y > 0 then
            local TextLabel = descendant:IsA("TextLabel")
            local v14, TextLabel2

            if TextLabel then
                v14 = descendant.Text == ""
            else
                TextLabel2 = descendant:IsA("TextLabel")
            end

            if TextLabel and not v14 or not TextLabel and not TextLabel2 then
                local Y2 = descendant.AbsolutePosition.Y

                if not Y or Y2 < Y then
                    Y = Y2
                end
            elseif TextLabel then
                TextLabel2 = descendant:IsA("TextLabel")

                if not TextLabel2 then
                    local Y2 = descendant.AbsolutePosition.Y

                    if not Y or Y2 < Y then
                        Y = Y2
                    end
                end
            end
        end
    end

    return Y
end

local function visibleBottom(p4) -- line: 57
    local v15

    for _, child in p4:GetChildren() do
        if child:IsA("GuiObject") and child.Visible then
            local v16 = child.AbsolutePosition.Y + child.AbsoluteSize.Y

            if not v15 or v15 < v16 then
                v15 = v16
            end
        end
    end

    return v15
end

RunService.RenderStepped:Connect(function() -- line: 67
    -- upvalues: LocalPlayer (copy), ScreenGui (copy), Frame (copy), UIScale (copy), v13 (ref), TopRight (ref), n1 (ref), visibleTop (copy), visibleBottom (copy)
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    local ViewportSize = CurrentCamera.ViewportSize
    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")
    local LapTimer = JerezRaceHUD and JerezRaceHUD:FindFirstChild("LapTimer")
    local UIScale2 = LapTimer and LapTimer:FindFirstChildOfClass("UIScale")
    local v17 = if UIScale2 then UIScale2.Scale else 1

    UIScale.Scale = math.clamp(math.min(ViewportSize.X / 960, ViewportSize.Y / 540), 0.55, 1.5) * 0.85

    local v21, v22

    if LapTimer then
        local SectorTimes = LapTimer:FindFirstChild("SectorTimes")

        if LapTimer.Visible and SectorTimes and SectorTimes.Visible then
            local v23 = 92 + SectorTimes.Size.Y.Offset + 6

            if v23 then
                v21 = v23
                v22 = true
            else
                v22 = false
            end
        else
            v22 = false
        end
    else
        v22 = false
    end

    if not v22 then
        v21 = 96
    end

    local v24 = (16 + v21) * v17

    if not (not (os.clock() >= n1) or v13 and v13.Parent) then
        n1 = os.clock() + 1
        v13 = LocalPlayer.PlayerGui:FindFirstChild("RaceDirectorSpectate", true)

        local v25 = v13 and v13:FindFirstAncestorOfClass("ScreenGui")

        TopRight = v25 and v25:FindFirstChild("TopRight")
    end

    local v26 = v13 and v13.Parent and v13:FindFirstAncestorOfClass("ScreenGui")
    local v27, v28
    local v29 = v24

    if v26 and v26.Enabled and v13.Visible then
        local v30 = visibleTop(v13)

        if v30 then
            local v31 = Frame.Size.Y.Offset * UIScale.Scale

            v27 = v30 - ScreenGui.AbsolutePosition.Y - v31 - 6 * UIScale.Scale
            v28 = TopRight and TopRight.Visible and visibleBottom(TopRight)

            if v28 then
                v27 = math.max(v27, v28 - ScreenGui.AbsolutePosition.Y + 14 * UIScale.Scale)
            end

            v29 = math.min(v24, v27)
        end
    end

    Frame.Position = UDim2.fromOffset(ViewportSize.X - v17 * 14, v29)
end)

local function tween(p5, p6, p7, p8, p9) -- line: 100
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p5, TweenInfo.new(p7, p8 or Enum.EasingStyle.Quart, p9 or Enum.EasingDirection.Out), p6)

    tween:Play()

    return tween
end

local function makeRow(p10, p11) -- line: 104
    -- upvalues: Frame (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), shortName (copy), nationalFlag (copy)
    local v33 = (p11 - 1) * 22
    local v34 = p10.kind == "RETIRED" or p10.kind == "DSQ"
    local v35 = p10.kind == "DSQ"
    local v36 = if v35 then 110 elseif v34 then 70 else 48
    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Crash_" .. p11
    Frame2.BackgroundTransparency = 1
    Frame2.Size = UDim2.fromOffset(82 + v36, 21)
    Frame2.Position = UDim2.fromOffset(48 - v36, v33)
    Frame2.ClipsDescendants = true
    Frame2.Parent = Frame

    local Frame3 = Instance.new("Frame")

    Frame3.Name = "Rider"
    Frame3.BorderSizePixel = 0
    Frame3.BackgroundColor3 = v1
    Frame3.BackgroundTransparency = 1
    Frame3.Size = UDim2.fromOffset(82, 21)
    Frame3.Position = UDim2.fromOffset(v36 + 82, 0)
    Frame3.ZIndex = 3
    Frame3.Parent = Frame2

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Flag"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromOffset(16, 21)
    TextLabel.Position = UDim2.fromOffset(4, 0)
    TextLabel.Text = nationalFlag(p10.country)
    TextLabel.TextSize = 12
    TextLabel.TextTransparency = 1
    TextLabel.ZIndex = 4
    TextLabel.Parent = Frame3

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Name = "Name"
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Size = UDim2.fromOffset(56, 21)
    TextLabel2.Position = UDim2.fromOffset(23, 0)
    TextLabel2.FontFace = v5
    TextLabel2.TextSize = 14
    TextLabel2.TextColor3 = v2
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.AutoLocalize = false
    TextLabel2.Text = shortName(p10.name)
    TextLabel2.TextTransparency = 1
    TextLabel2.ZIndex = 4
    TextLabel2.Parent = Frame3

    local Frame4 = Instance.new("Frame")

    Frame4.Name = "CrashTag"
    Frame4.BorderSizePixel = 0
    Frame4.BackgroundColor3 = v35 and v4 or v3
    Frame4.Size = UDim2.fromOffset(v36, 21)
    Frame4.Position = UDim2.fromOffset(v36, 0)
    Frame4.ZIndex = 2
    Frame4.Visible = false
    Frame4.Parent = Frame2

    local TextLabel3 = Instance.new("TextLabel")

    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Size = UDim2.fromScale(1, 1)
    TextLabel3.FontFace = v6
    TextLabel3.TextSize = 13
    TextLabel3.TextColor3 = v2

    if v35 then
        TextLabel3.Text = "DISQUALIFIED"
    elseif v34 then
        TextLabel3.Text = "RETIRED"
    else
        TextLabel3.Text = "CRASH"
    end

    TextLabel3.ZIndex = 2
    TextLabel3.Parent = Frame4

    return {
        holder = Frame2,
        rider = Frame3,
        flag = TextLabel,
        name = TextLabel2,
        crash = Frame4,
        crashText = TextLabel3,
        tagW = v36
    }
end

local function showBatch(p12) -- line: 125
    -- upvalues: TweenService (copy), makeRow (copy)
    local t1 = {}

    for v37, v38 in p12 do
        local v39 = makeRow(v38, v37)

        t1[v37] = v39
        task.delay((v37 - 1) * 0.08, function() -- line: 129
            -- upvalues: v39 (copy), TweenService (copy)
            local rider = v39.rider
            local t2 = {
                BackgroundTransparency = 0.12,
                Position = UDim2.fromOffset(v39.tagW, 0)
            }

            TweenService:Create(rider, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), t2):Play()

            local flag = v39.flag
            local t3 = {
                TextTransparency = 0
            }

            TweenService:Create(flag, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), t3):Play()

            local name = v39.name
            local t4 = {
                TextTransparency = 0
            }

            TweenService:Create(name, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), t4):Play()
            task.wait(0.3)
            v39.crash.Visible = true

            local crash = v39.crash
            local t5 = {
                Position = UDim2.fromOffset(0, 0)
            }

            TweenService:Create(crash, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), t5):Play()
        end)
    end

    task.wait(4)

    for _, v40 in t1 do
        local rider = v40.rider
        local t6 = {
            BackgroundTransparency = 1
        }
        local Quad = Enum.EasingStyle.Quad

        TweenService:Create(rider, TweenInfo.new(0.35, Quad or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), t6):Play()

        local flag = v40.flag
        local t7 = {
            TextTransparency = 1
        }
        local Quad2 = Enum.EasingStyle.Quad

        TweenService:Create(flag, TweenInfo.new(0.35, Quad2 or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), t7):Play()

        local name = v40.name
        local t8 = {
            TextTransparency = 1
        }
        local Quad3 = Enum.EasingStyle.Quad

        TweenService:Create(name, TweenInfo.new(0.35, Quad3 or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), t8):Play()

        local crash = v40.crash
        local t9 = {
            BackgroundTransparency = 1
        }
        local Quad4 = Enum.EasingStyle.Quad

        TweenService:Create(crash, TweenInfo.new(0.35, Quad4 or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), t9):Play()

        local crashText = v40.crashText
        local t10 = {
            TextTransparency = 1
        }
        local Quad5 = Enum.EasingStyle.Quad

        TweenService:Create(crashText, TweenInfo.new(0.35, Quad5 or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), t10):Play()
    end

    task.wait(0.4)

    for _, v41 in t1 do
        v41.holder:Destroy()
    end
end

local t11 = {}

MotoLegends:WaitForChild("CrashFeed").OnClientEvent:Connect(function(p13) -- line: 152
    -- upvalues: Players (copy), t11 (copy)
    if typeof(p13) ~= "table" then
        return
    end

    local v42 = p13.userId and Players:GetPlayerByUserId(p13.userId)
    local name = p13.name
    local v43, v44

    if name then
        v43 = name
        v44 = true
    elseif v42 then
        local DisplayName = v42.DisplayName

        if DisplayName then
            v43 = DisplayName
            v44 = true
        else
            v44 = false
        end
    else
        v44 = false
    end

    if not v44 then
        v43 = "?"
    end

    local t12 = {}

    t12.name = v43
    t12.country = p13.country or v42 and v42:GetAttribute("Country")

    local v45, v46

    if p13.kind == "RETIRED" or p13.kind == "DSQ" then
        local kind = p13.kind

        if kind then
            v45 = kind
            v46 = true
        else
            v46 = false
        end
    else
        v46 = false
    end

    t12.kind = if not v46 then "CRASH" else v45
    table.insert(t11, t12)
end)
task.spawn(function() -- line: 158
    -- upvalues: showBatch (copy), t11 (copy)
    while true do
        if #t11 == 0 then
            task.wait(0.1)
            continue
        end

        task.wait(3)

        local t13 = {}

        while #t11 > 0 and #t13 < 3 do
            table.insert(t13, table.remove(t11, 1))
        end

        showBatch(t13)
    end
end)
