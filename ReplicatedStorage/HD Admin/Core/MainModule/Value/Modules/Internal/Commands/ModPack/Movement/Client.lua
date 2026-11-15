-- https://lua.expert

local t1 = {
    Left = Vector3.new(-1, 0, 0),
    Right = Vector3.new(1, 0, 0),
    Forwards = Vector3.new(0, 0, -1),
    Backwards = Vector3.new(0, 0, 1),
    Up = Vector3.new(0, 1, 0),
    Down = Vector3.new(0, -1, 0)
}
local Modules = script:FindFirstAncestor("HD Admin").Core.MainModule.Value.Modules
local Log = require(Modules.Log)
local CommandAPI = require(script:FindFirstAncestor("HD Admin").Core.CommandAPI)
local getHumanoid, getHRP = CommandAPI.getHumanoid, CommandAPI.getHRP
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local PhysicsService = game:GetService("PhysicsService")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local t2 = {}
local InputController = Modules.Parent.Controllers.InputController

local function setCollisionGroupRecursive(p1, p2) -- line: 33
    -- upvalues: PhysicsService (copy), t2 (copy)
    if p2 and not t2[p2] then
        t2[p2] = true

        local function v1() -- line: 38
            -- upvalues: p2 (copy), PhysicsService (copy)
            PhysicsService:RegisterCollisionGroup(p2)
        end

        pcall(v1)
    end

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v2 = descendant:GetAttribute("HDCollisionGroupCount") or 0
            local HDOriginalCollisionGroup = descendant:GetAttribute("HDOriginalCollisionGroup")

            if p2 then
                if not HDOriginalCollisionGroup then
                    descendant:SetAttribute("HDOriginalCollisionGroup", descendant.CollisionGroup)
                end

                v2 += 1
                descendant.CollisionGroup = p2
            elseif typeof(HDOriginalCollisionGroup) == "string" then
                v2 -= 1

                if v2 <= 0 then
                    v2 = nil
                end

                descendant.CollisionGroup = HDOriginalCollisionGroup
            end

            descendant:SetAttribute("HDCollisionGroupCount", v2)
        end
    end
end

local function getCF(p3, p4) -- line: 65
    local _CFrame = p3.CFrame
    local v3 = CFrame.new(_CFrame.p)
    local v4, v5, v6 = (workspace.CurrentCamera.CFrame - workspace.CurrentCamera.CFrame.p):toEulerAnglesXYZ()
    local Angles = CFrame.Angles

    if p4 and v6 then
        v4 = v6
    end

    return v3 * Angles(v4, v5, v6)
end

local function getNextMovement(p5, p6) -- line: 73
    -- upvalues: t1 (copy), getHumanoid (copy), getHRP (copy), UserInputService (copy), InputController (copy), getCF (copy)
    local v7 = Vector3.new()
    local v8 = require(InputController).getPressedMovementKeys()

    local function updateNextMove() -- line: 77
        -- upvalues: v7 (ref), v8 (copy), t1 (copy), getHumanoid (copy), getHRP (copy), UserInputService (copy), getCF (copy)
        if UserInputService.KeyboardEnabled then
            for _, v9 in v8 do
                local v10 = t1[v9]

                if v10 then
                    v7 += v10
                end
            end
        else
            local v11 = getHumanoid()
            local v12 = getHRP()

            if v11 and v12 then
                local _, MoveDirection = v11.MoveDirection, v11.MoveDirection

                for _, v13 in t1 do
                    if ((getCF(v12, true) * CFrame.new(v13) - v12.CFrame.p).p - MoveDirection).magnitude <= 1.05 and MoveDirection ~= Vector3.new(0, 0, 0) then
                        v7 += v13
                    end
                end
            end
        end
    end

    updateNextMove()

    return CFrame.new(v7 * p6 * p5), v7
end

