-- https://lua.expert

local v1

local function __raceRC() -- line: 3
    -- upvalues: v1 (ref)
    if not (v1 and v1.Parent) then
        v1 = workspace:FindFirstChild("RaceCollision", true)
    end

    return v1
end

local Config = require(script.Parent.Config)
local HighsideTuning = script.Parent:WaitForChild("HighsideTuning")
local HighsideTuning2 = require(HighsideTuning)

local function tune(p1) -- line: 8
    -- upvalues: HighsideTuning (copy), HighsideTuning2 (copy)
    local Attribute = HighsideTuning:GetAttribute(p1)

    if type(Attribute) ~= "number" or not Attribute then
        Attribute = HighsideTuning2[p1]
    end

    return Attribute
end

local t1 = {}
local v2 = RaycastParams.new()

v2.FilterType = Enum.RaycastFilterType.Include

local function contact(p2, p3) -- line: 33
    -- upvalues: v1 (ref), HighsideTuning (copy), HighsideTuning2 (copy), v2 (copy)
    local v3 = p2.bike or p2.root.Parent
    local v4 = v3 and v3:FindFirstChild(p3 .. "TyreContact")

    if not v4 then
        return
    end

    if not (v1 and v1.Parent) then
        v1 = workspace:FindFirstChild("RaceCollision", true)
    end

    local v5 = v1

    v2.FilterDescendantsInstances = {
        v5,
        workspace.Terrain
    }

    local RightVector = v4.CFrame.RightVector
    local v6 = workspace:Raycast(v4.Position + Vector3.new(0, 2, 0), Vector3.new(-0, -1, -0, -0) * (v4.Size.Y + 4), v2)
    local Normal, v7

    if not v6 or v6.Normal.Y < 0.45 or v6.Instance:GetAttribute("Surface") == "Barrier" then
        return
    else
        Normal = v6.Normal

        local v9 = RightVector:Dot(Normal)
        local v10 = Normal - RightVector * v9

        v7 = RightVector * (math.sign(v9) * v4.Size.X * 0.5)

        if v10.Magnitude > 0.01 then
            v7 += v10.Unit * (v4.Size.Y * 0.5)
        end
    end

    local v11 = v4.Position - v7
    local _workspace = workspace
    local v12 = v11 + Normal * 2
    local v13 = -Normal
    local SuspensionTravel = HighsideTuning:GetAttribute("SuspensionTravel")

    if type(SuspensionTravel) ~= "number" or not SuspensionTravel then
        SuspensionTravel = HighsideTuning2.SuspensionTravel
    end

    local v14 = _workspace:Raycast(v12, v13 * (2 + SuspensionTravel + 0.2), v2)
    local v15, SuspensionTravel2

    if v14 and not (v14.Normal.Y < 0.45) and v14.Instance:GetAttribute("Surface") ~= "Barrier" then
        v15 = (v11 - v14.Position):Dot(v14.Normal)
        SuspensionTravel2 = HighsideTuning:GetAttribute("SuspensionTravel")
        SuspensionTravel2 = type(SuspensionTravel2) == "number" and SuspensionTravel2 or HighsideTuning2.SuspensionTravel

        if SuspensionTravel2 < v15 then
            return
        end

        return v14.Position, v14.Normal, v4, v15
    end
end

local function inverseInertia(p4, p5) -- line: 53
    local v16 = p4.Parent:FindFirstChild("CrashMass") or p4
    local Size = v16.Size
    local AssemblyMass = p4.AssemblyMass
    local v17 = v16.CFrame:VectorToObjectSpace(p5)
    local v21 = Vector3.new(Size.Y ^ 2 + Size.Z ^ 2, Size.X ^ 2 + Size.Z ^ 2, Size.X ^ 2 + Size.Y ^ 2) * AssemblyMass / 12

    return v16.CFrame:VectorToWorldSpace((Vector3.new(v17.X / math.max(v21.X, 0.01), v17.Y / math.max(v21.Y, 0.01), v17.Z / math.max(v21.Z, 0.01))))
end

local function contactMass(p6, p7, p8) -- line: 60
    -- upvalues: inverseInertia (copy)
    local v25 = (p7 - p6.AssemblyCenterOfMass):Cross(p8)

    return 1 / (1 / p6.AssemblyMass + math.max(0, v25:Dot(inverseInertia(p6, v25))))
end

local function contactForce(p9, p10, p11, p12) -- line: 67
    local root = p9.root
    local v26 = root:FindFirstChild("LossContact_" .. p10)

    if not v26 then
        v26 = Instance.new("Attachment")
        v26.Name = "LossContact_" .. p10
        v26.Parent = root

        local VectorForce = Instance.new("VectorForce")

        VectorForce.Name = "LossForce_" .. p10
        VectorForce.Attachment0 = v26
        VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        VectorForce.ApplyAtCenterOfMass = false
        VectorForce.Parent = root
    end

    v26.Position = root.CFrame:PointToObjectSpace(p11)
    root["LossForce_" .. p10].Force = p12
end

local function pulse(p13, p14, p15, p16, p17) -- line: 78
    local physics = p13.loss.physics

    physics.pulses = physics.pulses or {}
    physics.pulses[p14] = {
        age = 0,
        point = p13.root.CFrame:PointToObjectSpace(p15),
        impulse = p16,
        duration = p17
    }
end

local function wheelSupport(p18, p19, p20, p21, _, p23, p24) -- line: 83
    -- upvalues: Config (copy)
    local root = p18.root
    local physics = p18.loss.physics
    local v28 = math.max((root.AssemblyCenterOfMass - p20):Dot(p21), 0.2)
    local v30 = (physics.totalLongitudinalForce or 0) * v28 / math.max(Config.Wheelbase, 0.5)
    local v31 = root.AssemblyMass * Config.Gravity * p24

    v30 = p19 == "Front" and -v30 or v30

    local v32 = v31 + v30
    local v33 = root:GetVelocityAtPosition(p20):Dot(p21)

    physics.normalVelocities = physics.normalVelocities or {}

    local v37 = math.clamp((v33 - (physics.normalVelocities[p19] or v33)) / math.max(p23, 0.005), -Config.Gravity, Config.Gravity * 2)

    physics.normalVelocities[p19] = v33

    local v39 = math.max(0, v32 + root.AssemblyMass * p24 * v37)

    physics.loads = physics.loads or {}

    local v40 = physics.loads[p19] or math.max(v32, 0)
    local v43 = v40 + (v39 - v40) * (1 - math.exp(-p23 / 0.09))

    physics.loads[p19] = v43

    return v43
end

