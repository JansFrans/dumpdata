-- https://lua.expert

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local Config = require(MotoLegends:WaitForChild("Config"))
local BikeCams = require(MotoLegends:WaitForChild("BikeCams"))
local RemoteBikes = require(MotoLegends:WaitForChild("RemoteBikes"))
local SettingsBridge = require(MotoLegends:WaitForChild("SettingsBridge"))
local t1 = {
    SETTINGS = {
        Cell = 80,
        Radius = 200,
        LowRadius = 120,
        Ahead = 110,
        ClonesPerFrame = 150,
        RemovalsPerFrame = 400,
        BikeRadius = 330,
        BikeRefresh = 0.3,
        IndexBatch = 6000,
        Modes = { "Tail", "Dash", "Heli", "Front", "Rear" },
        Names = {
            Tail = "TAIL CAM",
            Dash = "RIDER DASHCAM",
            Heli = "HELICOPTER",
            Front = "FRONT TYRE CAM",
            Rear = "REAR TYRE CAM"
        },
        SkipFolders = {
            MarshalResponseAreas = true,
            RaceSessionGates = true
        }
    }
}
local SETTINGS = t1.SETTINGS
local t2 = {
    state = "none",
    cells = {}
}

local function cellKey(p1, p2) -- line: 34
    return p1 .. "," .. p2
end

