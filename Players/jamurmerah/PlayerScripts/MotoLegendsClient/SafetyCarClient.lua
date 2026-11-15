-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SafetyCar = ReplicatedStorage:WaitForChild("MotoLegends"):WaitForChild("SafetyCar")
local Config = require(SafetyCar:WaitForChild("Config"))
local CarPhysics = require(SafetyCar:WaitForChild("CarPhysics"))
local CarVisuals = require(SafetyCar:WaitForChild("CarVisuals"))
local CarHUD = require(SafetyCar:WaitForChild("CarHUD"))
local State = SafetyCar:WaitForChild("State")
local Action = SafetyCar:WaitForChild("Action")
local SafetyCars = workspace:WaitForChild("SafetyCars")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1 = CarHUD.New(PlayerGui)
local StudMetres = Config.StudMetres
local KeyCode = Enum.KeyCode
local Sink, Pass = Enum.ContextActionResult.Sink, Enum.ContextActionResult.Pass
local t1
local t2 = {
    transmission = "Automatic",
    camera = 1,
    esc = Config.ESC
}
local t3 = {}
local t4 = {
    throttle = 0,
    brake = 0,
    steer = 0,
    camX = 0,
    camY = 0
}
local n1 = 0
local n2 = 0
local n3 = 0
local v2 = false
local v3 = false
local n4 = 0
local t5
local t6 = {
    yaw = nil,
    orbitYaw = 0,
    orbitPitch = 0,
    zoom = 1,
    lastOrbit = 0,
    dragging = false,
    focusY = nil,
    rot = nil,
    wasBack = false
}
local t7 = {}
local t8 = {
    KeyCode.W,
    KeyCode.S,
    KeyCode.A,
    KeyCode.D,
    KeyCode.Up,
    KeyCode.Down,
    KeyCode.Left,
    KeyCode.Right,
    KeyCode.Q,
    KeyCode.E,
    KeyCode.M,
    KeyCode.R,
    KeyCode.L,
    KeyCode.H,
    KeyCode.U,
    KeyCode.LeftShift,
    KeyCode.RightShift,
    KeyCode.Space,
    KeyCode.C,
    KeyCode.X,
    KeyCode.ButtonR2,
    KeyCode.ButtonL2,
    KeyCode.Thumbstick1,
    KeyCode.Thumbstick2,
    KeyCode.ButtonX,
    KeyCode.ButtonY,
    KeyCode.ButtonA,
    KeyCode.ButtonB,
    KeyCode.ButtonR1,
    KeyCode.ButtonL1,
    KeyCode.ButtonR3,
    KeyCode.ButtonL3,
    KeyCode.DPadUp,
    KeyCode.DPadDown,
    KeyCode.DPadLeft,
    KeyCode.DPadRight
}
local t9 = {
    KeyCode.Space,
    KeyCode.C,
    KeyCode.X,
    KeyCode.ButtonR1,
    KeyCode.ButtonR3,
    KeyCode.ButtonL3,
    KeyCode.Thumbstick2,
    KeyCode.ButtonA,
    KeyCode.ButtonX,
    KeyCode.ButtonY
}

local function humanoid() -- line: 50
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    return Character and Character:FindFirstChildOfClass("Humanoid")
end

local function axis(p1, p2, p3) -- line: 55
    if typeof(p1) ~= "number" or p1 ~= p1 then
        return 0
    end

    local v5 = math.clamp((math.abs(p1) - p2) / ((p3 or 1) - p2), 0, 1)

    return math.sign(p1) * v5
end

local function moveToward(p4, p5, p6) -- line: 61
    if p4 < p5 then
        return (math.min(p4 + p6, p5))
    end

    return (math.max(p4 - p6, p5))
end

