-- https://lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local function waitIntro() -- line: 11
    -- upvalues: LocalPlayer (copy)
    local elapsed = os.clock()

    while LocalPlayer:GetAttribute("PitIntroDone") ~= true and os.clock() - elapsed < 40 do
        task.wait(0.1)
    end

    return LocalPlayer:GetAttribute("PitIntroDone") == true
end

local function returning() -- line: 16
    -- upvalues: LocalPlayer (copy)
    local elapsed = os.clock()

    while LocalPlayer:GetAttribute("ReturningPlayer") == nil and LocalPlayer:GetAttribute("ProgressLoaded") ~= true and os.clock() - elapsed < 6 do
        task.wait(0.1)
    end

    if LocalPlayer:GetAttribute("ReturningPlayer") == true then
        return true
    end

    return (LocalPlayer:GetAttribute("TotalLaps") or 0) > 0
end

local function crewHead() -- line: 23
    -- upvalues: LocalPlayer (copy)
    local PitboxIndex = LocalPlayer:GetAttribute("PitboxIndex")

    if PitboxIndex then
        local v1 = workspace:FindFirstChild("PlayerPitboxes", true)

        if v1 then
            local v2 = v1:FindFirstChild("PitboxDecor_" .. PitboxIndex)

            if v2 then
                local PitboxCrew = v2:FindFirstChild("PitboxCrew")

                if PitboxCrew then
                    return PitboxCrew:FindFirstChild("Head", true)
                end
            end
        end
    end
end

local TextService = game:GetService("TextService")
local v3 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)

local function show(p1, p2) -- line: 37
    -- upvalues: TweenService (copy), LocalPlayer (copy), TextService (copy), v3 (copy)
    local v4 = TextService:GetTextSize(p2, 15, Enum.Font.GothamBold, Vector2.new(1000, 100)).X + 32
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "PitboxWelcome"
    BillboardGui.Adornee = p1
    BillboardGui.AlwaysOnTop = false
    BillboardGui.LightInfluence = 0
    BillboardGui.ResetOnSpawn = false
    BillboardGui.MaxDistance = 90
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 2.6, 0)
    BillboardGui.Size = UDim2.fromOffset(v4 + 8, 48)

    local Frame = Instance.new("Frame")

    Frame.Name = "Pill"
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.new(0.5, 0, 0, 0)
    Frame.Size = UDim2.fromOffset(v4, 30)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Parent = BillboardGui

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.FontFace = v3
    TextLabel.TextSize = 15
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextTransparency = 1
    TextLabel.Text = p2
    TextLabel.AutoLocalize = false
    TextLabel.Parent = Frame

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Tip"
    Frame2.AnchorPoint = Vector2.new(0.5, 0)
    Frame2.Position = UDim2.new(0.5, 0, 0, 36)
    Frame2.Size = UDim2.fromOffset(16, 8)
    Frame2.BackgroundTransparency = 1
    Frame2.Parent = BillboardGui

    local t1 = {}

    for i = 0, 7 do
        local v5 = (1 - (i + 0.5) / 8) * 16
        local Frame = Instance.new("Frame")

        Frame.AnchorPoint = Vector2.new(0.5, 0)
        Frame.Position = UDim2.new(0.5, 0, 0, i)
        Frame.Size = UDim2.new(0, math.max(1, (math.floor(v5 + 0.5))), 0, 1)
        Frame.BackgroundColor3 = Color3.new(0, 0, 0)
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.Parent = Frame2
        table.insert(t1, Frame)
    end

    BillboardGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local function fade(p3, p4, p5, p6) -- line: 56
        -- upvalues: Frame (copy), TextLabel (copy), t1 (copy), TweenService (copy)
        local v8 = TweenInfo.new(p6, Enum.EasingStyle.Quad)

        TweenService:Create(Frame, v8, {
            BackgroundTransparency = p3
        }):Play()
        TweenService:Create(TextLabel, v8, {
            TextTransparency = p4
        }):Play()

        for _, v9 in t1 do
            TweenService:Create(v9, v8, {
                BackgroundTransparency = p5
            }):Play()
        end
    end

    fade(0.2, 0, 0.25, 0.25)
    task.delay(5, function() -- line: 63
        -- upvalues: BillboardGui (copy), fade (copy)
        fade(1, 1, 1, 0.4)
        task.delay(0.45, function() -- line: 65
            -- upvalues: BillboardGui (copy)
            BillboardGui:Destroy()
        end)
    end)
end

task.spawn(function() -- line: 69
    -- upvalues: LocalPlayer (copy), waitIntro (copy), returning (copy), crewHead (copy), show (copy)
    if not waitIntro() then
        return
    end

    local v10 = returning()
    local elapsed = os.clock()
    local v11

    while not v11 and os.clock() - elapsed < 5 do
        v11 = crewHead()

        if not v11 then
            task.wait(0.25)
        end
    end

    if v11 then
        local DisplayName = LocalPlayer.DisplayName ~= "" and LocalPlayer.DisplayName or LocalPlayer.Name

        show(v11, (v10 and "Welcome back, " or "Welcome, ") .. DisplayName)
    end
end)
