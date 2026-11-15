-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

return {
    New = function(p1, p2, p3) -- New | line: 4
        -- upvalues: Players (copy), UserInputService (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = "RaceMinimap"
        Frame.AnchorPoint = Vector2.new(0, 1)
        Frame.Size = UDim2.fromOffset(146, 158)
        Frame.Visible = false
        Frame.BackgroundColor3 = Color3.fromRGB(15, 22, 26)
        Frame.BackgroundTransparency = 0.3
        Frame.BorderSizePixel = 0
        Frame.ClipsDescendants = true
        Frame.Parent = p1
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

        local UIScale = Instance.new("UIScale", Frame)
        local Frame2 = Instance.new("Frame", Frame)

        Frame2.Name = "Track"
        Frame2.Size = UDim2.fromScale(1, 1)
        Frame2.BackgroundTransparency = 1

        local MapForward = p2.MapForward

        local function flat(p4) -- line: 11
            -- upvalues: MapForward (copy)
            return Vector2.new(-p4.X * MapForward.X + p4.Z * MapForward.Y, -p4.X * MapForward.Y - p4.Z * MapForward.X)
        end

        local v1 = Vector2.new(1e999, 1e999)
        local v2 = Vector2.new((-1e999), (-1e999))

        for _, v3 in p2.Points do
            local v4 = Vector2.new(-v3.X * MapForward.X + v3.Z * MapForward.Y, -v3.X * MapForward.Y - v3.Z * MapForward.X)

            v1 = Vector2.new(math.min(v1.X, v4.X), (math.min(v1.Y, v4.Y)))
            v2 = Vector2.new(math.max(v2.X, v4.X), (math.max(v2.Y, v4.Y)))
        end

        local v9 = math.min(122 / (v2.X - v1.X), 134 / (v2.Y - v1.Y))
        local v10 = Vector2.new(73, 79) - (v1 + v2) * 0.5 * v9

        local function project(p5) -- line: 16
            -- upvalues: MapForward (copy), v9 (copy), v10 (copy)
            return Vector2.new(-p5.X * MapForward.X + p5.Z * MapForward.Y, -p5.X * MapForward.Y - p5.Z * MapForward.X) * v9 + v10
        end

        local function line(p6, p7, p8, p9, p10) -- line: 17
            -- upvalues: Frame2 (copy)
            local v11 = p7 - p6
            local Frame = Instance.new("Frame")

            Frame.Name = p10 or "TrackLine"
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.fromOffset((p6.X + p7.X) / 2, (p6.Y + p7.Y) / 2)
            Frame.Size = UDim2.fromOffset(v11.Magnitude + 0.6, p9 or 2)
            Frame.Rotation = math.deg((math.atan2(v11.Y, v11.X)))
            Frame.BackgroundColor3 = p8
            Frame.BorderSizePixel = 0
            Frame.Parent = Frame2

            return Frame
        end

        local v13 = Color3.fromRGB(242, 244, 244)
        local v14 = Color3.fromRGB(126, 143, 149)
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "SmoothTrackOutline"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Size = UDim2.fromScale(1, 1)
        ImageLabel.Visible = false
        ImageLabel.Parent = Frame2

        local function v15() -- line: 31
            -- upvalues: p2 (copy), Frame2 (copy), MapForward (copy), v9 (copy), v10 (copy), v13 (copy), v14 (copy)
            local v16 = #p2.Points
            local v19 = math.max(1, (math.floor(v16 / 320)))
            local t2 = {}

            for i = 1, v16, v19 do
                local v20 = p2.Points[i]

                table.insert(t2, Vector2.new(-v20.X * MapForward.X + v20.Z * MapForward.Y, -v20.X * MapForward.Y - v20.Z * MapForward.X) * v9 + v10)
            end

            local v22 = #t2

            local function cp(p11) -- line: 35
                -- upvalues: t2 (copy), v22 (copy)
                local v23 = t2[(p11 - 1) % v22 + 1]
                local v24 = (t2[p11 % v22 + 1] - t2[(p11 - 2) % v22 + 1]) / 6

                return Path2DControlPoint.new(UDim2.fromScale(v23.X / 146, v23.Y / 158), UDim2.fromScale(-v24.X / 146, -v24.Y / 158), UDim2.fromScale(v24.X / 146, v24.Y / 158))
            end

            for _, v25 in {
                    { v14, 4, "TrackOutline", 1 },
                    { v13, 2, "TrackLine", 2 }
                } do
                local n1 = 1

                while true do
                    local v28 = math.min(n1 + 90, v22 + 1)
                    local t3 = {}

                    for j = n1, v28 do
                        table.insert(t3, cp(j))
                    end

                    local Path2D = Instance.new("Path2D")

                    Path2D.Name = v25[3]
                    Path2D.Color3 = v25[1]
                    Path2D.Thickness = v25[2]
                    Path2D.ZIndex = v25[4]
                    Path2D:SetControlPoints(t3)
                    Path2D.Parent = Frame2

                    if v22 < v28 then
                        break
                    end

                    n1 = v28
                end
            end
        end

        if not pcall(v15) then
            for _, child in Frame2:GetChildren() do
                if child:IsA("Path2D") then
                    child:Destroy()
                end
            end

            local v29 = #p2.Points
            local v32 = math.max(1, (math.floor(v29 / 160)))
            local t4 = {}

            for i = 1, v29, v32 do
                local v33 = p2.Points[i]

                table.insert(t4, Vector2.new(-v33.X * MapForward.X + v33.Z * MapForward.Y, -v33.X * MapForward.Y - v33.Z * MapForward.X) * v9 + v10)
            end

            for _ = 1, 2 do
                local t5 = {}
                local v35 = #t4

                for i = 1, v35 do
                    local v36 = t4[i]
                    local v37 = t4[i % v35 + 1]

                    table.insert(t5, v36:Lerp(v37, 0.25))
                    table.insert(t5, v36:Lerp(v37, 0.75))
                end

                t4 = t5
            end

            for _, v38 in {
                    { v14, 3.4, "TrackOutline", 1 },
                    { v13, 1.7, "TrackLine", 2 }
                } do
                for j = 1, #t4 do
                    local v39 = t4[j]

                    line(v39, t4[j % #t4 + 1], v38[1], v38[2], v38[3]).ZIndex = v38[4]

                    local Frame = Instance.new("Frame")

                    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
                    Frame.Position = UDim2.fromOffset(v39.X, v39.Y)
                    Frame.Size = UDim2.fromOffset(v38[2], v38[2])
                    Frame.BackgroundColor3 = v38[1]
                    Frame.BorderSizePixel = 0
                    Frame.ZIndex = v38[4]
                    Frame.Parent = Frame2
                    Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)
                end
            end
        end

        for v40, v41 in p3.Gates do
            local v42 = v41[2]:Cross((Vector3.new(0, 1, 0)))
            local v43 = v41[1] - v42 * 25
            local v44 = Vector2.new(-v43.X * MapForward.X + v43.Z * MapForward.Y, -v43.X * MapForward.Y - v43.Z * MapForward.X) * v9 + v10
            local v45 = v41[1] + v42 * 25
            local v46 = Vector2.new(-v45.X * MapForward.X + v45.Z * MapForward.Y, -v45.X * MapForward.Y - v45.Z * MapForward.X) * v9 + v10
            local v47 = v41[1]
            local v48 = Vector2.new(-v47.X * MapForward.X + v47.Z * MapForward.Y, -v47.X * MapForward.Y - v47.Z * MapForward.X) * v9 + v10
            local Unit = (v46 - v44).Unit

            line(v48 - Unit * 5, v48 + Unit * 5, v40 == 1 and Color3.fromRGB(225, 37, 46) or Color3.fromRGB(207, 214, 215), 1.4, if v40 == 1 then "FinishLine" else "SectorLine" .. v40).ZIndex = 3
        end

        local t6 = {}
        local t7 = {}
        local v49 = Players.LocalPlayer.UserId

        local function styleDot(p12, p13) -- line: 71
            -- upvalues: v49 (ref)
            local v50 = p13 == v49

            p12.Size = UDim2.fromOffset(v50 and 9 or 6, v50 and 9 or 6)
            p12.BackgroundColor3 = v50 and Color3.fromRGB(242, 37, 48) or Color3.fromRGB(176, 184, 188)
            p12.ZIndex = v50 and 5 or 4
        end

        local function dot(p14) -- line: 77
            -- upvalues: Frame (copy), t6 (copy), styleDot (copy)
            if t6[p14] then
                return t6[p14]
            end

            local Frame2 = Instance.new("Frame")

            Frame2.Name = "Rider_" .. p14
            Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame2.BorderSizePixel = 0
            styleDot(Frame2, p14)
            Frame2.Parent = Frame
            Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0)

            local UIStroke = Instance.new("UIStroke", Frame2)

            UIStroke.Color = Color3.fromRGB(15, 22, 26)
            UIStroke.Thickness = 1
            UIStroke.Transparency = 0.35
            t6[p14] = Frame2

            return Frame2
        end

        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "CornerLabel"
        TextLabel.AnchorPoint = Vector2.new(0.5, 1)
        TextLabel.Size = UDim2.fromOffset(200, 20)
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderSizePixel = 0
        TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        TextLabel.TextStrokeTransparency = 0.55
        TextLabel.Font = Enum.Font.GothamBlack
        TextLabel.TextSize = 14
        TextLabel.TextColor3 = v13
        TextLabel.RichText = true
        TextLabel.AutoLocalize = false
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel.Text = ""
        TextLabel.Visible = false
        TextLabel.Parent = p1

        local UIScale2 = Instance.new("UIScale", TextLabel)
        local n2 = 0
        local number = nil
        local v51 = #p2.Points

        local function cornerAt(p15) -- line: 93
            -- upvalues: p2 (copy), v51 (copy)
            local n3 = 1
            local n4 = 1e999

            for i = 1, v51, 3 do
                local Magnitude = (p2.Points[i] - p15).Magnitude

                if Magnitude < n4 then
                    n4 = Magnitude
                    n3 = i
                end
            end

            for i = n3 - 3, n3 + 3 do
                local v52 = (i - 1) % v51 + 1
                local Magnitude = (p2.Points[v52] - p15).Magnitude

                if Magnitude < n4 then
                    n4 = Magnitude
                    n3 = v52
                end
            end

            if n4 > 140 then
                return nil
            end

            local n5 = 1e999
            local v53

            for _, v54 in p2.Corners or {} do
                local v55 = (n3 - v54.index + v51 / 2) % v51 - v51 / 2

                if v55 >= -24 and v55 <= 16 then
                    local v56 = math.abs(v55) * (if v55 > 0 then 1.4 else 1)

                    if v56 < n5 then
                        n5 = v56
                        v53 = v54
                    end
                end
            end

            return v53
        end

        local t8 = {
            Root = Frame,
            CornerLabel = TextLabel
        }

        function t8.Resize(p16, p17) -- line: 106
            -- upvalues: Frame (copy), UIScale (copy), TextLabel (copy), UIScale2 (copy)
            UIScale.Scale = math.min(p17 * 0.8, 1.5)
            Frame.Position = UDim2.fromOffset(18 * p17, p16.Y - 16 * p17)
            Frame:SetAttribute("MapScale", UIScale.Scale)
            UIScale2.Scale = UIScale.Scale
            TextLabel.Position = UDim2.fromOffset(18 * p17 + 73 * UIScale.Scale, p16.Y - 16 * p17 - 161 * UIScale.Scale)
        end

        function t8.Update(p18, p19, p20) -- line: 111
            -- upvalues: Frame (copy), MapForward (copy), v9 (copy), v10 (copy), t6 (copy), t7 (copy), v49 (ref), styleDot (copy), dot (copy), TextLabel (copy), n2 (ref), number (ref), cornerAt (copy), Players (copy), UserInputService (copy)
            local v58 = p19 == true and not UserInputService.TouchEnabled

            Frame.Visible = v58

            if not v58 then
                TextLabel.Visible = false
                number = nil

                return
            end

            p20 = p20 or Players.LocalPlayer.UserId

            if p20 ~= v49 then
                v49 = p20
                number = nil

                for v60, v61 in t6 do
                    styleDot(v61, v60)
                end
            end

            n2 += p18

            if n2 > 0.15 then
                n2 = 0

                local RaceBikes = workspace:FindFirstChild("RaceBikes")
                local child

                if RaceBikes then
                    for _, child2 in RaceBikes:GetChildren() do
                        if child2:GetAttribute("OwnerUserId") == v49 and child2.PrimaryPart then
                            child = child2
                            break
                        end
                    end
                end

                local v62 = child and cornerAt(child.PrimaryPart.Position)

                if v62 then
                    if number ~= v62.number then
                        number = v62.number

                        local number2, v63

                        if not v62.name or v62.name == "Turn " .. v62.number then
                            number2 = v62.number
                            v63 = ""
                        else
                            local name = v62.name

                            number2 = v62.number
                            v63 = name and "  <font size=\"11\" color=\"#C3CDD1\" weight=\"500\">" .. name:upper() .. "</font>" or ""
                        end

                        TextLabel.Text = "TURN " .. number2 .. v63
                    end

                    TextLabel.Visible = true
                else
                    number = nil
                    TextLabel.Visible = false
                end

                Frame:SetAttribute("CurrentCorner", number)
            end

            local t9 = {}
            local RaceBikes = workspace:FindFirstChild("RaceBikes")

            if RaceBikes then
                for _, child in RaceBikes:GetChildren() do
                    local OwnerUserId = child:GetAttribute("OwnerUserId")
                    local RiderSeat = child:FindFirstChild("RiderSeat")

                    if OwnerUserId and child.PrimaryPart and RiderSeat and RiderSeat.Occupant and child:GetAttribute("Crash") == "" then
                        local PrimaryPartPosition = child.PrimaryPart.Position
                        local v64 = Vector2.new(-PrimaryPartPosition.X * MapForward.X + PrimaryPartPosition.Z * MapForward.Y, -PrimaryPartPosition.X * MapForward.Y - PrimaryPartPosition.Z * MapForward.X) * v9 + v10

                        if v64.X > -8 and v64.X < 154 and v64.Y > -8 and v64.Y < 166 then
                            local v65 = dot(OwnerUserId)
                            local v66 = t7[OwnerUserId]

                            if v66 and (v64 - v66).Magnitude < 35 then
                                v64 = v66:Lerp(v64, 1 - math.exp(-p18 * 18)) or v64
                            end

                            t7[OwnerUserId] = v64
                            v65.Position = UDim2.fromOffset(math.clamp(v64.X, 4, 142), (math.clamp(v64.Y, 4, 154)))
                            v65.Visible = true
                            t9[OwnerUserId] = true
                        else
                            t7[OwnerUserId] = nil
                        end
                    end
                end
            end

            local n6 = 0

            for v69, v70 in t6 do
                v70.Visible = t9[v69] == true

                if v70.Visible then
                    n6 += 1
                end
            end

            Frame:SetAttribute("RiderCount", n6)
        end

        return t8
    end
}
