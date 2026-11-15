-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local v1 = TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local t1 = {
    lighting = {
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        ExposureCompensation = Lighting.ExposureCompensation
    },
    atmos = {},
    sunrays = {},
    bloom = {}
}

for _, child in Lighting:GetChildren() do
    if child:IsA("Atmosphere") then
        t1.atmos[child] = {
            Density = child.Density,
            Haze = child.Haze,
            Glare = child.Glare,
            Color = child.Color,
            Decay = child.Decay,
            Offset = child.Offset
        }
    elseif child:IsA("SunRaysEffect") then
        t1.sunrays[child] = {
            Intensity = child.Intensity
        }
    elseif child:IsA("BloomEffect") then
        t1.bloom[child] = {
            Intensity = child.Intensity
        }
    end
end

local Clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
local v2 = Clouds == nil

if not Clouds then
    Clouds = Instance.new("Clouds")
    Clouds.Cover = 0
    Clouds.Density = 0
    Clouds.Enabled = false
    Clouds.Parent = workspace.Terrain
end

t1.clouds = {
    Cover = Clouds.Cover,
    Density = Clouds.Density,
    Color = Clouds.Color
}

local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

ColorCorrectionEffect.Name = "RainGrade"
ColorCorrectionEffect.Enabled = false
ColorCorrectionEffect.Parent = Lighting

local Part = Instance.new("Part")

Part.Name = "RainEmitter"
Part.Anchored = true
Part.CanCollide = false
Part.CanTouch = false
Part.CanQuery = false
Part.Transparency = 1
Part.Size = Vector3.new(80, 1, 80)
Part.CastShadow = false

local function makeEmitter(p1, p2, p3, p4) -- line: 34
    -- upvalues: Part (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.EmissionDirection = Enum.NormalId.Bottom
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
    ParticleEmitter.Orientation = Enum.ParticleOrientation.VelocityParallel
    ParticleEmitter.Speed = NumberRange.new(p3 * 0.9, p3 * 1.1)
    ParticleEmitter.Lifetime = NumberRange.new(0.55, 0.7)
    ParticleEmitter.Acceleration = Vector3.new(4, 0, 2)
    ParticleEmitter.Size = NumberSequence.new(p2)
    ParticleEmitter.Squash = NumberSequence.new(-2.7)
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(215, 226, 242))
    ParticleEmitter.LightEmission = 0.5
    ParticleEmitter.LightInfluence = 0.3
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.12, p4),
        NumberSequenceKeypoint.new(1, p4)
    })
    ParticleEmitter.Rate = 0
    ParticleEmitter.Enabled = true
    ParticleEmitter.Parent = Part

    return ParticleEmitter, p1
end

local t2 = {}
local v3, v4 = makeEmitter(1800, 0.24, 85, 0.32)

table.insert(t2, {
    e = v3,
    rate = v4
})

local v5, v6 = makeEmitter(400, 0.34, 95, 0.22)

table.insert(t2, {
    e = v5,
    rate = v6
})
Part.Parent = workspace

local n1 = 0
local n2 = 0
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local _require = require
local ok, result = pcall(_require, MotoLegends:WaitForChild("Config"))
local Track = ok and result.Track or nil
local v7 = RaycastParams.new()

v7.FilterType = Enum.RaycastFilterType.Exclude

local t5 = {
    (Vector3.new(0, 0, 0)),
    (Vector3.new(5, 0, 0)),
    (Vector3.new(-5, 0, 0)),
    (Vector3.new(0, 0, 5)),
    (Vector3.new(0, 0, -5))
}

local function afkSpawn() -- line: 66
    -- upvalues: Track (copy)
    local v8 = Track and workspace:FindFirstChild(Track)
    local Buildings = v8 and v8:FindFirstChild("Buildings")
    local AFKLounge = Buildings and Buildings:FindFirstChild("AFKLounge")

    return AFKLounge and AFKLounge:FindFirstChild("AFKSpawn")
