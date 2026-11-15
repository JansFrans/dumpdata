-- https://lua.expert

local Players = game:GetService("Players")
local Config = require(script.Parent:WaitForChild("Config"))
local CarPhysics = require(script.Parent:WaitForChild("CarPhysics"))
local CarDash = require(script.Parent:WaitForChild("CarDash"))
local t1 = {}
local t2 = {
    {
        rpm = 791,
        id = 102307062616811,
        gain = 2.2
    },
    {
        rpm = 1625,
        id = 108489707631881
    },
    {
        rpm = 2925,
        id = 72959524466421
    },
    {
        rpm = 4138,
        id = 73193626895868
    },
    {
        rpm = 5664,
        id = 108373362814072
    },
    {
        rpm = 6547,
        id = 106303435620409
    },
    {
        rpm = 7294,
        id = 83333136067553
    }
}
local StudMetres = Config.StudMetres
local t3 = {
    "FL",
    "FR",
    "RL",
    "RR"
}
local v1 = Color3.fromRGB(255, 150, 20)
local v2 = Color3.fromRGB(255, 200, 70)
local t4 = {}
local t5 = {
    FL = 1,
    FR = 2,
    RL = 4,
    RR = 8
}
local t6 = {
    FL = 16,
    FR = 32,
    RL = 64,
    RR = 128
}
local n1 = 50

local function v3() -- line: 37
    -- upvalues: n1 (ref)
    local MotoLegends = game:GetService("ReplicatedStorage"):FindFirstChild("MotoLegends")
    local v4 = MotoLegends and require(MotoLegends:FindFirstChild("Config")).SkidMarkSeconds

    if typeof(v4) == "number" then
        n1 = v4
    end
end

pcall(v3)

local function hasBit(p1, p2) -- line: 43
    return p2 <= p1 % (p2 * 2)
end

local function effectsOn() -- line: 46
    -- upvalues: Players (copy)
    return Players.LocalPlayer:GetAttribute("GfxEffects") ~= false
end

local t7 = {}

local function marksFolder() -- line: 52
    local RaceTyreMarks = workspace:FindFirstChild("RaceTyreMarks")

    if RaceTyreMarks then
        return RaceTyreMarks
    end

    local SafetyCarTyreMarks = workspace:FindFirstChild("SafetyCarTyreMarks")

    if not SafetyCarTyreMarks then
        SafetyCarTyreMarks = Instance.new("Folder")
        SafetyCarTyreMarks.Name = "SafetyCarTyreMarks"
        SafetyCarTyreMarks.Parent = workspace
    end

    return SafetyCarTyreMarks
end

local function layMark(p3, p4, p5, p6) -- line: 64
    -- upvalues: t7 (copy)
    local v5 = p4 - p3
    local Magnitude = v5.Magnitude

    if Magnitude < 0.12 or Magnitude > 40 then
        return
    end

    local v6 = v5 / Magnitude
    local v7 = v6:Cross(p5)

    if v7.Magnitude < 0.001 then
        return
    end

    local Part = Instance.new("Part")

    Part.Name = "SafetyCarTyreMark"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.Material = Enum.Material.SmoothPlastic
    Part.Color = Color3.fromRGB(15, 16, 17)
    Part.Transparency = 0.3
    Part.Size = Vector3.new(p6, 0.02, Magnitude + 0.08)
    Part.CFrame = CFrame.fromMatrix((p3 + p4) / 2, v7.Unit, p5, -v6)

    local RaceTyreMarks = workspace:FindFirstChild("RaceTyreMarks")

    if not RaceTyreMarks then
        RaceTyreMarks = workspace:FindFirstChild("SafetyCarTyreMarks")

        if not RaceTyreMarks then
            RaceTyreMarks = Instance.new("Folder")
            RaceTyreMarks.Name = "SafetyCarTyreMarks"
            RaceTyreMarks.Parent = workspace
        end
    end

    Part.Parent = RaceTyreMarks
    table.insert(t7, {
        part = Part,
        born = os.clock()
    })

    if #t7 > 900 then
        table.remove(t7, 1).part:Destroy()
    end
end

