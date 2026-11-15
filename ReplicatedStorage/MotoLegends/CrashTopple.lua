-- https://lua.expert

local Config = require(script.Parent:WaitForChild("Config"))
local t1 = {}

t1.Settings = {
    Seconds = 6,
    Delay = 0.6,
    BusySpin = 3,
    UprightUpY = 0.6427876096865394,
    RollRate = 2.4,
    PivotDown = 0.6,
    PivotSide = 0.9,
    LiftMax = 2.5,
    SideMax = 3,
    BlockedSteps = 24,
    GroundProbe = 4,
    TyreHalf = 0.15,
    RiseMax = 0.3,
    LiftCap = 0.6,
    BlockedTime = 0.3,
    BlockedTilt = 0.04,
    MaxPushTime = 1.5,
    LowsideSeconds = 4,
    LowsideMaxUp = 4,
    LowsideMaxSpin = 7,
    LowsideSpeedMargin = 2,
    LowsideRollOut = 0.5,
    SlideDecelG = 1.6,
    SlideYawAccel = 10,
    SlideTumbleAccel = 16,
    LowsideMaxYaw = 4,
    LowsideMaxTumble = 4.5
}

function t1.LimitLowside(p1, p2) -- line: 64
    -- upvalues: t1 (copy)
    local Settings = t1.Settings
    local AssemblyLinearVelocity = p1.AssemblyLinearVelocity
    local v1 = false

    if AssemblyLinearVelocity.Y > Settings.LowsideMaxUp then
        AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, Settings.LowsideMaxUp, AssemblyLinearVelocity.Z)
        v1 = true
    end

    if typeof(p2) == "number" then
        local v2 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
        local v3 = p2 + Settings.LowsideSpeedMargin

        if v3 < v2.Magnitude then
            local v4 = v2.Unit * v3

            AssemblyLinearVelocity = Vector3.new(v4.X, AssemblyLinearVelocity.Y, v4.Z)
            v1 = true
        end
    end

    if v1 then
        p1.AssemblyLinearVelocity = AssemblyLinearVelocity
    end

    local AssemblyAngularVelocity = p1.AssemblyAngularVelocity

    if AssemblyAngularVelocity.Magnitude > Settings.LowsideMaxSpin then
        p1.AssemblyAngularVelocity = AssemblyAngularVelocity.Unit * Settings.LowsideMaxSpin
    end
end

function t1.GuardLowsideRoll(p3) -- line: 79
    -- upvalues: t1 (copy)
    local LossSide = p3:GetAttribute("LossSide")

    if typeof(LossSide) == "number" and LossSide ~= 0 then
        local v5 = math.sign(LossSide)
        local LookVector = p3.CFrame.LookVector
        local AssemblyAngularVelocity = p3.AssemblyAngularVelocity
        local v6 = AssemblyAngularVelocity:Dot(LookVector) * v5
        local v7 = t1.Settings.LowsideRollOut or 0.5

        if v7 < v6 then
            p3.AssemblyAngularVelocity = AssemblyAngularVelocity - LookVector * v5 * (v6 - v7)
        end
    end
end

local self = setmetatable({}, {
    __mode = "k"
})
local v9 = RaycastParams.new()

v9.FilterType = Enum.RaycastFilterType.Include

local n1 = 0

