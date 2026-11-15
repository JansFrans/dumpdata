-- https://lua.expert

local BikeGearbox = require(script.Parent.Parent.Parent.BikeGearbox)
local t1 = {}
local self = setmetatable({}, {
    __mode = "k"
})
local t4 = {
    {
        name = "R082",
        id = "rbxassetid://96900249756657",
        tone = 81.9049,
        tiles = 4
    },
    {
        name = "R096",
        id = "rbxassetid://75968919941514",
        tone = 95.8759,
        tiles = 4
    },
    {
        name = "R114",
        id = "rbxassetid://74428208089888",
        tone = 113.93,
        tiles = 4
    },
    {
        name = "R125",
        id = "rbxassetid://98096526242734",
        tone = 124.8302,
        tiles = 4
    },
    {
        name = "R135",
        id = "rbxassetid://80941610537867",
        tone = 134.6036,
        tiles = 4
    },
    {
        name = "R141",
        id = "rbxassetid://74356586043200",
        tone = 141.4173,
        tiles = 4
    },
    {
        name = "R149",
        id = "rbxassetid://82767911230819",
        tone = 148.8314,
        tiles = 4
    }
}

local function ease(p1) -- line: 49
    local v2 = math.clamp(p1, 0, 1)

    return v2 * v2 * (3 - 2 * v2)
end

function t1.Mix(p2, p3, p4, p5, p6, p7) -- line: 51
    -- upvalues: BikeGearbox (copy)
    local v3 = math.clamp(p7, 0, 0.1)

    p2.clock = (p2.clock or 0) + v3

    if p2.gear ~= nil and p2.gear ~= p3 then
        p2.shiftStart = p2.clock
        p2.shiftDirection = p2.gear < p3 and 1 or -1
    end

    p2.gear = p3

    local v4 = p2.shiftStart and p2.clock - p2.shiftStart or 99
    local v5 = v4 < 0.12 and math.sin(3.141592653589793 * v4 / 0.12) or 0
    local v7 = math.clamp(p4, BikeGearbox.IdleRPM, BikeGearbox.RedlineRPM)
    local v8 = p2.rpm or v7
    local v9 = if v8 < v7 then 30 elseif not (v4 < 0.4) or p2.shiftDirection ~= 1 then 20 else 60

    p2.rpm = v8 + (v7 - v8) * (1 - math.exp(-v3 * v9))
    p2.throttle = (p2.throttle or 0) + (math.clamp(p5, 0, 1) - (p2.throttle or 0)) * (1 - math.exp(-v3 * 12))

    local v15, v16

    if p3 == 0 or p2.stationary then
        local v18 = math.clamp(p2.throttle / 0.25, 0, 1)
        local v19 = 1 - v18 * v18 * (3 - 2 * v18)

        if v19 then
            v15 = v19
            v16 = true
        else
            v16 = false
        end
    else
        v16 = false
    end

    if not v16 then
        v15 = 0
    end

    p2.idleMix = (p2.idleMix or v15) + (v15 - (p2.idleMix or v15)) * (1 - math.exp(-v3 * 5))

    local v26 = 2.5892857142857144 ^ math.clamp((p2.rpm - BikeGearbox.IdleRPM) / (BikeGearbox.RedlineRPM - BikeGearbox.IdleRPM), 0, 1) * 56 * (math.max((p3 or 1) - 1, 0) * 0.035 + 1)
    local v27 = 1 - (if p2.shiftDirection == 1 then 0.45 else 0.135) * v5
    local v28 = p6 and (0.45 + 0.55 * p2.throttle) * v27 * 3.5 or 0
    local v29 = if p6 then 0.9625000000000001 else 0

    return {
        engineVolume = 0,
        idleVolumeOld = 0,
        enginePitch = 1,
        idlePitch = 1,
        rpm = p2.rpm,
        tone = v26,
        idleness = p2.idleMix,
        driveVolume = v28,
        idleVolume = v29,
        shiftEnvelope = v5
    }
end

function t1.Configure(p8, p9) -- line: 76
    p8.Volume = 0
    p9.Volume = 0
end

function t1.Apply(p10, p11, p12, p13, p14, p15, p16, p17) -- line: 81
    -- upvalues: t1 (copy)
    local v30 = t1.Mix(p10, p13, p14, p15, p16, p17)

    p11.Volume = 0
    p12.Volume = 0

    return v30
