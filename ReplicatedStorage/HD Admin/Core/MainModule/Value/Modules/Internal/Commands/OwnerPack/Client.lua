-- https://lua.expert

local LocalPlayer = game:GetService("Players").LocalPlayer
local Modules = script:FindFirstAncestor("HD Admin").Core.MainModule.Value.Modules
local CommandAPI = require(script:FindFirstAncestor("HD Admin").Core.CommandAPI)

require(Modules.Objects.Remote).get("ControlAction"):onClientEvent(function(p1, p2) -- line: 18
    -- upvalues: LocalPlayer (copy), CommandAPI (copy)
    if p1 == "BecomeControlled" then
        local PlayerScripts = LocalPlayer.PlayerScripts

        if not PlayerScripts then
            return
        end

        local v1 = PlayerScripts:WaitForChild("PlayerModule", 3)

        if not v1 then
            return
        end

        local v2 = require(v1)
        local v3 = v2 and v2:GetControls()
        local Character = LocalPlayer.Character
        local Animate = Character and Character:FindFirstChild("Animate")

        if v3 and Animate and Animate:IsA("LocalScript") then
            if p2 then
                Animate.Enabled = false
                v3:Disable()
            else
                v3:Enable()
                Animate.Enabled = true
            end
        end
    elseif p1 == "ViewPlayer" then
        CommandAPI.setCameraSubject(p2)
    elseif p1 == "SetResetButtonCallbackEnabled" then
        local StarterGui = game:GetService("StarterGui")
        local RunService = game:GetService("RunService")

        for _ = 1, 100 do
            local SetCore = StarterGui.SetCore

            if pcall(SetCore, StarterGui, "ResetButtonCallback", p2) then
                break
            end

            RunService.Heartbeat:Wait()
        end
    end
end)

return {
    {
        name = "Control",
        run = function(_) -- run | line: 72
        end
    }
}
