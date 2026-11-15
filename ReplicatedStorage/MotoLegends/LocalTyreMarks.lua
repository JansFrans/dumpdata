-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Parent = script.Parent
local Config = require(Parent:WaitForChild("Config"))
local BikeDynamics = require(Parent:WaitForChild("BikeDynamics"))
local OwnerFeatures14 = require(Parent:WaitForChild("OwnerFeatures14"))
local LocalPlayer = Players.LocalPlayer
local t1 = {
    Max = 900,
    Cull = 350,
    Interval = 0.05
}
local Folder
local t2 = {}
local v1 = RaycastParams.new()

v1.FilterType = Enum.RaycastFilterType.Include

local v2

local function cast(p1) -- line: 29
    -- upvalues: v1 (copy), v2 (ref)
    if not (v2 and v2.Parent) then
        v2 = workspace:FindFirstChild("RaceCollision", true)

        local v3 = v2
        local v4

        if v3 then
            local v5 = v2

            v4 = {
                v5,
                workspace.Terrain
            } or {
                workspace.Terrain
            }
        else
            v4 = {
                workspace.Terrain
            }
        end

        v1.FilterDescendantsInstances = v4
    end

    local v6 = workspace:Raycast(p1 + Vector3.new(0, 3, 0), Vector3.new(0, -12, 0), v1)
    local v7 = if not v6 or not (v6.Normal.Y > 0.55) or v6.Instance:GetAttribute("Surface") == "Barrier" then nil else v6

    return v7
end

local function getFolder() -- line: 37
    -- upvalues: Folder (ref)
    if Folder and Folder.Parent then
        return Folder
    end

    Folder = Instance.new("Folder")
    Folder.Name = "LocalTyreMarks"

    local Folder2 = Folder

    Folder2.Parent = workspace

    return Folder
end

local function add(p2) -- line: 41
    -- upvalues: TweenService (copy), Config (copy), t1 (copy), Folder (ref), t2 (copy)
    if not (Folder and Folder.Parent) then
        Folder = Instance.new("Folder")
        Folder.Name = "LocalTyreMarks"

        local Folder2 = Folder

        Folder2.Parent = workspace
    end

    p2.Parent = Folder
    table.insert(t2, p2)

    if #t2 > t1.Max then
        local v9 = table.remove(t2, 1)

        if v9 then
            v9:Destroy()
        end
    end

    local v10 = Config.SkidMarkSeconds or 50

    task.delay(math.max(0, v10 - 8), function() -- line: 46
        -- upvalues: p2 (copy), TweenService (copy)
        if p2.Parent then
            TweenService:Create(p2, TweenInfo.new(8, Enum.EasingStyle.Linear), {
                Transparency = 1
            }):Play()
        end
    end)
    task.delay(v10, function() -- line: 49
        -- upvalues: p2 (copy)
        if p2.Parent then
            p2:Destroy()
        end
    end)
end

function t1.On() -- line: 51
    -- upvalues: OwnerFeatures14 (copy), LocalPlayer (copy)
    return OwnerFeatures14.On() and LocalPlayer:GetAttribute("GfxEffects") ~= false
end

t1.MarkSlideShare = 0.85
t1.MarkSlip = 0.7
t1.MarkLock = 0.6

function t1.NearLimit(p3, p4) -- line: 63
    -- upvalues: Parent (copy), Config (copy), BikeDynamics (copy), t1 (copy)
    local MaxSlideCrashYaw = Parent.BikeDynamics:GetAttribute("MaxSlideCrashYaw")

    if typeof(MaxSlideCrashYaw) ~= "number" or not MaxSlideCrashYaw then
        MaxSlideCrashYaw = 1
    end

    if p4 and p4:GetAttribute("LegendAbility") == "SlideMaster" and BikeDynamics.Legend then
        MaxSlideCrashYaw *= BikeDynamics.Legend.KuriSlideCrashYaw or 1
    end

    if math.abs(p3.rearYaw or 0) >= Config.RearYaw * MaxSlideCrashYaw * t1.MarkSlideShare or (p3.slip or 0) > t1.MarkSlip then
        return true
    end

    return (p3.rearBrakeSlip or 0) > t1.MarkLock
