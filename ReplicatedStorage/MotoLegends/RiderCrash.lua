-- https://lua.expert

local v1

local function __raceRC() -- line: 3
    -- upvalues: v1 (ref)
    if not (v1 and v1.Parent) then
        v1 = workspace:FindFirstChild("RaceCollision", true)
    end

    return v1
end

local Players = game:GetService("Players")
local Config = require(script.Parent.Config)
local t2 = {
    Head = true,
    Torso = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    UpperTorso = true,
    LowerTorso = true,
    LeftUpperArm = true,
    LeftLowerArm = true,
    LeftHand = true,
    RightUpperArm = true,
    RightLowerArm = true,
    RightHand = true,
    LeftUpperLeg = true,
    LeftLowerLeg = true,
    LeftFoot = true,
    RightUpperLeg = true,
    RightLowerLeg = true,
    RightFoot = true
}
local t1 = {}

function t1.ValidatePose(p1) -- line: 11
    -- upvalues: t2 (copy)
    if typeof(p1) ~= "table" then
        return nil
    end

    local t3 = {}
    local n1 = 0

    for v2, v3 in p1 do
        if not t2[v2] or typeof(v3) ~= "CFrame" or v3.Position.Magnitude > 8 then
            return nil
        end

        for _, v4 in { v3:GetComponents() } do
            if v4 ~= v4 or math.abs(v4) == 1e999 then
                return nil
            end
        end

        t3[v2] = v3
        n1 += 1

        if n1 > 20 then
            return nil
        end
    end

    return n1 > 0 and t3 or nil
end

local self = setmetatable({}, {
    __mode = "k"
})

t1.ServerSimulated = false

local function setRagdollOwner(p2, p3) -- line: 38
    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") and not descendant.Anchored then
            local v6 = descendant.AssemblyRootPart or descendant

            local function v7() -- line: 42
                -- upvalues: p3 (copy), v6 (copy)
                if v6:CanSetNetworkOwnership() and v6:GetNetworkOwner() ~= p3 then
                    v6:SetNetworkOwner(p3)
                end
            end

            pcall(v7)
        end
    end
end