function t1.GuardSlide(p4, p5) -- line: 93
    -- upvalues: t1 (copy), Config (copy), self (copy), v9 (copy), n1 (ref)
    local Settings = t1.Settings

    p5 = p5 or 0.016666666666666666

    local AssemblyLinearVelocity, AssemblyAngularVelocity = p4.AssemblyLinearVelocity, p4.AssemblyAngularVelocity
    local elapsed = os.clock()
    local v11 = self[p4]
    local v13
    local v12 = AssemblyAngularVelocity
    local v14 = AssemblyLinearVelocity

    if v11 and elapsed - v11.t < 0.25 then
        v13 = v11

        local flat = v11.flat

        if flat.Magnitude > 1 then
            if n1 < elapsed then
                n1 = elapsed + 5

                local t4 = {}
                local v15 = workspace:FindFirstChild("RaceCollision", true)

                if v15 then
                    table.insert(t4, v15)
                end

                v9.FilterDescendantsInstances = t4
            end

            local v16 = workspace:Raycast(p4.AssemblyCenterOfMass, flat.Unit * (flat.Magnitude * p5 + 5), v9)

            if v16 ~= nil and v16.Instance:GetAttribute("Surface") == "Barrier" then
                v11.wallUntil = elapsed + 0.4
            end
        end

        if (v11.wallUntil or 0) < elapsed then
            local v17 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z)
            local v18 = flat.Magnitude - Settings.SlideDecelG * Config.Gravity * p5
            local v19, v20

            if v18 > 0 and v17.Magnitude < v18 - 0.05 then
                local v21 = (v17.Magnitude > 1 and v17.Unit or flat.Unit) * v18

                v20 = Vector3.new(v21.X, AssemblyLinearVelocity.Y, v21.Z)
                v19 = true
            else
                v20 = AssemblyLinearVelocity
                v19 = false
            end

            v14 = v20

            local Y = AssemblyAngularVelocity.Y
            local v23 = math.min(Settings.LowsideMaxYaw, math.abs(v11.wy) + Settings.SlideYawAccel * p5)

            if v23 < math.abs(Y) then
                v19 = true
                Y = math.sign(Y) * v23
            end

            local v24 = Vector3.new(AssemblyAngularVelocity.X, 0, AssemblyAngularVelocity.Z)
            local v26 = math.min(Settings.LowsideMaxTumble, v11.th + Settings.SlideTumbleAccel * p5)

            if v26 < v24.Magnitude then
                v19 = true
                v24 = v24.Unit * v26
            end

            if v19 then
                v12 = Vector3.new(v24.X, Y, v24.Z)
                p4.AssemblyLinearVelocity = v20
                p4.AssemblyAngularVelocity = v12
            end
        end
    else
        v13 = {}
        self[p4] = v13
    end

    v13.t = elapsed
    v13.flat = Vector3.new(v14.X, 0, v14.Z)
    v13.wy = v12.Y
    v13.th = Vector3.new(v12.X, 0, v12.Z).Magnitude
end

function t1.StartSpeed(p6) -- line: 135
    local LossVelocity = p6:GetAttribute("LossVelocity")

    return if typeof(LossVelocity) == "Vector3" then Vector3.new(LossVelocity.X, 0, LossVelocity.Z).Magnitude or nil else nil
end

local v27 = RaycastParams.new()

v27.FilterType = Enum.RaycastFilterType.Include

local n2 = 0

local function groundUnder(p7, p8) -- line: 141
    -- upvalues: v27 (copy), n2 (ref)
    if os.clock() > n2 then
        n2 = os.clock() + 5

        local t5 = {
            workspace.Terrain
        }
        local v28 = workspace:FindFirstChild("RaceCollision", true)

        if v28 then
            table.insert(t5, v28)
        end

        v27.FilterDescendantsInstances = t5
    end

    local v29 = workspace:Raycast(p7, Vector3.new(-0, -1, -0, -0) * p8, v27)

    if v29 and v29.Normal.Y > 0.5 and v29.Instance:GetAttribute("Surface") ~= "Barrier" then
        return v29
    end
end

local self2 = setmetatable({}, {
    __mode = "k"
})

function t1.CrashAge(p9) -- line: 151
    local CrashAudioStartedAt = p9:GetAttribute("CrashAudioStartedAt")

    return typeof(CrashAudioStartedAt) == "number" and workspace:GetServerTimeNow() - CrashAudioStartedAt or 0
end

