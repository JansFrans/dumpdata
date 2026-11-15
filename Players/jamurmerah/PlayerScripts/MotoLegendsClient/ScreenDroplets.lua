-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "ScreenDropletsHUD"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 1
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local n1 = 0
local v1 = Color3.fromRGB(255, 255, 255)
local AssetService = game:GetService("AssetService")

local function smooth(p1, p2, p3) -- line: 25
    local v3 = math.clamp((p3 - p1) / (p2 - p1), 0, 1)

    return v3 * v3 * (3 - 2 * v3)
end

local function over(p4, p5, p6, p7, p8, p9, p10, p11) -- line: 26
    local v4 = p11 + p7 * (1 - p11)

    if v4 <= 0 then
        return 0, 0, 0, 0
    end

    return (p8 * p11 + p4 * p7 * (1 - p11)) / v4, (p9 * p11 + p5 * p7 * (1 - p11)) / v4, (p10 * p11 + p6 * p7 * (1 - p11)) / v4, v4
end

local function shade(p12, p13) -- line: 30
    local v6 = math.sqrt(p12 * p12 + p13 * p13)
    local v8 = math.sqrt((p12 - 0.07) ^ 2 + (p13 - 0.11) ^ 2)
    local v9, v10, v11, v12

    if v6 >= 0.98 and v8 < 1.14 then
        local v14 = math.clamp((v8 - 1) / 0.1399999999999999, 0, 1)
        local v15 = (1 - v14 * v14 * (3 - 2 * v14)) * 0.22
        local v16 = v15 + 0 * (1 - v15)
        local v17, v18, v19

        if v16 <= 0 then
            v17 = 0
            v18 = 0
            v19 = 0
            v16 = 0
        else
            v17 = (0.05 * v15 + 0 * 0 * (1 - v15)) / v16
            v18 = (0.07 * v15 + 0 * 0 * (1 - v15)) / v16
            v19 = (0.1 * v15 + 0 * 0 * (1 - v15)) / v16
        end

        v9 = v16
        v10 = v17
        v11 = v18
        v12 = v19
    else
        v10 = 0
        v11 = 0
        v12 = 0
        v9 = 0
    end

    local v20, v21, v22, v23

    if v6 < 1 then
        local v25 = math.clamp((-p13 + 1) / 2, 0, 1)
        local v26 = 0.06 + v9 * 0.94
        local v27, v28, v29

        if v26 <= 0 then
            v27 = 0
            v28 = 0
            v29 = 0
            v26 = 0
        else
            v27 = (0.051 + v10 * v9 * 0.94) / v26
            v28 = (0.054 + v11 * v9 * 0.94) / v26
            v29 = (0.056999999999999995 + v12 * v9 * 0.94) / v26
        end

        local v31 = math.clamp((v6 - 0.5) / 0.5, 0, 1)
        local v32 = (v31 * v31 * (3 - 2 * v31)) ^ 1.6 * (v25 * 0.6 + 0.25)
        local v33 = v32 + v26 * (1 - v32)
        local v34, v35, v36

        if v33 <= 0 then
            v34 = 0
            v35 = 0
            v36 = 0
            v33 = 0
        else
            v34 = (0.12 * v32 + v27 * v26 * (1 - v32)) / v33
            v35 = (0.15 * v32 + v28 * v26 * (1 - v32)) / v33
            v36 = (0.2 * v32 + v29 * v26 * (1 - v32)) / v33
        end

        local v38 = math.exp(-((v6 - 0.8) / 0.12) ^ 2)
        local v40 = math.clamp((v25 - 0.2) / 0.7, 0, 1)
        local v41 = v38 * (v40 * v40 * (3 - 2 * v40)) * 0.25
        local v42 = v41 + v33 * (1 - v41)
        local v43, v44, v45

        if v42 <= 0 then
            v43 = 0
            v44 = 0
            v45 = 0
            v42 = 0
        else
            v43 = (0.2 * v41 + v34 * v33 * (1 - v41)) / v42
            v44 = (0.24 * v41 + v35 * v33 * (1 - v41)) / v42
            v45 = (0.3 * v41 + v36 * v33 * (1 - v41)) / v42
        end

        local v47 = math.exp(-((v6 - 0.8) / 0.09) ^ 2)
        local v49 = math.clamp((p13 - 0.15) / 0.6, 0, 1)
        local v50 = v47 * (v49 * v49 * (3 - 2 * v49)) * 0.85
        local v51 = v50 + v42 * (1 - v50)
        local v52, v53, v54

        if v51 <= 0 then
            v52 = 0
            v53 = 0
            v54 = 0
            v51 = 0
        else
            v52 = (1 * v50 + v43 * v42 * (1 - v50)) / v51
            v53 = (1 * v50 + v44 * v42 * (1 - v50)) / v51
            v54 = (1 * v50 + v45 * v42 * (1 - v50)) / v51
        end

        local v56 = math.exp(-((v6 - 0.965) / 0.025) ^ 2) * ((1 - v25) * 0.4 + 0.35)
        local v57 = v56 + v51 * (1 - v56)
        local v58, v59, v60

        if v57 <= 0 then
            v58 = 0
            v59 = 0
            v60 = 0
            v57 = 0
        else
            v58 = (1 * v56 + v52 * v51 * (1 - v56)) / v57
            v59 = (1 * v56 + v53 * v51 * (1 - v56)) / v57
            v60 = (1 * v56 + v54 * v51 * (1 - v56)) / v57
        end

        local v61 = (p12 + 0.38) / 0.2
        local v62 = (p13 + 0.44) / 0.12
        local v65 = math.clamp(1.4 - math.sqrt(v61 * v61 + v62 * v62), 0, 1) * 0.95
        local v66 = v65 + v57 * (1 - v65)
        local v67, v68, v69

        if v66 <= 0 then
            v67 = 0
            v68 = 0
            v69 = 0
            v66 = 0
        else
            v67 = (1 * v65 + v58 * v57 * (1 - v65)) / v66
            v68 = (1 * v65 + v59 * v57 * (1 - v65)) / v66
            v69 = (1 * v65 + v60 * v57 * (1 - v65)) / v66
        end

        local v72 = math.clamp(1.3 - math.sqrt(((p12 - 0.3) / 0.06) ^ 2 + ((p13 + 0.55) / 0.05) ^ 2), 0, 1) * 0.7
        local v73 = v72 + v66 * (1 - v72)

        if v73 <= 0 then
            v20 = 0
            v21 = 0
            v22 = 0
            v73 = 0
        else
            v20 = (1 * v72 + v67 * v66 * (1 - v72)) / v73
            v21 = (1 * v72 + v68 * v66 * (1 - v72)) / v73
            v22 = (1 * v72 + v69 * v66 * (1 - v72)) / v73
        end

        v23 = v73 * (math.clamp((1 - v6) * 60, 0, 1) * 1 + 0)
    else
        v23 = v9
        v20 = v10
        v21 = v11
        v22 = v12
    end

    return v20, v21, v22, v23
