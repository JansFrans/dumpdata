-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local Config = require(MotoLegends:WaitForChild("Config"))
local RacingLine = require(ReplicatedStorage:WaitForChild("MotoLegends"):WaitForChild("RacingLine"))
local _require = require
local ok, result = pcall(_require, MotoLegends:WaitForChild("BikeDynamics"))
local v1, v2

if ok and typeof(result) == "table" then
    local FrontBrake = result.FrontBrake

    if FrontBrake then
        v1 = FrontBrake
        v2 = true
    else
        v2 = false
    end
else
    v2 = false
end

if not v2 then
    v1 = {}
end

local _require2 = require
local ok2, result2 = pcall(_require2, MotoLegends:WaitForChild("SettingsBridge"))
local result3 = result2

if not ok2 then
    result3 = nil
end

local _require3 = require
local ok3, result4 = pcall(_require3, MotoLegends:WaitForChild("TyreCatalog"))
local result5 = result4

if not ok3 or typeof(result4) ~= "table" then
    result5 = nil
end

local _require4 = require
local ok4, result6 = pcall(_require4, MotoLegends:WaitForChild("BikeStats"))
local result7 = result6

if not ok4 or typeof(result6) ~= "table" then
    result7 = nil
end

local _require5 = require
local ok5, result8 = pcall(_require5, MotoLegends:WaitForChild("BikeGearbox"))
local result9 = result8
local result10

if not ok5 or typeof(result8) ~= "table" then
    result9 = nil
else
    result10 = result8
end

local v3 = Color3.fromRGB(195, 255, 0)
local v4 = Color3.fromRGB(255, 65, 34)
local t1 = {
    Color3.fromRGB(255, 225, 0),
    Color3.fromRGB(255, 170, 0),
    Color3.fromRGB(255, 110, 20)
}
local v5 = Config.Gravity or 35
local v6 = Config.StudMetres or 0.28
local v7 = Config.MaxLean or 1.0471975511965976
local v8 = 1.6003345290410507 / math.tan(v7)
local v9 = 0.95 * v5
local Power = result10 and result10.Power or 13200
local v10 = (Config.TopSpeedKph or 400) / 3.6 / v6
local v11 = v1.EBSStrength or { 0.7, 0.78, 0.885, 1.016, 1.15 }
local v12 = v1.EBSGripCap or { 1, 1, 1, 1, 1.06 }
local v13 = v1.ABSLimit or 0.95
local v14
local n1 = 0
local v15
local t2 = {}

t2[1] = nil

local v16 = nil

local function idx(p1) -- line: 72
    -- upvalues: n1 (ref)
    return (p1 - 1) % n1 + 1
end

local function circle(p2, p3, p4) -- line: 74
    local Magnitude = (p3 - p2).Magnitude
    local Magnitude2 = (p4 - p3).Magnitude
    local Magnitude3 = (p2 - p4).Magnitude
    local v18 = math.abs((p3.X - p2.X) * (p4.Z - p2.Z) - (p3.Z - p2.Z) * (p4.X - p2.X))

    if v18 < 1E-06 then
        return 1e999
    end

    return Magnitude * Magnitude2 * Magnitude3 / (v18 * 2)
end

local function wetness() -- line: 81
    -- upvalues: MotoLegends (copy)
    local TrackWetness = MotoLegends:GetAttribute("TrackWetness")

    if typeof(TrackWetness) == "number" then
        return (math.clamp(TrackWetness, 0, 1))
    end

    if MotoLegends:GetAttribute("Raining") == true then
        return 1
    end

    return 0
end

local function drag(p5) -- line: 88
    return 1E-04 * p5 * p5 + 0.025 * p5
end

local v19 = result10 and ((result10.DownshiftRPM or 6800) + 600) / (result10.RedlineRPM or 16000) or 0.4625

