-- https://lua.expert

game:GetService("RunService")

local Config = require(script.Parent.Config)
local BikeStats = require(script.Parent.BikeStats)
local BikeSuspension = require(script.Parent.BikeSuspension)
local BikeGearbox = require(script.Parent.BikeGearbox)
local PitLimiter = require(script.Parent.PitLimiter)
local BikeCrashPhysics = require(script.Parent.BikeCrashPhysics)
local TyreCatalog = script.Parent:FindFirstChild("TyreCatalog")

local function v1() -- line: 10
    -- upvalues: TyreCatalog (copy)
    return TyreCatalog and require(TyreCatalog)
end

local ok, result = pcall(v1)

if not ok or not result then
    result = nil
end

local t1 = {}

t1.Slipstream = require(script.Parent:WaitForChild("LegendSlipstream"))

function t1.PrivateFeatures() -- line: 19
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
    LockFull = 0.6,
    Yaw = 0.45,
    FromKph = 15,
    FullKph = 40,
    GrowFrom = 0.15,
    GrowRate = 0.6,
    SettleRate = 1.2,
    CounterRate = 2.5,
    ReleaseRate = 3,
    AirPitch = 0.03,
    RearAlone = 0.6,
    HoldGrowRate = 0.12
}
t1.StoppieEBS = { 0.687, 0.769, 0.96, 0.938, 0.855 }

function t1.RiderKg(p1) -- line: 197
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

function t1.BikeStats(p2) -- line: 203
    -- upvalues: BikeStats (copy)
    local v6 = p2.root and p2.root.Parent

    return BikeStats.Physics(v6 and v6:GetAttribute("BikeName"))
end

function t1.LegendAbility(p3) -- line: 207
    local v7 = p3.root and p3.root.Parent

    return v7 and v7:GetAttribute("LegendAbility") or ""
end

local function ramp(p4, p5, p6) -- line: 211
    local v9 = math.clamp((p4 - p5) / (p6 - p5), 0, 1)

    return v9 * v9 * (3 - 2 * v9)
end

function t1.BaseLeanBoost(p7) -- line: 213
    -- upvalues: t1 (copy)
    local Base = t1.Base

    p7 = p7 or 0

    local BoostFromKph, BoostFullKph = Base.BoostFromKph, Base.BoostFullKph
    local v12 = math.clamp((p7 - BoostFromKph) / (BoostFullKph - BoostFromKph), 0, 1)

    return v12 * v12 * (3 - 2 * v12)
end

function t1.SamuraiLeanBoost(p8) -- line: 216
    -- upvalues: t1 (copy)
    local Legend = t1.Legend

    p8 = p8 or 0

    local SamuraiBoostFromKph, SamuraiBoostFullKph = Legend.SamuraiBoostFromKph, Legend.SamuraiBoostFullKph
    local v15 = math.clamp((p8 - SamuraiBoostFromKph) / (SamuraiBoostFullKph - SamuraiBoostFromKph), 0, 1)

    return v15 * v15 * (3 - 2 * v15)
end

function t1.KuriMidSpeed(p9) -- line: 220
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

local function v23() -- line: 229
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

function t1.SurfaceOf(p10) -- line: 232
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

function t1.RaceCollision() -- line: 247
    -- upvalues: v24 (ref)
    if not (v24 and v24.Parent) then
        v24 = workspace:FindFirstChild("RaceCollision", true)
    end

    return v24
end

local self = setmetatable({}, {
    __mode = "k"
})

function t1.RunoffGripOf(p11) -- line: 253
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

local function cast(p12) -- line: 271
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
    Hz = 2,
    HzFast = 2,
    FastFromKph = 60,
    FastFullKph = 180,
    Damping = 0.35,
    CompDamping = 0.45,
    ReboundDamping = 0.75,
    KneeSpeed = 1,
    BlowOff = 0.25,
    Up = 0.35,
    Down = 0.25
}
t1.LooseRide = {
    Enabled = true,
    Blend = 10,
    AliasFrames = 2.5,
    Gravel = {
        Sink = 0.1,
        Mid = 0.035,
        MidWave = 5,
        Long = 0.022,
        LongWave = 18,
        Fine = 0.03,
        FineWave = 1.2
    },
    Grass = {
        Sink = 0.03,
        Mid = 0.02,
        MidWave = 7,
        Long = 0.045,
        LongWave = 28,
        Fine = 0.006,
        FineWave = 2
    }
}

local function looseWave(p13, p14, p15, p16, p17, p18) -- line: 312
    local v44 = math.clamp((p15 / p17 - p18) / 1.5, 0, 1)

    return v44 > 0 and p14 * v44 * 3.6363636363636362 * math.noise(p13.X / p15, p13.Z / p15, p16) or 0
end

function t1.LooseHeight(p19, p20, p21, p22) -- line: 316
    -- upvalues: t1 (copy)
    p20 = p20 or 0
    p21 = p21 or 0

    if p20 <= 0.001 and p21 <= 0.001 then
        return 0, 0
    end

    local LooseRide = t1.LooseRide
    local v48 = math.max(p22 or 0, 0.001) / 60
    local AliasFrames = LooseRide.AliasFrames
    local v49, v50

    if p20 > 0.001 then
        local Gravel = LooseRide.Gravel
        local v51 = -Gravel.Sink
        local Mid, MidWave = Gravel.Mid, Gravel.MidWave
        local v53 = math.clamp((MidWave / v48 - AliasFrames) / 1.5, 0, 1)
        local v54 = v51 + (v53 > 0 and Mid * v53 * 3.6363636363636362 * math.noise(p19.X / MidWave, p19.Z / MidWave, 0.31) or 0)
        local Long, LongWave = Gravel.Long, Gravel.LongWave
        local v56 = math.clamp((LongWave / v48 - AliasFrames) / 1.5, 0, 1)

        v49 = 0 + p20 * (v54 + (v56 > 0 and Long * v56 * 3.6363636363636362 * math.noise(p19.X / LongWave, p19.Z / LongWave, 0.73) or 0))
        v50 = 0 + p20 * Gravel.Fine * 3.6363636363636362 * math.noise(p19.X / Gravel.FineWave, p19.Z / Gravel.FineWave, 0.52)
    else
        v49 = 0
        v50 = 0
    end

    local v57, v58

    if not (p21 > 0.001) then
        v58 = v50
        v57 = v49

        return v57, v58
    end

    local Grass = LooseRide.Grass
    local v59 = -Grass.Sink
    local Mid, MidWave = Grass.Mid, Grass.MidWave
    local v61 = math.clamp((MidWave / v48 - AliasFrames) / 1.5, 0, 1)
    local v62 = v59 + (v61 > 0 and Mid * v61 * 3.6363636363636362 * math.noise(p19.X / MidWave, p19.Z / MidWave, 0.57) or 0)
    local Long, LongWave = Grass.Long, Grass.LongWave
    local v64 = math.clamp((LongWave / v48 - AliasFrames) / 1.5, 0, 1)

    return v49 + p21 * (v62 + (v64 > 0 and Long * v64 * 3.6363636363636362 * math.noise(p19.X / LongWave, p19.Z / LongWave, 0.99) or 0)), v50 + p21 * Grass.Fine * 3.6363636363636362 * math.noise(p19.X / Grass.FineWave, p19.Z / Grass.FineWave, 0.78)
end

local function looseWheel(p23, p24, p25, p26, p27, p28, p29, p30) -- line: 332
    -- upvalues: t1 (copy)
    local v65, v66

    if p27 and p25 then
        local v67 = t1.SurfaceOf(p25)

        if v67 then
            v65 = v67
            v66 = true
        else
            v66 = false
        end
    else
        v66 = false
    end

    if not v66 then
        v65 = nil
    end

    local v68 = p23[p24 .. "LooseGravel"] or 0
    local v69 = v68 + ((if v65 == "Gravel" or v65 == "Sand" then 1 else 0) - v68) * p30
    local v70 = p23[p24 .. "LooseGrass"] or 0
    local v71 = v70 + ((if v65 == "Grass" then 1 else 0) - v70) * p30
    local v72 = p24 .. "LooseGravel"
    local v73 = p24 .. "LooseGrass"

    p23[v72] = v69
    p23[v73] = v71

    if v69 <= 0.001 and v71 <= 0.001 and math.abs(p23[p24 .. "LooseRoadE"] or 0) < 1E-04 and math.abs(p23[p24 .. "LooseRoadEV"] or 0) < 0.001 then
        p23[p24 .. "LooseComp"] = 0
        p23[p24 .. "LooseRoadG"] = 0

        return
    end

    local v76 = t1.LooseHeight(p23.root.CFrame:PointToWorldSpace(p26), v69, v71, p29)

    p23[p24 .. "LooseComp"] = t1.SuspTravel(p23, p24 .. "Loose", v76, p28, p29) - v76
end

function t1.RoadHit(p31, p32) -- line: 343
    -- upvalues: t1 (copy), v24 (ref)
    if not (t1._roadRoot and t1._roadRoot.Parent) then
        if v24 then
            if not v24.Parent then
                v24 = workspace:FindFirstChild("RaceCollision", true)
            end
        else
            v24 = workspace:FindFirstChild("RaceCollision", true)
        end

        local v79 = v24

        t1._roadRoot = v79
        t1._roadParams = RaycastParams.new()
        t1._roadParams.FilterType = Enum.RaycastFilterType.Include
        t1._roadParams.FilterDescendantsInstances = v79 and {
            v79,
            workspace.Terrain
        } or { workspace.Terrain }
    end

    local v80 = p31.CFrame:PointToWorldSpace(p32)
    local v81 = workspace:Raycast(v80 + Vector3.new(0, 3, 0), Vector3.new(-0, -12, -0, -0), t1._roadParams)
    local v82 = if not v81 or not (v81.Normal.Y > 0.55) or v81.Instance:GetAttribute("Surface") == "Barrier" then nil else v81

    return v82
end

function t1.RoadFilter(p33, p34, p35, p36, p37) -- line: 356
    -- upvalues: t1 (copy)
    local Y, v84

    if p35 then
        local v85 = t1.SurfaceOf(p35)

        if v85 == "Grass" or v85 == "Gravel" or v85 == "Sand" then
            v84 = false
        else
            local Y2 = p35.Position.Y

            if Y2 then
                Y = Y2
                v84 = true
            else
                v84 = false
            end
        end
    else
        v84 = false
    end

    if not v84 then
        Y = nil
    end

    local v86 = t1.SuspTravel(p33, p34, Y, p36, p37)

    p33[p34 .. "RoadComp"] = v86

    return v86
end

function t1.SuspTravel(p38, p39, p40, p41, p42) -- line: 364
    -- upvalues: t1 (copy)
    local RoadSusp = t1.RoadSusp
    local Hz = RoadSusp.Hz
    local v87 = RoadSusp.HzFast - RoadSusp.Hz

    p42 = p42 or 0

    local FastFromKph, FastFullKph = RoadSusp.FastFromKph, RoadSusp.FastFullKph
    local v90 = math.clamp((p42 - FastFromKph) / (FastFullKph - FastFromKph), 0, 1)
    local v91 = Hz + v87 * (v90 * v90 * (3 - 2 * v90))
    local v92 = p38[p39 .. "RoadG"]
    local v93 = p38[p39 .. "RoadV"]
    local v94 = p38[p39 .. "RoadE"] or 0
    local v95 = p38[p39 .. "RoadEV"] or 0
    local v96 = math.max(p41, 0.001)
    local v97 = not not (p40 and v92 and math.abs(p40 - v92) < 1.5)
    local v99, v100

    if v97 then
        local v101 = (p40 - v92) / v96
        local v102 = v93 and math.clamp((v101 - v93) / v96, -4000, 4000) or 0
        local v104 = v91 * 2 * 3.141592653589793
        local v105 = 2 * RoadSusp.Damping * v104 * v95

        if RoadSusp.CompDamping then
            local v106 = math.abs(v95)

            if RoadSusp.KneeSpeed < v106 then
                v106 = RoadSusp.KneeSpeed + (v106 - RoadSusp.KneeSpeed) * RoadSusp.BlowOff
            end

            v105 = 2 * (v95 < 0 and RoadSusp.CompDamping or RoadSusp.ReboundDamping) * v104 * v106 * math.sign(v95)
        end

        v99 = v95 + (-v104 * v104 * v94 - v105 - v102) * v96
        v100 = v94 + v99 * v96

        if v100 < -RoadSusp.Up then
            v100 = -RoadSusp.Up
            v99 = math.max(v99, 0)
        elseif RoadSusp.Down < v100 then
            v100 = RoadSusp.Down
            v99 = math.min(v99, 0)
        end

        p38[p39 .. "RoadV"] = v101
    else
        v100 = v94 * math.exp(-v96 * 8)
        v99 = 0
        p38[p39 .. "RoadV"] = nil
    end

    p38[p39 .. "RoadG"] = p40
    p38[p39 .. "RoadE"] = v100
    p38[p39 .. "RoadEV"] = v99

    return -v100
end

t1.WallBox = {
    Size = Vector3.new(3.4, 4.7, 9.4),
    Offset = Vector3.new(0, 1.13, 0.5)
}

local v108 = OverlapParams.new()

v108.FilterType = Enum.RaycastFilterType.Include

local function v109() -- line: 390
    -- upvalues: v108 (copy)
    v108.CollisionGroup = "RaceBike"
end

pcall(v109)

local v110

function t1.WallCrashSpeed() -- line: 392
    -- upvalues: Config (copy), t1 (copy)
    return (math.min(Config.ImpactSpeed, t1.WallCrashKph / (Config.StudMetres * 3.6)))
end

function t1.WallContact(p43) -- line: 393
    -- upvalues: Config (copy), t1 (copy), v24 (ref), v108 (copy), v110 (ref)
    local root = p43.root

    if not (v110 and v110.Parent) then
        if not (v24 and v24.Parent) then
            v24 = workspace:FindFirstChild("RaceCollision", true)
        end

        v110 = v24

        if not v110 then
            return nil
        end

        v108.FilterDescendantsInstances = { v110 }
    end

    local v112 = Config.Wheelbase / 6.2017
    local v113 = root.CFrame * CFrame.new(t1.WallBox.Offset * v112)

    for _, v114 in workspace:GetPartBoundsInBox(v113, t1.WallBox.Size * v112, v108) do
        if v114:GetAttribute("Surface") == "Barrier" then
            return v114
        end
    end

    return nil
end

t1.TyreCrownScale = 1.1

function t1.SupportHeight(p44, p45, p46, p47) -- line: 412
    -- upvalues: t1 (copy)
    local v115 = p44:VectorToWorldSpace(p45)
    local v117 = math.min(p47 * t1.TyreCrownScale, p46)

    return math.sqrt(p44.UpVector.Y ^ 2 + p44.LookVector.Y ^ 2) * (p46 - v117) + v117 - v115.Y
end

function t1.ResolveContact(p48) -- line: 420
    -- upvalues: Config (copy), BikeSuspension (copy), t1 (copy), cast (copy)
    local root = p48.root

    if not root.Anchored and (root:GetAttribute("LossStage") or "") == "" then
        local v119, v120 = BikeSuspension.Axles(p48)
        local v121 = cast(root.CFrame:PointToWorldSpace(v119))
        local v122 = cast(root.CFrame:PointToWorldSpace(v120))

        if not (v121 or v122) then
            return
        end

        local v123, v124

        if t1.PrivateFeatures() then
            local elapsed = os.clock()
            local v126 = math.clamp(elapsed - (p48.roadClock or elapsed - 0.016666666666666666), 0.004166666666666667, 0.05)

            p48.roadClock = elapsed

            local v127 = root.AssemblyLinearVelocity.Magnitude * Config.StudMetres * 3.6

            for _, v128 in {
                    { "front", v121, -0.28, 0.4 },
                    { "rear", v122, -0.18, 0.48 }
                } do
                local v129 = v128[1]
                local v130 = p48[v129 .. "RoadComp"] or 0
                local v131 = t1.RoadFilter(p48, v129, v128[2], v126, v127)

                p48[v129 .. "Compression"] = math.clamp((p48[v129 .. "Compression"] or 0) - v130 + v131, v128[3], v128[4])
            end

            v123, v124 = BikeSuspension.Axles(p48)
        else
            v124 = v120
            v123 = v119
        end

        local Rotation = root.CFrame.Rotation
        local t5 = {}

        if v121 then
            table.insert(t5, v121.Position.Y + t1.SupportHeight(Rotation, v123, Config.FrontWheelRadius, Config.FrontTyreHalfWidth))
        end

        if v122 then
            table.insert(t5, v122.Position.Y + t1.SupportHeight(Rotation, v124, Config.RearWheelRadius, Config.RearTyreHalfWidth))
        end

        local v138 = math.max(table.unpack(t5)) + 0.018
        local v139 = v138 - root.Position.Y

        if not (v139 < -0.65 or v139 > 2.6) then
            local AssemblyLinearVelocity, AssemblyAngularVelocity = root.AssemblyLinearVelocity, root.AssemblyAngularVelocity

            root.CFrame += Vector3.new(0, 1, 0) * v139

            if v139 > 0.05 and p48.roadVy then
                local v140 = math.min(p48.roadVy, 0)

                if AssemblyLinearVelocity.Y < v140 then
                    AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, v140, AssemblyLinearVelocity.Z)
                end
            end

            root.AssemblyLinearVelocity = AssemblyLinearVelocity
            root.AssemblyAngularVelocity = AssemblyAngularVelocity
            p48.supportHeight = v138
        end
    end
end

function t1.Contact(p49) -- line: 460
    -- upvalues: Config (copy), BikeSuspension (copy), t1 (copy), cast (copy)
    local root = p49.root
    local v141, v142 = BikeSuspension.Axles(p49)
    local v143 = cast(root.CFrame:PointToWorldSpace(v141))
    local v144 = cast(root.CFrame:PointToWorldSpace(v142))

    return v143 and root.Position.Y - t1.SupportHeight(root.CFrame.Rotation, v141, Config.FrontWheelRadius, Config.FrontTyreHalfWidth) - v143.Position.Y or 1e999, v144 and root.Position.Y - t1.SupportHeight(root.CFrame.Rotation, v142, Config.RearWheelRadius, Config.RearTyreHalfWidth) - v144.Position.Y or 1e999, v143, v144
end

function t1.PowerSlideMargin(_) -- line: 471
    return 1, 1
end

t1.SlideCurve = {
    Power = 1.8,
    AtLimit = 1
}

function t1.CurveSlide(p51) -- line: 487
    -- upvalues: Config (copy), t1 (copy)
    local v145 = if typeof(p51) == "number" and p51 == p51 and p51 then p51 else 0
    local SlideCurve = t1.SlideCurve
    local MaxSlideCrashYaw = script:GetAttribute("MaxSlideCrashYaw")

    if typeof(MaxSlideCrashYaw) ~= "number" or not MaxSlideCrashYaw then
        MaxSlideCrashYaw = 1
    end

    local v147 = math.max(Config.RearYaw * MaxSlideCrashYaw, 0.001)
    local v148 = math.abs(v145) / v147
    local v149 = v148 <= 1 and v148 ^ SlideCurve.Power or 1 + SlideCurve.Power * (v148 - 1)

    return math.sign(v145) * v147 * SlideCurve.AtLimit * v149
