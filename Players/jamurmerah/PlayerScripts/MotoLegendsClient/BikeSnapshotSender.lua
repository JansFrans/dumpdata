-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local BikeSnapshot = MotoLegends:WaitForChild("BikeSnapshot")
local SpectateSmoother = require(MotoLegends:WaitForChild("SpectateSmoother"))
local BikeSnapshotCodec = require(MotoLegends:WaitForChild("BikeSnapshotCodec"))

require(MotoLegends:WaitForChild("RemoteBikes"))

local LocalPlayer = Players.LocalPlayer
local v1 = 1 / SpectateSmoother.Settings.SendRate
local n1 = 0
local n2 = 0

local function myBikeRoot() -- line: 18
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v2 = Humanoid and Humanoid.SeatPart

    if v2 and v2.Name == "RiderSeat" then
        local Parent = v2.Parent

        if Parent and Parent:GetAttribute("OwnerUserId") == LocalPlayer.UserId and Parent:GetAttribute("Crash") == "" then
            return Parent.PrimaryPart
        end
    end

    return nil
end

RunService.PostSimulation:Connect(function(p1) -- line: 27
    -- upvalues: Players (copy), BikeSnapshot (copy), BikeSnapshotCodec (copy), v1 (copy), n1 (ref), n2 (ref), myBikeRoot (copy)
    n2 += p1

    if #Players:GetPlayers() < 2 then
        n1 = 0
    else
        n1 += p1

        if not (n1 < v1) then
            n1 = math.min(n1 - v1, v1)

            local v4 = myBikeRoot()

            if v4 then
                BikeSnapshot:FireServer(BikeSnapshotCodec.Encode(n2, v4.CFrame, v4.AssemblyLinearVelocity, v4.AssemblyAngularVelocity))
            end
        end
    end
end)
