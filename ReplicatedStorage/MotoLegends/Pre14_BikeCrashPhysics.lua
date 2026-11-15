-- https://lua.expert

local v1

local function __raceRC() -- line: 6
    -- upvalues: v1 (ref)
    if not (v1 and v1.Parent) then
        v1 = workspace:FindFirstChild("RaceCollision", true)
    end

    return v1
end

local Config = require(script.Parent.Config)
local HighsideTuning = script.Parent:WaitForChild("HighsideTuning")
local HighsideTuning2 = require(HighsideTuning)

local function tune(p1) -- line: 11
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

local function contact(p2, p3) -- line: 17
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

local function inverseInertia(p4, p5) -- line: 37
    local v16 = p4.Parent:FindFirstChild("CrashMass") or p4
    local Size = v16.Size
    local AssemblyMass = p4.AssemblyMass
    local v17 = v16.CFrame:VectorToObjectSpace(p5)
    local v21 = Vector3.new(Size.Y ^ 2 + Size.Z ^ 2, Size.X ^ 2 + Size.Z ^ 2, Size.X ^ 2 + Size.Y ^ 2) * AssemblyMass / 12

    return v16.CFrame:VectorToWorldSpace((Vector3.new(v17.X / math.max(v21.X, 0.01), v17.Y / math.max(v21.Y, 0.01), v17.Z / math.max(v21.Z, 0.01))))
end

local function contactMass(p6, p7, p8) -- line: 44
    -- upvalues: inverseInertia (copy)
    local v25 = (p7 - p6.AssemblyCenterOfMass):Cross(p8)

    return 1 / (1 / p6.AssemblyMass + math.max(0, v25:Dot(inverseInertia(p6, v25))))
end

local function contactForce(p9, p10, p11, p12) -- line: 51
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

local function pulse(p13, p14, p15, p16, p17) -- line: 62
    local physics = p13.loss.physics

    physics.pulses = physics.pulses or {}
    physics.pulses[p14] = {
        age = 0,
        point = p13.root.CFrame:PointToObjectSpace(p15),
        impulse = p16,
        duration = p17
    }
end

local function wheelSupport(p18, p19, p20, p21, _, p23, p24) -- line: 67
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

local function tyre(p25, p26, p27, p28, p29, p30, p31, p32, p33, p34) -- line: 87
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

function t1.RiderGrounded(p35) -- line: 120
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

