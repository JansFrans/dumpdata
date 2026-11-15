-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local UIArt = require(MotoLegends:WaitForChild("UIArt"))
local _require = require
local ok, result = pcall(_require, MotoLegends:WaitForChild("RaceNametags"))
local RoleStyles = ok and result.RoleStyles or {}

local function applyArt(p1) -- line: 18
    -- upvalues: UIArt (copy)
    if p1:IsA("ImageLabel") or p1:IsA("ImageButton") then
        task.spawn(function() -- line: 20
            -- upvalues: p1 (copy), UIArt (copy)
            local v1 = p1:GetAttribute("ArtName") and UIArt.Get(p1:GetAttribute("ArtName"))

            if not v1 and p1:GetAttribute("ArtFallback") then
                v1 = UIArt.Get(p1:GetAttribute("ArtFallback"))
            end

            if v1 and p1.Parent then
                p1.ImageContent = v1
            end
        end)
    end
end

for _, v2 in CollectionService:GetTagged("PitboxArt") do
    applyArt(v2)
end

CollectionService:GetInstanceAddedSignal("PitboxArt"):Connect(applyArt)

local v3

local function getSponsorTile() -- line: 32
    -- upvalues: UIArt (copy), v3 (ref)
    if v3 ~= nil then
        return v3 or nil
    end

    local function v4() -- line: 34
        -- upvalues: UIArt (copy)
        local MotoLegendsLogo = UIArt.Get("MotoLegendsLogo")
        local v5 = MotoLegendsLogo and MotoLegendsLogo.Object

        if not v5 then
            error("no logo image")
        end

        local v6 = game:GetService("AssetService"):CreateEditableImage({
            Size = Vector2.new(464, 434)
        })
        local v7 = 320 / v5.Size.X

        for _, v8 in {
                Vector2.new(232, 108),
                Vector2.new(0, 325),
                Vector2.new(464, 325)
            } do
            local function v9() -- line: 40
                -- upvalues: v5 (copy), v6 (copy), v7 (copy), v8 (copy)
                v6:DrawImageTransformed(v8, Vector2.new(v7, v7), 0, v5, {
                    CombineType = Enum.ImageCombineType.BlendSourceOver,
                    SamplingMode = Enum.ResamplerMode.Default
                })
            end

            pcall(v9)
        end

        return Content.fromObject(v6)
    end

    local ok, result = pcall(v4)

    if not ok then
        warn("[PitboxClient] sponsor tile: " .. tostring(result))
    end

    v3 = not not (ok and result) and result

    if not ok or not result then
        result = nil
    end

    return result
end

local function applySponsor(p2) -- line: 48
    -- upvalues: UIArt (copy), getSponsorTile (copy)
    if p2:IsA("ImageLabel") then
        task.spawn(function() -- line: 50
            -- upvalues: p2 (copy), UIArt (copy), getSponsorTile (copy)
            local v11 = getSponsorTile()

            if v11 and p2.Parent then
                p2.ImageContent = v11
            elseif p2.Parent then
                local MotoLegendsLogo = UIArt.Get("MotoLegendsLogo")

                if MotoLegendsLogo then
                    p2.ImageContent = MotoLegendsLogo
                end
            end
        end)
    end
end

for _, v12 in CollectionService:GetTagged("PitboxSponsor") do
    if v12:IsA("ImageLabel") then
        task.spawn(function() -- line: 50
            -- upvalues: UIArt (copy), getSponsorTile (copy), v12 (copy)
            local v13 = getSponsorTile()

            if v13 and v12.Parent then
                v12.ImageContent = v13
            elseif v12.Parent then
                local MotoLegendsLogo = UIArt.Get("MotoLegendsLogo")

                if MotoLegendsLogo then
                    v12.ImageContent = MotoLegendsLogo
                end
            end
        end)
    end
end

CollectionService:GetInstanceAddedSignal("PitboxSponsor"):Connect(applySponsor)

local v14

local function checker() -- line: 64
    -- upvalues: v14 (ref)
    if v14 ~= nil then
        return v14 or nil
    end

    local function v15() -- line: 66
        local v16 = game:GetService("AssetService"):CreateEditableImage({
            Size = Vector2.new(2, 2)
        })
        local v17 = buffer.create(16)

        buffer.writeu32(v17, 0, 4278190080)
        buffer.writeu32(v17, 4, 4294967295)
        buffer.writeu32(v17, 8, 4294967295)
        buffer.writeu32(v17, 12, 4278190080)
        v16:WritePixelsBuffer(Vector2.zero, Vector2.new(2, 2), v17)

        return Content.fromObject(v16)
    end

    local ok, result = pcall(v15)

    v14 = not not (ok and result) and result

    if not ok or not result then
        result = nil
    end

    return result
end

local t1 = {}

local function roleOf(p3) -- line: 77
    -- upvalues: Players (copy)
    local OwnerUserId = p3:GetAttribute("OwnerUserId")
    local v18 = OwnerUserId and Players:GetPlayerByUserId(OwnerUserId)
    local StaffRole = v18 and v18:GetAttribute("StaffRole")

    return typeof(StaffRole) == "string" and StaffRole:lower() or ""
end

