-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local GridOfficialMotion = require(MotoLegends:WaitForChild("GridOfficialMotion"))
local LocalPlayer = Players.LocalPlayer
local t1 = {
    0.34, 0.04, 0.52
}

local function smooth(p1) -- line: 32
    local v1 = math.clamp(p1, 0, 1)

    return v1 * v1 * (3 - 2 * v1)
end

local function smoother(p2) -- line: 33
    local v2 = math.clamp(p2, 0, 1)

    return v2 * v2 * v2 * (v2 * (v2 * 6 - 15) + 10)
end

local function flat(p3) -- line: 34
    return (Vector3.new(p3.X, 0, p3.Z))
end

local function yawOf(p4) -- line: 35
    return (math.atan2(-p4.X, -p4.Z))
end

local function angleTo(p5, p6) -- line: 36
    return (p6 - p5 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

local function ypr(p7, p8, p9) -- line: 37
    return CFrame.fromEulerAnglesYXZ(math.rad(p7), math.rad(p8), (math.rad(p9 or 0)))
end

local t2 = {}

local function setFade(p10, p11) -- line: 41
    if p10.fade == p11 then
        return
    end

    p10.fade = p11

    for _, descendant in p10.model:GetDescendants() do
        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
            descendant.LocalTransparencyModifier = p11
        end
    end
end

local function add(p12) -- line: 48
    -- upvalues: t2 (copy)
    local v8

    if not p12:IsA("Model") or t2[p12] then
        return
    else
        v8 = p12:FindFirstChildOfClass("Humanoid") or p12:WaitForChild("Humanoid", 5)
    end

    local v10 = p12:FindFirstChild("HumanoidRootPart") or p12:WaitForChild("HumanoidRootPart", 5)

    if not (v8 and v10 and p12.Parent) then
        return
    end

    if not ((v8:FindFirstChildOfClass("Animator") or v8:WaitForChild("Animator", 3)) and p12.Parent) and not v8:FindFirstChildOfClass("Animator") then
        Instance.new("Animator", v8)
    end

    local t3 = {
        aim = nil,
        model = p12,
        hum = v8,
        root = v10,
        j = {},
        ik = {},
        seed = p12:GetAttribute("Seed") or math.random() * 100
    }

    for _, v11 in { "Waist", "Neck" } do
        local v12 = p12:FindFirstChild(v11, true) or p12:WaitForChild(v11, 3)

        if v12 and v12:IsA("Motor6D") then
            t3.j[v11] = v12
        end
    end

    local v13 = p12:FindFirstChild("HoldAnchor") or p12:WaitForChild("HoldAnchor", 3)
    local v14 = v13 and v13.Value

    for _, v15 in { "Left", "Right" } do
        local Attribute = p12:GetAttribute(v15 .. "HandTarget")
        local v16 = v14 and Attribute and (v14:FindFirstChild(Attribute) or v14:WaitForChild(Attribute, 3))
        local v17 = p12:FindFirstChild(v15 .. "UpperArm")
        local v18 = p12:FindFirstChild(v15 .. "Hand")

        if v16 and v17 and v18 then
            local IKControl = Instance.new("IKControl")

            IKControl.Name = "F2FHold" .. v15
            IKControl.Type = Enum.IKControlType.Position
            IKControl.ChainRoot = v17
            IKControl.EndEffector = v18
            IKControl.Target = v16
            IKControl.Weight = 1
            IKControl.SmoothTime = 0.05
            IKControl.Priority = 1

            local v19 = v14:FindFirstChild(Attribute .. "Pole")

            if v19 then
                IKControl.Pole = v19
            end

            IKControl.Parent = v8
            t3.ik[v15] = IKControl
        end
    end

    for _, v20 in {
            "LeftHip",
            "RightHip",
            "LeftKnee",
            "RightKnee",
            "LeftAnkle",
            "RightAnkle",
            "LeftShoulder",
            "RightShoulder",
            "LeftElbow",
            "RightElbow",
            "Root"
        } do
        local v21 = p12:FindFirstChild(v20, true)

        if v21 and v21:IsA("Motor6D") then
            t3.j[v20] = v21
        end
    end

    local j = t3.j

    if j.Root and j.LeftHip and j.RightHip and j.LeftKnee and j.RightKnee and j.LeftAnkle and j.RightAnkle then
        t3.legs = {}

        local v22 = j.Root.C0 * j.Root.C1:Inverse()

        for _, v23 in { "Left", "Right" } do
            local v24 = j[v23 .. "Hip"]
            local v25 = j[v23 .. "Knee"]
            local v26 = j[v23 .. "Ankle"]
            local v27 = p12:FindFirstChild(v23 .. "Foot")
            local v30 = v24.C1:Inverse() * v25.C0 * v25.C1:Inverse() * v26.C0 * v26.C1:Inverse() * Vector3.new(0, -(v27 and v27.Size.Y / 2 or 0.15), 0)

            t3.legs[v23] = {
                hip = v24,
                knee = v25,
                ankle = v26,
                rel = v22 * v24.C0,
                rest = v30.Unit,
                len = v30.Magnitude
            }
        end

        t3.L = (t3.legs.Left.len + t3.legs.Right.len) / 2
    end

    t2[p12] = t3
end

for _, v31 in CollectionService:GetTagged("F2FCrew") do
    task.spawn(add, v31)
end

CollectionService:GetInstanceAddedSignal("F2FCrew"):Connect(function(p13) -- line: 97
    -- upvalues: add (copy)
    task.spawn(add, p13)
end)
CollectionService:GetInstanceRemovedSignal("F2FCrew"):Connect(function(p14) -- line: 98
    -- upvalues: t2 (copy)
    t2[p14] = nil
end)

local function riderBike(p15) -- line: 101
    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if RaceBikes and p15 then
        for _, child in RaceBikes:GetChildren() do
            if child:GetAttribute("OwnerUserId") == p15 then
                return child
            end
        end
    end

    return nil
end

local function hold(p16, _, p18, p19) -- line: 107
    -- upvalues: setFade (copy), riderBike (copy)
    local model = p16.model
    local HoldCF = model:GetAttribute("HoldCF")

    if typeof(HoldCF) ~= "CFrame" then
        return
    end

    p16.root.CFrame = HoldCF

    for _, v32 in p16.ik do
        v32.Enabled = true
        v32.Weight = 1
    end

    if p16.legs then
        for _, v33 in p16.legs do
            v33.hip.Transform = CFrame.identity
            v33.knee.Transform = CFrame.identity
            v33.ankle.Transform = CFrame.identity
        end
    end

    local v34 = p19 + p16.seed
    local v36 = math.sin(v34 * 1.6) * 1.1

    if p16.j.Waist then
        local Waist = p16.j.Waist
        local v37 = v36 * 0.4
        local v39 = math.sin(v34 * 0.37) * 2.5
        local v41 = math.sin(v34 * 0.29) * 1.5

        Waist.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v37), math.rad(v39), (math.rad(v41 or 0)))
    end

    if os.clock() - (p16.lookAt or 0) > 0.4 then
        p16.lookAt = os.clock()
        p16.bike = riderBike(model:GetAttribute("OwnerUserId"))
    end

    local bike = p16.bike and p16.bike.Parent and p16.bike.PrimaryPart
    local v45 = if bike and (bike.Position - p16.root.Position).Magnitude < 90 then bike.Position + Vector3.new(0, 2, 0) else nil
    local v46, v47

    if v45 then
        if p16.aim then
            p16.aim = p16.aim:Lerp(v45, (math.min(1, p18 * 5))) or v45
        else
            p16.aim = v45
        end

        local v49 = p16.root.CFrame:PointToObjectSpace(p16.aim)

        v46 = math.clamp(math.deg((math.atan2(-v49.X, -v49.Z))), -70, 70)
        v47 = math.clamp(math.deg((math.atan2(v49.Y - 1.5, (math.sqrt(v49.X ^ 2 + v49.Z ^ 2))))), -35, 10) + 12
    else
        p16.aim = nil
        v46 = math.sin(v34 * 0.23) * 22
        v47 = math.sin(v34 * 0.7) * 3 + -10
    end

    p16.headYaw = (p16.headYaw or v46) + (v46 - (p16.headYaw or v46)) * math.min(1, p18 * 4)
    p16.headPitch = (p16.headPitch or v47) + (v47 - (p16.headPitch or v47)) * math.min(1, p18 * 4)

    if p16.j.Neck then
        local Neck = p16.j.Neck
        local headPitch, headYaw = p16.headPitch, p16.headYaw

        Neck.Transform = CFrame.fromEulerAnglesYXZ(math.rad(headPitch), math.rad(headYaw), 0)
    end

    setFade(p16, 0)
