-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")

require(MotoLegends:WaitForChild("Config"))

local _require = require
local ok, result = pcall(_require, MotoLegends:WaitForChild("RaceNametags"))
local _ = {
    FadeOut = 0.22,
    FadeIn = 0.5,
    EndFade = 0.45,
    Hold = 0.12,
    ReturnFade = 0.6,
    BarsOut = 0.85,
    MinSeconds = 2,
    BarHeight = 0.105,
    StartAhead = 42,
    StartUp = 12,
    EndAhead = 40,
    EndUp = 6,
    SideStart = 0,
    SideFollow = 0,
    GridFollow = 0,
    StartLookBack = 26,
    EndLookBack = 34,
    FocusStart = 0.45,
    FocusEnd = 0.3,
    StartFov = 46,
    EndFov = 44,
    Shake = 0,
    IntroHold = 0.35,
    IntroSplit = 1.1,
    IntroBarHold = 0.45,
    IntroWalk = 12,
    IntroSettingsWait = 4,
    IntroSettle = 4,
    PitArriveWait = 4,
    PitRadius = 40
}
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "GridCutscene"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ScreenInsets = Enum.ScreenInsets.None

local function v1() -- line: 50
    -- upvalues: ScreenGui (copy)
    ScreenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.Off
end

pcall(v1)
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 1000
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function bar(p1, p2) -- line: 54
    -- upvalues: ScreenGui (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = p1
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.AnchorPoint = Vector2.new(0, p2)
    Frame.Position = UDim2.fromScale(0, p2)
    Frame.Size = UDim2.fromScale(1, 0)
    Frame.Parent = ScreenGui

    return Frame
end

local v2 = bar("TopBar", 0)
local v3 = bar("BottomBar", 1)
local Frame = Instance.new("Frame")

Frame.Name = "Fade"
Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 1
Frame.Size = UDim2.fromScale(1, 1)
Frame.ZIndex = 10
Frame.Parent = ScreenGui
ScreenGui.Enabled = true
Frame.BackgroundTransparency = 0

local function tween(p3, p4, p5, p6, p7) -- line: 65
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p3, TweenInfo.new(p4, p6 or Enum.EasingStyle.Sine, p7 or Enum.EasingDirection.InOut), p5)

    tween:Play()

    return tween
end