end

local t5 = {
    vel = Vector3.new(0, 0, 0)
}

function t1.UpdateListener(p18) -- line: 89
    -- upvalues: t5 (copy)
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    local function v31() -- line: 91
        game:GetService("SoundService").DopplerScale = 0
    end

    pcall(v31)

    local CFramePosition = CurrentCamera.CFrame.Position

    if t5.pos and p18 > 0 then
        local v32 = (CFramePosition - t5.pos) / p18

        if v32.Magnitude > 1500 then
            v32 = t5.vel
        end

        t5.vel = t5.vel:Lerp(v32, 1 - math.exp(-p18 * 10))
    end

    t5.pos = CFramePosition

    local LocalPlayer = game:GetService("Players").LocalPlayer
    local v34 = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("JerezRaceHUD")

    t5.spectating = v34 and v34:GetAttribute("LobbySpectating") == true
    t5.focusId = t5.spectating and v34:GetAttribute("SpectateTargetId") or nil

    local SpectateCamMode = t5.spectating and v34:GetAttribute("SpectateCamMode") or nil

    t5.broadcastCam = SpectateCamMode == 5 or SpectateCamMode == 6
    t5.ownId = LocalPlayer and LocalPlayer.UserId
end

local function dopplerFactor(p19, p20) -- line: 108
    -- upvalues: t5 (copy)
    if not t5.pos then
        return 1
    end

    local v36 = t5.pos - p19.Position
    local Magnitude = v36.Magnitude

    if Magnitude < 2 then
        return 1
    end

    local v37 = v36 / Magnitude
    local v39 = math.clamp((p20 or p19.AssemblyLinearVelocity):Dot(v37), -612.4999999999999, 612.4999999999999)

    return (math.clamp(((1224.9999999999998 - math.clamp(t5.vel:Dot(v37), -612.4999999999999, 612.4999999999999)) / (1224.9999999999998 - v39) - 1) * 1 + 1, 0.65, 1.5))
end

local function newSound(p21, p22, p23, p24, p25) -- line: 118
    local Sound = Instance.new("Sound")

    Sound.Name = p23
    Sound.SoundId = p24
    Sound.Looped = true
    Sound.Volume = 0
    Sound.RollOffMinDistance = p22.RollOffMinDistance
    Sound.RollOffMaxDistance = p22.RollOffMaxDistance
    Sound.RollOffMode = p22.RollOffMode
    Sound.Parent = p21

    local function region() -- line: 123
        -- upvalues: p25 (copy), Sound (copy)
        local TimeLength = Sound.TimeLength

        if not (p25 and p25 >= 3 and TimeLength > 0) then
            return
        end

        Sound.PlaybackRegionsEnabled = true
        Sound.LoopRegion = NumberRange.new(TimeLength / p25, TimeLength * (p25 - 1) / p25)
        Sound.TimePosition = TimeLength / p25
    end

    if Sound.IsLoaded then
        local TimeLength = Sound.TimeLength

        if p25 and p25 >= 3 and TimeLength > 0 then
            Sound.PlaybackRegionsEnabled = true
            Sound.LoopRegion = NumberRange.new(TimeLength / p25, TimeLength * (p25 - 1) / p25)
            Sound.TimePosition = TimeLength / p25
        end
    else
        Sound.Loaded:Once(region)
    end

    Sound:Play()

    return Sound
end

local function setActive(p26, p27, p28) -- line: 138
    if p27 then
        if not p26.IsPlaying then
            if p28.paused then
                p26:Resume()
            else
                p26:Play()
            end
        end

        p28.paused = false
    elseif p26.IsPlaying then
        p26:Pause()
        p28.paused = true
    end
end

