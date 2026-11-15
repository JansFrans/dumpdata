-- https://lua.expert

local _, Angles = math.rad, CFrame.Angles
local t1 = {}

t1.Poses = {
    CaseyStoner = {
        Root = Angles(0, 0, 0),
        Torso = Angles(-0.03490658503988659, 0, -0.03490658503988659),
        Neck = Angles(-0.05235987755982989, -0.12217304763960307, 0.05235987755982989),
        LeftShoulder = Angles(1.3962634015954636, -0.3141592653589793, 1.0122909661567112),
        RightShoulder = Angles(-0.08726646259971647, 0, 0.10471975511965978),
        LeftHip = Angles(0.05235987755982989, 0, -0.08726646259971647),
        RightHip = Angles(-0.05235987755982989, 0, 0.08726646259971647),
        Hair = CFrame.new(0, -0.1, 0.04),
        Cap = CFrame.new(0, 0.68, -0.14) * Angles(-0.03490658503988659, 0, 0)
    },
    MarcMarquez = {
        Root = Angles(0, 0, 0),
        Torso = Angles(-0.06981317007977318, 0, 0.03490658503988659),
        Neck = Angles(-0.06981317007977318, 1.6580627893946132, -0.10471975511965978),
        LeftShoulder = Angles(2.8797932657906435, 0, -0.3490658503988659),
        RightShoulder = Angles(-0.20943951023931956, 0, 0.13962634015954636),
        LeftHip = Angles(0.24434609527920614, 0, -0.06981317007977318),
        RightHip = Angles(-0.20943951023931956, 0, 0.08726646259971647),
        Hair = CFrame.new(0, -0.1, 0.04),
        Cap = CFrame.new(0, 0.68, -0.14) * Angles(-0.03490658503988659, 0, 0)
    }
}
t1.Cameras = {
    CaseyStoner = {
        Main = {
            Pos = Vector3.new(-3.1, 1.2, -13.2),
            Look = Vector3.new(0, -0.2, 0),
            Fov = 30
        },
        Slot = {
            Pos = Vector3.new(-1.8, 1.8, -7.9),
            Look = Vector3.new(0, 0.9, 0),
            Fov = 30
        }
    },
    MarcMarquez = {
        Main = {
            Pos = Vector3.new(-7.58, 1.72, 11.01),
            Look = Vector3.new(-0.32, -0.1, -0.21),
            Fov = 30
        },
        Slot = {
            Pos = Vector3.new(-5.13, 2.01, 6.86),
            Look = Vector3.new(-0.5, 0.85, -0.3),
            Fov = 30
        }
    }
}
t1.OutlineThickness = 0.02
t1.Display = {
    CaseyStoner = {
        Yaw = -0.22689280275926285,
        MenuYaw = 2.530727415391778
    },
    MarcMarquez = {
        Yaw = -2.530727415391778,
        MenuYaw = 0
    }
}
t1.Poses.KuriKuriBoy = table.clone(t1.Poses.CaseyStoner)
t1.Cameras.KuriKuriBoy = t1.Cameras.CaseyStoner
t1.Display.KuriKuriBoy = t1.Display.CaseyStoner
t1.Poses.CaseyStoner = {
    Root = Angles(0, 0, 0),
    Torso = Angles(0, 0, 0),
    Neck = Angles(0, 0.3141592653589793, 0),
    LeftShoulder = Angles(-0.05235987755982989, 0, -0.10471975511965978),
    RightShoulder = Angles(-0.05235987755982989, 0, 0.10471975511965978),
    LeftHip = Angles(0, 0, -0.03490658503988659),
    RightHip = Angles(0, 0, 0.03490658503988659),
    Hair = CFrame.new(0, -0.1, 0.04),
    Cap = CFrame.new(0, 0.68, -0.14) * Angles(-0.03490658503988659, 0, 0)
}
t1.Poses.TheDoctor = {
    Root = Angles(0, 0, 0),
    Torso = Angles(0, -0.13962634015954636, 0),
    Neck = Angles(-0.06981317007977318, -0.13962634015954636, -0.12217304763960307),
    LeftShoulder = Angles(3.001966313430247, 0.13962634015954636, -0.3141592653589793),
    RightShoulder = Angles(-0.05235987755982989, 0, 0.06981317007977318),
    LeftHip = Angles(0, 0, -0.05235987755982989),
    RightHip = Angles(-0.06981317007977318, 0, 0.05235987755982989),
    Hair = CFrame.new(0, -0.1, 0.04),
    Cap = CFrame.new(0, 0.68, -0.14) * Angles(-0.03490658503988659, 0, 0)
}
t1.Cameras.TheDoctor = {
    Main = {
        Pos = Vector3.new(3.1, 1.2, -13.2),
        Look = Vector3.new(0, -0.2, 0),
        Fov = 30
    },
    Slot = {
        Pos = Vector3.new(1.8, 1.8, -7.9),
        Look = Vector3.new(0, 0.9, 0),
        Fov = 30
    }
}
t1.Display.TheDoctor = {
    Yaw = 0.22689280275926285,
    MenuYaw = 0
}
t1.Poses.TheRomanEmperor = {
    Root = Angles(0, 0, 0),
    Torso = Angles(-0.03490658503988659, 0.10471975511965978, -0.03490658503988659),
    Neck = Angles(-0.08726646259971647, 0.24434609527920614, 0.10471975511965978),
    RightShoulder = Angles(3.0892327760299634, -0.10471975511965978, 0.2617993877991494),
    LeftShoulder = Angles(-0.06981317007977318, 0, -0.10471975511965978),
    LeftHip = Angles(-0.05235987755982989, 0, -0.05235987755982989),
    RightHip = Angles(0.05235987755982989, 0, 0.06981317007977318),
    Hair = CFrame.new(0, -0.1, 0.04),
    Cap = CFrame.new(0, 0.68, -0.14) * Angles(-0.03490658503988659, 0, 0)
}
t1.Cameras.TheRomanEmperor = {
    Main = {
        Pos = Vector3.new(3.1, 1.2, -13.2),
        Look = Vector3.new(0, -0.2, 0),
        Fov = 30
    },
    Slot = {
        Pos = Vector3.new(1.8, 1.8, -7.9),
        Look = Vector3.new(0, 0.9, 0),
        Fov = 30
    }
}
t1.Display.TheRomanEmperor = {
    Yaw = 0.22689280275926285,
    MenuYaw = 0
}
t1.Poses.DesmoDovi = {
    Root = Angles(0, 0, 0),
    Torso = Angles(0, -0.17453292519943295, 0),
    Neck = Angles(-0.2617993877991494, -0.05235987755982989, 0.06981317007977318),
    RightShoulder = Angles(0.7330382858376184, 0, -0.6457718232379019),
    LeftShoulder = Angles(0.7330382858376184, 0, 0.6457718232379019),
    LeftHip = Angles(0, 0, -0.03490658503988659),
    RightHip = Angles(0, 0, 0.03490658503988659),
    Hair = CFrame.new(0, -0.1, 0.04),
    Cap = CFrame.new(0, 0.68, -0.14) * Angles(0.13962634015954636, 0, 0)
}
t1.Cameras.DesmoDovi = {
    Main = {
        Pos = Vector3.new(3.1, 1.2, -13.2),
        Look = Vector3.new(0, -0.2, 0),
        Fov = 30
    },
    Slot = {
        Pos = Vector3.new(1.8, 1.8, -7.9),
        Look = Vector3.new(0, 0.9, 0),
        Fov = 30
    }
}
t1.Display.DesmoDovi = {
    Yaw = 0.22689280275926285,
    MenuYaw = 0
}
t1.Poses.Standing = {
    Root = Angles(0, 0, 0),
    Torso = Angles(0, 0, 0),
    Neck = Angles(-0.03490658503988659, -0.10471975511965978, 0),
    LeftShoulder = Angles(-0.03490658503988659, 0, -0.08726646259971647),
    RightShoulder = Angles(-0.03490658503988659, 0, 0.08726646259971647),
    LeftHip = Angles(0, 0, -0.03490658503988659),
    RightHip = Angles(0, 0, 0.03490658503988659),
    Hair = CFrame.new(0, -0.1, 0.04),
    Cap = CFrame.new(0, 0.68, -0.14) * Angles(-0.03490658503988659, 0, 0)
}
t1.Display.Standing = {
    Yaw = -0.20943951023931956,
    MenuYaw = 0
}

