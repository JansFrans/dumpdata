-- https://lua.expert

local t1 = {
    Order = { "Soft", "Medium", "Hard", "Wet" },
    Sides = { "F", "R" },
    Compounds = {
        Soft = {
            Letter = "S",
            Name = "Soft",
            Hint = "Most grip early · for cool tracks · overheats when hot",
            Grip = 1.04,
            WetGrip = 0.8,
            Wear = 1.25,
            WetWear = 0.6,
            Drop = 1,
            Color = Color3.fromRGB(245, 245, 245),
            Stripe = Color3.fromRGB(245, 245, 245)
        },
        Medium = {
            Letter = "M",
            Name = "Medium",
            Hint = "Balanced · works on most tracks",
            Stripe = nil,
            Grip = 1,
            WetGrip = 0.8,
            Wear = 1,
            WetWear = 0.6,
            Drop = 1,
            Color = Color3.fromRGB(120, 122, 128)
        },
        Hard = {
            Letter = "H",
            Name = "Hard",
            Hint = "Needs heat · for hot tracks · most consistent",
            Grip = 0.97,
            WetGrip = 0.8,
            Wear = 0.8,
            WetWear = 0.4,
            Drop = 1,
            Color = Color3.fromRGB(255, 212, 0),
            Stripe = Color3.fromRGB(255, 212, 0)
        },
        Wet = {
            Letter = "W",
            Name = "Wet",
            Hint = "For rain · burns up on dry",
            Grip = 0.86,
            WetGrip = 1.28,
            Wear = 3.5,
            WetWear = 1,
            Color = Color3.fromRGB(40, 140, 255),
            Stripe = Color3.fromRGB(40, 140, 255)
        }
    },
    PerCompound = 4,
    RestoreCost = 15000,
    RestoreStep = 100
}

function t1.RestoreCostFor(p1) -- line: 29
    -- upvalues: t1 (copy)
    local v2 = 1 - math.clamp(if typeof(p1) == "number" and p1 == p1 and p1 then p1 else 1, 0, 1)

    if v2 <= 5E-04 then
        return 0
    end

    return (math.max(t1.RestoreStep, math.ceil(t1.RestoreCost * v2 / t1.RestoreStep - 1E-06) * t1.RestoreStep))
end

t1.PickSeconds = 15
t1.Default = "Medium"
t1.Curve = {
    { 0, 0.6 },
    { 0.15, 0.74 },
    { 0.4, 0.86 },
    { 0.7, 0.94 },
    { 1, 1 }
}
t1.Curves = {
    Soft = {
        { 0, 0.55 },
        { 0.15, 0.7 },
        { 0.4, 0.84 },
        { 0.7, 0.95 },
        { 1, 1 }
    },
    Medium = {
        { 0, 0.62 },
        { 0.15, 0.76 },
        { 0.4, 0.88 },
        { 0.7, 0.955 },
        { 1, 1 }
    },
    Hard = {
        { 0, 0.7 },
        { 0.15, 0.82 },
        { 0.4, 0.92 },
        { 0.7, 0.97 },
        { 1, 1 }
    },
    Wet = {
        { 0, 0.55 },
        { 0.15, 0.7 },
        { 0.4, 0.84 },
        { 0.7, 0.95 },
        { 1, 1 }
    }
}