local function fadeTo(p8, p9) -- line: 69
    -- upvalues: TweenService (copy), Frame (copy)
    if p9 <= 0 then
        Frame.BackgroundTransparency = 1 - p8
    else
        local t1 = {
            BackgroundTransparency = 1 - p8
        }

        TweenService:Create(Frame, TweenInfo.new(p9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t1):Play()
        task.wait(p9)
    end
end

local function bars(p10, p11, p12, p13) -- line: 74
    -- upvalues: TweenService (copy), v2 (copy), v3 (copy)
    local v4 = UDim2.fromScale(1, if p10 then 0.105 else 0)
    local t2 = {
        Size = v4
    }
    local v5 = p12 or Enum.EasingStyle.Quart
    local v6 = p13 or Enum.EasingDirection.Out

    TweenService:Create(v2, TweenInfo.new(p11, v5 or Enum.EasingStyle.Sine, v6 or Enum.EasingDirection.InOut), t2):Play()

    local t3 = {
        Size = v4
    }

    p12 = p12 or Enum.EasingStyle.Quart
    p13 = p13 or Enum.EasingDirection.Out
    TweenService:Create(v3, TweenInfo.new(p11, p12 or Enum.EasingStyle.Sine, p13 or Enum.EasingDirection.InOut), t3):Play()
end

local t4 = {
    RaceLobbyHUD = true,
    ServerListHUD = true
}
local t5 = {}
local Hidden
local v9 = false

local function hideHud() -- line: 86
    -- upvalues: LocalPlayer (copy), ok (copy), result (copy), ScreenGui (copy), t4 (copy), t5 (copy), Hidden (ref), v9 (ref)
    table.clear(t5)

    for _, child in LocalPlayer.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child ~= ScreenGui and child.Enabled and not t4[child.Name] then
            child.Enabled = false
            table.insert(t5, child)
        end
    end

    if ok and result then
        Hidden = result.Hidden
        result.Hidden = true
    end

    v9 = true
end

RunService.RenderStepped:Connect(function() -- line: 95
    -- upvalues: LocalPlayer (copy), ScreenGui (copy), t4 (copy), t5 (copy), v9 (ref)
    if not v9 then
        return
    end

    for _, child in LocalPlayer.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child ~= ScreenGui and child.Enabled and not t4[child.Name] then
            child.Enabled = false
            table.insert(t5, child)
        end
    end
end)

local function restoreHud() -- line: 101
    -- upvalues: ok (copy), result (copy), t5 (copy), Hidden (ref), v9 (ref)
    v9 = false

    for _, v10 in t5 do
        if v10.Parent then
            v10.Enabled = true
        end
    end

    table.clear(t5)

    if ok and result and Hidden ~= nil then
        result.Hidden = Hidden
        Hidden = nil
    end
end

local v11

local function attr(p14) -- line: 110
    -- upvalues: v11 (ref)
    return v11 and v11:GetAttribute(p14)
end

local function smoother(p15) -- line: 111
    local v12 = math.clamp(p15, 0, 1)

    return v12 * v12 * v12 * (v12 * (v12 * 6 - 15) + 10)
end

local function easeOut(p16) -- line: 112
    return 1 - (1 - math.clamp(p16, 0, 1)) ^ 3
end

local t6
local GridOfficialMotion = require(MotoLegends:WaitForChild("GridOfficialMotion"))

local function redTravel() -- line: 116
    -- upvalues: v11 (ref), GridOfficialMotion (copy)
    local FrontRedFlagOfficial = v11 and v11:FindFirstChild("FrontRedFlagOfficial")

    if not FrontRedFlagOfficial then
        return nil
    end

    local StartPos = FrontRedFlagOfficial:GetAttribute("StartPos")
    local TargetPos = FrontRedFlagOfficial:GetAttribute("TargetPos")
    local v13 = FrontRedFlagOfficial:GetAttribute("DepartAt") or 0
    local v14 = FrontRedFlagOfficial:GetAttribute("Speed") or 0

    if typeof(StartPos) ~= "Vector3" or typeof(TargetPos) ~= "Vector3" or v13 <= 0 then
        return 0
    end

    return (math.min(GridOfficialMotion.Travel(workspace:GetServerTimeNow() - v13, v14), (TargetPos - StartPos).Magnitude))
end

local n1 = 0

local function shot(p17, p18) -- line: 124
    -- upvalues: v11 (ref), redTravel (copy), n1 (ref)
    local CutsceneAnchor = v11 and v11:GetAttribute("CutsceneAnchor")
    local CutsceneForward = v11 and v11:GetAttribute("CutsceneForward")
    local v16 = v11 and v11:GetAttribute("CutsceneWalk")

    if typeof(CutsceneAnchor) ~= "Vector3" or typeof(CutsceneForward) ~= "Vector3" then
        return nil
    end

    local v17 = Vector3.new(CutsceneForward.X, 0, CutsceneForward.Z)
    local v18 = v17.Magnitude > 0.05 and v17.Unit or Vector3.new(0, 0, -1)

    if typeof(v16) ~= "Vector3" or v16.Magnitude < 0.05 then
        v16 = v18:Cross((Vector3.new(0, 1, 0)))
    end

    local Unit = Vector3.new(v16.X, 0, v16.Z).Unit
    local v19 = redTravel()

    if v19 then
        n1 = v19
    else
        v19 = n1
    end

    local v21 = 0.5 - math.cos(3.141592653589793 * p17) * 0.5
    local v22 = math.clamp(p17, 0, 1)
    local v23 = 42 + -2 * (v22 * v22 * v22 * (v22 * (v22 * 6 - 15) + 10))
    local v24 = 12 + -6 * v21
    local v25 = CutsceneAnchor + v18 * v23 + Vector3.new(0, 1, 0) * v24 + Unit * (0 + 0 * v19)
    local v26 = (CutsceneAnchor - v18 * (26 + 8 * v21) + Vector3.new(0, 1, 0) * (v21 * 2.5 + -3) + Unit * (0 * v19)):Lerp(CutsceneAnchor + Vector3.new(0, 1, 0), 0.45 + -0.15000000000000002 * v21)

    return CFrame.lookAt(v25, v26) * CFrame.Angles(math.noise(p18 * 0.35, 1.7) * 0, math.noise(p18 * 0.31, 8.3) * 0, math.noise(p18 * 0.27, 4.1) * 0 * 0.6), 46 + -2 * v21
end

local v27 = "intro"

local function bindCamera(p19, p20) -- line: 149
    -- upvalues: RunService (copy), shot (copy)
    RunService:BindToRenderStep("GridCutscene", Enum.RenderPriority.Camera.Value + 30, function() -- line: 150
        -- upvalues: p19 (copy), p20 (copy), shot (copy)
        local CurrentCamera = workspace.CurrentCamera
        local v33, v34 = shot(math.clamp((workspace:GetServerTimeNow() - p19) / math.max(p20 - p19, 0.1), 0, 1), os.clock())

        if not v33 then
            return
        end

        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.CFrame = v33
        CurrentCamera.FieldOfView = v34
    end)
end

local function unbindCamera() -- line: 158
    -- upvalues: RunService (copy), t6 (ref)
    local function v35() -- line: 159
        -- upvalues: RunService (copy)
        RunService:UnbindFromRenderStep("GridCutscene")
    end

    pcall(v35)

    local CurrentCamera = workspace.CurrentCamera

    if not t6 then
        return
    end

    CurrentCamera.FieldOfView = t6.fov

    if t6.type ~= Enum.CameraType.Scriptable then
        CurrentCamera.CameraType = t6.type

        if t6.subject then
            CurrentCamera.CameraSubject = t6.subject
        end
    end

    t6 = nil
end

local function spectating() -- line: 170
    -- upvalues: LocalPlayer (copy)
    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

    return JerezRaceHUD ~= nil and JerezRaceHUD:GetAttribute("LobbySpectating") == true
end

local function watching() -- line: 175
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("RaceGridLocked") == true then
        return true
    end

    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

    return JerezRaceHUD ~= nil and JerezRaceHUD:GetAttribute("LobbySpectating") == true or LocalPlayer:GetAttribute("AFKMode") == true
end

local function cutscenesOn() -- line: 177
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("GfxCutscenes") ~= false
end

local function eligible() -- line: 178
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("GfxCutscenes") == false then
        return false
    end

    if LocalPlayer:GetAttribute("RaceGridLocked") ~= true then
        local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

        if (JerezRaceHUD == nil or JerezRaceHUD:GetAttribute("LobbySpectating") ~= true) and LocalPlayer:GetAttribute("AFKMode") ~= true then
            return false
        end
    end

    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

    return not (JerezRaceHUD and JerezRaceHUD:GetAttribute("Freecam") == true)
end

local function stillOn(p21) -- line: 186
    -- upvalues: LocalPlayer (copy), v11 (ref), v27 (ref)
    if v27 ~= p21 or (v11 and v11:GetAttribute("CutsceneId")) ~= p21 or not ((v11 and v11:GetAttribute("CutsceneEnd") or 0) > 0) then
        return false
    end

    local v36

    if LocalPlayer:GetAttribute("RaceGridLocked") == true then
        v36 = true
    else
        local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

        v36 = if JerezRaceHUD ~= nil then JerezRaceHUD:GetAttribute("LobbySpectating") == true or LocalPlayer:GetAttribute("AFKMode") == true else LocalPlayer:GetAttribute("AFKMode") == true
    end

    return v36 and LocalPlayer:GetAttribute("GfxCutscenes") ~= false
end

local function play(p22) -- line: 190
    -- upvalues: RunService (copy), TweenService (copy), LocalPlayer (copy), ok (copy), result (copy), ScreenGui (copy), v2 (copy), v3 (copy), Frame (copy), bars (copy), t5 (copy), Hidden (ref), v9 (ref), hideHud (copy), v11 (ref), t6 (ref), n1 (ref), shot (copy), v27 (ref), unbindCamera (copy)
    local v37 = v11 and v11:GetAttribute("CutsceneStart") or 0
    local v38 = v11 and v11:GetAttribute("CutsceneEnd") or 0
    local ServerTimeNow = workspace:GetServerTimeNow()

    if v38 - ServerTimeNow < 2 then
        return
    end

    local v39 = false

    if LocalPlayer:GetAttribute("GfxCutscenes") ~= false then
        local v40

        if LocalPlayer:GetAttribute("RaceGridLocked") == true then
            v40 = true
        else
            local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

            v40 = if JerezRaceHUD ~= nil then JerezRaceHUD:GetAttribute("LobbySpectating") == true or LocalPlayer:GetAttribute("AFKMode") == true else LocalPlayer:GetAttribute("AFKMode") == true
        end

        if v40 then
            local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

            v39 = not (JerezRaceHUD and JerezRaceHUD:GetAttribute("Freecam") == true)
        end
    end

    if not v39 then
        return
    end

    v27 = p22
    n1 = 0
    LocalPlayer:SetAttribute("CutscenePlaying", true)
    ScreenGui.Enabled = true

    if ServerTimeNow - v37 > 0.3 then
        Frame.BackgroundTransparency = 0
    else
        local t7 = {
            BackgroundTransparency = 0
        }

        TweenService:Create(Frame, TweenInfo.new(0.22, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t7):Play()
        task.wait(0.22)
    end

    local v41 = false

    if v27 == p22 and (v11 and v11:GetAttribute("CutsceneId")) == p22 and (v11 and v11:GetAttribute("CutsceneEnd") or 0) > 0 then
        local v42

        if LocalPlayer:GetAttribute("RaceGridLocked") == true then
            v42 = true
        else
            local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

            v42 = if JerezRaceHUD ~= nil then JerezRaceHUD:GetAttribute("LobbySpectating") == true or LocalPlayer:GetAttribute("AFKMode") == true else LocalPlayer:GetAttribute("AFKMode") == true
        end

        v41 = v42 and LocalPlayer:GetAttribute("GfxCutscenes") ~= false
    end

    if v41 then
        local CurrentCamera = workspace.CurrentCamera

        t6 = {
            type = CurrentCamera.CameraType,
            subject = CurrentCamera.CameraSubject,
            fov = CurrentCamera.FieldOfView
        }
        hideHud()
        RunService:BindToRenderStep("GridCutscene", Enum.RenderPriority.Camera.Value + 30, function() -- line: 150
            -- upvalues: v37 (copy), v38 (copy), shot (copy)
            local CurrentCamera = workspace.CurrentCamera
            local v48, v49 = shot(math.clamp((workspace:GetServerTimeNow() - v37) / math.max(v38 - v37, 0.1), 0, 1), os.clock())

            if not v48 then
                return
            end

            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CFrame = v48
            CurrentCamera.FieldOfView = v49
        end)
        v2.Size = UDim2.fromScale(1, 0.105)
        v3.Size = UDim2.fromScale(1, 0.105)

        local t8 = {
            BackgroundTransparency = 1
        }

        TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t8):Play()
        task.wait(0.5)

        while true do
            local v50 = false

            if v27 == p22 and (v11 and v11:GetAttribute("CutsceneId")) == p22 and (v11 and v11:GetAttribute("CutsceneEnd") or 0) > 0 then
                local v51

                if LocalPlayer:GetAttribute("RaceGridLocked") == true then
                    v51 = true
                else
                    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

                    v51 = if JerezRaceHUD ~= nil then JerezRaceHUD:GetAttribute("LobbySpectating") == true or LocalPlayer:GetAttribute("AFKMode") == true else LocalPlayer:GetAttribute("AFKMode") == true
                end

                v50 = v51 and LocalPlayer:GetAttribute("GfxCutscenes") ~= false
            end

            if not v50 or (v11 and v11:GetAttribute("CutsceneEnd") or 0) - workspace:GetServerTimeNow() <= 0.45 then
                break
            end

            task.wait()
        end

        local v52 = false

        if v27 == p22 and (v11 and v11:GetAttribute("CutsceneId")) == p22 and (v11 and v11:GetAttribute("CutsceneEnd") or 0) > 0 then
            local v53

            if LocalPlayer:GetAttribute("RaceGridLocked") == true then
                v53 = true
            else
                local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

                v53 = if JerezRaceHUD ~= nil then JerezRaceHUD:GetAttribute("LobbySpectating") == true or LocalPlayer:GetAttribute("AFKMode") == true else LocalPlayer:GetAttribute("AFKMode") == true
            end

            v52 = v53 and LocalPlayer:GetAttribute("GfxCutscenes") ~= false
        end

        local v54 = if not v52 then 0.2 else 0.45

        if v54 <= 0 then
            Frame.BackgroundTransparency = 0
        else
            local t9 = {
                BackgroundTransparency = 0
            }

            TweenService:Create(Frame, TweenInfo.new(v54, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t9):Play()
            task.wait(v54)
        end

        unbindCamera()
        v9 = false

        for _, v55 in t5 do
            if v55.Parent then
                v55.Enabled = true
            end
        end

        table.clear(t5)

        if ok and result and Hidden ~= nil then
            result.Hidden = Hidden
            Hidden = nil
        end

        LocalPlayer:SetAttribute("CutscenePlaying", false)
        task.wait(0.12)

        local t10 = {
            BackgroundTransparency = 1
        }

        TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t10):Play()
        task.wait(0.6)
        bars(false, 0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(0.85)

        if v27 == p22 then
            v27 = nil
            ScreenGui.Enabled = false
        end
    else
        v27 = nil
        LocalPlayer:SetAttribute("CutscenePlaying", false)

        local t11 = {
            BackgroundTransparency = 1
        }

        TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), t11):Play()
        task.wait(0.3)
        ScreenGui.Enabled = false
    end
