-- https://lua.expert

local Config = require(script.Parent.Config)
local t1 = {
    Settings = {
        BodySize = Vector3.new(1.6, 3.6, 6.3),
        RearContact = Vector3.new(0, -2.6, 3.1),
        SlipGrowth = 2,
        SlipMin = 1.2,
        SlipMax = 2.5,
        SlipSeconds = 0.22,
        SlipSecondsPerKph = 0.0012,
        SlipSecondsMax = 0.45,
        HighsideSnap = 0.36,
        HighsideMinSlip = 0.6,
        HighsideMaxSpin = 11,
        HighsideRiderMax = 42,
        RiderCatapult = 0.12,
        RiderSpinShare = 0.8,
        Restitution = 0.1,
        RiderRestitution = 0.08,
        WallFriction = 0.35,
        GlanceFriction = 0.12,
        LaunchUp = 0.13,
        MaxLaunchUp = 10,
        RiderLaunchUp = 0.12,
        RiderBaseUp = 1.5,
        RiderMaxLaunchUp = 10,
        SpinBase = 1.5,
        SpinPerSpeed = 0.13,
        MaxSpin = 13,
        RiderSpinBase = 2,
        RiderSpinPerSpeed = 0.11,
        RiderMaxSpin = 10,
        SpeedKeep = 0.97
    }
}

local function invI(p1, p2) -- line: 48
    -- upvalues: t1 (copy)
    local BodySize = t1.Settings.BodySize
    local v1 = p1:VectorToObjectSpace(p2)

    return p1:VectorToWorldSpace((Vector3.new(v1.X * 12 / (BodySize.Y ^ 2 + BodySize.Z ^ 2), v1.Y * 12 / (BodySize.X ^ 2 + BodySize.Z ^ 2), v1.Z * 12 / (BodySize.X ^ 2 + BodySize.Y ^ 2))))
end

local function effMass(p3, p4, p5) -- line: 54
    -- upvalues: invI (copy)
    local v5 = p4:Cross(p5)

    return 1 / (1 + v5:Dot(invI(p3, v5)))
end

local function cap(p6, p7) -- line: 58
    local Magnitude = p6.Magnitude

    return p7 < Magnitude and p6 * (p7 / Magnitude) or p6
end

local function flat(p8) -- line: 59
    return (Vector3.new(p8.X, 0, p8.Z))
end

local function keepSpeed(p9, p10) -- line: 62
    -- upvalues: t1 (copy)
    local v6 = p10.Magnitude * t1.Settings.SpeedKeep

    if p9.Magnitude <= v6 or p10.Magnitude < 0.01 then
        return p9
    end

    local Unit = p10.Unit
    local v7 = p9:Dot(Unit)
    local v8 = p9 - Unit * v7

    if v6 <= v8.Magnitude then
        return v8.Unit * v6
    end

    return v8 + Unit * (math.sign(v7) * math.sqrt(v6 * v6 - v8.Magnitude ^ 2))
end

t1.KeepSpeed = keepSpeed

function t1.Highside(p11) -- line: 74
    -- upvalues: Config (copy), t1 (copy), invI (copy), keepSpeed (copy)
    local Settings = t1.Settings
    local Rotation = p11.cf.Rotation
    local velocity = p11.velocity
    local v11 = p11.angular or Vector3.new(0, 0, 0)
    local Magnitude = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
    local v13 = math.sign(p11.lean or 0)

    if v13 == 0 then
        v13 = math.sign(p11.rearYaw or 0)
    end

    if v13 == 0 then
        v13 = 1
    end

    local RightVector = Rotation.RightVector
    local v15 = Vector3.new(RightVector.X, 0, RightVector.Z)
    local v16 = v15.Magnitude > 0.05 and v15.Unit * v13 or Vector3.new(1, 0, 0) * v13
    local v21 = Magnitude * math.sin((math.max(math.abs(p11.rearYaw or 0), Config.RearYaw * Settings.HighsideMinSlip)))
    local v22 = Rotation:VectorToWorldSpace(Settings.RearContact)
    local v23 = p11.com + v22
    local v24 = -v16
    local v25 = v22:Cross(v24)
    local v27 = invI(Rotation, v22:Cross(v24 * (1 / (1 + v25:Dot(invI(Rotation, v25))) * v21 * Settings.HighsideSnap)))
    local HighsideMaxSpin = Settings.HighsideMaxSpin
    local Magnitude2 = v27.Magnitude

    v27 = HighsideMaxSpin < Magnitude2 and v27 * (HighsideMaxSpin / Magnitude2) or v27

    local v28 = v27:Cross(p11.com - v23)
    local v29 = v27:Cross((p11.rider or p11.com + Rotation:VectorToWorldSpace((Vector3.new(0, 1.9, 0.6)))) - v23)
    local HighsideRiderMax = Settings.HighsideRiderMax
    local Magnitude3 = v29.Magnitude

    v29 = HighsideRiderMax < Magnitude3 and v29 * (HighsideRiderMax / Magnitude3) or v29

    local v30 = v29 + Vector3.new(0, 1, 0) * v21 * Settings.RiderCatapult

    return {
        bike = keepSpeed(velocity + v28, velocity),
        bikeSpin = v11 + v27,
        rider = keepSpeed(velocity + v30, velocity),
        riderSpin = v27 * Settings.RiderSpinShare + v11 * 0.5,
        info = {
            kind = "HIGHSIDE",
            lateralMps = v21 * Config.StudMetres,
            spin = v27.Magnitude,
            riderUpMps = v30.Y * Config.StudMetres
        }
    }