end

local v9 = false
local n3 = 0

local function checkIndoors(p5) -- line: 71
    -- upvalues: Part (copy), Players (copy), LocalPlayer (copy), Track (copy), v7 (copy), t5 (copy)
    if LocalPlayer:GetAttribute("AFKMode") == true then
        local v10 = Track and workspace:FindFirstChild(Track)
        local Buildings = v10 and v10:FindFirstChild("Buildings")
        local AFKLounge = Buildings and Buildings:FindFirstChild("AFKLounge")
        local AFKSpawn = AFKLounge and AFKLounge:FindFirstChild("AFKSpawn")

        if AFKSpawn and (p5 - AFKSpawn.Position).Magnitude < 140 then
            return true
        end
    end

    local t6 = {}

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t6, player.Character)
        end
    end

    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if RaceBikes then
        table.insert(t6, RaceBikes)
    end

    table.insert(t6, Part)
    v7.FilterDescendantsInstances = t6

    local n4 = 0

    for v11, v12 in t5 do
        local v13 = workspace:Raycast(p5 + v12, Vector3.new(0, 150, 0), v7)

        if v13 and v13.Instance.Transparency < 0.95 then
            n4 += 1
        elseif v11 == 1 then
            return false
        end
    end

    return n4 >= 3
end

RunService:BindToRenderStep("RainFollow", Enum.RenderPriority.Camera.Value + 5, function(p6) -- line: 88
    -- upvalues: Part (copy), t2 (copy), n1 (ref), n2 (ref), LocalPlayer (copy), v9 (ref), n3 (ref), checkIndoors (copy)
    n1 += (n2 - n1) * (1 - math.exp(-p6 * 0.8))

    if n1 < 0.005 and n2 == 0 then
        n1 = 0
    end

    local _CFrame = workspace.CurrentCamera.CFrame

    n3 -= p6

    if n3 <= 0 then
        n3 = 0.25

        local v17 = n1 > 0 and checkIndoors(_CFrame.Position) or false

        if v17 ~= v9 then
            v9 = v17
            LocalPlayer:SetAttribute("CameraIndoors", v9)

            if v9 then
                for _, v19 in t2 do
                    v19.e:Clear()
                end
            end
        end
    end

    local v20 = Vector3.new(_CFrame.LookVector.X, 0, _CFrame.LookVector.Z)
    local Unit = v20.Magnitude > 0.05 and v20.Unit or Vector3.new(0, 0, 0)

    Part.CFrame = CFrame.new(_CFrame.Position + Vector3.new(0, 22, 0) + Unit * 18)

    for _, v21 in t2 do
        local e = v21.e

        if v9 then
            e.Rate = 0
        else
            e.Rate = v21.rate * n1
        end
    end
end)

local t7 = {}

local function tween(p7, p8) -- line: 112
    -- upvalues: TweenService (copy), v1 (copy), t7 (ref)
    local tween = TweenService:Create(p7, v1, p8)

    table.insert(t7, tween)
    tween:Play()
end

local function slowRain() -- line: 119
    -- upvalues: MotoLegends (copy)
    return typeof(MotoLegends:GetAttribute("RainAmount")) == "number"
end

local function weatherMode() -- line: 120
    -- upvalues: MotoLegends (copy)
    if typeof(MotoLegends:GetAttribute("RainAmount")) == "number" then
        if (MotoLegends:GetAttribute("RainAmount") or 0) > 0 then
            return "rain"
        end

        local Weather = MotoLegends:GetAttribute("Weather")

        if Weather == "Cloudy" or Weather == "Rainy" then
            return "cloudy"
        end
    else
        if MotoLegends:GetAttribute("Raining") == true then
            return "rain"
        end

        if MotoLegends:GetAttribute("Weather") == "Cloudy" then
            return "cloudy"
        end
    end

    return "dry"
end