local function engineBrake(p6, p7) -- line: 92
    -- upvalues: result9 (ref), v6 (copy), v19 (copy)
    if result9 and result9.Limits and result9.Ratio then
        local v20 = p6 * v6 * 3.6
        local n2 = 6

        while n2 > 1 and v20 < (result9.Limits[n2] or 0) * v19 do
            n2 -= 1
        end

        return p6 * 0.028 * p7 * result9.Ratio(n2) / 2.7
    end

    return p6 * 0.028 * p7 * 1.3 / 2.7
end

local n3 = 1

local function accelAt(p8) -- line: 101
    -- upvalues: v9 (copy), Power (copy), n3 (ref)
    return math.max(0, math.min(v9, Power / math.max(p8, 1)) - (1E-04 * p8 * p8 + 0.025 * p8)) * n3
end

local n4 = 30
local n5 = 2
local v23

local function q(p9) -- line: 108
    return (math.floor((p9 or 1) * 50 + 0.5))
end

local v25

local function buildProfile(p10) -- line: 113
    -- upvalues: v5 (copy), v8 (copy), v10 (copy), v13 (copy), n1 (ref), v15 (ref), t2 (copy), v16 (ref), engineBrake (copy), n3 (ref), n4 (ref), n5 (ref), v23 (ref), v25 (ref), v11 (copy), v12 (copy)
    local v40 = table.concat({
        p10.ebs,
        if p10.abs then 1 else 0,
        math.floor((p10.wet or 1) * 50 + 0.5),
        if p10.slickWet then 1 else 0,
        math.floor((p10.grip or 1) * 50 + 0.5),
        math.floor((p10.fBrake or 1) * 50 + 0.5),
        math.floor((p10.holdL or 1) * 50 + 0.5),
        math.floor((p10.holdR or 1) * 50 + 0.5),
        (math.floor((p10.accel or 1) * 50 + 0.5))
    }, ",")

    if v40 == v25 then
        return
    end

    v25 = v40
    n5 = p10.ebs
    n3 = p10.accel
    n4 = math.min((if p10.abs then 50 else 58) * (v11[p10.ebs] or 0.885) * 0.95, p10.grip * p10.fBrake * v5 * (v12[p10.ebs] or 1) * (p10.abs and v13 or 1))

    local v43 = p10.holdL * v8 * v5
    local v44 = p10.holdR * v8 * v5
    local v45 = n1

    for i = 1, v45 do
        local v46 = if not (v23[i] > 0) or not v43 then v44 else v43
        local v47 = v16

        v47[i] = math.min(v10, (math.sqrt(v46 * v15[i])))
    end

    for _ = 1, 2 do
        local v50 = n1

        for i = v50, 1, -1 do
            local v51 = (i + 1 - 1) % n1 + 1
            local v52 = v16[v51]
            local v53 = t2[1][i]
            local v55 = v52 * v52
            local v56 = n4
            local v57 = math.sqrt(v55 + 2 * (v56 + (1E-04 * v52 * v52 + 0.025 * v52) + engineBrake(v52, n5)) * v53)
            local v58 = v52 * v52
            local v59 = (v57 + v52) / 2
            local v61 = n4
            local v62 = math.sqrt(v58 + 2 * (v61 + (1E-04 * v59 * v59 + 0.025 * v59) + engineBrake(v59, n5)) * v53)

            if v62 < v16[i] then
                local v63 = v16

                v63[i] = v62
            end
        end
    end
end

local v64 = math.tan(v7)

local function holdOf(p11, p12, p13, p14, p15) -- line: 141
    -- upvalues: result5 (ref), v64 (copy)
    local v65

    if not result5 or not result5.GripOf then
        v65 = v64

        return (math.max(v65, 0.2))
    end

    local v66, v67 = result5.GripOf(p11, p12, p13)
    local v68 = result5.Floor and result5.Floor(v66, "Front") or v66

    v67 = result5.Floor and result5.Floor(v67, "Rear") or v67
    v65 = if v68 < 1 then math.min(v64, v68 * v64) else v64

    if v67 < 1 then
        v65 = math.min(v65, v67 * v64)
    end

    if p15 then
        v65 = math.min(v65, p14 * v66)
    end

    return (math.max(v65, 0.2))
end

local t4 = {}

