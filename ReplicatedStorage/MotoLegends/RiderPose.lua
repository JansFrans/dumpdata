-- https://lua.expert

local Default = require(script.Parent:WaitForChild("RidingStyles"):WaitForChild("Default"))
local t1 = {}
local self = setmetatable({}, {
    __mode = "k"
})
local self2 = setmetatable({}, {
    __mode = "k"
})
local self3 = setmetatable({}, {
    __mode = "k"
})
local self4 = setmetatable({}, {
    __mode = "k"
})
local self5 = setmetatable({}, {
    __mode = "k"
})

local function isJoint(p1) -- line: 18
    return p1:IsA("Motor6D") or p1:IsA("AnimationConstraint")
end

local function rig(p2) -- line: 19
    -- upvalues: self (copy), self5 (copy)
    if self[p2] then
        return self[p2]
    end

    local t12 = {}

    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("Motor6D") or descendant:IsA("AnimationConstraint") then
            t12[descendant.Name] = descendant
        end
    end

    self[p2] = t12

    if not self5[p2] then
        self5[p2] = true

        local function drop(p3) -- line: 28
            -- upvalues: p2 (copy), self (copy)
            if p3:IsA("Motor6D") or p3:IsA("AnimationConstraint") then
                self[p2] = nil
            end
        end

        p2.DescendantAdded:Connect(drop)
        p2.DescendantRemoving:Connect(drop)
    end

    return t12
end

local function data(p4) -- line: 35
    if p4:IsA("AnimationConstraint") then
        return p4.Attachment0.Parent, p4.Attachment1.Parent, p4.Attachment0.CFrame, p4.Attachment1.CFrame
    end

    return p4.Part0, p4.Part1, p4.C0, p4.C1
end

local function unit(p5, p6) -- line: 40
    return p5.Magnitude > 1E-04 and p5.Unit or p6
end

local function slerpDir(p7, p8, p9) -- line: 43
    local v7 = math.clamp(p7:Dot(p8), -1, 1)

    if v7 > 0.99999 then
        return p8
    end

    local v8 = p7:Cross(p8)

    if v8.Magnitude < 1E-05 then
        v8 = p7:Cross((Vector3.new(0, 1, 0)))

        if v8.Magnitude < 1E-05 then
            v8 = p7:Cross((Vector3.new(1, 0, 0)))
        end
    end

    return CFrame.fromAxisAngle(v8.Unit, math.acos(v7) * p9):VectorToWorldSpace(p7)
end

local function bone(p10, p11, p12, p13, p14) -- line: 55
    local v9 = p13 - p12
    local v10 = -(v9.Magnitude > 1E-04 and v9.Unit or Vector3.new(0, 1, 0))
    local v11 = Vector3.new(1, 0, 0) - v10 * v10.X
    local Unit = v11.Magnitude > 1E-04 and v11.Unit or Vector3.new(0, 0, 1)
    local v12 = p11 - p10
    local v13 = -(v12.Magnitude > 1E-04 and v12.Unit or Vector3.new(0, 1, 0))
    local v14 = p14 - v13 * p14:Dot(v13)
    local Unit2 = v14.Magnitude > 1E-04 and v14.Unit or Vector3.new(1, 0, 0)
    local v15 = CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit2, v13, Unit2:Cross(v13))
    local v16 = CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit, v10, Unit:Cross(v10))

    return CFrame.new(p10) * v15 * v16:Inverse() * CFrame.new(-p12)
end

local function palmFrame(p15, p16, p17, _, p19, p20) -- line: 66
    -- upvalues: Default (copy)
    local _CFrame = p15.CFrame
    local v18 = math.rad(Default.FingerDown + (p20 or 0))
    local v19 = _CFrame.LookVector * math.cos(v18) - _CFrame.UpVector * math.sin(v18)
    local v20 = -v19
    local v21 = _CFrame.RightVector:Cross(v20) * (if Default.PalmFlip < 0 then -1 else 1)
    local v22 = v20:Cross(v21)
    local v23 = CFrame.fromMatrix(Vector3.new(0, 0, 0), v22, v20, v21)
    local v24 = if p16 == "Right" then 1 else -1
    local v27 = CFrame.fromAxisAngle(_CFrame.UpVector, -v24 * math.rad(Default.HandYaw)) * CFrame.fromAxisAngle(v19, v24 * math.rad(Default.HandRoll)) * v23
    local v28

    if not p19 then
        v28 = Vector3.new(0, -0.45, 0)

        return CFrame.new(p17 - v27:VectorToWorldSpace(v28)) * v27
    end

    v28 = p19.Position + Vector3.new(0, Default.GripDepth, 0) or Vector3.new(0, -0.45, 0)

    return CFrame.new(p17 - v27:VectorToWorldSpace(v28)) * v27