local function lookRain() -- line: 132
    -- upvalues: t1 (copy)
    local t9 = {
        clouds = {
            Cover = 0.86,
            Density = 0.7,
            Color = Color3.fromRGB(140, 146, 154)
        },
        lighting = {
            EnvironmentDiffuseScale = 0.7,
            EnvironmentSpecularScale = 0.9,
            Brightness = math.min(t1.lighting.Brightness, 1.55),
            Ambient = Color3.fromRGB(112, 118, 128),
            OutdoorAmbient = Color3.fromRGB(128, 135, 146),
            ExposureCompensation = t1.lighting.ExposureCompensation - 0.08
        },
        grade = {
            Saturation = -0.16,
            Contrast = 0.03,
            TintColor = Color3.fromRGB(236, 242, 250)
        },
        atmos = {},
        sunrays = {},
        bloom = {}
    }

    for v22, v23 in t1.atmos do
        t9.atmos[v22] = {
            Glare = 0,
            Density = math.max(v23.Density, 0.3),
            Haze = math.max(v23.Haze, 1.2),
            Color = Color3.fromRGB(184, 192, 202),
            Decay = Color3.fromRGB(118, 126, 138)
        }
    end

    for v24 in t1.sunrays do
        t9.sunrays[v24] = {
            Intensity = 0
        }
    end

    for v25, v26 in t1.bloom do
        t9.bloom[v25] = {
            Intensity = v26.Intensity * 0.5
        }
    end

    return t9
end

local function lookCloudy() -- line: 142
    -- upvalues: t1 (copy)
    local t12 = {
        clouds = {
            Cover = 0.74,
            Density = 0.42,
            Color = Color3.fromRGB(196, 200, 206)
        },
        lighting = {
            Brightness = math.min(t1.lighting.Brightness, 2.1),
            Ambient = t1.lighting.Ambient:Lerp(Color3.fromRGB(122, 128, 138), 0.5),
            OutdoorAmbient = t1.lighting.OutdoorAmbient:Lerp(Color3.fromRGB(136, 142, 152), 0.5),
            EnvironmentDiffuseScale = t1.lighting.EnvironmentDiffuseScale,
            EnvironmentSpecularScale = t1.lighting.EnvironmentSpecularScale,
            ExposureCompensation = t1.lighting.ExposureCompensation - 0.04
        },
        grade = {
            Saturation = -0.07,
            Contrast = 0.01,
            TintColor = Color3.fromRGB(244, 246, 250)
        },
        atmos = {},
        sunrays = {},
        bloom = {}
    }

    for v27, v28 in t1.atmos do
        t12.atmos[v27] = {
            Density = math.max(v28.Density, 0.24),
            Haze = math.max(v28.Haze, 0.9),
            Glare = v28.Glare * 0.3,
            Color = v28.Color:Lerp(Color3.fromRGB(196, 202, 210), 0.6),
            Decay = v28.Decay:Lerp(Color3.fromRGB(130, 138, 150), 0.5)
        }
    end

    for v29, v30 in t1.sunrays do
        t12.sunrays[v29] = {
            Intensity = v30.Intensity * 0.25
        }
    end

    for v31, v32 in t1.bloom do
        t12.bloom[v31] = {
            Intensity = v32.Intensity * 0.75
        }
    end

    return t12
end

local function mix(p9, p10, p11) -- line: 153
    local t15 = {}

    for v33, v34 in p9 do
        local v35 = p10[v33]

        if typeof(v34) == "number" and typeof(v35) == "number" then
            t15[v33] = v34 + (v35 - v34) * p11
        elseif typeof(v34) == "Color3" and typeof(v35) == "Color3" then
            t15[v33] = v34:Lerp(v35, p11)
        else
            t15[v33] = p11 < 0.5 and v34 or v35
        end
    end

    return t15
end

local v36 = TweenInfo.new(1, Enum.EasingStyle.Linear)
local t16 = {}