end

function t1.MaxSlideLoss(p52, p53, p54) -- line: 499
    -- upvalues: Config (copy), t1 (copy)
    if p53.surface ~= "Grass" and p53.surface ~= "Gravel" then
        local _ = p53.surface == "Sand"
    end

    local v150 = t1.LegendAbility(p52) == "SlideMaster"
    local v151 = Config.RearYaw * (script:GetAttribute("MaxSlideCrashYaw") or 1) * 1 * (v150 and t1.Legend.KuriSlideCrashYaw or 1)

    if (p52.kerbSlideYaw or 0) > 0 and t1.KerbEdge and t1.KerbEdge.RearSlideMargin then
        v151 = math.max(v151, math.abs(p52.kerbSlideYaw) + t1.KerbEdge.RearSlideMargin)
    end

    local onGround = p53.onGround and (p53.kph or 0) > 0.5 and v151 < math.abs(p52.rearYaw or 0)

    p52.maxSlideTime = onGround and (p52.maxSlideTime or 0) + p54 or 0
    p52.powerSlide = p52.maxSlideTime

    return onGround and p52.maxSlideTime >= (script:GetAttribute("MaxSlideCrashSeconds") or 0.12) * (v150 and t1.Legend.KuriSlideCrashSeconds or 1)
end

function t1.SlideCrashSeconds(_) -- line: 513
    return script:GetAttribute("CrashSlideSeconds") or 0.65
end

function t1.SlideRisk(p56, p57) -- line: 517
    -- upvalues: Config (copy)
    local v155 = math.clamp(((p57 or 0) - 60) / 180, 0, 1)

    return v155 * v155 * (3 - v155 * 2), (math.clamp((math.abs(p56.lean or 0) / Config.MaxLean - 0.85) / 0.15, 0, 1))
end

function t1.SlideCrashKind(_, _, p60) -- line: 523
    if p60 == "Grass" or p60 == "Gravel" or p60 == "Sand" then
        return "LOWSIDE"
    end

    return "HIGHSIDE"
end

function t1.RearLoss(p61, p62, p63, _) -- line: 528
    -- upvalues: t1 (copy)
    if t1.PrivateFeatures() then
        local v159 = p62.surface == "Grass" or p62.surface == "Gravel" or p62.surface == "Sand" or p61.anyLoose == true

        if p61.gripHighside then
            p61.gripHighside = false

            if p62.onGround and not v159 then
                p61.lossGripCatch = true

                return true, "HIGHSIDE"
            end
        end

        local v160 = (p61.skidGrow or 0) > 0.05 or (p62.rearBrake or 0) > 0.1 and (p61.rearBrakeSlip or 0) > math.max(p61.tractionSlip or 0, (p61.exitSlip or 0) * 1.05)
        local v164 = false

        if (p61.gripGasOff or 0) >= 0.5 and math.max(p61.gripRisk or 0, p61.gripRelease or 0) >= t1.GripReturn.HighsideSlide then
            v164 = math.abs(p61.lean or 0) >= t1.GripReturn.HighsideMinLean
        end

        local v168, v169

        if v160 then
            v169 = false
        elseif not v164 or v159 then
            v169 = false
        else
            local v170 = t1.SlideCrashKind(p62.kph or 0, p61.lean, p62.surface)

            if v170 then
                v168 = v170
                v169 = true
            else
                v169 = false
            end
        end

        if not v169 then
            v168 = "LOWSIDE"
        end

        local v171 = t1.MaxSlideLoss(p61, p62, p63)

        p61.lossOverSlide = v171 and v168 == "LOWSIDE"
        p61.lossGripCatch = v171 and v168 == "HIGHSIDE"

        return v171, v168
    end

    p61.gripHighside = false
    p61.lossOverSlide = false
    p61.lossGripCatch = false

    local v172 = (p61.skidGrow or 0) > 0.05 or (p62.rearBrake or 0) > 0.1 and (p61.rearBrakeSlip or 0) > math.max(p61.tractionSlip or 0, (p61.exitSlip or 0) * 1.05)
    local v176 = (p62.throttle or 0) >= 0.15
    local v177, v178

    if v172 then
        v178 = false
    elseif v176 then
        local v179 = t1.SlideCrashKind(p62.kph or 0, p61.lean, p62.surface)

        if v179 then
            v177 = v179
            v178 = true
        else
            v178 = false
        end
    else
        v178 = false
    end

    if not v178 then
        v177 = "LOWSIDE"
    end

    return t1.MaxSlideLoss(p61, p62, p63), v177
end

function t1.LowSpeedPowerTolerance(_) -- line: 577
    return 0, 1
end

function t1.SlideLoss(p66, _, _) -- line: 581
    p66.slideLossRisk = 0

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

function t1.BrakeCanTuck(p69, p70) -- line: 668
    -- upvalues: Config (copy), t1 (copy)
    local v182 = math.clamp(math.round(p69 or Config.EBS or 2), 1, 5)

    if p70 ~= false or v182 ~= 1 then
        return (t1.FrontBrake.EBSUse[v182] or 1) > 0
    end

    return (t1.FrontBrake.EBS1ABSOffUse or 0) > 0
end

function t1.FrontBrakeOver(p71, p72, p73, p74, p75, p76) -- line: 674
    -- upvalues: Config (copy), t1 (copy)
    local FrontBrake = t1.FrontBrake
    local v184 = math.abs(p71 or 0)
    local v186 = math.clamp(p72 or 0, 0, 1)

    if v184 < FrontBrake.MinLean or v186 < 0.02 then
        return 0
    end

    local v189 = math.clamp(math.round(p75 or Config.EBS or 2), 1, 5)
    local v190 = if p73 == false and v189 == 1 then v186 * (FrontBrake.EBS1ABSOffUse or 0) else v186 * (FrontBrake.EBSUse[v189] * (p73 == false and FrontBrake.ABSOffUse[v189] or 1))
    local v193 = math.tan((math.min(v184 * FrontBrake.LeanScale, 1.3962634015954636)))
    local v196 = math.sqrt((math.max(0, FrontBrake.Grip * FrontBrake.Grip - v193 * v193))) / FrontBrake.Grip * FrontBrake.Tolerance

    if p74 then
        local v197 = 1 - (Config.RainGrip or 0.72)
        local WetFrom, WetFull = FrontBrake.WetFrom, FrontBrake.WetFull
        local v199 = math.clamp((v184 - WetFrom) / (WetFull - WetFrom), 0, 1)

        v196 *= 1 - v197 * (v199 * v199 * (3 - 2 * v199))
    end

    if typeof(p76) == "number" and p76 == p76 then
        v196 *= math.clamp(p76, 0.3, 1.5)
    end

    return v190 / math.max(v196, 0.01)
end

function t1.FrontBrakeRate(p77, p78, p79) -- line: 687
    -- upvalues: Config (copy), t1 (copy)
    local FrontBrake = t1.FrontBrake
    local v202 = math.clamp(math.round(p78 or Config.EBS or 2), 1, 5)
    local v203 = if p79 == nil then 1 elseif p79 == false then FrontBrake.ABSOffTime or 1 else FrontBrake.ABSOnTime or 1
    local v204, v205

    if p77 > 1 then
        local v208 = math.clamp(1 + (p77 - 1) * (FrontBrake.EBSRiskRate[v202] or FrontBrake.RiskRate), 1, FrontBrake.EBSMaxRate[v202] or FrontBrake.MaxRate)

        if v208 then
            v204 = v208
            v205 = true
        else
            v205 = false
        end
    else
        v205 = false
    end

    if not v205 then
        v204 = 1
    end

    return v204 * (FrontBrake.EBSTimeScale and FrontBrake.EBSTimeScale[v202] or 1) * v203
end

function t1.LooseBrakeLoss(p80, _, _) -- line: 693
    p80.looseBrakeRisk = 0

    return false
end

function t1.WetBrakeLoss(p83, _, _) -- line: 708
    p83.wetBrakeRisk = 0

    return false
end

function t1.LeanAuthority(_, _) -- line: 724
    -- upvalues: Config (copy)
    return Config.MaxLean, 1
end

function t1.Handling(p88) -- line: 734
    local v210 = math.clamp((p88 - 180) / 120, 0, 1)
    local v211 = v210 * v210 * (3 - v210 * 2)

    return 12 - v211 * 6.6, 17 - v211 * 11.3, 3.6 - v211 * 2, 27 - v211 * 15
end

function t1.SlideFrame(p89, p90) -- line: 740
    -- upvalues: Config (copy)
    local FrontAxle = Config.FrontAxle
    local v212 = p89:Inverse() * CFrame.Angles(0, p90, 0) * p89

    return CFrame.new(FrontAxle) * v212 * CFrame.new(-FrontAxle)
end

function t1.BeginCrashPhysics(p91, p92) -- line: 745
    -- upvalues: BikeCrashPhysics (copy)
    BikeCrashPhysics.Begin(p91, p92)
end

function t1.ReleaseCrashPhysics(p93) -- line: 746
    -- upvalues: BikeCrashPhysics (copy)
    return BikeCrashPhysics.Release(p93)
end

function t1.CrashRiderMotion(p94, p95) -- line: 747
    -- upvalues: BikeCrashPhysics (copy)
    return BikeCrashPhysics.RiderMotion(p94, p95)
end

function t1.LiftCornerLoss(p96, p97, p98, p99) -- line: 748
    -- upvalues: Config (copy), t1 (copy)
    local v214 = math.abs(p96.lean or 0) > 0.12 or math.abs(p96.steer or 0) > 0.18

    if p97.surface ~= "Asphalt" or not p97.onGround or p97.speed <= 18 or not v214 then
        return nil
    end

    local v217 = math.asin((math.clamp(p96.root.CFrame.LookVector.Y, -1, 1)))

    if p98 > 0.22 and p99 < 0.12 and Config.WheelieCornerCrashPitch < v217 then
        return "LOWSIDE"
    end

    local v218 = t1.LegendAbility(p96) == "StoppieBrake"

    return if p99 > 0.22 and p98 < 0.12 and v217 < -(Config.StoppieCornerCrashPitch or 0.17453292519943295) * (v218 and t1.Legend.DoctorCornerStoppiePitch or 1) then "STOPPIE" else nil
end

function t1.LiftCornerCrashSeconds(p100, p101) -- line: 758
    -- upvalues: t1 (copy)
    if p101 ~= "STOPPIE" or t1.LegendAbility(p100) ~= "StoppieBrake" then
        return 0.18
    end

    return t1.Legend.DoctorCornerStoppieSeconds
end

function t1.RHDScrapeLoss(p102, p103, p104) -- line: 763
    -- upvalues: Config (copy)
    local onGround = p103.onGround and (p103.kph or 0) > 8 and (p102.scrape or 0) > 0.1

    p102.rhdScrapeRisk = onGround and (p102.rhdScrapeRisk or 0) + p104 or 0

    return onGround and p102.rhdScrapeRisk >= (Config.RHDScrapeCrashSeconds or 1.5)
end

function t1.CombinedBrakeLoss(p105, p106, p107) -- line: 768
    -- upvalues: Config (copy)
    local v219 = (p106.kph or p106.speed * Config.StudMetres * 3.6) >= Config.DriveBrakeCrashKph
    local v220 = p106.speed > 8 and math.abs(p105.lean) > 0.3141592653589793
    local onGround = p106.onGround
    local v221 = onGround and (if v219 or v220 then p105.throttle > 0.92 and p105.brake > 0.92 else v220)

    p105.combinedBrakeRisk = v221 and (p105.combinedBrakeRisk or 0) + p107 or 0

    return p105.combinedBrakeRisk > 0.22
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

function t1.AccelShapeAt(p108) -- line: 793
    -- upvalues: t1 (copy)
    local AccelShape = t1.AccelShape

    if typeof(p108) ~= "number" or p108 ~= p108 then
        return 1
    end

    if p108 <= AccelShape[1][1] then
        return AccelShape[1][2]
    end

    for i = 2, #AccelShape do
        local v222 = AccelShape[i - 1]
        local v223 = AccelShape[i]

        if p108 <= v223[1] then
            return v222[2] + (v223[2] - v222[2]) * (p108 - v222[1]) / (v223[1] - v222[1])
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
    Margin = 1.2,
    BuildRate = 1.8
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

function t1.IsKerb(p109) -- line: 854
    local v224 = p109 and p109.Instance

    if v224 == nil then
        return false
    end

    if v224:GetAttribute("Kerb") == true then
        return true
    end

    return string.find(string.lower(v224.Name), "kerb", 1, true) ~= nil
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

local v225
local Parent2 = script.Parent

local function kerbTrackPoints() -- line: 875
    -- upvalues: Config (copy), v225 (ref), Parent2 (copy)
    if v225 ~= nil then
        return v225 or nil
    end

    local function v226() -- line: 877
        -- upvalues: Config (copy), Parent2 (copy)
        local Tracks = Parent2 and Parent2:FindFirstChild("Tracks")
        local v227 = Tracks and Tracks:FindFirstChild(Config.Track)
        local Layout = v227 and v227:FindFirstChild("Layout")

        return Layout and require(Layout)
    end

    local ok, result = pcall(v226)

    v225 = ok and result and result.Points or false

    return v225 or nil
end

local function kerbOutward(p110, p111) -- line: 886
    -- upvalues: Config (copy), v225 (ref), Parent2 (copy)
    if v225 == nil then
        local function v228() -- line: 877
            -- upvalues: Config (copy), Parent2 (copy)
            local Tracks = Parent2 and Parent2:FindFirstChild("Tracks")
            local v229 = Tracks and Tracks:FindFirstChild(Config.Track)
            local Layout = v229 and v229:FindFirstChild("Layout")

            return Layout and require(Layout)
        end

        local ok, result = pcall(v228)

        v225 = ok and result and result.Points or false
    end

    local v230 = v225 or nil

    if not v230 or #v230 < 3 then
        return nil
    end

    local v231 = #v230
    local v232
    local n1 = 1e999

    local function test(p112) -- line: 889
        -- upvalues: p111 (copy), v230 (copy), v231 (copy), v232 (ref), n1 (ref)
        local v233 = (p112 - 1) % v231 + 1
        local Magnitude = (v230[v233] - p111).Magnitude

        if Magnitude < n1 then
            v232 = v233
            n1 = Magnitude
        end
    end

    if p110.kerbEdgeIdx then
        for i = p110.kerbEdgeIdx - 12, p110.kerbEdgeIdx + 12 do
            local v234 = (i - 1) % v231 + 1
            local Magnitude = (v230[v234] - p111).Magnitude

            if Magnitude < n1 then
                v232 = v234
                n1 = Magnitude
            end
        end
    end

    local v235 = v232

    if not v235 or n1 > 60 then
        v232 = nil
        n1 = 1e999

        for i = 1, v231, 3 do
            local v236 = (i - 1) % v231 + 1
            local Magnitude = (v230[v236] - p111).Magnitude

            if Magnitude < n1 then
                v232 = v236
                n1 = Magnitude
            end
        end

        local v237 = v232

        for i = v237 - 3, v237 + 3 do
            local v238 = (i - 1) % v231 + 1
            local Magnitude = (v230[v238] - p111).Magnitude

            if Magnitude < n1 then
                v232 = v238
                n1 = Magnitude
            end
        end
    end

    p110.kerbEdgeIdx = v232

    local v239 = v230[v232]
    local v240 = v230[v232 % v231 + 1]
    local v241 = v230[(v232 - 2) % v231 + 1]

    local function proj(p113, p114) -- line: 894
        -- upvalues: p111 (copy)
        local v242 = p114 - p113

        return p113 + v242 * math.clamp((p111 - p113):Dot(v242) / math.max(v242:Dot(v242), 1E-06), 0, 1)
    end

    local v246 = v240 - v239
    local v250 = v239 + v246 * math.clamp((p111 - v239):Dot(v246) / math.max(v246:Dot(v246), 1E-06), 0, 1)
    local v251 = v239 - v241
    local v255 = v241 + v251 * math.clamp((p111 - v241):Dot(v251) / math.max(v251:Dot(v251), 1E-06), 0, 1)

    if (v250 - p111).Magnitude < (v255 - p111).Magnitude and v250 then
        v255 = v250
    end

    local v258 = Vector3.new(p111.X - v255.X, 0, p111.Z - v255.Z)

    return v258.Magnitude > 0.05 and v258.Unit or nil
end

local function kerbGroundAt(p115) -- line: 900
    -- upvalues: t1 (copy), v24 (ref)
    if not (t1._roadParams and t1._roadRoot and t1._roadRoot.Parent) then
        if not (v24 and v24.Parent) then
            v24 = workspace:FindFirstChild("RaceCollision", true)
        end

        local v259 = v24

        t1._roadRoot = v259
        t1._roadParams = RaycastParams.new()
        t1._roadParams.FilterType = Enum.RaycastFilterType.Include
        t1._roadParams.FilterDescendantsInstances = v259 and {
            v259,
            workspace.Terrain
        } or { workspace.Terrain }
    end

    local v260 = workspace:Raycast(p115 + Vector3.new(0, 1.5, 0), Vector3.new(-0, -4, -0, -0), t1._roadParams)
    local v261 = if not v260 or not (v260.Normal.Y > 0.4) or v260.Instance:GetAttribute("Surface") == "Barrier" then nil else v260

    return v261
end

t1.KerbEdge.Kick = 0.4
t1.KerbEdge.RiskSeconds = 0.6
t1.KerbEdge.Recover = 1.2
t1.KerbEdge.SlideShare = 0.95
t1.KerbEdge.GasOpen = 0.15
t1.KerbEdge.WashTurnLoss = 0.65
t1.KerbEdge.WashWobble = 2.2
t1.KerbEdge.StandUpDeg = 4
t1.KerbEdge.FrontSink = 0.08
t1.KerbEdge.RearSlideShare = 0.9
t1.KerbEdge.RearSlideMargin = 0.05235987755982989
t1.KerbEdge.RearKick = 0.25
t1.KerbEdge.RearRiskSeconds = 0.8
t1.KerbEdge.RearRecover = 1.8
t1.KerbEdge.FrontKick = 0.2
t1.KerbEdge.FrontRiskSeconds = 1
t1.KerbEdge.FrontRecover = 2
t1.KerbEdge.WashTurnLoss = 0.45
t1.KerbEdge.WashWobble = 1.6
t1.KerbEdge.FrontSink = 0.04

local function kerbFullLean() -- line: 963
    -- upvalues: Config (copy), t1 (copy)
    local FullLean = t1.KerbEdge.FullLean

    if not Config.KerbEdgeLeanDry then
        return FullLean
    end

    return (math.rad((if script.Parent:GetAttribute("Raining") == true then Config.KerbEdgeLeanWet or Config.KerbEdgeLeanDry or Config.KerbEdgeLeanDry else Config.KerbEdgeLeanDry) - 0.5))
end