local function handleInput(p7, p8) -- line: 111
    -- upvalues: Modules (copy), Log (copy), getHumanoid (copy), LocalPlayer (copy), InputController (copy)
    local v14 = require(InputController)
    local Janitor = require(Modules.Objects.Janitor)
    local janitor = p7.janitor
    local v15 = janitor:add(Janitor.new())
    local v16 = getHumanoid()

    local function runLoop() -- line: 117
        -- upvalues: p7 (copy), p8 (copy), Log (copy), LocalPlayer (copy)
        local v17 = (p7.extra.loopGeneration or 0) + 1

        p7.extra.loopGeneration = v17
        p7.extra.loopAlive = true

        local n1 = 0

        while p7.extra.isActive do
            local v18 = true

            if n1 < 5 then
                local Character = LocalPlayer.Character

                v18 = if Character and Character.Parent and Character:FindFirstChild("HumanoidRootPart") then not not Character:FindFirstChildOfClass("Humanoid") else false
            end

            if v18 then
                break
            end

            p7.wait(0.1)
            n1 += 0.1
        end

        p7.extra.loopCharacter = LocalPlayer.Character

        local ok, result = pcall(p8)

        if p7.extra.loopGeneration == v17 then
            p7.extra.loopAlive = false
        end

        if not ok then
            Log.debug("flight error:", result)
        end
    end

    local function toggleFlight() -- line: 139
        -- upvalues: p7 (copy), v15 (copy), runLoop (copy)
        local v19 = not p7.extra.isActive

        p7.extra.isActive = v19

        if v19 then
            p7.spawn(runLoop)
        else
            v15:cleanup()
        end
    end

    p7.extra.janitor = v15
    p7.extra.isActive = true
    p7.extra.restartLoop = runLoop
    p7:onEnded(function() -- line: 151
        -- upvalues: p7 (copy)
        p7.extra.isActive = false
    end)
    p7.spawn(runLoop)
    janitor:add(v14.onPressed(Enum.KeyCode.E, toggleFlight))

    if v16 then
        janitor:add(v14.onDoubleJumped(v16, toggleFlight))
    end
end

local function startFlight(p9, p10, p11, p12) -- line: 161
    -- upvalues: getHumanoid (copy), getHRP (copy), LocalPlayer (copy), CurrentCamera (copy), setCollisionGroupRecursive (copy), getNextMovement (copy)
    local loopGeneration = p9.extra.loopGeneration
    local v20 = getHRP()
    local v21 = getHumanoid()

    if not (v20 and v21) then
        return
    end

    local janitor = p9.extra.janitor
    local v22 = janitor:add(Instance.new("BodyPosition"))

    v22.MaxForce = Vector3.new(1e999, 1e999, 1e999)
    v22.Position = v20.Position + Vector3.new(0, 4, 0)
    v22.Name = "HDAdminFlyForce"
    v22.Parent = v20

    local v23 = janitor:add(Instance.new("BodyGyro"))

    v23.D = 50
    v23.MaxTorque = Vector3.new(1e999, 1e999, 1e999)

    if p12 then
        v23.P = 2000
    else
        v23.P = 200
    end

    v23.Name = "HDAdminFlyGyro"
    v23.CFrame = v20.CFrame
    v23.Parent = v20

    local Character = LocalPlayer.Character

    if p12 and Character then
        setCollisionGroupRecursive(workspace, "HDGroupWorkspace")
        setCollisionGroupRecursive(Character, "HDGroupCharacter")
    end

    p9.extra.speed = p9.extra.speed or p10

    local v24 = 0
    local v25 = 0
    local v26 = tick()
    local Position = v20.Position

    repeat
        local v27 = tick() - v26
        local unit = (CurrentCamera.Focus.p - CurrentCamera.CFrame.p).unit
        local speed = p9.extra.speed
        local v28, v29 = getNextMovement(v27, speed * 10)
        local Position2 = v20.Position
        local v30 = CFrame.new(Position2, Position2 + unit) * v28
        local v31 = 750 + speed * 0.2

        if p12 then
            v31 /= 2
        end

        if v28.p == Vector3.new() then
            v25 += 1

            if (v20.Position - Position).magnitude > 6 and v25 >= 4 then
                v22.Position = v20.Position
            end

            v24 = 1
        else
            v22.D = v31
            v24 += 1
            v25 = 0
            v22.Position = v30.p
        end

        if math.abs(v24) > 25 then
            v24 = 25
        end

        if v22.D == v31 then
            local _ = v24 * v29.X * -0.5
            local v32 = if p12 then 0 else v24 * v29.Z

            v23.CFrame = v30 * CFrame.Angles(math.rad(v32), 0, 0)
        end

        v26 = tick()
        Position = v20.Position
        v21[p11] = true
        p9.wait()
    until not p9.extra.isActive or p9.extra.loopGeneration ~= loopGeneration or not v21.Parent or not v20.Parent

    v22:Destroy()
    v23:Destroy()

    if v21.Parent then
        v21[p11] = false
    end

    if p12 then
        setCollisionGroupRecursive(workspace, nil)

        if Character and Character.Parent then
            setCollisionGroupRecursive(Character, nil)
        end
    end
end