local function blendTween(p12, p13) -- line: 165
    -- upvalues: TweenService (copy), v36 (copy), t16 (ref)
    local tween = TweenService:Create(p12, v36, p13)

    table.insert(t16, tween)
    tween:Play()
end

local function apply(p14) -- line: 166
    -- upvalues: Lighting (copy), TweenService (copy), v1 (copy), t1 (copy), Clouds (ref), ColorCorrectionEffect (copy), n2 (ref), t7 (ref), weatherMode (copy), t16 (ref), v2 (copy)
    for _, v37 in t7 do
        v37:Cancel()
    end

    t7 = {}

    for _, v38 in t16 do
        v38:Cancel()
    end

    t16 = {}
    n2 = p14 == "rain" and 1 or 0

    if p14 == "rain" then
        local Clouds2 = Clouds

        Clouds2.Enabled = true

        local tween = TweenService:Create(Clouds2, v1, {
            Cover = 0.86,
            Density = 0.7,
            Color = Color3.fromRGB(140, 146, 154)
        })

        table.insert(t7, tween)
        tween:Play()

        local tween2 = TweenService:Create(Lighting, v1, {
            EnvironmentDiffuseScale = 0.7,
            EnvironmentSpecularScale = 0.9,
            Brightness = math.min(t1.lighting.Brightness, 1.55),
            Ambient = Color3.fromRGB(112, 118, 128),
            OutdoorAmbient = Color3.fromRGB(128, 135, 146),
            ExposureCompensation = t1.lighting.ExposureCompensation - 0.08
        })

        table.insert(t7, tween2)
        tween2:Play()

        for v39, v40 in t1.atmos do
            local tween = TweenService:Create(v39, v1, {
                Glare = 0,
                Density = math.max(v40.Density, 0.3),
                Haze = math.max(v40.Haze, 1.2),
                Color = Color3.fromRGB(184, 192, 202),
                Decay = Color3.fromRGB(118, 126, 138)
            })

            table.insert(t7, tween)
            tween:Play()
        end

        for v41 in t1.sunrays do
            local tween = TweenService:Create(v41, v1, {
                Intensity = 0
            })

            table.insert(t7, tween)
            tween:Play()
        end

        for v42, v43 in t1.bloom do
            local tween = TweenService:Create(v42, v1, {
                Intensity = v43.Intensity * 0.5
            })

            table.insert(t7, tween)
            tween:Play()
        end

        ColorCorrectionEffect.Enabled = true
        ColorCorrectionEffect.Saturation = 0
        ColorCorrectionEffect.Contrast = 0
        ColorCorrectionEffect.TintColor = Color3.new(1, 1, 1)

        local tween3 = TweenService:Create(ColorCorrectionEffect, v1, {
            Saturation = -0.16,
            Contrast = 0.03,
            TintColor = Color3.fromRGB(236, 242, 250)
        })

        table.insert(t7, tween3)
        tween3:Play()
    elseif p14 == "cloudy" then
        local Clouds2 = Clouds

        Clouds2.Enabled = true

        local tween = TweenService:Create(Clouds2, v1, {
            Cover = 0.74,
            Density = 0.42,
            Color = Color3.fromRGB(196, 200, 206)
        })

        table.insert(t7, tween)
        tween:Play()

        local tween2 = TweenService:Create(Lighting, v1, {
            Brightness = math.min(t1.lighting.Brightness, 2.1),
            Ambient = t1.lighting.Ambient:Lerp(Color3.fromRGB(122, 128, 138), 0.5),
            OutdoorAmbient = t1.lighting.OutdoorAmbient:Lerp(Color3.fromRGB(136, 142, 152), 0.5),
            EnvironmentDiffuseScale = t1.lighting.EnvironmentDiffuseScale,
            EnvironmentSpecularScale = t1.lighting.EnvironmentSpecularScale,
            ExposureCompensation = t1.lighting.ExposureCompensation - 0.04
        })

        table.insert(t7, tween2)
        tween2:Play()

        for v44, v45 in t1.atmos do
            local tween = TweenService:Create(v44, v1, {
                Density = math.max(v45.Density, 0.24),
                Haze = math.max(v45.Haze, 0.9),
                Glare = v45.Glare * 0.3,
                Color = v45.Color:Lerp(Color3.fromRGB(196, 202, 210), 0.6),
                Decay = v45.Decay:Lerp(Color3.fromRGB(130, 138, 150), 0.5)
            })

            table.insert(t7, tween)
            tween:Play()
        end

        for v46, v47 in t1.sunrays do
            local tween = TweenService:Create(v46, v1, {
                Intensity = v47.Intensity * 0.25
            })

            table.insert(t7, tween)
            tween:Play()
        end

        for v48, v49 in t1.bloom do
            local tween = TweenService:Create(v48, v1, {
                Intensity = v49.Intensity * 0.75
            })

            table.insert(t7, tween)
            tween:Play()
        end

        ColorCorrectionEffect.Enabled = true

        local tween3 = TweenService:Create(ColorCorrectionEffect, v1, {
            Saturation = -0.07,
            Contrast = 0.01,
            TintColor = Color3.fromRGB(244, 246, 250)
        })

        table.insert(t7, tween3)
        tween3:Play()
    else
        local Clouds2 = Clouds
        local tween = TweenService:Create(Clouds2, v1, {
            Cover = t1.clouds.Cover,
            Density = t1.clouds.Density,
            Color = t1.clouds.Color
        })

        table.insert(t7, tween)
        tween:Play()

        local tween2 = TweenService:Create(Lighting, v1, t1.lighting)

        table.insert(t7, tween2)
        tween2:Play()

        for v50, v51 in t1.atmos do
            local tween = TweenService:Create(v50, v1, v51)

            table.insert(t7, tween)
            tween:Play()
        end

        for v52, v53 in t1.sunrays do
            local tween = TweenService:Create(v52, v1, v53)

            table.insert(t7, tween)
            tween:Play()
        end

        for v54, v55 in t1.bloom do
            local tween = TweenService:Create(v54, v1, v55)

            table.insert(t7, tween)
            tween:Play()
        end

        local tween3 = TweenService:Create(ColorCorrectionEffect, v1, {
            Saturation = 0,
            Contrast = 0,
            TintColor = Color3.new(1, 1, 1)
        })

        table.insert(t7, tween3)
        tween3:Play()
        task.delay(v1.Time + 0.1, function() -- line: 199
            -- upvalues: Clouds (ref), ColorCorrectionEffect (copy), weatherMode (copy), v2 (copy)
            if weatherMode() == "dry" then
                ColorCorrectionEffect.Enabled = false

                if v2 then
                    Clouds.Enabled = false
                end
            end
        end)
    end
