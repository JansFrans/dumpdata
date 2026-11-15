-- https://lua.expert

local Config = require(script.Parent.Config)
local t1 = {
    IdleRPM = 1800,
    RedlineRPM = 16000,
    UpshiftRPM = 15600,
    DownshiftRPM = 6800,
    MinUpshiftRPM = 8500,
    LugRPM = 6500,
    OverRevRPM = 15500,
    ShiftInterval = 0.03,
    AutomaticInterval = 0.06,
    NeutralMaxKph = 0.1,
    GearSpread = { 0.3261, 0.4351, 0.5618, 0.6886, 0.8105, 1 },
    Limits = {},
    Up = {},
    Down = { 0 },
    Minimum = { 0 }
}

for v1 in Config.Gears do
    t1.Limits[v1] = Config.TopSpeedKph * (t1.GearSpread[v1] or Config.Gears[6] / Config.Gears[v1])
    t1.Up[v1] = v1 < 6 and t1.Limits[v1] * t1.UpshiftRPM / t1.RedlineRPM or 1e999

    if v1 > 1 then
        t1.Down[v1] = t1.Limits[v1] * t1.DownshiftRPM / t1.RedlineRPM
        t1.Minimum[v1] = math.max(t1.Limits[v1] * t1.LugRPM / t1.RedlineRPM, t1.Limits[v1 - 1] * t1.MinUpshiftRPM / t1.RedlineRPM)
    end
end

local function finite(p1) -- line: 27
    if typeof(p1) == "number" and p1 == p1 then
        return math.abs(p1) < 1e999
    end

    return false
end

local function validGear(p2) -- line: 28
    return typeof(p2) == "number" and p2 == p2 and math.abs(p2) < 1e999 and p2 % 1 == 0 and p2 >= -1 and p2 <= 6
end

function t1.WheelRPM(p3, p4) -- line: 29
    -- upvalues: Config (copy), t1 (copy)
    local v4 = typeof(p3) == "number" and p3 == p3 and math.abs(p3) < 1e999 and p3 % 1 == 0 and p3 >= -1 and p3 <= 6

    if v4 then
        if typeof(p4) == "number" and p4 == p4 and math.abs(p4) < 1e999 and p3 ~= 0 then
            local ReverseSpeedKph = p3 < 0 and Config.ReverseSpeedKph or t1.Limits[p3]

            return math.abs(p4) / ReverseSpeedKph * t1.RedlineRPM
        end
    end

    return t1.IdleRPM
end

function t1.RPM(p5, p6, p7, p8) -- line: 34
    -- upvalues: t1 (copy)
    local v6 = math.clamp(p7 or 0, 0, 1)

    if p5 == 0 then
        return t1.IdleRPM + v6 * 12500
    end

    if p5 == -1 then
        return (math.clamp(t1.IdleRPM + v6 * 2200 + math.abs(p6) * 90, t1.IdleRPM, 5800))
    end

    local v8 = t1.WheelRPM(p5, p6)

    if p5 == 1 then
        v8 = math.max(v8, t1.IdleRPM + v6 * 7500 * (1 - math.clamp(math.abs(p6) / 45, 0, 1)))
    end

    return (math.clamp(v8 + math.clamp(p8 or 0, 0, 1) * 1100, t1.IdleRPM, t1.RedlineRPM))
end

function t1.Target(p9, p10, p11, p12) -- line: 43
    -- upvalues: t1 (copy)
    local v14 = typeof(p9) == "number" and p9 == p9 and math.abs(p9) < 1e999 and p9 % 1 == 0 and p9 >= -1 and p9 <= 6

    if not v14 or p10 ~= 1 and p10 ~= -1 or typeof(p11) ~= "number" or p11 ~= p11 or not (math.abs(p11) < 1e999) then
        return nil
    end

    local v15 = math.abs(p11)
    local v16 = p9 + p10
    local v17 = typeof(v16) == "number" and v16 == v16 and math.abs(v16) < 1e999 and v16 % 1 == 0 and v16 >= -1 and v16 <= 6

    if not v17 or v16 == 0 and t1.NeutralMaxKph < v15 then
        return nil
    end

    if p12 then
        return v16 >= 0 and v16 or nil
    end

    if v16 < 0 then
        return nil
    end

    if p9 == 0 then
        return if v16 == 1 and v15 < t1.Limits[1] * 0.95 then 1 else nil
    end

    if v16 == 0 then
        return 0
    end

    if p10 > 0 then
        if not p12 and (t1.WheelRPM(p9, v15) < t1.MinUpshiftRPM or t1.WheelRPM(v16, v15) < t1.LugRPM) then
            return nil
        end
    elseif t1.WheelRPM(v16, v15) > t1.RedlineRPM + 400 then
        return nil
    end

    return v16
end

