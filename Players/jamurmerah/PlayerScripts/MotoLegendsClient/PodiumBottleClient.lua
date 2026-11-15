-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PodiumBottleRemote = ReplicatedStorage:WaitForChild("PodiumBottleRemote")

local function checkPrompt(p1) -- line: 21
    -- upvalues: LocalPlayer (copy)
    if p1:IsA("ProximityPrompt") then
        local PodiumBottleOwner = p1:GetAttribute("PodiumBottleOwner")

        if PodiumBottleOwner ~= nil and PodiumBottleOwner ~= LocalPlayer.UserId then
            p1.Enabled = false
        end
    end
end

local function watchPodium(p2) -- line: 27
    -- upvalues: LocalPlayer (copy), checkPrompt (copy)
    if p2.Name == "SprintPodium" then
        for _, descendant in p2:GetDescendants() do
            if descendant:IsA("ProximityPrompt") then
                local PodiumBottleOwner = descendant:GetAttribute("PodiumBottleOwner")

                if PodiumBottleOwner ~= nil and PodiumBottleOwner ~= LocalPlayer.UserId then
                    descendant.Enabled = false
                end
            end
        end

        p2.DescendantAdded:Connect(checkPrompt)
    end
end

workspace.ChildAdded:Connect(watchPodium)

for _, child in workspace:GetChildren() do
    watchPodium(child)
end

local v1
local t1 = {}
local n1 = 0

local function interactable(p3) -- line: 41
    while true do
        if not p3 or not p3:IsA("GuiObject") then
            return true
        end

        if p3.Interactable then
            p3 = p3.Parent
            continue
        end

        break
    end

    return false
end

local function shown(p4) -- line: 49
    local v3 = p4:FindFirstAncestorWhichIsA("CanvasGroup")

    while v3 do
        if v3.GroupTransparency >= 0.95 then
            return false
        end

        v3 = v3:FindFirstAncestorWhichIsA("CanvasGroup")
    end

    if p4:IsA("CanvasGroup") and p4.GroupTransparency >= 0.95 then
        return false
    end

    if p4:IsA("ViewportFrame") or p4.BackgroundTransparency < 0.95 or (p4:IsA("ImageLabel") or p4:IsA("ImageButton")) and p4.Image ~= "" and p4.ImageTransparency < 0.95 then
        return true
    end

    return not not ((p4:IsA("TextLabel") or p4:IsA("TextButton")) and p4.Text ~= "" and p4.TextTransparency < 0.95)
end

