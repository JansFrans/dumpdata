-- https://lua.expert

local Config = require(script.Parent.Config)
local OwnerFeatures14 = require(script.Parent:WaitForChild("OwnerFeatures14"))
local t1 = {
    ImpactCompression = 0.5,
    ImpactRebound = 0.8
}

local function spring(p1, p2, p3, p4, p5) -- line: 10
    local v2 = math.exp(-p5 * p4)
    local v3 = p1 - p3

    return p3 + (v3 + (p2 + p5 * v3) * p4) * v2, (p2 - p5 * (p2 + p5 * v3) * p4) * v2
end

function t1.LandingImpact(p6, p7, p8) -- line: 17
    local v4 = p7 .. "ImpactVelocity"

    p6[v4] = math.max(p6[v4] or 0, (math.clamp(p8 * 1.15, 0, 22)))
    p6[p7 .. "LandingSpeed"] = p8
end

t1.ArmClearance = 0.32
t1.ArmSeconds = 0.06

function t1.TrackLanding(p9, p10, p11, p12, p13) -- line: 27
    -- upvalues: t1 (copy)
    local v8 = p10 .. "LandingArmed"
    local v9 = p10 .. "LandingAir"

    if not (t1.ArmClearance < p11 and p11 < 20) then
        if p11 <= 0.045 then
            p9[v9] = 0
        end
    else
        p9[v9] = (p9[v9] or 0) + (p13 or 0)

        if p9[v9] >= t1.ArmSeconds then
            p9[v8] = true
        end
    end

    if p9[v8] and p11 <= 0.045 then
        p9[v8] = false

        if p12 > 0.35 then
            t1.LandingImpact(p9, p10, p12)

            return true
        end
    end

    return false
end

local function impactSpring(p14, p15, p16) -- line: 39
    -- upvalues: OwnerFeatures14 (copy), t1 (copy)
    local v10 = p14[p15 .. "Impact"] or 0
    local v11 = p14[p15 .. "ImpactVelocity"] or 0
    local v12 = if p15 == "front" then 18 else 16
    local v13 = if OwnerFeatures14.On() then v11 > 0 and t1.ImpactCompression or t1.ImpactRebound else 0.58
    local v15 = v12 * math.sqrt(1 - v13 * v13)
    local v17 = math.exp(-v13 * v12 * p16)
    local v19 = math.cos(v15 * p16)
    local v21 = math.sin(v15 * p16)
    local v22 = v17 * (v10 * v19 + (v11 + v13 * v12 * v10) / v15 * v21)
    local v23 = v17 * (v11 * v19 - (v13 * v12 * v11 + v12 * v12 * v10) / v15 * v21)
    local v24 = if p15 == "front" then 0.4 else 0.48

    if v24 < v22 then
        v23 = -math.abs(v23) * 0.25
    else
        v24 = v22
    end

    if v24 < -0.09 then
        v24 = -0.09
        v23 = math.max(0, v23) * 0.35
    end

    if math.abs(v24) < 1E-04 and math.abs(v23) < 0.002 then
        v24 = 0
        v23 = 0
    end

    local v25 = p15 .. "Impact"
    local v26 = p15 .. "ImpactVelocity"

    p14[v25] = v24
    p14[v26] = v23

    return v24
end

function t1.Step(p17, p18, p19, p20, p21, p22) -- line: 56
    -- upvalues: Config (copy), impactSpring (copy)
    local v27 = if p17.rhd and p22 and p17.gear > 0 then 1 else 0
    local v28 = p17.rhdBlend or 0
    local v29 = p17.rhdVelocity or 0
    local v31 = math.exp(-8 * p18)
    local v32 = v28 - v27
    local v33 = v27 + (v32 + (v29 + 8 * v32) * p18) * v31
    local v34 = (v29 - 8 * (v29 + 8 * v32) * p18) * v31

    p17.rhdBlend = v33
    p17.rhdVelocity = v34

    local v36 = math.clamp(p19 / Config.Gravity, 0, 1.6)
    local v38 = math.clamp(p20 / Config.Gravity, 0, 1.6)
    local v39 = p21 and math.clamp(v38 * 0.19 - v36 * 0.055, 0, 0.31) or 0
    local v40 = p21 and math.clamp(v36 * 0.13 - v38 * 0.07, 0, 0.23) + p17.rhdBlend * 0.23 or 0
    local v43 = (p17.roughPhase or 0) * 1.25
    local v47 = math.clamp(v39 + (p17.frontBump or 0) * (math.sin(v43 * 1.2) * 0.16 + -0.12), -0.28, 0.06)
    local v51 = math.clamp(v40 + (p17.rearBump or 0) * (math.sin(v43 * 1.47 + 2) * 0.22 + 0.08), -0.18, 0.4)
    local v52 = p17.frontLoadCompression or 0
    local v53 = p17.frontSpringVelocity or 0
    local v54 = if (p17.frontBump or 0) > 0.01 then 25 else 20
    local v56 = math.exp(-v54 * p18)
    local v57 = v52 - v47
    local v58 = v47 + (v57 + (v53 + v54 * v57) * p18) * v56
    local v59 = (v53 - v54 * (v53 + v54 * v57) * p18) * v56

    p17.frontLoadCompression = v58
    p17.frontSpringVelocity = v59

    local v60 = p17.rearLoadCompression or 0
    local v61 = p17.rearSpringVelocity or 0
    local v62 = if (p17.rearBump or 0) > 0.01 then 22.5 else 18
    local v64 = math.exp(-v62 * p18)
    local v65 = v60 - v51
    local v66 = v51 + (v65 + (v61 + v62 * v65) * p18) * v64
    local v67 = (v61 - v62 * (v61 + v62 * v65) * p18) * v64

    p17.rearLoadCompression = v66
    p17.rearSpringVelocity = v67
    p17.frontCompression = math.clamp(p17.frontLoadCompression + impactSpring(p17, "front", p18) + (p17.frontRoadComp or 0) + (p17.frontLooseComp or 0), -0.28, 0.4)
    p17.rearCompression = math.clamp(p17.rearLoadCompression + impactSpring(p17, "rear", p18) + (p17.rearRoadComp or 0) + (p17.rearLooseComp or 0), -0.18, 0.48)

    return (math.atan2(p17.rearCompression - p17.frontCompression, Config.Wheelbase))
