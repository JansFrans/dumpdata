-- https://lua.expert

local Config = require(script.Parent:WaitForChild("Config"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StudMetres = Config.StudMetres
local t2 = {
    "FL",
    "FR",
    "RL",
    "RR"
}
local MotoLegends = ReplicatedStorage:FindFirstChild("MotoLegends")
local result
local PitLimiter = MotoLegends and MotoLegends:FindFirstChild("PitLimiter")

if PitLimiter then
    local _require = require
    local ok, result2 = pcall(_require, PitLimiter)

    if ok then
        result = result2
    end
end

local t1 = {}

function t1.TrackWetness() -- line: 32
    -- upvalues: MotoLegends (copy)
    if not MotoLegends then
        return 0
    end

    local TrackWetness = MotoLegends:GetAttribute("TrackWetness")

    if typeof(TrackWetness) == "number" then
        return (math.clamp(TrackWetness, 0, 1))
    end

    if MotoLegends:GetAttribute("Raining") == true then
        return 1
    end

    return 0
end

local function sign(p1) -- line: 39
    if p1 > 0 then
        return 1
    end

    if p1 < 0 then
        return -1
    end

    return 0
end

local function torqueAt(p2) -- line: 43
    -- upvalues: Config (copy)
    local TorqueCurve = Config.TorqueCurve

    if p2 <= TorqueCurve[1][1] then
        return TorqueCurve[1][2]
    end

    for i = 2, #TorqueCurve do
        local v1 = TorqueCurve[i - 1]
        local v2 = TorqueCurve[i]

        if p2 <= v2[1] then
            return v1[2] + (v2[2] - v1[2]) * (p2 - v1[1]) / (v2[1] - v1[1])
        end
    end

    return TorqueCurve[#TorqueCurve][2]
end

t1.TorqueAt = torqueAt

function t1.Ratio(p3) -- line: 54
    -- upvalues: Config (copy)
    if p3 == -1 then
        return Config.ReverseGear
    end

    return if p3 >= 1 then Config.Gears[p3] else nil
end

for v3, v4 in Config.Surfaces do
    v4.name = v3
end

local self = setmetatable({}, {
    __mode = "k"
})

local function surfaceOf(p4) -- line: 65
    -- upvalues: Config (copy), self (copy)
    local Instance = p4.Instance
    local v6 = Instance and self[Instance]

    if v6 and Instance ~= workspace.Terrain then
        return v6
    end

    local v7 = Instance and Instance:GetAttribute("Surface")

    if v7 == "Barrier" then
        v7 = "Asphalt"
    end

    local v8 = typeof(v7) == "string" and Config.Surfaces[v7] or Config.Surfaces[Config.MaterialSurface[p4.Material.Name] or "Asphalt"] or Config.Surfaces.Asphalt

    if Instance and Instance ~= workspace.Terrain then
        self[Instance] = v8
    end

    return v8
end

function t1.New(p5) -- line: 77
    -- upvalues: Config (copy), StudMetres (copy), t2 (copy)
    local PrimaryPart = p5.PrimaryPart
    local t5 = {
        gear = 1,
        shiftAt = -10,
        autoHoldUntil = 0,
        reverseTimer = 0,
        pendingShift = 0,
        steer = 0,
        throttle = 0,
        brake = 0,
        handbrake = false,
        smoothThrottle = 0,
        hb = 0,
        speed = 0,
        kph = 0,
        fwdSpeed = 0,
        slip = 0,
        driveSlip = 0,
        grounded = 0,
        upsideDown = 0,
        tcsActive = false,
        absActive = false,
        escActive = false,
        limiter = false,
        engineBrakeForce = 0,
        car = p5,
        chassis = PrimaryPart,
        wheels = {},
        list = {},
        rpm = Config.IdleRPM,
        transmission = p5:GetAttribute("Transmission") == "Manual" and "Manual" or "Automatic",
        esc = Config.ESC,
        tcs = Config.TCS
    }

    for _, v9 in t2 do
        local v10 = PrimaryPart:WaitForChild("WheelJoint_" .. v9)
        local Part1 = v10.Part1
        local t6 = {
            contact = false,
            load = 0,
            steer = 0,
            vx = 0,
            spinRate = 0,
            slipping = false,
            id = v9,
            joint = v10,
            part = Part1,
            front = v9:sub(1, 1) == "F",
            left = v9:sub(2, 2) == "L",
            rest = v10.C0.Position,
            radius = Part1.Size.Y / 2,
            comp = Config.DroopTravel
        }

        t5.wheels[v9] = t6
        table.insert(t5.list, t6)
    end

    local FL, FR, RL = t5.wheels.FL, t5.wheels.FR, t5.wheels.RL

    t5.wheelbase = math.abs(FL.rest.Z - RL.rest.Z) * StudMetres
    t5.track = math.abs(FL.rest.X - FR.rest.X) * StudMetres
    t5.radius = FL.radius * StudMetres

    local Z = FL.rest.Z
    local Z2 = RL.rest.Z

    t5.frontShare = math.clamp((Z2 - PrimaryPart.CFrame:PointToObjectSpace(PrimaryPart.AssemblyCenterOfMass).Z) / (Z2 - Z), 0.35, 0.65)
    t5.yawInertiaPerMass = (PrimaryPart.Size.X ^ 2 + PrimaryPart.Size.Z ^ 2) / 12
    t5.lift = PrimaryPart:FindFirstChild("Lift")

    if t5.lift and not t5.lift:IsA("VectorForce") then
        t5.lift = nil
    end

    t5.params = RaycastParams.new()
    t5.params.FilterType = Enum.RaycastFilterType.Exclude
    t5.params.FilterDescendantsInstances = { p5 }
    t5.params.RespectCanCollide = true

    local function v14() -- line: 114
        -- upvalues: t5 (copy)
        t5.params.CollisionGroup = "SafetyCar"
    end

    pcall(v14)

    return t5
end

function t1.WheelRPM(p6, p7, p8) -- line: 119
    -- upvalues: Config (copy)
    local v15 = if p7 == -1 then Config.ReverseGear elseif p7 >= 1 then Config.Gears[p7] else nil

    if v15 then
        return math.abs(p8) / p6.radius * 60 / 6.283185307179586 * v15 * Config.FinalDrive
    end

    return 0
end

function t1.RequestShift(p9, p10) -- line: 127
    p9.pendingShift = math.clamp((p9.pendingShift or 0) + p10, -2, 2)
end

local function shift(p11, p12, p13, p14, p15) -- line: 131
    -- upvalues: Config (copy), t1 (copy)
    local gear = p11.gear
    local v17 = if p12 > 0 then if gear == -1 then 0 elseif gear < #Config.Gears then gear + 1 else nil
        elseif gear > 1 then gear - 1
        elseif gear == 1 then 0
        elseif gear == 0 then -1
        else nil

    if v17 == nil or p11.transmission == "Automatic" and v17 < 1 and gear >= 1 or v17 == -1 and p13 > 1.2 or v17 >= 1 and gear <= 0 and p13 < -1.2 or p12 < 0 and v17 >= 1 and t1.WheelRPM(p11, v17, p13) > Config.RedlineRPM + 250 then
        return false
    end

    p11.gear = v17
    p11.shiftAt = p14

    if p15 and p11.transmission == "Automatic" then
        p11.autoHoldUntil = p14 + Config.ManualHold
    end

    return true
end

t1.Shift = shift

local function automatic(p16, p17, p18, p19, p20) -- line: 153
    -- upvalues: Config (copy), t1 (copy)
    local v18 = p18.up or 0
    local v19 = p18.down or 0

    if p18.parked then
        p16.reverseTimer = 0
    elseif p16.gear == -1 then
        if p19 > -0.6 and v18 > 0.5 and v19 < 0.1 then
            p16.reverseTimer += p17

            if p16.reverseTimer >= Config.ReverseEngageDelay then
                p16.gear = 1
                p16.shiftAt = p20
                p16.reverseTimer = 0
            end
        else
            p16.reverseTimer = 0
        end
    else
        if p16.gear == 0 then
            p16.gear = 1
            p16.shiftAt = p20
        end

        if math.abs(p19) < 0.5 and v19 > 0.5 and v18 < 0.1 then
            p16.reverseTimer += p17

            if p16.reverseTimer >= Config.ReverseEngageDelay then
                p16.gear = -1
                p16.shiftAt = p20
                p16.reverseTimer = 0
            elseif not (p20 < p16.autoHoldUntil or p20 - p16.shiftAt < Config.ShiftTime + 0.18) then
                local smoothThrottle = p16.smoothThrottle
                local v20 = t1.WheelRPM(p16, p16.gear, p19)
                local v21 = Config.UpshiftRPMLight + (Config.UpshiftRPM - Config.UpshiftRPMLight) * smoothThrottle

                if p16.gear < #Config.Gears and p19 > 0 and (smoothThrottle > 0.12 and v21 < v20 or Config.UpshiftRPM < v20) then
                    local gear = p16.gear
                    local v22 = if gear == -1 then 0 elseif gear < #Config.Gears then gear + 1 else nil

                    if v22 ~= nil then
                        if p16.transmission == "Automatic" and v22 < 1 and gear >= 1 then
                            return
                        end

                        if v22 ~= -1 or not (p19 > 1.2) then
                            if v22 >= 1 and gear <= 0 and p19 < -1.2 then
                                return
                            end

                            p16.gear = v22
                            p16.shiftAt = p20
                        end
                    end
                elseif p16.gear > 1 then
                    local v23 = Config.DownshiftRPM + 1300 * smoothThrottle

                    if v19 > 0.3 then
                        v23 = math.max(v23, 2600)
                    end

                    if v20 < v23 then
                        local gear = p16.gear
                        local v24 = if gear > 1 then gear - 1
                            elseif gear == 1 then 0
                            elseif gear == 0 then -1
                            else nil

                        if v24 ~= nil then
                            if p16.transmission == "Automatic" and v24 < 1 and gear >= 1 then
                                return
                            end

                            if v24 ~= -1 or not (p19 > 1.2) then
                                if v24 >= 1 and gear <= 0 and p19 < -1.2 then
                                    return
                                end

                                if not (v24 >= 1 and t1.WheelRPM(p16, v24, p19) > Config.RedlineRPM + 250) then
                                    p16.gear = v24
                                    p16.shiftAt = p20
                                end
                            end
                        end
                    elseif smoothThrottle > 0.9 and t1.WheelRPM(p16, p16.gear - 1, p19) < Config.KickdownRPM then
                        local gear = p16.gear
                        local v25 = if gear > 1 then gear - 1
                            elseif gear == 1 then 0
                            elseif gear == 0 then -1
                            else nil

                        if v25 == nil or p16.transmission == "Automatic" and v25 < 1 and gear >= 1 or v25 == -1 and p19 > 1.2 or v25 >= 1 and gear <= 0 and p19 < -1.2 or v25 >= 1 and t1.WheelRPM(p16, v25, p19) > Config.RedlineRPM + 250 then
                            return
                        end

                        p16.gear = v25
                        p16.shiftAt = p20
                    end
                end
            end
        else
            p16.reverseTimer = 0

            if not (p20 < p16.autoHoldUntil) and not (p20 - p16.shiftAt < Config.ShiftTime + 0.18) then
                local smoothThrottle = p16.smoothThrottle
                local v26 = t1.WheelRPM(p16, p16.gear, p19)
                local v27 = Config.UpshiftRPMLight + (Config.UpshiftRPM - Config.UpshiftRPMLight) * smoothThrottle

                if p16.gear < #Config.Gears and p19 > 0 then
                    local gear, v28

                    if smoothThrottle > 0.12 and v27 < v26 then
                        gear = p16.gear

                        if gear == -1 then
                            v28 = 0
                        elseif gear < #Config.Gears then
                            v28 = gear + 1
                        end

                        if v28 ~= nil then
                            if p16.transmission == "Automatic" and v28 < 1 and gear >= 1 or v28 == -1 and p19 > 1.2 or v28 >= 1 and gear <= 0 and p19 < -1.2 then
                                return
                            end

                            p16.gear = v28
                            p16.shiftAt = p20
                        end

                        return
                    end

                    if Config.UpshiftRPM < v26 then
                        gear = p16.gear
                        v28 = if gear == -1 then 0 elseif gear < #Config.Gears then gear + 1 else nil

                        if v28 ~= nil then
                            if p16.transmission == "Automatic" and v28 < 1 and gear >= 1 or v28 == -1 and p19 > 1.2 or v28 >= 1 and gear <= 0 and p19 < -1.2 then
                                return
                            end

                            p16.gear = v28
                            p16.shiftAt = p20
                        end

                        return
                    end
                end

                if p16.gear > 1 then
                    local v29 = Config.DownshiftRPM + 1300 * smoothThrottle

                    if v19 > 0.3 then
                        v29 = math.max(v29, 2600)
                    end

                    if v26 < v29 then
                        local gear = p16.gear
                        local v30 = if gear > 1 then gear - 1
                            elseif gear == 1 then 0
                            elseif gear == 0 then -1
                            else nil

                        if v30 ~= nil then
                            if p16.transmission == "Automatic" and v30 < 1 and gear >= 1 or v30 == -1 and p19 > 1.2 or v30 >= 1 and gear <= 0 and p19 < -1.2 or v30 >= 1 and t1.WheelRPM(p16, v30, p19) > Config.RedlineRPM + 250 then
                                return
                            end

                            p16.gear = v30
                            p16.shiftAt = p20
                        end
                    elseif smoothThrottle > 0.9 and t1.WheelRPM(p16, p16.gear - 1, p19) < Config.KickdownRPM then
                        local gear = p16.gear
                        local v31 = if gear > 1 then gear - 1
                            elseif gear == 1 then 0
                            elseif gear == 0 then -1
                            else nil

                        if v31 == nil or p16.transmission == "Automatic" and v31 < 1 and gear >= 1 or v31 == -1 and p19 > 1.2 or v31 >= 1 and gear <= 0 and p19 < -1.2 or v31 >= 1 and t1.WheelRPM(p16, v31, p19) > Config.RedlineRPM + 250 then
                            return
                        end

                        p16.gear = v31
                        p16.shiftAt = p20
                    end
                end
            end
        end
    end
end

function t1.Step(p21, p22, p23) -- line: 192
    -- upvalues: Config (copy), t1 (copy), StudMetres (copy), result (ref), torqueAt (copy), surfaceOf (copy), shift (copy), automatic (copy)
    local chassis = p21.chassis

    if chassis.Parent and not chassis.Anchored then
        local v32 = math.clamp(p22, 0.004166666666666667, 0.06666666666666667)
        local elapsed = os.clock()
        local _CFrame = chassis.CFrame
        local UpVector, LookVector = _CFrame.UpVector, _CFrame.LookVector
        local AssemblyMass = chassis.AssemblyMass

        if not (AssemblyMass > 0 and AssemblyMass < 1e999) then
            return
        end

        local v33 = AssemblyMass / (Config.Mass * StudMetres)
        local AssemblyLinearVelocity = chassis.AssemblyLinearVelocity
        local Gravity = Config.Gravity
        local v34 = Vector3.new(0, 1, 0) * (AssemblyMass * (workspace.Gravity - Gravity / StudMetres))
        local hit = p21.lift

        if hit and hit.Parent == chassis then
            if not ((hit.Force - v34).Magnitude <= 1) then
                hit.Force = v34
            end

            if not hit.Enabled then
                hit.Enabled = true
            end
        else
            chassis:ApplyImpulse(v34 * v32)
        end

        if p21.lastStep == nil or elapsed - p21.lastStep > 0.25 then
            p21.softUntil = elapsed + Config.SoftStart

            for _, v35 in p21.list do
                v35.contact = false
                v35.prevComp = nil
            end
        end

        p21.lastStep = elapsed
        hit = elapsed < (p21.softUntil or 0)

        local v36 = t1.TrackWetness()

        p21.wetness = v36

        local v37 = 1 - (1 - Config.RainGrip) * v36
        local v38 = AssemblyLinearVelocity:Dot(LookVector) * StudMetres

        p21.fwdSpeed = v38
        p21.speed = AssemblyLinearVelocity.Magnitude * StudMetres
        p21.kph = p21.speed * 3.6

        local ok, result2

        if result then
            if elapsed - (p21.pitCheckAt or 0) > 0.1 then
                p21.pitCheckAt = elapsed
                result2 = result.Contains

                local CFramePosition = _CFrame.Position

                ok, result2 = pcall(result2, CFramePosition)
                p21.inPit = ok and result2 == true
            end
        else
            p21.inPit = false
        end

        ok = Config.PitLimitKph or 60
        result2 = p21.pendingShift or 0

        local v39, v40

        if result2 ~= 0 then
            p21.pendingShift = 0
            v40 = if result2 > 0 then 1 elseif result2 < 0 then -1 else 0
            v39 = math.abs(result2)

            for _ = 1, v39 do
                shift(p21, v40, v38, elapsed, true)
            end
        end

        if p23.parked then
            p21.gear = 0
        elseif p21.transmission == "Automatic" then
            automatic(p21, v32, p23, v38, elapsed)
        end

        v40 = p23.up or 0

        local v41 = p23.down or 0

        if p21.gear ~= -1 or p21.transmission ~= "Automatic" then
            v41, v40 = v40, v41
        end

        local v42 = math.clamp(v41, 0, 1)
        local v43 = math.clamp(v40, 0, 1)
        local wheelbase

        if p21.inPit and v38 > 0 and p21.kph > ok + 2 then
            wheelbase = (p21.kph - ok) / 25
            v39 = math.clamp(wheelbase, 0.2, 0.85)
            v43 = math.max(v43, v39)
        end

        p21.smoothThrottle = p21.smoothThrottle + (v42 - p21.smoothThrottle) * math.min(1, v32 * 5)
        result2 = p23.handbrake == true

        local gear = p21.hb

        wheelbase = if result2 then 1 else 0
        v39 = wheelbase - p21.hb

        local v44 = v32 * (result2 and Config.HandbrakeOnRate or Config.HandbrakeOffRate)

        p21.hb = gear + v39 * math.min(1, v44)

        if p21.hb < 0.005 then
            p21.hb = 0
        end

        gear = p21.gear

        local v45 = if gear == -1 then Config.ReverseGear elseif gear >= 1 then Config.Gears[gear] else nil

        v39 = elapsed - p21.shiftAt < Config.ShiftTime
        elapsed = t1.WheelRPM(p21, gear, v38) * (1 + p21.driveSlip)

        local v46, v47, v48, v49, v50

        if v45 then
            wheelbase = Config.IdleRPM

            if gear == 1 or gear == -1 then
                wheelbase += v42 * (Config.LaunchRPM - Config.IdleRPM)
            end

            v47 = math.max(elapsed, wheelbase)
            v44 = p21.rpm
            v48 = v47 - p21.rpm
            v49 = v32 * 16
            p21.rpm = v44 + v48 * math.min(1, v49)
        else
            wheelbase = Config.IdleRPM + v42 * (Config.RedlineRPM - Config.IdleRPM)
            v47 = p21.rpm
            v46 = wheelbase - p21.rpm
            v49 = if p21.rpm < wheelbase then 6 else 2.5
            v50 = v32 * v49
            p21.rpm = v47 + v46 * math.min(1, v50)
        end

        v47 = p21.rpm
        p21.rpm = math.clamp(v47, Config.IdleRPM * 0.9, Config.RedlineRPM + 120)
        p21.limiter = false
        p21.engineBrakeForce = 0

        local v51

        if v45 then
            local v52 = torqueAt(p21.rpm) * v42

            if p21.rpm >= Config.RedlineRPM then
                v52 = 0
                p21.limiter = true
            end

            if gear > 0 and p21.kph >= Config.TopSpeedKph and v38 > 0 then
                v51 = 0
                p21.limiter = true
            else
                v51 = v52
            end

            if p21.inPit and gear > 0 and v38 > 0 then
                v47 = (ok - p21.kph) / 4
                v51 *= math.clamp(v47, 0, 1)
            end

            if gear == -1 and v38 < -10 then
                v51 = 0
            end

            if v39 then
                v51 *= 0.15
            end

            if p21.escCut then
                v51 *= p21.escCut
            end

            v47 = (p21.rpm - Config.IdleRPM) / (Config.RedlineRPM - Config.IdleRPM)
            wheelbase = math.clamp(v47, 0, 1)
            p21.engineBrakeForce = Config.EngineBrake * wheelbase * (1 - v42) * v45 * Config.FinalDrive * Config.Efficiency / p21.radius
        else
            v51 = 0
        end

        v39 = v51 * (v45 or 0) * Config.FinalDrive * Config.Efficiency / p21.radius

        if gear == -1 then
            v39 = -v39
        end

        p21.throttle = v42
        p21.brake = v43
        p21.handbrake = result2
        wheelbase = p21.wheelbase
        v47 = p21.track
        v46 = Config.MaxSteerDeg

        local v53 = math.rad(v46)

        v44 = math.abs(v38)

        local v54 = _CFrame:VectorToObjectSpace(AssemblyLinearVelocity)
        local v55, tcs

        if v44 > 1 then
            v48 = v54.X
            v46 = math.abs(v48)
            v50 = v54.Z
            v55 = math.abs(v50)
            v48 = math.max(v55, 0.1)
            tcs = math.atan2(v46, v48) or 0
        else
            tcs = 0
        end

        p21.beta = tcs

        local v56, v57, v58

        if v44 > 1 then
            v50 = wheelbase * (Config.SteerGrip * Gravity * v37) / (v44 * v44)
            v55 = math.atan(v50)
            v49 = Config.SteerSlipDeg
            v48 = v55 + math.rad(v49)
            v50 = Config.MinSteerDeg
            v55 = math.rad(v50)
            v56 = math.clamp(v48, v55, v53)

            if (p23.steer or 0) * v54.X > 0 and Config.SlipPeakRear * 1.6 < tcs then
                v58 = Config.SteerSlipDeg
                v49 = tcs + math.rad(v58)
                v55 = math.max(v56, v49)
                v57 = math.min(v53, v55)
            else
                v57 = v56
            end

            if p21.hb > 0.3 then
                v55 = v53 / (1 + (v44 / Config.HandbrakeSteerRef) ^ 2)
                v57 = math.max(v57, v55)
            end
        else
            v57 = v53
        end

        if p21.steerLock and v57 < p21.steerLock then
            tcs = p21.steerLock
            v48 = v57 - p21.steerLock
            v49 = v32 * 5
            v57 = tcs + v48 * math.min(1, v49)
        end

        local v59

        if p21.steerLock and p21.steerLock < v57 then
            v55 = p21.steerLock
            v59 = Config.LockRiseRate
            v48 = v55 + math.rad(v59) * v32
            v57 = math.min(v57, v48)
        end

        p21.steerLock = v57
        v45 = math.clamp(p23.steer or 0, -1, 1) * v57
        p21.steer = v45

        if math.abs(v45) > 1E-04 then
            v55 = math.abs(v45)
            v40 = wheelbase / math.tan(v55)
            v49 = wheelbase / (v40 - v47 / 2)
            v50 = math.atan(v49)
            v55 = math.atan(wheelbase / (v40 + v47 / 2))

            if not (v45 > 0) then
                v55, v50 = -v50, -v55
            end
        else
            v50 = v45
            v55 = v45
        end

        v48 = p21.wheels.FL

        local FR = p21.wheels.FR

        v48.steer = v55
        FR.steer = v50
        v56 = Config.BumpTravel + Config.DroopTravel
        tcs = p21.params
        v47 = 0

        local v61, v62, v63, load, v64, Unit, v65, v66, v67, v68

        for _, v69 in p21.list do
            v63 = v69.rest
            load = Config.BumpTravel / StudMetres

            local v70 = _CFrame:PointToWorldSpace(v63 + Vector3.new(0, load, 0))
            local v71 = workspace:Raycast(v70, -UpVector * (v56 / StudMetres + v69.radius), tcs)

            v69.top = v70

            if v71 then
                v47 += 1
                v68 = v56 - (v71.Distance - v69.radius) * StudMetres
                v58 = math.clamp(v68, 0, v56)
                v68 = if v69.contact and v69.prevComp then (v58 - v69.prevComp) / v32 else -chassis:GetVelocityAtPosition(v70):Dot(UpVector) * StudMetres
                v61 = hit and math.clamp(v68, -1, 1) or math.clamp(v68, -4, 4)
                v69.prevComp = v58
                v69.comp = v58
                v69.hit = v71
                v69.contact = true

                local SpringFront = v69.front and Config.SpringFront or Config.SpringRear

                v63 = v69.front and p21.frontShare or 1 - p21.frontShare
                v62 = Config.Mass * v63 / 2
                v63 = v62 * Gravity + SpringFront * (v58 - Config.DroopTravel)
                v67 = v56 - Config.BumpStopRange

                if v67 < v58 then
                    v63 += SpringFront * Config.BumpStopRate * (v58 - v67)
                end

                v64 = SpringFront * v62
                v63 += v61 * (math.sqrt(v64) * 2) * (v61 > 0 and Config.DampBump or Config.DampRebound)
                v65 = v62 * Gravity
                v66 = if hit then 1.3 else Config.MaxWheelLoad
                Unit = v65 * v66
                v69.force = math.min(v63, Unit)
            else
                v69.contact = false
                v69.prevComp = nil
                v69.comp = 0
                v69.hit = nil
                v69.force = 0
            end
        end

        for _, v72 in {
                {
                    p21.wheels.FL,
                    p21.wheels.FR,
                    Config.AntiRollFront
                },
                {
                    p21.wheels.RL,
                    p21.wheels.RR,
                    Config.AntiRollRear
                }
            } do
            v58 = v72[1]
            v68 = v72[2]
            v56 = v72[3] * (v58.comp - v68.comp)

            if v58.contact then
                v58.force += v56
            end

            if v68.contact then
                v68.force -= v56
            end
        end

        p21.grounded = v47
        v48 = Config.FrontTorqueShare / 2
        v55 = (1 - Config.FrontTorqueShare) / 2
        tcs = p21.tcs
        p21.tcsActive = false
        v50 = 0
        v49 = 0
        v59 = 0
        p21.absActive = false

        for _, v73 in p21.list do
            load = v73.force or 0
            v73.load = math.max(load, 0)
            v73.slipping = false

            if v73.contact then
                hit = v73.hit
                v67 = hit.Normal
                load = v73.load
                v64 = hit.Position + UpVector * v73.radius
                chassis:ApplyImpulseAtPosition(UpVector * (load * v32 * v33), v64)

                local v74 = v73.steer

                v66 = math.sin(v74)

                local v75 = v73.steer
                local v76 = -math.cos(v75)

                v64 = _CFrame:VectorToWorldSpace((Vector3.new(v66, 0, v76)))
                Unit = v64 - v67 * v64:Dot(v67)

                if not (Unit.Magnitude < 0.001) then
                    Unit = Unit.Unit
                    v65 = Unit:Cross(v67)
                    v67 = chassis:GetVelocityAtPosition(hit.Position) * StudMetres
                    v74 = v67:Dot(Unit)
                    v66 = v67:Dot(v65)
                    v73.vx = v74

                    local v77 = surfaceOf(hit)

                    v73.surface = v77.name

                    local v78 = v73.front and p21.frontShare or 1 - p21.frontShare

                    v76 = Config.Mass * v78 / 2
                    v78 = if v77.name == "Grass" or v77.name == "Gravel" or v77.name == "Sand" then v37 * (1 - (1 - Config.LooseRainGrip) * v36) else v37
                    v75 = Config.Grip * v77.grip * v78

                    local SlipPeakFront = v75 * (if v73.front then 1 else Config.RearGrip)

                    v59 += SlipPeakFront
                    v75 = SlipPeakFront * load
                    v78 = v75 * math.clamp(1 - Config.LoadSensitivity * (load / (v76 * Gravity) - 1), 0.75, 1.15)
                    SlipPeakFront = v73.front and Config.SlipPeakFront or Config.SlipPeakRear
                    v75 = v39 * (v73.front and v48 or v55)

                    local v79 = v43 * Config.BrakeG * Config.Mass * Gravity * (v73.front and Config.BrakeBias or 1 - Config.BrakeBias) / 2
                    local v80 = if v73.front then 0 else p21.hb
                    local v81 = v80 > 0.05
                    local v82

                    if v81 then
                        v82 = v80 * Config.HandbrakeG * Config.Mass * Gravity * (1 - p21.frontShare) / 2
                        v79 = math.max(v79, v82)
                    end

                    local v83 = p21.engineBrakeForce * (v73.front and v48 or v55)

                    if v80 > 0 then
                        v75 *= 1 - v80
                        v83 *= 1 - v80
                    end

                    local v84 = (Config.RollingResistance + v77.drag) * load
                    local v85, v86, v87, v88, v89

                    if math.abs(v74) > 0.3 then
                        load = v79 + v83 + v84
                        v89 = math.abs(v74) * v76 / v32 * 0.5
                        v86 = if v74 > 0 then 1 elseif v74 < 0 then -1 else 0
                        v87 = v75 * v86
                        v67 = v89 + math.max(0, v87)
                        v88 = if v74 > 0 then 1 elseif v74 < 0 then -1 else 0
                        v82 = v75 - v88 * math.min(load, v67)
                    else
                        v89 = v79 + v84

                        if math.abs(v75) <= v89 then
                            v88 = 0
                        else
                            v87 = if v75 > 0 then 1 elseif v75 < 0 then -1 else 0
                            v88 = v75 - v87 * v89
                        end

                        v85 = v74 * v76 / v32
                        v87 = if v79 > 0 then 0.5 else 0.1
                        v82 = v88 - v85 * v87
                    end

                    if v79 > 0 or v81 then
                        if v75 == 0 then
                            v84 = true
                        else
                            v85 = if v82 > 0 then 1 elseif v82 < 0 then -1 else 0
                            v87 = if v75 > 0 then 1 elseif v75 < 0 then -1 else 0
                            v84 = v85 ~= v87
                        end
                    else
                        v84 = v81
                    end

                    v83 = if v84 then Config.ABS and not v81 or not v84 else v75 ~= 0 and tcs

                    local min

                    if v78 < math.abs(v82) then
                        if v84 then
                            if Config.ABS then
                                v87 = if v82 > 0 then 1 elseif v82 < 0 then -1 else 0

                                if v81 then
                                    v82 = v87 * v78 * 0.9
                                else
                                    v82 = v87 * v78 * 0.95
                                    p21.absActive = p21.absActive or v43 > 0.05
                                end

                                v89 = false
                            else
                                v87 = if v82 > 0 then 1 elseif v82 < 0 then -1 else 0

                                if v81 then
                                    v82 = v87 * v78 * 0.9
                                    v89 = false
                                else
                                    v82 = v87 * v78 * Config.SpinGrip
                                    v89 = true
                                end
                            end

                            v88 = false
                        elseif tcs then
                            v87 = if v82 > 0 then 1 elseif v82 < 0 then -1 else 0
                            v82 = v87 * v78 * 0.97
                            v89 = false
                            v88 = false
                            p21.tcsActive = true
                        else
                            v79 = math.abs(v82) / math.max(v78, 1)
                            v87 = if v82 > 0 then 1 elseif v82 < 0 then -1 else 0
                            v82 = v87 * v78 * Config.SpinGrip
                            min = (v79 - 1) * 0.5
                            v86 = math.clamp(min, 0, 0.6)
                            v49 = math.max(v49, v86)
                            v89 = false
                            v88 = true
                        end
                    else
                        v89 = false
                        v88 = false
                    end

                    v87 = math.abs(v66)
                    min = math.abs(v74)
                    v86 = math.max(min, 1)
                    v85 = math.atan2(v87, v86)
                    v75 = v85 / SlipPeakFront

                    local v90, v91

                    if v75 < 1 then
                        v91 = v75 * (2 - v75)

                        if not v91 then
                            v86 = 1 - Config.SlideGrip
                            v90 = (v85 - SlipPeakFront) / math.rad(Config.SlideFalloffDeg)
                            v91 = 1 - v86 * math.min(1, v90)
                        end
                    else
                        v86 = 1 - Config.SlideGrip
                        v90 = (v85 - SlipPeakFront) / math.rad(Config.SlideFalloffDeg)
                        v91 = 1 - v86 * math.min(1, v90)
                    end

                    v75 = v78 * v91

                    if v88 then
                        v75 *= 0.45
                    end

                    if v80 > 0 then
                        v75 *= 1 - v80 * (1 - Config.HandbrakeSideGrip)
                    end

                    v86 = if v66 > 0 then 1 elseif v66 < 0 then -1 else 0
                    v87 = -v86

                    local v94 = math.abs(v66) * v76 / v32 * 0.5

                    v91 = v87 * math.min(v75, v94)

                    if v89 then
                        v86 = v74 * v74 + v66 * v66
                        v87 = math.sqrt(v86)

                        if v87 > 0.5 then
                            v76 = v78 * Config.SpinGrip
                            v82 = -v76 * v74 / v87
                            v91 = -v76 * v66 / v87
                        end
                    elseif v82 * v82 + v91 * v91 > v78 * v78 then
                        if v83 then
                            min = v78 * v78 - v91 * v91
                            v86 = math.max(min, 0)
                            v87 = math.sqrt(v86)

                            if v84 then
                                v94 = v78 * Config.ABSMinShare
                                v87 = math.max(v87, v94)
                            end

                            if v87 < math.abs(v82) then
                                v86 = if v82 > 0 then 1 elseif v82 < 0 then -1 else 0
                                v82 = v86 * v87

                                if v84 then
                                    p21.absActive = p21.absActive or v43 > 0.05
                                else
                                    p21.tcsActive = true
                                end
                            end
                        end

                        min = v78 * v78 - v82 * v82
                        v86 = math.max(min, 0)
                        v87 = math.sqrt(v86)

                        if v87 < math.abs(v91) then
                            v86 = if v91 > 0 then 1 elseif v91 < 0 then -1 else 0
                            v91 = v86 * v87
                        end
                    end

                    chassis:ApplyImpulseAtPosition((Unit * v82 + v65 * v91) * (v32 * v33), hit.Position + UpVector * (v73.radius * 0.5))
                    v91 = v80 > 0.5 and math.abs(v74) > 2
                    v73.slipping = v89 or v88 or v91 or SlipPeakFront * 1.6 < v85
                    v73.marking = v89 or v88 or v91 or SlipPeakFront * 1.3 < v85

                    if v89 or v91 then
                        v73.spinRate = 0
                    else
                        v73.spinRate = v74 / p21.radius * (v88 and 1.6 or 1)
                    end

                    min = math.clamp((v85 - SlipPeakFront) / 0.24434609527920614, 0, 1)
                    v94 = if v89 or v88 then 1 else 0
                    v90 = if v91 then 0.8 else 0
                    v50 = math.max(v50, min, v94, v90)
                end

                continue
            end

            v73.vx = v38
        end

        p21.slip = v50
        v58 = p21.driveSlip
        v61 = v49 - p21.driveSlip
        p21.driveSlip = v58 + v61 * math.min(1, v32 * 8)
        v49 = AssemblyLinearVelocity * StudMetres
        v50 = v49.Magnitude

        if v50 > 0.5 then
            v55 = 0.5 * Config.AirDensity * v50 * v50
            chassis:ApplyImpulse(-v49.Unit * (v55 * Config.CdA * v32 * v33))

            if v47 > 0 then
                v48 = v55 * Config.ClA
                v58 = p21.wheels.FL.rest
                v68 = p21.wheels.RL.rest
                v62 = -UpVector * (v48 * Config.DownforceFront * v32 * v33)
                v66 = v58.Z
                chassis:ApplyImpulseAtPosition(v62, _CFrame:PointToWorldSpace((Vector3.new(0, 0, v66))))
                v62 = -UpVector * (v48 * (1 - Config.DownforceFront) * v32 * v33)
                v66 = v68.Z
                chassis:ApplyImpulseAtPosition(v62, _CFrame:PointToWorldSpace((Vector3.new(0, 0, v66))))
            end
        end

        p21.escActive = false
        p21.escCut = nil

        local v95, v96

        if not (not p21.esc or result2 and p21.hb > 0.5) then
            local v97 = false
            local v98 = false
            local v99 = false
            local v100 = false
            local v101 = false

            if v47 >= 3 then
                v97 = true
            else
                v101 = true
            end

            if v97 then
                if math.abs(v38) > 6 then
                    v98 = true
                else
                    v101 = true
                end
            end

            v97 = false

            local v102, v103

            if v98 then
                v95 = chassis.AssemblyAngularVelocity:Dot(UpVector)
                v68 = v59 / math.max(v47, 1)
                v61 = Config.ESCGrip
                tcs = math.min(v68, v61) * Gravity / v44
                v103 = Config.ESCMargin
                v61 = 15 / v44
                v102 = v103 * math.clamp(v61, 0.35, 1)
                v68 = -v38 * math.tan(v45) / wheelbase
                v61 = -tcs
                v103 = math.clamp(v68, v61, tcs)

                if v102 < math.abs(v95) - math.abs(v103) then
                    v101 = false
                else
                    v97 = true
                end
            end

            v98 = false

            if v97 then
                if v95 > 0 then
                    v99 = true
                else
                    v98 = true
                end
            end

            v97 = false

            if v98 then
                if v95 < 0 then
                    v100 = true
                else
                    v97 = true
                end
            end

            v98 = false

            local v104

            if v97 then
                v104 = 0
                v98 = true
            end

            v97 = false

            if v100 then
                v104 = -1
                v98 = true
            end

            v100 = false

            if v99 then
                v104 = 1
                v98 = true
            end

            v99 = false

            if v98 then
                if v103 > 0 then
                    v97 = true
                else
                    v100 = true
                end
            end

            v98 = false

            if v100 then
                if v103 < 0 then
                    v99 = true
                else
                    v98 = true
                end
            end

            v100 = false

            if v98 then
                v96 = 0
                v100 = true
            end

            if v99 then
                v96 = -1
                v100 = true
            end

            v99 = false

            if v97 then
                v96 = 1
                v100 = true
            end

            if v100 then
                if v104 == v96 then
                    v101 = true
                else
                    v99 = true
                end
            end

            v100 = false

            if v99 then
                if math.abs(v95) > v102 * 2 then
                    v100 = true
                else
                    v101 = true
                end
            end

            if v100 then
                v101 = not (math.abs(v103) > 0.02)
            end

            if not v101 then
                v41 = v95 - v103
                v63 = if v41 > 0 then 1 elseif v41 < 0 then -1 else 0
                v95 = -(v41 - v63 * v102)
                v63 = Config.ESCGain * v32
                chassis:ApplyAngularImpulse(UpVector * (v95 * math.min(1, v63) * AssemblyMass * p21.yawInertiaPerMass))
                p21.escActive = true
                v96 = 1 - math.abs(v41) * 1.5
                p21.escCut = math.clamp(v96, 0.2, 1)
            end
        end

        if UpVector.Y < 0.35 then
            p21.upsideDown += v32
        else
            p21.upsideDown = 0
        end

        if p21.upsideDown > 2.5 and p21.speed < 4 then
            p21.upsideDown = 0
            v95 = LookVector.X
            v61 = LookVector.Z

            local v105 = Vector3.new(v95, 0, v61)

            if v105.Magnitude < 0.1 then
                v96 = _CFrame.UpVector.X
                v63 = _CFrame.UpVector.Z
                v105 = Vector3.new(v96, 0, v63)
            end

            if v105.Magnitude < 0.1 then
                v105 = Vector3.new(0, 0, 1)
            end

            v47 = _CFrame.Position + Vector3.new(0, 6, 0)
            chassis.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            chassis.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            chassis.CFrame = CFrame.lookAt(v47, v47 + v105.Unit)
        end
    end
end

local t7 = {
    FL = 1,
    FR = 2,
    RL = 4,
    RR = 8
}

function t1.WheelMask(p24) -- line: 555
    -- upvalues: t7 (copy)
    local n1 = 0

    for _, v106 in p24.list do
        if v106.contact then
            local surface = v106.surface

            if surface == "Gravel" or surface == "Sand" then
                if p24.speed > 1.5 then
                    n1 += t7[v106.id] * 16
                end
            elseif v106.marking and (surface == "Asphalt" or surface == "Kerb") and p24.speed > 2 then
                n1 += t7[v106.id]
            end
        end
    end

    return n1
end

return t1
