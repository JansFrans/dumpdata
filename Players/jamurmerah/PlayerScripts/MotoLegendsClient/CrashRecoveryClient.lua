-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local Config = require(MotoLegends:WaitForChild("Config"))
local CrashRecovered = MotoLegends:WaitForChild("CrashRecovered")
local LocalPlayer = Players.LocalPlayer
local v1 = (Config.CrashRecoverySeconds or 3) + 3.5
local v2
local n1 = (-1e999)

local function clear() -- line: 17
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return
    end

    if Character:GetAttribute("RaceCrashActive") == true then
        Character:SetAttribute("RaceCrashActive", false)
    end

    Humanoid.PlatformStand = false
    Humanoid.AutoRotate = true
    Humanoid.EvaluateStateMachine = true

    for _, descendant in Character:GetDescendants() do
        if descendant:IsA("Motor6D") then
            descendant.Transform = CFrame.identity
        end
    end

    local Animate = Character:FindFirstChild("Animate")

    if Animate then
        Animate.Enabled = true
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart then
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end

    Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

CrashRecovered.OnClientEvent:Connect(function() -- line: 28
    -- upvalues: v2 (ref), clear (copy)
    clear()
    task.delay(0.15, clear)
    v2 = nil
end)
RunService.Heartbeat:Connect(function() -- line: 34
    -- upvalues: CrashRecovered (copy), LocalPlayer (copy), v1 (copy), v2 (ref), n1 (ref)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v3 = Humanoid and Humanoid.SeatPart
    local v4 = v3 ~= nil and v3.Name == "RiderSeat"
    local v5

    if Humanoid ~= nil then
        if Humanoid.Health > 0 then
            v5 = not v4

            if v5 then
                v5 = Character:GetAttribute("RaceCrashActive") == true or Humanoid.PlatformStand
            end
        else
            v5 = false
        end
    else
        v5 = false
    end

    if not v5 then
        v2 = nil

        return
    end

    local elapsed = os.clock()

    v2 = v2 or elapsed

    if elapsed - v2 > v1 and elapsed - n1 > 3 then
        n1 = elapsed
        CrashRecovered:FireServer()
    end
end)