local function onControl(p5) -- line: 62
    -- upvalues: LocalPlayer (copy), interactable (copy), shown (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui then
        local GetGuiObjectsAtPosition = PlayerGui.GetGuiObjectsAtPosition
        local X, Y = p5.X, p5.Y
        local ok, result = pcall(GetGuiObjectsAtPosition, PlayerGui, X, Y)

        if ok then
            for _, v4 in result do
                if (v4:IsA("GuiButton") or v4:IsA("TextBox")) and interactable(v4) then
                    return true
                end

                local LayerCollector = v4:FindFirstAncestorWhichIsA("LayerCollector")

                if LayerCollector then
                    if LayerCollector.Name == "ProximityPrompts" then
                        return true
                    end

                    if LayerCollector.Name == "TouchGui" then
                        if v4.Name:find("Thumbstick") then
                            return true
                        end
                    elseif interactable(v4) and shown(v4) then
                        return true
                    end
                elseif interactable(v4) and shown(v4) then
                    return true
                end
            end
        end
    end

    return false
end

local function tap() -- line: 83
    -- upvalues: PodiumBottleRemote (copy), v1 (ref), n1 (ref)
    if v1 and v1.Parent then
        local elapsed = os.clock()

        if not (elapsed - n1 < 0.25) and v1:GetAttribute("DrinkStart") == nil then
            n1 = elapsed
            PodiumBottleRemote:FireServer("Tap")
        end
    end
end

UserInputService.InputBegan:Connect(function(p6, p7) -- line: 92
    -- upvalues: UserInputService (copy), PodiumBottleRemote (copy), v1 (ref), t1 (copy), n1 (ref), onControl (copy)
    if not v1 then
        return
    end

    local UserInputType = p6.UserInputType

    if UserInputType == Enum.UserInputType.Gamepad1 then
        if p6.KeyCode == Enum.KeyCode.ButtonR2 and not p7 and v1 then
            if not v1.Parent then
                return
            end

            local elapsed = os.clock()

            if elapsed - n1 < 0.25 or v1:GetAttribute("DrinkStart") ~= nil then
                return
            end

            n1 = elapsed
            PodiumBottleRemote:FireServer("Tap")
        end
    elseif UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
        local FocusedTextBox = if not p7 then UserInputService:GetFocusedTextBox() else nil

        if not (p7 or FocusedTextBox) then
            local v5 = Vector2.new(p6.Position.X, p6.Position.Y)

            if not onControl(v5) then
                t1[p6] = {
                    t = os.clock(),
                    pos = v5
                }
            end
        end
    end
end)
UserInputService.InputChanged:Connect(function(p8) -- line: 105
    -- upvalues: t1 (copy)
    local v6 = t1[p8]

    if v6 and (Vector2.new(p8.Position.X, p8.Position.Y) - v6.pos).Magnitude > 14 then
        t1[p8] = nil
    end
end)
UserInputService.InputEnded:Connect(function(p9) -- line: 109
    -- upvalues: PodiumBottleRemote (copy), v1 (ref), t1 (copy), n1 (ref)
    local v7 = t1[p9]

    if v7 then
        t1[p9] = nil

        if not (os.clock() - v7.t > 0.35) and not ((Vector2.new(p9.Position.X, p9.Position.Y) - v7.pos).Magnitude > 14) and v1 then
            if not v1.Parent then
                return
            end

            local elapsed = os.clock()

            if elapsed - n1 < 0.25 or v1:GetAttribute("DrinkStart") ~= nil then
                return
            end

            n1 = elapsed
            PodiumBottleRemote:FireServer("Tap")
        end
    end
end)

local v8 = require(ReplicatedStorage:WaitForChild("MotoLegends"):WaitForChild("ShopCatalog")).BottleScale or 1
local _ = {
    Lean = 16,
    Neck = 30,
    Gulp = 3.5,
    GulpRate = 8,
    BottleStart = Vector3.new(0.42, -0.42, -0.8),
    BottleEnd = Vector3.new(0.42, -0.1, -0.9),
    MouthDepth = 0.12,
    HandR = Vector3.new(0.8, -0.2, 0.14),
    HandL = Vector3.new(0.98, -0.17, -0.12),
    PoleR = Vector3.new(1.4, -1, 0.6),
    PoleL = Vector3.new(-1.4, -1, 0.6)
}

local function smooth(p10) -- line: 133
    local v9 = math.clamp(p10, 0, 1)

    return v9 * v9 * (3 - 2 * v9)
end

local function joint(p11, p12) -- line: 134
    local v10 = p11 and p11:FindFirstChild(p12)

    if v10 then
        if v10:IsA("Motor6D") then
            return {
                j = v10,
                a0 = v10.C0,
                a1 = v10.C1
            }
        end

        if v10:IsA("AnimationConstraint") and v10.Attachment0 and v10.Attachment1 then
            return {
                j = v10,
                a0 = v10.Attachment0.CFrame,
                a1 = v10.Attachment1.CFrame
            }
        end
    end

    return nil
end

local function frame(p13, p14) -- line: 142
    local v11 = -p13.Unit
    local v12 = p14 - v11 * p14:Dot(v11)

    if v12.Magnitude < 1E-04 then
        v12 = Vector3.new(0, 0, 1) - v11 * v11.Z
    end

    local Unit = v12.Unit

    return CFrame.fromMatrix(Vector3.new(0, 0, 0), v11:Cross(Unit), v11, Unit)
end

local function aimRotation(p15, p16, p17) -- line: 149
    -- upvalues: frame (copy)
    return frame(p16, p17) * frame(p15, (Vector3.new(0, 0, 1))):Inverse()
end

local function solveElbow(p18, p19, p20, p21, p22) -- line: 153
    local v13 = p19 - p18
    local v17 = math.clamp(v13.Magnitude, math.abs(p20 - p21) + 0.001, p20 + p21 - 0.001)
    local Unit = v13.Magnitude > 1E-04 and v13.Unit or Vector3.new(0, 1, 0)
    local v19 = math.clamp((p20 * p20 + v17 * v17 - p21 * p21) / (2 * p20 * v17), -1, 1)
    local v20 = p22 - Unit * p22:Dot(Unit)
    local Unit2 = v20.Magnitude > 1E-04 and v20.Unit or Vector3.new(0, 1, 0)

    return p18 + Unit * p20 * v19 + Unit2 * p20 * math.sqrt(1 - v19 * v19)
end

local function poseArm(p23, p24, p25, p26, p27, p28) -- line: 163
    -- upvalues: joint (copy), frame (copy), solveElbow (copy)
    local v24 = p23:FindFirstChild(p24 .. "UpperArm")
    local v25 = p23:FindFirstChild(p24 .. "LowerArm")
    local v26 = p23:FindFirstChild(p24 .. "Hand")
    local v27 = joint(v24, p24 .. "Shoulder")
    local v28 = joint(v25, p24 .. "Elbow")
    local v29 = joint(v26, p24 .. "Wrist")
    local v30 = v26 and v26:FindFirstChild(p24 .. "GripAttachment")

    if not (v27 and v28 and v29 and v30) then
        return nil
    end

    local v31 = v24:FindFirstChild(p24 .. "ElbowRigAttachment")
    local Position

    if v31 then
        Position = v31.Position

        if not Position then
            Position = Vector3.new(0, -v24.Size.Y / 2, 0)
        end
    else
        Position = Vector3.new(0, -v24.Size.Y / 2, 0)
    end

    local v34 = Position - v27.a1.Position
    local v35 = v29.a0.Position + (v30.Position - v29.a1.Position) - v28.a1.Position
    local Position2 = (p25 * v27.a0).Position
    local v37 = frame(solveElbow(Position2, p26, v34.Magnitude, v35.Magnitude, p27) - Position2, p27) * frame(v34, (Vector3.new(0, 0, 1))):Inverse()
    local v38 = CFrame.new(Position2) * v37 * CFrame.new(-v27.a1.Position)
    local Position3 = (v38 * v28.a0).Position
    local v40 = frame(p26 - Position3, p27) * frame(v35, (Vector3.new(0, 0, 1))):Inverse()
    local v41 = CFrame.new(Position3) * v40 * CFrame.new(-v28.a1.Position)
    local v42 = (p25 * v27.a0):Inverse() * v38 * v27.a1
    local v43 = (v38 * v28.a0):Inverse() * v41 * v28.a1

    v27.j.Transform = v27.j.Transform:Lerp(v42, p28)
    v28.j.Transform = v28.j.Transform:Lerp(v43, p28)
    v29.j.Transform = v29.j.Transform:Lerp(CFrame.identity, p28)

    return v41 * v29.a0 * v29.a1:Inverse()
end

local function poseDrink(p29, p30, p31, p32, p33) -- line: 188
    -- upvalues: v8 (copy), joint (copy), poseArm (copy)
    local HumanoidRootPart = p29:FindFirstChild("HumanoidRootPart")
    local LowerTorso = p29:FindFirstChild("LowerTorso")
    local UpperTorso = p29:FindFirstChild("UpperTorso")
    local Head = p29:FindFirstChild("Head")
    local Handle = p30:FindFirstChild("Handle")
    local Root = joint(LowerTorso, "Root")
    local Waist = joint(UpperTorso, "Waist")
    local Neck = joint(Head, "Neck")

    if not (HumanoidRootPart and Handle and Root and Waist and Neck) then
        return
    end

    local v45 = math.sin(p31 * 8) * 3.5
    local v47 = math.clamp(p33 * 4, 0, 1)
    local v48 = v45 * (v47 * v47 * (3 - 2 * v47))

    Waist.j.Transform = Waist.j.Transform:Lerp(CFrame.Angles(0.2792526803190927, 0, 0), p32)
    Neck.j.Transform = Neck.j.Transform:Lerp(CFrame.Angles(math.rad(30 + v48), 0, 0), p32)

    local v50 = HumanoidRootPart.CFrame * Root.a0 * Root.j.Transform * Root.a1:Inverse() * Waist.a0 * Waist.j.Transform * Waist.a1:Inverse()
    local v51 = v50 * Neck.a0 * Neck.j.Transform * Neck.a1:Inverse()
    local Size = Head.Size
    local v54 = Vector3.new(0, -0.27 * Size.Y, -0.5 * Size.Z)
    local v55 = math.clamp(p33, 0, 1)
    local Unit = (Vector3.new(0.42, -0.42, -0.8)):Lerp(Vector3.new(0.42, -0.1, -0.9), v55 * v55 * (3 - 2 * v55)).Unit
    local Unit2 = (Vector3.new(0, 1, 0) - Unit * Unit.Y).Unit
    local Nozzle = Handle:FindFirstChild("Nozzle")
    local X = Nozzle and Nozzle.Position.X or 1.33 * v8
    local v56 = v51 * CFrame.fromMatrix(v54 + Unit * (X - 0.12 * v8), -Unit, Unit2)
    local v57 = poseArm(p29, "Right", v50, (v56 * CFrame.new(Vector3.new(0.8, -0.2, 0.14) * v8)).Position, v50:VectorToWorldSpace((Vector3.new(1.4, -1, 0.6))), p32)

    poseArm(p29, "Left", v50, (v56 * CFrame.new(Vector3.new(0.98, -0.17, -0.12) * v8)).Position, v50:VectorToWorldSpace((Vector3.new(-1.4, -1, 0.6))), p32)

    local RightHand = p29:FindFirstChild("RightHand")
    local RightGrip = RightHand and RightHand:FindFirstChild("RightGrip")

    if v57 and RightGrip and RightGrip:IsA("Weld") and RightGrip.Part1 == Handle then
        local v58 = v56:Inverse() * v57 * RightGrip.C0

        RightGrip.C1 = p30.Grip:Lerp(v58, p32)
    end
end

local t2 = {}

local function releaseGrip(p34) -- line: 220
    -- upvalues: t2 (copy)
    t2[p34] = nil

    local Parent = p34.Parent
    local RightHand = Parent and Parent:FindFirstChild("RightHand")
    local RightGrip = RightHand and RightHand:FindFirstChild("RightGrip")

    if RightGrip and RightGrip:IsA("Weld") then
        RightGrip.C1 = p34.Grip
    end
end

RunService.PreSimulation:Connect(function() -- line: 227
    -- upvalues: Players (copy), poseDrink (copy), t2 (copy)
    local ServerTimeNow = workspace:GetServerTimeNow()

    for v59 in t2 do
        if not v59.Parent or v59:GetAttribute("DrinkStart") == nil then
            t2[v59] = nil

            local Parent = v59.Parent

            Parent = Parent and Parent:FindFirstChild("RightHand")
            Parent = Parent and Parent:FindFirstChild("RightGrip")

            if Parent and Parent:IsA("Weld") then
                Parent.C1 = v59.Grip
            end
        end
    end

    for _, player in Players:GetPlayers() do
        local Character = player.Character
        local PodiumBottle = Character and Character:FindFirstChild("PodiumBottle")
        local DrinkStart = PodiumBottle and PodiumBottle:GetAttribute("DrinkStart")

        if DrinkStart then
            local DrinkTiming = PodiumBottle:GetAttribute("DrinkTiming")
            local v60, v61, v62

            if typeof(DrinkTiming) == "Vector3" then
                v60 = DrinkTiming.X
                v61 = DrinkTiming.Y
                v62 = DrinkTiming.Z
            else
                v60 = 0.4
                v61 = 1.8
                v62 = 0.45
            end

            local v64 = math.max(0, ServerTimeNow - DrinkStart)
            local v65 = v60 + v61 + v62

            if v64 < v65 then
                local v66

                if v64 < v60 then
                    local v68 = math.clamp(v64 / v60, 0, 1)

                    v66 = v68 * v68 * (3 - 2 * v68)

                    if not v66 then
                        if v60 + v61 < v64 then
                            local v70 = math.clamp((v65 - v64) / v62, 0, 1)

                            v66 = v70 * v70 * (3 - 2 * v70) or 1
                        else
                            v66 = 1
                        end
                    end
                elseif v60 + v61 < v64 then
                    local v72 = math.clamp((v65 - v64) / v62, 0, 1)

                    v66 = v72 * v72 * (3 - 2 * v72) or 1
                else
                    v66 = 1
                end

                t2[PodiumBottle] = true

                local v74 = math.clamp((v64 - v60) / v61, 0, 1)
                local ok, result = pcall(poseDrink, Character, PodiumBottle, v64, v66, v74)

                if not ok then
                    warn("[PodiumBottle] drink pose: " .. tostring(result))
                end
            elseif t2[PodiumBottle] then
                t2[PodiumBottle] = nil

                local Parent = PodiumBottle.Parent
                local RightHand = Parent and Parent:FindFirstChild("RightHand")
                local RightGrip = RightHand and RightHand:FindFirstChild("RightGrip")

                if RightGrip and RightGrip:IsA("Weld") then
                    RightGrip.C1 = PodiumBottle.Grip
                end
            end
        end
    end
end)

local CollectionService = game:GetService("CollectionService")
local t3 = {}

local function addRainbow(p35) -- line: 258
    -- upvalues: t3 (copy)
    if p35:IsA("BasePart") then
        t3[p35] = p35.CFrame.Position.X
    end
end

CollectionService:GetInstanceAddedSignal("RainbowBottlePart"):Connect(addRainbow)
CollectionService:GetInstanceRemovedSignal("RainbowBottlePart"):Connect(function(p36) -- line: 260
    -- upvalues: t3 (copy)
    t3[p36] = nil
end)

for _, v75 in CollectionService:GetTagged("RainbowBottlePart") do
    if v75:IsA("BasePart") then
        t3[v75] = v75.CFrame.Position.X
    end
end

RunService.RenderStepped:Connect(function() -- line: 262
    -- upvalues: t3 (copy)
    if next(t3) == nil then
        return
    end

    local v76 = os.clock() * 0.35

    for v77, _ in t3 do
        if v77.Parent then
            local Handle = v77.Parent:FindFirstChild("Handle")
            local v78 = Handle and Handle ~= v77 and Handle.CFrame:PointToObjectSpace(v77.Position).X or 0

            v77.Color = Color3.fromHSV((v76 + v78 * 0.18) % 1, 0.8, 1)
        else
            t3[v77] = nil
        end
    end
end)

local function cseq(...) -- line: 277
    local t4 = {}
    local t5 = { ... }

    for v79, v80 in t5 do
        table.insert(t4, ColorSequenceKeypoint.new((v79 - 1) / (#t5 - 1), v80))
    end

    return ColorSequence.new(t4)
end

local t6 = {
    Pink = {
        ribbons = 2,
        hazeRate = 5,
        ribbon = cseq(Color3.fromRGB(255, 215, 236), Color3.fromRGB(255, 110, 190)),
        haze = Color3.fromRGB(255, 140, 205)
    },
    Golden = {
        ribbons = 3,
        hazeRate = 7,
        ribbon = cseq(Color3.fromRGB(255, 250, 215), Color3.fromRGB(255, 196, 40)),
        haze = Color3.fromRGB(255, 206, 90)
    },
    Rainbow = {
        ribbons = 5,
        hazeRate = 12,
        rainbowHaze = true,
        ribbon = cseq(Color3.fromRGB(255, 80, 80), Color3.fromRGB(255, 200, 60), Color3.fromRGB(110, 255, 130), Color3.fromRGB(80, 190, 255), Color3.fromRGB(200, 110, 255)),
        haze = Color3.fromRGB(235, 225, 255)
    },
    Blackhole = {
        ribbons = 4,
        hazeRate = 3,
        ribbon = cseq(Color3.fromRGB(255, 248, 210), Color3.fromRGB(255, 192, 30), Color3.fromRGB(255, 110, 10)),
        haze = Color3.fromRGB(255, 170, 40)
    }
}

local function bhDisk(p37, p38) -- line: 291
    local t7 = {
        tilt = 0.3141592653589793,
        layers = {},
        streaks = {}
    }

    for _, v82 in {
            {
                Color3.fromRGB(255, 242, 180),
                0.18, 2.5, 0.06
            },
            {
                Color3.fromRGB(255, 190, 40),
                0.36, 3.5, 0.045
            },
            {
                Color3.fromRGB(255, 122, 15),
                0.6, 4.6, 0.03
            },
            {
                Color3.fromRGB(190, 70, 10),
                0.84, 5.8, 0.018
            }
        } do
        local Part = Instance.new("Part")

        Part.Name = "BHDisk"
        Part.Shape = Enum.PartType.Cylinder
        Part.Material = Enum.Material.Neon
        Part.Color = v82[1]
        Part.Transparency = v82[2]
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.Massless = true
        Part.Size = Vector3.new(v82[4], p38 * v82[3], p38 * v82[3])
        Part.CFrame = p37.CFrame
        Part.Parent = p37
        table.insert(t7.layers, Part)
    end

    local v86 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 250, 220)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 196, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 110, 10))
    })

    for _ = 1, 7 do
        local Attachment = Instance.new("Attachment")

        Attachment.Name = "BHStreakA"
        Attachment.Parent = p37

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Name = "BHStreakB"
        Attachment2.Parent = p37

        local Trail = Instance.new("Trail")

        Trail.Name = "BHStreak"
        Trail.Attachment0 = Attachment
        Trail.Attachment1 = Attachment2
        Trail.Color = v86
        Trail.LightEmission = 1
        Trail.LightInfluence = 0
        Trail.Brightness = 2
        Trail.Lifetime = 0.2
        Trail.MinLength = 0
        Trail.FaceCamera = true
        Trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.7, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
        Trail.WidthScale = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0.15)
        })
        Trail.Parent = p37

        local v87 = p38 * (1.4 + math.random() * 1.3)

        table.insert(t7.streaks, {
            a0 = Attachment,
            a1 = Attachment2,
            r = v87,
            th = math.random() * 3.141592653589793 * 2,
            w = 7 / (v87 / p38) ^ 1.5
        })
    end

    return t7
end

local function bhDiskPose(p39, p40, p41, p42) -- line: 313
    local v89 = CFrame.Angles(0, 0, p39.tilt + math.sin(p41 * 0.9) * 0.07)
    local v90 = p40.CFrame * v89

    for _, v91 in p39.layers do
        v91.CFrame = v90
    end

    for _, v92 in p39.streaks do
        v92.th += p42 * v92.w

        local v95 = v89:VectorToWorldSpace(Vector3.new(0, math.cos(v92.th), (math.sin(v92.th))) * v92.r)

        v92.a0.Position = v95
        v92.a1.Position = v95 + v89.RightVector * 0.06
    end
end

local function prismRing(p43, p44) -- line: 325
    local t9 = {
        tilt = -0.24434609527920614,
        gems = {}
    }

    for i = 1, 14 do
        local Part = Instance.new("Part")

        Part.Name = "PrismGem"
        Part.Shape = Enum.PartType.Ball
        Part.Material = Enum.Material.Neon
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.Massless = true

        local v96 = p44 * 0.32

        Part.Size = Vector3.new(v96, v96, v96)
        Part.CFrame = p43.CFrame
        Part.Parent = p43
        table.insert(t9.gems, {
            p = Part,
            a = (i - 1) / 14 * 3.141592653589793 * 2
        })
    end

    t9.r = p44 * 2.1

    return t9
end