local function tyre(p25, p26, p27, p28, p29, p30, p31, p32, p33, p34) -- line: 103
    -- upvalues: HighsideTuning (copy), HighsideTuning2 (copy), contactForce (copy)
    local root = p25.root
    local v44 = root.CFrame.LookVector - p28 * root.CFrame.LookVector:Dot(p28)

    if v44.Magnitude < 0.05 then
        return 0, 0, 0, 0
    end

    local Unit = v44.Unit

    if p34 then
        Unit = CFrame.fromAxisAngle(p28, p34):VectorToWorldSpace(Unit)
    end

    local Unit2 = Unit:Cross(p28).Unit
    local VelocityAtPosition = root:GetVelocityAtPosition(p27)
    local v45 = VelocityAtPosition:Dot(Unit)
    local v46 = VelocityAtPosition:Dot(Unit2)
    local v49 = math.atan2(v46, (math.max(math.abs(v45), 2)))
    local LongitudinalStiffness = HighsideTuning:GetAttribute("LongitudinalStiffness")

    if type(LongitudinalStiffness) ~= "number" or not LongitudinalStiffness then
        LongitudinalStiffness = HighsideTuning2.LongitudinalStiffness
    end

    local v50 = p31 * LongitudinalStiffness * (p32 or 0)
    local v51 = -p31
    local CorneringStiffness = HighsideTuning:GetAttribute("CorneringStiffness")

    if type(CorneringStiffness) ~= "number" or not CorneringStiffness then
        CorneringStiffness = HighsideTuning2.CorneringStiffness
    end

    local v52 = CorneringStiffness * v49
    local CamberThrust = HighsideTuning:GetAttribute("CamberThrust")

    if type(CamberThrust) ~= "number" or not CamberThrust then
        CamberThrust = HighsideTuning2.CamberThrust
    end

    local v53 = v51 * (v52 + CamberThrust * math.sin(p33))
    local v55 = math.max(p31 * p29, 0.001)
    local v57 = math.sqrt(v50 * v50 + v53 * v53) / v55
    local SlidingGripFraction, v58, v59

    if v57 <= 1 then
        local v61 = math.sin(v57 * 3.141592653589793 * 0.5)

        if v61 then
            v58 = v61
            v59 = true
        else
            SlidingGripFraction = HighsideTuning:GetAttribute("SlidingGripFraction")
            SlidingGripFraction = type(SlidingGripFraction) == "number" and SlidingGripFraction or HighsideTuning2.SlidingGripFraction
            v59 = false
        end
    else
        SlidingGripFraction = HighsideTuning:GetAttribute("SlidingGripFraction")
        SlidingGripFraction = type(SlidingGripFraction) == "number" and SlidingGripFraction or HighsideTuning2.SlidingGripFraction
        v59 = false
    end

    if not v59 then
        local SlidingGripFraction2 = HighsideTuning:GetAttribute("SlidingGripFraction")

        if type(SlidingGripFraction2) ~= "number" or not SlidingGripFraction2 then
            SlidingGripFraction2 = HighsideTuning2.SlidingGripFraction
        end

        v58 = SlidingGripFraction + (1 - SlidingGripFraction2) * math.exp(-(v57 - 1) ^ 2)
    end

    local v66 = math.max(math.sqrt(v50 * v50 + v53 * v53), 0.001)
    local v67 = (Unit2 * v53 + Unit * v50) * (v55 * v58 / v66)
    local physics = p25.loss.physics

    physics.tyreForces = physics.tyreForces or {}

    local v68 = physics.tyreForces[p26] or Vector3.new(0, 0, 0)
    local v69 = -p30
    local ForceResponse = HighsideTuning:GetAttribute("ForceResponse")

    if type(ForceResponse) ~= "number" or not ForceResponse then
        ForceResponse = HighsideTuning2.ForceResponse
    end

    local v71 = v68:Lerp(v67, 1 - math.exp(v69 / math.max(ForceResponse, 0.005)))
    local v72 = v71 - p28 * v71:Dot(p28)

    if v55 < v72.Magnitude then
        v72 = v72.Unit * v55
    end

    physics.tyreForces[p26] = v72
    contactForce(p25, p26, p27, v72)

    return v46, v72:Dot(Unit), v57, v72:Dot(Unit2)
end

local t3 = {
    Head = true,
    UpperTorso = true,
    LowerTorso = true,
    Torso = true,
    LeftUpperArm = true,
    RightUpperArm = true,
    LeftLowerArm = true,
    RightLowerArm = true,
    LeftUpperLeg = true,
    RightUpperLeg = true,
    LeftLowerLeg = true,
    RightLowerLeg = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true
}

function t1.RiderGrounded(p35) -- line: 136
    -- upvalues: v1 (ref), v2 (copy), t3 (copy)
    local v73 = p35.rider and p35.rider.Parent

    if v73 then
        if not (v1 and v1.Parent) then
            v1 = workspace:FindFirstChild("RaceCollision", true)
        end

        v2.FilterDescendantsInstances = {
            v1,
            workspace.Terrain
        }

        for _, child in v73:GetChildren() do
            if child:IsA("BasePart") and t3[child.Name] then
                local CFrame, Size = child.CFrame, child.Size
                local v75 = Size * 0.5
                local v76 = Vector3.new(v75.X, 0, v75.Z)
                local v78 = Vector3.new(-v75.X, 0, v75.Z)
                local v80 = Vector3.new(v75.X, 0, -v75.Z)
                local v81 = -v75.X
                local v82 = -v75.Z

                for _, v83 in {
                        Vector3.new(0, 0, 0),
                        v76,
                        v78,
                        v80,
                        (Vector3.new(v81, 0, v82))
                    } do
                    local v84 = CFrame:PointToWorldSpace(v83)
                    local v85 = math.abs(CFrame.UpVector.Y) * v75.Y + 0.1

                    if v83 == Vector3.new(0, 0, 0) then
                        v85 = (math.abs(CFrame.RightVector.Y) * Size.X + math.abs(CFrame.UpVector.Y) * Size.Y + math.abs(CFrame.LookVector.Y) * Size.Z) * 0.5 + 0.1
                    end

                    local v88 = workspace:Raycast(v84 + Vector3.new(0, 0.1, 0), Vector3.new(-0, -1, -0, -0) * (v85 + 0.1), v2)

                    if v88 and v88.Normal.Y > 0.4 and v88.Instance:GetAttribute("Surface") ~= "Barrier" then
                        return true
                    end
                end
            end
        end
    end

    return false
end