local function commit(p13, p14, p15) -- line: 59
    local gear = p13.gear

    p13.gear = p14
    p13.shiftAt = p15
    p13.shiftDirection = gear < p14 and 1 or -1
    p13.shiftSerial = (p13.shiftSerial or 0) + 1

    if p13.bike then
        p13.bike:SetAttribute("Gear", p14)
        p13.bike:SetAttribute("ShiftSerial", p13.shiftSerial)
        p13.bike:SetAttribute("ShiftDirection", p13.shiftDirection)
    end

    return true
end

function t1.Shift(p16, p17, p18, p19, p20) -- line: 68
    -- upvalues: t1 (copy), commit (copy)
    p19 = p19 or os.clock()

    if not (typeof(p19) == "number" and p19 == p19 and math.abs(p19) < 1e999) or p19 - (p16.shiftAt or -100) < t1.ShiftInterval then
        return false
    end

    local v19 = t1.Target(p16.gear, p17, p18, p20)

    return v19 ~= nil and (commit(p16, v19, p19))
end

function t1.Request(p21, p22, p23, p24) -- line: 75
    -- upvalues: t1 (copy)
    if p21.followServerGear or typeof(p23) ~= "number" or p23 ~= p23 or not (math.abs(p23) < 1e999) then
        return false
    end

    p24 = p24 or os.clock()

    if p22 == 1 or p22 == -1 then
        if not (p24 - (p21.shiftAt or -100) < t1.ShiftInterval) then
            local v21 = t1.Shift(p21, p22, p23, p24, true)

            if v21 then
                if p21.transmission ~= "Manual" then
                    p21.autoHold = p24 + 1.2
                end
            else
                local v22

                if p22 < 0 and p21.gear > 1 and p24 - (p21.shiftAt or -100) >= t1.ShiftInterval then
                    v22 = p21.pendingShifts or {}
                    p21.pendingShifts = v22

                    if #p21.pendingShifts < 12 then
                        table.insert(p21.pendingShifts, {
                            p22,
                            p24
                        })
                    end
                end
            end

            return v21
        end

        p21.pendingShifts = p21.pendingShifts or {}

        if #p21.pendingShifts < 12 then
            table.insert(p21.pendingShifts, {
                p22,
                p24
            })
        end
    end

    return false
end