end

t1.PalmFrame = palmFrame

local function fingerExtra(p21, p22, p23) -- line: 82
    -- upvalues: Default (copy)
    local v29 = if p21 == "Right" then 1 else -1
    local v31 = math.clamp(-p22 * v29 / 0.8, 0, 1)

    return p23 * (v31 * Default.InsideFingerDown + (1 - v31) * Default.OutsideFingerDown)
end

local function gripAttachment(p24, p25) -- line: 88
    local v32 = p24:FindFirstChild(p25 .. "Hand")

    return v32 and v32:FindFirstChild(p25 .. "GripAttachment")
end

function t1.SeatFrame(p26, p27) -- line: 93
    -- upvalues: Default (copy), rig (copy)
    local v33 = rig(p26)
    local v34 = v33.Root or v33.RootJoint

    if v34 then
        local v35, v36

        if v34:IsA("AnimationConstraint") then
            local _ = v34.Attachment0.Parent
            local _ = v34.Attachment1.Parent

            v36 = v34.Attachment0.CFrame
            v35 = v34.Attachment1.CFrame
        else
            local _, _ = v34.Part0, v34.Part1

            v36 = v34.C0
            v35 = v34.C1
        end

        local v37 = v36 * v35:Inverse()
        local v39 = p27.SeatOffset + Vector3.new(0, 0.38 + Default.SeatRaise, 0.38)

        return CFrame.new(v39 - v37.Position)
    end

    return CFrame.new(p27.SeatOffset + Vector3.new(0, 1.25 + Default.SeatRaise, 0))
end

function t1.Reset(p28) -- line: 103
    -- upvalues: self (copy), self2 (copy), self3 (copy), self4 (copy)
    self2[p28] = nil
    self3[p28] = nil
    self4[p28] = nil

    local v41 = self[p28]

    if v41 then
        for _, v42 in v41 do
            if v42.Parent then
                v42.Transform = CFrame.identity
            end
        end
    end
end

local function applyLoss(p29, p30, p31, _, _) -- line: 113
    -- upvalues: self2 (copy), self3 (copy)
    local v43 = p30:GetAttribute("LossStarted") or 0
    local v44 = self3[p29]

    if not v44 or v44.started ~= v43 then
        local t13 = {}

        for v45, v46 in p31 do
            t13[v45] = self2[p29] and self2[p29][v45] or v46.Transform
        end

        v44 = {
            started = v43,
            transforms = t13
        }
        self3[p29] = v44
    end

    for v47, v48 in p31 do
        v48.Transform = v44.transforms[v47] or v48.Transform
    end
end

