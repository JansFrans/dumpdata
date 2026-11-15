-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Prompt = require(Modules.Prompt)

require(Modules.Objects.Task)
game:GetService("EncodingService")
game:GetService("Players")

local RunService = game:GetService("RunService")
local getAnimator = require(Modules.PlayerUtil.getAnimator)
local getHRP = require(Modules.PlayerUtil.getHRP)
local t1 = {}

local function setTorsoSoundSpeed(p1, p2) -- line: 15
    -- upvalues: getHRP (copy)
    local v1 = getHRP(p1)
    local HDTorsoSound = v1 and v1:FindFirstChild("HDTorsoSound")

    if HDTorsoSound and HDTorsoSound:IsA("Sound") then
        HDTorsoSound.PlaybackSpeed = (p2 - 1) / 2 + 1 or 1
    end
end

local function playAnimation(p3, p4, p5, p6) -- line: 25
    -- upvalues: Modules (copy), RunService (copy), getAnimator (copy), getHRP (copy)
    p5 = p5 or 1

    local v3, v4 = require(Modules.PlayerUtil.loadTrack)(p3, p4)

    if not (v3 and v4) then
        return nil, nil
    end

    local v5 = if p6 then 98 else 99
    local v6 = p6 == true

    v3.Looped = v6
    v3.Priority = Enum.AnimationPriority.Core
    v3:Play(1, v5, p5)

    local v7 = getHRP(p3)
    local HDTorsoSound = v7 and v7:FindFirstChild("HDTorsoSound")

    if HDTorsoSound and HDTorsoSound:IsA("Sound") then
        HDTorsoSound.PlaybackSpeed = (p5 - 1) / 2 + 1 or 1
    end

    v4:SetAttribute("HDSpeed", p5)
    v4:GetAttributeChangedSignal("HDSpeed"):Connect(function() -- line: 39
        -- upvalues: p3 (copy), v3 (copy), v4 (copy), getHRP (copy)
        local HDSpeed = v4:GetAttribute("HDSpeed")

        if typeof(HDSpeed) ~= "number" then
            return
        end

        v3:AdjustSpeed(HDSpeed)

        local v8 = getHRP(p3)
        local HDTorsoSound = v8 and v8:FindFirstChild("HDTorsoSound")

        if HDTorsoSound and HDTorsoSound:IsA("Sound") then
            HDTorsoSound.PlaybackSpeed = (HDSpeed - 1) / 2 + 1 or 1
        end
    end)

    local v9 = getAnimator(p3)

    if not v6 and v9 then
        local Length

        for _ = 1, 200 do
            Length = v3.Length

            if Length and Length > 0 then
                break
            end

            task.wait(0.02)
        end

        local n1 = 1

        if not Length or Length <= 0 then
            n1 = 0
        end

        local TrackCount = v4:GetAttribute("TrackCount")

        if typeof(TrackCount) ~= "number" then
            TrackCount = 0
        end

        v4:SetAttribute("TrackCount", TrackCount + 1)

        local function finishUp() -- line: 67
            -- upvalues: v3 (copy), v4 (copy), n1 (ref)
            if v4.Parent then
                v3:AdjustWeight(-1)
                v3.Priority = Enum.AnimationPriority.Core
                v3:Stop(n1)
            end

            task.delay(n1, function() -- line: 73
                -- upvalues: v4 (copy)
                local v11 = (v4:GetAttribute("TrackCount") or 1) - 1

                v4:SetAttribute("TrackCount", v11)

                if v11 <= 0 then
                    v4:Destroy()
                end
            end)
        end

        if n1 <= 0 then
            finishUp()
        else
            local connection

            connection = RunService.Heartbeat:Connect(function() -- line: 89
                -- upvalues: v3 (copy), v4 (copy), n1 (ref), finishUp (copy), connection (ref)
                if v4.Parent then
                    local Speed = v3.Speed

                    if not (Speed <= 0) then
                        local v12 = (v3.Length - v3.TimePosition) / Speed

                        if not v3.IsPlaying or v12 <= n1 then
                            connection:Disconnect()
                            finishUp()
                        end
                    end
                else
                    connection:Disconnect()
                end
            end)
        end
    end

    local Character = p3.Character

    if Character then
        v4.Parent = Character
    end

    return v3, v4
end

