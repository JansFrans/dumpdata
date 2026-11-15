-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

game:GetService("TweenService")

local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local LocalPlayer = Players.LocalPlayer
local t1 = {
    QualiLoopScale = 0.8,
    Spacing = 3.4,
    Fill = 0.32,
    RaceStep = 2,
    QualiStep = 4,
    RaceCount = 3000,
    Scale = 0.85,
    NearRange = 160,
    NearMax = 300,
    NearMaxLow = 120,
    AnimHz = 20,
    LoopSound = "rbxassetid://9112779886",
    OohSound = "rbxassetid://9114010280",
    LoopVolume = 2,
    OohVolume = 6,
    EmitterCell = 220,
    RollMin = 45,
    RollMax = 480,
    CrashSeconds = 5,
    CrashNear = 350,
    RacePhases = {
        Grid = true,
        Lights = true,
        Racing = true,
        RaceResults = true
    },
    QualiPhases = {
        Qualifying = true,
        QualifyingFinish = true,
        QualifyingResults = true
    }
}
local t2 = {
    Color3.fromRGB(200, 30, 40),
    Color3.fromRGB(230, 230, 235),
    Color3.fromRGB(25, 25, 30),
    Color3.fromRGB(240, 190, 30),
    Color3.fromRGB(30, 90, 200),
    Color3.fromRGB(20, 140, 70),
    Color3.fromRGB(240, 110, 30),
    Color3.fromRGB(150, 40, 160),
    Color3.fromRGB(120, 180, 230)
}
local t3 = {
    Color3.fromRGB(35, 40, 60),
    Color3.fromRGB(25, 25, 28),
    Color3.fromRGB(90, 80, 70),
    Color3.fromRGB(60, 70, 90),
    Color3.fromRGB(52, 86, 140),
    Color3.fromRGB(70, 110, 165),
    Color3.fromRGB(190, 170, 130),
    Color3.fromRGB(120, 120, 125),
    Color3.fromRGB(230, 230, 232)
}

local function shirtColor(p1) -- line: 52
    local v1 = p1:NextNumber()

    if v1 < 0.06 then
        return Color3.fromRGB(240, 240, 242)
    end

    if v1 < 0.11 then
        return Color3.fromRGB(28, 28, 32)
    end

    if v1 < 0.15 then
        return Color3.fromRGB(130, 132, 138)
    end

    return Color3.fromHSV(p1:NextNumber(), p1:NextNumber(0.55, 0.95), p1:NextNumber(0.75, 1))
end

local t4 = {
    Color3.fromRGB(255, 220, 190),
    Color3.fromRGB(234, 184, 146),
    Color3.fromRGB(198, 140, 100),
    Color3.fromRGB(141, 85, 54),
    Color3.fromRGB(95, 60, 40)
}
local v3 = CFrame.new(0, math.max(workspace.FallenPartsDestroyHeight + 60, -400), 0)

local function lowSpec() -- line: 61
    -- upvalues: UserInputService (copy), LocalPlayer (copy)
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled or LocalPlayer:GetAttribute("GfxEffects") == false
end

local v4, t5, Folder

local function standsRoot() -- line: 69
    local Track = workspace:GetAttribute("Track")
    local v5 = typeof(Track) == "string" and workspace:FindFirstChild(Track)
    local v6, v7

    if v5 then
        local Grandstands = v5:FindFirstChild("Grandstands")

        if Grandstands then
            v6 = Grandstands
            v7 = true
        else
            local v8 = v5:FindFirstChild("Grandstands", true)

            if v8 then
                v6 = v8
                v7 = true
            else
                v7 = false
            end
        end
    else
        v7 = false
    end

    if not v7 then
        v6 = nil
    end

    return v6
end