local function prismRingPose(p45, p46, p47) -- line: 336
    local v97 = p46.CFrame * CFrame.Angles(0, 0, p45.tilt)

    for v98, v99 in p45.gems do
        local v100 = v99.a + p47 * 1.6

        v99.p.CFrame = v97 * CFrame.new(0, math.cos(v100) * p45.r, math.sin(v100) * p45.r)
        v99.p.Color = Color3.fromHSV((v98 / #p45.gems - p47 * 0.25) % 1, 0.75, 1)
    end
end

local function fxPartsHidden(p48, p49) -- line: 349
    local v101 = if p49 then 1 else 0

    if p48.disk then
        for _, v102 in p48.disk.layers do
            v102.LocalTransparencyModifier = v101
        end
    end

    if p48.prism then
        for _, v103 in p48.prism.gems do
            v103.p.LocalTransparencyModifier = v101
        end
    end
end

local t11 = {}

local function decorate(p50) -- line: 355
    -- upvalues: t6 (copy), bhDisk (copy), prismRing (copy), t11 (copy)
    if t11[p50] or not p50:IsA("BasePart") then
        return
    end

    local v104 = t6[p50:GetAttribute("BottleFx") or ""]

    if v104 then
        local t12 = {
            orbits = {},
            fx = v104
        }
        local X = p50.Size.X
        local v105 = p50.Size.Y * 0.5

        for i = 1, v104.ribbons do
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "LuxOrbitA"
            Attachment.Parent = p50

            local Attachment2 = Instance.new("Attachment")

            Attachment2.Name = "LuxOrbitB"
            Attachment2.Parent = p50

            local Trail = Instance.new("Trail")

            Trail.Name = "LuxRibbon"
            Trail.Attachment0 = Attachment
            Trail.Attachment1 = Attachment2
            Trail.Color = v104.ribbon
            Trail.LightEmission = 0.75
            Trail.LightInfluence = 0
            Trail.Brightness = 1.2
            Trail.Lifetime = 0.32
            Trail.MinLength = 0
            Trail.FaceCamera = true
            Trail.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.05),
                NumberSequenceKeypoint.new(0.6, 0.55),
                NumberSequenceKeypoint.new(1, 1)
            })
            Trail.WidthScale = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0.1)
            })
            Trail.Parent = p50

            local v106 = if i % 2 == 0 then -1 else 1
            local orbits = t12.orbits
            local t13 = {
                a0 = Attachment,
                a1 = Attachment2,
                phase = (i - 1) / v104.ribbons * 3.141592653589793 * 2,
                speed = v106 * (i * 0.55 + 3.6)
            }
            local v107 = v104.ribbons - 1

            t13.x = X * ((i - 1) * 0.4 / math.max(1, v107) + -0.2)
            t13.amp = X * 0.28
            t13.wave = i * 0.3 + 1.4
            t13.r = v105 * (i * 0.1 + 1.3)
            table.insert(orbits, t13)
        end

        local ParticleEmitter = Instance.new("ParticleEmitter")

        ParticleEmitter.Name = "LuxHaze"
        ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
        ParticleEmitter.Color = v104.rainbowHaze and v104.ribbon or ColorSequence.new(v104.haze)
        ParticleEmitter.LightEmission = 1
        ParticleEmitter.LightInfluence = 0
        ParticleEmitter.Brightness = 1.5
        ParticleEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, X * 0.9),
            NumberSequenceKeypoint.new(1, X * 1.6)
        })
        ParticleEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.86),
            NumberSequenceKeypoint.new(1, 1)
        })
        ParticleEmitter.Lifetime = NumberRange.new(1.2, 1.8)
        ParticleEmitter.Speed = NumberRange.new(0.1, 0.4)
        ParticleEmitter.Rate = v104.hazeRate
        ParticleEmitter.Rotation = NumberRange.new(0, 360)
        ParticleEmitter.RotSpeed = NumberRange.new(-30, 30)
        ParticleEmitter.LockedToPart = true
        ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
        ParticleEmitter.Parent = p50
        t12.haze = ParticleEmitter

        if p50:GetAttribute("BottleFx") == "Blackhole" then
            t12.disk = bhDisk(p50, v105)
        end

        if p50:GetAttribute("BottleFx") == "Rainbow" then
            t12.prism = prismRing(p50, v105)
        end

        t12.shown = false
        ParticleEmitter.Enabled = false

        if t12.disk then
            for _, v108 in t12.disk.layers do
                v108.LocalTransparencyModifier = 1
            end
        end

        if t12.prism then
            for _, v109 in t12.prism.gems do
                v109.p.LocalTransparencyModifier = 1
            end
        end

        t11[p50] = t12
    end
end

CollectionService:GetInstanceAddedSignal("LuxuryBottle"):Connect(function(p51) -- line: 386
    -- upvalues: decorate (copy)
    task.defer(decorate, p51)
end)

for _, v110 in CollectionService:GetTagged("LuxuryBottle") do
    decorate(v110)
end

local function bottleVisible(p52, p53) -- line: 394
    if not p53 then
        return true
    end

    local CFramePosition = p53.CFrame.Position

    if (p52.Position - CFramePosition).Magnitude > 150 then
        return false
    end

    local v111 = p53:WorldToViewportPoint(p52.Position)

    if v111.Z <= 0 then
        return (p52.Position - CFramePosition).Magnitude < 12
    end

    local ViewportSize = p53.ViewportSize
    local v112 = math.max(ViewportSize.X, ViewportSize.Y) * 0.3

    if v111.X > -v112 and v111.X < ViewportSize.X + v112 and v111.Y > -v112 then
        return v111.Y < ViewportSize.Y + v112
    end

    return false
end

RunService.RenderStepped:Connect(function(p54) -- line: 403
    -- upvalues: bhDiskPose (copy), prismRingPose (copy), t11 (copy), bottleVisible (copy)
    if next(t11) == nil then
        return
    end

    local elapsed = os.clock()
    local CurrentCamera = workspace.CurrentCamera

    for v113, v114 in t11 do
        if v113.Parent then
            v114.fxDt = (v114.fxDt or 0) + p54

            local v115 = bottleVisible(v113, CurrentCamera)

            if v114.shown ~= v115 then
                if v114.haze then
                    v114.haze.Enabled = v115
                end

                local v116 = if not v115 then 1 else 0

                if v114.disk then
                    for _, v117 in v114.disk.layers do
                        v117.LocalTransparencyModifier = v116
                    end
                end

                if v114.prism then
                    for _, v118 in v114.prism.gems do
                        v118.p.LocalTransparencyModifier = v116
                    end
                end

                if v115 then
                    v114.fxDt = math.max(v114.fxDt, 0.03333333333333333)
                end
            end

            v114.shown = v115

            if v115 and (not v113.Anchored or not (v114.fxDt < 0.03333333333333333)) then
                local fxDt = v114.fxDt

                v114.fxDt = 0

                for _, v127 in v114.orbits do
                    local v128 = elapsed * v127.speed + v127.phase
                    local v131 = Vector3.new(0, math.cos(v128), (math.sin(v128)))
                    local v134 = Vector3.new(v127.x + v127.amp * math.sin(elapsed * v127.wave + v127.phase), 0, 0) + v131 * v127.r

                    v127.a0.Position = v134
                    v127.a1.Position = v134 + v131 * 0.1 + Vector3.new(0.04, 0, 0)
                end

                if v114.disk then
                    bhDiskPose(v114.disk, v113, elapsed, fxDt)
                end

                if v114.prism then
                    prismRingPose(v114.prism, v113, elapsed)
                end
            end

            continue
        end

        t11[v113] = nil
    end
end)

local t14 = {}

local function bhPart(p55, p56, p57, p58, p59, p60) -- line: 443
    local Part = Instance.new("Part")

    Part.Name = p55
    Part.Shape = p56
    Part.Color = p57
    Part.Material = p58
    Part.Transparency = p59
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Size = Vector3.new(0.05, 0.05, 0.05)
    Part.Parent = p60

    return Part
end

local function bhSound(p61, p62, p63, p64, p65) -- line: 449
    local Sound = Instance.new("Sound")

    Sound.SoundId = p61
    Sound.Volume = p63
    Sound.PlaybackSpeed = p64
    Sound.Looped = p65 == true
    Sound.RollOffMode = Enum.RollOffMode.InverseTapered
    Sound.RollOffMinDistance = 20
    Sound.RollOffMaxDistance = 260
    Sound.Parent = p62

    return Sound
end

local function bhEmitter(p66, p67) -- line: 454
    local ParticleEmitter = Instance.new("ParticleEmitter")

    for v135, v136 in p67 do
        ParticleEmitter[v135] = v136
    end

    ParticleEmitter.Parent = p66

    return ParticleEmitter
end

local function backOut(p68) -- line: 460
    return 1 + 2.70158 * (p68 - 1) ^ 3 + 1.70158 * (p68 - 1) ^ 2
end