function t1.Tick() -- line: 85
    -- upvalues: n1 (ref), t7 (copy)
    local elapsed = os.clock()

    while t7[1] and elapsed - t7[1].born >= n1 do
        table.remove(t7, 1).part:Destroy()
    end

    for i = 1, #t7 do
        local v9 = t7[i]
        local v10 = elapsed - v9.born

        if v10 < n1 - 8 then
            break
        end

        local v13 = math.min(math.floor((v10 - (n1 - 8)) / 2) + 1, 4)

        if v9.step ~= v13 then
            v9.step = v13
            v9.part.Transparency = v13 * 0.7 / 4 + 0.3
        end
    end
end

local function makeGravelFx(p7) -- line: 103
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "GravelDust"
    ParticleEmitter.Enabled = false
    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(226, 208, 172), Color3.fromRGB(176, 156, 122))
    ParticleEmitter.Lifetime = NumberRange.new(1.1, 2.2)
    ParticleEmitter.Speed = NumberRange.new(4, 12)
    ParticleEmitter.Drag = 1.2
    ParticleEmitter.VelocityInheritance = 0.35
    ParticleEmitter.SpreadAngle = Vector2.new(60, 60)
    ParticleEmitter.Acceleration = Vector3.new(0, -2.5, 0)
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-35, 35)
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.25, 0.38),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.LightInfluence = 0.25
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = p7

    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Name = "GravelStones"
    ParticleEmitter2.Enabled = false
    ParticleEmitter2.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter2.EmissionDirection = Enum.NormalId.Back
    ParticleEmitter2.Color = ColorSequence.new(Color3.fromRGB(96, 83, 64), Color3.fromRGB(60, 52, 42))
    ParticleEmitter2.Lifetime = NumberRange.new(0.35, 0.75)
    ParticleEmitter2.Speed = NumberRange.new(10, 22)
    ParticleEmitter2.SpreadAngle = Vector2.new(28, 38)
    ParticleEmitter2.Acceleration = Vector3.new(0, -75, 0)
    ParticleEmitter2.Drag = 0.6
    ParticleEmitter2.VelocityInheritance = 0.5
    ParticleEmitter2.Size = NumberSequence.new(0.28)
    ParticleEmitter2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter2.LightInfluence = 0.4
    ParticleEmitter2.Rate = 0
    ParticleEmitter2.Parent = p7

    return ParticleEmitter, ParticleEmitter2
end

local function setGravel(p8, p9, p10) -- line: 143
    if p8.dust then
        if p9 then
            local v15 = math.clamp(p10 / 150, 0, 1)
            local v17 = math.floor(v15 * 10 + 0.5) / 10

            if p8.dustStep ~= v17 then
                p8.dustStep = v17

                local v18 = v17 * 0.75 + 0.55

                p8.dust.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, v18 * 0.6),
                    NumberSequenceKeypoint.new(0.35, v18 * 3.2),
                    NumberSequenceKeypoint.new(1, v18 * 6)
                })
                p8.dust.Speed = NumberRange.new(v17 * 8 + 3, v17 * 14 + 6)
            end

            p8.dust.Rate = (p8.front and 0.6 or 1) * (v15 * 120 + 20)
            p8.stones.Rate = v15 * 70 + 20

            if not p8.dust.Enabled then
                p8.dust.Enabled = true
                p8.stones.Enabled = true
            end
        elseif p8.dust.Enabled then
            p8.dust.Enabled = false
            p8.stones.Enabled = false
        end
    end
end

local function sprayEmitter(p11, p12) -- line: 166
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "WetSpray"
    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(205, 214, 224))
    ParticleEmitter.LightEmission = 0.3
    ParticleEmitter.LightInfluence = 0.6
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.35, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 1)
    ParticleEmitter.Speed = NumberRange.new(5, 12)
    ParticleEmitter.SpreadAngle = Vector2.new(22, 35)
    ParticleEmitter.Acceleration = Vector3.new(0, -14, 0)
    ParticleEmitter.Drag = 2
    ParticleEmitter.VelocityInheritance = 0.45
    ParticleEmitter.Rate = 0
    ParticleEmitter.EmissionDirection = Enum.NormalId.Back
    ParticleEmitter.LockedToPart = false

    if not p12 then
        ParticleEmitter.Lifetime = NumberRange.new(0.9, 1.7)
        ParticleEmitter.Acceleration = Vector3.new(0, -3, 0)
    end

    ParticleEmitter.Parent = p11

    return ParticleEmitter
end