local function styleSign(p4) -- line: 82
    -- upvalues: Players (copy), ok (copy), result (copy), RoleStyles (copy), v14 (ref), t1 (copy)
    local Panel = p4:FindFirstChild("Panel")

    if not Panel then
        return
    end

    local v19 = t1[p4]

    if not v19 then
        v19 = {}
        t1[p4] = v19
    end

    local OwnerUserId = p4:GetAttribute("OwnerUserId")
    local v20 = OwnerUserId and Players:GetPlayerByUserId(OwnerUserId)
    local StaffRole = v20 and v20:GetAttribute("StaffRole")
    local v21 = typeof(StaffRole) == "string" and StaffRole:lower() or ""

    if v19.role == v21 then
        return
    end

    v19.role = v21

    local v22 = RoleStyles[v21]

    Panel.BackgroundColor3 = v22 and v22.color or Color3.new(0, 0, 0)
    Panel.BackgroundTransparency = v22 and v22.transp or 0.5

    local v23 = Panel:FindFirstChild("PlayerName", true)

    if v23 then
        v23.TextColor3 = v22 and v22.text or Color3.new(1, 1, 1)
    end

    local v24 = if v22 and (v22.glow or v22.rim) then 12 else 0

    Panel.Position = UDim2.fromOffset(v24, v24)
    Panel.Size = UDim2.new(1, -2 * v24, 1, -2 * v24)

    local RoleShine = Panel:FindFirstChild("RoleShine")

    if v22 and v22.shine then
        if not RoleShine then
            RoleShine = Instance.new("Frame")
            RoleShine.Name = "RoleShine"
            RoleShine.BorderSizePixel = 0
            RoleShine.Size = UDim2.fromScale(1, 1)
            RoleShine.ZIndex = 2

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Name = "Sweep"
            UIGradient.Rotation = 15
            UIGradient.Offset = Vector2.new(-1.2, 0)
            UIGradient.Parent = RoleShine
            RoleShine.Parent = Panel
        end

        RoleShine.BackgroundColor3 = v22.shineColor or Color3.new(1, 1, 1)
        RoleShine.Sweep.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.34, 1),
            NumberSequenceKeypoint.new(0.5, v22.shine),
            NumberSequenceKeypoint.new(0.66, 1),
            NumberSequenceKeypoint.new(1, 1)
        })
        v19.shine = RoleShine.Sweep
    else
        if RoleShine then
            RoleShine:Destroy()
        end

        v19.shine = nil
    end

    local RoleGlow = Panel:FindFirstChild("RoleGlow")
    local UIStroke

    if not RoleGlow or RoleGlow:GetAttribute("Kind") == (v22 and v22.glow) then
        UIStroke = RoleGlow
    else
        RoleGlow:Destroy()
    end

    if v22 and v22.glow then
        if not UIStroke then
            UIStroke = Instance.new("UIStroke")
            UIStroke.Name = "RoleGlow"
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Thickness = 8
            UIStroke:SetAttribute("Kind", v22.glow)
            UIStroke.Parent = Panel
        end

        if ok and result.DressGlow then
            result.DressGlow(UIStroke, v22)
        end

        v19.glow = UIStroke
    else
        if UIStroke then
            UIStroke:Destroy()
        end

        v19.glow = nil
    end

    if ok and result.ApplyBar then
        result.ApplyBar(Panel, v22, v23)
    end

    local v25, v26

    if ok and result.BuildFx then
        local v27 = result.BuildFx(Panel, v22 and v22.particles or nil, 4, {
            crownK = 4.4
        })

        if v27 then
            v25 = v27
            v26 = true
        else
            v26 = false
        end
    else
        v26 = false
    end

    if not v26 then
        v25 = nil
    end

    v19.fx = v25

    local RDRim = Panel:FindFirstChild("RDRim")

    if v22 and v22.rim == "checker" then
        if not RDRim then
            local Folder = Instance.new("Folder")

            Folder.Name = "RDRim"
            Folder.Parent = Panel

            local result

            if v14 ~= nil then
                result = v14 or nil
            else
                local function v28() -- line: 66
                    local v29 = game:GetService("AssetService"):CreateEditableImage({
                        Size = Vector2.new(2, 2)
                    })
                    local v30 = buffer.create(16)

                    buffer.writeu32(v30, 0, 4278190080)
                    buffer.writeu32(v30, 4, 4294967295)
                    buffer.writeu32(v30, 8, 4294967295)
                    buffer.writeu32(v30, 12, 4278190080)
                    v29:WritePixelsBuffer(Vector2.zero, Vector2.new(2, 2), v30)

                    return Content.fromObject(v29)
                end

                local ok

                ok, result = pcall(v28)

                if ok and result then
                    v14 = result
                else
                    v14 = false
                    result = nil
                end
            end

            if result then
                for _, v31 in {
                        {
                            UDim2.new(0, 0, 0, 0),
                            UDim2.new(1, 0, 0, 16)
                        },
                        {
                            UDim2.new(0, 0, 1, -16),
                            UDim2.new(1, 0, 0, 16)
                        },
                        {
                            UDim2.new(0, 0, 0, 16),
                            UDim2.new(0, 16, 1, -32)
                        },
                        {
                            UDim2.new(1, -16, 0, 16),
                            UDim2.new(0, 16, 1, -32)
                        }
                    } do
                    local ImageLabel = Instance.new("ImageLabel")

                    ImageLabel.BackgroundTransparency = 1
                    ImageLabel.BorderSizePixel = 0
                    ImageLabel.Position = v31[1]
                    ImageLabel.Size = v31[2]
                    ImageLabel.ImageContent = result
                    ImageLabel.ScaleType = Enum.ScaleType.Tile
                    ImageLabel.TileSize = UDim2.fromOffset(16, 16)
                    ImageLabel.ResampleMode = Enum.ResamplerMode.Pixelated
                    ImageLabel.ZIndex = 4
                    ImageLabel.Parent = Folder
                end
            else
                local UIStroke = Instance.new("UIStroke")

                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                UIStroke.Thickness = 8
                UIStroke.Color = Color3.new(1, 1, 1)
                UIStroke.Parent = Folder.Parent
                UIStroke.Name = "RDRimStroke"
            end
        end
    else
        if RDRim then
            RDRim:Destroy()
        end

        local RDRimStroke = Panel:FindFirstChild("RDRimStroke")

        if RDRimStroke then
            RDRimStroke:Destroy()
        end
    end

    if ok and result.ApplyFlag then
        result.ApplyFlag(Panel, v22, 4, true)
    end

    if v23 and ok and result.FlagTextStroke then
        result.FlagTextStroke(v23, v22)
    end
end

local function addSign(p5) -- line: 152
    -- upvalues: t1 (copy), styleSign (copy)
    if not p5:IsA("SurfaceGui") then
        return
    end

    t1[p5] = t1[p5] or {}
    styleSign(p5)
end

for _, v33 in CollectionService:GetTagged("PitboxSign") do
    if v33:IsA("SurfaceGui") then
        t1[v33] = t1[v33] or {}
        styleSign(v33)
    end
end

CollectionService:GetInstanceAddedSignal("PitboxSign"):Connect(addSign)
CollectionService:GetInstanceRemovedSignal("PitboxSign"):Connect(function(p6) -- line: 155
    -- upvalues: t1 (copy)
    t1[p6] = nil
end)
task.spawn(function() -- line: 157
    -- upvalues: t1 (copy), styleSign (copy)
    while true do
        task.wait(1)

        for v34 in t1 do
            if v34.Parent then
                styleSign(v34)
            else
                t1[v34] = nil
            end
        end
    end
end)

local t2 = {
    "Root",
    "Waist",
    "Neck",
    "LeftShoulder",
    "LeftElbow",
    "LeftWrist",
    "RightShoulder",
    "RightElbow",
    "RightWrist",
    "LeftHip",
    "RightHip",
    "LeftKnee",
    "RightKnee",
    "LeftAnkle",
    "RightAnkle"
}
local t3 = {}

local function rad(p7) -- line: 167
    return (math.rad(p7))
end

local function ypr(p8, p9, p10) -- line: 168
    return CFrame.fromEulerAnglesYXZ(math.rad(p8), math.rad(p9), (math.rad(p10 or 0)))
end

local function rnd(p11, p12) -- line: 169
    return p11 + math.random() * (p12 - p11)
end

local function grabJoints(p13, p14, p15) -- line: 172
    local elapsed = os.clock()

    while true do
        local v38 = false

        for _, v39 in p14 do
            if not p15[v39] then
                local v40 = p13:FindFirstChild(v39, true)

                if v40 and v40:IsA("Motor6D") then
                    p15[v39] = v40
                else
                    v38 = true
                end
            end
        end

        if v38 or not p13:FindFirstChild("HumanoidRootPart") then
            task.wait(0.25)

            if not (os.clock() - elapsed > 30) and p13.Parent then
                continue
            end

            return false
        end

        break
    end

    return true
end

local function addCrew(p16) -- line: 184
    -- upvalues: t2 (copy), t3 (copy), grabJoints (copy)
    if not p16:IsA("Model") then
        return
    end

    local elapsed = os.clock()
    local t4 = {
        model = p16,
        j = {},
        seed = p16:GetAttribute("Seed") or math.random() * 100,
        state = "type",
        untilT = elapsed + 2 + math.random() * 3,
        look = 0,
        typing = 1,
        read = 0,
        player = 0,
        around = 0,
        point = 0,
        hy = 0,
        hp = -30,
        hyV = 0,
        hpV = 0,
        sx = 0,
        sy = 0,
        saccT = 0,
        keyT = elapsed,
        burstOn = true,
        burstT = elapsed + (0.6 + math.random() * 1.2000000000000002),
        tap = 0,
        handX = 0,
        handT = 0,
        keys = 0,
        enter = 0,
        weight = 0,
        weightT = elapsed + (3 + math.random() * 4),
        wSmooth = 0,
        regrip = 0,
        regripT = elapsed + (6 + math.random() * 6),
        nod = 0,
        wasNear = false
    }

    grabJoints(p16, t2, t4.j)
    t4.root = p16:FindFirstChild("HumanoidRootPart")
    t3[p16] = t4
end

for _, v41 in CollectionService:GetTagged("PitboxCrew") do
    task.spawn(addCrew, v41)
end

CollectionService:GetInstanceAddedSignal("PitboxCrew"):Connect(function(p17) -- line: 197
    -- upvalues: addCrew (copy)
    task.spawn(addCrew, p17)
end)
CollectionService:GetInstanceRemovedSignal("PitboxCrew"):Connect(function(p18) -- line: 198
    -- upvalues: t3 (copy)
    t3[p18] = nil
end)

