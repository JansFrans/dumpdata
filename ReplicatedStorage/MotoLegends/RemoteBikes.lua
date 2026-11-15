-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local t1 = {}

if RunService:IsClient() then
    local Parent = script.Parent
    local SpectateSmoother = require(Parent:WaitForChild("SpectateSmoother"))
    local BikeSnapshotCodec = require(Parent:WaitForChild("BikeSnapshotCodec"))
    local BikeSnapshot = Parent:WaitForChild("BikeSnapshot")
    local ViewerCamera = Parent:WaitForChild("ViewerCamera")
    local LocalPlayer = Players.LocalPlayer
    local t2 = {}
    local t3 = {}
    local n1 = 0
    local _ = {
        Enabled = false,
        Max = 1.5,
        BlendTime = 0.12,
        BlendMax = 0.3,
        FadeTime = 0.2,
        MaxDistance = 250,
        ViewCone = 0.2
    }
    local v1
    local t4 = {
        RaceCrashSocket = true,
        RaceCrashJoint = true,
        RaceCrashCollider = true,
        RaceCrashRoot = true,
        RagdollGravity = true,
        RagdollGravityAttachment = true
    }

    local function visualList(p1) -- line: 49
        local t5 = {}

        for _, descendant in p1:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                table.insert(t5, descendant)
            end
        end

        return t5
    end

    local function setLocalFade(p2, p3) -- line: 54
        for _, v2 in p2 do
            if v2.Parent then
                v2.LocalTransparencyModifier = p3
            end
        end
    end

    local UserInputService = game:GetService("UserInputService")

    local function isMobile() -- line: 60
        -- upvalues: UserInputService (copy)
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
    end

    local function worthStandIn(p4) -- line: 61
        -- upvalues: UserInputService (copy)
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
            return false
        end

        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera then
            local v3 = p4 - CurrentCamera.CFrame.Position
            local Magnitude = v3.Magnitude

            if not (Magnitude > 250 or Magnitude < 0.001) then
                return CurrentCamera.CFrame.LookVector:Dot(v3 / Magnitude) >= 0.2
            end
        end

        return false
    end

    local function makeStandIn(p5, p6) -- line: 68
        -- upvalues: v1 (ref), t4 (copy), visualList (copy)
        local Archivable = p5.Archivable

        p5.Archivable = true

        local function v4() -- line: 70
            -- upvalues: p5 (copy)
            return p5:Clone()
        end

        local ok, result = pcall(v4)

        p5.Archivable = Archivable

        if ok and result then
            for _, descendant in result:GetDescendants() do
                if descendant.Parent and (descendant:IsA("BaseScript")
                    or descendant:IsA("ModuleScript")
                    or descendant:IsA("BillboardGui")
                    or descendant:IsA("IKControl")
                    or descendant:IsA("Sound")
                    or descendant:IsA("VectorForce")
                    or descendant:IsA("AlignOrientation")
                    or descendant:IsA("AlignPosition")
                    or t4[descendant.Name]) then
                    descendant:Destroy()
                end
            end

            for v5 in result:GetAttributes() do
                result:SetAttribute(v5, nil)
            end

            result.Name = p5.Name .. "_CrashStandIn"

            local Humanoid = result:FindFirstChildOfClass("Humanoid")

            if Humanoid and result:FindFirstChild("HumanoidRootPart") then
                Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff

                for _, descendant in result:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = false
                    end
                end

                for _, v6 in (visualList(result)) do
                    if v6.Parent then
                        v6.LocalTransparencyModifier = 0
                    end
                end

                result.Parent = workspace
                v1 = v1 or require(script.Parent:WaitForChild("RiderCrash"))

                local Start = v1.Start

                if pcall(Start, result, nil, 60, nil, nil) then
                    local AssemblyLinearVelocity, AssemblyAngularVelocity = p6.AssemblyLinearVelocity, p6.AssemblyAngularVelocity
                    local t6 = {}

                    for _, descendant in result:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            local v7 = descendant.AssemblyRootPart or descendant

                            if not t6[v7] then
                                t6[v7] = true
                                v7.AssemblyLinearVelocity = AssemblyLinearVelocity
                                v7.AssemblyAngularVelocity = AssemblyAngularVelocity
                            end
                        end
                    end

                    return result, result:FindFirstChild(p6.Name)
                end
            end

            result:Destroy()
        end

        return nil
    end

    local function bridgeMove(_, p8, p9) -- line: 98
        local t7 = {}

        for _, v8 in p8.realVisual do
            if v8.Parent and v8:IsA("BasePart") and not v8.Anchored then
                local v9 = v8.AssemblyRootPart or v8

                if not t7[v9] then
                    t7[v9] = true

                    local v10 = p8.parts[v9]
                    local v11 = v10 and v9.CFrame == v10 and p9 - p8.applied or p9

                    if v11.Magnitude > 1E-05 then
                        v9.CFrame += v11
                    end
                end
            end
        end

        p8.applied = p9
        table.clear(p8.parts)

        for v12 in t7 do
            p8.parts[v12] = v12.CFrame
        end
    end

    local t8 = {}

    setmetatable({}, {
        __mode = "k"
    })

    local t11 = {}

    local function userFromSlot(p10) -- line: 119
        -- upvalues: Players (copy), t11 (copy)
        local v13 = t11[p10]
        local v14 = v13 and Players:GetPlayerByUserId(v13)

        if v14 and v14:GetAttribute("SnapSlot") == p10 then
            return v13
        end

        t11[p10] = nil

        for _, player in Players:GetPlayers() do
            if player:GetAttribute("SnapSlot") == p10 then
                t11[p10] = player.UserId

                return player.UserId
            end
        end
    end

    BikeSnapshot.OnClientEvent:Connect(function(p11) -- line: 126
        -- upvalues: SpectateSmoother (copy), BikeSnapshotCodec (copy), LocalPlayer (copy), t2 (copy), userFromSlot (copy)
        if typeof(p11) ~= "buffer" then
            return
        end

        local elapsed = os.clock()

        for i = 0, buffer.len(p11) // BikeSnapshotCodec.ENTRY - 1 do
            local v15 = i * BikeSnapshotCodec.ENTRY
            local v16 = userFromSlot((buffer.readu8(p11, v15)))
            local v17, v18, v19, v20, v21

            if v16 and v16 ~= LocalPlayer.UserId then
                v17, v18, v19, v20 = BikeSnapshotCodec.Read(p11, v15 + 1)

                if v17 then
                    v21 = t2[v16]

                    if not v21 then
                        v21 = SpectateSmoother.New()
                        t2[v16] = v21
                    end

                    v21:Push(v17, v18, v19, v20, elapsed)
                end
            end
        end
    end)
    Players.PlayerRemoving:Connect(function(p12) -- line: 141
        -- upvalues: t2 (copy), t3 (copy)
        t2[p12.UserId] = nil
        t3[p12.UserId] = nil
    end)

    local function ridingRoot(p13) -- line: 143
        if p13:GetAttribute("Crash") ~= "" or not p13.PrimaryPart then
            return nil
        end

        local RiderSeat = p13:FindFirstChild("RiderSeat")

        return RiderSeat and RiderSeat.Occupant and p13.PrimaryPart or nil
    end

    local n2 = 0
    local n3 = -1

    local function myPing(p14) -- line: 150
        -- upvalues: LocalPlayer (copy), n2 (ref), n3 (ref)
        if not (p14 - n3 > 1) then
            return n2
        end

        n3 = p14

        local GetNetworkPing = LocalPlayer.GetNetworkPing
        local ok, result = pcall(GetNetworkPing, LocalPlayer)

        if ok and typeof(result) == "number" and result == result then
            n2 = math.clamp(result, 0, 1)
        end

        return n2
    end

    local function selfRiding(p15) -- line: 159
        -- upvalues: LocalPlayer (copy)
        for _, child in p15:GetChildren() do
            if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                local v22

                if child:GetAttribute("Crash") == "" and child.PrimaryPart then
                    local RiderSeat = child:FindFirstChild("RiderSeat")

                    v22 = RiderSeat and RiderSeat.Occupant and child.PrimaryPart or nil
                end

                return v22 ~= nil
            end
        end

        return false
    end

    RunService:BindToRenderStep("RemoteBikeSmoothing", Enum.RenderPriority.Camera.Value - 1, function(p16) -- line: 167
        -- upvalues: LocalPlayer (copy), t2 (copy), t3 (copy), n1 (ref), bridgeMove (copy), t8 (copy), n2 (ref), n3 (ref), selfRiding (copy)
        n1 += 1

        local RaceBikes = workspace:FindFirstChild("RaceBikes")

        if RaceBikes then
            local v23 = selfRiding(RaceBikes)

            if v23 then
                local elapsed = os.clock()

                if elapsed - n3 > 1 then
                    n3 = elapsed

                    local GetNetworkPing = LocalPlayer.GetNetworkPing
                    local ok, result = pcall(GetNetworkPing, LocalPlayer)

                    if ok and typeof(result) == "number" and result == result then
                        n2 = math.clamp(result, 0, 1)
                    end
                end
            end

            local v24 = v23 and n2 or 0

            for _, child in RaceBikes:GetChildren() do
                local OwnerUserId = child:GetAttribute("OwnerUserId")
                local v25 = OwnerUserId and OwnerUserId ~= LocalPlayer.UserId and t2[OwnerUserId]

                if v25 then
                    local v26

                    if child:GetAttribute("Crash") == "" and child.PrimaryPart then
                        local RiderSeat = child:FindFirstChild("RiderSeat")

                        v26 = RiderSeat and RiderSeat.Occupant and child.PrimaryPart or nil
                    end

                    if v26 and v25.lastArrival then
                        local _, v27 = v25:Apply(v26, p16, v23 and v25.delay + v24 or 0)
                        local v28 = t3[OwnerUserId]

                        if not v28 then
                            v28 = {}
                            t3[OwnerUserId] = v28
                        end

                        v28.vel = v27
                        v28.frame = n1
                    end
                end
            end

            os.clock()

            for _, child in RaceBikes:GetChildren() do
                child:GetAttribute("OwnerUserId")
            end
        end

        for v29, v30 in t8 do
            local torso = v30.torso

            if v29.Parent and torso.Parent then
                local elapsed = os.clock()
                local v31 = v30.parts[torso.AssemblyRootPart or torso]

                if not v31 or (torso.AssemblyRootPart or torso).CFrame ~= v31 then
                    v30.realNow = torso.Position
                end

                if v30.phase == "standin" then
                    if v30.copy.Parent and v30.copyTorso.Parent then
                        if (v30.realNow - v30.stale).Magnitude > 0.001 or elapsed - v30.t0 > 1.5 then
                            v30.phase = "blend"
                            v30.tb = elapsed
                            v30.err = v30.copyTorso.Position - v30.realNow

                            if v30.err.Magnitude > 25 then
                                v30.err = v30.err.Unit * 25
                            end
                        end
                    else
                        for _, v32 in v30.realVisual do
                            if v32.Parent then
                                v32.LocalTransparencyModifier = 0
                            end
                        end

                        t8[v29] = nil
                    end
                end

                if v30.phase == "blend" then
                    local v34 = math.clamp((elapsed - v30.tb) / 0.2, 0, 1)
                    local v36 = math.exp(-(elapsed - v30.tb) / 0.12)

                    if v36 < 0.03 and v34 >= 1 or elapsed - v30.tb > 0.3 then
                        pcall(bridgeMove, v29, v30, (Vector3.new(0, 0, 0)))

                        for _, v37 in v30.realVisual do
                            if v37.Parent then
                                v37.LocalTransparencyModifier = 0
                            end
                        end

                        if v30.copy then
                            v30.copy:Destroy()
                        end

                        t8[v29] = nil
                    else
                        local v38 = v30.err * v36

                        pcall(bridgeMove, v29, v30, v38)

                        local realVisual = v30.realVisual
                        local v39 = 1 - v34

                        for _, v40 in realVisual do
                            if v40.Parent then
                                v40.LocalTransparencyModifier = v39
                            end
                        end

                        for _, v41 in v30.copyVisual do
                            if v41.Parent then
                                v41.LocalTransparencyModifier = v34
                            end
                        end
                    end
                end
            else
                if v30.copy then
                    v30.copy:Destroy()
                end

                if v29.Parent then
                    for _, v42 in v30.realVisual do
                        if v42.Parent then
                            v42.LocalTransparencyModifier = 0
                        end
                    end
                end

                t8[v29] = nil
            end
        end

        for v43, v44 in t2 do
            local v45 = t3[v43]

            if v44.lastOut and (not v45 or v45.frame ~= n1) then
                v44:Release()
            end
        end
    end)

    function t1.Velocity(p17) -- line: 264
        -- upvalues: t3 (copy), n1 (ref)
        local v46 = t3[p17]
        local vel, v47

        if v46 and v46.frame == n1 then
            local vel2 = v46.vel

            if vel2 then
                vel = vel2
                v47 = true
            else
                v47 = false
            end
        else
            v47 = false
        end

        if not v47 then
            vel = nil
        end

        return vel
    end

    task.spawn(function() -- line: 269
        -- upvalues: Players (copy), ViewerCamera (copy)
        while true do
            task.wait(0.25)

            local CurrentCamera = workspace.CurrentCamera

            if CurrentCamera and #Players:GetPlayers() > 1 then
                ViewerCamera:FireServer(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector)
            end
        end
    end)
end

return t1
