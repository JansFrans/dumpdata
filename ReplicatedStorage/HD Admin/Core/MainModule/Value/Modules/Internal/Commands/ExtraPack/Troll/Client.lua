-- https://lua.expert

local Modules = script:FindFirstAncestor("HD Admin").Core.MainModule.Value.Modules
local CommandAPI = require(script:FindFirstAncestor("HD Admin").Core.CommandAPI)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local getHumanoid, getHead, getHRP, getNeck = CommandAPI.getHumanoid, CommandAPI.getHead, CommandAPI.getHRP, CommandAPI.getNeck
local t1 = {}
local t2 = {}
local v1 = TweenInfo.new(0.7)

local function getNeckOffset(p1) -- line: 21
    if p1:IsA("Motor6D") then
        return p1.C0
    end

    local Attachment0 = p1.Attachment0

    if Attachment0 then
        return Attachment0.CFrame
    end

    return CFrame.identity
end

local function setNeckOffset(p2, p3) -- line: 29
    if p2:IsA("Motor6D") then
        p2.C0 = p3
    else
        local Attachment0 = p2.Attachment0

        if Attachment0 then
            Attachment0.CFrame = p3
        end
    end
end

local function tweenNeckOffset(p4, p5, p6) -- line: 40
    -- upvalues: TweenService (copy)
    if p4:IsA("Motor6D") then
        TweenService:Create(p4, p6, {
            C0 = p5
        }):Play()
    else
        local Attachment0 = p4.Attachment0

        if Attachment0 then
            TweenService:Create(Attachment0, p6, {
                CFrame = p5
            }):Play()
        end
    end
end

local function displayLaser(p7, p8) -- line: 51
    local LeftBeam = p7 and p7:FindFirstChild("LeftBeam")

    if not LeftBeam then
        return
    end

    LeftBeam.Enabled = p8
    p7.RightBeam.Enabled = p8
    p7.MidAttachment.GlowHit.Enabled = p8
end