end

local v56 = false

local function applyBlend(p15) -- line: 208
    -- upvalues: Lighting (copy), TweenService (copy), Clouds (ref), ColorCorrectionEffect (copy), n2 (ref), t7 (ref), lookRain (copy), lookCloudy (copy), mix (copy), v36 (copy), t16 (ref)
    for _, v57 in t7 do
        v57:Cancel()
    end

    t7 = {}

    for _, v58 in t16 do
        v58:Cancel()
    end

    t16 = {}
    n2 = p15

    local v59 = lookCloudy()
    local v60 = lookRain()
    local Clouds2 = Clouds

    Clouds2.Enabled = true
    ColorCorrectionEffect.Enabled = true

    local tween = TweenService:Create(Clouds2, v36, (mix(v59.clouds, v60.clouds, p15)))

    table.insert(t16, tween)
    tween:Play()

    local tween2 = TweenService:Create(Lighting, v36, (mix(v59.lighting, v60.lighting, p15)))

    table.insert(t16, tween2)
    tween2:Play()

    local tween3 = TweenService:Create(ColorCorrectionEffect, v36, (mix(v59.grade, v60.grade, p15)))

    table.insert(t16, tween3)
    tween3:Play()

    for v64, v65 in v59.atmos do
        local tween = TweenService:Create(v64, v36, (mix(v65, v60.atmos[v64], p15)))

        table.insert(t16, tween)
        tween:Play()
    end

    for v67, v68 in v59.sunrays do
        local tween = TweenService:Create(v67, v36, (mix(v68, v60.sunrays[v67], p15)))

        table.insert(t16, tween)
        tween:Play()
    end

    for v70, v71 in v59.bloom do
        local tween = TweenService:Create(v70, v36, (mix(v71, v60.bloom[v70], p15)))

        table.insert(t16, tween)
        tween:Play()
    end