function t1.Begin(p36, p37) -- line: 143
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
        initialRearYaw = p36.rearYaw or 0
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

    local function v112() -- line: 195
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

    local function sramp(p38, p39, p40) -- line: 217
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

    local Rear3, RightVector2, v153

    if v152 then
        local Rear

        Rear3, Rear = contact(p36, "Rear")

        if Rear3 then
            RightVector2 = CFrame.Angles(0, p36.yaw, 0).RightVector

            local v154 = RightVector2 - Rear * RightVector2:Dot(Rear)

            if v154.Magnitude > 0.01 then
                RightVector2 = v154.Unit
            end

            v153 = false
        else
            v153 = true
        end
    else
        v153 = true
    end

    if v153 then
        return
    end

    local v157 = math.abs((math.tan(p36.rearYaw or 0))) * Magnitude
    local v158 = (Rear3 - root.AssemblyCenterOfMass):Cross(RightVector2)
    local v159 = 1 / (1 / root.AssemblyMass + math.max(0, v158:Dot(inverseInertia(root, v158))))
    local DryGrip = HighsideTuning:GetAttribute("DryGrip")

    if type(DryGrip) ~= "number" or not DryGrip then
        DryGrip = HighsideTuning2.DryGrip
    end

    local CatchSpike = HighsideTuning:GetAttribute("CatchSpike")

    if type(CatchSpike) ~= "number" or not CatchSpike then
        CatchSpike = HighsideTuning2.CatchSpike
    end

    local v160 = DryGrip * CatchSpike * root.AssemblyMass * Config.Gravity * 0.52
    local CatchSeconds = HighsideTuning:GetAttribute("CatchSeconds")

    if type(CatchSeconds) ~= "number" or not CatchSeconds then
        CatchSeconds = HighsideTuning2.CatchSeconds
    end

    local v161 = v160 * CatchSeconds
    local v163 = math.min(v159 * v157, v161)
    local v165 = math.abs((inverseInertia(root, (Rear3 - root.AssemblyCenterOfMass):Cross(-RightVector2 * v96)):Dot(root.CFrame.LookVector)))

    if v165 > 1E-06 then
        local CatchMaxRoll = HighsideTuning:GetAttribute("CatchMaxRoll")

        v163 = math.min(v163, (type(CatchMaxRoll) == "number" and CatchMaxRoll or HighsideTuning2.CatchMaxRoll) / v165)
    end

    local v167 = -RightVector2 * v96 * v163
    local CatchSeconds2 = HighsideTuning:GetAttribute("CatchSeconds")

    if type(CatchSeconds2) ~= "number" or not CatchSeconds2 then
        CatchSeconds2 = HighsideTuning2.CatchSeconds
    end

    pulse(p36, "RearCatch", Rear3, v167, CatchSeconds2)

    local RearCatch = t5.pulses.RearCatch
    local CatchDelay = HighsideTuning:GetAttribute("CatchDelay")

    if type(CatchDelay) ~= "number" or not CatchDelay then
        CatchDelay = HighsideTuning2.CatchDelay
    end

    RearCatch.age = -CatchDelay
    root:SetAttribute("HighsideCatchImpulse", v163 / math.max(root.AssemblyMass, 1))
end

