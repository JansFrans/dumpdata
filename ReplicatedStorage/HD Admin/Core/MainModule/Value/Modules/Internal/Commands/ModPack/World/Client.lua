-- https://lua.expert

require(script:FindFirstAncestor("HD Admin").Core.CommandAPI)

return {
    {
        name = "FieldOfView",
        run = function(p1, p2) -- run | line: 12
            local LocalPlayer = game:GetService("Players").LocalPlayer

            p1.extra.fieldOfView = p2

            if p1.extra.buff then
                p1:updateBuffs(LocalPlayer, "Camera")
            else
                p1.extra.buff = p1:buff(LocalPlayer, "Camera", function(p3, p4) -- line: 20
                    -- upvalues: p1 (copy)
                    local CurrentCamera = workspace.CurrentCamera
                    local FieldOfView = CurrentCamera.FieldOfView

                    if p3 then
                        CurrentCamera.FieldOfView = p4
                    else
                        CurrentCamera.FieldOfView = p1.extra.fieldOfView
                    end

                    return FieldOfView
                end)
            end
        end
    }
}