local function getAnimIdFromEmoteIdAsync(p7) -- line: 113
    -- upvalues: Modules (copy), t1 (copy)
    local v13 = require(Modules.Parent.Services.Emotes).getEmoteById(p7)
    local v14 = v13 and v13.animationId

    if v14 then
        return true, v14
    end

    local v15 = tostring(p7)
    local v16 = t1[v15]

    if v16 then
        return true, v16
    end

    local function v17() -- line: 125
        -- upvalues: p7 (copy)
        return game:GetService("AssetService"):LoadAssetAsync(p7)
    end

    local ok, result = pcall(v17)

    if not ok then
        return false, (tostring(result))
    end

    local Animation = result:FindFirstChildOfClass("Animation")

    if Animation then
        local v18 = tonumber(Animation.AnimationId:match("%d+"))

        if v18 then
            t1[v15] = v18
            Animation:Destroy()

            return true, v18
        end

        result:Destroy()

        return false, "Invalid animation ID"
    end

    result:Destroy()

    return false, "No animation in asset"
end

local function stopCurrentEmote(p8) -- line: 148
    local emoteTrack, emoteAnimation = p8.extra.emoteTrack, p8.extra.emoteAnimation

    p8.extra.emoteTrack = nil
    p8.extra.emoteAnimation = nil

    if emoteTrack then
        emoteTrack:Stop()
        emoteTrack:Destroy()
    end

    if emoteAnimation then
        emoteAnimation:Destroy()
    end
end

local function runEmoteId(p9, p10, p11, p12) -- line: 162
    -- upvalues: Prompt (copy), getHRP (copy), playAnimation (copy), getAnimIdFromEmoteIdAsync (copy)
    local v19, v20 = getAnimIdFromEmoteIdAsync(p10)

    if not v19 then
        Prompt.error(p9.caller, (("Failed to run emote ID %*: %*"):format(p10, v20)))

        return
    end

    if p9.isActive then
        p9:keep("UntilTargetRespawns")

        local target = p9.target
        local emoteTrack, emoteAnimation = p9.extra.emoteTrack, p9.extra.emoteAnimation

        if emoteTrack and emoteAnimation and emoteAnimation.Parent and p9.extra.emoteAnimId == v20 then
            local v21 = p11 or 1

            emoteTrack:Play(1, p12 and 98 or 99, v21)
            emoteAnimation:SetAttribute("HDSpeed", v21)

            local v22 = getHRP(target)
            local HDTorsoSound = v22 and v22:FindFirstChild("HDTorsoSound")

            if HDTorsoSound and HDTorsoSound:IsA("Sound") then
                HDTorsoSound.PlaybackSpeed = (v21 - 1) / 2 + 1 or 1
            end

            p9.extra.emoteSpeed = v21

            return true
        end

        local emoteTrack2, emoteAnimation2 = p9.extra.emoteTrack, p9.extra.emoteAnimation

        p9.extra.emoteTrack = nil
        p9.extra.emoteAnimation = nil

        if emoteTrack2 then
            emoteTrack2:Stop()
            emoteTrack2:Destroy()
        end

        if emoteAnimation2 then
            emoteAnimation2:Destroy()
        end

        local v23, v24 = playAnimation(target, v20, p11, p12)

        p9.extra.emoteTrack = v23
        p9.extra.emoteAnimation = v24
        p9.extra.emoteAnimId = v20
        p9.extra.emoteSpeed = p11 or 1

        local janitor = p9.janitor

        if p9.isActive and janitor.add then
            if not p9.extra.emoteCleanupBound then
                p9.extra.emoteCleanupBound = true
                janitor:add(function() -- line: 199
                    -- upvalues: p9 (copy)
                    local emoteTrack, emoteAnimation = p9.extra.emoteTrack, p9.extra.emoteAnimation

                    p9.extra.emoteTrack = nil
                    p9.extra.emoteAnimation = nil

                    if emoteTrack then
                        emoteTrack:Stop()
                        emoteTrack:Destroy()
                    end

                    if emoteAnimation then
                        emoteAnimation:Destroy()
                    end
                end)
            end

            return true
        end

        local emoteTrack3, emoteAnimation3 = p9.extra.emoteTrack, p9.extra.emoteAnimation

        p9.extra.emoteTrack = nil
        p9.extra.emoteAnimation = nil

        if emoteTrack3 then
            emoteTrack3:Stop()
            emoteTrack3:Destroy()
        end

        if emoteAnimation3 then
            emoteAnimation3:Destroy()
        end
    end
end

return runEmoteId
