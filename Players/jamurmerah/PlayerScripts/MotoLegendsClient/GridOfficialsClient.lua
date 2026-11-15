-- https://lua.expert

local RunService = game:GetService("RunService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local GridOfficialMotion = require(MotoLegends:WaitForChild("GridOfficialMotion"))
local t1 = {
    -0.1, 2.75
}
local t2 = {
    0.15, 1.1
}
local t3 = {
    0.34, 0.04, 0.52
}
local _ = {
    Rate = 6.6,
    Top = 1.25,
    Mid = 0.5,
    Amp = 0.72,
    OutMid = 0.3,
    OutAmp = 0.2,
    Wrist = 0.6,
    WristMin = -0.15,
    WristMax = 1.3,
    PoleHz = 2.6,
    PoleZeta = 0.5
}
local _ = {
    N = 10,
    Thick = 0.05,
    Lag = 0.026,
    Twist = 0.12,
    Drag = 0.3,
    Hz = 3.4,
    Zeta = 0.42,
    Wind = 0.4,
    Ripple = 0.1,
    RippleFast = 0.025,
    RippleMax = 0.38,
    RippleK = 1.05,
    RippleW = 9,
    RippleWFast = 0.35
}
local Unit = (Vector3.new(0.8, 0, 0.6)).Unit
local t4 = {}

local function clamp01(p1) -- line: 83
    return (math.clamp(p1, 0, 1))
end

local function smooth(p2) -- line: 84
    local v1 = math.clamp(p2, 0, 1)

    return v1 * v1 * (3 - 2 * v1)
end

local function smoother(p3) -- line: 85
    local v2 = math.clamp(p3, 0, 1)

    return v2 * v2 * v2 * (v2 * (v2 * 6 - 15) + 10)
end

local function win(p4, p5, p6) -- line: 86
    local v4 = math.clamp((p4 - p5) / (p6 - p5), 0, 1)

    return v4 * v4 * (3 - 2 * v4)
end

local function band(p7, p8, p9, p10, p11) -- line: 87
    local v6 = math.clamp((p7 - p8) / (p9 - p8), 0, 1)
    local v7 = v6 * v6 * (3 - 2 * v6)
    local v9 = math.clamp((p7 - p10) / (p11 - p10), 0, 1)

    return v7 * (1 - v9 * v9 * (3 - 2 * v9))
end

local function lerp(p12, p13, p14) -- line: 88
    return p12 + (p13 - p12) * p14
end

local function yawOf(p15) -- line: 89
    return (math.atan2(-p15.X, -p15.Z))
end

local function angleTo(p16, p17) -- line: 90
    return (p17 - p16 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

local function flat(p18) -- line: 91
    return (Vector3.new(p18.X, 0, p18.Z))
end

local function wander(p19, p20) -- line: 93
    return math.noise(p19, p20, 0.31) * 1.3 + math.noise(p19 * 2.3, p20 + 4.7, 0.77) * 0.6
end

local function hash(p21, p22) -- line: 94
    local v13 = math.sin(p21 * 127.1 + p22 * 311.7) * 43758.5453

    return v13 - math.floor(v13)
end

local function held(p23, p24, p25, p26) -- line: 95
    local v15 = math.floor(p23 / p25)
    local v16 = v15 * p25
    local v17 = p24 + 0.37
    local v19 = math.sin(v15 * 127.1 + v17 * 311.7) * 43758.5453
    local v20 = v16 + (v19 - math.floor(v19)) * p25 * 0.45
    local v22 = math.sin((v15 - 1) * 127.1 + p24 * 311.7) * 43758.5453
    local v23 = v22 - math.floor(v22)
    local v25 = math.sin(v15 * 127.1 + p24 * 311.7) * 43758.5453
    local v26 = v25 - math.floor(v25)
    local v28 = math.clamp((p23 - v20) / p26, 0, 1)
    local v29 = v28 * v28 * v28 * (v28 * (v28 * 6 - 15) + 10)

    return (v23 + (v26 - v23) * v29) * 2 - 1
end

local function spring(p27, p28, p29, p30, p31) -- line: 101
    local v30 = 6.283185307179586 * p29
    local v33 = math.max(1, (math.ceil(p31 * 120)))
    local v34 = p31 / v33

    for _ = 1, v33 do
        p27.v += (v30 * v30 * (p28 - p27.x) - 2 * p30 * v30 * p27.v) * v34
        p27.x += p27.v * v34
    end

    return p27.x
end

local function rig(p32) -- line: 111
    -- upvalues: t4 (copy)
    local v35 = t4[p32]

    if v35 then
        return v35
    end

    local Torso = p32:FindFirstChild("Torso")
    local HumanoidRootPart = p32:FindFirstChild("HumanoidRootPart")
    local v36 = p32:FindFirstChild("Right Arm")

    if not (Torso and HumanoidRootPart and v36) then
        return nil
    end

    local v37 = Torso:FindFirstChild("Left Shoulder")
    local v38 = Torso:FindFirstChild("Right Shoulder")
    local v39 = Torso:FindFirstChild("Left Hip")
    local v40 = Torso:FindFirstChild("Right Hip")

    if not (v37 and v38 and v39 and v40) then
        return nil
    end

    v37.C1 = CFrame.new(0, 1, 0)
    v38.C1 = CFrame.new(0, 1, 0)
    v39.C1 = CFrame.new(0, 1, 0)
    v40.C1 = CFrame.new(0, 1, 0)

    local FlagPole = p32:FindFirstChild("FlagPole")
    local FlagPoleWeld = v36:FindFirstChild("FlagPoleWeld")
    local child, Part1

    if FlagPole then
        local child2, Part1_2

        for _, child3 in FlagPole:GetChildren() do
            if child3:IsA("Motor6D") and child3.Name:match("Flag[Ww]eld$") then
                child2 = child3
                Part1_2 = child3.Part1
            end

            Part1 = Part1_2
            child = child2
        end
    end

    local t5 = {}
    local t6 = {}

    for _, descendant in p32:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t5, descendant)
        elseif descendant:IsA("Decal") then
            table.insert(t6, {
                d = descendant,
                base = descendant.Transparency
            })
        end
    end

    local Neck = Torso:FindFirstChild("Neck")
    local v41 = math.random() * 20
    local t8 = {
        fade = 0,
        ls = v37,
        rs = v38,
        lh = v39,
        rh = v40,
        neck = Neck,
        neckC0 = Neck and Neck.C0,
        rootJoint = HumanoidRootPart:FindFirstChild("RootJoint"),
        pole = FlagPole,
        poleJoint = FlagPoleWeld,
        cloth = child,
        clothPart = Part1,
        clothC0 = child and child.C0,
        parts = t5,
        decals = t6,
        seed = v41,
        breath = 3.4 + v41 % 1 * 0.8,
        red = p32:GetAttribute("Official") == "Red",
        lag = {
            x = 0,
            v = 0
        },
        flap = {
            x = 0,
            v = 0
        }
    }

    t4[p32] = t8

    return t8
end

local function setFade(p33, p34) -- line: 140
    if math.abs(p34 - p33.fade) < 0.01 then
        return
    end

    p33.fade = p34

    for _, v43 in p33.parts do
        if v43.Parent then
            v43.LocalTransparencyModifier = p34
        end
    end

    for _, v44 in p33.decals do
        if v44.d.Parent then
            v44.d.Transparency = v44.base + (1 - v44.base) * p34
        end
    end
end

local function torsoOf(p35, p36) -- line: 147
    local rootJoint = p35.rootJoint

    return rootJoint and p36 * rootJoint.C0 * rootJoint.C1:Inverse() or p36
end

local function armCF(p37, p38, p39) -- line: 151
    return p37 * p39 * p38.C1:Inverse()
end

local function shoulderX(p40) -- line: 154
    return math.clamp((math.abs(p40) - 0.6) / 1.9, 0, 1) * -0.19999999999999996 + 1.5
end

local function shoulderC0(p41, p42, p43) -- line: 155
    local v47 = math.clamp((math.abs(p43) - 0.6) / 1.9, 0, 1) * -0.19999999999999996 + 1.5
    local new = CFrame.new
    local v48 = if p41 then -v47 else nil

    if p41 and v48 then
        v47 = v48
    end

    return new(v47, 1, 0) * CFrame.Angles(p42, 0, p43)
end

local function aimLeg(p44, p45, p46, p47, p48) -- line: 158
    local v50 = Vector3.new(if p46 then -0.5 else 0.5, -1, 0)
    local v51 = p45:VectorToObjectSpace(p47 - p45 * v50)
    local v52, v53

    if v51.Magnitude > 0.001 then
        local Unit = v51.Unit

        v53 = math.asin((math.clamp(Unit.X, -1, 1)))
        v52 = math.atan2(-Unit.Z, -Unit.Y)
    else
        v52 = 0
        v53 = 0
    end

    p44.C0 = CFrame.new(v50) * CFrame.Angles(v52 + (p48 or 0), 0, v53)
end

local function bodyHeight(p49, p50, p51, p52, p53, p54) -- line: 173
    local n1 = 1e999

    for _, v57 in p52 do
        local v59 = p49 * Vector3.new(if v57[2] then -0.5 else 0.5, -1, 0)
        local v62 = Vector3.new(v57[1].X - (p50 + v59.X), 0, v57[1].Z - (p51 + v59.Z))

        n1 = math.min(n1, v57[1].Y + math.sqrt((math.max(4 - v62:Dot(v62), 0.5))) - v59.Y)
    end

    return n1 - math.max((p54 or 0) - math.max(p53 + 3 - n1, 0), 0) * 0.35
end

local function setHead(p55, p56, p57, p58) -- line: 183
    if p55.neck and p55.neckC0 then
        p55.neck.C0 = p55.neckC0 * CFrame.Angles(0, 0, p57) * CFrame.Angles(p56, p58, 0)
    end
end

local function holdRedFlag(p59, p60, p61, p62) -- line: 191
    -- upvalues: t1 (copy), t2 (copy)
    if not (p59.poleJoint and p59.pole and p59.cloth and p59.clothPart) then
        return
    end

    local rootJoint = p59.rootJoint
    local v69 = rootJoint and p60 * rootJoint.C0 * rootJoint.C1:Inverse() or p60
    local v70 = t1[1] + p62
    local v71 = t1[2] + p61
    local v73 = math.clamp((math.abs(v71) - 0.6) / 1.9, 0, 1) * -0.19999999999999996 + 1.5
    local v74 = CFrame.new(v73, 1, 0) * CFrame.Angles(v70, 0, v71)

    p59.rs.C0 = v74

    local rs = p59.rs
    local v75 = v69 * v74 * rs.C1:Inverse()
    local v76 = v75 * Vector3.new(0, -0.85, 0)
    local UpVector, RightVector = v69.UpVector, v69.RightVector
    local X, Y = p59.clothPart.Size.X, p59.clothPart.Size.Y
    local Y2 = p59.pole.Size.Y
    local v77 = Y2 - 0.4 - Y
    local v78 = v69 * Vector3.new(-1.3210526315789475, 1, 0)

    local function frame(p63) -- line: 204
        -- upvalues: v76 (copy), UpVector (copy), RightVector (copy), X (copy), v77 (copy)
        local v79 = UpVector * math.cos(p63) - RightVector * math.sin(p63)
        local v80 = -RightVector * math.cos(p63) - UpVector * math.sin(p63)

        return v79, v80, v76 + v79 * v77 + v80 * X
    end

    local function gap(p64) -- line: 209
        -- upvalues: v76 (copy), UpVector (copy), RightVector (copy), X (copy), v77 (copy), v78 (copy)
        local v81 = UpVector * math.cos(p64) - RightVector * math.sin(p64)
        local v82 = -RightVector * math.cos(p64) - UpVector * math.sin(p64)

        return (v76 + v81 * v77 + v82 * X - v78).Magnitude - 1.85
    end

    local v83 = t2[1]
    local v84 = t2[2]
    local v85 = UpVector * math.cos(v83) - RightVector * math.sin(v83)
    local v86 = -RightVector * math.cos(v83) - UpVector * math.sin(v83)
    local v87 = 0.5

    if (v76 + v85 * v77 + v86 * X - v78).Magnitude - 1.85 > 0 then
        local v88 = UpVector * math.cos(v84) - RightVector * math.sin(v84)
        local v89 = -RightVector * math.cos(v84) - UpVector * math.sin(v84)

        if (v76 + v88 * v77 + v89 * X - v78).Magnitude - 1.85 < 0 then
            for _ = 1, 14 do
                local v90 = (v83 + v84) / 2
                local v91 = UpVector * math.cos(v90) - RightVector * math.sin(v90)
                local v92 = -RightVector * math.cos(v90) - UpVector * math.sin(v90)

                if (v76 + v91 * v77 + v92 * X - v78).Magnitude - 1.85 > 0 then
                    v83 = v90
                else
                    v84 = v90
                end
            end

            v87 = (v83 + v84) / 2
        end
    end

    local v93 = UpVector * math.cos(v87) - RightVector * math.sin(v87)
    local v94 = -RightVector * math.cos(v87) - UpVector * math.sin(v87)
    local v95 = v69:VectorToObjectSpace((v76 + v93 * v77 + v94 * X - v78).Unit)
    local v96 = math.abs(v95.Y) > 0.001 and math.atan(v95.Z / v95.Y) or 0
    local v99 = math.atan2(v95.X, -v95.Y / math.cos(v96))

    p59.ls.C0 = CFrame.new(-1.3210526315789475, 1, 0) * CFrame.Angles(v96, 0, v99)

    local v100 = CFrame.fromMatrix(v76 + v93 * (Y2 / 2 - 0.4), v94, v93)
    local v101 = CFrame.fromMatrix(v76 + v93 * (Y2 - 0.4 - Y / 2) + v94 * (X / 2), v94, v93)

    p59.poleJoint.C0 = v75:Inverse() * v100 * p59.poleJoint.C1
    p59.cloth.C0 = v100:Inverse() * v101 * p59.cloth.C1
end

local function animateRed(p65, p66, p67) -- line: 228
    -- upvalues: held (copy), spring (copy), aimLeg (copy), bodyHeight (copy), holdRedFlag (copy)
    local t, travelled, walk, idle = p67.t, p67.travelled, p67.walk, p67.idle
    local dt = p67.dt
    local v102 = p67.departAt > 0
    local dir = p67.dir.Magnitude > 0 and p67.dir or p67.right
    local v103 = if dir:Dot(p67.right) >= 0 then 1 else -1
    local v104 = v103 < 0
    local v105 = Vector3.new(p67.start.X, p67.ground, p67.start.Z)

    local function at(p68) -- line: 235
        -- upvalues: dir (copy), v105 (copy)
        return v105 + dir * p68
    end

    local v106 = v105 + dir * 0.56
    local v107 = v105 + dir * -0.56
    local v108, v109, v110, v111

    if travelled > 0.001 then
        local v112 = travelled / 1.9
        local v113 = math.floor(v112)

        v108 = v112 - v113

        if v108 < 0.5 then
            local v115 = math.clamp(v108 / 0.5, 0, 1)

            v111 = v115 * v115 * v115 * (v115 * (v115 * 6 - 15) + 10)
            v106 = v105 + dir * (v113 * 1.9 + 0.56 + v111 * 1.9)
            v107 = v105 + dir * (v113 * 1.9 - 0.56)
            v109 = false
            v110 = true
        else
            local v117 = math.clamp((v108 - 0.5) / 0.5, 0, 1)

            v111 = v117 * v117 * v117 * (v117 * (v117 * 6 - 15) + 10)
            v106 = v105 + dir * ((v113 + 1) * 1.9 + 0.56)
            v107 = v105 + dir * (v113 * 1.9 - 0.56 + v111 * 1.9)
            v109 = true
            v110 = false
        end
    else
        v109 = true
        v110 = true
        v111 = 0
        v108 = 0
    end

    local v118 = 1

    if v102 then
        local v120 = math.clamp(t / 0.4, 0, 1)

        v118 = 1 - v120 * v120 * (3 - 2 * v120) or 1
    end

    local v122 = math.sin(idle * 2 * 3.141592653589793 / p66.breath)
    local v123 = 0.09 * held(idle * 0.85, p66.seed, 5.5, 1.6)
    local v124 = idle * 0.4
    local v125 = p66.seed + 2
    local v126 = (v123 + 0.012 * (math.noise(v124, v125, 0.31) * 1.3 + math.noise(v124 * 2.3, v125 + 4.7, 0.77) * 0.6)) * v118
    local start = p67.start
    local v127 = Vector3.new(start.X, 0, start.Z) + dir * travelled + p67.right * v126
    local v130 = 0.35 * v126 - v103 * (math.sin(6.283185307179586 * v108) * 0.02 + 0.045) * walk
    local v131 = -v103 * 0.06 * walk
    local v132 = -0.035 * walk
    local v133 = CFrame.Angles(0, p67.faceYaw, 0) * CFrame.Angles(v132, v131, v130)
    local t9 = {}

    if v109 then
        table.insert(t9, {
            v106,
            v104
        })
    end

    if v110 then
        table.insert(t9, {
            v107,
            not v104
        })
    end

    local v134 = bodyHeight(v133, v127.X, v127.Z, t9, p67.ground, 0.2737613143021038 * walk)
    local v135 = CFrame.new(v127.X, v134, v127.Z) * v133

    p65:PivotTo(v135)

    local rootJoint = p66.rootJoint
    local v136 = rootJoint and v135 * rootJoint.C0 * rootJoint.C1:Inverse() or v135
    local v138 = math.sin(3.141592653589793 * v111) * 0.16
    local v139 = if v104 then not v109 or not v104 and not v110 else not v104 and not v110
    local v140 = if v104 then v104 and not v110 else not v109 or v104 and not v110

    aimLeg(p66.lh, v136, true, if not v104 or not v106 then v107 else v106, if not v139 or not v138 then 0 else v138)

    local rh = p66.rh

    if v104 and v107 then
        v106 = v107
    end

    if not v140 or not v138 then
        v138 = 0
    end

    aimLeg(rh, v136, false, v106, v138)

    local v141, v142

    if p66.lastY and dt > 0 then
        local v143 = (v134 - p66.lastY) / dt

        if v143 then
            v141 = v143
            v142 = true
        else
            v142 = false
        end
    else
        v142 = false
    end

    if not v142 then
        v141 = 0
    end

    p66.lastY = v134

    local v145 = spring(p66.lag, math.clamp(-v141 * 0.03, -0.08, 0.08), 2.4, 0.32, dt)
    local v147 = math.floor(idle / 6.8)
    local v148 = idle - v147 * 6.8 - 1
    local seed = p66.seed
    local v150 = math.sin(v147 * 127.1 + seed * 311.7) * 43758.5453
    local v151 = (v148 - (v150 - math.floor(v150)) * 3.5) / 0.8
    local v152 = if v151 > 0 and v151 < 1 then math.sin(3.141592653589793 * v151) ^ 2 else 0
    local v154 = idle * 0.33
    local v155 = p66.seed + 5
    local v156 = (0.045 * (math.noise(v154, v155, 0.31) * 1.3 + math.noise(v154 * 2.3, v155 + 4.7, 0.77) * 0.6) + v122 * 0.02 + v152 * 0.08) * v118 + v145
    local v157 = idle * 0.27
    local v158 = p66.seed + 8

    holdRedFlag(p66, v135, v156, (0.03 * (math.noise(v157, v158, 0.31) * 1.3 + math.noise(v157 * 2.3, v158 + 4.7, 0.77) * 0.6) - v152 * 0.05) * v118 + v122 * 0.012)

    local v160 = idle * 0.4
    local v161 = p66.seed + 3
    local v162 = 0.035 * (math.noise(v160, v161, 0.31) * 1.3 + math.noise(v160 * 2.3, v161 + 4.7, 0.77) * 0.6)
    local v163 = 0.04 + 0.03 * held(idle * 0.7, p66.seed + 17, 3.3, 0.6) + v122 * 0.008
    local v164 = 0

    if v102 then
        local v166 = math.clamp((t - 0) / 0.32, 0, 1)
        local v167 = v166 * v166 * (3 - 2 * v166)
        local v169 = math.clamp((t - 0.95) / 0.5, 0, 1)
        local v170 = 0.85 * (v167 * (1 - v169 * v169 * (3 - 2 * v169)))
        local v172 = math.clamp((t - 3.1) / 0.2999999999999998, 0, 1)
        local v173 = v172 * v172 * (3 - 2 * v172)
        local v175 = math.clamp((t - 3.9) / 0.3999999999999999, 0, 1)

        v164 = v170 + 0.55 * (v173 * (1 - v175 * v175 * (3 - 2 * v175))) or 0
    end

    local v176 = v163 * (1 - 0.6 * v164)
    local v177 = v162 * v118
    local v178 = v177 + (-v103 * 0.95 - v177) * v164 - v131
    local v179 = -v130 * 0.8

    if p66.neck and p66.neckC0 then
        p66.neck.C0 = p66.neckC0 * CFrame.Angles(0, 0, v178) * CFrame.Angles(v176, v179, 0)
    end
end

local function clothStep(p69, p70, p71, p72, p73, p74, p75) -- line: 284
    -- upvalues: Unit (copy)
    local clothPart = p70.clothPart
    local X, Y = clothPart.Size.X, clothPart.Size.Y
    local v180 = X / 10

    clothPart.LocalTransparencyModifier = 1

    if not p70.strips then
        p70.strips = {}

        for i = 1, 10 do
            local Part = Instance.new("Part")

            Part.Name = "GreenFlagStrip"
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.Massless = true
            Part.CastShadow = true
            Part.Color = clothPart.Color
            Part.Material = Enum.Material.Fabric
            Part.TopSurface = Enum.SurfaceType.Smooth
            Part.BottomSurface = Enum.SurfaceType.Smooth
            Part.Size = Vector3.new(v180, Y, 0.05)
            Part.LocalTransparencyModifier = p70.fade
            Part.Parent = p69
            p70.strips[i] = Part
            table.insert(p70.parts, Part)
        end
    end

    local v181 = -p71.YVector
    local v183 = p71 * Vector3.new(0, -p72 / 2, 0)

    local function inPlane(p76) -- line: 302
        -- upvalues: v181 (copy)
        return p76 - v181 * p76:Dot(v181)
    end

    local v184 = v183 - v181 * (Y / 2)
    local v185

    if p70.lastProbe and p73 > 0 then
        v185 = (v184 - p70.lastProbe) / p73

        if v185.Magnitude > 45 then
            v185 = v185.Unit * 45
        end
    else
        v185 = Vector3.new(0, 0, 0)
    end

    p70.lastProbe = v184

    local v186 = p75 * 0.4
    local v187 = p70.seed + 40
    local v188 = Vector3.new(0, -1, 0) + Unit * (0.4 + 0.2 * (math.noise(v186, v187, 0.31) * 1.3 + math.noise(v186 * 2.3, v187 + 4.7, 0.77) * 0.6)) - v185 * 0.3
    local v189 = v188 - v181 * v188:Dot(v181)
    local v190

    if p70.hd then
        local hd = p70.hd

        v190 = hd - v181 * hd:Dot(v181) or Vector3.new(0, 0, 0)
    else
        v190 = Vector3.new(0, 0, 0)
    end

    local Unit2 = (if v190.Magnitude < 0.05 then v189.Magnitude > 0.05 and v189 or p71.XVector else v190).Unit
    local Unit3 = v189.Magnitude > 0.05 and v189.Unit or Unit2
    local v191

    if p70.hv then
        local hv = p70.hv

        v191 = hv - v181 * hv:Dot(v181) or Vector3.new(0, 0, 0)
    else
        v191 = Vector3.new(0, 0, 0)
    end

    local v194 = math.max(1, (math.ceil(p73 * 120)))
    local v195 = p73 / v194

    for _ = 1, v194 do
        local v196 = v191 + (456.3705075063719 * (Unit3 - Unit2) - 17.944777237304898 * v191) * v195
        local v197 = Unit2 + v196 * v195
        local v198 = v197 - v181 * v197:Dot(v181)
        local v199 = v198.Magnitude > 0.001
        local Unit = if v199 then v198.Unit else nil

        Unit2 = if not v199 or not Unit then Unit3 else Unit
        v191 = v196 - v181 * v196:Dot(v181)
    end

    if v191.Magnitude > 30 then
        v191 = v191.Unit * 30
    end

    p70.hd = Unit2
    p70.hv = v191

    local elapsed = os.clock()
    local v200 = p70.hist or {}

    p70.hist = v200
    table.insert(v200, {
        t = elapsed,
        d = Unit2,
        u = v181
    })

    while #v200 > 2 and v200[2].t < elapsed - 0.26 - 0.1 do
        table.remove(v200, 1)
    end

    local function past(p77) -- line: 329
        -- upvalues: elapsed (copy), v200 (copy)
        local v201 = elapsed - p77

        for i = #v200, 1, -1 do
            local v202 = v200[i]

            if v202.t <= v201 then
                local v203 = v200[i + 1]

                if not v203 then
                    return v202.d, v202.u
                end

                local v206 = (v201 - v202.t) / math.max(v203.t - v202.t, 1E-04)

                return v202.d:Lerp(v203.d, v206), v202.u:Lerp(v203.u, v206)
            end
        end

        return v200[1].d, v200[1].u
    end

    local Magnitude = v185.Magnitude
    local v208 = math.min(0.1 + Magnitude * 0.025, 0.38)

    p70.rph = (p70.rph or 0) + p73 * (9 + Magnitude * 0.35)

    local t14 = {}
    local t13 = {}

    t13[0] = v183
    t14[0] = v183 - v181 * Y

    local v209 = p74 + 0.3

    for i = 1, 10 do
        local v210, v211 = past(i * 0.026)
        local v212 = v181:Lerp(v211, 0.12)
        local v213 = v212.Magnitude > 0.001
        local Unit = if v213 then v212.Unit else nil
        local v214 = if not v213 or not Unit then v181 else Unit
        local v215 = v210 - v214 * v210:Dot(v214)
        local v216 = v215.Magnitude > 0.001
        local Unit3 = if v216 then v215.Unit else nil
        local v217 = if not v216 or not Unit3 then Unit2 else Unit3
        local v218 = i / 10
        local v219 = v217:Cross(v214)
        local v220 = v208 * v218 ^ 1.4
        local v222 = v220 * math.sin(i * 1.05 - p70.rph)
        local v224 = v220 * math.sin(i * 1.05 - p70.rph - 0.7)
        local v225 = v217 * v180
        local lastWt = p70.lastWt
        local v226 = if lastWt then p70.lastWt[i - 1] else nil
        local v227 = v225 + v219 * (v222 - (if not lastWt or not v226 then 0 else v226))

        t13[i] = t13[i - 1] + v227.Unit * v180

        local v228 = v217 * v180
        local lastWb = p70.lastWb
        local v229 = if lastWb then p70.lastWb[i - 1] else nil
        local v230 = v228 + v219 * (v224 - (if not lastWb or not v229 then 0 else v229))

        t14[i] = t14[i - 1] + v230.Unit * v180
        p70.lastWb = p70.lastWb or {}
        p70.lastWb[i] = v224

        if t13[i].Y < v209 then
            t13[i] = Vector3.new(t13[i].X, v209, t13[i].Z)
        end

        if t14[i].Y < v209 then
            t14[i] = Vector3.new(t14[i].X, v209, t14[i].Z)
        end

        p70.lastWt = p70.lastWt or {}
        p70.lastWt[i] = v222
    end

    for i = 1, 10 do
        local v231 = t13[i - 1]
        local v232 = t13[i]
        local v233 = t14[i - 1]
        local v234 = t14[i]
        local v235 = (v232 + v234 - (v231 + v233)) / 2
        local v236 = (v231 + v232 - (v233 + v234)) / 2
        local Magnitude = v235.Magnitude
        local Magnitude2 = v236.Magnitude

        if Magnitude > 0.001 and Magnitude2 > 0.001 then
            local v237 = v235 / Magnitude
            local v238 = v236 - v237 * v236:Dot(v237)

            if v238.Magnitude > 0.001 then
                local v239 = p70.strips[i]

                v239.Size = Vector3.new(Magnitude + 0.06, Magnitude2, 0.05)
                v239.CFrame = CFrame.fromMatrix((v231 + v232 + v233 + v234) / 4, v237, v238.Unit)
            end
        end
    end
end

local function animateGreen(p78, p79, p80) -- line: 389
    -- upvalues: t3 (copy), spring (copy), aimLeg (copy), bodyHeight (copy), clothStep (copy)
    local t, travelled, walk, idle = p80.t, p80.travelled, p80.walk, p80.idle
    local v241 = p80.departAt > 0
    local dir = p80.dir.Magnitude > 0 and p80.dir or p80.fwd
    local v244 = math.atan2(-dir.X, -dir.Z)
    local v245 = (v244 - p80.faceYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
    local v246 = v245 > 0
    local v251 = math.min(t3[1] + t3[2] * math.max(p80.speed, 0.5), t3[3])
    local v252 = math.sin(v251) * 8
    local v255 = Vector3.new(math.cos(v244), 0, -math.sin(v244))
    local v256 = Vector3.new(p80.start.X, p80.ground, p80.start.Z)
    local v257 = (p80.right * ((if v246 then 1 else -1) * 0.56)):Dot(dir)
    local v258 = v257 + v252 / 4

    local function foot(p81) -- line: 405
        -- upvalues: p80 (copy), travelled (copy), dir (copy), v252 (copy), v255 (copy), v256 (copy), v246 (copy), v257 (copy), v258 (copy)
        local v259 = p81 == v246
        local v261 = v256 + p80.right * (if v259 then -0.56 else 0.56)

        local function spot(p82) -- line: 408
            -- upvalues: p81 (copy), v259 (copy), v261 (copy), dir (copy), v252 (copy), v255 (copy), v256 (copy), v257 (copy)
            if p82 < 0 or p82 == 0 and not p81 then
                return v261
            end

            return v256 + dir * (v257 + (p81 and v252 / 2 or 0) + p82 * v252) + v255 * (if v259 then -0.56 else 0.56)
        end

        if travelled <= 0.001 then
            return v261, true, 0, v259
        end

        local v265 = p81 and (travelled - v257 - v252 / 4) / v252 or (travelled - v257 + v252 / 4) / v252
        local v266 = math.floor(v265)
        local v267 = v265 - v266

        if v267 < 0.5 then
            local v268

            if not (v266 < 0) and (v266 ~= 0 or p81) then
                local v269 = if p81 then v252 / 2 else nil

                if not p81 or not v269 then
                    v269 = 0
                end

                v268 = v256 + dir * (v257 + v269 + v266 * v252) + v255 * (if v259 then -0.56 else 0.56)
            else
                v268 = v261
            end

            return v268, true, 0, v259
        end

        local v272, v273

        if p81 and v266 == -1 then
            local v275 = math.clamp(travelled / v258, 0, 1)
            local v276 = v275 * v275 * v275 * (v275 * (v275 * 6 - 15) + 10)

            if v276 then
                v272 = v276
                v273 = true
            else
                v273 = false
            end
        else
            v273 = false
        end

        if not v273 then
            local v278 = math.clamp((v267 - 0.5) / 0.5, 0, 1)

            v272 = v278 * v278 * v278 * (v278 * (v278 * 6 - 15) + 10)
        end

        local v279

        if not (v266 < 0) and (v266 ~= 0 or p81) then
            local v280 = if p81 then v252 / 2 else nil

            if not p81 or not v280 then
                v280 = 0
            end

            v279 = v256 + dir * (v257 + v280 + v266 * v252) + v255 * (if v259 then -0.56 else 0.56)
        else
            v279 = v261
        end

        local v283 = v266 + 1

        if v283 < 0 or v283 == 0 and not p81 then
            return v279:Lerp(v261, v272), false, v272, v259
        end

        local v285 = if p81 then v252 / 2 else nil

        if not p81 or not v285 then
            v285 = 0
        end

        return v279:Lerp(v256 + dir * (v257 + v285 + v283 * v252) + v255 * (if v259 then -0.56 else 0.56), v272), false, v272, v259
    end

    local v288, v289, v290, v291 = foot(false)
    local v292, v293, v294 = foot(true)
    local v297 = (if v291 then -1 else 1) * math.sin(6.283185307179586 * (travelled - v257) / v252) * walk
    local dt = p80.dt
    local v299 = math.sin(idle * 2 * 3.141592653589793 / p79.breath)
    local v300, v301

    if v241 then
        local v303 = math.clamp((t - 0.12) / 0.7, 0, 1)

        v300 = v303 * v303 * v303 * (v303 * (v303 * 6 - 15) + 10) or 0

        local v305 = math.clamp((t - 0.6) / 0.9, 0, 1)

        v301 = v305 * v305 * v305 * (v305 * (v305 * 6 - 15) + 10) or 0
    else
        v300 = 0
        v301 = 0
    end

    local v306 = idle * 6.6
    local v307 = idle * 0.07
    local v308 = p79.seed + 30
    local v309 = v306 + 0.2 * (math.noise(v307, v308, 0.31) * 1.3 + math.noise(v307 * 2.3, v308 + 4.7, 0.77) * 0.6)
    local v310 = idle * 0.17
    local v311 = p79.seed + 31
    local v312 = 1 + 0.06 * (math.noise(v310, v311, 0.31) * 1.3 + math.noise(v310 * 2.3, v311 + 4.7, 0.77) * 0.6)
    local v314 = math.sin(v309 - 0.4) * v301
    local faceYaw = p80.faceYaw
    local v315 = 0

    if v241 then
        local v317 = math.clamp(t / 0.8, 0, 1)

        v315 = v317 * v317 * (3 - 2 * v317) or 0
    end

    local v318 = faceYaw + v245 * v315
    local v319 = 0.42 * v297
    local v320 = 0.04 * v297
    local v321 = 0.08 * v297
    local v322 = CFrame.Angles(0, v318, 0) * CFrame.Angles(0.05 * v314, v321 - 0.045 * v314, v320 + 0.022 * v314)
    local start = p80.start
    local v323 = Vector3.new(start.X, 0, start.Z) + dir * travelled
    local t15 = {}

    if v289 then
        table.insert(t15, {
            v288,
            v291
        })
    end

    if v293 then
        table.insert(t15, {
            v292,
            not v291
        })
    end

    local v326 = bodyHeight(v322, v323.X, v323.Z, t15, p80.ground, (1 - math.cos(v251)) * 2 * walk) + math.sin(idle * 1.7) * 0.025 * (1 - walk)
    local v327 = CFrame.new(v323.X, v326, v323.Z) * v322

    p78:PivotTo(v327)

    local rootJoint = p79.rootJoint
    local v328 = if rootJoint then v327 * rootJoint.C0 * rootJoint.C1:Inverse() else nil

    if rootJoint and v328 then
        v327 = v328
    end

    local v329 = if not v291 or not v288 then v292 else v288

    if v291 and v292 then
        v288 = v292
    end

    local v330 = if not v291 or not v290 then v294 else v290

    if v291 and v294 then
        v290 = v294
    end

    aimLeg(p79.lh, v327, true, v329, math.sin(3.141592653589793 * v330) * 0.05)
    aimLeg(p79.rh, v327, false, v288, math.sin(3.141592653589793 * v290) * 0.05)

    local ls = p79.ls
    local v333 = -v319 * 0.8 - 0.05 * v314
    local v334 = -0.1 - 0.05 * walk - 0.04 * v301
    local v336 = math.clamp((math.abs(v334) - 0.6) / 1.9, 0, 1) * -0.19999999999999996 + 1.5

    ls.C0 = CFrame.new(-v336 or v336, 1, 0) * CFrame.Angles(v333, 0, v334)

    local v337 = 1.25 + -0.75 * v301 + 0.72 * v301 * v312 * math.sin(v309)
    local v338 = 0.3 + 0.2 * v301 * math.cos(v309)
    local v339 = v299 * 0.03 + -1.42
    local v340 = v339 + (v337 - v339) * v300
    local v341 = 0.06 + (v338 - 0.06) * v300
    local Unit = Vector3.new(v341, math.sin(v340), -math.cos(v340)).Unit
    local v344 = idle * 0.3
    local v345 = p79.seed + 33
    local v346 = 1.45 + 0.03 * (math.noise(v344, v345, 0.31) * 1.3 + math.noise(v344 * 2.3, v345 + 4.7, 0.77) * 0.6)
    local v347 = v346 + (v340 + 0.6 - v346) * v300
    local v348 = 0.22 + (v341 * 0.55 - 0.22) * v300

    if not p79.pe then
        p79.pe = {
            v = 0,
            x = v347
        }
        p79.po = {
            v = 0,
            x = v348
        }
    end

    local v349 = spring(p79.pe, v347, 2.6, 0.5, dt)

    if v300 > 0.05 then
        local v352 = math.clamp(v349, v340 + -0.15, v340 + 1.3)

        if v352 ~= v349 then
            v349 = v352
            p79.pe.x = v352
            p79.pe.v *= 0.5
        end
    end

    local Unit2 = Vector3.new(spring(p79.po, v348, 2.6, 0.5, dt), math.sin(v349), -math.cos(v349)).Unit
    local v357 = math.clamp((Unit.Y + 0.1) / 0.9, 0, 1)
    local v358 = 1.5 + -0.19999999999999996 * v357
    local v359 = 1 + 0.12 * v300 * v357
    local v360 = Vector3.new(1, 0, 0) - Unit * Unit.X
    local Unit3 = v360.Magnitude > 0.001 and v360.Unit or Vector3.new(0, 0, 1)
    local v361 = CFrame.new(v358, v359, 0) * CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit3, -Unit)

    p79.rs.C0 = v361

    if p79.poleJoint and p79.pole then
        local rs = p79.rs
        local v362 = v327 * v361 * rs.C1:Inverse()
        local Y = p79.pole.Size.Y
        local v363 = v327:VectorToWorldSpace(Unit2)
        local v366 = v362 * Vector3.new(0, -0.85 + -0.09999999999999998 * v300, -0.5 * (1 - v300))
        local RightVector = v327.RightVector
        local v367 = RightVector - v363 * RightVector:Dot(v363)

        if v367.Magnitude < 0.1 then
            local LookVector = v327.LookVector

            v367 = LookVector - v363 * LookVector:Dot(v363)
        end

        local v368 = CFrame.fromMatrix(v366 + v363 * (Y / 2 - 0.5), v367.Unit, -v363)

        p79.poleJoint.C0 = v362:Inverse() * v368 * p79.poleJoint.C1

        if p79.clothPart then
            clothStep(p78, p79, v368, Y, dt, p80.ground, idle)
        end
    end

    local v372 = math.sin(idle * 0.9) * 0.2 * walk + math.sin(idle * 0.37) * 0.12 * (1 - walk)
    local v374 = math.sin(idle * 0.23) * 0.03
    local v375 = v372 - v321

    if p79.neck and p79.neckC0 then
        p79.neck.C0 = p79.neckC0 * CFrame.Angles(0, 0, v375) * CFrame.Angles(v374, 0, 0)
    end
end

local function animate(p83, p84, p85, p86, p87) -- line: 495
    -- upvalues: GridOfficialMotion (copy), setFade (copy), animateRed (copy), animateGreen (copy)
    local StartPos = p83:GetAttribute("StartPos")
    local TargetPos = p83:GetAttribute("TargetPos")
    local Look = p83:GetAttribute("Look")

    if typeof(StartPos) ~= "Vector3" or typeof(TargetPos) ~= "Vector3" or typeof(Look) ~= "Vector3" then
        return
    end

    local v376 = p83:GetAttribute("DepartAt") or 0
    local v377 = p83:GetAttribute("Speed") or 0
    local v378 = v376 > 0 and math.max(p85 - v376, 0) or 0
    local v380 = TargetPos - StartPos
    local v381 = Vector3.new(v380.X, 0, v380.Z)
    local Magnitude = v381.Magnitude
    local v383 = math.min(GridOfficialMotion.Travel(v378, v377), Magnitude)
    local v384 = v376 > 0 and v377 > 0 and v383 < Magnitude
    local v387 = math.atan2(-Look.X, -Look.Z)
    local t18 = {
        t = v378,
        dt = p87,
        departAt = v376,
        speed = v377,
        start = StartPos,
        ground = StartPos.Y - 3,
        travelled = v383,
        walk = v384 and math.clamp(GridOfficialMotion.Speed(v378, v377) / v377, 0, 1) or 0,
        idle = p86 + p84.seed,
        dir = Magnitude > 0.05 and v381.Unit or Vector3.new(0, 0, 0),
        faceYaw = v387,
        fwd = Vector3.new(-math.sin(v387), 0, -math.cos(v387)),
        right = Vector3.new(math.cos(v387), 0, -math.sin(v387))
    }

    if p84.red then
        animateRed(p83, p84, t18)
    else
        animateGreen(p83, p84, t18)
    end

    if not (v376 > 0 and v377 > 0) then
        setFade(p84, 0)
    else
        setFade(p84, 1 - math.clamp((GridOfficialMotion.Duration(Magnitude, v377) - v378) / GridOfficialMotion.FadeSeconds, 0, 1))
    end
end

local function step(p88, p89, p90) -- line: 518
    -- upvalues: t4 (copy), rig (copy), animate (copy)
    for v394, v395 in t4 do
        if not v394.Parent then
            if v395.strips then
                for _, v396 in v395.strips do
                    v396:Destroy()
                end
            end

            t4[v394] = nil
        end
    end

    local GridOfficials = workspace:FindFirstChild("GridOfficials")

    if GridOfficials then
        for _, child in GridOfficials:GetChildren() do
            if child:IsA("Model") and child:GetAttribute("Official") then
                local v397 = rig(child)

                if v397 then
                    local ok, result = pcall(animate, child, v397, p88, p89, p90)

                    if not ok then
                        warn("[GridOfficialsClient] " .. tostring(result))
                    end
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function(p91) -- line: 533
    -- upvalues: step (copy)
    step(workspace:GetServerTimeNow(), os.clock(), (math.min(p91, 0.06666666666666667)))
end)
