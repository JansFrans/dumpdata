-- https://lua.expert

require(script:FindFirstAncestor("HD Admin").Core.CommandAPI)

return {
    {
        name = "Warp",
        run = function(_) -- run | line: 12
            local _ = game:GetService("Players").LocalPlayer
            local RunService = game:GetService("RunService")
            local CurrentCamera = workspace.CurrentCamera
            local n1 = 0.995
            local n2 = -0.005

            repeat
                RunService.RenderStepped:Wait()

                if n1 < 0.005 then
                    n1 = 0.005
                    n2 = 0.005
                elseif n1 > 1 then
                    n1 = 1
                    n2 = -0.005
                end

                CurrentCamera.CFrame *= CFrame.new(0, 0, 0, n1, 0, 0, 0, n1, 0, 0, 0, 1)
                n1 += n2
            until n1 > 1
        end
    }
}
