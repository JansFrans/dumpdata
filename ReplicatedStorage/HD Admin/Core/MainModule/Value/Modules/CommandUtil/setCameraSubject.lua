-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules

return function(p1) -- line: 3
    -- upvalues: Modules (copy)
    if typeof(p1) ~= "Instance" then
        return
    end

    local v1 = p1

    if p1:IsA("Player") then
        v1 = require(Modules.PlayerUtil.getHumanoid)(p1)

        if not v1 then
            return
        end
    end

    workspace.CurrentCamera.CameraSubject = v1
end
