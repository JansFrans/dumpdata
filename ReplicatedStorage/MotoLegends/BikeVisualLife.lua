-- https://lua.expert

local RunService = game:GetService("RunService")
local Config = require(script.Parent.Config)
local BikeDynamics = require(script.Parent.BikeDynamics)
local t1 = {
    Settings = {
        Enabled = true,
        RoadLong = 0.035,
        RoadMid = 0.045,
        RoadFine = 0.015,
        RoadFromKph = 8,
        RoadFullKph = 160,
        WheelShare = 0.5,
        BodyHz = 2.1,
        BodyDamping = 0.65,
        EngineHeave = 0.005,
        EngineRoll = 0.0010471975511965976,
        EngineHz = 26,
        EngineIdleShare = 1,
        EngineMovingShare = 0.35,
        WeaveFromKph = 230,
        WeaveFullKph = 330,
        WeaveRoll = 0.003839724354387525,
        WeaveYaw = 0.0017453292519943296,
        WeaveHz = 1.6,
        KerbBlend = 25,
        SuspHz = 2.6,
        SuspDamping = 0.7,
        SuspTravel = 0.2,
        ExtendSlack = 0.03,
        ReleaseBand = 0.04,
        FrontTravel = { -0.28, 0.4 },
        RearTravel = { -0.18, 0.48 }
    }
}
local self = setmetatable({}, {
    __mode = "k"
})
local t4 = {
    body = CFrame.identity
}

local function ramp(p1, p2, p3) -- line: 47
    local v3 = math.clamp((p1 - p2) / (p3 - p2), 0, 1)

    return v3 * v3 * (3 - 2 * v3)
end

local function road(p4, p5, p6) -- line: 48
    -- upvalues: t1 (copy)
    local Settings = t1.Settings

    return Settings.RoadLong * math.noise(p4 * 0.023, p5, 0.31) + Settings.RoadMid * p6 * math.noise(p4 * 0.22, p5 + 7.7, 0.53) + Settings.RoadFine * p6 * math.noise(p4 * 0.9, p5 + 3.1, 0.77)
end

local function follow(p7, p8, p9, p10) -- line: 52
    -- upvalues: t1 (copy)
    local Settings = t1.Settings
    local v4 = Settings.BodyHz * 2 * 3.141592653589793
    local v5 = p8 + ((p9 - p7) * v4 * v4 - 2 * Settings.BodyDamping * v4 * p8) * p10

    return p7 + v5 * p10, v5
end

local v6 = RaycastParams.new()

v6.FilterType = Enum.RaycastFilterType.Include

local v7

local function groundHit(p11, p12, p13) -- line: 60
    -- upvalues: v6 (copy), v7 (ref)
    if not (v7 and v7.Parent) then
        local v8 = workspace:FindFirstChild("RaceCollision", true)

        if not v8 then
            return nil
        end

        v7 = v8
        v6.FilterDescendantsInstances = {
            v8,
            workspace.Terrain
        }
    end

    local v10 = workspace:Raycast(Vector3.new(p11, p12 + 1.2, p13), Vector3.new(0, -2.6, 0), v6)

    return if v10 and v10.Normal.Y > 0.4 and v10.Instance:GetAttribute("Surface") ~= "Barrier" then v10 else nil
end

local t5 = {
    Grass = true,
    Gravel = true,
    Sand = true
}

local function paved(p14) -- line: 71
    -- upvalues: BikeDynamics (copy), t5 (copy)
    return p14 ~= nil and not t5[BikeDynamics.SurfaceOf(p14) or ""]
end

local function looseKind(p15) -- line: 72
    -- upvalues: BikeDynamics (copy)
    local v11 = p15 and BikeDynamics.SurfaceOf(p15)
    local v12 = if v11 == "Gravel" or v11 == "Sand" then 1 else 0

    if v11 == "Grass" then
        return v12, 1
    end

    return v12, 0
end