function t1.Begin(p36, p37) -- line: 159
    -- upvalues: Config (copy), HighsideTuning (copy), HighsideTuning2 (copy), contact (copy), inverseInertia (copy), pulse (copy)
    local root = p36.root
    local Magnitude = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z).Magnitude
    local v94 = math.max(p36.slip or 0, p36.exitSlip or 0, p36.tractionSlip or 0, math.abs(p36.rearYaw or 0) * 3)
    local v96 = math.sign(p36.lean or 0)

    if v96 == 0 then
        v96 = 1
    end

    local v100 = math.clamp(v94 * 0.3 + 0.15 + Magnitude * Config.StudMetres * 3.6 / 420 + math.abs(p36.lean or 0) * 0.2, 0.2, 1.4)
    local t5 = {
        kind = p37,
        side = v96,
        severity = v100,
        at = workspace:GetServerTimeNow(),
        initialLean = math.abs(p36.lean or 0),
        cornerForce = -math.tan(p36.lean or 0) * root.AssemblyMass * Config.Gravity * 0.82,
        travelRight = CFrame.Angles(0, p36.yaw, 0).RightVector,
        recoverAfter = v100 * 0.12 + 0.48,
        hardness = math.clamp(v94 * 0.25 + 0.65 + (p36.highsideSlipRecovery or 0) * 0.08, 0.65, 1.4),
        pitchFall = p37 == "LOOPOVER" or p37 == "STOPPIE",
        initialThrottle = math.clamp(p36.smoothThrottle or p36.throttle or 0, 0, 1),
        initialRearYaw = p36.rearYaw or 0,
        initialHeading = p36.yaw or 0
    }

    root:SetAttribute("LossInitialHeading", p36.yaw or 0)
    root:SetAttribute("LossInitialRearYaw", t5.initialRearYaw)
    root:SetAttribute("HighsidePhase", "RearSlide")
    p36.loss.physics = t5

    local AssemblyMass, AssemblyLinearVelocity, AssemblyAngularVelocity, AssemblyCenterOfMass = root.AssemblyMass, root.AssemblyLinearVelocity, root.AssemblyAngularVelocity, root.AssemblyCenterOfMass
    local CrashMass = p36.bike:FindFirstChild("CrashMass")

    if not CrashMass then
        CrashMass = Instance.new("Part")
        CrashMass.Name = "CrashMass"
        CrashMass.Transparency = 1
        CrashMass.Size = Vector3.new(1.1, 2.5, 4.3) * Config.BikeScale
        CrashMass.CFrame = root.CFrame * CFrame.new(0, 1.3, 0)
        CrashMass.Massless = true
        CrashMass.CanCollide = false
        CrashMass.CanTouch = false
        CrashMass.CanQuery = false
        CrashMass.CollisionGroup = root.CollisionGroup
        CrashMass.Parent = p36.bike

        local WeldConstraint = Instance.new("WeldConstraint")

        WeldConstraint.Name = "CrashMassWeld"
        WeldConstraint.Part0 = root
        WeldConstraint.Part1 = CrashMass
        WeldConstraint.Parent = CrashMass
    end

    CrashMass.CustomPhysicalProperties = PhysicalProperties.new(math.min(100, AssemblyMass / (CrashMass.Size.X * CrashMass.Size.Y * CrashMass.Size.Z)), 0, 0, 100, 100)
    CrashMass.RootPriority = 0
    CrashMass.Massless = false

    if root.RootPriority ~= 127 then
        root.RootPriority = 127
    end

    root.CustomPhysicalProperties = PhysicalProperties.new(0.01, root.CurrentPhysicalProperties.Friction, root.CurrentPhysicalProperties.Elasticity, root.CurrentPhysicalProperties.FrictionWeight, root.CurrentPhysicalProperties.ElasticityWeight)
    CrashMass.CollisionGroup = root.CollisionGroup
    CrashMass.CanCollide = true
    CrashMass.CustomPhysicalProperties = PhysicalProperties.new(CrashMass.CurrentPhysicalProperties.Density, Config.CrashFriction, 0, 100, 100)
    root.AssemblyLinearVelocity = AssemblyLinearVelocity + AssemblyAngularVelocity:Cross(root.AssemblyCenterOfMass - AssemblyCenterOfMass)
    root.AssemblyAngularVelocity = AssemblyAngularVelocity

    if t5.pitchFall then
        local RightVector = root.CFrame.RightVector
        local v105

        if p37 == "LOOPOVER" then
            v105 = math.max(AssemblyAngularVelocity:Dot(RightVector), p36.wheelieVelocity or 0)

            if not v105 then
                v105 = math.min(AssemblyAngularVelocity:Dot(RightVector), -(p36.stoppieVelocity or 0))
            end
        else
            v105 = math.min(AssemblyAngularVelocity:Dot(RightVector), -(p36.stoppieVelocity or 0))
        end

        root.AssemblyAngularVelocity = AssemblyAngularVelocity + RightVector * (v105 - AssemblyAngularVelocity:Dot(RightVector))
    end

    local function v112() -- line: 212
        -- upvalues: p36 (copy), root (copy)
        root:SetNetworkOwner(p36.player)
    end

    pcall(v112)
    p36.force.Force = Vector3.new(0, 0, 0)
    p36.force.Enabled = false
    p36.align.Enabled = false

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "CrashGravityAttachment"
    Attachment.Parent = root

    local VectorForce = Instance.new("VectorForce")

    VectorForce.Name = "CrashGravity"
    VectorForce.Attachment0 = Attachment
    VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
    VectorForce.ApplyAtCenterOfMass = true
    VectorForce.Force = Vector3.new(0, 1, 0) * root.AssemblyMass * (workspace.Gravity - Config.Gravity)
    VectorForce.Parent = root
    root:SetAttribute("CrashPhysics", true)
    root:SetAttribute("HighsideCaught", false)
    root:SetAttribute("HighsideSeverity", v100)
    root:SetAttribute("HighsideCatch", t5.recoverAfter)

    for _, v113 in { "Front", "Rear" } do
        local v114 = p36.bike:FindFirstChild(v113 .. "TyreContact")

        if v114 then
            v114.CanCollide = true
            v114.CustomPhysicalProperties = PhysicalProperties.new(0.5, 0, 0, 100, 100)
        end
    end

    local v115 = p37 == "LOWSIDE" and p36.lossOverSlide == true

    p36.lossOverSlide = false

    local function sramp(p38, p39, p40) -- line: 234
        local v119 = math.clamp((p38 - p39) / math.max(p40 - p39, 0.001), 0, 1)

        return v119 * v119 * (3 - 2 * v119)
    end

    local v120 = Magnitude * Config.StudMetres * 3.6
    local SpinLeanMin = HighsideTuning:GetAttribute("SpinLeanMin")

    if type(SpinLeanMin) ~= "number" or not SpinLeanMin then
        SpinLeanMin = HighsideTuning2.SpinLeanMin
    end

    local v121 = SpinLeanMin or 0
    local v122 = 1 - v121
    local v124 = math.abs(p36.lean or 0)
    local SpinLeanFrom = HighsideTuning:GetAttribute("SpinLeanFrom")

    if type(SpinLeanFrom) ~= "number" or not SpinLeanFrom then
        SpinLeanFrom = HighsideTuning2.SpinLeanFrom
    end

    local v125 = SpinLeanFrom or 0.3490658503988659
    local SpinLeanFull = HighsideTuning:GetAttribute("SpinLeanFull")

    if type(SpinLeanFull) ~= "number" or not SpinLeanFull then
        SpinLeanFull = HighsideTuning2.SpinLeanFull
    end

    local v126 = SpinLeanFull or 0.7853981633974483
    local v130 = math.clamp((v124 - v125) / math.max(v126 - v125, 0.001), 0, 1)
    local v131 = v121 + v122 * (v130 * v130 * (3 - 2 * v130))
    local SpinFromKph = HighsideTuning:GetAttribute("SpinFromKph")

    if type(SpinFromKph) ~= "number" or not SpinFromKph then
        SpinFromKph = HighsideTuning2.SpinFromKph
    end

    local v132 = SpinFromKph or 25
    local SpinFullKph = HighsideTuning:GetAttribute("SpinFullKph")

    if type(SpinFullKph) ~= "number" or not SpinFullKph then
        SpinFullKph = HighsideTuning2.SpinFullKph
    end

    local v133 = SpinFullKph or 60
    local v137 = math.clamp((v120 - v132) / math.max(v133 - v132, 0.001), 0, 1)

    t5.spinF = v137 * v137 * (3 - 2 * v137) * v131

    if v115 and t5.spinF < 0.05 then
        v115 = false
    end

    t5.spinOut = v115
    root:SetAttribute("SpinOutLowside", v115)

    local v138 = p37 == "LOWSIDE" and (v115 or math.max(p36.tractionSlip or 0, p36.exitSlip or 0) > 0.12 and (p36.rearBrakeSlip or 0) < 0.15)

    t5.powerLowside = v138
    root:SetAttribute("PowerLowside", v138)

    local Rear, Rear2, RightVector, v141

    if v138 and not v115 then
        Rear, Rear2 = contact(p36, "Rear")

        if Rear then
            RightVector = CFrame.Angles(0, p36.yaw, 0).RightVector
            math.clamp(Magnitude * (math.min(v94, 1.5) * 0.07 + 0.045) + 2, 3, 17)

            local v143 = RightVector - Rear2 * RightVector:Dot(Rear2)

            if v143.Magnitude > 0.01 then
                RightVector = v143.Unit
            end

            local v144 = root:GetVelocityAtPosition(Rear):Dot(RightVector) * v96

            v141 = math.clamp(math.abs((math.tan(p36.rearYaw or 0))) * Magnitude - v144, 0, 7)

            local v148 = Rear + Rear2 * (root.AssemblyCenterOfMass - Rear):Dot(Rear2)
            local v149 = RightVector * v96 * v141
            local v150 = (v148 - root.AssemblyCenterOfMass):Cross(RightVector)

            pulse(p36, "RearSlide", v148, v149 * (1 / (1 / root.AssemblyMass + math.max(0, v150:Dot(inverseInertia(root, v150))))), 0.18)
            t5.seeded = true
        end
    end

    local v152 = p37 == "HIGHSIDE" and p36.lossGripCatch == true

    p36.lossGripCatch = false
    t5.gripCatch = v152

    local Rear3, RightVector2

    if v152 then
        local Rear

        Rear3, Rear = contact(p36, "Rear")

        if Rear3 then
            RightVector2 = CFrame.Angles(0, p36.yaw, 0).RightVector

            local v153 = RightVector2 - Rear * RightVector2:Dot(Rear)

            if v153.Magnitude > 0.01 then
                RightVector2 = v153.Unit
            end

            local v156 = math.abs((math.tan(p36.rearYaw or 0))) * Magnitude
            local v157 = (Rear3 - root.AssemblyCenterOfMass):Cross(RightVector2)
            local v158 = 1 / (1 / root.AssemblyMass + math.max(0, v157:Dot(inverseInertia(root, v157))))
            local DryGrip = HighsideTuning:GetAttribute("DryGrip")

            if type(DryGrip) ~= "number" or not DryGrip then
                DryGrip = HighsideTuning2.DryGrip
            end

            local CatchSpike = HighsideTuning:GetAttribute("CatchSpike")

            if type(CatchSpike) ~= "number" or not CatchSpike then
                CatchSpike = HighsideTuning2.CatchSpike
            end

            local v159 = DryGrip * CatchSpike * root.AssemblyMass * Config.Gravity * 0.52
            local CatchSeconds = HighsideTuning:GetAttribute("CatchSeconds")

            if type(CatchSeconds) ~= "number" or not CatchSeconds then
                CatchSeconds = HighsideTuning2.CatchSeconds
            end

            local v160 = v159 * CatchSeconds
            local v162 = math.min(v158 * v156, v160)
            local v164 = math.abs((inverseInertia(root, (Rear3 - root.AssemblyCenterOfMass):Cross(-RightVector2 * v96)):Dot(root.CFrame.LookVector)))

            if v164 > 1E-06 then
                local CatchMaxRoll = HighsideTuning:GetAttribute("CatchMaxRoll")

                v162 = math.min(v162, (type(CatchMaxRoll) == "number" and CatchMaxRoll or HighsideTuning2.CatchMaxRoll) / v164)
            end

            local v166 = -RightVector2 * v96 * v162
            local CatchSeconds2 = HighsideTuning:GetAttribute("CatchSeconds")

            if type(CatchSeconds2) ~= "number" or not CatchSeconds2 then
                CatchSeconds2 = HighsideTuning2.CatchSeconds
            end

            pulse(p36, "RearCatch", Rear3, v166, CatchSeconds2)

            local RearCatch = t5.pulses.RearCatch
            local CatchDelay = HighsideTuning:GetAttribute("CatchDelay")

            if type(CatchDelay) ~= "number" or not CatchDelay then
                CatchDelay = HighsideTuning2.CatchDelay
            end

            RearCatch.age = -CatchDelay
            root:SetAttribute("HighsideCatchImpulse", v162 / math.max(root.AssemblyMass, 1))
        end
    end

    local v167 = false

    if p37 == "LOWSIDE" and p36.player then
        local GetNetworkOwner = root.GetNetworkOwner
        local ok, result = pcall(GetNetworkOwner, root)

        v167 = ok and result == p36.player
    end

    t5.ownerRuns = v167
    root:SetAttribute("LossOwnerPhysics", v167)
