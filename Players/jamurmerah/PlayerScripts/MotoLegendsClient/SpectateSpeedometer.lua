-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local t1 = {}
local Config = require(MotoLegends:WaitForChild("Config"))
local RaceGauge = require(MotoLegends:WaitForChild("RaceGauge"))
local RemoteBikes = require(MotoLegends:WaitForChild("RemoteBikes"))
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local JerezRaceHUD = PlayerGui:WaitForChild("JerezRaceHUD")
local t2 = {
    Enabled = true,
    ShowDelay = 2.5,
    Size = 0.6,
    InSeconds = 0.45,
    OutSeconds = 0.3,
    Slide = 26,
    BottomGap = 12,
    CardsGap = 6,
    RiseResponse = 10,
    CamModes = {
        [0] = true,
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true,
        [7] = true,
        [8] = true
    }
}
local v1 = 356 * (RaceGauge.Height / 428)
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "SpectateSpeedoHUD"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 8
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local CanvasGroup = Instance.new("CanvasGroup")

CanvasGroup.Name = "Speedometer"
CanvasGroup.BackgroundTransparency = 1
CanvasGroup.BorderSizePixel = 0
CanvasGroup.Size = UDim2.fromOffset(RaceGauge.Width, RaceGauge.Height)
CanvasGroup.GroupTransparency = 1
CanvasGroup.Visible = false
CanvasGroup.Parent = ScreenGui

local UIScale = Instance.new("UIScale")

UIScale.Parent = CanvasGroup

local Frame = Instance.new("Frame")

Frame.Name = "TelemetryAnchor"
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.Size = UDim2.fromOffset(RaceGauge.Width, RaceGauge.Height)
Frame.Parent = CanvasGroup

local v2 = RaceGauge.New(Frame)

v2.hideAssists = true
v2.angle.Visible = false
v2.rhdLabel.Visible = false

local function cardsTop() -- line: 48
    -- upvalues: PlayerGui (copy)
    local SpectateTimingCardsHUD = PlayerGui:FindFirstChild("SpectateTimingCardsHUD")

    SpectateTimingCardsHUD = SpectateTimingCardsHUD and SpectateTimingCardsHUD.Enabled and SpectateTimingCardsHUD:FindFirstChild("TimingCards")

    if SpectateTimingCardsHUD then
        for _, child in SpectateTimingCardsHUD:GetChildren() do
            if child:IsA("GuiObject") and child.Visible then
                return SpectateTimingCardsHUD.AbsolutePosition.Y + game:GetService("GuiService"):GetGuiInset().Y
            end
        end
    end

    return nil
end

local function ridingBike(p1) -- line: 60
    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if RaceBikes then
        for _, child in RaceBikes:GetChildren() do
            if child:GetAttribute("OwnerUserId") == p1 and child.PrimaryPart and (child:GetAttribute("Crash") or "") == "" then
                local RiderSeat = child:FindFirstChild("RiderSeat")

                if RiderSeat and RiderSeat.Occupant then
                    return child
                end
            end
        end
    end

    return nil
end

local n1 = 0
local SpectateTargetId
local n2 = 0
local t3 = {
    gear = 1,
    lean = 0
}
local t4 = {
    throttle = 0,
    brake = 0,
    rearBrake = 0
}

v2.input = t4

local n3 = 0

t1[1] = nil
RunService.RenderStepped:Connect(function(p2) -- line: 80
    -- upvalues: Config (copy), RaceGauge (copy), RemoteBikes (copy), JerezRaceHUD (copy), t2 (copy), v1 (copy), CanvasGroup (copy), UIScale (copy), v2 (copy), cardsTop (copy), ridingBike (copy), n1 (ref), SpectateTargetId (ref), n2 (ref), t3 (copy), t4 (copy), n3 (ref), t1 (copy)
    local v3 = math.min(p2, 0.1)
    local v4 = JerezRaceHUD:GetAttribute("LobbySpectating") == true
    local SpectateTargetId2 = JerezRaceHUD:GetAttribute("SpectateTargetId")
    local SpectateCamMode = JerezRaceHUD:GetAttribute("SpectateCamMode")
    local v5, v6

    if v4 and typeof(SpectateTargetId2) == "number" then
        local v7 = ridingBike(SpectateTargetId2)

        if v7 then
            v5 = v7
            v6 = true
        else
            v6 = false
        end
    else
        v6 = false
    end

    if not v6 then
        v5 = nil
    end

    local v8 = v5 ~= nil and typeof(SpectateCamMode) == "number" and t2.CamModes[SpectateCamMode] == true

    n1 = v8 and n1 + v3 or 0

    if SpectateTargetId2 ~= SpectateTargetId then
        SpectateTargetId = SpectateTargetId2
        n2 = 0
    end

    local v10 = t2.Enabled

    if v10 then
        local v11 = v8

        v11 = v11 and n1 >= t2.ShowDelay
        v10 = v11
    end

    local v9 = v10
    local v13 = v3 / (v9 and t2.InSeconds or t2.OutSeconds)
    local v14 = if v9 then math.min(1, n3 + v13) else nil

    if not v9 or not v14 then
        v14 = math.max(0, n3 - v13)
    end

    n3 = v14

    if n3 <= 0 then
        if CanvasGroup.Visible then
            CanvasGroup.Visible = false
        end

        t1[1] = nil
    else
        CanvasGroup.Visible = true

        local v17 = if v9 then 1 - (1 - n3) ^ 5 else nil

        if not v9 or not v17 then
            v17 = n3 * n3
        end

        local ViewportSize = workspace.CurrentCamera.ViewportSize
        local v21 = math.min(ViewportSize.X / 737, ViewportSize.Y / 412)
        local v22 = v21 * t2.Size

        UIScale.Scale = v22

        local v23 = ViewportSize.Y - t2.BottomGap * v21 - v1 * v22
        local v24 = cardsTop()

        if v24 then
            v23 = math.min(v23, v24 - t2.CardsGap * v21 - v1 * v22)
        end

        local v26 = t1[1]
        local v27 = if v26 then t1[1] + (v23 - t1[1]) * (1 - math.exp(-v3 * t2.RiseResponse)) else nil

        t1[1] = if v26 and v27 then v27 else v23
        CanvasGroup.Position = UDim2.fromOffset(ViewportSize.X / 2 - RaceGauge.Width * v22 / 2, t1[1] + t2.Slide * v21 * (1 - v17))
        CanvasGroup.GroupTransparency = 1 - v17

        if v5 then
            local v31 = RemoteBikes.Velocity(SpectateTargetId2)
            local SpeedKph

            if v31 then
                SpeedKph = Vector3.new(v31.X, 0, v31.Z).Magnitude * Config.StudMetres * 3.6
            else
                SpeedKph = v5:GetAttribute("SpeedKph")

                if not SpeedKph then
                    SpeedKph = v5.PrimaryPart and Vector3.new(v5.PrimaryPart.AssemblyLinearVelocity.X, 0, v5.PrimaryPart.AssemblyLinearVelocity.Z).Magnitude * Config.StudMetres * 3.6 or 0
                end
            end

            n2 += (SpeedKph - n2) * (1 - math.exp(-v3 * 12))
            t3.gear = v5:GetAttribute("Gear") or t3.gear
            t3.rpm = v5:GetAttribute("EngineRPM")
            t3.throttle = v5:GetAttribute("Throttle") or 0
            t4.throttle = t3.throttle
            t4.brake = v5:GetAttribute("Brake") or 0
            v2.Update(v3, t3, n2)
        end
    end
end)
