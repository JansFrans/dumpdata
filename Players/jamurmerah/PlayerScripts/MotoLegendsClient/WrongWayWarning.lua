-- https://lua.expert

local Track = require(game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends"):WaitForChild("Config")).Track
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local LocalPlayer = Players.LocalPlayer
local JerezRaceHUD = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("JerezRaceHUD")
local v1 = require(MotoLegends:WaitForChild("WrongWayDetector")).New(require(MotoLegends:WaitForChild("Tracks"):WaitForChild(Track):WaitForChild("Layout")))
local TextLabel = Instance.new("TextLabel")

TextLabel.Name = "WrongWayWarning"
TextLabel.AnchorPoint = Vector2.new(0.5, 0)
TextLabel.Position = UDim2.new(0.5, 0, 0, 86)
TextLabel.Size = UDim2.fromOffset(230, 40)
TextLabel.BackgroundColor3 = Color3.fromRGB(175, 24, 20)
TextLabel.BackgroundTransparency = 0.08
TextLabel.BorderSizePixel = 0
TextLabel.Text = "⚠  WRONG WAY"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Font = Enum.Font.GothamBlack
TextLabel.TextSize = 20
TextLabel.ZIndex = 55
TextLabel.Visible = false
TextLabel.Parent = JerezRaceHUD
Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 10)

local TweenService = game:GetService("TweenService")
local v2 = false
local v3

TextLabel.BackgroundTransparency = 1
TextLabel.TextTransparency = 1

local n1 = 0

local function blink(p1) -- line: 18
    -- upvalues: TextLabel (copy), TweenService (copy), v2 (ref), v3 (ref), n1 (ref)
    task.spawn(function() -- line: 19
        -- upvalues: p1 (copy), TextLabel (copy), TweenService (copy), v2 (ref), v3 (ref), n1 (ref)
        task.wait(0.25)

        while v2 do
            if p1 == n1 then
                v3 = TweenService:Create(TextLabel, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {
                    BackgroundTransparency = 0.85,
                    TextTransparency = 0.85
                })
                v3:Play()
                task.wait(0.25)

                if v2 and p1 == n1 then
                    v3 = TweenService:Create(TextLabel, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {
                        BackgroundTransparency = 0.08,
                        TextTransparency = 0
                    })
                    v3:Play()
                    task.wait(0.4)
                    continue
                end
            end

            break
        end
    end)
end

local function fade(p2) -- line: 29
    -- upvalues: TextLabel (copy), TweenService (copy), v2 (ref), v3 (ref), n1 (ref)
    if p2 == v2 then
        return
    end

    v2 = p2
    n1 += 1

    if v3 then
        v3:Cancel()
    end

    if p2 then
        TextLabel.Visible = true
    end

    v3 = TweenService:Create(TextLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = p2 and 0.08 or 1,
        TextTransparency = p2 and 0 or 1
    })
    v3.Completed:Connect(function(p3) -- line: 34
        -- upvalues: TextLabel (copy), v2 (ref)
        if p3 == Enum.PlaybackState.Completed and not v2 then
            TextLabel.Visible = false
        end
    end)
    v3:Play()

    if p2 then
        local v5 = n1

        task.spawn(function() -- line: 19
            -- upvalues: v5 (copy), TextLabel (copy), TweenService (copy), v2 (ref), v3 (ref), n1 (ref)
            task.wait(0.25)

            while v2 do
                if v5 == n1 then
                    v3 = TweenService:Create(TextLabel, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {
                        BackgroundTransparency = 0.85,
                        TextTransparency = 0.85
                    })
                    v3:Play()
                    task.wait(0.25)

                    if v2 and v5 == n1 then
                        v3 = TweenService:Create(TextLabel, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {
                            BackgroundTransparency = 0.08,
                            TextTransparency = 0
                        })
                        v3:Play()
                        task.wait(0.4)
                        continue
                    end
                end

                break
            end
        end)
    end
end

local v6
local t2 = {}
local n2 = 0

RunService.Heartbeat:Connect(function(p4) -- line: 39
    -- upvalues: LocalPlayer (copy), JerezRaceHUD (copy), v1 (copy), fade (copy), v6 (ref), t2 (ref), n2 (ref)
    n2 += p4

    if n2 < 0.15 then
        return
    end

    local v8 = math.min(n2, 0.3)

    n2 = 0

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v9 = Humanoid and Humanoid.SeatPart
    local v10 = v9 and v9:FindFirstAncestorOfClass("Model")

    if v10 then
        v10 = v10:GetAttribute("OwnerUserId") == LocalPlayer.UserId and v10:GetAttribute("Crash") == "" and v10.PrimaryPart
    end

    if v10 ~= v6 then
        v6 = v10
        t2 = {}
    end

    local v11 = v6 and v1.Update(t2, v6.Position, v6.AssemblyLinearVelocity, v8, true) or false

    fade(v11)
    JerezRaceHUD:SetAttribute("WrongWay", v11)
end)