end

local t3 = {}

function t1.Step(p5, _) -- line: 70
    -- upvalues: BikeDynamics (copy), t1 (copy), t3 (copy)
    if not p5 or not p5.root or not p5.root.Parent then
        return
    end

    if not t1.On() then
        t3.bike = nil

        return
    end

    local v13 = BikeDynamics.Contact(p5)
    local v14 = (p5.wheeliePitch or 0) > 0.045 or p5.root.CFrame.LookVector.Y > 0.055 and v13 > 0.1
    local v15 = t1.NearLimit(p5, p5.root.Parent)
    local v16 = (p5.burnout or 0) > 0.025

    t3.bike = p5.root.Parent
    t3.at = os.clock()
    t3.rear = not v14 and (v15 or v16)
    t3.front = not v14 and (p5.frontLoss or 0) > 0.16
    t3.burnout = not v14 and v16
end

local function tShade(p7, p8) -- line: 96
    return 1 - math.clamp(p7 / (p8 + 1), 0, 1) * 0.6799999999999999
end

local t4 = {
    Front = {
        part = "Object_8",
        width = 0.055
    },
    Rear = {
        part = "Object_92",
        width = 0.08
    }
}
local self = setmetatable({}, {
    __mode = "k"
})

local function tyreInfo(p9, p10) -- line: 100
    -- upvalues: Config (copy), t4 (copy)
    local v19 = p9:FindFirstChild(t4[p10].part, true)

    if not (v19 and v19:IsA("BasePart")) then
        return nil
    end

    local Size = v19.Size
    local v20 = if Size.X <= Size.Y and Size.X <= Size.Z then "X" elseif Size.Y <= Size.Z then "Y" else "Z"
    local v21 = math.max(Size.X, Size.Y, Size.Z)
    local v24 = math.min(Size[v20] * 0.5, v21 * 0.25)

    return {
        part = v19,
        axis = v20,
        r = v24,
        crown = v21 * 0.5 - v24,
        width = t4[p10].width / Config.StudMetres
    }
end

local function axisOf(p11, p12) -- line: 107
    local v25, v26

    if p12 == "X" then
        local RightVector = p11.RightVector

        if RightVector then
            v25 = RightVector
            v26 = true
        elseif p12 == "Y" then
            local UpVector = p11.UpVector

            if UpVector then
                v25 = UpVector
                v26 = true
            else
                v26 = false
            end
        else
            v26 = false
        end
    elseif p12 == "Y" then
        local UpVector = p11.UpVector

        if UpVector then
            v25 = UpVector
            v26 = true
        else
            v26 = false
        end
    else
        v26 = false
    end

    if not v26 then
        v25 = p11.LookVector
    end

    return v25
end

local function endRun(p13) -- line: 109
    if not p13 then
        return
    end

    local recent = p13.recent

    if recent and #recent > 0 then
        local v27 = #recent

        for v28, v29 in recent do
            if v29.Parent then
                v29.Transparency = math.max(v29.Transparency, 1 - math.clamp((v27 - v28 + 1) / (v27 + 1), 0, 1) * 0.6799999999999999)
            end
        end
    end

    p13.last = nil
    p13.patch = nil
    p13.run = 0
    p13.recent = {}
    p13.patches = 0
end

local function forget(p14) -- line: 120
    -- upvalues: endRun (copy)
    if not p14 then
        return
    end

    for _, v32 in { "Front", "Rear" } do
        endRun(p14[v32])
    end
end

