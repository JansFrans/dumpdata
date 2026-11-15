-- https://lua.expert

local RunService = game:GetService("RunService")
local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Icons = require(UI.Config.Icons)
local Children = Fusion.Children
local Pressable = require(UI.Components.Pressable)

return function(p1, p2) -- line: 28
    -- upvalues: RunService (copy), Theme (copy), Icons (copy), Children (copy), Pressable (copy)
    local v1 = p1:Value(false)
    local v2 = p1:Computed(function(p3) -- line: 31
        -- upvalues: v1 (copy), Theme (copy)
        local v3 = p3(Theme.Color.Neutral)

        if not p3(v1) then
            return v3
        end

        return v3:Lerp(if 0.299 * v3.R + 0.587 * v3.G + 0.114 * v3.B > 0.5 then Color3.new(0, 0, 0) else Color3.new(1, 1, 1), 0.1)
    end)
    local v4 = p1:New("ImageLabel")({
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = Icons.Outfits,
        ImageColor3 = Theme.Color.NeutralContentMain,
        Size = UDim2.fromOffset(20, 20)
    })
    local n1 = 0

    table.insert(p1, (RunService.Heartbeat:Connect(function(p4) -- line: 51
        -- upvalues: v4 (copy), n1 (ref)
        if v4.Parent then
            n1 += p4
            v4.Rotation = math.sin(n1 * 3.141592653589793) * 8
        end
    end)))

    return Pressable(p1, {
        name = "OutfitsButton",
        size = p2.size or UDim2.fromOffset(38, 38),
        layoutOrder = p2.layoutOrder,
        backgroundColor = v2,
        onHoverChanged = function(p5) -- onHoverChanged | line: 63
            -- upvalues: v1 (copy)
            v1:set(p5)
        end,
        onActivate = p2.onActivate,
        [Children] = {
            p1:New("UIAspectRatioConstraint")({
                AspectRatio = 1,
                AspectType = Enum.AspectType.FitWithinMaxSize,
                DominantAxis = Enum.DominantAxis.Height
            }),
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 6)
            }),
            p1:New("UIStroke")({
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Theme.Color.NeutralStroke
            }),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            v4
        }
    })
end