end

local v75

local function texture() -- line: 67
    -- upvalues: AssetService (copy), shade (copy), v75 (ref)
    if v75 ~= nil then
        return v75
    end

    v75 = false

    local function v76() -- line: 70
        -- upvalues: AssetService (copy), shade (copy)
        local v77 = buffer.create(65536)

        for i = 0, 127 do
            for j = 0, 127 do
                local n2 = 0
                local n3 = 0
                local n4 = 0
                local n5 = 0

                for k = 0, 2 do
                    for n = 0, 2 do
                        local v80, v81, v82, v83 = shade((j + (n + 0.5) / 3) / 128 * 2.3 - 1.15, (i + (k + 0.5) / 3) / 128 * 2.3 - 1.15)

                        n2 += v80 * v83
                        n3 += v81 * v83
                        n4 += v82 * v83
                        n5 += v83
                    end
                end

                if n5 > 0 then
                    local v92 = math.floor(n2 / n5 * 255 + 0.5) + math.floor(n3 / n5 * 255 + 0.5) * 256 + math.floor(n4 / n5 * 255 + 0.5) * 65536 + math.floor(math.min(1, n5 / 9) * 255 + 0.5) * 16777216

                    buffer.writeu32(v77, (i * 128 + j) * 4, v92)
                end
            end

            if i % 16 == 0 then
                task.wait()
            end
        end

        local v93 = AssetService:CreateEditableImage({
            Size = Vector2.new(128, 128)
        })

        v93:WritePixelsBuffer(Vector2.zero, Vector2.new(128, 128), v77)

        return Content.fromObject(v93)
    end

    local ok, result = pcall(v76)

    if ok then
        v75 = result
    else
        warn("[ScreenDroplets] drop texture: " .. tostring(result))
    end

    return v75
