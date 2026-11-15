-- https://lua.expert

game:GetService("RunService")

local Config = require(script.Parent.Config)
local BikeStats = require(script.Parent.BikeStats)
local BikeSuspension = require(script.Parent.BikeSuspension)
local BikeGearbox = require(script.Parent.BikeGearbox)
local PitLimiter = require(script.Parent.PitLimiter)
local BikeCrashPhysics = require(script.Parent.BikeCrashPhysics)
local TyreCatalog = script.Parent:FindFirstChild("TyreCatalog")

local function v1() -- line: 13
    -- upvalues: TyreCatalog (copy)
    return TyreCatalog and require(TyreCatalog)
end

local ok, result = pcall(v1)

if not ok or not result then
    result = nil
end

local t1 = {}

t1.Slipstream = require(script.Parent:WaitForChild("LegendSlipstream"))

function t1.PrivateFeatures() -- line: 22
    return workspace:GetAttribute("PrivateFeatures") == true
end

t1.Base = {
    BoostFromKph = 180,
    BoostFullKph = 260,
    RollRate = 0.22,
    RollAccel = 0.25,
    RollFrequency = 0.18,
    SteerRate = 0.15,
    LeanShrinkFromKph = 210,
    LeanFloorDeg = 50,
    EdgeResistance = 0.75
}
t1.Legend = {
    SamuraiBoostFromKph = 60,
    SamuraiBoostFullKph = 160,
    SamuraiRollRate = 0.2,
    SamuraiRollAccel = 0.22,
    SamuraiRollFrequency = 0.15,
    SamuraiSteerRate = 0.15,
    SamuraiLeanShrinkFromKph = 230,
    SamuraiLeanFloorDeg = 54,
    SamuraiEdgeResistance = 0.6,
    SamuraiOversteerYaw = 0.04,
    SamuraiOversteerFromKph = 45,
    SamuraiOversteerFullKph = 110,
    SamuraiOversteerLeanFrom = 0.3,
    SamuraiOversteerLeanFull = 0.9,
    SamuraiYawBuild = 0.88,
    KuriSlideCrashYaw = 1.12,
    KuriSlideCrashSeconds = 1.4,
    KuriMidFromKph = 60,
    KuriMidFullKph = 110,
    KuriMidEndKph = 170,
    KuriMidOffKph = 230,
    KuriMidSlide = 0.35,
    KuriSlidePowerKeep = 0.35,
    KuriSlideDrive = 0.03,
    DoctorStoppieFrom = 0.008726646259971648,
    DoctorStoppieFull = 0.05235987755982989,
    DoctorBrakeBonus = 0.7,
    DoctorBrakeStoppie = 1.25,
    DoctorCornerStoppiePitch = 1.3,
    DoctorCornerStoppieSeconds = 0.26,
    EmperorWheelieFrom = 0.026179938779914945,
    EmperorWheelieFull = 0.5235987755982988,
    EmperorLossKeep = 1,
    EmperorWheelieDrive = 0.15
}
t1.Weight = {
    RiderKg = 70,
    BikeKg = 157,
    ReferenceKg = 200,
    ShiftSeconds = 0.3,
    ShiftSecondsFast = 0.42,
    UnloadedResponse = 0.6,
    FromKph = 20,
    FullKph = 60,
    YawGain = 0.96,
    HangOffYawBonus = 0.05,
    YawBuildSeconds = 0.1,
    YawBuildSecondsFast = 0.15,
    ReleaseSteerRate = 0.5,
    PickUpResponse = 0.6,
    ReleaseSteerRateFast = 0.3,
    PickUpResponseFast = 0.3,
    PickUpFromKph = 80,
    PickUpFullKph = 300
}
t1.Turn = {
    BaseWeight = 0.9,
    SpeedHeavy = 0.33,
    SpeedHeavyFromKph = 60,
    SpeedHeavyFullKph = 320,
    EdgeFrom = 0.35,
    EdgeResistance = 0.58,
    EdgeMin = 0.18,
    UprightTipWeight = 0.5,
    UprightTipFrom = 0.13962634015954636,
    UprightTipFade = 0.5585053606381855,
    UprightLean = 0.13962634015954636,
    FlickRollRate = 0.5235987755982988,
    TipInHeavy = 0.9,
    TipInEdgeExtra = 0.3,
    ResistSmooth = 10,
    RollCapEase = 8,
    LeanStartWeight = 0.65,
    LeanStartFull = 0.03490658503988659,
    LeanStartFade = 0.20943951023931956,
    LeanStartReset = 0.08,
    LeanStartWeightNearMax = 0.4,
    LeanStartNearFrom = 0.4363323129985824,
    LeanStartNearFull = 0.8377580409572782
}
t1.ExitSlide = {
    MinPeak = 0.20943951023931956,
    PickFrom = 0.026179938779914945,
    PickFull = 0.10471975511965978,
    ResetLean = 0.05235987755982989,
    Rise = 10,
    Fall = 10,
    UprightLean = 0.17453292519943295,
    TipRate = 0.06981317007977318,
    LockThrottle = 0.95,
    UnlockThrottle = 0.9
}
t1.SlideMidHigh = {
    Low = 1.5,
    High = 0.81,
    CurvePower = 3
}
t1.RearSkid = {
    FrontFrom = 0.15,
    FrontFull = 0.5,
    ThrottleOff = 0.15,
    LockFull = 0.35,
    Yaw = 0.55,
    FromKph = 15,
    FullKph = 40,
    GrowFrom = 0.15,
    GrowRate = 0.6,
    SettleRate = 1.2,
    CounterRate = 2.5,
    ReleaseRate = 3
}
t1.StoppieEBS = { 0.687, 0.769, 0.96, 0.938, 0.855 }

function t1.RiderKg(p1) -- line: 186
    -- upvalues: t1 (copy)
    local v2 = p1.root and p1.root.Parent
    local RiderWeightKg = v2 and v2:GetAttribute("RiderWeightKg")
    local v3, v4

    if typeof(RiderWeightKg) == "number" and RiderWeightKg == RiderWeightKg then
        local v5 = math.clamp(RiderWeightKg, 40, 130)

        if v5 then
            v3 = v5
            v4 = true
        else
            v4 = false
        end
    else
        v4 = false
    end

    if not v4 then
        v3 = t1.Weight.RiderKg
    end

    return v3
end

function t1.BikeStats(p2) -- line: 192
    -- upvalues: BikeStats (copy)
    local v6 = p2.root and p2.root.Parent

    return BikeStats.Physics(v6 and v6:GetAttribute("BikeName"))
end

function t1.LegendAbility(p3) -- line: 196
    local v7 = p3.root and p3.root.Parent

    return v7 and v7:GetAttribute("LegendAbility") or ""
end

local function ramp(p4, p5, p6) -- line: 200
    local v9 = math.clamp((p4 - p5) / (p6 - p5), 0, 1)

    return v9 * v9 * (3 - 2 * v9)
end

function t1.BaseLeanBoost(p7) -- line: 202
    -- upvalues: t1 (copy)
    local Base = t1.Base

    p7 = p7 or 0

    local BoostFromKph, BoostFullKph = Base.BoostFromKph, Base.BoostFullKph
    local v12 = math.clamp((p7 - BoostFromKph) / (BoostFullKph - BoostFromKph), 0, 1)

    return v12 * v12 * (3 - 2 * v12)
end

function t1.SamuraiLeanBoost(p8) -- line: 205
    -- upvalues: t1 (copy)
    local Legend = t1.Legend

    p8 = p8 or 0

    local SamuraiBoostFromKph, SamuraiBoostFullKph = Legend.SamuraiBoostFromKph, Legend.SamuraiBoostFullKph
    local v15 = math.clamp((p8 - SamuraiBoostFromKph) / (SamuraiBoostFullKph - SamuraiBoostFromKph), 0, 1)

    return v15 * v15 * (3 - 2 * v15)
end

function t1.KuriMidSpeed(p9) -- line: 209
    -- upvalues: t1 (copy)
    local Legend = t1.Legend

    p9 = p9 or 0

    local KuriMidFromKph, KuriMidFullKph = Legend.KuriMidFromKph, Legend.KuriMidFullKph
    local v18 = math.clamp((p9 - KuriMidFromKph) / (KuriMidFullKph - KuriMidFromKph), 0, 1)
    local v19 = v18 * v18 * (3 - 2 * v18)
    local KuriMidEndKph, KuriMidOffKph = Legend.KuriMidEndKph, Legend.KuriMidOffKph
    local v21 = math.clamp((p9 - KuriMidEndKph) / (KuriMidOffKph - KuriMidEndKph), 0, 1)

    return v19 * (1 - v21 * v21 * (3 - 2 * v21))
end

local v22 = RaycastParams.new()

v22.FilterType = Enum.RaycastFilterType.Include

local function v23() -- line: 218
    -- upvalues: v22 (copy)
    v22.CollisionGroup = "RaceBike"
end

pcall(v23)

local t2 = {
    [Enum.Material.Sand] = "Gravel",
    [Enum.Material.Asphalt] = "Asphalt",
    [Enum.Material.Concrete] = "Asphalt",
    [Enum.Material.Pavement] = "Asphalt"
}

function t1.SurfaceOf(p10) -- line: 221
    -- upvalues: t2 (copy)
    if not p10 then
        return nil
    end

    if p10.Instance == workspace.Terrain then
        return t2[p10.Material] or "Grass"
    end

    return p10.Instance:GetAttribute("Surface")
end

t1.RunoffGrip = {
    Tarmac = 0.75,
    Paint = 0.65,
    Kerb = 0.75
}

local v24

function t1.RaceCollision() -- line: 236
    -- upvalues: v24 (ref)
    if not (v24 and v24.Parent) then
        v24 = workspace:FindFirstChild("RaceCollision", true)
    end

    return v24
end

local self = setmetatable({}, {
    __mode = "k"
})

function t1.RunoffGripOf(p11) -- line: 242
    -- upvalues: t1 (copy), v24 (ref), self (copy)
    local v26 = false
    local v27 = false
    local v28 = false
    local v29 = false
    local v30 = false

    if p11 then
        v26 = true
    else
        v30 = true
    end

    if v26 then
        if p11.Instance == workspace.Terrain then
            v30 = true
        else
            v27 = true
        end
    end

    v26 = false

    local Instance, v31

    if v27 then
        Instance = p11.Instance

        local v32 = self[Instance]

        if v32 ~= nil then
            v31 = v32
            v30 = false
        else
            v26 = true
        end
    end

    v27 = false

    local v33

    if v26 then
        if t1.IsKerb then
            v27 = true
        else
            v33 = 1
            v28 = true
        end
    end

    v26 = false

    if v27 then
        if t1.IsKerb(p11) then
            v26 = true
        else
            v33 = 1
            v28 = true
        end
    end

    v27 = false

    if v26 then
        v33 = t1.RunoffGrip.Kerb
        v28 = true
    end

    v26 = false

    if v28 then
        if v24 then
            v26 = true
        else
            v27 = true
        end
    end

    v28 = false

    if v26 then
        if v24.Parent then
            v28 = true
        else
            v27 = true
        end
    end

    v26 = false

    if v27 then
        v24 = workspace:FindFirstChild("RaceCollision", true)
        v28 = true
    end

    v27 = false

    local v34, v35

    if v28 then
        v34 = v24

        if v34 then
            v27 = true
        else
            v35 = v34
            v26 = true
        end
    end

    v28 = false

    if v27 then
        v35 = v34:FindFirstChild("Runoff")
        v26 = true
    end

    v27 = false

    local v36

    if v26 then
        if v33 == 1 then
            v27 = true
        else
            v36 = v33
            v28 = true
        end
    end

    v26 = false

    if v27 then
        if v35 then
            v26 = true
        else
            v36 = v33
            v28 = true
        end
    end

    v27 = false

    if v26 then
        if Instance:IsDescendantOf(v35) then
            v27 = true
        else
            v36 = v33
            v28 = true
        end
    end

    v26 = false

    if v27 then
        if Instance.Name == "LongLapLane" then
            v36 = v33
            v28 = true
        else
            v26 = true
        end
    end

    v27 = false

    if v26 then
        if Instance:GetAttribute("LongLap") == true then
            v36 = v33
            v28 = true
        else
            v27 = true
        end
    end

    v26 = false

    local Name

    if v27 then
        Name = Instance.Name

        if Name:find("Paint") then
            v29 = true
        else
            v26 = true
        end
    end

    v27 = false

    if v26 then
        if Name:find("TrackLimitGreen") then
            v29 = true
        else
            v27 = true
        end
    end

    v26 = false

    local v37

    if v29 then
        local Paint = t1.RunoffGrip.Paint

        if Paint then
            v37 = Paint
            v26 = true
        else
            v27 = true
        end
    end

    if v27 then
        v37 = t1.RunoffGrip.Tarmac
        v26 = true
    end

    if v26 then
        v36 = v37
        v28 = true
    end

    if v28 then
        self[Instance] = v36
        v31 = v36
        v30 = false
    end

    if not v30 then
        return v31
    end

    return 1
end

local v38 = false

local function cast(p12) -- line: 260
    -- upvalues: v22 (copy), v24 (ref), v38 (ref)
    if not (v24 and v24.Parent) then
        v24 = workspace:FindFirstChild("RaceCollision", true)
    end

    local v39 = v24

    if v39 ~= v38 then
        v38 = v39
        v22.FilterDescendantsInstances = {
            v39,
            workspace.Terrain
        }
    end

    local v40 = workspace:Raycast(p12 + Vector3.new(0, 3, 0), Vector3.new(-0, -12, -0, -0), v22)
    local v41 = if not v40 or not (v40.Normal.Y > 0.55) or v40.Instance:GetAttribute("Surface") == "Barrier" then nil else v40

    return v41
end

t1.WallCrashKph = 15
t1.RoadSusp = {
    Hz = 1,
    HzFast = 0.5,
    FastFromKph = 60,
    FastFullKph = 180,
    Damping = 0.35,
    Up = 0.35,
    Down = 0.25
}

function t1.RoadHit(p13, p14) -- line: 281
    -- upvalues: t1 (copy), v24 (ref)
    if not (t1._roadRoot and t1._roadRoot.Parent) then
        if v24 then
            if not v24.Parent then
                v24 = workspace:FindFirstChild("RaceCollision", true)
            end
        else
            v24 = workspace:FindFirstChild("RaceCollision", true)
        end

        local v45 = v24

        t1._roadRoot = v45
        t1._roadParams = RaycastParams.new()
        t1._roadParams.FilterType = Enum.RaycastFilterType.Include
        t1._roadParams.FilterDescendantsInstances = v45 and {
            v45,
            workspace.Terrain
        } or { workspace.Terrain }
    end

    local v46 = p13.CFrame:PointToWorldSpace(p14)
    local v47 = workspace:Raycast(v46 + Vector3.new(0, 3, 0), Vector3.new(-0, -12, -0, -0), t1._roadParams)
    local v48 = if not v47 or not (v47.Normal.Y > 0.55) or v47.Instance:GetAttribute("Surface") == "Barrier" then nil else v47

    return v48
end

function t1.RoadFilter(p15, p16, p17, p18, p19) -- line: 294
    -- upvalues: t1 (copy)
    local RoadSusp = t1.RoadSusp
    local Hz = RoadSusp.Hz
    local v50 = RoadSusp.HzFast - RoadSusp.Hz

    p19 = p19 or 0

    local FastFromKph, FastFullKph = RoadSusp.FastFromKph, RoadSusp.FastFullKph
    local v53 = math.clamp((p19 - FastFromKph) / (FastFullKph - FastFromKph), 0, 1)
    local v54 = Hz + v50 * (v53 * v53 * (3 - 2 * v53))
    local Y, v55

    if p17 then
        local v56 = t1.SurfaceOf(p17)

        if v56 == "Grass" or v56 == "Gravel" or v56 == "Sand" then
            v55 = false
        else
            local Y2 = p17.Position.Y

            if Y2 then
                Y = Y2
                v55 = true
            else
                v55 = false
            end
        end
    else
        v55 = false
    end

    if not v55 then
        Y = nil
    end

    local v57 = p15[p16 .. "RoadG"]
    local v58 = p15[p16 .. "RoadV"]
    local v59 = p15[p16 .. "RoadE"] or 0
    local v60 = p15[p16 .. "RoadEV"] or 0
    local v61 = math.max(p18, 0.001)
    local v62 = not not (Y and v57 and math.abs(Y - v57) < 1.5)
    local v64, v65

    if v62 then
        local v66 = (Y - v57) / v61
        local v67 = v58 and math.clamp((v66 - v58) / v61, -4000, 4000) or 0
        local v69 = v54 * 2 * 3.141592653589793

        v64 = v60 + (-v69 * v69 * v59 - 2 * RoadSusp.Damping * v69 * v60 - v67) * v61
        v65 = v59 + v64 * v61

        if v65 < -RoadSusp.Up then
            v65 = -RoadSusp.Up
            v64 = math.max(v64, 0)
        elseif RoadSusp.Down < v65 then
            v65 = RoadSusp.Down
            v64 = math.min(v64, 0)
        end

        p15[p16 .. "RoadV"] = v66
    else
        v65 = v59 * math.exp(-v61 * 8)
        v64 = 0
        p15[p16 .. "RoadV"] = nil
    end

    p15[p16 .. "RoadG"] = Y
    p15[p16 .. "RoadE"] = v65
    p15[p16 .. "RoadEV"] = v64
    p15[p16 .. "RoadComp"] = -v65

    return -v65
end

t1.WallBox = {
    Size = Vector3.new(3.4, 4.7, 9.4),
    Offset = Vector3.new(0, 1.13, 0.5)
}

local v71 = OverlapParams.new()

v71.FilterType = Enum.RaycastFilterType.Include

local function v72() -- line: 318
    -- upvalues: v71 (copy)
    v71.CollisionGroup = "RaceBike"
end

pcall(v72)

local v73

function t1.WallCrashSpeed() -- line: 320
    -- upvalues: Config (copy), t1 (copy)
    return (math.min(Config.ImpactSpeed, t1.WallCrashKph / (Config.StudMetres * 3.6)))
end