local function openHole(p69) -- line: 461
    -- upvalues: LocalPlayer (copy), t14 (copy)
    local v137, v138, v139

    if t14[p69] then
        v139 = true
    elseif p69:IsA("BasePart") then
        v137 = p69:GetAttribute("Radius") or 3
        v138 = LocalPlayer:GetAttribute("GfxEffects") ~= false
        v139 = false
    else
        v139 = true
    end

    if v139 then
        return
    end

    local Model = Instance.new("Model")

    Model.Name = "BlackholeFX"

    local t15 = {
        spin = 0,
        started = false,
        anchor = p69,
        model = Model,
        R = v137,
        start = p69:GetAttribute("Start") or workspace:GetServerTimeNow(),
        life = p69:GetAttribute("Life") or 6,
        streaks = {},
        disks = {}
    }
    local Ball = Enum.PartType.Ball
    local v140 = Color3.new(0, 0, 0)
    local Neon = Enum.Material.Neon
    local Part = Instance.new("Part")

    Part.Name = "Core"
    Part.Shape = Ball
    Part.Color = v140
    Part.Material = Neon
    Part.Transparency = 0
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Size = Vector3.new(0.05, 0.05, 0.05)
    Part.Parent = Model
    t15.core = Part
    t15.ring = Instance.new("Highlight")
    t15.ring.Name = "PhotonRing"
    t15.ring.Adornee = t15.core
    t15.ring.FillTransparency = 1
    t15.ring.OutlineColor = Color3.fromRGB(255, 214, 110)
    t15.ring.OutlineTransparency = 1
    t15.ring.DepthMode = Enum.HighlightDepthMode.Occluded
    t15.ring.Parent = Model

    for v141, v142 in {
            {
                "DiskInner",
                Color3.fromRGB(255, 242, 180),
                0.12, 2, 0.2
            },
            {
                "DiskMid",
                Color3.fromRGB(255, 190, 40),
                0.34, 2.9, 0.14
            },
            {
                "DiskOuter",
                Color3.fromRGB(255, 122, 15),
                0.6, 3.9, 0.09
            },
            {
                "DiskHalo",
                Color3.fromRGB(190, 70, 10),
                0.84, 5.2, 0.05
            }
        } do
        local disks = t15.disks
        local t16 = {}
        local v143 = v142[1]
        local Cylinder = Enum.PartType.Cylinder
        local v144 = v142[2]
        local Neon = Enum.Material.Neon
        local v145 = v142[3]
        local Part = Instance.new("Part")

        Part.Name = v143
        Part.Shape = Cylinder
        Part.Color = v144
        Part.Material = Neon
        Part.Transparency = v145
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.TopSurface = Enum.SurfaceType.Smooth
        Part.BottomSurface = Enum.SurfaceType.Smooth
        Part.Size = Vector3.new(0.05, 0.05, 0.05)
        Part.Parent = Model
        t16.p = Part
        t16.d = v142[4]
        t16.th = v142[5]
        t16.w = 1 + v141 * 0.12
        table.insert(disks, t16)
    end

    local Block = Enum.PartType.Block
    local v146 = Color3.new()
    local SmoothPlastic = Enum.Material.SmoothPlastic
    local Part2 = Instance.new("Part")

    Part2.Name = "Hub"
    Part2.Shape = Block
    Part2.Color = v146
    Part2.Material = SmoothPlastic
    Part2.Transparency = 1
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanTouch = false
    Part2.CanQuery = false
    Part2.CastShadow = false
    Part2.TopSurface = Enum.SurfaceType.Smooth
    Part2.BottomSurface = Enum.SurfaceType.Smooth
    Part2.Size = Vector3.new(0.05, 0.05, 0.05)
    Part2.Parent = Model
    t15.hub = Part2

    local v147 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 250, 220)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 196, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 110, 10))
    })

    for _ = 1, 12 do
        local Attachment = Instance.new("Attachment")

        Attachment.Parent = t15.hub

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Parent = t15.hub

        local Trail = Instance.new("Trail")

        Trail.Attachment0 = Attachment
        Trail.Attachment1 = Attachment2
        Trail.Color = v147
        Trail.LightEmission = 1
        Trail.LightInfluence = 0
        Trail.Brightness = 2
        Trail.Lifetime = 0.22
        Trail.MinLength = 0
        Trail.FaceCamera = true
        Trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.7, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
        Trail.WidthScale = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0.15)
        })
        Trail.Parent = t15.hub

        local v148 = 1.25 + math.random() * 1.25

        table.insert(t15.streaks, {
            a0 = Attachment,
            a1 = Attachment2,
            r = v148,
            th = math.random() * 3.141592653589793 * 2,
            w = 5.2 / v148 ^ 1.5,
            y = (math.random() - 0.5) * 0.12
        })
    end

    t15.light = Instance.new("PointLight")
    t15.light.Color = Color3.fromRGB(255, 170, 50)
    t15.light.Range = 30
    t15.light.Brightness = 0
    t15.light.Shadows = false
    t15.light.Parent = t15.core

    if v138 then
        local Ball = Enum.PartType.Ball
        local v149 = Color3.new()
        local SmoothPlastic = Enum.Material.SmoothPlastic
        local Part = Instance.new("Part")

        Part.Name = "Infall"
        Part.Shape = Ball
        Part.Color = v149
        Part.Material = SmoothPlastic
        Part.Transparency = 1
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.TopSurface = Enum.SurfaceType.Smooth
        Part.BottomSurface = Enum.SurfaceType.Smooth
        Part.Size = Vector3.new(0.05, 0.05, 0.05)
        Part.Parent = Model
        t15.infall = Part

        local infall = t15.infall
        local t18 = {
            Texture = "rbxasset://textures/particles/sparkles_main.dds",
            LightEmission = 1,
            LightInfluence = 0,
            Brightness = 2.5,
            Rate = 0,
            Shape = Enum.ParticleEmitterShape.Sphere,
            ShapeInOut = Enum.ParticleEmitterShapeInOut.Inward,
            ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
            Orientation = Enum.ParticleOrientation.VelocityParallel,
            Color = ColorSequence.new(Color3.fromRGB(255, 240, 160), Color3.fromRGB(255, 130, 20)),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.12),
                NumberSequenceKeypoint.new(0.7, 0.35),
                NumberSequenceKeypoint.new(1, 0.05)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.2, 0),
                NumberSequenceKeypoint.new(1, 0.2)
            }),
            Lifetime = NumberRange.new(0.6, 0.6),
            Speed = NumberRange.new(v137 * 4, v137 * 4),
            Squash = NumberSequence.new(-0.8)
        }
        local ParticleEmitter = Instance.new("ParticleEmitter")

        for v150, v151 in t18 do
            ParticleEmitter[v150] = v151
        end

        ParticleEmitter.Parent = infall
        t15.sparks = ParticleEmitter

        local infall2 = t15.infall
        local t19 = {
            Texture = "rbxasset://textures/particles/smoke_main.dds",
            LightEmission = 0,
            LightInfluence = 0,
            Brightness = 1,
            Rate = 0,
            Shape = Enum.ParticleEmitterShape.Sphere,
            ShapeInOut = Enum.ParticleEmitterShapeInOut.Inward,
            ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface,
            Color = ColorSequence.new(Color3.fromRGB(6, 5, 4), Color3.fromRGB(26, 18, 6)),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, v137 * 0.6),
                NumberSequenceKeypoint.new(1, v137 * 0.15)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.3, 0.45),
                NumberSequenceKeypoint.new(1, 0.7)
            }),
            Lifetime = NumberRange.new(1.1, 1.1),
            Speed = NumberRange.new(v137 * 2.2, v137 * 2.2),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-90, 90)
        }
        local ParticleEmitter2 = Instance.new("ParticleEmitter")

        for v152, v153 in t19 do
            ParticleEmitter2[v152] = v153
        end

        ParticleEmitter2.Parent = infall2
        t15.dust = ParticleEmitter2

        local core = t15.core
        local t20 = {
            Texture = "rbxasset://textures/particles/sparkles_main.dds",
            LightEmission = 1,
            LightInfluence = 0,
            Brightness = 3,
            Enabled = false,
            Drag = 2.5,
            Color = ColorSequence.new(Color3.fromRGB(255, 250, 220), Color3.fromRGB(255, 150, 20)),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.7),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Lifetime = NumberRange.new(0.6, 1.2),
            Speed = NumberRange.new(30, 70),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-400, 400)
        }
        local ParticleEmitter3 = Instance.new("ParticleEmitter")

        for v154, v155 in t20 do
            ParticleEmitter3[v154] = v155
        end

        ParticleEmitter3.Parent = core
        t15.burst = ParticleEmitter3
    end

    local core = t15.core
    local Sound = Instance.new("Sound")

    Sound.SoundId = "rbxasset://sounds/Rocket whoosh 01.wav"
    Sound.Volume = 0
    Sound.PlaybackSpeed = 0.32
    Sound.Looped = true
    Sound.RollOffMode = Enum.RollOffMode.InverseTapered
    Sound.RollOffMinDistance = 20
    Sound.RollOffMaxDistance = 260
    Sound.Parent = core
    t15.hum = Sound
    Model.Parent = workspace
    t14[p69] = t15
end

local function closeHole(p70) -- line: 513
    -- upvalues: t14 (copy)
    local v156 = t14[p70]

    t14[p70] = nil

    if v156 then
        v156.model:Destroy()
    end
end

CollectionService:GetInstanceAddedSignal("BottleBlackhole"):Connect(function(p71) -- line: 517
    -- upvalues: openHole (copy)
    task.defer(openHole, p71)
end)
CollectionService:GetInstanceRemovedSignal("BottleBlackhole"):Connect(closeHole)

for _, v157 in CollectionService:GetTagged("BottleBlackhole") do
    openHole(v157)
end

RunService.RenderStepped:Connect(function(p72) -- line: 520
    -- upvalues: t14 (copy)
    if next(t14) == nil then
        return
    end

    local ServerTimeNow = workspace:GetServerTimeNow()

    for v158, v159 in t14 do
        if v158.Parent then
            local v160 = ServerTimeNow - v159.start
            local R = v159.R
            local Position = v158.Position
            local n2 = 0

            if v160 < 0 then
            elseif v160 < 0.7 then
                local v161 = v160 / 0.7

                n2 = math.max(0, 1 + 2.70158 * (v161 - 1) ^ 3 + 1.70158 * (v161 - 1) ^ 2)
            elseif v160 < v159.life - 0.6 then
                n2 = math.sin(v160 * 6) * 0.035 + 1
            elseif v160 < v159.life then
                local v164 = (v160 - (v159.life - 0.6)) / 0.6

                n2 = (1 - v164) ^ 2 * (1 + math.sin(v164 * 30) * 0.25 * (1 - v164))
            end

            if v160 >= 0 and not v159.started then
                v159.started = true

                local core = v159.core
                local Sound = Instance.new("Sound")

                Sound.SoundId = "rbxasset://sounds/HalloweenThunder.wav"
                Sound.Volume = 1.6
                Sound.PlaybackSpeed = 0.5
                Sound.Looped = false
                Sound.RollOffMode = Enum.RollOffMode.InverseTapered
                Sound.RollOffMinDistance = 20
                Sound.RollOffMaxDistance = 260
                Sound.Parent = core
                Sound:Play()
                game:GetService("Debris"):AddItem(Sound, 8)
                v159.hum:Play()

                if v159.sparks then
                    v159.sparks.Rate = 110
                    v159.dust.Rate = 28
                end
            end

            if v159.life <= v160 and not v159.collapsed then
                v159.collapsed = true
                v159.collapseAt = ServerTimeNow
                v159.hum:Stop()

                if v159.sparks then
                    v159.sparks.Rate = 0
                    v159.dust.Rate = 0
                    v159.burst:Emit(170)
                end

                local core = v159.core
                local Sound = Instance.new("Sound")

                Sound.SoundId = "rbxasset://sounds/bass.wav"
                Sound.Volume = 2.2
                Sound.PlaybackSpeed = 0.55
                Sound.Looped = false
                Sound.RollOffMode = Enum.RollOffMode.InverseTapered
                Sound.RollOffMinDistance = 20
                Sound.RollOffMaxDistance = 260
                Sound.Parent = core
                Sound:Play()
                game:GetService("Debris"):AddItem(Sound, 4)

                local core2 = v159.core
                local Sound2 = Instance.new("Sound")

                Sound2.SoundId = "rbxasset://sounds/HalloweenThunder.wav"
                Sound2.Volume = 1.2
                Sound2.PlaybackSpeed = 0.85
                Sound2.Looped = false
                Sound2.RollOffMode = Enum.RollOffMode.InverseTapered
                Sound2.RollOffMinDistance = 20
                Sound2.RollOffMaxDistance = 260
                Sound2.Parent = core2
                Sound2:Play()
                game:GetService("Debris"):AddItem(Sound2, 6)

                local Cylinder = Enum.PartType.Cylinder
                local v167 = Color3.fromRGB(255, 200, 90)
                local Neon = Enum.Material.Neon
                local model = v159.model
                local Part = Instance.new("Part")

                Part.Name = "Shockwave"
                Part.Shape = Cylinder
                Part.Color = v167
                Part.Material = Neon
                Part.Transparency = 0.2
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanTouch = false
                Part.CanQuery = false
                Part.CastShadow = false
                Part.TopSurface = Enum.SurfaceType.Smooth
                Part.BottomSurface = Enum.SurfaceType.Smooth
                Part.Size = Vector3.new(0.05, 0.05, 0.05)
                Part.Parent = model
                v159.wave = Part
            end

            v159.spin += p72

            local v168 = (v158.CFrame.Rotation + Position) * CFrame.Angles(0.24434609527920614, 0, 0)
            local v169 = math.max(n2, 0)
            local v171 = math.max(0.05, 2 * R * v169)

            v159.core.Size = Vector3.new(v171, v171, v171)
            v159.core.CFrame = CFrame.new(Position)

            local ring = v159.ring

            if not (v169 > 0.05) or v159.collapsed then
                ring.OutlineTransparency = 1
            else
                ring.OutlineTransparency = math.sin(v160 * 9) ^ 2 * 0.2 + 0.1 or 1
            end

            for _, v173 in v159.disks do
                local v175 = math.max(0.05, v173.d * R * v169)

                v173.p.Size = Vector3.new(v173.th, v175, v175)
                v173.p.CFrame = v168 * CFrame.Angles(0, v159.spin * v173.w, 0) * CFrame.Angles(0, 0, 1.5707963267948966)
            end

            v159.hub.CFrame = v168

            for _, v176 in v159.streaks do
                v176.th += p72 * v176.w * 1.6

                local v177 = v176.r * R * v169
                local v181 = Vector3.new(math.cos(v176.th) * v177, v176.y * R, math.sin(v176.th) * v177)

                v176.a0.Position = v181
                v176.a1.Position = v181 + Vector3.new(0, 0.1 * R * math.max(v169, 0.01), 0)
            end

            if v159.infall then
                local v184 = math.max(0.05, 7 * R * math.min(v169, 1.1))

                v159.infall.Size = Vector3.new(v184, v184, v184)
                v159.infall.CFrame = CFrame.new(Position)
            end

            local light = v159.light

            if v159.collapsed then
                light.Brightness = 0
            else
                light.Brightness = math.min(v169, 1.2) * 2.6
            end

            v159.hum.Volume = math.min(v169, 1) * 1.1

            if v159.collapsed then
                local v186 = math.clamp((ServerTimeNow - v159.collapseAt) / 0.7, 0, 1)

                v159.light.Brightness = (1 - v186) ^ 2 * 10
                v159.light.Range = v186 * 30 + 30

                if v159.wave then
                    local v187 = R * (v186 * 11 + 1.5)

                    v159.wave.Size = Vector3.new(0.08, v187, v187)
                    v159.wave.Transparency = v186 * 0.8 + 0.2
                    v159.wave.CFrame = v168 * CFrame.Angles(0, 0, 1.5707963267948966)
                end

                if v186 >= 1 then
                    v159.model:Destroy()
                    t14[v158] = nil
                end
            end
        else
            local v188 = t14[v158]

            t14[v158] = nil

            if v188 then
                v188.model:Destroy()
            end
        end
    end
end)