function t1.CurveAt(p2, p3) -- line: 56
    -- upvalues: t1 (copy)
    local v6 = math.clamp(if typeof(p2) == "number" and p2 == p2 and p2 then p2 else 1, 0, 1)
    local v7, v8

    if p3 and t1.Curves then
        local v9 = t1.Curves[p3]

        if v9 then
            v7 = v9
            v8 = true
        else
            v8 = false
        end
    else
        v8 = false
    end

    if not v8 then
        v7 = t1.Curve
    end

    for i = 2, #v7 do
        if v6 <= v7[i][1] then
            local v10 = v7[i - 1]
            local v11 = v7[i]

            return v10[2] + (v11[2] - v10[2]) * (v6 - v10[1]) / (v11[1] - v10[1])
        end
    end

    return v7[#v7][2]
end

function t1.WearFactor(p4, p5) -- line: 68
    -- upvalues: t1 (copy)
    local v12 = t1.Compounds[p4]

    if v12 then
        return 1 - (1 - t1.CurveAt(p5, p4)) * (v12.Drop or 1)
    end

    return 1
end

t1.WearDriveUpright = 0.25

function t1.Worn(p6, p7) -- line: 80
    -- upvalues: t1 (copy)
    local v13, v14, v15

    if p7 then
        v13 = t1.Compounds[p7]

        if t1.Curves then
            local v16 = t1.Curves[p7]

            if v16 then
                v14 = v16
                v15 = true
            else
                v15 = false
            end
        else
            v15 = false
        end
    else
        v13 = p7
        v15 = false
    end

    if not v15 then
        v14 = t1.Curve
    end

    return (math.clamp((1 - t1.CurveAt(p6, p7)) * (v13 and v13.Drop or 1) / (1 - v14[1][2]), 0, 1))
end

t1.LateralSlide = 1

function t1.RearWornOf(p8, p9) -- line: 92
    -- upvalues: t1 (copy)
    if not p8 or p8:GetAttribute("TyreRear") == nil then
        return 0
    end

    return (math.max(t1.Worn(t1.WearOf(p8, "R", p9), p8:GetAttribute("TyreRear")), t1.ColdOf(p8, "R", p9) * (t1.Temp.ColdSlide or 0)))
end

t1.SlideBoost = 0.6
t1.Temp = {
    Rise = 60,
    TimeConst = 80,
    WarmerTemp = 72,
    RainCool = 1.6,
    ColdLoss = 0.25,
    ColdSpan = 60,
    ColdCurve = 1.6,
    HotLoss = 0.12,
    HotSpan = 40,
    HotWear = 2,
    ColdTuck = 0.15,
    ColdSlide = 0.5,
    ShoulderLean = 0.6108652381980153,
    CentreDrop = 0.55,
    ShoulderBase = 0.5,
    ShoulderGain = 0.9,
    Conduct = 100,
    KneeRise = 60,
    MaxRise = 120,
    CoolStill = 180,
    SlipFloor = 0.8,
    BurnoutHeat = 2.8,
    BurnoutTimeConst = 12,
    BurnoutFlashGain = 20,
    BurnoutFlashMax = 50,
    FlashGain = 11,
    FlashFrom = 0.4,
    FlashMax = 24,
    FlashRise = 2.2,
    FlashDecay = 5,
    BurnoutFlashRise = 1.5,
    ScrubCore = 0.6
}
t1.Temp.BrakeFlashGain = 12
t1.Temp.RearBrakeHeat = 1.2
t1.Temp.RearBrakeEBS = { 0.65, 0.82, 1, 1.18, 1.38 }
t1.Temp.EngineBrakeHeat = 0.6
t1.Temp.SlipstreamOn = false
t1.Temp.AggroTimeConst = 45
t1.Temp.AggroBrake = 0.8
t1.Temp.AggroScrub = 1.2
t1.Temp.SlipDist = 70
t1.Temp.SlipWidth = 6
t1.Temp.SlipFromKph = 80
t1.Temp.SlipHeatF = 8
t1.Temp.SlipHeatR = 3
t1.Temp.SlipCool = 0.35
t1.Temp.ColdWear = 0.6
t1.Temp.BrakeFlashKph = 200
t1.Temp.BrakeFlashMax = 34
t1.Temp.BrakeFlashDecay = 10
t1.Temp.EBSHeat = { 0.3, 0.45, 0.75, 1.25, 2 }
t1.Temp.TCSHeat = { 1.35, 1.2, 1.08, 1, 0.9 }
t1.Zones = { "L", "C", "R" }

function t1.LeanZone(p10) -- line: 232
    -- upvalues: t1 (copy)
    local v20 = if typeof(p10) == "number" and p10 == p10 and p10 then p10 else 0
    local v22 = math.clamp(math.abs(v20) / t1.Temp.ShoulderLean, 0, 1)

    if v20 > 0 then
        return v22, "L"
    end

    return v22, "R"
end

function t1.ContactTemp(p11, p12) -- line: 237
    -- upvalues: t1 (copy)
    local v23, v24 = t1.LeanZone(p12)

    return p11.C + (p11[v24] - p11.C) * v23
end

function t1.TempOf(p13, p14, p15) -- line: 242
    -- upvalues: t1 (copy)
    if not p13 then
        return nil
    end

    local Attribute = p13:GetAttribute("TyreTemp" .. p14 .. "C")

    if typeof(Attribute) ~= "number" then
        return p13:GetAttribute("TyreTemp" .. p14)
    end

    local Attribute2 = p13:GetAttribute("TyreTemp" .. p14 .. "L")
    local Attribute3 = p13:GetAttribute("TyreTemp" .. p14 .. "R")
    local ContactTemp = t1.ContactTemp

    if typeof(Attribute2) ~= "number" or not Attribute2 then
        Attribute2 = Attribute
    end

    return ContactTemp({
        L = Attribute2,
        C = Attribute,
        R = if typeof(Attribute3) == "number" and Attribute3 then Attribute3 else Attribute
    }, p15)
end

t1.ZoneWearBase = 0.12

function t1.ZoneWearShare(p16) -- line: 259
    -- upvalues: t1 (copy)
    local v25, v26 = t1.LeanZone(p16)
    local ZoneWearBase = t1.ZoneWearBase
    local t3 = {
        L = ZoneWearBase,
        C = 1 - v25 + ZoneWearBase,
        R = ZoneWearBase
    }

    t3[v26] += v25

    for v27, v28 in t3 do
        t3[v27] = v28 / (1 + ZoneWearBase)
    end

    return t3
end

function t1.WearOf(p17, p18, p19) -- line: 268
    -- upvalues: t1 (copy)
    if not p17 then
        return nil
    end

    local Attribute = p17:GetAttribute("TyreWear" .. p18 .. "C")

    if typeof(Attribute) ~= "number" then
        return p17:GetAttribute("TyreWear" .. p18)
    end

    local Attribute2 = p17:GetAttribute("TyreWear" .. p18 .. "L")
    local Attribute3 = p17:GetAttribute("TyreWear" .. p18 .. "R")
    local v29, v30 = t1.LeanZone(p19)

    if typeof(Attribute2) ~= "number" or not Attribute2 then
        Attribute2 = Attribute
    end

    local t4 = {
        L = Attribute2,
        C = Attribute,
        R = if typeof(Attribute3) == "number" and Attribute3 then Attribute3 else Attribute
    }

    return t4.C + (t4[v30] - t4.C) * v29
end

for v31, v32 in {
        Rise = 100,
        RiseF = 0.87,
        RiseR = 1.03,
        KneeRise = 95,
        MaxRise = 150,
        TrackShare = 0.5,
        TrackRef = 25,
        WarmerTemp = 90,
        RainCool = 2.4,
        ColdLoss = 0.3,
        ColdSpan = 50,
        ColdCurve = 1.5,
        HotLoss = 0.18,
        HotSpan = 35,
        HotWear = 2.5,
        ScrubCore = 0.2,
        WarmWear = 0.25,
        FlashGain = 8,
        FlashMax = 15
    } do
    t1.Temp[v31] = v32
end

t1.Temp.WarmRate = {
    Soft = 1.2,
    Medium = 1,
    Hard = 0.8,
    Wet = 1.2
}
t1.Temp.ColdSpan = 45
t1.Temp.ColdCurve = 1
t1.Temp.HeatWear = {
    Soft = 1.6,
    Medium = 1,
    Hard = 0.6,
    Wet = 1.5
}
t1.TempWindows = {
    Soft = { 75, 112, 1.03 },
    Medium = { 85, 120, 1 },
    Hard = { 95, 130, 0.95 },
    Wet = { 40, 80, 1 }
}
t1.Temp.PeakBonus = 0.03
t1.Temp.PeakFrom = 0.5
t1.Temp.PeakTo = 0.75
t1.Temp.EBSHeat = { 0.8, 0.9, 1, 1.15, 1.3 }
t1.Temp.SlideHeatPower = 3
t1.Temp.SurfCoolMax = 15
t1.Temp.SurfCoolWorkRef = 1
t1.Temp.SurfCoolTime = 3
t1.Temp.SurfWarmTime = 1.5
t1.Temp.WarmerBy = {
    Wet = 65
}
t1.Temp.SurfCoolRain = 1.3
t1.Temp.SpinHeatRef = 0.6
t1.Temp.SpinHeatPower = 2.5

function t1.SlideHeatLoad(p20, p21, p22, p23) -- line: 381
    -- upvalues: t1 (copy)
    local Temp = t1.Temp
    local v34 = math.max(0, p20 or 0)
    local v35 = Temp.SpinHeatRef or 0.6
    local v36 = p23.Slip * v35 * (v34 <= v35 and (v34 / v35) ^ (Temp.SpinHeatPower or 1) or v34 / v35)
    local v38 = math.max(p22 or 0.12566370614359174, 0.001)
    local v40 = math.abs(p21 or 0) / v38
    local v41 = p23.Slide * v38 / 0.17453292519943295

    v40 = v40 <= 1 and v40 ^ (Temp.SlideHeatPower or 1) or v40

    return v36 + v41 * v40
end

t1.Temp.BrakeFlashGain = 6
t1.Temp.BrakeFlashMax = 18
t1.Temp.BrakeFlashDecay = 6
t1.Temp.MaxRise = 115

local function smooth(p24) -- line: 396
    local v42 = math.clamp(p24, 0, 1)

    return v42 * v42 * (3 - 2 * v42)
end

function t1.TempFactor(p25, p26) -- line: 397
    -- upvalues: t1 (copy)
    local v43 = t1.TempWindows[p25]

    if not v43 or typeof(p26) ~= "number" then
        return 1
    end

    local Temp = t1.Temp

    if p26 < v43[1] then
        return 1 - Temp.ColdLoss * t1.Coldness(p25, p26)
    end

    if v43[2] < p26 then
        return 1 - Temp.HotLoss * math.clamp((p26 - v43[2]) / Temp.HotSpan, 0, 1)
    end

    local v45 = Temp.PeakBonus or 0

    if v45 <= 0 then
        return 1
    end

    local v46 = v43[2] - v43[1]
    local v47 = v43[1] + v46 * (Temp.PeakFrom or 0.5)
    local v48 = v43[1] + v46 * (Temp.PeakTo or 0.75)
    local v49, v50

    if p26 < v47 then
        local v54 = math.clamp((p26 - v43[1]) / math.max(v47 - v43[1], 0.001), 0, 1)
        local v55 = v54 * v54 * (3 - 2 * v54)

        if v55 then
            v49 = v55
            v50 = true
        elseif v48 < p26 then
            local v59 = math.clamp((v43[2] - p26) / math.max(v43[2] - v48, 0.001), 0, 1)
            local v60 = v59 * v59 * (3 - 2 * v59)

            if v60 then
                v49 = v60
                v50 = true
            else
                v50 = false
            end
        else
            v50 = false
        end
    elseif v48 < p26 then
        local v64 = math.clamp((v43[2] - p26) / math.max(v43[2] - v48, 0.001), 0, 1)
        local v65 = v64 * v64 * (3 - 2 * v64)

        if v65 then
            v49 = v65
            v50 = true
        else
            v50 = false
        end
    else
        v50 = false
    end

    if not v50 then
        v49 = 1
    end

    return 1 + v45 * v49
end

function t1.Coldness(p27, p28) -- line: 410
    -- upvalues: t1 (copy)
    local v66 = t1.TempWindows[p27]

    if not v66 or typeof(p28) ~= "number" or v66[1] <= p28 then
        return 0
    end

    return math.clamp((v66[1] - p28) / t1.Temp.ColdSpan, 0, 1) ^ (t1.Temp.ColdCurve or 1)
end

function t1.ColdOf(p29, p30, p31) -- line: 415
    -- upvalues: t1 (copy)
    if not p29 then
        return 0
    end

    local Attribute = p29:GetAttribute(if p30 == "F" then "TyreFront" else "TyreRear")

    if Attribute == nil then
        return 0
    end

    return t1.Coldness(Attribute, t1.TempOf(p29, p30, p31))
end

function t1.TempWear(p32, p33) -- line: 420
    -- upvalues: t1 (copy)
    local v68 = t1.TempWindows[p32]

    if not v68 or typeof(p33) ~= "number" then
        return 1
    end

    if p33 < v68[1] then
        return 1 + (t1.Temp.ColdWear or 0) * t1.Coldness(p32, p33)
    end

    local v69 = t1.Temp.WarmWear or 0

    if p33 <= v68[2] then
        if v69 <= 0 then
            return 1
        end

        local v70 = (v68[1] + v68[2]) / 2
        local v74 = math.clamp((p33 - v70) / math.max(v68[2] - v70, 0.001), 0, 1)

        return 1 + v69 * (v74 * v74 * (3 - 2 * v74))
    end

    local v75 = t1.Temp.HeatWear and t1.Temp.HeatWear[p32] or 1

    return 1 + v69 + t1.Temp.HotWear * v75 * math.clamp((p33 - v68[2]) / t1.Temp.HotSpan, 0, 1)
end

function t1.TempState(p34, p35) -- line: 434
    -- upvalues: t1 (copy)
    local v79 = t1.TempWindows[p34]

    if v79 and typeof(p35) == "number" then
        if p35 < v79[1] then
            return "COLD"
        end

        if v79[2] < p35 then
            return "HOT"
        end
    end

    return "OK"
end

function t1.Factor(p36, p37, p38, p39) -- line: 440
    -- upvalues: t1 (copy)
    local v80 = t1.Compounds[p36]

    if not v80 then
        return 1
    end

    return (p38 and v80.WetGrip or v80.Grip) * (1 - (1 - t1.CurveAt(p37, p36)) * (v80.Drop or 1)) * t1.TempFactor(p36, p39)
end

function t1.GripOf(p40, p41, p42) -- line: 445
    -- upvalues: t1 (copy)
    if not p40 then
        return 1, 1
    end

    local TyreFront = p40:GetAttribute("TyreFront")
    local TyreRear = p40:GetAttribute("TyreRear")

    if TyreFront ~= nil or TyreRear ~= nil then
        return t1.Factor(TyreFront, t1.WearOf(p40, "F", p42), p41, t1.TempOf(p40, "F", p42)), t1.Factor(TyreRear, t1.WearOf(p40, "R", p42), p41, t1.TempOf(p40, "R", p42))
    end

    return 1, 1
end

t1.LooseGrip = 0.8

function t1.LooseFactor(p43, p44, p45) -- line: 458
    -- upvalues: t1 (copy)
    if t1.Compounds[p43] then
        return t1.LooseGrip * t1.WearFactor(p43, p44) * t1.TempFactor(p43, p45)
    end

    return t1.LooseGrip
end

function t1.LooseGripOf(p46, p47) -- line: 463
    -- upvalues: t1 (copy)
    if not p46 then
        return t1.LooseGrip, t1.LooseGrip
    end

    local TyreFront = p46:GetAttribute("TyreFront")
    local TyreRear = p46:GetAttribute("TyreRear")

    if TyreFront ~= nil or TyreRear ~= nil then
        return t1.LooseFactor(TyreFront, t1.WearOf(p46, "F", p47), t1.TempOf(p46, "F", p47)), t1.LooseFactor(TyreRear, t1.WearOf(p46, "R", p47), t1.TempOf(p46, "R", p47))
    end

    return t1.LooseGrip, t1.LooseGrip
end

t1.LeanFloorShare = {
    Front = 1,
    Rear = 1
}

function t1.Floor(p48, p49) -- line: 472
    -- upvalues: t1 (copy)
    return 1 + ((p48 or 1) - 1) * (t1.LeanFloorShare[p49] or 0)
end

t1.FloorLimitLean = 1.0471975511965976
t1.WearMargin = 0.25

function t1.FloorAt(p50, p51, p52) -- line: 485
    -- upvalues: t1 (copy)
    local v81 = t1.Floor(p50, p51)

    if v81 >= 1 then
        return v81
    end

    local v85 = math.tan((math.clamp(math.abs(if typeof(p52) == "number" and p52 == p52 and p52 then p52 else 0), 0, 1.4835298641951802)))

    return (math.min(v85 > 0.001 and math.min(1, v81 * math.tan(t1.FloorLimitLean) / v85) or 1, 1 - t1.WearMargin * (1 - v81)))
end

t1.WearBrakeUpright = 0.5
t1.BaseKm = 260
t1.Durability = 1.5
t1.WearModel = {
    Base = 0.55,
    Lean = 0.55,
    Brake = 0.9,
    Throttle = 0.35,
    Slip = 3,
    Slide = 1.6,
    RearLock = 2,
    Offtrack = 1.6,
    Kerb = 1.15,
    BurnoutPerSecond = 0.003,
    RearWear = 1.2,
    SlidePerSecond = 0.001,
    SlideFrom = 0.25,
    SpinPerSecond = 0.0015,
    SpinFrom = 0.15
}
t1.RateGreen = 5E-04 / t1.Durability
t1.RateOrange = 0.0012 / t1.Durability
t1.RateRed = 0.0023 / t1.Durability

function t1.RateColor(p53) -- line: 533
    -- upvalues: t1 (copy)
    local v89 = Color3.fromRGB(28, 255, 10)
    local v90 = Color3.fromRGB(255, 150, 0)
    local v91 = Color3.fromRGB(255, 30, 25)

    p53 = p53 or 0

    if p53 <= t1.RateGreen then
        return v89
    end

    if p53 <= t1.RateOrange then
        return v89:Lerp(v90, (p53 - t1.RateGreen) / (t1.RateOrange - t1.RateGreen))
    end

    if p53 <= t1.RateRed then
        return v90:Lerp(v91, (p53 - t1.RateOrange) / (t1.RateRed - t1.RateOrange))
    end

    return v91
end

function t1.Color(p54) -- line: 541
    if p54 > 0.4 then
        return Color3.fromRGB(28, 255, 10)
    end

    if p54 > 0.15 then
        return Color3.fromRGB(255, 200, 0)
    end

    return Color3.fromRGB(255, 45, 35)
end

return require(script.Parent:WaitForChild("OwnerFeatures14")).Wrap(t1, script.Parent, "Pre14_TyreCatalog")