local function kerbEdgeTouch(p116, p117) -- line: 971
    -- upvalues: Config (copy), t1 (copy), kerbOutward (copy), kerbGroundAt (copy)
    local KerbEdge = t1.KerbEdge
    local root = p116.root
    local FullLean = t1.KerbEdge.FullLean

    if Config.KerbEdgeLeanDry then
        FullLean = math.rad((if script.Parent:GetAttribute("Raining") == true then Config.KerbEdgeLeanWet or Config.KerbEdgeLeanDry or Config.KerbEdgeLeanDry else Config.KerbEdgeLeanDry) - 0.5)
    end

    if root and p117.onGround and not ((p117.kph or 0) < KerbEdge.MinKph) and not (math.abs(p116.lean or 0) < FullLean) then
        local CFrame = root.CFrame

        for _, v266 in {
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
            local v269 = math.min(v266[3] * t1.TyreCrownScale, v266[2])
            local v270 = CFrame:PointToWorldSpace(v266[1]) - CFrame.UpVector * (v266[2] - v269)
            local v271 = kerbGroundAt(v270)

            if v271 and t1.IsKerb(v271) then
                local v272 = kerbOutward(p116, v270)

                if v272 then
                    local v273 = kerbGroundAt(Vector3.new(v270.X, v271.Position.Y, v270.Z) + v272 * KerbEdge.Probe)

                    if not v273 or not t1.IsKerb(v273) then
                        return true
                    end
                end
            end
        end

        return false
    end

    return false
end

function t1.KerbCornerLoss(p118, p119, _, _, _, _, p124) -- line: 992
    -- upvalues: Config (copy), t1 (copy), kerbEdgeTouch (copy)
    p118.kerbLeanRisk = 0

    local KerbEdge = t1.KerbEdge
    local v275 = math.min(p124 or 0, 0.1)
    local v276 = kerbEdgeTouch(p118, p119)
    local v277 = p118.kerbEdgeRisk or 0
    local v278 = false
    local v279 = false
    local v280 = false
    local v281 = false
    local v282 = false

    if v276 then
        v278 = true
    else
        v282 = true
    end

    local v283

    if v278 then
        if p118.kerbEdgeOn then
            v283 = v277
            v282 = false
        else
            v279 = true
        end
    end

    v278 = false

    if v279 then
        if (p119.throttle or 0) >= KerbEdge.GasOpen then
            v278 = true
        else
            v280 = true
        end
    end

    v279 = false

    if v278 then
        if (p119.brake or 0) < 0.1 then
            v279 = true
        else
            v280 = true
        end
    end

    v278 = false

    local v284

    if v280 then
        v284 = "Front"
        v278 = true
    end

    v280 = false

    if v279 then
        v284 = "Rear"
        v278 = true
    end

    v279 = false

    if v278 then
        p118.kerbSlideMode = v284

        if p118.kerbSlideMode == "Rear" then
            v279 = true
        else
            v280 = true
        end
    end

    v278 = false

    local v285

    if v279 then
        local RearKick = KerbEdge.RearKick

        if RearKick then
            v285 = RearKick
            v281 = true
        else
            v278 = true
        end
    end

    if v278 then
        local Kick = KerbEdge.Kick

        if Kick then
            v285 = Kick
            v281 = true
        else
            v280 = true
        end
    end

    v278 = false

    if v280 then
        local FrontKick = KerbEdge.FrontKick

        if FrontKick then
            v285 = FrontKick
            v281 = true
        else
            v278 = true
        end
    end

    if v278 then
        v285 = KerbEdge.Kick
        v281 = true
    end

    if v281 then
        v283 = math.max(v277, v285)
        v282 = false
    end

    local v286, v287

    if v282 then
        local v288 = false

        if p118.kerbSlideMode == "Front" and v277 > 0 and p119.onGround and (p119.kph or 0) >= KerbEdge.MinKph then
            local v290 = math.abs(p118.lean or 0)
            local FullLean = t1.KerbEdge.FullLean

            if Config.KerbEdgeLeanDry then
                FullLean = math.rad((if script.Parent:GetAttribute("Raining") == true then Config.KerbEdgeLeanWet or Config.KerbEdgeLeanDry or Config.KerbEdgeLeanDry else Config.KerbEdgeLeanDry) - 0.5)
            end

            v288 = FullLean <= v290
        end

        if v288 then
            v287 = true
            v286 = v277 + v275 / (KerbEdge.FrontRiskSeconds or KerbEdge.RiskSeconds)
        else
            local v292, v293

            if p118.kerbSlideMode == "Rear" then
                local RearRecover = KerbEdge.RearRecover

                if RearRecover then
                    v292 = RearRecover
                    v293 = true
                else
                    local Recover = KerbEdge.Recover

                    if Recover then
                        v292 = Recover
                        v293 = true
                    else
                        v293 = false
                    end
                end
            else
                v293 = false
            end

            if not v293 then
                v292 = KerbEdge.FrontRecover or KerbEdge.Recover
            end

            v287 = false
            v286 = math.max(0, v277 - v275 * v292)
        end
    else
        local v295, v296

        if p118.kerbSlideMode == "Rear" then
            local RearRiskSeconds = KerbEdge.RearRiskSeconds

            if RearRiskSeconds then
                v295 = RearRiskSeconds
                v296 = true
            else
                local RiskSeconds = KerbEdge.RiskSeconds

                if RiskSeconds then
                    v295 = RiskSeconds
                    v296 = true
                else
                    v296 = false
                end
            end
        else
            v296 = false
        end

        if not v296 then
            v295 = KerbEdge.FrontRiskSeconds or KerbEdge.RiskSeconds
        end

        v287 = false
        v286 = v283 + v275 / v295
    end

    p118.kerbEdgeOn = v276
    p118.kerbEdgeHit = v276 or nil
    p118.kerbEdgeRisk = v286
    p118.kerbEdgeWash = math.clamp(v286, 0, 1)

    if v276 or v287 then
        v287 = v286 >= 1
    end

    return v287
end

t1.WheelieDrive = {
    FreeDeg = 5,
    FullDeg = 45,
    FullLoss = 0.4,
    MaxLoss = 0.55
}
t1.FrontLight = {
    TurnLoss = 0.1,
    FullDemand = 0.9,
    LeanFrom = 8,
    LeanFull = 15,
    LeanFadeFrom = 40,
    LeanFadeTo = 50,
    RHDShare = 0.15,
    Rise = 0.2,
    Fall = 0.35
}
t1.RHDWheelie = {
    Lift = 0.15,
    Target = 0.18,
    Cap = 0.1,
    Ramp = 0.5,
    Balance = 0.4
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

function t1.WetSlickLoss(p125, p126, p127) -- line: 1057
    -- upvalues: t1 (copy)
    local WetSlick = t1.WetSlick
    local v297 = math.min(p127, 0.1)
    local v298 = p125.wetSlickOver or 0
    local onGround

    if p125.slickWet == true then
        onGround = p126.onGround

        if onGround then
            onGround = (p126.kph or 0) > WetSlick.MinKph and v298 > 1
        end
    else
        onGround = false
    end

    if onGround then
        local v300 = math.clamp((v298 - 1) / WetSlick.OverFull, 0, 1)
        local v301 = 1 / WetSlick.EdgeSeconds + (1 / WetSlick.FastSeconds - 1 / WetSlick.EdgeSeconds) * v300

        p125.wetSlickRisk = (p125.wetSlickRisk or 0) + v297 * v301
    else
        p125.wetSlickRisk = math.max(0, (p125.wetSlickRisk or 0) - v297 * WetSlick.Recover)
    end

    p125.wetSlickWash = math.clamp(p125.wetSlickRisk, 0, 1)

    return onGround and p125.wetSlickRisk >= 1
end

function t1.LooseLeanLimit(p128, p129) -- line: 1072
    -- upvalues: t1 (copy)
    local Points = t1.LooseLean.Points
    local v303

    if p128 <= Points[1][1] then
        v303 = Points[1][2]
    elseif Points[#Points][1] <= p128 then
        v303 = Points[#Points][2]
    else
        for i = 1, #Points - 1 do
            local v304 = Points[i]
            local v305 = Points[i + 1]

            if p128 <= v305[1] then
                v303 = v304[2] + (v305[2] - v304[2]) * (p128 - v304[1]) / (v305[1] - v304[1])
                break
            end

            v303 = nil
        end
    end

    return (math.rad((math.max(0, v303 - (p129 and t1.LooseLean.WetLess or 0)))))
end

t1.LooseLeanBySpeed = {
    EdgeSeconds = 0.35,
    FastSeconds = 0.1,
    FastOverDeg = 8,
    Recover = 3,
    ThrottleLessDeg = 5,
    WetLess = 6,
    MinKph = 8,
    Grass = {
        { 20, 32 },
        { 60, 27 },
        { 100, 22 },
        { 150, 16 },
        { 200, 11 },
        { 270, 5 }
    },
    Gravel = {
        { 20, 34 },
        { 60, 29 },
        { 100, 24 },
        { 150, 18 },
        { 200, 13 },
        { 270, 7 }
    }
}

local function looseLimitDeg(p130, p131) -- line: 1100
    -- upvalues: t1 (copy)
    local v308 = t1.LooseLeanBySpeed[if p130 == "Grass" then "Grass" else "Gravel"]

    if p131 <= v308[1][1] then
        return v308[1][2]
    end

    if not (v308[#v308][1] <= p131) then
        for i = 1, #v308 - 1 do
            local v309 = v308[i]
            local v310 = v308[i + 1]

            if p131 <= v310[1] then
                return v309[2] + (v310[2] - v309[2]) * (p131 - v309[1]) / (v310[1] - v309[1])
            end
        end
    end

    return v308[#v308][2]
end

t1.LooseLimitDeg = looseLimitDeg

function t1.LooseLeanLoss(p132, p133, p134, p135, p136, p137, p138) -- line: 1109
    -- upvalues: t1 (copy), looseLimitDeg (copy)
    local LooseLean, LooseLeanBySpeed = t1.LooseLean, t1.LooseLeanBySpeed
    local v311 = math.min(p136, 0.1)

    local function loose(p139, p140) -- line: 1112
        -- upvalues: t1 (copy)
        local v312 = p139 and p140 and p140 < 0.18 and t1.SurfaceOf(p139)

        return if (v312 == "Grass" or v312 == "Gravel" or v312 == "Sand") and v312 then v312 else nil
    end

    local v313 = p135 and p134 and p134 < 0.18 and t1.SurfaceOf(p135)
    local v314 = if (v313 == "Grass" or v313 == "Gravel" or v313 == "Sand") and v313 then v313 else nil
    local v315 = p138 and p137 and p137 < 0.18 and t1.SurfaceOf(p138)
    local v316 = if (v315 == "Grass" or v315 == "Gravel" or v315 == "Sand") and v315 then v315 else nil
    local v317 = p133.kph or 0
    local v320 = math.deg((math.abs(p132.lean or 0)))
    local v321 = script.Parent:GetAttribute("Raining") == true
    local v322 = if v314 then v320 - (looseLimitDeg(v314, v317) - (v321 and LooseLeanBySpeed.WetLess or 0)) else -1
    local v323 = -1

    if v316 then
        local v324 = math.clamp(p132.smoothThrottle or p132.throttle or 0, 0, 1)
        local v325 = looseLimitDeg(v316, v317)
        local WetLess = if v321 then LooseLeanBySpeed.WetLess else nil

        if not v321 or not WetLess then
            WetLess = 0
        end

        v323 = v320 - (v325 - WetLess - v324 * LooseLeanBySpeed.ThrottleLessDeg)
    end

    local v326 = math.max(v322, v323)
    local v327 = v314 ~= nil and LooseLean.UprightKph <= v317
    local onGround = p133.onGround

    if onGround then
        if LooseLeanBySpeed.MinKph < v317 then
            if v326 > 0 then
                v327 = true
            end
        else
            v327 = false
        end
    else
        v327 = onGround
    end

    if v327 then
        local v329 = math.clamp(math.max(v326, 0) / LooseLeanBySpeed.FastOverDeg, 0, 1)

        p132.looseLeanRisk = (p132.looseLeanRisk or 0) + v311 * (1 / LooseLeanBySpeed.EdgeSeconds + (1 / LooseLeanBySpeed.FastSeconds - 1 / LooseLeanBySpeed.EdgeSeconds) * v329)
    else
        p132.looseLeanRisk = math.max(0, (p132.looseLeanRisk or 0) - v311 * LooseLeanBySpeed.Recover)
    end

    p132.looseWash = math.clamp(p132.looseLeanRisk, 0, 1)

    local v331 = true

    if v327 and p132.looseLeanRisk >= 1 then
        if v323 > 0 then
            p132.lossOverSlide = true
        end

        v331 = false
    end

    return not v331
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

function t1.KerbResistance(p141, p142, p143, p144, p145) -- line: 1148
    -- upvalues: t1 (copy)
    local v332 = if not p144 or not p145 then 0 else 1

    p141.kerbResistance = (p141.kerbResistance or 0) + (v332 - (p141.kerbResistance or 0)) * (1 - math.exp(-p143 * (if v332 == 1 then 12 else 8)))

    local Kerb = p141.onKerb and t1.KerbDrag.Kerb or t1.KerbDrag.Runoff

    return math.sign(p142) * math.min(math.abs(p142) * Kerb.Rate, Kerb.Cap) * p141.kerbResistance
end

function t1.BumpKind(p146, p147) -- line: 1155
    -- upvalues: t1 (copy)
    local v338 = p146 and p146.Instance

    if t1.IsKerb(p146) then
        if t1.PrivateFeatures() then
            return 0
        end

        return 0.75
    end

    local v339 = v338 and t1.SurfaceOf(p146) or p147

    if v339 == "Gravel" then
        return 1
    end

    if v339 == "Grass" then
        return 0.65
    end

    return 0
end

function t1.RoughSurface(p148, p149, p150, p151, p152, p153, p154, p155) -- line: 1163
    -- upvalues: Config (copy), t1 (copy), looseWheel (copy)
    local v340 = p152 and (p150 == "Grass" or p150 == "Gravel")
    local v342 = math.clamp(p151 / 22, 0, 1)
    local v343, v344

    if v340 then
        local v345 = v342 * (if p150 == "Gravel" then 1 else 0.7)

        if v345 then
            v343 = v345
            v344 = true
        else
            v344 = false
        end
    else
        v344 = false
    end

    if not v344 then
        v343 = 0
    end

    p148.roughBlend = (p148.roughBlend or 0) + (v343 - (p148.roughBlend or 0)) * (1 - math.exp(-p149 * (if v340 then 5 else 12)))
    p153 = p153 or workspace:GetServerTimeNow()

    local rootPosition = p148.root.Position
    local v350 = p153 * 8 + rootPosition.X * 0.025 + rootPosition.Z * 0.021

    p148.roughPhase = v350
    p148.roughRoll = 0
    p148.roughSteer = p148.roughBlend * (math.sin(v350 * 0.63) * 0.65 + math.sin(v350 * 1.11) * 0.35)

    local v354 = p152 and v342 * t1.BumpKind(p154, p150) or 0
    local v355 = p152 and v342 * t1.BumpKind(p155, p150) or 0

    p148.frontBump = (p148.frontBump or 0) + (v354 - (p148.frontBump or 0)) * (1 - math.exp(-p149 * 12))
    p148.rearBump = (p148.rearBump or 0) + (v355 - (p148.rearBump or 0)) * (1 - math.exp(-p149 * 12))

    if t1.LooseRide.Enabled and p148.root then
        p148.frontBump = 0
        p148.rearBump = 0

        local v363 = 1 - math.exp(-p149 * t1.LooseRide.Blend)

        looseWheel(p148, "front", p154, Config.FrontAxle, p152, p149, p151, v363)
        looseWheel(p148, "rear", p155, Config.RearAxle, p152, p149, p151, v363)
    end

    return 0, p148.roughSteer
end

function t1.RearSlideSpeedFactor(p156, _) -- line: 1188
    -- upvalues: t1 (copy)
    local v365 = math.clamp(((p156 or 0) - 30) / 220, 0, 1)
    local SlideMidHigh = t1.SlideMidHigh

    return SlideMidHigh.Low - (SlideMidHigh.Low - SlideMidHigh.High) * v365 ^ SlideMidHigh.CurvePower
end

function t1.RearSlide(p158, p159, p160, p161) -- line: 1199
    -- upvalues: t1 (copy)
    local SnapFrequency = if p161 then 4.3 else (p158.gripGasOff or 0) >= 0.5 and t1.GripReturn.SnapFrequency or 8
    local v367 = p158.rearYaw or 0
    local v368 = p158.rearYawVelocity or 0
    local v369 = v367 - p159
    local v371 = math.exp(-SnapFrequency * p160)

    p158.rearYaw = p159 + (v369 + (v368 + SnapFrequency * v369) * p160) * v371
    p158.rearYawVelocity = (v368 - SnapFrequency * (v368 + SnapFrequency * v369) * p160) * v371

    return p158.rearYaw
end

function t1.Burnout(p162, p163, p164, _, p166, p167, p168, p169) -- line: 1209
    local v372 = p162.lean or 0
    local v373

    if math.abs(v372) < 0.2617993877991494 and p162.gear > 0 and p166 == "Asphalt" then
        if p167 then
            v373 = false

            if p168 < 0.12 and (p162.wheeliePitch or 0) < 0.045 and math.max(p163, p162.throttle or 0) > 0.25 then
                v373 = math.max(p164, p162.brake or 0) > 0.25
            end
        else
            v373 = p167
        end
    else
        v373 = false
    end

    local v376 = v373 and math.clamp((math.max(p163, p162.throttle or 0) - 0.25) / 0.75, 0, 1) * math.clamp((math.max(p164, p162.brake or 0) - 0.25) / 0.75, 0, 1) or 0

    p162.burnout = (p162.burnout or 0) + (v376 - (p162.burnout or 0)) * (1 - math.exp(-p169 * (if v373 then 5 else 16)))

    if not v373 then
        p162.burnout = 0
    end

    return p162.burnout
end

function t1.WheelieSpeedFactor(p170) -- line: 1217
    return math.clamp((p170 - 8) / 22, 0, 1) * math.clamp((270 - p170) / 120, 0, 1)
end

function t1.WheelieLiftDemand(p171, p172, p173, p174) -- line: 1220
    -- upvalues: Config (copy), t1 (copy)
    if p174 then
        return 0
    end

    local v389 = math.clamp((p172 - 55) / 75, 0, 1) * 0.55 + 1

    return math.max(0, p171 / Config.Gravity - 0.56) * t1.WheelieSpeedFactor(p172) * v389 * (1 - math.clamp(math.abs(p173) / 0.65, 0, 1))
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

function t1.TCSFeel(p175) -- line: 1248
    -- upvalues: Config (copy), t1 (copy)
    local v395 = math.clamp(math.round(p175 or Config.TCS), 1, 5)

    return (if v395 == 1 then 0 else v395 - 1) + t1.TCSSoften
end

function t1.TCSPick(p176, p177) -- line: 1253
    local v397 = math.clamp(p177, 0, #p176 - 1)
    local v398 = math.floor(v397)
    local v399 = v397 - v398
    local v400 = p176[v398 + 1]

    return v400 + (p176[math.min(v398 + 2, #p176)] - v400) * v399
end

function t1.TractionResponse(p178, p179, p180, p181) -- line: 1259
    -- upvalues: t1 (copy)
    local v403 = t1.TCSPick({ 4, 4, 0.65, 0.3, 0.12, 0.035 }, p181)
    local v404 = t1.TCSPick({ 0, 0, 0.45, 0.75, 0.93, 0.995 }, p181)
    local v407 = math.sqrt((math.max(0, (p180 * (1 + v403)) ^ 2 - p178 ^ 2)))
    local v408 = p179 > 0 and math.clamp(1 - v407 / p179, 0, 1) * v404 or 0
    local v410 = p179 * (1 - v408)

    return v408, (math.max(0, math.sqrt(p178 * p178 + v410 * v410) / math.max(p180, 1) - 1))
end

t1.LandEase = 10

function t1.Step(p182, p183, p184) -- line: 1269
    -- upvalues: Config (copy), BikeStats (copy), BikeSuspension (copy), BikeGearbox (copy), PitLimiter (copy), BikeCrashPhysics (copy), result (ref), t1 (copy), v22 (copy), cast (copy)
    local root

    if p182.root.Parent and (p182.root.Parent:GetAttribute("Crash") or "") ~= "" then
        if p184 then
            p182.force.Force = Vector3.new(0, 0, 0)
            p182.force.Enabled = false
            p182.align.Enabled = false
        end

        root = p182.root.AssemblyLinearVelocity

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

    root = p182.root:GetAttribute("LossStage")

    if root and root ~= "" then
        return BikeCrashPhysics.Step(p182, p183, p184)
    end

    local v413 = math.min(p183, 0.04)

    root = p182.root

    local rootPosition, AssemblyLinearVelocity = root.Position, root.AssemblyLinearVelocity
    local Magnitude = root.Parent and root.Parent:GetAttribute("LooseWash") or p182.looseWash or 0
    local v414 = p182.washVisual or 0
    local v415 = Magnitude - (p182.washVisual or 0)
    local v416 = -v413 * 10

    p182.washVisual = v414 + v415 * (1 - math.exp(v416))
    Magnitude = p182.kerbEdgeWash or 0

    local v417 = if (p182.kerbWashVisual or 0) < Magnitude then 25 else 6
    local v418 = p182.kerbWashVisual or 0
    local ebs = Magnitude - (p182.kerbWashVisual or 0)
    local LookVector = -v413 * v417

    p182.kerbWashVisual = v418 + ebs * (1 - math.exp(LookVector))

    if root:GetAttribute("NoReverse") then
        v417 = root.CFrame.LookVector.X
        v418 = root.CFrame.LookVector.Z
        Magnitude = Vector3.new(v417, 0, v418).Unit
        v417 = AssemblyLinearVelocity:Dot(Magnitude)

        if v417 < 0 then
            AssemblyLinearVelocity -= Magnitude * v417

            if p184 then
                root.AssemblyLinearVelocity = AssemblyLinearVelocity
            end
        end
    end

    Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude
    v417 = Magnitude * Config.StudMetres * 3.6
    v414 = t1.TCSFeel(p182.tcs)
    v418 = math.clamp(p182.aw or Config.AW, 1, 5)
    v415 = math.clamp(p182.ebs or Config.EBS, 1, 5)

    local v419 = p182.gear or 1

    p182.gear = math.clamp(v419, 0, 6)

    local v420 = p182.throttle > p182.smoothThrottle and t1.TCSPick({ 21, 20, 19, 18, 17, 16 }, v414) or 24
    local Turn

    v419, v416, LookVector, Turn = t1.Handling(v417)
    v419 *= 0.78
    v416 *= 0.72
    LookVector *= 0.76
    Turn *= 0.82

    local v421 = t1.BikeStats(p182)

    v419 *= v421.Handling
    v416 *= v421.Handling
    LookVector *= v421.Handling
    Turn *= v421.Handling

    local v422 = t1.LegendAbility(p182)

    t1.Slipstream.Step(p182, v413, v417, v422 == "Slipstream")

    local Weight = t1.Base
    local v423 = t1.BaseLeanBoost(v417)

    v419 *= 1 + Weight.RollFrequency * v423
    v416 *= 1 + Weight.RollAccel * v423
    LookVector *= 1 + Weight.RollRate * v423
    Turn *= 1 + Weight.SteerRate * v423

    if v422 == "SharpLean" then
        Weight = t1.Legend
        v423 = t1.SamuraiLeanBoost(v417)
        v419 *= 1 + Weight.SamuraiRollFrequency * v423
        v416 *= 1 + Weight.SamuraiRollAccel * v423
        LookVector *= 1 + Weight.SamuraiRollRate * v423
        Turn *= 1 + Weight.SamuraiSteerRate * v423
    end

    Weight = t1.Weight
    v423 = t1.RiderKg(p182)

    local v424 = (v423 + Weight.BikeKg) / Weight.ReferenceKg

    v419 /= math.sqrt(v424)
    v416 /= v424
    LookVector /= math.sqrt(v424)

    local v430 = (Weight.ShiftSeconds + (Weight.ShiftSecondsFast - Weight.ShiftSeconds) * math.clamp(v417 / 300, 0, 1)) * math.sqrt(v423 / Weight.RiderKg)
    local v428 = math.clamp(-(p182.steer or 0), -1, 1)
    local v425 = p182.bodyShift or 0
    local v429 = 2 / math.max(v430, 0.05) * v413
    local v427 = v428 - v425
    local v431 = -v429

    p182.bodyShift = v425 + math.clamp(v427, v431, v429)

    if p182.clutch then
    end

    if p182.clutch then
        p182.clutchBlend = 1
    else
        v428 = p182.clutchBlend or 0
        v429 = -v413 * 6
        p182.clutchBlend = v428 * math.exp(v429)
    end

    v430 = p182.smoothThrottle
    v425 = p182.throttle - p182.smoothThrottle
    p182.smoothThrottle = v430 + v425 * (1 - math.exp(-v413 * v420))
    v430 = BikeGearbox.RPM(p182.gear, v417, p182.smoothThrottle, p182.tractionSlip)
    v420 = if p182.gear == 0 then 1 else p182.clutchBlend
    v428 = BikeGearbox.IdleRPM

    local v432 = v428 + math.clamp(p182.smoothThrottle, 0, 1) * (BikeGearbox.RedlineRPM - BikeGearbox.IdleRPM - 300)

    p182.engineRpm = p182.engineRpm or v430

    local v433

    if v420 > 0.02 then
        v428 = p182.engineRpm
        v429 = v432 - p182.engineRpm
        v431 = -v413
        v433 = if p182.engineRpm < v432 then 6.5 else 2.4
        v427 = v431 * v433
        p182.engineRpm = v428 + v429 * (1 - math.exp(v427))

        if p182.engineRpm > BikeGearbox.RedlineRPM - 350 then
            p182.engineRpm -= 700
        end
    end

    v432 = p182.clutchHeld == true
    p182.clutchHeld = p182.clutch == true

    local v434, v435

    if v432 and not p182.clutch and p182.gear > 0 then
        v425 = BikeGearbox.WheelRPM(p182.gear, v417)
        v435 = BikeGearbox.IdleRPM
        v428 = math.max(v425, v435)
        v434 = (p182.engineRpm - v428) / 9000
        v435 = math.clamp(v434, 0, 1)
        v434 = if p182.gear <= 2 then 1 else 0.45
        p182.clutchLaunch = v435 * v434
    end

    v435 = (p182.clutchLaunch or 0) - v413 * 1.3
    p182.clutchLaunch = math.max(0, v435)

    if v420 <= 0.02 then
        p182.engineRpm = v430
    end

    p182.reportRpm = v430 + (p182.engineRpm - v430) * v420
    v430 = p182.smoothBrake
    v425 = p182.brake - p182.smoothBrake

    local BaseWeight = -v413 * 24

    p182.smoothBrake = v430 + v425 * (1 - math.exp(BaseWeight))
    v430 = p182.rearBrake or 0
    v428 = p182.smoothRearBrake or 0
    v434 = v430 - v428
    p182.smoothRearBrake = v428 + v434 * (1 - math.exp(-v413 * (if v428 < v430 then 4.5 else 20)))

    if p182.steer * p182.smoothSteer >= 0 then
        v435 = p182.steer
        v425 = math.abs(v435)
        v434 = p182.smoothSteer
        v428 = v425 < math.abs(v434)
    else
        v428 = false
    end

    v425 = Weight.ReleaseSteerRate
    v434 = Weight.ReleaseSteerRateFast - Weight.ReleaseSteerRate
    v431 = Weight.PickUpFromKph
    v433 = Weight.PickUpFullKph

    local v437 = (v417 - v431) / (v433 - v431)
    local v436 = math.clamp(v437, 0, 1)

    v430 = v425 + v434 * (v436 * v436 * (3 - 2 * v436))

    local v438, SpeedHeavyFromKph

    if v428 then
        BaseWeight = v430 - 1
        v433 = Weight.FromKph
        v436 = Weight.FullKph
        SpeedHeavyFromKph = (v417 - v433) / (v436 - v433)
        v437 = math.clamp(SpeedHeavyFromKph, 0, 1)
        v438 = 1 + BaseWeight * (v437 * v437 * (3 - 2 * v437)) or 1
    else
        v438 = 1
    end

    v435 = p182.smoothSteer
    BaseWeight = p182.steer - p182.smoothSteer
    v433 = -v413 * Turn * v438
    p182.smoothSteer = v435 + BaseWeight * (1 - math.exp(v433))
    v435 = root.CFrame.LookVector.X
    BaseWeight = root.CFrame.LookVector.Z
    v438 = Vector3.new(v435, 0, BaseWeight)

    if v438.Magnitude < 0.1 then
        v438 = Vector3.new(-1, 0, 0)
    end

    local v439, v440, LeanStartFade, v441, v442, v443, v444, v445

    if p184 then
        v438 = t1.LeanAuthority(v417, v422)
        v434 = -p182.smoothSteer
        BaseWeight = if p182.paddling then 0.12 else v438
        v435 = v434 * BaseWeight
        BaseWeight = Magnitude / 30
        v428 = v435 * math.clamp(BaseWeight, 0, 1)

        if (p182.washVisual or 0) > 0 then
            v434 = p182.lean

            if math.abs(v434) > 0.02 then
                v431 = p182.lean
                v434 = math.sign(v431) * t1.LooseLean.WashSink * p182.washVisual
                v427 = math.abs(v428)
                v433 = p182.lean
                v431 = math.abs(v433)
                v428 += v434 * math.max(v427, v431)
            end
        end

        if (p182.kerbWashVisual or 0) > 0.01 then
            v434 = p182.lean

            if math.abs(v434) > 0.02 then
                if p182.kerbSlideMode == "Front" then
                    v431 = p182.lean
                    v434 = math.sign(v431) * t1.KerbEdge.FrontSink * p182.kerbWashVisual
                    v427 = math.abs(v428)
                    v433 = p182.lean
                    v431 = math.abs(v433)
                    v428 += v434 * math.max(v427, v431)
                elseif math.abs(v428) > 0.02 then
                    v434 = math.sign(v428)
                    v427 = math.abs(v428)
                    v436 = t1.KerbEdge.StandUpDeg
                    v431 = math.rad(v436) * p182.kerbWashVisual
                    v428 -= v434 * math.min(v427, v431)
                end
            end
        end

        if v428 * p182.lean >= 0 then
            v435 = math.abs(v428)
            BaseWeight = p182.lean
            v430 = math.abs(BaseWeight) < v435
        else
            v430 = false
        end

        Turn = t1.Turn
        v433 = p182.lean
        v434 = (math.abs(v433) / math.max(v438, 0.01) - Turn.EdgeFrom) / (1 - Turn.EdgeFrom)
        v435 = math.clamp(v434, 0, 1)
        v435 *= v435
        BaseWeight = (v417 - 200) / 120
        v434 = math.clamp(BaseWeight, 0, 1)
        v434 = (1 - Turn.EdgeResistance * v435) * (1 - (v422 == "SharpLean" and t1.Legend.SamuraiEdgeResistance or t1.Base.EdgeResistance) * v435 * v434)
        BaseWeight = Turn.BaseWeight
        v433 = Turn.SpeedHeavy
        SpeedHeavyFromKph = Turn.SpeedHeavyFromKph
        v444 = Turn.SpeedHeavyFullKph
        v439 = (v417 - SpeedHeavyFromKph) / (v444 - SpeedHeavyFromKph)
        v440 = math.clamp(v439, 0, 1)
        v438 = BaseWeight * (1 - v433 * (v440 * v440 * (3 - 2 * v440)))

        if p182.tipFromUpright ~= false then
            v438 *= Turn.TipInHeavy
            v434 *= 1 - Turn.TipInEdgeExtra * v435
        end

        if v430 then
            v427 = Turn.EdgeMin
            v431 = v438 * v434
            v443 = math.max(v427, v431)
        end

        if not v430 or not v443 then
            v443 = 1
        end

        BaseWeight = p182.lean
        v434 = math.abs(BaseWeight)

        local v446

        if v430 then
            p182.leanStartIdle = 0

            if not p182.leanStartAt then
                p182.leanStartAt = v434
                p182.leanStartRest = (p182.rollVelocity or 0) * math.sign(v428) < Turn.FlickRollRate
            end

            local v448

            if p182.tipFromUpright == false then
                v448 = 1
            else
                v427 = 1 - Turn.UprightTipWeight
                v437 = Turn.UprightTipFrom
                SpeedHeavyFromKph = Turn.UprightTipFade
                v440 = (v434 - v437) / (SpeedHeavyFromKph - v437)
                v444 = math.clamp(v440, 0, 1)
                v448 = 1 - v427 * (1 - v444 * v444 * (3 - 2 * v444))
            end

            if p182.leanStartAt and p182.leanStartRest then
                v427 = Turn.LeanStartWeight
                v433 = Turn.LeanStartWeightNearMax - Turn.LeanStartWeight
                v437 = p182.leanStartAt
                SpeedHeavyFromKph = Turn.LeanStartNearFrom
                v444 = Turn.LeanStartNearFull
                v439 = (v437 - SpeedHeavyFromKph) / (v444 - SpeedHeavyFromKph)
                v440 = math.clamp(v439, 0, 1)
                v437 = 1 - (v427 + v433 * (v440 * v440 * (3 - 2 * v440)))
                v440 = v434 - p182.leanStartAt
                v439 = Turn.LeanStartFull
                LeanStartFade = Turn.LeanStartFade

                local v450 = math.clamp((v440 - v439) / (LeanStartFade - v439), 0, 1)

                v433 = 1 - v437 * (1 - v450 * v450 * (3 - 2 * v450))
                v446 = math.min(v448, v433)
            else
                v446 = v448
            end

            v441 = v443 * v446
            v443 = p182.turnResist or 1

            if v443 < v441 then
                v431 = v441 - v443
                v437 = -v413 * Turn.ResistSmooth
                v441 = v443 + v431 * (1 - math.exp(v437))
            end

            v443 = p182.turnStart or 1

            if v443 < v446 then
                v431 = v446 - v443
                v437 = -v413 * Turn.ResistSmooth
                v446 = v443 + v431 * (1 - math.exp(v437))
            end
        else
            v441 = v443
            p182.leanStartIdle = (p182.leanStartIdle or 0) + v413

            if p182.leanStartIdle > Turn.LeanStartReset then
                p182.leanStartAt = nil
            end

            v446 = 1
        end

        p182.turnResist = v441
        p182.turnStart = v446
        v442 = math.abs(v428) > 0.02 and math.sign(v428) or 0

        if v442 == 0 then
            v443 = 1
        else
            v427 = (p182.bodyShift or 0) * v442
            v443 = math.clamp(v427, 0, 1)
        end

        v433 = Weight.UnloadedResponse + (1 - Weight.UnloadedResponse) * v443 - 1
        SpeedHeavyFromKph = Weight.FromKph
        v444 = Weight.FullKph
        v439 = (v417 - SpeedHeavyFromKph) / (v444 - SpeedHeavyFromKph)
        v440 = math.clamp(v439, 0, 1)
        v442 = 1 + v433 * (v440 * v440 * (3 - 2 * v440))
        v427 = math.abs(v428)

        if v427 < math.abs(p182.lean) - 0.01 and v428 * p182.lean >= 0 then
            v427 = Weight.PickUpResponse
            v433 = Weight.PickUpResponseFast - Weight.PickUpResponse
            SpeedHeavyFromKph = Weight.PickUpFromKph
            v444 = Weight.PickUpFullKph
            v439 = (v417 - SpeedHeavyFromKph) / (v444 - SpeedHeavyFromKph)
            v440 = math.clamp(v439, 0, 1)
            v433 = v427 + v433 * (v440 * v440 * (3 - 2 * v440)) - 1
            SpeedHeavyFromKph = Weight.FromKph
            v444 = Weight.FullKph
            v439 = (v417 - SpeedHeavyFromKph) / (v444 - SpeedHeavyFromKph)
            v440 = math.clamp(v439, 0, 1)
            v442 = 1 + v433 * (v440 * v440 * (3 - 2 * v440))
        end

        p182.rollVelocity = p182.rollVelocity or 0
        v427 = v416 * v442
        v431 = -v427

        if v430 then
            if v428 > 0 then
                v427 *= v446
            else
                v431 *= v446
            end
        end

        v437 = (v428 - p182.lean) * v419 * v419 * v441 * v442 - 2 * v419 * p182.rollVelocity

        local SamuraiEdgeResistance = math.clamp(v437, v431, v427)

        if v430 then
            v445 = LookVector * v441
        end

        if not v430 or not v445 then
            v445 = LookVector
        end

        v433 = v445 * math.sqrt(v442)
        v431 = p182.rollVelocity + SamuraiEdgeResistance * v413

        if not (v430 and v433 < math.abs(v431)) then
            SpeedHeavyFromKph = -v433
            v431 = math.clamp(v431, SpeedHeavyFromKph, v433)
        else
            v445 = math.abs(v431)
            v444 = v445 - v433
            LeanStartFade = -v413 * Turn.RollCapEase
            v437 = v445 - v444 * (1 - math.exp(LeanStartFade))
            SpeedHeavyFromKph = LookVector * math.sqrt(v442)
            v445 = math.min(v437, SpeedHeavyFromKph)
            v431 = math.sign(v431) * v445
        end

        p182.rollVelocity = v431
        v433 = p182.lean
        v437 = p182.lean + p182.rollVelocity * v413
        SpeedHeavyFromKph = -Config.MaxLean
        v444 = Config.MaxLean
        p182.lean = math.clamp(v437, SpeedHeavyFromKph, v444)
        v437 = p182.lean

        local v452 = math.abs(v437) < Turn.UprightLean
        local v453

        if v452 then
            v437 = p182.rollVelocity
            v453 = math.abs(v437) < Turn.FlickRollRate
        end

        if not v452 or not v453 then
            if v433 * p182.lean < 0 then
                v437 = p182.rollVelocity

                if math.abs(v437) >= Turn.FlickRollRate then
                    p182.tipFromUpright = false
                end
            end
        else
            p182.tipFromUpright = true
        end
    else
        v442 = -v438.X
        v443 = -v438.Z
        p182.yaw = math.atan2(v442, v443)
        v442 = root.CFrame.RightVector.Y
        v443 = root.CFrame.UpVector.Y
        p182.lean = math.atan2(v442, v443)
    end

    LookVector = CFrame.Angles(0, p182.yaw, 0).LookVector
    v441 = LookVector:Cross((Vector3.new(0, 1, 0)))
    v435 = cast(rootPosition + LookVector * Config.Wheelbase / 2)
    v429 = cast(rootPosition - LookVector * Config.Wheelbase / 2)
    v442 = v435 or v429
    v443, v427 = t1.Contact(p182)
    v431 = v442 ~= nil and math.min(v443, v427) < 0.55

    local v454 = v431 and t1.SurfaceOf(v442) or "Air"

    p182.surface = v454

    local function looseOf(p185) -- line: 1463
        -- upvalues: t1 (copy)
        local v455 = p185 and t1.SurfaceOf(p185)

        if v455 == "Grass" or v455 == "Gravel" then
            return true
        end

        return v455 == "Sand"
    end

    local v456 = false
    local v457 = false
    local v458 = false
    local v459 = false
    local v460 = false

    if v431 then
        v456 = true
    end

    local v461

    if v456 then
        if v435 then
            v457 = true
        else
            v461 = v435
            v458 = true
        end
    end

    v456 = false

    if v457 then
        v461 = t1.SurfaceOf(v435)
        v458 = true
    end

    v457 = false

    local v462

    if v458 then
        if v461 == "Grass" then
            v462 = true
            v456 = true
        else
            v457 = true
        end
    end

    v458 = false

    if v457 then
        if v461 == "Gravel" then
            v462 = true
            v456 = true
        else
            v458 = true
        end
    end

    v457 = false

    if v458 then
        if v461 == "Sand" then
            v459 = true
        else
            v457 = true
        end
    end

    v458 = false

    if v457 then
        v462 = false
        v456 = true
    end

    v457 = false

    if v459 then
        v462 = true
        v456 = true
    end

    v459 = false

    local v463

    if v456 then
        if v462 then
            v463 = v462
            v460 = true
        else
            v459 = true
        end
    end

    v456 = false

    local v464

    if v459 then
        if v429 then
            v456 = true
        else
            v464 = v429
            v457 = true
        end
    end

    v459 = false

    if v456 then
        v464 = t1.SurfaceOf(v429)
        v457 = true
    end

    v456 = false

    local v465

    if v457 then
        if v464 == "Grass" then
            v465 = true
            v459 = true
        else
            v456 = true
        end
    end

    v457 = false

    if v456 then
        if v464 == "Gravel" then
            v465 = true
            v459 = true
        else
            v457 = true
        end
    end

    v456 = false

    if v457 then
        if v464 == "Sand" then
            v458 = true
        else
            v456 = true
        end
    end

    if v456 then
        v465 = false
        v459 = true
    end

    if v458 then
        v465 = true
        v459 = true
    end

    if v459 then
        if v465 then
            v463 = v465
            v460 = true
        else
            v460 = false
        end
    end

    p182.anyLoose = not not v460 and v463

    if v431 then
        v445 = v443 < 0.18 and t1.IsKerb(v435)
        v462 = v427 < 0.18 and t1.IsKerb(v429)
    else
        v462 = v431
        v445 = v431
    end

    p182.onKerb = v445 or v462
    v461, v444 = t1.RoughSurface(p182, v413, v454, Magnitude, v431, nil, v435, v429)
    v462 = v431 and (v454 == "Grass" or v454 == "Gravel" or v454 == "Sand")
    p182.looseAsWet = v462
    v445 = Config.Grip * v421.Grip

    local v466, v467, smoothThrottle

    if v431 then
        local v468, v469

        if v435 and v443 < 0.55 then
            v440 = t1.RunoffGripOf(v435)

            if v440 then
                v468 = v440
                v469 = true
            else
                v469 = false
            end
        else
            v469 = false
        end

        if not v469 then
            v468 = nil
        end

        local v470 = false

        if v429 and v427 < 0.55 then
            v439 = t1.RunoffGripOf(v429)

            if v439 then
                smoothThrottle = v439
                v470 = true
            end
        end

        if not v470 then
            smoothThrottle = nil
        end

        local v471 = false

        if v468 and smoothThrottle then
            LeanStartFade = (v468 + smoothThrottle) / 2

            if LeanStartFade then
                v466 = LeanStartFade
                v471 = true
            end
        end

        if not v471 then
            v466 = v468 or smoothThrottle or 1
        end

        v445 *= v466
        p182.runoffGrip = v466
        v468 = not p182.onKerb
        v467 = v468 and (v443 < 0.18 and t1.RunoffGripOf(v435) < 1 or v427 < 0.18 and t1.RunoffGripOf(v429) < 1)
    else
        v467 = v431
    end

    p182.onRunoff = v467
    v467 = script.Parent:GetAttribute("Raining") == true
    smoothThrottle = v467 or v462
    p182.wet = smoothThrottle
    v466 = script.Parent:GetAttribute("TrackWetness")

    if typeof(v466) == "number" then
        p182.wetAmount = if v462 then 1 else math.clamp(v466, 0, 1)
        v445 *= 1 - (1 - (Config.RainGrip or 0.72)) * p182.wetAmount

        if v462 then
            v445 *= 1 - (1 - t1.LooseRainGrip) * math.clamp(v466, 0, 1)
        end
    else
        p182.wetAmount = smoothThrottle and 1 or 0

        if smoothThrottle then
            v445 *= Config.RainGrip or 0.72
        end

        if v462 and v467 then
            v445 *= t1.LooseRainGrip
        end
    end

    v445 *= script.Parent:GetAttribute("WeatherGrip") or 1

    local v473

    if result then
        local GripOf

        GripOf, v473 = result.GripOf(p182.root and p182.root.Parent, smoothThrottle, p182.lean)
        p182.tyreF = GripOf
        p182.tyreR = v473
        p182.tyreWornR = result.RearWornOf(p182.root and p182.root.Parent, p182.lean)
    else
        p182.tyreF = 1
        p182.tyreR = 1
        p182.tyreWornR = 0
    end

    if v462 then
        v466 = p182.root and p182.root.Parent

        if not (result and result.LooseGripOf) then
            if not (v466 and v466:GetAttribute("TyreFront")) then
                local v474 = result and result.Compounds and result.Compounds[result.Default or "Medium"]
                local WetGrip = if v474 then v474.WetGrip else nil

                if not v474 or not WetGrip then
                    WetGrip = 0.8
                end

                p182.tyreF = WetGrip
                p182.tyreR = WetGrip
            end
        else
            local WetGrip

            WetGrip, v473 = result.LooseGripOf(v466, p182.lean)
            p182.tyreF = WetGrip
            p182.tyreR = v473
        end
    end

    v473 = p182.tyreF

    local v475, v476

    if result and result.Temp then
        local ColdTuck = result.Temp.ColdTuck

        if ColdTuck then
            v475 = ColdTuck
            v476 = true
        else
            v476 = false
        end
    else
        v476 = false
    end

    if not v476 then
        v475 = 0
    end

    local v477, v478

    if result and result.ColdOf then
        local ColdOf = result.ColdOf(p182.root and p182.root.Parent, "F", p182.lean)

        if ColdOf then
            v477 = ColdOf
            v478 = true
        else
            v478 = false
        end
    else
        v478 = false
    end

    if not v478 then
        v477 = 0
    end

    p182.tyreFBrake = v473 * (1 - v475 * v477)
    v462 = p182.root and p182.root.Parent

    local smoothBrake = result

    if result then
        smoothBrake = smoothThrottle and v431 and v454 == "Asphalt" and v462 and v462:GetAttribute("TyreFront")
    end

    local v479 = typeof(smoothBrake) == "string" and smoothBrake ~= "Wet"
    local v480 = if v431 and (v454 == "Grass" or v454 == "Gravel" or v454 == "Sand") then true else v479

    v473 = v445 * (p182.tyreF or 1)
    p182.slickWet = v480

    local v481 = 0

    if v480 then
        v477 = math.tan(p182.lean)
        v481 = math.abs(v477) / math.max(v473, 0.05) or 0
    end

    p182.wetSlickOver = v481
    v475 = p182.root and p182.root.Parent
    v477 = result and v475 and result.Compounds and result.Compounds[v475:GetAttribute("TyreRear") or ""]

    local smoothRearBrake = 1

    if v477 then
        smoothBrake = not smoothThrottle and v477.Grip or 1
        smoothRearBrake = if result.WearFactor then result.WearFactor(v475:GetAttribute("TyreRear"), result.WearOf and result.WearOf(v475, "R", p182.lean) or v475:GetAttribute("TyreWearR")) else 1
    else
        smoothBrake = 1
    end

    v477 = math.clamp(math.abs(p182.lean or 0) / 0.7853981633974483, 0, 1)

    local WearFactor = 0.25 + 0.75 * v477
    local WearDriveUpright = result and result.WearDriveUpright or 1
    local v482 = WearDriveUpright + (1 - WearDriveUpright) * v477

    p182.tyreRDrive = p182.tyreR / smoothBrake * ((smoothBrake - 1) * WearFactor + 1) / math.max(smoothRearBrake, 0.05) * (1 + (smoothRearBrake - 1) * v482)

    local v483 = if result and v475 and result.Compounds and result.Compounds[v475:GetAttribute("TyreFront") or ""] and result.WearFactor then result.WearFactor(v475:GetAttribute("TyreFront"), result.WearOf and result.WearOf(v475, "F", p182.lean) or v475:GetAttribute("TyreWearF")) else 1
    local v484 = result and result.WearBrakeUpright or 1

    p182.tyreFBrakeGrip = (p182.tyreF or 1) / math.max(v483, 0.05) * (1 + (v483 - 1) * (v484 + (1 - v484) * v477))
    smoothThrottle = p182.smoothThrottle
    smoothBrake = p182.smoothBrake
    smoothRearBrake = p182.smoothRearBrake
    v475 = AssemblyLinearVelocity:Dot(LookVector)
    v477 = not root:GetAttribute("NoReverse")

    local v485, v486

    if v477 then
        v477 = not p182.exitHold

        if v477 then
            v477 = not p182.exitRequested

            if v477 then
                if v431 then
                    if (p182.brake or 0) > 0.5 and (p182.throttle or 0) < 0.05 then
                        if v417 < 4.5 then
                            v486 = true
                        elseif p182.paddling == true and v475 < 0 then
                            v485 = Config.PaddleSpeedKph or 5
                            v486 = v417 < v485 + 3
                        else
                            v486 = false
                        end
                    else
                        v486 = false
                    end
                else
                    v486 = v431
                end
            else
                v486 = v477
            end
        else
            v486 = v477
        end
    else
        v486 = v477
    end

    p182.paddleHold = v486 and (p182.paddleHold or 0) + v413 or 0
    p182.paddling = p182.paddleHold > 0.35

    if p182.paddling then
        smoothBrake = 0
    end

    v475 = t1.Burnout(p182, smoothThrottle * (1 - p182.clutchBlend), smoothBrake, smoothRearBrake, v454, v431, v427, v413)
    v486 = -p182.smoothSteer * v475 * 0.75 * math.clamp((18 - v417) / 12, 0, 1)
    v484 = (p182.bodyShift or 0) * math.sign(p182.lean)
    v485 = math.clamp(v484, 0, 1)

    local v488 = p182.lean
    local Instance = math.abs(v488) / 0.3490658503988659
    local v487 = v485 * math.clamp(Instance, 0, 1)

    v485 = Weight.YawGain * (1 + Weight.HangOffYawBonus * v487) * (1 - t1.LooseLean.WashTurnLoss * (p182.washVisual or 0))

    if p182.kerbSlideMode == "Front" then
        v485 *= 1 - t1.KerbEdge.WashTurnLoss * (p182.kerbWashVisual or 0)
    end

    local SamuraiOversteerFromKph, SamuraiOversteerLeanFrom, FadeToKph, v489, v490, v491, v492

    if v422 == "SharpLean" then
        v484 = t1.Legend
        v488 = p182.lean

        local TyreFront = math.abs(v488)

        v489 = t1.LeanAuthority(v417, v422)
        Instance = TyreFront / math.max(v489, 0.01)

        if v431 then
            SamuraiOversteerFromKph = v484.SamuraiOversteerFromKph
            SamuraiOversteerLeanFrom = v484.SamuraiOversteerFullKph
            FadeToKph = (v417 - SamuraiOversteerFromKph) / (SamuraiOversteerLeanFrom - SamuraiOversteerFromKph)
            v490 = math.clamp(FadeToKph, 0, 1)
            v488 = v490 * v490 * (3 - 2 * v490)
            SamuraiOversteerLeanFrom = v484.SamuraiOversteerLeanFrom
            v490 = v484.SamuraiOversteerLeanFull
            v491 = (Instance - SamuraiOversteerLeanFrom) / (v490 - SamuraiOversteerLeanFrom)
            FadeToKph = math.clamp(v491, 0, 1)
            v492 = v488 * (FadeToKph * FadeToKph * (3 - 2 * FadeToKph))
        end

        if not v431 or not v492 then
            v492 = 0
        end

        v485 *= 1 + v484.SamuraiOversteerYaw * v492
    else
        v492 = 0
    end

    p182.oversteer = v492
    v487 = t1.SlideRotate
    v484 = p182.rearYaw or 0

    local v493

    if v431 and not p182.paddling and v484 * p182.lean > 0 then
        v492 = math.abs(v484) / (Config.RearYaw * v487.FullAt)
        Instance = math.clamp(v492, 0, 1)
        v489 = 1 - v487.HighSpeedKeep
        v490 = v487.FadeFromKph
        FadeToKph = v487.FadeToKph
        v493 = (v417 - v490) / (FadeToKph - v490)
        v491 = math.clamp(v493, 0, 1)
        v492 = 1 - v489 * (v491 * v491 * (3 - 2 * v491))
        v489 = v487.Gain * Instance * v492
        v490 = v487.MinKph
        FadeToKph = v487.MinKph + 20
        v493 = (v417 - v490) / (FadeToKph - v490)
        v491 = math.clamp(v493, 0, 1)
        p182.slideRotate = v489 * (v491 * v491 * (3 - 2 * v491))
        v485 *= 1 + p182.slideRotate
    else
        p182.slideRotate = 0
    end

    if v431 and not p182.paddling then
        v492 = t1.FrontLight.TurnLoss
        v489 = p182.frontLight or 0
        v485 *= 1 - v492 * math.clamp(v489, 0, 1)
    end

    v489 = p182.lean
    v484 = math.tan(v489) * Config.Gravity / math.max(Magnitude, 20) * v485

    if v480 then
        Instance = v473 * t1.WetSlick.TurnHold * Config.Gravity / math.max(Magnitude, 20) * v485

        if Instance < math.abs(v484) then
            v484 = math.sign(v484) * Instance
        end
    end

    if Magnitude < 25 then
        v488 = p182.smoothSteer
        SamuraiOversteerFromKph = Magnitude / 25
        v484 -= v488 * math.clamp(SamuraiOversteerFromKph, 0, 1) * 0.17
    end

    if p182.paddling then
        v492 = p182.smoothSteer
        v489 = Magnitude / 1.2
        v484 = v492 * math.clamp(v489, 0, 1) * 0.45
    end

    local v494, v495

    if p182.paddling then
        v495 = true
    elseif p184 then
        v492 = Weight.YawBuildSeconds
        v489 = Weight.YawBuildSecondsFast - Weight.YawBuildSeconds
        FadeToKph = (v417 - 40) / 240
        v490 = math.clamp(FadeToKph, 0, 1)
        v494 = (v492 + v489 * (v490 * v490 * (3 - 2 * v490))) * math.sqrt(v424)

        if v422 == "SharpLean" then
            v494 *= t1.Legend.SamuraiYawBuild
        end

        v495 = false
    else
        v495 = true
    end

    if v495 then
        p182.yawRateBuilt = v484
    else
        v473 = p182.yawRateBuilt or v484

        if v473 ~= v473 then
            v473 = v484
        end

        v488 = v484 - v473
        SamuraiOversteerLeanFrom = -v413 / math.max(v494, 0.01)
        p182.yawRateBuilt = v473 + v488 * (1 - math.exp(SamuraiOversteerLeanFrom))
        v484 = p182.yawRateBuilt
    end

    v484 += v444 * 0.035 + v486

    if (p182.washVisual or 0) > 0 then
        SamuraiOversteerFromKph = os.clock() * 19
        v484 += math.sin(SamuraiOversteerFromKph) * t1.LooseLean.WashWobble * p182.washVisual * 0.12
    end

    if p182.kerbSlideMode == "Front" and (p182.kerbWashVisual or 0) > 0.01 then
        SamuraiOversteerFromKph = os.clock() * 23
        v484 += math.sin(SamuraiOversteerFromKph) * t1.KerbEdge.WashWobble * p182.kerbWashVisual * 0.12
    end

    if (p182.gripWobble or 0) > 0 and v431 then
        v489 = os.clock() * 16
        v484 += math.sin(v489) * t1.GripReturn.WobbleYaw * p182.gripWobble
    end

    if p184 and v431 then
        p182.yaw += v484 * v413
    end

    v489 = p182.brake

    if math.max(smoothBrake, smoothRearBrake, v489, p182.rearBrake or 0) > 0.045 then
        p182.rhd = false
    end

    v484 = smoothThrottle ^ (1 + (v414 - 1) * 0.08)
    v480 = p182.onKerb or p182.onRunoff
    v492 = 1 - p182.clutchBlend

    local v496, v497

    if p182.onKerb then
        v488 = t1.KerbDrag.Kerb.Throttle

        if v488 then
            v496 = v488
            v497 = true
        elseif p182.onRunoff then
            v488 = t1.KerbDrag.Runoff.Throttle

            if v488 then
                v496 = v488
                v497 = true
            else
                v497 = false
            end
        else
            v497 = false
        end
    elseif p182.onRunoff then
        v488 = t1.KerbDrag.Runoff.Throttle

        if v488 then
            v496 = v488
            v497 = true
        else
            v497 = false
        end
    else
        v497 = false
    end

    if not v497 then
        v496 = 1
    end

    v484 *= v492 * v496

    if Magnitude > 1 then
        v492 = workspace:Raycast(rootPosition + Vector3.new(0, 0.6, 0), AssemblyLinearVelocity.Unit * (Magnitude * v413 + Config.Wheelbase / 2 + 0.7), v22)

        if v492 and v492.Instance:GetAttribute("Surface") == "Barrier" then
            Instance = v492.Instance

            if p184 and Magnitude < t1.WallCrashSpeed() then
                v489 = AssemblyLinearVelocity.Y
                root.AssemblyLinearVelocity = Vector3.new(0, v489, 0)
            end

            v424 = true
        else
            v424 = false
            Instance = nil
        end
    else
        v424 = false
        Instance = nil
    end

    if v424 then
        v492 = nil
        smoothBrake = 1
        v484 = 0
    elseif t1.WallCrashSpeed() <= Magnitude then
        v492 = t1.WallContact(p182)
        Instance = v492 or Instance
    else
        v492 = nil
    end

    if not p182.clutch then
        BikeGearbox.Automatic(p182, v417, os.clock())
    end

    v496 = BikeGearbox.Ratio(p182.gear)
    v489 = v421.TopSpeedKph / Config.TopSpeedKph
    SamuraiOversteerFromKph = if p182.gear == 0 then 0 else BikeGearbox.Limits[p182.gear] * (p182.gear == 6 and v489 or 1) + (p182.gear == 6 and p182.slipTopKph or 0)
    SamuraiOversteerLeanFrom = (if p182.gear == 0 then 1 else SamuraiOversteerFromKph + 5.85) / (Config.StudMetres * 3.6)

    local v498 = PitLimiter.Contains(rootPosition)

    p182.inPit = v498
    v490 = PitLimiter.LimitKph / (Config.StudMetres * 3.6)

    if v498 and p182.gear > 0 then
        SamuraiOversteerLeanFrom = math.min(SamuraiOversteerLeanFrom, v490)
    end

    local v499 = t1.AccelShapeAt(v417)
    local v500, v501

    if p182.gear == 0 then
        v491 = 0
    else
        v500 = v484 * Config.EngineAcceleration * BikeGearbox.Drive(p182.gear, v417)
        v501 = (SamuraiOversteerLeanFrom - Magnitude) / 8
        v491 = v500 * math.clamp(v501, 0, 1) * v499
    end

    local v502

    if p182.gear == 6 and Config.TopGearTau then
        SamuraiOversteerLeanFrom = (BikeGearbox.Limits[6] * v489 + (p182.slipTopKph or 0)) / (Config.StudMetres * 3.6)
        v502 = (1E-04 * Magnitude * Magnitude + 0.025 * Magnitude) * (1 - (p182.slipDrag or 0)) + (SamuraiOversteerLeanFrom - Magnitude) / Config.TopGearTau * 1.8 * v499
        v501 = v484 * math.max(0, v502)
        v491 = math.min(v491, v501)
    end

    local v503 = BikeStats.AccelFadeFromKph

    v501 = BikeStats.AccelFadeToKph

    local FrontLight = math.clamp((v417 - v503) / (v501 - v503), 0, 1)

    v499 = 1 - FrontLight * FrontLight * (3 - 2 * FrontLight)
    v491 *= 1 + (v421.Accel - 1) * v499
    v489 = p182.wetAmount

    if not v489 then
        v489 = if p182.wet then 1 else 0
    end

    if v489 > 0 then
        v491 *= 1 - (1 - (Config.RainEngine or 0.82)) * v489
    end

    local v505

    if p182.paddling then
        v421 = (Config.PaddleSpeedKph or 5) / (Config.StudMetres * 3.6)
        v500 = p182.reverseDrive or 0
        v501 = 1 - (p182.reverseDrive or 0)
        v502 = -v413 * 3
        p182.reverseDrive = v500 + v501 * (1 - math.exp(v502))
        v505 = 4 * p182.reverseDrive
        v503 = (v421 - Magnitude) / 1.5
        v491 = v505 * math.clamp(v503, 0, 1)
    else
        p182.reverseDrive = 0
    end

    v491 *= BikeGearbox.DriveCut(p182, os.clock())

    if p182.gear > 0 and (p182.clutchLaunch or 0) > 0 then
        v491 *= 1 + p182.clutchLaunch * 0.6 * (1 - p182.clutchBlend)
    end

    v491 *= 1 - v475 * 0.8
    v505 = ({ 0, 0.28, 0.65, 0.93, 1 })[v418]
    v500 = math.clamp(p182.rhdBlend or 0, 0, 1)
    v503 = t1.WheelieLiftDemand(v491, v417, p182.lean, v498)
    v501 = v505 * math.clamp(v503 * 0.28, 0, 0.26)
    FrontLight = t1.FrontLight

    local v506, v507, v508, v509, v510, TCSDrive, v511
    local v504 = 0

    if not v431 or v498 then
    elseif p182.gear > 0 and smoothThrottle > 0.3 and smoothBrake < 0.05 then
        v508 = p182.lean
        v502 = math.abs(v508)
        v509 = FrontLight.LeanFrom
        v510 = math.rad(v509)
        TCSDrive = FrontLight.LeanFull
        v509 = math.rad(TCSDrive)
        v511 = (v502 - v510) / (v509 - v510)
        TCSDrive = math.clamp(v511, 0, 1)
        v506 = TCSDrive * TCSDrive * (3 - 2 * TCSDrive)
        v511 = FrontLight.LeanFadeFrom
        TCSDrive = math.rad(v511)
        v511 = math.rad(FrontLight.LeanFadeTo)
        v507 = (v502 - TCSDrive) / (v511 - TCSDrive)

        local LeanFadeTo = math.clamp(v507, 0, 1)

        v508 = v506 * (1 - LeanFadeTo * LeanFadeTo * (3 - 2 * LeanFadeTo))
        v509 = t1.WheelieLiftDemand(v491, v417, 0, v498) / FrontLight.FullDemand
        v504 = math.clamp(v509, 0, 1) * v508 * (1 - v505) * (1 - v500 * FrontLight.RHDShare)
    end

    v502 = p182.frontLight or 0

    local v512 = v504 - v502

    TCSDrive = -v413 / (v502 < v504 and FrontLight.Rise or FrontLight.Fall)
    p182.frontLight = v502 + v512 * (1 - math.exp(TCSDrive))
    v491 *= (1 - v501) * (v500 * 0.035 + 1)

    local Legend, v513, v514, v515

    if v491 > 0 then
        FrontLight = t1.WheelieDrive
        v506 = p182.wheeliePitch or 0
        v510 = FrontLight.FreeDeg
        v508 = v506 - math.rad(v510)
        v504 = math.max(0, v508)
        v510 = FrontLight.FullDeg - FrontLight.FreeDeg
        v508 = v504 / math.rad(v510) * FrontLight.FullLoss
        v512 = FrontLight.MaxLoss
        v502 = math.clamp(v508, 0, v512)

        if v422 == "WheelieBoost" and v431 then
            Legend = t1.Legend
            v506 = ((p182.wheeliePitch or 0) - Legend.EmperorWheelieFrom) / (Legend.EmperorWheelieFull - Legend.EmperorWheelieFrom)
            v513 = math.clamp(v506, 0, 1)
            v514 = if (p182.wheeliePitch or 0) > Legend.EmperorWheelieFrom then v502 * (1 - Legend.EmperorLossKeep) else v502
            v515 = 1 + Legend.EmperorWheelieDrive * v513
        else
            v514 = v502
            v515 = 1
        end

        v491 *= (1 - v514) * v515
    end

    Legend = math.abs(math.tan(p182.lean) * Config.Gravity)
    v514 = math.clamp((110 - v417) / 90, 0, 1)
    v513 = if p182.gear <= 2 then 1 else 0.35
    v515 = v514 * v513
    v514 = v491 * (1.12 + 0.48 * v515) * (1 + (5 - v414) * 0.1)

    local function floorOf(p186, p187) -- line: 1740
        -- upvalues: p182 (copy), result (ref)
        if not result then
            return 1
        end

        if result.FloorAt then
            return result.FloorAt(p186, p187, p182.lean)
        end

        return result.Floor(p186, p187)
    end

    local v516, v517

    if v454 == "Asphalt" or p182.looseAsWet then
        v512 = v445 * p182.tyreF * Config.Gravity
        v509 = Legend * 1.08
        v511 = p182.tyreF
        TCSDrive = if not result then 1 elseif result.FloorAt then result.FloorAt(v511, "Front", p182.lean) else result.Floor(v511, "Front")
        v510 = v509 * TCSDrive
        v506 = math.max(v512, v510)

        if v506 then
            v516 = v506
            v517 = true
        else
            v517 = false
        end
    else
        v517 = false
    end

    if not v517 then
        v516 = v445 * p182.tyreF * Config.Gravity
    end

    v509 = v445 * (p182.tyreRDrive or p182.tyreR) * Config.Gravity

    local v519 = math.sin(p182.lean)

    v510 = v509 * (0.96 - 0.22 * math.abs(v519))

    local Rise, v520, v521

    if v454 == "Asphalt" or p182.looseAsWet then
        TCSDrive = Legend * 1.03
        Rise = p182.tyreR
        v511 = if not result then 1 elseif result.FloorAt then result.FloorAt(Rise, "Rear", p182.lean) else result.Floor(Rise, "Rear")
        v509 = TCSDrive * v511

        if v509 then
            v520 = v509
            v521 = true
        else
            v521 = false
        end
    else
        v521 = false
    end

    if not v521 then
        v520 = 0
    end

    v512 = math.max(v510, v520)

    if v431 and smoothThrottle > 0.025 then
        v507 = Legend * Legend + v514 * v514
        TCSDrive = math.sqrt(v507) / math.max(v512, 1) - 1

        local _ = not not math.max(0, TCSDrive)
    end

    v510, v520 = t1.TractionResponse(Legend, v514, v512, v414)
    TCSDrive = t1.TCSDrive
    v511 = t1.TCSFeel(Config.TCS or 4)
    Rise = v491 * (1.12 + 0.48 * v515) * (1 + (5 - v511) * 0.1)

    local v522, v523, v524

    if v431 and smoothThrottle > 0.025 then
        v522 = Legend * Legend + Rise * Rise
        v519 = math.sqrt(v522) / math.max(v512, 1) - 1
        v507 = math.max(0, v519)

        if v507 then
            v523 = v507
            v524 = true
        else
            v524 = false
        end
    else
        v524 = false
    end

    if not v524 then
        v523 = 0
    end

    local v525 = t1.TractionResponse(Legend, Rise, v512, v511)
    local v518 = v523 * t1.TCSPick({ 0.44, 0.34, 0.24, 0.15, 0.07, 0 }, v511)
    local v526 = 1 - v511

    v522 = 0.2 + math.clamp(v526, 0, 1) * 0.04
    v519 = math.clamp(v518, 0, v522)

    local v527 = p182.tcs or Config.TCS or 4

    v518 = math.round(v527)
    p182.tcsLevel = math.clamp(v518, 1, 5)

    local v528, v529

    if p182.wet then
        v511 = 1
    else
        v518 = p182.lean
        v528 = math.abs(v518)
        v518 = TCSDrive.LeanFrom
        v527 = TCSDrive.LeanFull
        v529 = (v528 - v518) / (v527 - v518)
        v522 = math.clamp(v529, 0, 1)
        v511 = v522 * v522 * (3 - 2 * v522)
    end

    local v530, v531, v532

    if v431 and smoothThrottle > 0.025 then
        v530 = Legend * Legend + v514 * v514
        v527 = math.sqrt(v530) / math.max(v512, 1) - 1
        v528 = math.max(0, v527)

        if v528 then
            v531 = v528
            v532 = true
        else
            v532 = false
        end
    else
        v532 = false
    end

    if not v532 then
        v531 = 0
    end

    v527 = v531 * t1.TCSPick({ 0.44, 0.34, 0.24, 0.15, 0.07, 0 }, v414)

    local RearSkid = 1 - v414

    v529 = 0.2 + math.clamp(RearSkid, 0, 1) * 0.04
    v518 = math.clamp(v527, 0, v529)
    v531 = v525 + (v510 - v525) * v511
    v525 = v519 + (v518 - v519) * v511

    local v533 = p182.wet and TCSDrive.Wet[p182.tcsLevel] * math.clamp(v523, 0, 1) or 0

    p182.spinLoss = v525
    p182.tcsDriveLoss = 1 - (1 - v531) * (1 - v525) * (1 + v533)
    v491 *= 1 - p182.tcsDriveLoss

    local v534 = if v431 and smoothThrottle > 0.025 and v520 then v520 else 0

    if result and (p182.tyreWornR or 0) > 0 and v431 and (v454 == "Asphalt" or p182.looseAsWet) then
        v531 = Legend / math.max(v512, 1) - 1
        Rise = math.max(0, v531) * (result.LateralSlide or 1)
        v534 = math.max(v534, Rise)
    end

    p182.driveThrottle = v484 * (1 - v501) * (1 - v510)
    v512 = t1.SlideHold
    v511 = p182.lean
    TCSDrive = math.abs(v511)

    if (p182.slip or 0) > 0.05 then
        v511 = p182.slidePeakLean or 0
        p182.slidePeakLean = math.max(v511, TCSDrive)
    elseif (p182.slip or 0) < 0.02 then
        p182.slidePeakLean = TCSDrive
    end

    v515 = (p182.slidePeakLean or TCSDrive) - TCSDrive
    v534 = math.abs(p182.rearYaw or 0) / math.max(Config.RearYaw, 0.001)
    v523 = v512.LeanFrom
    v525 = v512.LeanFull
    v531 = math.clamp((TCSDrive - v523) / (v525 - v523), 0, 1)
    v511 = v531 * v531 * (3 - 2 * v531)
    v514 = v511 > 0
    v525 = v512.Active - v512.Band
    v531 = v512.Active + v512.Band
    v527 = (v534 - v525) / (v531 - v525)
    v533 = math.clamp(v527, 0, 1)
    Rise = v533 * v533 * (3 - 2 * v533)

    if v514 and Rise > 0 then
        v525 = v512.SlowRecover
        v527 = v512.PickFrom
        v522 = v512.PickFull
        v530 = (v515 - v527) / (v522 - v527)
        v529 = math.clamp(v530, 0, 1)
        v531 = v529 * v529 * (3 - 2 * v529)
        v523 = math.max(v525, v531)
        v520 = 1 - Rise * v511 * (1 - v523)
    else
        v520 = 1
    end

    v511 = t1.GripReturn

    local n2 = 0

    if t1.PrivateFeatures() then
        v533 = v511.OffFrom
        v527 = v511.OnFrom
        v529 = (smoothThrottle - v533) / (v527 - v533)
        v522 = math.clamp(v529, 0, 1)
        n2 = 1 - v522 * v522 * (3 - 2 * v522) or 0
    end

    p182.gripGasOff = n2
    v525 = p182.gripThrottle or smoothThrottle

    local v535

    if v525 <= smoothThrottle then
        v535 = smoothThrottle
    else
        v527 = smoothThrottle - v525
        v530 = -v413 * v511.ReleaseRate
        v535 = v525 + v527 * (1 - math.exp(v530))
    end

    p182.gripThrottle = v535
    v529 = v525 - v535
    v533 = math.max(0, v529) / math.max(v413, 0.001)

    if n2 < 0.5 then
        p182.gripCloseRate = 0
    else
        v522 = p182.gripCloseRate or 0
        p182.gripCloseRate = math.max(v522, v533)
    end

    p182.driveRecover = v520 * (1 - n2) + n2 * v511.Recover * (1 + v511.SizeBoost * math.clamp(v534, 0, 1.5))

    if v431 then
        if v512.MinKph < v417 then
            if v514 then
                v514 = Rise > 0 and v515 < v512.PickFrom and n2 < 0.5
            end
        else
            v514 = false
        end
    else
        v514 = v431
    end

    v531 = p182.slideCreep or 0

    local v536, v537

    if v514 then
        v522 = v512.MaxCreep
        v526 = Rise * v512.Grow * v534
        v537 = v512.InputBoost
        v536 = smoothThrottle or 0
        v529 = v531 + v526 * (1 + v537 * math.max(v536, smoothRearBrake or 0)) * v413
        v531 = math.min(v522, v529)
    else
        v522 = -v413 * v512.CreepDecay
        v531 *= math.exp(v522)
    end

    p182.slideCreep = v531
    p182.slideHoldRecover = v520
    v534 = t1.RearLock
    n2 = v445 * (p182.tyreR or 1) * Config.Gravity
    v531 = v534.CapacityFloor
    Rise = n2 * math.max(v531, 0.33 - 0.18 * smoothBrake)
    v533 = 1 - (Legend / math.max(v445 * Config.Gravity, 1)) ^ 2
    v525 = math.max(0.08, v533)
    v511 = Rise * math.sqrt(v525)
    Rise = smoothRearBrake * Config.RearBrakeAcceleration * ({ 0.65, 0.82, 1, 1.18, 1.38 })[v415]

    local v539, v540

    if v431 and (p182.stoppiePitch or 0) <= t1.RearSkid.AirPitch then
        v531 = (v417 - 12) / 25
        v525 = math.clamp(v531, 0, 1)
        v527 = Rise / math.max(v511, 1) - v534.Margin
        n2 = v525 * math.max(0, v527)

        if n2 then
            v539 = n2
            v540 = true
        else
            v540 = false
        end
    else
        v540 = false
    end

    if not v540 then
        v539 = 0
    end

    v531 = p182.rearBrakeSlip or 0
    p182.rearBrakeSlip = v531 + (v539 - (p182.rearBrakeSlip or 0)) * (1 - math.exp(-v413 * ((p182.rearBrakeSlip or 0) < v539 and v534.BuildRate * (t1.RearBrakeSlideEBS.Rate[v415] or 1) or v520 * 10)))
    v539 = v431 and v454 == "Asphalt" and p182.gear > 0 and not v498
    v525 = math.max(smoothBrake, smoothRearBrake)

    if v539 then
        v534 = false

        if v418 <= 2 and smoothThrottle > 0.8 and v525 < 0.1 then
            v531 = p182.lean

            if math.abs(v531) < 0.22 and v417 > 8 and v417 < 250 then
                v534 = p182.gear <= 4
            end
        end
    else
        v534 = v539
    end

    local v541 = if v534 then (p182.wheelieHold or 0) + v413 else nil

    if not v534 or not v541 then
        v533 = (p182.wheelieHold or 0) - v413 * 4
        v541 = math.max(0, v533)
    end

    p182.wheelieHold = v541
    v534 = ({ 1.55, 0.95, 0.32, 0.08, 0.02 })[v418]
    p182.liftLoad = (p182.liftLoad or 0) + (v503 - (p182.liftLoad or 0)) * (1 - math.exp(-v413 * 4))
    v531 = (p182.wheelieHold or 0) / (0.45 * (1 + v500 * t1.RHDWheelie.Ramp))
    v541 = math.clamp(v531, 0, 1)
    v527 = p182.liftLoad * 0.72 * (1 - v505 * 0.98) * (1 - v510) * (1 - v525)

    if not (v418 <= 2) or not v541 then
        v541 = 1
    end

    v541 = v527 * v541 * smoothThrottle * (1 - v500 * t1.RHDWheelie.Lift)

    local v542, v543

    if v418 <= 2 and v417 < 110 and p182.gear <= 2 then
        v527 = p182.wheelieHold - 0.85 * (1 + v500 * t1.RHDWheelie.Balance)
        v531 = math.max(0, v527)
        v533 = if v418 == 1 then 0.68 else 0.3
        v503 = v531 * v533

        if v503 then
            v542 = v503
            v543 = true
        else
            v543 = false
        end
    else
        v543 = false
    end

    if not v543 then
        v542 = 0
    end

    if smoothThrottle < 0.3 or (p182.throttle or 0) < 0.3 or v417 < 8 then
        p182.wheelieSpent = false
    end

    if p182.wheelieSpent then
        v542 = 0
        v541 = 0
        p182.wheelieHold = 0
    end

    v533 = p182.lean

    if math.abs(v533) > 0.35 then
        v505 = true
    else
        v533 = p182.steer
        v505 = math.abs(v533) > 0.55
    end

    v533 = math.clamp(root.CFrame.LookVector.Y, -1, 1)
    v531 = math.asin(v533)

    if v505 then
        v522 = p182.wheeliePitch or 0
        v505 = math.max(v522, v531) <= Config.WheelieCornerCrashPitch
    end

    local v544 = math.clamp(p182.manualWheelie or 0, 0, 1)

    v527 = math.clamp(p182.manualStoppie or 0, 0, 1)

    local v545 = v539

    if v539 then
        v545 = not v505

        if v545 then
            v529 = p182.lean
            v545 = math.abs(v529) < 0.35 and p182.throttle > 0.08 and v525 < 0.15 and Magnitude > 8
        end
    end

    local v546, v547

    if v545 then
        v529 = (v541 + v542) * (1 - v500 * t1.RHDWheelie.Target)
        v547 = v534 * (1 - v500 * t1.RHDWheelie.Cap)
        v546 = math.clamp(v529, 0, v547) or 0
    else
        v546 = 0
    end

    v529 = t1.WheelieSpeedFactor(v417)

    if v545 and v544 > 0.05 then
        v542 = v544 * v529 * smoothThrottle * 1.0122909661567112 * (1 - v500 * 0.35) * ({ 1, 0.72, 0.35, 0.09, 0.02 })[v418]
        v534 = math.max(v534, v542)
        v546 = math.max(v546, v542)
    end

    v541 = p182.wheeliePitch or 0
    v418 = p182.wheelieVelocity or 0
    v529 = math.asin((math.clamp(root.CFrame.LookVector.Y, -1, 1)))
    v530 = not v545

    if not v530 then
        v530 = p182.throttle < 0.12 or v525 > 0.15 or v546 + 0.04 < v541
    end

    v545 = v541 > 0.02 or (BikeSuspension.ArmClearance or 0.32) < v443

    if v529 > 0.035 and v443 > 0.045 and v530 and v545 then
        p182.wheelieReturning = true
    end

    if v443 <= 0.045 or v529 <= 0 or not v431 then
        p182.wheelieReturning = false
    end

    if p182.wheelieReturning and (p182.wheeliePeak or 0) > 0.08 and smoothThrottle > 0.5 and v544 < 0.05 then
        p182.wheelieSpent = true
    end

    p182.pitchFallAcceleration = nil

    local v548, v549, v550

    if p182.wheelieReturning then
        v547 = math.max(0, v529)
        v550 = root.AssemblyAngularVelocity:Dot(root.CFrame.RightVector)
        v549 = 2.9 * math.cos(v547) - 0.9 * math.sin(v547)
        p182.pitchFallAcceleration = -math.max(0.8, v549) * Config.LiftGravityScale - v550 * 0.12 - v525 * 4
    else
        v548 = v418 + ((v546 - v541) * 17 - v418 * 7.5) * v413
        v550 = math.clamp(v548, -4.5, 1.05)
        v548 = v541 + v550 * v413
        v547 = math.clamp(v548, 0, v534)

        if v547 == 0 and v550 < 0 then
            v550 = 0
        end
    end

    p182.wheeliePitch = v547
    p182.wheelieVelocity = v550

    local v551, v552

    if v547 > 0.02 or p182.wheelieReturning then
        v548 = p182.wheeliePeak or 0
        v550 = math.max(v548, v547, v529)

        if v550 then
            v551 = v550
            v552 = true
        else
            v552 = false
        end
    else
        v552 = false
    end

    if not v552 then
        v551 = 0
    end

    p182.wheeliePeak = v551
    v546 = p182.slip

    local PickFrom = p182.lean

    v551 = math.clamp(math.abs(PickFrom) / 0.6108652381980153, 0, 1)
    v531 = t1.ExitSlide
    v550 = math.abs(p182.lean)

    local v553 = math.sign(p182.lean)

    v418 = p182.cornerPeakLean or 0

    local v554 = p182.prevLeanAbs or v550

    p182.prevLeanAbs = v550
    v548 = v550 - v554 > v531.TipRate * v413

    local v555, v556

    if v550 < v531.ResetLean then
        v556 = false
    elseif not p182.cornerPeakSide or v553 == 0 or v553 == p182.cornerPeakSide then
        v555 = v418
        v556 = true
    else
        v556 = false
    end

    if not v556 then
        v555 = 0
    end

    if v548 or v555 < v550 then
        v555 = v550
        p182.cornerPeakSide = v553
    end

    p182.cornerPeakLean = v555

    if v550 < v531.UprightLean and v531.LockThrottle <= smoothThrottle then
        p182.slideLock = true
    elseif smoothThrottle < v531.UnlockThrottle then
        p182.slideLock = false
    end

    local v557, v558

    if v431 and v531.MinPeak <= v555 then
        RearSkid = v555 - v550
        PickFrom = v531.PickFrom

        local PickFull = v531.PickFull

        v549 = (RearSkid - PickFrom) / (PickFull - PickFrom)
        v537 = math.clamp(v549, 0, 1)
        v550 = v537 * v537 * (3 - 2 * v537)

        if v550 then
            v557 = v550
            v558 = true
        else
            v558 = false
        end
    else
        v558 = false
    end

    if not v558 then
        v557 = 0
    end

    v511 = p182.exitGate or 0

    local v559

    if v548 then
        RearSkid = 0
    else
        v559 = v557 - v511
        v536 = -v413 * (v511 < v557 and v531.Rise or v531.Fall)
        RearSkid = v511 + v559 * (1 - math.exp(v536))
    end

    p182.exitGate = RearSkid

    local exitGate = p182.slideLock and p182.exitGate or 1

    PickFrom = t1.RearSlideSpeedFactor(v417, v534) * (Config.SlideSensitivity or 1)
    v536 = (Config.RainSlide or 1.7) - 1

    local v560 = p182.wetAmount

    if not v560 then
        v560 = if p182.wet then 1 else 0
    end

    v548 = PickFrom * (1 + v536 * v560) * (1 + (result and result.SlideBoost or 0) * (p182.tyreWornR or 0))

    if v422 == "SlideMaster" then
        v548 *= 1 + t1.Legend.KuriMidSlide * t1.KuriMidSpeed(v417)
    end

    p182.slideGate = v551
    RearSkid = t1.TCSDrive.SlideScale[p182.tcsLevel or 4] or 1
    PickFrom = v534 * v551 * v548 * exitGate * RearSkid
    v537 = p182.tractionSlip or 0
    v536 = PickFrom - (p182.tractionSlip or 0)
    p182.tractionSlip = v537 + v536 * (1 - math.exp(-v413 * (if (p182.tractionSlip or 0) < PickFrom then 3.8 else (7.5 + (v414 - 1) * 2) * (p182.driveRecover or v520))))
    v537 = p182.tractionSlip

    local SlideBoost = p182.rearBrakeSlip

    p182.slip = math.max(v537, SlideBoost)

    local v564

    do
        local v565 = false

        if v431 and p182.gear > 0 then
            v536 = p182.lean
            v537 = math.abs(v536) / 0.7
            v559 = math.clamp(v537, 0, 1)
            SlideBoost = v417 / 8
            PickFrom = v559 * math.clamp(SlideBoost, 0, 1)

            if PickFrom then
                v564 = PickFrom
                v565 = true
            end
        end

        if not v565 then
            v564 = 0
        end
    end

    SlideBoost = smoothThrottle - (p182.previousThrottle or smoothThrottle)
    v534 = math.max(0, SlideBoost) / math.max(v413, 0.001)
    p182.highsideClosingRate = math.max(0, (p182.previousThrottle or smoothThrottle) - smoothThrottle) / math.max(v413, 0.001)
    p182.previousThrottle = smoothThrottle
    v559 = math.clamp(math.abs(p182.lean) / 0.6981317007977318, 0, 1)

    local v566 = v564 * v559
    local v567 = v534 / 2

    v537 = v566 * (math.clamp(v567, 0, 1) * 0.85 + smoothThrottle ^ 3 * 0.45) * smoothThrottle * t1.TCSPick({ 1.4, 1, 0.6, 0.3, 0.12, 0.025 }, v414) * (1 - v510) * v551 * v548 * exitGate * RearSkid
    v536 = p182.exitSlip or 0

    local Rise2 = v537 - (p182.exitSlip or 0)

    v566 = -v413

    local v568

    if (p182.exitSlip or 0) < v537 then
        v568 = 12
    elseif v559 < 0.05 then
        v568 = 9
    else
        v567 = 2.8 + (v414 - 1) * 2
        v568 = math.max(1.4, v567) * (p182.driveRecover or v520)
    end

    local v562 = v566 * v568

    p182.exitSlip = v536 + Rise2 * (1 - math.exp(v562))

    if v559 < 0.05 then
        SlideBoost = p182.tractionSlip
        v560 = -v413 * 6
        p182.tractionSlip = SlideBoost * math.exp(v560)
    end

    v536 = p182.tractionSlip
    p182.slip = math.max(v536, p182.rearBrakeSlip, p182.exitSlip * 1.05)
    Rise2 = v546 - p182.slip
    p182.highsideSlipRecovery = math.max(0, Rise2) / math.max(v413, 0.001)
    v537 = math.clamp(p182.slip, 0, 1) * Config.SlidePowerReduction * t1.TCSDrive.SlideCost[p182.tcsLevel or 4]

    if v422 == "SlideMaster" then
        local v569, v570

        if v431 and p182.gear > 0 and smoothThrottle > 0.3 then
            Rise2 = p182.rearYaw or 0
            v536 = math.abs(Rise2) / (Config.RearYaw * 0.35)
            SlideBoost = math.clamp(v536, 0, 1)

            if SlideBoost then
                v569 = SlideBoost
                v570 = true
            else
                v570 = false
            end
        else
            v570 = false
        end

        if not v570 then
            v569 = 0
        end

        v537 *= 1 - t1.Legend.KuriSlidePowerKeep * v569
        RearSkid = 1 + t1.Legend.KuriSlideDrive * v569
    else
        RearSkid = 1
    end

    p182.slidePowerCut = v537
    v491 *= (1 - v537) * RearSkid
    p182.driveThrottle *= 1 - v537
    RearSkid = t1.RearBrakeSlideEBS.Max[v415] or 1
    v537 = p182.rearBrakeSlip * t1.RearSlideSpeedFactor(v417, p182.rearBrakeSlip) * 0.8
    v560 = p182.tractionSlip
    Rise2 = p182.exitSlip * 1.05
    SlideBoost = math.max(v560, Rise2) * v559

    local v563 = -v537 / RearSkid

    exitGate = SlideBoost + RearSkid * (1 - math.exp(v563))

    local v561 = p182.lean

    v537 = math.sign(v561) * math.clamp(exitGate, 0, 1.4) * v564 * Config.RearYaw * (1 + (5 - v414) * 0.08) * 0.82

    if not (smoothRearBrake > 0.1 and p182.rearBrakeSlip > (p182.tractionSlip or 0)) then
        v537 *= v551
    end

    if (p182.slideCreep or 0) > 0 then
        Rise2 = p182.lean
        v537 += math.sign(Rise2) * p182.slideCreep * Config.RearYaw
    end

    RearSkid = t1.RearSkid
    SlideBoost = math.clamp((p182.rearBrakeSlip or 0) / RearSkid.LockFull, 0, 1)
    v536 = math.clamp((smoothBrake - RearSkid.FrontFrom) / (RearSkid.FrontFull - RearSkid.FrontFrom), 0, 1)
    v560 = RearSkid.RearAlone or 0
    v549 = math.max(v536, v560)
    Rise2 = smoothThrottle / RearSkid.ThrottleOff
    v544 = v549 * (1 - math.clamp(Rise2, 0, 1))

    do
        local v571, v572

        if v431 and smoothRearBrake > 0.1 then
            SlideBoost *= v544
            Rise2 = RearSkid.FromKph
            v563 = RearSkid.FullKph
            v562 = (v417 - Rise2) / (v563 - Rise2)
            v561 = math.clamp(v562, 0, 1)
            v520 = SlideBoost * (v561 * v561 * (3 - 2 * v561))

            if v520 then
                v571 = v520
                v572 = true
            else
                v572 = false
            end
        else
            v572 = false
        end

        if not v572 then
            v571 = 0
        end

        v559 = v571 * (1 - v564)
        exitGate = p182.skidGrow or 0

        if v559 > 0.01 or exitGate > 0 then
            local rearSkidSide = p182.rearSkidSide

            if not p182.rearSkidActive then
                v536 = p182.lean

                if math.abs(v536) > 0.017453292519943295 then
                    v536 = p182.lean
                    rearSkidSide = math.sign(v536)
                else
                    v536 = p182.steer or 0

                    if math.abs(v536) > 0.1 then
                        v536 = p182.steer
                        rearSkidSide = -math.sign(v536)
                    else
                        v536 = AssemblyLinearVelocity:Dot(v441)

                        if math.abs(v536) > 0.05 then
                            v536 = AssemblyLinearVelocity:Dot(v441)
                            rearSkidSide = math.sign(v536)
                        else
                            rearSkidSide = rearSkidSide or 1
                        end
                    end
                end
            end

            rearSkidSide = rearSkidSide or 1
            p182.rearSkidSide = rearSkidSide
            p182.rearSkidActive = v571 > 0.01
            v534 = -(p182.steer or 0) * rearSkidSide

            if v571 <= 0.01 then
                exitGate -= RearSkid.ReleaseRate * v413
            elseif v534 < -0.3 then
                exitGate -= RearSkid.CounterRate * v413
            elseif RearSkid.GrowFrom < v571 and v431 then
                exitGate += ((RearSkid.HoldGrowRate or 0) * v571 * (1 - v564) + (v534 > 0.3 and RearSkid.GrowRate * v534 or 0)) * v413
            else
                exitGate -= RearSkid.SettleRate * v413
            end

            SlideBoost = math.clamp(exitGate, 0, 1.5)
            p182.skidGrow = SlideBoost
            v537 += rearSkidSide * (v559 * RearSkid.Yaw * (t1.RearBrakeSlideEBS.Skid[v415] or 1) + SlideBoost) * Config.RearYaw
        else
            p182.rearSkidActive = false
        end
    end

    p182.rearSkid = v559

    local v573

    do
        local v574

        if v559 > 0.05 or (p182.skidGrow or 0) > 0.05 then
            v564 = true
        elseif smoothRearBrake > 0.1 then
            SlideBoost = p182.rearBrakeSlip or 0
            v573 = p182.tractionSlip or 0
            v574 = (p182.exitSlip or 0) * 1.05
            v564 = math.max(v573, v574) < SlideBoost
        else
            v564 = false
        end

        v536 = p182.brakeSlideShare or 0
        v563 = if v564 then 1 else 0
        v574 = v563 - (p182.brakeSlideShare or 0)
        v562 = -v413 * 6
        p182.brakeSlideShare = v536 + v574 * (1 - math.exp(v562))
    end

    local KuriSlideCrashYaw

    if (p182.kerbWashVisual or 0) > 0.01 and v431 and p182.kerbSlideMode ~= "Front" then
        SlideBoost = Config.RearYaw * (script:GetAttribute("MaxSlideCrashYaw") or 1)
        KuriSlideCrashYaw = v422 == "SlideMaster" and t1.Legend.KuriSlideCrashYaw or 1
        v414 = SlideBoost * KuriSlideCrashYaw
        p182.kerbSlideYaw = p182.kerbWashVisual * (t1.KerbEdge.RearSlideShare or t1.KerbEdge.SlideShare) * v414
        v573 = p182.lean
        v537 += math.sign(v573) * p182.kerbSlideYaw
    else
        p182.kerbSlideYaw = 0
    end

    SlideBoost = t1.RearSlide
    v563 = smoothRearBrake > 0.1 and p182.rearBrakeSlip > (p182.tractionSlip or 0) or v559 > 0.05
    SlideBoost(p182, v537, v413, v563)
    v537 = t1.GripReturn
    SlideBoost = v422 == "SlideMaster"
    KuriSlideCrashYaw = Config.RearYaw * (script:GetAttribute("MaxSlideCrashYaw") or 1) * (SlideBoost and t1.Legend.KuriSlideCrashYaw or 1)

    local KuriSlideCrashYaw2 = p182.rearYaw or 0

    SlideBoost = math.abs(KuriSlideCrashYaw2) / math.max(KuriSlideCrashYaw, 0.001)
    KuriSlideCrashYaw = v454 == "Grass" or v454 == "Gravel" or v454 == "Sand"

    if v559 > 0.05 or (p182.skidGrow or 0) > 0.05 then
        v573 = true
    elseif smoothRearBrake > 0.1 then
        KuriSlideCrashYaw2 = p182.rearBrakeSlip or 0
        v561 = p182.tractionSlip or 0
        v562 = (p182.exitSlip or 0) * 1.05
        v573 = math.max(v561, v562) < KuriSlideCrashYaw2
    else
        v573 = false
    end

    if v431 then
        KuriSlideCrashYaw2 = not KuriSlideCrashYaw

        if KuriSlideCrashYaw2 then
            KuriSlideCrashYaw2 = not p182.paddling

            if KuriSlideCrashYaw2 then
                KuriSlideCrashYaw2 = v537.MinKph < v417 and not v573 and (p182.kerbWashVisual or 0) < 0.05
            end
        end
    else
        KuriSlideCrashYaw2 = v431
    end

    v573 = p182.gripGasOff or 0
    p182.gripSnapping = false

    local v576, v577, v578

    do
        local v579

        if KuriSlideCrashYaw2 then
            if v573 < 0.5 then
                p182.gripRelease = SlideBoost
                p182.gripBite = false
                p182.gripRisk = 0
            else
                v576 = (p182.gripRelease or 0) > 0.05 and not p182.gripBite
                p182.gripSnapping = v576

                if not p182.gripBite and (p182.gripRelease or 0) > 0.05 and SlideBoost <= (p182.gripRelease or 0) * (1 - v537.BiteFrac) then
                    p182.gripBite = true
                    v576 = v537.SoftClose
                    v562 = 1 - v537.SoftClose
                    v568 = (p182.gripCloseRate or 0) / (v537.ReleaseRate * 0.9)
                    KuriSlideCrashYaw = v576 + v562 * math.clamp(v568, 0, 1)
                    v579 = v537.LeanLow
                    v566 = 1 - v537.LeanLow

                    local v580 = math.abs(p182.lean)
                    local LeanFrom = v537.LeanFrom

                    v567 = v537.LeanFull
                    v577 = (v580 - LeanFrom) / (v567 - LeanFrom)
                    v578 = math.clamp(v577, 0, 1)
                    v576 = v579 + v566 * (v578 * v578 * (3 - 2 * v578))
                    v579 = (p182.gripRelease or 0) * KuriSlideCrashYaw * v576
                    v566 = p182.lean

                    if math.abs(v566) < v537.HighsideMinLean then
                        v568 = v537.HighsideSlide - 0.01
                        v579 = math.min(v579, v568)
                    end

                    p182.gripRisk = v579

                    if v537.HighsideSlide <= v579 then
                        p182.gripHighside = true
                    elseif v537.SafeSlide < v579 then
                        v562 = v579 - v537.SafeSlide
                        v568 = v537.HighsideSlide - v537.SafeSlide
                        v576 = v562 / math.max(v568, 0.001)
                        v566 = p182.gripWobble or 0
                        v568 = 0.35 + 0.65 * math.clamp(v576, 0, 1)
                        p182.gripWobble = math.max(v566, v568)
                    end
                end
            end
        else
            p182.gripRelease = 0
            p182.gripBite = false
            p182.gripRisk = 0
        end

        p182.gripSlideSize = SlideBoost
        v562 = (p182.gripWobble or 0) - v413 / v537.WobbleSeconds
        p182.gripWobble = math.max(0, v562)
        KuriSlideCrashYaw = if p182.abs then 50 else 58
        v559 = smoothBrake * KuriSlideCrashYaw * t1.FrontBrake.EBSStrength[v415]
        KuriSlideCrashYaw2 = 0.12 * smoothBrake
        v562 = p182.lean
        v579 = math.sin(v562)
        SlideBoost = v516 * (1 - KuriSlideCrashYaw2 * math.abs(v579))
        KuriSlideCrashYaw2 = Legend * Legend + v559 * v559
        KuriSlideCrashYaw = math.sqrt(KuriSlideCrashYaw2) / math.max(SlideBoost, 1)
        v576 = v445 * (p182.tyreFBrakeGrip or p182.tyreF or 1) * Config.Gravity * (t1.FrontBrake.EBSGripCap[v415] or 1) * (p182.abs ~= false and t1.FrontBrake.ABSLimit or 1)
        v573 = math.min(v559, v576)

        if v422 == "StoppieBrake" and v431 then
            Legend = t1.Legend
            KuriSlideCrashYaw2 = p182.stoppiePitch or 0
            v576 = -v529
            v560 = math.max(KuriSlideCrashYaw2, v576)
            KuriSlideCrashYaw2 = Legend.DoctorStoppieFrom
            v576 = Legend.DoctorStoppieFull
            v562 = (v560 - KuriSlideCrashYaw2) / (v576 - KuriSlideCrashYaw2)
            v579 = math.clamp(v562, 0, 1)
            v445 = v579 * v579 * (3 - 2 * v579)
            SlideBoost = v573 * Legend.DoctorBrakeBonus * v445
        else
            SlideBoost = 0
        end
    end

    p182.doctorBrake = SlideBoost
    v560 = root.CFrame:PointToWorldSpace(Config.FrontAxle)
    KuriSlideCrashYaw2 = root.CFrame:PointToWorldSpace(Config.RearAxle)

    local v581 = p182.lastLandingFC and (p182.lastLandingFC - v443) / math.max(v413, 0.001) or 0
    local v582 = p182.lastLandingRC and (p182.lastLandingRC - v427) / math.max(v413, 0.001) or 0

    v562 = BikeSuspension.TrackLanding
    v578 = math.min(v581, 24)
    v562 = v562(p182, "front", v443, math.max(0, v578, -root:GetVelocityAtPosition(v560).Y), v413)
    v566 = BikeSuspension.TrackLanding
    v577 = math.min(v582, 24)

    local v583 = -root:GetVelocityAtPosition(KuriSlideCrashYaw2).Y

    v566 = v566(p182, "rear", v427, math.max(0, v577, v583), v413)

    if not (v443 < 20) or not v443 then
        v443 = nil
    end

    p182.lastLandingFC = v443

    local v584 = if not (v427 < 20) or not v427 then nil else v427

    p182.lastLandingRC = v584

    if v562 then
        p182.wheelieReturning = false
        p182.wheeliePitch = 0
        p182.wheelieVelocity = 0
    end

    if v566 then
        p182.stoppieReturning = false
        p182.stoppiePitch = 0
        p182.stoppieVelocity = 0
    end

    do
        local v585

        if p184 then
            if v562 or v566 then
                v582 = root.CFrame.RightVector
                KuriSlideCrashYaw2 = root.AssemblyAngularVelocity
                root.AssemblyAngularVelocity = KuriSlideCrashYaw2 - v582 * KuriSlideCrashYaw2:Dot(v582)
                p182.pitchFallAcceleration = nil
            end
        else
            v560 = t1.PrivateFeatures() and v431
            v584 = t1.RoadFilter

            local v586 = if v560 then t1.RoadHit(root, Config.FrontAxle) else nil

            if not v560 or not v586 then
                v586 = nil
            end

            v584(p182, "front", v586, v413, v417)
            v584 = t1.RoadFilter

            if v560 then
                v585 = t1.RoadHit(root, Config.RearAxle)
            end

            if not v560 or not v585 then
                v585 = nil
            end

            v584(p182, "rear", v585, v413, v417)
        end

        v584 = BikeSuspension.Step(p182, v413, v491, v573, v431, v539)

        local v587 = p182.stoppiePitch or 0

        v568 = p182.stoppieVelocity or 0

        local v588, v589

        if v539 then
            v567 = p182.lean

            if math.abs(v567) < 0.3 and v417 > 24 then
                v588 = if v527 > 0.05 then 0.28 else 0.4
                v589 = v588 < smoothBrake and p182.brake > 0.1
            else
                v589 = false
            end
        else
            v589 = v539
        end

        v567 = (v417 - 22) / 32
        v588 = math.clamp(v567, 0, 1)
        v578 = -v529
        v585 = math.max(0, v578)

        if v585 > 0.035 and v427 > 0.045 and not v589 and (v587 > 0.02 or (BikeSuspension.ArmClearance or 0.32) < v427) then
            p182.stoppieReturning = true
        end

        if v427 <= 0.045 or v585 <= 0 or not v431 then
            p182.stoppieReturning = false
        end

        if p182.stoppieReturning then
            v568 = -root.AssemblyAngularVelocity:Dot(root.CFrame.RightVector)
            p182.pitchFallAcceleration = (2.8 * math.cos(v585) - 2.45 * math.sin(v585)) * 1.35 * Config.LiftGravityScale + v568 * 0.12
        else
            v585 = v587

            if v589 then
                local v590 = v573 / Config.Gravity * v588 * (1.05 + v527 * 0.65) * t1.StoppieEBS[v415 or 3]

                if v422 == "StoppieBrake" then
                    v577 = t1.Legend.DoctorBrakeStoppie * v588 * smoothBrake
                    v590 = math.max(v590, v577)
                end

                v577 = v568 + ((v590 * (2.45 * math.cos(v587) + 2.8 * math.sin(v587)) - (2.8 * math.cos(v587) - 2.45 * math.sin(v587))) * 0.85 - v568 * 2.6) * v413
                v568 = math.clamp(v577, -0.8, 1.05)
            else
                v568 += (-(2.8 * math.cos(v587) - 2.45 * math.sin(v587)) * 1.35 * Config.LiftGravityScale - v568 * 1.2) * v413
                v568 = math.clamp(v568, -4.5, 1.55)
            end
        end

        v578 = v585 + v568 * v413
        v567 = math.clamp(v578, 0, 1.42)

        if v567 == 0 and v568 < 0 then
            v568 = 0
        end

        p182.stoppiePitch = v567
        p182.stoppieVelocity = v568

        if p182.legendRecoverUntil then
            if os.clock() < p182.legendRecoverUntil then
                v578 = -v413 * (Config.LegendRecoverRate or 6)

                local v591 = 1 - math.exp(v578)

                if p184 then
                    p182.lean -= p182.lean * v591
                    p182.rollVelocity = (p182.rollVelocity or 0) * (1 - v591)
                    p182.smoothSteer *= 1 - v591
                end

                p182.rearYaw = (p182.rearYaw or 0) * (1 - v591)
                p182.rearYawVelocity = 0
                p182.tractionSlip = (p182.tractionSlip or 0) * (1 - v591)
                p182.exitSlip = (p182.exitSlip or 0) * (1 - v591)
                p182.rearBrakeSlip = (p182.rearBrakeSlip or 0) * (1 - v591)
                v578 = p182.tractionSlip
                v577 = p182.rearBrakeSlip
                v583 = p182.exitSlip * 1.05
                p182.slip = math.max(v578, v577, v583)
                p182.wheelieReturning = false
                p182.stoppieReturning = false
                p182.pitchFallAcceleration = nil
                p182.wheeliePitch = (p182.wheeliePitch or 0) * (1 - v591)
                p182.wheelieVelocity = 0
                v567 *= 1 - v591
                p182.stoppiePitch = v567
                p182.stoppieVelocity = 0
            else
                p182.legendRecoverUntil = nil
            end
        end

        if p184 then
            v589 = p182.wheelieReturning or p182.stoppieReturning
            p182.align.PrimaryAxisOnly = v589 == true

            if v589 and p182.pitchFallAcceleration then
                v568 = root.Size
                v539 = root.AssemblyMass * (v568.Y * v568.Y + v568.Z * v568.Z) / 12
                root:ApplyAngularImpulse(root.CFrame.RightVector * p182.pitchFallAcceleration * v539 * v413)
            end
        end
    end

    local Wheelbase, v592

    do
        local v593 = false

        if v435 and v429 then
            v583 = v435.Position.Y - v429.Position.Y
            Wheelbase = Config.Wheelbase
            v577 = math.atan2(v583, Wheelbase)

            if v577 then
                v592 = v577
                v593 = true
            end
        end

        if not v593 then
            v592 = 0
        end
    end

    v493 = v592 + v584 + (p182.wheeliePitch or 0) - v567

    local v594

    v594, v578 = BikeSuspension.Axles(p182)
    v443 = CFrame.Angles(0, p182.yaw, 0) * CFrame.Angles(v493, 0, p182.lean + v461)

    local v595

    if v431 and v505 and v547 < 0.02 and v567 < 0.02 and v435 and v429 then
        for _ = 1, 3 do
            v461 = v429.Position.Y + t1.SupportHeight(v443, v578, Config.RearWheelRadius, Config.RearTyreHalfWidth)
            v595 = (v435.Position.Y + t1.SupportHeight(v443, v594, Config.FrontWheelRadius, Config.FrontTyreHalfWidth) - v461) / Config.Wheelbase
            v493 += math.clamp(v595, -0.06, 0.06)
            v443 = CFrame.Angles(0, p182.yaw, 0) * CFrame.Angles(v493, 0, p182.lean)
        end
    end

    v584 = p182.wheelieReturning == true or p182.stoppieReturning == true

    local Y

    if p184 and p182.wasFalling and not v584 then
        Y = root.CFrame.LookVector.Y
        Wheelbase = math.clamp(Y, -1, 1)
        p182.landOffset = math.asin(Wheelbase) - v493
        v533 = root.CFrame.RightVector
        v541 = root.AssemblyAngularVelocity
        root.AssemblyAngularVelocity = v541 - v533 * v541:Dot(v533)
    end

    p182.wasFalling = v584

    if v584 then
        p182.landOffset = nil
    end

    if p182.landOffset then
        v583 = p182.landOffset

        if math.abs(v583) < 5E-04 then
            p182.landOffset = nil
        else
            v443 = CFrame.Angles(0, p182.yaw, 0) * CFrame.Angles(p182.landOffset, 0, 0) * CFrame.Angles(0, -p182.yaw, 0) * v443
            v592 = p182.landOffset
            Wheelbase = -v413 * (t1.LandEase or 10)
            p182.landOffset = v592 * math.exp(Wheelbase)
        end
    end

    local v596, v597, v598

    if v431 then
        v592 = (v429 or v442).Position.Y + t1.SupportHeight(v443, v578, Config.RearWheelRadius, Config.RearTyreHalfWidth)
        v592 = (v435 or v442).Position.Y + t1.SupportHeight(v443, v594, Config.FrontWheelRadius, Config.FrontTyreHalfWidth)
        v592 = (v429 or v442).Position.Y + t1.SupportHeight(root.CFrame.Rotation, v578, Config.RearWheelRadius, Config.RearTyreHalfWidth)
        v597 = (v435 or v442).Position.Y + t1.SupportHeight(root.CFrame.Rotation, v594, Config.FrontWheelRadius, Config.FrontTyreHalfWidth)

        local v599 = math.max(v592, v597) + 0.018
        local v600

        if v435 and v429 then
            v600 = (v435.Position.Y - v429.Position.Y) / Config.Wheelbase * AssemblyLinearVelocity:Dot(LookVector)
            v597 = math.max(0, v600) or 0
        else
            v597 = 0
        end

        local v601, v602

        if v435 and v429 then
            Y = (v435.Position.Y - v429.Position.Y) / Config.Wheelbase * AssemblyLinearVelocity:Dot(LookVector)

            if Y then
                v601 = Y
                v602 = true
            else
                v602 = false
            end
        else
            v602 = false
        end

        if not v602 then
            v601 = nil
        end

        p182.roadVy = v601
        v601 = p182.supportHeight

        if v601 then
            v600 = p182.supportHeight + v413 * (12 + v597 * 1.3)
            v596 = math.min(v599, v600)
        end

        if v601 and v596 then
            v599 = v596
        end

        v596 = p182.supportHeight

        local v603

        if v596 then
            v601 = (v599 - p182.supportHeight) / math.max(v413, 0.001)
            v600 = 10 + v597 * 1.3
            v603 = math.clamp(v601, -16, v600)
        end

        if not v596 or not v603 then
            v603 = 0
        end

        v598 = if v562 or v566 or (p182.frontImpact or 0) > 0.002 or (p182.rearImpact or 0) > 0.002 then math.min(v603, 0) else v603
        p182.supportHeight = v599
        v597 = v599 - rootPosition.Y
        v595 = workspace.Gravity + Config.Gravity * 1.5
        v596 = v595 + (v597 > 0.05 and Config.Gravity * math.clamp(v597 * 8, 0, 12) or 0)
        v505 = math.clamp(workspace.Gravity + (v599 - rootPosition.Y) * 180 - (AssemblyLinearVelocity.Y - v598) * 25, 0, v596)
    else
        p182.supportHeight = nil
        v505 = 0
        p182.roadVy = nil
    end

    v578 = AssemblyLinearVelocity:Dot(LookVector)
    v592 = AssemblyLinearVelocity:Dot(v441)
    v562 = (1E-04 * v578 * math.abs(v578) + v578 * 0.025) * (1 - v500 * 0.035) * (1 - (p182.slipDrag or 0))

    local v606, v607

    if not v431 or v454 == "Grass" or v454 == "Gravel" then
        v607 = false
    else
        v595 = p182.lean
        v597 = (math.abs(v595) - 0.8726646259971648) / 0.08726646259971647
        v581 = v500 * math.clamp(v597, 0, 1)

        if v581 then
            v606 = v581
            v607 = true
        else
            v607 = false
        end
    end

    if not v607 then
        v606 = 0
    end

    p182.scrape = v606
    v562 += math.sign(v578) * math.min(math.abs(v578) * 0.22, 35) * v606
    v500 = (v573 + Rise + SlideBoost) * math.sign(v578)

    if v475 > 0.05 and math.abs(v578) < 0.4 then
        v500 = math.max(0, v491) + v578 * 12
    end

    if math.abs(v578) < 0.4 and v484 == 0 and not p182.paddling then
        v500 = v578 * 10
    end

    local v608, v609

    if not (v484 < 0.05) or p182.paddling then
        v609 = false
    else
        SlideBoost = v578 * 0.028 * v415 * v496 / 2.7

        if SlideBoost then
            v608 = SlideBoost
            v609 = true
        else
            v609 = false
        end
    end

    if not v609 then
        v608 = 0
    end

    v608 *= 1 - p182.clutchBlend
    v559 = if p182.paddling then -1 else 1

    local v610 = v431 and v559 * v491 - v500 - v562 - v608 or -v562

    if Config.OfftrackDrag[v454] then
        v610 -= v578 * Config.OfftrackDrag[v454]
    end

    v610 -= t1.KerbResistance(p182, v578, v413, v480, v431)
    v577 = 10 - (p182.roughBlend or 0) * 2.5
    v595 = p182.slip
    v562 = v577 * (1 - math.clamp(v595, 0, 1) * 0.25)
    v597 = (v486 * Config.Wheelbase / 2 - v592) * v562 + v444 * Config.Gravity * 0.025
    v598 = -v516
    v577 = math.clamp(v597, v598, v516)

    if v424 then
        v610 = math.min(0, v610)
    end

    if v498 and v431 and v490 < v578 then
        v595 = (v578 - v490) * 2.2
        v598 = -math.clamp(v595, 2, 26)
        v610 = math.min(v610, v598)
    end

    if p184 then
        local force = p182.force

        v598 = root.AssemblyMass
        v595 = Vector3.new(0, 1, 0) * v505 + LookVector * v610

        local v611 = if v431 then v441 * v577 else nil

        if not v431 or not v611 then
            v611 = Vector3.new(0, 0, 0)
        end

        force.Force = v598 * (v595 + v611)
        p182.align.CFrame = v443
    end

    v592 = {
        pitLimiter = v498,
        speed = Magnitude,
        kph = v417,
        velocity = AssemblyLinearVelocity,
        onGround = v431,
        surface = v454,
        blocked = v424,
        impact = Instance,
        wallContact = v492,
        frontExcess = KuriSlideCrashYaw,
        oldSlip = v546,
        lateral = v592,
        throttle = smoothThrottle,
        driveThrottle = p182.driveThrottle,
        brake = smoothBrake,
        rearBrake = smoothRearBrake,
        rearBrakeSlip = p182.rearBrakeSlip,
        rearYaw = p182.rearYaw,
        wheeliePitch = p182.wheeliePitch,
        stoppiePitch = p182.stoppiePitch,
        burnout = v475,
        roughBlend = p182.roughBlend,
        roughPhase = p182.roughPhase,
        rhd = p182.rhd == true,
        frontCompression = p182.frontCompression,
        rearCompression = p182.rearCompression,
        tractionCut = v510,
        liftCut = v501,
        wheelieDrag = 0,
        acceleration = v610,
        scrape = v606,
        clutch = p182.clutchBlend
    }
    v592.rpm = math.max(p182.reportRpm or BikeGearbox.RPM(p182.gear, v417, v484, p182.tractionSlip), 1800 + v475 * 12000)

    return v592
end

return require(script.Parent:WaitForChild("OwnerFeatures14")).Wrap(t1, script.Parent, "Pre14_BikeDynamics")