end

local function aimLeg(p20, p21, p22, p23, p24) -- line: 143
    local v67 = p20.legs[p21]
    local v68 = p22 * v67.rel
    local v69 = v68:VectorToObjectSpace(p23 - v68.Position)
    local identity = CFrame.identity

    if v69.Magnitude > 0.001 then
        local Unit = v69.Unit
        local v70 = v67.rest:Cross(Unit)

        if v70.Magnitude > 1E-05 then
            identity = CFrame.fromAxisAngle(v70.Unit, (math.acos((math.clamp(v67.rest:Dot(Unit), -1, 1)))))
        end
    end

    v67.hip.Transform = identity * CFrame.Angles(0.32 * p24, 0, 0)
    v67.knee.Transform = CFrame.Angles(-0.85 * p24, 0, 0)
    v67.ankle.Transform = CFrame.Angles(0.4 * p24, 0, 0)
end

local function bodyHeight(p25, p26, p27, p28, p29, p30, p31, p32) -- line: 159
    local n1 = 1e999

    for _, v73 in p29 do
        local v74 = p26 * p25.legs[if v73[2] then "Left" else "Right"].rel.Position
        local v77 = Vector3.new(v73[1].X - (p27 + v74.X), 0, v73[1].Z - (p28 + v74.Z))

        n1 = math.min(n1, v73[1].Y + math.sqrt((math.max(p25.L * p25.L - v77:Dot(v77), 0.5))) - v74.Y)
    end

    if n1 == 1e999 then
        n1 = p30 + p31
    end

    return n1 - math.max((p32 or 0) - math.max(p30 + p31 - n1, 0), 0) * 0.35