local function nextState(p19, p20) -- line: 209
    local v42 = typeof(p19.model:GetAttribute("LookAt2")) == "Vector3"
    local v43 = math.random()

    p19.point = 0

    local v44, v45

    if p19.state ~= "look" or not v42 or p19.second then
        v45 = true
    elseif v43 < 0.55 then
        p19.second = true
        p19.side = not p19.side
        p19.untilT = p20 + (1.4 + math.random() * 1.2000000000000002)
        v44 = math.random() < 0.3
        v45 = false
    else
        v45 = true
    end

    if not v45 then
        p19.pointing = v44
    else
        p19.second = false
        p19.pointing = false

        if p19.state ~= "type" and p19.state ~= "read" then
            p19.state = math.random() < 0.7 and "type" or "read"
            p19.untilT = p20 + (2.5 + math.random() * 3.5)
        elseif p19.playerNear and v43 < 0.3 then
            p19.state = "player"
            p19.untilT = p20 + (1.6 + math.random() * 1.6)
        elseif v43 < (if v42 then 0.68 else 0.55) then
            p19.state = "look"

            if v42 then
                p19.side = not p19.side
            end

            local v46 = if v42 then 1.6 + math.random() * 1.4 else nil

            if not v42 or not v46 then
                v46 = 2.5 + math.random() * 2
            end

            p19.untilT = p20 + v46
            p19.pointing = math.random() < 0.3
        elseif v43 < 0.8 then
            p19.state = "around"
            p19.aroundYaw = (math.random() < 0.5 and -1 or 1) * (35 + math.random() * 35)
            p19.aroundPitch = -8 + math.random() * 12
            p19.untilT = p20 + (1 + math.random() * 1.2000000000000002)
        else
            p19.state = p19.state == "type" and "read" or "type"
            p19.untilT = p20 + (1.5 + math.random() * 1.5)
        end
    end
end

local function aimAngles(p21, p22) -- line: 234
    local v47 = p21.root.CFrame:PointToObjectSpace(p22)

    return math.clamp(math.deg((math.atan2(-v47.X, -v47.Z))), -80, 80), (math.clamp(math.deg((math.atan2(v47.Y - 1.6, (math.sqrt(v47.X ^ 2 + v47.Z ^ 2))))), -35, 20))
end

local function pose(p23, p24, p25) -- line: 239
    -- upvalues: Players (copy), nextState (copy), aimAngles (copy)
    local j = p23.j
    local v58 = math.min(p25, 0.1)
    local root = Players.LocalPlayer.Character
    local v59 = root and root:FindFirstChild("Head")

    root = v59 and p23.root and (v59.Position - p23.root.Position).Magnitude < 20

    if root and p23.root then
        root = p23.root.CFrame:PointToObjectSpace(v59.Position).Z < 4
    end

    p23.playerNear = root

    if root and not p23.wasNear and p23.state ~= "player" then
        p23.state = "player"
        p23.untilT = p24 + (1.8 + math.random() * 0.9999999999999998)
        p23.nod = 1
    end

    p23.wasNear = root

    if p23.untilT <= p24 then
        nextState(p23, p24)
    end

    local v61 = math.min(1, v58 * 3.2)

    p23.look += ((p23.state == "look" and 1 or 0) - p23.look) * v61
    p23.typing += ((p23.state == "type" and 1 or 0) - p23.typing) * v61
    p23.read += ((p23.state == "read" and 1 or 0) - p23.read) * v61
    p23.player += ((p23.state == "player" and 1 or 0) - p23.player) * v61
    p23.around += ((p23.state == "around" and 1 or 0) - p23.around) * v61
    p23.point = p23.point + ((if p23.state ~= "look" or not p23.pointing then 0 else 1) - p23.point) * math.min(1, v58 * 4)
    v61 = math.clamp(p23.look + p23.player + p23.around, 0, 1)

    local typing = p23.typing
    local read = p23.read
    local v60 = p24 + p23.seed
    local v62 = p23.model:GetAttribute("LookAt")
    local v63

    if p23.side then
        v63 = p23.model

        if typeof(v63:GetAttribute("LookAt2")) == "Vector3" then
            v62 = p23.model:GetAttribute("LookAt2")
        end
    end

    local v64

    if p23.root and typeof(v62) == "Vector3" then
        v64, v63 = aimAngles(p23, v62)
    else
        v64 = 40
        v63 = -18
    end

    local v65, v66

    if p23.root and v59 then
        v66, v65 = aimAngles(p23, v59.Position)
    else
        v66 = 0
        v65 = 0
    end

    if p23.saccT <= p24 then
        p23.saccT = p24 + (0.35 + math.random() * 1.0499999999999998)
        p23.sx = -4 + math.random() * 8
        p23.sy = -2.5 + math.random() * 4.5
    end

    v62 = v60 * 0.77 % 1
    v59 = -7 + 14 * v62 * v62 * (3 - 2 * v62)
    v62 = -1.5 * (v60 / 7 % 1)
    v66 = (p23.handX * 4 + p23.sx) * typing + (v59 + p23.sx * 0.3) * read + v64 * p23.look + v66 * p23.player + (p23.aroundYaw or 0) * p23.around

    local v67 = (-30 + p23.sy) * typing + (-28 + v62 + p23.sy * 0.4) * read
    local v68 = v60 * 2.3
    local wSmooth = v67 + (v63 + math.sin(v68) * 1.5) * p23.look + v65 * p23.player + (p23.aroundPitch or 0) * p23.around
    local v69

    if p23.nod > 0 then
        v67 = p23.nod - v58 * 1.6
        p23.nod = math.max(0, v67)
        v69 = (1 - p23.nod) * 2.2
        v67 = 3.141592653589793 * math.clamp(v69, 0, 1)
        wSmooth += math.sin(v67) * -9
    end

    p23.hyV += (121 * (v66 - p23.hy) - 15.84 * p23.hyV) * v58
    p23.hy += p23.hyV * v58
    p23.hpV += (121 * (wSmooth - p23.hp) - 15.84 * p23.hpV) * v58
    p23.hp += p23.hpV * v58
    v66 = math.sin(v60 * 1.7) * 1.2

    local v70

    if p23.weightT <= p24 then
        p23.weightT = p24 + (4 + math.random() * 5)
        v70 = math.random()

        if v70 < 0.4 then
            p23.weight = -1
        elseif v70 < 0.8 then
            p23.weight = 1
        else
            p23.weight = 0
        end
    end

    v70 = p23.wSmooth
    v67 = p23.weight - p23.wSmooth
    v69 = v58 * 1.4
    p23.wSmooth = v70 + v67 * math.min(1, v69)
    wSmooth = p23.wSmooth
    v62 = wSmooth * 0.07
    v59 = wSmooth * 2.5

    local v71, v72, v73, fromEulerAnglesYXZ

    if j.Root then
        v70 = j.Root
        v67 = CFrame.new(v62, 0, 0)
        v72 = v60 * 0.37
        v71 = math.sin(v72) * 1.5
        v69 = -v59
        v72 = CFrame.fromEulerAnglesYXZ
        v73 = math.rad(v71)
        fromEulerAnglesYXZ = v69 or 0
        v70.Transform = v67 * v72(0, v73, (math.rad(fromEulerAnglesYXZ)))
    end

    local v74 = v62 / 3
    local Waist = math.asin((math.clamp(v74, -1, 1)))

    v70 = math.deg(Waist)

    local v75, v76

    for _, v77 in { "Left", "Right" } do
        local v78, v79

        if v77 == "Left" then
            local v80 = wSmooth > 0
            local v81

            if v80 then
                v75 = math.abs(wSmooth)
            else
                if v77 ~= "Right" then
                    v62 = 0
                    v72 = j[v77 .. "Hip"]

                    if v72 then
                        v72 = j[v77 .. "Hip"]
                        v73 = -6 * v62
                        v78 = v59 - v70
                        fromEulerAnglesYXZ = CFrame.fromEulerAnglesYXZ
                        v76 = math.rad(v73)
                        v79 = v78 or 0
                        v72.Transform = fromEulerAnglesYXZ(v76, 0, (math.rad(v79)))
                    end

                    v72 = j[v77 .. "Knee"]

                    if v72 then
                        v72 = j[v77 .. "Knee"]
                        v73 = 11 * v62
                        v72.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v73), 0, 0)
                    end

                    v72 = j[v77 .. "Ankle"]

                    if v72 then
                        v72 = j[v77 .. "Ankle"]
                        v73 = -5 * v62
                        v72.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v73), 0, 0)
                    end

                    continue
                end

                v81 = wSmooth < 0
            end

            if v80 and not v75 or not v80 and not v81 then
                v62 = 0
            elseif v80 then
                v62 = v75
            else
                v75 = math.abs(wSmooth)
                v62 = v75 or 0
            end
        elseif v77 == "Right" then
            if wSmooth < 0 then
                v75 = math.abs(wSmooth)
                v62 = v75 or 0
            else
                v62 = 0
            end
        else
            v62 = 0
        end

        v72 = j[v77 .. "Hip"]

        if v72 then
            v72 = j[v77 .. "Hip"]
            v73 = -6 * v62
            v78 = v59 - v70
            fromEulerAnglesYXZ = CFrame.fromEulerAnglesYXZ
            v76 = math.rad(v73)
            v79 = v78 or 0
            v72.Transform = fromEulerAnglesYXZ(v76, 0, (math.rad(v79)))
        end

        v72 = j[v77 .. "Knee"]

        if v72 then
            v72 = j[v77 .. "Knee"]
            v73 = 11 * v62
            v72.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v73), 0, 0)
        end

        v72 = j[v77 .. "Ankle"]

        if v72 then
            v72 = j[v77 .. "Ankle"]
            v73 = -5 * v62
            v72.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v73), 0, 0)
        end
    end

    v70 = p23.hy * 0.38

    if j.Waist then
        Waist = j.Waist
        v74 = v66 - v61 * 2 + (p23.hp + 30) * 0.12
        v73 = v60 * 0.43
        v71 = v70 + math.sin(v73) * 1.5 * (1 - v61)
        v69 = -v59 * 0.6
        v75 = CFrame.fromEulerAnglesYXZ
        v68 = math.rad(v74)
        v73 = math.rad(v71)
        fromEulerAnglesYXZ = v69 or 0
        Waist.Transform = v75(v68, v73, (math.rad(fromEulerAnglesYXZ)))
    end

    if j.Neck then
        Waist = j.Neck
        v74 = p23.hp - (p23.hp + 30) * 0.12
        v71 = p23.hy - v70
        v69 = v59 * 0.4
        v75 = CFrame.fromEulerAnglesYXZ
        v68 = math.rad(v74)
        v73 = math.rad(v71)
        fromEulerAnglesYXZ = v69 or 0
        Waist.Transform = v75(v68, v73, (math.rad(fromEulerAnglesYXZ)))
    end

    if p23.regripT <= p24 then
        p23.regripT = p24 + (7 + math.random() * 7)
        p23.regrip = 1
    end

    p23.regrip = math.max(0, p23.regrip - v58 * 2.2)
    v74 = 3.141592653589793 * (1 - p23.regrip)
    wSmooth = math.sin(v74) * p23.regrip * 2
    v59 = v61 * (1 - p23.point * 0.5)

    if j.LeftShoulder then
        Waist = j.LeftShoulder
        v74 = v66 * 0.4 + 19 + wSmooth * 4 - v59 * 7
        Waist.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v74), -0.4188790204786391, 0.3490658503988659)
    end

    if j.LeftElbow then
        Waist = j.LeftElbow
        v74 = 45 - v59 * 6
        Waist.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v74), 0, 0)
    end

    if j.LeftWrist then
        Waist = j.LeftWrist
        v74 = -8 + v59 * 4
        Waist.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v74), 0, 0)
    end

    if typing > 0.05 then
        if p23.burstT <= p24 then
            p23.burstOn = not p23.burstOn
            p23.burstT = p24 + (p23.burstOn and 0.6 + math.random() * 1.4 or 0.3 + math.random() * 0.8)

            if not p23.burstOn and math.random() < 0.45 then
                p23.enter = 1
                p23.handTarget = 1
            end
        end

        if p23.burstOn and p23.keyT <= p24 then
            p23.keyT = p24 + (0.06 + math.random() * 0.11000000000000001)
            p23.tap = 1
            p23.keys += 1

            if p23.keys % math.random(3, 6) == 0 then
                p23.handTarget = -1 + math.random() * 1.8
            end
        end
    end

    p23.tap = p23.tap * math.exp(-v58 * 22)
    p23.enter = math.max(0, p23.enter - v58 * 3)
    p23.handX = p23.handX + ((p23.handTarget or 0) - p23.handX) * math.min(1, v58 * 9)
    wSmooth = math.sin(3.141592653589793 * (1 - p23.enter)) * p23.enter * 3
    v59 = (p23.tap + wSmooth) * typing
    wSmooth = if p23.burstOn then 0 else 1
    Waist = math.sin(v60 * 2.1) * read
    v67 = 25 + (-p23.handX * 2 * typing + wSmooth * typing * 2 + Waist * 1.5)
    v73 = p23.handX * 7 * typing

    local v82 = v60 * 1.3

    v74 = 51 + (v73 + math.sin(v82) * 2 * typing - 6 * read)
    v71 = 57 + (v59 * 4 + wSmooth * typing * -3 + Waist * 2)
    v69 = -10 + (v59 * 11 + wSmooth * typing * -4 + Waist * 5)
    Waist = v61 * (1 - p23.point)
    v75 = math.clamp(v64 - v70, -40, 70)
    v67 = v67 * (1 - v61) + 5 * Waist + (v63 * 0.6 + 62) * p23.point
    v74 = v74 * (1 - v61) + 2 * Waist + v75 * p23.point
    v71 = v71 * (1 - v61) + (v66 * 0.5 + 15) * Waist + 8 * p23.point
    v69 = v69 * (1 - v61) + 0 * Waist - 5 * p23.point

    if j.RightShoulder then
        v75 = j.RightShoulder
        fromEulerAnglesYXZ = (1 - v61) * -10
        v76 = CFrame.fromEulerAnglesYXZ
        v82 = math.rad(v67)
        v75.Transform = v76(v82, math.rad(v74), (math.rad(fromEulerAnglesYXZ or 0)))
    end

    if j.RightElbow then
        j.RightElbow.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v71), 0, 0)
    end

    if j.RightWrist then
        j.RightWrist.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v69), 0, 0)
    end