local function isKerb(p16) -- line: 73
    if p16:GetAttribute("Kerb") == true then
        return true
    end

    return string.find(string.lower(p16.Name), "kerb", 1, true) ~= nil
end

local function inactive(p17, p18) -- line: 74
    if workspace:GetAttribute("PrivateFeatures") ~= true then
        return true
    end

    if (p18:GetAttribute("LossStage") or "") == "" and (p17:GetAttribute("Crash") or "") == "" then
        return p17:GetAttribute("VisualSlideBaked") == true
    end

    return true
end

local function patchOf(p19, p20, p21, p22) -- line: 80
    -- upvalues: BikeDynamics (copy)
    local v14 = math.min(p22 * BikeDynamics.TyreCrownScale, p21)

    return p19:PointToWorldSpace(p20) - p19.UpVector * (p21 - v14), v14
end

function t1.Update(p23, p24) -- line: 84
    -- upvalues: RunService (copy), Config (copy), BikeDynamics (copy), t1 (copy), self (copy), t4 (copy), road (copy), groundHit (copy), t5 (copy), inactive (copy)
    if not RunService:IsClient() then
        return t4
    end

    local Settings = t1.Settings
    local v15 = p23 and p23.PrimaryPart
    local v16, _CFrame, Y, Y2, v17

    if v15 and Settings.Enabled and not inactive(p23, v15) then
        v16 = math.clamp(p24 or 0.016666666666666666, 0.004166666666666667, 0.05)
        _CFrame = v15.CFrame
        Y = _CFrame:PointToWorldSpace(Config.FrontAxle).Y
        Y2 = _CFrame:PointToWorldSpace(Config.RearAxle).Y
        v17 = self[p23]

        if not v17 or math.abs(Y - v17.cbf) > 3 or math.abs(Y2 - v17.cbr) > 3 then
            v17 = {
                dist = 0,
                t = 0,
                yf = 0,
                vf = 0,
                yr = 0,
                vr = 0,
                cvf = 0,
                cvr = 0,
                kf = 0,
                kr = 0,
                cbf = Y,
                cbr = Y2
            }
            v17.seed = (p23:GetAttribute("SpawnToken") or math.random(1, 999)) * 1.37
            self[p23] = v17
        end

        local SpeedKph = p23:GetAttribute("SpeedKph")

        if typeof(SpeedKph) ~= "number" then
            SpeedKph = math.abs((v15.AssemblyLinearVelocity:Dot(_CFrame.LookVector))) * Config.StudMetres * 3.6
        end

        local v22 = p23:GetAttribute("Parked") == true or v15.Anchored

        if v22 then
            SpeedKph = 0
        end

        v17.dist += SpeedKph / (Config.StudMetres * 3.6) * v16
        v17.t += v16

        local RoadFromKph, RoadFullKph = Settings.RoadFromKph, Settings.RoadFullKph
        local v24 = math.clamp((SpeedKph - RoadFromKph) / (RoadFullKph - RoadFromKph), 0, 1)
        local v25 = v24 * v24 * (3 - 2 * v24)
        local RoadFromKph2 = Settings.RoadFromKph
        local v27 = math.clamp((SpeedKph - 0) / (RoadFromKph2 - 0), 0, 1)
        local v28 = v27 * v27 * (3 - 2 * v27)
        local v29 = road(v17.dist, v17.seed, v25) * v28
        local v30 = road(v17.dist - Config.Wheelbase, v17.seed, v25) * v28
        local yf, vf = v17.yf, v17.vf
        local Settings2 = t1.Settings
        local v31 = Settings2.BodyHz * 2 * 3.141592653589793
        local v32 = vf + ((v29 - yf) * v31 * v31 - 2 * Settings2.BodyDamping * v31 * vf) * v16

        v17.yf = yf + v32 * v16
        v17.vf = v32

        local yr, vr = v17.yr, v17.vr
        local Settings3 = t1.Settings
        local v33 = Settings3.BodyHz * 2 * 3.141592653589793
        local v34 = vr + ((v30 - yr) * v33 * v33 - 2 * Settings3.BodyDamping * v33 * vr) * v16

        v17.yr = yr + v34 * v16
        v17.vr = v34

        local FrontAxle, FrontWheelRadius = Config.FrontAxle, Config.FrontWheelRadius
        local v36 = math.min(Config.FrontTyreHalfWidth * BikeDynamics.TyreCrownScale, FrontWheelRadius)
        local v37 = _CFrame:PointToWorldSpace(FrontAxle) - _CFrame.UpVector * (FrontWheelRadius - v36)
        local RearAxle, RearWheelRadius = Config.RearAxle, Config.RearWheelRadius
        local v39 = math.min(Config.RearTyreHalfWidth * BikeDynamics.TyreCrownScale, RearWheelRadius)
        local v40 = _CFrame:PointToWorldSpace(RearAxle) - _CFrame.UpVector * (RearWheelRadius - v39)
        local v41 = groundHit(v37.X, v37.Y, v37.Z)
        local v42 = groundHit(v40.X, v40.Y, v40.Z)

        v17.gyf = v41 and v41.Position.Y
        v17.gyr = v42 and v42.Position.Y

        local v44 = 1 - math.exp(-v16 * Settings.KerbBlend)
        local kf = v17.kf
        local v45 = false

        if v41 then
            local Instance = v41.Instance

            v45 = Instance:GetAttribute("Kerb") == true or string.find(string.lower(Instance.Name), "kerb", 1, true) ~= nil
        end

        v17.kf = kf + ((v45 and 1 or 0) - v17.kf) * v44

        local kr = v17.kr
        local v46 = false

        if v42 then
            local Instance = v42.Instance

            v46 = Instance:GetAttribute("Kerb") == true or string.find(string.lower(Instance.Name), "kerb", 1, true) ~= nil
        end

        v17.kr = kr + ((v46 and 1 or 0) - v17.kr) * v44
        v17.pvf = (v17.pvf or 0) + ((v41 ~= nil and not t5[BikeDynamics.SurfaceOf(v41) or ""] and 1 or 0) - (v17.pvf or 0)) * v44
        v17.pvr = (v17.pvr or 0) + ((v42 ~= nil and not t5[BikeDynamics.SurfaceOf(v42) or ""] and 1 or 0) - (v17.pvr or 0)) * v44

        local LooseHeight = BikeDynamics.LooseHeight
        local v47, v48

        if typeof(LooseHeight) == "function" and BikeDynamics.LooseRide then
            local v50 = 1 - math.exp(-v16 * (BikeDynamics.LooseRide.Blend or 10))
            local v51 = v41 and BikeDynamics.SurfaceOf(v41)
            local v52 = if v51 == "Gravel" or v51 == "Sand" then 1 else 0
            local v53 = if v51 == "Grass" then 1 else 0
            local v54 = v42 and BikeDynamics.SurfaceOf(v42)
            local v55 = if v54 == "Gravel" or v54 == "Sand" then 1 else 0
            local v56 = if v54 == "Grass" then 1 else 0

            v17.lgf = (v17.lgf or 0) + (v52 - (v17.lgf or 0)) * v50
            v17.lsf = (v17.lsf or 0) + (v53 - (v17.lsf or 0)) * v50
            v17.lgr = (v17.lgr or 0) + (v55 - (v17.lgr or 0)) * v50
            v17.lsr = (v17.lsr or 0) + (v56 - (v17.lsr or 0)) * v50

            local v57 = SpeedKph / (Config.StudMetres * 3.6)
            local v58, v59 = LooseHeight(_CFrame:PointToWorldSpace(Config.FrontAxle), v17.lgf, v17.lsf, v57)
            local v60, v61 = LooseHeight(_CFrame:PointToWorldSpace(Config.RearAxle), v17.lgr, v17.lsr, v57)

            v47 = v58 + v59
            v48 = v60 + v61
        else
            v47 = 0
            v48 = 0
        end

        local v62 = (Y - v17.cbf) / v16
        local v63 = (Y2 - v17.cbr) / v16
        local v65 = math.clamp((v62 - v17.cvf) / v16, -3000, 3000)
        local v67 = math.clamp((v63 - v17.cvr) / v16, -3000, 3000)

        v17.cbf = Y
        v17.cbr = Y2
        v17.cvf = v62
        v17.cvr = v63

        local v68 = Settings.SuspHz * 2 * 3.141592653589793
        local SuspDamping, SuspTravel = Settings.SuspDamping, Settings.SuspTravel

        v17.sxvf = (v17.sxvf or 0) + (-v68 * v68 * (v17.sxf or 0) - 2 * SuspDamping * v68 * (v17.sxvf or 0) - v65) * v16
        v17.sxf = (v17.sxf or 0) + v17.sxvf * v16
        v17.sxvr = (v17.sxvr or 0) + (-v68 * v68 * (v17.sxr or 0) - 2 * SuspDamping * v68 * (v17.sxvr or 0) - v67) * v16
        v17.sxr = (v17.sxr or 0) + v17.sxvr * v16

        if SuspTravel < math.abs(v17.sxf) then
            v17.sxf = math.clamp(v17.sxf, -SuspTravel, SuspTravel)
            v17.sxvf = 0
        end

        if SuspTravel < math.abs(v17.sxr) then
            v17.sxr = math.clamp(v17.sxr, -SuspTravel, SuspTravel)
            v17.sxvr = 0
        end

        local v71 = v17.sxf * (v17.pvf or 0)
        local v72 = v17.sxr * (v17.pvr or 0)
        local v73 = p23:GetAttribute("EngineRPM") or 0
        local v74 = 0

        if not v22 and v73 > 500 then
            local EngineIdleShare = Settings.EngineIdleShare
            local v75 = Settings.EngineMovingShare - Settings.EngineIdleShare
            local v77 = math.clamp((SpeedKph - 3) / 37, 0, 1)

            v74 = (EngineIdleShare + v75 * (v77 * v77 * (3 - 2 * v77))) * math.clamp(v73 / 9000, 0.35, 1.2) or 0
        end

        local v80 = v17.t * Settings.EngineHz
        local v81 = Settings.EngineHeave * v74 * math.noise(v80, v17.seed, 1.9)
        local v82 = Settings.EngineRoll * v74 * math.noise(v17.seed, v80, 4.2)
        local WeaveFromKph, WeaveFullKph = Settings.WeaveFromKph, Settings.WeaveFullKph
        local v84 = math.clamp((SpeedKph - WeaveFromKph) / (WeaveFullKph - WeaveFromKph), 0, 1)
        local v85 = v84 * v84 * (3 - 2 * v84)
        local v86 = v17.t * Settings.WeaveHz
        local v89 = Settings.WeaveRoll * v85 * (math.sin(v86 * 2 * 3.141592653589793) * 0.7 + math.noise(v86, v17.seed, 8.8) * 0.6)
        local v92 = Settings.WeaveYaw * v85 * math.sin(v86 * 2 * 3.141592653589793 - 1.1)
        local v93 = v17.yf + v81 + v71
        local v94 = v17.yr + v81 + v72
        local Z = Config.FrontAxle.Z
        local Z2 = Config.RearAxle.Z
        local v95 = Z2 - Z ~= 0 and (v93 - v94) / (Z2 - Z) or 0
        local v96 = v93 + Z * v95
        local t6 = {
            body = CFrame.new(0, v96, 0) * CFrame.Angles(v95, v92, v82 + v89),
            front = v93,
            rear = v94,
            wf = v29 * Settings.WheelShare - (v17.yf + v81),
            wr = v30 * Settings.WheelShare - (v17.yr + v81),
            texF = v29 * Settings.WheelShare,
            texR = v30 * Settings.WheelShare,
            loF = v47,
            loR = v48
        }

        v17.out = t6

        return t6
    end

    if p23 then
        self[p23] = nil
    end

    return t4