function t1.WallContact(p20) -- line: 321
    -- upvalues: Config (copy), t1 (copy), v24 (ref), v71 (copy), v73 (ref)
    local root = p20.root

    if not (v73 and v73.Parent) then
        if not (v24 and v24.Parent) then
            v24 = workspace:FindFirstChild("RaceCollision", true)
        end

        v73 = v24

        if not v73 then
            return nil
        end

        v71.FilterDescendantsInstances = { v73 }
    end

    local v75 = Config.Wheelbase / 6.2017
    local v76 = root.CFrame * CFrame.new(t1.WallBox.Offset * v75)

    for _, v77 in workspace:GetPartBoundsInBox(v76, t1.WallBox.Size * v75, v71) do
        if v77:GetAttribute("Surface") == "Barrier" then
            return v77
        end
    end

    return nil
end

t1.TyreCrownScale = 1.1

function t1.SupportHeight(p21, p22, p23, p24) -- line: 340
    -- upvalues: t1 (copy)
    local v78 = p21:VectorToWorldSpace(p22)
    local v80 = math.min(p24 * t1.TyreCrownScale, p23)

    return math.sqrt(p21.UpVector.Y ^ 2 + p21.LookVector.Y ^ 2) * (p23 - v80) + v80 - v78.Y
end

function t1.ResolveContact(p25) -- line: 348
    -- upvalues: Config (copy), BikeSuspension (copy), t1 (copy), cast (copy)
    local root = p25.root

    if not root.Anchored and (root:GetAttribute("LossStage") or "") == "" then
        local v82, v83 = BikeSuspension.Axles(p25)
        local v84 = cast(root.CFrame:PointToWorldSpace(v82))
        local v85 = cast(root.CFrame:PointToWorldSpace(v83))

        if not (v84 or v85) then
            return
        end

        local v86, v87

        if t1.PrivateFeatures() then
            local elapsed = os.clock()
            local v89 = math.clamp(elapsed - (p25.roadClock or elapsed - 0.016666666666666666), 0.004166666666666667, 0.05)

            p25.roadClock = elapsed

            local v90 = root.AssemblyLinearVelocity.Magnitude * Config.StudMetres * 3.6

            for _, v91 in {
                    { "front", v84, -0.28, 0.4 },
                    { "rear", v85, -0.18, 0.48 }
                } do
                local v92 = v91[1]
                local v93 = p25[v92 .. "RoadComp"] or 0
                local v94 = t1.RoadFilter(p25, v92, v91[2], v89, v90)

                p25[v92 .. "Compression"] = math.clamp((p25[v92 .. "Compression"] or 0) - v93 + v94, v91[3], v91[4])
            end

            v86, v87 = BikeSuspension.Axles(p25)
        else
            v87 = v83
            v86 = v82
        end

        local Rotation = root.CFrame.Rotation
        local t5 = {}

        if v84 then
            table.insert(t5, v84.Position.Y + t1.SupportHeight(Rotation, v86, Config.FrontWheelRadius, Config.FrontTyreHalfWidth))
        end

        if v85 then
            table.insert(t5, v85.Position.Y + t1.SupportHeight(Rotation, v87, Config.RearWheelRadius, Config.RearTyreHalfWidth))
        end

        local v101 = math.max(table.unpack(t5)) + 0.018
        local v102 = v101 - root.Position.Y

        if not (v102 < -0.65 or v102 > 2.6) then
            local AssemblyLinearVelocity, AssemblyAngularVelocity = root.AssemblyLinearVelocity, root.AssemblyAngularVelocity

            root.CFrame += Vector3.new(0, 1, 0) * v102

            if v102 > 0.05 and p25.roadVy then
                local v103 = math.min(p25.roadVy, 0)

                if AssemblyLinearVelocity.Y < v103 then
                    AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, v103, AssemblyLinearVelocity.Z)
                end
            end

            root.AssemblyLinearVelocity = AssemblyLinearVelocity
            root.AssemblyAngularVelocity = AssemblyAngularVelocity
            p25.supportHeight = v101
        end
    end
end

function t1.Contact(p26) -- line: 388
    -- upvalues: Config (copy), BikeSuspension (copy), t1 (copy), cast (copy)
    local root = p26.root
    local v104, v105 = BikeSuspension.Axles(p26)
    local v106 = cast(root.CFrame:PointToWorldSpace(v104))
    local v107 = cast(root.CFrame:PointToWorldSpace(v105))

    return v106 and root.Position.Y - t1.SupportHeight(root.CFrame.Rotation, v104, Config.FrontWheelRadius, Config.FrontTyreHalfWidth) - v106.Position.Y or 1e999, v107 and root.Position.Y - t1.SupportHeight(root.CFrame.Rotation, v105, Config.RearWheelRadius, Config.RearTyreHalfWidth) - v107.Position.Y or 1e999, v106, v107
end

function t1.PowerSlideMargin(_) -- line: 399
    return 1, 1
end

function t1.MaxSlideLoss(p28, p29, p30) -- line: 404
    -- upvalues: Config (copy), t1 (copy)
    if p29.surface ~= "Grass" and p29.surface ~= "Gravel" then
        local _ = p29.surface == "Sand"
    end

    local v108 = t1.LegendAbility(p28) == "SlideMaster"
    local v109 = Config.RearYaw * (script:GetAttribute("MaxSlideCrashYaw") or 1) * 1 * (v108 and t1.Legend.KuriSlideCrashYaw or 1) + (p28.kerbSlideYaw or 0)
    local onGround = p29.onGround and (p29.kph or 0) > 0.5 and v109 < math.abs(p28.rearYaw or 0)

    p28.maxSlideTime = onGround and (p28.maxSlideTime or 0) + p30 or 0
    p28.powerSlide = p28.maxSlideTime

    return onGround and p28.maxSlideTime >= (script:GetAttribute("MaxSlideCrashSeconds") or 0.12) * (v108 and t1.Legend.KuriSlideCrashSeconds or 1)
end

function t1.SlideCrashSeconds(_) -- line: 417
    return script:GetAttribute("CrashSlideSeconds") or 0.65
end

function t1.SlideRisk(p32, p33) -- line: 421
    -- upvalues: Config (copy)
    local v112 = math.clamp(((p33 or 0) - 60) / 180, 0, 1)

    return v112 * v112 * (3 - v112 * 2), (math.clamp((math.abs(p32.lean or 0) / Config.MaxLean - 0.85) / 0.15, 0, 1))
end

function t1.SlideCrashKind(_, _, p36) -- line: 427
    if p36 == "Grass" or p36 == "Gravel" or p36 == "Sand" then
        return "LOWSIDE"
    end

    return "HIGHSIDE"
end

function t1.RearLoss(p37, p38, p39, _) -- line: 432
    -- upvalues: t1 (copy)
    if t1.PrivateFeatures() then
        local v116 = p38.surface == "Grass" or p38.surface == "Gravel" or p38.surface == "Sand" or p37.anyLoose == true

        if p37.gripHighside then
            p37.gripHighside = false

            if p38.onGround and not v116 then
                p37.lossGripCatch = true

                return true, "HIGHSIDE"
            end
        end

        local v117 = (p37.skidGrow or 0) > 0.05 or (p38.rearBrake or 0) > 0.1 and (p37.rearBrakeSlip or 0) > math.max(p37.tractionSlip or 0, (p37.exitSlip or 0) * 1.05)
        local v121 = false

        if (p37.gripGasOff or 0) >= 0.5 and math.max(p37.gripRisk or 0, p37.gripRelease or 0) >= t1.GripReturn.HighsideSlide then
            v121 = math.abs(p37.lean or 0) >= t1.GripReturn.HighsideMinLean
        end

        local v125, v126

        if v117 then
            v126 = false
        elseif not v121 or v116 then
            v126 = false
        else
            local v127 = t1.SlideCrashKind(p38.kph or 0, p37.lean, p38.surface)

            if v127 then
                v125 = v127
                v126 = true
            else
                v126 = false
            end
        end

        if not v126 then
            v125 = "LOWSIDE"
        end

        local v128 = t1.MaxSlideLoss(p37, p38, p39)

        p37.lossOverSlide = v128 and v125 == "LOWSIDE"
        p37.lossGripCatch = v128 and v125 == "HIGHSIDE"

        return v128, v125
    end

    p37.gripHighside = false
    p37.lossOverSlide = false
    p37.lossGripCatch = false

    local v129 = (p37.skidGrow or 0) > 0.05 or (p38.rearBrake or 0) > 0.1 and (p37.rearBrakeSlip or 0) > math.max(p37.tractionSlip or 0, (p37.exitSlip or 0) * 1.05)
    local v133 = (p38.throttle or 0) >= 0.15
    local v134, v135

    if v129 then
        v135 = false
    elseif v133 then
        local v136 = t1.SlideCrashKind(p38.kph or 0, p37.lean, p38.surface)

        if v136 then
            v134 = v136
            v135 = true
        else
            v135 = false
        end
    else
        v135 = false
    end

    if not v135 then
        v134 = "LOWSIDE"
    end

    return t1.MaxSlideLoss(p37, p38, p39), v134
end

function t1.LowSpeedPowerTolerance(_) -- line: 481
    return 0, 1
end

function t1.SlideLoss(p42, _, _) -- line: 485
    p42.slideLossRisk = 0

    return false
end

t1.FrontBrake = {
    Grip = 1.55,
    LeanScale = 0.9166666666666666,
    Tolerance = 1.14,
    MinLean = 0.3490658503988659,
    WetFrom = 0.17453292519943295,
    WetFull = 0.5235987755982988,
    RiskRate = 6,
    MaxRate = 3,
    ABSLimit = 0.95,
    ABSOnTime = 0.75,
    ABSOffTime = 1.3,
    EBS1ABSOffUse = 0.713,
    ABSOffUse = { 1, 1.472, 1.318, 1.063, 1.02 },
    EBSUse = { 0, 0.579, 0.713, 0.95, 1.05 },
    EBSRiskRate = { 1, 1, 1, 1.146, 1.766 },
    EBSMaxRate = { 1, 1, 1.429, 2, 2.857 },
    EBSTimeScale = { 0.743, 0.87, 1.043, 1.304, 1.565 },
    EBSGripCap = { 1, 1, 1, 1, 1.06 },
    EBSStrength = { 0.7, 0.78, 0.885, 1.016, 1.15 }
}

function t1.BrakeCanTuck(p45, p46) -- line: 572
    -- upvalues: Config (copy), t1 (copy)
    local v139 = math.clamp(math.round(p45 or Config.EBS or 2), 1, 5)

    if p46 ~= false or v139 ~= 1 then
        return (t1.FrontBrake.EBSUse[v139] or 1) > 0
    end

    return (t1.FrontBrake.EBS1ABSOffUse or 0) > 0
end

function t1.FrontBrakeOver(p47, p48, p49, p50, p51, p52) -- line: 578
    -- upvalues: Config (copy), t1 (copy)
    local FrontBrake = t1.FrontBrake
    local v141 = math.abs(p47 or 0)
    local v143 = math.clamp(p48 or 0, 0, 1)

    if v141 < FrontBrake.MinLean or v143 < 0.02 then
        return 0
    end

    local v146 = math.clamp(math.round(p51 or Config.EBS or 2), 1, 5)
    local v147 = if p49 == false and v146 == 1 then v143 * (FrontBrake.EBS1ABSOffUse or 0) else v143 * (FrontBrake.EBSUse[v146] * (p49 == false and FrontBrake.ABSOffUse[v146] or 1))
    local v150 = math.tan((math.min(v141 * FrontBrake.LeanScale, 1.3962634015954636)))
    local v153 = math.sqrt((math.max(0, FrontBrake.Grip * FrontBrake.Grip - v150 * v150))) / FrontBrake.Grip * FrontBrake.Tolerance

    if p50 then
        local v154 = 1 - (Config.RainGrip or 0.72)
        local WetFrom, WetFull = FrontBrake.WetFrom, FrontBrake.WetFull
        local v156 = math.clamp((v141 - WetFrom) / (WetFull - WetFrom), 0, 1)

        v153 *= 1 - v154 * (v156 * v156 * (3 - 2 * v156))
    end

    if typeof(p52) == "number" and p52 == p52 then
        v153 *= math.clamp(p52, 0.3, 1.5)
    end

    return v147 / math.max(v153, 0.01)
end

function t1.FrontBrakeRate(p53, p54, p55) -- line: 591
    -- upvalues: Config (copy), t1 (copy)
    local FrontBrake = t1.FrontBrake
    local v159 = math.clamp(math.round(p54 or Config.EBS or 2), 1, 5)
    local v160 = if p55 == nil then 1 elseif p55 == false then FrontBrake.ABSOffTime or 1 else FrontBrake.ABSOnTime or 1
    local v161, v162

    if p53 > 1 then
        local v165 = math.clamp(1 + (p53 - 1) * (FrontBrake.EBSRiskRate[v159] or FrontBrake.RiskRate), 1, FrontBrake.EBSMaxRate[v159] or FrontBrake.MaxRate)

        if v165 then
            v161 = v165
            v162 = true
        else
            v162 = false
        end
    else
        v162 = false
    end

    if not v162 then
        v161 = 1
    end

    return v161 * (FrontBrake.EBSTimeScale and FrontBrake.EBSTimeScale[v159] or 1) * v160
end

function t1.LooseBrakeLoss(p56, _, _) -- line: 597
    p56.looseBrakeRisk = 0

    return false
end

function t1.WetBrakeLoss(p59, _, _) -- line: 612
    p59.wetBrakeRisk = 0

    return false
end

function t1.LeanAuthority(_, _) -- line: 628
    -- upvalues: Config (copy)
    return Config.MaxLean, 1
end

function t1.Handling(p64) -- line: 638
    local v167 = math.clamp((p64 - 180) / 120, 0, 1)
    local v168 = v167 * v167 * (3 - v167 * 2)

    return 12 - v168 * 6.6, 17 - v168 * 11.3, 3.6 - v168 * 2, 27 - v168 * 15
end

function t1.SlideFrame(p65, p66) -- line: 644
    -- upvalues: Config (copy)
    local FrontAxle = Config.FrontAxle
    local v169 = p65:Inverse() * CFrame.Angles(0, p66, 0) * p65

    return CFrame.new(FrontAxle) * v169 * CFrame.new(-FrontAxle)
end

function t1.BeginCrashPhysics(p67, p68) -- line: 649
    -- upvalues: BikeCrashPhysics (copy)
    BikeCrashPhysics.Begin(p67, p68)
end

function t1.ReleaseCrashPhysics(p69) -- line: 650
    -- upvalues: BikeCrashPhysics (copy)
    return BikeCrashPhysics.Release(p69)
end

function t1.CrashRiderMotion(p70, p71) -- line: 651
    -- upvalues: BikeCrashPhysics (copy)
    return BikeCrashPhysics.RiderMotion(p70, p71)
end

function t1.LiftCornerLoss(p72, p73, p74, p75) -- line: 652
    -- upvalues: Config (copy), t1 (copy)
    local v171 = math.abs(p72.lean or 0) > 0.12 or math.abs(p72.steer or 0) > 0.18

    if p73.surface ~= "Asphalt" or not p73.onGround or p73.speed <= 18 or not v171 then
        return nil
    end

    local v174 = math.asin((math.clamp(p72.root.CFrame.LookVector.Y, -1, 1)))

    if p74 > 0.22 and p75 < 0.12 and Config.WheelieCornerCrashPitch < v174 then
        return "LOWSIDE"
    end

    local v175 = t1.LegendAbility(p72) == "StoppieBrake"

    return if p75 > 0.22 and p74 < 0.12 and v174 < -(Config.StoppieCornerCrashPitch or 0.17453292519943295) * (v175 and t1.Legend.DoctorCornerStoppiePitch or 1) then "STOPPIE" else nil
end

function t1.LiftCornerCrashSeconds(p76, p77) -- line: 662
    -- upvalues: t1 (copy)
    if p77 ~= "STOPPIE" or t1.LegendAbility(p76) ~= "StoppieBrake" then
        return 0.18
    end

    return t1.Legend.DoctorCornerStoppieSeconds
end

function t1.RHDScrapeLoss(p78, p79, p80) -- line: 667
    -- upvalues: Config (copy)
    local onGround = p79.onGround and (p79.kph or 0) > 8 and (p78.scrape or 0) > 0.1

    p78.rhdScrapeRisk = onGround and (p78.rhdScrapeRisk or 0) + p80 or 0

    return onGround and p78.rhdScrapeRisk >= (Config.RHDScrapeCrashSeconds or 1.5)
end

function t1.CombinedBrakeLoss(p81, p82, p83) -- line: 672
    -- upvalues: Config (copy)
    local v176 = (p82.kph or p82.speed * Config.StudMetres * 3.6) >= Config.DriveBrakeCrashKph
    local v177 = p82.speed > 8 and math.abs(p81.lean) > 0.3141592653589793
    local onGround = p82.onGround
    local v178 = onGround and (if v176 or v177 then p81.throttle > 0.92 and p81.brake > 0.92 else v177)

    p81.combinedBrakeRisk = v178 and (p81.combinedBrakeRisk or 0) + p83 or 0

    return p81.combinedBrakeRisk > 0.22
end

t1.AccelShape = {
    { 0, 0.7 },
    { 120, 0.72 },
    { 190, 0.85 },
    { 260, 1 },
    { 330, 1.12 },
    { 400, 1.2 },
    { 450, 1.2 }
}

