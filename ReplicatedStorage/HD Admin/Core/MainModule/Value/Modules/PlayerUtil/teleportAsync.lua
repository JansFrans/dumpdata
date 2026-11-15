-- https://lua.expert

local RunService = game:GetService("RunService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules

local function unseatPlayer(p1) -- line: 5
    -- upvalues: Modules (copy)
    local v1 = require(Modules.PlayerUtil.getHumanoid)(p1)

    if v1 then
        local SeatPart = v1.SeatPart

        if SeatPart then
            local SeatWeld = SeatPart:FindFirstChild("SeatWeld")

            if SeatWeld then
                SeatWeld:Destroy()
                task.wait()
            end
        end
    end
end

return function(p2, p3) -- line: 23
    -- upvalues: RunService (copy), unseatPlayer (copy)
    if not p3 then
        return false, "Missing CFrame"
    end

    if not p2 then
        return false, "Missing player"
    end

    if RunService:IsClient() then
        return false, "teleportAsync must be called from server"
    end

    local v2 = p2.Character or p2.CharacterAdded:Wait()
    local HumanoidRootPart = v2:WaitForChild("HumanoidRootPart")

    unseatPlayer(p2)

    if workspace.StreamingEnabled then
        local RequestStreamAroundAsync = p2.RequestStreamAroundAsync
        local Position = p3.Position

        pcall(RequestStreamAroundAsync, p2, Position)
    end

    v2:PivotTo(p3)

    if HumanoidRootPart then
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end

    return true, "Success"
end