local function solveLimb(p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45) -- line: 127
    -- upvalues: Default (copy), self4 (copy), slerpDir (copy), bone (copy), palmFrame (copy)
    local v49 = p40 == "Hand"
    local v51 = p36[p41 .. (if v49 then "Shoulder" else "Hip")]
    local v52 = p36[p41 .. (if v49 then "Elbow" else "Knee")]
    local v54 = p36[p41 .. (if v49 then "Wrist" else "Ankle")]
    local v50 = p35:FindFirstChild(p41 .. p40 .. "Target")

    if not (v51 and v52 and v54 and v50) then
        return
    end

    local v55 = v49 and p38 or p39
    local v56, v57, v58
    local v53

    if v51:IsA("AnimationConstraint") then
        v53 = v51.Attachment0.Parent
        v56 = v51.Attachment1.Parent
        v57 = v51.Attachment0.CFrame
        v58 = v51.Attachment1.CFrame
    else
        v53 = v51.Part0
        v56 = v51.Part1
        v57 = v51.C0
        v58 = v51.C1
    end

    local v59, v60, v61

    if v52:IsA("AnimationConstraint") then
        v59 = v52.Attachment0.Parent

        local _ = v52.Attachment1.Parent

        v60, v61 = v52.Attachment0.CFrame, v52.Attachment1.CFrame
    else
        v59 = v52.Part0

        local _ = v52.Part1

        v60, v61 = v52.C0, v52.C1
    end

    local v62, v63, v64

    if v54:IsA("AnimationConstraint") then
        local _ = v54.Attachment0.Parent

        v62 = v54.Attachment1.Parent
        v63, v64 = v54.Attachment0.CFrame, v54.Attachment1.CFrame
    else
        local _ = v54.Part0

        v62 = v54.Part1
        v63, v64 = v54.C0, v54.C1
    end

    v62 = if p41 == "Right" then 1 else -1

    local v65, v66

    if v49 then
        v66 = false
    elseif v62 == (p37.dangleSide or -1) then
        local v68 = math.clamp(p37.dangle or 0, 0, 1)

        if v68 then
            v65 = v68
            v66 = true
        else
            v66 = false
        end
    else
        v66 = false
    end

    if not v66 then
        v65 = 0
    end

    local v69, v70, v71, v72, v73

    if v49 then
        v72 = 0
        v73 = 1
    elseif p41 == (Default.ShiftFoot or "Left") then
        v69 = self4[p34]

        if v69 and v69.shiftAt then
            v59 = (os.clock() - v69.shiftAt) / (Default.ShiftTime or 0.24)

            if v59 >= 0 and v59 < 1 then
                v70 = 3.141592653589793 * v59
                v71 = math.sin(v70) * (1 - v65) * (1 - (p37.paddle or 0))
            else
                v71 = 0
            end

            v72 = v71
            v73 = (v69.shiftDir or 1) * (if (Default.ShiftPattern or "GP") == "Road" then -1 else 1)
        else
            v72 = 0
            v73 = 1
        end
    else
        v72 = 0
        v73 = 1
    end

    v65 = v50.WorldPosition

    local _CFrame, new, Position, v74

    if not v49 and v62 == (p37.dangleSide or -1) then
        _CFrame = p35.CFrame
        new = CFrame.new
        Position = v50.Position
        v74 = v62 * (0.85 + (Default.DangleShinOut or 0.35))
        v65 = v65:Lerp((_CFrame * new(Position + Vector3.new(v74, -0.55, -0.35))).Position, p37.dangle or 0)
    end

    local v75, v76
    local v77 = v65

    if v49 then
    elseif (p37.paddle or 0) > 0 then
        v75 = p37.paddlePhase or 0
        v76 = if v62 > 0 then 3.141592653589793 else 0
        v56 = v75 + v76
        v53 = math.sin(v56) * 0.85
        _CFrame = math.cos(v56)
        v75 = math.max(0, _CFrame) * 0.38
        v77 = v65:Lerp((p35.CFrame * CFrame.new(v62 * 1.15, v75 + -0.95, v50.Position.Z - 0.25 + v53)).Position, p37.paddle)
    end

    local Position2, v78, v79, v80, v81

    if p45 > 0 then
        if v49 then
            v76 = (p45 - 0.55) / 0.45
            v79 = math.clamp(v76, 0, 1) or p45
        else
            v79 = p45
        end

        new = p35.CFrame
        v80 = CFrame.new
        Position2 = v50.Position
        v78 = v62 * 0.16
        v81 = v77:Lerp((new * v80(Position2 + Vector3.new(v78, 0.7, -0.18))).Position, v79)
    else
        v81 = v77
    end

    local v82, _CFrame2, v83, v84

    if v49 then
        v84 = v81
    else
        v76 = -p42 * v62 / 0.8
        v75 = math.clamp(v76, 0, 1)
        v79 = p35.CFrame
        _CFrame = v62 * Default.FootOut
        new = v75 * p43 * Default.InsideFootLift
        v82 = v81 + v79:VectorToWorldSpace((Vector3.new(_CFrame, new, 0)))

        if v72 > 0 then
            _CFrame2 = p35.CFrame
            v83 = if v73 > 0 then Default.ShiftPress or 0.03 else Default.ShiftLift or 0.1
            new = v72 * v83
            v83 = if v73 > 0 then 0 else v72 * -0.05
            v84 = v82 + _CFrame2:VectorToWorldSpace((Vector3.new(0, new, v83)))
        else
            v84 = v82
        end
    end

    if v49 then
        v76 = p34:FindFirstChild(p41 .. "Hand")
        _CFrame2 = v76 and v76:FindFirstChild(p41 .. "GripAttachment")
    else
        _CFrame2 = v49
    end

    local v85, v86, v87

    if v49 then
        v74 = if p41 == "Right" then 1 else -1
        v85 = -p42 * v74 / 0.8
        v78 = math.clamp(v85, 0, 1)
        v76 = palmFrame(p35, p41, v84, 0, _CFrame2, p43 * (v78 * Default.InsideFingerDown + (1 - v78) * Default.OutsideFingerDown))

        if v76 then
            v86 = v76
            v87 = true
        else
            v87 = false
        end
    else
        v87 = false
    end

    if not v87 then
        v70 = CFrame.new(v84) * p35.CFrame.Rotation * CFrame.Angles(-0.08726646259971647, 0, 0)
        _CFrame = CFrame.Angles
        Position = (Default.ShiftToe or 28) * v72 * v73
        v86 = v70 * _CFrame(-math.rad(Position), 0, 0)
    end

    local Position3 = (v55 * v57).Position

    v73 = (v60.Position - v58.Position).Magnitude
    v72 = (v63.Position - v61.Position).Magnitude

    if v73 < 0.005 or v72 < 0.005 then
        return
    end

    v70 = math.clamp(-p42 * v62 / 0.8, 0, 1)

    local v90 = math.clamp(p44, 0, 1) * (1 - p43 * 0.8)
    local _CFrame3 = p35.CFrame
    local v91 = if v49 then _CFrame3.RightVector * (v62 * (Default.ElbowOut + p43 * Default.ElbowCornerOut - v90 * Default.ElbowTuckIn)) - _CFrame3.LookVector * (Default.ElbowBack - p43 * Default.ElbowCornerFwd + v90 * 0.2) + _CFrame3.UpVector * (-Default.ElbowDown + p43 * (Default.ElbowOutsideLift - v70 * Default.ElbowInsideDrop) + v90 * 0.1) else _CFrame3.LookVector + _CFrame3.RightVector * v62 * (Default.KneeOut + v70 * p43 * Default.CornerKneeOut)

    v84 = (v86 * v64).Position - Position3
    v83 = _CFrame3.LookVector
    v83 = v84.Magnitude > 1E-04 and v84.Unit or v83
    v80 = math.clamp(v84.Magnitude, math.abs(v73 - v72) + 0.003, v73 + v72 - 0.015)
    Position = v91 - v83 * v91:Dot(v83)
    Position2 = _CFrame3.RightVector * v62
    Position2 = Position.Magnitude > 1E-04 and Position.Unit or Position2

    local v92, v93, v94, v95

    if v49 then
        v92 = self4[p34]

        if v92 then
            v93 = v92.bend or {}
            v95 = false
        else
            v94 = Position2
            v95 = true
        end
    else
        v94 = Position2
        v95 = true
    end

    if not v95 then
        v92.bend = v93
        v93 = _CFrame3:VectorToObjectSpace(Position2)
        Position = v92.bend[p41]

        local v96

        if Position then
            v96 = -(v92.mdt or 0) * (Default.ArmTwistSpeed or 8)
            v93 = slerpDir(Position, v93, 1 - math.exp(v96))
        end

        v92.bend[p41] = v93
        v93 = _CFrame3:VectorToWorldSpace(v93)

        local v97 = v93 - v83 * v93:Dot(v83)
        local v98 = v97.Magnitude > 1E-04
        local Unit = if v98 then v97.Unit else nil

        v94 = if not v98 or not Unit then Position2 else Unit
    end

    v93 = (v73 * v73 - v72 * v72 + v80 * v80) / (v80 * 2)
    Position2 = Position3 + v83 * v93
    v85 = math.max(0, v73 * v73 - v93 * v93)

    local v99 = Position2 + v94 * math.sqrt(v85)
    local v100 = Position3 + v83 * v80

    v74 = v83:Cross(v94)
    v78 = _CFrame3.RightVector

    local v101 = v74.Magnitude > 1E-04
    local v102, Unit

    if v101 then
        Unit = v74.Unit
        v102 = Unit
    end

    if not v101 or not Unit then
        v102 = v78
    else
        v78 = Unit
    end

    if v78:Dot(_CFrame3.RightVector) < 0 then
        v102 = -v78
    end

    local function hingeAxis() -- line: 224
        -- upvalues: v83 (ref), Position3 (copy), v99 (copy), v100 (copy), v58 (ref), v60 (ref), v61 (ref), v63 (ref)
        local v103 = v99 - Position3
        local v104 = v83

        v104 = v103.Magnitude > 1E-04 and v103.Unit or v104

        local v105 = v100 - v99
        local v106 = v83

        v106 = v105.Magnitude > 1E-04 and v105.Unit or v106

        local v107 = v60.Position - v58.Position
        local X = (v107.Magnitude > 1E-04 and v107.Unit or Vector3.new(0, -1, 0)).X
        local v108 = v63.Position - v61.Position
        local X2 = (v108.Magnitude > 1E-04 and v108.Unit or Vector3.new(0, -1, 0)).X
        local v110 = math.clamp(v104:Dot(v106), -0.99999, 0.99999)

        return v104 * ((X - v110 * X2) / (1 - v110 * v110)) + v106 * ((X2 - v110 * X) / (1 - v110 * v110)), v104, v106
    end

    local function planeFor(p46) -- line: 238
        -- upvalues: v102 (ref), v49 (copy), hingeAxis (copy)
        local v111 = v102 * p46

        if not v49 then
            return v111
        end

        local v112, v113, v114 = hingeAxis()
        local Magnitude = v112.Magnitude

        if Magnitude >= 1 then
            return v111
        end

        local v116 = math.clamp((1 - Magnitude) / 0.4, 0, 1)
        local v117 = v116 * v116 * (3 - v116 * 2)
        local v118 = v113:Cross(v114)
        local Unit = v118.Magnitude > 1E-04 and v118.Unit or v111

        if Unit:Dot(v111) < 0 then
            Unit = -Unit
        end

        local v120 = v111:Lerp(v112 + Unit * math.sqrt(1 - Magnitude * Magnitude), v117)

        v111 = v120.Magnitude > 1E-04 and v120.Unit or v111

        return v111
    end

    local v121 = planeFor(1)

    v74 = bone(Position3, v99, v58.Position, v60.Position, v121)
    v121 = bone(v99, v100, v61.Position, v63.Position, v121)

    if v49 and (v74 * v60):ToObjectSpace(v121 * v61):ToOrientation() < 0 then
        v85 = planeFor(-1)
        v74 = bone(Position3, v99, v58.Position, v60.Position, v85)
        v121 = bone(v99, v100, v61.Position, v63.Position, v85)
    end

    v51.Transform = (v55 * v57):ToObjectSpace(v74 * v58)
    v52.Transform = (v74 * v60):ToObjectSpace(v121 * v61)
    v86 = CFrame.new(v100 - v86.Rotation * v64.Position) * v86.Rotation
    v54.Transform = (v121 * v63):ToObjectSpace(v86 * v64)