return {
    {
        name = "Ice",
        run = function(p9, p10, p11) -- run | line: 67
            -- upvalues: CommandAPI (copy), getHRP (copy)
            getHRP()

            local setAnchored = CommandAPI.setAnchored

            local function updateHRP() -- line: 70
                -- upvalues: p10 (copy), p11 (copy), setAnchored (copy)
                if p10 and p11 then
                    setAnchored(p11.Parent, true)
                    p10.CFrame = p11.CFrame * CFrame.new(0, 0.8, 0)
                end
            end

            if p10 and p11 then
                setAnchored(p11.Parent, true)
                p10.CFrame = p11.CFrame * CFrame.new(0, 0.8, 0)
            end

            p9:onEnded(function() -- line: 77
                -- upvalues: p11 (copy), setAnchored (copy)
                setAnchored(p11.Parent, false)
            end)
        end
    },
    {
        name = "LaserEyes",
        run = function(p12, p13) -- run | line: 86
            -- upvalues: Modules (copy), Players (copy), getHumanoid (copy), getHead (copy), getHRP (copy), getNeck (copy)
            local _ = Modules.Parent.Controllers.InputController
            local InputController = require(Modules.Parent.Controllers.InputController)

            p12.janitor:add(InputController.pressed:Connect(function() -- line: 89
                -- upvalues: p12 (copy), p13 (copy), InputController (copy), Players (copy), getHumanoid (copy), getHead (copy), getHRP (copy), getNeck (copy)
                if p12.extra.isRunning then
                    return
                end

                p12.extra.isRunning = true

                local v2 = getHead()
                local v3 = getHumanoid()
                local v4 = getHRP()
                local v5 = getNeck()

                if v2 and v3 and v4 and v5 then
                    local Parent = v2.Parent

                    if p13 and Parent then
                        local v6 = v3.RigType == Enum.HumanoidRigType.R6

                        Parent.PrimaryPart = v4

                        local v7 = tick() - 1
                        local v8

                        if v5:IsA("Motor6D") then
                            v8 = v5.C0
                        else
                            local Attachment0 = v5.Attachment0

                            v8 = if Attachment0 then Attachment0.CFrame else CFrame.identity
                        end

                        local PrimaryPart = Parent.PrimaryPart
                        local Fire = p13.MidAttachment2.Fire
                        local Sparks = p13.MidAttachment.Sparks
                        local LocalPlayer = Players.LocalPlayer
                        local LaserSizzle1, LaserSizzle2 = script.LaserSizzle1, script.LaserSizzle2

                        LaserSizzle1:Play()

                        local LeftBeam = p13 and p13:FindFirstChild("LeftBeam")

                        if LeftBeam then
                            LeftBeam.Enabled = true
                            p13.RightBeam.Enabled = true
                            p13.MidAttachment.GlowHit.Enabled = true
                        end

                        repeat
                            local v9, v10 = InputController.getHitPoint()
                            local v11 = CFrame.new(v9, v2.Position)
                            local v12 = LocalPlayer:DistanceFromCharacter(v11.Position)
                            local v13 = false

                            if v12 > 30 then
                                v11 *= CFrame.new(0, 0, 30 - v12)
                                v13 = true
                            end

                            p13.CFrame = v11

                            if Parent.PrimaryPart == nil then
                                Parent.PrimaryPart = v4
                            end

                            local v14 = p13.Position - v2.Position
                            local v15 = math.max(0.001, Vector3.new(v14.X, 0, v14.Z).Magnitude)
                            local v18 = math.clamp(math.atan(v14.Y / v15), -1.0471975511965976, 1.0471975511965976)
                            local v19 = PrimaryPart.CFrame:VectorToObjectSpace(v14)
                            local v23 = math.clamp(math.atan2(-v19.X, -v19.Z), -1.3089969389957472, 1.3089969389957472)
                            local v24 = if v6 then v8 * CFrame.Angles(0, 0, v23) * CFrame.Angles(v18 * 0.5, 0, 0) else v8 * CFrame.Angles(0, v23, 0) * CFrame.Angles(v18 * 0.5, 0, 0)

                            if v5:IsA("Motor6D") then
                                v5.C0 = v24
                            else
                                local Attachment0 = v5.Attachment0

                                if Attachment0 then
                                    Attachment0.CFrame = v24
                                end
                            end

                            if v7 < tick() - 0.6 then
                                v7 = tick()
                                p12.server:replicate(v11, v24)
                            end

                            local v25 = v10

                            if v10 then
                                v25 = v10.Parent
                                v10 = v10.Name
                            end

                            if not v13 and v25 and (v25:FindFirstChild("Humanoid") or v10 == "Handle") then
                                Fire.Enabled = true
                                Sparks.Enabled = true

                                if not LaserSizzle2.Playing then
                                    LaserSizzle2:Play()
                                end
                            else
                                Fire.Enabled = false
                                Sparks.Enabled = false

                                if LaserSizzle2.Playing then
                                    LaserSizzle2:Stop()
                                end
                            end

                            wait()
                        until not InputController.isPressing() or not p12.isActive or not v2.Parent or not v5.Parent

                        if v5:IsA("Motor6D") then
                            v5.C0 = v8
                        else
                            local Attachment0 = v5.Attachment0

                            if Attachment0 then
                                Attachment0.CFrame = v8
                            end
                        end

                        local LeftBeam2 = p13 and p13:FindFirstChild("LeftBeam")

                        if LeftBeam2 then
                            LeftBeam2.Enabled = false
                            p13.RightBeam.Enabled = false
                            p13.MidAttachment.GlowHit.Enabled = false
                        end

                        Fire.Enabled = false
                        Sparks.Enabled = false
                        LaserSizzle1:Stop()
                        LaserSizzle2:Stop()
                        p12.extra.isRunning = nil
                    end
                end
            end))
        end,
        replication = function(p14, p15, p16, p17) -- replication | line: 189
            -- upvalues: TweenService (copy), getHead (copy), getNeck (copy), t1 (copy), t2 (copy), v1 (copy), tweenNeckOffset (copy)
            local v26 = getHead(p14)
            local v27 = getNeck(p14)

            if not v26 or not v27 or not p15 then
                return
            end

            local _ = v26.Parent

            if t1[p14] then
                t1[p14] += 1
            else
                t1[p14] = 1

                local v28

                if v27:IsA("Motor6D") then
                    v28 = v27.C0
                else
                    local Attachment0 = v27.Attachment0

                    v28 = if Attachment0 then Attachment0.CFrame else CFrame.identity
                end

                t2[p14] = v28

                local v29 = math.random(10, 40) - 15

                p15.CFrame = p16 * CFrame.new(0, 0, v29)

                if v27:IsA("Motor6D") then
                    v27.C0 = p17
                else
                    local Attachment0 = v27.Attachment0

                    if Attachment0 then
                        Attachment0.CFrame = p17
                    end
                end

                p15.MidAttachment.GlowHit.Rate = 50

                local LeftBeam = p15:FindFirstChild("LeftBeam")

                if LeftBeam then
                    LeftBeam.Enabled = true
                    p15.RightBeam.Enabled = true
                    p15.MidAttachment.GlowHit.Enabled = true
                end
            end

            TweenService:Create(p15, v1, {
                CFrame = p16
            }):Play()
            tweenNeckOffset(v27, p17, v1)
            task.wait(0.7)
            t1[p14] -= 1

            if not (t1[p14] <= 0) then
                return
            end

            local LeftBeam = p15:FindFirstChild("LeftBeam")

            if LeftBeam then
                LeftBeam.Enabled = false
                p15.RightBeam.Enabled = false
                p15.MidAttachment.GlowHit.Enabled = false
            end

            local v30 = t2[p14]

            if v27:IsA("Motor6D") then
                v27.C0 = v30
            else
                local Attachment0 = v27.Attachment0

                if Attachment0 then
                    Attachment0.CFrame = v30
                end
            end

            task.delay(0.1, function() -- line: 219
                -- upvalues: v27 (copy), v30 (copy)
                if v27:IsA("Motor6D") then
                    v27.C0 = v30
                else
                    local Attachment0 = v27.Attachment0

                    if Attachment0 then
                        Attachment0.CFrame = v30
                    end
                end
            end)
            t2[p14] = nil
            t1[p14] = nil
        end
    }
}