local function spraySize(p13, p14) -- line: 191
    local v19 = p14 * 1.6

    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, (if p13 then 1.1 else 0.6) * v19),
        NumberSequenceKeypoint.new(0.4, (if p13 then 3.2 else 1.7) * v19),
        NumberSequenceKeypoint.new(1, (if p13 then 6 else 3.2) * v19)
    })
end

local function isLoose(p15) -- line: 196
    -- upvalues: Config (copy)
    local v20 = p15.Instance and p15.Instance:GetAttribute("Surface")

    if v20 == "Grass" or v20 == "Gravel" or v20 == "Sand" then
        return true
    end

    if typeof(v20) == "string" then
        return false
    end

    return Config.MaterialSurface[p15.Material.Name] ~= nil
end

local function setSpray(p16, p17, p18) -- line: 202
    -- upvalues: spraySize (copy)
    if p16.spray then
        if p17 <= 0 then
            if p16.sprayOn then
                p16.sprayOn = false
                p16.spray.Rate = 0
                p16.mist.Rate = 0
            end
        else
            p16.sprayOn = true

            local v23 = math.floor(math.clamp((p18 - 15) / 205, 0, 1) * 10 + 0.5) / 10

            if p16.sprayStep ~= v23 then
                p16.sprayStep = v23

                local v24 = v23 * 0.85 + 0.15

                p16.spray.Size = spraySize(true, v24)
                p16.mist.Size = spraySize(false, v24)
            end

            p16.spray.Rate = p17 * (p16.front and 140 or 300)
            p16.mist.Rate = p17 * (p16.front and 90 or 170)

            local v25 = 6 + p17 * 30

            p16.spray.Speed = NumberRange.new(v25 * 0.6, v25)
            p16.mist.Speed = NumberRange.new(v25 * 0.4, v25 * 0.8)
        end
    end
end

local function smooth(p19, p20, p21, p22) -- line: 224
    return p19 + (p20 - p19) * math.min(1, p22 * p21)
end

