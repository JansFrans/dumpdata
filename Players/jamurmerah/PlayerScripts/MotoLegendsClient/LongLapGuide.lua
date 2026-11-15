-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local Track = workspace:GetAttribute("Track")
local v1 = Track and MotoLegends:WaitForChild("Tracks"):FindFirstChild(Track)
local LongLapRoute = v1 and v1:FindFirstChild("LongLapRoute")

if not LongLapRoute then
    return
end

local _require = require
local ok, result = pcall(_require, LongLapRoute)
local t1, t2, t3, t4, build, v2

if not ok or typeof(result) ~= "table" or #result < 16 then
    return
else
    local v4 = Color3.fromRGB(255, 206, 0)
    local v5 = Color3.fromRGB(16, 18, 22)
    local t5 = {
        6, 10, 14
    }
    local v6 = Color3.fromRGB(255, 214, 0)

    local function chevronNodes() -- line: 36
        -- upvalues: LocalPlayer (copy), result (copy), t5 (copy)
        if LocalPlayer:GetAttribute("ApexAssist") == false then
            return t5
        end

        local t6 = {}

        for i = 6, #result - 3, 5 do
            table.insert(t6, i)
        end

        return t6
    end

    local function xz(p1) -- line: 44
        -- upvalues: result (copy)
        local position = result[p1].position

        return (Vector3.new(position.X, 0, position.Z))
    end

    local v7

    local function surfaceY(p2) -- line: 46
        -- upvalues: Track (copy), v7 (ref)
        if not v7 then
            local v8 = workspace:FindFirstChild(Track)
            local RaceCollision = v8 and v8:FindFirstChild("RaceCollision")

            if RaceCollision then
                v7 = RaycastParams.new()

                local v9 = v7

                v9.FilterType = Enum.RaycastFilterType.Include

                local v10 = v7

                v10.FilterDescendantsInstances = { RaceCollision }
            end
        end

        local v11 = v7

        v11 = v11 and workspace:Raycast(Vector3.new(p2.X, 400, p2.Z), Vector3.new(0, -800, 0), v7)

        return v11 and v11.Position.Y or nil
    end

    t1 = {}
    t1[1] = nil
    t2 = {}
    t2[1] = nil
    t3 = {}
    t4 = {}

    local t7 = t4
    local t8 = t3

    build = (function(p3, p4)
        local function build() -- line: 64
            -- upvalues: p3 (copy), p4 (copy), LocalPlayer (copy), result (copy), v4 (copy), v5 (copy), v6 (copy), chevronNodes (copy), surfaceY (copy), t7 (copy), t8 (copy)
            if p3[1] then
                p3[1]:Destroy()
                p3[1] = nil
            end

            if p4[1] then
                p4[1]:Destroy()
                p4[1] = nil
            end

            table.clear(t7)
            table.clear(t8)
            p3[1] = Instance.new("Folder")
            p3[1].Name = "LongLapGuide"

            for _, v15 in chevronNodes() do
                local position = result[v15].position
                local v16 = Vector3.new(position.X, 0, position.Z)
                local position2 = result[v15 + 1].position
                local v18 = Vector3.new(position2.X, 0, position2.Z)
                local position3 = result[v15 - 1].position
                local v20 = v18 - Vector3.new(position3.X, 0, position3.Z)

                if not (v20.Magnitude < 0.001) then
                    local v21 = surfaceY(v16)

                    if v21 then
                        local v23 = Vector3.new(v16.X, v21 + 0.08, v16.Z)
                        local v24 = CFrame.lookAt(v23, v23 + v20.Unit, (Vector3.new(0, 1, 0)))
                        local UpVector, RightVector = v24.UpVector, v24.RightVector
                        local v25 = -v24.LookVector
                        local WedgePart = Instance.new("WedgePart")

                        WedgePart.Name = "ArrowL"
                        WedgePart.Anchored = true
                        WedgePart.CanCollide = false
                        WedgePart.CanQuery = false
                        WedgePart.CanTouch = false
                        WedgePart.CastShadow = false
                        WedgePart.Material = Enum.Material.SmoothPlastic
                        WedgePart.Color = v6
                        WedgePart.Transparency = 1
                        WedgePart.Size = Vector3.new(0.06, 3, 4.5)
                        WedgePart.Parent = p3[1]

                        local WedgePart2 = Instance.new("WedgePart")

                        WedgePart2.Name = "ArrowR"
                        WedgePart2.Anchored = true
                        WedgePart2.CanCollide = false
                        WedgePart2.CanQuery = false
                        WedgePart2.CanTouch = false
                        WedgePart2.CastShadow = false
                        WedgePart2.Material = Enum.Material.SmoothPlastic
                        WedgePart2.Color = v6
                        WedgePart2.Transparency = 1
                        WedgePart2.Size = Vector3.new(0.06, 3, 4.5)
                        WedgePart2.Parent = p3[1]
                        WedgePart.CFrame = CFrame.fromMatrix(v23 - RightVector * 1.5, UpVector, -RightVector, v25)
                        WedgePart2.CFrame = CFrame.fromMatrix(v23 + RightVector * 1.5, -UpVector, RightVector, v25)
                        table.insert(t7, {
                            l = WedgePart,
                            r = WedgePart2,
                            pos = v23
                        })
                    end
                end
            end

            p3[1].Parent = workspace

            local position = result[4].position
            local v27 = Vector3.new(position.X, 0, position.Z)
            local v28 = surfaceY(v27)

            if not v28 then
                local position = result[8].position

                v28 = surfaceY((Vector3.new(position.X, 0, position.Z))) or 0
            end

            local Attachment = Instance.new("Attachment")

            Attachment.Name = "SignAnchor"

            local Part = Instance.new("Part")

            Part.Name = "SignHolder"
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.Transparency = 1
            Part.Size = Vector3.new(1, 1, 1)
            Part.Position = Vector3.new(v27.X, v28 + 16, v27.Z)
            Part.Parent = p3[1]
            Attachment.Parent = Part
            p4[1] = Instance.new("BillboardGui")
            p4[1].Name = "LongLapSign"
            p4[1].Adornee = Part
            p4[1].AlwaysOnTop = true
            p4[1].LightInfluence = 0
            p4[1].ResetOnSpawn = false
            p4[1].Size = UDim2.fromOffset(220, 70)
            p4[1].MaxDistance = 250

            local Frame = Instance.new("Frame")

            Frame.Name = "Pill"
            Frame.AnchorPoint = Vector2.new(0.5, 0)
            Frame.Position = UDim2.new(0.5, 0, 0, 22)
            Frame.Size = UDim2.fromOffset(176, 30)
            Frame.BackgroundColor3 = v4
            Frame.BorderSizePixel = 0
            Frame.ZIndex = 2
            Frame.Parent = p4[1]

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = Frame

            local TextLabel = Instance.new("TextLabel")

            TextLabel.BackgroundTransparency = 1
            TextLabel.Size = UDim2.fromScale(1, 1)
            TextLabel.ZIndex = 3
            TextLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
            TextLabel.TextSize = 15
            TextLabel.TextColor3 = v5
            TextLabel.Text = "LONG LAP PENALTY"
            TextLabel.AutoLocalize = false
            TextLabel.Parent = Frame

            for i = 1, 2 do
                local Frame = Instance.new("Frame")

                Frame.Name = "Pulse" .. i
                Frame.AnchorPoint = Vector2.new(0.5, 0.5)
                Frame.Position = UDim2.new(0.5, 0, 0, 37)
                Frame.Size = UDim2.fromOffset(176, 30)
                Frame.BackgroundTransparency = 1
                Frame.ZIndex = 1
                Frame.Parent = p4[1]

                local UICorner = Instance.new("UICorner")

                UICorner.CornerRadius = UDim.new(1, 0)
                UICorner.Parent = Frame

                local UIStroke = Instance.new("UIStroke")

                UIStroke.Color = v4
                UIStroke.Thickness = 2
                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                UIStroke.Parent = Frame
                table.insert(t8, {
                    w = 176,
                    h = 30,
                    grow = 22,
                    frame = Frame,
                    stroke = UIStroke,
                    corner = UICorner,
                    k = i
                })
            end

            local Frame2 = Instance.new("Frame")

            Frame2.Name = "Tip"
            Frame2.AnchorPoint = Vector2.new(0.5, 0)
            Frame2.Position = UDim2.new(0.5, 0, 0, 58)
            Frame2.Size = UDim2.fromOffset(16, 8)
            Frame2.BackgroundTransparency = 1
            Frame2.ZIndex = 2
            Frame2.Parent = p4[1]

            for i = 0, 7 do
                local v37 = (1 - (i + 0.5) / 8) * 16
                local Frame = Instance.new("Frame")

                Frame.AnchorPoint = Vector2.new(0.5, 0)
                Frame.Position = UDim2.new(0.5, 0, 0, i)
                Frame.Size = UDim2.new(0, math.max(1, (math.floor(v37 + 0.5))), 0, 1)
                Frame.BackgroundColor3 = Color3.new(0, 0, 0)
                Frame.BackgroundTransparency = 0.25
                Frame.BorderSizePixel = 0
                Frame.ZIndex = 2
                Frame.Parent = Frame2
            end

            p4[1].Parent = LocalPlayer:WaitForChild("PlayerGui")
        end

        return build
    end)(t1, t2)

    local function owed() -- line: 120
        -- upvalues: LocalPlayer (copy)
        local LongLapPenalties = LocalPlayer:GetAttribute("LongLapPenalties")

        if typeof(LongLapPenalties) == "number" then
            return LongLapPenalties > 0
        end

        return false
    end

    local build2 = build
    local refresh = (function(p5, p6)
        local function refresh() -- line: 121
            -- upvalues: p5 (copy), p6 (copy), LocalPlayer (copy), t7 (copy), t8 (copy), build2 (copy)
            local LongLapPenalties = LocalPlayer:GetAttribute("LongLapPenalties")

            if typeof(LongLapPenalties) == "number" and LongLapPenalties > 0 then
                if not p5[1] then
                    build2()
                end
            else
                if p5[1] then
                    p5[1]:Destroy()
                    p5[1] = nil
                end

                if p6[1] then
                    p6[1]:Destroy()
                    p6[1] = nil
                end

                table.clear(t7)
                table.clear(t8)
            end
        end

        return refresh
    end)(t1, t2)

    LocalPlayer:GetAttributeChangedSignal("LongLapPenalties"):Connect(refresh)
    LocalPlayer:GetAttributeChangedSignal("ApexAssist"):Connect(((function(p7, p8)
        return function() -- line: 126
            -- upvalues: p7 (copy), p8 (copy), LocalPlayer (copy), t7 (copy), t8 (copy), build2 (copy)
            if p7[1] then
                if p7[1] then
                    p7[1]:Destroy()
                    p7[1] = nil
                end

                if p8[1] then
                    p8[1]:Destroy()
                    p8[1] = nil
                end

                table.clear(t7)
                table.clear(t8)

                local LongLapPenalties = LocalPlayer:GetAttribute("LongLapPenalties")

                if typeof(LongLapPenalties) == "number" and LongLapPenalties > 0 then
                    if not p7[1] then
                        build2()
                    end
                else
                    if p7[1] then
                        p7[1]:Destroy()
                        p7[1] = nil
                    end

                    if p8[1] then
                        p8[1]:Destroy()
                        p8[1] = nil
                    end

                    table.clear(t7)
                    table.clear(t8)
                end
            end
        end
    end)(t1, t2)))

    local LongLapPenalties = LocalPlayer:GetAttribute("LongLapPenalties")

    v2 = typeof(LongLapPenalties) == "number" and LongLapPenalties > 0