end

local t5 = {
    "Root",
    "Waist",
    "Neck",
    "LeftShoulder",
    "LeftElbow",
    "LeftWrist",
    "RightShoulder",
    "RightElbow",
    "RightWrist",
    "LeftHip",
    "RightHip",
    "LeftKnee",
    "RightKnee",
    "LeftAnkle",
    "RightAnkle"
}
local t6 = {}

local function unit(p26, p27) -- line: 356
    return p26.Magnitude > 1E-04 and p26.Unit or p27
end

local function bone(p28, p29, p30, p31, p32) -- line: 357
    local v84 = p31 - p30
    local v85 = -(v84.Magnitude > 1E-04 and v84.Unit or Vector3.new(0, 1, 0))
    local v86 = Vector3.new(1, 0, 0) - v85 * v85.X
    local Unit = v86.Magnitude > 1E-04 and v86.Unit or Vector3.new(0, 0, 1)
    local v87 = p29 - p28
    local v88 = -(v87.Magnitude > 1E-04 and v87.Unit or Vector3.new(0, 1, 0))
    local v89 = p32 - v88 * p32:Dot(v88)
    local Unit2 = v89.Magnitude > 1E-04 and v89.Unit or Vector3.new(1, 0, 0)
    local v90 = CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit2, v88, Unit2:Cross(v88))
    local v91 = CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit, v85, Unit:Cross(v85))

    return CFrame.new(p28) * v90 * v91:Inverse() * CFrame.new(-p30)
end