end

local t12 = {}
local check

local function watch(p23) -- line: 228
    -- upvalues: LocalPlayer (copy), v11 (ref), v27 (ref), play (copy), t12 (copy), check (ref)
    v11 = p23

    local function check2() -- line: 230
        -- upvalues: p23 (copy), LocalPlayer (copy), v27 (ref), play (copy), t12 (copy)
        local CutsceneId = p23:GetAttribute("CutsceneId")

        if typeof(CutsceneId) == "number" and not t12[CutsceneId] and v27 == nil and (p23:GetAttribute("CutsceneEnd") or 0) > 0 then
            local v56 = LocalPlayer:GetAttribute("GfxCutscenes") ~= false

            if v56 then
                local v57

                if LocalPlayer:GetAttribute("RaceGridLocked") == true then
                    v57 = true
                else
                    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

                    v57 = if JerezRaceHUD ~= nil then JerezRaceHUD:GetAttribute("LobbySpectating") == true or LocalPlayer:GetAttribute("AFKMode") == true else LocalPlayer:GetAttribute("AFKMode") == true
                end

                if v57 then
                    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

                    if not (JerezRaceHUD and JerezRaceHUD:GetAttribute("Freecam") == true) then
                        t12[CutsceneId] = true
                        task.spawn(play, CutsceneId)
                    end
                end
            end
        end
    end

    check = check2
    p23:GetAttributeChangedSignal("CutsceneId"):Connect(check2)
    check2()