end

local function goHome(p33, p34, _, p36) -- line: 170
    -- upvalues: GridOfficialMotion (copy), t1 (copy), setFade (copy), aimLeg (copy), bodyHeight (copy)
    local model = p33.model
    local HoldCF = model:GetAttribute("HoldCF")
    local HomePos = model:GetAttribute("HomePos")

    if typeof(HoldCF) ~= "CFrame" or typeof(HomePos) ~= "Vector3" then
        return
    end

    local v84 = model:GetAttribute("WalkSpeed") or 6
    local v85 = model:GetAttribute("RootAboveFloor") or 3.19
    local HoldCFPosition = HoldCF.Position
    local v86 = HoldCFPosition.Y - v85
    local v87 = HomePos - HoldCFPosition
    local v88 = Vector3.new(v87.X, 0, v87.Z)
    local Magnitude = v88.Magnitude
    local LookVector = HoldCF.LookVector
    local Unit = Vector3.new(LookVector.X, 0, LookVector.Z).Unit
    local v89 = Magnitude > 0.05 and v88.Unit or Unit
    local v90 = p36 + p33.seed
    local v92 = math.clamp(p34 / 0.35, 0, 1)
    local v93 = v92 * v92 * (3 - 2 * v92)

    for _, v94 in p33.ik do
        v94.Weight = 1 - v93
        v94.Enabled = v93 < 1
    end

    local j = p33.j
    local v96 = math.max(p34 - 0.45, 0)
    local v98 = math.min(GridOfficialMotion.Travel(v96, v84), Magnitude)
    local v99 = p34 > 0.45 and v98 < Magnitude - 0.02 and math.clamp(GridOfficialMotion.Speed(v96, v84) / v84, 0, 1) or 0

    setFade(p33, (math.clamp((p34 - (0.45 + GridOfficialMotion.Duration(Magnitude, v84))) / 0.45, 0, 1)))

    if p33.legs then
        local v104 = math.atan2(-Unit.X, -Unit.Z)
        local v107 = math.atan2(-v89.X, -v89.Z)
        local v108 = (v107 - v104 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
        local v109 = v108 > 0
        local v112 = Vector3.new(math.cos(v104), 0, -math.sin(v104))
        local v115 = Vector3.new(math.cos(v107), 0, -math.sin(v107))
        local L = p33.L
        local v118 = math.min(t1[1] + t1[2] * math.max(v84, 0.5), t1[3])
        local v119 = 4 * L * math.sin(v118)
        local v120 = Vector3.new(HoldCFPosition.X, v86, HoldCFPosition.Z)
        local v122 = (v112 * ((if v109 then 1 else -1) * 0.5)):Dot(v89)
        local v123 = v122 + v119 / 4

        local function foot(p37) -- line: 210
            -- upvalues: v98 (copy), v112 (copy), v115 (copy), v119 (copy), v120 (copy), v109 (copy), v122 (copy), v123 (copy), v89 (copy)
            local v124 = p37 == v109
            local v126 = v120 + v112 * (if v124 then -0.5 else 0.5)

            local function spot(p38) -- line: 213
                -- upvalues: p37 (copy), v124 (copy), v126 (copy), v115 (copy), v119 (copy), v120 (copy), v122 (copy), v89 (copy)
                if p38 < 0 or p38 == 0 and not p37 then
                    return v126
                end

                return v120 + v89 * (v122 + (p37 and v119 / 2 or 0) + p38 * v119) + v115 * (if v124 then -0.5 else 0.5)
            end

            if v98 <= 0.001 then
                return v126, true, 0, v124
            end

            local v130 = p37 and (v98 - v122 - v119 / 4) / v119 or (v98 - v122 + v119 / 4) / v119
            local v131 = math.floor(v130)
            local v132 = v130 - v131

            if v132 < 0.5 then
                local v133

                if not (v131 < 0) and (v131 ~= 0 or p37) then
                    local v134 = if p37 then v119 / 2 else nil

                    if not p37 or not v134 then
                        v134 = 0
                    end

                    v133 = v120 + v89 * (v122 + v134 + v131 * v119) + v115 * (if v124 then -0.5 else 0.5)
                else
                    v133 = v126
                end

                return v133, true, 0, v124
            end

            local v137, v138

            if p37 and v131 == -1 then
                local v140 = math.clamp(v98 / v123, 0, 1)
                local v141 = v140 * v140 * v140 * (v140 * (v140 * 6 - 15) + 10)

                if v141 then
                    v137 = v141
                    v138 = true
                else
                    v138 = false
                end
            else
                v138 = false
            end

            if not v138 then
                local v143 = math.clamp((v132 - 0.5) / 0.5, 0, 1)

                v137 = v143 * v143 * v143 * (v143 * (v143 * 6 - 15) + 10)
            end

            local v144

            if not (v131 < 0) and (v131 ~= 0 or p37) then
                local v145 = if p37 then v119 / 2 else nil

                if not p37 or not v145 then
                    v145 = 0
                end

                v144 = v120 + v89 * (v122 + v145 + v131 * v119) + v115 * (if v124 then -0.5 else 0.5)
            else
                v144 = v126
            end

            local v148 = v131 + 1

            if v148 < 0 or v148 == 0 and not p37 then
                return v144:Lerp(v126, v137), false, v137, v124
            end

            local v150 = if p37 then v119 / 2 else nil

            if not p37 or not v150 then
                v150 = 0
            end

            return v144:Lerp(v120 + v89 * (v122 + v150 + v148 * v119) + v115 * (if v124 then -0.5 else 0.5), v137), false, v137, v124
        end

        local v153, v154, v155, v156 = foot(false)
        local v157, v158, v159 = foot(true)
        local v162 = (if v156 then -1 else 1) * math.sin(6.283185307179586 * (v98 - v122) / v119) * v99
        local v163 = 0.42 * v162
        local v164 = 0.04 * v162
        local v165 = 0.08 * v162
        local v166 = 0

        if p34 > 0.45 then
            local v168 = math.clamp(v96 / 0.8, 0, 1)

            v166 = v168 * v168 * (3 - 2 * v168) or 0
        end

        local v169 = v104 + v108 * v166
        local v170 = CFrame.Angles(0, v169, 0) * CFrame.Angles(0, v165, v164)
        local v171 = Vector3.new(HoldCFPosition.X, 0, HoldCFPosition.Z) + v89 * v98
        local t4 = {}

        if v154 then
            table.insert(t4, {
                v153,
                v156
            })
        end

        if v158 then
            table.insert(t4, {
                v157,
                not v156
            })
        end

        local v174 = bodyHeight(p33, v170, v171.X, v171.Z, t4, v86, v85, L * (1 - math.cos(v118)) * v99) + math.sin(v90 * 1.7) * 0.025 * (1 - v99)
        local v175 = CFrame.new(v171.X, v174, v171.Z) * v170

        p33.root.CFrame = v175

        local v176 = if not v156 or not v153 then v157 else v153

        if v156 and v157 then
            v153 = v157
        end

        local v177 = if not v156 or not v155 then v159 else v155

        if v156 and v159 then
            v155 = v159
        end

        local v178 = if not v156 or not v154 then not v156 and v158 else v154

        if not v156 or not v158 then
            v158 = not v156 and v154
        end

        aimLeg(p33, "Left", v175, v176, if v178 then 0 else math.sin(3.141592653589793 * v177))
        aimLeg(p33, "Right", v175, v153, if v158 then 0 else math.sin(3.141592653589793 * v155))

        if v93 >= 1 then
            if j.LeftShoulder then
                j.LeftShoulder.Transform = CFrame.Angles(-v163 * 0.8, 0, -0.06)
            end

            if j.RightShoulder then
                j.RightShoulder.Transform = CFrame.Angles(v163 * 0.8, 0, 0.06)
            end

            if j.LeftElbow then
                j.LeftElbow.Transform = CFrame.Angles(math.max(-v163, 0) * 0.12 + 0.2, 0, 0)
            end

            if j.RightElbow then
                j.RightElbow.Transform = CFrame.Angles(math.max(v163, 0) * 0.12 + 0.2, 0, 0)
            end
        end

        if p34 < 0.45 then
            if j.Waist then
                j.Waist.Transform = CFrame.identity
            end

            if j.Neck then
                local Neck = j.Neck
                local v184 = (p33.headPitch or 0) * (1 - v93)
                local v185 = (p33.headYaw or 0) * (1 - v93)

                Neck.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v184), math.rad(v185), 0)
            end
        else
            if j.Waist then
                j.Waist.Transform = CFrame.Angles(0, -1.4 * v165, 0)
            end

            local v189 = math.sin(v90 * 0.9) * 0.2 * v99 + math.sin(v90 * 0.37) * 0.12 * (1 - v99)

            if j.Neck then
                j.Neck.Transform = CFrame.Angles(0, 0.4 * v165 + v189, 0) * CFrame.Angles(math.sin(v90 * 0.23) * 0.03, 0, 0)
            end
        end
    else
        local v194 = math.atan2(-Unit.X, -Unit.Z)
        local v197 = math.atan2(-Unit.X, -Unit.Z)
        local v200 = (math.atan2(-v89.X, -v89.Z) - v197 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
        local v202 = math.clamp(v96 / 0.8, 0, 1)
        local v203 = v194 + v200 * (v202 * v202 * (3 - 2 * v202))

        p33.root.CFrame = CFrame.new(HoldCFPosition + v89 * v98) * CFrame.Angles(0, v203, 0)
    end
end

RunService.Stepped:Connect(function(_, p40) -- line: 264
    -- upvalues: t2 (copy), hold (copy), goHome (copy)
    if next(t2) == nil then
        return
    end

    local ServerTimeNow = workspace:GetServerTimeNow()
    local elapsed = os.clock()
    local CurrentCamera = workspace.CurrentCamera
    local v204 = CurrentCamera and CurrentCamera.CFrame.Position

    for v205, v206 in t2 do
        if v205.Parent then
            local v207 = not v206.posed or not v204 or (v206.root.Position - v204).Magnitude < 260
            local v208 = v205:GetAttribute("ReleaseAt") or 0

            if v207 or v208 > 0 and v208 <= ServerTimeNow then
                v206.posed = true

                if v208 <= 0 or ServerTimeNow < v208 then
                    hold(v206, ServerTimeNow, p40, elapsed)
                else
                    goHome(v206, ServerTimeNow - v208, p40, elapsed)
                end
            end
        else
            t2[v205] = nil
        end
    end
end)

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local t7 = {}
local t8 = {}

RunService.RenderStepped:Connect(function() -- line: 290
    -- upvalues: t8 (copy)
    if next(t8) == nil then
        return
    end

    local v209 = os.clock() / 2

    for _, v210 in t8 do
        for v211, v212 in v210 do
            local v213 = (v209 + (v211 - 1) * 0.5) % 1
            local v214 = 1 - (1 - v213) ^ 3

            v212.frame.Size = UDim2.fromOffset(170 + 44 * v214, 30 + 44 * v214)
            v212.stroke.Transparency = 1 - 0.8 * (1 - v213) ^ 2
        end
    end
end)

local function addSpare(p41) -- line: 304
    -- upvalues: LocalPlayer (copy), PlayerGui (copy), t7 (copy), t8 (copy)
    if not p41:IsA("BasePart") or t7[p41] or p41:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId then
        return
    end

    local v215 = p41:GetAttribute("Tyre") == "Wet"
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "F2FSpareMarker"
    BillboardGui.Adornee = p41
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.Size = UDim2.fromOffset(214, 70)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 5.2, 0)
    BillboardGui.MaxDistance = 1200
    BillboardGui.ResetOnSpawn = false

    local v216 = v215 and Color3.fromRGB(40, 140, 255) or Color3.fromRGB(245, 245, 245)
    local Frame = Instance.new("Frame")

    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Position = UDim2.new(0.5, 0, 0, 22)
    Frame.Size = UDim2.fromOffset(170, 30)
    Frame.BackgroundColor3 = v216
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 2
    Frame.Parent = BillboardGui

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame

    local t9 = {}

    for i = 1, 2 do
        local Frame = Instance.new("Frame")

        Frame.Name = "Pulse" .. i
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.new(0.5, 0, 0, 37)
        Frame.Size = UDim2.fromOffset(170, 30)
        Frame.BackgroundTransparency = 1
        Frame.ZIndex = 1
        Frame.Parent = BillboardGui

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Frame

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = v216
        UIStroke.Thickness = 2
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = Frame
        t9[i] = {
            frame = Frame,
            stroke = UIStroke,
            corner = UICorner
        }
    end

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Tip"
    Frame2.AnchorPoint = Vector2.new(0.5, 0)
    Frame2.Position = UDim2.new(0.5, 0, 0, 58)
    Frame2.Size = UDim2.fromOffset(16, 8)
    Frame2.BackgroundTransparency = 1
    Frame2.ZIndex = 2
    Frame2.Parent = BillboardGui

    for i = 0, 7 do
        local v217 = (1 - (i + 0.5) / 8) * 16
        local Frame = Instance.new("Frame")

        Frame.AnchorPoint = Vector2.new(0.5, 0)
        Frame.Position = UDim2.new(0.5, 0, 0, i)
        Frame.Size = UDim2.new(0, math.max(1, (math.floor(v217 + 0.5))), 0, 1)
        Frame.BackgroundColor3 = Color3.new(0, 0, 0)
        Frame.BackgroundTransparency = 0.25
        Frame.BorderSizePixel = 0
        Frame.ZIndex = 2
        Frame.Parent = Frame2
    end

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
    TextLabel.TextSize = 15
    TextLabel.TextColor3 = v215 and Color3.new(1, 1, 1) or Color3.fromRGB(16, 18, 22)
    TextLabel.Text = v215 and "YOUR WET BIKE" or "YOUR DRY BIKE"
    TextLabel.ZIndex = 3
    TextLabel.Parent = Frame
    BillboardGui.Parent = PlayerGui
    t7[p41] = BillboardGui
    t8[BillboardGui] = t9
    BillboardGui.Destroying:Connect(function() -- line: 339
        -- upvalues: BillboardGui (copy), t8 (copy)
        t8[BillboardGui] = nil
    end)

    local function upd() -- line: 340
        -- upvalues: p41 (copy), BillboardGui (copy), t7 (copy)
        if p41:GetAttribute("Swapped") == true or not p41.Parent then
            BillboardGui:Destroy()
            t7[p41] = nil
        end
    end

    p41:GetAttributeChangedSignal("Swapped"):Connect(upd)
    p41.Destroying:Connect(function() -- line: 344
        -- upvalues: p41 (copy), t7 (copy)
        if t7[p41] then
            t7[p41]:Destroy()
            t7[p41] = nil
        end
    end)

    if p41:GetAttribute("Swapped") == true or not p41.Parent then
        BillboardGui:Destroy()
        t7[p41] = nil
    end
end

for _, v220 in CollectionService:GetTagged("F2FSpare") do
    task.spawn(addSpare, v220)
end

CollectionService:GetInstanceAddedSignal("F2FSpare"):Connect(function(p42) -- line: 348
    -- upvalues: addSpare (copy)
    task.defer(addSpare, p42)
end)
CollectionService:GetInstanceRemovedSignal("F2FSpare"):Connect(function(p43) -- line: 349
    -- upvalues: t7 (copy)
    local v221 = t7[p43]

    if v221 then
        v221:Destroy()
        t7[p43] = nil
    end
end)