function t1.UpdateBike(p29, p30, p31, p32, p33) -- line: 144
    -- upvalues: BikeGearbox (copy), t1 (copy), self (copy), t4 (copy), t5 (copy), dopplerFactor (copy), newSound (copy)
    local PrimaryPart = p29.PrimaryPart

    if not PrimaryPart then
        return
    end

    local v42 = self[p29]

    if not v42 then
        local EngineLoad = PrimaryPart:FindFirstChild("EngineLoad")
        local EngineIdle = PrimaryPart:FindFirstChild("EngineIdle")

        if not EngineLoad or not EngineIdle then
            return
        end

        v42 = {
            engine = EngineLoad,
            idleSound = EngineIdle,
            layers = {}
        }
        self[p29] = v42
        v42.idleLoop = newSound(PrimaryPart, EngineLoad, "Ducati_Idle", "rbxassetid://112957815729262", 3)

        for _, v43 in t4 do
            table.insert(v42.layers, {
                s = newSound(PrimaryPart, EngineLoad, "Ducati_" .. v43.name, v43.id, v43.tiles),
                tone = v43.tone,
                lt = math.log(v43.tone)
            })
        end

        local function v44() -- line: 154
            -- upvalues: p29 (copy), v42 (ref), self (copy)
            v42.idleLoop:Destroy()

            for _, v45 in v42.layers do
                v45.s:Destroy()
            end

            self[p29] = nil
        end

        p29.Destroying:Once(v44)
        p29.AncestryChanged:Connect(function(_, p35) -- line: 156
            -- upvalues: p29 (copy), v42 (ref), self (copy)
            if p35 ~= nil then
                return
            end

            v42.idleLoop:Destroy()

            for _, v46 in v42.layers do
                v46.s:Destroy()
            end

            self[p29] = nil
        end)
    end

    local v47 = p33 or p29:GetAttribute("Gear") or 1
    local RiderSeat = p29:FindFirstChild("RiderSeat")
    local v48 = p29:GetAttribute("Crash") == "" and RiderSeat and RiderSeat.Occupant ~= nil
    local v49 = p32 or p29:GetAttribute("Throttle") or 0
    local v50 = p31 or p29:GetAttribute("EngineRPM") or BikeGearbox.RPM(v47, p29:GetAttribute("SpeedKph") or 0, v49, p29:GetAttribute("TractionSlip") or 0)
    local remoteBikes, Magnitude

    if p31 == nil then
        if t1.remoteBikes == nil then
            local _require = require
            local ParentParent = script.Parent.Parent.Parent
            local ok, result = pcall(_require, ParentParent:FindFirstChild("RemoteBikes"))

            t1.remoteBikes = ok and result or false
        end

        remoteBikes = t1.remoteBikes

        local OwnerUserId = p29:GetAttribute("OwnerUserId")

        remoteBikes = remoteBikes and remoteBikes.Velocity and OwnerUserId and remoteBikes.Velocity(OwnerUserId)

        if typeof(remoteBikes) == "Vector3" then
            Magnitude = remoteBikes.Magnitude
        else
            remoteBikes = nil
        end
    end

    local SpeedKph = p29:GetAttribute("SpeedKph")
    local v53 = math.max(Magnitude or 0, PrimaryPart.AssemblyLinearVelocity.Magnitude) * 0.28 * 3.6 < 2 and not (typeof(SpeedKph) == "number" and SpeedKph >= 2)

    v42.stationary = v53

    local v54

    if (p29:GetAttribute("Crash") or "") == "" then
        v54 = 1
    else
        local v55 = math.max(BikeGearbox.IdleRPM, p29:GetAttribute("CrashAudioRPM") or v42.rpm or v50)
        local v57 = math.max(0, workspace:GetServerTimeNow() - (p29:GetAttribute("CrashAudioStartedAt") or workspace:GetServerTimeNow()))
        local v58 = (v55 - BikeGearbox.IdleRPM) / 5500

        v50 = math.max(BikeGearbox.IdleRPM, v55 - v57 * 5500)
        v47 = math.max(v47, 1)

        local v60 = v42

        v60.idleMix = 0
        v60.stationary = false

        if v58 + 0.2 <= v57 then
            local IdleRPM = BikeGearbox.IdleRPM

            v42.rpm = IdleRPM
        end

        v54 = 1 - math.clamp((v57 - v58 - 0.2) / 0.4, 0, 1)
        v48 = v54 > 0
        v49 = 0
    end

    local v62 = t1.Apply(v42, v42.engine, v42.idleSound, v47, v50, v49, v48, p30)

    v62.driveVolume *= v54
    v62.idleVolume *= v54

    local OwnerUserId = p29:GetAttribute("OwnerUserId")
    local v63 = p31 ~= nil or OwnerUserId ~= nil and (OwnerUserId == t5.ownId or OwnerUserId == t5.focusId)
    local v64

    if v63 then
        v64 = v63
    else
        v64 = not t5.pos or (t5.pos - PrimaryPart.Position).Magnitude <= v42.engine.RollOffMaxDistance + 25

        if not t5.spectating then
            v62.driveVolume *= 0.45
            v62.idleVolume *= 0.45
        end
    end

    local v65

    if p31 == nil and (not v63 or t5.broadcastCam) then
        if not remoteBikes then
            local elapsed = os.clock()
            local PrimaryPartPosition = PrimaryPart.Position

            if v42.fdPos and v42.fdT < elapsed then
                local v66 = (PrimaryPartPosition - v42.fdPos) / (elapsed - v42.fdT)

                if v66.Magnitude < 1500 then
                    local v67 = (v42.fdVel or v66):Lerp(v66, 0.35)

                    v42.fdVel = v67
                end
            end

            local v68 = v42

            v68.fdPos = PrimaryPartPosition
            v68.fdT = elapsed

            local AssemblyLinearVelocity = PrimaryPart.AssemblyLinearVelocity
            local v69, v70

            if v42.fdVel and v42.fdVel.Magnitude > AssemblyLinearVelocity.Magnitude then
                local fdVel = v42.fdVel

                if fdVel then
                    v69 = fdVel
                    v70 = true
                else
                    v70 = false
                end
            else
                v70 = false
            end

            if not v70 then
                v69 = AssemblyLinearVelocity
            end

            remoteBikes = v69
        end

        local v71 = dopplerFactor(PrimaryPart, remoteBikes)
        local v75 = (v42.doppler or v71) + (v71 - (v42.doppler or v71)) * (1 - math.exp(-math.clamp(p30, 0, 0.1) * 8))

        v42.doppler = v75
        v65 = v42.doppler
    else
        v65 = 1
        v42.doppler = 1
    end

    local v76 = p31 == nil
    local SoundService = if not v76 then game:GetService("SoundService") else nil

    if not v76 and SoundService then
        PrimaryPart = SoundService
    end

    if v42.home ~= PrimaryPart then
        v42.home = PrimaryPart
        v42.idleLoop.Parent = PrimaryPart

        for _, v77 in v42.layers do
            v77.s.Parent = PrimaryPart
        end
    end

    local idleness = v62.idleness

    v42.idleRec = v42.idleRec or {}

    if v48 then
        local idleLoop = v42.idleLoop
        local v78 = v64 and (v63 or idleness > 5E-04)
        local idleRec = v42.idleRec

        if v78 then
            if not idleLoop.IsPlaying then
                if idleRec.paused then
                    idleLoop:Resume()
                else
                    idleLoop:Play()
                end
            end

            idleRec.paused = false
        elseif idleLoop.IsPlaying then
            idleLoop:Pause()
            idleRec.paused = true
        end
    else
        v42.idleLoop:Stop()
        v42.idleRec.paused = false
    end

    v42.idleLoop.Volume = math.sqrt(idleness) * v62.idleVolume
    v42.idleLoop.PlaybackSpeed = v65

    local v79 = math.log(v62.tone)
    local v80 = #v42.layers

    for v81, v82 in v42.layers do
        local v83

        if v81 == 1 and v79 <= v82.lt or v81 == v80 and v82.lt <= v79 then
            v83 = 1
        else
            local v84 = v42
            local v85 = v84.layers[v81 - 1]
            local v86 = v84.layers[v81 + 1]

            v83 = if v79 <= v82.lt and v85 then math.sin(math.clamp((v79 - v85.lt) / (v82.lt - v85.lt), 0, 1) * 3.141592653589793 / 2) elseif v82.lt < v79 and v86 then math.cos(math.clamp((v79 - v82.lt) / (v86.lt - v82.lt), 0, 1) * 3.141592653589793 / 2) else 0
        end

        if v48 then
            local s = v82.s

            if v64 and (v63 or v83 > 0) then
                if not s.IsPlaying then
                    if v82.paused then
                        s:Resume()
                    else
                        s:Play()
                    end
                end

                v82.paused = false
            elseif s.IsPlaying then
                s:Pause()
                v82.paused = true
            end
        else
            v82.s:Stop()
            v82.paused = false
        end

        v82.s.PlaybackSpeed = v62.tone / v82.tone * v65
        v82.s.Volume = v83 * math.sqrt(1 - idleness) * v62.driveVolume
    end

    return v62
end

return t1
