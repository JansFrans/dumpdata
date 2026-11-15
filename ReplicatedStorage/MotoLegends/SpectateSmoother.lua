-- https://lua.expert

local t2 = {
    SendRate = 30,
    MinDelay = 0.07,
    MaxDelay = 0.35,
    DelayMargin = 0.02,
    MaxExtrapolation = 0.5,
    ExtrapolationFade = 3,
    RawMaxExtrapolation = 0.25,
    StaleSeconds = 1,
    MaxCorrectionFraction = 0.35,
    MaxCorrectionBase = 30,
    HardSnapStuds = 300,
    CorrectionResponse = 8,
    TeleportStuds = 150,
    BufferSeconds = 1.5,
    MaxTimeWarp = 0.03,
    OffsetWindow = 3,
    LeadEnabled = true,
    MaxLead = 0.35,
    LeadResponse = 2,
    LeadSmooth = 6,
    LeadDropResponse = 10,
    MinClockRate = 0.4,
    MaxClockRate = 1.25,
    ClockRateSpan = 0.5,
    ClockRateResponse = 0.15
}
local t1 = {}

t1.Settings = t2

local function hermite(p1, p2, p3) -- line: 60
    local v1 = p2.t - p1.t

    if v1 <= 1E-04 then
        return p2.cf, p2.vel
    end

    local v3 = math.clamp((p3 - p1.t) / v1, 0, 1)
    local v4 = v3 * v3
    local v5 = v4 * v3
    local cfPosition = p1.cf.Position
    local cfPosition2 = p2.cf.Position
    local v6 = cfPosition * (v5 * 2 - v4 * 3 + 1) + p1.vel * ((v5 - v4 * 2 + v3) * v1) + cfPosition2 * (v5 * -2 + v4 * 3) + p2.vel * ((v5 - v4) * v1)
    local v7 = cfPosition * ((v4 * 6 - v3 * 6) / v1) + p1.vel * (v4 * 3 - v3 * 4 + 1) + cfPosition2 * ((v3 * 6 - v4 * 6) / v1) + p2.vel * (v4 * 3 - v3 * 2)

    return CFrame.new(v6) * p1.cf.Rotation:Lerp(p2.cf.Rotation, v3), v7
end

local function project(p4, p5, p6, p7) -- line: 74
    p6 = p6 or 0

    local v9 = Vector3.new(p5.X, 0, p5.Z)
    local v10

    if math.abs(p6) > 0.001 then
        local v11 = (Vector3.new(0, 1, 0)):Cross(v9)

        v10 = v9 * (math.sin(p6 * p7) / p6) + v11 * ((1 - math.cos(p6 * p7)) / p6)
    else
        v10 = v9 * p7
    end

    local v16 = v10 + Vector3.new(0, p5.Y * p7, 0)

    return CFrame.new(p4.Position + v16) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), p6 * p7) * p4.Rotation
end

t1.Project = project

local function extrapolate(p8, p9) -- line: 89
    -- upvalues: t2 (copy), project (copy)
    local v18 = math.max(p9 - p8.t, 0)
    local v19

    if not (t2.MaxExtrapolation < v18) then
        v19 = 1

        return project(p8.cf, p8.vel, p8.turn, v18), p8.vel * v19
    end

    local v20 = v18 - t2.MaxExtrapolation
    local ExtrapolationFade = t2.ExtrapolationFade

    v19 = math.exp(-v20 * ExtrapolationFade)
    v18 = t2.MaxExtrapolation + (1 - v19) / ExtrapolationFade

    return project(p8.cf, p8.vel, p8.turn, v18), p8.vel * v19
end

local function decayCapped(p10, p11, p12, p13) -- line: 101
    -- upvalues: t2 (copy)
    local v22 = p10 * p11
    local v23 = p13 * (t2.MaxCorrectionFraction * p12 + t2.MaxCorrectionBase)
    local Magnitude = v22.Magnitude

    if v23 < Magnitude and Magnitude > 0 then
        v22 *= v23 / Magnitude
    end

    return p10 - v22
end

local t3 = {}

t3.__index = t3

function t1.New() -- line: 110
    -- upvalues: t3 (copy)
    local self = setmetatable({}, t3)

    self:Reset()

    return self
end