local function readState(p16, p17) -- line: 155
    -- upvalues: result5 (ref), result7 (ref), MotoLegends (copy), Config (copy), v7 (copy), holdOf (copy), t4 (copy)
    t4.ebs = math.clamp(math.floor(tonumber(p16 and p16:GetAttribute("EBS")) or Config.EBS or 3), 1, 5)
    t4.abs = p17

    local TrackWetness = MotoLegends:GetAttribute("TrackWetness")

    t4.wet = if typeof(TrackWetness) == "number" then math.clamp(TrackWetness, 0, 1) elseif MotoLegends:GetAttribute("Raining") == true then 1 else 0

    local v75 = MotoLegends:GetAttribute("Raining") == true
    local v76 = result7 and result7.Physics and p16 and result7.Physics(p16:GetAttribute("BikeName"))
    local v77 = (Config.Grip or 1.55) * (v76 and v76.Grip or 1) * (1 - (1 - (Config.RainGrip or 0.72)) * t4.wet) * (MotoLegends:GetAttribute("WeatherGrip") or 1)

    t4.grip = v77
    t4.accel = v76 and v76.Accel or 1

    local TyreFront = p16 and p16:GetAttribute("TyreFront")

    t4.slickWet = v75 and typeof(TyreFront) == "string" and TyreFront ~= "Wet"
    t4.fBrake = 1

    if result5 and result5.GripOf and p16 then
        t4.fBrake = 1 + (result5.GripOf(p16, v75, 0) - 1) * 0.75
    end

    t4.holdL = holdOf(p16, v75, v7, v77, t4.slickWet)
    t4.holdR = holdOf(p16, v75, -v7, v77, t4.slickWet)

    return t4
end

local Folder = Instance.new("Folder")

Folder.Name = "ApexAssistLine"

local function wedge(p18) -- line: 182
    -- upvalues: v3 (copy), Folder (copy)
    local WedgePart = Instance.new("WedgePart")

    WedgePart.Name = p18
    WedgePart.Anchored = true
    WedgePart.CanCollide = false
    WedgePart.CanTouch = false
    WedgePart.CanQuery = false
    WedgePart.CastShadow = false
    WedgePart.Material = Enum.Material.SmoothPlastic
    WedgePart.Color = v3
    WedgePart.Transparency = 1
    WedgePart.Size = Vector3.new(0.06, 3, 4.5)
    WedgePart.Parent = Folder

    return WedgePart
end

local t5 = {}

for i = 1, 26 do
    local t6 = {
        t = 1
    }
    local WedgePart = Instance.new("WedgePart")

    WedgePart.Name = "ArrowL"
    WedgePart.Anchored = true
    WedgePart.CanCollide = false
    WedgePart.CanTouch = false
    WedgePart.CanQuery = false
    WedgePart.CastShadow = false
    WedgePart.Material = Enum.Material.SmoothPlastic
    WedgePart.Color = v3
    WedgePart.Transparency = 1
    WedgePart.Size = Vector3.new(0.06, 3, 4.5)
    WedgePart.Parent = Folder
    t6.l = WedgePart

    local WedgePart2 = Instance.new("WedgePart")

    WedgePart2.Name = "ArrowR"
    WedgePart2.Anchored = true
    WedgePart2.CanCollide = false
    WedgePart2.CanTouch = false
    WedgePart2.CanQuery = false
    WedgePart2.CastShadow = false
    WedgePart2.Material = Enum.Material.SmoothPlastic
    WedgePart2.Color = v3
    WedgePart2.Transparency = 1
    WedgePart2.Size = Vector3.new(0.06, 3, 4.5)
    WedgePart2.Parent = Folder
    t6.r = WedgePart2
    t6.c = v3
    t5[i] = t6
end

local t7 = {}
local t8 = {}
local v79 = RaycastParams.new()

v79.FilterType = Enum.RaycastFilterType.Exclude

