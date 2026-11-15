-- https://lua.expert

local Config = require(script.Parent.Config)
local t1 = {
    Settings = {
        Restitution = 0.2,
        Friction = 0.35,
        YawShare = 0.2,
        MaxYawKick = 1.4,
        LeanShare = 0.08,
        MaxLeanKick = 0.8,
        MinClosingKph = 4,
        ToleranceFrontSide = 11,
        ToleranceRearSide = 15,
        ToleranceMidSide = 20,
        ToleranceFrontEnd = 17,
        ToleranceRearEnd = 28,
        LeanWeakness = 0.9,
        LowSpeedKph = 25,
        LoopoverKph = 30,
        WobbleFrom = 0.5,
        Luck = 0.12,
        PushStiffness = 12,
        MaxPush = 8,
        PairCooldown = 0.4,
        MarginX = 0.15,
        MarginY = 0.2,
        MarginZ = 0.15
    }
}

function t1.Get(p1) -- line: 40
    -- upvalues: t1 (copy)
    local Attribute = workspace:GetAttribute("BikeContact_" .. p1)

    if typeof(Attribute) ~= "number" or Attribute ~= Attribute then
        return t1.Settings[p1]
    end

    return Attribute
end

function t1.Flat(p2) -- line: 45
    return (Vector3.new(p2.X, 0, p2.Z))
end

function t1.Enabled() -- line: 47
    return workspace:GetAttribute("BikeCollision") == true
end

local ok, result

function t1.Mass(p3) -- line: 51
    -- upvalues: ok (ref), result (ref)
    if ok == nil then
        local _require = require
        local BikeDynamics = script.Parent.BikeDynamics

        ok, result = pcall(_require, BikeDynamics)
    end

    local v1 = ok and result.Weight
    local BikeKg = v1 and v1.BikeKg or 157
    local RiderWeightKg = p3 and p3:GetAttribute("RiderWeightKg")

    return BikeKg + math.clamp(if typeof(RiderWeightKg) == "number" and RiderWeightKg == RiderWeightKg then RiderWeightKg else v1 and v1.RiderKg or 70, 40, 130)
end

function t1.Body(p4) -- line: 61
    local BikeBodyContact = p4 and p4:FindFirstChild("BikeBodyContact")

    return if BikeBodyContact and BikeBodyContact:IsA("BasePart") then BikeBodyContact else nil
end

function t1.Touch(p5, p6, p7, p8) -- line: 68
    -- upvalues: t1 (copy)
    local v3 = Vector3.new(t1.Get("MarginX"), t1.Get("MarginY"), t1.Get("MarginZ"))
    local v4 = p6 / 2 + v3
    local v5 = p8 / 2 + v3
    local t2 = {
        p5.RightVector,
        p5.UpVector,
        p5.LookVector
    }
    local t3 = {
        p7.RightVector,
        p7.UpVector,
        p7.LookVector
    }
    local t4 = {
        v4.X,
        v4.Y,
        v4.Z
    }
    local t5 = {
        v5.X,
        v5.Y,
        v5.Z
    }
    local v6 = p7.Position - p5.Position

    local function radius(p9) -- line: 74
        -- upvalues: t2 (copy), t3 (copy), t4 (copy), t5 (copy)
        return math.abs((t2[1]:Dot(p9))) * t4[1] + math.abs((t2[2]:Dot(p9))) * t4[2] + math.abs((t2[3]:Dot(p9))) * t4[3], math.abs((t3[1]:Dot(p9))) * t5[1] + math.abs((t3[2]:Dot(p9))) * t5[2] + math.abs((t3[3]:Dot(p9))) * t5[3]
    end

    local function separated(p10) -- line: 78
        -- upvalues: v6 (copy), radius (copy)
        if p10.Magnitude < 1E-04 then
            return false
        end

        local Unit = p10.Unit
        local v18, v19 = radius(Unit)

        return math.abs((v6:Dot(Unit))) > v18 + v19
    end

    for i = 1, 3 do
        local v21 = t2[i]
        local v22

        if v21.Magnitude < 1E-04 then
            v22 = false
        else
            local Unit = v21.Unit
            local v23, v24 = radius(Unit)

            v22 = math.abs((v6:Dot(Unit))) > v23 + v24
        end

        local v26

        if v22 then
            v26 = false
        else
            local v27 = t3[i]
            local v28

            if v27.Magnitude < 1E-04 then
                v28 = false
            else
                local Unit = v27.Unit
                local v29, v30 = radius(Unit)

                v28 = math.abs((v6:Dot(Unit))) > v29 + v30
            end

            v26 = not v28
        end

        if not v26 then
            return nil
        end
    end

    for i = 1, 3 do
        for j = 1, 3 do
            local v32 = t2[i]:Cross(t3[j])

            if not (v32.Magnitude < 1E-04) then
                local Unit = v32.Unit
                local v33, v34 = radius(Unit)

                if math.abs((v6:Dot(Unit))) > v33 + v34 then
                    return nil
                end
            end
        end
    end

    local v36, v37

    for _, v38 in {
            t2[1],
            t2[3],
            t3[1],
            t3[3]
        } do
        local v39 = Vector3.new(v38.X, 0, v38.Z)

        if v39.Magnitude > 0.1 then
            local Unit = v39.Unit
            local v40, v41 = radius(Unit)
            local v44 = v40 + v41 - math.abs((v6:Dot(Unit)))

            if not v37 or v44 < v37 then
                v37 = v44
                v36 = if v6:Dot(Unit) >= 0 and Unit then Unit else -Unit
            end
        end
    end

    if not v36 then
        local v45 = Vector3.new(v6.X, 0, v6.Z)

        v36 = v45.Magnitude > 0.05 and v45.Unit or Vector3.new(1, 0, 0)
        v37 = 0
    end

    return v36, (math.max(v37, 0))