end

task.spawn(function() -- line: 241
    -- upvalues: LocalPlayer (copy), v11 (ref), v27 (ref), play (copy), t12 (copy), check (ref)
    local v58 = workspace:WaitForChild("GridOfficials", 1e999)

    v11 = v58

    local function check2() -- line: 230
        -- upvalues: v58 (copy), LocalPlayer (copy), v27 (ref), play (copy), t12 (copy)
        local CutsceneId = v58:GetAttribute("CutsceneId")

        if typeof(CutsceneId) == "number" and not t12[CutsceneId] and v27 == nil and (v58:GetAttribute("CutsceneEnd") or 0) > 0 then
            local v59 = LocalPlayer:GetAttribute("GfxCutscenes") ~= false

            if v59 then
                local v60

                if LocalPlayer:GetAttribute("RaceGridLocked") == true then
                    v60 = true
                else
                    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

                    v60 = if JerezRaceHUD ~= nil then JerezRaceHUD:GetAttribute("LobbySpectating") == true or LocalPlayer:GetAttribute("AFKMode") == true else LocalPlayer:GetAttribute("AFKMode") == true
                end

                if v60 then
                    local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

                    if not (JerezRaceHUD and JerezRaceHUD:GetAttribute("Freecam") == true) then
                        t12[CutsceneId] = true
                        task.spawn(play, CutsceneId)
                    end
                end
            end
        end
    end

    check = check2
    v58:GetAttributeChangedSignal("CutsceneId"):Connect(check2)
    check2()
end)
LocalPlayer.CharacterAdded:Connect(function() -- line: 245
    -- upvalues: LocalPlayer (copy), ok (copy), result (copy), ScreenGui (copy), v2 (copy), v3 (copy), Frame (copy), t5 (copy), Hidden (ref), v9 (ref), v27 (ref), unbindCamera (copy)
    if not v27 or v27 == "intro" then
        return
    end

    v27 = nil
    unbindCamera()
    v9 = false

    for _, v61 in t5 do
        if v61.Parent then
            v61.Enabled = true
        end
    end

    table.clear(t5)

    if ok and result and Hidden ~= nil then
        result.Hidden = Hidden
        Hidden = nil
    end

    LocalPlayer:SetAttribute("CutscenePlaying", false)
    Frame.BackgroundTransparency = 1
    v2.Size = UDim2.fromScale(1, 0)
    v3.Size = UDim2.fromScale(1, 0)
    ScreenGui.Enabled = false
end)

