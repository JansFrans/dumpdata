-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MotoLegends = game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends")
local ChampionshipEvent = MotoLegends:WaitForChild("ChampionshipEvent")
local LocalPlayer = Players.LocalPlayer

local function myRoot() -- line: 13
    -- upvalues: LocalPlayer (copy)
    local RaceBikes = workspace:FindFirstChild("RaceBikes")

    if RaceBikes then
        for _, child in RaceBikes:GetChildren() do
            if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                return child.PrimaryPart
            end
        end
    end

    return nil
end

local CFrame, v1
local v2 = false

RunService.Heartbeat:Connect(function() -- line: 23
    -- upvalues: MotoLegends (copy), ChampionshipEvent (copy), LocalPlayer (copy), myRoot (copy), CFrame (ref), v1 (ref), v2 (ref)
    local SessionPhase = MotoLegends:GetAttribute("SessionPhase")

    if LocalPlayer:GetAttribute("RaceParticipant") ~= true then
        CFrame = nil
        v1 = nil

        return
    end

    if SessionPhase == "Grid" then
        v2 = false

        local v3 = myRoot()

        if not v3 or LocalPlayer:GetAttribute("RaceGridLocked") ~= true then
            CFrame = nil
            v1 = nil
        else
            CFrame = v3.CFrame
            v1 = v3
        end
    elseif SessionPhase == "Lights" and not v2 and CFrame and not ((MotoLegends:GetAttribute("StartRedLights") or 0) <= 0) then
        local v4 = myRoot()

        if v4 and v4 == v1 and (v4.Position - CFrame.Position):Dot(CFrame.LookVector) > 1.2 then
            v2 = true
            ChampionshipEvent:FireServer("JumpStart")
        end
    end
end)