end

function t1.BeginLocal(p41, p42) -- line: 302
    -- upvalues: Config (copy), HighsideTuning (copy), HighsideTuning2 (copy), contact (copy), inverseInertia (copy), pulse (copy)
    local root = p41.root

    if p41.loss and p41.loss.owner and p41.loss.physics and p41.loss.physics.cleanup then
        p41.loss.physics.cleanup()
    end

    p41.bike = p41.bike or root.Parent

    local AssemblyLinearVelocity = root.AssemblyLinearVelocity
    local Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude

    math.max(p41.slip or 0, p41.exitSlip or 0, p41.tractionSlip or 0, math.abs(p41.rearYaw or 0) * 3)

    local LossSide = root:GetAttribute("LossSide")
    local v173, v174

    if typeof(LossSide) ~= "number" or LossSide == 0 then
        v174 = false
    else
        local v175 = math.sign(LossSide)

        if v175 then
            v173 = v175
            v174 = true
        else
            v174 = false
        end
    end

    if not v174 then
        local v177 = math.sign(p41.lean or 0) == 0
        local v178 = if not v177 then math.sign(p41.lean or 0) else nil

        v173 = if v177 or not v178 then 1 else v178
    end

    local LookVector = root.CFrame.LookVector
    local t6 = {
        owner = true,
        kind = p42,
        side = v173,
        initialLean = math.abs(p41.lean or 0),
        travelRight = CFrame.Angles(0, p41.yaw or 0, 0).RightVector,
        initialHeading = math.atan2(-LookVector.X, -LookVector.Z),
        initialRearYaw = p41.rearYaw or root:GetAttribute("LossInitialRearYaw") or 0,
        initialThrottle = math.clamp(p41.smoothThrottle or p41.throttle or 0, 0, 1)
    }
    local v183 = root:GetAttribute("LossStarted") or workspace:GetServerTimeNow()
    local v184 = root:GetAttribute("SpinOutLowside") == true

    local function sramp(p43, p44, p45) -- line: 318
        local v188 = math.clamp((p43 - p44) / math.max(p45 - p44, 0.001), 0, 1)

        return v188 * v188 * (3 - 2 * v188)
    end

    local SpinLeanMin = HighsideTuning:GetAttribute("SpinLeanMin")

    if type(SpinLeanMin) ~= "number" or not SpinLeanMin then
        SpinLeanMin = HighsideTuning2.SpinLeanMin
    end

    local v189 = SpinLeanMin or 0
    local v190 = 1 - v189
    local v192 = math.abs(p41.lean or 0)
    local SpinLeanFrom = HighsideTuning:GetAttribute("SpinLeanFrom")

    if type(SpinLeanFrom) ~= "number" or not SpinLeanFrom then
        SpinLeanFrom = HighsideTuning2.SpinLeanFrom
    end

    local v193 = SpinLeanFrom or 0.3490658503988659
    local SpinLeanFull = HighsideTuning:GetAttribute("SpinLeanFull")

    if type(SpinLeanFull) ~= "number" or not SpinLeanFull then
        SpinLeanFull = HighsideTuning2.SpinLeanFull
    end

    local v194 = SpinLeanFull or 0.7853981633974483
    local v198 = math.clamp((v192 - v193) / math.max(v194 - v193, 0.001), 0, 1)
    local v199 = v189 + v190 * (v198 * v198 * (3 - 2 * v198))
    local v200 = Magnitude * Config.StudMetres * 3.6
    local SpinFromKph = HighsideTuning:GetAttribute("SpinFromKph")

    if type(SpinFromKph) ~= "number" or not SpinFromKph then
        SpinFromKph = HighsideTuning2.SpinFromKph
    end

    local v201 = SpinFromKph or 25
    local SpinFullKph = HighsideTuning:GetAttribute("SpinFullKph")

    if type(SpinFullKph) ~= "number" or not SpinFullKph then
        SpinFullKph = HighsideTuning2.SpinFullKph
    end

    local v202 = SpinFullKph or 60
    local v206 = math.clamp((v200 - v201) / math.max(v202 - v201, 0.001), 0, 1)

    t6.spinF = v206 * v206 * (3 - 2 * v206) * v199

    if v184 and t6.spinF < 0.05 then
        v184 = false
    end

    t6.spinOut = v184

    local v207 = p42 == "LOWSIDE" and (v184 or math.max(p41.tractionSlip or 0, p41.exitSlip or 0) > 0.12 and (p41.rearBrakeSlip or 0) < 0.15)

    t6.powerLowside = v207
    p41.lossOverSlide = false
    p41.lossGripCatch = false
    p41.loss = {
        owner = true,
        kind = p42,
        at = v183,
        key = root:GetAttribute("LossStarted"),
        root = root,
        physics = t6
    }

    local Rear, Rear2, RightVector

    if t6.powerLowside and not v184 then
        Rear, Rear2 = contact(p41, "Rear")

        if Rear then
            RightVector = CFrame.Angles(0, p41.yaw or 0, 0).RightVector

            local v210 = RightVector - Rear2 * RightVector:Dot(Rear2)

            if v210.Magnitude > 0.01 then
                RightVector = v210.Unit
            end

            local v211 = root:GetVelocityAtPosition(Rear):Dot(RightVector) * v173
            local v215 = math.clamp(math.abs((math.tan(p41.rearYaw or 0))) * Magnitude - v211, 0, 7)
            local v216 = Rear + Rear2 * (root.AssemblyCenterOfMass - Rear):Dot(Rear2)
            local v217 = RightVector * v173 * v215
            local v218 = (v216 - root.AssemblyCenterOfMass):Cross(RightVector)

            pulse(p41, "RearSlide", v216, v217 * (1 / (1 / root.AssemblyMass + math.max(0, v218:Dot(inverseInertia(root, v218))))), 0.18)
            t6.seeded = true
        end
    end

    local t7 = {}

    local function done() -- line: 343
        -- upvalues: p41 (copy), root (copy), t6 (copy), t7 (copy)
        for _, v220 in t7 do
            v220:Disconnect()
        end

        table.clear(t7)

        for _, child in root:GetChildren() do
            if child.Name:sub(1, 10) == "LossForce_" or child.Name:sub(1, 12) == "LossContact_" or child.Name == "LossYawDamping" then
                child:Destroy()
            end
        end

        if p41.loss and p41.loss.physics == t6 then
            p41.loss = nil
        end
    end

    t6.cleanup = done
    table.insert(t7, root:GetAttributeChangedSignal("LossStage"):Connect(function() -- line: 350
        -- upvalues: root (copy), done (copy)
        if (root:GetAttribute("LossStage") or "") == "" then
            done()
        end
    end))
    table.insert(t7, root.AncestryChanged:Connect(function() -- line: 351
        -- upvalues: root (copy), done (copy)
        if not root:IsDescendantOf(workspace) then
            done()
        end
    end))

    local rootParent = root.Parent

    if not rootParent then
        return
    end

    table.insert(t7, rootParent:GetAttributeChangedSignal("Crash"):Connect(function() -- line: 353
        -- upvalues: done (copy), rootParent (copy)
        if (rootParent:GetAttribute("Crash") or "") ~= "" then
            done()
        end
    end))