end

local function wheel(p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38) -- line: 169
    -- upvalues: BikeDynamics (copy), t1 (copy)
    local Settings = t1.Settings
    local v97 = p27 + p31 + (p38 or 0)

    if not (p33 <= 0.001) and p35 then
        local v99 = p26 + Vector3.new(0, 1, 0) * p27
        local v100 = p25.Position.Y - BikeDynamics.SupportHeight(p25.CFrame.Rotation, v99, p28, p29) + p30
        local v98 = p35 + p34 * (1 - p32) - v100

        if v98 < 0 then
            local v101 = -v98
            local v102 = p37 + Settings.ReleaseBand
            local v104 = math.clamp((v101 - p37) / (v102 - p37), 0, 1)

            v98 *= 1 - v104 * v104 * (3 - 2 * v104)
        end

        return (math.clamp(v97 + (p27 + v98 - v97) * p33, p36[1], p36[2]))
    end

    return (math.clamp(v97, p36[1], p36[2]))
end

local self2 = setmetatable({}, {
    __mode = "k"
})
local self3 = setmetatable({}, {
    __mode = "k"
})

function t1.ApplyRider(p39, p40) -- line: 189
    -- upvalues: self2 (copy), self3 (copy)
    local v113 = p39 and p39.PrimaryPart
    local v112 = p39 and p39:FindFirstChild("RiderSeat")
    local SeatWeld = v112 and v112:FindFirstChild("SeatWeld")

    if not (v113 and SeatWeld and SeatWeld:IsA("Weld")) then
        return
    end

    local v114 = self2[SeatWeld]
    local v115 = self3[SeatWeld]

    if not v114 or v115 and SeatWeld.C0 ~= v115 then
        v114 = SeatWeld.C0
        self2[SeatWeld] = v114
    end

    if p40 == CFrame.identity then
        if SeatWeld.C0 ~= v114 then
            SeatWeld.C0 = v114
        end
    else
        local v116 = v113.CFrame:ToObjectSpace(v112.CFrame)

        SeatWeld.C0 = v116:Inverse() * p40 * v116 * v114
    end

    self3[SeatWeld] = SeatWeld.C0
