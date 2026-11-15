-- https://lua.expert

local Config = require(script.Parent.Config)
local t1 = {}
local v1 = game:GetService("RunService"):IsServer()

local function qset(p1, p2, p3) -- line: 10
    if p1 and p1:GetAttribute(p2) ~= p3 then
        p1:SetAttribute(p2, p3)
    end
end

local function q(p4, p5) -- line: 11
    return math.round(p4 / p5) * p5
end

t1.ExhaustTips = {
    Ducati = { Vector3.new(0.64, 2.17, 3.66), 8 },
    Gresini = { Vector3.new(0.64, 2.3, 3.68), 10 },
    VR46 = { Vector3.new(0.64, 2.3, 3.68), 10 },
    Aprilia = { Vector3.new(0.44, 2.11, 4.12), 24 },
    Trackhouse = { Vector3.new(0.45, 2.13, 4.12), 24 },
    KTM = { Vector3.new(0.58, 2.24, 3.9), 14 },
    Yamaha = { Vector3.new(0.62, 2.46, 4.25), 6 },
    Pramac = { Vector3.new(0.62, 2.46, 4.25), 6 },
    Honda = { Vector3.new(0.67, 2.27, 3.98), 20 },
    LCR = { Vector3.new(0.67, 2.27, 3.98), 20 },
    Tech3 = { Vector3.new(0.6, 2.26, 3.9), 14 }
}

function t1.Create(p6, p7, p8, p9) -- line: 21
    -- upvalues: Config (copy), t1 (copy)
    local Attachment = Instance.new("Attachment", p6)

    Attachment.Name = "ExhaustOutlet"

    local v3 = p6.Parent and p6.Parent:GetAttribute("BikeName")
    local v4 = t1.ExhaustTips[v3]
    local v5 = v4 and v4[1] or Vector3.new(0.53, 1.48, 2.13) * p7 + p8

    Attachment.CFrame = CFrame.new(v5) * CFrame.Angles(0, 3.141592653589793, 0) * CFrame.Angles(math.rad(v4 and v4[2] or 8), 0, 0)
    Attachment:SetAttribute("PopSound", p9 or "")

    local Attachment2 = Instance.new("Attachment", p6)

    Attachment2.Name = "RearTyreSmoke"
    Attachment2.Position = Config.RearAxle - Vector3.new(0, 1, 0) * (Config.RearWheelRadius - 0.05)

    local ParticleEmitter = Instance.new("ParticleEmitter", Attachment2)

    ParticleEmitter.Name = "BurnoutSmoke"
    ParticleEmitter.Enabled = false
    ParticleEmitter.Rate = 0
    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Lifetime = NumberRange.new(0.65, 1.35)
    ParticleEmitter.Speed = NumberRange.new(1.4, 4)
    ParticleEmitter.SpreadAngle = Vector2.new(28, 28)
    ParticleEmitter.Acceleration = Vector3.new(0, 3.5, 0)
    ParticleEmitter.Drag = 2
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-35, 35)
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.45),
        NumberSequenceKeypoint.new(0.35, 1.8),
        NumberSequenceKeypoint.new(1, 3)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.35),
        NumberSequenceKeypoint.new(0.2, 0.45),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(210, 215, 215), Color3.fromRGB(150, 157, 158))
    ParticleEmitter.LightInfluence = 0.65

    local clone = ParticleEmitter:Clone()

    clone.Name = "GravelDust"
    clone.Parent = Attachment2
    ParticleEmitter.Lifetime = NumberRange.new(1.6, 3.2)
    ParticleEmitter.Speed = NumberRange.new(1.6, 4.6)
    ParticleEmitter.Drag = 1.5
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(0.3, 2.8),
        NumberSequenceKeypoint.new(1, 5.5)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.25, 0.4),
        NumberSequenceKeypoint.new(1, 1)
    })
    clone.Color = ColorSequence.new(Color3.fromRGB(195, 172, 131), Color3.fromRGB(139, 119, 89))
    clone.Lifetime = NumberRange.new(1.1, 2.2)
    clone.Speed = NumberRange.new(4, 12)
    clone.Drag = 1.2
    clone.SpreadAngle = Vector2.new(50, 50)
    clone.Acceleration = Vector3.new(0, -2.5, 0)
    clone.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.25),
        NumberSequenceKeypoint.new(0.4, 1.3),
        NumberSequenceKeypoint.new(1, 2.5)
    })

    local Attachment3 = Instance.new("Attachment", p6)

    Attachment3.Name = "ScrapeSparks"

    local ParticleEmitter2 = Instance.new("ParticleEmitter", Attachment3)

    ParticleEmitter2.Name = "Sparks"
    ParticleEmitter2.Enabled = false
    ParticleEmitter2.Rate = 0
    ParticleEmitter2.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter2.EmissionDirection = Enum.NormalId.Back
    ParticleEmitter2.Lifetime = NumberRange.new(0.18, 0.45)
    ParticleEmitter2.Speed = NumberRange.new(10, 26)
    ParticleEmitter2.SpreadAngle = Vector2.new(35, 18)
    ParticleEmitter2.Acceleration = Vector3.new(0, -60, 0)
    ParticleEmitter2.Drag = 2
    ParticleEmitter2.LightEmission = 1
    ParticleEmitter2.LightInfluence = 0
    ParticleEmitter2.Brightness = 3
    ParticleEmitter2.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.18),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 250, 210)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 190, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 90, 20))
    })
    ParticleEmitter2.Orientation = Enum.ParticleOrientation.VelocityParallel
    ParticleEmitter2.Squash = NumberSequence.new(-1.6)

    local PointLight = Instance.new("PointLight", Attachment3)

    PointLight.Name = "SparkGlow"
    PointLight.Color = Color3.fromRGB(255, 170, 60)
    PointLight.Range = 8
    PointLight.Brightness = 0
    PointLight.Shadows = false
    PointLight.Enabled = true

    return {
        lastAt = -100,
        token = 0,
        lastGear = 1,
        root = p6,
        smoke = ParticleEmitter,
        dust = clone,
        rearSmoke = Attachment2,
        sparks = ParticleEmitter2,
        sparkPoint = Attachment3,
        sparkGlow = PointLight
    }