local HttpService = game:GetService("HttpService")
local v62 = game:IsLoaded()
local elapsed, elapsed2

if v62 then
    elapsed2 = os.clock()
    elapsed = elapsed2
end

local elapsed3

if not v62 or not elapsed2 then
    elapsed = nil
else
    elapsed3 = elapsed2
end

if not elapsed3 then
    game.Loaded:Once(function() -- line: 263
        -- upvalues: elapsed (ref)
        elapsed = os.clock()
    end)
end

local function introOff() -- line: 264
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("GfxCutscenes") == false
end

local v63

LocalPlayer:GetAttributeChangedSignal("GfxCutscenes"):Connect(function() -- line: 267
    -- upvalues: LocalPlayer (copy), v63 (ref)
    if LocalPlayer:GetAttribute("SavedSettings") ~= nil then
        v63 = LocalPlayer:GetAttribute("GfxCutscenes") ~= false
    end
end)

local function introSetting() -- line: 270
    -- upvalues: LocalPlayer (copy), HttpService (copy), v63 (ref)
    if LocalPlayer:GetAttribute("GfxCutscenes") == false then
        return false
    end

    if v63 ~= nil then
        return v63
    end

    local SavedSettings = LocalPlayer:GetAttribute("SavedSettings")

    if typeof(SavedSettings) ~= "string" then
        return nil
    end

    local JSONDecode = HttpService.JSONDecode
    local ok, result = pcall(JSONDecode, HttpService, SavedSettings)

    if ok then
        ok = false

        if typeof(result) == "table" and typeof(result.client) == "table" then
            ok = result.client.gfx
        end
    end

    return not (typeof(ok) == "table" and ok.cutscenes == false)
end

local function introDistance(p24, p25, p26, p27) -- line: 280
    -- upvalues: Players (copy)
    local v64 = if p24.RigType == Enum.HumanoidRigType.R6 then 3 else p24.HipHeight + p25.Size.Y / 2
    local t13 = {}

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t13, player.Character)
        end
    end

    local v65 = table.clone(t13)
    local v66 = RaycastParams.new()

    v66.FilterType = Enum.RaycastFilterType.Exclude
    v66.FilterDescendantsInstances = v65

    local v67 = p26.Y - v64
    local v68 = v67 + 0.45
    local v69 = v67 + v64 + 2
    local v71 = Vector3.new(p26.X, (v68 + v69) / 2, p26.Z)
    local n2 = 12

    for _ = 1, 12 do
        local v74 = workspace:Blockcast(CFrame.lookAt(v71, v71 - p27), Vector3.new(2.6, v69 - v68, 1), -p27 * 13.5, v66)

        if not v74 then
            break
        end

        local Instance = v74.Instance

        if Instance.CanCollide or Instance:IsA("Seat") or Instance:IsA("VehicleSeat") then
            n2 = math.min(12, v74.Distance - 1.2)
            break
        end

        table.insert(v65, Instance)
        v66.FilterDescendantsInstances = v65
    end

    local v76 = RaycastParams.new()

    v76.FilterType = Enum.RaycastFilterType.Exclude
    v76.RespectCanCollide = true
    v76.FilterDescendantsInstances = t13

    while true do
        if not (n2 >= 2) then
            return 0
        end

        local v79 = workspace:Raycast(p26 - p27 * n2, Vector3.new(0, -(v64 + 3), 0), v76)

        if v79 and v79.Normal.Y > 0.7 and math.abs(v79.Position.Y - v67) < 1.2 then
            break
        end

        n2 -= 1.5
    end

    return n2
end

local v81 = "hold"
local walk

local function introStep() -- line: 310
    -- upvalues: LocalPlayer (copy), v81 (ref), walk (ref)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return
    end

    local walk2 = walk
    local v82

    if v81 ~= "walk" or not walk2 or walk2.char ~= Character or walk2.off then
        v82 = Vector3.new(0, 0, 0)
    else
        local v83 = walk2.target - walk2.hrp.Position
        local v84 = Vector3.new(v83.X, 0, v83.Z)
        local v85 = v84:Dot(walk2.look)
        local v86 = walk2.t1 - os.clock()

        if v84.Magnitude > walk2.dist + 4 then
            walk2.off = true
            v82 = Vector3.new(0, 0, 0)
        elseif v85 > 0.08 and v86 > 0 then
            Humanoid.WalkSpeed = math.clamp(v85 / v86, 1, 16)
            walk2.speedSet = Humanoid.WalkSpeed
            v82 = v84.Magnitude > 0.3 and v84.Unit or walk2.look
        else
            v82 = Vector3.new(0, 0, 0)
        end
    end

    Humanoid:Move(v82)
    Humanoid.Jump = false