function t1.Start(p4, p5, p6, p7, p8) -- line: 46
    -- upvalues: v1 (ref), Players (copy), Config (copy), t1 (copy), t2 (copy), self (copy), setRagdollOwner (copy)
    local v8 = p4 and p4:FindFirstChildOfClass("Humanoid")
    local v9 = p4 and p4:FindFirstChild("HumanoidRootPart")

    if not v8 or not v9 then
        return
    end

    if p4:GetAttribute("RaceCrashFlexible") then
        if self[p4] then
            return
        end

        t1.ForceRecover(p4)
    end

    p4:SetAttribute("RaceCrashEvaluationOriginal", true)
    p4:SetAttribute("RaceCrashActive", true)
    p4:SetAttribute("RaceCrashFlexible", true)

    local RequiresNeck, BreakJointsOnDeath = v8.RequiresNeck, v8.BreakJointsOnDeath

    v8.RequiresNeck = false
    v8.BreakJointsOnDeath = false
    v8.EvaluateStateMachine = false
    v8.PlatformStand = true
    v8.AutoRotate = false
    v8:ChangeState(Enum.HumanoidStateType.Physics)

    local Animate = p4:FindFirstChild("Animate")
    local v10

    if Animate then
        v10 = Animate.Enabled
        Animate.Enabled = false
    else
        v10 = Animate
    end

    local Animator = v8:FindFirstChildOfClass("Animator")

    if Animator then
        for _, v11 in Animator:GetPlayingAnimationTracks() do
            v11:Stop(0)
        end
    end

    local t6 = {}
    local t7 = {}
    local t8 = {}
    local t9 = {}

    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("Motor6D") or descendant:IsA("AnimationConstraint") then
            local v12, v13, v14

            if descendant:IsA("Motor6D") then
                v12 = descendant.Part0
                v13 = descendant.Part1
                v14 = descendant.C1
            elseif descendant:IsA("AnimationConstraint") and descendant.Attachment0 and descendant.Attachment1 then
                v12 = descendant.Attachment0.Parent
                v13 = descendant.Attachment1.Parent
                v14 = descendant.Attachment1.CFrame
            end

            if v12 and v13 and v12:IsA("BasePart") and v13:IsA("BasePart") and (t2[v13.Name] or v13 == v9) then
                t6[descendant] = descendant.Enabled
                table.insert(t9, {
                    a = v12,
                    b = v13,
                    local1 = v14,
                    name = descendant.Name
                })
                descendant.Enabled = false
            end
        end
    end

    local _CFrame = v9.CFrame

    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("BasePart") then
            t7[descendant] = {
                collide = descendant.CanCollide,
                group = descendant.CollisionGroup,
                massless = descendant.Massless,
                physical = descendant.CustomPhysicalProperties,
                anchored = descendant.Anchored
            }
            descendant.CanCollide = false
            descendant.CollisionGroup = "Riders"

            if t2[descendant.Name] then
                descendant.Massless = false
                descendant.CustomPhysicalProperties = PhysicalProperties.new(0.8, 0.72, 0, 1, 1)

                if p5 and p5[descendant.Name] then
                    descendant.CFrame = _CFrame * p5[descendant.Name]
                end
            else
                descendant.Massless = true
            end
        end
    end

    local t11 = {}
    local n2 = 0

    for _, v15 in t9 do
        local a, b = v15.a, v15.b
        local v16 = a.Name .. ":" .. b.Name

        if not t11[v16] then
            t11[v16] = true

            if a == v9 or b == v9 then
                local WeldConstraint = Instance.new("WeldConstraint")

                WeldConstraint.Name = "RaceCrashRoot"
                WeldConstraint.Part0 = a
                WeldConstraint.Part1 = b
                WeldConstraint.Parent = v9
                table.insert(t8, WeldConstraint)
            else
                local v17 = b.CFrame * v15.local1
                local Attachment = Instance.new("Attachment")

                Attachment.Name = "RaceCrashJoint"
                Attachment.CFrame = a.CFrame:ToObjectSpace(v17)
                Attachment.Parent = a

                local Attachment2 = Instance.new("Attachment")

                Attachment2.Name = "RaceCrashJoint"
                Attachment2.CFrame = v15.local1
                Attachment2.Parent = b

                local v18 = v15.name:lower()
                local v19, v20, v21

                if v18:find("shoulder") then
                    v19 = 85
                    v20 = 55
                    v21 = 2
                elseif v18:find("elbow") or v18:find("knee") then
                    v19 = 65
                    v20 = 12
                    v21 = 2
                elseif v18:find("waist") then
                    v19 = 35
                    v20 = 25
                    v21 = 4
                elseif v18:find("neck") then
                    v19 = 35
                    v20 = 30
                    v21 = 2.5
                else
                    if v18:find("wrist") or v18:find("ankle") then
                        v19 = 25
                        v20 = 15
                    else
                        v19 = 65
                        v20 = 35
                    end

                    v21 = 2
                end

                local BallSocketConstraint = Instance.new("BallSocketConstraint")

                BallSocketConstraint.Name = "RaceCrashSocket"
                BallSocketConstraint.Attachment0 = Attachment
                BallSocketConstraint.Attachment1 = Attachment2
                BallSocketConstraint.LimitsEnabled = true
                BallSocketConstraint.UpperAngle = v19
                BallSocketConstraint.TwistLimitsEnabled = true
                BallSocketConstraint.TwistLowerAngle = -v20
                BallSocketConstraint.TwistUpperAngle = v20
                BallSocketConstraint.Restitution = 0
                BallSocketConstraint.MaxFrictionTorque = v21
                BallSocketConstraint.Parent = a
                table.insert(t8, BallSocketConstraint)
                table.insert(t8, Attachment)
                table.insert(t8, Attachment2)
                n2 += 1
            end
        end
    end

    for v22 in t7 do
        if t2[v22.Name] and not v22.Name:find("Hand") and not v22.Name:find("Foot") then
            local Part = Instance.new("Part")

            Part.Name = "RaceCrashCollider"
            Part.Size = v22.Size * Vector3.new(0.76, 0.86, 0.76)
            Part.CFrame = v22.CFrame
            Part.Transparency = 1
            Part.CanCollide = true
            Part.CanTouch = false
            Part.CanQuery = false
            Part.Massless = true
            Part.CollisionGroup = "RiderRagdoll"
            Part.CustomPhysicalProperties = PhysicalProperties.new(0.8, 0.72, 0, 1, 1)
            Part.Parent = p4

            if v22.Name == "Head" then
                Part.Shape = Enum.PartType.Ball
            end

            local WeldConstraint = Instance.new("WeldConstraint", Part)

            WeldConstraint.Part0 = v22
            WeldConstraint.Part1 = Part
            table.insert(t8, Part)
        end
    end

    local t12 = {}

    for v23 in t7 do
        if v23.Parent and t2[v23.Name] then
            local v24 = v23.AssemblyRootPart or v23

            if not t12[v24] then
                t12[v24] = true

                local Attachment = Instance.new("Attachment")

                Attachment.Name = "RagdollGravityAttachment"
                Attachment.Parent = v24

                local VectorForce = Instance.new("VectorForce")

                VectorForce.Name = "RagdollGravity"
                VectorForce.Attachment0 = Attachment
                VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
                VectorForce.ApplyAtCenterOfMass = true
                VectorForce.Force = Vector3.new(0, 1, 0) * v24.AssemblyMass * (workspace.Gravity - Config.Gravity)
                VectorForce.Parent = v24
                table.insert(t8, VectorForce)
                table.insert(t8, Attachment)
            end
        end
    end

    p4:SetAttribute("RaceRagdollJoints", n2)
    p4:SetAttribute("RaceRigidWelds", 0)

    if t1.ServerSimulated then
        p4:SetAttribute("RaceCrashServerSim", true)
        setRagdollOwner(p4, nil)
        task.spawn(function() -- line: 133
            -- upvalues: p4 (copy), setRagdollOwner (copy)
            local RunService = game:GetService("RunService")
            local elapsed = os.clock()

            while true do
                if p4.Parent and p4:GetAttribute("RaceCrashServerSim") == true then
                    if os.clock() - elapsed < 0.5 then
                        RunService.Heartbeat:Wait()
                    else
                        task.wait(0.25)
                    end

                    if p4:GetAttribute("RaceCrashServerSim") == true then
                        setRagdollOwner(p4, nil)
                        continue
                    end
                end

                break
            end
        end)
    else
        local function v26() -- line: 143
            -- upvalues: p4 (copy), p8 (copy), v9 (copy), Players (copy)
            local v27 = p8 or Players:GetPlayerFromCharacter(p4)

            if v9:GetNetworkOwner() ~= v27 then
                v9:SetNetworkOwner(v27)
            end
        end

        pcall(v26)
    end

    local v28 = false

    local function recover() -- line: 146
        -- upvalues: p4 (copy), p7 (copy), p8 (copy), RequiresNeck (copy), BreakJointsOnDeath (copy), Animate (copy), t6 (copy), t7 (copy), t8 (copy), v28 (ref), recover (copy), v8 (copy), v9 (copy), v10 (ref), v1 (ref), Players (copy), self (copy), setRagdollOwner (copy)
        local v29 = true

        if v28 then
        elseif v8.Parent and v9.Parent then
            v28 = true

            if self[p4] == recover then
                self[p4] = nil
            end

            v29 = false
        end

        if not v29 then
            for v30 in t7 do
                if v30.Parent then
                    v30.Anchored = true
                    v30.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v30.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end

            local v31 = RaycastParams.new()

            v31.FilterType = Enum.RaycastFilterType.Include

            if not (v1 and v1.Parent) then
                v1 = workspace:FindFirstChild("RaceCollision", true)
            end

            v31.FilterDescendantsInstances = {
                v1,
                workspace.Terrain
            }

            local v33 = workspace:Raycast(v9.Position + Vector3.new(0, 15, 0), Vector3.new(-0, -80, -0, -0), v31)
            local v34 = Vector3.new(v9.CFrame.LookVector.X, 0, v9.CFrame.LookVector.Z)
            local v35 = v34

            if v34.Magnitude < 0.1 then
                v35 = Vector3.new(-1, 0, 0)
            end

            local v37 = Vector3.new(v9.Position.X, (v33 and v33.Position.Y or v9.Position.Y) + v8.HipHeight + v9.Size.Y / 2 + 0.3, v9.Position.Z)

            local function v38() -- line: 155
                -- upvalues: v35 (ref), v37 (copy), p4 (copy)
                p4:PivotTo(CFrame.lookAt(v37, v37 + v35.Unit))
            end

            pcall(v38)

            for _, v39 in t8 do
                if v39.Parent then
                    v39:Destroy()
                end
            end

            for v40, v41 in t6 do
                if v40.Parent then
                    if v40:IsA("Motor6D") or v40:IsA("AnimationConstraint") then
                        v40.Transform = CFrame.identity
                    end

                    v40.Enabled = v41
                end
            end

            for v42, v43 in t7 do
                if v42.Parent then
                    v42.CanCollide = v43.collide
                    v42.CollisionGroup = v43.group
                    v42.Massless = v43.massless
                    v42.CustomPhysicalProperties = v43.physical
                    v42.Anchored = v43.anchored
                end
            end

            if p7 then
                local ok, result = pcall(p7)

                if not ok then
                    warn("[RiderCrash] recovery callback failed: " .. tostring(result))
                end
            end

            v8.RequiresNeck = RequiresNeck
            v8.BreakJointsOnDeath = BreakJointsOnDeath
            v8.PlatformStand = false
            v8.AutoRotate = true
            v8.EvaluateStateMachine = true
            p4:SetAttribute("RaceRagdollJoints", 0)
            p4:SetAttribute("RaceCrashFlexible", false)
            p4:SetAttribute("RaceCrashActive", false)
            p4:SetAttribute("RaceCrashServerSim", nil)

            local function v44() -- line: 163
                -- upvalues: p4 (copy), p8 (copy), v9 (copy), Players (copy)
                v9:SetNetworkOwner(p8 or Players:GetPlayerFromCharacter(p4))
            end

            pcall(v44)
            setRagdollOwner(p4, p8 or Players:GetPlayerFromCharacter(p4))

            if Animate and Animate.Parent then
                Animate.Enabled = v10
            end

            v8:ChangeState(Enum.HumanoidStateType.GettingUp)
        elseif self[p4] == recover then
            self[p4] = nil
        end
    end

    self[p4] = recover
    task.delay(p6, function() -- line: 170
        -- upvalues: p4 (copy), recover (copy), v9 (copy), self (copy)
        if v9.Parent then
            recover()
        elseif self[p4] == recover then
            self[p4] = nil
        end
    end)