end

function t1.Hold(p47) -- line: 271
    -- upvalues: self (copy), self2 (copy)
    if p47:GetAttribute("RaceCrashActive") then
        return true
    end

    local v122 = self2[p47]
    local v123 = self[p47]

    if not v123 or not v122 or not v123 then
        return false
    end

    for v124, v125 in v123 do
        local v126 = v122[v124]

        if v126 and v125.Parent then
            v125.Transform = v126
        end
    end

    return true
end

function t1.Apply(p48, p49, p50) -- line: 280
    -- upvalues: Default (copy), self2 (copy), self3 (copy), self4 (copy), rig (copy), palmFrame (copy), applyLoss (copy), solveLimb (copy)
    if p48:GetAttribute("RaceCrashActive") then
        return
    end

    local v127 = rig(p48)
    local v128 = v127.Root or v127.RootJoint
    local Waist = v127.Waist
    local LossStage = p49:GetAttribute("LossStage")

    if LossStage == "LOWSIDE" or LossStage == "HIGHSIDE" then
        applyLoss(p48, p49, v127, v128, LossStage)

        return
    end

    self3[p48] = nil

    local v129 = p50.lean or 0
    local v130 = p50.tuck or 0
    local v131 = p50.brake or 0
    local v132 = p50.brace or 0
    local v133 = p50.look or 0

    if p49:GetAttribute("DebugLean") then
        v129 = p49:GetAttribute("DebugLean")
        v130 = p49:GetAttribute("DebugTuck") or v130
    end

    if p49:GetAttribute("DebugDangle") then
        p50.dangle = p49:GetAttribute("DebugDangle")
        p50.dangleSide = p49:GetAttribute("DebugDangleSide") or 1
    end

    LossStage = math.clamp(math.abs(v129) / Default.CornerFull, 0, 1) * (1 - v132)
    LossStage = LossStage * LossStage * (3 - 2 * LossStage)

    local v136 = math.max(v130 * (1 - LossStage * Default.CornerTuckKeep), LossStage * Default.CornerTuckMin)
    local v137 = -v129
    local v134 = math.abs(v129) * Default.HipDropLean + LossStage * Default.HipDropCorner
    local v135 = (Vector3.new(0, -1, 0)):Lerp(p49.CFrame:VectorToObjectSpace((Vector3.new(-0, -1, -0, -0))), Default.HipDropToGround) * v134
    local elapsed = os.clock()
    local v138 = self4[p48]

    if not v138 then
        v138 = {
            hipV = 0,
            lift = 0,
            t = elapsed,
            seed = math.random() * 1000
        }
        self4[p48] = v138
    end

    local v139 = math.clamp(elapsed - v138.t, 0, 0.1)

    v138.t = elapsed
    v138.mdt = v139

    local speed = p50.speed
    local v140, v141

    if speed then
        v140 = speed
        v141 = true
    elseif p49.Parent then
        speed = p49.Parent:GetAttribute("SpeedKph")

        if speed then
            v140 = speed
            v141 = true
        else
            v141 = false
        end
    else
        v141 = false
    end

    if not v141 then
        v140 = p49.AssemblyLinearVelocity.Magnitude * 1.008
    end

    local throttle = p50.throttle
    local v142, v143

    if throttle then
        v142 = throttle
        v143 = true
    elseif p49.Parent then
        throttle = p49.Parent:GetAttribute("Throttle")

        if throttle then
            v142 = throttle
            v143 = true
        else
            v143 = false
        end
    else
        v143 = false
    end

    if not v143 then
        v142 = 0
    end

    local DebugGear = p49:GetAttribute("DebugGear") or p50.gear or p49.Parent and p49.Parent:GetAttribute("Gear")

    if typeof(DebugGear) == "number" then
        if v138.gear and DebugGear ~= v138.gear then
            v138.shiftAt = elapsed
            v138.shiftDir = v138.gear < DebugGear and 1 or -1
        end

        v138.gear = DebugGear
    end

    v138.speedF = math.clamp(v140 / (Default.VibFullKph or 220), 0, 1)

    local function nz(p51, p52) -- line: 324
        -- upvalues: elapsed (copy), v138 (ref)
        return (math.clamp(math.noise(elapsed * p51, v138.seed + p52 * 17.3, p52 * 3.1) * 2, -1, 1))
    end

    local v144 = v137 * (Default.HipSide + LossStage * (Default.HipCornerShift - Default.HipSide + Default.HipCornerOut)) + v135.X + (p50.dangleSide or 0) * (p50.dangle or 0) * (Default.HipPreShift or 0) * (1 - LossStage)

    if v138.hipX == nil then
        v138.hipX = v144
    end

    local v146 = Default.HipShiftSpeed or 11
    local v147 = math.ceil(v139 / 0.016)
    local v148 = math.max(1, v147)
    local v149 = v139 / v148
    local v150

    for _ = 1, v148 do
        v150 = v138.hipV + (v146 * v146 * (v144 - v138.hipX) - 2 * v146 * v138.hipV) * v149

        local v151 = v138

        v151.hipV = v150
        v151.hipX = v138.hipX + v138.hipV * v149
    end

    if v138.dropY == nil then
        v147 = v135.Y

        local v152 = v138

        v152.dropY = v147
        v152.dropV = 0
    end

    local identity = if v135.Y > v138.dropY then Default.HipRiseLead or 1.6 else Default.HipDropLag or 0.45

    v147 = v146 * identity

    local v153

    for _ = 1, v148 do
        v153 = v138.dropV + (v147 * v147 * (v135.Y - v138.dropY) - 2 * v147 * v138.dropV) * v149

        local v154 = v138

        v154.dropV = v153
        v154.dropY = v138.dropY + v138.dropV * v149
    end

    v144 = math.min(math.abs(v138.hipV) * (Default.HipShiftLift or 0.05), Default.HipShiftLiftMax or 0.16) * (1 - v132)
    v146 = v138.lift
    v149 = v144 - v138.lift

    local v155 = -v139 * 14

    v146 += v149 * (1 - math.exp(v155))
    v138.lift = v146
    v144 = (1 - v132) * (1 - (p50.paddle or 0))

    if p50.vibrate ~= true then
        v144 = 0
    end

    v134 = (Default.VibEngine or 0.006) * (0.45 + 0.55 * v142)
    v142 = (Default.VibRoad or 0.018) * v138.speedF
    v146 = (Default.VibBrake or 0.012) * math.clamp(v131 * 1.4 - 0.4, 0, 1) * math.clamp((v140 - 40) / 80, 0, 1)
    identity = CFrame.identity

    local v156, v157, v158, v159, UpVector

    if v144 > 0 then
        v159 = math.noise(elapsed * 23, v138.seed + 17.3, 3.1) * 2
        v153 = math.clamp(v159, -1, 1) * v134
        v156 = math.noise(elapsed * 4.3, v138.seed + 34.6, 6.2) * 2
        v150 = v153 + math.clamp(v156, -1, 1) * v142 * 0.5
        v156 = math.noise(elapsed * 27, v138.seed + 51.900000000000006, 9.3) * 2
        v159 = math.clamp(v156, -1, 1) * v134
        UpVector = math.noise(elapsed * 5.1, v138.seed + 69.2, 12.4) * 2
        v157 = v159 + math.clamp(UpVector, -1, 1) * v142
        v156 = math.noise(elapsed * 17, v138.seed + 86.5, 15.5) * 2
        v153 = v157 + math.clamp(v156, -1, 1) * v146
        v148 = Vector3.new(v150, v153, 0) * v144
        v157 = math.noise(elapsed * 3.7, v138.seed + 103.80000000000001, 18.6) * 2
        v149 = math.clamp(v157, -1, 1) * v142 * 0.9 * v144
        v157 = math.noise(elapsed * 4.7, v138.seed + 121.10000000000001, 21.7) * 2
        v147 = math.clamp(v157, -1, 1) * v142 * 1.2 * v144
        v159 = Default.VibHead or 1.4
        v157 = math.rad(v159)
        v158 = (v140 - 110) / 170
        v155 = v157 * math.clamp(v158, 0, 1) * (1 - LossStage * 0.5) * v144
        v150 = CFrame.Angles
        v159 = math.noise(elapsed * 9, v138.seed + 138.4, 24.8) * 2
        v153 = math.clamp(v159, -1, 1) * v155
        v158 = math.noise(elapsed * 7, v138.seed + 155.70000000000002, 27.900000000000002) * 2
        v157 = math.clamp(v158, -1, 1) * v155
        UpVector = math.noise(elapsed * 8, v138.seed + 173, 31) * 2
        identity = v150(v153, v157, math.clamp(UpVector, -1, 1) * v155 * 0.6)
    else
        v148 = Vector3.new(0, 0, 0)
        v149 = 0
        v147 = 0
    end

    v155 = CFrame.new(v138.hipX + v148.X, -v136 * Default.HipDropTuck + v138.dropY + v132 * 0.32 - (p50.paddle or 0) * 0.7 + v138.lift + v148.Y, Default.HipForward - v136 * Default.HipForwardTuck - v131 * Default.HipBrakeSlide + v135.Z)
    v150 = CFrame.Angles
    v157 = Default.HipPitch + Default.HipPitchTuck * v136 + Default.HipPitchBrake * v131 + 14 * v132
    v146 = v155 * v150(math.rad(v157), -v137 * Default.HipYaw, v129 * Default.HipRoll + v149)

    if v128 then
        v128.Transform = v146
    end

    v150 = Default.ChestBend + Default.ChestTuck * v136 + Default.ChestCorner * LossStage + Default.ChestBrake * v131 + 38 * v132

    local v160 = math.rad(v150)

    if Waist then
        Waist.Transform = CFrame.Angles(v160 + v147, -v137 * Default.ChestTwist - v133 * 0.16, v129 * Default.ChestRoll)
    end

    local HeadCornerDip, HeadTuckDip

    if v127.Neck then
        v155 = v127.Neck
        v157 = CFrame.new(v137 * Default.HeadInside, -LossStage * 0.07, -LossStage * 0.1)
        v159 = CFrame.Angles
        UpVector = -v160 * Default.HeadLift
        HeadCornerDip = Default.HeadCornerDip
        v156 = UpVector - LossStage * math.rad(HeadCornerDip)
        HeadTuckDip = Default.HeadTuckDip
        v155.Transform = v157 * v159(v156 - v136 * math.rad(HeadTuckDip), -v137 * Default.HeadTurn - v133 * 1.65, -v129 * Default.HeadLevel) * identity
    end

    if v128 and Waist then
        local v161, v162, v163

        if v128:IsA("AnimationConstraint") then
            v161 = v128.Attachment0.Parent
            v150 = v128.Attachment1.Parent
            v162 = v128.Attachment0.CFrame
            v163 = v128.Attachment1.CFrame
        else
            v161 = v128.Part0
            v150 = v128.Part1
            v162 = v128.C0
            v163 = v128.C1
        end

        v150 = v161.CFrame * v162 * v128.Transform * v163:Inverse()

        if Waist:IsA("AnimationConstraint") then
            v159 = Waist.Attachment0.Parent
            v158 = Waist.Attachment1.Parent
            v156 = Waist.Attachment0.CFrame
            UpVector = Waist.Attachment1.CFrame
        else
            v159 = Waist.Part0
            v158 = Waist.Part1
            v156 = Waist.C0
            UpVector = Waist.C1
        end

        local v164 = v150 * v156 * Waist.Transform * UpVector:Inverse()

        v158 = v164

        local v165

        for _ = 1, 16 do
            v165 = Vector3.new(0, 0, 0)

            local n1 = 0

            for _, v166 in { "Left", "Right" } do
                local v167 = v127[v166 .. "Shoulder"]
                local v168 = v127[v166 .. "Elbow"]
                local v169 = v127[v166 .. "Wrist"]
                local v170 = p49:FindFirstChild(v166 .. "HandTarget")

                if v167 and v168 and v169 and v170 and v132 == 0 then
                    local v171, v172

                    if v167:IsA("AnimationConstraint") then
                        local _ = v167.Attachment0.Parent
                        local _ = v167.Attachment1.Parent

                        v171 = v167.Attachment0.CFrame
                        v172 = v167.Attachment1.CFrame
                    else
                        local _, _ = v167.Part0, v167.Part1

                        v171 = v167.C0
                        v172 = v167.C1
                    end

                    local v173, v174, v175

                    if v168:IsA("AnimationConstraint") then
                        local _ = v168.Attachment0.Parent

                        v173 = v168.Attachment1.Parent
                        v174 = v168.Attachment0.CFrame
                        v175 = v168.Attachment1.CFrame
                    else
                        local _ = v168.Part0

                        v173 = v168.Part1
                        v174 = v168.C0
                        v175 = v168.C1
                    end

                    local Parent, v176, v177

                    if v169:IsA("AnimationConstraint") then
                        local _ = v169.Attachment0.Parent

                        Parent = v169.Attachment1.Parent
                        v176 = v169.Attachment0.CFrame
                        v177 = v169.Attachment1.CFrame
                    else
                        local _ = v169.Part0

                        Parent = v169.Part1
                        v176 = v169.C0
                        v177 = v169.C1
                    end

                    local WorldPosition = v170.WorldPosition
                    local v178 = p48:FindFirstChild(v166 .. "Hand")
                    local v179 = v178 and v178:FindFirstChild(v166 .. "GripAttachment")

                    v173 = if v166 == "Right" then 1 else -1

                    local v181 = math.clamp(-v129 * v173 / 0.8, 0, 1)

                    v177 = (palmFrame(p49, v166, WorldPosition, 0, v179, LossStage * (v181 * Default.InsideFingerDown + (1 - v181) * Default.OutsideFingerDown)) * v177).Position - (v158 * v171).Position
                    Parent = (v174.Position - v172.Position).Magnitude + (v176.Position - v175.Position).Magnitude - 0.015

                    if Parent < v177.Magnitude then
                        v165 += v177.Unit * (v177.Magnitude - Parent)
                        n1 += 1
                    end
                end
            end

            if n1 == 0 then
                break
            end

            v158 += v165 / n1
            n1 = v158.Position - v164.Position

            if n1.Magnitude > Default.ReachPull then
                v158 = v164 + n1.Unit * Default.ReachPull
                break
            end
        end

        v159 = (v158.Position - v164.Position) * Default.ReachPullHips
        UpVector = p49.CFrame.UpVector

        local v182 = v159:Dot(UpVector)

        v146 = self4[p48]

        if v146 then
            if v146.pullY == nil then
                v146.pullY = v182
                v146.pullV = 0
            end

            v144 = v146.mdt or 0

            local v183 = Default.HipShiftSpeed or 11

            HeadTuckDip = if v146.pullY < v182 then Default.HipRiseLead or 1.6 else Default.HipDropLag or 0.45
            DebugGear = v183 * HeadTuckDip
            v165 = v144 / 0.016
            HeadCornerDip = math.ceil(v165)
            v183 = math.max(1, HeadCornerDip)
            v140 = v144 / v183

            for _ = 1, v183 do
                v146.pullV += (DebugGear * DebugGear * (v182 - v146.pullY) - 2 * DebugGear * v146.pullV) * v140
                v146.pullY += v146.pullV * v140
            end

            v159 += UpVector * (v146.pullY - v182)
        end

        v150 += v159
        v128.Transform = (v161.CFrame * v162):ToObjectSpace(v150 * v163)

        for _, v184 in { "Hand", "Foot" } do
            for _, v185 in { "Left", "Right" } do
                solveLimb(p48, p49, v127, p50, v158, v150, v184, v185, v129, LossStage, v136, v132)
            end
        end

        local t14 = {}

        for v186, v187 in v127 do
            t14[v186] = v187.Transform
        end

        self2[p48] = t14
    else
        for _, v188 in { -1, 1 } do
            identity = if v188 == 1 then "Right" else "Left"
            v147 = v127[identity .. " Shoulder"]
            v149 = v127[identity .. " Hip"]

            if v147 then
                v147.Transform = CFrame.Angles(-1.3089969389957472, 0, -v188 * 0.12)
            end

            if v149 then
                v149.Transform = CFrame.Angles(-1.2217304763960306, 0, v188 * 0.1)
            end
        end
    end
end

return t1