end

function t1.Wall(p12) -- line: 102
    -- upvalues: Config (copy), t1 (copy), invI (copy), keepSpeed (copy)
    local Settings = t1.Settings
    local Rotation = p12.cf.Rotation
    local velocity, normal = p12.velocity, p12.normal
    local v31 = Vector3.new(normal.X, 0, normal.Z)
    local v32 = v31.Magnitude > 0.05
    local Unit = if v32 then v31.Unit else nil

    if not v32 or not Unit then
        local LookVector = Rotation.LookVector

        Unit = -Vector3.new(LookVector.X, 0, LookVector.Z).Unit
    end

    local v34 = math.max(0, -velocity:Dot(Unit))
    local v35 = v34 * Config.StudMetres
    local v36 = velocity - Unit * velocity:Dot(Unit)
    local v37 = Vector3.new(v36.X, 0, v36.Z)
    local Magnitude = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
    local v38 = Magnitude > 1 and math.clamp(v34 / Magnitude, 0, 1) or 1
    local v40 = Settings.GlanceFriction + (Settings.WallFriction - Settings.GlanceFriction) * v38
    local v42 = math.min(Settings.LaunchUp * v35, Settings.MaxLaunchUp) * (0.35 + 0.65 * v38) / Config.StudMetres
    local v44 = v37 * (1 - v40) + Unit * (Settings.Restitution * v34) + Vector3.new(0, 1, 0) * (math.max(velocity.Y, 0) + v42)
    local v45 = Settings.BodySize * 0.5
    local v46 = Rotation:VectorToObjectSpace(-Unit)
    local v54 = invI(Rotation, Rotation:VectorToWorldSpace((Vector3.new(math.clamp(v46.X * 3, -1, 1) * v45.X, -v45.Y * 0.4, math.clamp(v46.Z * 3, -1, 1) * v45.Z))):Cross(v44 - velocity))
    local v57 = math.min(Settings.SpinBase * math.clamp(v35 / 5, 0, 1) + Settings.SpinPerSpeed * v35, Settings.MaxSpin)
    local v58 = (p12.angular or Vector3.new(0, 0, 0)) * 0.3 + (v54.Magnitude > 1E-04 and v54.Unit * v57 or Vector3.new(0, 0, 0))
    local v60 = math.min(Settings.RiderLaunchUp * v35 + Settings.RiderBaseUp, Settings.RiderMaxLaunchUp) / Config.StudMetres
    local v62 = v37 * (1 - v40 * 0.6) + Unit * (Settings.RiderRestitution * v34) + Vector3.new(0, 1, 0) * (math.max(velocity.Y, 0) + v60)
    local Unit2 = v37.Magnitude > 0.5 and v37.Unit or -Unit
    local v63 = (Vector3.new(0, 1, 0)):Cross(-Unit)
    local v64 = Unit2 * (if Unit2:Cross((Vector3.new(0, 1, 0))):Dot(Unit) > 0 then 1 else -1)
    local v65 = v63 * v38 + v64 * (1 - v38)

    v63 = v65.Magnitude > 0.001 and v65.Unit or v63

    local v67 = v63 * math.min(Settings.RiderSpinBase + Settings.RiderSpinPerSpeed * v35, Settings.RiderMaxSpin)

    return {
        bike = keepSpeed(v44, velocity),
        bikeSpin = v58,
        rider = keepSpeed(v62, velocity),
        riderSpin = v67,
        info = {
            kind = "WALL",
            intoMps = v35,
            headOn = v38,
            bikeUpMps = v42 * Config.StudMetres,
            spin = v57
        }
    }
end

return t1