local function lerpAngle(p7, p8, p9) -- line: 66
    return p7 + ((p8 - p7 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * p9
end

local function sendAction(p10, p11) -- line: 71
    -- upvalues: Action (copy)
    Action:FireServer(p10, p11)
end

local function cameraCount() -- line: 75
    -- upvalues: Config (copy), t1 (ref)
    local v8, v9

    if t1 and t1.role == "Driver" then
        local v10 = #Config.Cameras

        if v10 then
            v8 = v10
            v9 = true
        else
            v9 = false
        end
    else
        v9 = false
    end

    if not v9 then
        v8 = 3
    end

    return v8
end

local function setHeadHidden(p12) -- line: 79
    -- upvalues: LocalPlayer (copy), t7 (copy)
    if p12 then
        local Character = LocalPlayer.Character

        if Character then
            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") and (descendant.Name == "Head" or descendant:FindFirstAncestorOfClass("Accessory")) then
                    descendant.LocalTransparencyModifier = 1
                    t7[descendant] = true
                end
            end
        end
    else
        for v11 in t7 do
            if v11.Parent then
                v11.LocalTransparencyModifier = 0
            end
        end

        table.clear(t7)
    end
end

local function nextCamera() -- line: 97
    -- upvalues: Config (copy), t1 (ref), t2 (copy), t6 (copy), t7 (copy)
    local camera = t2.camera
    local v12, v13

    if t1 and t1.role == "Driver" then
        local v14 = #Config.Cameras

        if v14 then
            v12 = v14
            v13 = true
        else
            v13 = false
        end
    else
        v13 = false
    end

    if not v13 then
        v12 = 3
    end

    t2.camera = camera % v12 + 1
    t6.yaw = nil
    t6.rot = nil

    for v15 in t7 do
        if v15.Parent then
            v15.LocalTransparencyModifier = 0
        end
    end

    table.clear(t7)
end

local function setHorn(p13) -- line: 103
    -- upvalues: Action (copy), v3 (ref)
    if v3 ~= p13 then
        v3 = p13
        Action:FireServer("Horn", p13)
    end
end

local function shift(p14) -- line: 109
    -- upvalues: CarPhysics (copy), t1 (ref)
    if t1 and t1.phys then
        CarPhysics.RequestShift(t1.phys, p14)
    end
end

local function toggleTransmission() -- line: 113
    -- upvalues: Action (copy), v1 (copy), t1 (ref), t2 (copy)
    local v16 = t1 and t1.phys

    if not v16 then
        return
    end

    v16.transmission = v16.transmission == "Automatic" and "Manual" or "Automatic"
    t2.transmission = v16.transmission

    if v16.transmission == "Automatic" and v16.gear == 0 then
        v16.gear = 1
    end

    Action:FireServer("Transmission", v16.transmission)
    v1:Toast(v16.transmission == "Manual" and "MANUAL GEARBOX  (Q / E to shift)" or "AUTOMATIC GEARBOX")
end

local function toggleAssists() -- line: 123
    -- upvalues: v1 (copy), t1 (ref), t2 (copy)
    local v17 = t1 and t1.phys

    if not v17 then
        return
    end

    t2.esc = not t2.esc

    local esc, esc2 = t2.esc, t2.esc

    v17.esc = esc
    v17.tcs = esc2
    v1:Toast(t2.esc and "ESC + TCS ON" or "ESC + TCS OFF")
end

local function onInput(_, p16, p17) -- line: 131
    -- upvalues: Config (copy), CarPhysics (copy), Action (copy), v1 (copy), KeyCode (copy), Sink (copy), Pass (copy), t1 (ref), t2 (copy), t3 (copy), t4 (copy), v2 (ref), v3 (ref), t6 (copy), t7 (copy), toggleTransmission (copy)
    if not t1 then
        return Pass
    end

    local KeyCode2 = p17.KeyCode
    local v18 = p16 == Enum.UserInputState.Begin or p16 == Enum.UserInputState.Change
    local v19 = t1.role == "Driver"

    if KeyCode2 == KeyCode.ButtonR2 then
        local v20, v21

        if v18 then
            local Z = p17.Position.Z

            if typeof(Z) == "number" and Z == Z then
                local v23 = math.clamp((math.abs(Z) - 0.04) / 0.96, 0, 1)
                local v24 = math.sign(Z) * v23

                if v24 then
                    v20 = v24
                    v21 = true
                else
                    v21 = false
                end
            else
                v20 = 0
                v21 = true
            end
        else
            v21 = false
        end

        t4.throttle = if not v21 then 0 else v20

        return Sink
    end

    if KeyCode2 == KeyCode.ButtonL2 then
        local v25, v26

        if v18 then
            local Z = p17.Position.Z

            if typeof(Z) == "number" and Z == Z then
                local v28 = math.clamp((math.abs(Z) - 0.04) / 0.96, 0, 1)
                local v29 = math.sign(Z) * v28

                if v29 then
                    v25 = v29
                    v26 = true
                else
                    v26 = false
                end
            else
                v25 = 0
                v26 = true
            end
        else
            v26 = false
        end

        t4.brake = if not v26 then 0 else v25

        return Sink
    end

    if KeyCode2 == KeyCode.Thumbstick1 then
        local v30, v31

        if v18 then
            local X = p17.Position.X

            if typeof(X) == "number" and X == X then
                local v33 = math.clamp((math.abs(X) - 0.1) / 0.75, 0, 1)
                local v34 = math.sign(X) * v33

                if v34 then
                    v30 = v34
                    v31 = true
                else
                    v31 = false
                end
            else
                v30 = 0
                v31 = true
            end
        else
            v31 = false
        end

        t4.steer = if not v31 then 0 else v30

        return Sink
    end

    if KeyCode2 == KeyCode.Thumbstick2 then
        local v35, v36

        if v18 then
            local X = p17.Position.X

            if typeof(X) == "number" and X == X then
                local v38 = math.clamp((math.abs(X) - 0.15) / 0.85, 0, 1)
                local v39 = math.sign(X) * v38

                if v39 then
                    v35 = v39
                    v36 = true
                else
                    v36 = false
                end
            else
                v35 = 0
                v36 = true
            end
        else
            v36 = false
        end

        t4.camX = if not v36 then 0 else v35

        local v40, v41

        if v18 then
            local Y = p17.Position.Y

            if typeof(Y) == "number" and Y == Y then
                local v43 = math.clamp((math.abs(Y) - 0.15) / 0.85, 0, 1)
                local v44 = math.sign(Y) * v43

                if v44 then
                    v40 = v44
                    v41 = true
                else
                    v41 = false
                end
            else
                v40 = 0
                v41 = true
            end
        else
            v41 = false
        end

        t4.camY = if not v41 then 0 else v40

        return Sink
    end

    t3[KeyCode2] = v18 or nil

    if KeyCode2 == KeyCode.X or KeyCode2 == KeyCode.ButtonR3 then
        v2 = v18
    end

    if p16 == Enum.UserInputState.Begin then
        if KeyCode2 == KeyCode.C or KeyCode2 == KeyCode.ButtonR1 then
            local camera = t2.camera
            local t10 = t1
            local v45 = t10 and t1.role == "Driver" and #Config.Cameras or 3

            t2.camera = camera % v45 + 1
            t6.yaw = nil
            t6.rot = nil

            for v46 in t7 do
                if v46.Parent then
                    v46.LocalTransparencyModifier = 0
                end
            end

            table.clear(t7)
        elseif KeyCode2 == KeyCode.Space or KeyCode2 == KeyCode.ButtonL3 then
            Action:FireServer("Exit", nil)
        elseif v19 then
            if KeyCode2 == KeyCode.Q or KeyCode2 == KeyCode.ButtonX then
                if t1 and t1.phys then
                    CarPhysics.RequestShift(t1.phys, -1)
                end
            elseif KeyCode2 == KeyCode.E or KeyCode2 == KeyCode.ButtonY then
                if t1 and t1.phys then
                    CarPhysics.RequestShift(t1.phys, 1)
                end
            elseif KeyCode2 == KeyCode.M or KeyCode2 == KeyCode.DPadRight then
                toggleTransmission()
            elseif KeyCode2 == KeyCode.R or KeyCode2 == KeyCode.ButtonB then
                Action:FireServer("LightBar", nil)
            elseif KeyCode2 == KeyCode.L or KeyCode2 == KeyCode.DPadUp then
                Action:FireServer("Headlights", nil)
            elseif KeyCode2 == KeyCode.U or KeyCode2 == KeyCode.DPadLeft then
                local v47 = t1

                v47 = v47 and t1.phys

                if v47 then
                    t2.esc = not t2.esc

                    local esc, esc2 = t2.esc, t2.esc

                    v47.esc = esc
                    v47.tcs = esc2
                    v1:Toast(t2.esc and "ESC + TCS ON" or "ESC + TCS OFF")
                end
            elseif KeyCode2 == KeyCode.H or KeyCode2 == KeyCode.ButtonL1 then
                if v3 == true then
                    return Sink
                end

                v3 = true
                Action:FireServer("Horn", true)
            end
        end
    elseif not (v18 or KeyCode2 ~= KeyCode.H and KeyCode2 ~= KeyCode.ButtonL1) and v3 ~= false then
        v3 = false
        Action:FireServer("Horn", false)
    end

    return Sink
end

v1.OnButton = function(p18) -- line: 165
    -- upvalues: Config (copy), CarPhysics (copy), Action (copy), t1 (ref), t2 (copy), t6 (copy), t7 (copy)
    if t1 then
        if p18 == "Camera" then
            local camera = t2.camera
            local v49, v50

            if t1 and t1.role == "Driver" then
                local v51 = #Config.Cameras

                if v51 then
                    v49 = v51
                    v50 = true
                else
                    v50 = false
                end
            else
                v50 = false
            end

            if not v50 then
                v49 = 3
            end

            t2.camera = camera % v49 + 1
            t6.yaw = nil
            t6.rot = nil

            for v52 in t7 do
                if v52.Parent then
                    v52.LocalTransparencyModifier = 0
                end
            end

            table.clear(t7)
        elseif p18 == "Exit" then
            Action:FireServer("Exit", nil)
        elseif t1.role == "Driver" then
            if p18 == "GearUp" then
                if t1 and t1.phys then
                    CarPhysics.RequestShift(t1.phys, 1)
                end
            elseif p18 == "GearDown" then
                if t1 and t1.phys then
                    CarPhysics.RequestShift(t1.phys, -1)
                end
            elseif p18 == "LightBar" then
                Action:FireServer("LightBar", nil)
            end
        end
    end
end

v1.OnHorn = function(p19) -- line: 176
    -- upvalues: Action (copy), t1 (ref), v3 (ref)
    if not t1 or t1.role ~= "Driver" or v3 == p19 then
        return
    end

    v3 = p19
    Action:FireServer("Horn", p19)
end

local RaceLobbyHUD

local function hideLobby(p20) -- line: 189
    -- upvalues: PlayerGui (copy), RaceLobbyHUD (ref)
    if p20 then
        local RaceLobbyHUD2 = PlayerGui:FindFirstChild("RaceLobbyHUD")

        if RaceLobbyHUD2 and RaceLobbyHUD2:IsA("ScreenGui") and RaceLobbyHUD2.Enabled then
            RaceLobbyHUD2.Enabled = false
            RaceLobbyHUD = RaceLobbyHUD2
        end

        local ChampionshipHUD = PlayerGui:FindFirstChild("ChampionshipHUD")
        local DailyTasks = ChampionshipHUD and ChampionshipHUD:FindFirstChild("DailyTasks")

        if DailyTasks and DailyTasks:IsA("GuiObject") and DailyTasks.Visible then
            DailyTasks.Visible = false
        end
    else
        if RaceLobbyHUD and RaceLobbyHUD.Parent then
            RaceLobbyHUD.Enabled = true
        end

        RaceLobbyHUD = nil
    end
end

local function leave() -- line: 205
    -- upvalues: UserInputService (copy), ContextActionService (copy), GuiService (copy), ProximityPromptService (copy), Action (copy), LocalPlayer (copy), v1 (copy), t1 (ref), t3 (copy), t4 (copy), n1 (ref), n2 (ref), n3 (ref), v2 (ref), v3 (ref), t5 (ref), t6 (copy), t7 (copy), RaceLobbyHUD (ref)
    if not t1 then
        return
    end

    ContextActionService:UnbindAction("SafetyCarControls")

    if v3 ~= false then
        v3 = false
        Action:FireServer("Horn", false)
    end

    for v53 in t7 do
        if v53.Parent then
            v53.LocalTransparencyModifier = 0
        end
    end

    table.clear(t7)
    v1:Hide()

    if RaceLobbyHUD and RaceLobbyHUD.Parent then
        RaceLobbyHUD.Enabled = true
    end

    RaceLobbyHUD = nil

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    end

    if t5 then
        LocalPlayer.CameraMinZoomDistance = t5.minZoom
        LocalPlayer.CameraMaxZoomDistance = t5.maxZoom
        workspace.CurrentCamera.FieldOfView = t5.fov
        ProximityPromptService.Enabled = t5.prompts

        local function v54() -- line: 219
            -- upvalues: GuiService (copy), t5 (ref)
            GuiService.TouchControlsEnabled = t5.touch
        end

        pcall(v54)
    end

    if t6.dragging then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end

    t6.dragging = false
    table.clear(t3)
    t4.throttle = 0
    t4.brake = 0
    t4.steer = 0
    t4.camX = 0
    t4.camY = 0
    n1 = 0
    n2 = 0
    n3 = 0
    v2 = false
    t1 = nil
    t5 = nil
end

local function enter(p21, p22) -- line: 230
    -- upvalues: ContextActionService (copy), GuiService (copy), ProximityPromptService (copy), Config (copy), CarPhysics (copy), Action (copy), LocalPlayer (copy), PlayerGui (copy), v1 (copy), t1 (ref), t2 (copy), t3 (copy), t4 (copy), n1 (ref), n2 (ref), n3 (ref), v2 (ref), t5 (ref), t6 (copy), t8 (copy), t9 (copy), onInput (copy), hideLobby (copy), leave (copy)
    if t1 and t1.car == p21 and t1.seat == p22 then
        return
    end

    if t1 then
        leave()
    end

    local v55 = p21.PrimaryPart or p21:FindFirstChild("Chassis")

    if not v55 then
        return
    end

    local v56 = if p22.Name == "DriverSeat" then "Driver" else "Passenger"

    t1 = {
        car = p21,
        chassis = v55,
        seat = p22,
        role = v56
    }

    if v56 == "Driver" then
        local v57 = CarPhysics.New(p21)

        if p21:GetAttribute("Transmission") == "Manual" then
            v57.transmission = "Manual"
        else
            v57.transmission = t2.transmission
        end

        local esc, esc2 = t2.esc, t2.esc

        v57.esc = esc
        v57.tcs = esc2
        t1.phys = v57
        Action:FireServer("Ready", p21)
    end

    table.clear(t3)
    t4.throttle = 0
    t4.brake = 0
    t4.steer = 0
    t4.camX = 0
    t4.camY = 0
    n1 = 0
    n2 = 0
    n3 = 0
    v2 = false

    local camera = t2.camera
    local v58, v59

    if t1 and t1.role == "Driver" then
        local v60 = #Config.Cameras

        if v60 then
            v58 = v60
            v59 = true
        else
            v59 = false
        end
    else
        v59 = false
    end

    if not v59 then
        v58 = 3
    end

    if v58 < camera then
        t2.camera = 1
    end

    t6.yaw = nil
    t6.rot = nil
    t6.focusY = nil
    t6.orbitYaw = 0
    t6.orbitPitch = 0

    local t13 = {
        minZoom = LocalPlayer.CameraMinZoomDistance,
        maxZoom = LocalPlayer.CameraMaxZoomDistance,
        fov = workspace.CurrentCamera.FieldOfView
    }
    local Enabled = ProximityPromptService.Enabled

    if not Enabled then
        Enabled = PlayerGui:FindFirstChild("JerezRaceHUD") ~= nil and PlayerGui.JerezRaceHUD:GetAttribute("SpectatePromptsBlocked") == true
    end

    t13.prompts = Enabled
    t13.touch = GuiService.TouchControlsEnabled
    t5 = t13
    LocalPlayer.CameraMaxZoomDistance = 15
    LocalPlayer.CameraMinZoomDistance = 15
    ProximityPromptService.Enabled = false

    local function v61() -- line: 258
        -- upvalues: GuiService (copy)
        GuiService.TouchControlsEnabled = false
    end

    pcall(v61)

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    end

    ContextActionService:BindActionAtPriority("SafetyCarControls", onInput, false, 3500, table.unpack(v56 == "Driver" and t8 or t9))
    v1:Show(v56, p21)
    hideLobby(true)
end

local function watchHumanoid(p23) -- line: 266
    -- upvalues: SafetyCars (copy), t1 (ref), leave (copy), enter (copy)
    local function check() -- line: 267
        -- upvalues: p23 (copy), SafetyCars (copy), t1 (ref), leave (copy), enter (copy)
        local SeatPart = p23.SeatPart
        local v63 = SeatPart and SeatPart.Parent

        if SeatPart and v63 and v63:IsA("Model") and v63:GetAttribute("SafetyCar") == true and v63.Parent == SafetyCars and (SeatPart.Name == "DriverSeat" or SeatPart.Name == "PassengerSeat") then
            enter(v63, SeatPart)
        elseif t1 then
            leave()
        end
    end

    p23:GetPropertyChangedSignal("SeatPart"):Connect(check)
    p23.Died:Connect(function() -- line: 278
        -- upvalues: t1 (ref), leave (copy)
        if t1 then
            leave()
        end
    end)
    check()
end

LocalPlayer.CharacterAdded:Connect(function(p24) -- line: 281
    -- upvalues: t1 (ref), leave (copy), watchHumanoid (copy)
    if t1 then
        leave()
    end

    local v64 = p24:WaitForChild("Humanoid", 10)

    if v64 then
        watchHumanoid(v64)
    end
end)
LocalPlayer.CharacterRemoving:Connect(function() -- line: 286
    -- upvalues: t1 (ref), leave (copy)
    if t1 then
        leave()
    end
end)

if LocalPlayer.Character then
    local v65 = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or LocalPlayer.Character:WaitForChild("Humanoid", 10)

    if v65 then
        watchHumanoid(v65)
    end
end

local function track(p25) -- line: 293
    -- upvalues: CarVisuals (copy)
    task.spawn(function() -- line: 294
        -- upvalues: p25 (copy), CarVisuals (copy)
        if p25:IsA("Model") then
            CarVisuals.Track(p25)
        end
    end)
end

SafetyCars.ChildAdded:Connect(track)
SafetyCars.ChildRemoved:Connect(function(p26) -- line: 299
    -- upvalues: CarVisuals (copy), t1 (ref), leave (copy)
    CarVisuals.Untrack(p26)

    if t1 and t1.car == p26 then
        leave()
    end
end)

for _, child in SafetyCars:GetChildren() do
    task.spawn(function() -- line: 294
        -- upvalues: CarVisuals (copy), child (copy)
        if child:IsA("Model") then
            CarVisuals.Track(child)
        end
    end)
end

local function refreshPrompts() -- line: 305
    -- upvalues: Config (copy), SafetyCars (copy), LocalPlayer (copy)
    for _, child in SafetyCars:GetChildren() do
        local Chassis = child:FindFirstChild("Chassis")
        local DriverDoor = Chassis and Chassis:FindFirstChild("DriverDoor")
        local DriverPrompt = DriverDoor and DriverDoor:FindFirstChild("DriverPrompt")

        if DriverPrompt then
            DriverPrompt.Enabled = (Config.DriverAccess ~= "Owner" or child:GetAttribute("OwnerUserId") == LocalPlayer.UserId) and (child:GetAttribute("Driver") or 0) == 0
        end

        local PassengerDoor = Chassis and Chassis:FindFirstChild("PassengerDoor")
        local PassengerPrompt = PassengerDoor and PassengerDoor:FindFirstChild("PassengerPrompt")

        if PassengerPrompt then
            PassengerPrompt.Enabled = (child:GetAttribute("Passenger") or 0) == 0
        end
    end
end

task.spawn(function() -- line: 319
    -- upvalues: refreshPrompts (copy)
    while true do
        refreshPrompts()
        task.wait(0.4)
    end
end)
Action.OnClientEvent:Connect(function(p27, p28) -- line: 326
    -- upvalues: LocalPlayer (copy), v1 (copy), t1 (ref), leave (copy)
    if p27 == "Notice" and typeof(p28) == "string" then
        v1:Toast(p28, 3.5)

        return
    end

    if p27 == "Exit" and typeof(p28) == "CFrame" then
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            if Humanoid.SeatPart then
                local SeatWeld = Humanoid.SeatPart:FindFirstChild("SeatWeld")

                if SeatWeld then
                    SeatWeld:Destroy()
                end
            end

            Humanoid.Sit = false
        end

        if t1 then
            leave()
        end

        if Character then
            Character:PivotTo(p28)

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart then
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)
RunService.PreSimulation:Connect(function(p29) -- line: 351
    -- upvalues: Config (copy), CarPhysics (copy), State (copy), LocalPlayer (copy), v1 (copy), KeyCode (copy), t1 (ref), t3 (copy), t4 (copy), n1 (ref), n2 (ref), n3 (ref), n4 (ref), leave (copy)
    local t14 = t1

    if t14 and t14.role == "Driver" and t14.phys then
        if not (t14.car.Parent and t14.chassis.Parent) then
            leave()
        elseif t14.car:GetAttribute("SimOwner") == LocalPlayer.UserId then
            local touch = v1.touch
            local v67 = math.max(if t3[KeyCode.W] or t3[KeyCode.Up] then 1 else 0, touch.gas)
            local v69 = math.max(if t3[KeyCode.S] or t3[KeyCode.Down] then 1 else 0, touch.brake)
            local v70 = n2
            local v71 = p29 * (if n2 < v67 then 4 else 10)

            n2 = if v70 < v67 then math.min(v70 + v71, v67) else math.max(v70 - v71, v67)

            local v74 = n3
            local v75 = p29 * (if n3 < v69 then 8 else 12)

            n3 = if v74 < v69 then math.min(v74 + v75, v69) else math.max(v74 - v75, v69)

            local v78 = n2
            local v79 = math.max(v78, t4.throttle)
            local v80 = n3
            local v81 = math.max(v80, t4.brake)
            local v82 = (if not t3[KeyCode.D] and not t3[KeyCode.Right] and not touch.right then 0 else 1) - (if not t3[KeyCode.A] and not t3[KeyCode.Left] and not touch.left then 0 else 1)

            if math.abs(t4.steer) > 0.01 then
                n1 += (t4.steer - n1) * math.min(1, p29 * Config.PadSteerResponse)
            elseif v82 == 0 then
                local v86 = n1
                local v87 = Config.KeyReturnRate * p29

                n1 = if v86 < 0 then math.min(v86 + v87, 0) else math.max(v86 - v87, 0)
            else
                local v90 = n1 * v82 < 0 and Config.KeySteerRate + Config.KeyReturnRate or Config.KeySteerRate
                local v91 = n1
                local v92 = v90 * p29

                n1 = if v91 < v82 then math.min(v91 + v92, v82) else math.max(v91 - v92, v82)
            end

            local v95 = t3[KeyCode.LeftShift]

            if not v95 then
                v95 = t3[KeyCode.RightShift]
                v95 = v95 or t3[KeyCode.ButtonA] or touch.handbrake
            end

            CarPhysics.Step(t14.phys, p29, {
                up = v79,
                down = v81,
                steer = n1,
                handbrake = v95 == true
            })

            local elapsed = os.clock()

            if n4 <= elapsed then
                n4 = elapsed + 1 / Config.TelemetryRate

                local phys = t14.phys

                State:FireServer(t14.car, phys.steer, phys.gear, math.floor(phys.rpm), phys.throttle, phys.brake > 0.05 or phys.handbrake, CarPhysics.WheelMask(phys))
            end
        end
    end
end)

local v98 = RaycastParams.new()

v98.FilterType = Enum.RaycastFilterType.Exclude
v98.RespectCanCollide = true

local function lobbyBusy() -- line: 387
    -- upvalues: PlayerGui (copy)
    local JerezRaceHUD = PlayerGui:FindFirstChild("JerezRaceHUD")

    if JerezRaceHUD then
        for _, v99 in { "Freecam", "LobbySpectating", "BikesPreviewOpen", "ResultsShowing", "SpectatingUserId" } do
            local Attribute = JerezRaceHUD:GetAttribute(v99)

            if Attribute ~= nil and Attribute ~= false then
                return true
            end
        end
    end

    return false
end

local v100

local function v101() -- line: 399
    -- upvalues: ReplicatedStorage (copy), v100 (ref)
    v100 = require(ReplicatedStorage:WaitForChild("MotoLegends", 10):WaitForChild("SettingsBridge", 10))
end

pcall(v101)

local n5 = 0

local function offroadLevel(p30) -- line: 401
    if p30.phys then
        local n6 = 0

        for _, v102 in p30.phys.list do
            if v102.contact then
                if v102.surface == "Gravel" or v102.surface == "Sand" then
                    n6 = 1
                elseif v102.surface == "Grass" then
                    n6 = math.max(n6, 0.5)
                end
            end
        end

        return n6
    end

    if (p30.car:GetAttribute("Wheels") or 0) >= 16 then
        return 1
    end

    return 0
end

local function cameraShakeOn() -- line: 418
    -- upvalues: v100 (ref)
    if v100 and v100.ready and v100.get then
        local get = v100.get
        local camShake, camShake2 = pcall(get, "camShake")

        return not (camShake and camShake2 == false)
    end

    return true
end

local function updateCamera(p31) -- line: 424
    -- upvalues: Config (copy), LocalPlayer (copy), StudMetres (copy), t1 (ref), t2 (copy), t4 (copy), v2 (ref), t6 (copy), t7 (copy), setHeadHidden (copy), v98 (copy), lobbyBusy (copy), v100 (ref), n5 (ref), offroadLevel (copy)
    local t15 = t1

    if not (t15 and t15.chassis.Parent) then
        return
    end

    local CurrentCamera = workspace.CurrentCamera
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if CurrentCamera.CameraType == Enum.CameraType.Custom and (not Humanoid or CurrentCamera.CameraSubject == Humanoid) and not lobbyBusy() then
        local v103 = math.min(p31, 0.1)
        local elapsed = os.clock()
        local v104 = t15.chassis.CFrame * CFrame.new(-Config.ChassisCentre)
        local v105 = Config.Cameras[t2.camera] or Config.Cameras[1]
        local v106 = t15.chassis.AssemblyLinearVelocity.Magnitude * StudMetres * 3.6

        if math.abs(t4.camX) > 0.08 or math.abs(t4.camY) > 0.08 then
            t6.orbitYaw -= t4.camX * v103 * 2.2
            t6.orbitPitch = math.clamp(t6.orbitPitch - t4.camY * v103 * 1.2, -0.35, 0.9)
        elseif not t6.dragging then
            t6.orbitYaw = (t6.orbitYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

            local v110 = 1 - math.exp(-v103 * 3.5)

            t6.orbitYaw += -t6.orbitYaw * v110
            t6.orbitPitch += -t6.orbitPitch * v110

            if math.abs(t6.orbitYaw) < 0.001 then
                t6.orbitYaw = 0
            end

            if math.abs(t6.orbitPitch) < 0.001 then
                t6.orbitPitch = 0
            end
        end

        local v111 = if v2 then 3.141592653589793 else 0

        if v105.distance then
            for v112 in t7 do
                if v112.Parent then
                    v112.LocalTransparencyModifier = 0
                end
            end

            table.clear(t7)

            local LookVector = v104.LookVector
            local v113 = Vector3.new(LookVector.X, 0, LookVector.Z)
            local v117 = (if v113.Magnitude > 0.05 then math.atan2(-v113.X, -v113.Z) or t6.yaw or 0 else t6.yaw or 0) + t6.orbitYaw + v111
            local v118 = t6.yaw == nil

            if not v118 then
                v118 = v2 ~= t6.wasBack
            end

            if v118 then
                t6.yaw = v117
            else
                local yaw = t6.yaw
                local v121 = 1 - math.exp(-v103 * 9)

                t6.yaw = yaw + ((v117 - yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v121
            end

            t6.wasBack = v2

            local v124 = Vector3.new(-math.sin(t6.yaw), 0, -math.cos(t6.yaw))
            local Position = v104.Position

            t6.focusY = if t6.focusY then t6.focusY + (Position.Y - t6.focusY) * (1 - math.exp(-v103 * 10)) or Position.Y else Position.Y

            local v129 = Vector3.new(Position.X, t6.focusY + v105.look, Position.Z)
            local v131 = math.clamp(v106 / Config.SpeedFOVKph, 0, 1)
            local v132 = v105.distance * t6.zoom * (v131 * 0.1 + 1)
            local v133 = v105.height * t6.zoom + t6.orbitPitch * v132 * 0.6
            local v134 = v129 - v124 * v132 + Vector3.new(0, 1, 0) * (v133 - v105.look)

            v98.FilterDescendantsInstances = {
                t15.car,
                LocalPlayer.Character
            }

            local v135 = workspace:Raycast(v129, v134 - v129, v98)

            if v135 then
                v134 = v135.Position + (v129 - v134).Unit * 0.8
            end

            CurrentCamera.CFrame = CFrame.lookAt(v134, v129 + v124 * 10 - Vector3.new(0, 1.2, 0))
            CurrentCamera.Focus = CFrame.new(v129)
            CurrentCamera.FieldOfView = v105.fov + Config.SpeedFOV * v131 * v131
        else
            local v136 = v104:PointToWorldSpace(v105.offset or t15.role == "Driver" and Config.DriverEye or Config.PassengerEye)
            local Rotation = v104.Rotation
            local rot = t6.rot
            local v137 = if rot then t6.rot:Lerp(Rotation, 1 - math.exp(-v103 * 22)) else nil

            t6.rot = if rot and v137 then v137 else Rotation

            local v139 = t15.phys and -t15.phys.steer * 0.35 or 0
            local v140 = t6.rot * CFrame.Angles(0, v111 + t6.orbitYaw + v139, 0) * CFrame.Angles(-t6.orbitPitch * 0.6, 0, 0)

            CurrentCamera.CFrame = CFrame.new(v136) * v140
            CurrentCamera.Focus = CFrame.new(v136 + v140.LookVector * 4)
            CurrentCamera.FieldOfView = v105.fov
            setHeadHidden(v105.name == "Cockpit")
        end

        local v141 = true

        if v100 and v100.ready and v100.get then
            local get = v100.get
            local camShake, camShake2 = pcall(get, "camShake")

            v141 = not (camShake and camShake2 == false)
        end

        local v142 = v141 and offroadLevel(t15) * math.clamp(v106 / 90, 0.2, 1) or 0

        n5 += (v142 - n5) * math.min(1, v103 * 10)

        if n5 > 0.01 then
            local v148 = elapsed * 30
            local v151 = Vector3.new(math.noise(v148, 1.3) * 0.1, math.noise(v148, 7.1) * 0.14, 0) * n5

            CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(v151) * CFrame.Angles(0, 0, math.noise(v148, 4.7) * 0.008726646259971648 * n5)
        end
    else
        for v152 in t7 do
            if v152.Parent then
                v152.LocalTransparencyModifier = 0
            end
        end

        table.clear(t7)
    end
end

RunService:BindToRenderStep("SafetyCarCamera", Enum.RenderPriority.Camera.Value + 3, updateCamera)
UserInputService.InputBegan:Connect(function(p32, p33) -- line: 500
    -- upvalues: UserInputService (copy), t1 (ref), t6 (copy)
    if not t1 or p33 or p32.UserInputType ~= Enum.UserInputType.MouseButton2 then
        return
    end

    t6.dragging = true
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
    UserInputService.MouseIconEnabled = false
end)
UserInputService.InputEnded:Connect(function(p34) -- line: 508
    -- upvalues: UserInputService (copy), t6 (copy)
    if p34.UserInputType ~= Enum.UserInputType.MouseButton2 or not t6.dragging then
        return
    end

    t6.dragging = false
    t6.lastOrbit = os.clock()
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
end)
UserInputService.InputChanged:Connect(function(p35, p36) -- line: 516
    -- upvalues: t1 (ref), t6 (copy)
    if t1 then
        if p35.UserInputType ~= Enum.UserInputType.MouseMovement or not t6.dragging then
            if p35.UserInputType == Enum.UserInputType.MouseWheel and not p36 then
                t6.zoom = math.clamp(t6.zoom - p35.Position.Z * 0.08, 0.7, 1.7)
            end
        else
            t6.orbitYaw -= p35.Delta.X * 0.006
            t6.orbitPitch = math.clamp(t6.orbitPitch + p35.Delta.Y * 0.004, -0.35, 0.9)
            t6.lastOrbit = os.clock()
        end
    end
end)
UserInputService.WindowFocusReleased:Connect(function() -- line: 526
    -- upvalues: Action (copy), t3 (copy), t4 (copy), n1 (ref), n2 (ref), n3 (ref), v2 (ref), v3 (ref)
    table.clear(t3)
    t4.throttle = 0
    t4.brake = 0
    t4.steer = 0
    t4.camX = 0
    t4.camY = 0
    n1 = 0
    n2 = 0
    n3 = 0
    v2 = false

    if v3 ~= false then
        v3 = false
        Action:FireServer("Horn", false)
    end
end)
RunService.RenderStepped:Connect(function(p37) -- line: 532
    -- upvalues: Config (copy), CarVisuals (copy), v1 (copy), StudMetres (copy), t1 (ref), hideLobby (copy)
    local v155 = math.min(p37, 0.1)
    local CFramePosition = workspace.CurrentCamera.CFrame.Position

    for v156, v157 in CarVisuals.Records() do
        local v158 = t1 and t1.car == v156 and t1.phys or nil

        CarVisuals.UpdateCar(v157, v155, v158, CFramePosition)
    end

    CarVisuals.Tick()
    v1:UpdateToast()

    local t16 = t1

    if not t16 then
        return
    end

    hideLobby(true)

    local car = t16.car
    local t17

    if t16.phys then
        local phys = t16.phys

        t17 = {
            kph = phys.kph,
            rpm = phys.rpm,
            gear = phys.gear,
            transmission = phys.transmission,
            throttle = phys.throttle,
            brake = phys.brake,
            handbrake = phys.handbrake,
            esc = phys.esc,
            escActive = phys.escActive,
            tcsActive = phys.tcsActive,
            absActive = phys.absActive,
            lights = car:GetAttribute("LightBar") == true,
            pitLimiter = phys.inPit == true
        }
    else
        t17 = {
            handbrake = false,
            kph = t16.chassis.AssemblyLinearVelocity.Magnitude * StudMetres * 3.6
        }
        t17.rpm = car:GetAttribute("RPM") or Config.IdleRPM
        t17.gear = car:GetAttribute("Gear") or 1
        t17.transmission = car:GetAttribute("Transmission")
        t17.throttle = car:GetAttribute("Throttle") or 0
        t17.brake = car:GetAttribute("Brake") and 1 or 0
        t17.lights = car:GetAttribute("LightBar") == true
    end

    v1:Update(v155, t17)
end)

local AIPath = require(SafetyCar:WaitForChild("AIPath"))
local t18 = {}
local v159 = RaycastParams.new()

v159.FilterType = Enum.RaycastFilterType.Include
v159.RespectCanCollide = true

local MotoLegends = ReplicatedStorage:FindFirstChild("MotoLegends")

local function Heartbeat() -- line: 576
    -- upvalues: MotoLegends (copy)
    return require(MotoLegends:FindFirstChild("Config")).Track
end

local ok

ok, Heartbeat = pcall(Heartbeat)

local v160, v161

if ok and typeof(Heartbeat) == "string" then
    local v162 = workspace:FindFirstChild(Heartbeat)

    if v162 then
        v160 = v162
        v161 = true
    else
        v161 = false
    end
else
    v161 = false
end

if not v161 then
    v160 = nil
end

v159.FilterDescendantsInstances = v160 and {
    v160,
    workspace.Terrain
} or { workspace.Terrain }

local function gearFor(p38) -- line: 580
    -- upvalues: Config (copy)
    local v164 = #Config.Gears

    for v165, v166 in Config.Gears do
        local v167 = p38 / 0.35 * 60 / 6.283185307179586 * v166 * Config.FinalDrive

        if v167 < 6400 or v165 == v164 then
            return v165, (math.clamp(v167, Config.IdleRPM, Config.RedlineRPM))
        end
    end

    return 1, Config.IdleRPM
end

local function track2(p39) -- line: 588
    -- upvalues: AIPath (copy), t18 (copy)
    local v168, v169

    if t18[p39] then
        v169 = true
    elseif p39:GetAttribute("AI") == true then
        v168 = p39.PrimaryPart or p39:WaitForChild("Chassis", 10)
        v169 = false
    else
        v169 = true
    end

    if v169 then
        return
    end

    local AIGround = p39:GetAttribute("AIGround")

    if v168 and typeof(AIGround) == "CFrame" and p39.Parent then
        local v170 = AIPath.Build(AIGround)

        if v170 then
            t18[p39] = {
                nextMove = 0,
                nextAttr = 0,
                chassis = v168,
                path = v170,
                y = AIGround.Position.Y,
                dir = AIGround.LookVector
            }
        end
    end
end

SafetyCars.ChildAdded:Connect(function(p40) -- line: 597
    -- upvalues: track2 (copy)
    task.spawn(track2, p40)
end)

for _, child in SafetyCars:GetChildren() do
    task.spawn(track2, child)
end

RunService.Heartbeat:Connect(function() -- line: 599
    -- upvalues: Config (copy), StudMetres (copy), AIPath (copy), t18 (copy), v159 (copy), gearFor (copy)
    if next(t18) == nil then
        return
    end

    local ServerTimeNow = workspace:GetServerTimeNow()
    local elapsed = os.clock()
    local CFramePosition = workspace.CurrentCamera.CFrame.Position

    for v171, v172 in t18 do
        local chassis = v172.chassis

        if v171.Parent and chassis.Parent then
            local AIGo = v171:GetAttribute("AIGo")

            if typeof(AIGo) == "number" and not (ServerTimeNow < AIGo) then
                if (chassis.Position - CFramePosition).Magnitude < 700 then
                    v172.nextMove = elapsed + 0.1

                    local path = v172.path
                    local v173, v174, v175 = AIPath.Sample(path, ServerTimeNow - AIGo)
                    local v176 = AIPath.PointAt(path, v173)
                    local v177 = AIPath.PointAt(path, v173 + 8) - AIPath.PointAt(path, v173 - 8)

                    if v177.Magnitude > 0.01 then
                        v172.dir = v177.Unit
                    end

                    local v179 = workspace:Raycast(Vector3.new(v176.X, v172.y + 6, v176.Z), Vector3.new(0, -30, 0), v159)

                    if v179 then
                        v172.y = v179.Position.Y
                    end

                    local v180 = Vector3.new(v176.X, v172.y, v176.Z)

                    chassis.CFrame = CFrame.lookAt(v180, v180 + v172.dir) * CFrame.new(Config.ChassisCentre)
                    chassis.AssemblyLinearVelocity = v172.dir * v174

                    if v172.nextAttr <= elapsed then
                        v172.nextAttr = elapsed + 0.1

                        local v181 = AIPath.PointAt(path, v173 + 18) - AIPath.PointAt(path, v173 + 2)
                        local v182 = 0

                        if v181.Magnitude > 0.01 then
                            local Unit = v181.Unit

                            v182 = math.atan2(v172.dir:Cross(Unit).Y, (v172.dir:Dot(Unit)))
                        end

                        local v184, v185 = gearFor(v174 * StudMetres)

                        v171:SetAttribute("Steer", (math.clamp(-math.atan(v182 * 0.66), -0.6, 0.6)))
                        v171:SetAttribute("Gear", v184)
                        v171:SetAttribute("RPM", (math.floor(v185)))
                        v171:SetAttribute("Throttle", if v175 > 1 then 1 elseif v175 < -1 then 0 else 0.35)
                        v171:SetAttribute("Brake", v175 < -5)
                    end
                elseif not (elapsed < v172.nextMove) then
                    v172.nextMove = elapsed + 0.1

                    local path = v172.path
                    local v188, v189, v190 = AIPath.Sample(path, ServerTimeNow - AIGo)
                    local v191 = AIPath.PointAt(path, v188)
                    local v192 = AIPath.PointAt(path, v188 + 8) - AIPath.PointAt(path, v188 - 8)

                    if v192.Magnitude > 0.01 then
                        v172.dir = v192.Unit
                    end

                    local v193 = Vector3.new(v191.X, v172.y, v191.Z)

                    chassis.CFrame = CFrame.lookAt(v193, v193 + v172.dir) * CFrame.new(Config.ChassisCentre)
                    chassis.AssemblyLinearVelocity = v172.dir * v189

                    if v172.nextAttr <= elapsed then
                        v172.nextAttr = elapsed + 0.1

                        local v194 = AIPath.PointAt(path, v188 + 18) - AIPath.PointAt(path, v188 + 2)
                        local v195 = 0

                        if v194.Magnitude > 0.01 then
                            local Unit = v194.Unit

                            v195 = math.atan2(v172.dir:Cross(Unit).Y, (v172.dir:Dot(Unit)))
                        end

                        local v197, v198 = gearFor(v189 * StudMetres)

                        v171:SetAttribute("Steer", (math.clamp(-math.atan(v195 * 0.66), -0.6, 0.6)))
                        v171:SetAttribute("Gear", v197)
                        v171:SetAttribute("RPM", (math.floor(v198)))
                        v171:SetAttribute("Throttle", if v190 > 1 then 1 elseif v190 < -1 then 0 else 0.35)
                        v171:SetAttribute("Brake", v190 < -5)
                    end
                end
            end
        else
            t18[v171] = nil
        end
    end
end)
task.spawn(function() -- line: 651
    -- upvalues: Action (copy), SafetyCars (copy), LocalPlayer (copy), PlayerGui (copy)
    local v201 = PlayerGui:WaitForChild("RaceLobbyHUD", 120)
    local v202

    if v201 then
        v202 = v201:WaitForChild("BikeSelection", 60)
        v201 = v201:WaitForChild("BikeSelectionStage", 60)
    else
        v202 = v201
    end

    local v203 = v201 and v201:WaitForChild("ReferenceCanvas", 60)
    local v204 = v203 and v203:WaitForChild("Controls", 60)

    if v202 and v204 then
        local TweenService = game:GetService("TweenService")
        local v205 = Color3.fromRGB(231, 0, 0)
        local v206 = Color3.new(0, 0, 0)
        local v207 = Color3.new(1, 1, 1)
        local TextButton = Instance.new("TextButton")

        TextButton.Name = "SafetyCarButton"
        TextButton.AutoButtonColor = false
        TextButton.BorderSizePixel = 0
        TextButton.BackgroundColor3 = v206
        TextButton.TextColor3 = v207
        TextButton.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy)
        TextButton.TextSize = 24
        TextButton.Position = UDim2.fromOffset(127, 990)
        TextButton.Size = UDim2.fromOffset(300, 45)
        TextButton.ZIndex = 44
        TextButton.Visible = false
        TextButton:SetAttribute("NoHover", true)
        TextButton:SetAttribute("DarkStyle", true)

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = TextButton

        local UIStroke = Instance.new("UIStroke")

        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Color = v207
        UIStroke.Thickness = 2
        UIStroke.Parent = TextButton

        local UIScale = Instance.new("UIScale")

        UIScale.Parent = TextButton
        TextButton.Parent = v204

        local function tween(p41, p42, p43, p44) -- line: 685
            -- upvalues: TweenService (copy)
            TweenService:Create(p41, TweenInfo.new(p43, p44 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p42):Play()
        end

        local function hover(p45) -- line: 688
            -- upvalues: TweenService (copy), v205 (copy), v206 (copy), TextButton (copy)
            local t19 = {
                BackgroundColor3 = p45 and v205 or v206
            }

            TweenService:Create(TextButton, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t19):Play()
        end

        TextButton.MouseEnter:Connect(function() -- line: 689
            -- upvalues: TweenService (copy), v205 (copy), v206 (copy), TextButton (copy)
            local t20 = {
                BackgroundColor3 = v205 or v206
            }

            TweenService:Create(TextButton, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t20):Play()
        end)
        TextButton.MouseLeave:Connect(function() -- line: 690
            -- upvalues: TweenService (copy), v206 (copy), TextButton (copy), UIScale (copy)
            local t21 = {
                BackgroundColor3 = v206
            }

            TweenService:Create(TextButton, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t21):Play()

            local t22 = {
                Scale = 1
            }

            TweenService:Create(UIScale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t22):Play()
        end)
        TextButton.SelectionGained:Connect(function() -- line: 691
            -- upvalues: TweenService (copy), v205 (copy), v206 (copy), TextButton (copy)
            local t23 = {
                BackgroundColor3 = v205 or v206
            }

            TweenService:Create(TextButton, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t23):Play()
        end)
        TextButton.SelectionLost:Connect(function() -- line: 692
            -- upvalues: TweenService (copy), v206 (copy), TextButton (copy)
            local t24 = {
                BackgroundColor3 = v206
            }

            TweenService:Create(TextButton, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t24):Play()
        end)
        TextButton.MouseButton1Down:Connect(function() -- line: 693
            -- upvalues: TweenService (copy), UIScale (copy)
            local t25 = {
                Scale = 0.95
            }

            TweenService:Create(UIScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t25):Play()
        end)
        TextButton.MouseButton1Up:Connect(function() -- line: 694
            -- upvalues: TweenService (copy), UIScale (copy)
            local t26 = {
                Scale = 1
            }
            local Back = Enum.EasingStyle.Back

            TweenService:Create(UIScale, TweenInfo.new(0.16, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t26):Play()
        end)

        local function myCar() -- line: 696
            -- upvalues: SafetyCars (copy), LocalPlayer (copy)
            for _, child in SafetyCars:GetChildren() do
                if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                    return child
                end
            end

            return nil
        end

        local v208 = false

        local function refresh() -- line: 703
            -- upvalues: TextButton (copy), myCar (copy), LocalPlayer (copy)
            TextButton.Visible = LocalPlayer:GetAttribute("SafetyCarAccess") == true
            TextButton.Text = myCar() and "REMOVE SAFETY CAR" or "SPAWN SAFETY CAR"
        end

        SafetyCars.ChildAdded:Connect(refresh)
        SafetyCars.ChildRemoved:Connect(refresh)
        LocalPlayer:GetAttributeChangedSignal("SafetyCarAccess"):Connect(refresh)
        TextButton.Visible = LocalPlayer:GetAttribute("SafetyCarAccess") == true
        TextButton.Text = myCar() and "REMOVE SAFETY CAR" or "SPAWN SAFETY CAR"
        TextButton.Activated:Connect(function() -- line: 711
            -- upvalues: TextButton (copy), myCar (copy), v208 (ref), v202 (ref), Action (copy), LocalPlayer (copy)
            if v208 then
                return
            end

            v208 = true

            if myCar() then
                Action:FireServer("MenuRemove", nil)
            else
                v202.Visible = false

                local elapsed = os.clock()

                repeat
                    task.wait(0.05)

                    local v210 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                until v210 and not v210.Anchored or os.clock() - elapsed > 2

                Action:FireServer("MenuSpawn", nil)
            end

            task.wait(1)
            v208 = false
            TextButton.Visible = LocalPlayer:GetAttribute("SafetyCarAccess") == true
            TextButton.Text = myCar() and "REMOVE SAFETY CAR" or "SPAWN SAFETY CAR"
        end)
    end
end)