local function reuseSpeed(p13, p14) -- line: 254
    -- upvalues: LocalPlayer (copy)
    if not p13.extra.janitor then
        return false
    end

    p13.extra.speed = p14

    local restartLoop = p13.extra.restartLoop
    local v33 = p13.extra.loopCharacter == LocalPlayer.Character
    local v34 = p13.extra.loopAlive and v33

    if p13.extra.isActive and restartLoop and not v34 then
        p13.spawn(restartLoop)
    end

    return true
end

return {
    {
        name = "Fly",
        run = function(p15, p16) -- run | line: 275
            -- upvalues: LocalPlayer (copy), handleInput (copy), startFlight (copy)
            if not p15.extra.janitor then
                handleInput(p15, function() -- line: 277
                    -- upvalues: p15 (copy), p16 (copy), startFlight (copy)
                    startFlight(p15, p16, "PlatformStand", false)
                end)

                return
            end

            p15.extra.speed = p16

            local restartLoop = p15.extra.restartLoop
            local v35 = p15.extra.loopCharacter == LocalPlayer.Character
            local v36 = p15.extra.loopAlive and v35

            if p15.extra.isActive and restartLoop and not v36 then
                p15.spawn(restartLoop)
            end
        end
    },
    {
        name = "Fly2",
        run = function(p17, p18) -- run | line: 286
            -- upvalues: LocalPlayer (copy), handleInput (copy), startFlight (copy)
            if not p17.extra.janitor then
                handleInput(p17, function() -- line: 288
                    -- upvalues: p17 (copy), p18 (copy), startFlight (copy)
                    startFlight(p17, p18, "Sit", false)
                end)

                return
            end

            p17.extra.speed = p18

            local restartLoop = p17.extra.restartLoop
            local v37 = p17.extra.loopCharacter == LocalPlayer.Character
            local v38 = p17.extra.loopAlive and v37

            if p17.extra.isActive and restartLoop and not v38 then
                p17.spawn(restartLoop)
            end
        end
    },
    {
        name = "NoClip",
        run = function(p19, p20) -- run | line: 297
            -- upvalues: getHumanoid (copy), getHRP (copy), LocalPlayer (copy), CurrentCamera (copy), getNextMovement (copy), handleInput (copy)
            if not p19.extra.janitor then
                handleInput(p19, function() -- line: 299
                    -- upvalues: p19 (copy), p20 (copy), getHumanoid (copy), getHRP (copy), CurrentCamera (copy), getNextMovement (copy)
                    local loopGeneration = p19.extra.loopGeneration
                    local v39 = getHumanoid()
                    local v40 = getHRP()

                    if v39 and v40 then
                        local v41 = tick()

                        p19.extra.speed = p19.extra.speed or p20
                        v40.Anchored = true
                        v39.PlatformStand = true

                        repeat
                            local v42 = tick() - v41
                            local Unit = (CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position).Unit
                            local v43 = getNextMovement(v42, p19.extra.speed)
                            local Position = v40.Position

                            v40.CFrame = CFrame.new(Position, Position + Unit) * v43
                            v41 = tick()
                            p19.wait()
                        until not p19.extra.isActive or p19.extra.loopGeneration ~= loopGeneration or not v39.Parent or not v40.Parent

                        if not (v40.Parent and v39.Parent) then
                            return
                        end

                        v40.Anchored = false
                        v40.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        v40.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        v39.PlatformStand = false
                    end
                end)

                return
            end

            p19.extra.speed = p20

            local restartLoop = p19.extra.restartLoop
            local v44 = p19.extra.loopCharacter == LocalPlayer.Character
            local v45 = p19.extra.loopAlive and v44

            if p19.extra.isActive and restartLoop and not v45 then
                p19.spawn(restartLoop)
            end
        end
    },
    {
        name = "NoClip2",
        run = function(p21, p22) -- run | line: 332
            -- upvalues: LocalPlayer (copy), handleInput (copy), startFlight (copy)
            if not p21.extra.janitor then
                handleInput(p21, function() -- line: 334
                    -- upvalues: p21 (copy), p22 (copy), startFlight (copy)
                    startFlight(p21, p22, "Sit", true)
                end)

                return
            end

            p21.extra.speed = p22

            local restartLoop = p21.extra.restartLoop
            local v46 = p21.extra.loopCharacter == LocalPlayer.Character
            local v47 = p21.extra.loopAlive and v46

            if p21.extra.isActive and restartLoop and not v47 then
                p21.spawn(restartLoop)
            end
        end
    }
}