local function buildSpots() -- line: 75
    -- upvalues: t1 (copy), t3 (copy), shirtColor (copy), t4 (copy), standsRoot (copy)
    local v9 = standsRoot()

    if not v9 then
        return {}, {}
    end

    local t6 = {}

    for _, child in v9:GetChildren() do
        for _, descendant in child:GetDescendants() do
            if descendant:IsA("BasePart") and (descendant.Name == "SeatRow" or descendant.Name == "Seats") then
                local CFrame, Size = descendant.CFrame, descendant.Size
                local v10 = Size.X >= Size.Z
                local RightVector = v10 and CFrame.RightVector or CFrame.LookVector
                local v11 = Vector3.new(RightVector.X, 0, RightVector.Z)

                if not (v11.Magnitude < 0.1) then
                    local Unit = v11.Unit
                    local Unit2 = Unit:Cross((Vector3.new(0, 1, 0))).Unit

                    table.insert(t6, {
                        part = descendant,
                        stand = child,
                        c = descendant.Position,
                        axis = Unit,
                        n = Unit2,
                        len = v10 and Size.X or Size.Z,
                        top = descendant.Position + CFrame.UpVector * (Size.Y / 2)
                    })
                end
            end
        end
    end

    for v12, v13 in t6 do
        local n1 = 0

        for v14, v15 in t6 do
            if v14 ~= v12 and v15.stand == v13.stand then
                local v16 = v15.c.Y - v13.c.Y

                if math.abs(v16) > 0.3 and math.abs(v16) < 6 then
                    local v19 = Vector3.new(v15.c.X - v13.c.X, 0, v15.c.Z - v13.c.Z)
                    local v20 = v19:Dot(v13.n)
                    local Magnitude = (v19 - v13.n * v20).Magnitude

                    if math.abs(v20) > 0.5 and math.abs(v20) < 9 and Magnitude < math.max(6, v13.len * 0.5) then
                        n1 += (if v16 < 0 then 1 else -1) * math.sign(v20)
                    end
                end
            end
        end

        v13.front = n1 >= 0 and v13.n or -v13.n
        v13.voted = n1 ~= 0

        if v12 % 60 == 0 then
            task.wait()
        end
    end

    local t8 = {}

    for _, v22 in t6 do
        if v22.voted then
            t8[v22.stand] = (t8[v22.stand] or Vector3.new(0, 0, 0)) + v22.front
        end
    end

    for _, v23 in t6 do
        if not v23.voted and t8[v23.stand] and t8[v23.stand].Magnitude > 0.1 then
            v23.front = t8[v23.stand].Unit:Dot(v23.n) >= 0 and v23.n or -v23.n
        end
    end

    local t9 = {
        Aisle = true,
        Step = true,
        AisleStep = true,
        Stairs = true
    }
    local t10 = {}

    for _, child in v9:GetChildren() do
        t10[child] = {}

        for _, descendant in child:GetDescendants() do
            if descendant:IsA("BasePart") and t9[descendant.Name] then
                local Size = descendant.Size
                local RightVector = Size.X >= Size.Z and descendant.CFrame.RightVector or descendant.CFrame.LookVector

                table.insert(t10[child], {
                    part = descendant,
                    long = Vector3.new(RightVector.X, 0, RightVector.Z).Unit,
                    ratio = math.max(Size.X, Size.Z) / math.max(math.min(Size.X, Size.Z), 0.1)
                })
            end
        end
    end

    local function onStairs(p2, p3, p4) -- line: 135
        -- upvalues: t10 (copy)
        for _, v27 in t10[p2] do
            local part = v27.part

            if not (v27.ratio > 3) or not (math.abs((v27.long:Dot(p4))) > 0.7) then
                local v34 = part.Size / 2
                local v35 = math.max(v34.X, v34.Y, v34.Z) + 4

                if math.abs(p3.X - part.Position.X) <= v35 and math.abs(p3.Z - part.Position.Z) <= v35 then
                    local v38 = part.CFrame:PointToObjectSpace(p3)

                    if math.abs(v38.X) <= v34.X + 1.2 and math.abs(v38.Z) <= v34.Z + 1.2 and math.abs(v38.Y) <= v34.Y + 6 then
                        return true
                    end
                end
            end
        end

        return false
    end

    local v39 = Random.new(110525)
    local t12 = {}
    local t13 = {}
    local Scale = t1.Scale
    local v40 = t1.Spacing / t1.Fill
    local n2 = 0

    for _, v41 in t6 do
        local v42 = v41.front:Cross((Vector3.new(0, 1, 0)))
        local v43 = -v41.len / 2 + 1 + v39:NextNumber(0, v40)

        while v43 < v41.len / 2 - 1 do
            local v44 = v41.top + v41.axis * v43

            v43 += v40 * v39:NextNumber(0.55, 1.45)

            if not onStairs(v41.stand, v44, v41.axis) then
                n2 += 1

                local t14 = {
                    cf = CFrame.fromMatrix(v44, v42, (Vector3.new(0, 1, 0))),
                    n = n2,
                    stand = v41.stand,
                    shirt = shirtColor(v39),
                    pants = t3[v39:NextInteger(1, #t3)],
                    skin = t4[v39:NextInteger(1, #t4)],
                    phase = v39:NextNumber(0, 6.283185307179586),
                    speed = v39:NextNumber(3, 6),
                    amp = v39:NextNumber(0.55, 1),
                    offset = v39:NextNumber(-0.5, 0.5)
                }

                table.insert(t12, t14)
                t13[v41.stand] = t13[v41.stand] or {}
                table.insert(t13[v41.stand], t14)
            end
        end
    end

    return t12, t13, Scale
end

local Scale = t1.Scale
local t15 = {
    Torso = CFrame.new(0, 1 * Scale, 0),
    Head = CFrame.new(0, 2.5 * Scale, 0),
    LeftLeg = CFrame.new(-0.5 * Scale, 0.5 * Scale, -1 * Scale) * CFrame.Angles(1.5707963267948966, 0, 0),
    RightLeg = CFrame.new(0.5 * Scale, 0.5 * Scale, -1 * Scale) * CFrame.Angles(1.5707963267948966, 0, 0),
    LeftShoulder = CFrame.new(-1.5 * Scale, 1.75 * Scale, 0),
    RightShoulder = CFrame.new(1.5 * Scale, 1.75 * Scale, 0),
    ArmDrop = CFrame.new(0, -0.75 * Scale, 0),
    Blob = CFrame.new(0, 1.3 * Scale, 0)
}

local function newPart(p5, p6, p7, p8) -- line: 188
    -- upvalues: v3 (copy)
    local Part = Instance.new("Part")

    Part.Name = p5
    Part.Size = p6
    Part.Color = p7
    Part.Material = Enum.Material.SmoothPlastic
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Locked = true
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.CFrame = v3
    Part.Parent = p8

    return Part
end

local t16 = {}

local function makeRig(p9) -- line: 197
    -- upvalues: t2 (copy), t3 (copy), t4 (copy), Scale (copy), newPart (copy)
    local Model = Instance.new("Model")

    Model.Name = "Spectator"

    local t17 = {
        model = Model
    }

    t17.Torso = newPart("Torso", Vector3.new(2, 2, 1) * Scale, t2[1], Model)
    t17.Head = newPart("Head", Vector3.new(2, 1, 1) * Scale, t4[1], Model)

    local SpecialMesh = Instance.new("SpecialMesh")

    SpecialMesh.MeshType = Enum.MeshType.Head
    SpecialMesh.Scale = Vector3.new(1.25, 1.25, 1.25)
    SpecialMesh.Parent = t17.Head
    t17.LeftArm = newPart("LeftArm", Vector3.new(1, 2, 1) * Scale, t4[1], Model)
    t17.RightArm = newPart("RightArm", Vector3.new(1, 2, 1) * Scale, t4[1], Model)
    t17.LeftLeg = newPart("LeftLeg", Vector3.new(1, 2, 1) * Scale, t3[1], Model)
    t17.RightLeg = newPart("RightLeg", Vector3.new(1, 2, 1) * Scale, t3[1], Model)
    Model.Parent = p9

    return t17
end

local function dress(p10, p11) -- line: 210
    p10.Torso.Color = p11.shirt
    p10.LeftArm.Color = p11.skin
    p10.RightArm.Color = p11.skin
    p10.Head.Color = p11.skin
    p10.LeftLeg.Color = p11.pants
    p10.RightLeg.Color = p11.pants
end

local v47 = false
local v48 = false
local v49 = false
local Folder2
local v50 = false
local t18 = {
    until_ = 0,
    pos = nil
}
local t19 = {
    at = -100,
    flip = false
}

local function sessionPhase() -- line: 223
    -- upvalues: MotoLegends (copy)
    return MotoLegends:GetAttribute("SessionPhase") or ""
end

local function build() -- line: 225
    -- upvalues: UserInputService (copy), LocalPlayer (copy), t1 (copy), v4 (ref), t5 (ref), Folder (ref), buildSpots (copy), Scale (copy), t15 (copy), newPart (copy), t16 (copy), makeRig (copy), v47 (ref), v49 (ref), Folder2 (ref), v50 (ref)
    if v47 or v49 then
        return
    end

    v49 = true

    local v51, v52 = buildSpots()

    v4 = v51
    Folder = Instance.new("Folder")
    Folder.Name = "GrandstandCrowd"
    Folder2 = Instance.new("Folder")
    Folder2.Name = "Silhouettes"
    Folder2.Parent = Folder

    local v53 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled or LocalPlayer:GetAttribute("GfxEffects") == false

    v50 = v53

    local v54 = #v4
    local v55 = math.min(t1.RaceCount, v54)
    local v56 = v4
    local n3 = 0

    for v57, v58 in v56 do
        if math.floor(v57 * v55 / v54) == math.floor((v57 - 1) * v55 / v54) then
            v58.r = nil
        else
            n3 += 1
            v58.r = n3
        end
    end

    local v62 = v4
    local n4 = 0

    for _, v63 in v62 do
        if v63.r and v63.r % (if v53 then 2 else 1) == 0 then
            local v64 = newPart("Fan", Vector3.new(1.9, 2.7, 1) * Scale, v63.shirt, Folder2)

            v64.CFrame = v63.cf * t15.Blob
            v63.blob = v64
            n4 += 1

            if n4 % 400 == 0 then
                task.wait()
            end
        end
    end

    local Folder3 = Instance.new("Folder")

    Folder3.Name = "Figures"
    Folder3.Parent = Folder

    for i = 1, v53 and t1.NearMaxLow or t1.NearMax do
        t16[i] = makeRig(Folder3)

        if i % 60 == 0 then
            task.wait()
        end
    end

    t5 = {}

    for _, v65 in v52 do
        local t20 = {}

        for _, v66 in v65 do
            local cfPosition = v66.cf.Position
            local v70 = math.floor(cfPosition.X / t1.EmitterCell) .. ":" .. math.floor(cfPosition.Z / t1.EmitterCell)
            local v71 = t20[v70] or {
                sum = Vector3.new(0, 0, 0),
                n = 0
            }

            v71.sum += cfPosition
            v71.n += 1
            t20[v70] = v71
        end

        for _, v72 in t20 do
            if v72.n >= 8 then
                local v73 = v72.sum / v72.n
                local v74 = newPart("CrowdSound", Vector3.new(1, 1, 1), Color3.new(), Folder)

                v74.Transparency = 1
                v74.CFrame = CFrame.new(v73)

                local function snd(p12, p13, p14, p15) -- line: 262
                    -- upvalues: v74 (copy), t1 (copy)
                    local Sound = Instance.new("Sound")

                    Sound.Name = p12
                    Sound.SoundId = p13
                    Sound.Looped = p15
                    Sound.Volume = p14
                    Sound.RollOffMode = Enum.RollOffMode.InverseTapered
                    Sound.RollOffMinDistance = t1.RollMin
                    Sound.RollOffMaxDistance = t1.RollMax
                    Sound.Parent = v74

                    return Sound
                end

                local t21 = t5
                local t22 = {
                    part = v74,
                    pos = v73
                }
                local LoopSound, LoopVolume = t1.LoopSound, t1.LoopVolume
                local Sound = Instance.new("Sound")

                Sound.Name = "Cheer"
                Sound.SoundId = LoopSound
                Sound.Looped = true
                Sound.Volume = LoopVolume
                Sound.RollOffMode = Enum.RollOffMode.InverseTapered
                Sound.RollOffMinDistance = t1.RollMin
                Sound.RollOffMaxDistance = t1.RollMax
                Sound.Parent = v74
                t22.loop = Sound

                local OohSound, OohVolume = t1.OohSound, t1.OohVolume
                local Sound2 = Instance.new("Sound")

                Sound2.Name = "CrashOoh"
                Sound2.SoundId = OohSound
                Sound2.Looped = false
                Sound2.Volume = OohVolume
                Sound2.RollOffMode = Enum.RollOffMode.InverseTapered
                Sound2.RollOffMinDistance = t1.RollMin
                Sound2.RollOffMaxDistance = t1.RollMax
                Sound2.Parent = v74
                t22.ooh = Sound2

                local OohSound2, OohVolume2 = t1.OohSound, t1.OohVolume
                local Sound3 = Instance.new("Sound")

                Sound3.Name = "CrashOoh2"
                Sound3.SoundId = OohSound2
                Sound3.Looped = false
                Sound3.Volume = OohVolume2
                Sound3.RollOffMode = Enum.RollOffMode.InverseTapered
                Sound3.RollOffMinDistance = t1.RollMin
                Sound3.RollOffMaxDistance = t1.RollMax
                Sound3.Parent = v74
                t22.ooh2 = Sound3
                table.insert(t21, t22)
            end
        end
    end

    v47 = true
    v49 = false
end

local v75

local function releaseRig(p16) -- line: 277
    if p16.spot then
        if p16.spot.blob then
            p16.spot.blob.Transparency = 0
        end

        p16.spot.rig = nil
        p16.spot = nil
    end
end

local function applyMode(p17) -- line: 280
    -- upvalues: v3 (copy), v4 (ref), t15 (copy)
    local t23 = {}
    local t24 = {}

    for _, v76 in v4 do
        if v76.blob then
            local v77 = v76.r ~= nil and v76.r % p17 == 0

            v76.visible = v77
            table.insert(t23, v76.blob)
            table.insert(t24, v77 and v76.cf * t15.Blob or v3)

            if not v77 and v76.rig then
                local rig = v76.rig

                if rig.spot then
                    if rig.spot.blob then
                        rig.spot.blob.Transparency = 0
                    end

                    rig.spot.rig = nil
                    rig.spot = nil
                end
            end
        end
    end

    if #t23 > 0 then
        workspace:BulkMoveTo(t23, t24, Enum.BulkMoveMode.FireCFrameChanged)
    end
end

local function setMode(p18) -- line: 293
    -- upvalues: t5 (ref), Folder (ref), t16 (copy), v47 (ref), v48 (ref), v50 (ref), build (copy), v75 (ref), applyMode (copy)
    if p18 == v75 then
        return
    end

    local v79 = v75

    v75 = p18

    if p18 then
        if not v47 then
            build()
        end

        if v75 == p18 then
            applyMode((p18 == 2 and 2 or 1) * (v50 and 2 or 1))

            if not v79 then
                Folder.Parent = workspace

                for _, v81 in t5 do
                    v81.loop.TimePosition = math.random() * 30
                    v81.loop:Play()
                end
            end

            v48 = true
        end
    else
        v48 = false

        if Folder then
            for _, v82 in t5 do
                v82.loop:Stop()
                v82.ooh:Stop()
                v82.ooh2:Stop()
            end

            for _, v83 in t16 do
                if v83.spot then
                    if v83.spot.blob then
                        v83.spot.blob.Transparency = 0
                    end

                    v83.spot.rig = nil
                    v83.spot = nil
                end
            end

            Folder.Parent = nil
        end
    end
end

local v84 = MotoLegends:WaitForChild("CrashFeed", 30)

if v84 then
    v84.OnClientEvent:Connect(function(p19) -- line: 318
        -- upvalues: Players (copy), t1 (copy), t5 (ref), v48 (ref), t18 (copy), t19 (copy), v75 (ref)
        if not v48 or typeof(p19) ~= "table" or p19.kind ~= nil then
            return
        end

        local v85 = typeof(p19.userId) == "number" and Players:GetPlayerByUserId(p19.userId)
        local Position

        for _, v86 in { "CrashedBikes", "RaceBikes" } do
            local v87 = workspace:FindFirstChild(v86)

            if v87 and not Position then
                for _, child in v87:GetChildren() do
                    if child:GetAttribute("OwnerUserId") == p19.userId and child.PrimaryPart then
                        Position = child.PrimaryPart.Position
                        break
                    end
                end
            end
        end

        if not Position and v85 and v85.Character and v85.Character:FindFirstChild("HumanoidRootPart") then
            Position = v85.Character.HumanoidRootPart.Position
        end

        t18.until_ = os.clock() + t1.CrashSeconds
        t18.pos = Position
        t18.at = os.clock()

        local elapsed = os.clock()
        local v88 = elapsed - t19.at >= 1.2

        if v88 then
            t19.at = elapsed
            t19.flip = not t19.flip
        end

        for _, v89 in t5 or {} do
            local v90 = 1

            if Position then
                local Magnitude = (v89.pos - Position).Magnitude

                v90 = if Magnitude <= t1.CrashNear then 1 else math.max(0.35, 1 - (Magnitude - t1.CrashNear) / 1200)
            end

            local v92 = t1.OohVolume * v90 * (v75 == 2 and t1.QualiLoopScale or 1)
            local ooh2 = t19.flip and v89.ooh2 or v89.ooh

            if v88 then
                ooh2.Volume = v92
                ooh2.TimePosition = 0
                ooh2:Play()
            elseif ooh2.Volume < v92 then
                ooh2.Volume = v92
            end
        end
    end)
end

local function excitement(p20) -- line: 349
    -- upvalues: t1 (copy), t18 (copy)
    local v93 = t18.until_ - os.clock()

    if v93 <= 0 then
        return 0
    end

    local v96 = math.min(1, math.clamp(v93 / t1.CrashSeconds, 0, 1) * 1.4)

    if t18.pos and p20 then
        local Magnitude = (p20 - t18.pos).Magnitude

        return v96 * (if Magnitude <= t1.CrashNear then 1 else math.max(0.35, 1 - (Magnitude - t1.CrashNear) / 1200))
    end

    return v96
end

local n5 = 0
local n6 = 0
local t25 = {}
local t26 = {}

local function assign() -- line: 364
    -- upvalues: t1 (copy), v3 (copy), v4 (ref), t15 (copy), t16 (copy)
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    local CFramePosition, LookVector = CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector
    local t27 = {}
    local v99 = t1.NearRange * t1.NearRange

    for _, v100 in v4 do
        if v100.blob and v100.visible then
            local v101 = v100.cf.Position - CFramePosition
            local v102 = v101.X * v101.X + v101.Y * v101.Y + v101.Z * v101.Z

            if v102 < v99 and (v102 < 900 or v101:Dot(LookVector) > math.sqrt(v102) * -0.25) then
                table.insert(t27, {
                    spot = v100,
                    d = v102
                })
            end
        end
    end

    table.sort(t27, function(p21, p22) -- line: 380
        return p21.d < p22.d
    end)

    local t29 = {}

    for i = 1, math.min(#t27, #t16) do
        t29[t27[i].spot] = true
    end

    local t30 = {}

    for _, v105 in t16 do
        if v105.spot and not t29[v105.spot] then
            v105.spot.blob.Transparency = 0
            v105.spot.rig = nil
            v105.spot = nil
        end

        if not v105.spot then
            table.insert(t30, v105)
        end
    end

    local t31 = {}
    local t32 = {}

    for v106 in t29 do
        if not v106.rig then
            local v107 = table.remove(t30)

            if not v107 then
                break
            end

            v107.spot = v106
            v106.rig = v107
            v106.blob.Transparency = 1
            v107.Torso.Color = v106.shirt
            v107.LeftArm.Color = v106.skin
            v107.RightArm.Color = v106.skin
            v107.Head.Color = v106.skin
            v107.LeftLeg.Color = v106.pants
            v107.RightLeg.Color = v106.pants

            local cf = v106.cf

            table.insert(t31, v107.Torso)
            table.insert(t32, cf * t15.Torso)
            table.insert(t31, v107.Head)
            table.insert(t32, cf * t15.Head)
            table.insert(t31, v107.LeftLeg)
            table.insert(t32, cf * t15.LeftLeg)
            table.insert(t31, v107.RightLeg)
            table.insert(t32, cf * t15.RightLeg)
        end
    end

    for _, v112 in t30 do
        for _, v113 in { "Torso", "Head", "LeftArm", "RightArm", "LeftLeg", "RightLeg" } do
            table.insert(t31, v112[v113])
            table.insert(t32, v3)
        end
    end

    if #t31 > 0 then
        workspace:BulkMoveTo(t31, t32, Enum.BulkMoveMode.FireCFrameChanged)
    end
end

local function animate(p23) -- line: 410
    -- upvalues: t15 (copy), t16 (copy), excitement (copy), t25 (copy), t26 (copy)
    table.clear(t25)
    table.clear(t26)

    for _, v115 in t16 do
        local spot = v115.spot

        if spot then
            local v116 = excitement(spot.cf.Position)
            local v117 = spot.speed * (1 + v116 * 1.2)
            local v118 = spot.amp + (1 - spot.amp) * v116
            local v120 = 0.5 - math.cos(p23 * v117 + spot.phase) * 0.5
            local v121 = 0.2617993877991494 + 2.705260340591211 * v118 * v120
            local v124 = 0.2617993877991494 + 2.705260340591211 * v118 * (0.5 - math.cos(p23 * v117 + spot.phase + spot.offset) * 0.5)
            local cf = spot.cf

            table.insert(t25, v115.LeftArm)
            table.insert(t26, cf * t15.LeftShoulder * CFrame.Angles(v121, 0, 0) * t15.ArmDrop)
            table.insert(t25, v115.RightArm)
            table.insert(t26, cf * t15.RightShoulder * CFrame.Angles(v124, 0, 0) * t15.ArmDrop)
        end
    end

    if #t25 > 0 then
        workspace:BulkMoveTo(t25, t26, Enum.BulkMoveMode.FireCFrameChanged)
    end
end

local function sounds() -- line: 429
    -- upvalues: t1 (copy), t5 (ref), v75 (ref)
    local v127 = t1.LoopVolume * (v75 == 2 and t1.QualiLoopScale or 1)

    for _, v128 in t5 do
        if v128.loop.Volume ~= v127 then
            v128.loop.Volume = v127
        end
    end
end

RunService.Heartbeat:Connect(function(p24) -- line: 434
    -- upvalues: MotoLegends (copy), LocalPlayer (copy), t1 (copy), t5 (ref), v47 (ref), v48 (ref), v49 (ref), v75 (ref), setMode (copy), n5 (ref), n6 (ref), assign (copy), animate (copy)
    local v129 = MotoLegends:GetAttribute("SessionPhase") or ""
    local v130 = if LocalPlayer:GetAttribute("GfxAudience") == false then nil
        elseif t1.RacePhases[v129] then 1
        elseif t1.QualiPhases[v129] and MotoLegends:GetAttribute("SessionPractice") ~= true then 2
        else nil

    if v130 ~= v75 and not v49 then
        task.spawn(setMode, v130)
    end

    if not (v48 and v47) then
        return
    end

    n5 -= p24

    if n5 <= 0 then
        n5 = 0.5
        assign()
    end

    n6 -= p24

    if not (n6 <= 0) then
        return
    end

    n6 = 1 / t1.AnimHz
    animate(os.clock())

    local v131 = t1.LoopVolume * (v75 == 2 and t1.QualiLoopScale or 1)

    for _, v132 in t5 do
        if v132.loop.Volume ~= v131 then
            v132.loop.Volume = v131
        end
    end
end)