end

local v88 = workspace:FindFirstChild("PlayerPitboxes", true)

local function pitMarker() -- line: 329
    -- upvalues: LocalPlayer (copy), v88 (copy)
    local PitboxIndex = LocalPlayer:GetAttribute("PitboxIndex")
    local v89, v90

    if not v88 or PitboxIndex == nil then
        v90 = false
    else
        local v91 = v88:FindFirstChild("Pitbox_" .. tostring(PitboxIndex))

        if v91 then
            v89 = v91
            v90 = true
        else
            v90 = false
        end
    end

    if not v90 then
        v89 = nil
    end

    return v89
end

local function pitArrive() -- line: 335
    -- upvalues: LocalPlayer (copy), v88 (copy)
    local elapsed = os.clock()
    local v92

    while true do
        if not (os.clock() - elapsed < 4) then
            return nil
        end

        if LocalPlayer:GetAttribute("GfxCutscenes") == false then
            break
        end

        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        local PitboxIndex = LocalPlayer:GetAttribute("PitboxIndex")
        local v93, v94

        if not v88 or PitboxIndex == nil then
            v94 = false
        else
            local v95 = v88:FindFirstChild("Pitbox_" .. tostring(PitboxIndex))

            if v95 then
                v93 = v95
                v94 = true
            else
                v94 = false
            end
        end

        if not v94 then
            v93 = nil
        end

        local v96

        if Humanoid and HumanoidRootPart and v93 and Humanoid.Health > 0 and not HumanoidRootPart.Anchored and not Humanoid.SeatPart and (HumanoidRootPart.Position - v93.Position).Magnitude < 40 then
            local v97 = v92 or os.clock()

            if os.clock() - v97 >= 0.3 and (Character:GetAttribute("AccountScaleApplied") == true or os.clock() - elapsed > 4) then
                return Character, Humanoid, HumanoidRootPart
            end

            v96 = v97
        end

        v92 = v96
        task.wait()
    end

    return nil
end

