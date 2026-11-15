-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer
local JerezRaceHUD = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("JerezRaceHUD")
local v1 = false

local function inSafetyCar() -- line: 14
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local v2 = Humanoid and Humanoid.SeatPart
    local v3 = v2 and v2.Parent

    return v3 ~= nil and v3:IsA("Model") and v3:GetAttribute("SafetyCar") == true
end

RunService.Heartbeat:Connect(function() -- line: 19
    -- upvalues: ProximityPromptService (copy), LocalPlayer (copy), JerezRaceHUD (copy), v1 (ref)
    if JerezRaceHUD:GetAttribute("LobbySpectating") == true then
        if not v1 then
            v1 = true
            JerezRaceHUD:SetAttribute("SpectatePromptsBlocked", true)
        end

        if ProximityPromptService.Enabled then
            ProximityPromptService.Enabled = false
        end
    else
        local v4 = false
        local v5 = false
        local v6 = false
        local v7 = false
        local v8 = false

        if v1 then
            v4 = true
        else
            v8 = true
        end

        if v4 then
            v1 = false

            if JerezRaceHUD:GetAttribute("Freecam") == true then
                v8 = false
            else
                v5 = true
            end
        end

        v4 = false

        local Character, v9

        if v5 then
            Character = LocalPlayer.Character

            if Character then
                v4 = true
            else
                v9 = Character
                v6 = true
            end
        end

        v5 = false

        if v4 then
            v9 = Character:FindFirstChildOfClass("Humanoid")
            v6 = true
        end

        v4 = false

        local v10

        if v6 then
            if v9 then
                v4 = true
            else
                v10 = v9
                v5 = true
            end
        end

        v6 = false

        if v4 then
            v10 = v9.SeatPart
            v5 = true
        end

        v4 = false

        local v11

        if v5 then
            if v10 then
                v4 = true
            else
                v11 = v10
                v6 = true
            end
        end

        v5 = false

        if v4 then
            v11 = v10.Parent
            v6 = true
        end

        v4 = false

        local v12

        if v6 then
            if v11 ~= nil then
                v4 = true
            else
                v12 = false
                v5 = true
            end
        end

        v6 = false

        if v4 then
            local Model = v11:IsA("Model")

            if Model then
                v6 = true
            else
                v12 = Model
                v5 = true
            end
        end

        v4 = false

        if v6 then
            if v11:GetAttribute("SafetyCar") == true then
                v7 = true
            else
                v4 = true
            end
        end

        if v4 then
            v12 = false
            v5 = true
        end

        if v7 then
            v12 = true
            v5 = true
        end

        v7 = false

        if v5 then
            if v12 then
                v8 = false
            else
                v7 = true
            end
        end

        if v7 then
            v8 = false
            ProximityPromptService.Enabled = true
        end

        if not v8 then
            JerezRaceHUD:SetAttribute("SpectatePromptsBlocked", nil)
        end
    end
end)