local t2 = {
    LeftKnee = "LeftKnee",
    RightKnee = "RightKnee",
    Waist = "Torso",
    Neck = "Neck",
    LeftShoulder = "LeftShoulder",
    RightShoulder = "RightShoulder",
    LeftHip = "LeftHip",
    RightHip = "RightHip",
    RootJoint = "Torso",
    ["Left Shoulder"] = "LeftShoulder",
    ["Right Shoulder"] = "RightShoulder",
    ["Left Hip"] = "LeftHip",
    ["Right Hip"] = "RightHip"
}
local t3 = {}

local function seedOf(p1) -- line: 140
    -- upvalues: t3 (copy)
    local v1 = t3[p1 or ""]

    if v1 then
        return v1
    end

    local n1 = 0

    for i = 1, #(p1 or "") do
        n1 = (n1 * 31 + string.byte(p1, i)) % 9973
    end

    local v3 = n1 / 97.31 + 0.37

    t3[p1 or ""] = v3

    return v3
end

local function wave(p2, p3, p4, p5) -- line: 147
    local v4 = math.noise(p2 * p3, p4, p5 * 1.731 + 0.27) * 3

    return v4 / math.sqrt(1 + v4 * v4)
end

t1.BreathCycle = 3.6

function t1.Idle(p6, p7) -- line: 149
    -- upvalues: t1 (copy), Angles (copy), seedOf (copy)
    p7 = p7 or 0

    local v7 = seedOf(p6)
    local v8 = (p7 / t1.BreathCycle + v7 * 0.13) % 1
    local v9 = v8 < 0.4 and v8 / 0.4 * 0.5 or 0.5 + (v8 - 0.4) / 0.6 * 0.5
    local v11 = 0.5 - math.cos(6.283185307179586 * v9) * 0.5
    local v13 = math.sin(6.283185307179586 * v9)
    local v14 = math.noise(p7 * 0.14, v7, 2.0010000000000003) * 3
    local v16 = v14 / math.sqrt(1 + v14 * v14)
    local v17 = math.noise(p7 * 0.11, v7, 3.732) * 3
    local v19 = v17 / math.sqrt(1 + v17 * v17)
    local v20 = math.noise(p7 * 0.17, v7, 5.463000000000001) * 3
    local v22 = v20 / math.sqrt(1 + v20 * v20) * 0.8
    local v23 = math.noise(p7 * 0.47, v7, 7.194000000000001) * 3
    local v25 = v22 + v23 / math.sqrt(1 + v23 * v23) * 0.2
    local v26 = math.noise(p7 * 0.21, v7, 8.925) * 3
    local v28 = v26 / math.sqrt(1 + v26 * v26)
    local v29 = math.noise(p7 * 0.13, v7, 10.656) * 3
    local v31 = v29 / math.sqrt(1 + v29 * v29)
    local v32 = 0.026179938779914945 * v16
    local t4 = {
        Inhale = v11,
        Lift = v11 * 0.025,
        ShoulderLift = v11 * 0.03,
        Sway = Angles(0, 0.027925268031909273 * v19, v32),
        Torso = Angles(v11 * -0.03490658503988659, 0, 0),
        Neck = Angles(v13 * 0.024434609527920613 + 0.05235987755982989 * v28, 0.22689280275926285 * v25, 0.04363323129985824 * v31 - v32 * 0.6)
    }
    local v33 = v11 * 0.04363323129985824
    local v34 = math.noise(p7 * 0.26, v7, 12.387) * 3
    local v36 = v33 + 0.03490658503988659 * (v34 / math.sqrt(1 + v34 * v34))
    local v37 = v11 * -0.026179938779914945 - v32 * 0.7
    local v38 = math.noise(p7 * 0.31, v7, 14.118) * 3

    t4.LeftShoulder = Angles(v36, 0, v37 + 0.026179938779914945 * (v38 / math.sqrt(1 + v38 * v38)))

    local v40 = math.noise(p7 * 0.24, v7, 15.849) * 3
    local v42 = 0.03490658503988659 * (v40 / math.sqrt(1 + v40 * v40))
    local v43 = v11 * 0.038397243543875255 - v32 * 0.7
    local v44 = math.noise(p7 * 0.29, v7, 17.580000000000002) * 3

    t4.RightShoulder = Angles(v42, 0, v43 + 0.026179938779914945 * (v44 / math.sqrt(1 + v44 * v44)))

    return t4