end

task.spawn(texture)

local function effectsOn() -- line: 98
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("GfxEffects") ~= false
end

local t1 = {}

LocalPlayer:GetAttributeChangedSignal("GfxEffects"):Connect(function() -- line: 101
    -- upvalues: LocalPlayer (copy), n1 (ref), t1 (copy)
    if LocalPlayer:GetAttribute("GfxEffects") ~= false then
        return
    end

    for v94 in t1 do
        t1[v94] = nil

        if v94.gui.Parent then
            v94.gui:Destroy()
            n1 -= 1
        end
    end
end)

local function drop(p14) -- line: 105
    -- upvalues: TweenService (copy), LocalPlayer (copy), ScreenGui (copy), n1 (ref), v1 (copy), AssetService (copy), shade (copy), v75 (ref), t1 (copy)
    if n1 >= 140 or LocalPlayer:GetAttribute("GfxEffects") == false then
        return
    end

    if v75 == nil then
        v75 = false

        local function v95() -- line: 70
            -- upvalues: AssetService (copy), shade (copy)
            local v96 = buffer.create(65536)

            for i = 0, 127 do
                for j = 0, 127 do
                    local n6 = 0
                    local n7 = 0
                    local n8 = 0
                    local n9 = 0

                    for k = 0, 2 do
                        for n = 0, 2 do
                            local v99, v100, v101, v102 = shade((j + (n + 0.5) / 3) / 128 * 2.3 - 1.15, (i + (k + 0.5) / 3) / 128 * 2.3 - 1.15)

                            n6 += v99 * v102
                            n7 += v100 * v102
                            n8 += v101 * v102
                            n9 += v102
                        end
                    end

                    if n9 > 0 then
                        local v111 = math.floor(n6 / n9 * 255 + 0.5) + math.floor(n7 / n9 * 255 + 0.5) * 256 + math.floor(n8 / n9 * 255 + 0.5) * 65536 + math.floor(math.min(1, n9 / 9) * 255 + 0.5) * 16777216

                        buffer.writeu32(v96, (i * 128 + j) * 4, v111)
                    end
                end

                if i % 16 == 0 then
                    task.wait()
                end
            end

            local v112 = AssetService:CreateEditableImage({
                Size = Vector2.new(128, 128)
            })

            v112:WritePixelsBuffer(Vector2.zero, Vector2.new(128, 128), v96)

            return Content.fromObject(v112)
        end

        local ok, result = pcall(v95)

        if ok then
            v75 = result
        else
            warn("[ScreenDroplets] drop texture: " .. tostring(result))
        end
    end

    local v113 = v75

    if v113 then
        local ViewportSize = workspace.CurrentCamera.ViewportSize
        local v114 = math.random() ^ 2.2
        local v115 = ViewportSize.Y * (p14.min + v114 * (p14.max - p14.min))
        local v116 = v115 * 1.15
        local v117 = v115 * 1.15 * (1 + math.random() * 0.22)
        local v118 = p14.x or math.random()
        local v119 = p14.y or math.random()
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Drop"
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.BorderSizePixel = 0
        ImageLabel.Position = UDim2.fromScale(v118, v119)
        ImageLabel.Size = UDim2.fromOffset(v116, v117)
        ImageLabel.ImageContent = v113
        ImageLabel.ImageTransparency = 1
        ImageLabel.ImageColor3 = p14.tint or v1
        ImageLabel.Rotation = math.random(-12, 12)

        local UIScale = Instance.new("UIScale")

        UIScale.Scale = 0.4
        UIScale.Parent = ImageLabel
        ImageLabel.Parent = ScreenGui
        n1 += 1

        local v120 = p14.life or 1.8 + math.random() * 2.6
        local v121 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        TweenService:Create(UIScale, v121, {
            Scale = 1
        }):Play()
        TweenService:Create(ImageLabel, v121, {
            ImageTransparency = p14.fill or 0.5
        }):Play()

        local t2 = {
            gui = ImageLabel,
            x = v118,
            y = v119,
            w = v116,
            h = v117,
            rot = ImageLabel.Rotation
        }

        t1[t2] = true

        if ViewportSize.Y * 0.022 < v115 and math.random() < (p14.slide or 0.35) then
            local v122 = ViewportSize.Y * (0.05 + math.random() * 0.18)

            t2.slide = TweenService:Create(ImageLabel, TweenInfo.new(v120, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(v118, 0, v119, v122),
                Size = UDim2.fromOffset(v116 * 0.85, v117 * 1.25)
            })
            t2.slide:Play()
        end

        task.delay(v120 - 0.7, function() -- line: 132
            -- upvalues: ImageLabel (copy), t2 (copy), TweenService (copy), n1 (ref), t1 (copy)
            TweenService:Create(ImageLabel, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                ImageTransparency = 1
            }):Play()
            task.delay(0.75, function() -- line: 134
                -- upvalues: ImageLabel (copy), t2 (copy), n1 (ref), t1 (copy)
                if t1[t2] then
                    t1[t2] = nil
                    ImageLabel:Destroy()
                    n1 -= 1
                end
            end)
        end)
    end