end

function t1.Observe(p46, _) -- line: 357
    -- upvalues: HighsideTuning (copy), HighsideTuning2 (copy), t1 (copy)
    local root = p46.root
    local v224 = p46.loss and p46.loss.physics

    if not v224 then
        return
    end

    local v225 = workspace:GetServerTimeNow() - (root:GetAttribute("LossStarted") or 0)
    local v226 = math.atan2(root.CFrame.RightVector.Y, root.CFrame.UpVector.Y)
    local v227, initialHeading

    if v224.spinOut and not v224.spinDone then
        local LookVector = root.CFrame.LookVector

        v227 = math.atan2(-LookVector.X, -LookVector.Z)
        initialHeading = v224.initialHeading or root:GetAttribute("LossInitialHeading") or v227

        local v235 = math.abs((math.atan2(math.sin(v227 - initialHeading), (math.cos(v227 - initialHeading)))))
        local SpinMaxTurn = HighsideTuning:GetAttribute("SpinMaxTurn")

        if type(SpinMaxTurn) ~= "number" or not SpinMaxTurn then
            SpinMaxTurn = HighsideTuning2.SpinMaxTurn
        end

        if (SpinMaxTurn or 1.0471975511965976) <= v235 then
            v224.spinDone = true
        end
    end

    if v224.spinOut then
        local v236, v237

        if math.abs(v226) > 1.3089969389957472 then
            local SpinMinTime = HighsideTuning:GetAttribute("SpinMinTime")

            if (type(SpinMinTime) == "number" and SpinMinTime or HighsideTuning2.SpinMinTime or 0) < v225 then
                v236 = true
                v237 = true
            else
                v237 = false
            end
        else
            v237 = false
        end

        if not v237 then
            local SpinRelease = HighsideTuning:GetAttribute("SpinRelease")

            if type(SpinRelease) ~= "number" or not SpinRelease then
                SpinRelease = HighsideTuning2.SpinRelease
            end

            v236 = SpinRelease < v225
        end

        v224.ready = v236
    elseif math.abs(v226) > 1.1344640137963142 then
        v224.ready = true
    else
        v224.ready = v225 > 0.4
    end

    local v238 = true

    if t1.RiderGrounded(p46) then
        if v224.spinOut then
            local SpinGroundedAfter = HighsideTuning:GetAttribute("SpinGroundedAfter")

            v238 = v225 < (type(SpinGroundedAfter) == "number" and SpinGroundedAfter or HighsideTuning2.SpinGroundedAfter or 0)
        else
            v238 = false
        end
    end

    if not v238 then
        v224.ready = true
    end

    root:SetAttribute("CrashReleaseReady", v224.ready == true)
end