end

local function breathing(p8, p9) -- line: 174
    -- upvalues: t1 (copy)
    local v46 = t1.Idle(p8, p9)

    return {
        Torso = v46.Sway * v46.Torso,
        Neck = v46.Neck,
        LeftShoulder = v46.LeftShoulder,
        RightShoulder = v46.RightShoulder
    }
end

function t1.JointRotations(p10, p11) -- line: 180
    -- upvalues: t1 (copy), t2 (copy)
    local v47 = p10 and t1.Poses[p10]

    if not v47 then
        return nil
    end

    local v48 = p11

    if p11 then
        local v49 = t1.Idle(p10, p11)

        v48 = {
            Torso = v49.Sway * v49.Torso,
            Neck = v49.Neck,
            LeftShoulder = v49.LeftShoulder,
            RightShoulder = v49.RightShoulder
        }
    end

    local t5 = {}

    for v50, v51 in t2 do
        if v47[v51] then
            t5[v50] = v48 and v48[v51] and v47[v51] * v48[v51] or v47[v51]
        end
    end

    return t5
end

function t1.DisplayYaw(p12) -- line: 189
    -- upvalues: t1 (copy)
    local v52 = p12 and t1.Display[p12]

    return v52 and v52.Yaw or 0
end

function t1.DisplayDrop(p13) -- line: 193
    -- upvalues: t1 (copy)
    local v53 = p13 and t1.Display[p13]

    return v53 and v53.Drop or 0
