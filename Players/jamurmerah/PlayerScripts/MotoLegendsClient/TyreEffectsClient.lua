-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local Config = require(MotoLegends:WaitForChild("Config"))
local LocalPlayer = Players.LocalPlayer
local t1 = {
    "RaceBikes",
    "CrashedBikes"
}
local new, new2 = NumberSequence.new, NumberSequenceKeypoint.new
local v2 = Vector3.new(0, Config.RearAxle.Y - Config.RearWheelRadius + 0.35, 0.6)
local self = setmetatable({}, {
    __mode = "k"
})

local function get(p1) -- line: 22
    -- upvalues: self (copy)
    local v4 = self[p1]

    if v4 then
        return v4
    end

    if not p1:IsA("Model") then
        return nil
    end

    local PrimaryPart = p1.PrimaryPart

    if not PrimaryPart then
        return nil
    end

    local RearTyreSmoke = PrimaryPart:FindFirstChild("RearTyreSmoke")
    local ScrapeSparks = PrimaryPart:FindFirstChild("ScrapeSparks")

    if not RearTyreSmoke then
        return nil
    end

    local t4 = {
        active = false,
        root = PrimaryPart,
        rear = RearTyreSmoke,
        smoke = RearTyreSmoke:FindFirstChild("BurnoutSmoke"),
        dust = RearTyreSmoke:FindFirstChild("GravelDust"),
        point = ScrapeSparks,
        sparks = ScrapeSparks and ScrapeSparks:FindFirstChild("Sparks"),
        glow = ScrapeSparks and ScrapeSparks:FindFirstChild("SparkGlow")
    }

    if t4.smoke and t4.dust then
        self[p1] = t4

        return t4
    end

    return nil
end

local function off(p2) -- line: 33
    p2.active = false
    p2.smoke.Enabled = false
    p2.smoke.Rate = 0
    p2.dust.Enabled = false
    p2.dust.Rate = 0

    if p2.sparks then
        p2.sparks.Enabled = false
        p2.sparks.Rate = 0
    end

    if p2.glow then
        p2.glow.Brightness = 0
    end
end

local function apply(p3, p4, p5, p6, p7) -- line: 40
    -- upvalues: Config (copy), new (copy), new2 (copy), v2 (copy)
    p3.active = true

    local v5 = p5 > 0.025

    p3.smoke.Enabled = v5
    p3.smoke.Rate = v5 and p5 * 80 or 0

    local v6 = p6 > 0

    if v6 then
        local v8 = math.clamp(p6 / 150, 0, 1)
        local v10 = math.floor(v8 * 10 + 0.5) / 10

        if p3.dustStep ~= v10 then
            p3.dustStep = v10

            local v11 = v10 * 0.65 + 0.35

            p3.dust.Size = new({
                new2(0, v11 * 0.6),
                new2(0.35, v11 * 3.2),
                new2(1, v11 * 6)
            })
            p3.dust.Speed = NumberRange.new(v10 * 8 + 3, v10 * 14 + 6)
        end

        p3.dust.Enabled = true
        p3.dust.Rate = v8 * 125 + 15
    else
        p3.dust.Enabled = false
        p3.dust.Rate = 0
    end

    if v5 or v6 then
        local DustPoint = p4:GetAttribute("DustPoint")

        if typeof(DustPoint) == "Vector3" then
            p3.rear.WorldPosition = DustPoint
        else
            p3.rear.Position = Config.RearAxle + Vector3.new(0, 1, 0) * ((p4:GetAttribute("RearCompression") or 0) - Config.RearWheelRadius + 0.05)
        end
    end

    if p3.sparks then
        local v12 = p7 > 0.02

        if v12 then
            local CFrame = p3.root.CFrame
            local v13 = CFrame * (v2 - Vector3.new(0.85, 0, 0))
            local v14 = CFrame * (v2 + Vector3.new(0.85, 0, 0))

            p3.point.Position = v13.Y < v14.Y and v2 - Vector3.new(0.85, 0, 0) or v2 + Vector3.new(0.85, 0, 0)
        end

        p3.sparks.Enabled = v12
        p3.sparks.Rate = v12 and p7 * 320 or 0

        if p3.glow then
            p3.glow.Brightness = v12 and (1.2 + math.random() * 1.8) * p7 or 0
        end
    end
end

RunService.Heartbeat:Connect(function() -- line: 77
    -- upvalues: LocalPlayer (copy), t1 (copy), self (copy), get (copy), apply (copy)
    local v15 = LocalPlayer:GetAttribute("GfxEffects") ~= false
    local CurrentCamera = workspace.CurrentCamera
    local v16 = CurrentCamera and CurrentCamera.CFrame.Position

    for _, v17 in t1 do
        local v18 = workspace:FindFirstChild(v17)

        if v18 then
            for _, child in v18:GetChildren() do
                local v19 = child:GetAttribute("Burnout") or 0
                local v20 = child:GetAttribute("GravelKph") or 0
                local v21 = child:GetAttribute("Scrape") or 0
                local v22 = self[child]

                if v15 and (v19 > 0.025 or v20 > 0 or v21 > 0.02) then
                    local v23 = v22 or get(child)

                    if v23 then
                        if v16 and (v23.root.Position - v16).Magnitude > 400 then
                            if v23.active then
                                v23.active = false
                                v23.smoke.Enabled = false
                                v23.smoke.Rate = 0
                                v23.dust.Enabled = false
                                v23.dust.Rate = 0

                                if v23.sparks then
                                    v23.sparks.Enabled = false
                                    v23.sparks.Rate = 0
                                end

                                if v23.glow then
                                    v23.glow.Brightness = 0
                                end
                            end
                        else
                            apply(v23, child, v19, v20, v21)
                        end
                    end
                elseif v22 and v22.active then
                    v22.active = false
                    v22.smoke.Enabled = false
                    v22.smoke.Rate = 0
                    v22.dust.Enabled = false
                    v22.dust.Rate = 0

                    if v22.sparks then
                        v22.sparks.Enabled = false
                        v22.sparks.Rate = 0
                    end

                    if v22.glow then
                        v22.glow.Brightness = 0
                    end
                end
            end
        end
    end
end)