end

function t1.Axles(p23) -- line: 75
    -- upvalues: Config (copy)
    return Config.FrontAxle + Vector3.new(0, 1, 0) * (p23.frontCompression or 0), Config.RearAxle + Vector3.new(0, 1, 0) * (p23.rearCompression or 0)
end

function t1.WheelTransform(p24, p25) -- line: 78
    local v71 = p24.Part1 and p24.Part1:GetAttribute("WheelSpinAxis") or p24.C0:VectorToObjectSpace((Vector3.new(1, 0, 0))).Unit

    return CFrame.fromAxisAngle(v71, -p25 % 6.283185307179586)
end

local v72

function t1.ApplyVisual(p26, p27, p28) -- line: 84
    -- upvalues: Config (copy), v72 (ref)
    local PrimaryPart = p26.PrimaryPart

    if not PrimaryPart then
        return
    end

    local v73 = p27
    local v74 = p28

    if game:GetService("RunService"):IsClient() then
        if v72 == nil then
            local _require = require
            local Parent = script.Parent
            local ok, result = pcall(_require, Parent:FindFirstChild("BikeVisualLife"))

            v72 = ok and result or false
        end

        if v72 then
            v73, v74 = v72.Wheels(p26, p27, p28)
        end
    end

    local v75 = PrimaryPart:GetAttribute("ForkAxis") or Vector3.new(0, 1, 0)
    local v76 = v73 or 0
    local v77 = CFrame.new(v75 * (v76 / math.max(v75.Y, 0.3)))
    local v78 = v74 or 0
    local SwingarmPivot = PrimaryPart:GetAttribute("SwingarmPivot")
    local v79

    if SwingarmPivot then
        local v80 = Config.RearAxle - SwingarmPivot
        local v81 = math.max(Vector2.new(v80.Y, v80.Z).Magnitude, 0.5)
        local v82 = math.atan2(v80.Y, v80.Z)
        local v85 = math.asin((math.clamp(v80.Y / v81 + v78 / v81, -1, 1)))

        v79 = CFrame.new(SwingarmPivot) * CFrame.Angles(-(v85 - v82), 0, 0) * CFrame.new(-SwingarmPivot)
    else
        v79 = CFrame.new(0, v78, 0)
    end

    for _, child in PrimaryPart:GetChildren() do
        local v86 = if (child.Name == "FrontWheel" or child.Name == "SuspFront") and v77 then v77 else (child.Name == "RearWheel" or child.Name == "SuspRear") and v79

        if v86 and child:IsA("Motor6D") and child.Part1 and not child.Part1:GetAttribute("Detached") then
            local SuspensionBase = child:GetAttribute("SuspensionBase")

            if not SuspensionBase then
                SuspensionBase = child.C0
                child:SetAttribute("SuspensionBase", SuspensionBase)
            end

            child.C0 = v86 * SuspensionBase
        end
    end

    for _, v87 in {
            {
                "FrontTyreContact",
                Config.FrontAxle,
                p27 or 0
            },
            {
                "RearTyreContact",
                Config.RearAxle,
                p28 or 0
            }
        } do
        local v88 = p26:FindFirstChild(v87[1])
        local ContactWeld = v88 and v88:FindFirstChild("ContactWeld")

        if ContactWeld then
            ContactWeld.C0 = CFrame.new(v87[2] + Vector3.new(0, 1, 0) * v87[3])
        end
    end
end

return t1
