-- https://lua.expert

local t1 = {
    Settings = {
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
        LowsideSeconds = 2.5,
        LowsideMaxUp = 7,
        LowsideMaxSpin = 12,
        LowsideSpeedMargin = 2
    }
}

function t1.LimitLowside(p1, p2) -- line: 50
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

function t1.StartSpeed(p3) -- line: 64
    local LossVelocity = p3:GetAttribute("LossVelocity")

    return if typeof(LossVelocity) == "Vector3" then Vector3.new(LossVelocity.X, 0, LossVelocity.Z).Magnitude or nil else nil
end

local v5 = RaycastParams.new()

v5.FilterType = Enum.RaycastFilterType.Include

local n1 = 0

local function groundUnder(p4, p5) -- line: 70
    -- upvalues: v5 (copy), n1 (ref)
    if os.clock() > n1 then
        n1 = os.clock() + 5

        local t2 = {
            workspace.Terrain
        }
        local v6 = workspace:FindFirstChild("RaceCollision", true)

        if v6 then
            table.insert(t2, v6)
        end

        v5.FilterDescendantsInstances = t2
    end

    local v7 = workspace:Raycast(p4, Vector3.new(-0, -1, -0, -0) * p5, v5)

    if v7 and v7.Normal.Y > 0.5 and v7.Instance:GetAttribute("Surface") ~= "Barrier" then
        return v7
    end
end

local self = setmetatable({}, {
    __mode = "k"
})

function t1.CrashAge(p6) -- line: 80
    local CrashAudioStartedAt = p6:GetAttribute("CrashAudioStartedAt")

    return typeof(CrashAudioStartedAt) == "number" and workspace:GetServerTimeNow() - CrashAudioStartedAt or 0
end