local t21 = {}

local function spPart(p73, p74, p75, p76, p77, p78, p79, p80) -- line: 595
    local model = p73.model
    local Part = Instance.new("Part")

    Part.Name = p74
    Part.Shape = p75
    Part.Color = p76
    Part.Material = p77
    Part.Transparency = p78
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Size = Vector3.new(0.05, 0.05, 0.05)
    Part.Parent = model

    local t22 = {
        p = Part,
        cf = p79,
        size = p80,
        transp = p78
    }

    table.insert(p73.items, t22)

    return t22
end

local function cylY(p81, p82, p83, p84, p85, p86, p87, p88) -- line: 601
    local Cylinder = Enum.PartType.Cylinder

    p88 = p88 or 0

    local v190 = CFrame.new(0, p87, 0) * CFrame.Angles(0, 0, 1.5707963267948966)
    local v191 = Vector3.new(p86, p85, p85)
    local model = p81.model
    local Part = Instance.new("Part")

    Part.Name = p82
    Part.Shape = Cylinder
    Part.Color = p83
    Part.Material = p84
    Part.Transparency = p88
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Size = Vector3.new(0.05, 0.05, 0.05)
    Part.Parent = model

    local t23 = {
        p = Part,
        cf = v190,
        size = v191,
        transp = p88
    }

    table.insert(p81.items, t23)

    return t23
end

local function buildHeart(p89, p90) -- line: 604
    local v192 = 2.3 * p90
    local v193 = 0.55 * p90
    local v194 = (-v192 / 1.4142135623730951 + v192 / 2.8284271247461903 + v192 / 2) / 2
    local v195 = Color3.fromRGB(255, 60, 150)
    local v196 = Color3.fromRGB(255, 160, 210)

    for _, v197 in {
            { v195, 0, 1, v193 },
            {
                v196,
                0.55, 1.13,
                v193 * 0.55
            }
        } do
        local v198 = v197[1]
        local v199 = v197[2]
        local v200 = v197[3]
        local v201 = v197[4]
        local v202 = v192 * v200
        local Block = Enum.PartType.Block
        local Neon = Enum.Material.Neon
        local v203 = CFrame.new(0, -v194, 0) * CFrame.Angles(0, 0, 0.7853981633974483)
        local v204 = Vector3.new(v202, v202, v201)
        local model = p89.model
        local Part = Instance.new("Part")

        Part.Name = "HeartBody"
        Part.Shape = Block
        Part.Color = v198
        Part.Material = Neon
        Part.Transparency = v199
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.TopSurface = Enum.SurfaceType.Smooth
        Part.BottomSurface = Enum.SurfaceType.Smooth
        Part.Size = Vector3.new(0.05, 0.05, 0.05)
        Part.Parent = model

        local t24 = {
            p = Part,
            cf = v203,
            size = v204,
            transp = v199
        }

        table.insert(p89.items, t24)

        for _, v205 in { -1, 1 } do
            local Cylinder = Enum.PartType.Cylinder
            local Neon = Enum.Material.Neon
            local v206 = CFrame.new(v205 * v192 / 2.8284271247461903, v192 / 2.8284271247461903 - v194, 0) * CFrame.Angles(0, 1.5707963267948966, 0)
            local v207 = Vector3.new(v201, v202, v202)
            local model = p89.model
            local Part = Instance.new("Part")

            Part.Name = "HeartLobe"
            Part.Shape = Cylinder
            Part.Color = v198
            Part.Material = Neon
            Part.Transparency = v199
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanTouch = false
            Part.CanQuery = false
            Part.CastShadow = false
            Part.TopSurface = Enum.SurfaceType.Smooth
            Part.BottomSurface = Enum.SurfaceType.Smooth
            Part.Size = Vector3.new(0.05, 0.05, 0.05)
            Part.Parent = model

            local t25 = {
                p = Part,
                cf = v206,
                size = v207,
                transp = v199
            }

            table.insert(p89.items, t25)
        end
    end

    p89.color = v195
    p89.lightColor = Color3.fromRGB(255, 110, 180)

    local Block = Enum.PartType.Block
    local v208 = Color3.new()
    local SmoothPlastic = Enum.Material.SmoothPlastic
    local model = p89.model
    local Part = Instance.new("Part")

    Part.Name = "Hub"
    Part.Shape = Block
    Part.Color = v208
    Part.Material = SmoothPlastic
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Size = Vector3.new(0.05, 0.05, 0.05)
    Part.Parent = model
    p89.hub = Part
    p89.minis = {}

    for i = 1, 10 do
        local Attachment = Instance.new("Attachment")

        Attachment.Parent = p89.hub

        local BillboardGui = Instance.new("BillboardGui")

        BillboardGui.Size = UDim2.fromScale(0.9 * p90, 0.9 * p90)
        BillboardGui.LightInfluence = 0
        BillboardGui.Adornee = Attachment
        BillboardGui.Parent = p89.hub

        local TextLabel = Instance.new("TextLabel")

        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.fromScale(1, 1)
        TextLabel.TextScaled = true
        TextLabel.Text = utf8.char(10084)

        local v209 = i % 2 == 0
        local v210 = if v209 then Color3.fromRGB(255, 90, 170) else nil

        if not v209 or not v210 then
            TextLabel.TextColor3 = Color3.fromRGB(255, 190, 225)
        else
            TextLabel.TextColor3 = v210
        end

        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Parent = BillboardGui
        table.insert(p89.minis, {
            a = Attachment,
            l = TextLabel,
            x = (math.random() - 0.5) * v192 * 2.2,
            z = (math.random() - 0.5) * p90,
            phase = math.random(),
            speed = 0.35 + math.random() * 0.25
        })
    end

    p89.ding = "rbxasset://sounds/electronicpingshort.wav"
    p89.dingSpeed = 1.25
end

local function buildTrophy(p91, p92) -- line: 629
    -- upvalues: cylY (copy)
    local v211 = Color3.fromRGB(255, 198, 58)
    local v212 = Color3.fromRGB(170, 118, 20)
    local v213 = Color3.fromRGB(22, 22, 26)
    local Metal = Enum.Material.Metal
    local v214 = -1.7 * p92
    local Block = Enum.PartType.Block
    local SmoothPlastic = Enum.Material.SmoothPlastic
    local v215 = CFrame.new(0, v214 + 0.28 * p92, 0)
    local v219 = Vector3.new(1.6 * p92, 0.56 * p92, 1.6 * p92)
    local model = p91.model
    local Part = Instance.new("Part")

    Part.Name = "Plinth"
    Part.Shape = Block
    Part.Color = v213
    Part.Material = SmoothPlastic
    Part.Transparency = 0
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Size = Vector3.new(0.05, 0.05, 0.05)
    Part.Parent = model

    local t27 = {
        transp = 0,
        p = Part,
        cf = v215,
        size = v219
    }

    table.insert(p91.items, t27)

    local Block2 = Enum.PartType.Block
    local v220 = CFrame.new(0, v214 + 0.58 * p92, 0)
    local v224 = Vector3.new(1.68 * p92, 0.07 * p92, 1.68 * p92)
    local model2 = p91.model
    local Part2 = Instance.new("Part")

    Part2.Name = "PlinthTrim"
    Part2.Shape = Block2
    Part2.Color = v211
    Part2.Material = Metal
    Part2.Transparency = 0
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanTouch = false
    Part2.CanQuery = false
    Part2.CastShadow = false
    Part2.TopSurface = Enum.SurfaceType.Smooth
    Part2.BottomSurface = Enum.SurfaceType.Smooth
    Part2.Size = Vector3.new(0.05, 0.05, 0.05)
    Part2.Parent = model2

    local t28 = {
        transp = 0,
        p = Part2,
        cf = v220,
        size = v224
    }

    table.insert(p91.items, t28)
    cylY(p91, "Foot", v211, Metal, 1.15 * p92, 0.2 * p92, v214 + 0.71 * p92)
    cylY(p91, "Stem", v211, Metal, 0.28 * p92, 0.8 * p92, v214 + 1.2 * p92)

    local Ball = Enum.PartType.Ball
    local v225 = CFrame.new(0, v214 + 1.18 * p92, 0)
    local v229 = Vector3.new(0.5 * p92, 0.5 * p92, 0.5 * p92)
    local model3 = p91.model
    local Part3 = Instance.new("Part")

    Part3.Name = "Knob"
    Part3.Shape = Ball
    Part3.Color = v211
    Part3.Material = Metal
    Part3.Transparency = 0
    Part3.Anchored = true
    Part3.CanCollide = false
    Part3.CanTouch = false
    Part3.CanQuery = false
    Part3.CastShadow = false
    Part3.TopSurface = Enum.SurfaceType.Smooth
    Part3.BottomSurface = Enum.SurfaceType.Smooth
    Part3.Size = Vector3.new(0.05, 0.05, 0.05)
    Part3.Parent = model3

    local t29 = {
        transp = 0,
        p = Part3,
        cf = v225,
        size = v229
    }

    table.insert(p91.items, t29)

    local Ball2 = Enum.PartType.Ball
    local v230 = CFrame.new(0, v214 + 2.2 * p92, 0)
    local v234 = Vector3.new(1.7 * p92, 1.7 * p92, 1.7 * p92)
    local model4 = p91.model
    local Part4 = Instance.new("Part")

    Part4.Name = "Bowl"
    Part4.Shape = Ball2
    Part4.Color = v211
    Part4.Material = Metal
    Part4.Transparency = 0
    Part4.Anchored = true
    Part4.CanCollide = false
    Part4.CanTouch = false
    Part4.CanQuery = false
    Part4.CastShadow = false
    Part4.TopSurface = Enum.SurfaceType.Smooth
    Part4.BottomSurface = Enum.SurfaceType.Smooth
    Part4.Size = Vector3.new(0.05, 0.05, 0.05)
    Part4.Parent = model4

    local t30 = {
        transp = 0,
        p = Part4,
        cf = v230,
        size = v234
    }

    table.insert(p91.items, t30)
    cylY(p91, "Cup", v211, Metal, 1.7 * p92, 0.95 * p92, v214 + 2.68 * p92)
    cylY(p91, "Rim", v211, Metal, 1.88 * p92, 0.12 * p92, v214 + 3.16 * p92)
    cylY(p91, "Inside", v212, Enum.Material.SmoothPlastic, 1.52 * p92, 0.03 * p92, v214 + 3.23 * p92)

    for _, v235 in { -1, 1 } do
        local v238 = Vector3.new(v235 * 0.86 * p92, v214 + 2.62 * p92, 0)
        local v239 = 0.44 * p92

        for i = 0, 7 do
            local v241 = math.rad(i * 160 / 8 + -80)
            local v243 = math.rad((i + 1) * 160 / 8 + -80)
            local v244 = (v241 + v243) / 2
            local v247 = v238 + Vector3.new(v235 * math.cos(v244) * v239, math.sin(v244) * v239, 0)
            local Unit = Vector3.new(-v235 * math.sin(v244), math.cos(v244), 0).Unit
            local v252 = 2 * v239 * math.sin((v243 - v241) / 2) * 1.15
            local Cylinder = Enum.PartType.Cylinder
            local v253 = CFrame.fromMatrix(v247, Unit, (Vector3.new(0, 0, 1)))
            local v256 = Vector3.new(v252, 0.15 * p92, 0.15 * p92)
            local model = p91.model
            local Part = Instance.new("Part")

            Part.Name = "Handle"
            Part.Shape = Cylinder
            Part.Color = v211
            Part.Material = Metal
            Part.Transparency = 0
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanTouch = false
            Part.CanQuery = false
            Part.CastShadow = false
            Part.TopSurface = Enum.SurfaceType.Smooth
            Part.BottomSurface = Enum.SurfaceType.Smooth
            Part.Size = Vector3.new(0.05, 0.05, 0.05)
            Part.Parent = model

            local t31 = {
                transp = 0,
                p = Part,
                cf = v253,
                size = v256
            }

            table.insert(p91.items, t31)
        end
    end

    local Ball3 = Enum.PartType.Ball
    local v257 = Color3.fromRGB(255, 240, 170)
    local Neon = Enum.Material.Neon
    local v258 = CFrame.new(0, v214 + 4 * p92, 0)
    local v262 = Vector3.new(0.45 * p92, 0.45 * p92, 0.45 * p92)
    local model5 = p91.model
    local Part5 = Instance.new("Part")

    Part5.Name = "Star"
    Part5.Shape = Ball3
    Part5.Color = v257
    Part5.Material = Neon
    Part5.Transparency = 0
    Part5.Anchored = true
    Part5.CanCollide = false
    Part5.CanTouch = false
    Part5.CanQuery = false
    Part5.CastShadow = false
    Part5.TopSurface = Enum.SurfaceType.Smooth
    Part5.BottomSurface = Enum.SurfaceType.Smooth
    Part5.Size = Vector3.new(0.05, 0.05, 0.05)
    Part5.Parent = model5

    local t32 = {
        transp = 0,
        p = Part5,
        cf = v258,
        size = v262
    }

    table.insert(p91.items, t32)

    for _, v263 in p91.items do
        v263.p.Reflectance = v263.p.Material == Metal and 0.28 or 0
    end

    p91.color = v211
    p91.lightColor = Color3.fromRGB(255, 200, 90)
    p91.ding = "rbxasset://sounds/victory.wav"
    p91.dingSpeed = 1
