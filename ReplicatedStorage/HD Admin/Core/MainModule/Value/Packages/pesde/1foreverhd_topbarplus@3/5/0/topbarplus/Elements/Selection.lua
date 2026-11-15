-- https://lua.expert

local Utility = require(script.Parent.Parent.Utility)

return function(_) -- line: 2
    -- upvalues: Utility (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "SelectionContainer"
    Frame.Visible = false

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Selection"
    Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame2.BackgroundTransparency = 1
    Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame2.BorderSizePixel = 0
    Frame2.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Name = "UIStroke"
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 3
    UIStroke.Parent = Frame2

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Name = "SelectionGradient"
    UIGradient.Parent = UIStroke

    local UICorner = Instance.new("UICorner")

    UICorner:SetAttribute("Collective", "IconCorners")
    UICorner.Name = "UICorner"
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame2

    local RunService = game:GetService("RunService")
    local GuiService = game:GetService("GuiService")
    local n1 = 1

    Frame2:GetAttributeChangedSignal("RotationSpeed"):Connect(function() -- line: 38
        -- upvalues: Frame2 (copy), n1 (ref)
        n1 = Frame2:GetAttribute("RotationSpeed")
    end)
    RunService.Heartbeat:Connect(function() -- line: 41
        -- upvalues: UIGradient (copy), GuiService (copy), n1 (ref), Utility (copy)
        if GuiService.SelectedObject and not Utility.isReducedMotion() then
            UIGradient.Rotation = os.clock() * n1 * 100 % 360
        end
    end)

    return Frame
end
