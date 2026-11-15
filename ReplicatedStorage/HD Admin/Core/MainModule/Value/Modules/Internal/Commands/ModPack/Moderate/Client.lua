-- https://lua.expert

local _ = game:GetService("Players").LocalPlayer

require(script:FindFirstAncestor("HD Admin").Core.CommandAPI)

local StarterGui = game:GetService("StarterGui")

return {
    {
        name = "Mute",
        run = function(p1) -- run | line: 15
            -- upvalues: StarterGui (copy)
            if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
                p1:onEnded(function() -- line: 19
                    -- upvalues: StarterGui (copy)
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
                end)
            end
        end
    }
}
