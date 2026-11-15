-- https://lua.expert

local Modules = script:FindFirstAncestor("MainModule").Value.Modules
local Packages = Modules.Parent.Packages
local UI = Modules.Parent.Controllers.UI
local Fusion = require(Packages.Fusion)
local Theme = require(UI.Util.Theme)
local Children = Fusion.Children
local CmdbarRow = require(UI.Components.CmdbarRow)

return function(p1, p2) -- line: 38
    -- upvalues: Theme (copy), Children (copy), CmdbarRow (copy)
    return p1:New("Frame")({
        Name = "CmdbarList",
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Color.Base,
        LayoutOrder = p2.layoutOrder,
        Size = UDim2.new(1, 0, 0, 0),
        Visible = p2.visible == nil or p2.visible,
        [Children] = {
            p1:New("UICorner")({
                CornerRadius = UDim.new(0, 8)
            }),
            p1:New("UIStroke")({
                Thickness = 1,
                Transparency = 0.3,
                Color = Theme.Color.NeutralStroke
            }),
            p1:New("UIPadding")({
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4)
            }),
            p1:New("UIListLayout")({
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2)
            }),
            p1:New("TextLabel")({
                Name = "Signature",
                LayoutOrder = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                FontFace = p1:Computed(function(p3) -- line: 74
                    -- upvalues: Theme (copy)
                    return Font.new(p3(Theme.Font.Body), p3(Theme.FontWeight.Regular))
                end),
                Text = p2.signature or "",
                TextColor3 = Theme.Color.NeutralContentDark,
                TextSize = Theme.TextSize.Small,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Size = UDim2.fromScale(1, 0),
                Visible = p1:Computed(function(p4) -- line: 83
                    -- upvalues: p2 (copy)
                    local v5 = if p2.signature then p4(p2.signature) else nil

                    if typeof(v5) == "string" then
                        return v5 ~= ""
                    end

                    return false
                end),
                [Children] = {
                    p1:New("UIPadding")({
                        PaddingTop = UDim.new(0, 4),
                        PaddingBottom = UDim.new(0, 4),
                        PaddingLeft = UDim.new(0, 8),
                        PaddingRight = UDim.new(0, 8)
                    })
                }
            }),
            p1:ForValues(p2.rows, function(_, p6, p7) -- line: 97
                -- upvalues: p2 (copy), CmdbarRow (copy)
                return CmdbarRow(p6, {
                    display = p7.display,
                    description = p7.description,
                    image = p7.image,
                    imageRounded = p7.imageRounded,
                    swatch = p7.swatch,
                    rich = p7.rich,
                    locked = p7.locked,
                    showUnlock = p7.showUnlock,
                    layoutOrder = p7.index + 1,
                    selected = p6:Computed(function(p8) -- line: 108
                        -- upvalues: p7 (copy), p2 (copy)
                        return p8(p2.selectedIndex) == p7.index
                    end),
                    onActivate = function() -- onActivate | line: 111
                        -- upvalues: p7 (copy), p2 (copy)
                        p2.onActivateIndex(p7.index)
                    end,
                    onHover = function() -- onHover | line: 114
                        -- upvalues: p7 (copy), p2 (copy)
                        p2.onHoverIndex(p7.index)
                    end
                })
            end)
        }
    })
end