end

local function clampInto(p11, p12, p13) -- line: 102
    local v46 = p11:PointToObjectSpace(p13)
    local v47 = p12 / 2

    return p11:PointToWorldSpace((Vector3.new(math.clamp(v46.X, -v47.X, v47.X), math.clamp(v46.Y, -v47.Y, v47.Y), (math.clamp(v46.Z, -v47.Z, v47.Z)))))
end

function t1.ContactPoint(p14, p15, p16, p17) -- line: 106
    -- upvalues: clampInto (copy)
    return (clampInto(p14, p15, p16.Position) + clampInto(p16, p17, p14.Position)) / 2
end

function t1.Zone(p18, p19, p20, p21) -- line: 112
    local v54 = p18:VectorToObjectSpace(p21)

    if math.abs(v54.Z) > math.abs(v54.X) * 1.2 then
        if v54.Z < 0 then
            return "FrontEnd"
        end

        return "RearEnd"
    end

    local v57 = p18:PointToObjectSpace(p20).Z / math.max(p19.Z / 2, 0.1)

    if v57 < -0.33 then
        return "FrontSide"
    end

    if v57 > 0.33 then
        return "RearSide"
    end

    return "MidSide"
end

function t1.Resolve(p22, p23, p24, p25) -- line: 124
    -- upvalues: Config (copy), t1 (copy)
    local v58 = p22.vel - p23.vel
    local v59 = Vector3.new(v58.X, 0, v58.Z)
    local v60 = v59:Dot(p24)

    if v60 < t1.Get("MinClosingKph") / (Config.StudMetres * 3.6) then
        return nil
    end

    local v61 = 1 / p22.mass + 1 / p23.mass
    local v62 = (1 + t1.Get("Restitution")) * v60 / v61
    local v63 = v59 - p24 * v60
    local v64, v65

    if v63.Magnitude > 0.05 then
        v64 = v63.Unit
        v65 = math.min(t1.Get("Friction") * v62, v63.Magnitude / v61)
    else
        v65 = 0
        v64 = Vector3.new(0, 0, 0)
    end

    local v68 = p24 * v62 + v64 * v65

    local function kicks(p26, p27) -- line: 134
        -- upvalues: p25 (copy), t1 (copy)
        local v69 = p25 - (p26.com or p26.cf.Position)
        local v70 = Vector3.new(v69.X, 0, v69.Z)
        local Z2, X2 = p26.size.Z, p26.size.X
        local v71 = p26.mass * (Z2 * Z2 + X2 * X2) / 12
        local v74 = math.clamp(v70:Cross(p27).Y / v71 * t1.Get("YawShare"), -t1.Get("MaxYawKick"), t1.Get("MaxYawKick"))
        local RightVector = p26.cf.RightVector
        local v75 = Vector3.new(RightVector.X, 0, RightVector.Z)
        local Unit = v75.Magnitude > 0.05 and v75.Unit or Vector3.new(1, 0, 0)

        return v74, (math.clamp(-(p27 / p26.mass):Dot(Unit) * t1.Get("LeanShare"), -t1.Get("MaxLeanKick"), t1.Get("MaxLeanKick")))
    end

    local v78 = -v68 / p22.mass
    local v79 = v68 / p23.mass
    local v80, v81 = kicks(p22, -v68)
    local v82, v83 = kicks(p23, v68)

    return {
        closing = v60,
        closingKph = v60 * Config.StudMetres * 3.6,
        a = {
            dv = v78,
            yaw = v80,
            lean = v81
        },
        b = {
            dv = v79,
            yaw = v82,
            lean = v83
        }
    }
