-- https://lua.expert

local AssetService = game:GetService("AssetService")
local EncodingService = game:GetService("EncodingService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local t1 = {}
local t2, v1, t3

local function decodeAtlas(p1) -- line: 9
    -- upvalues: EncodingService (copy)
    local Children = p1:GetChildren()

    table.sort(Children, function(p2, p3) -- line: 11
        return p2.Name < p3.Name
    end)

    local t4 = {}

    for _, v2 in Children do
        table.insert(t4, v2.Value)
    end

    local v3 = EncodingService:Base64Decode(buffer.fromstring(table.concat(t4)))
    local W = p1:GetAttribute("W")
    local H = p1:GetAttribute("H")
    local v4 = buffer.create(W * H)
    local v5 = 0
    local v6 = p1:GetAttribute("Palette") * 4

    while v6 < buffer.len(v3) do
        local v8 = buffer.readu8(v3, buffer.readu8(v3, v6) * 4 + 3)
        local v10 = buffer.readu16(v3, v6 + 1)

        buffer.fill(v4, v5, v8, v10)
        v5 += v10
        v6 += 3
    end

    assert(v5 == W * H, "Incomplete reference motion data")

    return {
        pixels = v4,
        width = W
    }
end

local function loadFrames() -- line: 28
    -- upvalues: HttpService (copy), t2 (ref), v1 (ref), t3 (ref), decodeAtlas (copy)
    if t2 then
        return t2, v1, t3
    end

    local Parent = script.Parent
    local v12 = HttpService:JSONDecode(Parent.ReferenceMotionInfo.Value)
    local t5 = {}
    local t6 = {}
    local atlas, v13

    for v14, v15 in v12.frames do
        if atlas ~= v15.atlas then
            atlas = v15.atlas
            v13 = decodeAtlas(Parent:FindFirstChild("ReferenceMotion" .. atlas))
            task.wait()
        end

        local v16 = buffer.create(v12.frameWidth * v12.frameHeight)

        for i = 0, v12.frameHeight - 1 do
            buffer.copy(v16, i * v12.frameWidth, v13.pixels, (v15.y + i) * v13.width + v15.x, v12.frameWidth)
        end

        t5[v14] = v16

        local frameWidth = v12.frameWidth
        local v17 = frameWidth * 0.3
        local v18 = frameWidth * 0.7
        local v19 = v12.frameHeight - 1
        local n1 = 0
        local n2 = 0
        local n3 = 0
        local n4 = 0

        for j = 0, v19 do
            local v20 = j * frameWidth

            for k = 0, frameWidth - 1 do
                if k < v17 then
                    n1 += buffer.readu8(v16, v20 + k)
                    n3 += 1
                elseif v18 < k then
                    n2 += buffer.readu8(v16, v20 + k)
                    n4 += 1
                end
            end
        end

        t6[v14] = {
            n1 / math.max(1, n3),
            n2 / math.max(1, n4)
        }

        if v14 % 16 == 0 then
            task.wait()
        end
    end

    t2 = t5
    v1 = v12
    t3 = t6

    return t5, v12, t6
end

function t1.Start(p4, p5, p6) -- line: 61
    -- upvalues: AssetService (copy), RunService (copy), loadFrames (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "BikeColorBackground"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ClipsDescendants = true
    Frame.Parent = p4

    local v23, v24, v25, v26 = pcall(loadFrames)

    if not v23 then
        warn("[MenuBackgroundFX] Reference motion: " .. tostring(v24))
        Frame:Destroy()

        return
    end

    local v27 = AssetService:CreateEditableImage({
        Size = Vector2.new(v25.frameWidth, v25.frameHeight)
    })

    if v27 then
        local v28 = Content.fromObject(v27)
        local t7 = {}

        for v29, v30 in p6.LightLanes do
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "ReferenceLightLane" .. v29
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.Position = UDim2.fromScale(0.5, v30.Center)
            ImageLabel.Size = UDim2.fromScale(1.12, v30.Height)
            ImageLabel.ImageContent = v28
            ImageLabel.ImageRectOffset = Vector2.new(0, v30.Top)
            ImageLabel.ImageRectSize = Vector2.new(v25.frameWidth, v30.Bottom - v30.Top)
            ImageLabel.Parent = Frame

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Name = "SoftEdges"
            UIGradient.Rotation = 90
            UIGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.16, 0),
                NumberSequenceKeypoint.new(0.84, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            UIGradient.Parent = ImageLabel
            table.insert(t7, {
                image = ImageLabel,
                lane = v30,
                phase = (v29 - 1) * 2.1,
                index = v29
            })
        end

        local v31 = p6.Colors[p5:GetAttribute("SelectedBike")] or p6.Colors.Ducati
        local v32 = v31
        local v33 = v31

        local function changeColor() -- line: 83
            -- upvalues: p5 (copy), p6 (copy), Frame (copy), v33 (ref)
            local v34 = p5:GetAttribute("SelectedBike") or "Ducati"

            v33 = p6.Colors[v34] or p6.Colors.Ducati
            Frame:SetAttribute("Bike", v34)
            Frame:SetAttribute("TargetColor", v33)
        end

        local connection = p5:GetAttributeChangedSignal("SelectedBike"):Connect(changeColor)
        local v36 = p5:GetAttribute("SelectedBike") or "Ducati"

        v33 = p6.Colors[v36] or p6.Colors.Ducati
        Frame:SetAttribute("Bike", v36)

        local v37 = v33

        Frame:SetAttribute("TargetColor", v37)

        local v38 = (#v24 - 1) / v25.fps
        local v39 = buffer.create(v25.frameWidth * v25.frameHeight * 4)
        local n5 = 0
        local n6 = 1e999
        local n7 = -1
        local n8 = -1

        local function onScreen() -- line: 97
            -- upvalues: Frame (copy)
            local FrameParent = Frame.Parent

            while true do
                if not FrameParent then
                    return false
                end

                if FrameParent:IsA("GuiObject") then
                    if FrameParent.Visible then
                        FrameParent = FrameParent.Parent
                        continue
                    end

                    break
                end

                if FrameParent:IsA("LayerCollector") then
                    return FrameParent.Enabled
                end

                FrameParent = FrameParent.Parent
            end

            return false
        end

        local connection2
        local v40 = false

        local function stop() -- line: 108
            -- upvalues: v27 (copy), connection (copy), connection2 (ref), v40 (ref)
            if v40 then
                return
            end

            v40 = true
            connection:Disconnect()

            if connection2 then
                connection2:Disconnect()
            end

            v27:Destroy()
        end

        local function draw(p7) -- line: 114
            -- upvalues: p6 (copy), Frame (copy), v24 (copy), v25 (copy), v26 (copy), v27 (copy), t7 (copy), v32 (ref), v33 (ref), connection (copy), v38 (copy), v39 (copy), n5 (ref), n6 (ref), n7 (ref), n8 (ref), onScreen (copy), connection2 (ref), v40 (ref)
            if Frame.Parent then
                n5 += p7
                n6 += p7

                if onScreen() then
                    local v41 = v32
                    local v42 = v33

                    v32 = v41:Lerp(v42, 1 - math.exp(-p7 * p6.ColorSpeed))

                    for _, v44 in t7 do
                        local v45 = n5 * 2 * 3.141592653589793 / (14 + v44.index * 3) + v44.phase
                        local v46 = 1.12 + math.sin(v45) * p6.LengthBreath
                        local v48 = 1 + math.sin(v45 * 0.81 + 1.2) * p6.ThicknessBreath

                        v44.image.ImageColor3 = v32
                        v44.image.Size = UDim2.fromScale(v46, v44.lane.Height * v48)
                        v44.image.Position = UDim2.fromScale(0.5, v44.lane.Center + math.sin(v45 * 0.67) * 0.012)
                    end

                    local v51 = n5
                    local v50 = v51 % (v38 * 2)

                    if not (v50 <= v38) or not v50 then
                        v50 = v38 * 2 - v50
                    end

                    if v50 < 0.8 then
                        local v52 = v50 / 0.8

                        v50 = 0.8 * (2 * v52 * v52 - v52 * v52 * v52)
                    elseif v38 - 0.8 < v50 then
                        local v53 = (v38 - v50) / 0.8

                        v50 = v38 - 0.8 * (2 * v53 * v53 - v53 * v53 * v53)
                    end

                    local v54 = v50 * v25.fps
                    local v57 = math.min(math.floor(v54) + 1, #v24)
                    local v60 = math.min(v57 + 1, #v24)
                    local v61 = v54 - math.floor(v54)
                    local v62 = v24[v57]
                    local v63 = v24[v60]

                    if n6 >= 0.03333333333333333 and (v57 ~= n7 or math.abs(v61 - n8) > 0.004) then
                        n6 = 0
                        n7 = v57
                        n8 = v61

                        for i = 0, v25.frameWidth * v25.frameHeight - 1 do
                            local v66 = buffer.readu8(v62, i)
                            local v67 = 16777215 + (v66 + (buffer.readu8(v63, i) - v66) * v61 + 0.5) // 1 * 16777216

                            buffer.writeu32(v39, i * 4, v67)
                        end

                        v27:WritePixelsBuffer(Vector2.zero, Vector2.new(v25.frameWidth, v25.frameHeight), v39)
                        Frame:SetAttribute("MotionFrame", v57)
                        Frame:SetAttribute("MotionTime", v50)
                    end

                    local v69 = v26[v57]
                    local v70 = v26[v60]

                    Frame:SetAttribute("CurrentColor", v32)
                    Frame:SetAttribute("LeftBrightness", (math.clamp((v69[1] + (v70[1] - v69[1]) * v61) / 255 * 3, 0.15, 1)))
                    Frame:SetAttribute("RightBrightness", (math.clamp((v69[2] + (v70[2] - v69[2]) * v61) / 255 * 3, 0.15, 1)))
                end
            elseif not v40 then
                v40 = true
                connection:Disconnect()

                if connection2 then
                    connection2:Disconnect()
                end

                v27:Destroy()
            end
        end

        Frame:SetAttribute("MotionSource", "Supplied video: background light only")
        Frame:SetAttribute("SourceFrames", #v24)
        draw(0)
        connection2 = RunService.RenderStepped:Connect(draw)
        Frame.Destroying:Connect(stop)

        return Frame
    end

    Frame:Destroy()
    warn("[MenuBackgroundFX] Image memory unavailable")
end

return t1
