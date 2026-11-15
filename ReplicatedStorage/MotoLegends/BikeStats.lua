-- https://lua.expert

local t1 = {
    MaxRating = 5,
    Order = {
        {
            Key = "TopSpeed",
            Label = "TOP SPEED"
        },
        {
            Key = "Acceleration",
            Label = "ACCELERATION"
        },
        {
            Key = "Handling",
            Label = "HANDLING"
        }
    },
    Manufacturers = {
        Ducati = {
            TopSpeed = 5,
            Acceleration = 4,
            Handling = 3
        },
        Aprilia = {
            TopSpeed = 5,
            Acceleration = 3,
            Handling = 4
        },
        Honda = {
            TopSpeed = 4,
            Acceleration = 5,
            Handling = 3
        },
        KTM = {
            TopSpeed = 4,
            Acceleration = 5,
            Handling = 3
        },
        Yamaha = {
            TopSpeed = 3,
            Acceleration = 5,
            Handling = 4
        }
    },
    TeamManufacturer = {
        Ducati = "Ducati",
        VR46 = "Ducati",
        Gresini = "Ducati",
        Aprilia = "Aprilia",
        Trackhouse = "Aprilia",
        KTM = "KTM",
        Tech3 = "KTM",
        Yamaha = "Yamaha",
        Pramac = "Yamaha",
        Honda = "Honda",
        LCR = "Honda"
    },
    Effects = {
        TopSpeedKph = { 417.6, 423.6, 429.6, 435.6, 441.6 },
        Acceleration = { 0.85, 0.9, 0.95, 1, 1.05 },
        Handling = { 0.82, 0.88, 0.94, 1, 1.06 },
        Grip = { 0.97, 0.98, 0.99, 1, 1.01 }
    },
    AccelFadeFromKph = 264,
    AccelFadeToKph = 360
}

local function teamId(p1) -- line: 41
    -- upvalues: t1 (copy)
    if typeof(p1) ~= "string" then
        return nil
    end

    if t1.TeamManufacturer[p1] then
        return p1
    end

    for v1 in t1.TeamManufacturer do
        if v1:upper() == p1:upper() then
            return v1
        end
    end

    return nil
end

function t1.Ratings(p2) -- line: 48
    -- upvalues: t1 (copy), teamId (copy)
    local v2 = teamId(p2)

    return v2 and t1.Manufacturers[t1.TeamManufacturer[v2]] or nil
end

local t2 = {}

function t1.Physics(p3) -- line: 54
    -- upvalues: t1 (copy), t2 (copy)
    local v3 = if typeof(p3) ~= "string" or not p3 then "" else p3
    local v4 = t2[v3]

    if v4 then
        return v4
    end

    local v5 = t1.Ratings(p3) or {
        TopSpeed = 4,
        Acceleration = 4,
        Handling = 4
    }
    local Effects = t1.Effects

    local function pick(p4, p5) -- line: 59
        return p4[math.clamp(math.floor(tonumber(p5) or 4), 1, #p4)]
    end

    local TopSpeedKph = Effects.TopSpeedKph
    local t3 = {}

    t3.TopSpeedKph = TopSpeedKph[math.clamp(math.floor(tonumber(v5.TopSpeed) or 4), 1, #TopSpeedKph)]

    local Acceleration = Effects.Acceleration

    t3.Accel = Acceleration[math.clamp(math.floor(tonumber(v5.Acceleration) or 4), 1, #Acceleration)]

    local Handling = Effects.Handling

    t3.Handling = Handling[math.clamp(math.floor(tonumber(v5.Handling) or 4), 1, #Handling)]

    local Grip = Effects.Grip

    t3.Grip = Grip[math.clamp(math.floor(tonumber(v5.Handling) or 4), 1, #Grip)]
    t2[v3] = t3

    return t3
end

return t1