end

function t1.GravelDust(p10, p11, p12, p13) -- line: 66
    -- upvalues: t1 (copy), v1 (copy)
    if p10 and p10.dust then
        if v1 then
            local v8 = p10.root and p10.root.Parent
            local v9 = if p12 then math.max(10, math.round((p11 or 0) / 10) * 10) else nil

            if not p12 or not v9 then
                v9 = 0
            end

            if v8 and v8:GetAttribute("GravelKph") ~= v9 then
                v8:SetAttribute("GravelKph", v9)
            end

            local v12, v13

            if p12 and typeof(p13) == "Vector3" then
                local v20 = Vector3.new(math.round(p13.X / 0.5) * 0.5, math.round(p13.Y / 0.5) * 0.5, math.round(p13.Z / 0.5) * 0.5)

                if v20 then
                    v12 = v20
                    v13 = true
                else
                    v13 = false
                end
            else
                v13 = false
            end

            if not v13 then
                v12 = nil
            end

            if v8 and v8:GetAttribute("DustPoint") ~= v12 then
                v8:SetAttribute("DustPoint", v12)
            end
        else
            t1.ApplyGravelDust(p10, p11, p12)
        end
    end
end

function t1.ApplyGravelDust(p14, p15, p16) -- line: 77
    local v21 = p14 and p14.dust

    if v21 then
        if p16 then
            local v23 = math.clamp((p15 or 0) / 150, 0, 1)
            local v25 = math.floor(v23 * 10 + 0.5) / 10

            if p14.dustStep ~= v25 then
                p14.dustStep = v25

                local v26 = v25 * 0.65 + 0.35

                v21.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, v26 * 0.6),
                    NumberSequenceKeypoint.new(0.35, v26 * 3.2),
                    NumberSequenceKeypoint.new(1, v26 * 6)
                })
                v21.Speed = NumberRange.new(v25 * 8 + 3, v25 * 14 + 6)
            end

            v21.Enabled = true
            v21.Rate = v23 * 125 + 15
        else
            v21.Enabled = false
            v21.Rate = 0
        end
    end