local function introPlay(p28, p29, p30, p31, p32) -- line: 352
    -- upvalues: elapsed (ref), RunService (copy), LocalPlayer (copy), v2 (copy), v3 (copy), Frame (copy), bars (copy), hideHud (copy), introDistance (copy), v81 (ref), walk (ref)
    if p30 and p31 and p32 and LocalPlayer.Character == p30 and p30.Parent and p31.Health > 0 and not p31.SeatPart then
        local JerezRaceHUD = LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

        if JerezRaceHUD == nil or JerezRaceHUD:GetAttribute("LobbySpectating") ~= true then
            local _CFrame = p32.CFrame
            local v99 = Vector3.new(_CFrame.LookVector.X, 0, _CFrame.LookVector.Z)
            local v100 = v99.Magnitude > 0.1 and v99.Unit or Vector3.new(0, 0, -1)
            local CFramePosition = _CFrame.Position
            local v101 = introDistance(p31, p32, CFramePosition, v100)

            if v101 >= 2 then
                local v102 = CFramePosition - v100 * v101

                p32.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                p30:PivotTo(CFrame.lookAt(v102, v102 + v100))
                p28.walk = {
                    char = p30,
                    hum = p31,
                    hrp = p32,
                    target = CFramePosition,
                    look = v100,
                    dist = v101,
                    speedWas = p31.WalkSpeed
                }
            end

            task.wait()

            local CurrentCamera = workspace.CurrentCamera

            if CurrentCamera.CameraType == Enum.CameraType.Custom and CurrentCamera.CameraSubject == p31 then
                local v103 = p32.Position + Vector3.new(0, 1.5, 0)
                local v104 = math.clamp((CurrentCamera.CFrame.Position - v103).Magnitude, 8, 20)
                local Unit = (v100 * 0.9781476007338057 - Vector3.new(0, 0.20791169, 0)).Unit

                CurrentCamera.CFrame = CFrame.lookAt(v103 - Unit * v104, v103)
            end
        end
    end

    hideHud()
    p28.hud = true
    LocalPlayer:SetAttribute("CutscenePlaying", true)
    p28.cut = true

    while true do
        local elapsed2 = elapsed

        if (not elapsed2 or os.clock() - elapsed < 0.8) and os.clock() - p29 < 20 then
            task.wait()
            continue
        end

        break
    end

    task.wait(0.35)

    local elapsed2 = os.clock()
    local n3 = 0

    while n3 < 8 and os.clock() - elapsed2 < 2 do
        if RunService.RenderStepped:Wait() < 0.05 then
            n3 += 1
        else
            n3 = 0
        end
    end

    if LocalPlayer:GetAttribute("GfxCutscenes") ~= false then
        local v105 = os.clock() + 1.1 + 0.45
        local v106 = v105 + 0.85

        if p28.walk then
            p28.walk.t1 = v106
            walk = p28.walk
            v81 = "walk"
        end

        v2.Size = UDim2.fromScale(1, 0.51)
        v3.Size = UDim2.fromScale(1, 0.51)
        Frame.BackgroundTransparency = 1
        bars(true, 1.1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)

        while os.clock() < v105 do
            if LocalPlayer:GetAttribute("GfxCutscenes") == false then
                return "skip"
            end

            task.wait()
        end

        bars(false, 0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

        while true do
            if not (os.clock() < v106) then
                return "done"
            end

            if LocalPlayer:GetAttribute("GfxCutscenes") == false then
                break
            end

            task.wait()
        end
    end

    return "skip"
end

local n4 = 0

task.spawn(function() -- line: 397
    -- upvalues: MotoLegends (copy), n4 (ref)
    local v107 = MotoLegends:WaitForChild("RaceEvent", 30)

    if v107 then
        v107.OnClientEvent:Connect(function(p33, p34) -- line: 399
            -- upvalues: n4 (ref)
            if p33 == "RaceNotice" and typeof(p34) == "table" and p34.text == "NOT NOW" then
                n4 = os.clock()
            end
        end)
    end
end)

local function introRun(p35, p36, p37) -- line: 403
    -- upvalues: RunService (copy), LocalPlayer (copy), introSetting (copy), introStep (copy), pitArrive (copy), introPlay (copy), n4 (ref)
    local elapsed = os.clock()

    RunService:BindToRenderStep("JoinIntro", Enum.RenderPriority.Input.Value + 5, introStep)

    local v109, v110, v111, v112, Character, Character2, v113, v114, elapsed2, v115, child

    if p37 then
        while true do
            if (LocalPlayer:GetAttribute("PitIntroToken") or 0) <= p37 then
                if os.clock() - elapsed > 2.5 or elapsed <= n4 or LocalPlayer:GetAttribute("GfxCutscenes") == false then
                    break
                end

                task.wait()
                continue
            end

            if p36 == "join" then
                v112 = introSetting()

                while v112 == nil and os.clock() - elapsed < 4 do
                    task.wait(0.05)
                    v112 = introSetting()
                end

                if v112 == false then
                    return "off"
                end

                Character = nil

                while not Character and os.clock() - elapsed < 15 do
                    Character2 = LocalPlayer.Character
                    Character = Character2

                    if not Character2 then
                        task.wait(0.05)
                    end
                end

                v113 = Character and Character:WaitForChild("Humanoid", 5)
                v114 = Character and Character:WaitForChild("HumanoidRootPart", 5)

                if v113 and v114 and v113:IsA("Humanoid") then
                    child = nil

                    for _, child2 in workspace:GetChildren() do
                        if child2:IsA("SpawnLocation") and child2.Name:match("PaddockSpawn$") then
                            child = child2
                            break
                        end
                    end

                    elapsed2 = os.clock()

                    while os.clock() - elapsed2 < 4 and LocalPlayer.Character == Character do
                        if LocalPlayer:GetAttribute("GfxCutscenes") == false then
                            break
                        end

                        v115 = if not child or LocalPlayer:GetAttribute("PitboxIndex") == nil then os.clock() - elapsed2 > 0.7 else (v114.Position - child.Position).Magnitude > 45

                        if v115 and Character:GetAttribute("AccountScaleApplied") == true then
                            break
                        end

                        task.wait()
                    end

                    task.wait(0.1)

                    if LocalPlayer:GetAttribute("GfxCutscenes") == false then
                        return "off"
                    end

                    return (introPlay(p35, elapsed, Character, v113, v114))
                end

                Character = nil

                return (introPlay(p35, elapsed, Character, v113, v114))
            end

            v109, v110, v111 = pitArrive()

            if not v109 then
                return "off"
            end

            return (introPlay(p35, elapsed, v109, v110, v111))
        end

        return "off"
    end

    if p36 == "join" then
        v112 = introSetting()

        while v112 == nil and os.clock() - elapsed < 4 do
            task.wait(0.05)
            v112 = introSetting()
        end

        if v112 == false then
            return "off"
        end

        Character = nil

        while not Character and os.clock() - elapsed < 15 do
            Character2 = LocalPlayer.Character

            if not Character2 then
                task.wait(0.05)
            end

            Character = Character2
        end

        v113 = Character and Character:WaitForChild("Humanoid", 5)
        v114 = Character and Character:WaitForChild("HumanoidRootPart", 5)

        if v113 and v114 and v113:IsA("Humanoid") then
            child = nil

            for _, child2 in workspace:GetChildren() do
                if child2:IsA("SpawnLocation") and child2.Name:match("PaddockSpawn$") then
                    child = child2
                    break
                end
            end

            elapsed2 = os.clock()

            while os.clock() - elapsed2 < 4 and LocalPlayer.Character == Character and LocalPlayer:GetAttribute("GfxCutscenes") ~= false do
                v115 = if not child or LocalPlayer:GetAttribute("PitboxIndex") == nil then os.clock() - elapsed2 > 0.7 else (v114.Position - child.Position).Magnitude > 45

                if v115 and Character:GetAttribute("AccountScaleApplied") == true then
                    break
                end

                task.wait()
            end

            task.wait(0.1)

            if LocalPlayer:GetAttribute("GfxCutscenes") == false then
                return "off"
            end

            return (introPlay(p35, elapsed, Character, v113, v114))
        end

        Character = nil

        return (introPlay(p35, elapsed, Character, v113, v114))
    end

    v109, v110, v111 = pitArrive()

    if not v109 then
        return "off"
    end

    return (introPlay(p35, elapsed, v109, v110, v111))
end

local function introCleanup(p38, p39) -- line: 442
    -- upvalues: RunService (copy), LocalPlayer (copy), ok (copy), result (copy), ScreenGui (copy), v2 (copy), v3 (copy), Frame (copy), bars (copy), t5 (copy), Hidden (ref), v9 (ref), v27 (ref), check (ref), v81 (ref), walk (ref)
    local function v116() -- line: 443
        -- upvalues: RunService (copy)
        RunService:UnbindFromRenderStep("JoinIntro")
    end

    pcall(v116)
    v81 = nil
    walk = nil

    local walk2 = p38.walk

    if walk2 and walk2.hum.Parent then
        walk2.hum:Move((Vector3.new(0, 0, 0)))

        if walk2.speedSet and walk2.hum.WalkSpeed == walk2.speedSet then
            walk2.hum.WalkSpeed = walk2.speedWas
        end

        if p39 ~= "done" and LocalPlayer.Character == walk2.char and (walk2.target - walk2.hrp.Position).Magnitude <= walk2.dist + 4 then
            walk2.char:PivotTo(CFrame.lookAt(walk2.target, walk2.target + walk2.look))
        end
    end

    if p38.hud then
        v9 = false

        for _, v117 in t5 do
            if v117.Parent then
                v117.Enabled = true
            end
        end

        table.clear(t5)

        if ok and result and Hidden ~= nil then
            result.Hidden = Hidden
            Hidden = nil
        end
    end

    if p38.cut then
        LocalPlayer:SetAttribute("CutscenePlaying", false)
    end

    bars(false, 0)
    v2.Size = UDim2.fromScale(1, 0)
    v3.Size = UDim2.fromScale(1, 0)
    Frame.BackgroundTransparency = 1

    if v27 == "intro" then
        v27 = nil
        ScreenGui.Enabled = false
    end

    if check then
        task.defer(check)
    end
end

local function startIntro(p40, p41) -- line: 461
    -- upvalues: LocalPlayer (copy), ScreenGui (copy), v2 (copy), v3 (copy), Frame (copy), bars (copy), v27 (ref), v81 (ref), walk (ref), introRun (copy), introCleanup (copy)
    v27 = "intro"
    ScreenGui.Enabled = true
    Frame.BackgroundTransparency = 0
    bars(false, 0)
    v2.Size = UDim2.fromScale(1, 0)
    v3.Size = UDim2.fromScale(1, 0)
    v81 = "hold"
    walk = nil
    task.spawn(function() -- line: 465
        -- upvalues: p40 (copy), p41 (copy), LocalPlayer (copy), introRun (copy), introCleanup (copy)
        local t14 = {}
        local ok, result = pcall(introRun, t14, p40, p41)

        if not ok then
            warn("[GridCutscene] pitbox intro (" .. p40 .. "): " .. tostring(result))
        end

        if not ok or not result then
            result = "error"
        end

        introCleanup(t14, result)

        if p40 == "join" then
            LocalPlayer:SetAttribute("PitIntroDone", true)
        end
    end)
end

startIntro("join")

local v118 = LocalPlayer.Character ~= nil

LocalPlayer.CharacterAdded:Connect(function() -- line: 477
    -- upvalues: LocalPlayer (copy), v27 (ref), introSetting (copy), v88 (copy), startIntro (copy), v118 (ref)
    if v118 then
        if v27 == nil and introSetting() == true then
            local PitboxIndex = LocalPlayer:GetAttribute("PitboxIndex")

            if v88 and PitboxIndex ~= nil and v88:FindFirstChild("Pitbox_" .. tostring(PitboxIndex)) and not LocalPlayer:GetAttribute("RaceGridLocked") and LocalPlayer:GetAttribute("AFKMode") ~= true then
                startIntro("respawn")
            end
        end
    else
        v118 = true
    end
end)
LocalPlayer:GetAttributeChangedSignal("PitIntroRequest"):Connect(function() -- line: 485
    -- upvalues: LocalPlayer (copy), v27 (ref), introSetting (copy), v88 (copy), startIntro (copy)
    if v27 == nil and introSetting() == true then
        local PitboxIndex = LocalPlayer:GetAttribute("PitboxIndex")

        if v88 and PitboxIndex ~= nil and v88:FindFirstChild("Pitbox_" .. tostring(PitboxIndex)) then
            startIntro("pit", LocalPlayer:GetAttribute("PitIntroToken") or 0)
        end
    end
end)
LocalPlayer:GetAttributeChangedSignal("PitIntroToken"):Connect(function() -- line: 490
    -- upvalues: LocalPlayer (copy), v27 (ref), introSetting (copy), v88 (copy), startIntro (copy)
    if v27 == nil and introSetting() == true then
        local PitboxIndex = LocalPlayer:GetAttribute("PitboxIndex")

        if v88 and PitboxIndex ~= nil and v88:FindFirstChild("Pitbox_" .. tostring(PitboxIndex)) then
            startIntro("pit")
        end
    end
end)
