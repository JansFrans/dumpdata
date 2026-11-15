-- https://lua.expert

local Track = require(game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends"):WaitForChild("Config")).Track
local Layout = require(script.Parent.Tracks[Track].Layout)
local v1 = Layout.StudMetres or 0.28
local t1 = {}

t1.LimitKph = 72

local v2 = (Layout.RoadWidthMetres or 13.2) / v1 / 2
local v3, v4

if Layout.PitLane and Layout.PitLane.paths[1] then
    local points = Layout.PitLane.paths[1].points

    if points then
        v3 = points
        v4 = true
    else
        v4 = false
    end
else
    v4 = false
end

if not v4 then
    v3 = {}
end

local Points = Layout.Points

local function key(p1, p2) -- line: 13
    return math.floor(p1 / 60) * 100003 + math.floor(p2 / 60)
end

local function flatDist(p3, p4) -- line: 14
    local v8 = p3.X - p4.X
    local v9 = p3.Z - p4.Z

    return (math.sqrt(v8 * v8 + v9 * v9))
end

local t2 = {}

for v11, v12 in Points do
    local X, Z = v12.X, v12.Z
    local v16 = math.floor(X / 60) * 100003 + math.floor(Z / 60)

    t2[v16] = t2[v16] or {}
    table.insert(t2[v16], v11)
end

local function trackDist(p5) -- line: 17
    -- upvalues: Points (copy), t2 (copy)
    local v19 = math.floor(p5.X / 60)
    local v21 = math.floor(p5.Z / 60)
    local n1 = 1e999

    for i = -2, 2 do
        for j = -2, 2 do
            local v22 = t2[(v19 + i) * 100003 + v21 + j]

            if v22 then
                for _, v24 in v22 do
                    local v25 = Points[v24]
                    local v26 = v25.X - p5.X
                    local v27 = v25.Z - p5.Z
                    local v29 = math.sqrt(v26 * v26 + v27 * v27)

                    if v29 < n1 then
                        n1 = v29
                    end
                end
            end
        end
    end

    return n1
end

t1.TrackDistance = trackDist

local t3 = {}
local t4 = {}

for v30, v31 in v3 do
    t3[v30] = trackDist(v31) > v2 + 22

    local X, Z = v31.X, v31.Z
    local v35 = math.floor(X / 60) * 100003 + math.floor(Z / 60)

    t4[v35] = t4[v35] or {}
    table.insert(t4[v35], v30)
end

local v38, v39

for i = 1, #v3 do
    if t3[i] then
        v39 = i
        v38 = v38 or i
    end
end

if v38 then
    for i = v38, v39 do
        t3[i] = true
    end
end

t1.ZoneRange = {
    v38 or 0,
    v39 or 0
}

local t5 = {
    Lusail = {
        entry = Vector3.new(898.34, 0, 1502.928),
        exit = Vector3.new(-436.495, 0, -890.166)
    },
    Jerez = {
        entry = Vector3.new(350.765, 0, 1492.83),
        exit = Vector3.new(-430.524, 0, -898.616)
    },
    Mandalika = {
        entry = Vector3.new(-1264.731, 1.339, -105.371),
        exit = Vector3.new(863.684, -0.001, -351.103)
    },
    Mugello = {
        entry = Vector3.new(-430.649, 0, 1155.15),
        exit = Vector3.new(345.125, 0, -584.105)
    },
    Sepang = {
        entry = Vector3.new(1462.647, 0, -259.182),
        exit = Vector3.new(-798.368, 0, -13.577)
    }
}
local t6 = {
    0
}

for i = 2, #v3 do
    local v40 = t6[i - 1]
    local v41 = v3[i]
    local v42 = v3[i - 1]
    local v43 = v41.X - v42.X
    local v44 = v41.Z - v42.Z

    t6[i] = v40 + math.sqrt(v43 * v43 + v44 * v44)
end

local function arcAt(p6, p7) -- line: 53
    -- upvalues: t6 (copy), v3 (ref)
    local v46 = t6[p7] or 0
    local v47 = v3[p7]
    local v49 = math.max(1, p7 - 2)
    local v52 = math.min(#v3 - 1, p7 + 1)
    local n2 = 1e999

    for i = v49, v52 do
        local v53 = v3[i]
        local v54 = v3[i + 1]
        local v57 = Vector3.new(v54.X - v53.X, 0, v54.Z - v53.Z)
        local v60 = Vector3.new(p6.X - v53.X, 0, p6.Z - v53.Z)
        local v61 = v57:Dot(v57)

        if v61 > 0 then
            local v63 = math.clamp(v60:Dot(v57) / v61, 0, 1)
            local Magnitude = (v60 - v57 * v63).Magnitude

            if Magnitude < n2 then
                n2 = Magnitude
                v46 = t6[i] + math.sqrt(v61) * v63
                v47 = v53 + v57 * v63
            end
        end
    end

    return v46, n2, v47
end

local function nearestPit(p8) -- line: 62
    -- upvalues: v3 (ref)
    local n3 = 1e999
    local v64

    for v65, v66 in v3 do
        local v67 = v66.X - p8.X
        local v68 = v66.Z - p8.Z
        local v70 = math.sqrt(v67 * v67 + v68 * v68)

        if v70 < n3 then
            n3 = v70
            v64 = v65
        end
    end

    return v64
end

local v71, v72, v73, v74
local v75 = t5[Track]
local v76, v77, v78, v79

if not (v75 and #v3 > 1) then
    if v38 then
        v76 = t6[v38]
        v71 = v76
        v77 = t6[v39]
        v72 = v77
    end
else
    local v80 = arcAt(v75.entry, (nearestPit(v75.entry)))

    v71 = v80
    v79 = arcAt(v75.exit, (nearestPit(v75.exit)))
    v72 = v79
    v73 = v80
    v74 = v79

    if v79 < v80 then
        v77 = v80
        v72 = v80
        v71 = v79
        v76 = v79
    else
        v77 = v79
        v76 = v80
    end

    v78 = v80
end

t1.ZoneArc = {
    v76 or 0,
    v77 or 0
}

local v82 = ({
    Mandalika = 72,
    Sepang = 80,
    Lusail = 80,
    Mugello = 62
})[Track] or 40
local v84 = math.ceil(math.max(40, v82) / 60) + 1
local v85 = (Layout.PitLane and Layout.PitLane.widthMetres or 7) / v1 / 2 + 1.2 / v1
local v86

local function behindPitWall(p9, p10) -- line: 87
    -- upvalues: Track (copy), v86 (ref)
    if v86 == nil then
        local v87 = workspace:FindFirstChild(Track)
        local RaceCollision = v87 and v87:FindFirstChild("RaceCollision")
        local Barriers = RaceCollision and RaceCollision:FindFirstChild("Barriers")

        if not (Barriers and Barriers:FindFirstChild("PitWall")) then
            if not v87 then
                return nil
            end

            v86 = false
        else
            v86 = RaycastParams.new()

            local v88 = v86

            v88.FilterType = Enum.RaycastFilterType.Include

            local v89 = v86

            v89.FilterDescendantsInstances = { Barriers }
        end
    end

    if not v86 then
        return nil
    end

    local v92 = Vector3.new(p10.X - p9.X, 0, p10.Z - p9.Z)

    if v92.Magnitude < 0.5 then
        return false
    end

    return workspace:Raycast(Vector3.new(p9.X, p9.Y + 1, p9.Z), v92, v86) ~= nil
end

local function locate(p11) -- line: 99
    -- upvalues: v2 (copy), trackDist (copy), t4 (copy), arcAt (copy), v71 (ref), v72 (ref), v82 (copy), v84 (copy), v85 (copy), behindPitWall (copy), v3 (ref)
    if not v71 then
        return false
    end

    local v95 = math.floor(p11.X / 60)
    local v97 = math.floor(p11.Z / 60)
    local v98 = -v84
    local n4 = 1e999
    local v99

    for i = v98, v84 do
        for j = -v84, v84 do
            local v100 = t4[(v95 + i) * 100003 + v97 + j]

            if v100 then
                for _, v103 in v100 do
                    local v104 = v3[v103]
                    local v105 = v104.X - p11.X
                    local v106 = v104.Z - p11.Z
                    local v108 = math.sqrt(v105 * v105 + v106 * v106)

                    if v108 < n4 then
                        n4 = v108
                        v99 = v103
                    end
                end
            end
        end
    end

    if not v99 or math.max(40, v82) + 6 < n4 then
        return false
    end

    local v109, v110, v111 = arcAt(p11, v99)

    if v82 < v110 or v110 > 40 and trackDist(p11) < trackDist(v111) or v109 < v71 or v72 < v109 then
        return false
    end

    local v112 = trackDist(p11)

    if v112 < trackDist(v111) then
        local v113 = behindPitWall(p11, v111)

        if v113 == true or v113 == nil and v85 < v110 then
            return false
        end
    end

    return v2 + 2 < v112, v109
end

function t1.Contains(p12) -- line: 116
    -- upvalues: locate (copy)
    return (locate(p12))
end

local v114, v115

if v78 and v79 then
    local v117 = math.abs(v79 - v78)

    if v117 then
        v114 = v117
        v115 = true
    else
        v115 = false
    end
else
    v115 = false
end

t1.Length = if not v115 then nil else v114

function t1.Progress(p13) -- line: 120
    -- upvalues: v73 (ref), v74 (ref), locate (copy)
    if v73 then
        local v118, v119 = locate(p13)

        if v118 and v119 then
            return (v119 - v73) * (if v74 >= v73 then 1 else -1)
        end
    end

    return nil
end

return t1