end

local function myBikeKph() -- line: 142
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v123 = Humanoid and Humanoid.SeatPart

    if not v123 or v123.Name ~= "RiderSeat" then
        return 0
    end

    local Parent = v123.Parent
    local v124 = Parent and Parent.PrimaryPart

    if not v124 then
        return 0
    end

    local AssemblyLinearVelocity = v124.AssemblyLinearVelocity

    return Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude * 0.28 * 3.6
end

local n10 = 0

RunService.RenderStepped:Connect(function(p15) -- line: 154
    -- upvalues: LocalPlayer (copy), n1 (ref), t1 (copy), n10 (ref)
    local v125 = math.min(p15, 0.1)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v126 = Humanoid and Humanoid.SeatPart
    local v127 = 0

    if v126 and v126.Name == "RiderSeat" then
        local Parent = v126.Parent
        local v128 = Parent and Parent.PrimaryPart

        if v128 then
            local AssemblyLinearVelocity = v128.AssemblyLinearVelocity

            v127 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude * 0.28 * 3.6
        end
    end

    local v130 = math.clamp(v127 / 260, 0, 1)

    n10 += (v130 - n10) * (1 - math.exp(-v125 * 4))

    if n10 < 0.02 or next(t1) == nil then
        return
    end

    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local v134 = ViewportSize.X / math.max(ViewportSize.Y, 1)

    for v135 in t1 do
        local gui = v135.gui

        if gui.Parent then
            if v135.slide then
                v135.slide:Cancel()
                v135.slide = nil
            end

            local guiPosition = gui.Position
            local v136 = guiPosition.X.Scale + guiPosition.X.Offset / ViewportSize.X
            local v137 = guiPosition.Y.Scale + guiPosition.Y.Offset / ViewportSize.Y
            local v138 = (v136 - 0.5) * v134
            local v139 = v137 - 0.62
            local v141 = math.sqrt(v138 * v138 + v139 * v139)

            if v141 < 0.02 then
                v141 = 0.03
                v138 = (math.random() - 0.5) * 0.04
                v139 = (math.random() - 0.5) * 0.04
            end

            local v142 = v138 / v141
            local v143 = v139 / v141
            local v144 = (v141 * 1.2 + 0.1) * n10 * n10 * 1.1

            if v139 > 0 then
                v144 *= 0.4
            end

            local v145 = v136 + v142 * v144 * v125 / v134
            local v146 = v137 + v143 * v144 * v125

            gui.Position = UDim2.fromScale(v145, v146)

            local v147 = n10 * 0.55 + 1

            gui.Size = UDim2.fromOffset(v135.w / math.sqrt(v147), v135.h * v147)
            gui.Rotation = math.deg((math.atan2(v143, v142))) - 90

            if v145 < -0.08 or v145 > 1.08 or v146 < -0.08 or v146 > 1.08 then
                t1[v135] = nil
                gui:Destroy()
                n1 -= 1
            end

            continue
        end

        t1[v135] = nil
    end
end)
LocalPlayer:GetAttributeChangedSignal("CameraIndoors"):Connect(function() -- line: 187
    -- upvalues: TweenService (copy), LocalPlayer (copy), n1 (ref), t1 (copy)
    if LocalPlayer:GetAttribute("CameraIndoors") ~= true then
        return
    end

    for v150 in t1 do
        t1[v150] = nil

        local gui = v150.gui

        if gui.Parent then
            if v150.slide then
                v150.slide:Cancel()
            end

            TweenService:Create(gui, TweenInfo.new(0.35), {
                ImageTransparency = 1
            }):Play()
            task.delay(0.4, function() -- line: 195
                -- upvalues: gui (copy), n1 (ref)
                if gui.Parent then
                    gui:Destroy()
                    n1 -= 1
                end
            end)
        end
    end
end)