function t1.Step(p41, p42, p43) -- line: 276
    -- upvalues: Config (copy), HighsideTuning (copy), HighsideTuning2 (copy), t1 (copy), v2 (copy), contact (copy), inverseInertia (copy), contactForce (copy), wheelSupport (copy), tyre (copy)
    local root = p41.root
    local v168 = p41.loss and p41.loss.physics
    local AssemblyLinearVelocity = root.AssemblyLinearVelocity
    local Front, Front2, _, Front3 = contact(p41, "Front")
    local Rear, Rear2, v169, Rear3 = contact(p41, "Rear")

    v169 = workspace:GetServerTimeNow() - (root:GetAttribute("LossStarted") or 0)

    local Y = root.CFrame.RightVector.Y
    local v170 = root.CFrame.UpVector.Y
    local v171 = math.atan2(Y, v170)
    local v172, LookVector

    if p43 and v168 then
        local v173 = math.min(p42, 0.05)

        p41.align.Enabled = false
        p41.force.Enabled = false
        p41.force.Force = Vector3.new(0, 0, 0)

        local contactRatio

        for _, v174 in { "Front", "Rear", "SupportFront", "SupportRear", "Handoff" } do
            contactRatio = root:FindFirstChild("LossForce_" .. v174)

            if contactRatio then
                contactRatio.Force = Vector3.new(0, 0, 0)
            end
        end

        local RightVector = root.CFrame.RightVector
        local v175 = if Rear then root:GetVelocityAtPosition(Rear):Dot(RightVector) else nil

        if not Rear or not v175 then
            v175 = 0
        end

        v170 = math.max(8, (math.abs((AssemblyLinearVelocity:Dot(root.CFrame.LookVector)))))

        local v177 = math.atan2(math.abs(v175), v170)

        contactRatio = v168.peakSlip or 0
        v168.peakSlip = math.max(contactRatio, v177)

        local v178

        if Rear then
            contactRatio = root:GetVelocityAtPosition(Rear):Dot(root.CFrame.LookVector)
            v178 = math.abs(contactRatio)
        end

        if Rear and v178 then
            v170 = v178
        end

        contactRatio = v168.rearWheelSpeed

        local SlipRecoveryLength, v179

        if not contactRatio then
            SlipRecoveryLength = p41.tractionSlip or 0
            v179 = p41.exitSlip or 0
            contactRatio = v170 * (math.max(SlipRecoveryLength, v179, 0.05) + 1)
        end

        v168.rearWheelSpeed = contactRatio

        local v180 = (v168.rearWheelSpeed - v170) / math.max(v170, 3)

        SlipRecoveryLength = HighsideTuning:GetAttribute("SlipRecoveryLength")

        if type(SlipRecoveryLength) ~= "number" or not SlipRecoveryLength then
            SlipRecoveryLength = HighsideTuning2.SlipRecoveryLength
        end

        v172 = SlipRecoveryLength / math.max(v170, 3)
        contactRatio = math.max(v172, 0.02)

        local v181 = v168.contactRatio or v180

        v179 = v180 - (v168.contactRatio or v180)

        local v182 = -v173 / contactRatio

        v168.contactRatio = v181 + v179 * (1 - math.exp(v182))
        contactRatio = v168.contactRatio

        local function surfaceScale(p44, p45) -- line: 301
            -- upvalues: v2 (copy)
            if not p44 then
                return 0
            end

            local v183 = workspace:Raycast(p44 + p45 * 0.2, -p45 * 0.5, v2)
            local v184, v185

            if v183 then
                local Surface = v183.Instance:GetAttribute("Surface")

                if v183.Instance == workspace.Terrain then
                    v184 = if v183.Material == Enum.Material.Sand then "Gravel" elseif v183.Material == Enum.Material.Grass then "Grass" else Surface
                    v185 = v184
                else
                    v185 = Surface
                end
            else
                v185 = v183
            end

            if v185 == "Grass" then
                return 0.35
            end

            if v185 == "Gravel" then
                return 0.45
            end

            if v185 == "Wet" then
                return 0.55
            end

            return 1
        end

        local v186 = if Front then wheelSupport(p41, "Front", Front, Front2, Front3, v173, 0.48) else nil

        if not Front or not v186 then
            v186 = 0
        end

        local v187 = if Rear then wheelSupport(p41, "Rear", Rear, Rear2, Rear3, v173, 0.52) else nil

        if not Rear or not v187 then
            v187 = 0
        end

        local SpinMaxTurn, DryGrip, v188, v189

        if v168.spinOut and not v168.spinDone then
            v179 = root.CFrame.LookVector
            v188 = -v179.X
            v182 = -v179.Z
            v189 = math.atan2(v188, v182)
            v179 = root:GetAttribute("LossInitialHeading") or v189
            SpinMaxTurn = v189 - v179
            DryGrip = math.sin(SpinMaxTurn)
            SpinMaxTurn = math.cos(v189 - v179)
            v182 = math.atan2(DryGrip, SpinMaxTurn)
            v188 = math.abs(v182)
            SpinMaxTurn = HighsideTuning:GetAttribute("SpinMaxTurn")
            SpinMaxTurn = type(SpinMaxTurn) == "number" and SpinMaxTurn or HighsideTuning2.SpinMaxTurn

            if (SpinMaxTurn or 1.0471975511965976) <= v188 then
                v168.spinDone = true
            end
        end

        v179 = v168.spinOut and not v168.spinDone
        v189 = if v179 then v168.spinF or 1 else 0
        DryGrip = HighsideTuning:GetAttribute("DryGrip")

        if type(DryGrip) ~= "number" or not DryGrip then
            DryGrip = HighsideTuning2.DryGrip
        end

        local v191, v192, v193

        if v168.kind == "LOWSIDE" then
            v192 = HighsideTuning:GetAttribute("SpinFrontGrip")

            local v194 = 0.35 + ((type(v192) == "number" and v192 or HighsideTuning2.SpinFrontGrip or 1) - 0.35) * v189

            if v194 then
                v191 = v194
                v193 = true
            else
                v193 = false
            end
        else
            v193 = false
        end

        if not v193 then
            v191 = 1
        end

        v188 = DryGrip * v191
        SpinMaxTurn = HighsideTuning:GetAttribute("DryGrip")

        if type(SpinMaxTurn) ~= "number" or not SpinMaxTurn then
            SpinMaxTurn = HighsideTuning2.DryGrip
        end

        local SpinRearLoss = HighsideTuning:GetAttribute("SpinRearLoss")

        if type(SpinRearLoss) ~= "number" or not SpinRearLoss then
            SpinRearLoss = HighsideTuning2.SpinRearLoss
        end

        v182 = SpinMaxTurn * (1 - (SpinRearLoss or 0) * v189)

        local Unit, Unit2, v195, v196, v197

        if Front then
            v191 = root.CFrame.LookVector - Front2 * root.CFrame.LookVector:Dot(Front2)

            if v191.Magnitude > 0.01 and v186 > 1 then
                Unit = v191.Unit
                Unit2 = Unit:Cross(Front2).Unit
                v195 = Rear and (Front + Rear) * 0.5 or Front
                v197 = false
            else
                v196 = 0
                v197 = true
            end
        else
            v196 = 0
            v197 = true
        end

        local v198, v199, v200, v201, SteeringResponse

        if not v197 then
            local v202 = root.AssemblyCenterOfMass - v195

            v199 = root.AssemblyMass * Config.Gravity * v202:Dot(Unit2)
            v192 = v202:Dot(Front2)
            v202 = v199 / math.max(v192, 0.4) - (v168.lastFySigned or 0)
            v195 = v186 * v188 * surfaceScale(Front, Front2)
            SpinRearLoss = v202 / math.max(v195, 1)
            v199 = math.clamp(SpinRearLoss, -0.96, 0.96)
            v192 = v195 * 0.6366197723675814
            v198 = math.abs(v199)
            v192 = -(v192 * math.asin(v198) * math.sign(v199)) / v186
            v200 = HighsideTuning:GetAttribute("CamberThrust")

            if type(v200) ~= "number" or not v200 then
                v200 = HighsideTuning2.CamberThrust
            end

            SpinRearLoss = v192 - v200 * math.sin(v171)
            v196 = HighsideTuning:GetAttribute("CorneringStiffness")

            if type(v196) ~= "number" or not v196 then
                v196 = HighsideTuning2.CorneringStiffness
            end

            v199 = SpinRearLoss / v196
            SpinRearLoss = root:GetVelocityAtPosition(Front)
            v192 = SpinRearLoss:Dot(Unit2)
            v200 = SpinRearLoss:Dot(Unit)
            v198 = math.abs(v200)
            v196 = math.max(v198, 3)
            v196 = v199 - math.atan2(v192, v196)
            v192 = math.clamp(v196, -0.35, 0.35)
            v196 = v168.frontSteer or v192
            v200 = v192 - (v168.frontSteer or v192)
            v201 = -v173
            SteeringResponse = HighsideTuning:GetAttribute("SteeringResponse")

            if type(SteeringResponse) ~= "number" or not SteeringResponse then
                SteeringResponse = HighsideTuning2.SteeringResponse
            end

            v168.frontSteer = v196 + v200 * (1 - math.exp(v201 / math.max(SteeringResponse, 0.02)))
            v192, v196 = tyre(p41, "Front", Front, Front2, v188 * surfaceScale(Front, Front2), v173, v186, 0, v171, v168.frontSteer)
            root:SetAttribute("CrashSteerAngle", v168.frontSteer)
        end

        local v204, v205, v206, v207, v208, TCSlip, v209, TCSlip2

        if Rear then
            Unit, v204, v205, v206 = tyre(p41, "Rear", Rear, Rear2, v182 * surfaceScale(Rear, Rear2), v173, v187, contactRatio, v171)
            v168.lastFySigned = v206
            v168.totalLongitudinalForce = v204 + v196
            v208 = p41.throttle or 0
            v207 = math.clamp(v208, 0, 1)

            if os.clock() - (p41.lastInput or os.clock()) > 0.5 then
                v207 = 0
            end

            if v168.spinDone then
                v207 = 0
            end

            v208 = math.round(p41.tcs or Config.TCS)
            v199 = math.clamp(v208, 1, 5)
            v200 = if v199 == 1 then 0 else v199 - 1
            v208 = math.clamp((v200 + 0.25 - 1) / 4, 0, 1)
            v196 = HighsideTuning:GetAttribute("TCStrength")

            if type(v196) ~= "number" or not v196 then
                v196 = HighsideTuning2.TCStrength
            end

            v199 = v208 * v196
            v198 = math.abs(v180)
            TCSlip = HighsideTuning:GetAttribute("TCSlip")

            if type(TCSlip) ~= "number" or not TCSlip then
                TCSlip = HighsideTuning2.TCSlip
            end

            v196 = v198 - TCSlip
            TCSlip = HighsideTuning:GetAttribute("TCSlip")

            if type(TCSlip) ~= "number" or not TCSlip then
                TCSlip = HighsideTuning2.TCSlip
            end

            Unit = math.clamp(v196 / math.max(TCSlip, 0.05), 0, 1) * v199
            v196 = root.AssemblyMass * Config.Gravity
            v200 = HighsideTuning:GetAttribute("DriveAccelerationG")

            if type(v200) ~= "number" or not v200 then
                v200 = HighsideTuning2.DriveAccelerationG
            end

            v199 = v196 * v200 * v207 * (1 - Unit)

            local v210 = root.AssemblyMass * Config.Gravity

            v198 = HighsideTuning:GetAttribute("EngineBrakeG")

            if type(v198) ~= "number" or not v198 then
                v198 = HighsideTuning2.EngineBrakeG
            end

            Unit = v210 * v198 * (1 - v207)
            v196 = root.AssemblyMass
            v200 = HighsideTuning:GetAttribute("WheelInertiaShare")

            if type(v200) ~= "number" or not v200 then
                v200 = HighsideTuning2.WheelInertiaShare
            end

            v208 = math.max(v196 * v200, 0.1)
            v198 = v168.rearWheelSpeed + (v199 - v204 - Unit) / v208 * v173
            v168.rearWheelSpeed = math.max(0, v198)

            if v168.lastRatio then
                v209 = math.abs(contactRatio)
                TCSlip2 = HighsideTuning:GetAttribute("TCSlip")
                TCSlip2 = type(TCSlip2) == "number" and TCSlip2 or HighsideTuning2.TCSlip

                if v209 < TCSlip2 then
                    v209 = math.abs(contactRatio)
                    TCSlip2 = v168.lastRatio

                    if v209 < math.abs(TCSlip2) and math.abs(v206) > (v168.lastFy or 0) and v168.peakSlip > 0.08726646259971647 and not v168.caughtAt then
                        v168.caughtAt = workspace:GetServerTimeNow()
                        root:SetAttribute("HighsideCaught", true)
                        root:SetAttribute("HighsideCatch", v169)
                    end
                end
            end

            v168.lastRatio = contactRatio
            v168.lastFy = math.abs(v206)
            root:SetAttribute("CrashRearSlipRatio", contactRatio)
            root:SetAttribute("CrashRearLateralForce", v206)
            root:SetAttribute("CrashRearDemand", v205)
            root:SetAttribute("CrashThrottle", v207)
        end

        local v211

        if Rear and (v168.kind == "HIGHSIDE" and not v168.gripCatch or v168.spinOut and not v168.spinDone) then
            v188 = root.CFrame.LookVector
            v204 = -v188.X
            v205 = -v188.Z
            Unit = math.atan2(v204, v205)
            v205 = Unit - (root:GetAttribute("LossInitialHeading") or Unit)
            v204 = math.sin(v205)
            v206 = Unit - (root:GetAttribute("LossInitialHeading") or Unit)
            v205 = math.cos(v206)
            Unit = math.atan2(v204, v205)
            v189 = (v168.initialRearYaw or 0) - Unit

            if v189 * (v168.initialRearYaw or 0) > 0 then
                local v212 = math.tan(v189) * v170

                v211 = root:GetVelocityAtPosition(Rear):Dot(Rear2:Cross(-v188).Unit)

                local SpinHandoffCap

                if not v168.spinOut or v168.spinDone then
                    SpinHandoffCap = 0.45
                else
                    SpinHandoffCap = HighsideTuning:GetAttribute("SpinHandoffCap")
                    SpinHandoffCap = type(SpinHandoffCap) == "number" and SpinHandoffCap or HighsideTuning2.SpinHandoffCap or 0.45
                end

                v207 = v212 - v211
                v196 = (Rear - root.AssemblyCenterOfMass):Cross(RightVector)
                v206 = v207 * (1 / (1 / root.AssemblyMass + math.max(0, v196:Dot(inverseInertia(root, v196)))))
                v209 = HighsideTuning:GetAttribute("HandoffResponse")

                if type(v209) ~= "number" or not v209 then
                    v209 = HighsideTuning2.HandoffResponse
                end

                v205 = v206 / math.max(v209, 0.05)
                v206 = -v187 * SpinHandoffCap
                v207 = v187 * SpinHandoffCap
                SpinHandoffCap = math.clamp(v205, v206, v207)
                v211 = Rear + Rear2 * (root.AssemblyCenterOfMass - Rear):Dot(Rear2)
                contactForce(p41, "Handoff", v211, v188:Cross(Rear2).Unit * SpinHandoffCap)
            end

            root:SetAttribute("PhysicalRearYaw", Unit)
        end

        root:SetAttribute("CrashFrontLoad", v186)
        root:SetAttribute("CrashRearLoad", v187)
        v168.lastRearVelocity = v175
        v206 = if v168.kind ~= "HIGHSIDE" then "Lowside" elseif v168.caughtAt then "CatchSnap" else "RearSlide"
        root:SetAttribute("HighsidePhase", v206)
        root:SetAttribute("CrashYawRate", root.AssemblyAngularVelocity.Y)
        root:SetAttribute("CrashRollRate", -root.AssemblyAngularVelocity:Dot(root.CFrame.LookVector))
        v211 = root:FindFirstChild("LossYawDamping")

        if not v211 then
            Unit = Instance.new("Attachment")
            Unit.Name = "LossContact_Yaw"
            Unit.Parent = root
            v211 = Instance.new("Torque")
            v211.Name = "LossYawDamping"
            v211.Attachment0 = Unit
            v211.RelativeTo = Enum.ActuatorRelativeTo.World
            v211.Parent = root
        end

        local v213, v214, YawMomentLimit

        if Front and Rear then
            local Unit2 = (Front2 + Rear2).Unit

            Unit = p41.bike:FindFirstChild("CrashMass") or root
            v213 = root.AssemblyMass * (Unit.Size.X ^ 2 + Unit.Size.Z ^ 2) / 12
            v214 = root.AssemblyMass * Config.Gravity * Config.Wheelbase
            YawMomentLimit = HighsideTuning:GetAttribute("YawMomentLimit")
            Unit = v214 * (type(YawMomentLimit) == "number" and YawMomentLimit or HighsideTuning2.YawMomentLimit)
            v206 = -Unit2
            v209 = root.AssemblyAngularVelocity:Dot(Unit2) * v213
            TCSlip = HighsideTuning:GetAttribute("YawDamping")

            if type(TCSlip) ~= "number" or not TCSlip then
                TCSlip = HighsideTuning2.YawDamping
            end

            SteeringResponse = HighsideTuning:GetAttribute("SpinYawFree")

            if type(SteeringResponse) ~= "number" or not SteeringResponse then
                SteeringResponse = HighsideTuning2.SpinYawFree
            end

            v201 = (SteeringResponse or 1) - 1
            TCSlip2 = TCSlip * (1 + v201 * (if v179 then v168.spinF or 1 else 0))
            v208 = v209 / math.max(TCSlip2, 0.05)
            v209 = -Unit
            v211.Torque = v206 * math.clamp(v208, v209, Unit)
        else
            v211.Torque = Vector3.new(0, 0, 0)
        end

        v211 = root:FindFirstChild("LossForce_RollGuard")

        if not v211 then
            Unit = Instance.new("Attachment")
            Unit.Name = "LossContact_Roll"
            Unit.Parent = root
            v211 = Instance.new("Torque")
            v211.Name = "LossForce_RollGuard"
            v211.Attachment0 = Unit
            v211.RelativeTo = Enum.ActuatorRelativeTo.World
            v211.Parent = root
        end

        local v215, RollGuardRate, v216

        if v168.kind == "LOWSIDE" then
            LookVector = root.CFrame.LookVector
            v215 = root.AssemblyAngularVelocity:Dot(LookVector) * v168.side
            RollGuardRate = HighsideTuning:GetAttribute("RollGuardRate")
            v213 = type(RollGuardRate) == "number" and RollGuardRate or HighsideTuning2.RollGuardRate or 0.5
            YawMomentLimit = HighsideTuning:GetAttribute("SpinFallRate")

            if type(YawMomentLimit) ~= "number" or not YawMomentLimit then
                YawMomentLimit = HighsideTuning2.SpinFallRate
            end

            v214 = YawMomentLimit or 1.2
            RollGuardRate = if v213 < v215 then v215 - v213
                elseif not v168.spinOut or v168.spinDone then 0
                elseif v215 < -v214 then v215 + v214
                else 0

            if RollGuardRate == 0 then
                v211.Torque = Vector3.new(0, 0, 0)
            else
                local v217 = p41.bike:FindFirstChild("CrashMass") or root

                v213 = root.AssemblyMass * (v217.Size.X ^ 2 + v217.Size.Y ^ 2) / 12
                v217 = root.AssemblyMass * Config.Gravity * Config.Wheelbase
                v216 = -LookVector * v168.side

                local v218 = RollGuardRate * v213
                local RollGuardTau = HighsideTuning:GetAttribute("RollGuardTau")

                TCSlip = type(RollGuardTau) == "number" and RollGuardTau or HighsideTuning2.RollGuardTau or 0.08
                v196 = v218 / math.max(TCSlip, 0.02)
                v211.Torque = v216 * math.clamp(v196, -v217, v217)
            end
        else
            v211.Torque = Vector3.new(0, 0, 0)
        end

        for v219, v220 in v168.pulses or {} do
            v220.age += v173

            if not (v220.age < 0) then
                v209 = v220.age / v220.duration
                v216 = math.clamp(v209, 0, 1)
                v216 = v216 * 6 * (1 - v216)
                contactForce(p41, v219, root.CFrame:PointToWorldSpace(v220.point), v220.impulse * (v216 / v220.duration))

                if v220.age >= v220.duration then
                    root["LossForce_" .. v219].Force = Vector3.new(0, 0, 0)
                    v168.pulses[v219] = nil
                end
            end
        end

        v215 = p41.rider and p41.rider.Parent:FindFirstChild("HumanoidRootPart")

        local VelocityAtPosition = v215 and root:GetVelocityAtPosition(v215.Position) or AssemblyLinearVelocity

        if v168.caughtAt then
            v215 = workspace:GetServerTimeNow() - v168.caughtAt
        end

        if v171 * v168.side < 0 and root.CFrame.UpVector.Y > 0.15 then
        end

        local v221

        if v168.pitchFall then
            YawMomentLimit = root.CFrame.LookVector.Y
            RollGuardRate = math.clamp(YawMomentLimit, -1, 1)

            if math.abs((math.asin(RollGuardRate))) > 1.4486232791552935 or root.CFrame.UpVector.Y < 0.15 then
                v168.ready = true
            else
                v168.ready = v169 > 0.8
            end
        elseif v168.kind == "HIGHSIDE" then
            if v168.peakSlip > 0.08726646259971647 and VelocityAtPosition.Y > 5 then
                v168.ready = -root.AssemblyAngularVelocity:Dot(root.CFrame.LookVector) * v168.side < -1
            else
                v168.ready = false
            end
        elseif v168.spinOut then
            local v223 = false

            if math.abs(v171) > 1.3089969389957472 then
                v216 = HighsideTuning:GetAttribute("SpinMinTime")

                if (type(v216) == "number" and v216 or HighsideTuning2.SpinMinTime or 0) < v169 then
                    v221 = true
                    v223 = true
                end
            end

            if not v223 then
                YawMomentLimit = HighsideTuning:GetAttribute("SpinRelease")

                if type(YawMomentLimit) ~= "number" or not YawMomentLimit then
                    YawMomentLimit = HighsideTuning2.SpinRelease
                end

                v221 = YawMomentLimit < v169
            end

            v168.ready = v221
        elseif math.abs(v171) > 1.1344640137963142 then
            v168.ready = true
        else
            v168.ready = v169 > 0.4
        end

        local v224 = true

        if t1.RiderGrounded(p41) then
            if v168.spinOut then
                YawMomentLimit = HighsideTuning:GetAttribute("SpinGroundedAfter")
                v224 = v169 < (type(YawMomentLimit) == "number" and YawMomentLimit or HighsideTuning2.SpinGroundedAfter or 0)
            else
                v224 = false
            end
        end

        if not v224 then
            v168.ready = true
        end

        v221 = root.AssemblyAngularVelocity

        if v221.Magnitude > 32 then
            root.AssemblyAngularVelocity = v221.Unit * 32
        end

        if v168.kind == "LOWSIDE" then
            v221 = require(script.Parent.CrashTopple)
            v221.LimitLowside(root, v221.StartSpeed(root))
        end

        root:SetAttribute("CrashRearVelocity", v175)
        root:SetAttribute("CrashShear", v168.shear)
        root:SetAttribute("CrashRearSlip", v177)
        root:SetAttribute("CrashGrip", v182)
        root:SetAttribute("CrashRiderPointY", VelocityAtPosition.Y)
        root:SetAttribute("CrashReleaseReady", v168.ready == true)
    end

    p41.lean = v171
    p41.rearYaw = 0
    v171 = {
        frontExcess = 0,
        lateral = 0,
        throttle = 0,
        brake = 0,
        rearBrake = 0,
        rearYaw = 0,
        rpm = 3000,
        speed = AssemblyLinearVelocity.Magnitude
    }
    v171.kph = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude * Config.StudMetres * 3.6
    v171.velocity = AssemblyLinearVelocity

    if Front ~= nil then
        v171.onGround = true
    else
        v171.onGround = Rear ~= nil
    end

    if Front or Rear then
        v171.surface = p41.surface or "Asphalt"
    else
        v171.surface = "Air"
    end

    v171.oldSlip = p41.slip or 0

    return v171
end

function t1.RiderMotion(p46, p47) -- line: 488
    local root = p46.root

    return root:GetVelocityAtPosition(p47), root.AssemblyAngularVelocity
end

function t1.Release(p48) -- line: 492
    for _, child in p48.root:GetChildren() do
        if child.Name:sub(1, 10) == "LossForce_" or child.Name:sub(1, 12) == "LossContact_" or child.Name == "LossYawDamping" then
            child:Destroy()
        end
    end

    p48.align.Enabled = false
    p48.force.Enabled = false
    p48.force.Force = Vector3.new(0, 0, 0)

    return p48.root.AssemblyLinearVelocity, p48.root.AssemblyAngularVelocity
end

return t1