local function limb(p33, p34, p35, p36, p37, p38, p39, p40) -- line: 368
    -- upvalues: bone (copy)
    if not (p34 and p35 and p36) then
        return
    end

    local C0, C1 = p34.C0, p34.C1
    local C0_2, C1_2 = p35.C0, p35.C1
    local C0_3, C1_3 = p36.C0, p36.C1
    local Position = (p33 * C0).Position
    local Magnitude = (C0_2.Position - C1.Position).Magnitude
    local Magnitude2 = (C0_3.Position - C1_2.Position).Magnitude

    if Magnitude < 0.01 or Magnitude2 < 0.01 then
        return
    end

    local v92 = p37 - Position
    local v93 = v92.Magnitude > 1E-04 and v92.Unit or Vector3.new(-0, -1, -0, -0)
    local v97 = math.clamp(v92.Magnitude, math.abs(Magnitude - Magnitude2) + 0.01, Magnitude + Magnitude2 - 0.01)
    local v98 = p38 - v93 * p38:Dot(v93)
    local Unit = v98.Magnitude > 1E-04 and v98.Unit or Vector3.new(0, 0, 1)
    local v99 = (Magnitude * Magnitude - Magnitude2 * Magnitude2 + v97 * v97) / (v97 * 2)
    local v103 = Position + v93 * v99 + Unit * math.sqrt((math.max(0, Magnitude * Magnitude - v99 * v99)))
    local v104 = Position + v93 * v97
    local v105 = v93:Cross(Unit)
    local Unit2 = v105.Magnitude > 1E-04 and v105.Unit or Vector3.new(1, 0, 0)

    if p40 and Unit2:Dot(p40) < 0 then
        Unit2 = -Unit2
    end

    local v106 = bone(Position, v103, C1.Position, C0_2.Position, Unit2)
    local v107 = bone(v103, v104, C1_2.Position, C0_3.Position, Unit2)

    p34.Transform = (p33 * C0):ToObjectSpace(v106 * C1)
    p35.Transform = (v106 * C0_2):ToObjectSpace(v107 * C1_2)

    if p39 then
        local v108 = CFrame.new(v104 - p39 * C1_3.Position) * p39

        p36.Transform = (v107 * C0_3):ToObjectSpace(v108 * C1_3)
    else
        p36.Transform = CFrame.identity
    end
end

local function addMech(p41) -- line: 392
    -- upvalues: grabJoints (copy), t5 (copy), t6 (copy)
    if not p41:IsA("Model") then
        return
    end

    local t7 = {
        model = p41,
        j = {}
    }

    if grabJoints(p41, t5, t7.j) then
        local LeftFoot = p41:FindFirstChild("LeftFoot")
        local elapsed = os.clock()

        while not LeftFoot and os.clock() - elapsed < 10 do
            task.wait(0.25)
            LeftFoot = p41:FindFirstChild("LeftFoot")
        end

        t7.root = p41:FindFirstChild("HumanoidRootPart")

        local j = t7.j

        if t7.root and j.Root and j.Waist and j.LeftHip and j.LeftKnee and j.LeftAnkle then
            local v109 = j.Root.C0 * j.Root.C1:Inverse()

            t7.hipL = (v109 * j.LeftHip.C0).Position
            t7.hipR = (v109 * (j.RightHip or j.LeftHip).C0).Position
            t7.thigh = (j.LeftKnee.C0.Position - j.LeftHip.C1.Position).Magnitude
            t7.shin = (j.LeftAnkle.C0.Position - j.LeftKnee.C1.Position).Magnitude

            local LeftFoot = p41:FindFirstChild("LeftFoot")

            t7.footH = LeftFoot and j.LeftAnkle.C1.Position.Y + LeftFoot.Size.Y / 2 or 0.3
            t7.up = p41:GetAttribute("RootAboveFloor") or 3

            local elapsed = os.clock()

            t7.seed = p41:GetAttribute("Seed") or math.random() * 100
            t7.state = "work"
            t7.untilT = elapsed + (5 + math.random() * 4)
            t7.w = {
                work = 1,
                inspect = 0,
                stand = 0
            }
            t7.hy = 0
            t7.hp = -35
            t7.hyV = 0
            t7.hpV = 0
            t7.saccT = 0
            t7.sx = 0
            t7.sy = 0
            t7.phase = 0
            t7.burst = true
            t7.burstT = elapsed + (1.2 + math.random() * 1.4000000000000001)
            t7.nod = 0
            t7.wasNear = false
            t7.regrip = 0
            t6[p41] = t7
        end
    end
end

local function aimYP(p42, p43) -- line: 415
    return math.deg((math.atan2(-p42.X, -p42.Z))), (math.deg((math.atan2(p42.Y - p43, (math.sqrt(p42.X ^ 2 + p42.Z ^ 2))))))
end