function t1.Step(p7, p8) -- line: 85
    -- upvalues: t1 (copy), groundUnder (copy), self (copy)
    local PrimaryPart = p7.PrimaryPart
    local v9, v10

    if not PrimaryPart or PrimaryPart.Anchored or (p7:GetAttribute("Crash") or "") == "" then
        v10 = true
    else
        v9 = t1.CrashAge(p7)

        if p7:GetAttribute("Crash") == "LOWSIDE" and v9 < t1.Settings.LowsideSeconds then
            t1.LimitLowside(PrimaryPart, t1.StartSpeed(PrimaryPart))
        end

        v10 = false
    end

    if v10 or t1.Settings.Seconds < v9 or v9 < t1.Settings.Delay or PrimaryPart.AssemblyAngularVelocity.Magnitude > t1.Settings.BusySpin then
        return
    end

    local CFrame = PrimaryPart.CFrame
    local v11 = false
    local v12 = false
    local v13 = false
    local v14 = false
    local v15 = false
    local v16 = false
    local v17 = false

    if CFrame.UpVector.Y < t1.Settings.UprightUpY then
        v17 = true
    else
        v11 = true
    end

    local LookVector, v18, v19

    if v11 then
        LookVector = CFrame.LookVector
        v18 = p7:GetAttribute("CrashAudioStartedAt") or 0
        v19 = self[p7]

        if v19 then
            v12 = true
        else
            v13 = true
        end
    end

    v11 = false

    local v20

    if v12 then
        if v19.key == v18 then
            v20 = v19
            v17 = false
        else
            v13 = true
        end
    end

    v12 = false

    local Y, v21

    if v13 then
        Y = CFrame.RightVector.Y
        v21 = PrimaryPart.AssemblyAngularVelocity:Dot(LookVector)

        if math.abs(v21) > 0.3 then
            v11 = true
        else
            v12 = true
        end
    end

    v13 = false

    if v12 then
        if Y < -0.03 then
            v14 = true
        else
            v13 = true
        end
    end

    v12 = false

    if v13 then
        if Y > 0.03 then
            v15 = true
        else
            v12 = true
        end
    end

    v13 = false

    local LossSide

    if v12 then
        local LossSide2 = PrimaryPart:GetAttribute("LossSide")

        if LossSide2 then
            LossSide = LossSide2
            v16 = true
        else
            v13 = true
        end
    end

    v12 = false

    if v13 then
        LossSide = p7:GetAttribute("LossSide")
        v16 = true
    end

    v13 = false

    if v16 then
        if typeof(LossSide) == "number" then
            v13 = true
        else
            v12 = true
        end
    end

    v16 = false

    if v13 then
        if LossSide == 0 then
            v12 = true
        else
            v16 = true
        end
    end

    v13 = false

    local v22

    if v16 then
        local v23 = math.sign(LossSide)

        if v23 then
            v22 = v23
            v13 = true
        else
            v12 = true
        end
    end

    v16 = false

    if v12 then
        v22 = 1
        v13 = true
    end

    local v24

    if v13 then
        v24 = v22
        v16 = true
    end

    if v15 then
        v24 = -1
        v16 = true
    end

    if v14 then
        v24 = 1
        v16 = true
    end

    if v11 then
        v24 = math.sign(v21)
        v16 = true
    end

    if v16 then
        v20 = {
            key = v18,
            side = v24
        }
        v17 = false
        self[p7] = v20
    end

    if not v17 and not v20.gaveUp then
        local Settings = t1.Settings
        local side = v20.side
        local AssemblyAngularVelocity = PrimaryPart.AssemblyAngularVelocity
        local v25 = AssemblyAngularVelocity:Dot(LookVector) * side

        if Settings.RollRate <= v25 then
            v20.blocked = 0
        else
            local v26 = CFrame.RightVector.Y * side
            local AssemblyCenterOfMass = PrimaryPart.AssemblyCenterOfMass
            local v27 = groundUnder(AssemblyCenterOfMass, Settings.GroundProbe)

            if v27 then
                local v28 = AssemblyCenterOfMass.Y - v27.Position.Y

                v20.baseGap = v20.baseGap or v28

                if not (v20.baseGap + Settings.RiseMax < v28) then
                    v20.pushTime = (v20.pushTime or 0) + (p8 or 0.016666666666666666)

                    if v20.pushTime > Settings.MaxPushTime then
                        v20.gaveUp = true
                    else
                        v20.windowTime = (v20.windowTime or 0) + (p8 or 0.016666666666666666)

                        if v20.windowTime >= Settings.BlockedTime then
                            local v29 = v20.windowTilt and v20.windowTilt - v26 or 1

                            v20.windowTime = 0
                            v20.windowTilt = v26

                            if v29 < Settings.BlockedTilt then
                                if v20.flipped then
                                    v20.gaveUp = true
                                else
                                    v20.flipped = true
                                    v20.side = -side
                                    v20.windowTilt = nil
                                end

                                return
                            end
                        elseif not v20.windowTilt then
                            v20.windowTilt = v26
                        end

                        local v30 = LookVector * side * (Settings.RollRate - v25)
                        local v31 = Vector3.new(CFrame.RightVector.X, 0, CFrame.RightVector.Z)
                        local Unit = v31.Magnitude > 0.05 and v31.Unit or Vector3.new(0, 0, 0)
                        local v32 = v27.Position + Unit * side * Settings.TyreHalf

                        PrimaryPart.AssemblyAngularVelocity = AssemblyAngularVelocity + v30

                        local AssemblyLinearVelocity = PrimaryPart.AssemblyLinearVelocity
                        local v33 = v30:Cross(AssemblyCenterOfMass - v32)
                        local Y = v33.Y

                        if Y > 0 then
                            Y = math.max(0, (math.min(Y, Settings.LiftCap - AssemblyLinearVelocity.Y)))
                        end

                        local v36 = Vector3.new(v33.X, 0, v33.Z)
                        local v37 = Vector3.new(CFrame.RightVector.X, 0, CFrame.RightVector.Z)

                        if v37.Magnitude > 0.05 and v36.Magnitude > 1E-04 then
                            local v38 = v37.Unit * side
                            local v39 = v36:Dot(v38)

                            if v39 > 0 then
                                v36 += v38 * (math.min(v39, (math.max(0, Settings.SideMax - AssemblyLinearVelocity:Dot(v38)))) - v39)
                            end
                        end

                        PrimaryPart.AssemblyLinearVelocity = AssemblyLinearVelocity + Vector3.new(v36.X, Y, v36.Z)
                    end
                end
            end
        end
    end
end

function t1.Folders() -- line: 164
    local t5 = {}

    for _, v42 in { "RaceBikes", "CrashedBikes" } do
        local v43 = workspace:FindFirstChild(v42)

        if v43 then
            table.insert(t5, v43)
        end
    end

    return t5
end

return t1
