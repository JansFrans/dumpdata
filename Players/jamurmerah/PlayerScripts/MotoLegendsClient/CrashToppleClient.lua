-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CrashTopple = require(game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends"):WaitForChild("CrashTopple"))
local LocalPlayer = Players.LocalPlayer

RunService.PreSimulation:Connect(function(p1) -- line: 6
    -- upvalues: CrashTopple (copy), LocalPlayer (copy)
    for _, v1 in CrashTopple.Folders() do
        for _, child in v1:GetChildren() do
            if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId and (child:GetAttribute("Crash") or "") ~= "" then
                CrashTopple.Step(child, p1)
            end
        end
    end
end)
