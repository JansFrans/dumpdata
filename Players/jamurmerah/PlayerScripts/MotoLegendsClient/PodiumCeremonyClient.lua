-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local PodiumCeremonyPlan = require(MotoLegends:WaitForChild("PodiumCeremonyPlan"))
local PodiumMedal = require(MotoLegends:WaitForChild("PodiumMedal"))
local _require = require
local ok, result = pcall(_require, MotoLegends:WaitForChild("RaceNametags"))
local Beat = PodiumCeremonyPlan.Beat
local t1 = {
    FadeOut = 0.25,
    FadeIn = 0.55,
    EndFade = 0.45,
    Hold = 0.12,
    ReturnFade = 0.6,
    BarsOut = 0.85,
    BarHeight = 0.105,
    MinSeconds = 2.5,
    WideFovFrom = 50,
    WideFovTo = 46,
    Angle = -55,
    DistFrom = 19,
    DistTo = 13,
    UpFrom = 6.5,
    UpTo = 3.5,
    LookUpFrom = 0.8,
    LookUpTo = 1.3,
    FovFrom = 46,
    FovTo = 44,
    WideFrom = { 0, 66, 13 },
    WideTo = { 0, 33, 12 },
    WideLookFrom = { 0, 0, 8 },
    WideLookTo = { 0, 2, 7 }
}

local function clamp01(p1) -- line: 42
    return (math.clamp(p1, 0, 1))
end

local function smooth(p2) -- line: 43
    local v1 = math.clamp(p2, 0, 1)

    return v1 * v1 * (3 - 2 * v1)
end

local function smoother(p3) -- line: 44
    local v2 = math.clamp(p3, 0, 1)

    return v2 * v2 * v2 * (v2 * (v2 * 6 - 15) + 10)
end

local function win(p4, p5, p6) -- line: 45
    local v4 = math.clamp((p4 - p5) / (p6 - p5), 0, 1)

    return v4 * v4 * (3 - 2 * v4)
end

local function band(p7, p8, p9, p10, p11) -- line: 46
    local v6 = math.clamp((p7 - p8) / (p9 - p8), 0, 1)
    local v7 = v6 * v6 * (3 - 2 * v6)
    local v9 = math.clamp((p7 - p10) / (p11 - p10), 0, 1)

    return v7 * (1 - v9 * v9 * (3 - 2 * v9))
end

local function lerp(p12, p13, p14) -- line: 47
    return p12 + (p13 - p12) * p14
end

local function yawOf(p15) -- line: 48
    return (math.atan2(-p15.X, -p15.Z))
end