local n11 = 0
local n12 = 0
local v151 = false
local n13 = 0
local n14 = 0
local v152 = RaycastParams.new()

v152.FilterType = Enum.RaycastFilterType.Exclude

local function refreshRain() -- line: 206
    -- upvalues: MotoLegends (copy), n12 (ref)
    local RainAmount = MotoLegends:GetAttribute("RainAmount")

    n12 = if typeof(RainAmount) == "number" then math.clamp(RainAmount, 0, 1) else MotoLegends:GetAttribute("Raining") == true and 1 or 0
end

MotoLegends:GetAttributeChangedSignal("Raining"):Connect(refreshRain)
MotoLegends:GetAttributeChangedSignal("RainAmount"):Connect(refreshRain)

local RainAmount = MotoLegends:GetAttribute("RainAmount")

n12 = if typeof(RainAmount) == "number" then math.clamp(RainAmount, 0, 1) else MotoLegends:GetAttribute("Raining") == true and 1 or 0

local Position

RunService.RenderStepped:Connect(function(p16) -- line: 212
    -- upvalues: Players (copy), LocalPlayer (copy), drop (copy), n11 (ref), n12 (ref), v151 (ref), n13 (ref), n14 (ref), v152 (copy), Position (ref)
    local v153 = math.min(p16, 0.1)

    n11 += (n12 - n11) * (1 - math.exp(-v153 * 0.5))

    if n11 < 0.01 and n12 == 0 then
        n11 = 0

        return
    end

    local CurrentCamera = workspace.CurrentCamera

    n13 -= v153

    if n13 <= 0 then
        n13 = 0.4

        local t3 = {}

        for _, player in Players:GetPlayers() do
            if player.Character then
                table.insert(t3, player.Character)
            end
        end

        local RaceBikes = workspace:FindFirstChild("RaceBikes")

        if RaceBikes then
            table.insert(t3, RaceBikes)
        end

        v152.FilterDescendantsInstances = t3
        v151 = workspace:Raycast(CurrentCamera.CFrame.Position, Vector3.new(0, 120, 0), v152) ~= nil
    end

    if not v151 and LocalPlayer:GetAttribute("CameraIndoors") ~= true then
        local v157 = Position and (CurrentCamera.CFrame.Position - Position).Magnitude / v153 or 0

        Position = CurrentCamera.CFrame.Position

        local v159 = (math.clamp(v157 / 60, 0, 1) * 15 + 15) * n11

        n14 += v153 * v159

        while n14 >= 1 do
            n14 -= 1
            drop({
                min = 0.006,
                max = 0.038,
                slide = 0.35
            })
        end
    end
end)

local n15 = 0

task.spawn(function() -- line: 236
    -- upvalues: ReplicatedStorage (copy), v1 (copy), drop (copy), n15 (ref)
    local v161 = ReplicatedStorage:WaitForChild("PodiumBottleSplash", 60)

    if v161 then
        v161.OnClientEvent:Connect(function(p17, p18, p19) -- line: 239
            -- upvalues: v1 (copy), drop (copy), n15 (ref)
            local elapsed = os.clock()

            if elapsed - n15 < 0.12 then
                return
            end

            n15 = elapsed

            local v163 = math.clamp(tonumber(p17) or 0.5, 0, 1)

            for _ = 1, math.floor(14 * v163 + 0.5) + 6 do
                local v165 = typeof(p18) == "Color3"
                local v166 = if v165 then p18:Lerp(v1, 0.25) else nil
                local v167 = if not v165 or not v166 then v1 else v166

                if p19 then
                    v167 = Color3.fromHSV(math.random(), 0.55, 1)
                end

                drop({
                    min = 0.012,
                    fill = 0.25,
                    slide = 0.5,
                    max = 0.06 + 0.03 * v163,
                    tint = v167,
                    x = 0.15 + math.random() * 0.7,
                    y = 0.1 + math.random() * 0.75,
                    life = 2.2 + math.random() * 2
                })
            end
        end)
    end
end)
