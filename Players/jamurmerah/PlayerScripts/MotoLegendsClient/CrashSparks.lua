-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local v1 = RaycastParams.new()

v1.FilterType = Enum.RaycastFilterType.Include

local Config = require(game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends"):WaitForChild("Config"))
local v2
local t1 = {}

task.spawn(function() -- line: 13
    local _require = require
    local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")

    pcall(_require, MotoLegends:WaitForChild("LocalTyreMarks"))
end)

local function ground(p1) -- line: 14
    -- upvalues: v1 (copy), v2 (ref)
    if v2 and v2.Parent then
        return workspace:Raycast(p1 + Vector3.new(0, 2, 0), Vector3.new(-0, -6, -0, -0), v1)
    end

    v2 = workspace:FindFirstChild("RaceCollision", true)

    if not v2 then
        return
    end

    v1.FilterDescendantsInstances = {
        v2,
        workspace.Terrain
    }

    return workspace:Raycast(p1 + Vector3.new(0, 2, 0), Vector3.new(-0, -6, -0, -0), v1)
end

local function makeFx() -- line: 21
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "CrashSparkPoint"
    Attachment.Parent = workspace.Terrain

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Sparks"
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 250, 210)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 190, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 90, 20))
    })
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Brightness = 3
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.18),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.8, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.18, 0.45)
    ParticleEmitter.Speed = NumberRange.new(10, 26)
    ParticleEmitter.SpreadAngle = Vector2.new(35, 18)
    ParticleEmitter.Acceleration = Vector3.new(0, -60, 0)
    ParticleEmitter.Drag = 2
    ParticleEmitter.Rate = 0
    ParticleEmitter.Enabled = true
    ParticleEmitter.Orientation = Enum.ParticleOrientation.VelocityParallel
    ParticleEmitter.Squash = NumberSequence.new(-1.6)
    ParticleEmitter.Parent = Attachment

    local PointLight = Instance.new("PointLight")

    PointLight.Color = Color3.fromRGB(255, 170, 60)
    PointLight.Range = 8
    PointLight.Brightness = 0
    PointLight.Shadows = false
    PointLight.Parent = Attachment

    return {
        attachment = Attachment,
        emitter = ParticleEmitter,
        light = PointLight
    }
end

local function bodies(p2) -- line: 36
    local t2 = {}

    for _, v3 in { "CrashMass", "FrontTyreContact", "RearTyreContact" } do
        local v4 = p2:FindFirstChild(v3)

        if v4 and v4:IsA("BasePart") then
            table.insert(t2, v4)
        end
    end

    if p2.PrimaryPart then
        table.insert(t2, p2.PrimaryPart)
    end

    return t2
end

local function step(p3, p4) -- line: 42
    -- upvalues: LocalPlayer (copy), Config (copy), t1 (copy), ground (copy), makeFx (copy), bodies (copy)
    local PrimaryPart = p3.PrimaryPart

    if not PrimaryPart then
        return
    end

    local v5 = (p3:GetAttribute("Crash") or "") ~= ""
    local v6 = (PrimaryPart:GetAttribute("LossStage") or "") ~= "" and math.abs(PrimaryPart.CFrame.UpVector.Y) < 0.55
    local v7 = t1[p3]

    if not (v5 or v6) then
        if v7 then
            v7.emitter.Rate = 0
            v7.light.Brightness = 0
        end
    else
        local AssemblyLinearVelocity = PrimaryPart.AssemblyLinearVelocity
        local Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude
        local Position, v8

        for _, v9 in bodies(p3) do
            local v10 = ground(v9.Position)

            if v10 and v10.Instance:GetAttribute("Surface") == "Asphalt" then
                local CFrame, Size = v9.CFrame, v9.Size
                local v13 = (math.abs(CFrame.RightVector.Y) * Size.X + math.abs(CFrame.UpVector.Y) * Size.Y + math.abs(CFrame.LookVector.Y) * Size.Z) / 2
                local v14 = v9.Position.Y - v13 - v10.Position.Y

                if v14 < 0.35 and (not v8 or v14 < v8) then
                    v8 = v14
                    Position = v10.Position
                end
            end
        end

        local v15 = Position and Magnitude > 5

        if v15 and not v7 then
            v7 = makeFx()
            t1[p3] = v7
        end

        if v7 then
            if v15 then
                v7.attachment.WorldCFrame = CFrame.lookAt(Position + Vector3.new(0, 0.1, 0), Position + Vector3.new(0, 0.1, 0) - Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Unit + Vector3.new(0, 0.35, 0))
                v7.emitter.Rate = math.clamp(Magnitude * 5, 25, 320)
                v7.light.Brightness = (1.2 + math.random() * 1.8) * math.clamp(Magnitude / 40, 0.3, 1)
            else
                v7.emitter.Rate = 0
                v7.light.Brightness = 0
            end
        end

        if v5 and p3:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            local AssemblyAngularVelocity = PrimaryPart.AssemblyAngularVelocity

            if AssemblyAngularVelocity.Magnitude > 16 then
                AssemblyAngularVelocity = AssemblyAngularVelocity.Unit * 16
            end

            if Position then
                local v21 = Vector3.new(0, 1, 0) * AssemblyAngularVelocity.Y
                local v22 = AssemblyAngularVelocity - v21

                AssemblyAngularVelocity = v21 * math.exp(-p4 * 0.9) + v22 * math.exp(-p4 * 2.6)
            end

            local v26 = ground(PrimaryPart.Position)

            if v26 and (PrimaryPart.Position - v26.Position).Magnitude < 3 and (if v26.Instance == workspace.Terrain and (v26.Material == Enum.Material.Sand or v26.Material == Enum.Material.Ground) then "Gravel" else v26.Instance:GetAttribute("Surface")) == "Gravel" then
                AssemblyAngularVelocity *= math.exp(-p4 * 1.8)

                if Magnitude > 0.05 then
                    local v29 = math.min(Magnitude, Config.Gravity * 0.85 * p4)

                    PrimaryPart.AssemblyLinearVelocity = AssemblyLinearVelocity - Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Unit * v29
                end
            end

            PrimaryPart.AssemblyAngularVelocity = AssemblyAngularVelocity
        end
    end
end

RunService.Heartbeat:Connect(function(p5) -- line: 99
    -- upvalues: t1 (copy), step (copy)
    for _, v30 in { "RaceBikes", "CrashedBikes" } do
        local v31 = workspace:FindFirstChild(v30)

        if v31 then
            for _, child in v31:GetChildren() do
                if child:IsA("Model") then
                    step(child, p5)
                end
            end
        end
    end

    for v32, v33 in t1 do
        if not v32.Parent then
            v33.attachment:Destroy()
            t1[v32] = nil
        end
    end
end)