end

function t1.Pop(p17, p18, p19, p20) -- line: 91
    local effects = p17.effects
    local elapsed, v27, v28, v29

    if not effects or p17.crashed then
        v29 = true
    elseif p17.rider then
        elapsed = os.clock()
        v27 = elapsed - effects.lastAt
        v28 = if p18 then 0.22 else 0.45
        v29 = false
    else
        v29 = true
    end

    if v29 or v27 < v28 then
        return false
    end

    effects.lastAt = elapsed
    p17.bike:SetAttribute("ExhaustBurst", (math.clamp(math.floor(p19 or 1), 1, 5)))
    p17.bike:SetAttribute("ExhaustPower", math.floor(math.clamp(p20 or 0.6, 0, 1) * 100 + 0.5) / 100)
    p17.bike:SetAttribute("ExhaustPops", (p17.bike:GetAttribute("ExhaustPops") or 0) + 1)

    return true
end

function t1.Burnout(p21, p22) -- line: 100
    -- upvalues: Config (copy), t1 (copy), v1 (copy)
    local effects = p21.effects

    if not effects then
        return
    end

    local v34 = not p21.crashed and p21.rider and p22.onGround and p22.surface == "Gravel" and p22.speed > 2

    t1.GravelDust(effects, p22.kph or p22.speed * Config.StudMetres * 3.6, v34 == true)

    local v35, v36

    if p21.crashed then
        v36 = false
    elseif p21.rider and p22.onGround and p22.surface == "Asphalt" then
        local v38 = math.clamp(p22.burnout or 0, 0, 1)

        if v38 then
            v35 = v38
            v36 = true
        else
            v36 = false
        end
    else
        v36 = false
    end

    if not v36 then
        v35 = 0
    end

    if v1 then
        local bike = p21.bike
        local v40 = math.round(v35 / 0.05) * 0.05

        if bike and bike:GetAttribute("Burnout") ~= v40 then
            bike:SetAttribute("Burnout", v40)
        end

        local bike2 = p21.bike
        local v41, v42

        if effects.sparks then
            local n1 = 0

            if p21.crashed then
            elseif p21.rider then
                n1 = math.clamp(p22.scrape or 0, 0, 1) or 0
            end

            local v45 = math.round(n1 / 0.05) * 0.05

            if v45 then
                v41 = v45
                v42 = true
            else
                v42 = false
            end
        else
            v42 = false
        end

        if not v42 then
            v41 = 0
        end

        if bike2 and bike2:GetAttribute("Scrape") ~= v41 then
            bike2:SetAttribute("Scrape", v41)
        end
    else
        effects.smoke.Enabled = v35 > 0.025
        effects.smoke.Rate = v35 * 80

        if effects.smoke.Enabled or effects.dust.Enabled then
            local rearMarkPosition = p21.rearMarkPosition

            if rearMarkPosition then
                effects.rearSmoke.Position = p21.root.CFrame:PointToObjectSpace(rearMarkPosition + Vector3.new(0, 0.08, 0))
            else
                effects.rearSmoke.Position = Config.RearAxle + Vector3.new(0, 1, 0) * ((p21.rearCompression or 0) - Config.RearWheelRadius + 0.05)
            end
        end

        p21.bike:SetAttribute("Burnout", v35)

        if effects.sparks then
            local n2 = 0

            if p21.crashed then
            elseif p21.rider then
                n2 = math.clamp(p22.scrape or 0, 0, 1) or 0
            end

            if n2 > 0.02 then
                local CFrame = p21.root.CFrame
                local v48 = Vector3.new(0, Config.RearAxle.Y - Config.RearWheelRadius + 0.35, 0.6)
                local v49 = CFrame * (v48 + Vector3.new(-0.85, 0, 0))
                local v50 = CFrame * (v48 + Vector3.new(0.85, 0, 0))

                effects.sparkPoint.Position = v48 + Vector3.new(v49.Y < v50.Y and -0.85 or 0.85, 0, 0)
            end

            effects.sparks.Enabled = n2 > 0.02
            effects.sparks.Rate = n2 * 320
            effects.sparkGlow.Brightness = n2 > 0.02 and (1.2 + math.random() * 1.8) * n2 or 0
            p21.bike:SetAttribute("Scrape", n2)
        end
    end
