-- https://lua.expert

local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local t1 = {}

local function postsFolder() -- line: 14
    -- upvalues: MotoLegends (copy)
    local v1 = workspace:FindFirstChild(MotoLegends:GetAttribute("Track") or "")

    if v1 then
        return v1:FindFirstChild("MarshalPosts")
    end

    for _, child in workspace:GetChildren() do
        local MarshalPosts = child:FindFirstChild("MarshalPosts")

        if MarshalPosts then
            return MarshalPosts
        end
    end
end

local self = setmetatable({}, {
    __mode = "k"
})

local function syncIdle(p1, p2) -- line: 24
    -- upvalues: self (copy), syncIdle (copy)
    local v3 = p2 and p1:GetAttribute("MarshalIdle") == true
    local v4 = self[p1]
    local Animator, v5

    if not v3 or v4 then
        v5 = v4
    else
        local Humanoid = p1:FindFirstChildOfClass("Humanoid")

        Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

        local IdleAnim = p1:GetAttribute("IdleAnim")

        if not Animator or not IdleAnim then
            return
        end

        local Animation = Instance.new("Animation")

        Animation.AnimationId = IdleAnim

        local LoadAnimation = Animator.LoadAnimation
        local ok, result = pcall(LoadAnimation, Animator, Animation)

        if not ok or not result then
            return
        end

        result.Looped = true
        v5 = {
            on = false,
            track = result
        }
        self[p1] = v5
        p1:GetAttributeChangedSignal("MarshalIdle"):Connect(function() -- line: 33
            -- upvalues: p1 (copy), syncIdle (copy)
            syncIdle(p1, p1.Parent ~= nil)
        end)
    end

    if v5 and v5.on ~= v3 then
        v5.on = v3

        if v3 then
            v5.track:Play(0.2)
        else
            v5.track:Stop(0.2)
        end
    end
end

local Players = game:GetService("Players")

local function watchedPos() -- line: 41
    -- upvalues: Players (copy)
    local v6 = Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v7 = v6 and v6:FindFirstChild("JerezRaceHUD")

    if v7 then
        v7 = v7:GetAttribute("LobbySpectating") == true and v7:GetAttribute("SpectateTargetId")
    end

    if not v7 then
        return nil
    end

    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if RaceBikes then
        for _, child in RaceBikes:GetChildren() do
            if child:GetAttribute("OwnerUserId") == v7 and child.PrimaryPart then
                return child.PrimaryPart.Position
            end
        end
    end

    local PlayerByUserId = Players:GetPlayerByUserId(v7)

    PlayerByUserId = PlayerByUserId and PlayerByUserId.Character and PlayerByUserId.Character:FindFirstChild("HumanoidRootPart")

    return PlayerByUserId and PlayerByUserId.Position
end

local function dist(p3, p4, p5) -- line: 51
    local Magnitude = (p3 - p4).Magnitude

    if p5 then
        Magnitude = math.min(Magnitude, (p3 - p5).Magnitude)
    end

    return Magnitude
end

local function facing(p6, p7, p8) -- line: 63
    local v8 = p6 - p7
    local Magnitude = v8.Magnitude

    if Magnitude < 60 then
        return 1
    end

    return v8:Dot(p8) / Magnitude
end

local function marshalPos(p9) -- line: 69
    local HumanoidRootPart = p9:FindFirstChild("HumanoidRootPart")

    return HumanoidRootPart and HumanoidRootPart.Position
end

while true do
    task.wait(0.25)

    local CurrentCamera = workspace.CurrentCamera
    local v9 = postsFolder()

    if CurrentCamera and v9 then
        local CFramePosition = CurrentCamera.CFrame.Position
        local v10 = watchedPos()
        local LookVector = CurrentCamera.CFrame.LookVector

        for v11, v12 in t1 do
            if v12.Parent and v12.Parent == v9 then
                local HumanoidRootPart = v11:FindFirstChild("HumanoidRootPart")
                local v13 = HumanoidRootPart and HumanoidRootPart.Position

                if v13 then
                    local Magnitude = (v13 - CFramePosition).Magnitude

                    if v10 then
                        Magnitude = math.min(Magnitude, (v13 - v10).Magnitude)
                    end

                    if Magnitude < 600 then
                        local v14 = v13 - CFramePosition
                        local Magnitude = v14.Magnitude

                        if (if Magnitude < 60 then 1 else v14:Dot(LookVector) / Magnitude) > -0.25 then
                            v11.Parent = v12
                            t1[v11] = nil
                            syncIdle(v11, true)
                        end
                    end
                end
            else
                t1[v11] = nil
            end
        end

        for _, child in v9:GetChildren() do
            for _, child2 in child:GetChildren() do
                if child2:IsA("Model") and child2:FindFirstChildOfClass("Humanoid") then
                    local HumanoidRootPart = child2:FindFirstChild("HumanoidRootPart")
                    local v15 = HumanoidRootPart and HumanoidRootPart.Position

                    if v15 then
                        local Magnitude = (v15 - CFramePosition).Magnitude

                        if v10 then
                            Magnitude = math.min(Magnitude, (v15 - v10).Magnitude)
                        end

                        if Magnitude > 700 then
                            local v16 = self[child2]

                            if v16 and v16.on ~= false then
                                v16.on = false
                                v16.track:Stop(0.2)
                            end

                            t1[child2] = child
                            child2.Parent = nil
                        else
                            local v17 = v15 - CFramePosition
                            local Magnitude = v17.Magnitude

                            if (if Magnitude < 60 then 1 else v17:Dot(LookVector) / Magnitude) < -0.45 then
                                local v18 = self[child2]

                                if v18 and v18.on ~= false then
                                    v18.on = false
                                    v18.track:Stop(0.2)
                                end

                                t1[child2] = child
                                child2.Parent = nil
                            else
                                syncIdle(child2, true)
                            end
                        end
                    else
                        syncIdle(child2, true)
                    end
                end
            end
        end
    end
end
