-- https://lua.expert

local Workspace = game:GetService("Workspace")
local new, new2, new3, new4 = NumberSequence.new, NumberSequenceKeypoint.new, ColorSequence.new, ColorSequenceKeypoint.new

local function emitter(p1, p2, p3) -- line: 10
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = p2
    ParticleEmitter.Enabled = false
    ParticleEmitter.Rate = 0
    ParticleEmitter.LightInfluence = 0

    for v1, v2 in p3 do
        ParticleEmitter[v1] = v2
    end

    ParticleEmitter.Parent = p1

    return ParticleEmitter
end

local function build(p4) -- line: 16
    -- upvalues: new (copy), new2 (copy), new3 (copy), new4 (copy)
    local t1 = {}
    local t2 = {
        Texture = "rbxasset://textures/particles/fire_main.dds",
        LockedToPart = true,
        Drag = 6,
        LightEmission = 0.85,
        Brightness = 1.35,
        ZOffset = 0.2,
        EmissionDirection = Enum.NormalId.Front,
        Orientation = Enum.ParticleOrientation.VelocityParallel,
        Squash = new(-1.4),
        Lifetime = NumberRange.new(0.05, 0.1),
        Speed = NumberRange.new(16, 26),
        SpreadAngle = Vector2.new(6, 6),
        Size = new({
            new2(0, 0.16),
            new2(0.25, 0.42),
            new2(0.7, 0.3),
            new2(1, 0)
        }),
        Transparency = new({
            new2(0, 0),
            new2(0.6, 0.15),
            new2(1, 1)
        }),
        Color = new3({
            new4(0, Color3.fromRGB(90, 140, 255)),
            new4(0.1, Color3.fromRGB(255, 215, 120)),
            new4(0.35, Color3.fromRGB(255, 150, 40)),
            new4(0.7, Color3.fromRGB(235, 70, 15)),
            new4(1, Color3.fromRGB(120, 25, 8))
        })
    }
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "BackfireJet"
    ParticleEmitter.Enabled = false
    ParticleEmitter.Rate = 0
    ParticleEmitter.LightInfluence = 0

    for v3, v4 in t2 do
        ParticleEmitter[v3] = v4
    end

    ParticleEmitter.Parent = p4
    t1.jet = ParticleEmitter

    local t3 = {
        Texture = "rbxasset://textures/particles/fire_main.dds",
        LockedToPart = true,
        Drag = 10,
        LightEmission = 0.8,
        Brightness = 1.2,
        EmissionDirection = Enum.NormalId.Front,
        Lifetime = NumberRange.new(0.06, 0.12),
        Speed = NumberRange.new(5, 10),
        SpreadAngle = Vector2.new(25, 25),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-200, 200),
        Size = new({
            new2(0, 0.2),
            new2(0.3, 0.65),
            new2(1, 0.25)
        }),
        Transparency = new({
            new2(0, 0.05),
            new2(0.5, 0.3),
            new2(1, 1)
        }),
        Color = new3({
            new4(0, Color3.fromRGB(255, 205, 110)),
            new4(0.35, Color3.fromRGB(255, 130, 35)),
            new4(1, Color3.fromRGB(170, 40, 10))
        })
    }
    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Name = "BackfireBall"
    ParticleEmitter2.Enabled = false
    ParticleEmitter2.Rate = 0
    ParticleEmitter2.LightInfluence = 0

    for v5, v6 in t3 do
        ParticleEmitter2[v5] = v6
    end

    ParticleEmitter2.Parent = p4
    t1.ball = ParticleEmitter2

    local t4 = {
        Texture = "rbxasset://textures/particles/fire_main.dds",
        LockedToPart = true,
        LightEmission = 1,
        Brightness = 1.8,
        EmissionDirection = Enum.NormalId.Front,
        Lifetime = NumberRange.new(0.025, 0.045),
        Speed = NumberRange.new(4, 8),
        SpreadAngle = Vector2.new(4, 4),
        Size = new({
            new2(0, 0.14),
            new2(1, 0.05)
        }),
        Transparency = new({
            new2(0, 0.1),
            new2(1, 0.8)
        }),
        Color = new3(Color3.fromRGB(110, 160, 255), Color3.fromRGB(190, 220, 255))
    }
    local ParticleEmitter3 = Instance.new("ParticleEmitter")

    ParticleEmitter3.Name = "BackfireCore"
    ParticleEmitter3.Enabled = false
    ParticleEmitter3.Rate = 0
    ParticleEmitter3.LightInfluence = 0

    for v7, v8 in t4 do
        ParticleEmitter3[v7] = v8
    end

    ParticleEmitter3.Parent = p4
    t1.core = ParticleEmitter3

    local t5 = {
        Texture = "rbxasset://textures/particles/sparkles_main.dds",
        Acceleration = Vector3.new(0, -40, 0),
        Drag = 3,
        VelocityInheritance = 0.85,
        LightEmission = 1,
        Brightness = 2.5,
        EmissionDirection = Enum.NormalId.Front,
        Lifetime = NumberRange.new(0.15, 0.4),
        Speed = NumberRange.new(10, 22),
        SpreadAngle = Vector2.new(22, 22),
        Orientation = Enum.ParticleOrientation.VelocityParallel,
        Squash = new(-1.2),
        Size = new({
            new2(0, 0.07),
            new2(1, 0)
        }),
        Transparency = new({
            new2(0, 0),
            new2(0.7, 0.2),
            new2(1, 1)
        }),
        Color = new3({
            new4(0, Color3.fromRGB(255, 240, 190)),
            new4(0.4, Color3.fromRGB(255, 160, 50)),
            new4(1, Color3.fromRGB(255, 70, 20))
        })
    }
    local ParticleEmitter4 = Instance.new("ParticleEmitter")

    ParticleEmitter4.Name = "BackfireEmbers"
    ParticleEmitter4.Enabled = false
    ParticleEmitter4.Rate = 0
    ParticleEmitter4.LightInfluence = 0

    for v9, v10 in t5 do
        ParticleEmitter4[v9] = v10
    end

    ParticleEmitter4.Parent = p4
    t1.embers = ParticleEmitter4

    return t1