local function buildIndex() -- line: 35
    -- upvalues: Config (copy), SETTINGS (copy), t2 (copy)
    if t2.state == "none" then
        t2.state = "building"
        task.spawn(function() -- line: 38
            -- upvalues: Config (copy), SETTINGS (copy), t2 (copy)
            local v1 = workspace:FindFirstChild(Config.Track)

            if v1 then
                local cells = t2.cells

                local function add(p3, p4) -- line: 42
                    -- upvalues: cells (copy)
                    local v2 = cells[p3]

                    if not v2 then
                        v2 = {}
                        cells[p3] = v2
                    end

                    v2[#v2 + 1] = p4
                end

                local n1 = 0

                for _, child in v1:GetChildren() do
                    if not SETTINGS.SkipFolders[child.Name] then
                        local Descendants = child:GetDescendants()

                        if child:IsA("BasePart") then
                            table.insert(Descendants, child)
                        end

                        local v3 = n1

                        for _, v4 in Descendants do
                            if v4:IsA("BasePart") and v4.Transparency < 0.98 and v4.Archivable then
                                local Position = v4.Position
                                local v5 = v4.Size.Magnitude * 0.5

                                if v5 < SETTINGS.Cell then
                                    local v9 = math.floor(Position.X / SETTINGS.Cell) .. "," .. math.floor(Position.Z / SETTINGS.Cell)
                                    local v10 = cells[v9]

                                    if not v10 then
                                        v10 = {}
                                        cells[v9] = v10
                                    end

                                    v10[#v10 + 1] = v4
                                else
                                    for i = math.floor((Position.X - v5) / SETTINGS.Cell), math.floor((Position.X + v5) / SETTINGS.Cell) do
                                        for j = math.floor((Position.Z - v5) / SETTINGS.Cell), math.floor((Position.Z + v5) / SETTINGS.Cell) do
                                            local v17 = i .. "," .. j
                                            local v18 = cells[v17]

                                            if not v18 then
                                                v18 = {}
                                                cells[v17] = v18
                                            end

                                            v18[#v18 + 1] = v4
                                        end
                                    end
                                end

                                v3 += 1

                                if v3 % SETTINGS.IndexBatch == 0 then
                                    task.wait()
                                end
                            end

                            n1 = v3
                        end
                    end
                end
            end

            t2.state = "ready"
        end)
    end
end

local function strip(p5) -- line: 64
    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("LuaSourceContainer")
            or descendant:IsA("Sound")
            or descendant:IsA("LayerCollector")
            or descendant:IsA("ParticleEmitter")
            or descendant:IsA("Trail")
            or descendant:IsA("Beam")
            or descendant:IsA("Light")
            or descendant:IsA("ProximityPrompt")
            or descendant:IsA("ClickDetector")
            or descendant:IsA("AudioEmitter")
            or descendant:IsA("Fire")
            or descendant:IsA("Smoke")
            or descendant:IsA("Sparkles") then
            descendant:Destroy()
        end
    end
end

local function bikeOf(p6, p7) -- line: 72
    for _, v19 in { "RaceBikes", "CrashedBikes" } do
        local v20 = workspace:FindFirstChild(v19)

        if v20 then
            for _, child in v20:GetChildren() do
                if child:GetAttribute("OwnerUserId") == p6 and child.PrimaryPart then
                    if (child:GetAttribute("Crash") or "") ~= "" then
                        if p7 then
                            return child.PrimaryPart, false
                        end
                    else
                        local RiderSeat = child:FindFirstChild("RiderSeat")

                        if RiderSeat and RiderSeat.Occupant then
                            return child.PrimaryPart, true
                        end
                    end
                end
            end
        end
    end

    return nil
end

local function lowQuality() -- line: 85
    -- upvalues: SettingsBridge (copy)
    return SettingsBridge.ready and SettingsBridge.get("quality") == "Low"
end

function t1.New(p8) -- line: 88
    -- upvalues: Players (copy), Lighting (copy), Config (copy), BikeCams (copy), RemoteBikes (copy), SettingsBridge (copy), SETTINGS (copy), t2 (copy), strip (copy), bikeOf (copy)
    local t3 = {
        target = nil,
        mode = "Tail",
        scanAt = 0,
        center = nil,
        heli = {},
        loaded = {},
        cloneOf = {},
        queue = {},
        dyn = {}
    }
    local Frame = Instance.new("Frame")

    Frame.Name = "Sky"
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.Parent = p8

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Parent = Frame

    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "View"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Size = UDim2.fromScale(1, 1)
    ViewportFrame.Parent = Frame

    local WorldModel = Instance.new("WorldModel")

    WorldModel.Parent = ViewportFrame

    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 70
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Cover"
    Frame2.BorderSizePixel = 0
    Frame2.BackgroundColor3 = Color3.fromRGB(8, 9, 13)
    Frame2.Size = UDim2.fromScale(1, 1)
    Frame2.ZIndex = 3
    Frame2.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Mode"
    TextLabel.BackgroundColor3 = Color3.fromRGB(8, 9, 13)
    TextLabel.BackgroundTransparency = 0.25
    TextLabel.BorderSizePixel = 0
    TextLabel.Position = UDim2.fromOffset(6, 6)
    TextLabel.AutomaticSize = Enum.AutomaticSize.X
    TextLabel.Size = UDim2.fromOffset(0, 13)
    TextLabel.ZIndex = 4
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
    TextLabel.TextSize = 8
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.AutoLocalize = false
    TextLabel.Text = ""
    TextLabel.Parent = Frame

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 5)
    UIPadding.PaddingRight = UDim.new(0, 5)
    UIPadding.Parent = TextLabel
    t3.Frame = Frame

    local function lighting() -- line: 102
        -- upvalues: UIGradient (copy), ViewportFrame (copy), Lighting (copy)
        local ClockTime = Lighting.ClockTime

        if ClockTime < 6.3 or ClockTime > 18.2 then
            UIGradient.Color = ColorSequence.new(Color3.fromRGB(6, 9, 22), Color3.fromRGB(28, 38, 66))
            ViewportFrame.Ambient = Color3.fromRGB(150, 150, 156)
            ViewportFrame.LightColor = Color3.fromRGB(205, 205, 210)
            ViewportFrame.LightDirection = Vector3.new(-0.25, -1, -0.2)
        else
            UIGradient.Color = ColorSequence.new(Color3.fromRGB(96, 150, 214), Color3.fromRGB(196, 222, 244))
            ViewportFrame.Ambient = Color3.fromRGB(150, 150, 150)
            ViewportFrame.LightColor = Color3.fromRGB(255, 250, 238)
            ViewportFrame.LightDirection = -Lighting:GetSunDirection()
        end
    end

    local function release(p9) -- line: 114
        -- upvalues: t3 (copy)
        local v21 = t3.cloneOf[p9]

        if v21 then
            v21.refs -= 1

            if v21.refs <= 0 then
                v21.clone:Destroy()
                t3.cloneOf[p9] = nil
            end
        end
    end

    local function unloadCell(p10) -- line: 119
        -- upvalues: t3 (copy)
        local v22 = t3.loaded[p10]

        if not v22 then
            return
        end

        for i = 1, v22.done do
            local v23 = v22.parts[i]
            local v24 = t3.cloneOf[v23]

            if v24 then
                v24.refs -= 1

                if v24.refs <= 0 then
                    v24.clone:Destroy()
                    t3.cloneOf[v23] = nil
                end
            end
        end

        t3.loaded[p10] = nil
    end

    local function desired(p11, p12) -- line: 124
        -- upvalues: SETTINGS (copy)
        local t4 = {}
        local X, Z = p11.X, p11.Z

        for i = math.floor((X - p12) / SETTINGS.Cell), math.floor((X + p12) / SETTINGS.Cell) do
            for j = math.floor((Z - p12) / SETTINGS.Cell), math.floor((Z + p12) / SETTINGS.Cell) do
                local v31 = (i + 0.5) * SETTINGS.Cell
                local v32 = (j + 0.5) * SETTINGS.Cell
                local v34 = math.sqrt((v31 - X) ^ 2 + (v32 - Z) ^ 2)

                if v34 <= p12 + SETTINGS.Cell * 0.71 then
                    t4[i .. "," .. j] = v34
                end
            end
        end

        return t4
    end

    local function stream(p13) -- line: 136
        -- upvalues: t3 (copy), WorldModel (copy), desired (copy), SettingsBridge (copy), SETTINGS (copy), t2 (copy), strip (copy)
        if t2.state ~= "ready" then
            return 0
        end

        local LowRadius = SettingsBridge.ready and SettingsBridge.get("quality") == "Low" and SETTINGS.LowRadius or SETTINGS.Radius

        if not t3.center or (p13 - t3.center).Magnitude > SETTINGS.Cell * 0.4 then
            t3.center = p13

            local v35 = desired(p13, LowRadius)
            local t5 = {}

            for v36 in t3.loaded do
                if not v35[v36] then
                    t5[#t5 + 1] = v36
                end
            end

            t3.drop = t5

            local t6 = {}

            for v37, v38 in v35 do
                local v39 = t3.loaded[v37]

                if not v39 then
                    local v40 = t2.cells[v37]

                    if v40 then
                        v39 = {
                            done = 0,
                            parts = v40
                        }
                        t3.loaded[v37] = v39
                    end
                end

                if v39 and v39.done < #v39.parts then
                    t6[#t6 + 1] = {
                        k = v37,
                        d = v38
                    }
                end
            end

            table.sort(t6, function(p14, p15) -- line: 152
                return p14.d < p15.d
            end)
            t3.queue = t6
        end

        local n2 = 0

        while t3.drop and #t3.drop > 0 and n2 < SETTINGS.RemovalsPerFrame do
            local v41 = table.remove(t3.drop)
            local v42 = t3.loaded[v41]

            if v42 then
                n2 += v42.done

                local v43 = t3.loaded[v41]

                if v43 then
                    for i = 1, v43.done do
                        local v44 = v43.parts[i]
                        local v45 = t3.cloneOf[v44]

                        if v45 then
                            v45.refs -= 1

                            if v45.refs <= 0 then
                                v45.clone:Destroy()
                                t3.cloneOf[v44] = nil
                            end
                        end
                    end

                    t3.loaded[v41] = nil
                end
            end
        end

        local v46 = SETTINGS.ClonesPerFrame

        while v46 > 0 and #t3.queue > 0 do
            local v47 = t3.queue[1]
            local v48 = t3.loaded[v47.k]

            if v48 then
                while v46 > 0 and v48.done < #v48.parts do
                    v48.done += 1

                    local v49 = v48.parts[v48.done]
                    local v50 = t3.cloneOf[v49]

                    if v50 then
                        v50.refs += 1
                    elseif v49.Parent and v49:IsDescendantOf(workspace) then
                        local clone = v49:Clone()

                        if clone then
                            if #clone:GetChildren() > 0 then
                                strip(clone)
                            end

                            clone.Anchored = true
                            clone.CanCollide = false
                            clone.CanQuery = false
                            clone.CanTouch = false
                            clone.Parent = WorldModel
                            t3.cloneOf[v49] = {
                                refs = 1,
                                clone = clone
                            }
                        else
                            t3.cloneOf[v49] = {
                                refs = 1,
                                clone = Instance.new("Folder")
                            }
                        end

                        v46 -= 1
                    else
                        t3.cloneOf[v49] = {
                            refs = 1,
                            clone = Instance.new("Folder")
                        }
                    end
                end

                if v48.done >= #v48.parts then
                    table.remove(t3.queue, 1)
                end
            else
                table.remove(t3.queue, 1)
            end
        end

        return #t3.queue
    end

    local function dropDyn(p16) -- line: 186
        -- upvalues: t3 (copy)
        local v51 = t3.dyn[p16]

        if v51 then
            v51.clone:Destroy()
            t3.dyn[p16] = nil
        end
    end

    local function addDyn(p17) -- line: 187
        -- upvalues: t3 (copy), WorldModel (copy), strip (copy)
        local Archivable = p17.Archivable

        p17.Archivable = true

        local function v52() -- line: 189
            -- upvalues: p17 (copy)
            return p17:Clone()
        end

        local ok, result = pcall(v52)

        p17.Archivable = Archivable

        if not ok or not result then
            return
        end

        strip(result)

        local t8 = {}
        local t9 = {}

        for _, descendant in p17:GetDescendants() do
            if descendant:IsA("BasePart") then
                t8[#t8 + 1] = descendant
            end
        end

        for _, descendant in result:GetDescendants() do
            if descendant:IsA("BasePart") then
                t9[#t9 + 1] = descendant
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
            end
        end

        local Humanoid = result:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end

        local t10 = {}

        for v53, v54 in t8 do
            if t9[v53] then
                t10[#t10 + 1] = {
                    v54,
                    t9[v53]
                }
            end
        end

        result.Parent = WorldModel
        t3.dyn[p17] = {
            clone = result,
            pairs = t10,
            count = #t8
        }
    end

    local function scanDyn(p18) -- line: 202
        -- upvalues: t3 (copy), addDyn (copy), Players (copy), SETTINGS (copy)
        local t11 = {}

        local function consider(p19, p20) -- line: 204
            -- upvalues: p18 (copy), t11 (copy), t3 (copy), addDyn (copy), SETTINGS (copy)
            if not ((p20 - p18).Magnitude <= SETTINGS.BikeRadius) then
                return
            end

            t11[p19] = true

            local v55 = t3.dyn[p19]

            if not v55 then
                addDyn(p19)

                return
            end

            local n3 = 0

            for _, descendant in p19:GetDescendants() do
                if descendant:IsA("BasePart") then
                    n3 += 1
                end
            end

            if n3 ~= v55.count then
                local v56 = t3.dyn[p19]

                if v56 then
                    v56.clone:Destroy()
                    t3.dyn[p19] = nil
                end

                addDyn(p19)
            end
        end

        for _, v57 in { "RaceBikes", "CrashedBikes" } do
            local v58 = workspace:FindFirstChild(v57)

            if v58 then
                for _, child in v58:GetChildren() do
                    if child:IsA("Model") and child.PrimaryPart then
                        consider(child, child.PrimaryPart.Position)
                    end
                end
            end
        end

        for _, player in Players:GetPlayers() do
            local Character = player.Character
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart then
                consider(Character, HumanoidRootPart.Position)
            end
        end

        for v59 in t3.dyn do
            if not t11[v59] then
                local v60 = t3.dyn[v59]

                if v60 then
                    v60.clone:Destroy()
                    t3.dyn[v59] = nil
                end
            end
        end
    end

    function t3.SetTarget(p21, p22, p23) -- line: 225
        -- upvalues: Frame2 (copy), TextLabel (copy), lighting (copy), Config (copy), SETTINGS (copy), t2 (copy)
        if t2.state == "none" then
            t2.state = "building"
            task.spawn(function() -- line: 38
                -- upvalues: Config (copy), SETTINGS (copy), t2 (copy)
                local v61 = workspace:FindFirstChild(Config.Track)

                if v61 then
                    local cells = t2.cells

                    local function add(p24, p25) -- line: 42
                        -- upvalues: cells (copy)
                        local v62 = cells[p24]

                        if not v62 then
                            v62 = {}
                            cells[p24] = v62
                        end

                        v62[#v62 + 1] = p25
                    end

                    local n4 = 0

                    for _, child in v61:GetChildren() do
                        if not SETTINGS.SkipFolders[child.Name] then
                            local Descendants = child:GetDescendants()

                            if child:IsA("BasePart") then
                                table.insert(Descendants, child)
                            end

                            local v63 = n4

                            for _, v64 in Descendants do
                                if v64:IsA("BasePart") and v64.Transparency < 0.98 and v64.Archivable then
                                    local Position = v64.Position
                                    local v65 = v64.Size.Magnitude * 0.5

                                    if v65 < SETTINGS.Cell then
                                        local v69 = math.floor(Position.X / SETTINGS.Cell) .. "," .. math.floor(Position.Z / SETTINGS.Cell)
                                        local v70 = cells[v69]

                                        if not v70 then
                                            v70 = {}
                                            cells[v69] = v70
                                        end

                                        v70[#v70 + 1] = v64
                                    else
                                        for i = math.floor((Position.X - v65) / SETTINGS.Cell), math.floor((Position.X + v65) / SETTINGS.Cell) do
                                            for j = math.floor((Position.Z - v65) / SETTINGS.Cell), math.floor((Position.Z + v65) / SETTINGS.Cell) do
                                                local v77 = i .. "," .. j
                                                local v78 = cells[v77]

                                                if not v78 then
                                                    v78 = {}
                                                    cells[v77] = v78
                                                end

                                                v78[#v78 + 1] = v64
                                            end
                                        end
                                    end

                                    v63 += 1

                                    if v63 % SETTINGS.IndexBatch == 0 then
                                        task.wait()
                                    end
                                end

                                n4 = v63
                            end
                        end
                    end
                end

                t2.state = "ready"
            end)
        end

        lighting()
        p21.target = p22
        p21.mode = p23 or p21.mode
        p21.heli = {}
        p21.scanAt = 0
        p21.ready = false
        p21.openedAt = os.clock()
        Frame2.BackgroundTransparency = 0
        TextLabel.Text = SETTINGS.Names[p21.mode] or ""
        TextLabel.TextTransparency = 0
        TextLabel.BackgroundTransparency = 0.25
    end

    function t3.Clear(p26) -- line: 231
        -- upvalues: t3 (copy), Players (copy)
        for v79 in table.clone(p26.loaded) do
            local v80 = t3.loaded[v79]

            if v80 then
                for i = 1, v80.done do
                    local v81 = v80.parts[i]
                    local v82 = t3.cloneOf[v81]

                    if v82 then
                        v82.refs -= 1

                        if v82.refs <= 0 then
                            v82.clone:Destroy()
                            t3.cloneOf[v81] = nil
                        end
                    end
                end

                t3.loaded[v79] = nil
            end
        end

        for _, v83 in p26.cloneOf do
            v83.clone:Destroy()
        end

        table.clear(p26.cloneOf)
        table.clear(p26.loaded)
        p26.queue = {}
        p26.drop = {}
        p26.center = nil

        for v84 in table.clone(p26.dyn) do
            local v85 = t3.dyn[v84]

            if v85 then
                v85.clone:Destroy()
                t3.dyn[v84] = nil
            end
        end

        p26.target = nil

        if Players.LocalPlayer then
            Players.LocalPlayer:SetAttribute("PoseLODFocus", nil)
        end
    end

    function t3.Update(p27, p28) -- line: 240
        -- upvalues: Camera (copy), Frame2 (copy), TextLabel (copy), stream (copy), scanDyn (copy), Players (copy), BikeCams (copy), RemoteBikes (copy), SETTINGS (copy), t2 (copy), bikeOf (copy)
        local v86 = p27.target and Players:GetPlayerByUserId(p27.target)

        if not v86 then
            return false
        end

        local v87 = p27.mode ~= "Heli"
        local v88, v89 = bikeOf(v86.UserId, v87)
        local v90 = v86.Character and v86.Character:FindFirstChild("HumanoidRootPart")
        local v91, v92, X, Z, v93, Position, LocalPlayer, PoseLODFocus, v94, v95, v96, CFrame, v97, BackgroundTransparency, v98, v99, v100, v101, v102

        if v87 and v88 then
            local v103

            v91, v103 = ({
                Tail = BikeCams.Tail,
                Dash = BikeCams.Dash,
                Front = BikeCams.FrontTyre,
                Rear = BikeCams.RearTyre
            })[p27.mode](v88)

            local v104 = v89 and RemoteBikes.Velocity(v86.UserId) or v88.AssemblyLinearVelocity

            v92 = v103 + math.clamp(Vector3.new(v104.X, 0, v104.Z).Magnitude / 360, 0, 1) * 14
            Camera.CFrame = v91
            Camera.FieldOfView = v92
            X = v91.LookVector.X
            Z = v91.LookVector.Z
            v93 = Vector3.new(X, 0, Z)

            local v106 = false

            if v88 or v90 then
                local Position2 = (v88 or v90).Position

                if Position2 then
                    Position = Position2
                    v106 = true
                end
            end

            if not v106 then
                Position = v91.Position
            end

            LocalPlayer = Players.LocalPlayer
            PoseLODFocus = LocalPlayer and LocalPlayer:GetAttribute("PoseLODFocus")

            if LocalPlayer and (typeof(PoseLODFocus) ~= "Vector3" or (PoseLODFocus - Position).Magnitude > 20) then
                LocalPlayer:SetAttribute("PoseLODFocus", Position)
            end

            local v107 = false

            if v87 and v88 then
                local v108 = v91.Position + (v93.Magnitude > 0.01 and v93.Unit or Vector3.new(0, 0, 0)) * SETTINGS.Ahead

                if v108 then
                    v94 = v108
                    v107 = true
                end
            end

            if not v107 then
                v94 = Position
            end

            v95 = stream(v94)
            p27.scanAt -= p28

            if p27.scanAt <= 0 then
                p27.scanAt = SETTINGS.BikeRefresh
                scanDyn(Position)
            end

            for _, v109 in p27.dyn do
                for _, v110 in v109.pairs do
                    v96 = v110[1]

                    if v96.Parent then
                        CFrame = v96.CFrame

                        if v110[2].CFrame ~= CFrame then
                            v110[2].CFrame = CFrame
                        end
                    end
                end
            end

            if not p27.ready and t2.state == "ready" and (v95 == 0 or os.clock() - p27.openedAt > 1.2) then
                p27.ready = true
            end

            v97 = if p27.ready then 1 else 0

            if Frame2.BackgroundTransparency ~= v97 then
                BackgroundTransparency = Frame2.BackgroundTransparency
                v98 = if Frame2.BackgroundTransparency < v97 then 1 else -1
                v99 = BackgroundTransparency + v98 * p28 / 0.25
                Frame2.BackgroundTransparency = math.clamp(v99, 0, 1)
            end

            v100 = os.clock() - p27.openedAt

            if v100 > 3 then
                v101 = (v100 - 3) / 0.5
                v102 = math.clamp(v101, 0, 1)
                TextLabel.TextTransparency = v102
                TextLabel.BackgroundTransparency = v102 * 0.75 + 0.25
            end

            return true
        end

        local v111 = v88 or v90

        if v111 then
            v91, v92 = BikeCams.Heli(v111, p27.heli, p28)
            Camera.CFrame = v91
            Camera.FieldOfView = v92
            X = v91.LookVector.X
            Z = v91.LookVector.Z
            v93 = Vector3.new(X, 0, Z)
            Position = (v88 or v90) and (v88 or v90).Position or v91.Position
            LocalPlayer = Players.LocalPlayer
            PoseLODFocus = LocalPlayer and LocalPlayer:GetAttribute("PoseLODFocus")

            if LocalPlayer and (typeof(PoseLODFocus) ~= "Vector3" or (PoseLODFocus - Position).Magnitude > 20) then
                LocalPlayer:SetAttribute("PoseLODFocus", Position)
            end

            v94 = v87 and v88 and v91.Position + (v93.Magnitude > 0.01 and v93.Unit or Vector3.new(0, 0, 0)) * SETTINGS.Ahead or Position
            v95 = stream(v94)
            p27.scanAt -= p28

            if p27.scanAt <= 0 then
                p27.scanAt = SETTINGS.BikeRefresh
                scanDyn(Position)
            end

            for _, v112 in p27.dyn do
                for _, v113 in v112.pairs do
                    v96 = v113[1]

                    if v96.Parent then
                        CFrame = v96.CFrame

                        if v113[2].CFrame ~= CFrame then
                            v113[2].CFrame = CFrame
                        end
                    end
                end
            end

            if not p27.ready and t2.state == "ready" and (v95 == 0 or os.clock() - p27.openedAt > 1.2) then
                p27.ready = true
            end

            v97 = if p27.ready then 1 else 0

            if Frame2.BackgroundTransparency ~= v97 then
                BackgroundTransparency = Frame2.BackgroundTransparency
                v98 = if Frame2.BackgroundTransparency < v97 then 1 else -1
                v99 = BackgroundTransparency + v98 * p28 / 0.25
                Frame2.BackgroundTransparency = math.clamp(v99, 0, 1)
            end

            v100 = os.clock() - p27.openedAt

            if v100 > 3 then
                v101 = (v100 - 3) / 0.5
                v102 = math.clamp(v101, 0, 1)
                TextLabel.TextTransparency = v102
                TextLabel.BackgroundTransparency = v102 * 0.75 + 0.25
            end
        end

        return true
    end

    function t3.Destroy(p29) -- line: 280
        -- upvalues: Frame (copy)
        p29:Clear()
        Frame:Destroy()
    end

    return t3
end

return t1