end

function t1.Wheels(p41, p42, p43) -- line: 201
    -- upvalues: RunService (copy), Config (copy), BikeDynamics (copy), t1 (copy), self (copy), inactive (copy), wheel (copy)
    p42 = p42 or 0
    p43 = p43 or 0

    if not RunService:IsClient() then
        return p42, p43
    end

    local v119 = p41 and p41.PrimaryPart
    local v120 = self[p41]

    if not v119 or not v120 or not v120.out or not t1.Settings.Enabled or inactive(p41, v119) then
        return p42, p43
    end

    local Settings = t1.Settings
    local out = v120.out
    local _CFrame = v119.CFrame
    local v121 = CFrame.Angles(0, 0, (math.atan2(_CFrame.RightVector.Y, _CFrame.UpVector.Y)))
    local v122 = BikeDynamics.SupportHeight(v121, Config.FrontAxle, Config.FrontWheelRadius, Config.FrontTyreHalfWidth)
    local v123 = BikeDynamics.SupportHeight(v121, Config.RearAxle, Config.RearWheelRadius, Config.RearTyreHalfWidth)
    local v125 = Settings.ExtendSlack + math.max(0, v123 - v122)
    local v127 = Settings.ExtendSlack + math.max(0, v122 - v123)

    return wheel(v119, Config.FrontAxle, p42, Config.FrontWheelRadius, Config.FrontTyreHalfWidth, out.front, out.wf, v120.kf, v120.pvf or 0, out.texF or 0, v120.gyf, Settings.FrontTravel, v125, out.loF), (wheel(v119, Config.RearAxle, p43, Config.RearWheelRadius, Config.RearTyreHalfWidth, out.rear, out.wr, v120.kr, v120.pvr or 0, out.texR or 0, v120.gyr, Settings.RearTravel, v127, out.loR))
end

return t1