end

local t33 = {
    Color3.fromRGB(255, 45, 60),
    Color3.fromRGB(255, 140, 30),
    Color3.fromRGB(255, 232, 40),
    Color3.fromRGB(60, 230, 90),
    Color3.fromRGB(40, 170, 255),
    Color3.fromRGB(80, 80, 255),
    Color3.fromRGB(190, 80, 255)
}

local function buildRainbow(p93, p94) -- line: 661
    -- upvalues: t33 (copy)
    local v264 = 7.5 * p94
    local v265 = 0.6 * p94
    local v266 = -v264 * 0.42

    p93.bands = {}

    for v267, v268 in t33 do
        local v269 = v264 - (v267 - 1) * v265
        local v270, v271 = v268:ToHSV()
        local t34 = {
            hue = v270,
            sat = v271,
            segs = {}
        }

        for i = 1, 30 do
            local v272 = (3.141592653589793 * (1 - (i - 1) / 30) + 3.141592653589793 * (1 - i / 30)) / 2
            local v273 = 2 * v269 * 0.05233595624294383 * 1.08
            local Block = Enum.PartType.Block
            local Neon = Enum.Material.Neon
            local v274 = CFrame.new(math.cos(v272) * v269, math.sin(v272) * v269 + v266, 0) * CFrame.Angles(0, 0, v272 + 1.5707963267948966)
            local v277 = Vector3.new(v273, v265 * 1.02, 0.3 * p94)
            local model = p93.model
            local Part = Instance.new("Part")

            Part.Name = "Band"
            Part.Shape = Block
            Part.Color = v268
            Part.Material = Neon
            Part.Transparency = 0.08
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanTouch = false
            Part.CanQuery = false
            Part.CastShadow = false
            Part.TopSurface = Enum.SurfaceType.Smooth
            Part.BottomSurface = Enum.SurfaceType.Smooth
            Part.Size = Vector3.new(0.05, 0.05, 0.05)
            Part.Parent = model

            local t35 = {
                transp = 0.08,
                p = Part,
                cf = v274,
                size = v277
            }

            table.insert(p93.items, t35)
            t35.k = i / 30
            table.insert(t34.segs, t35)
        end

        table.insert(p93.bands, t34)
    end

    for _, v278 in {
            v264 + v265 * 0.55,
            v264 - #t33 * v265 + v265 * 0.45
        } do
        for j = 1, 30 do
            local v279 = 3.141592653589793 * (1 - (j - 0.5) / 30)
            local v280 = 2 * v278 * 0.05233595624294383 * 1.08
            local Block = Enum.PartType.Block
            local v281 = Color3.fromRGB(255, 255, 255)
            local Neon = Enum.Material.Neon
            local v282 = CFrame.new(math.cos(v279) * v278, math.sin(v279) * v278 + v266, 0) * CFrame.Angles(0, 0, v279 + 1.5707963267948966)
            local v285 = Vector3.new(v280, v265 * 0.5, 0.18 * p94)
            local model = p93.model
            local Part = Instance.new("Part")

            Part.Name = "Glow"
            Part.Shape = Block
            Part.Color = v281
            Part.Material = Neon
            Part.Transparency = 0.72
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanTouch = false
            Part.CanQuery = false
            Part.CastShadow = false
            Part.TopSurface = Enum.SurfaceType.Smooth
            Part.BottomSurface = Enum.SurfaceType.Smooth
            Part.Size = Vector3.new(0.05, 0.05, 0.05)
            Part.Parent = model

            local t36 = {
                transp = 0.72,
                p = Part,
                cf = v282,
                size = v285
            }

            table.insert(p93.items, t36)
            t36.k = j / 30
        end
    end

    local v286 = v264 - (#t33 - 1) * v265 / 2

    p93.clouds = {}

    for _, v287 in { -1, 1 } do
        for _, v288 in {
                { 0, 0, 0, 2.1 },
                { 0.75, 0.35, 0.2, 1.6 },
                { -0.75, 0.25, -0.15, 1.5 },
                { 0.35, -0.35, 0.35, 1.4 },
                { -0.4, -0.3, -0.3, 1.3 },
                { 0, 0.6, 0, 1.3 }
            } do
            local v289 = v288[4] * p94
            local Ball = Enum.PartType.Ball
            local v290 = Color3.fromRGB(255, 255, 255)
            local Neon = Enum.Material.Neon
            local v291 = CFrame.new(v287 * v286 + v288[1] * p94, v266 + v288[2] * p94, v288[3] * p94)
            local v292 = Vector3.new(v289, v289, v289)
            local model = p93.model
            local Part = Instance.new("Part")

            Part.Name = "Cloud"
            Part.Shape = Ball
            Part.Color = v290
            Part.Material = Neon
            Part.Transparency = 0.05
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanTouch = false
            Part.CanQuery = false
            Part.CastShadow = false
            Part.TopSurface = Enum.SurfaceType.Smooth
            Part.BottomSurface = Enum.SurfaceType.Smooth
            Part.Size = Vector3.new(0.05, 0.05, 0.05)
            Part.Parent = model

            local t37 = {
                transp = 0.05,
                p = Part,
                cf = v291,
                size = v292
            }

            table.insert(p93.items, t37)
            t37.cloud = true
        end
    end

    p93.feet = {
        Vector3.new(-v286, v266, 0),
        (Vector3.new(v286, v266, 0))
    }
    p93.top = Vector3.new(0, v264 + v266, 0)
    p93.color = Color3.fromRGB(255, 255, 255)
    p93.lightColor = Color3.fromRGB(255, 255, 255)
    p93.ding = "rbxasset://sounds/electronicpingshort.wav"
    p93.dingSpeed = 0.8
end

local function openShow(p95) -- line: 702
    -- upvalues: LocalPlayer (copy), t21 (copy), buildHeart (copy), buildTrophy (copy), t33 (copy), buildRainbow (copy)
    local Kind, v295, v296, v297

    if t21[p95] then
        v297 = true
    elseif p95:IsA("BasePart") then
        Kind = p95:GetAttribute("Kind")
        v295 = p95:GetAttribute("Scale") or 1
        v296 = LocalPlayer:GetAttribute("GfxEffects") ~= false
        v297 = false
    else
        v297 = true
    end

    if v297 then
        return
    end

    local Model = Instance.new("Model")

    Model.Name = "BottleShowpiece_" .. tostring(Kind)

    local t38 = {
        yaw = nil,
        started = false,
        anchor = p95,
        kind = Kind,
        model = Model,
        items = {},
        start = p95:GetAttribute("Start") or workspace:GetServerTimeNow(),
        life = p95:GetAttribute("Life") or 6,
        u = v295
    }

    if Kind == "Pink" then
        buildHeart(t38, v295)
    elseif Kind == "Golden" then
        buildTrophy(t38, v295)
    else
        if Kind ~= "Rainbow" then
            return
        end

        buildRainbow(t38, v295)
    end

    local Highlight = Instance.new("Highlight")

    Highlight.FillTransparency = 1
    Highlight.OutlineColor = t38.lightColor
    Highlight.OutlineTransparency = 1
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Adornee = Model
    Highlight.Parent = Model
    t38.hl = Highlight

    local Ball = Enum.PartType.Ball
    local v298 = Color3.new()
    local SmoothPlastic = Enum.Material.SmoothPlastic
    local Part = Instance.new("Part")

    Part.Name = "Core"
    Part.Shape = Ball
    Part.Color = v298
    Part.Material = SmoothPlastic
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.TopSurface = Enum.SurfaceType.Smooth
    Part.BottomSurface = Enum.SurfaceType.Smooth
    Part.Size = Vector3.new(0.05, 0.05, 0.05)
    Part.Parent = Model
    t38.core = Part
    t38.light = Instance.new("PointLight")
    t38.light.Color = t38.lightColor
    t38.light.Range = Kind == "Rainbow" and 40 or 24
    t38.light.Brightness = 0
    t38.light.Shadows = false
    t38.light.Parent = t38.core

    if v296 then
        local v299 = if Kind == "Rainbow" then 7 else 2.6
        local Block = Enum.PartType.Block
        local v300 = Color3.new()
        local SmoothPlastic = Enum.Material.SmoothPlastic
        local Part = Instance.new("Part")

        Part.Name = "Emit"
        Part.Shape = Block
        Part.Color = v300
        Part.Material = SmoothPlastic
        Part.Transparency = 1
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanTouch = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.TopSurface = Enum.SurfaceType.Smooth
        Part.BottomSurface = Enum.SurfaceType.Smooth
        Part.Size = Vector3.new(0.05, 0.05, 0.05)
        Part.Parent = Model
        t38.emit = Part

        local v301 = Kind == "Rainbow" and ColorSequence.new({
            ColorSequenceKeypoint.new(0, t33[1]),
            ColorSequenceKeypoint.new(0.25, t33[3]),
            ColorSequenceKeypoint.new(0.5, t33[4]),
            ColorSequenceKeypoint.new(0.75, t33[5]),
            ColorSequenceKeypoint.new(1, t33[7])
        }) or ColorSequence.new(Color3.new(1, 1, 1), t38.lightColor)
        local emit = t38.emit
        local t39 = {
            Texture = "rbxasset://textures/particles/sparkles_main.dds",
            LightEmission = 1,
            LightInfluence = 0,
            Brightness = 2.5,
            Rate = 0,
            Shape = Enum.ParticleEmitterShape.Box,
            ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume,
            Color = v301,
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.3, 0.45 * v295),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Lifetime = NumberRange.new(0.8, 1.6),
            Speed = NumberRange.new(0.5, 2),
            Acceleration = Vector3.new(0, Kind == "Rainbow" and -9 or 2, 0),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-180, 180)
        }
        local ParticleEmitter = Instance.new("ParticleEmitter")

        for v303, v304 in t39 do
            ParticleEmitter[v303] = v304
        end

        ParticleEmitter.Parent = emit
        t38.sparkle = ParticleEmitter

        local core = t38.core
        local t40 = {
            Texture = "rbxasset://textures/particles/sparkles_main.dds",
            LightEmission = 1,
            LightInfluence = 0,
            Brightness = 3,
            Enabled = false,
            Drag = 2.5,
            Color = v301,
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.7 * v295),
                NumberSequenceKeypoint.new(1, 0)
            }),
            Lifetime = NumberRange.new(0.7, 1.4),
            Speed = NumberRange.new(20 * v295, 45 * v295),
            SpreadAngle = Vector2.new(180, 180),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-400, 400)
        }
        local ParticleEmitter2 = Instance.new("ParticleEmitter")

        for v305, v306 in t40 do
            ParticleEmitter2[v305] = v306
        end

        ParticleEmitter2.Parent = core
        t38.burst = ParticleEmitter2
        t38.sizeK = v299

        if Kind == "Rainbow" then
            t38.fountains = {}

            for _, v307 in t38.feet do
                local Block = Enum.PartType.Block
                local v308 = Color3.new()
                local SmoothPlastic = Enum.Material.SmoothPlastic
                local Part = Instance.new("Part")

                Part.Name = "Fountain"
                Part.Shape = Block
                Part.Color = v308
                Part.Material = SmoothPlastic
                Part.Transparency = 1
                Part.Anchored = true
                Part.CanCollide = false
                Part.CanTouch = false
                Part.CanQuery = false
                Part.CastShadow = false
                Part.TopSurface = Enum.SurfaceType.Smooth
                Part.BottomSurface = Enum.SurfaceType.Smooth
                Part.Size = Vector3.new(0.05, 0.05, 0.05)
                Part.Parent = Model

                local t41 = {
                    Texture = "rbxasset://textures/particles/sparkles_main.dds",
                    LightEmission = 1,
                    LightInfluence = 0,
                    Brightness = 2.5,
                    Rate = 0,
                    Color = v301,
                    Size = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0.5 * v295),
                        NumberSequenceKeypoint.new(1, 0)
                    }),
                    Lifetime = NumberRange.new(1, 1.6),
                    Speed = NumberRange.new(12 * v295, 18 * v295),
                    SpreadAngle = Vector2.new(22, 22),
                    Acceleration = Vector3.new(0, -14 * v295, 0),
                    Rotation = NumberRange.new(0, 360),
                    RotSpeed = NumberRange.new(-300, 300),
                    EmissionDirection = Enum.NormalId.Top
                }
                local ParticleEmitter = Instance.new("ParticleEmitter")

                for v310, v311 in t41 do
                    ParticleEmitter[v310] = v311
                end

                ParticleEmitter.Parent = Part

                local PointLight = Instance.new("PointLight")

                PointLight.Range = 18
                PointLight.Brightness = 0
                PointLight.Shadows = false
                PointLight.Parent = Part
                table.insert(t38.fountains, {
                    p = Part,
                    em = ParticleEmitter,
                    light = PointLight,
                    at = v307
                })
            end
        end
    end

    for _, v312 in t38.items do
        v312.p.Size = Vector3.new(0.05, 0.05, 0.05)
    end

    Model.Parent = workspace
    t21[p95] = t38