local function poseMech(p44, p45, p46) -- line: 418
    -- upvalues: Players (copy), limb (copy)
    local j = p44.j
    local v118 = math.min(p46, 0.1)
    local _CFrame = p44.root.CFrame
    local v119 = p45 + p44.seed
    local WorkAt = p44.model:GetAttribute("WorkAt")
    local v120 = typeof(WorkAt) == "Vector3"
    local v121 = if v120 then _CFrame:PointToObjectSpace(WorkAt) else nil
    local v122

    if not v120 or not v121 then
        v122 = 1.3 - p44.up
        v121 = Vector3.new(0, v122, -2.1)
    end

    WorkAt = -p44.up

    local state = Players.LocalPlayer.Character

    v122 = state and state:FindFirstChild("Head")
    state = v122 and (v122.Position - p44.root.Position).Magnitude < 22

    if state and not p44.wasNear then
        p44.state = "look"
        p44.untilT = p45 + (1.6 + math.random() * 0.7999999999999998)
        p44.nod = 1
    end

    p44.wasNear = state

    local v123

    if p44.untilT <= p45 then
        v123 = math.random()

        if p44.state == "work" then
            if v123 < 0.5 then
                p44.state = "inspect"
                p44.untilT = p45 + (2.2 + math.random() * 1.7999999999999998)
            elseif v123 < 0.75 then
                p44.state = "stand"
                p44.untilT = p45 + (3.5 + math.random() * 2)
                p44.standKind = math.random() < 0.5 and "stretch" or "wipe"
                p44.standT = p45
            else
                local v124 = if state then v123 < 0.9 else nil

                if not state or not v124 then
                    p44.state = "crew"
                    p44.untilT = p45 + (1.2 + math.random() * 0.8)
                else
                    p44.state = "look"
                    p44.untilT = p45 + (1.4 + math.random() * 0.8000000000000003)
                end
            end
        else
            p44.state = "work"
            p44.untilT = p45 + (5 + math.random() * 6)
            p44.burst = true
            p44.burstT = p45 + (1 + math.random() * 1.4)
        end
    end

    state = p44.state
    v123 = {}
    v123.work = state ~= "work" and state ~= "look" and state ~= "crew" and 0 or 1
    v123.inspect = state == "inspect" and 1 or 0
    v123.stand = state == "stand" and 1 or 0

    local v125, hipR, v126, v127, v128

    for v129, v130 in v123 do
        v128 = p44.w
        v125 = v128[v129]
        v127 = v130 - p44.w[v129]
        v126 = if v129 == "stand" then 2.4 else 3.2
        hipR = v118 * v126
        v128[v129] = v125 + v127 * math.min(1, hipR)
    end

    local v131, v132, v133 = p44.w.work, p44.w.inspect, p44.w.stand

    v123 = v131 + v132 + v133

    if v123 < 0.001 then
        v123 = 1
        v131 = 1
    end

    v131 /= v123
    v132 /= v123
    v133 /= v123

    local v134, v135 = p44.thigh, p44.shin

    v128 = p44.footH
    v123 = p44.hipL.Y
    v125 = math.sin(v119 * 1.6)

    local v136 = WorkAt + 0.2 + v134 * 0.96

    v127 = WorkAt + v128 + (v134 + v135) * 0.46

    local v137 = v131 * (v123 - v136) + v132 * (v123 - v127)
    local v138, Rotation

    if p44.standKind == "stretch" then
        Rotation = (p45 - (p44.standT or p45)) / 2.2
        hipR = 3.141592653589793 * math.clamp(Rotation, 0, 1)
        v138 = math.sin(hipR) or 0
    else
        v138 = 0
    end

    v136 = v131 * -8 + v132 * -22 + v133 * (v138 * 10 - 3)
    v123 = v131 * 0.05 + v132 * -0.15
    j.Root.Transform = CFrame.new(0, -v137 + v125 * 0.01, v123) * CFrame.fromEulerAnglesYXZ(math.rad(v136), 0, 0)
    v123 = _CFrame * j.Root.C0 * j.Root.Transform * j.Root.C1:Inverse()

    local hipL = p44.hipL

    hipR = p44.hipR
    v126 = WorkAt + v128

    local v139 = Vector3.new(hipL.X - 0.05, v126, hipL.Z - v134 * 0.85)
    local v140 = Vector3.new(hipR.X + 0.05, WorkAt + 0.24, hipR.Z + v135 * 0.92)
    local v141 = Vector3.new(hipL.X - 0.25, v126, hipL.Z - 0.35)
    local v142 = Vector3.new(hipR.X + 0.25, v126, hipR.Z - 0.35)
    local v143 = Vector3.new(hipL.X, v126, hipL.Z)

    Rotation = Vector3.new(hipR.X, v126, hipR.Z)
    v126 = v139 * v131 + v141 * v132 + v143 * v133
    v139 = v140 * v131 + v142 * v132 + Rotation * v133

    local LookVector = _CFrame.LookVector
    local RightVector = _CFrame.RightVector

    Rotation = _CFrame.Rotation
    limb(v123, j.LeftHip, j.LeftKnee, j.LeftAnkle, _CFrame * v126, LookVector - RightVector * 0.15, Rotation, RightVector)

    local v145, v146, v147 = j.RightHip, j.RightKnee, j.RightAnkle
    local v148 = _CFrame * v139
    local v149 = LookVector + RightVector * 0.15
    local Angles = CFrame.Angles
    local v150 = -62 * v131

    limb(v123, v145, v146, v147, v148, v149, Rotation * Angles(math.rad(v150), 0, 0), RightVector)
    v139 = v131 * -20 + v132 * -30 + v133 * (v138 * 14 - 6)

    local v144 = v131 + v132

    v148 = -v121.X
    v149 = -v121.Z
    v126 = v144 * math.clamp(math.deg((math.atan2(v148, v149))) * 0.25, -12, 12)
    v144 = j.Waist
    v145 = v139 + v125 * 0.8
    v144.Transform = CFrame.fromEulerAnglesYXZ(math.rad(v145), math.rad(v126), 0)
    v127 = v123 * j.Waist.C0 * j.Waist.Transform * j.Waist.C1:Inverse()

    if p44.burstT <= p45 then
        p44.burst = not p44.burst
        p44.burstT = p45 + (p44.burst and 1.2 + math.random() * 1.5999999999999999 or 0.5 + math.random() * 0.8)

        if p44.burst then
            p44.regrip = 1
        end
    end

    if p44.burst and state == "work" then
        p44.phase += v118 * 2 * 3.141592653589793 * 2.3
    end

    p44.regrip = math.max(0, p44.regrip - v118 * 2.5)

    local v151 = p44.phase

    v151 = math.sin(v151) * 20 + 38
    v128 = math.rad(v151) - p44.regrip * 0.5
    v125 = v121 + Vector3.new(0, 0, 0.12)
    v135 = v125 + Vector3.new(math.sin(v128) * 0.62, -math.cos(v128) * 0.62, 0.22)
    v128 = _CFrame * v135
    v134 = _CFrame * v125
    v144 = math.sin(v119 * 1.3)
    WorkAt = v121 + Vector3.new(0.45, 0.55, 0.3)

    local v152 = v121 + Vector3.new(-0.25, v144 * 0.35 + 0.15, 0.32)

    v151 = v121 + Vector3.new(-0.3, 0.62, 0.3)
    v145 = math.sin(v119 * 7)

    if p44.standKind == "stretch" then
        v146 = Vector3.new(0.55, -0.35, 0.55)
        v147 = Vector3.new(-0.55, -0.35, 0.55)
    else
        v149 = v145 * 0.12 + 0.15
        v146 = Vector3.new(v149, -0.45, -0.75)
        v149 = -0.1 - v145 * 0.12
        v147 = Vector3.new(v149, -0.45, -0.72)
    end

    v146 = hipR + v146 + Vector3.new(0, 1.1, 0)
    v147 = hipL + v147 + Vector3.new(0, 1.1, 0)
    v145 = v135 * v131 + WorkAt * v132 + v146 * v133
    v146 = v151 * v131 + v152 * v132 + v147 * v133
    v148 = v134 - v128

    local Unit = v148.Magnitude > 1E-04 and v148.Unit or LookVector

    Unit = Rotation:Lerp(CFrame.lookAt(Vector3.new(0, 0, 0), Unit, LookVector).Rotation, v131)
    limb(v127, j.RightShoulder, j.RightElbow, j.RightWrist, _CFrame * v145, _CFrame:VectorToWorldSpace((Vector3.new(1, -0.8, 0.6))), Unit, RightVector)
    limb(v127, j.LeftShoulder, j.LeftElbow, j.LeftWrist, _CFrame * v146, _CFrame:VectorToWorldSpace((Vector3.new(-1, -0.8, 0.6))), Rotation * CFrame.Angles(-1.0471975511965976, 0, 0), RightVector)

    if p44.saccT <= p45 then
        p44.saccT = p45 + (0.4 + math.random() * 1.1)
        p44.sx = -5 + math.random() * 10
        p44.sy = -3 + math.random() * 6
    end

    Unit = 1.5 - v137

    local CrewAt = p44.model:GetAttribute("CrewAt")
    local v153, v154, v155, v156, v157

    if state ~= "look" or not v122 then
        if state == "crew" and typeof(CrewAt) == "Vector3" then
            v153 = _CFrame:PointToObjectSpace(CrewAt)
            v156 = -v153.X
            v154 = -v153.Z
            v155 = math.atan2(v156, v154)
            v148 = math.deg(v155)
            v156 = v153.Y - Unit
            v157 = v153.X ^ 2 + v153.Z ^ 2
            v154 = math.sqrt(v157)
            v155 = math.atan2(v156, v154)
            v149 = math.deg(v155)
        elseif state == "stand" then
            v153 = v121 + Vector3.new(0, 0.6, 0)
            v156 = -v153.X
            v154 = -v153.Z
            v155 = math.atan2(v156, v154)
            v150 = math.deg(v155)
            v156 = v153.Y - Unit
            v157 = v153.X ^ 2 + v153.Z ^ 2
            v154 = math.sqrt(v157)
            v155 = math.atan2(v156, v154)
            v149 = math.deg(v155)
            v153 = v119 * 0.7
            v148 = v150 + math.sin(v153) * 12
        elseif state == "inspect" then
            v156 = v144 * 0.35 + 0.15
            v153 = v121 + Vector3.new(-0.2, v156, 0)
            v156 = -v153.X
            v154 = -v153.Z
            v155 = math.atan2(v156, v154)
            v150 = math.deg(v155)
            v156 = v153.Y - Unit
            v157 = v153.X ^ 2 + v153.Z ^ 2
            v154 = math.sqrt(v157)
            v155 = math.atan2(v156, v154)

            local v158 = math.deg(v155)

            v148 = v150 + p44.sx * 0.5
            v149 = v158 + p44.sy * 0.5
        else
            v155 = -v125.X
            v156 = -v125.Z
            v150 = math.atan2(v155, v156)
            v153 = math.deg(v150)
            v150 = v125.Y - Unit
            v156 = v125.X ^ 2 + v125.Z ^ 2
            v155 = math.sqrt(v156)
            Angles = math.deg((math.atan2(v150, v155)))
            v148 = v153 + p44.sx
            v149 = Angles + p44.sy
        end
    else
        v153 = _CFrame:PointToObjectSpace(v122.Position)
        v156 = -v153.X
        v154 = -v153.Z
        v155 = math.atan2(v156, v154)
        v148 = math.deg(v155)
        v156 = v153.Y - Unit
        v157 = v153.X ^ 2 + v153.Z ^ 2
        v154 = math.sqrt(v157)
        v155 = math.atan2(v156, v154)
        v149 = math.deg(v155)
    end

    if p44.nod > 0 then
        v153 = p44.nod - v118 * 1.6
        p44.nod = math.max(0, v153)
        v156 = (1 - p44.nod) * 2.2
        v153 = 3.141592653589793 * math.clamp(v156, 0, 1)
        v149 += math.sin(v153) * -9
    end

    p44.hyV += (100 * (v148 - p44.hy) - 14.399999999999999 * p44.hyV) * v118
    p44.hy += p44.hyV * v118
    p44.hpV += (100 * (v149 - p44.hp) - 14.399999999999999 * p44.hpV) * v118
    p44.hp += p44.hpV * v118

    if j.Neck then
        CrewAt = j.Neck
        v150 = p44.hp - v139 - v136
        v153 = math.clamp(v150, -55, 45)
        v155 = p44.hy - v126
        v150 = math.clamp(v155, -75, 75)
        v155 = p44.sx * 0.6 * (v131 + v132)
        v156 = CFrame.fromEulerAnglesYXZ
        v154 = math.rad(v153)
        v157 = math.rad(v150)
        CrewAt.Transform = v156(v154, v157, (math.rad(v155 or 0)))
    end