function t1.FlushPending(p25, p26, p27) -- line: 92
    -- upvalues: t1 (copy)
    local pendingShifts = p25.pendingShifts

    if not (pendingShifts and #pendingShifts > 0 and p27 - (p25.shiftAt or -100) >= t1.ShiftInterval) then
        return false
    end

    local v23 = table.remove(pendingShifts, 1)
    local v24 = p27

    if typeof(v23) == "table" then
        v23, v24 = v23[1], v23[2]
    end

    if p27 - v24 > 0.6 then
        return false
    end

    local v25 = t1.Shift(p25, v23, p26, p27, true)

    if v25 then
        if p25.transmission ~= "Manual" then
            p25.autoHold = p27 + 1.2

            return v25
        end
    elseif v23 < 0 and p25.gear > 1 then
        table.insert(pendingShifts, 1, {
            v23,
            v24
        })
    end

    return v25
end

function t1.Automatic(p28, p29, p30) -- line: 106
    -- upvalues: t1 (copy)
    if p28.followServerGear or typeof(p29) ~= "number" or p29 ~= p29 or not (math.abs(p29) < 1e999) then
        return false
    end

    local gear = p28.gear
    local v26 = typeof(gear) == "number" and gear == gear and math.abs(gear) < 1e999 and gear % 1 == 0 and gear >= -1 and gear <= 6

    if v26 then
        local v27 = p30 or os.clock()
        local v28 = math.abs(p29)

        if p28.gear == 0 then
            if p28.transmission ~= "Manual" and math.clamp(p28.smoothThrottle or p28.throttle or 0, 0, 1) > 0.2 and v27 - (p28.shiftAt or -100) >= 0.35 then
                return t1.Shift(p28, 1, v28, v27)
            end
        elseif p28.transmission == "Automatic" and not (p28.gear < 0) then
            if v27 - (p28.shiftAt or -100) < t1.AutomaticInterval or v27 < (p28.autoHold or 0) then
                return false
            end

            local v29 = math.clamp(p28.smoothThrottle or p28.throttle or 0, 0, 1)
            local v30 = 13200 + (t1.UpshiftRPM - 13200) * v29
            local v31 = t1.WheelRPM(p28.gear, v28)

            if p28.gear < 6 and v29 > 0.15 and v30 <= v31 then
                return t1.Shift(p28, 1, v28, v27)
            end

            if p28.gear > 1 and v31 < t1.DownshiftRPM + (1 - v29) * 600 or p28.gear > 1 and v29 > 0.85 and v31 < t1.KickdownRPM and t1.WheelRPM(p28.gear - 1, v28) < t1.UpshiftRPM - 800 then
                return t1.Shift(p28, -1, v28, v27)
            end
        end

        return false
    end

    return false
end

function t1.Pull(p31, p32) -- line: 130
    -- upvalues: t1 (copy)
    if p31 <= 1 then
        return 1
    end

    local v32 = t1.WheelRPM(p31, p32)
    local v34 = math.clamp((v32 - t1.IdleRPM) / 7000, 0, 1)
    local v35 = v34 * v34 * (3 - v34 * 2)
    local v36 = 0.02 / (p31 - 1) ^ 2

    return (v36 + (1 - v36) * v35 * v35) * (1 - math.clamp((v32 - 13000) / 3000, 0, 1) * 0.08)
end

t1.Power = 13200
t1.PowerCurve = {
    { 4000, 0.25 },
    { 8000, 0.55 },
    { 10000, 0.7 },
    { 12000, 0.85 },
    { 14000, 0.97 },
    { 15000, 1 },
    { 16000, 0.97 }
}

function t1.Ratio(p33) -- line: 155
    -- upvalues: Config (copy), t1 (copy)
    local v39 = typeof(p33) == "number" and p33 == p33 and math.abs(p33) < 1e999 and p33 % 1 == 0 and p33 >= -1 and p33 <= 6
    local v40 = if not v39 or p33 <= 0 then 1 else p33

    return Config.Gears[1] * t1.Limits[1] / t1.Limits[v40]
end

t1.TorqueCurve = {
    { 1800, 0.3 },
    { 4000, 0.45 },
    { 6000, 0.62 },
    { 8000, 0.78 },
    { 10000, 0.92 },
    { 12000, 1 },
    { 13500, 1 },
    { 15000, 0.93 },
    { 16000, 0.85 }
}
t1.RatioExponent = 0.6
t1.DriveScale = 1.1
t1.LaunchRPM = 10500
t1.KickdownRPM = 8500

function t1.Torque(p34) -- line: 164
    -- upvalues: t1 (copy)
    local TorqueCurve = t1.TorqueCurve

    if p34 <= TorqueCurve[1][1] then
        return TorqueCurve[1][2]
    end

    for i = 2, #TorqueCurve do
        local v41 = TorqueCurve[i - 1]
        local v42 = TorqueCurve[i]

        if p34 <= v42[1] then
            return v41[2] + (v42[2] - v41[2]) * (p34 - v41[1]) / (v42[1] - v41[1])
        end
    end

    return TorqueCurve[#TorqueCurve][2]
end

function t1.Drive(p35, p36) -- line: 172
    -- upvalues: Config (copy), t1 (copy)
    local v43 = typeof(p35) == "number" and p35 == p35 and math.abs(p35) < 1e999 and p35 % 1 == 0 and p35 >= -1 and p35 <= 6
    local v44, v45

    if not v43 or p35 <= 0 then
        v45 = true
    else
        v44 = typeof(p36) == "number" and p36 == p36 and math.abs(p36) < 1e999
        v45 = false
    end

    if v45 or not v44 then
        return 0
    end

    local v46 = t1.WheelRPM(p35, p36)

    if p35 == 1 then
        v46 = math.max(v46, t1.LaunchRPM)
    end

    local v47 = t1.Torque(v46) * (t1.Limits[1] / t1.Limits[p35]) ^ t1.RatioExponent * t1.DriveScale

    if p35 > 1 then
        local v49 = math.clamp((v46 - t1.IdleRPM) / 3200, 0, 1)
        local v50 = 0.02 / (p35 - 1) ^ 2

        v47 *= v50 + (1 - v50) * v49 * v49 * (3 - v49 * 2)
    end

    local v52 = math.max(p36 / (Config.StudMetres * 3.6), 20)
    local PowerCurve = t1.PowerCurve
    local v53 = PowerCurve[#PowerCurve][2]

    if v46 <= PowerCurve[1][1] then
        v53 = PowerCurve[1][2]
    else
        for i = 2, #PowerCurve do
            local v54 = PowerCurve[i - 1]
            local v55 = PowerCurve[i]

            if v46 <= v55[1] then
                v53 = v54[2] + (v55[2] - v54[2]) * (v46 - v54[1]) / (v55[1] - v54[1])
                break
            end
        end
    end

    return (math.min(v47, t1.Power * v53 / (v52 * 72)))
end

function t1.DriveCut(p37, p38) -- line: 191
    if not p37.shiftAt then
        return 1
    end

    local v57 = (p38 - p37.shiftAt) / 0.025

    if v57 < 0 or v57 >= 1 then
        return 1
    end

    return 1 - math.sin(3.141592653589793 * v57) * 0.4
end

return t1