function t1.Step(p10, p11) -- line: 156
    -- upvalues: t1 (copy), groundUnder (copy), self2 (copy)
    local PrimaryPart = p10.PrimaryPart
    local v31, v32

    if not PrimaryPart or PrimaryPart.Anchored or (p10:GetAttribute("Crash") or "") == "" then
        v32 = true
    else
        v31 = t1.CrashAge(p10)

        if p10:GetAttribute("Crash") == "LOWSIDE" and v31 < t1.Settings.LowsideSeconds then
            t1.LimitLowside(PrimaryPart, t1.StartSpeed(PrimaryPart))
            t1.GuardLowsideRoll(PrimaryPart)
            t1.GuardSlide(PrimaryPart, p11)
        end

        v32 = false
    end

    if v32 or t1.Settings.Seconds < v31 or v31 < t1.Settings.Delay or PrimaryPart.AssemblyAngularVelocity.Magnitude > t1.Settings.BusySpin then
        return
    end

    local CFrame = PrimaryPart.CFrame
    local v33 = false
    local v34 = false
    local v35 = false
    local v36 = false
    local v37 = false
    local v38 = false
    local v39 = false
    local v40 = false

    if CFrame.UpVector.Y < t1.Settings.UprightUpY then
        v40 = true
    else
        v33 = true
    end

    local LookVector, v41, v42

    if v33 then
        LookVector = CFrame.LookVector
        v41 = p10:GetAttribute("CrashAudioStartedAt") or 0
        v42 = self2[p10]

        if v42 then
            v34 = true
        else
            v35 = true
        end
    end

    v33 = false

    local v43

    if v34 then
        if v42.key == v41 then
            v43 = v42
            v40 = false
        else
            v35 = true
        end
    end

    v34 = false

    local Y, v44, LossSide

    if v35 then
        Y = CFrame.RightVector.Y
        v44 = PrimaryPart.AssemblyAngularVelocity:Dot(LookVector)

        local LossSide2 = PrimaryPart:GetAttribute("LossSide")

        if LossSide2 then
            LossSide = LossSide2
            v33 = true
        else
            v34 = true
        end
    end

    v35 = false

    if v34 then
        LossSide = p10:GetAttribute("LossSide")
        v33 = true
    end

    v34 = false

    if v33 then
        if p10:GetAttribute("Crash") == "LOWSIDE" then
            v34 = true
        else
            v35 = true
        end
    end

    v33 = false

    if v34 then
        if typeof(LossSide) == "number" then
            v33 = true
        else
            v35 = true
        end
    end

    v34 = false

    if v33 then
        if LossSide == 0 then
            v35 = true
        else
            v34 = true
        end
    end

    v33 = false

    local v45

    if v34 then
        v45 = -math.sign(LossSide)
        v33 = true
    end

    v34 = false

    if v35 then
        if math.abs(v44) > 0.3 then
            v36 = true
        else
            v34 = true
        end
    end

    v35 = false

    if v34 then
        if Y < -0.03 then
            v37 = true
        else
            v35 = true
        end
    end

    v34 = false

    if v35 then
        if Y > 0.03 then
            v38 = true
        else
            v34 = true
        end
    end

    v35 = false

    local LossSide2

    if v34 then
        local LossSide = PrimaryPart:GetAttribute("LossSide")

        if LossSide then
            LossSide2 = LossSide
            v39 = true
        else
            v35 = true
        end
    end

    v34 = false

    if v35 then
        LossSide2 = p10:GetAttribute("LossSide")
        v39 = true
    end

    v35 = false

    if v39 then
        if typeof(LossSide2) == "number" then
            v35 = true
        else
            v34 = true
        end
    end

    v39 = false

    if v35 then
        if LossSide2 == 0 then
            v34 = true
        else
            v39 = true
        end
    end

    v35 = false

    local v46

    if v39 then
        local v47 = math.sign(LossSide2)

        if v47 then
            v46 = v47
            v35 = true
        else
            v34 = true
        end
    end

    if v34 then
        v46 = 1
        v35 = true
    end

    if v35 then
        v45 = v46
        v33 = true
    end

    if v38 then
        v45 = -1
        v33 = true
    end

    if v37 then
        v45 = 1
        v33 = true
    end

    if v36 then
        v45 = math.sign(v44)
        v33 = true
    end

    if v33 then
        v43 = {
            key = v41,
            side = v45
        }
        v40 = false
        self2[p10] = v43
    end

    if not v40 and not v43.gaveUp then
        local Settings = t1.Settings
        local side = v43.side
        local AssemblyAngularVelocity = PrimaryPart.AssemblyAngularVelocity
        local v48 = AssemblyAngularVelocity:Dot(LookVector) * side

        if Settings.RollRate <= v48 then
            v43.blocked = 0
        else
            local v49 = CFrame.RightVector.Y * side
            local AssemblyCenterOfMass = PrimaryPart.AssemblyCenterOfMass
            local v50 = groundUnder(AssemblyCenterOfMass, Settings.GroundProbe)

            if v50 then
                local v51 = AssemblyCenterOfMass.Y - v50.Position.Y

                v43.baseGap = v43.baseGap or v51

                if not (v43.baseGap + Settings.RiseMax < v51) then
                    v43.pushTime = (v43.pushTime or 0) + (p11 or 0.016666666666666666)

                    if v43.pushTime > Settings.MaxPushTime then
                        v43.gaveUp = true
                    else
                        v43.windowTime = (v43.windowTime or 0) + (p11 or 0.016666666666666666)

                        if v43.windowTime >= Settings.BlockedTime then
                            local v52 = v43.windowTilt and v43.windowTilt - v49 or 1

                            v43.windowTime = 0
                            v43.windowTilt = v49

                            if v52 < Settings.BlockedTilt then
                                if v43.flipped then
                                    v43.gaveUp = true
                                else
                                    v43.flipped = true
                                    v43.side = -side
                                    v43.windowTilt = nil
                                end

                                return
                            end
                        elseif not v43.windowTilt then
                            v43.windowTilt = v49
                        end

                        local v53 = LookVector * side * (Settings.RollRate - v48)
                        local v54 = Vector3.new(CFrame.RightVector.X, 0, CFrame.RightVector.Z)
                        local Unit = v54.Magnitude > 0.05 and v54.Unit or Vector3.new(0, 0, 0)
                        local v55 = v50.Position + Unit * side * Settings.TyreHalf

                        PrimaryPart.AssemblyAngularVelocity = AssemblyAngularVelocity + v53

                        local AssemblyLinearVelocity = PrimaryPart.AssemblyLinearVelocity
                        local v56 = v53:Cross(AssemblyCenterOfMass - v55)
                        local Y = v56.Y

                        if Y > 0 then
                            Y = math.max(0, (math.min(Y, Settings.LiftCap - AssemblyLinearVelocity.Y)))
                        end

                        local v59 = Vector3.new(v56.X, 0, v56.Z)
                        local v60 = Vector3.new(CFrame.RightVector.X, 0, CFrame.RightVector.Z)

                        if v60.Magnitude > 0.05 and v59.Magnitude > 1E-04 then
                            local v61 = v60.Unit * side
                            local v62 = v59:Dot(v61)

                            if v62 > 0 then
                                v59 += v61 * (math.min(v62, (math.max(0, Settings.SideMax - AssemblyLinearVelocity:Dot(v61)))) - v62)
                            end
                        end

                        PrimaryPart.AssemblyLinearVelocity = AssemblyLinearVelocity + Vector3.new(v59.X, Y, v59.Z)
                    end
                end
            end
        end
    end
end

function t1.Folders() -- line: 239
    local t8 = {}

    for _, v65 in { "RaceBikes", "CrashedBikes" } do
        local v66 = workspace:FindFirstChild(v65)

        if v66 then
            table.insert(t8, v66)
        end
    end

    return t8
end

return require(script.Parent:WaitForChild("OwnerFeatures14")).Wrap(t1, script.Parent, "Pre14_CrashTopple")