function t1.AccelShapeAt(p84) -- line: 697
    -- upvalues: t1 (copy)
    local AccelShape = t1.AccelShape

    if typeof(p84) ~= "number" or p84 ~= p84 then
        return 1
    end

    if p84 <= AccelShape[1][1] then
        return AccelShape[1][2]
    end

    for i = 2, #AccelShape do
        local v179 = AccelShape[i - 1]
        local v180 = AccelShape[i]

        if p84 <= v180[1] then
            return v179[2] + (v180[2] - v179[2]) * (p84 - v179[1]) / (v180[1] - v179[1])
        end
    end

    return AccelShape[#AccelShape][2]
end

t1.SlideRotate = {
    Gain = 0.1,
    FullAt = 0.6,
    HighSpeedKeep = 0.35,
    FadeFromKph = 90,
    FadeToKph = 220,
    MinKph = 25
}
t1.RearLock = {
    CapacityFloor = 0.18,
    Margin = 1.1,
    BuildRate = 2.4
}
t1.RearBrakeSlideEBS = {
    Max = { 0.55, 0.75, 0.95, 1.15, 1.35 },
    Rate = { 0.8, 0.9, 1, 1.15, 1.3 },
    Skid = { 0.7, 0.85, 1, 1.15, 1.3 }
}
t1.SlideHold = {
    LeanFrom = 0.6981317007977318,
    LeanFull = 0.8726646259971648,
    SlowRecover = 0.12,
    SafeLean = 0.6981317007977318,
    Active = 0.3,
    Band = 0.05,
    PickFrom = 0.03490658503988659,
    PickFull = 0.10471975511965978,
    Grow = 0,
    InputBoost = 0.6,
    CreepDecay = 5,
    MinKph = 20,
    MaxCreep = 1.6
}
t1.GripReturn = {
    OffFrom = 0.05,
    OnFrom = 0.25,
    Recover = 2.4,
    SizeBoost = 1,
    SnapFrequency = 14,
    ReleaseRate = 6,
    SoftClose = 0.55,
    LeanFrom = 0.3490658503988659,
    LeanFull = 0.7853981633974483,
    LeanLow = 0.75,
    BiteFrac = 0.12,
    HighsideMinLean = 0.6108652381980153,
    SafeSlide = 0.45,
    HighsideSlide = 0.8,
    WobbleSeconds = 0.6,
    WobbleYaw = 0.08,
    MinKph = 20
}

function t1.IsKerb(p85) -- line: 758
    local v181 = p85 and p85.Instance

    if v181 == nil then
        return false
    end

    if v181:GetAttribute("Kerb") == true then
        return true
    end

    return string.find(string.lower(v181.Name), "kerb", 1, true) ~= nil
end

t1.KerbLean = {
    SafeDry = 0.9424777960769379,
    SafeWet = 0.8377580409572782,
    TimeEdge = 2,
    TimeFull = 1,
    WetTimeScale = 0.8,
    Recover = 2
}
t1.KerbEdge = {
    FullLean = 0.9948376736367679,
    Probe = 0.6,
    MinKph = 8
}

local v182
local Parent2 = script.Parent

local function kerbTrackPoints() -- line: 779
    -- upvalues: Config (copy), v182 (ref), Parent2 (copy)
    if v182 ~= nil then
        return v182 or nil
    end

    local function v183() -- line: 781
        -- upvalues: Config (copy), Parent2 (copy)
        local Tracks = Parent2 and Parent2:FindFirstChild("Tracks")
        local v184 = Tracks and Tracks:FindFirstChild(Config.Track)
        local Layout = v184 and v184:FindFirstChild("Layout")

        return Layout and require(Layout)
    end

    local ok, result = pcall(v183)

    v182 = ok and result and result.Points or false

    return v182 or nil
end

local function kerbOutward(p86, p87) -- line: 790
    -- upvalues: Config (copy), v182 (ref), Parent2 (copy)
    if v182 == nil then
        local function v185() -- line: 781
            -- upvalues: Config (copy), Parent2 (copy)
            local Tracks = Parent2 and Parent2:FindFirstChild("Tracks")
            local v186 = Tracks and Tracks:FindFirstChild(Config.Track)
            local Layout = v186 and v186:FindFirstChild("Layout")

            return Layout and require(Layout)
        end

        local ok, result = pcall(v185)

        v182 = ok and result and result.Points or false
    end

    local v187 = v182 or nil

    if not v187 or #v187 < 3 then
        return nil
    end

    local v188 = #v187
    local v189
    local n1 = 1e999

    local function test(p88) -- line: 793
        -- upvalues: p87 (copy), v187 (copy), v188 (copy), v189 (ref), n1 (ref)
        local v190 = (p88 - 1) % v188 + 1
        local Magnitude = (v187[v190] - p87).Magnitude

        if Magnitude < n1 then
            v189 = v190
            n1 = Magnitude
        end
    end

    if p86.kerbEdgeIdx then
        for i = p86.kerbEdgeIdx - 12, p86.kerbEdgeIdx + 12 do
            local v191 = (i - 1) % v188 + 1
            local Magnitude = (v187[v191] - p87).Magnitude

            if Magnitude < n1 then
                v189 = v191
                n1 = Magnitude
            end
        end
    end

    local v192 = v189

    if not v192 or n1 > 60 then
        v189 = nil
        n1 = 1e999

        for i = 1, v188, 3 do
            local v193 = (i - 1) % v188 + 1
            local Magnitude = (v187[v193] - p87).Magnitude

            if Magnitude < n1 then
                v189 = v193
                n1 = Magnitude
            end
        end

        local v194 = v189

        for i = v194 - 3, v194 + 3 do
            local v195 = (i - 1) % v188 + 1
            local Magnitude = (v187[v195] - p87).Magnitude

            if Magnitude < n1 then
                v189 = v195
                n1 = Magnitude
            end
        end
    end

    p86.kerbEdgeIdx = v189

    local v196 = v187[v189]
    local v197 = v187[v189 % v188 + 1]
    local v198 = v187[(v189 - 2) % v188 + 1]

    local function proj(p89, p90) -- line: 798
        -- upvalues: p87 (copy)
        local v199 = p90 - p89

        return p89 + v199 * math.clamp((p87 - p89):Dot(v199) / math.max(v199:Dot(v199), 1E-06), 0, 1)
    end

    local v203 = v197 - v196
    local v207 = v196 + v203 * math.clamp((p87 - v196):Dot(v203) / math.max(v203:Dot(v203), 1E-06), 0, 1)
    local v208 = v196 - v198
    local v212 = v198 + v208 * math.clamp((p87 - v198):Dot(v208) / math.max(v208:Dot(v208), 1E-06), 0, 1)

    if (v207 - p87).Magnitude < (v212 - p87).Magnitude and v207 then
        v212 = v207
    end

    local v215 = Vector3.new(p87.X - v212.X, 0, p87.Z - v212.Z)

    return v215.Magnitude > 0.05 and v215.Unit or nil
end

local function kerbGroundAt(p91) -- line: 804
    -- upvalues: t1 (copy), v24 (ref)
    if not (t1._roadParams and t1._roadRoot and t1._roadRoot.Parent) then
        if not (v24 and v24.Parent) then
            v24 = workspace:FindFirstChild("RaceCollision", true)
        end

        local v216 = v24

        t1._roadRoot = v216
        t1._roadParams = RaycastParams.new()
        t1._roadParams.FilterType = Enum.RaycastFilterType.Include
        t1._roadParams.FilterDescendantsInstances = v216 and {
            v216,
            workspace.Terrain
        } or { workspace.Terrain }
    end

    local v217 = workspace:Raycast(p91 + Vector3.new(0, 1.5, 0), Vector3.new(-0, -4, -0, -0), t1._roadParams)
    local v218 = if not v217 or not (v217.Normal.Y > 0.4) or v217.Instance:GetAttribute("Surface") == "Barrier" then nil else v217

    return v218
end

t1.KerbEdge.Kick = 0.4
t1.KerbEdge.RiskSeconds = 0.6
t1.KerbEdge.Recover = 1.2
t1.KerbEdge.SlideShare = 1.6
t1.KerbEdge.GasOpen = 0.15
t1.KerbEdge.WashTurnLoss = 0.5
t1.KerbEdge.WashWobble = 1.6

local function kerbEdgeTouch(p92, p93) -- line: 834
    -- upvalues: Config (copy), t1 (copy), kerbOutward (copy), kerbGroundAt (copy)
    local KerbEdge = t1.KerbEdge
    local root = p92.root
    local FullLean = KerbEdge.FullLean

    if Config.KerbEdgeLeanDryPre14 or Config.KerbEdgeLeanDry then
        FullLean = math.rad((if script.Parent:GetAttribute("Raining") == true then Config.KerbEdgeLeanWetPre14
            or Config.KerbEdgeLeanWet
            or Config.KerbEdgeLeanDryPre14
            or Config.KerbEdgeLeanDry
            or Config.KerbEdgeLeanDryPre14
            or Config.KerbEdgeLeanDry else Config.KerbEdgeLeanDryPre14 or Config.KerbEdgeLeanDry) - 0.5)
    end

    if root and p93.onGround and not ((p93.kph or 0) < KerbEdge.MinKph) and not (math.abs(p92.lean or 0) < FullLean) then
        local CFrame = root.CFrame

        for _, v222 in {
                {
                    Config.FrontAxle,
                    Config.FrontWheelRadius,
                    Config.FrontTyreHalfWidth
                },
                {
                    Config.RearAxle,
                    Config.RearWheelRadius,
                    Config.RearTyreHalfWidth
                }
            } do
            local v225 = math.min(v222[3] * t1.TyreCrownScale, v222[2])
            local v226 = CFrame:PointToWorldSpace(v222[1]) - CFrame.UpVector * (v222[2] - v225)
            local v227 = kerbGroundAt(v226)

            if v227 and t1.IsKerb(v227) then
                local v228 = kerbOutward(p92, v226)

                if v228 then
                    local v229 = kerbGroundAt(Vector3.new(v226.X, v227.Position.Y, v226.Z) + v228 * KerbEdge.Probe)

                    if not v229 or not t1.IsKerb(v229) then
                        return true
                    end
                end
            end
        end

        return false
    end

    return false
end

function t1.KerbCornerLoss(p94, p95, _, _, _, _, p100) -- line: 859
    -- upvalues: t1 (copy), kerbEdgeTouch (copy)
    p94.kerbLeanRisk = 0

    local KerbEdge = t1.KerbEdge
    local v231 = math.min(p100 or 0, 0.1)
    local v232 = kerbEdgeTouch(p94, p95)
    local v233 = p94.kerbEdgeRisk or 0
    local v234

    if v232 then
        local v235

        if p94.kerbEdgeOn then
            v235 = v233
        else
            v235 = math.max(v233, KerbEdge.Kick)
            p94.kerbSlideMode = (p95.throttle or 0) >= KerbEdge.GasOpen and (p95.brake or 0) < 0.1 and "Rear" or "Front"
        end

        v234 = v235 + v231 / KerbEdge.RiskSeconds
    else
        v234 = math.max(0, v233 - v231 * KerbEdge.Recover)
    end

    p94.kerbEdgeOn = v232
    p94.kerbEdgeHit = v232 or nil
    p94.kerbEdgeRisk = v234
    p94.kerbEdgeWash = math.clamp(v234, 0, 1)

    return v232 and v234 >= 1
end

t1.WheelieDrive = {
    FreeDeg = 5,
    FullDeg = 45,
    FullLoss = 0.4,
    MaxLoss = 0.55
}
t1.LooseLean = {
    UprightKph = 270,
    Delay = 0.15,
    UprightDelay = 0.3,
    WetLess = 5,
    WashSeconds = 1,
    WashFastRate = 2,
    WashOverDeg = 15,
    WashRecover = 1.6,
    WashTurnLoss = 0.45,
    WashSink = 0.3,
    WashWobble = 0.9,
    Points = {
        { 60, 30 },
        { 200, 10 },
        { 270, 0 }
    }
}
t1.LooseRainGrip = 0.8
t1.WetSlick = {
    TurnHold = 1,
    EdgeSeconds = 1.2,
    FastSeconds = 0.4,
    OverFull = 0.35,
    Recover = 1.5,
    MinKph = 20
}

function t1.WetSlickLoss(p101, p102, p103) -- line: 907
    -- upvalues: t1 (copy)
    local WetSlick = t1.WetSlick
    local v237 = math.min(p103, 0.1)
    local v238 = p101.wetSlickOver or 0
    local onGround

    if p101.slickWet == true then
        onGround = p102.onGround

        if onGround then
            onGround = (p102.kph or 0) > WetSlick.MinKph and v238 > 1
        end
    else
        onGround = false
    end

    if onGround then
        local v240 = math.clamp((v238 - 1) / WetSlick.OverFull, 0, 1)
        local v241 = 1 / WetSlick.EdgeSeconds + (1 / WetSlick.FastSeconds - 1 / WetSlick.EdgeSeconds) * v240

        p101.wetSlickRisk = (p101.wetSlickRisk or 0) + v237 * v241
    else
        p101.wetSlickRisk = math.max(0, (p101.wetSlickRisk or 0) - v237 * WetSlick.Recover)
    end

    p101.wetSlickWash = math.clamp(p101.wetSlickRisk, 0, 1)

    return onGround and p101.wetSlickRisk >= 1
end

function t1.LooseLeanLimit(p104, p105) -- line: 922
    -- upvalues: t1 (copy)
    local Points = t1.LooseLean.Points
    local v243

    if p104 <= Points[1][1] then
        v243 = Points[1][2]
    elseif Points[#Points][1] <= p104 then
        v243 = Points[#Points][2]
    else
        for i = 1, #Points - 1 do
            local v244 = Points[i]
            local v245 = Points[i + 1]

            if p104 <= v245[1] then
                v243 = v244[2] + (v245[2] - v244[2]) * (p104 - v244[1]) / (v245[1] - v244[1])
                break
            end

            v243 = nil
        end
    end

    return (math.rad((math.max(0, v243 - (p105 and t1.LooseLean.WetLess or 0)))))
end

function t1.LooseLeanLoss(p106, p107, p108, p109, p110) -- line: 933
    -- upvalues: t1 (copy)
    local LooseLean = t1.LooseLean
    local v248 = p109 and t1.SurfaceOf(p109)
    local v249 = p108 < 0.18 and (v248 == "Grass" or v248 == "Gravel" or v248 == "Sand")
    local v250 = p107.kph or 0

    math.abs(p106.lean or 0)

    local v252 = LooseLean.UprightKph <= v250
    local onGround = p107.onGround and v250 > 8 and v249 and v252
    local v253 = 1 + (LooseLean.WashFastRate - 1) * 0

    if onGround then
        p106.looseLeanRisk = (p106.looseLeanRisk or 0) + math.min(p110, 0.1) * v253
    else
        p106.looseLeanRisk = math.max(0, (p106.looseLeanRisk or 0) - math.min(p110, 0.1) * LooseLean.WashRecover)
    end

    p106.looseWash = math.clamp(p106.looseLeanRisk / LooseLean.WashSeconds, 0, 1)

    return onGround and p106.looseLeanRisk >= LooseLean.WashSeconds
end

t1.KerbDrag = {
    Kerb = {
        Rate = 0.0175,
        Cap = 4,
        Throttle = 0.97
    },
    Runoff = {
        Rate = 0.035,
        Cap = 8,
        Throttle = 0.94
    }
}

function t1.KerbResistance(p111, p112, p113, p114, p115) -- line: 959
    -- upvalues: t1 (copy)
    local v256 = if not p114 or not p115 then 0 else 1

    p111.kerbResistance = (p111.kerbResistance or 0) + (v256 - (p111.kerbResistance or 0)) * (1 - math.exp(-p113 * (if v256 == 1 then 12 else 8)))

    local Kerb = p111.onKerb and t1.KerbDrag.Kerb or t1.KerbDrag.Runoff

    return math.sign(p112) * math.min(math.abs(p112) * Kerb.Rate, Kerb.Cap) * p111.kerbResistance
end

function t1.BumpKind(p116, p117) -- line: 966
    -- upvalues: t1 (copy)
    local v262 = p116 and p116.Instance

    if t1.IsKerb(p116) then
        if t1.PrivateFeatures() then
            return 0
        end

        return 0.75
    end

    local v263 = v262 and t1.SurfaceOf(p116) or p117

    if v263 == "Gravel" then
        return 1
    end

    if v263 == "Grass" then
        return 0.65
    end

    return 0
end

function t1.RoughSurface(p118, p119, p120, p121, p122, p123, p124, p125) -- line: 974
    -- upvalues: t1 (copy)
    local v264 = p122 and (p120 == "Grass" or p120 == "Gravel")
    local v266 = math.clamp(p121 / 22, 0, 1)
    local v267, v268

    if v264 then
        local v269 = v266 * (if p120 == "Gravel" then 1 else 0.7)

        if v269 then
            v267 = v269
            v268 = true
        else
            v268 = false
        end
    else
        v268 = false
    end

    if not v268 then
        v267 = 0
    end

    p118.roughBlend = (p118.roughBlend or 0) + (v267 - (p118.roughBlend or 0)) * (1 - math.exp(-p119 * (if v264 then 5 else 12)))
    p123 = p123 or workspace:GetServerTimeNow()

    local rootPosition = p118.root.Position
    local v274 = p123 * 8 + rootPosition.X * 0.025 + rootPosition.Z * 0.021

    p118.roughPhase = v274
    p118.roughRoll = 0
    p118.roughSteer = p118.roughBlend * (math.sin(v274 * 0.63) * 0.65 + math.sin(v274 * 1.11) * 0.35)

    local v278 = p122 and v266 * t1.BumpKind(p124, p120) or 0
    local v279 = p122 and v266 * t1.BumpKind(p125, p120) or 0

    p118.frontBump = (p118.frontBump or 0) + (v278 - (p118.frontBump or 0)) * (1 - math.exp(-p119 * 12))
    p118.rearBump = (p118.rearBump or 0) + (v279 - (p118.rearBump or 0)) * (1 - math.exp(-p119 * 12))

    return 0, p118.roughSteer
end

function t1.RearSlideSpeedFactor(p126, _) -- line: 991
    -- upvalues: t1 (copy)
    local v287 = math.clamp(((p126 or 0) - 30) / 220, 0, 1)
    local SlideMidHigh = t1.SlideMidHigh

    return SlideMidHigh.Low - (SlideMidHigh.Low - SlideMidHigh.High) * v287 ^ SlideMidHigh.CurvePower
end

function t1.RearSlide(p128, p129, p130, p131) -- line: 1002
    -- upvalues: t1 (copy)
    local SnapFrequency = if p131 then 4.3 else (p128.gripGasOff or 0) >= 0.5 and t1.GripReturn.SnapFrequency or 8
    local v289 = p128.rearYaw or 0
    local v290 = p128.rearYawVelocity or 0
    local v291 = v289 - p129
    local v293 = math.exp(-SnapFrequency * p130)

    p128.rearYaw = p129 + (v291 + (v290 + SnapFrequency * v291) * p130) * v293
    p128.rearYawVelocity = (v290 - SnapFrequency * (v290 + SnapFrequency * v291) * p130) * v293

    return p128.rearYaw
end

function t1.Burnout(p132, p133, p134, _, p136, p137, p138, p139) -- line: 1012
    local v294 = p132.lean or 0
    local v295

    if math.abs(v294) < 0.2617993877991494 and p132.gear > 0 and p136 == "Asphalt" then
        if p137 then
            v295 = false

            if p138 < 0.12 and (p132.wheeliePitch or 0) < 0.045 and math.max(p133, p132.throttle or 0) > 0.25 then
                v295 = math.max(p134, p132.brake or 0) > 0.25
            end
        else
            v295 = p137
        end
    else
        v295 = false
    end

    local v298 = v295 and math.clamp((math.max(p133, p132.throttle or 0) - 0.25) / 0.75, 0, 1) * math.clamp((math.max(p134, p132.brake or 0) - 0.25) / 0.75, 0, 1) or 0

    p132.burnout = (p132.burnout or 0) + (v298 - (p132.burnout or 0)) * (1 - math.exp(-p139 * (if v295 then 5 else 16)))

    if not v295 then
        p132.burnout = 0
    end

    return p132.burnout
end

function t1.WheelieSpeedFactor(p140) -- line: 1020
    return math.clamp((p140 - 8) / 22, 0, 1) * math.clamp((270 - p140) / 120, 0, 1)
end

function t1.WheelieLiftDemand(p141, p142, p143, p144) -- line: 1023
    -- upvalues: Config (copy), t1 (copy)
    if p144 then
        return 0
    end

    local v311 = math.clamp((p142 - 55) / 75, 0, 1) * 0.55 + 1

    return math.max(0, p141 / Config.Gravity - 0.56) * t1.WheelieSpeedFactor(p142) * v311 * (1 - math.clamp(math.abs(p143) / 0.65, 0, 1))
end

t1.TCSSoften = 0.4
t1.TCSDrive = {
    LeanFrom = 0.13962634015954636,
    LeanFull = 0.5235987755982988,
    Dry = { -0.02, 0.12, 0.12, 0.04, -0.02 },
    Wet = { -0.12, -0.06, 0, 0.06, 0.1 },
    SlideCost = { 1.15, 0.4, 0.4, 0.8, 1 },
    SlideScale = { 1, 0.6, 0.55, 0.85, 1.2 }
}

function t1.TCSFeel(p145) -- line: 1051
    -- upvalues: Config (copy), t1 (copy)
    local v317 = math.clamp(math.round(p145 or Config.TCS), 1, 5)

    return (if v317 == 1 then 0 else v317 - 1) + t1.TCSSoften
end

function t1.TCSPick(p146, p147) -- line: 1056
    local v319 = math.clamp(p147, 0, #p146 - 1)
    local v320 = math.floor(v319)
    local v321 = v319 - v320
    local v322 = p146[v320 + 1]

    return v322 + (p146[math.min(v320 + 2, #p146)] - v322) * v321
end

function t1.TractionResponse(p148, p149, p150, p151) -- line: 1062
    -- upvalues: t1 (copy)
    local v325 = t1.TCSPick({ 4, 4, 0.65, 0.3, 0.12, 0.035 }, p151)
    local v326 = t1.TCSPick({ 0, 0, 0.45, 0.75, 0.93, 0.995 }, p151)
    local v329 = math.sqrt((math.max(0, (p150 * (1 + v325)) ^ 2 - p148 ^ 2)))
    local v330 = p149 > 0 and math.clamp(1 - v329 / p149, 0, 1) * v326 or 0
    local v332 = p149 * (1 - v330)

    return v330, (math.max(0, math.sqrt(p148 * p148 + v332 * v332) / math.max(p150, 1) - 1))
end

t1.LandEase = 10

function t1.Step(p152, p153, p154) -- line: 1072
    -- upvalues: Config (copy), BikeStats (copy), BikeSuspension (copy), BikeGearbox (copy), PitLimiter (copy), BikeCrashPhysics (copy), result (ref), t1 (copy), v22 (copy), cast (copy)
    local root

    if p152.root.Parent and (p152.root.Parent:GetAttribute("Crash") or "") ~= "" then
        if p154 then
            p152.force.Force = Vector3.new(0, 0, 0)
            p152.force.Enabled = false
            p152.align.Enabled = false
        end

        root = p152.root.AssemblyLinearVelocity

        return {
            onGround = false,
            surface = "Air",
            frontExcess = 0,
            oldSlip = 0,
            lateral = 0,
            throttle = 0,
            brake = 0,
            rpm = 1800,
            speed = root.Magnitude,
            kph = root.Magnitude * Config.StudMetres * 3.6,
            velocity = root
        }
    end

    root = p152.root:GetAttribute("LossStage")

    if root and root ~= "" then
        return BikeCrashPhysics.Step(p152, p153, p154)
    end

    local v335 = math.min(p153, 0.04)

    root = p152.root

    local rootPosition, AssemblyLinearVelocity = root.Position, root.AssemblyLinearVelocity
    local Magnitude = root.Parent and root.Parent:GetAttribute("LooseWash") or p152.looseWash or 0
    local v336 = p152.washVisual or 0
    local v337 = Magnitude - (p152.washVisual or 0)
    local v338 = -v335 * 10

    p152.washVisual = v336 + v337 * (1 - math.exp(v338))
    Magnitude = p152.kerbEdgeWash or 0

    local v339 = if (p152.kerbWashVisual or 0) < Magnitude then 25 else 6
    local v340 = p152.kerbWashVisual or 0
    local ebs = Magnitude - (p152.kerbWashVisual or 0)
    local LookVector = -v335 * v339

    p152.kerbWashVisual = v340 + ebs * (1 - math.exp(LookVector))

    if root:GetAttribute("NoReverse") then
        v339 = root.CFrame.LookVector.X
        v340 = root.CFrame.LookVector.Z
        Magnitude = Vector3.new(v339, 0, v340).Unit
        v339 = AssemblyLinearVelocity:Dot(Magnitude)

        if v339 < 0 then
            AssemblyLinearVelocity -= Magnitude * v339

            if p154 then
                root.AssemblyLinearVelocity = AssemblyLinearVelocity
            end
        end
    end

    Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude
    v339 = Magnitude * Config.StudMetres * 3.6
    v336 = t1.TCSFeel(p152.tcs)
    v340 = math.clamp(p152.aw or Config.AW, 1, 5)
    v337 = math.clamp(p152.ebs or Config.EBS, 1, 5)

    local v341 = p152.gear or 1

    p152.gear = math.clamp(v341, 0, 6)

    local v342 = p152.throttle > p152.smoothThrottle and t1.TCSPick({ 21, 20, 19, 18, 17, 16 }, v336) or 24
    local Turn

    v341, v338, LookVector, Turn = t1.Handling(v339)
    v341 *= 0.78
    v338 *= 0.72
    LookVector *= 0.76
    Turn *= 0.82

    local v343 = t1.BikeStats(p152)

    v341 *= v343.Handling
    v338 *= v343.Handling
    LookVector *= v343.Handling
    Turn *= v343.Handling

    local v344 = t1.LegendAbility(p152)

    t1.Slipstream.Step(p152, v335, v339, v344 == "Slipstream")

    local Weight = t1.Base
    local v345 = t1.BaseLeanBoost(v339)

    v341 *= 1 + Weight.RollFrequency * v345
    v338 *= 1 + Weight.RollAccel * v345
    LookVector *= 1 + Weight.RollRate * v345
    Turn *= 1 + Weight.SteerRate * v345

    if v344 == "SharpLean" then
        Weight = t1.Legend
        v345 = t1.SamuraiLeanBoost(v339)
        v341 *= 1 + Weight.SamuraiRollFrequency * v345
        v338 *= 1 + Weight.SamuraiRollAccel * v345
        LookVector *= 1 + Weight.SamuraiRollRate * v345
        Turn *= 1 + Weight.SamuraiSteerRate * v345
    end

    Weight = t1.Weight
    v345 = t1.RiderKg(p152)

    local v346 = (v345 + Weight.BikeKg) / Weight.ReferenceKg

    v341 /= math.sqrt(v346)
    v338 /= v346
    LookVector /= math.sqrt(v346)

    local v352 = (Weight.ShiftSeconds + (Weight.ShiftSecondsFast - Weight.ShiftSeconds) * math.clamp(v339 / 300, 0, 1)) * math.sqrt(v345 / Weight.RiderKg)
    local v350 = math.clamp(-(p152.steer or 0), -1, 1)
    local v347 = p152.bodyShift or 0
    local v351 = 2 / math.max(v352, 0.05) * v335
    local v349 = v350 - v347
    local v353 = -v351

    p152.bodyShift = v347 + math.clamp(v349, v353, v351)

    if p152.clutch then
    end

    if p152.clutch then
        p152.clutchBlend = 1
    else
        v350 = p152.clutchBlend or 0
        v351 = -v335 * 6
        p152.clutchBlend = v350 * math.exp(v351)
    end

    v352 = p152.smoothThrottle
    v347 = p152.throttle - p152.smoothThrottle
    p152.smoothThrottle = v352 + v347 * (1 - math.exp(-v335 * v342))
    v352 = BikeGearbox.RPM(p152.gear, v339, p152.smoothThrottle, p152.tractionSlip)
    v342 = if p152.gear == 0 then 1 else p152.clutchBlend
    v350 = BikeGearbox.IdleRPM

    local v354 = v350 + math.clamp(p152.smoothThrottle, 0, 1) * (BikeGearbox.RedlineRPM - BikeGearbox.IdleRPM - 300)

    p152.engineRpm = p152.engineRpm or v352

    local v355

    if v342 > 0.02 then
        v350 = p152.engineRpm
        v351 = v354 - p152.engineRpm
        v353 = -v335
        v355 = if p152.engineRpm < v354 then 6.5 else 2.4
        v349 = v353 * v355
        p152.engineRpm = v350 + v351 * (1 - math.exp(v349))

        if p152.engineRpm > BikeGearbox.RedlineRPM - 350 then
            p152.engineRpm -= 700
        end
    end

    v354 = p152.clutchHeld == true
    p152.clutchHeld = p152.clutch == true

    local v356, v357

    if v354 and not p152.clutch and p152.gear > 0 then
        v347 = BikeGearbox.WheelRPM(p152.gear, v339)
        v357 = BikeGearbox.IdleRPM
        v350 = math.max(v347, v357)
        v356 = (p152.engineRpm - v350) / 9000
        v357 = math.clamp(v356, 0, 1)
        v356 = if p152.gear <= 2 then 1 else 0.45
        p152.clutchLaunch = v357 * v356
    end

    v357 = (p152.clutchLaunch or 0) - v335 * 1.3
    p152.clutchLaunch = math.max(0, v357)

    if v342 <= 0.02 then
        p152.engineRpm = v352
    end

    p152.reportRpm = v352 + (p152.engineRpm - v352) * v342
    v352 = p152.smoothBrake
    v347 = p152.brake - p152.smoothBrake

    local BaseWeight = -v335 * 24

    p152.smoothBrake = v352 + v347 * (1 - math.exp(BaseWeight))
    v352 = p152.rearBrake or 0
    v350 = p152.smoothRearBrake or 0
    v356 = v352 - v350
    p152.smoothRearBrake = v350 + v356 * (1 - math.exp(-v335 * (if v350 < v352 then 4.5 else 20)))

    if p152.steer * p152.smoothSteer >= 0 then
        v357 = p152.steer
        v347 = math.abs(v357)
        v356 = p152.smoothSteer
        v350 = v347 < math.abs(v356)
    else
        v350 = false
    end

    v347 = Weight.ReleaseSteerRate
    v356 = Weight.ReleaseSteerRateFast - Weight.ReleaseSteerRate
    v353 = Weight.PickUpFromKph
    v355 = Weight.PickUpFullKph

    local v359 = (v339 - v353) / (v355 - v353)
    local v358 = math.clamp(v359, 0, 1)

    v352 = v347 + v356 * (v358 * v358 * (3 - 2 * v358))

    local v360, SpeedHeavyFromKph

    if v350 then
        BaseWeight = v352 - 1
        v355 = Weight.FromKph
        v358 = Weight.FullKph
        SpeedHeavyFromKph = (v339 - v355) / (v358 - v355)
        v359 = math.clamp(SpeedHeavyFromKph, 0, 1)
        v360 = 1 + BaseWeight * (v359 * v359 * (3 - 2 * v359)) or 1
    else
        v360 = 1
    end

    v357 = p152.smoothSteer
    BaseWeight = p152.steer - p152.smoothSteer
    v355 = -v335 * Turn * v360
    p152.smoothSteer = v357 + BaseWeight * (1 - math.exp(v355))
    v357 = root.CFrame.LookVector.X
    BaseWeight = root.CFrame.LookVector.Z
    v360 = Vector3.new(v357, 0, BaseWeight)

    if v360.Magnitude < 0.1 then
        v360 = Vector3.new(-1, 0, 0)
    end

    local v361, v362, LeanStartFade, v363, v364, v365, v366, v367

    if p154 then
        v360 = t1.LeanAuthority(v339, v344)
        v356 = -p152.smoothSteer
        BaseWeight = if p152.paddling then 0.12 else v360
        v357 = v356 * BaseWeight
        BaseWeight = Magnitude / 30
        v350 = v357 * math.clamp(BaseWeight, 0, 1)

        if (p152.washVisual or 0) > 0 then
            v356 = p152.lean

            if math.abs(v356) > 0.02 then
                v353 = p152.lean
                v356 = math.sign(v353) * t1.LooseLean.WashSink * p152.washVisual
                v349 = math.abs(v350)
                v355 = p152.lean
                v353 = math.abs(v355)
                v350 += v356 * math.max(v349, v353)
            end
        end

        if v350 * p152.lean >= 0 then
            v357 = math.abs(v350)
            BaseWeight = p152.lean
            v352 = math.abs(BaseWeight) < v357
        else
            v352 = false
        end

        Turn = t1.Turn
        v355 = p152.lean
        v356 = (math.abs(v355) / math.max(v360, 0.01) - Turn.EdgeFrom) / (1 - Turn.EdgeFrom)
        v357 = math.clamp(v356, 0, 1)
        v357 *= v357
        BaseWeight = (v339 - 200) / 120
        v356 = math.clamp(BaseWeight, 0, 1)
        v356 = (1 - Turn.EdgeResistance * v357) * (1 - (v344 == "SharpLean" and t1.Legend.SamuraiEdgeResistance or t1.Base.EdgeResistance) * v357 * v356)
        BaseWeight = Turn.BaseWeight
        v355 = Turn.SpeedHeavy
        SpeedHeavyFromKph = Turn.SpeedHeavyFromKph
        v366 = Turn.SpeedHeavyFullKph
        v361 = (v339 - SpeedHeavyFromKph) / (v366 - SpeedHeavyFromKph)
        v362 = math.clamp(v361, 0, 1)
        v360 = BaseWeight * (1 - v355 * (v362 * v362 * (3 - 2 * v362)))

        if p152.tipFromUpright ~= false then
            v360 *= Turn.TipInHeavy
            v356 *= 1 - Turn.TipInEdgeExtra * v357
        end

        if v352 then
            v349 = Turn.EdgeMin
            v353 = v360 * v356
            v365 = math.max(v349, v353)
        end

        if not v352 or not v365 then
            v365 = 1
        end

        BaseWeight = p152.lean
        v356 = math.abs(BaseWeight)

        local v368

        if v352 then
            p152.leanStartIdle = 0

            if not p152.leanStartAt then
                p152.leanStartAt = v356
                p152.leanStartRest = (p152.rollVelocity or 0) * math.sign(v350) < Turn.FlickRollRate
            end

            local v369

            if p152.tipFromUpright == false then
                v369 = 1
            else
                v349 = 1 - Turn.UprightTipWeight
                v359 = Turn.UprightTipFrom
                SpeedHeavyFromKph = Turn.UprightTipFade
                v362 = (v356 - v359) / (SpeedHeavyFromKph - v359)
                v366 = math.clamp(v362, 0, 1)
                v369 = 1 - v349 * (1 - v366 * v366 * (3 - 2 * v366))
            end

            if p152.leanStartAt and p152.leanStartRest then
                v349 = Turn.LeanStartWeight
                v355 = Turn.LeanStartWeightNearMax - Turn.LeanStartWeight
                v359 = p152.leanStartAt
                SpeedHeavyFromKph = Turn.LeanStartNearFrom
                v366 = Turn.LeanStartNearFull
                v361 = (v359 - SpeedHeavyFromKph) / (v366 - SpeedHeavyFromKph)
                v362 = math.clamp(v361, 0, 1)
                v359 = 1 - (v349 + v355 * (v362 * v362 * (3 - 2 * v362)))
                v362 = v356 - p152.leanStartAt
                v361 = Turn.LeanStartFull
                LeanStartFade = Turn.LeanStartFade

                local v371 = math.clamp((v362 - v361) / (LeanStartFade - v361), 0, 1)

                v355 = 1 - v359 * (1 - v371 * v371 * (3 - 2 * v371))
                v368 = math.min(v369, v355)
            else
                v368 = v369
            end

            v363 = v365 * v368
            v365 = p152.turnResist or 1

            if v365 < v363 then
                v353 = v363 - v365
                v359 = -v335 * Turn.ResistSmooth
                v363 = v365 + v353 * (1 - math.exp(v359))
            end

            v365 = p152.turnStart or 1

            if v365 < v368 then
                v353 = v368 - v365
                v359 = -v335 * Turn.ResistSmooth
                v368 = v365 + v353 * (1 - math.exp(v359))
            end
        else
            v363 = v365
            p152.leanStartIdle = (p152.leanStartIdle or 0) + v335

            if p152.leanStartIdle > Turn.LeanStartReset then
                p152.leanStartAt = nil
            end

            v368 = 1
        end

        p152.turnResist = v363
        p152.turnStart = v368
        v364 = math.abs(v350) > 0.02 and math.sign(v350) or 0

        if v364 == 0 then
            v365 = 1
        else
            v349 = (p152.bodyShift or 0) * v364
            v365 = math.clamp(v349, 0, 1)
        end

        v355 = Weight.UnloadedResponse + (1 - Weight.UnloadedResponse) * v365 - 1
        SpeedHeavyFromKph = Weight.FromKph
        v366 = Weight.FullKph
        v361 = (v339 - SpeedHeavyFromKph) / (v366 - SpeedHeavyFromKph)
        v362 = math.clamp(v361, 0, 1)
        v364 = 1 + v355 * (v362 * v362 * (3 - 2 * v362))
        v349 = math.abs(v350)

        if v349 < math.abs(p152.lean) - 0.01 and v350 * p152.lean >= 0 then
            v349 = Weight.PickUpResponse
            v355 = Weight.PickUpResponseFast - Weight.PickUpResponse
            SpeedHeavyFromKph = Weight.PickUpFromKph
            v366 = Weight.PickUpFullKph
            v361 = (v339 - SpeedHeavyFromKph) / (v366 - SpeedHeavyFromKph)
            v362 = math.clamp(v361, 0, 1)
            v355 = v349 + v355 * (v362 * v362 * (3 - 2 * v362)) - 1
            SpeedHeavyFromKph = Weight.FromKph
            v366 = Weight.FullKph
            v361 = (v339 - SpeedHeavyFromKph) / (v366 - SpeedHeavyFromKph)
            v362 = math.clamp(v361, 0, 1)
            v364 = 1 + v355 * (v362 * v362 * (3 - 2 * v362))
        end

        p152.rollVelocity = p152.rollVelocity or 0
        v349 = v338 * v364
        v353 = -v349

        if v352 then
            if v350 > 0 then
                v349 *= v368
            else
                v353 *= v368
            end
        end

        v359 = (v350 - p152.lean) * v341 * v341 * v363 * v364 - 2 * v341 * p152.rollVelocity

        local SamuraiEdgeResistance = math.clamp(v359, v353, v349)

        if v352 then
            v367 = LookVector * v363
        end

        if not v352 or not v367 then
            v367 = LookVector
        end

        v355 = v367 * math.sqrt(v364)
        v353 = p152.rollVelocity + SamuraiEdgeResistance * v335

        if not (v352 and v355 < math.abs(v353)) then
            SpeedHeavyFromKph = -v355
            p152.rollVelocity = math.clamp(v353, SpeedHeavyFromKph, v355)
        else
            v367 = math.abs(v353)
            v366 = v367 - v355
            LeanStartFade = -v335 * Turn.RollCapEase
            v359 = v367 - v366 * (1 - math.exp(LeanStartFade))
            SpeedHeavyFromKph = LookVector * math.sqrt(v364)
            v367 = math.min(v359, SpeedHeavyFromKph)
            p152.rollVelocity = math.sign(v353) * v367
        end

        v355 = p152.lean
        v359 = p152.lean + p152.rollVelocity * v335
        SpeedHeavyFromKph = -Config.MaxLean
        v366 = Config.MaxLean
        p152.lean = math.clamp(v359, SpeedHeavyFromKph, v366)
        v359 = p152.lean

        local v373 = math.abs(v359) < Turn.UprightLean
        local v374

        if v373 then
            v359 = p152.rollVelocity
            v374 = math.abs(v359) < Turn.FlickRollRate
        end

        if not v373 or not v374 then
            if v355 * p152.lean < 0 then
                v359 = p152.rollVelocity

                if math.abs(v359) >= Turn.FlickRollRate then
                    p152.tipFromUpright = false
                end
            end
        else
            p152.tipFromUpright = true
        end
    else
        v364 = -v360.X
        v365 = -v360.Z
        p152.yaw = math.atan2(v364, v365)
        v364 = root.CFrame.RightVector.Y
        v365 = root.CFrame.UpVector.Y
        p152.lean = math.atan2(v364, v365)
    end

    LookVector = CFrame.Angles(0, p152.yaw, 0).LookVector
    v363 = LookVector:Cross((Vector3.new(0, 1, 0)))
    v357 = cast(rootPosition + LookVector * Config.Wheelbase / 2)
    v351 = cast(rootPosition - LookVector * Config.Wheelbase / 2)
    v364 = v357 or v351
    v365, v349 = t1.Contact(p152)
    v353 = v364 ~= nil and math.min(v365, v349) < 0.55

    local v375 = v353 and t1.SurfaceOf(v364) or "Air"

    p152.surface = v375

    local function looseOf(p155) -- line: 1261
        -- upvalues: t1 (copy)
        local v376 = p155 and t1.SurfaceOf(p155)

        if v376 == "Grass" or v376 == "Gravel" then
            return true
        end

        return v376 == "Sand"
    end

    local v377 = false
    local v378 = false
    local v379 = false
    local v380 = false
    local v381 = false

    if v353 then
        v377 = true
    end

    local v382

    if v377 then
        if v357 then
            v378 = true
        else
            v382 = v357
            v379 = true
        end
    end

    v377 = false

    if v378 then
        v382 = t1.SurfaceOf(v357)
        v379 = true
    end

    v378 = false

    local v383

    if v379 then
        if v382 == "Grass" then
            v383 = true
            v377 = true
        else
            v378 = true
        end
    end

    v379 = false

    if v378 then
        if v382 == "Gravel" then
            v383 = true
            v377 = true
        else
            v379 = true
        end
    end

    v378 = false

    if v379 then
        if v382 == "Sand" then
            v380 = true
        else
            v378 = true
        end
    end

    v379 = false

    if v378 then
        v383 = false
        v377 = true
    end

    v378 = false

    if v380 then
        v383 = true
        v377 = true
    end

    v380 = false

    local v384

    if v377 then
        if v383 then
            v384 = v383
            v381 = true
        else
            v380 = true
        end
    end

    v377 = false

    local v385

    if v380 then
        if v351 then
            v377 = true
        else
            v385 = v351
            v378 = true
        end
    end

    v380 = false

    if v377 then
        v385 = t1.SurfaceOf(v351)
        v378 = true
    end

    v377 = false

    local v386

    if v378 then
        if v385 == "Grass" then
            v386 = true
            v380 = true
        else
            v377 = true
        end
    end

    v378 = false

    if v377 then
        if v385 == "Gravel" then
            v386 = true
            v380 = true
        else
            v378 = true
        end
    end

    v377 = false

    if v378 then
        if v385 == "Sand" then
            v379 = true
        else
            v377 = true
        end
    end

    if v377 then
        v386 = false
        v380 = true
    end

    if v379 then
        v386 = true
        v380 = true
    end

    if v380 then
        if v386 then
            v384 = v386
            v381 = true
        else
            v381 = false
        end
    end

    p152.anyLoose = not not v381 and v384

    if v353 then
        v367 = v365 < 0.18 and t1.IsKerb(v357)
        v383 = v349 < 0.18 and t1.IsKerb(v351)
    else
        v383 = v353
        v367 = v353
    end

    p152.onKerb = v367 or v383
    v382, v366 = t1.RoughSurface(p152, v335, v375, Magnitude, v353, nil, v357, v351)
    v383 = v353 and (v375 == "Grass" or v375 == "Gravel" or v375 == "Sand")
    p152.looseAsWet = v383
    v367 = Config.Grip * v343.Grip

    local v387, v388, smoothThrottle

    if v353 then
        local v389, v390

        if v357 and v365 < 0.55 then
            v362 = t1.RunoffGripOf(v357)

            if v362 then
                v389 = v362
                v390 = true
            else
                v390 = false
            end
        else
            v390 = false
        end

        if not v390 then
            v389 = nil
        end

        local v391 = false

        if v351 and v349 < 0.55 then
            v361 = t1.RunoffGripOf(v351)

            if v361 then
                smoothThrottle = v361
                v391 = true
            end
        end

        if not v391 then
            smoothThrottle = nil
        end

        local v392 = false

        if v389 and smoothThrottle then
            LeanStartFade = (v389 + smoothThrottle) / 2

            if LeanStartFade then
                v387 = LeanStartFade
                v392 = true
            end
        end

        if not v392 then
            v387 = v389 or smoothThrottle or 1
        end

        v367 *= v387
        p152.runoffGrip = v387
        v389 = not p152.onKerb
        v388 = v389 and (v365 < 0.18 and t1.RunoffGripOf(v357) < 1 or v349 < 0.18 and t1.RunoffGripOf(v351) < 1)
    else
        v388 = v353
    end

    p152.onRunoff = v388
    v388 = script.Parent:GetAttribute("Raining") == true
    smoothThrottle = v388 or v383
    p152.wet = smoothThrottle
    v387 = script.Parent:GetAttribute("TrackWetness")

    if typeof(v387) == "number" then
        if v383 then
            p152.wetAmount = 1
        else
            p152.wetAmount = math.clamp(v387, 0, 1)
        end

        v367 *= 1 - (1 - (Config.RainGrip or 0.72)) * p152.wetAmount

        if v383 then
            v367 *= 1 - (1 - t1.LooseRainGrip) * math.clamp(v387, 0, 1)
        end
    else
        p152.wetAmount = smoothThrottle and 1 or 0

        if smoothThrottle then
            v367 *= Config.RainGrip or 0.72
        end

        if v383 and v388 then
            v367 *= t1.LooseRainGrip
        end
    end

    v367 *= script.Parent:GetAttribute("WeatherGrip") or 1

    local v393

    if result then
        local GripOf

        GripOf, v393 = result.GripOf(p152.root and p152.root.Parent, smoothThrottle, p152.lean)
        p152.tyreF = GripOf
        p152.tyreR = v393
        p152.tyreWornR = result.RearWornOf(p152.root and p152.root.Parent, p152.lean)
    else
        p152.tyreF = 1
        p152.tyreR = 1
        p152.tyreWornR = 0
    end

    if v383 then
        v387 = p152.root and p152.root.Parent

        if not (result and result.LooseGripOf) then
            if not (v387 and v387:GetAttribute("TyreFront")) then
                local v394 = result and result.Compounds and result.Compounds[result.Default or "Medium"]
                local WetGrip = if v394 then v394.WetGrip else nil

                if not v394 or not WetGrip then
                    WetGrip = 0.8
                end

                p152.tyreF = WetGrip
                p152.tyreR = WetGrip
            end
        else
            local WetGrip

            WetGrip, v393 = result.LooseGripOf(v387, p152.lean)
            p152.tyreF = WetGrip
            p152.tyreR = v393
        end
    end

    v393 = p152.tyreF

    local v395, v396

    if result and result.Temp then
        local ColdTuck = result.Temp.ColdTuck

        if ColdTuck then
            v395 = ColdTuck
            v396 = true
        else
            v396 = false
        end
    else
        v396 = false
    end

    if not v396 then
        v395 = 0
    end

    local v397, v398

    if result and result.ColdOf then
        local ColdOf = result.ColdOf(p152.root and p152.root.Parent, "F", p152.lean)

        if ColdOf then
            v397 = ColdOf
            v398 = true
        else
            v398 = false
        end
    else
        v398 = false
    end

    if not v398 then
        v397 = 0
    end

    p152.tyreFBrake = v393 * (1 - v395 * v397)
    v383 = p152.root and p152.root.Parent

    local smoothBrake = result

    if result then
        smoothBrake = smoothThrottle and v353 and v375 == "Asphalt" and v383 and v383:GetAttribute("TyreFront")
    end

    local v399 = typeof(smoothBrake) == "string" and smoothBrake ~= "Wet"
    local v400 = if v353 and (v375 == "Grass" or v375 == "Gravel" or v375 == "Sand") then true else v399

    v393 = v367 * (p152.tyreF or 1)
    p152.slickWet = v400

    if v400 then
        local v401 = p152.lean

        v397 = math.tan(v401)
        p152.wetSlickOver = math.abs(v397) / math.max(v393, 0.05) or 0
    else
        p152.wetSlickOver = 0
    end

    v395 = p152.root and p152.root.Parent
    v397 = result and v395 and result.Compounds and result.Compounds[v395:GetAttribute("TyreRear") or ""]

    local smoothRearBrake = 1

    if v397 then
        smoothBrake = not smoothThrottle and v397.Grip or 1
        smoothRearBrake = if result.WearFactor then result.WearFactor(v395:GetAttribute("TyreRear"), v395:GetAttribute("TyreWearR")) else 1
    else
        smoothBrake = 1
    end

    v397 = math.clamp(math.abs(p152.lean or 0) / 0.7853981633974483, 0, 1)
    v395 = 0.25 + 0.75 * v397

    local WearDriveUpright = result and result.WearDriveUpright or 1
    local v403 = WearDriveUpright + (1 - WearDriveUpright) * v397

    p152.tyreRDrive = p152.tyreR / smoothBrake * ((smoothBrake - 1) * v395 + 1) / math.max(smoothRearBrake, 0.05) * (1 + (smoothRearBrake - 1) * v403)
    smoothThrottle = p152.smoothThrottle
    smoothBrake = p152.smoothBrake
    smoothRearBrake = p152.smoothRearBrake
    v395 = AssemblyLinearVelocity:Dot(LookVector)
    v397 = not root:GetAttribute("NoReverse")

    local v404, v405

    if v397 then
        v397 = not p152.exitHold

        if v397 then
            v397 = not p152.exitRequested

            if v397 then
                if v353 then
                    if (p152.brake or 0) > 0.5 and (p152.throttle or 0) < 0.05 then
                        if v339 < 4.5 then
                            v405 = true
                        elseif p152.paddling == true and v395 < 0 then
                            v404 = Config.PaddleSpeedKph or 5
                            v405 = v339 < v404 + 3
                        else
                            v405 = false
                        end
                    else
                        v405 = false
                    end
                else
                    v405 = v353
                end
            else
                v405 = v397
            end
        else
            v405 = v397
        end
    else
        v405 = v397
    end

    p152.paddleHold = v405 and (p152.paddleHold or 0) + v335 or 0
    p152.paddling = p152.paddleHold > 0.35

    if p152.paddling then
        smoothBrake = 0
    end

    v395 = t1.Burnout(p152, smoothThrottle * (1 - p152.clutchBlend), smoothBrake, smoothRearBrake, v375, v353, v349, v335)
    v405 = -p152.smoothSteer * v395 * 0.75 * math.clamp((18 - v339) / 12, 0, 1)

    local v402 = (p152.bodyShift or 0) * math.sign(p152.lean)

    v404 = math.clamp(v402, 0, 1)

    local v407 = p152.lean
    local Instance = math.abs(v407) / 0.3490658503988659
    local v406 = v404 * math.clamp(Instance, 0, 1)

    v404 = Weight.YawGain * (1 + Weight.HangOffYawBonus * v406) * (1 - t1.LooseLean.WashTurnLoss * (p152.washVisual or 0))

    if p152.kerbSlideMode == "Front" then
        v404 *= 1 - t1.KerbEdge.WashTurnLoss * (p152.kerbWashVisual or 0)
    end

    local SamuraiOversteerFromKph, SamuraiOversteerLeanFrom, FadeToKph, v408, v409, v410, v411

    if v344 == "SharpLean" then
        v402 = t1.Legend
        v407 = p152.lean

        local v412 = math.abs(v407)

        v408 = t1.LeanAuthority(v339, v344)
        Instance = v412 / math.max(v408, 0.01)

        if v353 then
            SamuraiOversteerFromKph = v402.SamuraiOversteerFromKph
            SamuraiOversteerLeanFrom = v402.SamuraiOversteerFullKph
            FadeToKph = (v339 - SamuraiOversteerFromKph) / (SamuraiOversteerLeanFrom - SamuraiOversteerFromKph)
            v409 = math.clamp(FadeToKph, 0, 1)
            v407 = v409 * v409 * (3 - 2 * v409)
            SamuraiOversteerLeanFrom = v402.SamuraiOversteerLeanFrom
            v409 = v402.SamuraiOversteerLeanFull
            v410 = (Instance - SamuraiOversteerLeanFrom) / (v409 - SamuraiOversteerLeanFrom)
            FadeToKph = math.clamp(v410, 0, 1)
            v411 = v407 * (FadeToKph * FadeToKph * (3 - 2 * FadeToKph))
        end

        if not v353 or not v411 then
            v411 = 0
        end

        v404 *= 1 + v402.SamuraiOversteerYaw * v411
    else
        v411 = 0
    end

    p152.oversteer = v411
    v406 = t1.SlideRotate
    v402 = p152.rearYaw or 0

    local v413

    if v353 and not p152.paddling and v402 * p152.lean > 0 then
        v411 = math.abs(v402) / (Config.RearYaw * v406.FullAt)
        Instance = math.clamp(v411, 0, 1)
        v408 = 1 - v406.HighSpeedKeep
        v409 = v406.FadeFromKph
        FadeToKph = v406.FadeToKph
        v413 = (v339 - v409) / (FadeToKph - v409)
        v410 = math.clamp(v413, 0, 1)
        v411 = 1 - v408 * (v410 * v410 * (3 - 2 * v410))
        v408 = v406.Gain * Instance * v411
        v409 = v406.MinKph
        FadeToKph = v406.MinKph + 20
        v413 = (v339 - v409) / (FadeToKph - v409)
        v410 = math.clamp(v413, 0, 1)
        p152.slideRotate = v408 * (v410 * v410 * (3 - 2 * v410))
        v404 *= 1 + p152.slideRotate
    else
        p152.slideRotate = 0
    end

    v408 = p152.lean
    v402 = math.tan(v408) * Config.Gravity / math.max(Magnitude, 20) * v404

    if v400 then
        Instance = v393 * t1.WetSlick.TurnHold * Config.Gravity / math.max(Magnitude, 20) * v404

        if Instance < math.abs(v402) then
            v402 = math.sign(v402) * Instance
        end
    end

    if Magnitude < 25 then
        v407 = p152.smoothSteer
        SamuraiOversteerFromKph = Magnitude / 25
        v402 -= v407 * math.clamp(SamuraiOversteerFromKph, 0, 1) * 0.17
    end

    if p152.paddling then
        v411 = p152.smoothSteer
        v408 = Magnitude / 1.2
        v402 = v411 * math.clamp(v408, 0, 1) * 0.45
    end

    local v414, v415

    if p152.paddling then
        v415 = true
    elseif p154 then
        v411 = Weight.YawBuildSeconds
        v408 = Weight.YawBuildSecondsFast - Weight.YawBuildSeconds
        FadeToKph = (v339 - 40) / 240
        v409 = math.clamp(FadeToKph, 0, 1)
        v414 = (v411 + v408 * (v409 * v409 * (3 - 2 * v409))) * math.sqrt(v346)

        if v344 == "SharpLean" then
            v414 *= t1.Legend.SamuraiYawBuild
        end

        v415 = false
    else
        v415 = true
    end

    if v415 then
        p152.yawRateBuilt = v402
    else
        v393 = p152.yawRateBuilt or v402

        if v393 ~= v393 then
            v393 = v402
        end

        v407 = v402 - v393
        SamuraiOversteerLeanFrom = -v335 / math.max(v414, 0.01)
        p152.yawRateBuilt = v393 + v407 * (1 - math.exp(SamuraiOversteerLeanFrom))
        v402 = p152.yawRateBuilt
    end

    v402 += v366 * 0.035 + v405

    if (p152.washVisual or 0) > 0 then
        SamuraiOversteerFromKph = os.clock() * 19
        v402 += math.sin(SamuraiOversteerFromKph) * t1.LooseLean.WashWobble * p152.washVisual * 0.12
    end

    if p152.kerbSlideMode == "Front" and (p152.kerbWashVisual or 0) > 0.01 then
        SamuraiOversteerFromKph = os.clock() * 23
        v402 += math.sin(SamuraiOversteerFromKph) * t1.KerbEdge.WashWobble * p152.kerbWashVisual * 0.12
    end

    if (p152.gripWobble or 0) > 0 and v353 then
        v408 = os.clock() * 16
        v402 += math.sin(v408) * t1.GripReturn.WobbleYaw * p152.gripWobble
    end

    if p154 and v353 then
        p152.yaw += v402 * v335
    end

    v408 = p152.brake

    if math.max(smoothBrake, smoothRearBrake, v408, p152.rearBrake or 0) > 0.045 then
        p152.rhd = false
    end

    v402 = smoothThrottle ^ (1 + (v336 - 1) * 0.08)
    v400 = p152.onKerb or p152.onRunoff
    v411 = 1 - p152.clutchBlend

    local v416, v417

    if p152.onKerb then
        v407 = t1.KerbDrag.Kerb.Throttle

        if v407 then
            v416 = v407
            v417 = true
        elseif p152.onRunoff then
            v407 = t1.KerbDrag.Runoff.Throttle

            if v407 then
                v416 = v407
                v417 = true
            else
                v417 = false
            end
        else
            v417 = false
        end
    elseif p152.onRunoff then
        v407 = t1.KerbDrag.Runoff.Throttle

        if v407 then
            v416 = v407
            v417 = true
        else
            v417 = false
        end
    else
        v417 = false
    end

    if not v417 then
        v416 = 1
    end

    v402 *= v411 * v416

    if Magnitude > 1 then
        v411 = workspace:Raycast(rootPosition + Vector3.new(0, 0.6, 0), AssemblyLinearVelocity.Unit * (Magnitude * v335 + Config.Wheelbase / 2 + 0.7), v22)

        if v411 and v411.Instance:GetAttribute("Surface") == "Barrier" then
            Instance = v411.Instance

            if p154 and Magnitude < t1.WallCrashSpeed() then
                v408 = AssemblyLinearVelocity.Y
                root.AssemblyLinearVelocity = Vector3.new(0, v408, 0)
            end

            v346 = true
        else
            v346 = false
            Instance = nil
        end
    else
        v346 = false
        Instance = nil
    end

    if v346 then
        v411 = nil
        smoothBrake = 1
        v402 = 0
    elseif t1.WallCrashSpeed() <= Magnitude then
        v411 = t1.WallContact(p152)
        Instance = v411 or Instance
    else
        v411 = nil
    end

    if not p152.clutch then
        BikeGearbox.Automatic(p152, v339, os.clock())
    end

    v416 = BikeGearbox.Ratio(p152.gear)
    v408 = v343.TopSpeedKph / Config.TopSpeedKph
    SamuraiOversteerFromKph = if p152.gear == 0 then 0 else BikeGearbox.Limits[p152.gear] * (p152.gear == 6 and v408 or 1) + (p152.gear == 6 and p152.slipTopKph or 0)
    SamuraiOversteerLeanFrom = (if p152.gear == 0 then 1 else SamuraiOversteerFromKph + 5.85) / (Config.StudMetres * 3.6)

    local v418 = PitLimiter.Contains(rootPosition)

    p152.inPit = v418
    v409 = PitLimiter.LimitKph / (Config.StudMetres * 3.6)

    if v418 and p152.gear > 0 then
        SamuraiOversteerLeanFrom = math.min(SamuraiOversteerLeanFrom, v409)
    end

    local v419 = t1.AccelShapeAt(v339)
    local v420, v421

    if p152.gear == 0 then
        v410 = 0
    else
        v420 = v402 * Config.EngineAcceleration * BikeGearbox.Drive(p152.gear, v339)
        v421 = (SamuraiOversteerLeanFrom - Magnitude) / 8
        v410 = v420 * math.clamp(v421, 0, 1) * v419
    end

    local v422

    if p152.gear == 6 and Config.TopGearTau then
        SamuraiOversteerLeanFrom = (BikeGearbox.Limits[6] * v408 + (p152.slipTopKph or 0)) / (Config.StudMetres * 3.6)
        v422 = (1E-04 * Magnitude * Magnitude + 0.025 * Magnitude) * (1 - (p152.slipDrag or 0)) + (SamuraiOversteerLeanFrom - Magnitude) / Config.TopGearTau * 1.8 * v419
        v421 = v402 * math.max(0, v422)
        v410 = math.min(v410, v421)
    end

    local v423 = BikeStats.AccelFadeFromKph

    v421 = BikeStats.AccelFadeToKph

    local WheelieDrive = math.clamp((v339 - v423) / (v421 - v423), 0, 1)

    v419 = 1 - WheelieDrive * WheelieDrive * (3 - 2 * WheelieDrive)
    v410 *= 1 + (v343.Accel - 1) * v419
    v408 = p152.wetAmount

    if not v408 then
        v408 = if p152.wet then 1 else 0
    end

    if v408 > 0 then
        v410 *= 1 - (1 - (Config.RainEngine or 0.82)) * v408
    end

    local v425

    if p152.paddling then
        v343 = (Config.PaddleSpeedKph or 5) / (Config.StudMetres * 3.6)
        v420 = p152.reverseDrive or 0
        v421 = 1 - (p152.reverseDrive or 0)
        v422 = -v335 * 3
        p152.reverseDrive = v420 + v421 * (1 - math.exp(v422))
        v425 = 4 * p152.reverseDrive
        v423 = (v343 - Magnitude) / 1.5
        v410 = v425 * math.clamp(v423, 0, 1)
    else
        p152.reverseDrive = 0
    end

    v410 *= BikeGearbox.DriveCut(p152, os.clock())

    if p152.gear > 0 and (p152.clutchLaunch or 0) > 0 then
        v410 *= 1 + p152.clutchLaunch * 0.6 * (1 - p152.clutchBlend)
    end

    v410 *= 1 - v395 * 0.8
    v425 = ({ 0, 0.28, 0.65, 0.93, 1 })[v340]
    v420 = math.clamp(p152.rhdBlend or 0, 0, 1)
    v423 = t1.WheelieLiftDemand(v410, v339, p152.lean, v418)

    local v424 = v423 * 0.28

    v421 = v425 * math.clamp(v424, 0, 0.26)
    v410 *= (1 - v421) * (v420 * 0.035 + 1)

    local Legend, v426, v427, v428, v429, v430, SlideHold

    if v410 > 0 then
        WheelieDrive = t1.WheelieDrive
        SlideHold = p152.wheeliePitch or 0
        v429 = WheelieDrive.FreeDeg
        v424 = math.max(0, SlideHold - math.rad(v429))
        v429 = WheelieDrive.FullDeg - WheelieDrive.FreeDeg

        local v431 = v424 / math.rad(v429) * WheelieDrive.FullLoss

        v430 = WheelieDrive.MaxLoss
        v422 = math.clamp(v431, 0, v430)

        if v344 == "WheelieBoost" and v353 then
            Legend = t1.Legend
            SlideHold = ((p152.wheeliePitch or 0) - Legend.EmperorWheelieFrom) / (Legend.EmperorWheelieFull - Legend.EmperorWheelieFrom)
            v426 = math.clamp(SlideHold, 0, 1)
            v427 = if (p152.wheeliePitch or 0) > Legend.EmperorWheelieFrom then v422 * (1 - Legend.EmperorLossKeep) else v422
            v428 = 1 + Legend.EmperorWheelieDrive * v426
        else
            v427 = v422
            v428 = 1
        end

        v410 *= (1 - v427) * v428
    end

    Legend = math.abs(math.tan(p152.lean) * Config.Gravity)
    v427 = math.clamp((110 - v339) / 90, 0, 1)
    v426 = if p152.gear <= 2 then 1 else 0.35
    v428 = v427 * v426
    v427 = v410 * (1.12 + 0.48 * v428) * (1 + (5 - v336) * 0.1)

    local v432, v433

    if v375 == "Asphalt" or p152.looseAsWet then
        SlideHold = v367 * p152.tyreF * Config.Gravity
        v430 = Legend * 1.08 * (result and result.Floor(p152.tyreF, "Front") or 1)
        v426 = math.max(SlideHold, v430)

        if v426 then
            v432 = v426
            v433 = true
        else
            v433 = false
        end
    else
        v433 = false
    end

    if not v433 then
        v432 = v367 * p152.tyreF * Config.Gravity
    end

    v429 = v367 * (p152.tyreRDrive or p152.tyreR) * Config.Gravity

    local v434 = math.sin(p152.lean)

    v430 = v429 * (0.96 - 0.22 * math.abs(v434))

    local v435, v436

    if v375 == "Asphalt" or p152.looseAsWet then
        v429 = Legend * 1.03 * (result and result.Floor(p152.tyreR, "Rear") or 1)

        if v429 then
            v435 = v429
            v436 = true
        else
            v436 = false
        end
    else
        v436 = false
    end

    if not v436 then
        v435 = 0
    end

    SlideHold = math.max(v430, v435)

    local v437, v438

    if v353 and smoothThrottle > 0.025 then
        v437 = Legend * Legend + v427 * v427
        v438 = math.sqrt(v437) / math.max(SlideHold, 1) - 1

        local _ = not not math.max(0, v438)
    end

    v435, v438 = t1.TractionResponse(Legend, v427, SlideHold, v336)
    v427 = t1.TCSDrive

    local v439 = t1.TCSFeel(Config.TCS or 4)
    local v440 = v410 * (1.12 + 0.48 * v428) * (1 + (5 - v439) * 0.1)
    local v441, v442, v443

    if v353 and smoothThrottle > 0.025 then
        v442 = Legend * Legend + v440 * v440
        v434 = math.sqrt(v442) / math.max(SlideHold, 1) - 1
        v437 = math.max(0, v434)

        if v437 then
            v441 = v437
            v443 = true
        else
            v443 = false
        end
    else
        v443 = false
    end

    if not v443 then
        v441 = 0
    end

    local v444 = t1.TractionResponse(Legend, v440, SlideHold, v439)
    local ExitSlide = v441 * t1.TCSPick({ 0.44, 0.34, 0.24, 0.15, 0.07, 0 }, v439)
    local v445 = 1 - v439

    v442 = 0.2 + math.clamp(v445, 0, 1) * 0.04
    v434 = math.clamp(ExitSlide, 0, v442)

    local LeanFull = p152.tcs or Config.TCS or 4

    ExitSlide = math.round(LeanFull)
    p152.tcsLevel = math.clamp(ExitSlide, 1, 5)

    local v446, wet

    if p152.wet then
        v439 = 1
    else
        ExitSlide = p152.lean
        v446 = math.abs(ExitSlide)
        ExitSlide = v427.LeanFrom
        LeanFull = v427.LeanFull
        wet = (v446 - ExitSlide) / (LeanFull - ExitSlide)
        v442 = math.clamp(wet, 0, 1)
        v439 = v442 * v442 * (3 - 2 * v442)
    end

    v446 = (p152.wet and v427.Wet or v427.Dry)[p152.tcsLevel] * math.clamp(v441, 0, 1) * v439
    p152.spinLoss = v434
    p152.tcsDriveLoss = 1 - (1 - v444) * (1 - v434) * (1 + v446)
    v410 *= 1 - p152.tcsDriveLoss

    local v447 = if v353 and smoothThrottle > 0.025 and v438 then v438 else 0

    if result and (p152.tyreWornR or 0) > 0 and v353 and (v375 == "Asphalt" or p152.looseAsWet) then
        ExitSlide = Legend / math.max(SlideHold, 1) - 1
        v441 = math.max(0, ExitSlide) * (result.LateralSlide or 1)
        v447 = math.max(v447, v441)
    end

    p152.driveThrottle = v402 * (1 - v421) * (1 - v435)
    SlideHold = t1.SlideHold
    v440 = p152.lean
    v439 = math.abs(v440)

    if (p152.slip or 0) > 0.05 then
        v440 = p152.slidePeakLean or 0
        p152.slidePeakLean = math.max(v440, v439)
    elseif (p152.slip or 0) < 0.02 then
        p152.slidePeakLean = v439
    end

    v447 = (p152.slidePeakLean or v439) - v439
    v440 = math.abs(p152.rearYaw or 0) / math.max(Config.RearYaw, 0.001)
    v434 = SlideHold.LeanFrom
    ExitSlide = SlideHold.LeanFull
    LeanFull = math.clamp((v439 - v434) / (ExitSlide - v434), 0, 1)
    v441 = LeanFull * LeanFull * (3 - 2 * LeanFull)
    v428 = v441 > 0
    ExitSlide = SlideHold.Active - SlideHold.Band
    LeanFull = SlideHold.Active + SlideHold.Band
    wet = (v440 - ExitSlide) / (LeanFull - ExitSlide)

    local Wet = math.clamp(wet, 0, 1)

    v444 = Wet * Wet * (3 - 2 * Wet)

    local v448, v449

    if v428 and v444 > 0 then
        ExitSlide = SlideHold.SlowRecover
        wet = SlideHold.PickFrom
        v449 = SlideHold.PickFull
        v445 = (v447 - wet) / (v449 - wet)
        v448 = math.clamp(v445, 0, 1)
        LeanFull = v448 * v448 * (3 - 2 * v448)
        v434 = math.max(ExitSlide, LeanFull)
        v438 = 1 - v444 * v441 * (1 - v434)
    else
        v438 = 1
    end

    v441 = t1.GripReturn

    local n2 = 0

    if t1.PrivateFeatures() then
        Wet = v441.OffFrom
        wet = v441.OnFrom
        v448 = (smoothThrottle - Wet) / (wet - Wet)
        v449 = math.clamp(v448, 0, 1)
        n2 = 1 - v449 * v449 * (3 - 2 * v449) or 0
    end

    p152.gripGasOff = n2
    ExitSlide = p152.gripThrottle or smoothThrottle

    local v450

    if ExitSlide <= smoothThrottle then
        v450 = smoothThrottle
    else
        wet = smoothThrottle - ExitSlide
        v445 = -v335 * v441.ReleaseRate
        v450 = ExitSlide + wet * (1 - math.exp(v445))
    end

    p152.gripThrottle = v450
    v448 = ExitSlide - v450
    Wet = math.max(0, v448) / math.max(v335, 0.001)

    if n2 < 0.5 then
        p152.gripCloseRate = 0
    else
        v449 = p152.gripCloseRate or 0
        p152.gripCloseRate = math.max(v449, Wet)
    end

    p152.driveRecover = v438 * (1 - n2) + n2 * v441.Recover * (1 + v441.SizeBoost * math.clamp(v440, 0, 1.5))

    if v353 then
        if SlideHold.MinKph < v339 then
            if v428 then
                v428 = v444 > 0 and v447 < SlideHold.PickFrom and n2 < 0.5
            end
        else
            v428 = false
        end
    else
        v428 = v353
    end

    LeanFull = p152.slideCreep or 0

    local InputBoost, RearSkid

    if v428 then
        v449 = SlideHold.MaxCreep
        RearSkid = v444 * SlideHold.Grow * v440
        InputBoost = SlideHold.InputBoost
        v448 = LeanFull + RearSkid * (1 + InputBoost * math.max(smoothThrottle or 0, smoothRearBrake or 0)) * v335
        p152.slideCreep = math.min(v449, v448)
    else
        v449 = -v335 * SlideHold.CreepDecay
        p152.slideCreep = LeanFull * math.exp(v449)
    end

    p152.slideHoldRecover = v438
    v447 = t1.RearLock
    v444 = v367 * (p152.tyreR or 1) * Config.Gravity
    ExitSlide = v447.CapacityFloor
    v441 = v444 * math.max(ExitSlide, 0.33 - 0.18 * smoothBrake)
    LeanFull = 1 - (Legend / math.max(v367 * Config.Gravity, 1)) ^ 2
    n2 = math.max(0.08, LeanFull)
    v440 = v441 * math.sqrt(n2)
    v441 = smoothRearBrake * Config.RearBrakeAcceleration * ({ 0.65, 0.82, 1, 1.18, 1.38 })[v337]

    local n3 = 0

    if v353 then
        ExitSlide = (v339 - 12) / 25
        n2 = math.clamp(ExitSlide, 0, 1)
        Wet = v441 / math.max(v440, 1) - v447.Margin
        n3 = n2 * math.max(0, Wet) or 0
    end

    ExitSlide = p152.rearBrakeSlip or 0
    p152.rearBrakeSlip = ExitSlide + (n3 - (p152.rearBrakeSlip or 0)) * (1 - math.exp(-v335 * ((p152.rearBrakeSlip or 0) < n3 and v447.BuildRate * (t1.RearBrakeSlideEBS.Rate[v337] or 1) or v438 * 10)))
    n3 = v353 and v375 == "Asphalt" and p152.gear > 0 and not v418
    n2 = math.max(smoothBrake, smoothRearBrake)

    if n3 then
        v447 = false

        if v340 <= 2 and smoothThrottle > 0.8 and n2 < 0.1 then
            ExitSlide = p152.lean

            if math.abs(ExitSlide) < 0.22 and v339 > 8 and v339 < 250 then
                v447 = p152.gear <= 4
            end
        end
    else
        v447 = n3
    end

    local v453 = if v447 then (p152.wheelieHold or 0) + v335 else nil

    if not v447 or not v453 then
        LeanFull = (p152.wheelieHold or 0) - v335 * 4
        v453 = math.max(0, LeanFull)
    end

    p152.wheelieHold = v453
    v447 = ({ 1.55, 0.95, 0.32, 0.08, 0.02 })[v340]
    p152.liftLoad = (p152.liftLoad or 0) + (v423 - (p152.liftLoad or 0)) * (1 - math.exp(-v335 * 4))
    ExitSlide = (p152.wheelieHold or 0) / ((v420 * 1.2 + 1) * 0.45)
    v453 = math.clamp(ExitSlide, 0, 1)
    Wet = p152.liftLoad * 0.72 * (1 - v425 * 0.98) * (1 - v435) * (1 - n2)

    if not (v340 <= 2) or not v453 then
        v453 = 1
    end

    v453 = Wet * v453 * smoothThrottle * (1 - v420 * 0.4)

    local v454, v455

    if v340 <= 2 and v339 < 110 and p152.gear <= 2 then
        Wet = p152.wheelieHold - 0.85 * (v420 * 0.8 + 1)
        ExitSlide = math.max(0, Wet)
        LeanFull = if v340 == 1 then 0.68 else 0.3
        v423 = ExitSlide * LeanFull

        if v423 then
            v454 = v423
            v455 = true
        else
            v455 = false
        end
    else
        v455 = false
    end

    if not v455 then
        v454 = 0
    end

    if smoothThrottle < 0.3 or (p152.throttle or 0) < 0.3 or v339 < 8 then
        p152.wheelieSpent = false
    end

    if p152.wheelieSpent then
        v454 = 0
        v453 = 0
        p152.wheelieHold = 0
    end

    LeanFull = p152.lean

    if math.abs(LeanFull) > 0.35 then
        v425 = true
    else
        LeanFull = p152.steer
        v425 = math.abs(LeanFull) > 0.55
    end

    LeanFull = math.clamp(root.CFrame.LookVector.Y, -1, 1)
    ExitSlide = math.asin(LeanFull)

    if v425 then
        wet = p152.wheeliePitch or 0
        v425 = math.max(wet, ExitSlide) <= Config.WheelieCornerCrashPitch
    end

    v442 = math.clamp(p152.manualWheelie or 0, 0, 1)
    Wet = math.clamp(p152.manualStoppie or 0, 0, 1)

    local v456 = n3

    if n3 then
        v456 = not v425

        if v456 then
            v449 = p152.lean
            v456 = math.abs(v449) < 0.35 and p152.throttle > 0.08 and n2 < 0.15 and Magnitude > 8
        end
    end

    local n4 = 0

    if v456 then
        v449 = (v453 + v454) * (1 - v420 * 0.35)
        v445 = v447 * (1 - v420 * 0.2)
        n4 = math.clamp(v449, 0, v445) or 0
    end

    v449 = t1.WheelieSpeedFactor(v339)

    if v456 and v442 > 0.05 then
        v454 = v442 * v449 * smoothThrottle * 1.0122909661567112 * (1 - v420 * 0.35) * ({ 1, 0.72, 0.35, 0.09, 0.02 })[v340]
        v447 = math.max(v447, v454)
        n4 = math.max(n4, v454)
    end

    v453 = p152.wheeliePitch or 0
    v340 = p152.wheelieVelocity or 0
    v449 = math.asin((math.clamp(root.CFrame.LookVector.Y, -1, 1)))
    v448 = not v456

    if not v448 then
        v448 = p152.throttle < 0.12 or n2 > 0.15 or n4 + 0.04 < v453
    end

    v456 = v453 > 0.02 or (BikeSuspension.ArmClearance or 0.32) < v365

    if v449 > 0.035 and v365 > 0.045 and v448 and v456 then
        p152.wheelieReturning = true
    end

    if v365 <= 0.045 or v449 <= 0 or not v353 then
        p152.wheelieReturning = false
    end

    if p152.wheelieReturning and (p152.wheeliePeak or 0) > 0.08 and smoothThrottle > 0.5 and v442 < 0.05 then
        p152.wheelieSpent = true
    end

    p152.pitchFallAcceleration = nil

    local v457, v458

    if p152.wheelieReturning then
        v445 = math.max(0, v449)
        v458 = root.AssemblyAngularVelocity:Dot(root.CFrame.RightVector)
        InputBoost = 2.9 * math.cos(v445) - 0.9 * math.sin(v445)
        p152.pitchFallAcceleration = -math.max(0.8, InputBoost) * Config.LiftGravityScale - v458 * 0.12 - n2 * 4
    else
        v457 = v340 + ((n4 - v453) * 17 - v340 * 7.5) * v335
        v458 = math.clamp(v457, -4.5, 1.05)
        v457 = v453 + v458 * v335
        v445 = math.clamp(v457, 0, v447)

        if v445 == 0 and v458 < 0 then
            v458 = 0
        end
    end

    p152.wheeliePitch = v445
    p152.wheelieVelocity = v458

    local v459, v460

    if v445 > 0.02 or p152.wheelieReturning then
        v457 = p152.wheeliePeak or 0
        v458 = math.max(v457, v445, v449)

        if v458 then
            v459 = v458
            v460 = true
        else
            v460 = false
        end
    else
        v460 = false
    end

    if not v460 then
        v459 = 0
    end

    p152.wheeliePeak = v459
    n4 = p152.slip

    local PickFrom = p152.lean

    v459 = math.clamp(math.abs(PickFrom) / 0.6108652381980153, 0, 1)
    ExitSlide = t1.ExitSlide
    v458 = math.abs(p152.lean)

    local v461 = math.sign(p152.lean)

    v340 = p152.cornerPeakLean or 0

    local v462 = p152.prevLeanAbs or v458

    p152.prevLeanAbs = v458
    v457 = v458 - v462 > ExitSlide.TipRate * v335

    local v463, v464

    if v458 < ExitSlide.ResetLean then
        v464 = false
    elseif not p152.cornerPeakSide or v461 == 0 or v461 == p152.cornerPeakSide then
        v463 = v340
        v464 = true
    else
        v464 = false
    end

    if not v464 then
        v463 = 0
    end

    if v457 or v463 < v458 then
        v463 = v458
        p152.cornerPeakSide = v461
    end

    p152.cornerPeakLean = v463

    if v458 < ExitSlide.UprightLean and ExitSlide.LockThrottle <= smoothThrottle then
        p152.slideLock = true
    elseif smoothThrottle < ExitSlide.UnlockThrottle then
        p152.slideLock = false
    end

    local v465, v466, v467

    if v353 and ExitSlide.MinPeak <= v463 then
        RearSkid = v463 - v458
        PickFrom = ExitSlide.PickFrom

        local PickFull = ExitSlide.PickFull

        InputBoost = (RearSkid - PickFrom) / (PickFull - PickFrom)
        v465 = math.clamp(InputBoost, 0, 1)
        v458 = v465 * v465 * (3 - 2 * v465)

        if v458 then
            v466 = v458
            v467 = true
        else
            v467 = false
        end
    else
        v467 = false
    end

    if not v467 then
        v466 = 0
    end

    v440 = p152.exitGate or 0

    local v468, v469

    if v457 then
        p152.exitGate = 0
    else
        v468 = v466 - v440
        v469 = -v335 * (v440 < v466 and ExitSlide.Rise or ExitSlide.Fall)
        p152.exitGate = v440 + v468 * (1 - math.exp(v469))
    end

    local exitGate = p152.slideLock and p152.exitGate or 1

    PickFrom = t1.RearSlideSpeedFactor(v339, v447) * (Config.SlideSensitivity or 1)
    v469 = (Config.RainSlide or 1.7) - 1

    local v470 = p152.wetAmount

    if not v470 then
        v470 = if p152.wet then 1 else 0
    end

    v457 = PickFrom * (1 + v469 * v470) * (1 + (result and result.SlideBoost or 0) * (p152.tyreWornR or 0))

    if v344 == "SlideMaster" then
        v457 *= 1 + t1.Legend.KuriMidSlide * t1.KuriMidSpeed(v339)
    end

    p152.slideGate = v459
    RearSkid = t1.TCSDrive.SlideScale[p152.tcsLevel or 4] or 1
    PickFrom = v447 * v459 * v457 * exitGate * RearSkid
    v465 = p152.tractionSlip or 0
    v469 = PickFrom - (p152.tractionSlip or 0)
    p152.tractionSlip = v465 + v469 * (1 - math.exp(-v335 * (if (p152.tractionSlip or 0) < PickFrom then 3.8 else (7.5 + (v336 - 1) * 2) * (p152.driveRecover or v438))))
    v465 = p152.tractionSlip

    local SlideBoost = p152.rearBrakeSlip

    p152.slip = math.max(v465, SlideBoost)

    local v474, v475

    if v353 and p152.gear > 0 then
        v469 = p152.lean
        v465 = math.abs(v469) / 0.7
        v468 = math.clamp(v465, 0, 1)
        SlideBoost = v339 / 8
        PickFrom = v468 * math.clamp(SlideBoost, 0, 1)

        if PickFrom then
            v474 = PickFrom
            v475 = true
        else
            v475 = false
        end
    else
        v475 = false
    end

    if not v475 then
        v474 = 0
    end

    SlideBoost = smoothThrottle - (p152.previousThrottle or smoothThrottle)
    v447 = math.max(0, SlideBoost) / math.max(v335, 0.001)
    p152.highsideClosingRate = math.max(0, (p152.previousThrottle or smoothThrottle) - smoothThrottle) / math.max(v335, 0.001)
    p152.previousThrottle = smoothThrottle
    v468 = math.clamp(math.abs(p152.lean) / 0.6981317007977318, 0, 1)

    local v476 = v474 * v468
    local v477 = v447 / 2

    v465 = v476 * (math.clamp(v477, 0, 1) * 0.85 + smoothThrottle ^ 3 * 0.45) * smoothThrottle * t1.TCSPick({ 1.4, 1, 0.6, 0.3, 0.12, 0.025 }, v336) * (1 - v435) * v459 * v457 * exitGate * RearSkid
    v469 = p152.exitSlip or 0

    local Rise = v465 - (p152.exitSlip or 0)

    v476 = -v335

    local v478

    if (p152.exitSlip or 0) < v465 then
        v478 = 12
    elseif v468 < 0.05 then
        v478 = 9
    else
        v477 = 2.8 + (v336 - 1) * 2
        v478 = math.max(1.4, v477) * (p152.driveRecover or v438)
    end

    local v472 = v476 * v478

    p152.exitSlip = v469 + Rise * (1 - math.exp(v472))

    if v468 < 0.05 then
        SlideBoost = p152.tractionSlip
        v470 = -v335 * 6
        p152.tractionSlip = SlideBoost * math.exp(v470)
    end

    v469 = p152.tractionSlip
    p152.slip = math.max(v469, p152.rearBrakeSlip, p152.exitSlip * 1.05)
    Rise = n4 - p152.slip
    p152.highsideSlipRecovery = math.max(0, Rise) / math.max(v335, 0.001)
    v465 = math.clamp(p152.slip, 0, 1) * Config.SlidePowerReduction * t1.TCSDrive.SlideCost[p152.tcsLevel or 4]

    if v344 == "SlideMaster" then
        local v479, v480

        if v353 and p152.gear > 0 and smoothThrottle > 0.3 then
            Rise = p152.rearYaw or 0
            v469 = math.abs(Rise) / (Config.RearYaw * 0.35)
            SlideBoost = math.clamp(v469, 0, 1)

            if SlideBoost then
                v479 = SlideBoost
                v480 = true
            else
                v480 = false
            end
        else
            v480 = false
        end

        if not v480 then
            v479 = 0
        end

        v465 *= 1 - t1.Legend.KuriSlidePowerKeep * v479
        RearSkid = 1 + t1.Legend.KuriSlideDrive * v479
    else
        RearSkid = 1
    end

    p152.slidePowerCut = v465
    v410 *= (1 - v465) * RearSkid
    p152.driveThrottle *= 1 - v465
    RearSkid = t1.RearBrakeSlideEBS.Max[v337] or 1
    v465 = p152.rearBrakeSlip * t1.RearSlideSpeedFactor(v339, p152.rearBrakeSlip) * 0.8
    v470 = p152.tractionSlip
    Rise = p152.exitSlip * 1.05
    SlideBoost = math.max(v470, Rise) * v468

    local v473 = -v465 / RearSkid

    exitGate = SlideBoost + RearSkid * (1 - math.exp(v473))

    local v471 = p152.lean

    v465 = math.sign(v471) * math.clamp(exitGate, 0, 1.4) * v474 * Config.RearYaw * (1 + (5 - v336) * 0.08) * 0.82

    if not (smoothRearBrake > 0.1 and p152.rearBrakeSlip > (p152.tractionSlip or 0)) then
        v465 *= v459
    end

    if (p152.slideCreep or 0) > 0 then
        Rise = p152.lean
        v465 += math.sign(Rise) * p152.slideCreep * Config.RearYaw
    end

    RearSkid = t1.RearSkid
    SlideBoost = math.clamp((p152.rearBrakeSlip or 0) / RearSkid.LockFull, 0, 1)
    v469 = (smoothBrake - RearSkid.FrontFrom) / (RearSkid.FrontFull - RearSkid.FrontFrom)
    InputBoost = math.clamp(v469, 0, 1)
    Rise = smoothThrottle / RearSkid.ThrottleOff
    v442 = InputBoost * (1 - math.clamp(Rise, 0, 1))

    local v481, v482

    if v353 and smoothRearBrake > 0.1 then
        SlideBoost *= v442
        Rise = RearSkid.FromKph
        v473 = RearSkid.FullKph
        v472 = (v339 - Rise) / (v473 - Rise)
        v471 = math.clamp(v472, 0, 1)
        v438 = SlideBoost * (v471 * v471 * (3 - 2 * v471))

        if v438 then
            v481 = v438
            v482 = true
        else
            v482 = false
        end
    else
        v482 = false
    end

    if not v482 then
        v481 = 0
    end

    v468 = v481 * (1 - v474)
    exitGate = p152.skidGrow or 0

    if v468 > 0.01 or exitGate > 0 then
        local rearSkidSide = p152.rearSkidSide

        if not p152.rearSkidActive then
            v469 = p152.lean

            if math.abs(v469) > 0.017453292519943295 then
                v469 = p152.lean
                rearSkidSide = math.sign(v469)
            else
                v469 = p152.steer or 0

                if math.abs(v469) > 0.1 then
                    v469 = p152.steer
                    rearSkidSide = -math.sign(v469)
                else
                    v469 = AssemblyLinearVelocity:Dot(v363)

                    if math.abs(v469) > 0.05 then
                        v469 = AssemblyLinearVelocity:Dot(v363)
                        rearSkidSide = math.sign(v469)
                    else
                        rearSkidSide = rearSkidSide or 1
                    end
                end
            end
        end

        rearSkidSide = rearSkidSide or 1
        p152.rearSkidSide = rearSkidSide
        p152.rearSkidActive = v481 > 0.01
        v447 = -(p152.steer or 0) * rearSkidSide

        if RearSkid.GrowFrom < v481 and v447 > 0.3 and v353 then
            exitGate += RearSkid.GrowRate * v447 * v335
        elseif v481 <= 0.01 then
            exitGate -= RearSkid.ReleaseRate * v335
        elseif v447 < -0.3 then
            exitGate -= RearSkid.CounterRate * v335
        else
            exitGate -= RearSkid.SettleRate * v335
        end

        SlideBoost = math.clamp(exitGate, 0, 1.5)
        p152.skidGrow = SlideBoost
        v465 += rearSkidSide * (v468 * RearSkid.Yaw * (t1.RearBrakeSlideEBS.Skid[v337] or 1) + SlideBoost) * Config.RearYaw
    else
        p152.rearSkidActive = false
    end

    p152.rearSkid = v468

    local KuriSlideCrashYaw

    if (p152.kerbWashVisual or 0) > 0.01 and v353 and p152.kerbSlideMode ~= "Front" then
        SlideBoost = Config.RearYaw * (script:GetAttribute("MaxSlideCrashYaw") or 1)
        KuriSlideCrashYaw = v344 == "SlideMaster" and t1.Legend.KuriSlideCrashYaw or 1
        v474 = SlideBoost * KuriSlideCrashYaw
        p152.kerbSlideYaw = p152.kerbWashVisual * t1.KerbEdge.SlideShare * v474
        v470 = p152.lean
        v465 += math.sign(v470) * p152.kerbSlideYaw
    else
        p152.kerbSlideYaw = 0
    end

    SlideBoost = t1.RearSlide
    v473 = smoothRearBrake > 0.1 and p152.rearBrakeSlip > (p152.tractionSlip or 0) or v468 > 0.05
    SlideBoost(p152, v465, v335, v473)
    v465 = t1.GripReturn
    v336 = v344 == "SlideMaster"
    SlideBoost = Config.RearYaw * (script:GetAttribute("MaxSlideCrashYaw") or 1) * (v336 and t1.Legend.KuriSlideCrashYaw or 1)

    local KuriSlideCrashYaw2 = p152.rearYaw or 0

    v336 = math.abs(KuriSlideCrashYaw2) / math.max(SlideBoost, 0.001)
    SlideBoost = v375 == "Grass" or v375 == "Gravel" or v375 == "Sand"

    if v468 > 0.05 or (p152.skidGrow or 0) > 0.05 then
        KuriSlideCrashYaw = true
    elseif smoothRearBrake > 0.1 then
        KuriSlideCrashYaw2 = p152.rearBrakeSlip or 0
        v473 = p152.tractionSlip or 0
        v471 = (p152.exitSlip or 0) * 1.05
        KuriSlideCrashYaw = math.max(v473, v471) < KuriSlideCrashYaw2
    else
        KuriSlideCrashYaw = false
    end

    if v353 then
        KuriSlideCrashYaw2 = not SlideBoost

        if KuriSlideCrashYaw2 then
            KuriSlideCrashYaw2 = not p152.paddling

            if KuriSlideCrashYaw2 then
                KuriSlideCrashYaw2 = v465.MinKph < v339 and not KuriSlideCrashYaw and (p152.kerbWashVisual or 0) < 0.05
            end
        end
    else
        KuriSlideCrashYaw2 = v353
    end

    KuriSlideCrashYaw = p152.gripGasOff or 0
    p152.gripSnapping = false

    local v484, v485, v486

    if KuriSlideCrashYaw2 then
        if KuriSlideCrashYaw < 0.5 then
            p152.gripRelease = v336
            p152.gripBite = false
            p152.gripRisk = 0
        else
            if (p152.gripRelease or 0) > 0.05 then
                p152.gripSnapping = not p152.gripBite
            else
                p152.gripSnapping = false
            end

            if not p152.gripBite and (p152.gripRelease or 0) > 0.05 and v336 <= (p152.gripRelease or 0) * (1 - v465.BiteFrac) then
                p152.gripBite = true
                v484 = v465.SoftClose
                v471 = 1 - v465.SoftClose
                v476 = (p152.gripCloseRate or 0) / (v465.ReleaseRate * 0.9)
                SlideBoost = v484 + v471 * math.clamp(v476, 0, 1)
                v486 = v465.LeanLow
                v472 = 1 - v465.LeanLow
                v478 = math.abs(p152.lean)

                local LeanFrom = v465.LeanFrom
                local LeanFull = v465.LeanFull

                v485 = (v478 - LeanFrom) / (LeanFull - LeanFrom)
                v477 = math.clamp(v485, 0, 1)
                v484 = v486 + v472 * (v477 * v477 * (3 - 2 * v477))
                v486 = (p152.gripRelease or 0) * SlideBoost * v484
                v472 = p152.lean

                if math.abs(v472) < v465.HighsideMinLean then
                    v476 = v465.HighsideSlide - 0.01
                    v486 = math.min(v486, v476)
                end

                p152.gripRisk = v486

                if v465.HighsideSlide <= v486 then
                    p152.gripHighside = true
                elseif v465.SafeSlide < v486 then
                    v471 = v486 - v465.SafeSlide
                    v476 = v465.HighsideSlide - v465.SafeSlide
                    v484 = v471 / math.max(v476, 0.001)
                    v472 = p152.gripWobble or 0
                    v476 = 0.35 + 0.65 * math.clamp(v484, 0, 1)
                    p152.gripWobble = math.max(v472, v476)
                end
            end
        end
    else
        p152.gripRelease = 0
        p152.gripBite = false
        p152.gripRisk = 0
    end

    p152.gripSlideSize = v336
    p152.gripWobble = math.max(0, (p152.gripWobble or 0) - v335 / v465.WobbleSeconds)
    KuriSlideCrashYaw = if p152.abs then 50 else 58
    v468 = smoothBrake * KuriSlideCrashYaw * t1.FrontBrake.EBSStrength[v337]
    v484 = 0.12 * smoothBrake
    v472 = p152.lean
    v471 = math.sin(v472)
    SlideBoost = v432 * (1 - v484 * math.abs(v471))
    v484 = Legend * Legend + v468 * v468
    KuriSlideCrashYaw = math.sqrt(v484) / math.max(SlideBoost, 1)
    v486 = v367 * (p152.tyreF or 1) * Config.Gravity * (t1.FrontBrake.EBSGripCap[v337] or 1) * (p152.abs ~= false and t1.FrontBrake.ABSLimit or 1)
    KuriSlideCrashYaw2 = math.min(v468, v486)

    if v344 == "StoppieBrake" and v353 then
        Legend = t1.Legend
        v484 = p152.stoppiePitch or 0
        v486 = -v449
        v470 = math.max(v484, v486)
        v484 = Legend.DoctorStoppieFrom
        v486 = Legend.DoctorStoppieFull
        v472 = (v470 - v484) / (v486 - v484)
        v471 = math.clamp(v472, 0, 1)
        v367 = v471 * v471 * (3 - 2 * v471)
        SlideBoost = KuriSlideCrashYaw2 * Legend.DoctorBrakeBonus * v367
    else
        SlideBoost = 0
    end

    p152.doctorBrake = SlideBoost
    v470 = root.CFrame:PointToWorldSpace(Config.FrontAxle)
    v484 = root.CFrame:PointToWorldSpace(Config.RearAxle)

    local v487 = p152.lastLandingFC and (p152.lastLandingFC - v365) / math.max(v335, 0.001) or 0
    local v488 = p152.lastLandingRC and (p152.lastLandingRC - v349) / math.max(v335, 0.001) or 0

    v472 = BikeSuspension.TrackLanding(p152, "front", v365, math.max(0, math.min(v487, 24), -root:GetVelocityAtPosition(v470).Y), v335)
    v476 = BikeSuspension.TrackLanding

    local v489 = math.min(v488, 24)
    local v490 = -root:GetVelocityAtPosition(v484).Y

    v476 = v476(p152, "rear", v349, math.max(0, v489, v490), v335)

    if not (v365 < 20) or not v365 then
        v365 = nil
    end

    p152.lastLandingFC = v365

    if not (v349 < 20) or not v349 then
        p152.lastLandingRC = nil
    else
        p152.lastLandingRC = v349
    end

    if v472 then
        p152.wheelieReturning = false
        p152.wheeliePitch = 0
        p152.wheelieVelocity = 0
    end

    if v476 then
        p152.stoppieReturning = false
        p152.stoppiePitch = 0
        p152.stoppieVelocity = 0
    end

    local v491, v492

    if p154 then
        if v472 or v476 then
            v488 = root.CFrame.RightVector
            v484 = root.AssemblyAngularVelocity
            root.AssemblyAngularVelocity = v484 - v488 * v484:Dot(v488)
            p152.pitchFallAcceleration = nil
        end
    else
        v470 = t1.PrivateFeatures() and v353
        v492 = t1.RoadFilter

        local v493 = if v470 then t1.RoadHit(root, Config.FrontAxle) else nil

        if not v470 or not v493 then
            v493 = nil
        end

        v492(p152, "front", v493, v335, v339)
        v492 = t1.RoadFilter

        if v470 then
            v491 = t1.RoadHit(root, Config.RearAxle)
        end

        if not v470 or not v491 then
            v491 = nil
        end

        v492(p152, "rear", v491, v335, v339)
    end

    v492 = BikeSuspension.Step(p152, v335, v410, KuriSlideCrashYaw2, v353, n3)

    local v494 = p152.stoppiePitch or 0

    v478 = p152.stoppieVelocity or 0

    local v495, v496

    if n3 then
        v477 = p152.lean

        if math.abs(v477) < 0.3 and v339 > 24 then
            v495 = if Wet > 0.05 then 0.28 else 0.4
            v496 = v495 < smoothBrake and p152.brake > 0.1
        else
            v496 = false
        end
    else
        v496 = n3
    end

    v495 = math.clamp((v339 - 22) / 32, 0, 1)
    v491 = math.max(0, -v449)

    if v491 > 0.035 and v349 > 0.045 and not v496 and (v494 > 0.02 or (BikeSuspension.ArmClearance or 0.32) < v349) then
        p152.stoppieReturning = true
    end

    if v349 <= 0.045 or v491 <= 0 or not v353 then
        p152.stoppieReturning = false
    end

    if p152.stoppieReturning then
        v478 = -root.AssemblyAngularVelocity:Dot(root.CFrame.RightVector)
        p152.pitchFallAcceleration = (2.8 * math.cos(v491) - 2.45 * math.sin(v491)) * 1.35 * Config.LiftGravityScale + v478 * 0.12
    else
        v491 = v494

        if v496 then
            local v497 = KuriSlideCrashYaw2 / Config.Gravity * v495 * (1.05 + Wet * 0.65) * t1.StoppieEBS[v337 or 3]

            if v344 == "StoppieBrake" then
                v489 = t1.Legend.DoctorBrakeStoppie * v495 * smoothBrake
                v497 = math.max(v497, v489)
            end

            v489 = v478 + ((v497 * (2.45 * math.cos(v494) + 2.8 * math.sin(v494)) - (2.8 * math.cos(v494) - 2.45 * math.sin(v494))) * 0.85 - v478 * 2.6) * v335
            v478 = math.clamp(v489, -0.8, 1.05)
        else
            v478 += (-(2.8 * math.cos(v494) - 2.45 * math.sin(v494)) * 1.35 * Config.LiftGravityScale - v478 * 1.2) * v335
            v478 = math.clamp(v478, -4.5, 1.55)
        end
    end

    v485 = v491 + v478 * v335
    v477 = math.clamp(v485, 0, 1.42)

    if v477 == 0 and v478 < 0 then
        v478 = 0
    end

    p152.stoppiePitch = v477
    p152.stoppieVelocity = v478

    if p152.legendRecoverUntil then
        if os.clock() < p152.legendRecoverUntil then
            v485 = -v335 * (Config.LegendRecoverRate or 6)

            local v498 = 1 - math.exp(v485)

            if p154 then
                p152.lean -= p152.lean * v498
                p152.rollVelocity = (p152.rollVelocity or 0) * (1 - v498)
                p152.smoothSteer *= 1 - v498
            end

            p152.rearYaw = (p152.rearYaw or 0) * (1 - v498)
            p152.rearYawVelocity = 0
            p152.tractionSlip = (p152.tractionSlip or 0) * (1 - v498)
            p152.exitSlip = (p152.exitSlip or 0) * (1 - v498)
            p152.rearBrakeSlip = (p152.rearBrakeSlip or 0) * (1 - v498)
            v485 = p152.tractionSlip
            v489 = p152.rearBrakeSlip
            v490 = p152.exitSlip * 1.05
            p152.slip = math.max(v485, v489, v490)
            p152.wheelieReturning = false
            p152.stoppieReturning = false
            p152.pitchFallAcceleration = nil
            p152.wheeliePitch = (p152.wheeliePitch or 0) * (1 - v498)
            p152.wheelieVelocity = 0
            v477 *= 1 - v498
            p152.stoppiePitch = v477
            p152.stoppieVelocity = 0
        else
            p152.legendRecoverUntil = nil
        end
    end

    if p154 then
        v496 = p152.wheelieReturning or p152.stoppieReturning
        p152.align.PrimaryAxisOnly = v496 == true

        if v496 and p152.pitchFallAcceleration then
            v478 = root.Size
            n3 = root.AssemblyMass * (v478.Y * v478.Y + v478.Z * v478.Z) / 12
            root:ApplyAngularImpulse(root.CFrame.RightVector * p152.pitchFallAcceleration * n3 * v335)
        end
    end

    local Wheelbase, v499, v500

    if v357 and v351 then
        v490 = v357.Position.Y - v351.Position.Y
        Wheelbase = Config.Wheelbase
        v489 = math.atan2(v490, Wheelbase)

        if v489 then
            v499 = v489
            v500 = true
        else
            v500 = false
        end
    else
        v500 = false
    end

    if not v500 then
        v499 = 0
    end

    v413 = v499 + v492 + (p152.wheeliePitch or 0) - v477

    local v501

    v501, v485 = BikeSuspension.Axles(p152)
    v365 = CFrame.Angles(0, p152.yaw, 0) * CFrame.Angles(v413, 0, p152.lean + v382)

    local v502

    if v353 and v425 and v445 < 0.02 and v477 < 0.02 and v357 and v351 then
        for _ = 1, 3 do
            v382 = v351.Position.Y + t1.SupportHeight(v365, v485, Config.RearWheelRadius, Config.RearTyreHalfWidth)
            v502 = (v357.Position.Y + t1.SupportHeight(v365, v501, Config.FrontWheelRadius, Config.FrontTyreHalfWidth) - v382) / Config.Wheelbase
            v413 += math.clamp(v502, -0.06, 0.06)
            v365 = CFrame.Angles(0, p152.yaw, 0) * CFrame.Angles(v413, 0, p152.lean)
        end
    end

    v492 = p152.wheelieReturning == true or p152.stoppieReturning == true

    local Y

    if p154 and p152.wasFalling and not v492 then
        Y = root.CFrame.LookVector.Y
        Wheelbase = math.clamp(Y, -1, 1)
        p152.landOffset = math.asin(Wheelbase) - v413
        LeanFull = root.CFrame.RightVector
        v453 = root.AssemblyAngularVelocity
        root.AssemblyAngularVelocity = v453 - LeanFull * v453:Dot(LeanFull)
    end

    p152.wasFalling = v492

    if v492 then
        p152.landOffset = nil
    end

    if p152.landOffset then
        v490 = p152.landOffset

        if math.abs(v490) < 5E-04 then
            p152.landOffset = nil
        else
            v365 = CFrame.Angles(0, p152.yaw, 0) * CFrame.Angles(p152.landOffset, 0, 0) * CFrame.Angles(0, -p152.yaw, 0) * v365
            v499 = p152.landOffset
            Wheelbase = -v335 * (t1.LandEase or 10)
            p152.landOffset = v499 * math.exp(Wheelbase)
        end
    end

    local v503, v504, v505

    if v353 then
        v499 = (v351 or v364).Position.Y + t1.SupportHeight(v365, v485, Config.RearWheelRadius, Config.RearTyreHalfWidth)
        v499 = (v357 or v364).Position.Y + t1.SupportHeight(v365, v501, Config.FrontWheelRadius, Config.FrontTyreHalfWidth)
        v499 = (v351 or v364).Position.Y + t1.SupportHeight(root.CFrame.Rotation, v485, Config.RearWheelRadius, Config.RearTyreHalfWidth)
        v504 = (v357 or v364).Position.Y + t1.SupportHeight(root.CFrame.Rotation, v501, Config.FrontWheelRadius, Config.FrontTyreHalfWidth)

        local v506 = math.max(v499, v504) + 0.018
        local v507

        if v357 and v351 then
            v507 = (v357.Position.Y - v351.Position.Y) / Config.Wheelbase * AssemblyLinearVelocity:Dot(LookVector)
            v504 = math.max(0, v507) or 0
        else
            v504 = 0
        end

        local v508, v509

        if v357 and v351 then
            Y = (v357.Position.Y - v351.Position.Y) / Config.Wheelbase * AssemblyLinearVelocity:Dot(LookVector)

            if Y then
                v508 = Y
                v509 = true
            else
                v509 = false
            end
        else
            v509 = false
        end

        if not v509 then
            v508 = nil
        end

        p152.roadVy = v508
        v508 = p152.supportHeight

        if v508 then
            v507 = p152.supportHeight + v335 * (12 + v504 * 1.3)
            v503 = math.min(v506, v507)
        end

        if v508 and v503 then
            v506 = v503
        end

        v503 = p152.supportHeight

        local v510

        if v503 then
            v508 = (v506 - p152.supportHeight) / math.max(v335, 0.001)
            v507 = 10 + v504 * 1.3
            v510 = math.clamp(v508, -16, v507)
        end

        if not v503 or not v510 then
            v510 = 0
        end

        v505 = if v472 or v476 or (p152.frontImpact or 0) > 0.002 or (p152.rearImpact or 0) > 0.002 then math.min(v510, 0) else v510
        p152.supportHeight = v506
        v504 = v506 - rootPosition.Y
        v502 = workspace.Gravity + Config.Gravity * 1.5
        v503 = v502 + (v504 > 0.05 and Config.Gravity * math.clamp(v504 * 8, 0, 12) or 0)
        v425 = math.clamp(workspace.Gravity + (v506 - rootPosition.Y) * 180 - (AssemblyLinearVelocity.Y - v505) * 25, 0, v503)
    else
        p152.supportHeight = nil
        v425 = 0
        p152.roadVy = nil
    end

    v485 = AssemblyLinearVelocity:Dot(LookVector)
    v499 = AssemblyLinearVelocity:Dot(v363)
    v472 = (1E-04 * v485 * math.abs(v485) + v485 * 0.025) * (1 - v420 * 0.035) * (1 - (p152.slipDrag or 0))

    local v513, v514

    if not v353 or v375 == "Grass" or v375 == "Gravel" then
        v514 = false
    else
        v502 = p152.lean
        v504 = (math.abs(v502) - 0.8726646259971648) / 0.08726646259971647
        v487 = v420 * math.clamp(v504, 0, 1)

        if v487 then
            v513 = v487
            v514 = true
        else
            v514 = false
        end
    end

    if not v514 then
        v513 = 0
    end

    p152.scrape = v513
    v472 += math.sign(v485) * math.min(math.abs(v485) * 0.22, 35) * v513
    v420 = (KuriSlideCrashYaw2 + v441 + SlideBoost) * math.sign(v485)

    if v395 > 0.05 and math.abs(v485) < 0.4 then
        v420 = math.max(0, v410) + v485 * 12
    end

    if math.abs(v485) < 0.4 and v402 == 0 and not p152.paddling then
        v420 = v485 * 10
    end

    local v515, v516

    if not (v402 < 0.05) or p152.paddling then
        v516 = false
    else
        SlideBoost = v485 * 0.028 * v337 * v416 / 2.7

        if SlideBoost then
            v515 = SlideBoost
            v516 = true
        else
            v516 = false
        end
    end

    if not v516 then
        v515 = 0
    end

    v515 *= 1 - p152.clutchBlend
    v468 = if p152.paddling then -1 else 1

    local v517 = v353 and v468 * v410 - v420 - v472 - v515 or -v472

    if Config.OfftrackDrag[v375] then
        v517 -= v485 * Config.OfftrackDrag[v375]
    end

    v517 -= t1.KerbResistance(p152, v485, v335, v400, v353)
    v489 = 10 - (p152.roughBlend or 0) * 2.5
    v502 = p152.slip
    v472 = v489 * (1 - math.clamp(v502, 0, 1) * 0.25)
    v504 = (v405 * Config.Wheelbase / 2 - v499) * v472 + v366 * Config.Gravity * 0.025
    v505 = -v432
    v489 = math.clamp(v504, v505, v432)

    if v346 then
        v517 = math.min(0, v517)
    end

    if v418 and v353 and v409 < v485 then
        v502 = (v485 - v409) * 2.2
        v505 = -math.clamp(v502, 2, 26)
        v517 = math.min(v517, v505)
    end

    if p154 then
        local force = p152.force

        v505 = root.AssemblyMass
        v502 = Vector3.new(0, 1, 0) * v425 + LookVector * v517

        local v518 = if v353 then v363 * v489 else nil

        if not v353 or not v518 then
            v518 = Vector3.new(0, 0, 0)
        end

        force.Force = v505 * (v502 + v518)
        p152.align.CFrame = v365
    end

    v499 = {
        pitLimiter = v418,
        speed = Magnitude,
        kph = v339,
        velocity = AssemblyLinearVelocity,
        onGround = v353,
        surface = v375,
        blocked = v346,
        impact = Instance,
        wallContact = v411,
        frontExcess = KuriSlideCrashYaw,
        oldSlip = n4,
        lateral = v499,
        throttle = smoothThrottle,
        driveThrottle = p152.driveThrottle,
        brake = smoothBrake,
        rearBrake = smoothRearBrake,
        rearBrakeSlip = p152.rearBrakeSlip,
        rearYaw = p152.rearYaw,
        wheeliePitch = p152.wheeliePitch,
        stoppiePitch = p152.stoppiePitch,
        burnout = v395,
        roughBlend = p152.roughBlend,
        roughPhase = p152.roughPhase,
        rhd = p152.rhd == true,
        frontCompression = p152.frontCompression,
        rearCompression = p152.rearCompression,
        tractionCut = v435,
        liftCut = v421,
        wheelieDrag = 0,
        acceleration = v517,
        scrape = v513,
        clutch = p152.clutchBlend
    }
    v499.rpm = math.max(p152.reportRpm or BikeGearbox.RPM(p152.gear, v339, v402, p152.tractionSlip), 1800 + v395 * 12000)

    return v499
end

return t1