end

if v2 then
    if not t1[1] then
        build()
    end
else
    if t1[1] then
        t1[1]:Destroy()
        t1[1] = nil
    end

    if t2[1] then
        t2[1]:Destroy()
        t2[1] = nil
    end

    table.clear(t4)
    table.clear(t3)
end

RunService.RenderStepped:Connect(((function(p9)
    return function() -- line: 130
        -- upvalues: p9 (copy), LocalPlayer (copy), t3 (ref), t4 (ref)
        if p9[1] then
            local elapsed = os.clock()
            local Character = LocalPlayer.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local v47 = Humanoid and Humanoid.SeatPart
            local v48 = v47 and v47.Position

            for _, v49 in t4 do
                local v54 = 1 - (if v48 then math.clamp((Vector3.new(v49.pos.X - v48.X, 0, v49.pos.Z - v48.Z).Magnitude - 10) / 60, 0, 1) else 1) * 0.9

                if v49.l.Transparency ~= v54 then
                    v49.l.Transparency = v54
                    v49.r.Transparency = v54
                end
            end

            local v55 = elapsed / 2

            for _, v56 in t3 do
                local v57 = (v55 + (v56.k - 1) * 0.5) % 1
                local v58 = 1 - (1 - v57) ^ 3

                v56.frame.Size = UDim2.fromOffset(v56.w + 2 * v56.grow * v58, v56.h + 2 * v56.grow * v58)
                v56.stroke.Transparency = 1 - 0.8 * (1 - v57) ^ 2
            end
        end
    end
end)(t1)))
