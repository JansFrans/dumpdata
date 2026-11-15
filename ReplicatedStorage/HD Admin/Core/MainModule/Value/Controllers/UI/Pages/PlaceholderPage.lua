-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Icons = require(UI.Config.Icons)
local Viewport = require(UI.Config.Viewport)
local Children = Fusion.Children

return function(p1, p2) -- line: 23
    -- upvalues: Theme (copy), Icons (copy), Viewport (copy), Children (copy)
    local v1 = p2.pageName or "This page"
    local v2 = if p2.centered then p1:Computed(function(p3) -- line: 28
        -- upvalues: Viewport (copy)
        return UDim2.new(1, 0, 0, (math.max(0, p3(Viewport.MaxContentHeight) - 52)))
    end) else UDim2.fromScale(1, 1)

    return p1:New("Frame")({
        Name = "PlaceholderPage",
        BackgroundTransparency = 1,
        Size = v2,
        [Children] = {
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 18),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            p1:New("ImageLabel")({
                BackgroundTransparency = 1,
                Image = Icons.LogoGlyph,
                ImageColor3 = Theme.Color.NeutralContentDark,
                LayoutOrder = 1,
                Size = UDim2.fromOffset(48, 48),
                [Children] = {
                    p1:New("UICorner")({
                        CornerRadius = UDim.new(0, 3)
                    })
                }
            }),
            p1:New("TextLabel")({
                BackgroundTransparency = 1,
                LayoutOrder = 2,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                FontFace = p1:Computed(function(p4) -- line: 61
                    -- upvalues: Theme (copy)
                    return Font.new(p4(Theme.Font.Body), p4(Theme.FontWeight.Body))
                end),
                Size = UDim2.new(1, 0, 0, 0),
                Text = p1:Computed(function(p5) -- line: 66
                    -- upvalues: v1 (copy)
                    return (if typeof(v1) == "table" then p5(v1) else v1) .. " is under development.\nPlease check back later!"
                end),
                TextColor3 = Theme.Color.NeutralContentDark,
                TextSize = Theme.TextSize.Body,
                TextXAlignment = Enum.TextXAlignment.Center
            })
        }
    })
end
