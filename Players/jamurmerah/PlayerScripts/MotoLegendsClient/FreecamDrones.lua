-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local MotoLegends = ReplicatedStorage:WaitForChild("MotoLegends")
local FreecamDrone = MotoLegends:WaitForChild("FreecamDrone")
local FreecamPose = MotoLegends:WaitForChild("FreecamPose")
local JerezRaceHUD = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("JerezRaceHUD")
local Folder = Instance.new("Folder")

Folder.Name = "FreecamDrones"
Folder.Parent = workspace

local function inFreecam() -- line: 28
    -- upvalues: JerezRaceHUD (copy)
    return JerezRaceHUD:GetAttribute("Freecam") == true
end

local v1 = false

task.spawn(function() -- line: 30
    -- upvalues: FreecamPose (copy), JerezRaceHUD (copy), v1 (ref)
    while true do
        if JerezRaceHUD:GetAttribute("Freecam") == true then
            v1 = true
            FreecamPose:FireServer(workspace.CurrentCamera.CFrame)
        elseif v1 then
            v1 = false
            FreecamPose:FireServer(nil)
        end

        task.wait(0.1)
    end
end)

local t1 = {}

local function headingOnly(p1) -- line: 46
    local v2 = Vector3.new(p1.LookVector.X, 0, p1.LookVector.Z)

    if v2.Magnitude < 0.001 then
        v2 = Vector3.new(0, 0, -1)
    end

    return CFrame.lookAt(p1.Position, p1.Position + v2.Unit)
end

local function build(p2) -- line: 52
    -- upvalues: FreecamDrone (copy), Folder (copy)
    local clone = FreecamDrone:Clone()

    clone.Name = "Drone_" .. p2.Name

    local function v3() -- line: 54
        -- upvalues: clone (copy)
        clone:ScaleTo(clone:GetScale() * 1.8)
    end

    pcall(v3)

    local v4 = clone.PrimaryPart or clone:FindFirstChild("Base")

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BillboardGui") then
            descendant:Destroy()
        end
    end

    local t2 = {}

    for _, child in clone:GetChildren() do
        if child:IsA("BasePart") and child.Name == "Propeller" then
            table.insert(t2, {
                part = child,
                offset = v4.CFrame:ToObjectSpace(child.CFrame)
            })
        end
    end

    local v5 = clone:GetPivot():ToObjectSpace(v4.CFrame)
    local FreecamDroneCF = p2:GetAttribute("FreecamDroneCF")
    local v6, v7

    if FreecamDroneCF then
        local v8 = Vector3.new(FreecamDroneCF.LookVector.X, 0, FreecamDroneCF.LookVector.Z)

        if v8.Magnitude < 0.001 then
            v8 = Vector3.new(0, 0, -1)
        end

        local v9 = CFrame.lookAt(FreecamDroneCF.Position, FreecamDroneCF.Position + v8.Unit)

        if v9 then
            v6 = v9
            v7 = true
        else
            v7 = false
        end
    else
        v7 = false
    end

    if not v7 then
        v6 = CFrame.new()
    end

    local t4 = {
        vel = Vector3.new(0, 0, 0),
        model = clone,
        base = v4,
        baseOffset = v5,
        props = t2,
        cf = v6,
        tilt = CFrame.identity,
        spin = math.random() * 6
    }

    clone.Parent = Folder

    return t4
end

local function drop(p3) -- line: 70
    -- upvalues: t1 (copy)
    local v10 = t1[p3]

    if v10 then
        v10.model:Destroy()
        t1[p3] = nil
    end
end

Players.PlayerRemoving:Connect(drop)
RunService.RenderStepped:Connect(function(p4) -- line: 75
    -- upvalues: Players (copy), LocalPlayer (copy), JerezRaceHUD (copy), Folder (copy), t1 (copy), build (copy)
    local v11 = math.min(p4, 0.1)

    if JerezRaceHUD:GetAttribute("Freecam") == true and LocalPlayer:GetAttribute("FreecamDroneSelfTest") ~= true then
        if Folder.Parent then
            Folder.Parent = nil
        end
    else
        if Folder.Parent ~= workspace then
            Folder.Parent = workspace
        end

        local CFramePosition = workspace.CurrentCamera.CFrame.Position

        for _, player in Players:GetPlayers() do
            if (player ~= LocalPlayer or LocalPlayer:GetAttribute("FreecamDroneSelfTest") == true) and player:GetAttribute("FreecamDrone") == true and player:GetAttribute("FreecamDroneCF") ~= nil then
                local v12 = t1[player] or build(player)

                t1[player] = v12

                local FreecamDroneCF = player:GetAttribute("FreecamDroneCF")
                local v13 = Vector3.new(FreecamDroneCF.LookVector.X, 0, FreecamDroneCF.LookVector.Z)

                if v13.Magnitude < 0.001 then
                    v13 = Vector3.new(0, 0, -1)
                end

                local v14 = CFrame.lookAt(FreecamDroneCF.Position, FreecamDroneCF.Position + v13.Unit)
                local v16 = 1 - math.exp(-v11 * 9)
                local cfPosition = v12.cf.Position

                v12.cf = v12.cf:Lerp(v14, v16)

                local v17 = (v12.cf.Position - cfPosition) / math.max(v11, 0.001)

                v12.vel = v12.vel:Lerp(v17, 1 - math.exp(-v11 * 6))

                local v19 = v12.cf:VectorToObjectSpace(v12.vel)
                local v21 = math.clamp(v19.Z * 0.012, -0.3839724354387525, 0.3839724354387525)
                local v23 = math.clamp(-v19.X * 0.012, -0.3839724354387525, 0.3839724354387525)

                v12.tilt = v12.tilt:Lerp(CFrame.Angles(v21, 0, v23), 1 - math.exp(-v11 * 4))

                if (v12.cf.Position - CFramePosition).Magnitude > 1500 then
                    if v12.model.Parent then
                        v12.model.Parent = nil
                    end
                else
                    if v12.model.Parent ~= Folder then
                        v12.model.Parent = Folder
                    end

                    local v26 = v12.cf * v12.tilt * v12.baseOffset

                    v12.base.CFrame = v26
                    v12.spin += 55 * v11

                    for v27, v28 in v12.props do
                        local v29 = v27 % 2 == 0 and 1 or -1

                        v28.part.CFrame = v26 * v28.offset * CFrame.Angles(0, v12.spin * v29, 0)
                    end
                end
            elseif t1[player] then
                local v30 = t1[player]

                if v30 then
                    v30.model:Destroy()
                    t1[player] = nil
                end
            end
        end
    end
end)