local function lay(p15, p16, p17, p18) -- line: 121
    -- upvalues: Config (copy), cast (copy), add (copy), endRun (copy)
    local _CFrame = p15.part.CFrame
    local axis = p15.axis
    local v33, v34

    if axis == "X" then
        local RightVector = _CFrame.RightVector

        if RightVector then
            v33 = RightVector
            v34 = true
        elseif axis == "Y" then
            local UpVector = _CFrame.UpVector

            if UpVector then
                v33 = UpVector
                v34 = true
            else
                v34 = false
            end
        else
            v34 = false
        end
    elseif axis == "Y" then
        local UpVector = _CFrame.UpVector

        if UpVector then
            v33 = UpVector
            v34 = true
        else
            v34 = false
        end
    else
        v34 = false
    end

    if not v34 then
        v33 = _CFrame.LookVector
    end

    local v35 = Vector3.new(-0, -1, -0, -0) + v33 * v33.Y

    if not (v35.Magnitude < 0.05) then
        local v36 = _CFrame.Position + v35.Unit * p15.crown
        local v37 = cast(v36)
        local v38, last, v39

        if v37 and v37.Instance:GetAttribute("Surface") == "Asphalt" and not (v36.Y - v37.Position.Y > p15.r + 0.3) then
            v38 = v37.Position + v37.Normal * 0.036
            last = p15.last
            p15.last = v38
            v39 = p15.recent or {}
            p15.recent = v39
            p15.run = p15.run or 0
            p15.patches = p15.patches or 0

            if p17 and p16 == "Rear" and (not last or (v38 - last).Magnitude < 0.35) then
                p15.last = last or v38

                local patch = p15.patch
                local v40 = Config.RearTyreHalfWidth * 1.3
                local v41 = patch

                if (not patch or not patch.Parent or (patch.Position - v38).Magnitude > v40 * 0.85) and p15.patches < 4 then
                    p15.patches += 1

                    local Part = Instance.new("Part")

                    v41 = Part
                    Part.Name = "RearBurnoutMark"
                    Part.Shape = Enum.PartType.Cylinder
                    Part.Anchored = true
                    Part.CanCollide = false
                    Part.CanTouch = false
                    Part.CanQuery = false
                    Part.Material = Enum.Material.SmoothPlastic
                    Part.Color = Color3.fromRGB(15, 16, 17)
                    Part.Transparency = 0.26
                    Part.CastShadow = false

                    local axis = p15.axis
                    local RightVector = axis == "X" and _CFrame.RightVector or axis == "Y" and _CFrame.UpVector or _CFrame.LookVector
                    local v43 = RightVector - v37.Normal * RightVector:Dot(v37.Normal)

                    if v43.Magnitude < 0.05 then
                        v43 = Vector3.new(1, 0, 0)
                    end

                    local Unit = v43.Unit

                    Part.CFrame = CFrame.fromMatrix(v38, v37.Normal, Unit, v37.Normal:Cross(Unit))
                    Part.Size = Vector3.new(0.02, Config.RearTyreHalfWidth * 1.3, Config.RearTyreHalfWidth * 1.3)
                    Part.Transparency = 0.7
                    add(Part)
                    p15.patch = Part
                end

                if v41 and v41.Parent then
                    v41.Transparency = math.max(0.2, v41.Transparency - p18 * 0.08)
                end

                return
            end

            p15.patch = nil

            if last then
                local v47 = v38 - last
                local Magnitude = v47.Magnitude

                if Magnitude < 0.35 then
                    p15.last = last
                elseif Magnitude > 30 then
                    endRun(p15)
                    p15.last = v38
                else
                    local Unit = v47.Unit
                    local Unit2 = Unit:Cross(v37.Normal).Unit

                    p15.run += 1

                    local Part = Instance.new("Part")

                    Part.Name = p16 .. "TyreMark"
                    Part.Anchored = true
                    Part.CanCollide = false
                    Part.CanTouch = false
                    Part.CanQuery = false
                    Part.Material = Enum.Material.SmoothPlastic
                    Part.Color = Color3.fromRGB(15, 16, 17)

                    if p15.run <= 6 then
                        Part.Transparency = 1 - math.clamp(p15.run / 7, 0, 1) * 0.6799999999999999 or 0.32
                    else
                        Part.Transparency = 0.32
                    end

                    Part.Size = Vector3.new(p15.width, 0.02, Magnitude + 0.02)
                    Part.CFrame = CFrame.fromMatrix((last + v38) / 2, Unit2, v37.Normal, -Unit)
                    Part.CastShadow = false
                    add(Part)
                    table.insert(p15.recent, Part)

                    if #p15.recent > 6 then
                        table.remove(p15.recent, 1)
                    end
                end
            end

            return
        end
    end

    endRun(p15)