end

local v73
local n5 = 0
local v74

v74 = function() -- line: 224
    -- upvalues: v74 (ref), MotoLegends (copy), v1 (copy), n2 (ref), weatherMode (copy), apply (copy), v56 (ref), applyBlend (copy), v73 (ref), n5 (ref)
    if typeof(MotoLegends:GetAttribute("RainAmount")) == "number" then
        local v75 = MotoLegends:GetAttribute("RainAmount") or 0

        if v75 > 0 then
            n2 = v75

            if not (os.clock() < n5) then
                if v56 or v73 ~= "dry" then
                    v56 = true
                    v73 = "rain"
                    applyBlend(v75)
                else
                    apply("cloudy")
                    n2 = v75
                    v73 = "cloudy"
                    n5 = os.clock() + v1.Time
                    task.delay(v1.Time + 0.05, v74)
                end
            end

            return
        end

        v56 = false
    end

    local v76 = weatherMode()

    if v76 ~= v73 then
        v73 = v76
        apply(v76)
    end
end

MotoLegends:GetAttributeChangedSignal("Raining"):Connect(v74)
MotoLegends:GetAttributeChangedSignal("Weather"):Connect(v74)
MotoLegends:GetAttributeChangedSignal("RainAmount"):Connect(v74)

if weatherMode() == "dry" then
    v73 = "dry"
else
    v74()
end

local SoundService = game:GetService("SoundService")
local Sound = Instance.new("Sound")

Sound.Name = "RainLoop"
Sound.SoundId = "rbxassetid://6657181480"
Sound.Looped = true
Sound.Volume = 0
Sound.Parent = SoundService

local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")

EqualizerSoundEffect.Name = "IndoorMuffle"
EqualizerSoundEffect.Priority = 0
EqualizerSoundEffect.Parent = Sound

local function applyMuffle() -- line: 254
    -- upvalues: TweenService (copy), LocalPlayer (copy), EqualizerSoundEffect (copy)
    local v77 = LocalPlayer:GetAttribute("CameraIndoors") == true

    TweenService:Create(EqualizerSoundEffect, TweenInfo.new(0.6), {
        HighGain = v77 and -40 or 0,
        MidGain = v77 and -14 or 0,
        LowGain = v77 and -4 or 0
    }):Play()
end

LocalPlayer:GetAttributeChangedSignal("CameraIndoors"):Connect(applyMuffle)
applyMuffle()

local v79

local function rainAudio(p16) -- line: 261
    -- upvalues: TweenService (copy), Sound (copy), v79 (ref)
    if v79 then
        v79:Cancel()
    end

    if p16 then
        if not Sound.IsPlaying then
            Sound:Play()
        end

        v79 = TweenService:Create(Sound, TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Volume = 0.6
        })
    else
        v79 = TweenService:Create(Sound, TweenInfo.new(7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Volume = 0
        })
        v79.Completed:Connect(function(p17) -- line: 269
            -- upvalues: Sound (copy)
            if p17 == Enum.PlaybackState.Completed and Sound.Volume < 0.01 then
                Sound:Stop()
            end
        end)
    end

    v79:Play()
end