function t1.Track(p23) -- line: 228
    -- upvalues: Config (copy), CarDash (copy), t2 (copy), t3 (copy), t4 (copy), makeGravelFx (copy), sprayEmitter (copy)
    if t4[p23] then
        return t4[p23]
    end

    local v28 = p23.PrimaryPart or p23:WaitForChild("Chassis", 5)

    if not v28 then
        return nil
    end

    local t9 = {
        throttle = 0,
        steer = 0,
        slip = 0,
        car = p23,
        chassis = v28,
        wheels = {},
        lamps = {},
        rpm = Config.IdleRPM
    }

    for _, v29 in t3 do
        local v30 = v28:WaitForChild("WheelJoint_" .. v29, 5)

        if v30 and v30.Part1 then
            local t10 = {
                joint = v30,
                rest = v30.C0.Position,
                radius = v30.Part1.Size.Y / 2,
                front = v29:sub(1, 1) == "F",
                comp = Config.DroopTravel,
                spin = math.random() * 3.141592653589793 * 2
            }
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "SafetyCarGravel_" .. v29
            Attachment.Position = t10.rest + Vector3.new(0, -t10.radius + 0.25, t10.radius * 0.7)
            Attachment.Parent = v28

            local v33, v34 = makeGravelFx(Attachment)

            t10.dust = v33
            t10.stones = v34

            local Attachment2 = Instance.new("Attachment")

            Attachment2.Name = "SafetyCarSpray_" .. v29
            Attachment2.Position = t10.rest + Vector3.new(0, -t10.radius + 0.1, t10.radius * 0.6)
            Attachment2.Orientation = Vector3.new(-25, 0, 0)
            Attachment2.Parent = v28

            local v37 = sprayEmitter(Attachment2, true)
            local v38 = sprayEmitter(Attachment2, false)

            t10.spray = v37
            t10.mist = v38
            t9.wheels[v29] = t10
        end
    end

    local LightBar = p23:FindFirstChild("LightBar")

    if LightBar then
        for _, child in LightBar:GetChildren() do
            if child:IsA("BasePart") then
                table.insert(t9.lamps, {
                    part = child,
                    left = child:GetAttribute("Side") == "L",
                    glow = child:FindFirstChild("Glow")
                })
            end
        end
    end

    local Engine = v28:FindFirstChild("Engine")

    t9.engine = Engine and Engine:FindFirstChild("Engine")

    if t9.engine then
        t9.engine:Stop()
    end

    if Engine then
        local SoundGroup = Instance.new("SoundGroup")

        SoundGroup.Name = "SafetyCarEngine"
        SoundGroup.Volume = 1
        SoundGroup.Parent = game:GetService("SoundService")
        t9.engineEq = Instance.new("EqualizerSoundEffect")

        local engineEq, engineEq2, engineEq3 = t9.engineEq, t9.engineEq, t9.engineEq

        engineEq.LowGain = 2
        engineEq2.MidGain = 0
        engineEq3.HighGain = 0
        t9.engineEq.Parent = SoundGroup
        t9.engineGroup = SoundGroup
        t9.layers = {}

        for v39, v40 in t2 do
            local Sound = Instance.new("Sound")

            Sound.Name = "EngineLayer" .. v39
            Sound.SoundId = "rbxassetid://" .. v40.id
            Sound.Looped = true
            Sound.Volume = 0
            Sound.RollOffMinDistance = 15
            Sound.RollOffMaxDistance = 450
            Sound.SoundGroup = SoundGroup
            Sound.Parent = Engine
            t9.layers[v39] = {
                sound = Sound,
                rpm = v40.rpm,
                gain = v40.gain or 1
            }
        end

        Engine = Engine:FindFirstChild("Horn")
    end

    t9.horn = Engine
    t9.skid = v28:FindFirstChild("Skid")

    local Sound = Instance.new("Sound")

    Sound.Name = "GravelRoll"
    Sound.SoundId = "rbxassetid://9114658419"
    Sound.Looped = true
    Sound.Volume = 0
    Sound.RollOffMinDistance = 12
    Sound.RollOffMaxDistance = 260
    Sound.Parent = v28
    t9.gravelSound = Sound
    t9.steerJoint = v28:FindFirstChild("SteeringWheelJoint")

    local Build = CarDash.Build
    local ok, result = pcall(Build, p23)

    t9.dash = if not ok or not result then nil else result
    t9.brakeGlow = p23:FindFirstChild("BrakeGlow")
    t9.headGlow = p23:FindFirstChild("HeadGlow")

    local Headlights = v28:FindFirstChild("Headlights")

    t9.beam = Headlights and Headlights:FindFirstChild("Beam")

    local TailLight = v28:FindFirstChild("TailLight")

    t9.brakeLight = TailLight and TailLight:FindFirstChild("Brake")
    t9.params = RaycastParams.new()
    t9.params.FilterType = Enum.RaycastFilterType.Exclude
    t9.params.FilterDescendantsInstances = { p23 }
    t9.params.RespectCanCollide = true

    local function v41() -- line: 311
        -- upvalues: t9 (copy)
        t9.params.CollisionGroup = "SafetyCar"
    end

    pcall(v41)
    t4[p23] = t9

    return t9
end

function t1.Untrack(p24) -- line: 316
    -- upvalues: t4 (copy)
    local v42 = t4[p24]

    if not v42 then
        return
    end

    t4[p24] = nil

    for _, v43 in {
            v42.engine,
            v42.skid,
            v42.horn,
            v42.gravelSound
        } do
        if v43 then
            local function v44() -- line: 321
                -- upvalues: v43 (copy)
                v43:Stop()
            end

            pcall(v44)
        end
    end

    for _, v45 in v42.layers or {} do
        local function v46() -- line: 323
            -- upvalues: v45 (copy)
            v45.sound:Stop()
        end

        pcall(v46)
    end

    if v42.engineGroup then
        v42.engineGroup:Destroy()
    end

    for _, v47 in v42.wheels do
        if v47.dust then
            v47.dust.Enabled = false
            v47.stones.Enabled = false
        end
    end
end

function t1.Records() -- line: 330
    -- upvalues: t4 (copy)
    return t4
end

local function lampOn(p25, p26) -- line: 333
    local v48 = p25 % 0.9

    if not p26 then
        v48 = (v48 + 0.45) % 0.9
    end

    if v48 < 0.08 then
        return true
    end

    if v48 > 0.14 then
        return v48 < 0.22
    end

    return false
end