local function angleTo(p16, p17) -- line: 49
    return (p17 - p16 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

local function flat(p18) -- line: 50
    return (Vector3.new(p18.X, 0, p18.Z))
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "PodiumCutscene"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ScreenInsets = Enum.ScreenInsets.None

local function v12() -- line: 53
    -- upvalues: ScreenGui (copy)
    ScreenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.Off
end

pcall(v12)
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 1001
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function bar(p19, p20) -- line: 57
    -- upvalues: ScreenGui (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p19
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.AnchorPoint = Vector2.new(0, p20)
    Frame.Position = UDim2.fromScale(0, p20)
    Frame.Size = UDim2.fromScale(1, 0)
    Frame.Parent = ScreenGui

    return Frame
end

local v13 = bar("TopBar", 0)
local v14 = bar("BottomBar", 1)
local Frame = Instance.new("Frame")

Frame.Name = "Fade"
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 1
Frame.Size = UDim2.fromScale(1, 1)
Frame.ZIndex = 10
Frame.Parent = ScreenGui

local function tween(p21, p22, p23, p24, p25) -- line: 65
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p21, TweenInfo.new(p22, p24 or Enum.EasingStyle.Sine, p25 or Enum.EasingDirection.InOut), p23)

    tween:Play()

    return tween
end

local function fadeTo(p26, p27) -- line: 69
    -- upvalues: TweenService (copy), Frame (copy)
    if p27 <= 0 then
        Frame.BackgroundTransparency = 1 - p26
    else
        local t2 = {
            BackgroundTransparency = 1 - p26
        }

        TweenService:Create(Frame, TweenInfo.new(p27, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t2):Play()
        task.wait(p27)
    end
end

local function bars(p28, p29, p30, p31) -- line: 73
    -- upvalues: TweenService (copy), t1 (copy), v13 (copy), v14 (copy)
    local v15 = UDim2.fromScale(1, p28 and t1.BarHeight or 0)
    local t3 = {
        Size = v15
    }

    TweenService:Create(v13, TweenInfo.new(p29, p30 or Enum.EasingStyle.Sine, p31 or Enum.EasingDirection.InOut), t3):Play()

    local t4 = {
        Size = v15
    }

    TweenService:Create(v14, TweenInfo.new(p29, p30 or Enum.EasingStyle.Sine, p31 or Enum.EasingDirection.InOut), t4):Play()
end

local t5 = {
    RaceLobbyHUD = true,
    ServerListHUD = true
}
local t6 = {}
local Hidden
local v16 = false

local function hideHud() -- line: 82
    -- upvalues: LocalPlayer (copy), ok (copy), result (copy), ScreenGui (copy), t5 (copy), t6 (copy), Hidden (ref), v16 (ref)
    table.clear(t6)

    for _, child in LocalPlayer.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child ~= ScreenGui and child.Enabled and not t5[child.Name] then
            child.Enabled = false
            table.insert(t6, child)
        end
    end

    if ok and result then
        Hidden = result.Hidden
        result.Hidden = true
    end

    v16 = true
end

RunService.RenderStepped:Connect(function() -- line: 91
    -- upvalues: LocalPlayer (copy), ScreenGui (copy), t5 (copy), t6 (copy), v16 (ref)
    if not v16 then
        return
    end

    for _, child in LocalPlayer.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child ~= ScreenGui and child.Enabled and not t5[child.Name] then
            child.Enabled = false
            table.insert(t6, child)
        end
    end
end)

local function restoreHud() -- line: 97
    -- upvalues: ok (copy), result (copy), t6 (copy), Hidden (ref), v16 (ref)
    v16 = false

    for _, v17 in t6 do
        if v17.Parent then
            v17.Enabled = true
        end
    end

    table.clear(t6)

    if ok and result and Hidden ~= nil then
        result.Hidden = Hidden
        Hidden = nil
    end
end

local t7 = {}

t7[3] = {
    Angle = -60,
    DistFrom = 11.2,
    DistTo = 10.4,
    UpFrom = 6.4,
    UpTo = 5.8,
    LookUpFrom = 2.2,
    LookUpTo = 2.4,
    FovFrom = 54,
    FovTo = 52
}
t7[2] = {
    AngleFrom = 27,
    AngleTo = 60,
    DistFrom = 12.8,
    DistTo = 10.4,
    UpFrom = 6.6,
    UpTo = 5.8,
    LookUpFrom = 2.1,
    LookUpTo = 2.4,
    FovFrom = 56,
    FovTo = 52,
    Follow = 0.45
}
t7[1] = {
    Angle = t1.Angle,
    DistFrom = t1.DistFrom,
    DistTo = t1.DistTo,
    UpFrom = t1.UpFrom,
    UpTo = t1.UpTo,
    LookUpFrom = t1.LookUpFrom,
    LookUpTo = t1.LookUpTo,
    FovFrom = t1.FovFrom,
    FovTo = t1.FovTo
}

local v18 = 4.5 / (PodiumCeremonyPlan.TimeScale or 1)
local v19

local function attr(p32) -- line: 119
    -- upvalues: v19 (ref)
    return v19 and v19:GetAttribute(p32)
end

local function sceneInfo(p33, p34) -- line: 121
    local v20 = "Sc" .. p34

    return {
        i = p34,
        place = p33:GetAttribute(v20 .. "Place") or 1,
        S = p33:GetAttribute(v20 .. "Start") or 0,
        walkAt = p33:GetAttribute(v20 .. "WalkAt") or 0,
        Ta = p33:GetAttribute(v20 .. "Ta") or 0,
        E = p33:GetAttribute(v20 .. "End") or 0,
        stand = p33:GetAttribute(v20 .. "Stand"),
        spot = p33:GetAttribute(v20 .. "Spot")
    }
end

local function sceneIndex(p35, p36, p37) -- line: 127
    local v21 = p35:GetAttribute("Scenes") or 0
    local v22

    for i = 1, v21 do
        if (p35:GetAttribute("Sc" .. i .. "Start") or 0) - (p37 or 0) <= p36 then
            v22 = i
        end
    end

    return v22, v21
end

local function shot(p38) -- line: 132
    -- upvalues: PodiumCeremonyPlan (copy), t1 (copy), t7 (copy), v18 (copy), v19 (ref), sceneInfo (copy), sceneIndex (copy)
    local Origin = v19 and v19:GetAttribute("Origin")
    local Right = v19 and v19:GetAttribute("Right")
    local ToAudience = v19 and v19:GetAttribute("ToAudience")

    if typeof(Origin) ~= "Vector3" or typeof(Right) ~= "Vector3" or typeof(ToAudience) ~= "Vector3" then
        return nil
    end

    local function at(p39, p40, p41) -- line: 135
        -- upvalues: Origin (copy), Right (copy), ToAudience (copy)
        return Origin + Right * p39 + ToAudience * p40 + Vector3.new(0, 1, 0) * p41
    end

    local v23, v24 = sceneIndex(v19, p38)

    if v24 ~= 0 then
        local v25 = sceneInfo(v19, v23 or 1)
        local v26 = t7[v25.place] or t7[1]
        local stand, spot = v25.stand, v25.spot

        if typeof(stand) ~= "Vector3" or typeof(spot) ~= "Vector3" then
            return nil
        end

        local v31 = math.clamp((p38 - v25.S) / math.max(math.max(v25.Ta, v25.S + v18) - v25.S, 1), 0, 1)
        local v32 = v31 * v31 * v31 * (v31 * (v31 * 6 - 15) + 10)
        local v34 = (Vector3.new(stand.X, 0, stand.Z) + Vector3.new(spot.X, 0, spot.Z)) / 2
        local Angle = v26.Angle

        if not Angle then
            local AngleFrom = v26.AngleFrom

            Angle = AngleFrom + (v26.AngleTo - AngleFrom) * v32
        end

        local v35 = math.rad(Angle)
        local Unit = (ToAudience * math.cos(v35) + Right * math.sin(v35)).Unit
        local DistFrom = v26.DistFrom
        local v36 = v34 + Unit * (DistFrom + (v26.DistTo - DistFrom) * v32)
        local Y = stand.Y
        local UpFrom = v26.UpFrom
        local v37 = v36 + Vector3.new(0, 1, 0) * (Y + (UpFrom + (v26.UpTo - UpFrom) * v32))
        local v38 = v34

        if v26.Follow then
            local PodiumPresenter = v19:FindFirstChild("PodiumPresenter")

            PodiumPresenter = PodiumPresenter and PodiumPresenter:IsA("Model") and PodiumPresenter:GetPivot().Position

            if PodiumPresenter and (Vector3.new(PodiumPresenter.X, 0, PodiumPresenter.Z) - v34).Magnitude < 40 then
                v38 = v34:Lerp(Vector3.new(PodiumPresenter.X, 0, PodiumPresenter.Z), v26.Follow * (1 - v32))
            end
        end

        local lookAt = CFrame.lookAt
        local Y2 = stand.Y
        local LookUpFrom = v26.LookUpFrom
        local v39 = lookAt(v37, v38 + Vector3.new(0, 1, 0) * (Y2 + (LookUpFrom + (v26.LookUpTo - LookUpFrom) * v32)))
        local FovFrom = v26.FovFrom

        return v39, FovFrom + (v26.FovTo - FovFrom) * v32
    end

    local v41 = math.clamp((p38 - (v19 and v19:GetAttribute("T0") or 0)) / PodiumCeremonyPlan.Scene1, 0, 1)
    local v42 = v41 * v41 * v41 * (v41 * (v41 * 6 - 15) + 10)

    local function v(p42, p43) -- line: 140
        -- upvalues: v42 (copy), Origin (copy), Right (copy), ToAudience (copy)
        local v43 = p42[1]
        local v44 = v43 + (p43[1] - v43) * v42
        local v45 = p42[2]
        local v46 = v45 + (p43[2] - v45) * v42
        local v47 = p42[3]
        local v48 = v47 + (p43[3] - v47) * v42

        return Origin + Right * v44 + ToAudience * v46 + Vector3.new(0, 1, 0) * v48
    end

    local lookAt = CFrame.lookAt
    local WideFrom, WideTo = t1.WideFrom, t1.WideTo
    local v49 = WideFrom[1]
    local v50 = v49 + (WideTo[1] - v49) * v42
    local v51 = WideFrom[2]
    local v52 = v51 + (WideTo[2] - v51) * v42
    local v53 = WideFrom[3]
    local v54 = v53 + (WideTo[3] - v53) * v42
    local v55 = Origin + Right * v50 + ToAudience * v52 + Vector3.new(0, 1, 0) * v54
    local WideLookFrom, WideLookTo = t1.WideLookFrom, t1.WideLookTo
    local v56 = WideLookFrom[1]
    local v57 = v56 + (WideLookTo[1] - v56) * v42
    local v58 = WideLookFrom[2]
    local v59 = v58 + (WideLookTo[2] - v58) * v42
    local v60 = WideLookFrom[3]
    local v61 = v60 + (WideLookTo[3] - v60) * v42
    local v62 = lookAt(v55, Origin + Right * v57 + ToAudience * v59 + Vector3.new(0, 1, 0) * v61)
    local WideFovFrom = t1.WideFovFrom

    return v62, WideFovFrom + (t1.WideFovTo - WideFovFrom) * v42
end

local FieldOfView

local function bindCamera() -- line: 161
    -- upvalues: RunService (copy), shot (copy)
    RunService:BindToRenderStep("PodiumCutscene", Enum.RenderPriority.Camera.Value + 31, function() -- line: 162
        -- upvalues: shot (copy)
        local v63, v64 = shot(workspace:GetServerTimeNow())

        if not v63 then
            return
        end

        local CurrentCamera = workspace.CurrentCamera

        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.CFrame = v63
        CurrentCamera.FieldOfView = v64
    end)
end

local function unbindCamera() -- line: 167
    -- upvalues: RunService (copy), LocalPlayer (copy), FieldOfView (ref)
    local function v65() -- line: 168
        -- upvalues: RunService (copy)
        RunService:UnbindFromRenderStep("PodiumCutscene")
    end

    pcall(v65)

    local CurrentCamera = workspace.CurrentCamera

    if FieldOfView then
        CurrentCamera.FieldOfView = FieldOfView
        FieldOfView = nil
    end

    local v66 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    CurrentCamera.CameraType = Enum.CameraType.Custom

    if v66 then
        CurrentCamera.CameraSubject = v66
    end
end

local v67

local function cutscenesOn() -- line: 180
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("GfxCutscenes") ~= false
end

local function eligible() -- line: 181
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("GfxCutscenes") == false then
        return false
    end

    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

    return not (JerezRaceHUD and JerezRaceHUD:GetAttribute("Freecam") == true)
end

local function stillOn(p44, p45) -- line: 188
    -- upvalues: LocalPlayer (copy), v67 (ref)
    if v67 == p45 and p44.Parent ~= nil and p44:GetAttribute("Id") == p45 and (p44:GetAttribute("End") or 0) > 0 then
        return LocalPlayer:GetAttribute("GfxCutscenes") ~= false
    end

    return false
end

local function waitFor(p46, p47, p48, p49) -- line: 190
    -- upvalues: LocalPlayer (copy), v67 (ref)
    while v67 == p47 and p46.Parent ~= nil and p46:GetAttribute("Id") == p47 and (p46:GetAttribute("End") or 0) > 0 and LocalPlayer:GetAttribute("GfxCutscenes") ~= false and workspace:GetServerTimeNow() < (p46:GetAttribute(p48) or 0) + (p49 or 0) do
        task.wait()
    end

    if v67 == p47 and p46.Parent ~= nil and p46:GetAttribute("Id") == p47 and (p46:GetAttribute("End") or 0) > 0 then
        return LocalPlayer:GetAttribute("GfxCutscenes") ~= false
    end

    return false
end

local function play(p50, p51) -- line: 194
    -- upvalues: RunService (copy), TweenService (copy), LocalPlayer (copy), PodiumCeremonyPlan (copy), ok (copy), result (copy), t1 (copy), ScreenGui (copy), v13 (copy), v14 (copy), Frame (copy), bars (copy), t6 (copy), Hidden (ref), v16 (ref), hideHud (copy), v19 (ref), shot (copy), FieldOfView (ref), unbindCamera (copy), v67 (ref), waitFor (copy)
    local v68 = p50:GetAttribute("T0") or 0
    local _ = p50:GetAttribute("S2") or 0
    local v69 = p50:GetAttribute("End") or 0
    local ServerTimeNow = workspace:GetServerTimeNow()

    if v69 - ServerTimeNow < t1.MinSeconds then
        return
    end

    local v70 = false

    if LocalPlayer:GetAttribute("GfxCutscenes") ~= false then
        local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

        v70 = not (JerezRaceHUD and JerezRaceHUD:GetAttribute("Freecam") == true)
    end

    if not v70 then
        return
    end

    v67 = p51
    v19 = p50
    LocalPlayer:SetAttribute("PodiumCutscenePlaying", true)
    LocalPlayer:SetAttribute("CutscenePlaying", true)
    ScreenGui.Enabled = true
    v13.Size = UDim2.fromScale(1, t1.BarHeight)
    v14.Size = UDim2.fromScale(1, t1.BarHeight)

    if ServerTimeNow < v68 then
        local FadeOut = t1.FadeOut

        if FadeOut <= 0 then
            Frame.BackgroundTransparency = 0
        else
            local t8 = {
                BackgroundTransparency = 0
            }

            TweenService:Create(Frame, TweenInfo.new(FadeOut, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t8):Play()
            task.wait(FadeOut)
        end
    else
        Frame.BackgroundTransparency = 0
    end

    FieldOfView = workspace.CurrentCamera.FieldOfView
    hideHud()
    RunService:BindToRenderStep("PodiumCutscene", Enum.RenderPriority.Camera.Value + 31, function() -- line: 162
        -- upvalues: shot (copy)
        local v71, v72 = shot(workspace:GetServerTimeNow())

        if not v71 then
            return
        end

        local CurrentCamera = workspace.CurrentCamera

        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.CFrame = v71
        CurrentCamera.FieldOfView = v72
    end)

    local T0 = waitFor(p50, p51, "T0")

    if T0 then
        local FadeIn = t1.FadeIn

        if FadeIn <= 0 then
            Frame.BackgroundTransparency = 1
        else
            local t9 = {
                BackgroundTransparency = 1
            }

            TweenService:Create(Frame, TweenInfo.new(FadeIn, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t9):Play()
            task.wait(FadeIn)
        end
    end

    for i = 2, p50:GetAttribute("Scenes") or 0 do
        local v73 = "Sc" .. i .. "Start"
        local v74

        if T0 and workspace:GetServerTimeNow() < (p50:GetAttribute(v73) or 0) then
            local v75 = waitFor(p50, p51, v73, -PodiumCeremonyPlan.CutFade)

            if v75 then
                local CutFade = PodiumCeremonyPlan.CutFade

                if CutFade <= 0 then
                    Frame.BackgroundTransparency = 0
                else
                    local t10 = {
                        BackgroundTransparency = 0
                    }

                    TweenService:Create(Frame, TweenInfo.new(CutFade, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t10):Play()
                    task.wait(CutFade)
                end

                v74 = waitFor(p50, p51, v73)

                if v74 then
                    local CutFade = PodiumCeremonyPlan.CutFade

                    if CutFade <= 0 then
                        Frame.BackgroundTransparency = 1
                    else
                        local t11 = {
                            BackgroundTransparency = 1
                        }

                        TweenService:Create(Frame, TweenInfo.new(CutFade, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t11):Play()
                        task.wait(CutFade)
                    end
                end
            else
                v74 = v75
            end
        else
            v74 = T0
        end

        T0 = v74
    end

    local EndFade = T0 and waitFor(p50, p51, "End", -t1.EndFade) and t1.EndFade or 0.2

    if EndFade <= 0 then
        Frame.BackgroundTransparency = 0
    else
        local t12 = {
            BackgroundTransparency = 0
        }

        TweenService:Create(Frame, TweenInfo.new(EndFade, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t12):Play()
        task.wait(EndFade)
    end

    unbindCamera()
    v16 = false

    for _, v76 in t6 do
        if v76.Parent then
            v76.Enabled = true
        end
    end

    table.clear(t6)

    if ok and result and Hidden ~= nil then
        result.Hidden = Hidden
        Hidden = nil
    end

    LocalPlayer:SetAttribute("CutscenePlaying", false)
    task.wait(t1.Hold)

    local ReturnFade = t1.ReturnFade

    if ReturnFade <= 0 then
        Frame.BackgroundTransparency = 1
    else
        local t13 = {
            BackgroundTransparency = 1
        }

        TweenService:Create(Frame, TweenInfo.new(ReturnFade, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t13):Play()
        task.wait(ReturnFade)
    end

    bars(false, t1.BarsOut, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    task.wait(t1.BarsOut)

    if v67 == p51 then
        v67 = nil
        ScreenGui.Enabled = false
    end

    LocalPlayer:SetAttribute("PodiumCutscenePlaying", false)
end

local t14 = {}

local function check(p52) -- line: 228
    -- upvalues: v67 (ref), play (copy), t14 (copy)
    local Id = p52:GetAttribute("Id")

    if typeof(Id) == "number" and not t14[Id] and v67 == nil then
        t14[Id] = true
        task.spawn(play, p52, Id)
    end
end

workspace.ChildAdded:Connect(function(p53) -- line: 232
    -- upvalues: v67 (ref), play (copy), t14 (copy)
    if p53.Name == "PodiumCeremony" and p53:IsA("Folder") then
        local Id = p53:GetAttribute("Id")

        if typeof(Id) == "number" and not t14[Id] and v67 == nil then
            t14[Id] = true
            task.spawn(play, p53, Id)
        end
    end
end)

local ChildAdded = workspace:FindFirstChild("PodiumCeremony")

if ChildAdded then
    local Id = ChildAdded:GetAttribute("Id")

    if typeof(Id) == "number" and not t14[Id] and v67 == nil then
        t14[Id] = true
        task.spawn(play, ChildAdded, Id)
    end
end

local t15 = {
    (Vector3.new(-0.22, -0.2, -1.3)),
    (Vector3.new(0.22, -0.2, -1.3))
}
local v77 = 2.7 * (PodiumCeremonyPlan.TimeScale or 1)

local function hash(p54, p55) -- line: 256
    local v79 = math.sin(p54 * 127.1 + p55 * 311.7) * 43758.5453

    return v79 - math.floor(v79)
end

local function held(p56, p57, p58, p59) -- line: 257
    local v81 = math.floor(p56 / p58)
    local v82 = v81 * p58
    local v83 = p57 + 0.37
    local v85 = math.sin(v81 * 127.1 + v83 * 311.7) * 43758.5453
    local v86 = v82 + (v85 - math.floor(v85)) * p58 * 0.45
    local v88 = math.sin((v81 - 1) * 127.1 + p57 * 311.7) * 43758.5453
    local v89 = v88 - math.floor(v88)
    local v91 = math.sin(v81 * 127.1 + p57 * 311.7) * 43758.5453
    local v92 = v91 - math.floor(v91)
    local v94 = math.clamp((p56 - v86) / p59, 0, 1)
    local v95 = v94 * v94 * v94 * (v94 * (v94 * 6 - 15) + 10)

    return (v89 + (v92 - v89) * v95) * 2 - 1
end

local function wander(p60, p61) -- line: 262
    return math.noise(p60, p61, 0.31) * 1.3 + math.noise(p60 * 2.3, p61 + 4.7, 0.77) * 0.6
end

local function spring(p62, p63, p64, p65, p66) -- line: 263
    local v96 = 6.283185307179586 * p64
    local v99 = math.max(1, (math.ceil(p66 * 120)))
    local v100 = p66 / v99

    for _ = 1, v99 do
        p62.v += (v96 * v96 * (p63 - p62.x) - 2 * p65 * v96 * p62.v) * v100
        p62.x += p62.v * v100
    end

    return p62.x
end

local function rightOf(p67) -- line: 269
    return (Vector3.new(math.cos(p67), 0, -math.sin(p67)))
end

local function newPath(p68) -- line: 272
    -- upvalues: PodiumCeremonyPlan (copy)
    local t16 = {
        p68[1]
    }

    for i = 2, #p68 - 1 do
        local v103 = p68[i - 1]
        local v104 = p68[i]
        local v105 = p68[i + 1]
        local v106 = v104 - v103
        local v107 = Vector3.new(v106.X, 0, v106.Z).Magnitude * 0.45
        local v108 = v105 - v104
        local v110 = math.min(1.8, v107, Vector3.new(v108.X, 0, v108.Z).Magnitude * 0.45)

        if v110 < 0.05 then
            table.insert(t16, v104)
        else
            local v111 = v104 + (v103 - v104).Unit * v110
            local v112 = v104 + (v105 - v104).Unit * v110

            for j = 0, 8 do
                local v113 = j / 8

                table.insert(t16, v111 * (1 - v113) ^ 2 + v104 * ((1 - v113) * 2 * v113) + v112 * (v113 * v113))
            end
        end
    end

    table.insert(t16, p68[#p68])

    local v116 = PodiumCeremonyPlan.Prepare(t16)
    local v117 = #t16
    local v118 = t16[2] - t16[1]
    local v119 = Vector3.new(v118.X, 0, v118.Z)
    local v120 = t16[v117] - t16[v117 - 1]
    local v121 = Vector3.new(v120.X, 0, v120.Z)

    return {
        pts = t16,
        cum = v116,
        len = v116[v117],
        d0 = v119.Magnitude > 1E-04 and v119.Unit or Vector3.new(0, 0, -1),
        d1 = v121.Magnitude > 1E-04 and v121.Unit or Vector3.new(0, 0, -1)
    }
end

local function pathAt(p69, p70) -- line: 287
    local pts, cum = p69.pts, p69.cum
    local v122 = #p69.pts

    if p70 <= 0 then
        return pts[1] + p69.d0 * p70
    end

    if cum[v122] <= p70 then
        return pts[v122] + p69.d1 * (p70 - cum[v122])
    end

    local n1 = 2

    while cum[n1] < p70 do
        n1 += 1
    end

    local v123 = cum[n1] - cum[n1 - 1]

    return pts[n1 - 1]:Lerp(pts[n1], v123 > 1E-06 and (p70 - cum[n1 - 1]) / v123 or 1)
end

local function pathDir(p71, p72) -- line: 296
    -- upvalues: pathAt (copy)
    local v124 = pathAt(p71, p72 + 0.45) - pathAt(p71, p72 - 0.45)
    local v125 = Vector3.new(v124.X, 0, v124.Z)

    return v125.Magnitude > 1E-04 and v125.Unit or p71.d0
end

local function stance(p73, p74) -- line: 301
    local v127 = Vector3.new(p73.X, p73.Y - 3, p73.Z)
    local v130 = Vector3.new(math.cos(p74), 0, -math.sin(p74))

    return {
        dL = true,
        dR = true,
        kL = 0,
        kR = 0,
        L = v127 - v130 * 0.56,
        R = v127 + v130 * 0.56
    }
end

local function setupWalk(p75, p76, p77) -- line: 308
    local v131 = (p77 and p76.R or p76.L) - p75.pts[1]
    local v132 = Vector3.new(v131.X, 0, v131.Z):Dot(p75.d0)
    local v135 = math.max(1, (math.floor(2 * (p75.len - v132) / 3.5515848557241583 + 0.5)))

    p75.Lc = math.max(2 * (p75.len - v132) / v135, 0.4)
    p75.o = v132
    p75.stood = p76
    p75.firstLeft = p77
    p75.amp = math.asin((math.clamp(p75.Lc / 8, 0, 0.9)))
end

local function walkFeet(p78, p79) -- line: 315
    -- upvalues: pathAt (copy)
    local Lc, o = p78.Lc, p78.o

    local function plant(p80, p81) -- line: 317
        -- upvalues: p78 (copy), pathAt (copy)
        local v139 = pathAt(p78, p81)
        local v140 = pathAt(p78, p81 + 0.45) - pathAt(p78, p81 - 0.45)
        local v141 = Vector3.new(v140.X, 0, v140.Z)
        local Unit = v141.Magnitude > 1E-04 and v141.Unit or p78.d0

        return Vector3.new(v139.X, v139.Y - 3, v139.Z) + Vector3.new(-Unit.Z, 0, Unit.X) * (if p80 then -0.56 else 0.56)
    end

    local function foot(p82) -- line: 321
        -- upvalues: p78 (copy), p79 (copy), Lc (copy), o (copy), pathAt (copy)
        local v145 = p82 == p78.firstLeft
        local L = v145 and p78.stood.L or p78.stood.R
        local L2 = L

        local function spot(p83) -- line: 324
            -- upvalues: p82 (copy), v145 (copy), L2 (copy), p78 (copy), Lc (copy), o (copy), pathAt (copy)
            if p83 < 0 or p83 == 0 and not p82 then
                return L2
            end

            local v147 = o + (p82 and Lc / 2 or 0) + p83 * Lc
            local v148 = pathAt(p78, v147)
            local v149 = pathAt(p78, v147 + 0.45) - pathAt(p78, v147 - 0.45)
            local v150 = Vector3.new(v149.X, 0, v149.Z)
            local Unit = v150.Magnitude > 1E-04 and v150.Unit or p78.d0

            return Vector3.new(v148.X, v148.Y - 3, v148.Z) + Vector3.new(-Unit.Z, 0, Unit.X) * (if v145 then -0.56 else 0.56)
        end

        if p79 <= 0.001 then
            return L, true, 0
        end

        local v154 = p82 and (p79 - o - Lc / 4) / Lc or (p79 - o + Lc / 4) / Lc
        local v155 = math.floor(v154)
        local v156 = v154 - v155

        if v156 < 0.5 then
            if not (v155 < 0) and (v155 ~= 0 or p82) then
                local v157 = if p82 then Lc / 2 else nil

                if not p82 or not v157 then
                    v157 = 0
                end

                local v158 = o + v157 + v155 * Lc
                local v159 = pathAt(p78, v158)
                local v160 = pathAt(p78, v158 + 0.45) - pathAt(p78, v158 - 0.45)
                local v161 = Vector3.new(v160.X, 0, v160.Z)
                local Unit = v161.Magnitude > 1E-04 and v161.Unit or p78.d0

                L = Vector3.new(v159.X, v159.Y - 3, v159.Z) + Vector3.new(-Unit.Z, 0, Unit.X) * (if v145 then -0.56 else 0.56)
            end

            return L, true, 0
        end

        local v165, v166

        if p82 and v155 == -1 then
            local v169 = math.clamp(p79 / math.max(o + Lc / 4, 0.05), 0, 1)
            local v170 = v169 * v169 * v169 * (v169 * (v169 * 6 - 15) + 10)

            if v170 then
                v165 = v170
                v166 = true
            else
                v166 = false
            end
        else
            v166 = false
        end

        if not v166 then
            local v172 = math.clamp((v156 - 0.5) / 0.5, 0, 1)

            v165 = v172 * v172 * v172 * (v172 * (v172 * 6 - 15) + 10)
        end

        local v173

        if not (v155 < 0) and (v155 ~= 0 or p82) then
            local v174 = if p82 then Lc / 2 else nil

            if not p82 or not v174 then
                v174 = 0
            end

            local v175 = o + v174 + v155 * Lc
            local v176 = pathAt(p78, v175)
            local v177 = pathAt(p78, v175 + 0.45) - pathAt(p78, v175 - 0.45)
            local v178 = Vector3.new(v177.X, 0, v177.Z)
            local Unit = v178.Magnitude > 1E-04 and v178.Unit or p78.d0

            v173 = Vector3.new(v176.X, v176.Y - 3, v176.Z) + Vector3.new(-Unit.Z, 0, Unit.X) * (if v145 then -0.56 else 0.56)
        else
            v173 = L
        end

        local v182 = v155 + 1

        if not (v182 < 0) and (v182 ~= 0 or p82) then
            local v183 = if p82 then Lc / 2 else nil

            if not p82 or not v183 then
                v183 = 0
            end

            local v184 = o + v183 + v182 * Lc
            local v185 = pathAt(p78, v184)
            local v186 = pathAt(p78, v184 + 0.45) - pathAt(p78, v184 - 0.45)
            local v187 = Vector3.new(v186.X, 0, v186.Z)
            local Unit = v187.Magnitude > 1E-04 and v187.Unit or p78.d0

            L = Vector3.new(v185.X, v185.Y - 3, v185.Z) + Vector3.new(-Unit.Z, 0, Unit.X) * (if v145 then -0.56 else 0.56)
        end

        return v173:Lerp(L, v165), false, v165
    end

    local v191, v192, v193 = foot(false)
    local v194, v195, v196 = foot(true)
    local v197 = not p78.firstLeft
    local v198 = if v197 then 1 else -1
    local v199 = 6.283185307179586 * (p79 - o) / Lc
    local t18 = if v197 then {
        L = v191,
        R = v194,
        dL = v192,
        dR = v195,
        kL = v193,
        kR = v196
    } else {
        L = v194,
        R = v191,
        dL = v195,
        dR = v192,
        kL = v196,
        kR = v193
    }
    local v200 = -v198 * math.sin(v199)
    local v201 = v198 * math.cos(v199)
    local v204 = -v198 * math.sin(v199 - 0.35)

    t18.aheadL = v200
    t18.overL = v201
    t18.armL = v204
    t18.ph = v199

    if p78.len - 0.001 <= p79 then
        t18.dL = true
        t18.dR = true
        t18.kL = 0
        t18.kR = 0
    end

    return t18
end

local function replant(p84, p85, p86, p87, p88, p89) -- line: 345
    local v206 = math.max(p88 - p87, 0.1)
    local v208 = math.clamp((p86 - p87) / (v206 * 0.5), 0, 1)
    local v209 = v208 * v208 * v208 * (v208 * (v208 * 6 - 15) + 10)
    local v211 = math.clamp((p86 - p87 - v206 * 0.5) / (v206 * 0.5), 0, 1)
    local v212 = v211 * v211 * v211 * (v211 * (v211 * 6 - 15) + 10)
    local v213 = if not p89 or not v209 then v212 else v209

    if p89 and v212 then
        v209 = v212
    end

    return {
        L = p84.L:Lerp(p85.L, v213),
        R = p84.R:Lerp(p85.R, v209),
        dL = v213 <= 0 or v213 >= 1,
        dR = v209 <= 0 or v209 >= 1,
        kL = v213,
        kR = v209
    }
end

local function hipHeight(p90, p91, p92, p93, p94, p95) -- line: 352
    local n2 = 1e999

    for _, v214 in {
            {
                p93.L,
                p93.dL,
                -0.5
            },
            {
                p93.R,
                p93.dR,
                0.5
            }
        } do
        if v214[2] then
            local v216 = p90 * Vector3.new(v214[3], 0, 0)
            local v219 = Vector3.new(v214[1].X - (p91 + v216.X), 0, v214[1].Z - (p92 + v216.Z))

            n2 = math.min(n2, v214[1].Y + math.sqrt((math.max(4 - v219:Dot(v219), 0.5))) - v216.Y)
        end
    end

    if n2 == 1e999 then
        n2 = p94 + 2
    end

    return n2 - math.max(p95 - math.max(p94 + 2 - n2, 0), 0) * 0.35
end

local function aimLeg(p96, p97, p98, p99, p100) -- line: 364
    local v226 = Vector3.new(if p98 then -0.5 else 0.5, -1, 0)
    local v227 = p97:VectorToObjectSpace(p99 - p97 * v226)
    local v228, v229

    if v227.Magnitude > 0.001 then
        local Unit = v227.Unit

        v229 = math.asin((math.clamp(Unit.X, -1, 1)))
        v228 = math.atan2(-Unit.Z, -Unit.Y)
    else
        v228 = 0
        v229 = 0
    end

    p96.C0 = CFrame.new(v226) * CFrame.Angles(v228 + (p100 or 0), 0, v229)
end

local t20 = {}

local function presenterRig(p101) -- line: 375
    -- upvalues: PodiumCeremonyPlan (copy), newPath (copy), t20 (copy)
    local v233 = t20[p101]

    if v233 then
        return v233
    end

    local Torso = p101:FindFirstChild("Torso")
    local HumanoidRootPart = p101:FindFirstChild("HumanoidRootPart")

    if not Torso or not HumanoidRootPart then
        return nil
    end

    local v234 = Torso:FindFirstChild("Left Shoulder")
    local v235 = Torso:FindFirstChild("Right Shoulder")
    local v236 = Torso:FindFirstChild("Left Hip")
    local v237 = Torso:FindFirstChild("Right Hip")

    if not (v234 and v235 and v236 and v237) then
        return nil
    end

    local function path(p102) -- line: 382
        -- upvalues: p101 (copy)
        local t21 = {}

        for i = 1, p101:GetAttribute(p102 .. "N") or 0 do
            local Attribute = p101:GetAttribute(p102 .. i)

            if typeof(Attribute) ~= "Vector3" then
                return nil
            end

            t21[i] = Attribute
        end

        return if not (#t21 < 2) then t21 else nil
    end

    local Back = path("Back")

    if not Back then
        return nil
    end

    local t22 = {}
    local t23 = {}

    for i = 1, p101:GetAttribute("Scenes") or 0 do
        local v238 = path("Sc" .. i .. "Path")

        if v238 then
            t22[i] = newPath(v238)
            t23[i] = PodiumCeremonyPlan.Length(v238)
        end
    end

    v234.C1 = CFrame.new(0, 1, 0)
    v235.C1 = CFrame.new(0, 1, 0)
    v236.C1 = CFrame.new(0, 1, 0)
    v237.C1 = CFrame.new(0, 1, 0)

    local Neck = Torso:FindFirstChild("Neck")
    local v239 = math.random() * 20
    local t24 = {
        ls = v234,
        rs = v235,
        lh = v236,
        rh = v237,
        neck = Neck,
        neckC0 = Neck and Neck.C0,
        seed = v239,
        breath = 3.5 + v239 % 1 * 0.7,
        paths = t22,
        server = t23,
        ready = {},
        back = newPath(Back),
        backServer = PodiumCeremonyPlan.Length(Back),
        hy = {
            x = 0,
            v = 0
        },
        hp = {
            x = 0,
            v = 0
        },
        swX = {
            x = 0,
            v = 0
        },
        swZ = {
            x = 0,
            v = 0
        }
    }

    t20[p101] = t24

    return t24
end

local function riderParts(p103, p104) -- line: 407
    local v240 = p104 and p103:FindFirstChild("Sc" .. p104 .. "Rider")

    v240 = v240 and v240:IsA("ObjectValue") and v240.Value

    if not (v240 and v240.Parent and v240:IsA("Model")) then
        return nil
    end

    return v240, v240:FindFirstChild("UpperTorso") or v240:FindFirstChild("Torso"), v240:FindFirstChild("RightHand") or v240:FindFirstChild("Right Arm")
end

local function parkMedals(p105, p106, p107) -- line: 414
    for _, child in p105:GetChildren() do
        if child ~= p106 and child:IsA("Model") and child.Name:sub(1, 9) == "HeldMedal" then
            child:PivotTo(CFrame.new(p107))
        end
    end
end

local function blendArm(p108, p109, p110) -- line: 420
    local ax = p108.ax
    local t25 = {}

    t25.ax = ax + (p109.ax - ax) * p110

    local az = p108.az

    t25.az = az + (p109.az - az) * p110

    local sx = p108.sx

    t25.sx = sx + (p109.sx - sx) * p110

    return t25
end

local function aimArm(p111, p112, p113) -- line: 422
    local n3 = 1.5
    local n4 = 0
    local n5 = 0

    for _ = 1, 2 do
        local v241 = if p112 then -n3 else nil
        local v243 = p113 - p111 * Vector3.new(if not p112 or not v241 then n3 else v241, 1, 0)

        if v243.Magnitude < 0.001 then
            break
        end

        local v244 = p111:VectorToObjectSpace(v243.Unit)

        n4 = math.atan2(-v244.Z, -v244.Y)
        n5 = math.atan2(v244.X, (math.sqrt(v244.Y * v244.Y + v244.Z * v244.Z)))
        n3 = 1.5 - 0.2 * math.clamp(n4 / 1.3, 0, 1)
    end

    return {
        ax = n4,
        az = n5,
        sx = n3
    }
end

local function armC0(p114, p115) -- line: 433
    return CFrame.new(p114 and -p115.sx or p115.sx, 1, 0) * CFrame.Angles(p115.ax, 0, p115.az)
end

local function gripOf(p116, p117, p118) -- line: 434
    return p116 * (CFrame.new(p117 and -p118.sx or p118.sx, 1, 0) * CFrame.Angles(p118.ax, 0, p118.az)) * Vector3.new(0, -1.85, 0)
end

local function lookAt(p119, p120, p121, p122, p123) -- line: 436
    -- upvalues: spring (copy)
    local v250, v251

    if p121 then
        local v252 = p120:PointToObjectSpace(p121) - Vector3.new(0, 1.5, 0)

        v250 = math.clamp(math.atan2(-v252.X, -v252.Z), -1.15, 1.15)
        v251 = math.clamp(math.atan2(-v252.Y, (math.sqrt(v252.X * v252.X + v252.Z * v252.Z))), -0.6, 0.55)
    else
        v250 = 0
        v251 = 0
    end

    local v260 = spring(p119.hy, v250, 2.6, 0.85, p122)
    local v261 = spring(p119.hp, v251, 2.6, 0.85, p122)

    if p119.neck and p119.neckC0 then
        p119.neck.C0 = p119.neckC0 * CFrame.Angles(0, 0, v260) * CFrame.Angles(v261 + (p123 or 0), 0, 0)
    end
end

local v262

local function rightArmLengths(p124) -- line: 449
    local v263 = p124 and p124:FindFirstChild("RightUpperArm")
    local v264 = p124 and p124:FindFirstChild("RightLowerArm")
    local v265 = p124 and p124:FindFirstChild("RightHand")

    if not (v263 and v264 and v265) then
        return nil
    end

    local RightShoulderRigAttachment = v263:FindFirstChild("RightShoulderRigAttachment")
    local RightElbowRigAttachment = v263:FindFirstChild("RightElbowRigAttachment")
    local RightElbowRigAttachment2 = v264:FindFirstChild("RightElbowRigAttachment")
    local RightWristRigAttachment = v264:FindFirstChild("RightWristRigAttachment")
    local RightWristRigAttachment2 = v265:FindFirstChild("RightWristRigAttachment")
    local RightGripAttachment = v265:FindFirstChild("RightGripAttachment")

    if not (RightShoulderRigAttachment and RightElbowRigAttachment and RightElbowRigAttachment2 and RightWristRigAttachment and RightWristRigAttachment2) then
        return nil
    end

    return (RightElbowRigAttachment.Position - RightShoulderRigAttachment.Position).Magnitude, (RightWristRigAttachment.Position - RightElbowRigAttachment2.Position).Magnitude + ((RightGripAttachment and RightGripAttachment.Position or Vector3.new(0, 0, 0)) - RightWristRigAttachment2.Position).Magnitude
end

local function updatePresenter(p125, p126, p127, p128, p129, p130) -- line: 458
    -- upvalues: PodiumCeremonyPlan (copy), PodiumMedal (copy), Beat (copy), sceneInfo (copy), sceneIndex (copy), t15 (copy), v77 (copy), held (copy), spring (copy), pathAt (copy), stance (copy), setupWalk (copy), walkFeet (copy), replant (copy), hipHeight (copy), aimLeg (copy), riderParts (copy), parkMedals (copy), blendArm (copy), aimArm (copy), lookAt (copy), v262 (ref), rightArmLengths (copy)
    local HomeLook = p126:GetAttribute("HomeLook")

    if typeof(HomeLook) ~= "Vector3" then
        return
    end

    local v266, v267 = sceneIndex(p125, p128, 0.05)

    if not v266 then
        local v268 = sceneInfo(p125, 1)
        local v269 = typeof(v268.spot) == "Vector3"
        local stand = if v269 then v268.spot else nil

        if not v269 or not stand then
            stand = p126:GetPivot().Position
        end

        local spot = stand - Vector3.new(0, 60, 0)

        p126:PivotTo(CFrame.new(spot))
        parkMedals(p125, nil, spot - Vector3.new(0, 2, 0))
    else
        local v270 = sceneInfo(p125, v266)
        local spot, stand = v270.spot, v270.stand

        if typeof(spot) ~= "Vector3" or typeof(stand) ~= "Vector3" then
            return
        end

        local v271 = v266 == v267
        local walkAt, v272 = v270.walkAt, v270.Ta

        v267 = p125:GetAttribute("ReturnAt") or 0

        local v273 = if not v271 or not v267 then v270.E + PodiumCeremonyPlan.CutFade + 0.1 else v267

        if p127.scene ~= v266 then
            p127.scene = v266
            p127.lastMid = nil
            p127.lastVel = nil
            p127.swX = {
                x = 0,
                v = 0
            }
            p127.swZ = {
                x = 0,
                v = 0
            }
        end

        local v274 = p129 + p127.seed
        local v276 = math.sin(v274 * 2 * 3.141592653589793 / p127.breath)
        local v275 = p127.paths[v266]
        local back = p127.back
        local v277 = stand - spot
        local v280 = Vector3.new(v277.X, 0, v277.Z)

        v277 = math.atan2(-v280.X, -v280.Z)

        local v283 = math.atan2(-HomeLook.X, -HomeLook.Z)
        local v284, v285, v286, v287, v288, v289, v290

        if not p127.ready[v266] then
            if v275 then
                local v291 = v275.pts[1]

                v287 = v275.d0
                v288 = -v287.X
                v289 = -v287.Z
                setupWalk(v275, stance(v291, (math.atan2(v288, v289))), false)
            end

            if v271 then
                v284 = stance(spot, v277)
                v286 = back.d0
                v289 = -v286.X
                v290 = -v286.Z
                v285 = (math.atan2(v289, v290) - v277 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793 > 0
                setupWalk(back, v284, v285)
            end

            p127.ready[v266] = true
        end

        local v292 = p125:GetAttribute("Sc" .. v266 .. "Turn") or 0

        if v292 <= 0 then
            v292 = PodiumCeremonyPlan.Turn
        end

        local v293 = v275 and walkAt + PodiumCeremonyPlan.Duration(p127.server[v266], PodiumCeremonyPlan.Speed) or v270.S - 3

        v284 = v267 + PodiumCeremonyPlan.Duration(p127.backServer, PodiumCeremonyPlan.Speed)
        v285 = p128 - v272

        local v279 = v271 and v267 <= p128

        v271 = v272 + Beat.ShakeOut[1] + 0.1

        local v294, v295

        if v279 then
            v272 = 0
        else
            v287 = v271 + 0.3
            v286 = v273 - 0.2
            v289 = (p128 - v271) / (v287 - v271)
            v295 = math.clamp(v289, 0, 1)
            v288 = v295 * v295 * (3 - 2 * v295)
            v295 = (p128 - v286) / (v273 - v286)
            v294 = math.clamp(v295, 0, 1)
            v272 = v288 * (1 - v294 * v294 * (3 - 2 * v294))
        end

        v286 = ((v283 - v277 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * 0.3
        v289 = v271 + 0.2
        v290 = v271 + 0.9
        v295 = v273 + 0.7

        local v296 = math.clamp((p128 - v289) / (v290 - v289), 0, 1)
        local v297 = v296 * v296 * (3 - 2 * v296)

        v296 = (p128 - v273) / (v295 - v273)

        local v298 = math.clamp(v296, 0, 1)

        v287 = v286 * (v297 * (1 - v298 * v298 * (3 - 2 * v298)))
        v286, v288 = riderParts(p125, v266)

        local v299 = v288 and v288.Position + Vector3.new(0, 1, 0) * (v288.Size.Y * 0.5 + 0.65) or stand + Vector3.new(0, 4.6, 0)

        if not v279 or not back then
            back = v275
        end

        if back then
            local v300 = p128 - (v279 and v267 or walkAt)
            local backServer = if v279 then p127.backServer else nil

            if not v279 or not backServer then
                backServer = p127.server[v266]
            end

            v289 = PodiumCeremonyPlan.Travel(v300, backServer, PodiumCeremonyPlan.Speed) * (back.len / math.max(backServer, 0.001))
            v290 = PodiumCeremonyPlan.Rate(v300, backServer, PodiumCeremonyPlan.Speed) / PodiumCeremonyPlan.Speed
            v295 = pathAt(back, v289)
            v297 = walkFeet(back, v289)
        else
            v289 = 0
            v290 = 0
            v295 = spot
            v297 = stance(spot, v277)
        end

        local v301, d1, v302, v303, v304, Unit, v305, v306, v307, v308, v309, v310, v311, v312

        if v279 then
            local v313 = v277 + v287

            v304 = pathAt(back, v289 + 0.45) - pathAt(back, v289 - 0.45)
            d1 = v304.X
            v302 = v304.Z
            v301 = Vector3.new(d1, 0, v302)
            Unit = v301.Magnitude > 1E-04 and v301.Unit or back.d0

            local v315 = -Unit.X

            v304 = -Unit.Z
            v296 = (math.atan2(v315, v304) - v313 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
            v298 = v267 + 0.8
            Unit = (p128 - v267) / (v298 - v267)
            v315 = math.clamp(Unit, 0, 1)
            v313 += v296 * (v315 * v315 * (3 - 2 * v315))
            v296 = (v283 - v313 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
            v298 = v284 - 0.3
            Unit = v284 + 0.9
            v304 = math.clamp((p128 - v298) / (Unit - v298), 0, 1)
            v313 += v296 * (v304 * v304 * (3 - 2 * v304))
            v312 = v313

            if v284 - 0.05 < p128 then
                v305 = walkFeet(back, back.len)
                v306 = stance(back.pts[#back.pts], v283)
                v310 = v284 - 0.05
                v307 = v284 + 0.9
                d1 = back.d1
                v302 = -d1.X
                v303 = -d1.Z
                v308 = (v283 - math.atan2(v302, v303) + 3.141592653589793) % 6.283185307179586 - 3.141592653589793 > 0
                v311 = replant(v305, v306, p128, v310, v307, v308)
            else
                v311 = v297
            end

            v305 = v284 + 0.9
            v306 = v284 + 1.8
            v298 = (p128 - v305) / (v306 - v305)
            v307 = math.clamp(v298, 0, 1)
            v309 = v307 * v307 * (3 - 2 * v307)
        else
            local v317
            local v318 = v297

            if v275 then
                local v319 = pathAt(back, v289 + 0.45) - pathAt(back, v289 - 0.45)

                v298 = Vector3.new(v319.X, 0, v319.Z)

                local v321 = v298.Magnitude > 1E-04 and v298.Unit or back.d0

                v319 = -v321.X
                v298 = -v321.Z
                v296 = math.atan2(v319, v298)

                local v322 = (v277 - v296 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

                v298 = v293 - 0.3

                local v320 = v293 + v292
                local v323 = (p128 - v298) / (v320 - v298)

                v304 = math.clamp(v323, 0, 1)
                v317 = v296 + v322 * (v304 * v304 * (3 - 2 * v304))

                if v293 - 0.05 < p128 then
                    v296 = walkFeet(back, back.len)
                    v319 = stance(spot, v277)
                    v320 = v293 - 0.05
                    v323 = v293 + v292
                    d1 = back.d1
                    v302 = -d1.X
                    v303 = -d1.Z
                    v318 = replant(v296, v319, p128, v320, v323, (v277 - math.atan2(v302, v303) + 3.141592653589793) % 6.283185307179586 - 3.141592653589793 > 0)
                end
            else
                v317 = v277
            end

            v311 = v318
            v312 = v317 + v287

            if v275 then
                v306 = walkAt - 0.2
                v298 = walkAt + 0.2
                v310 = (p128 - v306) / (v298 - v306)
                v308 = math.clamp(v310, 0, 1)
                v309 = 1 - v308 * v308 * (3 - 2 * v308)
            else
                v310 = (v285 - -0.8) / 0.5
                v308 = math.clamp(v310, 0, 1)
                v309 = 0.4 * (1 - v308 * v308 * (3 - 2 * v308))
            end
        end

        v306 = 0.08 * held(v274 * 0.8, p127.seed, 6, 1.7)
        v308 = v274 * 0.4
        v304 = p127.seed + 2
        v287 = (v306 + 0.012 * (math.noise(v308, v304, 0.31) * 1.3 + math.noise(v308 * 2.3, v304 + 4.7, 0.77) * 0.6)) * v309
        v305 = (v311.overL or 0) * v290
        v306 = (v311.aheadL or 0) * v290
        v307 = math.cos(v312)
        v304 = -math.sin(v312)
        v310 = Vector3.new(v307, 0, v304)
        v295 += v310 * (v287 - 0.045 * v305)

        local atan2

        if Beat.Pump[1] < v285 and v285 < Beat.Pump[2] then
            v307 = (v285 - Beat.Pump[1]) * 2 * 3.141592653589793 * Beat.PumpHz
            Unit = math.sin(v307)
            v308 = Beat.Pump[1]
            v304 = Beat.Pump[1] + 0.25
            v301 = (v285 - v308) / (v304 - v308)
            atan2 = math.clamp(v301, 0, 1)
            v298 = Unit * (atan2 * atan2 * (3 - 2 * atan2))
            v308 = Beat.Pump[2] - 0.25
            v304 = Beat.Pump[2]
            v301 = (v285 - v308) / (v304 - v308)
            atan2 = math.clamp(v301, 0, 1)
            v277 = v298 * (1 - atan2 * atan2 * (3 - 2 * atan2))
        else
            v277 = 0
        end

        if v279 then
            v283 = 0
        else
            v298 = Beat.ShakeIn[1]
            Unit = Beat.ShakeIn[2]
            v307 = Beat.ShakeOut[1]
            v308 = Beat.ShakeOut[2]
            v301 = (v285 - v298) / (Unit - v298)
            atan2 = math.clamp(v301, 0, 1)
            v304 = atan2 * atan2 * (3 - 2 * atan2)
            atan2 = (v285 - v307) / (v308 - v307)
            v303 = math.clamp(atan2, 0, 1)
            v283 = v304 * (1 - v303 * v303 * (3 - 2 * v303))
        end

        local v324 = not v279 and v285 < 0

        Unit = v290 * 0.03

        local v325, v326

        if v279 then
            v307 = 0
        else
            d1 = Beat.Wear
            atan2 = Beat.ReleaseEnd
            v303 = (v285 - 0.2) / 0.6000000000000001
            v325 = math.clamp(v303, 0, 1)
            v302 = v325 * v325 * (3 - 2 * v325)
            v325 = (v285 - d1) / (atan2 - d1)
            v326 = math.clamp(v325, 0, 1)
            v307 = 0.1 * (v302 * (1 - v326 * v326 * (3 - 2 * v326))) + 0.12 * v283
        end

        v298 = Unit + v307
        v307 = if v324 then 0.025 else 0.06
        Unit = v306 * v307
        v306 = 0.02 * v305 + 0.35 * v287
        v305 = CFrame.Angles(0, v312, 0) * CFrame.Angles(-v298, Unit, v306)
        Unit = v295.Y - 3
        v304 = v295.X
        v301 = v295.Z

        local amp = back and back.amp or 0

        v298 = hipHeight(v305, v304, v301, v311, Unit, (1 - math.cos(amp)) * 2 * v290) - (v277 + 1) * 0.04 / 2 * v283

        local v327 = CFrame.new(v295.X, v298, v295.Z) * v305 * CFrame.new(0, 1, 0)

        p126:PivotTo(v327)
        v308 = p127.lh
        d1 = v311.L

        if v311.dL then
            atan2 = 0
        else
            v303 = 3.141592653589793 * v311.kL
            atan2 = math.sin(v303) * 0.08
        end

        aimLeg(v308, v327, true, d1, atan2)
        v308 = p127.rh
        d1 = v311.R

        if v311.dR then
            atan2 = 0
        else
            v303 = 3.141592653589793 * v311.kR
            atan2 = math.sin(v303) * 0.08
        end

        aimLeg(v308, v327, false, d1, atan2)
        v298 = (v311.armL or 0) * v290
        v306 = {
            sx = 1.5
        }
        v304 = v276 * 0.025 + 0.04
        v302 = v274 * 0.3
        v303 = p127.seed + 21
        v306.ax = v304 + 0.03 * (math.noise(v302, v303, 0.31) * 1.3 + math.noise(v302 * 2.3, v303 + 4.7, 0.77) * 0.6) - 0.42 * v298
        v306.az = -0.06 - v276 * 0.015 - v290 * 0.03
        v305 = {
            sx = 1.5
        }
        v304 = v276 * 0.025 + 0.04
        v302 = v274 * 0.31
        v303 = p127.seed + 22
        v305.ax = v304 + 0.03 * (math.noise(v302, v303, 0.31) * 1.3 + math.noise(v302 * 2.3, v303 + 4.7, 0.77) * 0.6) + 0.42 * v298
        v305.az = v276 * 0.015 + 0.06 + v290 * 0.03

        local Z, v328, v329, v330, Magnitude

        if v279 then
            v262 = nil
        else
            v301 = (v285 - -0.5) / 0.28
            atan2 = math.clamp(v301, 0, 1)
            v328 = atan2 * atan2 * (3 - 2 * atan2)
            atan2 = (v285 - -0.05) / 0.25
            v303 = math.clamp(atan2, 0, 1)
            v298 = v328 * (1 - v303 * v303 * (3 - 2 * v303))
            Z = 2 * (v311.ph or 0)
            d1 = math.sin(Z) * 0.035 * v290 - 0.1 * v298
            atan2 = 0.12 * v298

            local v331 = Vector3.new(0, d1, atan2)

            v328 = aimArm(v327, true, v327 * (t15[1] + v331))
            v331 = aimArm(v327, false, v327 * (t15[2] + v331))

            local v332 = v288

            if v288 then
                v301 = v295 - v288.Position
                atan2 = v301.X
                v303 = v301.Z
                v332 = Vector3.new(atan2, 0, v303)
            end

            local v333 = false

            if v332 and v332.Magnitude > 0.001 then
                v301 = v332.Unit

                if v301 then
                    v329 = v301
                    v333 = true
                end
            end

            if not v333 then
                v329 = -v327.LookVector
            end

            local v334 = v329

            if v288 and v285 > 0 then
                local v335

                v335, d1, atan2 = PodiumMedal.Worn(v288.CFrame, v288.Size)
                Z = Beat.LiftEnd
                v325 = (v285 - 0) / (Z - 0)
                v326 = math.clamp(v325, 0, 1)

                local v336 = v326 * v326 * (3 - 2 * v326)

                Z = Beat.LiftEnd
                v325 = Beat.LowerEnd
                amp = (v285 - Z) / (v325 - Z)
                v330 = math.clamp(amp, 0, 1)

                local v337 = v330 * v330 * (3 - 2 * v330)

                local function target(p131, p132) -- line: 571
                    -- upvalues: v327 (copy), v334 (copy), v335 (ref), v336 (copy), v337 (copy), t15 (copy)
                    local v338 = p132:Lerp(v335.Position, 0.45) + v334 * 0.15

                    return ((v327 * t15[p131]):Lerp(p132 + Vector3.new(0, 0.3, 0) + v334 * 0.35, v336) + Vector3.new(0, 0.35, 0) * math.sin(3.141592653589793 * v336)):Lerp(v338, v337)
                end

                Z = Beat.Wear
                v325 = Beat.ReleaseEnd
                amp = (v285 - Z) / (v325 - Z)
                v330 = math.clamp(amp, 0, 1)
                v312 = v330 * v330 * (3 - 2 * v330)
                v306 = blendArm(aimArm(v327, true, target(1, atan2)), v306, v312)
                v305 = blendArm(aimArm(v327, false, target(2, d1)), v305, v312)
            else
                v306 = v328
                v305 = v331
            end

            v287 = v288 and v288.Parent
            v324 = v288 and v288:FindFirstChild("RightShoulderRigAttachment")

            if not (v283 > 0) or not v324 then
                v262 = nil
            else
                v329 = v288.CFrame * v324.Position
                atan2 = v327 * Vector3.new(1.4, 1, 0) - v329
                v302, v303 = rightArmLengths(v287)
                amp = atan2.Unit
                v330 = ((v302 or 0.8) + (v303 or 0.9)) * 0.9
                Magnitude = atan2.Magnitude
                d1 = v329 + amp * math.min(v330, Magnitude) - Vector3.new(0, 1, 0) * (0.35 - v277 * 0.18)
                v305 = blendArm(v305, aimArm(v327, false, d1), v283)
                v262 = v327 * (CFrame.new(v305.sx, 1, 0) * CFrame.Angles(v305.ax, 0, v305.az)) * Vector3.new(0, -1.85, 0)
            end

            if not v287 then
                v262 = nil
            end

            if v272 > 0 then
                atan2 = (p128 - v271) * 2 * 3.141592653589793 * v77
                v324 = (0.5 - math.cos(atan2) * 0.5) ^ 0.7 * 0.3 + 0.5
                v287 = v327 * Vector3.new(0, 0.3, -1.45)
                v306 = blendArm(v306, aimArm(v327, true, v287 - v327.RightVector * v324), v272)
                v305 = blendArm(v305, aimArm(v327, false, v287 + v327.RightVector * v324), v272)
            end
        end

        p127.ls.C0 = CFrame.new(-v306.sx or v306.sx, 1, 0) * CFrame.Angles(v306.ax, 0, v306.az)
        p127.rs.C0 = CFrame.new(v305.sx, 1, 0) * CFrame.Angles(v305.ax, 0, v305.az)

        local v341 = back and pathAt(back, v289 + 5) + Vector3.new(0, 0.4, 0) or v299

        v307 = v295 + HomeLook * 24 + Vector3.new(0, 1.2, 0)

        local v342, v343

        if v279 then
            amp = p128 - v267
            v330 = (amp - 2.2) / 0.3999999999999999

            local v344 = math.clamp(v330, 0, 1)

            v326 = v344 * v344 * (3 - 2 * v344)

            local v345 = math.clamp((amp - 3.2) / 0.5, 0, 1)

            v343 = v341:Lerp(v299, 0.7 * (v326 * (1 - v345 * v345 * (3 - 2 * v345))))
            d1 = v295 + HomeLook * 24 + Vector3.new(0, 1.5, 0)
            v302 = v310 * 0.6
            Z = v274 * 0.25
            v325 = p127.seed + 5
            v328 = v343:Lerp(d1 + v302 * (math.noise(Z, v325, 0.31) * 1.3 + math.noise(Z * 2.3, v325 + 4.7, 0.77) * 0.6), v309)
            v329 = 0
        else
            v325 = v293 - 2.4
            amp = v293 - 1.1
            v326 = (p128 - v325) / (amp - v325)
            Magnitude = math.clamp(v326, 0, 1)
            Z = Magnitude * Magnitude * (3 - 2 * Magnitude)
            v326 = walkAt - 0.3
            v330 = walkAt + 0.4
            Magnitude = (p128 - v326) / (v330 - v326)
            v342 = math.clamp(Magnitude, 0, 1)
            v325 = 1 - v342 * v342 * (3 - 2 * v342)
            v343 = v341:Lerp(v299, (math.max(Z, v325)))

            local v346, v347

            if v275 then
                amp = p128 - walkAt
                v330 = (amp - 1.7) / 0.40000000000000013
                v346 = math.clamp(v330, 0, 1)
                v326 = v346 * v346 * (3 - 2 * v346)
                v346 = (amp - 2.7) / 0.5
                v347 = math.clamp(v346, 0, 1)
                v343 = v343:Lerp(v307, 0.6 * (v326 * (1 - v347 * v347 * (3 - 2 * v347))))
            end

            local v348

            if v288 and v285 > -0.2 and v285 < Beat.ReleaseEnd then
                v302 = PodiumMedal.Worn(v288.CFrame, v288.Size).Position
                amp = Beat.LowerEnd - 0.1
                v326 = Beat.LowerEnd + 0.3
                Magnitude = (v285 - 0.1) / 0.30000000000000004
                v342 = math.clamp(Magnitude, 0, 1)
                v330 = v342 * v342 * (3 - 2 * v342)
                v342 = (v285 - amp) / (v326 - amp)
                v348 = math.clamp(v342, 0, 1)
                v343 = v343:Lerp(v302, 0.55 * (v330 * (1 - v348 * v348 * (3 - 2 * v348))))
            end

            Z = v271 + 0.5
            v325 = v271 + 0.9
            amp = v273 + 0.5
            v330 = (p128 - Z) / (v325 - Z)
            v346 = math.clamp(v330, 0, 1)
            v326 = v346 * v346 * (3 - 2 * v346)
            v347 = math.clamp((p128 - v273) / (amp - v273), 0, 1)
            v328 = v343:Lerp(v307, v326 * (1 - v347 * v347 * (3 - 2 * v347)))
            v303 = Beat.ReleaseEnd - 0.2
            Z = Beat.ReleaseEnd + 0.05
            v325 = Beat.ReleaseEnd + 0.2
            amp = Beat.ReleaseEnd + 0.5
            v330 = (v285 - v303) / (Z - v303)
            v346 = math.clamp(v330, 0, 1)
            v326 = v346 * v346 * (3 - 2 * v346)
            v347 = math.clamp((v285 - v325) / (amp - v325), 0, 1)
            v343 = 0.16 * (v326 * (1 - v347 * v347 * (3 - 2 * v347)))
            Z = Beat.Pump[1] + 0.3
            v325 = Beat.Pump[1] + 0.5
            amp = Beat.Pump[1] + 0.6
            v326 = Beat.Pump[1] + 0.85
            Magnitude = (v285 - Z) / (v325 - Z)
            v342 = math.clamp(Magnitude, 0, 1)
            v330 = v342 * v342 * (3 - 2 * v342)
            v342 = (v285 - amp) / (v326 - amp)
            v348 = math.clamp(v342, 0, 1)
            v329 = v343 + 0.1 * (v330 * (1 - v348 * v348 * (3 - 2 * v348)))
        end

        lookAt(p127, v327, v328, p130, v329 + v276 * 0.01)
        v329 = p125:FindFirstChild("HeldMedal" .. v270.place)
        parkMedals(p125, v329, spot - Vector3.new(0, 62, 0))

        if v329 and v329:IsA("Model") then
            v343 = v327 * (CFrame.new(-v306.sx or v306.sx, 1, 0) * CFrame.Angles(v306.ax, 0, v306.az)) * Vector3.new(0, -1.85, 0)
            atan2 = v327 * (CFrame.new(v305.sx, 1, 0) * CFrame.Angles(v305.ax, 0, v305.az)) * Vector3.new(0, -1.85, 0)
            v302 = v327.LookVector
            Z = v302.X
            v328 = Vector3.new(Z, 0, v302.Z).Unit
            v303 = -v328.Z
            v302 = Vector3.new(v303, 0, v328.X)
            v307 = (v343 + atan2) / 2

            local v350, v351

            if p127.lastMid and p130 > 0 then
                v309 = (v307 - p127.lastMid) / p130

                if v309 then
                    v350 = v309
                    v351 = true
                else
                    v351 = false
                end
            else
                v351 = false
            end

            if not v351 then
                v350 = Vector3.new(0, 0, 0)
            end

            p127.lastMid = v307

            local v352, v353

            if p127.lastVel and p130 > 0 then
                v295 = (v350 - p127.lastVel) / p130

                if v295 then
                    v352 = v295
                    v353 = true
                else
                    v353 = false
                end
            else
                v353 = false
            end

            if not v353 then
                v352 = Vector3.new(0, 0, 0)
            end

            p127.lastVel = v350
            v303 = (v285 - -0.3) / 0.55

            local new = math.clamp(v303, 0, 1)

            v350 = 1 - new * new * (3 - 2 * new)
            v303 = p127.swX

            local v354 = spring(v303, math.clamp(-v352:Dot(v328) * 0.03, -0.4, 0.4) * v350, 1.5, 0.22, p130)

            v303 = p127.swZ

            local v355 = spring(v303, math.clamp(v352:Dot(v302) * 0.03, -0.3, 0.3) * v350, 1.5, 0.22, p130)

            v352 = CFrame.fromAxisAngle(v302, v354 * v350) * CFrame.fromAxisAngle(v328, v355 * v350)

            local v349 = -(PodiumMedal.LoopHeight + 0.5)

            v341 = v307 + v352:VectorToWorldSpace((Vector3.new(0, v349, 0)))
            v307 = CFrame.new(v341) * v352 * CFrame.lookAt(Vector3.new(0, 0, 0), -v328).Rotation

            if v288 and v285 > 0 then
                Z, new, v349 = PodiumMedal.Worn(v288.CFrame, v288.Size)
                v326 = Beat.LiftEnd
                v330 = Beat.LowerEnd
                Magnitude = (v285 - v326) / (v330 - v326)
                v342 = math.clamp(Magnitude, 0, 1)

                local v356 = v342 * v342 * (3 - 2 * v342)

                atan2 = atan2:Lerp(new, v356)
                v343 = v343:Lerp(v349, v356)
                v307 = CFrame.new(v307.Position:Lerp(Z.Position, v356)) * v307.Rotation:Lerp(Z.Rotation, v356)
            end

            PodiumMedal.Place(v329, v307, atan2, v343)
        end
    end
end

local function presenterStep(p133, p134, p135) -- line: 654
    -- upvalues: t20 (copy), presenterRig (copy), updatePresenter (copy)
    for v357 in t20 do
        if not v357.Parent then
            t20[v357] = nil
        end
    end

    local PodiumCeremony = workspace:FindFirstChild("PodiumCeremony")

    if not PodiumCeremony then
        return
    end

    local PodiumPresenter = PodiumCeremony:FindFirstChild("PodiumPresenter")
    local v358 = PodiumPresenter and presenterRig(PodiumPresenter)

    if v358 then
        local ok, result = pcall(updatePresenter, PodiumCeremony, PodiumPresenter, v358, p133, p134, p135)

        if not ok then
            warn("[PodiumCeremonyClient] " .. tostring(result))
        end
    end
end

RunService.RenderStepped:Connect(function(p136) -- line: 664
    -- upvalues: presenterStep (copy)
    presenterStep(workspace:GetServerTimeNow(), os.clock(), (math.min(p136, 0.06666666666666667)))
end)

local self = setmetatable({}, {
    __mode = "k"
})

local function jointsOf(p137) -- line: 670
    -- upvalues: self (copy)
    local v360 = self[p137]

    if v360 then
        return v360
    end

    local t28 = {}
    local n6 = 0

    for _, descendant in p137:GetDescendants() do
        if (descendant:IsA("Motor6D") or descendant:IsA("AnimationConstraint")) and not t28[descendant.Name] and not descendant:FindFirstAncestorWhichIsA("Accessory") and not descendant:FindFirstAncestorWhichIsA("Tool") then
            t28[descendant.Name] = descendant
            n6 += 1
        end
    end

    if n6 >= 15 then
        self[p137] = t28
    end

    return t28
end

local function rightArmIK(p138, p139) -- line: 682
    -- upvalues: rightArmLengths (copy)
    local UpperTorso = p138:FindFirstChild("UpperTorso")
    local RightUpperArm = p138:FindFirstChild("RightUpperArm")
    local RightLowerArm = p138:FindFirstChild("RightLowerArm")
    local RightHand = p138:FindFirstChild("RightHand")

    if not (UpperTorso and RightUpperArm and RightLowerArm and RightHand) then
        return nil
    end

    local RightShoulderRigAttachment = UpperTorso:FindFirstChild("RightShoulderRigAttachment")
    local RightShoulderRigAttachment2 = RightUpperArm:FindFirstChild("RightShoulderRigAttachment")
    local RightElbowRigAttachment = RightUpperArm:FindFirstChild("RightElbowRigAttachment")
    local RightElbowRigAttachment2 = RightLowerArm:FindFirstChild("RightElbowRigAttachment")
    local RightWristRigAttachment = RightLowerArm:FindFirstChild("RightWristRigAttachment")
    local RightWristRigAttachment2 = RightHand:FindFirstChild("RightWristRigAttachment")

    if not (RightShoulderRigAttachment and RightShoulderRigAttachment2 and RightElbowRigAttachment and RightElbowRigAttachment2 and RightWristRigAttachment and RightWristRigAttachment2) then
        return nil
    end

    local RightGripAttachment = RightHand:FindFirstChild("RightGripAttachment")
    local Position = RightGripAttachment and RightGripAttachment.Position or RightWristRigAttachment2.Position
    local v361, v362 = rightArmLengths(p138)

    if not v361 or v361 < 0.05 or v362 < 0.05 then
        return nil
    end

    local Rotation = UpperTorso.CFrame.Rotation
    local v363 = UpperTorso.CFrame * RightShoulderRigAttachment.Position

    local function solve(p140) -- line: 694
        -- upvalues: UpperTorso (copy), v361 (copy), v362 (copy), Rotation (copy), v363 (copy)
        local v364 = p140 - v363

        if v364.Magnitude < 0.001 then
            return nil
        end

        local Unit = v364.Unit
        local v368 = math.clamp(v364.Magnitude, math.abs(v361 - v362) + 0.05, v361 + v362 - 0.02)
        local v371 = math.acos((math.clamp((v361 * v361 + v368 * v368 - v362 * v362) / (2 * v361 * v368), -1, 1)))
        local v374 = 3.141592653589793 - math.acos((math.clamp((v361 * v361 + v362 * v362 - v368 * v368) / (2 * v361 * v362), -1, 1)))
        local v375 = Vector3.new(-0, -1, -0, -0) + UpperTorso.CFrame.RightVector * 0.6
        local v376 = v375 - Unit * v375:Dot(Unit)
        local Unit2 = v376.Magnitude > 0.001 and v376.Unit or Vector3.new(-0, -1, -0, -0)
        local Unit3 = (Unit * math.cos(v371) + Unit2 * math.sin(v371)).Unit
        local Unit4 = (v363 + Unit * v368 - (v363 + Unit3 * v361)).Unit
        local v377 = -Unit3
        local v378 = Unit4 - Unit3 * Unit3:Dot(Unit4)

        if v378.Magnitude < 0.001 then
            v378 = UpperTorso.CFrame.LookVector
        end

        local Unit5 = v377:Cross(-v378.Unit).Unit
        local Unit6 = Unit5:Cross(v377).Unit

        return Rotation:Inverse() * CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit5, v377, Unit6), CFrame.Angles(v374, 0, 0)
    end

    local function grip(p141, p142) -- line: 713
        -- upvalues: RightShoulderRigAttachment2 (copy), RightElbowRigAttachment (copy), RightElbowRigAttachment2 (copy), RightWristRigAttachment (copy), RightWristRigAttachment2 (copy), Position (copy), Rotation (copy), v363 (copy)
        local v379 = Rotation * p141
        local v380 = v363 + v379 * (RightElbowRigAttachment.Position - RightShoulderRigAttachment2.Position)
        local v381 = v379 * p142

        return v380 + v381 * (RightWristRigAttachment.Position - RightElbowRigAttachment2.Position) + v381 * (Position - RightWristRigAttachment2.Position)
    end

    local v382 = p139
    local v383, v384

    for _ = 1, 4 do
        v383, v384 = solve(v382)

        if not v383 then
            return nil
        end

        local v385 = Rotation * v383
        local v386 = v363 + v385 * (RightElbowRigAttachment.Position - RightShoulderRigAttachment2.Position)
        local v387 = v385 * v384
        local v388 = p139 - (v386 + v387 * (RightWristRigAttachment.Position - RightElbowRigAttachment2.Position) + v387 * (Position - RightWristRigAttachment2.Position))

        if v388.Magnitude < 0.02 then
            break
        end

        v382 += v388
    end

    return v383, v384
end

local self2 = setmetatable({}, {
    __mode = "k"
})

local function drive(p143, p144, p145) -- line: 730
    -- upvalues: self2 (copy)
    if not p143 then
        return
    end

    local Transform = p143.Transform
    local v390 = self2[p143]
    local v391, v392

    if v390 and Transform == v390 then
        local identity = CFrame.identity

        if identity then
            v391 = identity
            v392 = true
        else
            v392 = false
        end
    else
        v392 = false
    end

    if not v392 then
        v391 = Transform
    end

    v391 = p145 > 0 and v391:Lerp(p144, (math.min(p145, 1))) or v391
    p143.Transform = v391
    self2[p143] = v391
end

local v393

RunService.PreSimulation:Connect(function() -- line: 739
    -- upvalues: Beat (copy), sceneInfo (copy), riderParts (copy), v262 (ref), jointsOf (copy), rightArmIK (copy), self2 (copy), drive (copy), v393 (ref)
    local PodiumCeremony = workspace:FindFirstChild("PodiumCeremony")
    local ServerTimeNow = workspace:GetServerTimeNow()
    local v394, v395, v396

    if PodiumCeremony then
        for i = 1, PodiumCeremony:GetAttribute("Scenes") or 0 do
            local v397 = PodiumCeremony:GetAttribute("Sc" .. i .. "Ta") or 0
            local v398 = ServerTimeNow - v397

            if v397 > 0 and Beat.TurnIn[1] - 0.2 < v398 and v398 < Beat.TurnOut[2] + 0.3 then
                local v399 = riderParts(PodiumCeremony, i)

                if v399 then
                    v394 = v399
                    v395 = v398
                    v396 = sceneInfo(PodiumCeremony, i)
                end
            end
        end
    end

    if v393 and v393 ~= v394 then
        for _, v400 in jointsOf(v393) do
            local identity = CFrame.identity

            pcall(drive, v400, identity, 0)
        end

        v393 = nil
    end

    if not v394 then
        return
    end

    v393 = v394

    local v401 = jointsOf(v394)
    local v402 = Beat.TurnIn[1]
    local v403 = Beat.TurnIn[2]
    local v404 = Beat.TurnOut[1]
    local v405 = Beat.TurnOut[2]
    local v407 = math.clamp((v395 - v402) / (v403 - v402), 0, 1)
    local v408 = v407 * v407 * (3 - 2 * v407)
    local v410 = math.clamp((v395 - v404) / (v405 - v404), 0, 1)
    local v411 = v408 * (1 - v410 * v410 * (3 - 2 * v410))
    local v412 = Beat.BowIn[1]
    local v413 = Beat.BowIn[2]
    local v414 = Beat.BowOut[1]
    local v415 = Beat.BowOut[2]
    local v417 = math.clamp((v395 - v412) / (v413 - v412), 0, 1)
    local v418 = v417 * v417 * (3 - 2 * v417)
    local v420 = math.clamp((v395 - v414) / (v415 - v414), 0, 1)
    local v421 = v418 * (1 - v420 * v420 * (3 - 2 * v420))
    local v422 = Beat.ShakeIn[1]
    local v423 = Beat.ShakeIn[2]
    local v424 = Beat.ShakeOut[1]
    local v425 = Beat.ShakeOut[2]
    local v427 = math.clamp((v395 - v422) / (v423 - v422), 0, 1)
    local v428 = v427 * v427 * (3 - 2 * v427)
    local v430 = math.clamp((v395 - v424) / (v425 - v424), 0, 1)
    local v431 = v428 * (1 - v430 * v430 * (3 - 2 * v430))
    local v432 = 0

    if Beat.Pump[1] < v395 and v395 < Beat.Pump[2] then
        local v434 = math.sin((v395 - Beat.Pump[1]) * 2 * 3.141592653589793 * Beat.PumpHz)
        local v435 = Beat.Pump[1]
        local v436 = Beat.Pump[1] + 0.25
        local v438 = math.clamp((v395 - v435) / (v436 - v435), 0, 1)
        local v439 = v434 * (v438 * v438 * (3 - 2 * v438))
        local v440 = Beat.Pump[2] - 0.25
        local v441 = Beat.Pump[2]
        local v443 = math.clamp((v395 - v440) / (v441 - v440), 0, 1)

        v432 = v439 * (1 - v443 * v443 * (3 - 2 * v443))
    end

    local stand, spot = v396.stand, v396.spot
    local ToAudience = PodiumCeremony:GetAttribute("ToAudience")
    local v444 = 0

    if typeof(stand) == "Vector3" and typeof(spot) == "Vector3" and typeof(ToAudience) == "Vector3" then
        local v445 = Beat.ShakeIn[1] - 0.6
        local v446 = Beat.ShakeIn[1]
        local v447 = Beat.ShakeOut[1]
        local v448 = Beat.ShakeOut[2] + 0.2
        local v450 = math.clamp((v395 - v445) / (v446 - v445), 0, 1)
        local v451 = v450 * v450 * (3 - 2 * v450)
        local v453 = math.clamp((v395 - v447) / (v448 - v447), 0, 1)
        local v454 = v451 * (1 - v453 * v453 * (3 - 2 * v453))
        local v457 = math.atan2(-ToAudience.X, -ToAudience.Z)
        local v458 = spot - stand
        local v459 = Vector3.new(v458.X, 0, v458.Z)

        v444 = ((math.atan2(-v459.X, -v459.Z) - v457 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * (0.4 + 0.4 * v454)
    end

    local v463 = math.sin(os.clock() * 1.6)
    local t31 = {
        Root = CFrame.Angles(0, v444, 0),
        Waist = CFrame.Angles(-0.38 * v421 + v463 * 0.012, 0, 0),
        Neck = CFrame.Angles(-0.45 * v421 - 0.1 * v431 + v463 * 0.01, v444 * 0.4 * (1 - v421), 0),
        LeftShoulder = CFrame.Angles(v463 * 0.02 + 0.06, 0, -0.05),
        RightShoulder = CFrame.Angles(v463 * 0.02 + 0.06, 0, 0.05)
    }
    local v464, v465

    if v431 > 0 and v262 then
        v464, v465 = rightArmIK(v394, v262)
    end

    local v466 = v464 or CFrame.Angles(v432 * 0.11 + 0.3, 0, -0.25)
    local v467 = v465 or CFrame.Angles(1.3, 0, 0)

    local function v468() -- line: 785
        -- upvalues: v401 (copy), v411 (copy), v431 (copy), t31 (copy), v466 (copy), v467 (copy), self2 (copy)
        for v469, v470 in v401 do
            local v471 = t31[v469] or CFrame.identity

            if v469 == "RightShoulder" then
                v471 = v471:Lerp(v466, v431)
            elseif v469 == "RightElbow" then
                v471 = v471:Lerp(v467, v431)
            end

            if v470 then
                local Transform = v470.Transform
                local v472 = self2[v470]

                if v472 and Transform == v472 then
                    Transform = CFrame.identity or Transform
                end

                if v411 > 0 then
                    Transform = Transform:Lerp(v471, (math.min(v411, 1))) or Transform
                end

                v470.Transform = Transform
                self2[v470] = Transform
            end
        end
    end

    pcall(v468)
end)
