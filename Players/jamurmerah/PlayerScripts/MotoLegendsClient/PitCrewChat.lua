-- https://lua.expert

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer
local t1 = {
    "What's the plan, %s?",
    "What tyre do you want, %s?",
    "Welcome back, %s. Fresh rubber?",
    "Tyres are on the warmers, %s. Which ones?",
    "How's the bike feeling, %s?",
    "Ready when you are, %s.",
    "Want me to check the tyres, %s?",
    "Box, box... What do you need, %s?"
}
local v1 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)

local function myCrew() -- line: 32
    -- upvalues: CollectionService (copy), LocalPlayer (copy)
    local PitboxIndex = LocalPlayer:GetAttribute("PitboxIndex")

    if PitboxIndex ~= nil then
        for _, v2 in CollectionService:GetTagged("PitboxCrew") do
            if v2.Parent and v2:IsA("Model") and v2:GetAttribute("TyreGrid") ~= true then
                local Parent = v2.Parent

                if Parent and Parent:GetAttribute("PitboxIndex") == PitboxIndex then
                    return v2
                end
            end
        end
    end

    return nil
end

local BillboardGui = nil

local function say(p1) -- line: 43
    -- upvalues: TweenService (copy), TextService (copy), LocalPlayer (copy), t1 (copy), v1 (copy), BillboardGui (ref)
    local Head = p1:FindFirstChild("Head")

    if not Head then
        return
    end

    if BillboardGui then
        BillboardGui:Destroy()
        BillboardGui = nil
    end

    local DisplayName = LocalPlayer.DisplayName ~= "" and LocalPlayer.DisplayName or LocalPlayer.Name
    local v3 = t1[math.random(1, #t1)]:format(DisplayName)
    local v4 = TextService:GetTextSize(v3, 15, Enum.Font.GothamBold, Vector2.new(1000, 100)).X + 32
    local BillboardGui2 = Instance.new("BillboardGui")

    BillboardGui2.Name = "PitCrewChat"
    BillboardGui2.Adornee = Head
    BillboardGui2.AlwaysOnTop = false
    BillboardGui2.LightInfluence = 0
    BillboardGui2.ResetOnSpawn = false
    BillboardGui2.MaxDistance = 90
    BillboardGui2.StudsOffsetWorldSpace = Vector3.new(0, 2.6, 0)
    BillboardGui2.Size = UDim2.fromOffset(v4 + 8, 48)

    local Frame = Instance.new("Frame")

    Frame.Name = "Bubble"
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.new(0.5, 0, 0, 0)
    Frame.Size = UDim2.fromOffset(v4, 30)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Parent = BillboardGui2

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.FontFace = v1
    TextLabel.TextSize = 15
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextTransparency = 1
    TextLabel.Text = v3
    TextLabel.AutoLocalize = true
    TextLabel.Parent = Frame

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Tip"
    Frame2.AnchorPoint = Vector2.new(0.5, 0)
    Frame2.Position = UDim2.new(0.5, 0, 0, 36)
    Frame2.Size = UDim2.fromOffset(16, 8)
    Frame2.BackgroundTransparency = 1
    Frame2.Parent = BillboardGui2

    local t2 = {}

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
        table.insert(t2, Frame)
    end

    BillboardGui2.Parent = LocalPlayer:WaitForChild("PlayerGui")
    BillboardGui = BillboardGui2

    local function fade(p2, p3, p4, p5) -- line: 67
        -- upvalues: Frame (copy), TextLabel (copy), t2 (copy), TweenService (copy)
        local v8 = TweenInfo.new(p5, Enum.EasingStyle.Quad)

        TweenService:Create(Frame, v8, {
            BackgroundTransparency = p2
        }):Play()
        TweenService:Create(TextLabel, v8, {
            TextTransparency = p3
        }):Play()

        for _, v9 in t2 do
            TweenService:Create(v9, v8, {
                BackgroundTransparency = p4
            }):Play()
        end
    end

    fade(0.2, 0, 0.25, 0.25)
    task.delay(4.5, function() -- line: 74
        -- upvalues: BillboardGui2 (copy), fade (copy), BillboardGui (ref)
        if BillboardGui == BillboardGui2 then
            fade(1, 1, 1, 0.4)
            task.delay(0.45, function() -- line: 77
                -- upvalues: BillboardGui2 (copy), BillboardGui (ref)
                if BillboardGui == BillboardGui2 then
                    BillboardGui2:Destroy()
                    BillboardGui = nil
                end
            end)
        end
    end)
end

local Position
local n1 = (-1e999)
local n2 = (-1e999)
local n3 = 0

LocalPlayer.CharacterAdded:Connect(function() -- line: 85
    -- upvalues: LocalPlayer (copy), Position (ref), n2 (ref), n3 (ref)
    n3 += 1
    Position = nil

    if n3 > 1 or LocalPlayer:GetAttribute("PitIntroDone") == true then
        n2 = os.clock()
    end
end)
task.spawn(function() -- line: 86
    -- upvalues: LocalPlayer (copy), myCrew (copy), say (copy), Position (ref), n1 (ref), n2 (ref)
    while true do
        task.wait(0.25)

        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            continue
        end

        local Position2 = HumanoidRootPart.Position
        local Magnitude = HumanoidRootPart.AssemblyLinearVelocity.Magnitude
        local v10 = Position == nil or (Position2 - Position).Magnitude > math.max(40, Magnitude * 0.25 * 2 + 10)
        local v12 = os.clock() - n2 < 3

        if v10 or v12 then
            local v13, HumanoidRootPart

            if os.clock() - n1 > 12 and LocalPlayer:GetAttribute("PitIntroDone") == true and not LocalPlayer.PlayerGui:FindFirstChild("PitboxWelcome") then
                v13 = myCrew()
                HumanoidRootPart = v13 and v13:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart and (HumanoidRootPart.Position - Position2).Magnitude < 26 then
                    n1 = os.clock()

                    local delay = task.delay
                    local v14 = v13

                    delay(0.6, function() -- line: 100
                        -- upvalues: v14 (copy), say (copy)
                        if v14.Parent then
                            say(v14)
                        end
                    end)
                end
            end
        end

        Position = Position2
    end
end)