end

function t1.ForceRecover(p9) -- line: 177
    -- upvalues: v1 (ref), Players (copy), t2 (copy), self (copy), setRagdollOwner (copy)
    local v45 = p9 and self[p9]

    if v45 then
        v45()
    else
        local Humanoid = p9 and p9:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = p9 and p9:FindFirstChild("HumanoidRootPart")

        if not Humanoid or not HumanoidRootPart then
            return false
        end

        local t14 = {
            RaceCrashSocket = true,
            RaceCrashJoint = true,
            RaceCrashCollider = true,
            RaceCrashRoot = true,
            RagdollGravity = true,
            RagdollGravityAttachment = true
        }

        for _, descendant in p9:GetDescendants() do
            if t14[descendant.Name] and descendant.Parent then
                descendant:Destroy()
            end
        end

        for _, descendant in p9:GetDescendants() do
            if descendant:IsA("Motor6D") or descendant:IsA("AnimationConstraint") then
                descendant.Enabled = true
            elseif descendant:IsA("BasePart") then
                descendant.Anchored = false
                descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                descendant.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

                if t2[descendant.Name] then
                    descendant.CustomPhysicalProperties = nil
                end

                if descendant == HumanoidRootPart or descendant.Name == "UpperTorso" or descendant.Name == "LowerTorso" or descendant.Name == "Head" or descendant.Name == "Torso" then
                    descendant.CanCollide = true
                end
            end
        end

        local v46 = RaycastParams.new()

        v46.FilterType = Enum.RaycastFilterType.Include

        if not (v1 and v1.Parent) then
            v1 = workspace:FindFirstChild("RaceCollision", true)
        end

        v46.FilterDescendantsInstances = {
            v1,
            workspace.Terrain
        }

        local v48 = workspace:Raycast(HumanoidRootPart.Position + Vector3.new(0, 15, 0), Vector3.new(-0, -80, -0, -0), v46)
        local v49 = Vector3.new(HumanoidRootPart.CFrame.LookVector.X, 0, HumanoidRootPart.CFrame.LookVector.Z)
        local v50 = v49

        if v49.Magnitude < 0.1 then
            v50 = Vector3.new(-1, 0, 0)
        end

        local v52 = Vector3.new(HumanoidRootPart.Position.X, (v48 and v48.Position.Y or HumanoidRootPart.Position.Y) + Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2 + 0.3, HumanoidRootPart.Position.Z)

        local function v53() -- line: 196
            -- upvalues: p9 (copy), v50 (ref), v52 (copy)
            p9:PivotTo(CFrame.lookAt(v52, v52 + v50.Unit))
        end

        pcall(v53)
        Humanoid.PlatformStand = false
        Humanoid.AutoRotate = true
        Humanoid.EvaluateStateMachine = true
        Humanoid.RequiresNeck = true
        p9:SetAttribute("RaceCrashEvaluationOriginal", true)
        p9:SetAttribute("RaceRagdollJoints", 0)
        p9:SetAttribute("RaceCrashFlexible", false)
        p9:SetAttribute("RaceCrashActive", false)
        p9:SetAttribute("RaceCrashServerSim", nil)

        local Animate = p9:FindFirstChild("Animate")

        if Animate then
            Animate.Enabled = true
        end

        local function v54() -- line: 202
            -- upvalues: p9 (copy), HumanoidRootPart (copy), Players (copy)
            HumanoidRootPart:SetNetworkOwner(Players:GetPlayerFromCharacter(p9))
        end

        pcall(v54)
        setRagdollOwner(p9, Players:GetPlayerFromCharacter(p9))
        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    return true
end

function t1.Running(p10) -- line: 207
    -- upvalues: self (copy)
    return self[p10] ~= nil
end

return t1