end

local function flagsOf(p19, p20) -- line: 164
    -- upvalues: t3 (copy)
    if t3.bike == p19 and os.clock() - (t3.at or 0) < 0.25 and (p20:GetAttribute("LossStage") or "") == "" then
        return t3.rear, t3.front, t3.burnout
    end

    return p19:GetAttribute("TyreMarkRear") == true, p19:GetAttribute("TyreMarkFront") == true, p19:GetAttribute("TyreMarkBurnout") == true
end

local function step(p21) -- line: 168
    -- upvalues: t1 (copy), self (copy), tyreInfo (copy), endRun (copy), forget (copy), lay (copy), flagsOf (copy)
    if t1.On() then
        local RaceBikes = workspace:FindFirstChild("RaceBikes")

        if RaceBikes then
            local CurrentCamera = workspace.CurrentCamera
            local v50 = CurrentCamera and CurrentCamera.CFrame.Position

            for _, child in RaceBikes:GetChildren() do
                local v51 = child:IsA("Model") and child.PrimaryPart
                local v52 = self[child]

                if not v51 or (child:GetAttribute("Crash") or "") ~= "" or v51.Anchored then
                    forget(v52)
                else
                    local v53, v54, v55 = flagsOf(child, v51)

                    if not v53 and not v54 or v50 and (v51.Position - v50).Magnitude > t1.Cull then
                        forget(v52)
                    else
                        if not v52 then
                            v52 = {
                                clock = 0
                            }
                            self[child] = v52
                        end

                        v52.clock += p21

                        if not (v52.clock < t1.Interval) then
                            local clock = v52.clock

                            v52.clock = 0

                            for v56, v57 in {
                                    Rear = v53,
                                    Front = v54
                                } do
                                local v58 = v52[v56]

                                if v57 then
                                    if not v58 or not v58.part.Parent then
                                        v58 = tyreInfo(child, v56)
                                        v52[v56] = v58
                                    end

                                    if v58 then
                                        lay(v58, v56, v55, clock)
                                    end
                                elseif v58 and (v58.last or v58.patch) then
                                    endRun(v58)
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif next(self) then
        table.clear(self)
    end
end

if RunService:IsClient() then
    RunService.Heartbeat:Connect(step)
end

local function hideOwn(p22) -- line: 192
    -- upvalues: OwnerFeatures14 (copy), LocalPlayer (copy)
    if p22:IsA("BasePart") and p22:GetAttribute("Rider") == LocalPlayer.UserId and OwnerFeatures14.On() then
        p22.LocalTransparencyModifier = 1
    end
end

if RunService:IsClient() then
    task.spawn(function() -- line: 196
        -- upvalues: OwnerFeatures14 (copy), LocalPlayer (copy), hideOwn (copy)
        local v59 = workspace:WaitForChild("RaceTyreMarks", 60)

        if v59 then
            v59.ChildAdded:Connect(function(p23) -- line: 198
                -- upvalues: hideOwn (copy)
                task.defer(hideOwn, p23)
            end)

            for _, child in v59:GetChildren() do
                if child:IsA("BasePart") and child:GetAttribute("Rider") == LocalPlayer.UserId and OwnerFeatures14.On() then
                    child.LocalTransparencyModifier = 1
                end
            end
        end
    end)
end

return t1