MotoLegends:GetAttributeChangedSignal("Raining"):Connect(function() -- line: 273
    -- upvalues: MotoLegends (copy), rainAudio (copy)
    if typeof(MotoLegends:GetAttribute("RainAmount")) ~= "number" then
        rainAudio(MotoLegends:GetAttribute("Raining") == true)
    end
end)

if typeof(MotoLegends:GetAttribute("RainAmount")) ~= "number" and MotoLegends:GetAttribute("Raining") == true then
    if v79 then
        v79:Cancel()
    end

    if not Sound.IsPlaying then
        Sound:Play()
    end

    v79 = TweenService:Create(Sound, TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        Volume = 0.6
    })
    v79:Play()
end

local function slowAudio() -- line: 276
    -- upvalues: TweenService (copy), MotoLegends (copy), Sound (copy), v79 (ref)
    if typeof(MotoLegends:GetAttribute("RainAmount")) ~= "number" then
        return
    end

    local v81 = MotoLegends:GetAttribute("RainAmount") or 0

    if v79 then
        v79:Cancel()
    end

    if v81 > 0 and not Sound.IsPlaying then
        Sound:Play()
    end

    v79 = TweenService:Create(Sound, TweenInfo.new(1, Enum.EasingStyle.Linear), {
        Volume = 0.6 * v81
    })

    if v81 <= 0 then
        v79.Completed:Connect(function(p18) -- line: 282
            -- upvalues: Sound (copy)
            if p18 == Enum.PlaybackState.Completed and Sound.Volume < 0.01 then
                Sound:Stop()
            end
        end)
    end

    v79:Play()
end

MotoLegends:GetAttributeChangedSignal("RainAmount"):Connect(slowAudio)
slowAudio()

local function sprayEmitter(p19, p20) -- line: 291
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "WetSpray"
    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(205, 214, 224))
    ParticleEmitter.LightEmission = 0.15
    ParticleEmitter.LightInfluence = 0.9
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, p20 and 1.1 or 0.6),
        NumberSequenceKeypoint.new(0.4, p20 and 3.2 or 1.7),
        NumberSequenceKeypoint.new(1, p20 and 6 or 3.2)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.45),
        NumberSequenceKeypoint.new(0.35, 0.62),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 1)
    ParticleEmitter.Speed = NumberRange.new(5, 12)
    ParticleEmitter.SpreadAngle = Vector2.new(22, 35)
    ParticleEmitter.Acceleration = Vector3.new(0, -14, 0)
    ParticleEmitter.Drag = 2
    ParticleEmitter.Rate = 0
    ParticleEmitter.EmissionDirection = Enum.NormalId.Back
    ParticleEmitter.LockedToPart = false
    ParticleEmitter.Parent = p19

    return ParticleEmitter
end

local t57 = {}
local v82 = RaycastParams.new()

v82.FilterType = Enum.RaycastFilterType.Exclude

local function setupBike(p21) -- line: 305
    -- upvalues: sprayEmitter (copy), t57 (copy)
    if t57[p21] then
        return
    end

    local RearTyreContact = p21:FindFirstChild("RearTyreContact")
    local FrontTyreContact = p21:FindFirstChild("FrontTyreContact")
    local Chassis = p21:FindFirstChild("Chassis")

    if not (RearTyreContact and FrontTyreContact and Chassis) then
        return
    end

    local function att(p22, p23) -- line: 310
        local Attachment = Instance.new("Attachment")

        Attachment.Name = p23
        Attachment.Position = Vector3.new(0, -(p22.Size.Y / 2) + 0.08, 0)
        Attachment.Parent = p22

        return Attachment
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "WetSprayRear"
    Attachment.Position = Vector3.new(0, -(RearTyreContact.Size.Y / 2) + 0.08, 0)
    Attachment.Parent = RearTyreContact

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Name = "WetSprayFront"
    Attachment2.Position = Vector3.new(0, -(FrontTyreContact.Size.Y / 2) + 0.08, 0)
    Attachment2.Parent = FrontTyreContact
    t57[p21] = {
        root = Chassis,
        rearPart = RearTyreContact,
        frontPart = FrontTyreContact,
        rear = sprayEmitter(Attachment, true),
        mist = sprayEmitter(Attachment, false),
        front = sprayEmitter(Attachment2, false),
        last = Chassis.Position
    }