function t1.UpdateCar(p27, p28, p29, p30) -- line: 340
    -- upvalues: Players (copy), Config (copy), CarPhysics (copy), CarDash (copy), StudMetres (copy), v1 (copy), v2 (copy), t5 (copy), t6 (copy), layMark (copy), setGravel (copy), setSpray (copy)
    local car, chassis = p27.car, p27.chassis

    if chassis.Parent then
        local _CFrame = chassis.CFrame
        local UpVector = _CFrame.UpVector
        local AssemblyLinearVelocity = chassis.AssemblyLinearVelocity
        local v49 = AssemblyLinearVelocity:Dot(_CFrame.LookVector)
        local v50 = p30 == nil or (_CFrame.Position - p30).Magnitude < 650
        local v51 = p29 ~= nil or (car:GetAttribute("Driver") or 0) ~= 0
        local v52, v53, v54, v55, v56, comp, v57, v58, v59

        if v50 then
            v58 = car:GetAttribute("Steer") or 0

            local steer = p27.steer

            v52 = v58 - steer

            local v60 = p28 * 14

            p27.steer = steer + v52 * math.min(1, v60)
            v58 = Config.BumpTravel + Config.DroopTravel

            for v61, v62 in p27.wheels do
                v53 = p29 and p29.wheels[v61]

                if v53 then
                    local v63 = v53.contact and v53.comp or 0

                    v60 = v53.steer or 0
                    v54 = if v53.contact then v53.spinRate or 0 else (v62.lastRate or 0) * 0.995
                    v62.lastRate = v54
                    v56 = v62.comp

                    local v64 = v63 - v56

                    v55 = p28 * 40
                    v62.comp = v56 + v64 * math.min(1, v55)
                    v63 = v53.contact

                    if v63 then
                        v63 = v53.surface == "Asphalt" or v53.surface == "Kerb"
                    end

                    v62.onTarmac = v63
                else
                    comp = v62.rest
                    v57 = Config.BumpTravel / StudMetres
                    v54 = _CFrame:PointToWorldSpace(comp + Vector3.new(0, v57, 0))
                    v56 = workspace:Raycast(v54, -UpVector * (v58 / StudMetres + v62.radius), p27.params)

                    if v56 then
                        comp = v58 - (v56.Distance - v62.radius) * StudMetres
                        v59 = math.clamp(comp, 0, v58) or 0
                    else
                        v59 = 0
                    end

                    v60 = v62.front and p27.steer or 0
                    v54 = v49 / v62.radius
                    comp = v62.comp
                    v57 = v59 - comp
                    v62.comp = comp + v57 * math.min(1, p28 * 22)

                    if v56 ~= nil then
                        if v56.Distance - v62.radius < v58 / StudMetres then
                            local v66 = v56.Instance and v56.Instance:GetAttribute("Surface")

                            comp = v66 == "Grass" or v66 == "Gravel" or v66 == "Sand" or typeof(v66) ~= "string" and Config.MaterialSurface[v56.Material.Name] ~= nil
                            v62.onTarmac = not comp
                        else
                            v62.onTarmac = false
                        end
                    else
                        v62.onTarmac = false
                    end
                end

                v62.spin = (v62.spin - v54 * p28) % 6.283185307179586
                v53 = (v62.comp - Config.DroopTravel) / StudMetres
                v62.joint.Transform = CFrame.new(0, v53, 0) * CFrame.Angles(0, v62.front and -v60 or 0, 0) * CFrame.Angles(v62.spin, 0, 0)
            end

            if p27.steerJoint then
                p27.steerJoint.Transform = CFrame.Angles(0, 0, -(p29 and p29.steer or p27.steer) * 13)
            end
        end

        local v67 = p29 and CarPhysics.WheelMask(p29) or car:GetAttribute("Wheels") or 0

        v58 = AssemblyLinearVelocity.Magnitude * StudMetres * 3.6

        local steerJoint = v50 and Players.LocalPlayer:GetAttribute("GfxEffects") ~= false
        local v68 = CarPhysics.TrackWetness()
        local v69, v70, v71

        if steerJoint and v68 > 0 then
            v69 = (v58 - 15) / 200
            v52 = math.clamp(v69, 0, 1) * v68

            if v52 then
                v70 = v52
                v71 = true
            else
                v71 = false
            end
        else
            v71 = false
        end

        if not v71 then
            v70 = 0
        end

        local Angles = 0

        for v72, v73 in p27.wheels do
            if steerJoint then
                v56 = t6[v72]
                v54 = v56 <= v67 % (v56 * 2) and v58 > 3
            else
                v54 = steerJoint
            end

            if v54 then
                Angles += 1
            end

            setGravel(v73, v54, v58)
            setSpray(v73, v70 > 0 and v50 and v73.onTarmac and v70 or 0, v58)
        end

        p27.markClock = (p27.markClock or 0) + p28

        if p27.markClock >= 0.065 then
            p27.markClock = 0

            for v74, v75 in p27.wheels do
                if steerJoint then
                    v56 = t5[v74]

                    if v56 <= v67 % (v56 * 2) and v68 < 0.5 then
                        comp = v75.rest
                        v57 = (v75.comp - Config.DroopTravel) / StudMetres
                        v54 = _CFrame:PointToWorldSpace(comp + Vector3.new(0, v57, 0))
                        v54 = workspace:Raycast(v54, -UpVector * (v75.radius + 1.5), p27.params)

                        if v54 then
                            v70 = v54.Position + v54.Normal * 0.035

                            if v75.lastMark then
                                layMark(v75.lastMark, v70, v54.Normal, v75.front and 0.9 or 1.05)
                            end

                            v75.lastMark = v70
                        else
                            v75.lastMark = nil
                        end
                    else
                        v75.lastMark = nil
                    end
                else
                    v75.lastMark = nil
                end
            end
        end

        v68 = p27.gravelSound

        local v76, v77

        if v68 then
            v69 = v58 / 120
            v77 = math.clamp(v69, 0, 1)

            local v78 = Angles > 0 and (v77 * 0.55 + 0.25) * (Angles * 0.1 + 0.6) or 0

            v69 = p27.gravelVolume or 0
            v76 = v78 - v69
            v56 = p28 * 8
            p27.gravelVolume = v69 + v76 * math.min(1, v56)

            if p27.gravelVolume > 0.02 then
                if not v68.IsPlaying then
                    v68:Play()
                end

                v68.Volume = p27.gravelVolume
                v68.PlaybackSpeed = v77 * 0.45 + 0.8
            elseif v68.IsPlaying then
                v68:Stop()
            end
        end

        v77 = os.clock()
        v59 = car:GetAttribute("LightBar") == true

        for _, v79 in p27.lamps do
            if v59 then
                v54 = v79.left
                v56 = v77 % 0.9

                if not v54 then
                    v56 = (v56 + 0.45) % 0.9
                end

                chassis = v56 < 0.08 or v56 > 0.14 and v56 < 0.22
            else
                chassis = v59
            end

            v79.part.Transparency = chassis and 0 or 1
            v79.part.Color = chassis and v1 or v2

            if v79.glow then
                v79.glow.Enabled = chassis
            end
        end

        local v80 = if p29 then p29.brake > 0.05 or p29.handbrake else car:GetAttribute("Brake") == true

        if p27.brakeGlow then
            v69 = p27.brakeGlow

            if v80 then
                v69.Transparency = 0.05
            elseif v51 then
                v69.Transparency = 0.62
            else
                v69.Transparency = 0.82
            end
        end

        if p27.brakeLight then
            p27.brakeLight.Enabled = v80
        end

        local v81 = car:GetAttribute("Headlights") == true and v51

        if p27.headGlow then
            p27.headGlow.Transparency = v81 and 0.3 or 1
        end

        if p27.beam then
            p27.beam.Enabled = v81
        end

        local steer, gear, v82

        if p27.dash and p30 and (_CFrame.Position - p30).Magnitude < 60 then
            p27.dashClock = (p27.dashClock or 0) + p28

            if p27.dashClock >= 0.08333333333333333 then
                p27.dashClock = 0
                v82 = p29 ~= nil or (car:GetAttribute("Driver") or 0) ~= 0

                if p29 then
                    steer = p29.esc ~= false
                end

                v53 = CarDash.Update
                v54 = p27.dash
                v56 = {
                    kph = v58
                }

                local rpm = if p29 then p29.rpm else nil

                if not p29 or not rpm then
                    rpm = car:GetAttribute("RPM") or Config.IdleRPM
                end

                v56.rpm = rpm

                if p29 then
                    gear = p29.gear
                end

                if not p29 or not gear then
                    gear = car:GetAttribute("Gear") or 0
                end

                v56.gear = gear

                local transmission = if p29 then p29.transmission else nil

                if not p29 or not transmission then
                    transmission = car:GetAttribute("Transmission")
                end

                v56.transmission = transmission
                v56.lightBar = v59

                if v59 then
                    comp = v77 % 0.9
                    v59 = comp < 0.08 or comp > 0.14 and comp < 0.22
                end

                v56.flash = v59
                v56.headlights = v81
                v56.horn = car:GetAttribute("Horn") == true
                v56.driven = v82
                v56.esc = steer
                pcall(v53, v54, v56)
            end
        end

        local v83, v84

        if p29 then
            v83 = p29.rpm
            steer = p29.throttle
            v84 = p29.slip
        else
            v83 = car:GetAttribute("RPM") or Config.IdleRPM
            steer = car:GetAttribute("Throttle") or 0
            v77 = AssemblyLinearVelocity.Magnitude
            v54 = AssemblyLinearVelocity:Dot(_CFrame.RightVector)
            v53 = math.abs(v54)

            local v85 = v77 * StudMetres > 5

            if v85 then
                v54 = (v53 / math.max(v77, 0.001) - 0.12) / 0.25
                v84 = math.clamp(v54, 0, 1)
            end

            if not v85 or not v84 then
                v84 = 0
            end
        end

        v54 = p27.rpm
        p27.rpm = v54 + (v83 - v54) * math.min(1, p28 * 10)
        v54 = p27.throttle
        p27.throttle = v54 + (steer - v54) * math.min(1, p28 * 8)
        v54 = p27.slip
        comp = v84 - v54
        p27.slip = v54 + comp * math.min(1, p28 * 10)
        v76 = p27.layers

        if v76 then
            if not v51 or not v50 then
                for _, v86 in v76 do
                    if v86.sound.IsPlaying then
                        v86.sound:Stop()
                    end
                end
            else
                v54 = p27.rpm
                v56 = v76[1].rpm
                gear = v76[#v76].rpm
                v84 = math.clamp(v54, v56, gear)
                v82 = 1

                while v82 < #v76 and v76[v82 + 1].rpm < v84 do
                    v82 += 1
                end

                v83 = v76[v82]
                gear = v82 + 1
                comp = #v76
                v54 = v76[math.min(gear, comp)]

                local v87 = v54.rpm > v83.rpm and (v84 - v83.rpm) / (v54.rpm - v83.rpm) or 0

                comp = if p29 then 0.85 else 1
                v54 = 0.9 * comp * (0.5 + 0.5 * p27.throttle)

                for v88, v89 in v76 do
                    if v88 == v82 then
                        v55 = v87 * 3.141592653589793 / 2
                        v84 = math.cos(v55) * v54
                    else
                        v84 = 0
                    end

                    if v88 == v82 + 1 then
                        v55 = v87 * 3.141592653589793 / 2
                        v84 = math.sin(v55) * v54
                    end

                    steer = v89.sound

                    if v84 > 0.005 then
                        if not steer.IsPlaying then
                            steer:Play()
                        end

                        v55 = v84 * v89.gain
                        steer.Volume = math.min(v55, 1.5)
                        v55 = p27.rpm / v89.rpm
                        steer.PlaybackSpeed = math.clamp(v55, 0.5, 2)
                    elseif steer.IsPlaying then
                        steer.Volume = 0
                        steer:Stop()
                    end
                end

                v54 = 1 - p27.throttle
                p27.engineEq.HighGain = -14 * v54
                p27.engineEq.MidGain = -5 * v54
            end
        end

        v76 = p27.skid

        if v76 then
            local v90 = if v50 then p27.slip * 0.55 else nil

            if not v50 or not v90 then
                v90 = 0
            end

            if v90 > 0.02 then
                if not v76.IsPlaying then
                    v76:Play()
                end

                v76.Volume = v90
                v76.PlaybackSpeed = 0.9 + 0.2 * p27.slip
            elseif v76.IsPlaying then
                v76:Stop()
            end
        end

        v76 = p27.horn

        if not v76 then
            return
        end

        v51 = car:GetAttribute("Horn") == true

        if not v51 or p27.hornOn then
            if not v51 and p27.hornOn then
                v76:Stop()
            end
        else
            v76.TimePosition = 0
            v76:Play()
        end

        p27.hornOn = v51
    end
end

return t1