function t3.Reset(p14) -- line: 112
    -- upvalues: t2 (copy)
    p14.buf = {}
    p14.base = nil
    p14.jitter = 0
    p14.offs = {}
    p14.interval = 1 / t2.SendRate
    p14.delay = t2.MinDelay + 1 / t2.SendRate
    p14.renderStamp = nil
    p14.lastArrival = nil
    p14.lastStamp = nil
    p14.offsetPos = Vector3.new(0, 0, 0)
    p14.offsetRot = CFrame.identity
    p14.lastOut = nil
    p14.lastSource = nil
    p14.lastAnchor = nil
    p14.lastExtrapolated = false
    p14.written = nil
    p14.lastRaw = nil
    p14.lastRawVel = nil
    p14.realRaw = nil
    p14.realRawVel = nil
    p14.rawAge = 0
    p14.lead = 0
    p14.leadOff = Vector3.new(0, 0, 0)
    p14.leadYaw = 0
    p14.rate = 1
end

local function measureRate(p15) -- line: 123
    -- upvalues: t2 (copy)
    local v25 = #p15

    if v25 < 8 or p15[v25][1] - p15[1][1] < t2.ClockRateSpan then
        return nil
    end

    local n1 = 0
    local n2 = 0

    for _, v26 in p15 do
        n1 += v26[1]
        n2 += v26[3]
    end

    local v27 = n1 / v25
    local v28 = n2 / v25
    local n3 = 0
    local n4 = 0

    for _, v29 in p15 do
        local v30 = v29[1] - v27

        n3 += v30 * (v29[3] - v28)
        n4 += v30 * v30
    end

    return if not (n4 <= 1E-09) then n3 / n4 else nil
end