end

function t1.PoseAvatar(p14, p15, p16) -- line: 199
    -- upvalues: t1 (copy)
    local v54 = t1.JointRotations(p15, p16)

    if v54 and not p16 then
        local Humanoid = p14:FindFirstChildOfClass("Humanoid")
        local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

        if Animator then
            for _, v55 in Animator:GetPlayingAnimationTracks() do
                v55:Stop(0)
            end
        end
    end

    for _, descendant in p14:GetDescendants() do
        local v56 = v54 and v54[descendant.Name]

        if descendant:IsA("Motor6D") then
            local LegendBaseC0 = descendant:GetAttribute("LegendBaseC0")

            if typeof(LegendBaseC0) ~= "CFrame" then
                LegendBaseC0 = descendant.C0
                descendant:SetAttribute("LegendBaseC0", LegendBaseC0)
            end

            if v54 then
                descendant.Transform = CFrame.identity
            end

            descendant.C0 = v56 and CFrame.new(LegendBaseC0.Position) * v56 * LegendBaseC0.Rotation or LegendBaseC0
        elseif descendant:IsA("AnimationConstraint") and descendant.Attachment0 then
            local Attachment0 = descendant.Attachment0
            local LegendBaseCFrame = Attachment0:GetAttribute("LegendBaseCFrame")

            if typeof(LegendBaseCFrame) ~= "CFrame" then
                LegendBaseCFrame = Attachment0.CFrame
                Attachment0:SetAttribute("LegendBaseCFrame", LegendBaseCFrame)
            end

            if v54 then
                descendant.Transform = CFrame.identity
            end

            Attachment0.CFrame = v56 and CFrame.new(LegendBaseCFrame.Position) * v56 * LegendBaseCFrame.Rotation or LegendBaseCFrame
        end
    end

    return v54 ~= nil
end

local function setCF(p17, p18, p19) -- line: 223
    local v57 = p17:FindFirstChild(p18)

    if v57 then
        v57.CFrame = p19
    end

    return v57
end