end

local function isLoose(p24) -- line: 317
    local Instance = p24.Instance
    local Surface = Instance and Instance:GetAttribute("Surface")

    if Surface == "Grass" or Surface == "Gravel" or Surface == "Sand" then
        return true
    end

    local Material = p24.Material

    if Material == Enum.Material.Grass or Material == Enum.Material.Sand or Material == Enum.Material.LeafyGrass or Material == Enum.Material.Ground then
        return true
    end

    return Material == Enum.Material.Mud
end

local function touching(p25) -- line: 324
    -- upvalues: v82 (copy), isLoose (copy)
    local v86 = p25.Size.Y / 2
    local v88 = workspace:Raycast(p25.Position, Vector3.new(0, -(v86 + 0.6), 0), v82)

    if v88 ~= nil and p25.Position.Y - v88.Position.Y <= v86 + 0.3 then
        return not isLoose(v88)
    end

    return false
end

local function sizeSeq(p26, p27) -- line: 330
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, (if p26 then 1.1 else 0.6) * p27),
        NumberSequenceKeypoint.new(0.4, (if p26 then 3.2 else 1.7) * p27),
        NumberSequenceKeypoint.new(1, (if p26 then 6 else 3.2) * p27)
    })
end

local v89 = workspace:WaitForChild("RaceBikes", 30)

RunService.Heartbeat:Connect(function(p28) -- line: 334
    -- upvalues: MotoLegends (copy), n1 (ref), t57 (copy), v82 (copy), setupBike (copy), touching (copy), sizeSeq (copy), v89 (copy)
    if not v89 then
        return
    end

    local t58 = {
        v89
    }

    for _, player in game:GetService("Players"):GetPlayers() do
        if player.Character then
            table.insert(t58, player.Character)
        end
    end

    v82.FilterDescendantsInstances = t58

    for _, child in v89:GetChildren() do
        if not t57[child] then
            setupBike(child)
        end
    end

    for v90, v91 in t57 do
        if v90.Parent and v91.root.Parent then
            local rootPosition = v91.root.Position
            local v92 = (rootPosition - v91.last) / math.max(p28, 0.004166666666666667)

            v91.last = rootPosition

            local v93 = Vector3.new(v92.X, 0, v92.Z).Magnitude * 1.0080000000000002
            local v94 = n1
            local TrackWetness = MotoLegends:GetAttribute("TrackWetness")

            if typeof(TrackWetness) ~= "number" then
                TrackWetness = v94
            end

            local v96 = math.clamp((v93 - 15) / 200, 0, 1) * TrackWetness
            local v97 = v96 > 0 and touching(v91.rearPart) and v96 or 0
            local v98 = v96 > 0 and touching(v91.frontPart) and v96 or 0

            v91.rear.Rate = v97 * 260
            v91.mist.Rate = v97 * 140
            v91.front.Rate = v98 * 90

            local v101 = math.floor(math.clamp((v93 - 15) / 205, 0, 1) * 10 + 0.5) / 10

            if v91.step ~= v101 then
                v91.step = v101

                local v102 = v101 * 0.85 + 0.15

                v91.rear.Size = sizeSeq(true, v102)
                v91.mist.Size = sizeSeq(false, v102)
                v91.front.Size = sizeSeq(false, v102)
            end

            local v103 = v96 * 30 + 6

            v91.rear.Speed = NumberRange.new(v103 * 0.6, v103)
            v91.mist.Speed = NumberRange.new(v103 * 0.4, v103 * 0.8)
            v91.front.Speed = NumberRange.new(v103 * 0.3, v103 * 0.6)
            continue
        end

        t57[v90] = nil
    end
end)
