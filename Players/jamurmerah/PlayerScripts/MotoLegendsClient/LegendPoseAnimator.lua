-- https://lua.expert

local RunService = game:GetService("RunService")
local LegendRig = require(game:GetService("ReplicatedStorage"):WaitForChild("MotoLegends"):WaitForChild("LegendRig"))
local t1 = {
    "TimePlayedLeaderboard",
    "PointsLeaderboard",
    "WeeklyLapLeaderboard"
}
local t2 = {}

local function scan() -- line: 8
    -- upvalues: t1 (copy), t2 (copy)
    table.clear(t2)

    for _, v1 in t1 do
        local v2 = workspace:FindFirstChild(v1)

        if v2 then
            for _, descendant in v2:GetDescendants() do
                if descendant.Name == "Rig" and descendant:IsA("Model") and (descendant:GetAttribute("LegendId") or "") ~= "" then
                    table.insert(t2, descendant)
                end
            end
        end
    end
end

task.spawn(function() -- line: 17
    -- upvalues: scan (copy)
    while true do
        scan()
        task.wait(2)
    end
end)

local elapsed = os.clock()

RunService.RenderStepped:Connect(function() -- line: 19
    -- upvalues: LegendRig (copy), t2 (copy), elapsed (copy)
    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        local v3 = os.clock() - elapsed

        for _, v4 in t2 do
            local v5 = v4.Parent and v4:GetAttribute("LegendId")
            local v6 = v4.PrimaryPart or v4:FindFirstChild("HumanoidRootPart")

            if v5 and v5 ~= "" and v6 and (v6.Position - CurrentCamera.CFrame.Position).Magnitude < 220 then
                LegendRig.PoseAvatar(v4, v5, v3)
            end
        end
    end
end)