function t1.Apply(p20, p21, p22, p23) -- line: 225
    -- upvalues: t1 (copy)
    local v58 = t1.Poses[p21]

    if not v58 then
        return
    end

    local v59 = t1.Idle(p21, p23)
    local v60 = p22 * v58.Root * CFrame.new(0, -1, 0) * v59.Sway * CFrame.new(0, 1 + v59.Lift, 0) * v58.Torso * v59.Torso
    local Torso = p20:FindFirstChild("Torso")

    if Torso then
        Torso.CFrame = v60
    end

    local v61 = v60 * CFrame.new(0, 1, 0) * v58.Neck * v59.Neck * CFrame.new(0, 0.5, 0)
    local Head = p20:FindFirstChild("Head")

    if Head then
        Head.CFrame = v61
    end

    local v62 = v58.LeftShoulder * v59.LeftShoulder
    local v63 = v58.RightShoulder * v59.RightShoulder
    local v64 = v60 * CFrame.new(-1.5, 0.5 + v59.ShoulderLift, 0) * v62 * CFrame.new(0, -0.5, 0)
    local v65 = v60 * CFrame.new(1.5, 0.5 + v59.ShoulderLift, 0) * v63 * CFrame.new(0, -0.5, 0)
    local v66 = p20:FindFirstChild("Left Arm")

    if v66 then
        v66.CFrame = v64
    end

    local v67 = p20:FindFirstChild("Right Arm")

    if v67 then
        v67.CFrame = v65
    end

    local v68 = v64 * CFrame.new(0, -0.8, 0)
    local v69 = p20:FindFirstChild("Left Hand")

    if v69 then
        v69.CFrame = v68
    end

    local v70 = v65 * CFrame.new(0, -0.8, 0)
    local v71 = p20:FindFirstChild("Right Hand")

    if v71 then
        v71.CFrame = v70
    end

    local v72 = p22 * v58.Root
    local v73 = v72 * CFrame.new(-0.5, -1, 0) * v58.LeftHip * CFrame.new(0, -1, 0)
    local v74 = p20:FindFirstChild("Left Leg")

    if v74 then
        v74.CFrame = v73
    end

    local v75 = v72 * CFrame.new(0.5, -1, 0) * v58.RightHip * CFrame.new(0, -1, 0)
    local v76 = p20:FindFirstChild("Right Leg")

    if v76 then
        v76.CFrame = v75
    end

    local Hair = p20:FindFirstChild("Hair")

    if Hair then
        local HairAttachment = Hair:FindFirstChild("HairAttachment")
        local v77 = v61 * CFrame.new(0, 0.6, 0) * v58.Hair * (HairAttachment and HairAttachment.CFrame:Inverse() or CFrame.identity)
        local Hair2 = p20:FindFirstChild("Hair")

        if Hair2 then
            Hair2.CFrame = v77
        end
    end

    local v78 = v61 * v58.Cap
    local Cap = p20:FindFirstChild("Cap")

    if Cap then
        Cap.CFrame = v78
    end

    local v79 = v78 * CFrame.new(0, -0.1, 0.26)
    local CapLiner = p20:FindFirstChild("CapLiner")

    if CapLiner then
        CapLiner.CFrame = v79
    end

    for _, child in p20:GetChildren() do
        local CapOffset = child:GetAttribute("CapOffset")

        if child:IsA("BasePart") and typeof(CapOffset) == "CFrame" then
            child.CFrame = v78 * CapOffset
        end

        local HeadOffset = child:GetAttribute("HeadOffset")

        if child:IsA("BasePart") and typeof(HeadOffset) == "CFrame" then
            child.CFrame = v61 * HeadOffset
        end
    end
end

function t1.MakeOutline(p24, p25) -- line: 258
    -- upvalues: t1 (copy)
    p25 = p25 or t1.OutlineThickness

    local clone = p24:Clone()

    clone.Name = p24.Name .. "Outline"

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("Decal") or descendant:IsA("Texture") or descendant:IsA("SurfaceAppearance") then
            descendant:Destroy()
        elseif descendant:IsA("BasePart") then
            local Size = descendant.Size
            local SpecialMesh = descendant:FindFirstChildOfClass("SpecialMesh")

            if SpecialMesh then
                if SpecialMesh.MeshType == Enum.MeshType.FileMesh then
                    SpecialMesh.Scale = SpecialMesh.Scale * (1 + 2 * p25 / math.max(Size.X, Size.Y, Size.Z) * 1.6)
                else
                    local v82 = Size * SpecialMesh.Scale

                    SpecialMesh.Scale = Vector3.new((v82.X + 2 * p25) / Size.X, (v82.Y + 2 * p25) / Size.Y, (v82.Z + 2 * p25) / Size.Z)
                end
            else
                descendant.Size = Size + Vector3.new(2, 2, 2) * p25
            end

            descendant.Color = Color3.new(1, 1, 1)
            descendant.Material = Enum.Material.SmoothPlastic

            if descendant:IsA("MeshPart") then
                descendant.TextureID = ""
            end
        end
    end

    return clone
end

return t1
