-- https://lua.expert

local t1 = {
    Order = { "Soft", "Medium", "Hard", "Wet" },
    Sides = { "F", "R" },
    Compounds = {
        Soft = {
            Letter = "S",
            Name = "Soft",
            Hint = "Most grip · wears fast · overheats on hot tracks",
            Grip = 1.1,
            WetGrip = 0.8,
            Wear = 1.25,
            WetWear = 0.6,
            Drop = 1.25,
            Color = Color3.fromRGB(245, 245, 245),
            Stripe = Color3.fromRGB(245, 245, 245)
        },
        Medium = {
            Letter = "M",
            Name = "Medium",
            Hint = "Balanced",
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
            Hint = "Less grip · lasts long · needs heat",
            Grip = 0.92,
            WetGrip = 0.8,
            Wear = 0.8,
            WetWear = 0.4,
            Drop = 0.8,
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

function t1.RestoreCostFor(p1) -- line: 32
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

function t1.CurveAt(p2) -- line: 51
    -- upvalues: t1 (copy)
    local v6 = math.clamp(if typeof(p2) == "number" and p2 == p2 and p2 then p2 else 1, 0, 1)
    local Curve = t1.Curve

    for i = 2, #Curve do
        if v6 <= Curve[i][1] then
            local v7 = Curve[i - 1]
            local v8 = Curve[i]

            return v7[2] + (v8[2] - v7[2]) * (v6 - v7[1]) / (v8[1] - v7[1])
        end
    end

    return Curve[#Curve][2]
end

function t1.WearFactor(p3, p4) -- line: 63
    -- upvalues: t1 (copy)
    local v9 = t1.Compounds[p3]

    if v9 then
        return 1 - (1 - t1.CurveAt(p4)) * (v9.Drop or 1)
    end

    return 1
end

t1.WearDriveUpright = 0.25

function t1.Worn(p5, p6) -- line: 75
    -- upvalues: t1 (copy)
    local v10 = p6 and t1.Compounds[p6]

    return (math.clamp((1 - t1.CurveAt(p5)) * (v10 and v10.Drop or 1) / (1 - t1.Curve[1][2]), 0, 1))
end

t1.LateralSlide = 1

function t1.RearWornOf(p7, p8) -- line: 86
    -- upvalues: t1 (copy)
    if not p7 or p7:GetAttribute("TyreRear") == nil then
        return 0
    end

    return (math.max(t1.Worn(p7:GetAttribute("TyreWearR"), p7:GetAttribute("TyreRear")), t1.ColdOf(p7, "R", p8) * (t1.Temp.ColdSlide or 0)))
end

t1.SlideBoost = 0.6
t1.Temp = {
    Rise = 52,
    TimeConst = 30,
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
    CoolStill = 120,
    SlipFloor = 0.8,
    BurnoutHeat = 2.8,
    BurnoutTimeConst = 12,
    BurnoutFlashGain = 20,
    BurnoutFlashMax = 50,
    FlashGain = 10,
    FlashFrom = 0.5,
    FlashMax = 32,
    FlashRise = 3.5,
    FlashDecay = 5,
    BurnoutFlashRise = 1.5,
    ScrubCore = 0.6
}
t1.Temp.BrakeFlashGain = 12
t1.Temp.BrakeFlashKph = 200
t1.Temp.BrakeFlashMax = 50
t1.Temp.BrakeFlashDecay = 10
t1.Temp.EBSHeat = { 0.3, 0.45, 0.75, 1.25, 2 }
t1.Temp.TCSHeat = { 1.35, 1.2, 1.08, 1, 0.9 }
t1.Zones = { "L", "C", "R" }

function t1.LeanZone(p9) -- line: 164
    -- upvalues: t1 (copy)
    local v14 = if typeof(p9) == "number" and p9 == p9 and p9 then p9 else 0
    local v16 = math.clamp(math.abs(v14) / t1.Temp.ShoulderLean, 0, 1)

    if v14 > 0 then
        return v16, "L"
    end

    return v16, "R"
end

function t1.ContactTemp(p10, p11) -- line: 169
    -- upvalues: t1 (copy)
    local v17, v18 = t1.LeanZone(p11)

    return p10.C + (p10[v18] - p10.C) * v17
end

function t1.TempOf(p12, p13, p14) -- line: 174
    -- upvalues: t1 (copy)
    if not p12 then
        return nil
    end

    local Attribute = p12:GetAttribute("TyreTemp" .. p13 .. "C")

    if typeof(Attribute) ~= "number" then
        return p12:GetAttribute("TyreTemp" .. p13)
    end

    local Attribute2 = p12:GetAttribute("TyreTemp" .. p13 .. "L")
    local Attribute3 = p12:GetAttribute("TyreTemp" .. p13 .. "R")
    local ContactTemp = t1.ContactTemp

    if typeof(Attribute2) ~= "number" or not Attribute2 then
        Attribute2 = Attribute
    end

    return ContactTemp({
        L = Attribute2,
        C = Attribute,
        R = if typeof(Attribute3) == "number" and Attribute3 then Attribute3 else Attribute
    }, p14)
end

t1.TempWindows = {
    Soft = { 70, 115, 1.25 },
    Medium = { 80, 120, 1 },
    Hard = { 85, 125, 0.85 },
    Wet = { 40, 80, 1 }
}

function t1.TempFactor(p15, p16) -- line: 182
    -- upvalues: t1 (copy)
    local v19 = t1.TempWindows[p15]

    if not v19 or typeof(p16) ~= "number" then
        return 1
    end

    local Temp = t1.Temp

    if p16 < v19[1] then
        return 1 - Temp.ColdLoss * t1.Coldness(p15, p16)
    end

    if not (v19[2] < p16) then
        return 1
    end

    return 1 - Temp.HotLoss * math.clamp((p16 - v19[2]) / Temp.HotSpan, 0, 1)
end

function t1.Coldness(p17, p18) -- line: 190
    -- upvalues: t1 (copy)
    local v21 = t1.TempWindows[p17]

    if not v21 or typeof(p18) ~= "number" or v21[1] <= p18 then
        return 0
    end

    return math.clamp((v21[1] - p18) / t1.Temp.ColdSpan, 0, 1) ^ (t1.Temp.ColdCurve or 1)
end

function t1.ColdOf(p19, p20, p21) -- line: 195
    -- upvalues: t1 (copy)
    if not p19 then
        return 0
    end

    local Attribute = p19:GetAttribute(if p20 == "F" then "TyreFront" else "TyreRear")

    if Attribute == nil then
        return 0
    end

    return t1.Coldness(Attribute, t1.TempOf(p19, p20, p21))
end

function t1.TempWear(p22, p23) -- line: 200
    -- upvalues: t1 (copy)
    local v23 = t1.TempWindows[p22]

    if not v23 or typeof(p23) ~= "number" or p23 <= v23[2] then
        return 1
    end

    return 1 + t1.Temp.HotWear * math.clamp((p23 - v23[2]) / t1.Temp.HotSpan, 0, 1)
end

function t1.TempState(p24, p25) -- line: 205
    -- upvalues: t1 (copy)
    local v25 = t1.TempWindows[p24]

    if v25 and typeof(p25) == "number" then
        if p25 < v25[1] then
            return "COLD"
        end

        if v25[2] < p25 then
            return "HOT"
        end
    end

    return "OK"
end

function t1.Factor(p26, p27, p28, p29) -- line: 211
    -- upvalues: t1 (copy)
    local v26 = t1.Compounds[p26]

    if not v26 then
        return 1
    end

    return (p28 and v26.WetGrip or v26.Grip) * (1 - (1 - t1.CurveAt(p27)) * (v26.Drop or 1)) * t1.TempFactor(p26, p29)
end

function t1.GripOf(p30, p31, p32) -- line: 216
    -- upvalues: t1 (copy)
    if not p30 then
        return 1, 1
    end

    local TyreFront = p30:GetAttribute("TyreFront")
    local TyreRear = p30:GetAttribute("TyreRear")

    if TyreFront ~= nil or TyreRear ~= nil then
        return t1.Factor(TyreFront, p30:GetAttribute("TyreWearF"), p31, t1.TempOf(p30, "F", p32)), t1.Factor(TyreRear, p30:GetAttribute("TyreWearR"), p31, t1.TempOf(p30, "R", p32))
    end

    return 1, 1
end

t1.LooseGrip = 0.8

function t1.LooseFactor(p33, p34, p35) -- line: 228
    -- upvalues: t1 (copy)
    if t1.Compounds[p33] then
        return t1.LooseGrip * t1.WearFactor(p33, p34) * t1.TempFactor(p33, p35)
    end

    return t1.LooseGrip
end

function t1.LooseGripOf(p36, p37) -- line: 233
    -- upvalues: t1 (copy)
    if not p36 then
        return t1.LooseGrip, t1.LooseGrip
    end

    local TyreFront = p36:GetAttribute("TyreFront")
    local TyreRear = p36:GetAttribute("TyreRear")

    if TyreFront ~= nil or TyreRear ~= nil then
        return t1.LooseFactor(TyreFront, p36:GetAttribute("TyreWearF"), t1.TempOf(p36, "F", p37)), t1.LooseFactor(TyreRear, p36:GetAttribute("TyreWearR"), t1.TempOf(p36, "R", p37))
    end

    return t1.LooseGrip, t1.LooseGrip
end

t1.LeanFloorShare = {
    Front = 1,
    Rear = 1
}

function t1.Floor(p38, p39) -- line: 242
    -- upvalues: t1 (copy)
    return 1 + ((p38 or 1) - 1) * (t1.LeanFloorShare[p39] or 0)
end

t1.BaseKm = 260
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
t1.RateGreen = 5E-04
t1.RateOrange = 0.0012
t1.RateRed = 0.0023

function t1.RateColor(p40) -- line: 275
    -- upvalues: t1 (copy)
    local v27 = Color3.fromRGB(28, 255, 10)
    local v28 = Color3.fromRGB(255, 150, 0)
    local v29 = Color3.fromRGB(255, 30, 25)

    p40 = p40 or 0

    if p40 <= t1.RateGreen then
        return v27
    end

    if p40 <= t1.RateOrange then
        return v27:Lerp(v28, (p40 - t1.RateGreen) / (t1.RateOrange - t1.RateGreen))
    end

    if p40 <= t1.RateRed then
        return v28:Lerp(v29, (p40 - t1.RateOrange) / (t1.RateRed - t1.RateOrange))
    end

    return v29
end

function t1.Color(p41) -- line: 283
    if p41 > 0.4 then
        return Color3.fromRGB(28, 255, 10)
    end

    if p41 > 0.15 then
        return Color3.fromRGB(255, 200, 0)
    end

    return Color3.fromRGB(255, 45, 35)
end

return t1