local function ground(p19, p20) -- line: 206
    -- upvalues: Players (copy), Folder (copy), t7 (copy), t8 (copy), v79 (copy)
    local v80 = t7[p19]

    if v80 then
        return v80, t8[p19]
    end

    local t9 = {
        Folder
    }

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t9, player.Character)
        end
    end

    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if RaceBikes then
        table.insert(t9, RaceBikes)
    end

    local SafetyCars = workspace:FindFirstChild("SafetyCars")

    if SafetyCars then
        table.insert(t9, SafetyCars)
    end

    v79.FilterDescendantsInstances = t9

    local v82 = Vector3.new(p20.X, p20.Y + 80, p20.Z)

    for _ = 1, 6 do
        local v83 = workspace:Raycast(v82, Vector3.new(0, -200, 0), v79)

        if not v83 then
            break
        end

        if v83.Instance:GetAttribute("Surface") ~= nil then
            t7[p19] = v83.Position.Y
            t8[p19] = v83.Normal.Y > 0.7 and v83.Normal or Vector3.new(0, 1, 0)

            return t7[p19], t8[p19]
        end

        v79:AddToFilter(v83.Instance)
    end

    return nil
end

local function place(p21, p22) -- line: 227
    -- upvalues: v14 (ref), n1 (ref), ground (copy)
    if p21.at == p22 then
        return
    end

    local points = v14.points
    local v85 = points[(p22 + 1 - 1) % n1 + 1] - points[(p22 - 1 - 1) % n1 + 1]
    local v86 = Vector3.new(v85.X, 0, v85.Z)

    if v86.Magnitude < 0.001 then
        return
    end

    local v87, v88 = ground(p22, points[p22])

    if v87 then
        p21.at = p22
    end

    local v89 = v88 or Vector3.new(0, 1, 0)
    local v91 = Vector3.new(points[p22].X, v87 or points[p22].Y, points[p22].Z) + v89 * 0.08
    local v92 = v86 - v89 * v86:Dot(v89)
    local v93 = CFrame.lookAt(v91, v91 + v92, v89)
    local UpVector, RightVector = v93.UpVector, v93.RightVector
    local v94 = -v93.LookVector

    p21.l.CFrame = CFrame.fromMatrix(v91 - RightVector * 1.5, UpVector, -RightVector, v94)
    p21.r.CFrame = CFrame.fromMatrix(v91 + RightVector * 1.5, -UpVector, RightVector, v94)
end

local function setT(p23, p24) -- line: 244
    local v96 = math.floor(p24 * 50 + 0.5) / 50

    if p23.t == v96 then
        return
    end

    p23.t = v96
    p23.l.Transparency = v96
    p23.r.Transparency = v96
end

local function setC(p25, p26) -- line: 251
    if p25.c == p26 then
        return
    end

    p25.c = p26
    p25.l.Color = p26
    p25.r.Color = p26
end

local function slotOf(p27) -- line: 257
    return (p27 - 1) // 3 % 26 + 1
end

local MotoLegends2 = ReplicatedStorage:WaitForChild("MotoLegends")

local function enabled() -- line: 261
    -- upvalues: LocalPlayer (copy), MotoLegends2 (copy)
    local SessionPhase = MotoLegends2:GetAttribute("SessionPhase")

    if SessionPhase == "Grid" or SessionPhase == "Lights" then
        return false
    end

    return LocalPlayer:GetAttribute("ApexAssist") ~= false
end

local function riderSeat() -- line: 268
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v97 = Humanoid and Humanoid.SeatPart

    return if v97 and v97.Name == "RiderSeat" and Humanoid.Health > 0 then v97 else nil
end

local v98

local function locate(p28, p29) -- line: 277
    -- upvalues: v14 (ref), n1 (ref), v98 (ref)
    local points = v14.points
    local v99 = v98 or 1
    local v100

    if p29 or not v98 then
        local v101 = n1

        v100 = 1e999

        for i = 1, v101 do
            local v102 = points[i]
            local v103 = (v102.X - p28.X) ^ 2 + (v102.Z - p28.Z) ^ 2

            if v103 < v100 then
                v100 = v103
                v99 = i
            end
        end
    else
        v100 = 1e999

        for i = -4, 30 do
            local v104 = (v98 + i - 1) % n1 + 1
            local v105 = points[v104]
            local v106 = (v105.X - p28.X) ^ 2 + (v105.Z - p28.Z) ^ 2

            if v106 < v100 then
                v100 = v106
                v99 = v104
            end
        end
    end

    return v99, (math.sqrt(v100))