function t3.Push(p16, p17, p18, p19, p20, p21) -- line: 136
    -- upvalues: t2 (copy), measureRate (copy)
    p21 = p21 or os.clock()

    if typeof(p17) ~= "number" or p17 ~= p17 or typeof(p18) ~= "CFrame" or typeof(p19) ~= "Vector3" or p16.lastStamp and p17 <= p16.lastStamp then
        return
    end

    local v32 = p16.buf[#p16.buf]

    if v32 and (p18.Position - (v32.cf.Position + v32.vel * (p17 - v32.t))).Magnitude > t2.TeleportStuds then
        table.clear(p16.buf)
        table.clear(p16.offs)
        p16.base = nil
        p16.renderStamp = nil
        p16.offsetPos = Vector3.new(0, 0, 0)
        p16.offsetRot = CFrame.identity
        p16.lastOut = nil
        p16.leadOff = Vector3.new(0, 0, 0)
        p16.leadYaw = 0
        p16.lead = 0
    end

    if p16.lastStamp then
        local v33 = p17 - p16.lastStamp

        if v33 > 0 and v33 < 0.5 then
            if p16.interval < v33 then
                p16.interval += (v33 - p16.interval) * 0.6
            else
                p16.interval += (v33 - p16.interval) * 0.04
            end
        end
    end

    p16.lastStamp = p17
    p16.lastArrival = p21

    local offs = p16.offs

    table.insert(offs, {
        p21,
        0,
        p17
    })

    while #offs > 1 and offs[1][1] < p21 - t2.OffsetWindow do
        table.remove(offs, 1)
    end

    local v34 = measureRate(offs)

    if v34 then
        p16.rate = p16.rate + (math.clamp(v34, t2.MinClockRate, t2.MaxClockRate) - p16.rate) * t2.ClockRateResponse
    end

    local rate = p16.rate
    local n5 = 1e999

    for _, v35 in offs do
        local v36 = v35[1] * rate - v35[3]

        v35[2] = v36

        if v36 < n5 then
            n5 = v36
        end
    end

    local v37 = p21 * rate - p17

    p16.base = n5

    local v39 = math.min(v37 - n5, 0.5)

    if p16.jitter < v39 then
        p16.jitter = v39
    else
        p16.jitter += (v39 - p16.jitter) * 0.006
    end

    local v40 = 0

    if v32 and p17 - v32.t > 0.001 then
        local v41 = Vector2.new(v32.vel.X, v32.vel.Z)
        local v42 = Vector2.new(p19.X, p19.Z)

        if v41.Magnitude > 5 and v42.Magnitude > 5 then
            local v45 = math.atan2(-v41.X, -v41.Y)
            local v48 = (math.atan2(-v42.X, -v42.Y) - v45 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

            v40 = (v32.turn or 0) + (math.clamp(v48 / (p17 - v32.t), -4, 4) - (v32.turn or 0)) * 0.5
        end
    end

    table.insert(p16.buf, {
        t = p17,
        cf = p18,
        vel = p19,
        ang = if typeof(p20) ~= "Vector3" or not p20 then Vector3.new(0, 0, 0) else p20,
        turn = v40
    })

    while #p16.buf > 2 and p16.buf[1].t < p17 - t2.BufferSeconds and (not p16.renderStamp or p16.buf[2].t <= p16.renderStamp) do
        table.remove(p16.buf, 1)
    end
end

function t3._sample(p22, p23, p24) -- line: 190
    -- upvalues: t2 (copy), hermite (copy), project (copy)
    local buf = p22.buf
    local v51 = #buf
    local delay, v52, v53, v54, v55

    if v51 == 0 then
        v55 = true
    elseif not p22.lastArrival or p24 - p22.lastArrival > t2.StaleSeconds then
        v55 = true
    else
        local v57 = math.clamp(p22.interval + p22.jitter + t2.DelayMargin, t2.MinDelay, t2.MaxDelay)

        delay = p22.delay
        v52 = v57 - p22.delay
        v53 = -p23
        v54 = if p22.delay < v57 then 4 else 0.5
        v55 = false
    end

    if v55 then
        return nil
    end

    p22.delay = delay + v52 * (1 - math.exp(v53 * v54))

    local v59 = p22.rate or 1
    local v60 = p24 * v59 - p22.base - p22.delay
    local renderStamp = p22.renderStamp
    local v61 = if renderStamp then math.abs(v60 - p22.renderStamp) > 0.5 else nil

    if not renderStamp or v61 then
        p22.renderStamp = v60
    else
        local v63 = p22.renderStamp + p23 * v59

        p22.renderStamp = v63 + math.clamp(v60 - v63, -p23 * t2.MaxTimeWarp, p23 * t2.MaxTimeWarp)
    end

    local renderStamp2 = p22.renderStamp

    if renderStamp2 <= buf[1].t then
        return buf[1].cf, buf[1].vel, false, buf[1], buf[1].turn, buf[1].vel
    end

    for i = v51 - 1, 1, -1 do
        if buf[i].t <= renderStamp2 then
            if renderStamp2 < buf[i + 1].t then
                local v67 = buf[i]
                local v68 = buf[i + 1]
                local v69, v70 = hermite(v67, v68, renderStamp2)
                local v74 = math.clamp((renderStamp2 - v67.t) / math.max(v68.t - v67.t, 1E-04), 0, 1)

                return v69, v70, false, v68, (v67.turn or 0) + ((v68.turn or 0) - (v67.turn or 0)) * v74, v67.vel:Lerp(v68.vel, v74)
            end

            break
        end
    end

    local v75 = buf[v51]
    local v77 = math.max(renderStamp2 - v75.t, 0)
    local v78

    if t2.MaxExtrapolation < v77 then
        local v79 = v77 - t2.MaxExtrapolation
        local ExtrapolationFade = t2.ExtrapolationFade

        v78 = math.exp(-v79 * ExtrapolationFade)
        v77 = t2.MaxExtrapolation + (1 - v78) / ExtrapolationFade
    else
        v78 = 1
    end

    local v81 = project(v75.cf, v75.vel, v75.turn, v77)
    local v82 = v75.vel * v78

    return v81, v82, true, buf[v51], buf[v51].turn, v82
end

function t3.Resolve(p25, p26, p27, p28, p29, p30) -- line: 225
    -- upvalues: t2 (copy), project (copy)
    local v83, v84, v85, v86, v87, v88 = p25:_sample(p28, p29 or os.clock())
    local v89

    if v83 then
        v89 = "snap"
    else
        v89 = "raw"
        v83 = p26
        v84 = p27
    end

    local lastOut = p25.lastOut

    if lastOut and (v83.Position - lastOut.Position).Magnitude > t2.HardSnapStuds then
        p25.offsetPos = Vector3.new(0, 0, 0)
        p25.offsetRot = CFrame.identity
        p25.leadOff = Vector3.new(0, 0, 0)
        lastOut = nil
        p25.leadYaw = 0
    end

    if lastOut then
        if v89 == p25.lastSource then
            local lastAnchor, v90, v91

            if v89 == "snap" and p25.lastExtrapolated and v86 ~= p25.lastAnchor and p25.lastAnchor then
                lastAnchor = p25.lastAnchor
                v90 = math.max(p25.renderStamp - lastAnchor.t, 0)

                if t2.MaxExtrapolation < v90 then
                    local v93 = v90 - t2.MaxExtrapolation
                    local ExtrapolationFade = t2.ExtrapolationFade

                    v91 = math.exp(-v93 * ExtrapolationFade)
                    v90 = t2.MaxExtrapolation + (1 - v91) / ExtrapolationFade
                else
                    v91 = 1
                end

                local v95 = project(lastAnchor.cf, lastAnchor.vel, lastAnchor.turn, v90)
                local _ = lastAnchor.vel * v91

                p25.offsetPos += v95.Position - v83.Position
                p25.offsetRot = p25.offsetRot * v95.Rotation * v83.Rotation:Inverse()
            end
        else
            p25.offsetPos = lastOut.Position + v84 * p28 - v83.Position
            p25.offsetRot = lastOut.Rotation * v83.Rotation:Inverse()
        end
    end

    local v97 = 1 - math.exp(-p28 * t2.CorrectionResponse)
    local Magnitude = v84.Magnitude
    local offsetPos = p25.offsetPos
    local v98 = offsetPos * v97
    local v99 = p28 * (t2.MaxCorrectionFraction * Magnitude + t2.MaxCorrectionBase)
    local Magnitude2 = v98.Magnitude

    if v99 < Magnitude2 and Magnitude2 > 0 then
        v98 *= v99 / Magnitude2
    end

    p25.offsetPos = offsetPos - v98
    p25.offsetRot = p25.offsetRot:Lerp(CFrame.identity, v97)

    if p25.offsetPos.Magnitude < 0.001 then
        p25.offsetPos = Vector3.new(0, 0, 0)
    end

    local v100 = CFrame.new(v83.Position + p25.offsetPos) * (p25.offsetRot * v83.Rotation)

    p25.lastOut = v100
    p25.lastSource = v89
    p25.lastAnchor = v86
    p25.lastExtrapolated = v85 == true

    local v101 = v89 == "snap"
    local v102, v103

    if t2.LeadEnabled and v101 then
        local v105 = math.clamp(p30 or 0, 0, t2.MaxLead)

        if v105 then
            v102 = v105
            v103 = true
        else
            v103 = false
        end
    else
        v103 = false
    end

    if not v103 then
        v102 = 0
    end

    p25.lead = p25.lead + (v102 - p25.lead) * (1 - math.exp(-p28 * (v101 and t2.LeadResponse or t2.LeadDropResponse)))

    if p25.lead < 0.001 then
        p25.lead = 0
    end

    local v108, v109

    if p25.lead > 0 then
        local v110 = v89 == "snap" and v87 or 0

        if v89 ~= "snap" or not v88 then
            v88 = v84
        end

        v108 = project(v100, v88, v110, p25.lead).Position - v100.Position
        v109 = v110 * p25.lead
    else
        v108 = Vector3.new(0, 0, 0)
        v109 = 0
    end

    local v112 = 1 - math.exp(-p28 * (v101 and t2.LeadSmooth or t2.LeadDropResponse))
    local v113 = p25.leadOff - v108
    local v114 = v113 * v112
    local v115 = p28 * (t2.MaxCorrectionFraction * Magnitude + t2.MaxCorrectionBase)
    local Magnitude3 = v114.Magnitude

    if v115 < Magnitude3 and Magnitude3 > 0 then
        v114 *= v115 / Magnitude3
    end

    p25.leadOff = v108 + (v113 - v114)
    p25.leadYaw += (v109 - p25.leadYaw) * v112

    if p25.lead > 0 or p25.leadOff.Magnitude > 0.01 then
        v100 = CFrame.new(v100.Position + p25.leadOff) * CFrame.fromAxisAngle(Vector3.new(0, 1, 0), p25.leadYaw) * v100.Rotation
    end

    return v100, v84, v89 == "snap"
end

function t3.Apply(p31, p32, p33, p34) -- line: 277
    -- upvalues: t2 (copy)
    local CFrame = p32.CFrame
    local realRawVel

    if p31.written and CFrame == p31.written and p31.realRaw then
        p31.rawAge = (p31.rawAge or 0) + p33

        local v116 = math.min(p31.rawAge, t2.RawMaxExtrapolation)

        CFrame = p31.realRaw + p31.realRawVel * v116
        realRawVel = p31.rawAge < t2.RawMaxExtrapolation and p31.realRawVel or Vector3.new(0, 0, 0)
    else
        realRawVel = p32.AssemblyLinearVelocity
        p31.realRaw = CFrame
        p31.realRawVel = realRawVel
        p31.rawAge = 0
    end

    p31.lastRaw = CFrame
    p31.lastRawVel = realRawVel

    local v118, v119, v120 = p31:Resolve(CFrame, realRawVel, p33, nil, p34)

    if not v120 and not (p31.offsetPos.Magnitude > 0.01) and not (p31.lead > 0) and not (p31.leadOff.Magnitude > 0.01) then
        p31.written = nil

        return v118, v119, v120
    end

    p32.CFrame = v118
    p31.written = p32.CFrame

    return v118, v119, v120
end

function t3.Release(p35) -- line: 300
    p35:Reset()
end

return t1