end

function t1.StopTyres(p23) -- line: 131
    if p23.bike and p23.bike:GetAttribute("TyreMarkRear") ~= nil then
        p23.bike:SetAttribute("TyreMarkRear", false)
        p23.bike:SetAttribute("TyreMarkFront", false)
        p23.bike:SetAttribute("TyreMarkBurnout", false)
    end

    if p23.effects and p23.effects.dust then
        p23.effects.dust.Enabled = false
        p23.effects.dust.Rate = 0
    end

    if p23.effects and p23.effects.smoke then
        p23.effects.smoke.Enabled = false
        p23.effects.smoke.Rate = 0
    end

    if p23.effects and p23.effects.sparks then
        p23.effects.sparks.Enabled = false
        p23.effects.sparkGlow.Brightness = 0
    end

    p23.burnout = 0
    p23.markSoundUntil = 0
    p23.bike:SetAttribute("Burnout", 0)
    p23.bike:SetAttribute("Scrape", 0)
    p23.bike:SetAttribute("GravelKph", 0)
    p23.bike:SetAttribute("DustPoint", nil)
    p23.bike:SetAttribute("TyreMarkSound", false)

    if p23.skid then
        p23.skid.Volume = 0
        p23.skid:Stop()
    end
end

function t1.MarkSound(p24, p25) -- line: 140
    local v52 = not p24.crashed
    local v53, v54, v55

    if v52 then
        local rider = p24.rider

        if rider then
            local v56 = not p24.parked

            if v56 then
                v53 = p24.markSoundUntil or 0
                v54 = p25 or os.clock()
                v55 = v54 < v53
            else
                v55 = v56
            end
        else
            v55 = rider
        end
    else
        v55 = v52
    end

    p24.bike:SetAttribute("TyreMarkSound", v55 == true)

    if v55 then
        p24.skid.Volume = math.clamp(0.1 + (p24.burnout or 0) * 0.3 + math.min(p24.slip or 0, 1.4) * 0.22, 0.1, 0.55)

        if not p24.skid.IsPlaying then
            p24.skid:Play()
        end
    else
        p24.skid.Volume = 0

        if p24.skid.IsPlaying then
            p24.skid:Stop()
        end
    end
end

function t1.Step(p26, p27, p28, p29, p30) -- line: 153
    -- upvalues: t1 (copy)
    local effects = p26.effects

    if not effects then
        return
    end

    p30 = p30 or 0

    local elapsed = os.clock()
    local v61 = (p26.gear or 1) < (effects.lastGear or 1)
    local v62 = (p26.gear or 1) > (effects.lastGear or 1)

    effects.lastGear = p26.gear

    local v63 = (effects.lastThrottle or 0) > 0.6 and p30 < 0.1

    effects.lastThrottle = p30

    if not (p29 < 35) and not p26.parked then
        local v65 = math.clamp((p27 - 7000) / 6000, 0, 1)

        if v61 and p27 > 7500 then
            t1.Pop(p26, true, math.random(2, 4), v65 * 0.35 + 0.65)
        elseif v62 and p30 > 0.7 and p27 > 9500 then
            if math.random() < 0.5 then
                t1.Pop(p26, true, 1, v65 * 0.1 + 0.22)
            end
        elseif v63 and p27 > 8500 then
            t1.Pop(p26, true, math.random(2, 3), v65 * 0.35 + 0.5)
        elseif p30 < 0.05 and p27 > 8500 then
            effects.nextCrackle = effects.nextCrackle or elapsed + 0.3

            if effects.nextCrackle <= elapsed then
                effects.nextCrackle = elapsed + 0.35 + math.random() * 0.75

                if t1.Pop(p26, false, math.random(1, 2), v65 * 0.35 + 0.25 + (p28 or 0) * 0.1) then
                end
            end
        else
            effects.nextCrackle = nil
        end
    end
end

return t1