end

for _, v161 in CollectionService:GetTagged("PitboxMechanic") do
    task.spawn(addMech, v161)
end

CollectionService:GetInstanceAddedSignal("PitboxMechanic"):Connect(function(p47) -- line: 510
    -- upvalues: addMech (copy)
    task.spawn(addMech, p47)
end)
CollectionService:GetInstanceRemovedSignal("PitboxMechanic"):Connect(function(p48) -- line: 511
    -- upvalues: t6 (copy)
    t6[p48] = nil
end)

local n1 = 0

local function signLowEnd() -- line: 520
    -- upvalues: Players (copy)
    local UserInputService = game:GetService("UserInputService")

    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled or Players.LocalPlayer:GetAttribute("GfxQuality") == "Low"
end

RunService.Stepped:Connect(function(_, p50) -- line: 524
    -- upvalues: ok (copy), result (copy), t1 (copy), t3 (copy), pose (copy), t6 (copy), poseMech (copy), n1 (ref)
    local CurrentCamera = workspace.CurrentCamera
    local v162 = CurrentCamera and CurrentCamera.CFrame.Position
    local elapsed = os.clock()

    for v163, v164 in t3 do
        if v163.Parent then
            if not v164.posed or v162 and v164.root and (v164.root.Position - v162).Magnitude < 150 then
                pose(v164, elapsed, p50)
                v164.posed = true
            end
        else
            t3[v163] = nil
        end
    end

    for v165, v166 in t6 do
        if v165.Parent then
            if not v166.posed or v162 and v166.root and (v166.root.Position - v162).Magnitude < 150 then
                poseMech(v166, elapsed, p50)
                v166.posed = true
            end
        else
            t6[v165] = nil
        end
    end

    n1 -= p50

    local v167 = true

    if n1 > 0 then
        v167 = false
    else
        n1 = math.max(n1 + 0.03333333333333333, 0)
    end

    local v170 = math.clamp(elapsed % 3 / 1.8, 0, 1)
    local v171 = v170 * v170 * (3 - v170 * 2)
    local v173 = math.sin(elapsed * 3.2) * 0.5 + 0.5

    if not (v167 and v162 and CurrentCamera) then
        return
    end

    local ViewportSize = CurrentCamera.ViewportSize
    local v174 = math.max(ViewportSize.X, ViewportSize.Y) * 0.25
    local t8 = {}

    for v175, v176 in t1 do
        local Parent = v175.Parent

        if (v176.shine or v176.glow or v176.fx) and Parent and Parent:IsA("BasePart") then
            local Magnitude = (Parent.Position - v162).Magnitude

            if Magnitude < 120 then
                local v177 = CurrentCamera:WorldToViewportPoint(Parent.Position)

                if v177.Z > 0 and v177.X > -v174 and v177.X < ViewportSize.X + v174 and v177.Y > -v174 and v177.Y < ViewportSize.Y + v174 then
                    t8[#t8 + 1] = {
                        rec = v176,
                        d = Magnitude
                    }
                end
            end
        end
    end

    table.sort(t8, function(p51, p52) -- line: 563
        return p51.d < p52.d
    end)

    local t9 = {}

    for i = 1, math.min(3, #t8) do
        local rec = t8[i].rec

        t9[rec] = true

        if rec.fx then
            result.StepFx(rec.fx, elapsed, 1)
            rec.fxShown = true
        end

        if rec.shine and rec.shine.Parent then
            rec.shine.Offset = Vector2.new(v171 * 2.4 + -1.2, 0)
        end

        local glow = rec.glow

        if glow and glow.Parent and ok and result.StepGlow then
            result.StepGlow(glow, elapsed, v173, 4)
        end
    end

    for _, v179 in t1 do
        if v179.fx and v179.fxShown ~= false and not t9[v179] then
            result.StepFx(v179.fx, elapsed, 0)
            v179.fxShown = false
        end
    end
end)

local LocalPlayer = Players.LocalPlayer
local v180 = workspace:WaitForChild(MotoLegends:WaitForChild("Config") and require(MotoLegends.Config).Track):WaitForChild("PlayerPitboxes", 30)
local t10 = {}
local UserInputService = game:GetService("UserInputService")

local function hideFarDecor() -- line: 595
    -- upvalues: LocalPlayer (copy), UserInputService (copy)
    if not UserInputService.TouchEnabled or UserInputService.KeyboardEnabled then
        return LocalPlayer:GetAttribute("GfxQuality") == "Low"
    end

    return true
end

local t11 = {}

local function myIndex() -- line: 600
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("PitboxIndex")
end

local function judge(p53) -- line: 601
    -- upvalues: CollectionService (copy), t3 (copy), t6 (copy), LocalPlayer (copy), t11 (copy)
    if not p53:IsA("Model") or t11[p53] then
        return
    end

    local v181

    if p53:GetAttribute("TyreGrid") == true then
        local TyreOwner = p53:GetAttribute("TyreOwner")

        if TyreOwner == nil then
            return
        end

        v181 = TyreOwner == LocalPlayer.UserId
    else
        local Parent = p53.Parent
        local PitboxIndex = Parent and Parent:GetAttribute("PitboxIndex")
        local PitboxIndex2 = LocalPlayer:GetAttribute("PitboxIndex")

        if PitboxIndex == nil or PitboxIndex2 == nil then
            return
        end

        v181 = PitboxIndex == PitboxIndex2
    end

    if not v181 then
        local Parent = p53.Parent
        local CrewCollider, v182

        if CollectionService:HasTag(p53, "PitboxMechanic") then
            v182 = false
        elseif Parent then
            local CrewCollider2 = Parent:FindFirstChild("CrewCollider")

            if CrewCollider2 then
                CrewCollider = CrewCollider2
                v182 = true
            else
                v182 = false
            end
        else
            v182 = false
        end

        if not v182 then
            CrewCollider = nil
        end

        t11[p53] = {
            decor = Parent,
            collider = CrewCollider
        }
        t3[p53] = nil
        t6[p53] = nil
        p53.Destroying:Connect(function() -- line: 618
            -- upvalues: p53 (copy), t11 (copy)
            t11[p53] = nil
        end)
        p53.Parent = nil

        if CrewCollider then
            CrewCollider.Parent = nil
        end
    end
end

local function watch(p54) -- line: 622
    -- upvalues: judge (copy)
    if not p54:IsA("Model") then
        return
    end

    judge(p54)
    p54:GetAttributeChangedSignal("TyreOwner"):Connect(function() -- line: 625
        -- upvalues: p54 (copy), judge (copy)
        judge(p54)
    end)
end

for _, v183 in CollectionService:GetTagged("PitboxCrew") do
    watch(v183)
end

CollectionService:GetInstanceAddedSignal("PitboxCrew"):Connect(watch)

for _, v184 in CollectionService:GetTagged("PitboxMechanic") do
    watch(v184)
end

CollectionService:GetInstanceAddedSignal("PitboxMechanic"):Connect(watch)
LocalPlayer:GetAttributeChangedSignal("PitboxIndex"):Connect(function() -- line: 631
    -- upvalues: CollectionService (copy), addCrew (copy), addMech (copy), LocalPlayer (copy), t11 (copy), judge (copy)
    local PitboxIndex = LocalPlayer:GetAttribute("PitboxIndex")

    for v185, v186 in t11 do
        if v186.decor and v186.decor.Parent then
            if not v185:GetAttribute("TyreGrid") and v186.decor:GetAttribute("PitboxIndex") == PitboxIndex then
                t11[v185] = nil

                local function v187() -- line: 638
                    -- upvalues: v186 (copy), v185 (copy)
                    v185.Parent = v186.decor

                    if v186.collider then
                        v186.collider.Parent = v186.decor
                    end
                end

                pcall(v187)

                if CollectionService:HasTag(v185, "PitboxMechanic") then
                    task.spawn(addMech, v185)
                else
                    task.spawn(addCrew, v185)
                end
            end
        else
            t11[v185] = nil
        end
    end

    for _, v188 in CollectionService:GetTagged("PitboxCrew") do
        judge(v188)
    end

    for _, v189 in CollectionService:GetTagged("PitboxMechanic") do
        judge(v189)
    end
end)
task.spawn(function() -- line: 646
    -- upvalues: t11 (copy)
    while true do
        task.wait(10)

        for v190, v191 in t11 do
            if not v191.decor or not v191.decor.Parent then
                t11[v190] = nil
            end
        end
    end
end)

local t12 = {}

local function collect(p55) -- line: 660
    local t13 = {}
    local t14 = {}

    for _, descendant in p55:GetDescendants() do
        if descendant:IsA("SurfaceGui") and (descendant.Enabled or descendant:GetAttribute("LodOff")) then
            table.insert(t13, descendant)
        elseif descendant:IsA("Light") and (descendant.Enabled or descendant:GetAttribute("LodLightOff")) then
            table.insert(t14, descendant)
        end
    end

    return t13, t14
end

local function setFx(p56, p57) -- line: 669
    if p56.on == p57 then
        return
    end

    p56.on = p57

    for _, v192 in p56.list do
        if v192.Parent then
            v192.Enabled = p57
            v192:SetAttribute("LodOff", not p57 or nil)
        end
    end
end

local function setLights(p58, p59) -- line: 674
    if p58.lightOn == p59 then
        return
    end

    p58.lightOn = p59

    for _, v193 in p58.lights or {} do
        if v193.Parent then
            v193.Enabled = p59
            v193:SetAttribute("LodLightOff", not p59 or nil)
        end
    end
end

local v194

task.spawn(function() -- line: 680
    -- upvalues: LocalPlayer (copy), v180 (copy), t10 (copy), UserInputService (copy), t12 (copy), collect (copy), setFx (copy), setLights (copy), v194 (copy)
    local v195 = v180 and v180.Parent

    if v195 then
        v195:FindFirstChild("PitComplex")
    end

    while true do
        task.wait(0.5)

        local CurrentCamera = workspace.CurrentCamera
        local v196 = CurrentCamera and CurrentCamera.CFrame.Position

        if v196 and v180 then
            local n2 = 0

            for v197, v198 in t10 do
                local v199 = v180:FindFirstChild("Pitbox_" .. v198)

                if n2 < 1 then
                    if v199 and (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled or LocalPlayer:GetAttribute("GfxQuality") == "Low") then
                        if (v199.Position - v196).Magnitude < 190 then
                            t10[v197] = nil
                            n2 += 1

                            local function v200() -- line: 699
                                -- upvalues: v197 (copy), v180 (copy)
                                v197.Parent = v180
                            end

                            pcall(v200)
                        end
                    else
                        t10[v197] = nil
                        n2 += 1

                        local function v201() -- line: 699
                            -- upvalues: v197 (copy), v180 (copy)
                            v197.Parent = v180
                        end

                        pcall(v201)
                    end
                end
            end

            for _, child in v180:GetChildren() do
                local v202 = child:IsA("Model") and child:GetAttribute("PitboxIndex")
                local v203 = v202 and v180:FindFirstChild("Pitbox_" .. v202)

                if v203 and (if UserInputService.TouchEnabled then not UserInputService.KeyboardEnabled or LocalPlayer:GetAttribute("GfxQuality") == "Low" else LocalPlayer:GetAttribute("GfxQuality") == "Low") and (v203.Position - v196).Magnitude > 220 then
                    if t10[child] == nil and n2 < 1 then
                        n2 += 1
                        t10[child] = v202
                        child.Destroying:Once(function() -- line: 709
                            -- upvalues: child (copy), t10 (copy)
                            t10[child] = nil
                        end)
                        child.Parent = nil
                    end

                    v202 = nil
                end

                if v202 then
                    local v204 = t12[child]
                    local v205

                    if v204 then
                        if v204.dirty then
                            local v206, v207 = collect(child)

                            v205 = {
                                on = nil,
                                lightOn = nil,
                                list = v206,
                                lights = v207
                            }
                            t12[child] = v205

                            if v204.on == false then
                                v205.on = nil
                            end
                        else
                            v205 = v204
                        end
                    else
                        local v208, v209 = collect(child)

                        v205 = {
                            on = nil,
                            lightOn = nil,
                            list = v208,
                            lights = v209
                        }
                        t12[child] = v205
                        child.DescendantAdded:Connect(function(p60) -- line: 725
                            -- upvalues: child (copy), t12 (copy)
                            if p60:IsA("SurfaceGui") or p60:IsA("Light") then
                                local v210 = t12[child]

                                if v210 then
                                    v210.dirty = true
                                end
                            end
                        end)
                    end

                    local v211 = v180:FindFirstChild("Pitbox_" .. v202)

                    v211 = v211 and (v211.Position - v196).Magnitude
                    setFx(v205, not (v211 and v211 > 140))
                    v211 = v211 and v211 > 180
                    setLights(v205, not v211)
                end
            end

            for v213 in t12 do
                if not v213.Parent then
                    t12[v213] = nil
                end
            end

            if v194 then
                for _, v214 in v194 do
                    if v214.pos and v214.light.Parent then
                        local v215 = (v214.pos - v196).Magnitude < 260

                        if v214.on ~= v215 then
                            v214.on = v215
                            v214.light.Enabled = v215
                        end
                    end
                end
            end
        end
    end
end)

local t15 = {}

local function addDisplayBike(p61) -- line: 758
    -- upvalues: t15 (copy)
    if t15[p61] or not p61:IsA("Model") or p61.Name ~= "DisplayBike" or not p61.Parent then
        return
    end

    t15[p61] = {
        hidden = false,
        home = p61.Parent,
        pos = p61:GetPivot().Position
    }
    p61.Destroying:Once(function() -- line: 761
        -- upvalues: p61 (copy), t15 (copy)
        t15[p61] = nil
    end)
end

if v180 then
    for _, descendant in v180:GetDescendants() do
        if descendant.Name == "DisplayBike" then
            addDisplayBike(descendant)
        end
    end

    v180.DescendantAdded:Connect(function(p62) -- line: 765
        -- upvalues: addDisplayBike (copy)
        if p62.Name == "DisplayBike" then
            task.defer(addDisplayBike, p62)
        end
    end)
end

task.spawn(function() -- line: 767
    -- upvalues: t10 (copy), t15 (copy)
    while true do
        task.wait(0.2)

        local CurrentCamera = workspace.CurrentCamera
        local v216 = CurrentCamera and CurrentCamera.CFrame.Position

        if v216 then
            local n3 = 0

            for v217, v218 in t15 do
                local home = v218.home

                if home then
                    if home.Parent == nil and t10[home] == nil then
                        t15[v217] = nil

                        if v218.hidden then
                            local function v219() -- line: 778
                                -- upvalues: v217 (copy)
                                v217:Destroy()
                            end

                            pcall(v219)
                        end
                    elseif v218.hidden or v217.Parent == home then
                        if n3 < 6 then
                            local Magnitude = (v218.pos - v216).Magnitude

                            if v218.hidden and Magnitude < 90 then
                                local function v220() -- line: 784
                                    -- upvalues: home (copy), v217 (copy)
                                    v217.Parent = home
                                end

                                if pcall(v220) then
                                    v218.hidden = false
                                    n3 += 1
                                else
                                    t15[v217] = nil
                                end
                            elseif not v218.hidden and Magnitude > 110 then
                                v217.Parent = nil
                                v218.hidden = true
                                n3 += 1
                            end
                        end
                    else
                        t15[v217] = nil
                    end
                else
                    t15[v217] = nil

                    if v218.hidden then
                        local function v221() -- line: 778
                            -- upvalues: v217 (copy)
                            v217:Destroy()
                        end

                        pcall(v221)
                    end
                end
            end
        end
    end
end)
