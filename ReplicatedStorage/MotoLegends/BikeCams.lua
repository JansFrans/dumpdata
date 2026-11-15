-- https://lua.expert

local Track = require(game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends"):WaitForChild("Config")).Track
local MotoLegends2 = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local Config = require(MotoLegends2:WaitForChild("Config"))
local Layout = require(MotoLegends2:WaitForChild("Tracks"):WaitForChild(Track):WaitForChild("Layout"))
local t1 = {}
local v1 = Config.FrontAxle or Vector3.new(0, -0.09, -3.1)
local v2 = Config.RearAxle or Vector3.new(0, 0.09, 3.1)
local _ = Config.SeatOffset or Vector3.new(0, 1.96, 1.22)
local v3 = Config.FrontWheelRadius or 1.24
local v4 = Config.RearWheelRadius or 1.42

local function frame(p1) -- line: 16
    local v5 = p1.Parent and p1.Parent:FindFirstChild("VisualFrame")

    return v5 and v5.CFrame or p1.CFrame
end

t1.Stabilizer = {
    Roll = 1,
    LookResponse = 16,
    UpResponse = 10
}

local self = setmetatable({}, {
    __mode = "k"
})

local function stabilize(p2, p3, p4) -- line: 23
    -- upvalues: t1 (copy), self (copy)
    local Stabilizer = t1.Stabilizer
    local v7 = self[p2]

    if not v7 then
        v7 = {}
        self[p2] = v7
    end

    local v8 = v7[p3]
    local elapsed = os.clock()
    local LookVector = p4.LookVector

    if not v8 or elapsed - v8.t > 0.25 then
        v8 = {
            t = elapsed,
            look = LookVector
        }
        v7[p3] = v8
    end

    local v10 = math.clamp(elapsed - v8.t, 0, 0.1)

    v8.t = elapsed
    v8.look = v8.look:Lerp(LookVector, 1 - math.exp(-v10 * Stabilizer.LookResponse))

    if v8.look.Magnitude < 0.01 then
        v8.look = LookVector
    end

    local Unit = v8.look.Unit

    if math.abs(Unit.Y) > 0.97 then
        return p4
    end

    local Unit2 = (Vector3.new(0, 1, 0) - Unit * Unit.Y).Unit
    local v12 = p4.UpVector:Lerp(Unit2, Stabilizer.Roll)
    local up = v8.up
    local v13 = if up then v8.up:Lerp(v12, 1 - math.exp(-v10 * Stabilizer.UpResponse)) else nil

    if up and v13 then
        v12 = v13
    end

    v8.up = v12

    local v15 = v8.up - Unit * Unit:Dot(v8.up)

    Unit2 = v15.Magnitude > 0.01 and v15.Unit or Unit2

    return CFrame.fromMatrix(p4.Position, Unit:Cross(Unit2), Unit2, -Unit)
end

t1.TailHeight = 3.25
t1.TailPitch = -8
t1.TailBack = 2.6

function t1.FrontTyre(p5) -- line: 52
    -- upvalues: v1 (copy), v3 (copy)
    local v16 = p5.Parent and p5.Parent:FindFirstChild("VisualFrame")
    local _CFrame = v16 and v16.CFrame or p5.CFrame
    local v19 = _CFrame * Vector3.new(0, v1.Y + v3 - 1, v1.Z - v3 - 0.2)

    return CFrame.fromMatrix(v19, _CFrame.RightVector, _CFrame.UpVector) * CFrame.Angles(-0.13962634015954636, 0, 0), 78
end

function t1.RearTyre(p6) -- line: 59
    -- upvalues: v2 (copy), v4 (copy), stabilize (copy)
    local v20 = p6.Parent and p6.Parent:FindFirstChild("VisualFrame")
    local _CFrame = v20 and v20.CFrame or p6.CFrame
    local v23 = _CFrame * Vector3.new(0, v2.Y + v4 - 1, v2.Z + v4 + 0.2)

    return stabilize(p6, "RearTyre", CFrame.fromMatrix(v23, -_CFrame.RightVector, _CFrame.UpVector) * CFrame.Angles(-0.13962634015954636, 0, 0)), 78
end

t1.DashPan = {
    YawPerLean = 0.32,
    MaxYaw = 20,
    Response = 5
}

function t1.Dash(p7) -- line: 70
    -- upvalues: t1 (copy), self (copy)
    local v24 = p7.Parent and p7.Parent:FindFirstChild("VisualFrame")
    local _CFrame = v24 and v24.CFrame or p7.CFrame
    local v25 = _CFrame * Vector3.new(0, 2.95, -2.62)
    local DashPan = t1.DashPan
    local v30 = math.clamp(-math.deg((math.asin((math.clamp(_CFrame.RightVector.Y, -1, 1))))) * DashPan.YawPerLean, -DashPan.MaxYaw, DashPan.MaxYaw)
    local v31 = self[p7]

    if not v31 then
        v31 = {}
        self[p7] = v31
    end

    local DashPan2 = v31.DashPan
    local elapsed = os.clock()

    if not DashPan2 or elapsed - DashPan2.t > 0.25 then
        DashPan2 = {
            t = elapsed,
            yaw = v30
        }
        v31.DashPan = DashPan2
    end

    local v33 = math.clamp(elapsed - DashPan2.t, 0, 0.1)

    DashPan2.t = elapsed
    DashPan2.yaw = DashPan2.yaw + (v30 - DashPan2.yaw) * (1 - math.exp(-v33 * DashPan.Response))

    return CFrame.fromMatrix(v25, -_CFrame.RightVector, _CFrame.UpVector) * CFrame.Angles(0, math.rad(DashPan2.yaw), 0) * CFrame.Angles(0.10471975511965978, 0, 0), 80
end

function t1.Tail(p8, p9) -- line: 84
    -- upvalues: t1 (copy), stabilize (copy)
    local v37 = p8.Parent and p8.Parent:FindFirstChild("VisualFrame")
    local _CFrame = v37 and v37.CFrame or p8.CFrame
    local v38 = _CFrame * Vector3.new(0, t1.TailHeight, t1.TailBack)
    local v40 = CFrame.fromMatrix(v38, _CFrame.RightVector, _CFrame.UpVector) * CFrame.Angles(math.rad(t1.TailPitch), 0, 0)

    if not p9 or not v40 then
        v40 = stabilize(p8, "Tail", v40)
    end

    return v40, 80
end

local t4 = {
    FocusResponse = 30,
    NormalFov = 24,
    NearFov = 28,
    FarFov = 4,
    NearDistanceStuds = 60,
    FarDistanceStuds = 250,
    ZoomResponse = 6,
    MinFov = 1,
    MaxFov = 55,
    AimHeightStuds = 1.5,
    ContinuousStartFov = 24,
    ContinuousEndFov = 2,
    ContinuousZoomSeconds = 4,
    NaturalShakeDegrees = 0.035,
    NaturalShakeFrequency = 1.5,
    ShakeNearDegrees = 0,
    ShakeFarDegrees = 0,
    ShakeNearDistanceStuds = 30,
    ShakeFarDistanceStuds = 220,
    ShakeFrequency = 9,
    OpeningZoomOut = 1.4,
    OpeningSeconds = 1.6
}
local Points = Layout.Points
local v41 = #Points
local t5 = {}

local function nearestIndex(p10, p11) -- line: 112
    -- upvalues: Points (copy), v41 (copy)
    local v42, v43, v44

    if p11 then
        local v45 = p11 - 40
        local v46 = p11 + 40

        v44 = 1
        v42 = 1e999

        for i = v45, v46 do
            local v47 = (i - 1) % v41 + 1
            local Magnitude = (Points[v47] - p10).Magnitude

            if Magnitude < v42 then
                v42 = Magnitude
                v44 = v47
            end
        end

        v43 = v42 < 120
    end

    if p11 and v43 then
        return v44
    end

    if not p11 then
        v44 = 1
        v42 = 1e999
    end

    for i = 1, v41, 4 do
        local Magnitude = (Points[i] - p10).Magnitude

        if Magnitude < v42 then
            v42 = Magnitude
            v44 = i
        end
    end

    for i = v44 - 4, v44 + 4 do
        local v48 = (i - 1) % v41 + 1
        local Magnitude = (Points[v48] - p10).Magnitude

        if Magnitude < v42 then
            v42 = Magnitude
            v44 = v48
        end
    end

    return v44
end

local t6 = {}
local n1 = (-1e999)

local function cameraSettings(p12) -- line: 125
    -- upvalues: t4 (copy)
    local t7 = {}

    for v49, v50 in t4 do
        local Attribute = p12:GetAttribute(v49)

        t7[v49] = typeof(Attribute) == "number" and Attribute == Attribute and math.abs(Attribute) < 1e999 and Attribute or v50
    end

    t7.MinFov = math.clamp(t7.MinFov, 1, 119)
    t7.MaxFov = math.clamp(t7.MaxFov, t7.MinFov, 120)

    for _, v51 in { "NormalFov", "NearFov", "FarFov" } do
        t7[v51] = math.clamp(t7[v51], t7.MinFov, t7.MaxFov)
    end

    t7.FocusResponse = math.clamp(t7.FocusResponse, 0.1, 120)
    t7.ZoomResponse = math.clamp(t7.ZoomResponse, 0.1, 120)
    t7.NearFov = math.max(t7.NearFov, t7.FarFov)
    t7.NearDistanceStuds = math.max(0, t7.NearDistanceStuds)
    t7.FarDistanceStuds = math.max(t7.NearDistanceStuds + 1, t7.FarDistanceStuds)
    t7.ContinuousZoom = p12:GetAttribute("ZoomMode") == "Continuous"
    t7.ContinuousStartFov = math.clamp(t7.ContinuousStartFov, t7.MinFov, t7.MaxFov)
    t7.ContinuousEndFov = math.clamp(t7.ContinuousEndFov, t7.MinFov, t7.ContinuousStartFov)
    t7.ContinuousZoomSeconds = math.max(0.1, t7.ContinuousZoomSeconds)
    t7.ShakeNearDegrees = math.clamp(t7.ShakeNearDegrees, 0, 3)
    t7.ShakeFarDegrees = math.clamp(t7.ShakeFarDegrees, 0, 3)
    t7.ShakeNearDistanceStuds = math.max(0, t7.ShakeNearDistanceStuds)
    t7.ShakeFarDistanceStuds = math.max(t7.ShakeNearDistanceStuds + 1, t7.ShakeFarDistanceStuds)
    t7.ShakeFrequency = math.clamp(t7.ShakeFrequency, 0.1, 30)
    t7.NaturalShakeDegrees = math.clamp(t7.NaturalShakeDegrees, 0, 0.5)
    t7.NaturalShakeFrequency = math.clamp(t7.NaturalShakeFrequency, 0.1, 10)

    return t7
end

local function refreshCameraRegistry() -- line: 152
    -- upvalues: v41 (copy), t5 (ref), nearestIndex (copy), t6 (copy), n1 (ref), cameraSettings (copy)
    local elapsed = os.clock()

    if elapsed - n1 < 0.5 then
        return
    end

    n1 = elapsed

    local TracksideTVCameras = workspace:FindFirstChild("TracksideTVCameras")
    local t8 = {}
    local t9 = {}

    if TracksideTVCameras then
        for _, child in TracksideTVCameras:GetChildren() do
            if child:IsA("Model") and child:GetAttribute("Enabled") ~= false then
                local v55 = child:FindFirstChild("CameraOrigin", true)

                if v55 and v55:IsA("BasePart") then
                    local v56 = t6[child] or {
                        model = child
                    }

                    v56.origin = v55
                    v56.pos = v55.Position
                    v56.settings = cameraSettings(child)
                    v56.active = true

                    local TrackIndex = child:GetAttribute("TrackIndex")

                    if child:GetAttribute("AutoTrackIndex") == false and typeof(TrackIndex) == "number" and TrackIndex == TrackIndex then
                        v56.index = math.clamp(math.floor(TrackIndex), 1, v41)
                    elseif v56.originFrame ~= v55.CFrame then
                        v56.index = nearestIndex(v55.Position)
                    end

                    local EndMarker = child:FindFirstChild("EndMarker")

                    v56.endIndex = EndMarker and EndMarker:IsA("BasePart") and EndMarker:GetAttribute("Enabled") ~= false and nearestIndex(EndMarker.Position) or nil

                    if EndMarker and EndMarker:IsA("BasePart") and game:GetService("RunService"):IsRunning() then
                        EndMarker.LocalTransparencyModifier = 1
                    end

                    local NextCamera = child:FindFirstChild("NextCamera")

                    v56.nextModel = NextCamera and NextCamera:IsA("ObjectValue") and NextCamera.Value or nil

                    local RequiredPreviousCamera = child:FindFirstChild("RequiredPreviousCamera")
                    local FallbackCamera = child:FindFirstChild("FallbackCamera")

                    if RequiredPreviousCamera ~= nil then
                        v56.requiresPrevious = RequiredPreviousCamera:IsA("ObjectValue")
                    else
                        v56.requiresPrevious = false
                    end

                    v56.requiredPreviousModel = v56.requiresPrevious and RequiredPreviousCamera.Value or nil
                    v56.fallbackModel = FallbackCamera and FallbackCamera:IsA("ObjectValue") and FallbackCamera.Value or nil
                    v56.originFrame = v55.CFrame
                    t6[child] = v56
                    t8[child] = true
                    table.insert(t9, v56)
                end
            end
        end
    end

    for v58, v59 in t6 do
        if not t8[v58] then
            v59.active = false
            t6[v58] = nil
        end
    end

    table.sort(t9, function(p13, p14) -- line: 184
        local v60 = tonumber(p13.model.Name:match("(%d+)$")) or 1e999
        local v61 = tonumber(p14.model.Name:match("(%d+)$")) or 1e999

        if v60 == v61 then
            return p13.model.Name < p14.model.Name
        end

        return v60 < v61
    end)
    t5 = t9

    for v62, v63 in t5 do
        v63.order = v62
    end
end

local t10 = {}

for _, v64 in { "Buildings", "Grandstands", "PitComplex", "Structures" } do
    local v65 = workspace:FindFirstChild(v64, true)

    if v65 then
        table.insert(t10, v65)
    end
end

local TimePlayedLeaderboard = workspace:FindFirstChild("TimePlayedLeaderboard")

if TimePlayedLeaderboard then
    table.insert(t10, TimePlayedLeaderboard)
end

table.insert(t10, workspace.Terrain)

local v66 = RaycastParams.new()

v66.FilterType = Enum.RaycastFilterType.Include
v66.FilterDescendantsInstances = t10

local function clear(p15, p16) -- line: 199
    -- upvalues: v66 (copy)
    local v67 = p16 - p15.pos

    return workspace:Raycast(p15.pos, v67 * 0.97, v66) == nil
end

local function tvZoomFov(p17, p18) -- line: 201
    local v69 = math.clamp((p17 - p18.NearDistanceStuds) / (p18.FarDistanceStuds - p18.NearDistanceStuds), 0, 1)
    local v70 = v69 * v69 * (3 - v69 * 2)

    return p18.NearFov + (p18.FarFov - p18.NearFov) * v70
end

local t11 = {
    station = nil,
    at = 0,
    parts = {}
}

local function hideStation(p19) -- line: 210
    -- upvalues: t11 (copy)
    t11.at = os.clock()

    if t11.station == p19 then
        return
    end

    for v71, v72 in t11.parts do
        if v71.Parent then
            v71.LocalTransparencyModifier = v72
        end
    end

    table.clear(t11.parts)
    t11.station = p19

    if p19 then
        for _, descendant in p19:GetDescendants() do
            if (descendant:IsA("BasePart") or descendant:IsA("Decal")) and descendant.Name ~= "EndMarker" then
                t11.parts[descendant] = descendant.LocalTransparencyModifier
                descendant.LocalTransparencyModifier = 1
            end
        end
    end
end

if game:GetService("RunService"):IsClient() then
    game:GetService("RunService").RenderStepped:Connect(function() -- line: 223
        -- upvalues: t11 (copy)
        if not (t11.station and os.clock() - t11.at > 0.2) then
            return
        end

        t11.at = os.clock()

        if t11.station == nil then
            return
        end

        for v73, v74 in t11.parts do
            if v73.Parent then
                v73.LocalTransparencyModifier = v74
            end
        end

        table.clear(t11.parts)
        t11.station = nil
    end)
end

function t1.TV(p20, p21, p22) -- line: 228
    -- upvalues: t4 (copy), v41 (copy), t5 (ref), nearestIndex (copy), t6 (copy), refreshCameraRegistry (copy), v66 (copy), hideStation (copy)
    refreshCameraRegistry()

    local Position = p20.Position

    if #t5 == 0 then
        p21.cam = nil
        p21.focus = nil
        p21.zoomFov = nil

        return CFrame.lookAt(Position + Vector3.new(0, 12, 25), Position + Vector3.new(0, 1.5, 0)), t4.NormalFov
    end

    local v75 = p21.lastPosition and (Position - p21.lastPosition).Magnitude > 250

    if p21.root ~= p20 or v75 then
        p21.root = p20
        p21.cam = nil
        p21.idx = nil
        p21.focus = nil
        p21.zoomFov = nil
        p21.shotSeconds = 0
        p21.check = 0
        p21.admittedCamera = nil
    end

    p21.lastPosition = Position

    local idx = p21.idx

    p21.idx = nearestIndex(Position, p21.idx)

    local function rel(p23) -- line: 245
        -- upvalues: p21 (copy), v41 (copy)
        return (p21.idx - p23.index + v41 / 2) % v41 - v41 / 2
    end

    local cam = p21.cam
    local cam2

    if not cam or cam.active and cam.origin.Parent and cam.model:IsDescendantOf(workspace) then
        cam2 = cam
    else
        p21.cam = nil
        p21.admittedCamera = nil
    end

    local cam3 = cam2

    if cam2 then
        if cam2.requiresPrevious and p21.admittedCamera ~= cam2.model then
            local v76 = t6[cam2.fallbackModel] or t5[1]

            if v76 and v76.requiresPrevious then
                v76 = t6[v76.fallbackModel] or t5[1]
            end

            if v76 and v76 ~= p21.cam then
                p21.cam = v76
                p21.focus = nil
                p21.zoomFov = nil
                p21.shotSeconds = 0
                p21.check = 0

                local v77 = v76.requiresPrevious and v76.model or nil

                p21.admittedCamera = v77
            end

            cam3 = p21.cam
        end
    end

    if cam3 then
        cam3.pos = cam3.origin.Position
    end

    p21.check = (p21.check or 0) + math.max(0, p22)

    local v78 = false

    if cam3 and p21.check > 0.4 then
        p21.check = 0

        local v79 = Position - cam3.pos

        v78 = workspace:Raycast(cam3.pos, v79 * 0.97, v66) ~= nil
    end

    local function crossedMarker(p24) -- line: 275
        -- upvalues: p21 (copy), idx (ref), v41 (copy)
        if not (p24.endIndex and idx) then
            return false
        end

        local v80 = (p21.idx - idx) % v41
        local v81 = (p24.endIndex - idx) % v41

        if v80 > 0 and v80 < v41 / 4 then
            if v81 == 0 then
                return true
            end

            return v81 <= v80
        end

        return false
    end

    local function pastShotEnd(p25) -- line: 282
        -- upvalues: p21 (copy), v41 (copy), t5 (ref)
        local v82

        if not p25.endIndex or #t5 < 2 then
            return false
        else
            local v84 = t5[(p25.order - 2) % #t5 + 1]

            v82 = v84.endIndex or v84.index
        end

        local v85 = (p25.endIndex - v82) % v41
        local v86 = (p21.idx - v82) % v41

        if v85 > 0 and v85 < v41 * 0.75 and v85 < v86 then
            return v86 < v85 + v41 / 4
        end

        return false
    end

    if cam3 and cam3.endIndex then
        for _ = 1, #t5 do
            local v87

            if not (cam3.endIndex and idx) then
                v87 = false
            else
                local v88 = (p21.idx - idx) % v41
                local v89 = (cam3.endIndex - idx) % v41

                v87 = v88 > 0 and v88 < v41 / 4 and (v89 == 0 or v89 <= v88)
            end

            if not (v87 or pastShotEnd(cam3)) then
                break
            end

            local v90 = t6[cam3.nextModel]

            if not v90 or not v90.active or v90 == cam3 then
                v90 = t5[cam3.order % #t5 + 1]
            end

            if v90 and v90.requiresPrevious and (not cam3 or cam3.model ~= v90.requiredPreviousModel) then
                v90 = t6[v90.fallbackModel] or t5[1]
            end

            if not v90 or v90 == cam3 then
                break
            end

            if v90.requiresPrevious and (not cam3 or cam3.model ~= v90.requiredPreviousModel) then
                v90 = t6[v90.fallbackModel] or t5[1]
            end

            if v90 and v90 ~= p21.cam then
                p21.cam = v90
                p21.focus = nil
                p21.zoomFov = nil
                p21.shotSeconds = 0
                p21.check = 0

                local v91 = v90.requiresPrevious and v90.model or nil

                p21.admittedCamera = v91
            end

            cam3 = p21.cam
            idx = nil
        end
    end

    local cam4, v92

    if cam3 then
        if cam3.endIndex then
            cam4 = cam3
            v92 = true
        elseif v78 or (p21.idx - cam3.index + v41 / 2) % v41 - v41 / 2 > 22 or (p21.idx - cam3.index + v41 / 2) % v41 - v41 / 2 < -48 then
            v92 = false
        else
            cam4 = cam3
            v92 = true
        end
    else
        v92 = false
    end

    if not v92 then
        local t14 = {}

        for _, v93 in t5 do
            local v94 = (p21.idx - v93.index + v41 / 2) % v41 - v41 / 2

            if v94 >= -44 and v94 <= 14 and v93 ~= (v78 and cam3 or nil) then
                table.insert(t14, {
                    v93,
                    (math.abs(v94 + 16))
                })
            end
        end

        table.sort(t14, function(p26, p27) -- line: 306
            return p26[2] < p27[2]
        end)

        local v96

        for _, v97 in t14 do
            local v98 = v97[1]
            local v99 = Position - v98.pos

            if workspace:Raycast(v98.pos, v99 * 0.97, v66) == nil then
                v96 = v97[1]
                break
            end

            v96 = nil
        end

        v96 = v96 or t14[1] and t14[1][1]

        if not v96 then
            local t16 = t5

            v96 = nil

            local n2 = 1e999

            for _, v100 in t16 do
                local v102 = math.abs((p21.idx - v100.index + v41 / 2) % v41 - v41 / 2)

                if v102 < n2 then
                    n2 = v102
                    v96 = v100
                end
            end
        end

        if v96 and v96.requiresPrevious and (not cam3 or cam3.model ~= v96.requiredPreviousModel) then
            v96 = t6[v96.fallbackModel] or t5[1]
        end

        if v96 and v96 ~= p21.cam then
            p21.cam = v96
            p21.focus = nil
            p21.zoomFov = nil
            p21.shotSeconds = 0
            p21.check = 0

            local v103 = v96.requiresPrevious and v96.model or nil

            p21.admittedCamera = v103
        end

        cam4 = p21.cam
    end

    local settings = cam4.settings

    cam4.pos = cam4.origin.Position
    p21.focus = p21.focus and p21.focus:Lerp(Position, 1 - math.exp(-p22 * settings.FocusResponse)) or Position

    local Magnitude = (Position - cam4.pos).Magnitude

    p21.shotSeconds = (p21.shotSeconds or 0) + math.max(0, p22)

    local v107 = math.clamp((Magnitude - settings.NearDistanceStuds) / (settings.FarDistanceStuds - settings.NearDistanceStuds), 0, 1)
    local v108 = v107 * v107 * (3 - v107 * 2)
    local v110 = math.clamp(settings.NearFov + (settings.FarFov - settings.NearFov) * v108, settings.MinFov, settings.MaxFov)

    if settings.ContinuousZoom then
        local v112 = math.clamp(p21.shotSeconds / settings.ContinuousZoomSeconds, 0, 1)

        v110 = settings.ContinuousStartFov + (settings.ContinuousEndFov - settings.ContinuousStartFov) * v112
    end

    local v114 = math.clamp(p21.shotSeconds / math.max(0.05, settings.OpeningSeconds), 0, 1)
    local v115 = v114 * v114 * (3 - v114 * 2)
    local v117 = math.min(settings.MaxFov, v110 * ((math.max(1, settings.OpeningZoomOut) - 1) * (1 - v115) + 1))
    local zoomFov = p21.zoomFov
    local v118 = if zoomFov then p21.zoomFov + (v117 - p21.zoomFov) * (1 - math.exp(-p22 * settings.ZoomResponse)) else nil

    p21.zoomFov = if zoomFov and v118 then v118 else v117

    local zoomFov2 = p21.zoomFov
    local v121 = CFrame.lookAt(cam4.pos, p21.focus + Vector3.new(0, 1, 0) * settings.AimHeightStuds)
    local v122 = math.rad(settings.NaturalShakeDegrees)

    if v122 > 0 then
        local v123 = os.clock() * settings.NaturalShakeFrequency

        v121 *= CFrame.Angles(math.noise(v123, 113, 0) * 2 * v122, math.noise(0, v123, 157) * 2 * v122, math.noise(193, 0, v123) * v122 * 0.25)
    end

    if game:GetService("RunService"):IsClient() then
        hideStation(cam4.model)
    end

    return v121, zoomFov2
end

function t1.CrashOnboard(p28, p29, p30, _) -- line: 347
    -- upvalues: t1 (copy)
    local v124 = if p28 and p28.Parent then p28 else p29

    if not v124 then
        return nil
    end

    p29 = p29 or v124

    if p30.rider ~= p29 then
        table.clear(p30)
        p30.rider = p29
    end

    if not p30.mode then
        p30.mode = math.random(1, 2) == 1 and "Tail" or "Dash"
    end

    local v126, v127

    if p30.mode == "Tail" then
        v126, v127 = t1.Tail(v124, true)
    else
        v126, v127 = t1.Dash(v124)
    end

    p30.target = p30.mode

    return v126, v127, (v126 * CFrame.new(0, 0, -20)).Position
end

local _ = {
    Height = 220,
    Behind = 145,
    Side = 80,
    Fov = 38,
    ShakeDegrees = 0.1,
    ShakeFrequency = 1.8,
    FovSlow = 22,
    FovFast = 44,
    SlowKph = 40,
    FastKph = 260,
    ZoomResponse = 0.9
}

function t1.Heli(p32, p33, p34) -- line: 364
    local _CFrame = p32.CFrame
    local v128 = Vector3.new(_CFrame.LookVector.X, 0, _CFrame.LookVector.Z)
    local Unit = v128.Magnitude > 0.01 and v128.Unit or Vector3.new(0, 0, -1)
    local fwd = p33.fwd
    local Unit2 = if fwd then p33.fwd:Lerp(Unit, 1 - math.exp(-p34 * 0.8)).Unit else nil

    p33.fwd = if fwd and Unit2 then Unit2 else Unit

    local v130 = p33.fwd:Cross((Vector3.new(0, 1, 0)))
    local v131 = p32.Position - p33.fwd * 145 + v130 * 80 + Vector3.new(0, 220, 0)

    if p33.pos and (v131 - p33.pos).Magnitude > 400 then
        p33.pos = nil
    end

    local pos = p33.pos
    local v132 = if pos then p33.pos:Lerp(v131, 1 - math.exp(-p34 * 1.6)) else nil

    p33.pos = if pos and v132 then v132 else v131

    if p33.focus then
        p33.focus = p33.focus:Lerp(p32.Position, 1 - math.exp(-p34 * 6)) or p32.Position
    else
        p33.focus = p32.Position
    end

    local v135 = CFrame.lookAt(p33.pos, p33.focus)
    local v136 = (p33.shakeTime or 0) + math.max(0, p34) * 1.8

    p33.shakeTime = v136

    local v137 = v135 * CFrame.Angles(math.noise(v136, 31, 0) * 0.0017453292519943296, math.noise(0, v136, 47) * 0.0017453292519943296, math.noise(59, 0, v136) * 0.0017453292519943296 * 0.35)
    local Position = p32.Position
    local v138 = require(script.Parent.Config).StudMetres or 0.28
    local v139, v140

    if p33.lastPos and p34 > 0 then
        local v141 = ((Position - p33.lastPos) * Vector3.new(1, 0, 1)).Magnitude / p34 * v138 * 3.6

        if v141 then
            v139 = v141
            v140 = true
        else
            v140 = false
        end
    else
        v140 = false
    end

    if not v140 then
        v139 = p33.kph or 0
    end

    p33.lastPos = Position

    if v139 > 500 then
        v139 = p33.kph or 0
    end

    local kph = p33.kph
    local v142 = if kph then p33.kph + (v139 - p33.kph) * (1 - math.exp(-p34 * 2)) else nil

    p33.kph = if kph and v142 then v142 else v139

    local v146 = math.clamp((p33.kph - 40) / 220, 0, 1)
    local v147 = 22 + 22 * (v146 * v146 * (3 - v146 * 2))
    local fov = p33.fov
    local v148 = if fov then p33.fov + (v147 - p33.fov) * (1 - math.exp(-p34 * 0.9)) else nil

    p33.fov = if fov and v148 then v148 else v147

    return v137, p33.fov
end

return t1