end

function t1.Risk(p28, p29, p30, p31) -- line: 155
    -- upvalues: Config (copy), t1 (copy)
    local v84 = Vector3.new(p29.X, 0, p29.Z).Magnitude * Config.StudMetres * 3.6
    local v85 = t1.Get("Tolerance" .. p28) or 20
    local v88 = 1 + t1.Get("LeanWeakness") * math.clamp(math.abs(p30 or 0) / 0.7853981633974483, 0, 1.4)
    local Luck = t1.Get("Luck")

    return v84 * v88 / math.max(v85, 1) * (1 + ((p31 or 0.5) * 2 - 1) * Luck), v84
end

function t1.CrashKind(p32, p33, p34, p35) -- line: 163
    -- upvalues: t1 (copy)
    local v90 = math.abs(p34 or 0)

    if not (p33 < t1.Get("LowSpeedKph")) then
        if p32 == "FrontEnd" then
            if t1.Get("LoopoverKph") <= p35 then
                return "LOOPOVER"
            end
        elseif p32 ~= "FrontSide" and (p32 == "RearSide" or p32 == "RearEnd" and v90 > 0.3490658503988659) then
            return "HIGHSIDE"
        end
    end

    return "LOWSIDE"
end

function t1.CrashPlan(p36, p37, p38, p39, p40, p41, p42) -- line: 175
    -- upvalues: Config (copy)
    local CrashImpulse = require(script.Parent.CrashImpulse)
    local v91 = 1 / Config.StudMetres
    local v92 = p37 + Vector3.new(p38.X, 0, p38.Z)
    local v93 = Vector3.new(v92.X, 0, v92.Z)
    local v94 = v93.Magnitude > 0.5
    local Unit = if v94 then v93.Unit else nil

    if not v94 or not Unit then
        local LookVector = p36.LookVector

        Unit = Vector3.new(LookVector.X, 0, LookVector.Z).Unit
    end

    local v95 = Unit:Cross((Vector3.new(0, 1, 0)))
    local v96 = p42 / 3.6
    local v97 = if p39:Dot(v95) >= 0 then 1 else -1
    local v99 = math.min(2.5 + 0.15 * v96, 8)
    local v102 = -Unit * v97 * v99 + Vector3.new(0, 1, 0) * math.clamp(-v97 * 0.15 * v96, -2, 2)
    local v103, v104

    if p41 == "LOOPOVER" then
        local v106 = math.min(1.5 + 0.1 * v96, 5) * v91

        v103 = p37 * 0.85 + Vector3.new(0, 1, 0) * v106
        v104 = v95 * math.min(3 + 0.08 * v96, 6)
        v102 = v95 * math.min(2 + 0.06 * v96, 5)
    elseif p40 == "RearEnd" then
        v103 = v92 + Vector3.new(0, 1.5, 0) * v91
        v104 = -v95 * 1.5 + Unit * v97 * 0.8
    else
        local v110 = math.min(1 + 0.06 * v96, 3.5) * v91

        v103 = v92 + p39 * Vector3.new(p38.X, 0, p38.Z).Magnitude * 0.3 + Vector3.new(0, 1, 0) * v110
        v104 = -Unit * v97 * math.min(1.5 + 0.06 * v96, 4)
    end

    local v113 = if not (p37.Magnitude >= v92.Magnitude) or not p37 then v92 else p37

    return {
        bike = CrashImpulse.KeepSpeed(v92, v113),
        bikeSpin = v102,
        rider = CrashImpulse.KeepSpeed(v103, v113),
        riderSpin = v104,
        info = {
            kind = "BIKE",
            zone = p40,
            crash = p41,
            closingKph = math.floor(p42 + 0.5),
            dvKph = math.floor(Vector3.new(p38.X, 0, p38.Z).Magnitude * Config.StudMetres * 3.6 + 0.5)
        }
    }
end

return t1