end

local v107 = false

local function show(p30) -- line: 298
    -- upvalues: Folder (copy), v98 (ref), v107 (ref)
    if p30 == v107 then
        return
    end

    v107 = p30
    Folder.Parent = p30 and workspace or nil

    if not p30 then
        v98 = nil
    end
end

local n6 = 0
local n7 = 0
local v108 = table.create(26, 0)
local v109 = table.create(26, false)

RunService.Heartbeat:Connect(function() -- line: 308
    -- upvalues: result3 (ref), LocalPlayer (copy), v3 (copy), v4 (copy), t1 (copy), v9 (copy), Power (copy), v10 (copy), v14 (ref), n1 (ref), t2 (copy), v16 (ref), n3 (ref), buildProfile (copy), readState (copy), Folder (copy), t5 (copy), place (copy), MotoLegends2 (copy), v98 (ref), locate (copy), v107 (ref), n6 (ref), n7 (ref), v108 (copy), v109 (copy)
    if not v16 then
        return
    end

    local SessionPhase = MotoLegends2:GetAttribute("SessionPhase")
    local v110 = SessionPhase ~= "Grid" and SessionPhase ~= "Lights" and LocalPlayer:GetAttribute("ApexAssist") ~= false
    local v111 = false
    local v112 = false
    local v113 = false
    local v114 = false

    if v110 then
        v111 = true
    end

    local Character, v115

    if v111 then
        Character = LocalPlayer.Character

        if Character then
            v112 = true
        else
            v115 = Character
            v113 = true
        end
    end

    v111 = false

    if v112 then
        v115 = Character:FindFirstChildOfClass("Humanoid")
        v113 = true
    end

    v112 = false

    local v116

    if v113 then
        if v115 then
            v112 = true
        else
            v116 = v115
            v111 = true
        end
    end

    v113 = false

    if v112 then
        v116 = v115.SeatPart
        v111 = true
    end

    v112 = false

    if v111 then
        if v116 then
            v112 = true
        else
            v113 = true
        end
    end

    v111 = false

    if v112 then
        if v116.Name == "RiderSeat" then
            v111 = true
        else
            v113 = true
        end
    end

    v112 = false

    if v111 then
        if v115.Health > 0 then
            v112 = true
        else
            v113 = true
        end
    end

    v111 = false

    if v113 then
        v111 = true
    end

    local v117

    if v112 then
        v117 = v116
        v111 = true
    end

    local v118

    if v111 then
        if v117 then
            v118 = v117
            v114 = true
        else
            v114 = false
        end
    end

    if not v114 then
        v118 = nil
    end

    if v118 then
        local Position = v118.Position
        local elapsed = os.clock()
        local v119, v120 = locate(Position, false)

        if v120 > 60 and n7 <= elapsed then
            n7 = elapsed + 1

            local points = v14.points

            v119 = v98 or 1

            local v121 = n1
            local n8 = 1e999

            for i = 1, v121 do
                local v122 = points[i]
                local v123 = (v122.X - Position.X) ^ 2 + (v122.Z - Position.Z) ^ 2

                if v123 < n8 then
                    n8 = v123
                    v119 = i
                end
            end

            v120 = math.sqrt(n8)
        end

        v98 = v119

        local v124 = v120 < 120

        if v124 ~= v107 then
            v107 = v124
            Folder.Parent = v124 and workspace or nil

            if not v124 then
                v98 = nil
            end
        end

        if v107 then
            local points = v14.points
            local v126 = v98 + 1

            while ((v126 - 1) % n1 + 1 - 1) % 3 ~= 0 do
                v126 += 1
            end

            for i = 1, 26 do
                local v127 = (v126 + (i - 1) * 3 - 1) % n1 + 1

                v108[i] = v127

                local v128 = t5[(v127 - 1) // 3 % 26 + 1]

                place(v128, v127)

                local v129 = points[v127]
                local v136 = math.floor((1 - math.min(math.clamp((math.sqrt((v129.X - Position.X) ^ 2 + (v129.Z - Position.Z) ^ 2) - 10) / 60, 0, 1), (math.clamp((26 - i + 1) / 5, 0, 1))) * 0.9) * 50 + 0.5) / 50

                if v128.t ~= v136 then
                    v128.t = v136
                    v128.l.Transparency = v136
                    v128.r.Transparency = v136
                end
            end

            if not (elapsed < n6) then
                n6 = elapsed + 0.1
                buildProfile((readState(v118:FindFirstAncestorOfClass("Model"), not (result3 and result3.ready and result3.get("abs") == false))))

                local v138 = points[(v98 + 1 - 1) % n1 + 1] - points[v98]
                local v140 = math.max(0, v138.Magnitude > 0 and v118.AssemblyLinearVelocity:Dot(v138.Unit) or 0)
                local v141 = v108[26]
                local n9 = 1
                local v142 = v98
                local v143

                while true do
                    v142 = (v142 + 1 - 1) % n1 + 1
                    v140 = math.min(v10, (math.sqrt(v140 * v140 + 2 * (math.max(0, math.min(v9, Power / math.max(v140, 1)) - (1E-04 * v140 * v140 + 0.025 * v140)) * n3) * t2[1][(v142 - 1 - 1) % n1 + 1])))

                    local v149

                    if v140 <= v16[v142] then
                        v149 = v3
                    else
                        local v150 = v16[v142]

                        v149 = if v150 < v16[(v142 - 1 - 1) % n1 + 1] then v4 else v3
                        v140 = v16[v142]
                    end

                    if v142 == v108[n9] then
                        v109[n9] = v149 == v4
                        v143 = n9 + 1
                    else
                        v143 = n9
                    end

                    if v142 == v141 or v143 > 26 then
                        break
                    end

                    n9 = v143
                end

                for i = v143, 26 do
                    v109[i] = false
                end

                for i = 1, 26 do
                    local v153 = v4

                    if not v109[i] then
                        v153 = v3

                        if v109[i + 1] then
                            v153 = t1[3]
                        elseif v109[i + 2] then
                            v153 = t1[2]
                        elseif v109[i + 3] then
                            v153 = t1[1]
                        end
                    end

                    local v154 = t5[(v108[i] - 1) // 3 % 26 + 1]

                    if v154.c ~= v153 then
                        v154.c = v153
                        v154.l.Color = v153
                        v154.r.Color = v153
                    end
                end
            end
        end
    elseif v107 ~= false then
        v107 = false
        Folder.Parent = nil
        v98 = nil
    end
end)
task.spawn(function() -- line: 386
    -- upvalues: RacingLine (copy), v14 (ref), n1 (ref), v15 (ref), t2 (copy), v16 (ref), circle (copy), v23 (ref), buildProfile (copy), readState (copy)
    v14 = RacingLine.Get()

    if not v14 then
        return
    end

    n1 = v14.n

    local points = v14.points
    local v155 = table.create(n1, 0)
    local v156 = table.create(n1, 0)
    local v157 = table.create(n1, 1)

    for i = 1, n1 do
        local v159 = points[(i - 4 - 1) % n1 + 1]
        local v160 = points[i]
        local v161 = points[(i + 4 - 1) % n1 + 1]

        v155[i] = circle(v159, v160, v161)
        v156[i] = (points[(i + 1 - 1) % n1 + 1] - points[i]).Magnitude
        v157[i] = (v160.Z - v159.Z) * (v161.X - v160.X) - (v160.X - v159.X) * (v161.Z - v160.Z) >= 0 and 1 or -1
    end

    v15 = v155
    t2[1] = v156
    v23 = v157
    v16 = table.create(n1, 0)
    buildProfile((readState(nil, true)))
end)