end

local function closeShow(p96) -- line: 752
    -- upvalues: t21 (copy)
    local v313 = t21[p96]

    t21[p96] = nil

    if v313 then
        v313.model:Destroy()
    end
end

CollectionService:GetInstanceAddedSignal("BottleShowpiece"):Connect(function(p97) -- line: 756
    -- upvalues: openShow (copy)
    task.defer(openShow, p97)
end)
CollectionService:GetInstanceRemovedSignal("BottleShowpiece"):Connect(function(p98) -- line: 757
    -- upvalues: t21 (copy)
    if not t21[p98] or t21[p98].closing then
        return
    end

    local v314 = t21[p98]

    t21[p98] = nil

    if v314 then
        v314.model:Destroy()
    end
end)

for _, v315 in CollectionService:GetTagged("BottleShowpiece") do
    openShow(v315)
end

local function heartBeat(p99) -- line: 759
    local v316 = p99 % 0.9 / 0.9

    return math.exp(-((v316 - 0.08) / 0.05) ^ 2) * 0.13 + 1 + math.exp(-((v316 - 0.3) / 0.05) ^ 2) * 0.08
end

RunService.RenderStepped:Connect(function(p100) -- line: 763
    -- upvalues: t21 (copy)
    if next(t21) == nil then
        return
    end

    local ServerTimeNow = workspace:GetServerTimeNow()
    local CurrentCamera = workspace.CurrentCamera

    for v320, v321 in t21 do
        if not v320.Parent and not v321.closing then
            v321.closing = true
        end

        local v322 = ServerTimeNow - v321.start
        local u = v321.u
        local v323, v324, v325

        if v322 < 0 then
            v324 = 0
        elseif v322 < 0.65 then
            v325 = v322 / 0.65
            v323 = 1 + 2.70158 * (v325 - 1) ^ 3 + 1.70158 * (v325 - 1) ^ 2
            v324 = math.max(0, v323)
        else
            v324 = if v322 < v321.life - 0.55 then 1 elseif v322 < v321.life then (1 - (v322 - (v321.life - 0.55)) / 0.55) ^ 2 else 0
        end

        local v326, hl

        if v322 >= 0 and not v321.started then
            v321.started = true
            v326 = v321.ding
            v323 = v321.core
            v325 = v321.dingSpeed
            hl = Instance.new("Sound")
            hl.SoundId = v326
            hl.Volume = 1.4
            hl.PlaybackSpeed = v325
            hl.Looped = false
            hl.RollOffMode = Enum.RollOffMode.InverseTapered
            hl.RollOffMinDistance = 20
            hl.RollOffMaxDistance = 260
            hl.Parent = v323
            hl:Play()
            game:GetService("Debris"):AddItem(hl, 4)

            if v321.burst then
                v321.burst:Emit(v321.kind == "Rainbow" and 220 or 120)
            end

            if v321.sparkle then
                v321.sparkle.Rate = v321.kind == "Rainbow" and 90 or 45
            end

            if v321.fountains then
                for _, v327 in v321.fountains do
                    v327.em.Rate = 60
                end
            end
        end

        if v321.life <= v322 and not v321.ended then
            v321.ended = true
            v321.endAt = ServerTimeNow

            if v321.sparkle then
                v321.sparkle.Rate = 0
            end

            if v321.fountains then
                for _, v328 in v321.fountains do
                    v328.em.Rate = 0
                end
            end

            if v321.burst then
                v321.burst:Emit(v321.kind == "Rainbow" and 260 or 140)
            end

            v326 = v321.core
            v323 = if v321.kind == "Golden" then 0.7 else 1.5
            v325 = Instance.new("Sound")
            v325.SoundId = "rbxasset://sounds/electronicpingshort.wav"
            v325.Volume = 1
            v325.PlaybackSpeed = v323
            v325.Looped = false
            v325.RollOffMode = Enum.RollOffMode.InverseTapered
            v325.RollOffMinDistance = 20
            v325.RollOffMaxDistance = 260
            v325.Parent = v326
            v325:Play()
            game:GetService("Debris"):AddItem(v325, 3)
        end

        if v321.ended and ServerTimeNow - v321.endAt > 1.6 then
            local Position = t21[v320]

            t21[v320] = nil

            if Position then
                Position.model:Destroy()
            end
        else
            local Position = v320.Parent

            if Position then
                Position = v320.Parent and v320.Position or v321.lastCenter or Vector3.new(0, 0, 0)
                v321.lastCenter = Position
                v323 = v321.kind

                local core, v329, p

                if v323 == "Golden" then
                    v323 = CFrame.new
                    v329 = (1 - math.min(v324, 1)) * -1.2 * u
                    v326 = v323(Position + Vector3.new(0, v329, 0)) * CFrame.Angles(0, v322 * 1.1, 0)
                else
                    v323 = CurrentCamera.CFrame.Position - Position
                    hl = v323.X
                    v329 = v323.Z
                    v325 = Vector3.new(hl, 0, v329)
                    hl = v325.Magnitude

                    if hl > 0.1 then
                        hl = -v325.X
                        core = -v325.Z
                        v325 = math.atan2(hl, core) or 0
                    else
                        v325 = 0
                    end

                    if not v321.yaw then
                        v321.yaw = v325
                    end

                    v323 = (v325 - v321.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                    hl = v321.yaw
                    v321.yaw = hl + v323 * (1 - math.exp(-p100 * 3))
                    v326 = CFrame.new(Position) * CFrame.Angles(0, v321.yaw + 3.141592653589793, 0)
                    hl = v321.kind

                    if hl == "Pink" then
                        core = CFrame.new
                        p = v322 * 1.6
                        hl = core(0, math.sin(p) * 0.35 * u, 0) * v326
                        core = CFrame.Angles
                        p = v322 * 1.25
                        v326 = hl * core(0, 0, math.sin(p) * 0.10471975511965978)
                    end
                end

                v323 = math.max(v324, 0)
                v325 = v321.kind

                local v331, Sound

                if v325 == "Pink" then
                    v325 = v322 % 0.9 / 0.9
                    Sound = -((v325 - 0.08) / 0.05) ^ 2
                    hl = math.exp(Sound) * 0.13 + 1
                    Sound = -((v325 - 0.3) / 0.05) ^ 2
                    v331 = hl + math.exp(Sound) * 0.08 or 1
                else
                    v331 = 1
                end

                v324 = v323 * v331
                v325 = v321.kind

                local v332

                if v325 == "Rainbow" then
                    hl = v322 / 1.3
                    v325 = math.clamp(hl, 0, 1)
                    core = v321.life

                    if core - 0.55 - 0.6 < v322 then
                        Sound = (v322 - (v321.life - 0.55 - 0.6)) / 1.15
                        core = 1 - math.clamp(Sound, 0, 1)
                        v325 = math.min(v325, core)
                    end

                    hl = v325 * 7 + 1E-06
                    v332 = math.floor(hl)
                    v321.notes = v321.notes or 0

                    while v321.notes < v332 and v321.notes < 7 do
                        v321.notes += 1
                        core = v321.core
                        v329 = 0.8 + v321.notes * 0.12
                        Sound = Instance.new("Sound")
                        Sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
                        Sound.Volume = 0.7
                        Sound.PlaybackSpeed = v329
                        Sound.Looped = false
                        Sound.RollOffMode = Enum.RollOffMode.InverseTapered
                        Sound.RollOffMinDistance = 20
                        Sound.RollOffMaxDistance = 260
                        Sound.Parent = core
                        Sound:Play()
                        game:GetService("Debris"):AddItem(Sound, 2)
                    end

                    for v333, v334 in v321.bands do
                        for _, v335 in v334.segs do
                            v332 = (v334.hue + math.sin(v322 * 2.4 - v335.k * 9 + v333 * 0.3) * 0.035) % 1
                            v335.p.Color = Color3.fromHSV(v332, v334.sat, 1)
                        end
                    end
                else
                    v325 = 1
                end

                v332 = math.max(v324, 0.002)

                local new, a

                for _, v337 in v321.items do
                    a = if v337.k and (v325 < v337.k or v321.ended) then 0.002 else v332

                    if v337.cloud and v321.kind == "Rainbow" then
                        new = v322 * 2 + v337.cf.Position.X
                        a = v332 * (math.sin(new) * 0.04 + 1)
                    end

                    v337.p.Size = v337.size * a
                    v337.p.CFrame = v326 * CFrame.new(v337.cf.Position * v324) * v337.cf.Rotation
                end

                v321.core.CFrame = v326
                hl = v321.hl

                if not (v323 > 0.05) or v321.ended then
                    hl.OutlineTransparency = 1
                else
                    a = v322 * 5
                    hl.OutlineTransparency = math.sin(a) ^ 2 * 0.25 + 0.25 or 1
                end

                if v321.kind == "Rainbow" then
                    v321.hl.OutlineColor = Color3.fromHSV(v322 * 0.2 % 1, 0.5, 1)
                end

                v325 = if v321.kind == "Rainbow" then 4 else 3
                hl = v321.light

                if v321.ended then
                    hl.Brightness = 0
                else
                    hl.Brightness = v325 * math.min(v323, 1.2)
                end

                if v321.kind == "Rainbow" then
                    v321.light.Color = Color3.fromHSV(v322 * 0.25 % 1, 0.45, 1)
                end

                hl = v321.ended

                if hl then
                    hl = (ServerTimeNow - v321.endAt) / 0.6
                    v325 = math.clamp(hl, 0, 1)
                    v321.light.Brightness = (1 - v325) ^ 2 * 8
                end

                if v321.emit then
                    local v338

                    if v321.kind == "Rainbow" then
                        core = 15 * u
                        v329 = 7 * u
                        Sound = 1.5 * u
                        v338 = Vector3.new(core, v329, Sound)

                        if not v338 then
                            core = v321.sizeK * u
                            v329 = v321.sizeK * u
                            Sound = 1.2 * u
                            v338 = Vector3.new(core, v329, Sound)
                        end
                    else
                        core = v321.sizeK * u
                        v329 = v321.sizeK * u
                        Sound = 1.2 * u
                        v338 = Vector3.new(core, v329, Sound)
                    end

                    v321.emit.Size = v338 * math.max(v323, 0.05)
                    v321.emit.CFrame = v321.kind == "Rainbow" and v326 * CFrame.new(0, v321.top.Y * 0.5, 0) or v326
                end

                if v321.fountains then
                    for _, v339 in v321.fountains do
                        v339.p.CFrame = v326 * CFrame.new(v339.at * v324)
                        v339.light.Color = Color3.fromHSV((v322 * 0.3 + v339.at.X * 0.01) % 1, 0.5, 1)
                        a = v339.light

                        if v321.ended then
                            a.Brightness = 0
                        else
                            a.Brightness = math.min(v323, 1) * 2.5
                        end
                    end
                end

                if v321.minis then
                    v321.hub.CFrame = v326

                    for _, v340 in v321.minis do
                        v324 = (v322 * v340.speed + v340.phase) % 1
                        a = v340.a

                        local v342 = v340.x + math.sin(v322 * 2 + v340.phase * 6) * 0.3 * u
                        local x = (-1 + v324 * 3.2) * u

                        new = v340.z
                        a.Position = Vector3.new(v342, x, new)
                        p = v324 * 3.141592653589793
                        a = math.sin(p)
                        v340.l.TextTransparency = 1 - a * math.min(v323, 1)
                    end
                end
            else
                Position = v321.lastCenter

                if Position then
                    Position = v320.Parent and v320.Position or v321.lastCenter or Vector3.new(0, 0, 0)
                    v321.lastCenter = Position
                    v323 = v321.kind

                    local core, v343, p

                    if v323 == "Golden" then
                        v323 = CFrame.new
                        v343 = (1 - math.min(v324, 1)) * -1.2 * u
                        v326 = v323(Position + Vector3.new(0, v343, 0)) * CFrame.Angles(0, v322 * 1.1, 0)
                    else
                        v323 = CurrentCamera.CFrame.Position - Position
                        hl = v323.X
                        v343 = v323.Z
                        v325 = Vector3.new(hl, 0, v343)
                        hl = v325.Magnitude

                        if hl > 0.1 then
                            hl = -v325.X
                            core = -v325.Z
                            v325 = math.atan2(hl, core) or 0
                        else
                            v325 = 0
                        end

                        if not v321.yaw then
                            v321.yaw = v325
                        end

                        v323 = (v325 - v321.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
                        hl = v321.yaw
                        v321.yaw = hl + v323 * (1 - math.exp(-p100 * 3))
                        v326 = CFrame.new(Position) * CFrame.Angles(0, v321.yaw + 3.141592653589793, 0)
                        hl = v321.kind

                        if hl == "Pink" then
                            core = CFrame.new
                            p = v322 * 1.6
                            hl = core(0, math.sin(p) * 0.35 * u, 0) * v326
                            core = CFrame.Angles
                            p = v322 * 1.25
                            v326 = hl * core(0, 0, math.sin(p) * 0.10471975511965978)
                        end
                    end

                    v323 = math.max(v324, 0)
                    v325 = v321.kind

                    local v345, Sound

                    if v325 == "Pink" then
                        v325 = v322 % 0.9 / 0.9
                        Sound = -((v325 - 0.08) / 0.05) ^ 2
                        hl = math.exp(Sound) * 0.13 + 1
                        Sound = -((v325 - 0.3) / 0.05) ^ 2
                        v345 = hl + math.exp(Sound) * 0.08 or 1
                    else
                        v345 = 1
                    end

                    v324 = v323 * v345
                    v325 = v321.kind

                    local v346

                    if v325 == "Rainbow" then
                        hl = v322 / 1.3
                        v325 = math.clamp(hl, 0, 1)
                        core = v321.life

                        if core - 0.55 - 0.6 < v322 then
                            Sound = (v322 - (v321.life - 0.55 - 0.6)) / 1.15
                            core = 1 - math.clamp(Sound, 0, 1)
                            v325 = math.min(v325, core)
                        end

                        hl = v325 * 7 + 1E-06
                        v346 = math.floor(hl)
                        v321.notes = v321.notes or 0

                        while v321.notes < v346 and v321.notes < 7 do
                            v321.notes += 1
                            core = v321.core
                            v343 = 0.8 + v321.notes * 0.12
                            Sound = Instance.new("Sound")
                            Sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
                            Sound.Volume = 0.7
                            Sound.PlaybackSpeed = v343
                            Sound.Looped = false
                            Sound.RollOffMode = Enum.RollOffMode.InverseTapered
                            Sound.RollOffMinDistance = 20
                            Sound.RollOffMaxDistance = 260
                            Sound.Parent = core
                            Sound:Play()
                            game:GetService("Debris"):AddItem(Sound, 2)
                        end

                        for v347, v348 in v321.bands do
                            for _, v349 in v348.segs do
                                v346 = (v348.hue + math.sin(v322 * 2.4 - v349.k * 9 + v347 * 0.3) * 0.035) % 1
                                v349.p.Color = Color3.fromHSV(v346, v348.sat, 1)
                            end
                        end
                    else
                        v325 = 1
                    end

                    v346 = math.max(v324, 0.002)

                    local new, a

                    for _, v351 in v321.items do
                        a = if v351.k and (v325 < v351.k or v321.ended) then 0.002 else v346

                        if v351.cloud and v321.kind == "Rainbow" then
                            new = v322 * 2 + v351.cf.Position.X
                            a = v346 * (math.sin(new) * 0.04 + 1)
                        end

                        v351.p.Size = v351.size * a
                        v351.p.CFrame = v326 * CFrame.new(v351.cf.Position * v324) * v351.cf.Rotation
                    end

                    v321.core.CFrame = v326
                    hl = v321.hl

                    if not (v323 > 0.05) or v321.ended then
                        hl.OutlineTransparency = 1
                    else
                        a = v322 * 5
                        hl.OutlineTransparency = math.sin(a) ^ 2 * 0.25 + 0.25 or 1
                    end

                    if v321.kind == "Rainbow" then
                        v321.hl.OutlineColor = Color3.fromHSV(v322 * 0.2 % 1, 0.5, 1)
                    end

                    v325 = if v321.kind == "Rainbow" then 4 else 3
                    hl = v321.light

                    if v321.ended then
                        hl.Brightness = 0
                    else
                        hl.Brightness = v325 * math.min(v323, 1.2)
                    end

                    if v321.kind == "Rainbow" then
                        v321.light.Color = Color3.fromHSV(v322 * 0.25 % 1, 0.45, 1)
                    end

                    hl = v321.ended

                    if hl then
                        hl = (ServerTimeNow - v321.endAt) / 0.6
                        v325 = math.clamp(hl, 0, 1)
                        v321.light.Brightness = (1 - v325) ^ 2 * 8
                    end

                    if v321.emit then
                        local v352

                        if v321.kind == "Rainbow" then
                            core = 15 * u
                            v343 = 7 * u
                            Sound = 1.5 * u
                            v352 = Vector3.new(core, v343, Sound)

                            if not v352 then
                                core = v321.sizeK * u
                                v343 = v321.sizeK * u
                                Sound = 1.2 * u
                                v352 = Vector3.new(core, v343, Sound)
                            end
                        else
                            core = v321.sizeK * u
                            v343 = v321.sizeK * u
                            Sound = 1.2 * u
                            v352 = Vector3.new(core, v343, Sound)
                        end

                        v321.emit.Size = v352 * math.max(v323, 0.05)
                        v321.emit.CFrame = v321.kind == "Rainbow" and v326 * CFrame.new(0, v321.top.Y * 0.5, 0) or v326
                    end

                    if v321.fountains then
                        for _, v353 in v321.fountains do
                            v353.p.CFrame = v326 * CFrame.new(v353.at * v324)
                            v353.light.Color = Color3.fromHSV((v322 * 0.3 + v353.at.X * 0.01) % 1, 0.5, 1)
                            a = v353.light

                            if v321.ended then
                                a.Brightness = 0
                            else
                                a.Brightness = math.min(v323, 1) * 2.5
                            end
                        end
                    end

                    if v321.minis then
                        v321.hub.CFrame = v326

                        for _, v354 in v321.minis do
                            v324 = (v322 * v354.speed + v354.phase) % 1
                            a = v354.a

                            local v356 = v354.x + math.sin(v322 * 2 + v354.phase * 6) * 0.3 * u
                            local x = (-1 + v324 * 3.2) * u

                            new = v354.z
                            a.Position = Vector3.new(v356, x, new)
                            p = v324 * 3.141592653589793
                            a = math.sin(p)
                            v354.l.TextTransparency = 1 - a * math.min(v323, 1)
                        end
                    end
                else
                    Position = t21[v320]
                    t21[v320] = nil

                    if Position then
                        Position.model:Destroy()
                    end
                end
            end
        end
    end
end)

local function setHeld(p101) -- line: 872
    -- upvalues: v1 (ref), t1 (copy)
    v1 = p101
    table.clear(t1)
end

local function watchCharacter(p102) -- line: 876
    -- upvalues: v1 (ref), t1 (copy)
    v1 = nil
    table.clear(t1)
    p102.ChildAdded:Connect(function(p103) -- line: 878
        -- upvalues: v1 (ref), t1 (copy)
        if p103:IsA("Tool") and p103.Name == "PodiumBottle" then
            v1 = p103
            table.clear(t1)
        end
    end)
    p102.ChildRemoved:Connect(function(p104) -- line: 879
        -- upvalues: v1 (ref), t1 (copy)
        if p104 == v1 then
            v1 = nil
            table.clear(t1)
        end
    end)

    local PodiumBottle = p102:FindFirstChild("PodiumBottle")

    if PodiumBottle and PodiumBottle:IsA("Tool") then
        v1 = PodiumBottle
        table.clear(t1)
    end
end

LocalPlayer.CharacterAdded:Connect(watchCharacter)

if LocalPlayer.Character then
    watchCharacter(LocalPlayer.Character)
end