function t1.Step(p48, p49, p50) -- line: 377
    -- upvalues: Config (copy), HighsideTuning (copy), HighsideTuning2 (copy), t1 (copy), v2 (copy), contact (copy), inverseInertia (copy), contactForce (copy), wheelSupport (copy), tyre (copy)
    local root = p48.root
    local v239 = p48.loss and p48.loss.physics
    local AssemblyLinearVelocity = root.AssemblyLinearVelocity
    local Front, Front2, _, Front3 = contact(p48, "Front")
    local Rear, Rear2, v240, Rear3 = contact(p48, "Rear")

    v240 = workspace:GetServerTimeNow() - (root:GetAttribute("LossStarted") or 0)

    local Y = root.CFrame.RightVector.Y
    local v241 = root.CFrame.UpVector.Y
    local v242 = math.atan2(Y, v241)
    local v243, Unit

    if p50 and v239 then
        local v244 = math.min(p49, 0.05)

        p48.align.Enabled = false
        p48.force.Enabled = false
        p48.force.Force = Vector3.new(0, 0, 0)

        local contactRatio

        for _, v245 in { "Front", "Rear", "SupportFront", "SupportRear", "Handoff" } do
            contactRatio = root:FindFirstChild("LossForce_" .. v245)

            if contactRatio then
                contactRatio.Force = Vector3.new(0, 0, 0)
            end
        end

        local RightVector = root.CFrame.RightVector
        local v246 = if Rear then root:GetVelocityAtPosition(Rear):Dot(RightVector) else nil

        if not Rear or not v246 then
            v246 = 0
        end

        v241 = math.max(8, (math.abs((AssemblyLinearVelocity:Dot(root.CFrame.LookVector)))))

        local v248 = math.atan2(math.abs(v246), v241)

        contactRatio = v239.peakSlip or 0
        v239.peakSlip = math.max(contactRatio, v248)

        local v249

        if Rear then
            contactRatio = root:GetVelocityAtPosition(Rear):Dot(root.CFrame.LookVector)
            v249 = math.abs(contactRatio)
        end

        if Rear and v249 then
            v241 = v249
        end

        contactRatio = v239.rearWheelSpeed

        local SlipRecoveryLength, v250

        if not contactRatio then
            SlipRecoveryLength = p48.tractionSlip or 0
            v250 = p48.exitSlip or 0
            contactRatio = v241 * (math.max(SlipRecoveryLength, v250, 0.05) + 1)
        end

        v239.rearWheelSpeed = contactRatio

        local v251 = (v239.rearWheelSpeed - v241) / math.max(v241, 3)

        SlipRecoveryLength = HighsideTuning:GetAttribute("SlipRecoveryLength")

        if type(SlipRecoveryLength) ~= "number" or not SlipRecoveryLength then
            SlipRecoveryLength = HighsideTuning2.SlipRecoveryLength
        end

        local v252 = SlipRecoveryLength / math.max(v241, 3)

        contactRatio = math.max(v252, 0.02)

        local v253 = v239.contactRatio or v251

        v250 = v251 - (v239.contactRatio or v251)

        local v254 = -v244 / contactRatio

        v239.contactRatio = v253 + v250 * (1 - math.exp(v254))
        contactRatio = v239.contactRatio

        local function surfaceScale(p51, p52) -- line: 402
            -- upvalues: v2 (copy)
            if not p51 then
                return 0
            end

            local v255 = workspace:Raycast(p51 + p52 * 0.2, -p52 * 0.5, v2)
            local v256, v257

            if v255 then
                local Surface = v255.Instance:GetAttribute("Surface")

                if v255.Instance == workspace.Terrain then
                    v256 = if v255.Material == Enum.Material.Sand then "Gravel" elseif v255.Material == Enum.Material.Grass then "Grass" else Surface
                    v257 = v256
                else
                    v257 = Surface
                end
            else
                v257 = v255
            end

            if v257 == "Grass" then
                return 0.35
            end

            if v257 == "Gravel" then
                return 0.45
            end

            if v257 == "Wet" then
                return 0.55
            end

            return 1
        end

        local v258 = if Front then wheelSupport(p48, "Front", Front, Front2, Front3, v244, 0.48) else nil

        if not Front or not v258 then
            v258 = 0
        end

        local v259 = if Rear then wheelSupport(p48, "Rear", Rear, Rear2, Rear3, v244, 0.52) else nil

        if not Rear or not v259 then
            v259 = 0
        end

        local v260, v261, v262, v263

        if not v239.spinOut or v239.spinDone then
            v263 = true
        else
            v261 = root.CFrame.LookVector
            v262 = -v261.X
            v254 = -v261.Z
            v260 = math.atan2(v262, v254)
            v261 = v239.initialHeading or root:GetAttribute("LossInitialHeading") or v260
            v263 = false
        end

        local DryGrip, v264, DryGrip2

        if not v263 then
            DryGrip2 = v260 - v261
            DryGrip = math.sin(DryGrip2)
            v264 = v260 - v261
            DryGrip2 = math.cos(v264)
            v254 = math.atan2(DryGrip, DryGrip2)
            v262 = math.abs(v254)
            DryGrip2 = HighsideTuning:GetAttribute("SpinMaxTurn")

            if type(DryGrip2) ~= "number" or not DryGrip2 then
                DryGrip2 = HighsideTuning2.SpinMaxTurn
            end

            if (DryGrip2 or 1.0471975511965976) <= v262 then
                v239.spinDone = true
            end
        end

        v261 = v239.spinOut and not v239.spinDone
        v260 = if v261 then v239.spinF or 1 else 0
        DryGrip = HighsideTuning:GetAttribute("DryGrip")

        if type(DryGrip) ~= "number" or not DryGrip then
            DryGrip = HighsideTuning2.DryGrip
        end

        local SpinFrontGrip, v265, v266

        if v239.kind == "LOWSIDE" then
            SpinFrontGrip = HighsideTuning:GetAttribute("SpinFrontGrip")

            local v267 = 0.35 + ((type(SpinFrontGrip) == "number" and SpinFrontGrip or HighsideTuning2.SpinFrontGrip or 1) - 0.35) * v260

            if v267 then
                v265 = v267
                v266 = true
            else
                v266 = false
            end
        else
            v266 = false
        end

        if not v266 then
            v265 = 1
        end

        v262 = DryGrip * v265

        local v268, v269

        if v239.spinOut then
            v254 = v239.spinF or 1

            if v239.spinDone then
                DryGrip2 = HighsideTuning:GetAttribute("SpinEndRearKeep")
                DryGrip2 = type(DryGrip2) == "number" and DryGrip2 or HighsideTuning2.SpinEndRearKeep or 1
            else
                DryGrip2 = 1
            end

            v260 = v254 * DryGrip2

            if v260 then
                v268 = v260
                v269 = true
            else
                v269 = false
            end
        else
            v269 = false
        end

        if not v269 then
            v268 = 0
        end

        DryGrip2 = HighsideTuning:GetAttribute("DryGrip")

        if type(DryGrip2) ~= "number" or not DryGrip2 then
            DryGrip2 = HighsideTuning2.DryGrip
        end

        local SpinRearLoss = HighsideTuning:GetAttribute("SpinRearLoss")

        if type(SpinRearLoss) ~= "number" or not SpinRearLoss then
            SpinRearLoss = HighsideTuning2.SpinRearLoss
        end

        v254 = DryGrip2 * (1 - (SpinRearLoss or 0) * v268)

        local v270, v271, SideFadeFrom, v272

        if v239.kind == "LOWSIDE" then
            v271 = math.abs(v242)
            SideFadeFrom = HighsideTuning:GetAttribute("SideFadeFrom")
            DryGrip2 = type(SideFadeFrom) == "number" and SideFadeFrom or HighsideTuning2.SideFadeFrom or 1.0821041362364843
            SideFadeFrom = HighsideTuning:GetAttribute("SideFadeTo")

            if type(SideFadeFrom) ~= "number" or not SideFadeFrom then
                SideFadeFrom = HighsideTuning2.SideFadeTo
            end

            v264 = SideFadeFrom or 1.3962634015954636
            SpinRearLoss = v271 - DryGrip2
            v270 = v264 - DryGrip2
            SideFadeFrom = SpinRearLoss / math.max(v270, 0.001)

            local v273 = math.clamp(SideFadeFrom, 0, 1)

            v272 = 1 - v273 * v273 * (3 - v273 * 2)
        else
            v272 = 1
        end

        v262 *= v272
        v254 *= v272

        local Unit2, Unit3, v274, v275, v276

        if Front then
            DryGrip2 = root.CFrame.LookVector - Front2 * root.CFrame.LookVector:Dot(Front2)

            if DryGrip2.Magnitude > 0.01 and v258 > 1 then
                Unit2 = DryGrip2.Unit
                Unit3 = Unit2:Cross(Front2).Unit
                v274 = Rear and (Front + Rear) * 0.5 or Front
                v276 = false
            else
                v275 = 0
                v276 = true
            end
        else
            v275 = 0
            v276 = true
        end

        local v277, v278, v279, v280

        if not v276 then
            SideFadeFrom = root.AssemblyCenterOfMass - v274
            SpinRearLoss = root.AssemblyMass * Config.Gravity * SideFadeFrom:Dot(Unit3)
            v270 = SideFadeFrom:Dot(Front2)
            SpinRearLoss = SpinRearLoss / math.max(v270, 0.4) - (v239.lastFySigned or 0)

            local LowsideHold, v281

            if v239.kind == "LOWSIDE" then
                LowsideHold = HighsideTuning:GetAttribute("LowsideHold")
                LowsideHold = type(LowsideHold) == "number" and LowsideHold or HighsideTuning2.LowsideHold
                v281 = false
            else
                v281 = true
            end

            SideFadeFrom = SpinRearLoss * (not v281 and LowsideHold or 1)
            v274 = v258 * v262 * surfaceScale(Front, Front2)
            SpinFrontGrip = SideFadeFrom / math.max(v274, 1)
            SpinRearLoss = math.clamp(SpinFrontGrip, -0.96, 0.96)
            LowsideHold = v274 * 0.6366197723675814
            v277 = math.abs(SpinRearLoss)
            LowsideHold = -(LowsideHold * math.asin(v277) * math.sign(SpinRearLoss)) / v258
            v278 = HighsideTuning:GetAttribute("CamberThrust")

            if type(v278) ~= "number" or not v278 then
                v278 = HighsideTuning2.CamberThrust
            end

            SpinFrontGrip = LowsideHold - v278 * math.sin(v242)
            v275 = HighsideTuning:GetAttribute("CorneringStiffness")

            if type(v275) ~= "number" or not v275 then
                v275 = HighsideTuning2.CorneringStiffness
            end

            SpinRearLoss = SpinFrontGrip / v275
            SpinFrontGrip = root:GetVelocityAtPosition(Front)
            LowsideHold = SpinFrontGrip:Dot(Unit3)
            v278 = SpinFrontGrip:Dot(Unit2)
            v277 = math.abs(v278)
            v275 = math.max(v277, 3)
            v275 = SpinRearLoss - math.atan2(LowsideHold, v275)
            LowsideHold = math.clamp(v275, -0.35, 0.35)
            v275 = v239.frontSteer or LowsideHold
            v278 = LowsideHold - (v239.frontSteer or LowsideHold)
            v279 = -v244

            local SteeringResponse = HighsideTuning:GetAttribute("SteeringResponse")

            if type(SteeringResponse) ~= "number" or not SteeringResponse then
                SteeringResponse = HighsideTuning2.SteeringResponse
            end

            v280 = v279 / math.max(SteeringResponse, 0.02)
            v239.frontSteer = v275 + v278 * (1 - math.exp(v280))
            LowsideHold, v275 = tyre(p48, "Front", Front, Front2, v262 * surfaceScale(Front, Front2), v244, v258, 0, v242, v239.frontSteer)
            root:SetAttribute("CrashSteerAngle", v239.frontSteer)
        end

        local v282, v283, v284, v285, v286, TCSlip, v287, TCSlip2

        if Rear then
            Unit2, v282, v283, v284 = tyre(p48, "Rear", Rear, Rear2, v254 * surfaceScale(Rear, Rear2), v244, v259, contactRatio, v242)
            v239.lastFySigned = v284
            v239.totalLongitudinalForce = v282 + v275
            v286 = p48.throttle or 0
            v285 = math.clamp(v286, 0, 1)

            if os.clock() - (p48.lastInput or os.clock()) > 0.5 then
                v285 = 0
            end

            if v239.spinDone then
                v285 = 0
            end

            v286 = math.round(p48.tcs or Config.TCS)
            SpinRearLoss = math.clamp(v286, 1, 5)
            v278 = if SpinRearLoss == 1 then 0 else SpinRearLoss - 1
            v286 = math.clamp((v278 + 0.25 - 1) / 4, 0, 1)
            v275 = HighsideTuning:GetAttribute("TCStrength")

            if type(v275) ~= "number" or not v275 then
                v275 = HighsideTuning2.TCStrength
            end

            SpinRearLoss = v286 * v275
            v277 = math.abs(v251)
            TCSlip = HighsideTuning:GetAttribute("TCSlip")

            if type(TCSlip) ~= "number" or not TCSlip then
                TCSlip = HighsideTuning2.TCSlip
            end

            v275 = v277 - TCSlip
            TCSlip = HighsideTuning:GetAttribute("TCSlip")

            if type(TCSlip) ~= "number" or not TCSlip then
                TCSlip = HighsideTuning2.TCSlip
            end

            Unit2 = math.clamp(v275 / math.max(TCSlip, 0.05), 0, 1) * SpinRearLoss
            v275 = root.AssemblyMass * Config.Gravity
            v278 = HighsideTuning:GetAttribute("DriveAccelerationG")

            if type(v278) ~= "number" or not v278 then
                v278 = HighsideTuning2.DriveAccelerationG
            end

            SpinRearLoss = v275 * v278 * v285 * (1 - Unit2)

            local v288 = root.AssemblyMass * Config.Gravity

            v277 = HighsideTuning:GetAttribute("EngineBrakeG")

            if type(v277) ~= "number" or not v277 then
                v277 = HighsideTuning2.EngineBrakeG
            end

            Unit2 = v288 * v277 * (1 - v285)
            v275 = root.AssemblyMass
            v278 = HighsideTuning:GetAttribute("WheelInertiaShare")

            if type(v278) ~= "number" or not v278 then
                v278 = HighsideTuning2.WheelInertiaShare
            end

            v286 = math.max(v275 * v278, 0.1)
            v277 = v239.rearWheelSpeed + (SpinRearLoss - v282 - Unit2) / v286 * v244
            v239.rearWheelSpeed = math.max(0, v277)

            if v239.lastRatio then
                v287 = math.abs(contactRatio)
                TCSlip2 = HighsideTuning:GetAttribute("TCSlip")
                TCSlip2 = type(TCSlip2) == "number" and TCSlip2 or HighsideTuning2.TCSlip

                if v287 < TCSlip2 then
                    v287 = math.abs(contactRatio)
                    TCSlip2 = v239.lastRatio

                    if v287 < math.abs(TCSlip2) and math.abs(v284) > (v239.lastFy or 0) and v239.peakSlip > 0.08726646259971647 and not v239.caughtAt then
                        v239.caughtAt = workspace:GetServerTimeNow()
                        root:SetAttribute("HighsideCaught", true)
                        root:SetAttribute("HighsideCatch", v240)
                    end
                end
            end

            v239.lastRatio = contactRatio
            v239.lastFy = math.abs(v284)
            root:SetAttribute("CrashRearSlipRatio", contactRatio)
            root:SetAttribute("CrashRearLateralForce", v284)
            root:SetAttribute("CrashRearDemand", v283)
            root:SetAttribute("CrashThrottle", v285)
        end

        local v289

        if Rear and (v239.kind == "HIGHSIDE" and not v239.gripCatch or v239.spinOut and not v239.spinDone) then
            v271 = root.CFrame.LookVector
            v282 = -v271.X
            v283 = -v271.Z
            Unit2 = math.atan2(v282, v283)
            v252 = v239.initialHeading or root:GetAttribute("LossInitialHeading") or Unit2
            v283 = Unit2 - v252
            v282 = math.sin(v283)
            v284 = Unit2 - v252
            v283 = math.cos(v284)
            Unit2 = math.atan2(v282, v283)
            v262 = (v239.initialRearYaw or 0) - Unit2

            if v262 * (v239.initialRearYaw or 0) > 0 then
                v243 = math.tan(v262) * v241
                v289 = root:GetVelocityAtPosition(Rear):Dot(Rear2:Cross(-v271).Unit)

                local SpinHandoffCap

                if not v239.spinOut or v239.spinDone then
                    SpinHandoffCap = 0.45
                else
                    SpinHandoffCap = HighsideTuning:GetAttribute("SpinHandoffCap")
                    SpinHandoffCap = type(SpinHandoffCap) == "number" and SpinHandoffCap or HighsideTuning2.SpinHandoffCap or 0.45
                end

                v285 = v243 - v289
                v275 = (Rear - root.AssemblyCenterOfMass):Cross(RightVector)
                v284 = v285 * (1 / (1 / root.AssemblyMass + math.max(0, v275:Dot(inverseInertia(root, v275)))))
                v287 = HighsideTuning:GetAttribute("HandoffResponse")

                if type(v287) ~= "number" or not v287 then
                    v287 = HighsideTuning2.HandoffResponse
                end

                v283 = v284 / math.max(v287, 0.05)
                v284 = -v259 * SpinHandoffCap * v272
                v285 = v259 * SpinHandoffCap * v272
                SpinHandoffCap = math.clamp(v283, v284, v285)
                v289 = Rear + Rear2 * (root.AssemblyCenterOfMass - Rear):Dot(Rear2)
                v243 = v271:Cross(Rear2).Unit
                contactForce(p48, "Handoff", v289, v243 * SpinHandoffCap)
            end

            root:SetAttribute("PhysicalRearYaw", Unit2)
        end

        root:SetAttribute("CrashFrontLoad", v258)
        root:SetAttribute("CrashRearLoad", v259)
        v239.lastRearVelocity = v246
        v284 = if v239.kind ~= "HIGHSIDE" then "Lowside" elseif v239.caughtAt then "CatchSnap" else "RearSlide"
        root:SetAttribute("HighsidePhase", v284)
        root:SetAttribute("CrashYawRate", root.AssemblyAngularVelocity.Y)
        root:SetAttribute("CrashRollRate", -root.AssemblyAngularVelocity:Dot(root.CFrame.LookVector))
        v289 = root:FindFirstChild("LossYawDamping")

        if not v289 then
            Unit2 = Instance.new("Attachment")
            Unit2.Name = "LossContact_Yaw"
            Unit2.Parent = root
            v289 = Instance.new("Torque")
            v289.Name = "LossYawDamping"
            v289.Attachment0 = Unit2
            v289.RelativeTo = Enum.ActuatorRelativeTo.World
            v289.Parent = root
        end

        local v290

        if Front and Rear then
            Unit = (Front2 + Rear2).Unit
            RightVector = p48.bike:FindFirstChild("CrashMass") or root
            v290 = root.AssemblyMass * (RightVector.Size.X ^ 2 + RightVector.Size.Z ^ 2) / 12

            local v291 = root.AssemblyMass * Config.Gravity * Config.Wheelbase
            local YawMomentLimit = HighsideTuning:GetAttribute("YawMomentLimit")

            RightVector = v291 * (type(YawMomentLimit) == "number" and YawMomentLimit or HighsideTuning2.YawMomentLimit)
            v283 = -Unit
            v286 = root.AssemblyAngularVelocity:Dot(Unit) * v290
            v278 = HighsideTuning:GetAttribute("YawDamping")

            if type(v278) ~= "number" or not v278 then
                v278 = HighsideTuning2.YawDamping
            end

            local SpinYawFree = HighsideTuning:GetAttribute("SpinYawFree")

            if type(SpinYawFree) ~= "number" or not SpinYawFree then
                SpinYawFree = HighsideTuning2.SpinYawFree
            end

            v280 = (SpinYawFree or 1) - 1
            v279 = if v261 then v239.spinF or 1 else 0
            v275 = v278 * (1 + v280 * v279)
            v285 = v286 / math.max(v275, 0.05)
            v286 = -RightVector
            v289.Torque = v283 * math.clamp(v285, v286, RightVector)
        else
            v289.Torque = Vector3.new(0, 0, 0)
        end

        v290 = root:FindFirstChild("LossForce_RollGuard")

        if not v290 then
            v289 = Instance.new("Attachment")
            v289.Name = "LossContact_Roll"
            v289.Parent = root
            v290 = Instance.new("Torque")
            v290.Name = "LossForce_RollGuard"
            v290.Attachment0 = v289
            v290.RelativeTo = Enum.ActuatorRelativeTo.World
            v290.Parent = root
        end

        local frontSteer, LookVector, v292, v293, v294

        if v239.kind == "LOWSIDE" then
            LookVector = root.CFrame.LookVector

            local v295 = root.AssemblyAngularVelocity:Dot(LookVector) * v239.side
            local LowsideRollGuardRate = HighsideTuning:GetAttribute("LowsideRollGuardRate")

            LowsideRollGuardRate = type(LowsideRollGuardRate) == "number" and LowsideRollGuardRate or HighsideTuning2.LowsideRollGuardRate

            local RollGuardRate, v296

            if LowsideRollGuardRate then
                v296 = LowsideRollGuardRate
            else
                RollGuardRate = HighsideTuning:GetAttribute("RollGuardRate")
                v296 = type(RollGuardRate) == "number" and RollGuardRate or HighsideTuning2.RollGuardRate or 0.5
            end

            v286 = HighsideTuning:GetAttribute("SpinFallRate")

            if type(v286) ~= "number" or not v286 then
                v286 = HighsideTuning2.SpinFallRate
            end

            RollGuardRate = v286 or 1.2
            v285 = if v296 < v295 then v295 - v296
                elseif not v239.spinOut or v239.spinDone then 0
                elseif v295 < -RollGuardRate then v295 + RollGuardRate
                else 0

            if v285 == 0 then
                v290.Torque = Vector3.new(0, 0, 0)
            else
                v292 = p48.bike:FindFirstChild("CrashMass") or root
                v296 = root.AssemblyMass * (v292.Size.X ^ 2 + v292.Size.Y ^ 2) / 12
                v292 = root.AssemblyMass * Config.Gravity * Config.Wheelbase
                v293 = -LookVector * v239.side
                v294 = v285 * v296

                local RollGuardTau = HighsideTuning:GetAttribute("RollGuardTau")

                frontSteer = type(RollGuardTau) == "number" and RollGuardTau or HighsideTuning2.RollGuardTau or 0.08
                TCSlip2 = v294 / math.max(frontSteer, 0.02)
                v294 = -v292
                v290.Torque = v293 * math.clamp(TCSlip2, v294, v292)
            end
        else
            v290.Torque = Vector3.new(0, 0, 0)
        end

        for v297, v298 in v239.pulses or {} do
            v298.age += v244

            if not (v298.age < 0) then
                v293 = v298.age / v298.duration
                v286 = math.clamp(v293, 0, 1)
                v286 = v286 * 6 * (1 - v286)
                contactForce(p48, v297, root.CFrame:PointToWorldSpace(v298.point), v298.impulse * (v286 / v298.duration))

                if v298.age >= v298.duration then
                    root["LossForce_" .. v297].Force = Vector3.new(0, 0, 0)
                    v239.pulses[v297] = nil
                end
            end
        end

        LookVector = p48.rider and p48.rider.Parent:FindFirstChild("HumanoidRootPart")

        local VelocityAtPosition = LookVector and root:GetVelocityAtPosition(LookVector.Position) or AssemblyLinearVelocity

        if v239.caughtAt then
            LookVector = workspace:GetServerTimeNow() - v239.caughtAt
        end

        if v242 * v239.side < 0 and root.CFrame.UpVector.Y > 0.15 then
        end

        if v239.pitchFall then
            v285 = root.CFrame.LookVector.Y
            v292 = math.clamp(v285, -1, 1)

            if math.abs((math.asin(v292))) > 1.4486232791552935 or root.CFrame.UpVector.Y < 0.15 then
                v239.ready = true
            else
                v239.ready = v240 > 0.8
            end
        elseif v239.kind == "HIGHSIDE" then
            if v239.peakSlip > 0.08726646259971647 and VelocityAtPosition.Y > 5 then
                v239.ready = -root.AssemblyAngularVelocity:Dot(root.CFrame.LookVector) * v239.side < -1
            else
                v239.ready = false
            end
        elseif v239.spinOut then
            local v300, v301

            if math.abs(v242) > 1.3089969389957472 then
                v286 = HighsideTuning:GetAttribute("SpinMinTime")

                if (type(v286) == "number" and v286 or HighsideTuning2.SpinMinTime or 0) < v240 then
                    v300 = true
                    v301 = true
                else
                    v301 = false
                end
            else
                v301 = false
            end

            if not v301 then
                v285 = HighsideTuning:GetAttribute("SpinRelease")

                if type(v285) ~= "number" or not v285 then
                    v285 = HighsideTuning2.SpinRelease
                end

                v300 = v285 < v240
            end

            v239.ready = v300
        elseif math.abs(v242) > 1.1344640137963142 then
            v239.ready = true
        else
            v239.ready = v240 > 0.4
        end

        local v302 = true

        if t1.RiderGrounded(p48) then
            if v239.spinOut then
                v285 = HighsideTuning:GetAttribute("SpinGroundedAfter")
                v302 = v240 < (type(v285) == "number" and v285 or HighsideTuning2.SpinGroundedAfter or 0)
            else
                v302 = false
            end
        end

        if not v302 then
            v239.ready = true
        end

        local LookVector2

        if v239.kind == "LOWSIDE" then
            LookVector2 = root.CFrame.LookVector

            local AssemblyAngularVelocity = root.AssemblyAngularVelocity
            local v303 = AssemblyAngularVelocity:Dot(LookVector2) * v239.side
            local RollGuardHard = HighsideTuning:GetAttribute("RollGuardHard")

            v286 = type(RollGuardHard) == "number" and RollGuardHard or HighsideTuning2.RollGuardHard or 1.5

            if v286 < v303 then
                AssemblyAngularVelocity -= LookVector2 * v239.side * (v303 - v286)
                v293 = true
            else
                v293 = false
            end

            RollGuardHard = if v261 then "SpinMaxYawRate" else "LowsideMaxYawRate"
            TCSlip2 = HighsideTuning:GetAttribute(RollGuardHard)

            if type(TCSlip2) ~= "number" or not TCSlip2 then
                TCSlip2 = HighsideTuning2[RollGuardHard]
            end

            if TCSlip2 then
                v277 = AssemblyAngularVelocity.Y

                if TCSlip2 < math.abs(v277) then
                    v277 = AssemblyAngularVelocity.X
                    frontSteer = AssemblyAngularVelocity.Y
                    v294 = math.sign(frontSteer) * TCSlip2
                    TCSlip = AssemblyAngularVelocity.Z
                    AssemblyAngularVelocity = Vector3.new(v277, v294, TCSlip)
                    v293 = true
                end
            end

            local v304 = v293
            local v305 = AssemblyAngularVelocity

            if v239.spinOut and v239.spinDone then
                local SpinEndYawDecay = HighsideTuning:GetAttribute("SpinEndYawDecay")

                if (type(SpinEndYawDecay) == "number" and SpinEndYawDecay or HighsideTuning2.SpinEndYawDecay or 0) > 0 then
                    local v306 = Vector3.new(0, 1, 0) * AssemblyAngularVelocity.Y
                    local v307 = -v244
                    local SpinEndYawDecay = HighsideTuning:GetAttribute("SpinEndYawDecay")

                    frontSteer = v307 * (type(SpinEndYawDecay) == "number" and SpinEndYawDecay or HighsideTuning2.SpinEndYawDecay)
                    v305 = AssemblyAngularVelocity - v306 * (1 - math.exp(frontSteer))
                    v304 = true
                end
            end

            if v304 then
                root.AssemblyAngularVelocity = v305
            end
        end

        v261 = root.AssemblyAngularVelocity

        if v261.Magnitude > 32 then
            root.AssemblyAngularVelocity = v261.Unit * 32
        end

        if v239.kind == "LOWSIDE" then
            LookVector2 = require(script.Parent.CrashTopple)
            LookVector2.LimitLowside(root, LookVector2.StartSpeed(root))

            if LookVector2.GuardSlide then
                LookVector2.GuardSlide(root, v244)
            end
        end

        root:SetAttribute("CrashRearVelocity", v246)
        root:SetAttribute("CrashShear", v239.shear)
        root:SetAttribute("CrashRearSlip", v248)
        root:SetAttribute("CrashGrip", v254)
        root:SetAttribute("CrashRiderPointY", VelocityAtPosition.Y)
        root:SetAttribute("CrashReleaseReady", v239.ready == true)
    end

    p48.lean = v242
    p48.rearYaw = 0
    v242 = {
        frontExcess = 0,
        lateral = 0,
        throttle = 0,
        brake = 0,
        rearBrake = 0,
        rearYaw = 0,
        rpm = 3000,
        speed = AssemblyLinearVelocity.Magnitude
    }
    v242.kph = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude * Config.StudMetres * 3.6
    v242.velocity = AssemblyLinearVelocity

    if Front ~= nil then
        v242.onGround = true
    else
        v242.onGround = Rear ~= nil
    end

    if Front or Rear then
        v242.surface = p48.surface or "Asphalt"
    else
        v242.surface = "Air"
    end

    v242.oldSlip = p48.slip or 0

    return v242
end

function t1.RiderMotion(p53, p54) -- line: 627
    local root = p53.root

    return root:GetVelocityAtPosition(p54), root.AssemblyAngularVelocity
end

function t1.Release(p55) -- line: 631
    p55.root:SetAttribute("LossOwnerPhysics", nil)

    for _, child in p55.root:GetChildren() do
        if child.Name:sub(1, 10) == "LossForce_" or child.Name:sub(1, 12) == "LossContact_" or child.Name == "LossYawDamping" then
            child:Destroy()
        end
    end

    p55.align.Enabled = false
    p55.force.Enabled = false
    p55.force.Force = Vector3.new(0, 0, 0)

    return p55.root.AssemblyLinearVelocity, p55.root.AssemblyAngularVelocity
end

return require(script.Parent:WaitForChild("OwnerFeatures14")).Wrap(t1, script.Parent, "Pre14_BikeCrashPhysics")