end

local t6 = {
    "rbxassetid://117693659451634",
    "rbxassetid://129025289910636"
}

local function play(p5, p6, p7, p8) -- line: 70
    task.delay(p8 or 0, function() -- line: 71
        -- upvalues: p5 (copy), p6 (copy), p7 (copy)
        if p5.Parent then
            local Sound = Instance.new("Sound")

            Sound.Name = "Bang"
            Sound.SoundId = p6
            Sound.Volume = p7
            Sound.PlaybackSpeed = 0.95 + math.random() * 0.1
            Sound.RollOffMode = Enum.RollOffMode.InverseTapered
            Sound.RollOffMinDistance = 10
            Sound.RollOffMaxDistance = 160
            Sound.Parent = p5
            Sound:Play()
            task.delay(2.5, function() -- line: 76
                -- upvalues: Sound (copy)
                Sound:Destroy()
            end)
        end
    end)
end

local function sound(p9, p10, p11) -- line: 79
    -- upvalues: t6 (copy)
    local v11 = 0.85 + math.random() * 0.3
    local v12 = p11 >= 0.55
    local v13

    if v12 then
        local v14 = (0.3 + 0.2 * p11) * v11
        local delay = task.delay
        local v15 = "rbxassetid://132331652249520"

        delay(0, function() -- line: 71
            -- upvalues: p9 (copy), v14 (copy), v15 (copy)
            if p9.Parent then
                local Sound = Instance.new("Sound")

                Sound.Name = "Bang"
                Sound.SoundId = v15
                Sound.Volume = v14
                Sound.PlaybackSpeed = 0.95 + math.random() * 0.1
                Sound.RollOffMode = Enum.RollOffMode.InverseTapered
                Sound.RollOffMinDistance = 10
                Sound.RollOffMaxDistance = 160
                Sound.Parent = p9
                Sound:Play()
                task.delay(2.5, function() -- line: 76
                    -- upvalues: Sound (copy)
                    Sound:Destroy()
                end)
            end
        end)
        v13 = p10 >= 2
    else
        if p10 >= 2 and math.random() < 0.5 then
            local v16 = t6[math.random(#t6)]
            local v17 = (0.15 + 0.15 * p11) * v11

            task.delay(0, function() -- line: 71
                -- upvalues: p9 (copy), v16 (copy), v17 (copy)
                if p9.Parent then
                    local Sound = Instance.new("Sound")

                    Sound.Name = "Bang"
                    Sound.SoundId = v16
                    Sound.Volume = v17
                    Sound.PlaybackSpeed = 0.95 + math.random() * 0.1
                    Sound.RollOffMode = Enum.RollOffMode.InverseTapered
                    Sound.RollOffMinDistance = 10
                    Sound.RollOffMaxDistance = 160
                    Sound.Parent = p9
                    Sound:Play()
                    task.delay(2.5, function() -- line: 76
                        -- upvalues: Sound (copy)
                        Sound:Destroy()
                    end)
                end
            end)

            return
        end

        local v18 = (0.14 + 0.2 * p11) * v11
        local delay = task.delay
        local v19 = "rbxassetid://132331652249520"

        delay(0, function() -- line: 71
            -- upvalues: p9 (copy), v18 (copy), v19 (copy)
            if p9.Parent then
                local Sound = Instance.new("Sound")

                Sound.Name = "Bang"
                Sound.SoundId = v19
                Sound.Volume = v18
                Sound.PlaybackSpeed = 0.95 + math.random() * 0.1
                Sound.RollOffMode = Enum.RollOffMode.InverseTapered
                Sound.RollOffMinDistance = 10
                Sound.RollOffMaxDistance = 160
                Sound.Parent = p9
                Sound:Play()
                task.delay(2.5, function() -- line: 76
                    -- upvalues: Sound (copy)
                    Sound:Destroy()
                end)
            end
        end)
    end

    if v12 and not v13 or not v12 then
        return
    end

    local v20 = t6[math.random(#t6)]
    local v21 = (0.28 + 0.2 * p11) * v11
    local v22 = 0.06 + math.random() * 0.05

    task.delay(v22 or 0, function() -- line: 71
        -- upvalues: p9 (copy), v20 (copy), v21 (copy)
        if p9.Parent then
            local Sound = Instance.new("Sound")

            Sound.Name = "Bang"
            Sound.SoundId = v20
            Sound.Volume = v21
            Sound.PlaybackSpeed = 0.95 + math.random() * 0.1
            Sound.RollOffMode = Enum.RollOffMode.InverseTapered
            Sound.RollOffMinDistance = 10
            Sound.RollOffMaxDistance = 160
            Sound.Parent = p9
            Sound:Play()
            task.delay(2.5, function() -- line: 76
                -- upvalues: Sound (copy)
                Sound:Destroy()
            end)
        end
    end)
end

local function bang(p12, p13, p14, p15, p16) -- line: 90
    if not p12.Parent or p16.token ~= p15 then
        return
    end

    local v23 = 0.45 + 0.55 * p14

    p13.jet:Emit((math.round(4 + 6 * v23)))
    p13.ball:Emit((math.round(2 + 3 * v23)))
    p13.core:Emit(2)

    if p14 > 0.35 then
        p13.embers:Emit(math.random(2, (math.round(3 + 6 * p14))))
    end

    p13.jet.Speed = NumberRange.new(12 + 10 * v23, 20 + 14 * v23)
end

local function hook(p17) -- line: 99
    -- upvalues: Workspace (copy), build (copy), bang (copy)
    if not p17:IsA("Attachment") or p17.Name ~= "ExhaustOutlet" then
        return
    end

    local v27 = p17.Parent and p17.Parent.Parent

    if not v27 then
        return
    end

    local v28
    local t7 = {
        token = 0,
        flash = 0
    }

    local function burst() -- line: 104
        -- upvalues: p17 (copy), v27 (copy), v28 (ref), t7 (copy), Workspace (copy), build (copy), bang (copy)
        if game:GetService("Players").LocalPlayer:GetAttribute("GfxEffects") == false then
            return
        end

        local WorldPosition = p17.WorldPosition
        local CurrentCamera = Workspace.CurrentCamera
        local v29

        if not CurrentCamera or (CurrentCamera.CFrame.Position - WorldPosition).Magnitude > 320 then
            return
        else
            v29 = v28 or build(p17)
        end

        v28 = v29

        local v32 = math.clamp(v27:GetAttribute("ExhaustBurst") or 1, 1, 5)
        local v34 = math.clamp(v27:GetAttribute("ExhaustPower") or 0.6, 0, 1)

        t7.token += 1

        local token = t7.token
        local n1 = 0

        for i = 1, v32 do
            local v35 = v34 * (if i == 1 then 1 else 0.55 + math.random() * 0.4)

            task.delay(n1, bang, p17, v28, v35, token, t7)
            n1 += 0.045 + math.random() * 0.09
        end
    end

    v27:GetAttributeChangedSignal("ExhaustPops"):Connect(burst)
end

for _, descendant in Workspace:GetDescendants() do
    if descendant.Name == "ExhaustOutlet" then
        task.spawn(hook, descendant)
    end
end

Workspace.DescendantAdded:Connect(function(p18) -- line: 126
    -- upvalues: hook (copy)
    if p18.Name == "ExhaustOutlet" then
        task.defer(hook, p18)
    end
end)
