-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local BikeCatalog = require(MotoLegends:WaitForChild("BikeCatalog"))
local Cards = require(script:WaitForChild("Cards"))
local JerezRaceHUD = PlayerGui:WaitForChild("JerezRaceHUD")
local ChampionshipEvent = MotoLegends:WaitForChild("ChampionshipEvent")
local t1 = {
    Enabled = true,
    Scale = 0.75,
    BottomGap = 14,
    SideGap = 10,
    Phases = {
        Qualifying = true,
        QualifyingFinish = true
    }
}
local t2 = {
    Ducati = "DUC",
    Aprilia = "APR",
    KTM = "KTM",
    Trackhouse = "TRH",
    Yamaha = "YAM",
    VR46 = "VR46",
    Gresini = "GRE",
    Pramac = "PRA",
    Honda = "HON",
    LCR = "LCR",
    Tech3 = "TE3"
}
local t3 = {}

ChampionshipEvent.OnClientEvent:Connect(function(p1, p2) -- line: 34
    -- upvalues: t3 (ref)
    if p1 ~= "Standings" or typeof(p2) ~= "table" then
        return
    end

    local t4 = {}

    for v1, v2 in p2 do
        if typeof(v2) == "table" and v2.userId then
            t4[v2.userId] = v1
        end
    end

    t3 = t4
end)

local function list(p3, p4) -- line: 41
    local t5 = {}

    for i = 1, 4 do
        local Attribute = p3:GetAttribute(p4 .. i)

        if typeof(Attribute) ~= "number" or not Attribute then
            Attribute = 0
        end

        t5[i] = Attribute
    end

    return t5
end

local function num(p5, p6) -- line: 45
    local Attribute = p5:GetAttribute(p6)

    if typeof(Attribute) ~= "number" or not Attribute then
        Attribute = 0
    end

    return Attribute
end

local t6 = {
    now = function() -- now | line: 48
        return workspace:GetServerTimeNow()
    end,
    rider = function(p7) -- rider | line: 49
        -- upvalues: Players (copy), BikeCatalog (copy), t2 (copy), t3 (ref), list (copy)
        local PlayerByUserId = Players:GetPlayerByUserId(p7)

        if not PlayerByUserId then
            return nil
        end

        local BikeName = PlayerByUserId:GetAttribute("BikeName") or PlayerByUserId:GetAttribute("SelectedBike") or "Ducati"
        local v3 = BikeCatalog.Teams[BikeName]
        local Character = PlayerByUserId.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local v4 = Humanoid and Humanoid.SeatPart
        local t7 = {
            userId = p7,
            name = PlayerByUserId.DisplayName,
            position = t3[p7],
            country = PlayerByUserId:GetAttribute("Country")
        }

        t7.badge = t2[BikeName] or tostring(BikeName):sub(1, 3):upper()
        t7.teamColor = v3 and v3.Color or BikeCatalog.ColorFor(BikeName) or Color3.fromRGB(120, 124, 135)

        local LiveLapStart = PlayerByUserId:GetAttribute("LiveLapStart")

        t7.lapStart = if typeof(LiveLapStart) ~= "number" or not LiveLapStart then 0 else LiveLapStart

        local LiveSectorStart = PlayerByUserId:GetAttribute("LiveSectorStart")

        t7.sectorStart = if typeof(LiveSectorStart) ~= "number" or not LiveSectorStart then 0 else LiveSectorStart

        local LiveGate = PlayerByUserId:GetAttribute("LiveGate")

        t7.gate = if typeof(LiveGate) ~= "number" or not LiveGate then 0 else LiveGate
        t7.valid = PlayerByUserId:GetAttribute("LiveLapValid") ~= false

        local LiveLastFinish = PlayerByUserId:GetAttribute("LiveLastFinish")

        t7.lastFinish = if typeof(LiveLastFinish) ~= "number" or not LiveLastFinish then 0 else LiveLastFinish
        t7.splits = list(PlayerByUserId, "LiveSplit")

        local BestLapTime = PlayerByUserId:GetAttribute("BestLapTime")

        t7.best = if typeof(BestLapTime) ~= "number" or not BestLapTime then 0 else BestLapTime

        local LastLapTime = PlayerByUserId:GetAttribute("LastLapTime")

        t7.last = if typeof(LastLapTime) ~= "number" or not LastLapTime then 0 else LastLapTime
        t7.bestSplits = list(PlayerByUserId, "BestLapSplit")
        t7.bestSectors = list(PlayerByUserId, "BestSector")
        t7.riding = v4 ~= nil and v4.Name == "RiderSeat"
        t7.crashed = Character ~= nil and Character:GetAttribute("RaceCrashActive") == true

        return t7
    end,
    all = function() -- all | line: 67
        -- upvalues: Players (copy), list (copy)
        local t8 = {}

        for _, player in Players:GetPlayers() do
            local t9 = {
                userId = player.UserId
            }
            local BestLapTime = player:GetAttribute("BestLapTime")

            t9.best = typeof(BestLapTime) == "number" and BestLapTime or 0
            t9.bestSplits = list(player, "BestLapSplit")
            t9.bestSectors = list(player, "BestSector")
            table.insert(t8, t9)
        end

        return t8
    end
}
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "SpectateTimingCardsHUD"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 15
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local v5 = Cards.New(ScreenGui, t6)
local v6

local function place() -- line: 81
    -- upvalues: PlayerGui (copy), Cards (copy), t1 (copy), v5 (copy), v6 (ref)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local ChampionshipHUD = PlayerGui:FindFirstChild("ChampionshipHUD")
    local HudScale = if ChampionshipHUD then ChampionshipHUD:GetAttribute("HudScale") else nil

    if not ChampionshipHUD or not HudScale then
        HudScale = math.clamp(math.min(ViewportSize.X / 960, ViewportSize.Y / 540), 0.55, 1.5)
    end

    local v10 = HudScale * t1.Scale

    if not (v6 and v6.Parent) then
        local RaceLobbyHUD = PlayerGui:FindFirstChild("RaceLobbyHUD")

        v6 = RaceLobbyHUD and RaceLobbyHUD:FindFirstChild("CameraMode", true) or nil
    end

    local v11 = v6

    if v11 and v11:IsA("GuiObject") and v11.AbsoluteSize.X > 0 then
        local v12 = (v11.AbsolutePosition.X - ViewportSize.X / 2 - t1.SideGap * HudScale) * 2
        local v13 = Cards.RowWidth()

        if v12 > 0 and v12 < v13 * v10 then
            v10 = v12 / v13
        end
    end

    v5:Place(ViewportSize.X / 2, ViewportSize.Y - t1.BottomGap * HudScale, v10)
end

local SpectateTargetId

RunService.Heartbeat:Connect(function() -- line: 102
    -- upvalues: MotoLegends (copy), JerezRaceHUD (copy), t1 (copy), v5 (copy), place (copy), SpectateTargetId (ref)
    local SessionPhase = MotoLegends:GetAttribute("SessionPhase")
    local SpectateTargetId2 = JerezRaceHUD:GetAttribute("SpectateTargetId")
    local Enabled = t1.Enabled and JerezRaceHUD:GetAttribute("LobbySpectating") == true and t1.Phases[SessionPhase or ""] == true

    if Enabled then
        if typeof(SpectateTargetId2) == "number" and SpectateTargetId2 ~= SpectateTargetId then
            SpectateTargetId = SpectateTargetId2
            v5:Show(SpectateTargetId2)
        end
    else
        SpectateTargetId = nil
        v5:CloseAll()

        if #v5.slots == 0 then
            return
        end
    end

    place()
    v5:Update(SessionPhase)
end)
